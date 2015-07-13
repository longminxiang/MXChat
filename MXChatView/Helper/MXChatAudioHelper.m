//
//  MXChatAudioHelper.m
//
//  Created by longminxiang on 15/6/9.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatAudioHelper.h"
#import "MXVoiceRecorder.h"
#import "MXChatAudioPlayer.h"
#import "MXChatPrefix.h"
#import <EGOCache/EGOCache.h>

@implementation MXChatAudioHelper

#pragma mark
#pragma mark === record ===

+ (void)startRecord
{
    [[MXVoiceRecorder sharedRecorder] startRecord];
}

+ (void)stopRecord:(MXChatAudioBlock)completion
{
    [[MXVoiceRecorder sharedRecorder] stopRecord:^(NSString *voicePath, float voiceTime) {
        if (voiceTime < 1.0f) {
            NSLog(@"太短了");
            mxc_showLoadingProgressWithMessage(@"太短了", 1);
            return;
        }
        NSData *data = [NSData dataWithContentsOfFile:voicePath];
        NSString *key = [data mxc_MD5];
        NSString *path = [self cacheAudioData:data key:key];
        if (completion) completion(data, voiceTime, path, key);
    }];
}

+ (void)cancelRecord
{
    [[MXVoiceRecorder sharedRecorder] cancelled];
}

#pragma mark
#pragma mark === cache ===

+ (NSData *)audioWithKey:(NSString *)key
{
    NSData *data = [[EGOCache globalCache] dataForKey:key];
    return data;
}

+ (NSString *)cacheAudioData:(NSData *)data key:(NSString *)key
{
    if (![[EGOCache globalCache] hasCacheForKey:key]) {
        [[EGOCache globalCache] setData:data forKey:key withTimeoutInterval:MAXFLOAT];
    }
    NSString *path = [[EGOCache globalCache] pathForKey:key];
    return path;
}

+ (NSString *)cacheAudioDataWithPath:(NSString *)path
{
    NSString *key = [path mxc_MD5];
    [[EGOCache globalCache] moveFilePath:path asKey:key withTimeoutInterval:MAXFLOAT];
    NSString *nowPath = [[EGOCache globalCache] pathForKey:key];
    return nowPath;
}

#pragma mark
#pragma mark === play ===

+ (void)playAudioWithKey:(NSString *)key completion:(void (^)(void))completion
{
    NSData *data = [self audioWithKey:key];
    if (!data) data = [self audioWithKey:[key mxc_MD5]];
    if (!data) {
        [self downAudioWithUrl:key completion:^(NSData *data) {
            [self playAudioWithData:data completion:completion];
        }];
    }
    else {
        [self playAudioWithData:data completion:completion];
    }
}

+ (void)playAudioWithData:(NSData *)data completion:(void (^)(void))completion
{
    [[MXChatAudioPlayer instance] playAudioWithData:data completion:completion];
}

+ (void)stopPlaying
{
    [[MXChatAudioPlayer instance] stopPlaying];
}

+ (void)downAudioWithUrl:(NSString *)urlString completion:(void (^)(NSData *data))completion
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data && !connectionError) {
                NSString *key = [urlString mxc_MD5];
                [self cacheAudioData:data key:key];
            }
            if (completion) completion(data);
        }];
    }
    else {
        if (completion) completion(nil);
    }
}

@end

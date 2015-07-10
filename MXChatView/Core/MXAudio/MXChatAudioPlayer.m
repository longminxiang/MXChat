//
//  MXChatAudioPlayer.m
//
//  Created by eric on 15/6/9.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface MXChatAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) void (^finishedPlayBlock)(void);

@end

@implementation MXChatAudioPlayer

+ (instancetype)instance
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

- (void)playAudioWithPath:(NSString *)path completion:(void (^)(void))completion
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self playAudioWithData:data completion:completion];
}

- (void)playAudioWithData:(NSData *)data completion:(void (^)(void))completion
{
    [self.player stop];
    self.player = nil;
    
    self.finishedPlayBlock = completion;
    
    if (!data) {
        if (self.finishedPlayBlock) self.finishedPlayBlock();
        return;
    }
    
    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.player.delegate = self;
    [self.player play];
}

- (void)stopPlaying
{
    [self.player stop];
    self.player = nil;
    if (self.finishedPlayBlock) self.finishedPlayBlock();
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlaying];
}

@end

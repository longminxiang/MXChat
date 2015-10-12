//
//  MXChatAudioHelper.h
//
//  Created by longminxiang on 15/6/9.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+MD5.h"

@interface MXChatAudioHelper : NSObject

typedef void (^MXChatAudioBlock)(NSData *data, float time, NSString *path, NSString *key);

/**
 *  开始录音
 */
+ (void)startRecord;

/**
 *  停止录音
 *
 *  @param completion 回调
 */
+ (void)stopRecord:(MXChatAudioBlock)completion;

/**
 *  取消录音
 */
+ (void)cancelRecord;

/**
 *  播放音频
 *
 *  @param key        音频key或url
 *  @param completion 回调
 */
+ (void)playAudioWithKey:(NSString *)key completion:(void (^)(void))completion;

/**
 *  缓存音频
 *
 *  @param path 音频路径
 *
 *  @return 缓存后的路径
 */
+ (NSString *)cacheAudioDataWithPath:(NSString *)path;

@end

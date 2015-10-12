//
//  MXChatAudioPlayer.h
//
//  Created by eric on 15/6/9.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXChatAudioPlayer : NSObject

+ (instancetype)instance;

- (void)playAudioWithPath:(NSString *)path completion:(void (^)(void))completion;

- (void)playAudioWithData:(NSData *)data completion:(void (^)(void))completion;

- (void)stopPlaying;

@end

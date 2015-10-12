//
//  MXVoiceRecorder.h
//
//  Created by longminxiang on 14-4-1.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXVoiceRecorder : NSObject

+ (instancetype)sharedRecorder;

- (void)startRecord;

- (void)stopRecord:(void (^)(NSString *voicePath, float voiceTime))completion;

- (void)cancelled;

@end

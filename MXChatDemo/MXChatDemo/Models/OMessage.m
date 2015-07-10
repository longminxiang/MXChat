//
//  OMessage.m
//
//  Created by eric on 15/6/9.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "OMessage.h"

@implementation OMessage

- (void)setSendTime:(NSDate *)sendTime
{
    _sendTime = [sendTime copy];
    
    if (!sendTime) {
        _sendTimeString = nil;
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    _sendTimeString = [formatter stringFromDate:sendTime];
}

- (void)setAudioTime:(CGFloat)audioTime
{
    _audioTime = audioTime;
    if (audioTime > CGFLOAT_MIN) {
        _audioTimeString = [NSString stringWithFormat:@"%g''", audioTime];
    }
}

@end
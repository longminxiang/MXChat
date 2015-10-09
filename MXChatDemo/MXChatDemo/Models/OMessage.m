//
//  OMessage.m
//
//  Created by eric on 15/6/9.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "OMessage.h"
#import <DTCoreText/DTCoreText.h>

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

+ (OMessage *)textMessageWithText:(NSString *)text
{
    OMessage *msg = [OMessage new];
    msg.type = MXChatMessageTypeText;
    msg.text = text;
    msg.ownerType = MXChatMessageOwnerTypeMine;
    msg.sendTime = [NSDate date];
    return msg;
}

+ (OMessage *)imageMessageWithKey:(NSString *)key path:(NSString *)path
{
    OMessage *msg = [OMessage new];
    msg.type = MXChatMessageTypeImage;
    msg.imageURL = key;
    msg.path = path;
    msg.ownerType = MXChatMessageOwnerTypeMine;
    msg.sendTime = [NSDate date];
    return msg;
}

+ (OMessage *)audioMessageWithKey:(NSString *)key path:(NSString *)path time:(float)time
{
    OMessage *msg = [OMessage new];
    msg.type = MXChatMessageTypeAudio;
    msg.audioURL = key;
    msg.path = path;
    msg.audioTime = time;
    msg.ownerType = MXChatMessageOwnerTypeMine;
    msg.sendTime = [NSDate date];
    return msg;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    text = [text mxc_parseMessageText];
    NSDictionary *dic = @{DTDefaultFontSize:@15,DTMaxImageSize:[NSValue valueWithCGSize:CGSizeMake(30, 30)]};
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    _attributedText = [[NSAttributedString alloc] initWithHTMLData:data options:dic documentAttributes:NULL];
}

@end
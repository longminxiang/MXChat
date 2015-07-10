//
//  MXChatMessage.m
//
//  Created by eric on 15/6/8.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatMessage.h"

extern void getImageMessagesFromChatMessages(NSArray *messages, id cntMsg, void (^completion)(NSArray *imageMessages, NSInteger cntIndex))
{
    NSInteger cntIndex = 0;
    NSMutableArray *imageMessages = [NSMutableArray new];
    for (int i = 0; i < messages.count; i++) {
        id<MXChatMessage> msg = messages[i];
        if ([msg type] == MXChatMessageTypeImage) {
            [imageMessages addObject:msg];
            if (msg == cntMsg) {
                cntIndex = [imageMessages indexOfObject:msg];
            }
        }
    }
    if (completion) completion(imageMessages, cntIndex);
}
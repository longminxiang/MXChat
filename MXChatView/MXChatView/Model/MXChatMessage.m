//
//  MXChatMessage.m
//
//  Created by eric on 15/6/8.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatMessage.h"
#import "FaceItem.h"

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

@implementation NSString (MXChatMessage)

- (NSString *)mxc_parseMessageText
{
    NSString *string = self;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"\n" options:NSRegularExpressionUseUnicodeWordBoundaries error:nil];
    NSRange range = NSMakeRange(0, string.length);
    string = [regular stringByReplacingMatchesInString:string options:NSMatchingWithoutAnchoringBounds range:range withTemplate:@"</br><br>"];
    
    regular = [NSRegularExpression regularExpressionWithPattern:@":([a-z0-9_]*):" options:NSRegularExpressionUseUnicodeWordBoundaries error:nil];
    
    range.length = string.length;
    NSTextCheckingResult *result = [regular firstMatchInString:string options:NSMatchingWithoutAnchoringBounds range:range];
    while (result != nil) {
        NSRange originRange = result.range;
        NSString *ogigin = [string substringWithRange:originRange];
        FaceItem *item = [FaceItem itemWithCode:ogigin];
        if (item) {
            NSString *replace = [NSString stringWithFormat:@"<img src=\"%@\">",item.imageName];
            string = [string stringByReplacingCharactersInRange:originRange withString:replace];
            range.location += replace.length;
        }
        else {
            range.location += originRange.length;
        }
        range.length = string.length - range.location;
        result = [regular firstMatchInString:string options:NSMatchingWithoutAnchoringBounds range:range];
    }
    return string;
}

@end
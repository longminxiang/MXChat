//
//  ODialog.m
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "ODialog.h"
#import <DTCoreText/DTCoreText.h>

@implementation ODialog

- (void)setTime:(NSDate *)time
{
    _time = [time copy];
    
    if (!time) {
        _timeString = nil;
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"MM-dd"];
    _timeString = [formatter stringFromDate:time];
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    _badgeText = badge > 0 ? [NSString stringWithFormat:@"%ld", (long)badge] : nil;
}

- (void)setOwner:(NSString *)owner
{
    _owner = [owner copy];
    _title = [owner copy];
}

- (void)setContent:(NSString *)content
{
    _content = [content copy];
    content = [content mxc_parseMessageText];
    NSDictionary *dic = @{DTDefaultFontSize:@15,DTMaxImageSize:[NSValue valueWithCGSize:CGSizeMake(20, 20)]};
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    _attributedText = [[NSAttributedString alloc] initWithHTMLData:data options:dic documentAttributes:NULL];
}


@end

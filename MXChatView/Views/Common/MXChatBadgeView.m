//
//  MXChatBadgeView.m
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatBadgeView.h"
#import "UIView+Radius.h"

@implementation MXChatBadgeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self mxc_setRadius:10];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.userInteractionEnabled = NO;
}

- (void)setBadgeText:(NSString *)badgeText
{
    _badgeText = [badgeText copy];
    [self setTitle:badgeText forState:UIControlStateNormal];
    self.hidden = !badgeText;
}

@end

//
//  UIView+Radius.m
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "UIView+Radius.h"

@implementation UIView (Radius)

- (void)mxc_setRadius:(CGFloat)cornerWidth
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerWidth;
    self.layer.borderWidth = 0.0;
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}

@end

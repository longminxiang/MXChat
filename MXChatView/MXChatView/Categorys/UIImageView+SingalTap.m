//
//  UIImageView+SingalTap.m
//
//  Created by eric on 15/6/15.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "UIImageView+SingalTap.h"
#import <objc/runtime.h>

@implementation UIImageView (Click)

static const char *singalTapBlockKey = "singalTapBlock";

- (void (^)(void))singalTapBlock
{
    return objc_getAssociatedObject(self, singalTapBlockKey);
}

- (void)mxc_setSingalTapBlock:(void ((^)(void)))singalTapBlock
{
    objc_setAssociatedObject(self, singalTapBlockKey, singalTapBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.userInteractionEnabled = !!singalTapBlock;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.singalTapBlock) self.singalTapBlock();
}

@end

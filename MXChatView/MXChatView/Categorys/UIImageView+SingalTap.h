//
//  UIImageView+SingalTap.h
//
//  Created by eric on 15/6/15.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SingalTap)

- (void)mxc_setSingalTapBlock:(void ((^)(void)))singalTapBlock;

@end
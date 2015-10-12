//
//  MXChatPrefix.h
//  MXChatDemo
//
//  Created by longminxiang on 15/7/4.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef __WEAKS
#define __WEAKS(__w) __weak __typeof(self) __w = self
#endif

void mxc_setImageBundlePath(NSString *path);

UIImage* mxc_imageInChatBundle(NSString *name);

UIViewController* mxc_rootViewController();

UIWindow *mxc_keyWindow();

BOOL mxc_stringIsNil(NSString *string);

void mxc_showLoadingProgressWithMessage(NSString *message, float delay);

void mxc_showLoadingProgress();

void mxc_hideLoadingProgress();

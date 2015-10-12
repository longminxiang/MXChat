//
//  MXChatPrefix.m
//  MXChatDemo
//
//  Created by longminxiang on 15/7/4.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatPrefix.h"
#import "MXChatConfig.h"
#import "MBProgressHUD.h"

extern void mxc_setImageBundlePath(NSString *path)
{
    [MXChatConfig instance].chatBundlePath = path;
}

extern UIImage* mxc_imageInChatBundle(NSString *name)
{
    return [[MXChatConfig instance] imageInChatBundle:name];
}

extern UIViewController* mxc_rootViewController()
{
    UIApplication *app = [UIApplication sharedApplication];
    UIViewController *rvc = app.keyWindow.rootViewController;
    if (rvc) return rvc;
    
    id delegate = app.delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        rvc = [delegate window].rootViewController;
    }
    return rvc;
}

extern UIWindow* mxc_keyWindow()
{
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    if (window) return window;
    
    id delegate = app.delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        window = [delegate window];
    }
    return window;
}

extern BOOL mxc_stringIsNil(NSString *string)
{
    if (!string || ![string isKindOfClass:[NSString class]]) return YES;
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL isNil = [str isEqualToString:@""];
    return isNil;
}

static MBProgressHUD *_messageHub;

extern void mxc_showLoadingProgressWithMessage(NSString *message, float delay)
{
    UIView *view = mxc_keyWindow();
    if (!_messageHub) {
        _messageHub = [[MBProgressHUD alloc] initWithView:view];
        [_messageHub setMode:MBProgressHUDModeText];
    }
    if (!_messageHub.superview) {
        [view addSubview:_messageHub];
    }
    [_messageHub setLabelText:message];
    [_messageHub show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_messageHub hide:YES];
    });
}

extern void mxc_showLoadingProgress()
{
    UIView *view = mxc_keyWindow();
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

extern void mxc_hideLoadingProgress()
{
    UIView *view = mxc_keyWindow();
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

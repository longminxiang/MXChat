//
//  UIView+ActionSheet.h
//
//  Created by longminxiang on 15/6/16.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ActionSheet)<UIActionSheetDelegate>


- (void)mxc_showActionSheetWithBlock:(void (^)(NSInteger buttonIndex))block
                           title:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     otherTitles:(NSArray *)otherButtonTitles;

- (void)mxc_showActionSheetWithBlock:(void (^)(NSInteger buttonIndex))block
                           title:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

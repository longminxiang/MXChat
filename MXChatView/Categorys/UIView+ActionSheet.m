//
//  UIView+ActionSheet.m
//
//  Created by longminxiang on 15/6/16.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "UIView+ActionSheet.h"

@implementation UIView (ActionSheet)

static void (^_actionSheetBlock)(NSInteger buttonIndex);

- (void)mxc_showActionSheetWithBlock:(void (^)(NSInteger buttonIndex))block
                           title:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *titles = [NSMutableArray new];
    va_list args;
    va_start(args, otherButtonTitles);
    while (otherButtonTitles) {
        [titles addObject:otherButtonTitles];
        otherButtonTitles = va_arg(args, id);
    }
    va_end(args);
    [self mxc_showActionSheetWithBlock:block title:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherTitles:titles];
}

- (void)mxc_showActionSheetWithBlock:(void (^)(NSInteger buttonIndex))block
                           title:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
                     otherTitles:(NSArray *)otherButtonTitles
{
    _actionSheetBlock = block;
    UIActionSheet *actionSheet = [UIActionSheet new];
    [actionSheet setTitle:title];
    [actionSheet setDelegate:self];
    if (destructiveButtonTitle) {
        [actionSheet setDestructiveButtonIndex:[actionSheet addButtonWithTitle:destructiveButtonTitle]];
    }
    for (NSString *title in otherButtonTitles) {
        if ([title isKindOfClass:[NSString class]]) {
            [actionSheet addButtonWithTitle:title];
        }
    }
    if (cancelButtonTitle) {
        [actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:cancelButtonTitle]];
    }
    [actionSheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_actionSheetBlock) _actionSheetBlock(buttonIndex);
}

@end

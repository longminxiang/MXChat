//
//  UITableView+NoneAnimation.m
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "UITableView+NoneAnimation.h"

@implementation UITableView (NoneAnimation)

- (void)mxc_reloadVisibleRows
{
    NSArray *vpaths = [self indexPathsForVisibleRows];
    if (!vpaths.count) return;
    [UIView setAnimationsEnabled:NO];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:vpaths withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (void)mxc_insertRows:(NSArray *)indexPaths
{
    NSArray *vpaths = [self indexPathsForVisibleRows];
    [UIView setAnimationsEnabled:NO];
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    if (vpaths.count) [self reloadRowsAtIndexPaths:vpaths withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (void)mxc_deleteRows:(NSArray *)indexPaths animation:(UITableViewRowAnimation)animation
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self mxc_reloadVisibleRows];
    }];
    [self beginUpdates];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self endUpdates];
    [CATransaction commit];
}

- (void)mxc_moveRow:(NSIndexPath *)indexPath to:(NSIndexPath *)newIndexPath
{
    [UIView setAnimationsEnabled:NO];
    [self beginUpdates];
    [self moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    [self endUpdates];
    [self mxc_reloadVisibleRows];
}

- (void)mxc_moveRowToTop:(NSIndexPath *)indexPath
{
    NSIndexPath *bpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self mxc_moveRow:indexPath to:bpath];
}

- (void)mxc_scrollToBottom:(BOOL)animated
{
    NSInteger lastSec = [self numberOfSections] - 1;
    if (lastSec < 0) return;
    NSInteger lastRow = [self numberOfRowsInSection:lastSec] - 1;
    if (lastRow < 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:lastSec];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    });
}

@end

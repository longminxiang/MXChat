//
//  UITableView+NoneAnimation.h
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NoneAnimation)

- (void)mxc_reloadVisibleRows;

- (void)mxc_insertRows:(NSArray *)indexPaths;

- (void)mxc_moveRow:(NSIndexPath *)indexPath to:(NSIndexPath *)newIndexPath;
- (void)mxc_moveRowToTop:(NSIndexPath *)indexPath;

- (void)mxc_deleteRows:(NSArray *)indexPaths animation:(UITableViewRowAnimation)animation;

- (void)mxc_scrollToBottom:(BOOL)animated;

@end

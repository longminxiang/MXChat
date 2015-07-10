//
//  UITableView+Refresh.h
//
//  Created by longminxiang on 15/6/22.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Refresh)

- (void)mxc_setRefreshingBlock:(void (^)(void))refreshingBlock;

- (void)mxc_startRefreshing;

- (void)mxc_stopRefreshing;

- (void)mxc_refreshForDidEndDecelerating;

@end

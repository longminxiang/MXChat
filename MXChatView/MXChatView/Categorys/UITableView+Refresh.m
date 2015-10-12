//
//  UITableView+Refresh.m
//
//  Created by longminxiang on 15/6/22.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "UITableView+Refresh.h"
#import <objc/runtime.h>

const char* isRefreshingKey = "isRefreshing";
const char* refreshingBlockKey = "refreshingBlock";

@implementation UITableView (Refresh)

- (BOOL)isRefreshing
{
    return [objc_getAssociatedObject(self, isRefreshingKey) boolValue];
}

- (void)setIsRefreshing:(BOOL)isRefreshing
{
    objc_setAssociatedObject(self, isRefreshingKey, @(isRefreshing), OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))refreshingBlock
{
    return objc_getAssociatedObject(self, refreshingBlockKey);
}

- (void)mxc_setRefreshingBlock:(void (^)(void))refreshingBlock
{
    objc_setAssociatedObject(self, refreshingBlockKey, refreshingBlock, OBJC_ASSOCIATION_COPY);
}

- (void)mxc_startRefreshing
{
    if (self.refreshingBlock) self.refreshingBlock();
}

- (void)mxc_stopRefreshing
{
    self.isRefreshing = NO;
}

- (void)mxc_refreshForDidEndDecelerating
{
    CGPoint offset = self.contentOffset;
    if (offset.y == -self.contentInset.top && !self.isRefreshing) {
        if (self.refreshingBlock) self.refreshingBlock();
        self.isRefreshing = YES;
    }
}

@end

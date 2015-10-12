//
//  MXChatListView.h
//
//  Created by eric on 15/6/25.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXChatDialog.h"
#import "MXChatPrefix.h"
#import "MXChatListCell.h"
#import "UITableView+NoneAnimation.h"

@interface MXChatListView : UIView

typedef void (^MXChatListViewDialogBlock)(id<MXChatDialog> dialog);
typedef void (^MXChatListViewSelectBlock)(id<MXChatDialog> dialog, NSInteger index);
typedef void (^MXChatListViewCustomCellBlock)(MXChatListCell *cell, id<MXChatDialog> dialog, NSInteger row);

@property (nonatomic, readonly) UITableView *tableView;

/**
 *  在最前面插入dialog
 *
 *  @param dialog dialog
 */
- (void)insertDialog:(id<MXChatDialog>)dialog;

/**
 *  插入dialog组
 *
 *  @param array array
 */
- (void)insertDialogFromArray:(NSArray *)array;

/**
 *  删除dialog
 *
 *  @param dialog dialog
 */
- (void)deleteDialog:(id<MXChatDialog>)dialog;

/**
 *  删除所有dialog
 *
 */
- (void)removeAllDialog;

/**
 *  设置tableViewCell额外属性
 *
 *  @param customCellBlock block
 */
- (void)setCustomCellBlock:(MXChatListViewCustomCellBlock)customCellBlock;

/**
 *  选中cell block
 *
 *  @param tableViewDidSelectRowBlock block
 */
- (void)setTableViewDidSelectRowBlock:(MXChatListViewSelectBlock)tableViewDidSelectRowBlock;

/**
 *  删除dialog block
 *
 *  @param deleteDialogBlock block
 */
- (void)setDeleteDialogBlock:(MXChatListViewDialogBlock)deleteDialogBlock;

@end

//
//  MXChatListView.m
//
//  Created by eric on 15/6/25.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatListView.h"
#import "UITableView+NoneAnimation.h"

@interface MXChatListView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) NSMutableArray *elements;
@property (nonatomic, copy) MXChatListViewDialogBlock deleteDialogBlock;
@property (nonatomic, copy) MXChatListViewSelectBlock tableViewDidSelectRowBlock;
@property (nonatomic, copy) MXChatListViewCustomCellBlock customCellBlock;

@end

@implementation MXChatListView

static NSString *chatListCellId = @"MXChatListCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _elements = [NSMutableArray new];
    
    //tableview
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:chatListCellId bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:chatListCellId];
    [self addSubview:tableView];
    _tableView = tableView;
}

#pragma mark
#pragma mark === elements === 

- (void)insertDialog:(id<MXChatDialog>)dialog
{
    if (!dialog) return;
    if (![self.elements containsObject:dialog]) {
        [self.elements insertObject:dialog atIndex:0];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView mxc_insertRows:@[path]];
    }
    else {
        NSInteger aindex = [self.elements indexOfObject:dialog];
        NSIndexPath *apath = [NSIndexPath indexPathForRow:aindex inSection:0];
        [self.elements removeObject:dialog];
        [self.elements insertObject:dialog atIndex:0];
        [self.tableView mxc_moveRowToTop:apath];
    }
}

- (void)insertDialogFromArray:(NSArray *)array
{
    NSInteger count = array.count;
    if (!count) return;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:(NSRange){0, count}];
    [self.elements insertObjects:array atIndexes:indexSet];
    
    NSMutableArray *paths = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [paths addObject:path];
    }
    [self.tableView mxc_insertRows:paths];
}

- (void)deleteDialog:(id<MXChatDialog>)dialog
{
    NSInteger index = [self.elements indexOfObject:dialog];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [self.elements removeObject:dialog];
    [self.tableView mxc_deleteRows:@[path] animation:UITableViewRowAnimationRight];
    if (self.deleteDialogBlock) self.deleteDialogBlock(dialog);
}

#pragma mark
#pragma mark === tableView delegate & datasource ===

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.elements.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    MXChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:chatListCellId];
    id<MXChatDialog>obj = self.elements[row];
    cell.titleLabel.text = [obj title];
    cell.messageLabel.text = [obj content];
    cell.timeLabel.text = [obj timeString];
    cell.badgeView.badgeText = [obj badgeText];
    cell.tag = row;
    if (self.customCellBlock) self.customCellBlock(cell, obj, row);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    id<MXChatDialog>obj = self.elements[row];
    if (self.tableViewDidSelectRowBlock) self.tableViewDidSelectRowBlock(obj, row);
    MXChatListCell *cell = (MXChatListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.badgeView.badgeText = [obj badgeText];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MXChatDialog>obj = self.elements[indexPath.row];
    [self deleteDialog:obj];
}

@end

//
//  MXChatView.m
//
//  Created by eric on 15/6/3.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatView.h"
#import "MXChatAudioHelper.h"
#import "MXChatImageHelper.h"
#import "UIView+ActionSheet.h"
#import "UITableView+NoneAnimation.h"
#import "UITableView+Refresh.h"
#import "UIView+Radius.h"

@interface MXChatView()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, MXChatBaseCellDelegate, MXChatAudioCellDelegate, MXChatImageCellDelegate>

@property (nonatomic, readonly) NSMutableArray *elements;
@property (nonatomic, copy) void (^textMessageOutBlock)(NSString *text);
@property (nonatomic, copy) MXChatViewAudioOutBlock audioMessageOutBlock;
@property (nonatomic, copy) MXChatViewImageOutBlock imageMessageOutBlock;

@property (nonatomic, copy) void (^resendMessageBlock)(id<MXChatMessage> message);
@property (nonatomic, copy) void (^deleteMessageBlock)(id<MXChatMessage> message);

@property (nonatomic, copy) void (^customCellForElementBlock)(MXChatBaseCell *cell, id<MXChatMessage>element);

@property (nonatomic, readonly) NSMutableDictionary *tmpCells;

@property (nonatomic, assign) NSInteger hasNewCount;

@end

@implementation MXChatView

static NSString *chatTextCellId = @"chatTextCellId";
static NSString *chatImageCellId = @"chatImageCellId";
static NSString *chatAudioCellId = @"chatAudioCellId";

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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[MXChatTextCell class] forCellReuseIdentifier:chatTextCellId];
    [tableView registerClass:[MXChatImageCell class] forCellReuseIdentifier:chatImageCellId];
    [tableView registerClass:[MXChatAudioCell class] forCellReuseIdentifier:chatAudioCellId];
    [self addSubview:tableView];
    _tableView = tableView;
    
    //touch空白收起输入框手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapHandle:)];
    gesture.delegate = self;
    [tableView addGestureRecognizer:gesture];
    
    //inputView
    MXInputView *inputView = [[MXInputView alloc] initWithSuperViewBounds:self.bounds];
    [self addSubview:inputView];
    
    [inputView setFrameChangeBlock:^(CGRect oldFrame, CGRect newFrame) {
        CGFloat changeHeight = newFrame.size.height - oldFrame.size.height;
        [self updateTableViewContentOffsetWithChangeHeight:changeHeight];
    }];
    
    [inputView setOutputTextBlock:^(NSString *text) {
        if (self.textMessageOutBlock) self.textMessageOutBlock(text);
        [self.tableView mxc_scrollToBottom:NO];
    }];
    
    [inputView setOutputVoiceBlock:^(NSData *data, float time, NSString *path, NSString *key) {
        if (self.audioMessageOutBlock) self.audioMessageOutBlock(data, time, path, key);
        [self.tableView mxc_scrollToBottom:NO];
    }];
    
    [inputView setOutputImageBlock:^(UIImage *image, NSString *path, NSString *key) {
        if (self.imageMessageOutBlock) self.imageMessageOutBlock(image, path, key);
        [self.tableView mxc_scrollToBottom:NO];
    }];
    
    _inputView = inputView;
    
    //has new message button
    CGRect frame = (CGRect){self.inputView.frame.size.width - 40, self.inputView.frame.origin.y - 40, 30, 30};
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button mxc_setRadius:10];
    button.backgroundColor = [UIColor brownColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.hidden = YES;
    [button addTarget:self.tableView action:@selector(mxc_scrollToBottom:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _hasNewButton = button;
    
    [self updateTableViewContentInset];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.tableView.frame = self.bounds;
}

- (void)setHasNewCount:(NSInteger)hasNewCount
{
    _hasNewCount = hasNewCount;
    if (hasNewCount > 0) {
        self.hasNewButton.hidden = NO;
        NSString *title = [NSString stringWithFormat:@"%ld", (long)hasNewCount];
        [self.hasNewButton setTitle:title forState:UIControlStateNormal];
    }
    else {
        self.hasNewButton.hidden = YES;
        [self.hasNewButton setTitle:nil forState:UIControlStateNormal];
    }
}

- (id<MXChatMessage>)firstElement
{
    return self.elements.count ? self.elements[0] : nil;
}

#pragma mark
#pragma mark === message ===

- (void)addMessage:(id<MXChatMessage>)message
{
    if (![self.elements containsObject:message]) {
        NSInteger index = [self calculateCellAddedHeightWithMessage:message];
        [self.elements addObject:message];
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        
        [self.tableView mxc_insertRows:@[path]];
        
        BOOL scroll = [self scrollTableViewToBottomIfNeeded];
        if (!scroll && [message ownerType] == MXChatMessageOwnerTypeOther) {
            self.hasNewCount++;
        }
    }
    else {
        NSInteger index = [self.elements indexOfObject:message];
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        MXChatBaseCell *cell = (MXChatBaseCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.state = (MXChatCellState)[message state];
    }
}

- (void)insertMessagesFromArray:(NSArray *)array
{
    NSInteger count = array.count;
    if (!count) return;
    NSMutableArray *paths = [NSMutableArray new];
    CGFloat height = 0, fheight = 0;
    for (int i = 0; i < count; i++) {
        id<MXChatMessage> obj = array[i];
        id pobj;
        if (i-1 >= 0) pobj = array[i-1];
        [self calculateCellHeightWithMessage:obj preMessage:pobj];
        if (i == count - 1) {
            id<MXChatMessage> feobj = [self firstElement];
            fheight = [feobj cellHeight];
            [self calculateCellHeightWithMessage:feobj preMessage:obj];
            fheight -= [feobj cellHeight];
        }
        height += [obj cellHeight];
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [paths addObject:path];
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:(NSRange){0, count}];
    [self.elements insertObjects:array atIndexes:indexSet];
    [self.tableView mxc_insertRows:paths];
    self.tableView.contentOffset = (CGPoint){0, height - self.tableView.contentInset.top - fheight};
}

- (void)deleteMessage:(id<MXChatMessage>)message
{
    NSInteger index = [self calculateCellDeletedHeightWithMessage:message];
    [self.elements removeObject:message];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView mxc_deleteRows:@[path] animation:UITableViewRowAnimationRight];
    if (self.deleteMessageBlock) self.deleteMessageBlock(message);
}

- (void)resendMessage:(id<MXChatMessage>)message
{
    if (self.resendMessageBlock) self.resendMessageBlock(message);
    NSInteger index = [self calculateCellDeletedHeightWithMessage:message];
    [self.elements removeObject:message];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    
    index = [self calculateCellAddedHeightWithMessage:message];
    [self.elements addObject:message];
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView mxc_moveRow:path to:path1];
    [self.tableView mxc_scrollToBottom:NO];
}

#pragma mark
#pragma mark === 计算cell高度 ===

//计算要增加的cell的高度
- (NSInteger)calculateCellAddedHeightWithMessage:(id)message
{
    NSInteger index = self.elements.count;
    id pobj;
    if (index-1 >= 0) pobj = self.elements[index-1];
    [self calculateCellHeightWithMessage:message preMessage:pobj];
    return index;
}

//删除cell时, 需要重新计算下一个cell的高度
- (NSInteger)calculateCellDeletedHeightWithMessage:(id)message
{
    NSInteger index = [self.elements indexOfObject:message];
    id aobj, pobj;
    if (index+1 < self.elements.count) aobj = self.elements[index+1];
    if (index-1 >= 0) pobj = self.elements[index-1];
    [self calculateCellHeightWithMessage:aobj preMessage:pobj];
    return index;
}

- (void)calculateCellHeightWithMessage:(id)message preMessage:(id)pmessage
{
    id<MXChatMessage>msg = (id<MXChatMessage>)message;
    id<MXChatMessage>pmsg = (id<MXChatMessage>)pmessage;
    
    NSString *cellId = [self cellIdentifierForElement:msg];
    MXChatBaseCell *cell = [self tempCellWithCellId:cellId];
    
    [self cell:cell setElement:msg preElement:pmsg];
    [cell layoutSubviews];
    CGFloat height = cell.frame.size.height;
    if (height < CGFLOAT_MIN) height = 44;
    
    [msg setCellHeight:height];
}

#pragma mark
#pragma mark === tableView ===

- (NSString *)cellIdentifierForElement:(id<MXChatMessage>)obj
{
    MXChatMessageType type = [obj type];
    if (type == MXChatMessageTypeImage) return chatImageCellId;
    if (type == MXChatMessageTypeAudio) return chatAudioCellId;
    return chatTextCellId;
}

- (id)tempCellWithCellId:(NSString *)cellId
{
    if (!_tmpCells) _tmpCells = [NSMutableDictionary new];
    id cell = _tmpCells[cellId];
    if (![[_tmpCells allKeys] containsObject:cellId]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
        [_tmpCells setValue:cell forKey:cellId];
    }
    return cell;
}

- (void)updateTableViewContentInset
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = self.inputView.frame.size.height;
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (void)updateTableViewContentOffsetWithChangeHeight:(CGFloat)changeHeight
{
    CGPoint offset = self.tableView.contentOffset;
    UIEdgeInsets inset = self.tableView.contentInset;
    offset.y += changeHeight;
    if (offset.y + inset.top < 0) offset.y = -inset.top;

    CGRect frame = (CGRect){self.inputView.frame.size.width - 40, self.inputView.frame.origin.y - 40, 30, 30};

    [UIView animateWithDuration:MXINPUTVIEW_SLIDE_SPEED*changeHeight animations:^{
        self.tableView.contentOffset = offset;
        [self updateTableViewContentInset];
        self.hasNewButton.frame = frame;
    }];
}

- (BOOL)scrollTableViewToBottomIfNeeded
{
    NSArray *vpaths = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *path = [vpaths lastObject];
    NSInteger row = path.row;
    if (self.elements.count - row <= 2) {
        [self.tableView mxc_scrollToBottom:NO];
        return YES;
    }
    return NO;
}

#pragma mark
#pragma mark === tableView delegate & datasource ===

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
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
    NSInteger row = indexPath.row;
    id<MXChatMessage> obj = self.elements[row];
    return [obj cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    return height;
}

- (void)cell:(MXChatBaseCell *)cell setElement:(id<MXChatMessage>)obj preElement:(id<MXChatMessage>)bobj
{
    MXChatMessageType type = [obj type];
    if (type == MXChatMessageTypeText) {
        MXChatTextCell *acell = (MXChatTextCell *)cell;
        id<MXChatTextMessage> aobj = (id<MXChatTextMessage>)obj;
        BOOL didResponse = [aobj respondsToSelector:@selector(text)];
        acell.textView.text = didResponse ? [aobj text] : nil;
    }
    else if (type == MXChatMessageTypeImage) {
        MXChatImageCell *acell = (MXChatImageCell *)cell;
        id<MXChatImageMessage> aobj = (id<MXChatImageMessage>)obj;
        BOOL didResponse = [aobj respondsToSelector:@selector(imageURL)];
        NSString *imageURL = didResponse ? [aobj imageURL] : nil;
        [acell.chatImageView setImageWithURL:imageURL];
    }
    else if (type == MXChatMessageTypeAudio) {
        MXChatAudioCell *acell = (MXChatAudioCell *)cell;
        id<MXChatAudioMessage> aobj = (id<MXChatAudioMessage>)obj;
        BOOL didResponse = [aobj respondsToSelector:@selector(audioTimeString)];
        acell.timeString = didResponse ? [aobj audioTimeString] : nil;
    }
    cell.delegate = self;
    cell.direction = (MXChatCellDirection)[obj ownerType];
    cell.timeLabel.text = [obj sendTimeString];
    cell.state = (MXChatCellState)[obj state];
    
    //是否显示时间
    BOOL showTimeLabel = ![[bobj sendTimeString] isEqualToString:[obj sendTimeString]];
    cell.showTimeLabel = showTimeLabel;
    
    if (self.customCellForElementBlock) self.customCellForElementBlock(cell, obj);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    id<MXChatMessage> obj = self.elements[row];
    NSString *cellId = [self cellIdentifierForElement:obj];
    MXChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.tag = row;
    
    id<MXChatMessage>bobj;
    if (row-1 >= 0) bobj = self.elements[row-1];
    [self cell:cell setElement:obj preElement:bobj];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.inputView deactive];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.tableView mxc_refreshForDidEndDecelerating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y >= scrollView.contentSize.height - scrollView.bounds.size.height - 20) {
        self.hasNewCount = 0;
    }
}

#pragma mark
#pragma mark === action ===

- (void)tableViewTapHandle:(UITapGestureRecognizer *)gesture
{
    [self.inputView deactive];
}

#pragma mark
#pragma mark === delegate ===

- (void)chatCellStateButtonTouched:(MXChatBaseCell *)cell
{
    id<MXChatMessage> msg = self.elements[cell.tag];
    [self mxc_showActionSheetWithBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self resendMessage:msg];
        }
        else if (buttonIndex == 1) {
            [self deleteMessage:msg];
        }
    } title:@"发送失败" cancelButtonTitle:@"取消" destructiveButtonTitle:@"重新发送" otherButtonTitles:@"删除", nil];
}

__weak id _tmpAudioCell;

- (void)chatAudioCellAudioButtonTouchedEnd:(MXChatAudioCell *)cell
{
    id<MXChatAudioMessage> obj = self.elements[cell.tag];
    if ([obj respondsToSelector:@selector(audioURL)]) {
        if (_tmpAudioCell) [_tmpAudioCell stopAudioAnimating];
        _tmpAudioCell = cell;
        [cell startAudioAnimating];
        [MXChatAudioHelper playAudioWithKey:[obj audioURL] completion:^{
            [cell stopAudioAnimating];
        }];
    }
}

- (void)chatImageCell:(MXChatImageCell *)cell chatImageViewDidTouchedEnd:(UIImageView *)imageView
{
    id cntObj = self.elements[cell.tag];
    getImageMessagesFromChatMessages(self.elements, cntObj, ^(NSArray *imageMessages, NSInteger cntIndex) {
        [MXChatImageHelper showPhotoViewerWithImageMessages:imageMessages cntIndex:cntIndex];
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = touch.view;
    if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return YES;
    }
    return NO;
}

@end

@implementation MXChatView (Refresh)

- (void)setRefreshingBlock:(void (^)(void))refreshingBlock
{
    [self.tableView mxc_setRefreshingBlock:refreshingBlock];
}

- (void)startRefreshing
{
    [self.tableView mxc_startRefreshing];
}

- (void)stopRefreshing
{
    [self.tableView mxc_stopRefreshing];
}

@end

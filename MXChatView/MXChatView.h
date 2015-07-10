//
//  MXChatView.h
//
//  Created by eric on 15/6/3.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXInputView.h"
#import "MXChatMessage.h"
#import "MXChatCell.h"
#import "MXChatPrefix.h"

@interface MXChatView : UIView

typedef void (^MXChatViewImageOutBlock)(UIImage *image, NSString *path, NSString *key);
typedef void (^MXChatViewAudioOutBlock)(NSData *data, float time, NSString *path, NSString *key);

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) MXInputView *inputView;
@property (nonatomic, readonly) UIButton *hasNewButton;

- (id<MXChatMessage>)firstElement;

/**
 *  输出文本block
 *
 *  @param textMessageOutBlock block
 */
- (void)setTextMessageOutBlock:(void (^)(NSString *text))textMessageOutBlock;

/**
 *  输出照片block
 *
 *  @param imageMessageOutBlock block
 */
- (void)setImageMessageOutBlock:(MXChatViewImageOutBlock)imageMessageOutBlock;

/**
 *  输出音频block
 *
 *  @param audioMessageOutBlock block
 */
- (void)setAudioMessageOutBlock:(MXChatViewAudioOutBlock)audioMessageOutBlock;

/**
 *  设置tableViewCell额外属性
 *
 *  @param customCellForElementBlock block
 */
- (void)setCustomCellForElementBlock:(void (^)(MXChatBaseCell *cell, id<MXChatMessage>element))customCellForElementBlock;

/**
 *  增加消息
 *
 *  @param message 消息
 */
- (void)addMessage:(id<MXChatMessage>)message;

/**
 *  在开头插入消息
 *
 *  @param array 消息数组
 */
- (void)insertMessagesFromArray:(NSArray *)array;

/**
 *  重发消息block
 *
 *  @param resendMessageBlock block
 */
- (void)setResendMessageBlock:(void (^)(id<MXChatMessage> message))resendMessageBlock;

/**
 *  删除消息block
 *
 *  @param deleteMessageBlock block
 */
- (void)setDeleteMessageBlock:(void (^)(id<MXChatMessage> message))deleteMessageBlock;

@end

@interface MXChatView (Refresh)

/**
 *  下拉加载历史block
 *
 *  @param refreshingBlock block
 */
- (void)setRefreshingBlock:(void (^)(void))refreshingBlock;

/**
 *  开始加载
 */
- (void)startRefreshing;

/**
 *  停止加载
 */
- (void)stopRefreshing;

@end

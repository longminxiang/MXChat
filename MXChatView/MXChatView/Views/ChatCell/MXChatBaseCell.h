//
//  MXChatBaseCell.h
//
//  Created by eric on 15/5/20.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXChatStateButton.h"

typedef NS_ENUM(NSInteger, MXChatCellDirection) {
    MXChatCellDirectionLeft = 0,
    MXChatCellDirectionRight = 1,
};

#define MXCC_TIMELABEL_HEIGHT       30
#define MXCC_TIMELABEL_FONT_SIZE    14

#define MXCC_AVATAR_SPACE           8
#define MXCC_AVATAR_SIZE            CGSizeMake(50,50)

#define MXCC_NAMELABEL_HEIGHT       20
#define MXCC_NAMELABEL_FONT_SIZE    12

#define MXCC_CHATVIEW_SPACE         8

#define MXCC_STATEBUTTON_SPACE      8
#define MXCC_STATEBUTTON_SIZE       CGSizeMake(44,44)

#define MXCC_BOTTOM_SPACE           20
#define MXCC_LR_SPACE               20

#define MXCC_CONTENT_INSETS         UIEdgeInsetsMake(8, 15, 8, 8)

@class MXChatBaseCell;

@protocol MXChatBaseCellDelegate <NSObject>

@optional
- (void)chatCellStateButtonTouched:(MXChatBaseCell *)cell;

@end

@interface MXChatBaseCell : UITableViewCell

@property (nonatomic, readonly) UILabel *timeLabel;
@property (nonatomic, readonly) UIButton *avatarButton;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UIView *chatContentView;
@property (nonatomic, readonly) UIImageView *chatContentBackgroundView;

@property (nonatomic, assign) MXChatCellDirection direction;
@property (nonatomic, assign) BOOL showTimeLabel;
@property (nonatomic, assign) BOOL showNameLabel;

@property (nonatomic, assign) MXChatCellState state;

@property (nonatomic, assign) CGSize chatContentSize;
@property (nonatomic, assign) UIEdgeInsets chatContentInsets;

@property (nonatomic, assign) id <MXChatBaseCellDelegate>delegate;

- (CGFloat)maxContentWidth;

@end

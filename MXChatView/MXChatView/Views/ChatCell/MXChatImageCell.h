//
//  MXChatImageCell.h
//
//  Created by longminxiang on 15/5/21.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatBaseCell.h"

#define MXCC_IMAGEVIEW_SIZE     CGSizeMake(120, 120)

@class MXChatImageCell;

@protocol MXChatImageCellDelegate <MXChatBaseCellDelegate>

@optional
- (void)chatImageCell:(MXChatImageCell *)cell chatImageViewDidTouchedEnd:(UIImageView *)imageView;

@end

@interface MXChatImageCell : MXChatBaseCell

@property (nonatomic, readonly) UIImageView *chatImageView;

@end

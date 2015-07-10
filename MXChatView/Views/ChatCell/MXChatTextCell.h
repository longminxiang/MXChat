//
//  MXChatTextCell.h
//
//  Created by longminxiang on 15/5/21.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatBaseCell.h"

#define MXCC_TEXTVIEW_ORIGIN    CGPointMake(10, 8)

@interface MXChatTextCell : MXChatBaseCell

@property (nonatomic, readonly) UITextView *textView;

@end

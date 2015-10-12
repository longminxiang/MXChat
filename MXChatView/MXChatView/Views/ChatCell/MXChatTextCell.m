//
//  MXChatTextCell.m
//
//  Created by longminxiang on 15/5/21.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatTextCell.h"

@interface MXChatTextCell ()

@end

@implementation MXChatTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UITextView *textView = [UITextView new];
        textView.font = [UIFont systemFontOfSize:14];
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.chatContentView addSubview:textView];
        _textView = textView;
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize fitSize = [self.textView sizeThatFits:CGSizeMake([self maxContentWidth] - MXCC_TEXTVIEW_ORIGIN.x * 2, 60)];
    if (fitSize.height < 20) fitSize.height = 20;
    CGRect frame = self.textView.bounds;
    frame.origin = MXCC_TEXTVIEW_ORIGIN;
    frame.size = fitSize;
    self.textView.frame = frame;
    
    self.chatContentSize = frame.size;
    [super layoutSubviews];
}

@end

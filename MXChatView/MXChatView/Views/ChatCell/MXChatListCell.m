//
//  MXChatListCell.m
//
//  Created by eric on 15/6/25.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatListCell.h"
#import "UIView+Radius.h"

@implementation MXChatListCell

- (void)awakeFromNib {
    // Initialization code
    [self.logoImageView mxc_setRadius:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
}

@end

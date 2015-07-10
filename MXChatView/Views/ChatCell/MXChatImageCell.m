//
//  MXChatImageCell.m
//
//  Created by longminxiang on 15/5/21.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatImageCell.h"
#import "UIImageView+SingalTap.h"

@implementation MXChatImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.chatContentView addSubview:imageView];
        _chatImageView = imageView;
        __weak MXChatImageCell *weaks = self;
        [imageView mxc_setSingalTapBlock:^{
            [weaks imageViewDidTouched];
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    UIEdgeInsets insets = self.chatContentInsets;
    if (self.direction) {
        CGFloat left = insets.left;
        insets.left = insets.right;
        insets.right = left;
    }
    
    CGRect frame;
    frame.origin = CGPointMake(insets.left, insets.top);
    frame.size = MXCC_IMAGEVIEW_SIZE;
    self.chatImageView.frame = frame;
    
    self.chatContentSize = frame.size;
    
    [super layoutSubviews];
}

- (void)imageViewDidTouched
{
    id<MXChatImageCellDelegate> delegate = (id<MXChatImageCellDelegate>)self.delegate;
    if ([delegate respondsToSelector:@selector(chatImageCell:chatImageViewDidTouchedEnd:)]) {
        [delegate chatImageCell:self chatImageViewDidTouchedEnd:self.chatImageView];
    }
}

@end

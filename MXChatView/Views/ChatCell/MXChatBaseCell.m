//
//  MXChatBaseCell.m
//
//  Created by eric on 15/5/20.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatBaseCell.h"
#import "MXChatPrefix.h"
#import "UIView+Radius.h"

@interface MXChatBaseCell ()

@property (nonatomic, readonly) MXChatStateButton *stateButton;

@end

@implementation MXChatBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self initialize];
        _direction = -777;
        self.chatContentSize = CGSizeMake(120, 60);
        self.direction = MXChatCellDirectionLeft;
        self.chatContentInsets = MXCC_CONTENT_INSETS;
        self.showNameLabel = NO;
    }
    return self;
}

- (void)initialize
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:MXCC_TIMELABEL_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"2015-05-21 12:09";
    [self.contentView addSubview:label];
    _timeLabel = label;
    
    UIButton *button = [UIButton new];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:mxc_imageInChatBundle(@"avator") forState:UIControlStateNormal];
    [button mxc_setRadius:20];
    [self.contentView addSubview:button];
    _avatarButton = button;
    
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:MXCC_NAMELABEL_FONT_SIZE];
    label.text = @"小X";
    [self.contentView addSubview:label];
    _nameLabel = label;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    _chatContentView = view;
    
    UIImageView *imageView = [UIImageView new];
    [_chatContentView addSubview:imageView];
    _chatContentBackgroundView = imageView;
    
    MXChatStateButton *sbutton = [MXChatStateButton new];
    [sbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sbutton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [sbutton addTarget:self action:@selector(stateButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sbutton];
    _stateButton = sbutton;
}

- (CGFloat)maxContentWidth
{
    return self.contentView.bounds.size.width - MXCC_AVATAR_SPACE - MXCC_AVATAR_SIZE.width - MXCC_CHATVIEW_SPACE - MXCC_STATEBUTTON_SIZE.width - MXCC_STATEBUTTON_SPACE - MXCC_LR_SPACE;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.contentView.bounds;
    
    //时间
    CGRect lframe = frame;
    lframe.size.height = self.showTimeLabel && !mxc_stringIsNil(self.timeLabel.text) ? MXCC_TIMELABEL_HEIGHT : 0;
    self.timeLabel.frame = lframe;
    
    //头像
    CGRect aframe;
    aframe.origin.y = lframe.size.height;
    aframe.size = MXCC_AVATAR_SIZE;
    
    //名字
    CGRect nframe = aframe;
    nframe.size.height = self.showNameLabel && !mxc_stringIsNil(self.nameLabel.text) ? MXCC_NAMELABEL_HEIGHT : 0;
    nframe.size.width = frame.size.width - aframe.size.width - MXCC_AVATAR_SPACE * 4;
    
    //内容
    CGRect cframe = aframe;
    cframe.origin.y = nframe.size.height + nframe.origin.y;
    cframe.size = self.chatContentSize;
    UIEdgeInsets insets = self.chatContentInsets;
    cframe.size.width += insets.left + insets.right;
    cframe.size.height += insets.top + insets.bottom;
    
    //发送状态
    CGRect sframe = aframe;
    sframe.size = MXCC_STATEBUTTON_SIZE;
    
    if (self.direction == MXChatCellDirectionLeft) {
        aframe.origin.x = MXCC_AVATAR_SPACE;
        nframe.origin.x = aframe.size.width + aframe.origin.x + MXCC_CHATVIEW_SPACE;
        cframe.origin.x = aframe.size.width + aframe.origin.x + MXCC_CHATVIEW_SPACE;
        sframe.origin.x = cframe.origin.x + cframe.size.width + MXCC_STATEBUTTON_SPACE;
    }
    else {
        aframe.origin.x = frame.size.width - MXCC_AVATAR_SIZE.width - MXCC_AVATAR_SPACE;
        nframe.origin.x = MXCC_CHATVIEW_SPACE * 2;
        cframe.origin.x = aframe.origin.x - cframe.size.width - MXCC_CHATVIEW_SPACE;
        sframe.origin.x = cframe.origin.x - MXCC_STATEBUTTON_SPACE - sframe.size.width;
    }
    self.avatarButton.frame = aframe;
    self.nameLabel.frame = nframe;
    self.stateButton.frame = sframe;
    self.chatContentView.frame = cframe;
    self.chatContentBackgroundView.frame = self.chatContentView.bounds;
    
    CGRect ssframe = self.frame;
    CGFloat cyh = cframe.size.height + cframe.origin.y;
    CGFloat ayh = aframe.size.height + aframe.origin.y;
    ssframe.size.height = MAX(cyh, ayh) + MXCC_BOTTOM_SPACE;
    self.frame = ssframe;
}

- (void)setDirection:(MXChatCellDirection)direction
{
    if (_direction == direction) return;
    _direction = direction;
    
    UIImage *image = mxc_imageInChatBundle(direction ? @"mr" : @"ml");
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.chatContentBackgroundView.image = image;
    
    self.nameLabel.textAlignment = direction ? NSTextAlignmentRight : NSTextAlignmentLeft;
}

- (void)setState:(MXChatCellState)state
{
    self.stateButton.cellState = state;
}

- (void)setShowNameLabel:(BOOL)showNameLabel
{
    _showNameLabel = showNameLabel;
    self.nameLabel.hidden = !showNameLabel;
}

- (MXChatCellState)state
{
    return self.stateButton.cellState;
}

- (void)stateButtonTouched:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(chatCellStateButtonTouched:)]) {
        [self.delegate chatCellStateButtonTouched:self];
    }
}

@end



//
//  MXChatAudioCell.m
//
//  Created by eric on 15/5/22.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatAudioCell.h"
#import "MXChatPrefix.h"

@interface MXChatAudioCell ()

@property (nonatomic, readonly) UIButton *chatAudioButton;
@property (nonatomic, strong) UIImageView *audioImageView;
@property (nonatomic, strong) UILabel *audioTimeLabel;
@property (nonatomic, strong) NSArray *leftImages, *rightImages;

@end

@implementation MXChatAudioCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *button = [UIButton new];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        [button addTarget:self action:@selector(audioButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.chatContentView addSubview:button];
        _chatAudioButton = button;
        
        UIImageView *imageView = [UIImageView new];
        imageView.animationDuration = 1;
        [button addSubview:imageView];
        _audioImageView = imageView;
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:11.f/255.f green:16.f/255.f blue:19.f/255.f alpha:1];
        [button addSubview:label];
        _audioTimeLabel = label;
        
        _leftImages = @[mxc_imageInChatBundle(@"vpl1"), mxc_imageInChatBundle(@"vpl2"), mxc_imageInChatBundle(@"vpl3")];
        _rightImages = @[mxc_imageInChatBundle(@"vpr1"), mxc_imageInChatBundle(@"vpr2"), mxc_imageInChatBundle(@"vpr3")];
    }
    return self;
}

- (NSString *)timeString
{
    return self.audioTimeLabel.text;
}

- (void)setTimeString:(NSString *)timeString
{
    self.audioTimeLabel.text = timeString;
}

- (void)setDirection:(MXChatCellDirection)direction
{
    [super setDirection:direction];
    UIImage *image = mxc_imageInChatBundle(direction ? @"vpr" : @"vpl");
    self.audioImageView.image = image;
    self.audioImageView.animationImages = direction ? self.rightImages : self.leftImages;
}

- (void)startAudioAnimating
{
    if ([self.audioImageView isAnimating]) return;
    [self.audioImageView startAnimating];
}

- (void)stopAudioAnimating
{
    [self.audioImageView stopAnimating];
}

- (void)audioButtonTouched:(UIButton *)button
{
    id<MXChatAudioCellDelegate> delegate = (id<MXChatAudioCellDelegate>)self.delegate;
    if ([delegate respondsToSelector:@selector(chatAudioCellAudioButtonTouchedEnd:)]) {
        [delegate chatAudioCellAudioButtonTouchedEnd:self];
    }
}

- (void)layoutSubviews
{
    UIEdgeInsets insets = self.chatContentInsets;
    if (self.direction) {
        CGFloat left = insets.left;
        insets.left = insets.right;
        insets.right = left;
        self.chatAudioButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    }
    
    CGRect frame;
    frame.origin = CGPointMake(insets.left, insets.top);
    frame.size = MXCC_AUDIO_SIZE;
    self.chatAudioButton.frame = frame;
    self.chatContentSize = frame.size;
    
    CGRect aframe = frame;
    aframe.origin.x = self.direction ? aframe.size.width - 25 : 0;
    aframe.origin.y = 0;
    aframe.size.width = 25;
    self.audioImageView.frame = aframe;
    
    CGRect lframe = frame;
    lframe.origin.x = self.direction ? 5 : 25 + 5;
    lframe.origin.y = 0;
    lframe.size.width = lframe.size.width - 30;
    self.audioTimeLabel.frame = lframe;
    self.audioTimeLabel.textAlignment = self.direction ? NSTextAlignmentRight : NSTextAlignmentLeft;
    
    [super layoutSubviews];
}

@end

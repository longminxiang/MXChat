//
//  MXChatFaceTextCell.m
//  Pods
//
//  Created by longminxiang on 15/10/9.
//
//

#import "MXChatFaceTextCell.h"

@implementation MXChatFaceTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        DTAttributedTextContentView *textView = [DTAttributedTextContentView new];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setEdgeInsets:UIEdgeInsetsZero];
        [textView setShouldDrawLinks:NO];
        [self.chatContentView addSubview:textView];
        _textView = textView;
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
    self.textView.frame = CGRectMake(insets.left, insets.top, [self maxContentWidth] - MXCC_FACE_TEXTVIEW_ORIGIN.x * 2, 60);
    CGRect tframe = [self.textView.layoutFrame intrinsicContentFrame];
    if (tframe.size.height < 25) tframe.size.height = 25;
    CGRect frame = self.textView.bounds;
    frame.origin = CGPointMake(insets.left, insets.top);
    frame.size = tframe.size;
    self.textView.frame = frame;
    
    self.chatContentSize = frame.size;
    [super layoutSubviews];
}

@end

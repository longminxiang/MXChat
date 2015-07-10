//
//  MXChatStateButton.m
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatStateButton.h"

@implementation MXChatStateButton
@synthesize loadingView = _loadingView;

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [UIActivityIndicatorView new];
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.loadingView.frame = self.bounds;
}

- (void)setCellState:(MXChatCellState)cellState
{
    _cellState = cellState;
    switch (cellState) {
        case MXChatCellStateLoading:
            self.userInteractionEnabled = NO;
            [self.loadingView startAnimating];
            [self setTitle:nil forState:UIControlStateNormal];
            self.hidden = NO;
            break;
        case MXChatCellStateFailed:
            self.userInteractionEnabled = YES;
            [self.loadingView stopAnimating];
            [self setTitle:@"发送失败" forState:UIControlStateNormal];
            self.hidden = NO;
            break;
        default:
            self.userInteractionEnabled = NO;
            [self.loadingView stopAnimating];
            [self setTitle:nil forState:UIControlStateNormal];
            self.hidden = YES;
            break;
    }
}

@end

//
//  MXChatStateButton.h
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MXChatCellState) {
    MXChatCellStateDefault = 0,
    MXChatCellStateLoading,
    MXChatCellStateFailed,
};

@interface MXChatStateButton : UIButton

@property (nonatomic, readonly) UIActivityIndicatorView *loadingView;

@property (nonatomic, assign) MXChatCellState cellState;

@end

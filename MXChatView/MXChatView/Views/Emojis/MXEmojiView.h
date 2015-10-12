//
//  MXEmojiView.h
//
//  Created by longminxiang on 14-1-8.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXEmojiView : UIView

@property (nonatomic, readonly) UIButton *sendButton;

- (id)initWithFrame:(CGRect )frame textInput:(id<UITextInput>)textInput;

@end

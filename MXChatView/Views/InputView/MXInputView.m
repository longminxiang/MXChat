//
//  MXInputView.m
//
//  Created by longminxiang on 14-3-6.
//  Copyright (c) 2014年 longminxiang. All rights reserved.
//

#import "MXInputView.h"
#import "MXVoiceRecorder.h"
#import "MXEmojiView.h"
#import "MXInputToobar.h"
#import "MXChatImageHelper.h"
#import "MXChatPrefix.h"
#import "MXExtentView.h"

#define MXINPUTVIEW_HEIGHT              44

typedef NS_ENUM(NSInteger, MXInputViewActiveType) {
    MXInputViewActiveNone,
    MXInputViewActiveAudio,
    MXInputViewActiveText,
    MXInputViewActiveSmile,
    MXInputViewActiveExtent,
};

@interface MXInputView ()<UITextViewDelegate>

@property (nonatomic, readonly) MXEmojiView *emojiView;
@property (nonatomic, readonly) MXExtentView *extenView;
@property (nonatomic, readonly) MXInputToobar *toobar;
@property (nonatomic, assign) MXInputViewActiveType activeType;

@property (nonatomic, assign) float keyboardHeight;
@property (nonatomic, assign) BOOL isToobarHeightChange;
@property (nonatomic, assign) BOOL active;

@property (nonatomic, copy) void (^frameChangeBlock)(CGRect oldFrame, CGRect newFrame);
@property (nonatomic, copy) void (^outputTextBlock)(NSString *text);
@property (nonatomic, copy) MXInputViewAudioOutBlock outputVoiceBlock;
@property (nonatomic, copy) MXInputViewImageOutBlock outputImageBlock;

@end

@implementation MXInputView

- (id)initWithSuperViewBounds:(CGRect)bounds
{
    CGRect frame = bounds;
    frame.origin.y = frame.size.height - MXINPUTVIEW_HEIGHT;
    frame.size.height = MXINPUTVIEW_HEIGHT;
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor grayColor];
        [self addNotification];
        [self setupToobar];
        [self setupEmojiView];
        [self setupExtenView];
        [self setAutoresizesSubviews:NO];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)addNotification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark
#pragma mark === setup ===

- (void)setupToobar
{
    MXInputToobar *toobar = [MXInputToobar xibView];
    CGRect frame = toobar.frame;
    frame.size.width = self.frame.size.width;
    toobar.frame = frame;
    [self addSubview:toobar];
    
    toobar.textView.delegate = self;
    
    __weak MXInputView *weaks = self;
    [toobar setHeightChangeBlock:^{
        weaks.isToobarHeightChange = YES;
        [weaks updateFrame];
    }];
    
    [toobar setButtonsTouchedBlock:^(NSInteger tag) {
        [weaks toobarButtonsTouched:tag];
    }];
    
    [toobar setVoiceRecordFinishedBlock:^(NSData *data, float time, NSString *path, NSString *key) {
        if (self.outputVoiceBlock) self.outputVoiceBlock(data, time, path, key);
    }];
    
    _toobar = toobar;
}

- (void)setupEmojiView
{
    CGRect frame = self.bounds;
    frame.size.height = MXEXTENT_VIEW_HEIGHT;
    frame.origin.y = self.frame.size.height;
    MXEmojiView *view = [[MXEmojiView alloc] initWithFrame:frame textInput:self.toobar.textView];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:view];
    
    [view.sendButton addTarget:self action:@selector(emojiViewSendButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    _emojiView = view;
}

- (void)setupExtenView
{
    CGRect frame = self.bounds;
    frame.size.height = MXEXTENT_VIEW_HEIGHT;
    frame.origin.y = self.frame.size.height;
    MXExtentView *view = [[MXExtentView alloc] initWithFrame:frame titles:@[@"拍照", @"选择"] images:@[@"c", @"p"]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view setFrame:frame];
    [self addSubview:view];
    [view setButtonsTouchedBlock:^(NSInteger tag) {
        if (tag >= 0 && tag <= 1) {
            [MXChatImageHelper showPhotoPickerOrCamera:tag completion:^(UIImage *image, NSString *path, NSString *key) {
                if (!image) return;
                if (self.outputImageBlock) self.outputImageBlock(image, path, key);
            }];
        }
    }];
    _extenView = view;
}

#pragma mark
#pragma mark === public ===

- (void)deactive
{
    if (self.active) {
        [self.toobar deactive];
        self.activeType = MXInputViewActiveNone;
        [self updateFrame];
    }
}

#pragma mark
#pragma mark === frame ===

- (void)updateFrame
{
    CGRect selfFrame = self.frame;
    CGRect toobarFrame = self.toobar.frame;
    
    UIView *tmpView;
    CGFloat selfHeight;
    BOOL emojiViewUpOrDown = NO, MXExtentViewUpOrDown = NO;
    switch (self.activeType) {
        case MXInputViewActiveText:
            selfHeight = toobarFrame.size.height + self.keyboardHeight;
            tmpView = nil;
            self.active = YES;
            break;
        case MXInputViewActiveSmile:
            selfHeight = toobarFrame.size.height + self.emojiView.frame.size.height;
            [self bringSubviewToFront:self.emojiView];
            emojiViewUpOrDown = YES;
            tmpView = self.emojiView;
            self.active = YES;
            break;
        case MXInputViewActiveExtent:
            selfHeight = toobarFrame.size.height + self.extenView.frame.size.height;
            tmpView = self.extenView;
            [self bringSubviewToFront:self.extenView];
            MXExtentViewUpOrDown = YES;
            self.active = YES;
            break;
        case MXInputViewActiveAudio:
            selfHeight = MXINPUTVIEW_HEIGHT;
            tmpView = nil;
            self.active = NO;
            break;
        default:
            selfHeight = toobarFrame.size.height;
            tmpView = nil;
            self.active = NO;
            break;
    }
    
    if (!self.isToobarHeightChange) {
        [self slideView:self.extenView selfHeight:selfHeight upOrDown:MXExtentViewUpOrDown];
        [self slideView:self.emojiView selfHeight:selfHeight upOrDown:emojiViewUpOrDown];
    }
    
    if (selfHeight == selfFrame.size.height) return;
    
    selfFrame.origin.y = self.superview.bounds.size.height - selfHeight;
    
    if (self.isToobarHeightChange) {
        self.frame = selfFrame;
        
        CGRect tmpViewFrame = tmpView.frame;
        tmpViewFrame.origin.y = toobarFrame.size.height;
        tmpView.frame = tmpViewFrame;
        
        self.isToobarHeightChange = NO;
    }
    selfFrame.size.height = selfHeight;
    
    CGRect oldFrame = self.frame;
    [UIView animateWithDuration:MXINPUTVIEW_SLIDE_DURATION animations:^{
        self.frame = selfFrame;
    }];
    if (self.frameChangeBlock) self.frameChangeBlock(oldFrame, selfFrame);
}

- (void)slideView:(UIView *)view selfHeight:(CGFloat)selfHeight upOrDown:(BOOL)upOrDown
{
    CGRect frame = view.frame;
    CGFloat oy = upOrDown ? self.toobar.frame.size.height : selfHeight;
    if (frame.origin.y == oy) return;
    frame.origin.y = oy;
    [UIView animateWithDuration:MXINPUTVIEW_SLIDE_DURATION animations:^{
        view.frame = frame;
    }];
}

#pragma mark
#pragma mark === action ===

- (void)tapGestureHandle
{
    
}

- (void)toobarButtonsTouched:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:[self.toobar.textView becomeFirstResponder];break;
        case 1:self.activeType = MXInputViewActiveAudio;break;
        case 2:self.activeType = MXInputViewActiveSmile;break;
        case 3:self.activeType = MXInputViewActiveExtent;break;
        default:break;
    }
    if (buttonIndex >= 1 && buttonIndex <= 3) {
        [self updateFrame];
        [self.toobar.textView resignFirstResponder];
    }
}

- (void)emojiViewSendButtonTouched:(UIButton *)button
{
    UITextView *textView = self.toobar.textView;
    NSString *text = textView.text;
    if (!text) return;
    if (![[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        if (self.outputTextBlock) self.outputTextBlock(text);
    }
    textView.text = nil;
}

#pragma mark
#pragma mark === delegate ===

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self emojiViewSendButtonTouched:nil];
        return NO;
    }
    return YES;
}

#pragma mark
#pragma mark === notification ===

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    CGRect endFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    BOOL isHide = mxc_keyWindow().bounds.size.height == endFrame.origin.y;
    self.keyboardHeight = isHide ? 0 : endFrame.size.height;
    if (!isHide) {
        self.activeType = MXInputViewActiveText;
        [self updateFrame];
    }
    else {
        if (self.activeType != MXInputViewActiveSmile && self.activeType != MXInputViewActiveExtent) {
            self.activeType = MXInputViewActiveNone;
            [self updateFrame];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

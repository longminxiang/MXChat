//
//  MXInputView.h
//
//  Created by longminxiang on 14-3-6.
//  Copyright (c) 2014年 longminxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXInputToobar.h"

#define MXEXTENT_VIEW_HEIGHT            216
#define MXINPUTVIEW_SLIDE_DURATION      0.25
#define MXINPUTVIEW_SLIDE_SPEED         MXINPUTVIEW_SLIDE_DURATION/MXEXTENT_VIEW_HEIGHT

@interface MXInputView : UIView

typedef void (^MXInputViewImageOutBlock)(UIImage *image, NSString *path, NSString *key);
typedef void (^MXInputViewAudioOutBlock)(NSData *data, float time, NSString *path, NSString *key);

@property (nonatomic, readonly) MXInputToobar *toobar;

- (id)initWithSuperViewBounds:(CGRect)bounds;

- (void)deactive;

- (void)setFrameChangeBlock:(void (^)(CGRect oldFrame, CGRect newFrame))frameChangeBlock;

- (void)setOutputTextBlock:(void (^)(NSString *text))outputTextBlock;

- (void)setOutputVoiceBlock:(MXInputViewAudioOutBlock)outputVoiceBlock;

- (void)setOutputImageBlock:(MXInputViewImageOutBlock)outputImageBlock;

@end

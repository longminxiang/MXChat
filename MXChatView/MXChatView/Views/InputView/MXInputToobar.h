//
//  MXInputToobar.h
//
//  Created by longminxiang on 14-3-6.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MXIT_TEXTVIEW_HEIGHT        34
#define MXIT_TEXTVIEW_MAX_HEIGHT    80

@interface MXInputToobar : UIView

typedef void (^MXInputToobarAudioOutBlock)(NSData *data, float time, NSString *path, NSString *key);

@property (nonatomic, weak) IBOutlet UIImageView *bgView;

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, assign) CGFloat textViewMinHeight;
@property (nonatomic, assign) CGFloat textViewMaxHeight;

+ (instancetype)xibView;

- (BOOL)deactive;

- (void)setButtonsTouchedBlock:(void (^)(NSInteger tag))buttonsTouchedBlock;

- (void)setHeightChangeBlock:(void (^)(void))heightChangeBlock;

- (void)setVoiceRecordFinishedBlock:(MXInputToobarAudioOutBlock)voiceRecordFinishedBlock;

@end

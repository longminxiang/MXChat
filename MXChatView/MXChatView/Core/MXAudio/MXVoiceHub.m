//
//  MXVoiceHub.m
//
//  Created by longminxiang on 14-4-1.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import "MXVoiceHub.h"
#import "MXChatPrefix.h"

#define IMAGEVIEW_TAG 1234
#define HUB_TAG 3323

@interface MXVoiceHub ()

@property (nonatomic, assign) float progress;

@end

@implementation MXVoiceHub

+ (instancetype)sharedHub
{
    static id object;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{object = [self new];});
    return object;
}

+ (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MXVoiceHub *hub = (MXVoiceHub *)[keyWindow viewWithTag:HUB_TAG];
    if (!hub) {
        hub = [self sharedHub];
        hub.tag = HUB_TAG;
        [keyWindow addSubview:hub];
    }
    [UIView animateWithDuration:0.3 animations:^{
        hub.alpha = 1;
    }];
}

+ (void)hide
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MXVoiceHub *hub = (MXVoiceHub *)[keyWindow viewWithTag:HUB_TAG];
    [UIView animateWithDuration:0.3 animations:^{
        hub.alpha = 0;
    }];
}

+ (void)setProgress:(float)progress
{
    [[self sharedHub] setProgress:progress];
}

- (id)init
{
    CGRect frame = CGRectMake(0, 0, 140, 140);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.tag = IMAGEVIEW_TAG;
        imageView.image = mxc_imageInChatBundle(@"a0");
        [self addSubview:imageView];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        imageView.center = keyWindow.center;
    }
    return self;
}

- (void)setProgress:(float)progress
{
    if (progress > 1) return;
    _progress = progress;
    
    int pro = (int)(progress * 90);
    if (pro > 6) pro = 6;
    UIImageView *imageView = (UIImageView *)[self viewWithTag:IMAGEVIEW_TAG];
    NSString *imageName = [NSString stringWithFormat:@"a%d",pro];
    imageView.image = mxc_imageInChatBundle(imageName);
}

@end

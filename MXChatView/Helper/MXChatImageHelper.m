//
//  MXChatImageHelper.m
//
//  Created by longminxiang on 15/6/12.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatImageHelper.h"
#import "MXPhotoViewer.h"
#import "UIImageView+WebCache.h"
#import "MXChatMessage.h"
#import "SDImageCache.h"
#import "MXChatPrefix.h"
#import "NSData+MD5.h"
#import "UIImage+FixOrientation.h"
#import "DALabeledCircularProgressView.h"
#import <objc/runtime.h>

#pragma mark
#pragma mark === CircularProgress ===

@implementation UIImageView (CircularProgress)

- (DALabeledCircularProgressView *)circularProgressView
{
    NSInteger tag = 23413;
    DALabeledCircularProgressView *view = (DALabeledCircularProgressView *)[self viewWithTag:tag];
    if (!view) {
        view = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
        view.tag = tag;
        view.trackTintColor = [UIColor lightGrayColor];
        view.progressTintColor = [UIColor grayColor];
        view.progressLabel.textColor = [UIColor whiteColor];
        view.progressLabel.font = [UIFont systemFontOfSize:12];
        view.roundedCorners = YES;
        [self addSubview:view];
    }
    return view;
}

- (void)removeProgressView
{
    NSInteger tag = 23413;
    DALabeledCircularProgressView *view = (DALabeledCircularProgressView *)[self viewWithTag:tag];
    [view removeFromSuperview];
}

- (void)progressViewChangeProgress:(float)progress
{
    if (progress <= 0) return;
    if (!CGPointEqualToPoint(self.circularProgressView.center, self.center)) {
        self.circularProgressView.center = self.center;
    }
    [self.circularProgressView setProgress:progress animated:YES];
    self.circularProgressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
}

@end

#pragma mark
#pragma mark === imageWithURL ===

@implementation UIImageView (imageWithURL)

- (void)setImageWithURLString:(NSString *)url
{
    [self sd_setImageWithURL:(NSURL *)url placeholderImage:mxc_imageInChatBundle(@"defaultImage")];
}

- (void)setImageAndShowProgressViewWithURL:(NSString *)url
{
    [self setImageAndShowProgressViewWithURL:url completion:nil];
}

- (void)setImageAndShowProgressViewWithURL:(NSString *)url completion:(void (^)(UIImage *image))completion
{
    [self sd_setImageWithURL:(NSURL *)url placeholderImage:mxc_imageInChatBundle(@"defaultImage") options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        double progress = (double)receivedSize / (double)expectedSize;
        [self progressViewChangeProgress:progress];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
        [self removeProgressView];
        if (completion) completion(image);
    }];
}

@end

#pragma mark
#pragma mark === MXChatImageHelper ===

@interface MXChatImageHelper ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) imageHelperBlock completion;

@end

@implementation MXChatImageHelper

+ (instancetype)sharedInstance
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

#pragma mark
#pragma mark === cache ===

+ (NSString *)storeImage:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    image = [[UIImage alloc] initWithData:data];
    NSString *key = [data mxc_MD5];
    [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:NO imageData:data forKey:key toDisk:YES];
    return key;
}

+ (NSString *)imagePathForKey:(NSString *)key
{
    return [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
}

+ (void)moveImageWithKey:(NSString *)key asKey:(NSString *)nkey
{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    [[SDImageCache sharedImageCache] storeImage:image forKey:nkey];
    [[SDImageCache sharedImageCache] removeImageForKey:key];
}

#pragma mark
#pragma mark === picker or camera ===

+ (void)showPhotoPickerOrCamera:(BOOL)pickerOrCamera completion:(imageHelperBlock)completion
{
    [[self sharedInstance] showPhotoPickerOrCamera:pickerOrCamera completion:completion];
}

- (void)showPhotoPickerOrCamera:(BOOL)pickerOrCamera completion:(imageHelperBlock)completion
{
    self.completion = completion;
    BOOL enableCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!pickerOrCamera && !enableCamera) {
        NSLog(@"找不到相机");
        if (self.completion) self.completion(nil, nil, nil);
        return ;
    }
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:pickerOrCamera ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera];
    [mxc_rootViewController() presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *key, *path;
    if (image) {
        if ( picker.sourceType != UIImagePickerControllerSourceTypeCamera) {
            image = [image mxc_fixOrientation];
        }
        key = [MXChatImageHelper storeImage:image];
        path = [MXChatImageHelper imagePathForKey:key];
    }
    if (self.completion) self.completion(image, path, key);
}

@end

@implementation MXChatImageHelper (PhotoViewer)

+ (void)showPhotoViewerWithImageMessages:(NSArray *)imgs cntIndex:(NSInteger)cntIndex
{
    [MXPhotoViewer showWithCount:imgs.count cntIndex:cntIndex detailViewSetter:^(MXPhotoDetailView *dview, NSInteger index) {
        id<MXChatImageMessage> msg = imgs[index];
        [dview.imageView setImageAndShowProgressViewWithURL:[msg imageURL] completion:^(UIImage *image) {
            [dview addImage:image];
        }];
    }];
}

@end
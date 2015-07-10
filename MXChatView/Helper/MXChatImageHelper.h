//
//  MXChatImageHelper.h
//
//  Created by longminxiang on 15/6/12.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark
#pragma mark === CircularProgress ===

@interface UIImageView (CircularProgress)

/**
 *  显示进度圈
 *
 *  @param progress 进度百分比
 */
- (void)progressViewChangeProgress:(float)progress;

/**
 *  移除进度圈
 */
- (void)removeProgressView;

@end

#pragma mark
#pragma mark === imageWithURL ===

@interface UIImageView (imageWithURL)

/**
 *  通过URL或key设置图片
 *
 *  @param url       url or key
 */
- (void)setImageWithURL:(NSString *)url;

/**
 *  通过URL或key设置图片，显示进度圈
 *
 *  @param url        url or key
 */
- (void)setImageAndShowProgressViewWithURL:(NSString *)url;

/**
 *  通过URL或key设置图片，显示进度圈
 *
 *  @param url        url or key
 *  @param completion 完成回调
 */
- (void)setImageAndShowProgressViewWithURL:(NSString *)url completion:(void (^)(UIImage *image))completion;

@end

#pragma mark
#pragma mark === MXChatImageHelper ===

@interface MXChatImageHelper : NSObject

typedef void (^imageHelperBlock)(UIImage *image, NSString *path, NSString *key);

+ (void)moveImageWithKey:(NSString *)key asKey:(NSString *)nkey;

+ (NSString *)imagePathForKey:(NSString *)key;

/**
 *  显示图片库或相机，选择相片
 *
 *  @param pickerOrCamera 图片库或相机
 *  @param completion     完成回调
 */
+ (void)showPhotoPickerOrCamera:(BOOL)pickerOrCamera completion:(imageHelperBlock)completion;

@end

@interface MXChatImageHelper (PhotoViewer)

/**
 *  显示图片浏览器
 *
 *  @param imgs     图片组
 *  @param cntIndex 当前图片index
 */
+ (void)showPhotoViewerWithImageMessages:(NSArray *)imgs cntIndex:(NSInteger)cntIndex;

@end

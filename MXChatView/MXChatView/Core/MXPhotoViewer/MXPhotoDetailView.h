//
//  MXPhotoDetailView.h
//
//  Created by eric on 15/6/11.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXPhotoDetailView : UIView

@property (nonatomic, readonly) UIImageView *imageView;

- (void)addImage:(UIImage *)image;

- (void)resetZoomScale;

@end

//
//  MXPhotoDetailView.m
//
//  Created by eric on 15/6/11.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXPhotoDetailView.h"

@interface MXPhotoDetailView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MXPhotoDetailView
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect bounds = self.bounds;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:bounds];
        [scrollView setDelegate:self];
        [scrollView setMinimumZoomScale:1];
        [scrollView setMaximumZoomScale:5];
        scrollView.alwaysBounceHorizontal = YES;
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        
        _imageView = [UIImageView new];
        _imageView.frame = (CGRect){0, 0, 280, 280};
        _imageView.center = self.center;
        [self.scrollView addSubview:_imageView];
    }
    return self;
}

- (void)addImage:(UIImage *)image
{
    if (!image) return;
    CGSize imageSize = image.size;
    float imageViewWeight = self.scrollView.frame.size.width;
    float imageViewHeight = 0.0f;
    float scale = imageSize.height / imageSize.width;
    imageViewHeight = imageViewWeight * scale;
    
    CGRect rect = CGRectMake(0, 0, imageViewWeight, imageViewHeight);
    [self.imageView setFrame:rect];
    [self.imageView setImage:image];
    
    [self.scrollView setContentSize:CGSizeMake(imageViewWeight, imageViewHeight)];
    
    float height = self.scrollView.frame.size.height;
    float hInset = ABS(height - imageViewHeight)/2;
    [self.scrollView setContentInset:UIEdgeInsetsMake(hInset, 0, hInset, 0)];
    
    float hInset2 = (imageViewHeight - height)/2;
    [self.scrollView setContentOffset:CGPointMake(0, hInset2)];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark === action ===

- (void)resetZoomScale
{
    if (self.scrollView.zoomScale < 1.5) {
        [self.scrollView setZoomScale:2 animated:YES];
    }
    else {
        [self.scrollView setZoomScale:1 animated:YES];
    }
}

@end

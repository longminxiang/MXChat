//
//  MXPhotoViewer.m
//
//  Created by eric on 15/6/11.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXPhotoViewer.h"
#import "MXChatPrefix.h"
#import "UIView+ActionSheet.h"

#pragma mark
#pragma mark === MXPhotoToolbar ===

@interface MXPhotoToolbar : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation MXPhotoToolbar

- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        self.label = [UILabel new];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor whiteColor];
        [self addSubview:self.label];
        
        UIButton *button = [UIButton new];
        [button setImage:mxc_imageInChatBundle(@"e") forState:UIControlStateNormal];
        [self addSubview:button];
        self.button = button;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect bounds = self.bounds;
    self.label.frame = bounds;
    bounds.origin.x = bounds.size.width - 60;
    bounds.size.width = 60;
    self.button.frame = bounds;
}

- (void)tapGestureHandle
{
    
}

@end

#pragma mark
#pragma mark === MXPhotoViewer ===

@interface MXPhotoViewer ()<UIScrollViewDelegate>

@property (nonatomic, strong) MXPhotoToolbar *toolbar;

@property (nonatomic) BOOL toolbarHide;

@property (nonatomic, readonly) NSMutableArray *detailViews;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger kNumberOfPages,currentPage;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture, *doubleGesture;

@property (nonatomic, copy) MXPhotoViewerDetailViewSetter detailViewSetter;

@end

@implementation MXPhotoViewer

#define VIEWER_TAG  35323

static UIStatusBarStyle _systemStatusBarStyle;

+ (void)showWithCount:(NSInteger)count cntIndex:(NSInteger)cntIndex detailViewSetter:(MXPhotoViewerDetailViewSetter)detailViewSetter
{
    MXPhotoViewer *viewer = [[MXPhotoViewer alloc] initWithCount:count cntIndex:cntIndex detailViewSetter:detailViewSetter];
    viewer.tag = VIEWER_TAG;
    
    UIWindow *window = mxc_keyWindow();
    CGRect bounds = [UIScreen mainScreen].bounds;
    viewer.frame = bounds;
    [window addSubview:viewer];
    viewer.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        viewer.alpha = 1;
    } completion:nil];
    _systemStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [viewer startLoadDetailViews];
}

+ (void)dismiss
{
    [[UIApplication sharedApplication] setStatusBarStyle:_systemStatusBarStyle];
    UIView *viewer = [mxc_keyWindow() viewWithTag:VIEWER_TAG];
    [UIView animateWithDuration:0.25 animations:^{
        viewer.alpha = 0;
    } completion:^(BOOL finished) {
        [viewer removeFromSuperview];
    }];
}

- (instancetype)initWithCount:(NSInteger)count cntIndex:(NSInteger)cntIndex detailViewSetter:(MXPhotoViewerDetailViewSetter)detailViewSetter
{
    if (self = [super init]) {
        self.currentPage = cntIndex;
        self.kNumberOfPages = count;
        self.detailViewSetter = detailViewSetter;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor blackColor];
    
    self.doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    self.doubleGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.doubleGesture];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.tapGesture requireGestureRecognizerToFail:self.doubleGesture];
    [self addGestureRecognizer:self.tapGesture];
    
    _detailViews = [NSMutableArray new];
    for (int i = 0; i < self.kNumberOfPages; i++) {
        [_detailViews addObject:[NSNull null]];
    }
    
    UIScrollView *scrollView = [UIScrollView new];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    MXPhotoToolbar *toobar = [MXPhotoToolbar new];
    [toobar.button addTarget:self action:@selector(toobarButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:toobar];
    self.toolbar = toobar;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateFrame];
}

- (void)updateFrame
{
    CGRect bounds = self.bounds;
    
    //toolbar
    CGRect tframe = bounds;
    CGFloat toolbarHeight = 49;
    tframe.origin.y = tframe.size.height - toolbarHeight;
    tframe.size.height = toolbarHeight;
    self.toolbar.frame = tframe;
    
    self.scrollView.frame = bounds;
    self.scrollView.contentSize = CGSizeMake(bounds.size.width * self.kNumberOfPages, bounds.size.height);
    [self.scrollView setContentOffset:CGPointMake(bounds.size.width * self.currentPage, 0)];
}

#pragma mark === scrollview ===

- (void)limitPageCount:(NSInteger)pCount cnPage:(NSInteger)page
{
    NSInteger rPage = page - pCount;
    if (rPage >= 0 && rPage < self.kNumberOfPages) {
        UIView *view = [self.detailViews objectAtIndex:rPage];
        if (![view isKindOfClass:[NSNull class]]) {
            [view removeFromSuperview];
            [self.detailViews replaceObjectAtIndex:rPage withObject:[NSNull null]];
        }
    }
}

- (void)startLoadDetailViews
{
    [self loadScrollViewWithPage:self.currentPage - 1];
    [self loadScrollViewWithPage:self.currentPage];
    [self loadScrollViewWithPage:self.currentPage + 1];
    
    self.toolbar.label.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentPage + 1,(long)self.kNumberOfPages];
}

- (void)loadScrollViewWithPage:(NSInteger)page
{
    if (page < 0 || page >= self.kNumberOfPages)
        return;
    [self limitPageCount:5 cnPage:page];
    [self limitPageCount:-5 cnPage:page];
    
    if ((NSNull *)[self.detailViews objectAtIndex:page] == [NSNull null]) {
        MXPhotoDetailView *view = [[MXPhotoDetailView alloc] initWithFrame:self.scrollView.bounds];
        if (self.detailViewSetter) self.detailViewSetter(view, page);
        [self.detailViews replaceObjectAtIndex:page withObject:view];
    }
    UIView *view = [self.detailViews objectAtIndex:page];
    if ([view superview] == nil) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        [view setFrame:frame];
        [self.scrollView addSubview:view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (self.currentPage != page) {
        self.currentPage = page;
        [self startLoadDetailViews];
    }
}

- (void)view:(UIView *)view showOrHideWithFade:(BOOL)showOrHide completion:(void (^)(BOOL finished))completion
{
    CGFloat alpha = showOrHide ? 1 : 0;
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = alpha;
    } completion:completion];
}

#pragma mark === action ===

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture == self.tapGesture) {
        [[self class] dismiss];
    }
    else {
        MXPhotoDetailView *view = self.detailViews[self.currentPage];
        [view resetZoomScale];
    }
}

- (void)toobarButtonTouched:(UIButton *)button
{
    [self mxc_showActionSheetWithBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self savePictureToAlbum];
        }
    } title:@"图片" cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles:nil];
}

- (void)savePictureToAlbum
{
    if (self.detailViews.count <= self.currentPage) return;
    MXPhotoDetailView *view = self.detailViews[self.currentPage];
    if (![view isKindOfClass:[MXPhotoDetailView class]]) return;
    UIImage *image = view.imageView.image;
    if (!image) return;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"保存成功");
        mxc_showLoadingProgressWithMessage(@"保存成功", 1);
    }
}

- (void)dealloc
{
    self.scrollView.delegate = nil;
}

@end

//
//  MXEmojiView.m
//
//  Created by longminxiang on 14-1-8.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import "MXEmojiView.h"
#import "MXEmojis.h"
#import "MXChatPrefix.h"

#define MXEMOJI_SIZE                      CGSizeMake(50, 40)

@interface MXEmojiView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *allEmoji;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) id textInput;

@property (nonatomic, assign) BOOL isPageControlAction;

@end

@implementation MXEmojiView

- (NSArray *)emojis
{
    static NSArray *emojis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojis = EMOJIS;
    });
    return emojis;
}

- (id)initWithFrame:(CGRect )frame textInput:(id<UITextInput>)textInput
{
    if (self = [super initWithFrame:frame]) {
        self.textInput = textInput;
        
        _allEmoji = [self emojis];
        NSInteger count = _allEmoji.count;
        NSInteger perRowCount = frame.size.width / MXEMOJI_SIZE.width;
        CGFloat exx = frame.size.width - (perRowCount * MXEMOJI_SIZE.width);
        NSInteger perPageRow = 4;
        NSInteger perPageCount = perRowCount * perPageRow - 1;
        NSInteger page = count / perPageCount + (count % perPageCount != 0);
        
        //scrollview
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setPagingEnabled:YES];
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(frame.size.width * page, frame.size.height);
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //buttons
        CGRect emojiFrame = CGRectZero;
        emojiFrame.size = MXEMOJI_SIZE;
        int current = 0;
        for (int i = 0; i < page; i++) {
            for (int j = 0; j < perPageRow; j++) {
                for (int k = 0; k < perRowCount; k++) {
                    if (current < count) {
                        if ((k+1)*(j+1) == perPageRow * perRowCount) continue;
                        emojiFrame.origin.x = emojiFrame.size.width * k + frame.size.width * i + exx / 2;
                        emojiFrame.origin.y = emojiFrame.size.height * j;
                        UIButton *button = [[UIButton alloc] initWithFrame:emojiFrame];
                        button.titleLabel.font = [UIFont systemFontOfSize:18];
                        button.tag = current;
                        NSString *emoji = _allEmoji[button.tag];
                        [button setTitle:emoji forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(emojiButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:button];
                        current++;
                    }
                }
            }
            emojiFrame.origin.x = emojiFrame.size.width * (perRowCount - 1) + frame.size.width * i + exx / 2;
            emojiFrame.origin.y = emojiFrame.size.height * (perPageRow - 1);
            UIButton *button = [[UIButton alloc] initWithFrame:emojiFrame];
            [button setImage:mxc_imageInChatBundle(@"de") forState:UIControlStateNormal];
            [button setImage:mxc_imageInChatBundle(@"de_p") forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(deleteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
        }
        
        //page control
        frame.origin.y = frame.size.height - 50;
        frame.size.height = 30;
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.numberOfPages = page;
        [pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        //sendButton
        frame = CGRectMake(frame.size.width - 70, self.frame.size.height - 44 - 13, 60, 44);
        UIButton *sendButton = [[UIButton alloc] initWithFrame:frame];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithRed:58.f/255.f green:143.f/255.f blue:183.f/255.f alpha:1] forState:UIControlStateNormal];
        [self addSubview:sendButton];
        _sendButton = sendButton;
    }
    return self;
}

- (void)emojiButtonTouched:(UIButton *)button
{
    if ([self.textInput respondsToSelector:@selector(replaceRange:withText:)] && [self.textInput respondsToSelector:@selector(selectedTextRange)]) {
        NSString *emoji = self.allEmoji[button.tag];
        UITextRange* selectedRange = [self.textInput selectedTextRange];
        [self.textInput replaceRange:selectedRange withText:emoji];
    }
}

- (void)deleteButtonTouched:(UIButton *)button
{
    if ([self.textInput respondsToSelector:@selector(deleteBackward)]) {
        [self.textInput deleteBackward];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isPageControlAction) return;
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isPageControlAction = NO;
}

- (void)pageControlAction:(UIPageControl *)pageControl
{
    self.isPageControlAction = YES;
    NSInteger cntPage = pageControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake(cntPage * self.scrollView.frame.size.width, 0) animated:YES];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[[self class] description]);
}

@end

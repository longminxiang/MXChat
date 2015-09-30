//
//  MXInputToobar.m
//
//  Created by eric on 14-3-6.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import "MXInputToobar.h"
#import "MXChatAudioHelper.h"
#import "MXChatPrefix.h"

@interface MXInputToobar ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;

@property (nonatomic, assign) NSInteger currentTag;

@property (nonatomic, assign) BOOL active;

@property (nonatomic, strong) NSArray *btnImgs;

@property (nonatomic, copy) void (^buttonsTouchedBlock)(NSInteger tag);
@property (nonatomic, copy) void (^heightChangeBlock)(void);
@property (nonatomic, copy) MXInputToobarAudioOutBlock voiceRecordFinishedBlock;

@end

@implementation MXInputToobar

+ (instancetype)xibView
{
    NSArray *views;
    @try {
        views = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil];
    }
    @catch (NSException *exception) {}
    for (id obj in views) {
        if ([obj isKindOfClass:[self class]]) return obj;
    }
    return nil;
}

- (void)awakeFromNib
{
    self.btnImgs = @[@"v", @"s", @"e", @"k"];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
    [center addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self.textView];
    [self updateButtonsImages];
    self.textViewMinHeight = MXIT_TEXTVIEW_HEIGHT;
    self.textViewMaxHeight = MXIT_TEXTVIEW_MAX_HEIGHT;
    
    UIImage *image = mxc_imageInChatBundle(@"bg");
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    self.bgView.image = image;
    
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.textView.bounds];
    self.textView.layer.shadowPath = path.CGPath;
    
    [self.textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark === setter ===

- (BOOL)deactive
{
    self.active = NO;

    if (self.currentTag == 2 || self.currentTag == 3) {
        self.currentTag = 0;
        [self updateButtonsImages];
    }
    [self.textView resignFirstResponder];
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"] && object == self.textView) {
        [self updateFrameHeight];
    }
}

#pragma mark === private ===

- (void)button:(UIButton *)button setImageWithIdx:(NSInteger)idx
{
    if (idx >= self.btnImgs.count) return;
    NSString *imgName = self.btnImgs[idx];
    NSString *pimgName = [NSString stringWithFormat:@"%@_p", imgName];
    [button setImage:mxc_imageInChatBundle(imgName) forState:UIControlStateNormal];
    [button setImage:mxc_imageInChatBundle(pimgName) forState:UIControlStateHighlighted];
}

- (void)updateButtonsImages
{
    for (UIButton *button in self.buttons) {
        [self button:button setImageWithIdx:button.tag - 1];
    }
}

- (void)updateFrameHeight
{
    CGRect frame = self.frame;
    CGRect tframe = self.textView.frame;
    CGSize textContentSize = [self.textView sizeThatFits:CGSizeMake(tframe.size.width, self.textViewMinHeight)];
    self.textView.contentSize = textContentSize;
    CGFloat height = textContentSize.height;
    if (height < self.textViewMinHeight) height = self.textViewMinHeight;
    else if (height > self.textViewMaxHeight) height = self.textViewMaxHeight;
    
    BOOL needUpdata = NO;
    if (frame.size.height != height + 10) {
        frame.size.height = height + 10;
        needUpdata = YES;
    }
    
    if (needUpdata) {
        self.frame = frame;
        if (self.heightChangeBlock) self.heightChangeBlock();
    }
}

- (void)updateTextViewContentOffset
{
    UITextView *view = self.textView;
    
    UITextPosition* beginning = view.beginningOfDocument;
    UITextRange* selectedRange = view.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    NSInteger location = [view offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [view offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    CGPoint bottomOffset = CGPointMake(0, view.contentSize.height - view.bounds.size.height);
    
    if (location+length == view.text.length) {
        view.contentOffset = bottomOffset;
    }
    
    [view scrollRangeToVisible:NSMakeRange(location+length, 0)];
}

#pragma mark
#pragma mark === voice ===

- (IBAction)recordVoiceStart
{
    [MXChatAudioHelper startRecord];
}

- (IBAction)recordVoiceEnd
{
    __weak MXInputToobar *weaks = self;
    [MXChatAudioHelper stopRecord:^(NSData *data, float time, NSString *path, NSString *key) {
        if (weaks.voiceRecordFinishedBlock) weaks.voiceRecordFinishedBlock(data, time, path, key);
    }];
}

- (IBAction)recordVoiceCancel
{
    [MXChatAudioHelper cancelRecord];
}

#pragma mark
#pragma mark === action ===

- (IBAction)buttonToucheds:(UIButton *)button
{
    if (self.currentTag != button.tag) {
        self.active = YES;
        if (button.tag == 1) {
            self.textView.text = @"";
            self.active = NO;
        }
        self.currentTag = button.tag;
        [self.recordButton setHidden:self.currentTag != 1];
        
        for (UIButton *btn in self.buttons) {
            NSInteger tag = btn == button ? 3 : btn.tag - 1;
            [self button:btn setImageWithIdx:tag];
        }
    }
    else {
        [self.recordButton setHidden:YES];
        self.currentTag = 0;
        [self button:button setImageWithIdx:button.tag - 1];
    }
    if (self.buttonsTouchedBlock) self.buttonsTouchedBlock(self.currentTag);
}

#pragma mark
#pragma mark === notification ===


- (void)textViewDidChange:(NSNotification *)notification
{
    if (notification.object == self.textView) {
        [self updateFrameHeight];
        [self updateTextViewContentOffset];
    }
}

- (void)textViewDidBeginEditing:(NSNotification *)notification
{
    if (notification.object == self.textView) {
        self.active = YES;
        if (self.currentTag == 0) return;
        [self updateButtonsImages];
        self.currentTag = 0;
    }
}

- (void)dealloc
{
//    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.textView removeObserver:self forKeyPath:@"text" context:nil];
}

@end

//
//  MXExtentView.m
//
//  Created by eric on 14-1-10.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import "MXExtentView.h"
#import "MXChatPrefix.h"

#define MXEV_ROW                            2
#define MXEV_PER_ROW_COUNT                  4

@interface MXExtentView ()

@property (nonatomic, readonly) NSArray *buttons;
@property (nonatomic, copy) void (^buttonsTouchedBlock)(NSInteger tag);

@end

@implementation MXExtentView

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images
{
    if (self = [super initWithFrame:frame]) {
        NSInteger maxCount = titles.count > images.count ? titles.count : images.count;
        frame = CGRectMake(0, 0, (frame.size.width - 40) / MXEV_PER_ROW_COUNT, frame.size.height / MXEV_ROW - 20);
        int current = 0;
        NSMutableArray *array = [NSMutableArray new];
        for (int i = 0; i < MXEV_ROW; i++) {
            for (int j = 0; j < MXEV_PER_ROW_COUNT; j++) {
                if (current >= maxCount) continue;
                frame.origin.x = frame.size.width * j + 20;
                frame.origin.y = frame.size.height * i;
                UIButton *button = [[UIButton alloc] initWithFrame:frame];
                button.tag = current++;
                
                NSString *n = images[button.tag];
                UIImage *img = mxc_imageInChatBundle(n);
                [button setImage:img forState:UIControlStateNormal];
                n = [n stringByAppendingString:@"_p"];
                img = mxc_imageInChatBundle(n);
                [button setImage:img forState:UIControlStateHighlighted];
                
                CGRect lframe = button.bounds;
                lframe.origin.y = lframe.size.height - 20;
                lframe.size.height = 20;
                UILabel *label = [[UILabel alloc] initWithFrame:lframe];
                label.font = [UIFont systemFontOfSize:13];
                label.backgroundColor = [UIColor clearColor];
                label.text = titles[button.tag];
                label.textColor = [UIColor darkGrayColor];
                label.textAlignment = NSTextAlignmentCenter;
                [button addSubview:label];
                
                [button addTarget:self action:@selector(buttonsTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                [array addObject:button];
            }
        }
        if (array.count) _buttons = [NSArray arrayWithArray:array];
    }
    return self;
}

- (void)buttonsTouched:(UIButton *)button
{
    if (self.buttonsTouchedBlock) self.buttonsTouchedBlock(button.tag);
}

- (void)dealloc
{
//    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end

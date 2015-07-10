//
//  MXChatDialog.h
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MXChatDialog <NSObject>

- (NSString *)title;
- (NSString *)content;
- (NSString *)timeString;
- (NSString *)badgeText;

@end
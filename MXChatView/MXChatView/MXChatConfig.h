//
//  MXChatConfig.h
//
//  Created by eric on 15/5/28.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MXCHAT_DEFAULT_BUNDLE                   @"MXChat.bundle"

@interface MXChatConfig : NSObject

@property (nonatomic, copy) NSString *chatBundlePath;

+ (instancetype)instance;

- (UIImage *)imageInChatBundle:(NSString *)name;

@end
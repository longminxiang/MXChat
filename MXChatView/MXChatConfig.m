//
//  MXChatConfig.m
//
//  Created by eric on 15/5/28.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatConfig.h"
#import "MBProgressHUD.h"

@interface MXChatConfig ()

@property (nonatomic, strong) NSCache *bundleImageCache;

@end

@implementation MXChatConfig

+ (instancetype)instance
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

- (NSCache *)bundleImageCache
{
    if (!_bundleImageCache) {
        _bundleImageCache = [NSCache new];
        _bundleImageCache.countLimit = 100;
    }
    return _bundleImageCache;
}

- (NSString *)chatBundlePath
{
    if (!_chatBundlePath) {
        _chatBundlePath = [MXCHAT_DEFAULT_BUNDLE copy];
    }
    return _chatBundlePath;
}

- (UIImage *)imageInChatBundle:(NSString *)name
{
    id obj = [self.bundleImageCache objectForKey:name];
    if (obj) return obj;

    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], [self chatBundlePath]];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    path = [NSString stringWithFormat:@"%@@2x", name];
    path = [bundle pathForResource:path ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image)[self.bundleImageCache setObject:image forKey:name];
    return image;
}

@end

//
//  NSData+MD5.m
//
//  Created by longminxiang on 15/6/14.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (MD5)

- (NSString *)mxc_MD5
{
    const void *bytes = [self bytes];
    unsigned char result[16];
    CC_MD5(bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12], result[13],result[14],result[15]];
}

@end

@implementation NSString (MD5)

- (NSString *)mxc_MD5
{
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding];
    return [data mxc_MD5];
}

@end

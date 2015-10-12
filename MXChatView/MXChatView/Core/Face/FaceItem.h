//
//  FaceItem.h
//  Pods
//
//  Created by longminxiang on 15/10/9.
//
//

#import <Foundation/Foundation.h>

@interface FaceItem : NSObject

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *imageName;

+ (NSArray *)faceItems;

+ (FaceItem *)itemWithCode:(NSString *)code;

@end

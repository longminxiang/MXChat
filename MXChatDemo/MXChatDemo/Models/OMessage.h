//
//  OMessage.h
//
//  Created by eric on 15/6/9.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MXChat/MXChatMessage.h>

@interface OMessage : NSObject<MXChatMessage, MXChatTextMessage, MXChatImageMessage, MXChatAudioMessage>

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, assign) MXChatMessageType type;
@property (nonatomic, assign) MXChatMessageState state;
@property (nonatomic, assign) MXChatMessageOwnerType ownerType;
@property (nonatomic, assign) BOOL showTimeLabel;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, readonly) NSString *sendTimeString;

//文本
@property (nonatomic, copy) NSString *text;

//图像
@property (nonatomic, copy) NSString *imageURL;

//音频
@property (nonatomic, readonly) NSString *audioTimeString;
@property (nonatomic, copy) NSString *audioURL;

//辅助
@property (nonatomic, copy) NSDate *sendTime;
@property (nonatomic, assign) CGFloat audioTime;
@property (nonatomic, copy) NSString *path;

//扩展
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *receiver;
//可以是群组名或个人
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, assign) BOOL isGroup;

+ (OMessage *)textMessageWithText:(NSString *)text;
+ (OMessage *)imageMessageWithKey:(NSString *)key path:(NSString *)path;
+ (OMessage *)audioMessageWithKey:(NSString *)key path:(NSString *)path time:(float)time;

@end
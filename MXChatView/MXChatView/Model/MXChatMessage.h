//
//  MXChatMessage.h
//
//  Created by eric on 15/6/8.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MXChatMessageType) {
    MXChatMessageTypeText = 0,
    MXChatMessageTypeAudio,
    MXChatMessageTypeImage,
};

typedef NS_ENUM(NSInteger, MXChatMessageState) {
    MXChatMessageStateDefult,
    MXChatMessageStateSending,
    MXChatMessageStateFailed,
    MXChatMessageStateSuccess = MXChatMessageStateDefult,
};

typedef NS_ENUM(NSInteger, MXChatMessageOwnerType) {
    MXChatMessageOwnerTypeOther = 0,
    MXChatMessageOwnerTypeMine = 1,
};

@protocol MXChatMessage <NSObject>

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL showTimeLabel;

- (MXChatMessageType)type;
- (MXChatMessageState)state;
- (MXChatMessageOwnerType)ownerType;

- (NSString *)sendTimeString;

@end

@protocol MXChatTextMessage <MXChatMessage>

- (NSString *)text;

- (NSAttributedString *)attributedText;

@end

@protocol MXChatImageMessage <MXChatMessage>

- (NSString *)imageURL;

@end

@protocol MXChatAudioMessage <MXChatMessage>

- (NSString *)audioTimeString;
- (NSString *)audioURL;

@end

void getImageMessagesFromChatMessages(NSArray *messages, id cntMsg, void (^completion)(NSArray *imageMessages, NSInteger cntIndex));

@interface NSString (MXChatMessage)

- (NSString *)mxc_parseMessageText;

@end

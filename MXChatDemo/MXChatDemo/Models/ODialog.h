//
//  ODialog.h
//
//  Created by eric on 15/6/26.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MXChat/MXChatDialog.h>

typedef NS_ENUM(NSInteger, ODialogType) {
    ODialogTypePerson = 0,
    ODialogTypeGroup,
};

@interface ODialog : NSObject<MXChatDialog>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, readonly) NSAttributedString *attributedText;
@property (nonatomic, copy) NSString *badgeText;
@property (nonatomic, readonly) NSString *timeString;

@property (nonatomic, copy) NSDate *time;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, assign) NSInteger badge;
@property (nonatomic, assign) ODialogType type;

@end

//
//  ChatVC.h
//
//  Created by eric on 15/5/28.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatVC : UIViewController

- (instancetype)initWithUser:(NSString *)user;

- (instancetype)initWithGroupName:(NSString *)groupName users:(NSArray *)users;

@end

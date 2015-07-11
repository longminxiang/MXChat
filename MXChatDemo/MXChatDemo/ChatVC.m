//
//  ChatVC.m
//
//  Created by eric on 15/5/28.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "ChatVC.h"
#import "MXChatView.h"
#import "OMessage.h"

@interface ChatVC ()

@property (nonatomic, strong) MXChatView *chatView;
@property (nonatomic, readonly) NSArray *users;

@end

@implementation ChatVC

- (instancetype)initWithUser:(NSString *)user
{
    if (self = [super init]) {
        _users = @[user];
    }
    return self;
}

- (instancetype)initWithGroupName:(NSString *)groupName users:(NSArray *)users
{
    if (self = [super init]) {
        _users = users;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];

    CGRect frame = self.view.bounds;
    MXChatView *chatView = [[MXChatView alloc] initWithFrame:frame];
    [self.view addSubview:chatView];
    
    self.chatView = chatView;
    
    [chatView setTextMessageOutBlock:^(NSString *text) {
        OMessage *msg = [OMessage textMessageWithText:text];
        [self.chatView addMessage:msg];
    }];
    
    [chatView setImageMessageOutBlock:^(UIImage *image, NSString *path, NSString *key) {
        OMessage *msg = [OMessage imageMessageWithKey:key path:path];
        [self.chatView addMessage:msg];
    }];
    
    [chatView setAudioMessageOutBlock:^(NSData *data, float time, NSString *path, NSString *key) {
        OMessage *msg = [OMessage audioMessageWithKey:key path:path time:time];
        [self.chatView addMessage:msg];
    }];
    
    [chatView setResendMessageBlock:^(id<MXChatMessage> message) {
    }];
    
    [chatView setDeleteMessageBlock:^(id<MXChatMessage> message) {
    }];
    
    [chatView setCustomCellForElementBlock:^(MXChatBaseCell *cell, id<MXChatMessage> element) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [[self class] description]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

//
//  ListVC.m
//
//  Created by eric on 15/5/22.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "ListVC.h"
#import "MXChatListView.h"
#import "ODialog.h"
#import "ChatVC.h"

@interface ListVC ()

@property (nonatomic, strong) MXChatListView *listView;

@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = self.view.bounds;
    MXChatListView *listView = [[MXChatListView alloc] initWithFrame:frame];
    [self.view addSubview:listView];
    self.listView = listView;
    
    ODialog *dialog = [ODialog new];
    dialog.owner = @"eric";
    dialog.content = @"xxxxxx你好:angry:";
    [listView insertDialog:dialog];
    
    dialog = [ODialog new];
    dialog.owner = @"群组测试";
    [listView insertDialog:dialog];
    
    __WEAKS(weaks);
    
    [listView setTableViewDidSelectRowBlock:^(id<MXChatDialog> dialog, NSInteger index) {
        ODialog *dl = (ODialog *)dialog;
        if ([dl.owner isEqualToString:@"群组测试"]) {
            ChatVC *vc = [[ChatVC alloc] initWithGroupName:dl.owner users:@[@"idtst", @"eric10", @"eric11"]];
            [weaks.navigationController pushViewController:vc animated:YES];
        }
        else {
            ChatVC *vc = [[ChatVC alloc] initWithUser:[(ODialog *)dialog owner]];
            [weaks.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [listView setDeleteDialogBlock:^(id<MXChatDialog> dialog) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


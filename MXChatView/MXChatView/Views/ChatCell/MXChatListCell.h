//
//  MXChatListCell.h
//
//  Created by eric on 15/6/25.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXChatBadgeView.h"
#import <DTCoreText/DTCoreText.h>

@interface MXChatListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *tagImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet DTAttributedLabel *messageLabel;
@property (nonatomic, weak) IBOutlet MXChatBadgeButton *badgeView;

@end

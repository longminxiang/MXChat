//
//  MXChatAudioCell.h
//
//  Created by eric on 15/5/22.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import "MXChatBaseCell.h"

#define MXCC_AUDIO_SIZE     CGSizeMake(80, 30)

@class MXChatAudioCell;

@protocol MXChatAudioCellDelegate <MXChatBaseCellDelegate>

@optional
- (void)chatAudioCellAudioButtonTouchedEnd:(MXChatAudioCell *)cell;

@end

@interface MXChatAudioCell : MXChatBaseCell

@property (nonatomic, copy) NSString *timeString;

- (void)startAudioAnimating;

- (void)stopAudioAnimating;

@end

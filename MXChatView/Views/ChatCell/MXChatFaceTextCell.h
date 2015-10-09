//
//  MXChatFaceTextCell.h
//  Pods
//
//  Created by longminxiang on 15/10/9.
//
//

#import "MXChatBaseCell.h"
#import <DTCoreText/DTCoreText.h>

#define MXCC_FACE_TEXTVIEW_ORIGIN    CGPointMake(10, 8)

@interface MXChatFaceTextCell : MXChatBaseCell

@property (nonatomic, readonly) DTAttributedTextContentView *textView;

@end

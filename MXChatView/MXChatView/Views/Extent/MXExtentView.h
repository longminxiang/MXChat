//
//  MXExtentView.h
//
//  Created by eric on 14-1-10.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXExtentView : UIView

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images;

- (void)setButtonsTouchedBlock:(void (^)(NSInteger tag))buttonsTouchedBlock;

@end

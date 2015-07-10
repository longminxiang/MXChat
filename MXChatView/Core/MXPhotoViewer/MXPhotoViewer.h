//
//  MXPhotoViewer.h
//
//  Created by eric on 15/6/11.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXPhotoDetailView.h"

@interface MXPhotoViewer : UIView

typedef void (^MXPhotoViewerDetailViewSetter)(MXPhotoDetailView *dview, NSInteger index);

+ (void)showWithCount:(NSInteger)count
             cntIndex:(NSInteger)cntIndex
     detailViewSetter:(MXPhotoViewerDetailViewSetter)detailViewSetter;

@end

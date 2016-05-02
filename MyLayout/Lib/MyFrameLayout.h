//
//  MyFrameLayout.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"


@interface UIView(MyFrameLayoutExt)

/**
 *设置当子视图添加到框架布局时垂直和水平所停靠的位置。默认是左上角停靠
 */
@property(nonatomic, assign) IBInspectable MyMarginGravity marginGravity;

@end


/**
 *框架布局是一种自身具有宽度和高度的布局视图, 其中的子视图将根据设定的停靠值marginGravity来决定视图的位置和尺寸。框架布局支持wrapContentHeight和wrapContentWidth
 */
@interface MyFrameLayout : MyBaseLayout


@end


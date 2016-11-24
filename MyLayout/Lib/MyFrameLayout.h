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
@property(nonatomic, assign)  MyMarginGravity marginGravity;

@end


/**
 *框架布局是一种里面的子视图停靠在父视图特定方位并且可以重叠的布局视图。框架布局里面的子视图的布局位置和添加的顺序无关，只跟父视图建立布局约束依赖关系。
 *框架布局将垂直方向上分为上、中、下三个方位，而水平方向上则分为左、中、右三个方位，任何一个子视图都只能定位在垂直方向和水平方向上的一个方位上。
 */
@interface MyFrameLayout : MyBaseLayout


@end


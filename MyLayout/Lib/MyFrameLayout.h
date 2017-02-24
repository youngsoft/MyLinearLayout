//
//  MyFrameLayout.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"

/*
@interface UIView(MyFrameLayoutExt)

//新版本1.3.3以后的版本将不再提供框架布局对子视图的这个扩展属性的支持。
@property(nonatomic, assign)  MyMarginGravity marginGravity;
 
 1.如果您想让子视图右对齐框架布局，则只需要设置myRightMargin = 数值 和宽度即可 不再需要设置marginGravity = MyMarginGravity_Horz_Right
 2.如果您想让子视图底对齐框架布局，则只需要设置myBottomMargin = 数值 和高度即可，不再需要设置marginGravity = MyMarginGravity_Vert_Bottom
 3.如果您想让子视图在框架布局中垂直居中，则只需要设置myCenterYOffset = 数值 和高度即可，不再需要设置marginGravity = MyMarginGravity_Vert_Center
 4.如果您想让子视图在框架布局中水平居中，则只需要设置myCenterXOffset = 数值 和宽度即可，不再需要设置marginGravity = MyMarginGravity_Horz_Center
 5.如果您想让子视图在框架布局中宽度填满，则只需要设置myLeftMargin = myRightMargin = 0，不再需要设置marginGravity = MyMarginGravity_Horz_Fill
 6.如果您想让子视图在框架布局中高度填满，则只需要设置myTopMargin = myBottomMargin = 0, 不再需要设置marginGravity = MyMarginGravity_Vert_Fill
 7.如果你要水平和垂直方向都设置，则请同时设置对应位置对象的值。
 8.新版本将不再支持让框架布局中的子视图在窗口中居中了。
 
 
 请使用了marginGravity属性的代码进行对应的代码变更！！！

@end
*/

/**
 *框架布局是一种里面的子视图停靠在父视图特定方位并且可以重叠的布局视图。框架布局里面的子视图的布局位置和添加的顺序无关，只跟父视图建立布局约束依赖关系。
 *框架布局将垂直方向上分为上、中、下三个方位，而水平方向上则分为左、中、右三个方位，任何一个子视图都只能定位在垂直方向和水平方向上的一个方位上。
 */
@interface MyFrameLayout : MyBaseLayout


@end


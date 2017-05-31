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
@property(nonatomic, assign)  MyGravity marginGravity;
 
 1.如果您想让子视图右对齐框架布局，则只需要设置myRight = 数值 和宽度即可 不再需要设置marginGravity = MyGravity_Horz_Right
 2.如果您想让子视图底对齐框架布局，则只需要设置myBottom = 数值 和高度即可，不再需要设置marginGravity = MyGravity_Vert_Bottom
 3.如果您想让子视图在框架布局中垂直居中，则只需要设置myCenterY = 数值 和高度即可，不再需要设置marginGravity = MyGravity_Vert_Center
 4.如果您想让子视图在框架布局中水平居中，则只需要设置myCenterX = 数值 和宽度即可，不再需要设置marginGravity = MyGravity_Horz_Center
 5.如果您想让子视图在框架布局中宽度填满，则只需要设置myHorzMargin = 0，不再需要设置marginGravity = MyGravity_Horz_Fill
 6.如果您想让子视图在框架布局中高度填满，则只需要设置myVertMargin = 0, 不再需要设置marginGravity = MyGravity_Vert_Fill
 7.如果你要水平和垂直方向都设置，则请同时设置对应位置对象的值。
 8.新版本将不再支持让框架布局中的子视图在窗口中居中了。
 
 
 请使用了marginGravity属性的代码进行对应的代码变更！！！

@end
*/

/**
 框架布局是一种里面的子视图停靠在父视图特定方位并且可以重叠的布局视图。框架布局里面的子视图的布局位置和添加的顺序无关，框架布局中的所有子视图的约束依赖都只是针对于和父布局视图的。框架布局是一种特殊的相对布局，因此如果某些布局里面的子视图只依赖于父视图的边界时则可以用框架布局来代替，从而加快布局的速度。
 */
@interface MyFrameLayout : MyBaseLayout


@end


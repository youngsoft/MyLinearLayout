//
//  MyRelativeLayout.h
//  MyLayout
//
//  Created by oybq on 15/7/1.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"



/**
 相对布局是一种里面的子视图通过相互之间的约束和依赖来进行布局和定位的布局视图。
 相对布局里面的子视图的布局位置和添加的顺序无关，而是通过设置子视图的相对依赖关系来进行定位和布局的。
 相对布局提供了和AutoLayout相似的能力。
 */
@interface MyRelativeLayout : MyBaseLayout


/**
 *这个属性已经无效了，请使用子视图自身的扩展属性myVisibility属性来进行子视图的隐藏和显示的定制化处理。
 */
@property(nonatomic, assign)  BOOL flexOtherViewWidthWhenSubviewHidden MYMETHODDEPRECATED("this property was invalid, please use subview's myVisibility to instead");

/**
 *这个属性已经无效了，请使用子视图自身的扩展属性myVisibility属性来进行子视图的隐藏和显示的定制化处理。
 */
@property(nonatomic, assign)  BOOL flexOtherViewHeightWhenSubviewHidden MYMETHODDEPRECATED("this property was invalid, please use subview's myVisibility to instead");
;


@end

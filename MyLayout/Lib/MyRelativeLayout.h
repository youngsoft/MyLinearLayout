//
//  MyRelativeLayout.h
//  MyLayout
//
//  Created by oybq on 15/7/1.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"



/**
 *相对布局是一种里面的子视图通过相互之间的约束和依赖来进行布局和定位的布局视图。
 *相对布局里面的子视图的布局位置和添加的顺序无关，而是通过设置子视图的相对依赖关系来进行定位和布局的。
 */
@interface MyRelativeLayout : MyBaseLayout


/**
 *子视图调用widthDime.equalTo(NSArray<MyLayoutDime*>均分宽度时当有子视图隐藏时是否参与宽度计算,这个属性只有在参与均分视图的子视图隐藏时才有效,默认是NO
 */
@property(nonatomic, assign) IBInspectable BOOL flexOtherViewWidthWhenSubviewHidden;

/**
 *子视图调用heightDime.equalTo(NSArray<MyLayoutDime*>均分高度时当有子视图隐藏时是否参与高度计算,这个属性只有在参与均分视图的子视图隐藏时才有效，默认是NO
 */
@property(nonatomic, assign) IBInspectable BOOL flexOtherViewHeightWhenSubviewHidden;


@end

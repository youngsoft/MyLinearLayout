//
//  MyRelativeLayout.h
//  MyLayout
//
//  Created by oybq on 15/7/1.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"



/**
 *相对布局视图是一种里面的子视图通过设置相互依赖的约束而进行布局视图。
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

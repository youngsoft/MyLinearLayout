//
//  MyRelativeLayout.h
//  MyLayout
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyBaseLayout.h"



/*
 相对布局视图，里面的所有子视图都需要指定位置和尺寸的依赖关系
 相对布局支持wrapContentHeight,wrapContentWidth特性
 */
@interface MyRelativeLayout : MyBaseLayout


//均分宽度时当有隐藏子视图，是否参与宽度计算,这个属性只有在参与均分视图的子视图隐藏时才有效,默认是NO
@property(nonatomic, assign) IBInspectable BOOL flexOtherViewWidthWhenSubviewHidden;

//均分高度时当有隐藏子视图，是否参与高度计算,这个属性只有在参与均分视图的子视图隐藏时才有效，默认是NO
@property(nonatomic, assign) IBInspectable BOOL flexOtherViewHeightWhenSubviewHidden;


@end

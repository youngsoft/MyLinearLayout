//
//  MyFrameLayout.h
//  MyLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyBaseLayout.h"


@interface UIView(MyFrameLayoutExt)

//用于指定视图在框架布局中的停靠位置，也就是在父视图中的停靠策略,这个属性只有放在框架布局才有意义，默认值是MyMarginGravity_None表示停靠在左上角
@property(nonatomic, assign) IBInspectable MyMarginGravity marginGravity;

@end


/*
 框架布局是一种自身具有宽度和高度的布局视图,其中里面的子视图按添加的顺序层叠排列，越往后添加的子视图越排列在上面。如果要将一个视图放入框架布局中则：
 
 1.可以通过视图扩展的属性marginGravity来指定视图水平和垂直方向停靠的位置，以及可以指定视图的填充宽度和高度值。
 2.视图的中设置的myLeftMargin,myTopMargin,myRightMargin,myBottomMargin中所设定的值表示距离框架布局的各个边界的偏移值。
 3.框架布局中的子视图支持相对的边界偏移值: 0 <xxxMargin < 1时表示偏移值占整个框架尺寸的比例值。
 4.框架布局支持子视图的宽度设置等于高度，也支持高度设置等于宽度，同时支持宽度设置和父视图的比例设置，以及高度设置和父是图的比例设置。
 5.框架布局中的子视图支持通过设置frame来决定高度和宽度，但是frame不能决定位置。
 6.框架布局不支持wrapContentHeight和wrapContentWidth属性。
 */
@interface MyFrameLayout : MyBaseLayout


@end


//
//  MyFrameLayout.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutBase.h"


@interface UIView(MyFrameLayoutExt)

//用于指定视图边距的停靠位置，也就是在父视图中的停靠策略,这个属性只有放在框架布局才有意义，默认值是MGRAVITY_NONE表示停靠在左上角
@property(nonatomic, assign) MarignGravity marginGravity;

@end


/*
 框架布局是一种自身具有宽度和高度的布局视图,其中里面的子视图按添加的顺序层叠排列，越往后添加的子视图越排列在上面。如果要将一个视图放入框架布局中则：
 
 1.可以通过视图扩展的属性marginGravity来指定视图水平和垂直方向停靠的位置，以及可以指定视图的填充宽度和高度值。
 2.视图的中设置的leftMargin,topMargin,rightMargin,bottomMargin中所设定的值表示距离框架布局的各个边界的偏移值。
 3.框架布局中的子视图支持相对的边界偏移值: 0 <xxxMargin < 1时表示偏移值占整个框架尺寸的比例值。
 4.框架布局中的子视图的设置不需要使用leftPos,topPos,rightPos,bottomPos,centerXPos,centerYPos这些高级的设置方法，只需要通过leftMargin, topMargin,rightMargin,bottomMargin,centerXOffset,centerYOffset,centerXOffset,width,widthDime, height,heightDime,marginGravity这些扩展属性来设置停靠位置以及尺寸。
 5.框架布局中的子视图支持通过设置frame来决定高度和宽度，但是frame不能决定位置。
 6.框架布局不支持wrapContentHeight和wrapContentWidth属性。
 */
@interface MyFrameLayout : MyLayoutBase

@end

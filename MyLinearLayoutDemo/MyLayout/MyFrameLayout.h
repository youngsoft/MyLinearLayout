//
//  MyFrameLayout.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutBase.h"


@interface UIView(MyFrameLayoutExt)

//用于指定边距的停靠位置，也就是在父视图中的停靠策略,这个属性只有放在框架布局才有意义，默认是停靠是左上角
@property(nonatomic, assign) MarignGravity marginGravity;

@end


/*
 框架布局。框架布局中以视图marginGravity的设置为最大的优先级停靠布局，其中的top,left,right,bottom都表示离框架视图各方向的边界值
 centerX,centerY没有意义。widthDime,heightDime的设置值会优先于通过frame设置的宽度和高度值，而且widhtDime,heightDime只支持NSNumber
 型
 */
@interface MyFrameLayout : MyLayoutBase

@end

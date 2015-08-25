//
//  MyLinearLayout.h
//  MyLinearLayoutDEMO
//
//  Created by oybq on 15/2/12.
//  Copyright (c) 2015年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutBase.h"


@interface UIView(LinearLayoutExt)

//比重，指定自定的高度或者宽度在父视图的比重。取值为>=0 <=1,这个特性用于平均分配高宽度或者按比例分配高宽度
@property(nonatomic, assign) CGFloat weight;

@end


//布局排列的方向
typedef enum : NSUInteger {
    LVORIENTATION_VERT,
    LVORIENTATION_HORZ,
} LineViewOrientation;



/*
 线性布局，分为水平和垂直方向，根据添加进入的子视图的顺序依次从上到下或者从左到右分别排列布局
 */
@interface MyLinearLayout : MyLayoutBase

//方向，默认是纵向的,请在布局视图建立后立即调用这个属性设置方向,对于垂直布局系统默认设置wrapContentHeight为YES，而对于水平布局则设置wrapContentWidth为YES
@property(nonatomic,assign) LineViewOrientation orientation;


//里面的所有子视图的停靠位置，默认是MGRAVITY_NONE，表示不控制子视图的停靠，可以分别控制水平和垂直的停靠位置
@property(nonatomic, assign) MarignGravity gravity;


//均分子视图和间距,布局会根据里面的子视图的数量来平均分配子视图的高度或者宽度以及间距。
//这个函数只对已经加入布局的视图有效，函数调用后加入的子视图无效。
//centered属性描述是否所有子视图居中，当居中时顶部和底部会保留出间距，而不居中时则顶部和底部不保持间距
-(void)averageSubviews:(BOOL)centered;

//均分子视图的间距，上面函数会使子视图和间距的尺寸保持一致，而这个函数则是子视图的尺寸保持不变而间距自动平均分配。
//centered的意义同上。
-(void)averageMargin:(BOOL)centered;



@end

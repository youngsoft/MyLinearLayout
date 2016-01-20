//
//  MyFlowLayout.h
//  MyLayout
//
//  Created by apple on 15/10/31.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutBase.h"

/**
 流式布局，支持从左到右以及从上到下的垂直布局方式，和从上到下以及从左到右的水平布局方式
 流式布局和表格布局的区别是流式布局限定了布局方向的子视图排列的数量，一旦数量达到则会自动换行排列；而表格布局需要明确指定建立一个新的行，但是列的数量
 是不固定的。
 流式布局支持wrapContentHeight,wrapContentWidth,而且流式布局支持子视图的宽度依赖于高度或者高度依赖于宽度。
 **/
@interface MyFlowLayout : MyLayoutBase

//初始化一个流式布局并指定布局的方向和布局的数量
-(id)initWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount;

+(id)flowLayoutWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount;

//流式布局的方向：
//如果是MyLayoutViewOrientation_Vert则表示从左到右，从上到下的垂直布局方式，这个方式是默认方式。
//如果是MyLayoutViewOrientation_Horz则表示从上到下，从左到右的水平布局方式
@property(nonatomic,assign) MyLayoutViewOrientation orientation;


//流式布局内所有子视图的整体停靠对齐位置设定。
//如果视图方向为MyLayoutViewOrientation_Vert时且averageArrange为YES时则水平方向的对齐失效。
//如果视图方向为MyLayoutViewOrientation_Horz时且averageArrange为YES时则垂直方向的对齐失效。
@property(nonatomic,assign) MyMarginGravity gravity;


//指定方向上的子视图的数量默认是1。
//如果方向为MyLayoutViewOrientation_Vert，则表示从左到右的数量，当子视图从左往右满足这个数量后新的子视图将会换行再排列
//如果方向为MyLayoutViewOrientation_Horz，则表示从上到下的数量，当子视图从上往下满足这个数量后新的子视图将会换列再排列
@property(nonatomic, assign) NSInteger arrangedCount;

//指定是否均分布局方向上的子视图的宽度或者高度，默认是NO。
//如果是MyLayoutViewOrientation_Vert则表示每行的子视图的宽度会被均分，这样子视图不需要指定宽度，但是布局视图必须要指定一个明确的宽度值，如果设置为YES则wrapContentWidth会失效。
//如果是MyLayoutViewOrientation_Horz则表示每列的子视图的高度会被均分，这样子视图不需要指定高度，但是布局视图必须要指定一个明确的高度值，如果设置为YES则wrapContentHeight会失效。
@property(nonatomic,assign) BOOL averageArrange;


//流式布局中每排子视图的停靠对齐位置设定。
//如果是MyLayoutViewOrientation_Vert则只用于表示每行子视图的上中下停靠对齐位置，这个属性只支持MyMarginGravity_Vert_Top，MyMarginGravity_Vert_Center,MyMarginGravity_Vert_Bottom，MyMarginGravity_Vert_Fill 这里的对齐基础是以每行中的最高的子视图为基准。
//如果是MyLayoutViewOrientation_Horz则只用于表示每列子视图的左中右停靠对齐位置，这个属性只支持MyMarginGravity_Horz_Left，MyMarginGravity_Horz_Center,MyMarginGravity_Horz_Right，MyMarginGravity_Horz_Fill 这里的对齐基础是以每列中的最宽的子视图为基准。
@property(nonatomic,assign) MyMarginGravity arrangedGravity;


//子视图之间的垂直和水平的间距，默认为0。当子视图之间的间距是固定时可以通过直接设置这两个属性值来指定间距
//而不需要为每个子视图来设置margin值。
@property(nonatomic ,assign) CGFloat subviewVertMargin;
@property(nonatomic, assign) CGFloat subviewHorzMargin;



@end


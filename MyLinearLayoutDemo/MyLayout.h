//
//  MyLayout.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLayout : UIView

@property(nonatomic,assign) UIEdgeInsets padding;  //用来描述里面的子视图的离自己的边距，默认上下左右都是0
//这个是上面属性的简化设置版本。
@property(nonatomic, assign) CGFloat topPadding;
@property(nonatomic, assign) CGFloat leftPadding;
@property(nonatomic, assign) CGFloat bottomPadding;
@property(nonatomic, assign) CGFloat rightPadding;


//布局时是否调用基类的布局方法，这个属性设置的作用体现在当自身的高度或者宽度调整时而且里面的子视图又设置了autoresizingMask时
//优先进行子视图的位置和高度宽度的拉升缩放，属性默认是NO
@property(nonatomic, assign) BOOL priorAutoresizingMask;


//设置自动布局前后的处理块，主要用于动画处理，可以在这两个函数中添加动画的代码。,如果为nil
@property(nonatomic,copy) void (^beginLayoutBlock)();
@property(nonatomic,copy) void (^endLayoutBlock)();


@property(nonatomic,assign) BOOL isLayouting;

//派生类重载这个函数进行构造。
-(void)construct;

//派生类重载这个函数进行布局
-(void)doLayoutSubviews;


@end

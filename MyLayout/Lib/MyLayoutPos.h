//
//  MyLayoutPos.h
//  MyLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  视图在布局中的偏移位置对象
 */
@interface MyLayoutPos : NSObject<NSCopying>

//设置偏移量
-(MyLayoutPos* (^)(CGFloat val))offset;

//最小的偏移量。如果设置了则最小不能低于这个值。
-(MyLayoutPos* (^)(CGFloat val))min;

//最大偏移量。如果设置了则最大不能超过这个值
-(MyLayoutPos* (^)(CGFloat val))max;


/*
 val的取值可以是NSNumber,MyLayoutPos,NSArray类型的对象。
 **如果是NSNumber类型的值表示在这个方向相对父视图或者兄弟视图(线性布局)的偏移值，比如：
 v.leftPos.equalTo(@10) 表示视图v左边偏移父视图或者兄弟视图10个点的位置。
 v.centerXPos.equalTo(@10) 表示视图v的水平中心点在父视图的水平中心点并偏移10个点的位置
 v.leftPos.equalTo(@0.1) 如果值被设置为大于0小于1则只在框架布局和线性布局里面有效表示左边距的值占用父视图宽度的10%
 **如果是MyLayoutPos类型的值则表示这个方向的值是相对于另外一个视图的边界值，比如：
 v1.leftPos.equal(v2.rightPos) 表示视图v1的左边边界值等于v2的右边边界值
 **如果是NSArray类型的值则只能用在相对布局的centerXPos,centerYPos中，数组里面里面也必须是centerXPos，表示指定的视图数组在父视图中居中，比如： A.centerXPos.equalTo(@[B.centerXPos.offset(20)].offset(20)  表示A和B在父视图中居中往下偏移20，B在A的右边，间隔20。
 */
-(MyLayoutPos* (^)(id val))equalTo;


//通过如下属性获取上面的设置结果。
@property(nonatomic, assign, readonly) CGFloat offsetVal;
@property(nonatomic, assign, readonly) CGFloat minVal;
@property(nonatomic, assign, readonly) CGFloat maxVal;
@property(nonatomic, strong, readonly) id posVal;


@end

//
//  MyLayoutPos.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"

/**
 *视图的布局位置类，用于定位视图在布局视图中的位置。位置可分为水平方向的位置和垂直方向的位置，在视图定位时必要同时指定水平方向的位置和垂直方向的位置。水平方向的位置可以分为左，水平居中，右三种位置，垂直方向的位置可以分为上，垂直居中，下三种位置。
 其中的offset方法可以用来设置布局位置的偏移值,一般只在equalTo设置为MyLayoutPos或者NSArray时配合使用。比如A.leftPos.equalTo(B.rightPos).offset(5)表示A在B的右边再偏移5个点
 
 其中的min,max表示用来设置布局位置的最大最小值。比如A.leftPos.min(10).max(40)表示左边边界值最小是10最大是40。最大最小值一般和线性布局和框架布局中的子视图的位置设置为相对间距的情况下搭配着用。
 
 下面的表格描述了各种布局下的子视图的布局位置对象的equalTo方法可以设置的值。
 为了表示方便我们把：线性布局简写为L、相对布局简写为R、表格布局简写为T、框架布局简写为FR、流式布局简写为FL、浮动布局简写为FO、全部简写为ALL，不支持为-
 +----------+--------+---------------------+-------+------+--------+---------+----------+----------+
 |method\val|NSNumber|NSArray<MyLayoutPos*>|leftPos|topPos|rightPos|bottomPos|centerXPos|centerYPos|
 +----------+--------+---------------------+-------+------+--------+---------+----------+----------+
 | leftPos	| ALL    | -                   | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------------+-------+------+--------+---------+----------+----------+
 | topPos   | ALL    | -                   | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------------+-------+------+--------+---------+----------+----------+
 |rightPos	| ALL    | -                   | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------------+-------+------+--------+---------+----------+----------+
 |bottomPos	| ALL    | -                   | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------------+-------+------+--------+---------+----------+----------+
 |centerXPos| ALL    | R                   | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------------+-------+------+--------+---------+----------+----------+
 |centerYPos| ALL    | R                   | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------------+-------+------+--------+---------+----------+----------+
 
 上表中所有布局下的子视图的布局位置都支持设置为数值，而数值对于线性布局，表格布局，框架布局这三种布局来说当设置的结果>0且<1时表示的是相对的边界值
 比如一个框架布局的宽度是100，而其中的一个子视图的leftPos.equalTo(@0.1)则表示这个子视图左边距离框架布局的左边的宽度是100*0.1
 
 */
@interface MyLayoutPos : NSObject<NSCopying>


/**
 *设置视图的具体位置,这个具体位置可以取值为NSNumber,MyLayoutPos,NSArray<MyLayoutPos*>类型的对象。
 设置为NSNumber类型的值表示在这个方向相对父视图或者兄弟视图(线性布局)的偏移值，比如：
 v.leftPos.equalTo(@10) 表示视图v左边偏移父视图或者兄弟视图10个点的位置。
 v.centerXPos.equalTo(@10) 表示视图v的水平中心点在父视图的水平中心点并偏移10个点的位置
 v.leftPos.equalTo(@0.1) 如果值被设置为大于0小于1则只在框架布局和线性布局里面有效表示左边距的值占用父视图宽度的10%
 设置为MyLayoutPos类型的值则表示这个方向的值是相对于另外一个视图的边界值，比如：
 v1.leftPos.equal(v2.rightPos) 表示视图v1的左边边界值等于v2的右边边界值
 设置为NSArray<MyLayoutPos*>类型的值则只能用在相对布局的centerXPos,centerYPos中，数组里面里面也必须是centerXPos，表示指定的视图数组在父视图中居中，比如： A.centerXPos.equalTo(@[B.centerXPos.offset(20)].offset(20)  表示A和B在父视图中居中往下偏移20，B在A的右边，间隔20。
 */
-(MyLayoutPos* (^)(id val))equalTo;


/**
 *设置布局位置的偏移量, 所谓偏移量是指布局位置在设置了某种值后再增加或者减少的偏移值。比如A.leftPos.equalTo(@10).offset(5)表示A视图的左边位置等于10再偏移5,也就是最终的左边位置是15；再比如A.leftPos.equalTo(B.rightPos).offset(5)表示A视图的左边位置等于B视图的右边位置再偏移5.
 */
-(MyLayoutPos* (^)(CGFloat val))offset;

/**
 *设置布局位置的最小值。如果设置了则最小不能低于这个值。
 */
-(MyLayoutPos* (^)(CGFloat val))min;

/**
 *最大偏移量。如果设置了则最大不能超过这个值
 */
-(MyLayoutPos* (^)(CGFloat val))max;


/**
 *清除各种属性设置
 */
-(void)clear;

//通过如下属性获取上面的设置结果。
@property(nonatomic, strong, readonly) id posVal;
@property(nonatomic, assign, readonly) CGFloat offsetVal;
@property(nonatomic, assign, readonly) CGFloat minVal;
@property(nonatomic, assign, readonly) CGFloat maxVal;


@end

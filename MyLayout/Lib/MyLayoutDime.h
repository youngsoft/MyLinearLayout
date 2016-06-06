//
//  MyLayoutDime.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"

/**
 *视图的布局尺寸类，用来设置视图在布局视图中的宽度和高度的尺寸值
 */
@interface MyLayoutDime : NSObject<NSCopying>


/**
 *设置尺寸的具体值，这个具体值可以设置为NSNumber, MyLayoutDime以及NSArray<MyLayoutDime*>数组和nil值。
 设置为NSNumber值表示指定具体的宽度或者高度数值
 设置为MyLayoutDime值表示宽度和高度与设置的对象有依赖关系, 甚至可以依赖对象本身
 设置为NSArray<MyLayoutDime*>数组的概念就是所有数组里面的子视图的尺寸平分父视图的尺寸。只有相对布局里面的子视图才支持这种设置。
 设置为nil时则清除设置的具体值。
 */
-(MyLayoutDime* (^)(id val))equalTo;

/**
 *设置尺寸增加值。
 */
-(MyLayoutDime* (^)(CGFloat val))add;


/**
 * 设置尺寸的倍数
 */
-(MyLayoutDime* (^)(CGFloat val))multiply;


/**
 *设置尺寸的最小值。如果设置了则最小不能低于这个值。A.min(10) <==>  A.lBound(@10, 0, 1)。min方法是lBound方法的简化版本。
 */
-(MyLayoutDime* (^)(CGFloat val))min;
/**
 * 设置尺寸的最小边界值。min方法只能设置最小的数值，但是lBound方法除了能将最小值设置为数值外，还可以设置为MyLayoutDime值。并且还可以指定增加的偏移值和放大的偏移值。
  *@sizeVal:指定边界的值类型，方法可以支持NSNumber和MyLayoutDime类型，前者表示最小限制为某个常量值，而后者表示最小限制为某个关联的视图的布局尺寸。
  *@addVal: 指定边界值限制的增量，如果没有增量请设置为0
  *@multiVal: 指定边界值限制的倍数，如果没有倍数请设置为1
  *最终限制的尺寸为: sizeVal的真实尺寸 * multiVal + addVal
  *1.比如我们有一个UILabel的宽度是由内容决定的，但是最小的宽度不能低于B视图的宽度，则设置为：
    A.widthDime.equalTo(A.widthDime).lBound(B.widthDime, 0, 1);
  *2.比如我们有一个视图的宽度也是由内容决定的，但是最小的宽度不能低于父视图宽度的1/2，则设置为：
    A.widthDime.equalTo(A.widthDime).lBound(superview.widthDime, 0, 0.5);
  *3.比如我们有一个视图的宽度也是由内容决定的，但是最小的宽度是父视图的宽度-30，则设置为：
    A.widthDime.equalTo(A.widthDime).lBound(superview.widthDime, -30, 1);
 */
-(MyLayoutDime* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))lBound;


/**
 *设置尺寸的最大值。如果设置了则最大不能超过这个值。A.max(10) <==>  A.uBound(@10, 0, 1)。max方法是uBound方法的简化版本。
 */
-(MyLayoutDime* (^)(CGFloat val))max;
/**
 * 设置尺寸的最小边界值。min方法只能设置最小的数值，但是lBound方法除了能将最小值设置为数值外，还可以设置为MyLayoutDime值。并且还可以指定增加的偏移值和放大的偏移值。
 *@sizeVal:指定边界的值类型，方法可以支持NSNumber和MyLayoutDime类型，前者表示最小限制为某个常量值，而后者表示最小限制为某个关联的视图的布局尺寸。
 *@addVal: 指定边界值限制的增量，如果没有增量请设置为0
 *@multiVal: 指定边界值限制的倍数，如果没有倍数请设置为1
 *最终限制的尺寸为: sizeVal的真实尺寸 * multiVal + addVal
 *1.比如我们有一个UILabel的宽度是由内容决定的，但是最大的宽度不能超过父视图的宽度，则设置为：
 A.widthDime.equalTo(A.widthDime).uBound(superview.widthDime, 0, 1);
 *2.比如我们有一个视图的宽度也是由内容决定的，但是最大的宽度不能超过父视图宽度的1/2，则设置为：
 A.widthDime.equalTo(A.widthDime).uBound(superview.widthDime, 0, 0.5);
 *3.比如我们有一个视图的宽度也是由内容决定的，但是最大的宽度不能超过父视图的宽度-30，则设置为：
 A.widthDime.equalTo(A.widthDime).uBound(superview.widthDime, -30, 1);
 */
-(MyLayoutDime* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))uBound;


/**
 *清除上面的所有设置的尺寸信息
 */
-(void)clear;


//上面方法设置的属性的获取。
@property(nonatomic, strong, readonly) id dimeVal;
@property(nonatomic, assign, readonly) CGFloat addVal;
@property(nonatomic, assign, readonly) CGFloat mutilVal;
@property(nonatomic, assign, readonly) CGFloat minVal;
@property(nonatomic, assign, readonly) CGFloat maxVal;



@end

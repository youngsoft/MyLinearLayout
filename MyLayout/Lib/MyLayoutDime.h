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
 *设置尺寸的最小值。如果设置了则最小不能低于这个值。
 */
-(MyLayoutDime* (^)(CGFloat val))min;

/**
 *设置尺寸的最大值。如果设置了则最大不能超过这个值
 */
-(MyLayoutDime* (^)(CGFloat val))max;


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

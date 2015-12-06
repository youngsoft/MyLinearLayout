//
//  MyLayoutDime.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  视图在布局中的尺寸对象
 */
@interface MyLayoutDime : NSObject

//乘
-(MyLayoutDime* (^)(CGFloat val))multiply;

//加,用这个和equalTo的数组功能可以实现均分子视图宽度以及间隔的设定。
-(MyLayoutDime* (^)(CGFloat val))add;


//最小的尺寸。如果设置了则最小不能低于这个值。
-(MyLayoutDime* (^)(CGFloat val))min;

//最大的尺寸。如果设置了则最大不能超过这个值
-(MyLayoutDime* (^)(CGFloat val))max;



//NSNumber, MyLayoutDime以及MyLayoutDime数组，数组的概念就是所有数组里面的子视图的尺寸平分父视图的尺寸。
-(MyLayoutDime* (^)(id val))equalTo;


//上面方法设置的属性的获取。
@property(nonatomic, assign, readonly) CGFloat addVal;
@property(nonatomic, assign, readonly) CGFloat minVal;
@property(nonatomic, assign, readonly) CGFloat maxVal;
@property(nonatomic, assign, readonly) CGFloat mutilVal;
@property(nonatomic, strong, readonly) id dimeVal;



@end

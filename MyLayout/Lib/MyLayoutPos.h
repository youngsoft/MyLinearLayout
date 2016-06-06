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
/*
 The MyLayoutPos is the layout position object of the UIView. It is used to set the position relationship at the six directions of left, top, right, bottom, horizontal center, vertical center between the view and sibling views or Layoutview.
 
 you can use the equalTo() method of MyLayoutPos to set as below:
 1.NSNumber: the layout position is equal to a number. e.g. leftPos.equalTo (@100) indicates that the value of the left boundary is 100.
 2.MyLayoutPos: the layout position depends on aother layout position. e.g. A.leftPos.equalTo(B.rightPos) indicates that A is on the right side of B.
 3.NSArray<MyLayoutPos*>: all views in the array and View are centered. e.g. A.centerXPos.equalTo(@[B.centerXPos, C.centerXPos]) indicates that A,B,C are overall horizontal centered.
 4.nil: the layout position value is clear.
 
 you can use offset() method of MyLayoutPos to set offset of the layout position,but it is generally used together when equalTo() is set at MyLayoutPos or NSArray. e.g. A.leftPos.equalTo(B.rightPos).offset(5) indicates that A is on the right side of B and increase 5 point offset.
 
 you can use max and min method of MyLayoutPos to limit the maximum and minimum postion value. e.g. A.leftPos.min (10).Max (40) indicates that the minimum value of the left boundary is 10 and the maximum is 40. The min and max method always be used together when the subview' position of MyLinearLayout or MyFrameLayout is set at the relative position(0,1].
 
 The above table describes the value the equalTo method can be set by the of the layout location object of the subview in MyLayout.
 
 For convenience we set MyLinearLayout abbreviated as L, MyRelativeLayout abbreviated as R, MyTableLayout abbreviated as T, MyFrameLayout abbreviated as FR, MyFlowLayout abbreviated as FL, MyFloatLayout abbreviated as FO, not support set to - support all set to ALL.
 
 */


/*
 视图的布局位置类是用来描述视图与其他视图之间的位置关系的类。视图在进行定位时需要明确的指出其在父视图坐标轴上的水平位置(x轴上的位置）和垂直位置(y轴上的位置）。
 视图的水平位置可以用左、水平中、右三个方位的值来描述，垂直位置则可以用上、垂直中、下三个方位的值来描述。
 也就是说一个视图的位置需要用水平的某个方位的值以及垂直的某个方位的值来确定。一个位置的值可以是一个具体的数值，也可以依赖于另外一个视图的位置来确定。
 */
@interface MyLayoutPos : NSObject<NSCopying>


/**
 *设置布局位置的值。参数val可以接收下面四种类型的值：
 *1.NSNumber表示位置是一个具体的数值。
 *2.MyLayoutPos表示位置依赖于另外一个位置。
 *3.NSArray<MyLayoutPos*>表示位置和数组里面的其他位置整体居中。
 *4.nil表示位置的值被清除。
 */
-(MyLayoutPos* (^)(id val))equalTo;


/**
 *设置布局位置值的偏移量。 所谓偏移量是指布局位置在设置了某种值后增加或减少的偏移值。
 *比如：A.leftPos.equalTo(@10).offset(5)表示A视图的左边位置等于10再往右偏移5,也就是最终的左边位置是15。
 *比如：A.leftPos.equalTo(B.rightPos).offset(5)表示A视图的左边位置等于B视图的右边位置再往右偏移5.
 */
-(MyLayoutPos* (^)(CGFloat val))offset;

/**
 *设置布局位置的最小值。这个方法一般和相对位置值配合使用。
 */
-(MyLayoutPos* (^)(CGFloat val))min;

/**
 *设置布局位置的最大值。这个方法一般和相对位置值配合使用。
 */
-(MyLayoutPos* (^)(CGFloat val))max;


/**
 *清除上面方法设置的值
 */
-(void)clear;

//通过如下属性获取上面方法设置的值。
@property(nonatomic, strong, readonly) id posVal;
@property(nonatomic, assign, readonly) CGFloat offsetVal;
@property(nonatomic, assign, readonly) CGFloat minVal;
@property(nonatomic, assign, readonly) CGFloat maxVal;


@end

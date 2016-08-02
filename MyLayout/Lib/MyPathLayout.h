//
//  MyPathLayout.h
//  MyLayout
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"


/**
 *定义子视图在路径布局中的距离的类型。
 */
typedef enum : NSUInteger {
    MyPathSpace_Flexed,    //浮动距离
    MyPathSpace_Fixed,     //固定距离
    MyPathSpace_Count,     //固定数量距离
} MyPathSpaceType;


/**
 *路径距离类，描述子视图在路径上的距离的类型。
 */
@interface MyPathSpace : NSObject

//浮动距离，根据布局视图的尺寸和子视图的数量动态决定
+(id)flexed;

//固定距离，len为长度，每个子视图之间的距离都是len
+(id)fixed:(CGFloat)len;

//数量距离，根据布局视图的尺寸和指定的数量动态决定。
+(id)count:(NSInteger)count;


//距离类型。
@property(nonatomic, assign, readonly) MyPathSpaceType type;
//距离的值。
@property(nonatomic, assign, readonly) CGFloat value;

@end


/**
 * 坐标轴设置类，用来描述坐标轴的信息。
 */
@interface MyCoordinateSetting : NSObject


/**
 *坐标原点的位置,位置是相对位置，默认是(0,0), 假如设置为(0.5,0.5)则在视图的中间。
 */
@property(nonatomic, assign) CGPoint origin;

/**
 * 指定是否是数学坐标系，默认为NO，表示绘图坐标系。 数学坐标系y轴向上为正，向下为负；绘图坐标系则反之。
 */
@property(nonatomic, assign) BOOL isMath;

/**
 *指定是否是y轴和x轴互换，默认为NO，如果设置为YES则方程提供的变量是y轴的值，方程返回的是x轴的值。
 */
@property(nonatomic, assign) BOOL isReverse;


//开始位置和结束位置。如果不设置则根据坐标原点设置以及视图的尺寸自动确定.默认是-CGFLOAT_MAX, CGFLOAT_MAX
@property(nonatomic, assign) CGFloat start;
@property(nonatomic, assign) CGFloat end;

-(void)reset;  //恢复默认设置。

@end



/**
 *路径布局类。路径布局通过坐标轴的设置，曲线路径函数方程，子视图中心点之间的距离三个要素来确定其中子视图的位置。因此通过路径布局可以实现一些非常酷炫的布局效果。
 */
@interface MyPathLayout : MyBaseLayout


/*
  你可以从MyPathLayout中派生出一个子类。并实现如下方法：
 +(Class)layerClass
 {
    return [CAShapeLayer class];
 }
  也就是说MyPathLayout的派生类返回一个CAShapeLayer，那么系统将自动会在每次布局时将layer的path属性进行赋值操作。
 */


/**
 **下面部分是路径布局的三要素：坐标、函数、距离的定义
 **/


/**
 * 坐标系设置，您可以调整坐标系的各种参数来完成下列两个方法中的坐标到绘制的映射转换。
 */
@property(nonatomic, strong, readonly) MyCoordinateSetting *coordinateSetting;


/**
 * 直角坐标普通方程，x是坐标系里面x轴的位置，返回y = f(x)。要求函数在定义域内是连续的，否则结果不确定。如果返回的y无效则函数要返回NAN
 */
@property(nonatomic, copy) CGFloat (^rectangularEquation)(CGFloat x);


/**
 *直角坐标参数方程，t是参数， 返回CGPoint是x轴和y轴的值。要求函数在定义域内是连续的，否则结果不确定。如果返回的点无效，则请返回CGPointMake(NAN,NAN)
 */
@property(nonatomic, copy) CGPoint (^parametricEquation)(CGFloat t);

/**
 *极坐标方程，angle是极坐标的弧度，返回r半径。要求函数在定义域内是连续的，否则结果不确定。如果返回的点无效，则请返回NAN
 */
@property(nonatomic, copy) CGFloat (^polarEquation)(CGFloat angle);


/**
 *设置子视图在路径曲线上的距离的类型,一共有Flexed, Fixed, MaxCount,默认是Flexed,
 */
@property(nonatomic, strong) MyPathSpace *spaceType;


/**
 *设置和获取布局视图中的原点视图，默认是nil。如果设置了原点视图则总会将原点视图作为布局视图中的最后一个子视图。原点视图将会显示在路径的坐标原点中心上，因此原点布局是不会参与在路径中的布局的。因为中心原点视图是布局视图中的最后一个子视图，而MyPathLayout重写了AddSubview方法，因此可以正常的使用这个方法来添加子视图。
 */
@property(nonatomic, strong) UIView *originView;


/**
 *返回布局视图中所有在曲线路径中排列的子视图。如果设置了原点视图则返回subviews里面除最后一个子视图外的所有子视图，如果没有原点子视图则返回subviews
 */
@property(nonatomic, strong,readonly) NSArray *pathSubviews;


/**
 *得到子视图在曲线路径中定位时的函数的自变量的值。也就是说在函数中当值等于下面的返回值时，这个视图的位置就被确定了。方法如果返回NAN则表示这个子视图没有定位。
 */
-(CGFloat)argumentFrom:(UIView*)subview;


/**
 *下面三个函数用来获取两个子视图之间的曲线路径数据，在调用getSubviewPathPoint方法之前请先调用beginSubviewPathPoint方法，而调用完毕后请调用endSubviewPathPoint方法，否则getSubviewPathPoint返回的结果未可知。
 */

//开始和结束获取子视图路径数据的方法,full表示getSubviewPathPoint获取的是否是全部路径点。如果为NO则只会获取子视图的位置的点。
-(void)beginSubviewPathPoint:(BOOL)full;
-(void)endSubviewPathPoint;

/**
 *创建从某个子视图到另外一个子视图之间的路径点，返回NSValue数组，里面的值是CGPoint。
 *fromIndex指定开始的子视图的索引位置，toIndex指定结束的子视图的索引位置。如果有原点子视图时,这两个索引值不能算上原点子视图的索引值。
 */
-(NSArray*)getSubviewPathPoint:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

/**
 *创建布局的曲线的路径。用户需要负责销毁返回的值。调用者可以用这个方法来获得曲线的路径，进行一些绘制的工作。
 *subviewCount:指定这个路径上子视图的数量的个数，如果设置为-1则是按照布局视图的子视图的数量来创建。需要注意的是如果布局视图的spaceType为Flexed,Count的话则这个参数设置无效。
 */
-(CGPathRef)createPath:(NSInteger)subviewCount;


/**
 * 设置获取子视图距离的误差值。默认是0.5，误差越小则距离的精确值越大，误差最低值不能<=0。一般不需要调整这个值，只有那些要求精度非常高的场景才需要微调这个值,比如在一些曲线路径较短的情况下，通过调小这个值来子视图之间间距的精确计算。
 */
@property(nonatomic, assign) CGFloat distanceError;


@end

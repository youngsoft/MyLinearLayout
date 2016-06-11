//
//  MyLinearLayout.h
//  MyLayout
//
//  Created by oybq on 15/2/12.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"


@interface UIView(MyLinearLayoutExt)

/**
 *设置子视图在垂直线性布局中的高度尺寸比重值和在水平线性布局下的宽度尺寸比重值。设置的范围是 0<=weight<=1。所谓比重指的是一个相对的尺寸值，视图的真实尺寸会根据布局视图的剩余尺寸乘以这个比重值所占的比例来得到真实的尺寸。假如一个垂直线性布局的高度为100，里面有A,B,C三个子视图。其中A视图的高度为20，B视图的高度比重值为0.4，C视图的高度比重值为0.6。那么最终视图A的高度是20，而视图B的高度就是(100 - 20)*(0.4/(0.4+0.6))=32，而视图C的高度就是(100 - 20)*(0.6/(0.4+0.6))=48。可以看到通过比重值的设置我们不需要明确的指定具体的尺寸，而是根据布局视图的尺寸大小来动态的决定自己的尺寸。使用比重时需要注意的几个点：
     1.垂直线性布局必须指定明确的高度，而不能使用wrapContentHeight属性；水平线性布局必须指定明确的宽度，而不能使用wrapContentWidth属性；
     2.如果比重属性如果设置为0的话则表示视图的尺寸必须要明确的被指定，这也是默认值。
     3.线性布局里面的子视图的比重值的和不一定要求是1，比如线性布局里面两个视图的比重都设置为1和都设置为0.5以及都设置为0.1的意义是一样的，都是占用50%。
 *
 */
@property(nonatomic, assign) IBInspectable CGFloat weight;

@end



/**
 *线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单列(单行)布局视图，因此里面的子视图是通过添加的顺序建立约束和依赖关系的。 
 *子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而子视图从左到右依次排列的线性布局视图则称为水平线性布局。
 */
@interface MyLinearLayout : MyBaseLayout


/**
 *初始化一个线性布局，并指定子视图布局的方向。如果不明确指定方向则默认是建立一个垂直线性布局。建立一个垂直线性布局时默认的wrapContentHeight设置为YES，而建立一个水平线性布局时默认的wrapContentWidth设置为YES。
 */
-(id)initWithOrientation:(MyLayoutViewOrientation)orientation;
+(id)linearLayoutWithOrientation:(MyLayoutViewOrientation)orientation;

/**
 *线性布局的布局方向。
 */
@property(nonatomic,assign) IBInspectable MyLayoutViewOrientation orientation;


/**
 *线性布局里面的所有子视图的整体停靠方向以及填充，所谓停靠是指布局视图里面的所有子视图整体在布局视图中的位置，系统默认的停靠是在布局视图的左上角。
 */
@property(nonatomic, assign) IBInspectable MyMarginGravity gravity;


/**
 *设置布局视图里面子视图之间的间距。如果是垂直线性布局则设置的是垂直间距，如果是水平线性布局则设置的是水平间距。两个视图之间的最终间距等于MyLayoutPos设置的间距加上subviewMargin设置的间距的和。
 */
@property(nonatomic, assign) IBInspectable CGFloat subviewMargin;


/**
 *均分子视图和间距,布局会根据里面的子视图的数量来平均分配子视图的高度或者宽度以及间距。
 *这个函数只对已经加入布局的视图有效，函数调用后新加入的子视图无效。
 *@centered参数描述是否所有子视图居中，当居中时对于垂直线性布局来说顶部和底部会保留出间距，而不居中时则顶部和底部不保持间距
 *@sizeClass参数表示设置在指定sizeClass下进行子视图和间距的均分
 */
-(void)averageSubviews:(BOOL)centered;
-(void)averageSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass;

/**
 *均分子视图，并指定固定的边距。上面的函数会导致子视图的高度或者宽度和他们之间的间距相等，而这个函数则表示间距是一个指定的值而子视图的高度或者宽度则会被均分。
 *这个函数只对已经加入布局的视图有效，函数调用后加入的子视图无效。
 *@centered参数描述是否所有子视图居中，当居中时对于垂直线性布局来说顶部和底部会保留出间距，而不居中时则顶部和底部不保持间距
 *@sizeClass参数表示设置在指定sizeClass下进行子视图高度或者宽度的均分以及间距的指定
 */
-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin;
-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin inSizeClass:(MySizeClass)sizeClass;

/**
 *均分子视图的间距，上面函数会调整子视图的尺寸以及间距，而这个函数则是子视图的尺寸保持不变而间距自动平均分配，也就是用布局视图的剩余空间来均分间距
 *@centered参数意义同上。
 *@sizeClass参数的意义同上。
 */
-(void)averageMargin:(BOOL)centered;
-(void)averageMargin:(BOOL)centered inSizeClass:(MySizeClass)sizeClass;


@end



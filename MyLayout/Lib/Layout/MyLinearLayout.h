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
 *设置视图在线性布局父视图中的尺寸的比重。默认值是0,表示默认不使用比重。这个属性的意义根据线性布局的方向的不同而不同：
  1.当线性布局是垂直线性布局时这个属性用来设置视图高度占用父线性布局剩余高度的比重，这样视图就不需要明确的设定高度值。
  2.当线性布局是水平线性布局时这个属性用来设置视图宽度占用父线性布局剩余宽度的比重，这样视图就不需要明确的设定宽度值。
 
     视图的真实尺寸值 = 布局视图剩余尺寸 * 当前视图的weight比重/(布局视图内所有设置了weight比重值的子视图比重之和)。
 
 对一个垂直线性布局举例来说：假设布局视图的高度是100，A子视图占据了20的固定高度，B子视图的weight设置为0.4，C子视图的weight设置为0.6 那么:
    A子视图的高度 = 20
    B子视图的高度 = (100-20)*0.4/(0.4+0.6) = 32
    C子视图的高度 = (100-20)*0.6/(0.4+0.6) = 48
 

 视图使用weight属性时要注意如下几点：
  1.垂直线性布局必须指定明确的高度，而不能使用wrapContentHeight属性；水平线性布局必须指定明确的宽度，而不能使用wrapContentWidth属性、
  2.如果比重属性设置为0的话则表示视图的尺寸必须要明确的被指定，这也是默认值。
  3.线性布局里面的所有子视图的比重值的和不一定要求是1，比如线性布局里面两个视图的比重都设置为1和都设置为0.5以及都设置为0.1的意义是一样的，都是占用50%。
 *
 */
@property(nonatomic, assign) IBInspectable CGFloat weight;

@end





/**
 *线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单行(单列)布局视图。线性布局里面的子视图是通过添加的顺序建立约束和依赖关系的。
 *根据排列的方向我们把子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而把子视图从左到右依次排列的线性布局视图则称为水平线性布局。
    垂直线性布局
    +-------+
    |   A   |
    +-------+
    |   B   |
    +-------+  ⥥
    |   C   |
    +-------+
    |  ...  |
    +-------+
 
           水平线性布局
    +-----+-----+-----+-----+
    |  A  |  B  |  C  | ... |
    +-----+-----+-----+-----+
                ⥤
 */
@interface MyLinearLayout : MyBaseLayout


/**
 *初始化一个线性布局，并指定子视图布局的方向。如果不明确指定方向则默认是建立一个垂直线性布局。建立一个垂直线性布局时默认的wrapContentHeight设置为YES，而建立一个水平线性布局时默认的wrapContentWidth设置为YES。
 */
-(instancetype)initWithOrientation:(MyLayoutViewOrientation)orientation;
-(instancetype)initWithFrame:(CGRect)frame orientation:(MyLayoutViewOrientation)orientation;
+(instancetype)linearLayoutWithOrientation:(MyLayoutViewOrientation)orientation;

/**
 *线性布局的布局方向。
 */
@property(nonatomic,assign) IBInspectable MyLayoutViewOrientation orientation;


/**
 *线性布局里面的所有子视图的整体停靠方向以及填充，所谓停靠是指布局视图里面的所有子视图整体在布局视图中的位置，系统默认的停靠是在布局视图的左上角。
 *MyMarginGravity_Vert_Top,MyMarginGravity_Vert_Center,MyMarginGravity_Vert_Bottom 表示整体垂直居上，居中，居下
 *MyMarginGravity_Horz_Left,MyMarginGravity_Horz_Center,MyMarginGravity_Horz_Right 表示整体水平居左，居中，居右
 *MyMarginGravity_Vert_Between 表示在垂直线性布局里面，每行之间的行间距都被拉伸，以便使里面的子视图垂直方向填充满整个布局视图。水平线性布局里面这个设置无效。
 *MyMarginGravity_Horz_Between 表示在水平线性布局里面，每列之间的列间距都被拉伸，以便使里面的子视图水平方向填充满整个布局视图。垂直线性布局里面这个设置无效。
 *MyMarginGravity_Vert_Fill 在垂直线性布局里面表示布局会拉伸每行子视图的高度，以便使里面的子视图垂直方向填充满整个布局视图的高度；在水平线性布局里面表示每个个子视图的高度都将和父视图保持一致，这样就不再需要设置子视图的高度了。
 *MyMarginGravity_Horz_Fill 在水平线性布局里面表示布局会拉伸每行子视图的宽度，以便使里面的子视图水平方向填充满整个布局视图的宽度；在垂直线性布局里面表示每个子视图的宽度都将和父视图保持一致，这样就不再需要设置子视图的宽度了。
 */
@property(nonatomic, assign) IBInspectable MyMarginGravity gravity;


/**
 *设置布局视图里面子视图之间的间距。如果是垂直线性布局则设置的是垂直间距，如果是水平线性布局则设置的是水平间距。两个视图之间的最终间距等于MyLayoutPos设置的间距加上subviewMargin设置的间距的和。
 */
@property(nonatomic, assign) IBInspectable CGFloat subviewMargin;


/**
 * 用来设置当线性布局中的子视图的尺寸大于线性布局的尺寸时的子视图压缩策略。默认值是MySubviewsShrink_None。
 这个枚举类型定义了在线性布局里面当某个子视图的尺寸设置为weight比重值或者间距为相对间距时，并且其他剩余的子视图的尺寸和间距的总和要大于
 布局视图本身的尺寸时，对那些具有固定尺寸的子视图的处理方式。需要强调的是只有当子视图的尺寸和间距总和大于布局视图的尺寸时才有意义，否则无意义。
 比如某个垂直线性布局的高度是100。 里面分别有A,B,C,D四个子视图。其中:
 A.topPos = 10
 A.height = 50
 B.topPos = 0.1
 B.weight = 0.2
 C.height = 60
 D.topPos = 20
 D.weight = 0.7
 
 那么这时候所有具有固定尺寸和间距的子视图高度总和 = A.topPos + A.height + C.height +D.topPos = 140 > 100。
 这里面多出了40的高度值，并且B和D设置了尺寸和间距的相对值，因此满足压缩条件。那么这时候我们可以用如下压缩策略来处理所有具有固定尺寸的子视图：
 
 
 1. MySubviewsShrink_None(这是布局的默认设置属性):
 这种情况下即使是固定的视图的尺寸超出也不会进行任何压缩！！！！
 
 2. MySubviewsShrink_Average (平均压缩)
 这种情况下，我们只会压缩那些具有固定尺寸的子视图A和C的高度，每个子视图被压缩的值是：剩余的尺寸40 / 固定尺寸的子视图数量2 = 20。 这样:
 A的最终高度 = 50 - 20 = 30
 C的最终高度 = 60 - 20 = 40
 
 3.MySubviewsShrink_Weight (按比例压缩)
 这种情况下，我们只会压缩那些具有固定尺寸的子视图A和C的高度，这些固定尺寸的子视图高度总和为50 + 60 = 110. 这样：
 A的最终高度 = 50 - 40 *(50/110) = 32
 C的最终高度 = 60 - 40 *（60/110) = 38
 
 
 
 4.MySubviewsShrink_Auto (自动压缩，只对水平线性布局有效）
 假如某个水平线性布局里面里面有左右2个UILabel A和B。A和B的宽度都不确定，但是二者不能覆盖重叠，而且当间距小于一个值后要求自动换行。因为宽度都不确定所以不能为子视图指定具体的宽度值和最大最小的宽度值，但是又要利用好剩余的空间，这时候就可以用这个属性。比如下面的例子：
 
 MyLinearLayout *horzLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
 horzLayout.myLeftMargin = horzLayout.myRightMargin = 0;
 horzLayout.wrapContentHeight = YES;
 horzLayout.subviewMargin = 10;  //二者的最小间距不能小于20
 horzLayout.shrinkType = MySubviewsShrink_Auto;
 
 UILabel *A = [UILabel new];
 A.text = @"xxxxxxx";
 A.widthDime.equalTo(A.widthDime); //宽度等于自身内容的宽度，必须要这么设置和 MySubviewsShrink_Auto 结合使用。
 A.wrapContentHeight = YES;        //自动换行
 A.rightPos.equalTo(@0.5);         //右边间距是剩余的50%
 [horzLayout addSubview:A];
 
 
 UILabel *B = [UILabel new];
 B.text = @"XXXXXXXX";
 B.widthDime.equalTo(B.widthDime); //宽度等于自身内容的宽度，必须要这么设置和 MySubviewsShrink_Auto 结合使用。
 B.wrapContentHeight = YES;        //自动换行
 B.leftPos.equalTo(@0.5);         //左边间距是剩余的50%
 [horzLayout addSubview:B];
 
 
 
 */
@property(nonatomic, assign) MySubviewsShrinkType shrinkType;


/**
 *均分子视图和间距,布局会根据里面的子视图的数量来平均分配子视图的高度或者宽度以及间距。
 *这个函数只对已经加入布局的视图有效，函数调用后新加入的子视图无效。
 *@centered参数描述是否所有子视图居中，当居中时对于垂直线性布局来说顶部和底部会保留出间距，而不居中时则顶部和底部不保持间距
 *@sizeClass参数表示设置在指定sizeClass下进行子视图和间距的均分
 */
-(void)averageSubviews:(BOOL)centered;
-(void)averageSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass;

/**
 *均分子视图，并指定固定的间距。上面的函数会导致子视图的高度或者宽度和他们之间的间距相等，而这个函数则表示间距是一个指定的值而子视图的高度或者宽度则会被均分。
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



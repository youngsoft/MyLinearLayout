//
//  MyLinearLayout.h
//  MyLayout
//
//  Created by oybq on 15/2/12.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"


/**
 线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单行(单列)布局视图。线性布局里面的子视图是通过添加的顺序建立约束和依赖关系的。
 
 @note
 根据排列的方向我们把子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而把子视图从左到右依次排列的线性布局视图则称为水平线性布局。
 
 @code
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
 @endcode
 */
@interface MyLinearLayout : MyBaseLayout


/**
 初始化一个线性布局，并指定子视图排列的方向。如果不明确指定方向则默认是建立一个垂直线性布局。
 @note 建立一个垂直线性布局时默认的wrapContentHeight设置为YES，表示高度默认由所有子视图的高度决定；而建立一个水平线性布局时默认的wrapContentWidth设置为YES，表示宽度默认由所有子视图的宽度决定。
 
 @param orientation 布局视图内子视图的排列方向。
 @return 返回线性布局对象实例。
 */
+(instancetype)linearLayoutWithOrientation:(MyOrientation)orientation;
-(instancetype)initWithOrientation:(MyOrientation)orientation;
-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation;

/**
 线性布局的布局方向:
 
 1. MyOrientation_Vert 表示布局内子视图依次从上到下垂直排列。这个方向是默认方向。
 
 2. MyOrientation_Horz 表示布局内子视图依次从左到右(RTL从右到左)水平排列。
 */
@property(nonatomic,assign) IBInspectable MyOrientation orientation;






/**
 用来设置当线性布局中的所有子视图的尺寸和间距的和大于线性布局的尺寸时子视图压缩策略。默认值是MySubviewsShrink_None，表示什么不压缩子视图的尺寸和间距。
 这个属性定义了在线性布局里面当某个子视图的尺寸设置为weight比重值或者间距为相对间距时，并且其他剩余的子视图的尺寸和间距的总和要大于布局视图本身的尺寸时，对那些具有固定尺寸的子视图的处理方式。需要强调的是只有当子视图的尺寸和间距总和大于布局视图的尺寸时才有意义，否则无意义。
 
 我们定义了4种压缩策略和2种压缩内容。
 
 4种压缩策略分别是：不压缩、平均压缩多余的值、按比例压缩多余的值、自动压缩多余的值。
 
 2种压缩内容是：压缩子视图的尺寸、压缩子视图之间的间距。
 
 下面分别描述压缩策略和压缩内容的组合,比如某个垂直线性布局的高度是100。 里面分别有A,B,C,D四个子视图。其中:
 @code
 A.topPos = 10
 A.height = 50
 B.topPos = 0.1
 B.weight = 0.2
 C.height = 60
 D.topPos = 20
 D.weight = 0.7
 
 @endcode
 
 那么这时候所有具有固定尺寸和间距的子视图高度总和 = A.topPos + A.height + C.height +D.topPos = 140 > 100。
 这里面多出了40的高度值，并且B和D设置了尺寸和间距的相对值，因此满足压缩条件。那么这时候我们可以用如下压缩策略来处理所有具有固定尺寸的子视图：
 
 1. MySubviewsShrink_None | MySubviewsShrink_Size(这是布局的默认设置属性):
 
 这种情况下即使是固定的视图的尺寸超出也不会进行任何压缩！！！！
 
 2. MySubviewsShrink_Average | MySubviewsShrink_Size (平均压缩)
 这种情况下，我们只会压缩那些具有固定尺寸的子视图A和C的高度，每个子视图被压缩的值是：剩余的尺寸40 / 固定尺寸的子视图数量2 = 20。 这样:
 @code
 A的最终高度 = 50 - 20 = 30
 C的最终高度 = 60 - 20 = 40
 @endcode
 
 3. MySubviewsShrink_Weight | MySubviewsShrink_Size(按比例压缩)
 这种情况下，我们只会压缩那些具有固定尺寸的子视图A和C的高度，这些固定尺寸的子视图高度总和为50 + 60 = 110. 这样：
 @code
 A的最终高度 = 50 - 40 *(50/110) = 32
 C的最终高度 = 60 - 40 *（60/110) = 38
 @endcode
 
 4.MySubviewsShrink_Auto (自动压缩，只对水平线性布局有效）
 假如某个水平线性布局里面里面有左右2个UILabel A和B。A和B的宽度都不确定，但是二者不能覆盖重叠，而且当间距小于一个值后要求自动换行。因为宽度都不确定所以不能为子视图指定具体的宽度值和最大最小的宽度值，但是又要利用好剩余的空间，这时候就可以用这个属性。比如下面的例子：
 @code
 MyLinearLayout *horzLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
 horzLayout.myHorzMargin = 0;
 horzLayout.wrapContentHeight = YES;
 horzLayout.subviewSpace = 10;  //二者的最小间距不能小于20
 horzLayout.shrinkType = MySubviewsShrink_Auto;
 
 UILabel *A = [UILabel new];
 A.text = @"xxxxxxx";
 A.widthSize.equalTo(A.widthSize); //宽度等于自身内容的宽度，必须要这么设置和 MySubviewsShrink_Auto 结合使用。
 A.wrapContentHeight = YES;        //自动换行
 A.rightPos.equalTo(@0.5);         //右边间距是剩余的50%
 [horzLayout addSubview:A];
 
 
 UILabel *B = [UILabel new];
 B.text = @"XXXXXXXX";
 B.widthSize.equalTo(B.widthSize); //宽度等于自身内容的宽度，必须要这么设置和 MySubviewsShrink_Auto 结合使用。
 B.wrapContentHeight = YES;        //自动换行
 B.leftPos.equalTo(@0.5);         //左边间距是剩余的50%
 [horzLayout addSubview:B];
 @endcode
 
 5. MySubviewsShrink_Average | MySubviewsShrink_Space (平均压缩间距）
 这种情况下，我们只会压缩那些具有固定间距的视图:A,D的间距，每个子视图的压缩的值是：剩余的尺寸40 / 固定间距的视图的数量2 = 20。 这样：
 @code
 A的最终topPos = 10 - 20 = -10
 D的最终topPos = 20 - 20 = 0
 @endcode

 6. MySubviewsShrink_Weight | MySubviewsShrink_Space: (按比重压缩间距)
 这种情况下，我们只会压缩那些具有固定间距的视图:A,D的间距，这些总的间距为10+20 = 30. 这样：
 @code
 A的最终topPos = 10 - 40 *(10/30) = -3
 D的最终topPos = 20 - 40 *(20/30) = -7
 @endcode
 */
@property(nonatomic, assign) MySubviewsShrinkType shrinkType;


/**
 均分子视图的尺寸和间距。布局会根据里面的子视图的数量来平均分配子视图的高度或者宽度以及间距。
 
 @note 这个方法只对已经加入布局的视图有效，方法调用后新加入的子视图无效。
 
 @param centered 指定是否所有子视图居中，当居中时对于垂直线性布局来说顶部和底部会保留出间距，而不居中时则顶部和底部不留出间距。水平线性布局则是指头部和尾部。
 */
-(void)equalizeSubviews:(BOOL)centered;
-(void)equalizeSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass;



/**
 均分子视图尺寸，并指定固定的间距。上面的方法会导致子视图的高度或者宽度和他们之间的间距相等，而这个方法则指定间距为一个固定的值而子视图的高度或者宽度则会被均分。
 
 @note 这个方法只对已经加入布局的视图有效，方法调用后加入的子视图无效。
 @param centered 指定是否所有子视图居中，当居中时对于垂直线性布局来说顶部和底部会保留出间距，而不居中时则顶部和底部不留出间距。水平线性布局则是指头部和尾部
 @param space 子视图之间的间距。
 */
-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space;
-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space inSizeClass:(MySizeClass)sizeClass;



/**
 均分子视图之间的间距，上面方法会均分子视图的尺寸以及间距，而这个方法则子视图的尺寸保持不变而间距自动平均分配，也就是用布局视图的剩余空间来均分间距

 @note 这个方法只对已经加入布局的视图有效，方法调用后加入的子视图无效。

 @param centered 参数描述是否所有子视图居中，当居中时对于垂直线性布局来说顶部和底部会保留出间距，而不居中时则顶部和底部不保持间距。水平线性布局则是指头部和尾部
 */
-(void)equalizeSubviewsSpace:(BOOL)centered;
-(void)equalizeSubviewsSpace:(BOOL)centered inSizeClass:(MySizeClass)sizeClass;


@end


@interface MyLinearLayout(MyLinearLayoutDeprecated)

/**
 * 过期的方法，这些过期的方法名取名不规范，因此为了和TangramKit统一，这里将这些不规范的方法设置为过期。
 */
-(void)averageSubviews:(BOOL)centered  MYMETHODDEPRECATED("use ’equalizeSubviews:(BOOL)centered‘ to instead");
-(void)averageSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass MYMETHODDEPRECATED("use ‘equalizeSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass’ to instead");

-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin MYMETHODDEPRECATED("use ‘equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space’ to instead");
-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin inSizeClass:(MySizeClass)sizeClass MYMETHODDEPRECATED("use ‘equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space inSizeClass:(MySizeClass)sizeClass’ to instead");

-(void)averageMargin:(BOOL)centered MYMETHODDEPRECATED("use ‘equalizeSubviewsSpace:(BOOL)centered’ to instead");
-(void)averageMargin:(BOOL)centered inSizeClass:(MySizeClass)sizeClass MYMETHODDEPRECATED("use ‘equalizeSubviewsSpace:(BOOL)centered inSizeClass:(MySizeClass)sizeClass’ to instead");


@end



//
//  MyFlowLayout.h
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"


@interface UIView(MyFlowLayoutExt)

/**
 *设置视图在流式布局父视图中的尺寸的比重。默认值是0,表示默认不使用比重。这个属性的意义根据流式布局的方向和类型的不同而不同：
  1.当流式布局是垂直流式布局时这个属性用来设置视图宽度占用父流式布局当前行的剩余宽度的比重，这样视图就不需要明确的设定宽度值。
  2.当流式布局是水平流式布局时这个属性用来设置视图高度占用父流式布局当前列的剩余高度的比重，这样视图就不需要明确的设定高度值。
 
同时在数量约束和内容约束两种布局中视图设置的比重值在最终计算出真实尺寸时也是有差异的：
  1.数量约束流式布局内的视图的真实尺寸值 = 布局视图剩余尺寸 * 当前视图的weight比重/(视图所在行的所有设置了weight比重值的视图比重之和)。
  2.内容约束流式布局内的视图的真实尺寸值 = 布局视图剩余尺寸 * 当前视图的weight比重。

 
 对一个垂直数量约束流式布局举例来说：假设布局视图的宽度是100，A子视图占据了20的固定宽度，B子视图的weight设置为0.4，C子视图的weight设置为0.6 那么:
       A子视图的宽度 = 20
       B子视图的宽度 = (100-20)*0.4/(0.4+0.6) = 32
       C子视图的宽度 = (100-20)*0.6/(0.4+0.6) = 48

 对一个垂直内容约束流式布局举例来说：假设布局视图的宽度是100，A子视图占据了20的固定宽度，B子视图的weight设置为0.4，C子视图的weight设置为0.6 那么：
       A子视图的宽度 = 20
       B子视图的宽度 = (100-20)*0.4 = 32
       C子视图的宽度 = (100-20-32)*0.6 = 28.8
 
注意上面子视图的weight属性设置在数量约束流式布局里面和内容约束流式布局中的意义的差异。
 
 */
@property(nonatomic, assign) IBInspectable CGFloat weight;

@end

/**
 *流式布局是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一排再重新排列的多行多列展示的布局视图。这里的约束限制主要有数量约束限制和内容尺寸约束限制两种，排列的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些有规律排列的场景，在某种程度上可以作为UICollectionView的替代品。
 1.垂直数量约束流式布局
 orientation为MyLayoutViewOrientation_Vert,arrangedCount不为0,支持wrapContentHeight,支持wrapContentWidth,不支持autoArrange。
 
 
每排数量为3的垂直数量约束流式布局
            =>
   +------+---+-----+
   |  A   | B |  C  |
   +---+--+-+-+-----+
   | D |  E |   F   |  |
   +---+-+--+--+----+  v
   |  G  |  H  | I  |
   +-----+-----+----+

 2.垂直内容约束流式布局.
    orientation为MyLayoutViewOrientation_Vert,arrangedCount为0,支持wrapContentHeight,不支持wrapContentWidth,支持autoArrange。
 
     垂直内容约束流式布局
           =>
   +-----+-----------+
   |  A  |     B     |
   +-----+-----+-----+
   |  C  |  D  |  E  |  |
   +-----+-----+-----+  v
   |        F        |
   +-----------------+
 
 
 
 3.水平数量约束流式布局。
 orientation为MyLayoutViewOrientation_Horz,arrangedCount不为0,支持wrapContentHeight,支持wrapContentWidth,不支持autoArrange。
 
 每排数量为3的水平数量约束流式布局
            =>
    +-----+----+-----+
    |  A  | D  |     |
    |     |----|  G  |
    |-----|    |     |
 |  |  B  | E  |-----|
 V  |-----|    |     |
    |     |----|  H  |
    |  C  |    |-----|
    |     | F  |  I  |
    +-----+----+-----+

 
 
 4.水平内容约束流式布局
    orientation为MyLayoutViewOrientation_Horz,arrangedCount为0,不支持wrapContentHeight,支持wrapContentWidth,支持autoArrange。
 
 
     水平内容约束流式布局
            =>
    +-----+----+-----+
    |  A  | C  |     |
    |     |----|     |
    |-----|    |     |
 |  |     | D  |     |
 V  |     |    |  F  |
    |  B  |----|     |
    |     |    |     |
    |     | E  |     |
    +-----+----+-----+
 

 
 
 流式布局中排的概念是一个通用的称呼，对于垂直方向的流式布局来说一排就是一行，垂直流式布局每排依次从上到下排列，每排内的子视图则是由左往右依次排列；对于水平方向的流式布局来说一排就是一列，水平流式布局每排依次从左到右排列，每排内的子视图则是由上往下依次排列
 
 */
@interface MyFlowLayout : MyBaseLayout

/**
 *初始化一个流式布局并指定布局的方向和布局的数量,如果数量为0则表示内容约束流式布局
 */
-(instancetype)initWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount;
-(instancetype)initWithFrame:(CGRect)frame orientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount;
+(instancetype)flowLayoutWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount;


/**
 *流式布局的布局方向
 *如果是MyLayoutViewOrientation_Vert则表示每排先从左到右，再从上到下的垂直布局方式，这个方式是默认方式。
 *如果是MyLayoutViewOrientation_Horz则表示每排先从上到下，在从左到右的水平布局方式。
 */
@property(nonatomic,assign) IBInspectable MyLayoutViewOrientation orientation;


/**
 *流式布局内所有子视图的整体停靠对齐位置设定。
 *MyMarginGravity_Vert_Top,MyMarginGravity_Vert_Center,MyMarginGravity_Vert_Bottom 表示整体垂直居上，居中，居下
 *MyMarginGravity_Horz_Left,MyMarginGravity_Horz_Center,MyMarginGravity_Horz_Right 表示整体水平居左，居中，居右
 *MyMarginGravity_Vert_Between 表示在流式布局里面，每行之间的行间距都被拉伸，以便使里面的子视图垂直方向填充满整个布局视图。
 *MyMarginGravity_Horz_Between 表示在流式布局里面，每列之间的列间距都被拉伸，以便使里面的子视图水平方向填充满整个布局视图。
 *MyMarginGravity_Vert_Fill 在垂直流式布局里面表示布局会拉伸每行子视图的高度，以便使里面的子视图垂直方向填充满整个布局视图的高度；在水平数量流式布局里面表示每列的高度都相等并且填充满整个布局视图的高度；在水平内容约束布局里面表示布局会自动拉升每列的高度，以便垂直方向填充满布局视图的高度(这种设置方法代替过期的方法：averageArrange)。
 *MyMarginGravity_Horz_Fill 在水平流式布局里面表示布局会拉伸每行子视图的宽度，以便使里面的子视图水平方向填充满整个布局视图的宽度；在垂直数量流式布局里面表示每行的宽度都相等并且填充满整个布局视图的宽度；在垂直内容约束布局里面表示布局会自动拉升每行的宽度，以便水平方向填充满布局视图的宽度(这种设置方法代替过期的方法：averageArrange)。
 */
@property(nonatomic,assign)  MyMarginGravity gravity;


/**
 *指定方向上每排的子视图数量，默认是0表示为内容约束流式布局，当数量不为0时则是数量约束流式布局。当值为0时则表示当子视图在指定方向上的尺寸超过布局视图的尺寸时则会新起一排。而如果数量不为0时则每排内子视图数量超过这个值时就会新起一排。
 */
@property(nonatomic, assign) IBInspectable  NSInteger arrangedCount;



/**
 *为流式布局提供分页展示的能力,默认是0表不支持分页展示，当设置为非0时则要求必须是arrangedCount的整数倍数，表示每页的子视图的数量。而arrangedCount则表示每排的子视图的数量。当启用pagedCount时要求将流式布局加入到UIScrollView或者其派生类中才能生效。只有数量约束流式布局才支持分页展示的功能，pagedCount和wrapContentHeight以及wrapContentWidth配合使用能实现不同的分页展示能力:
 
 1.垂直数量约束流式布局的wrapContentHeight设置为YES时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的宽度你也可以自定义)，整体的分页滚动是从上到下滚动。(每页布局时从左到右再从上到下排列，新页往下滚动继续排列)：
     1  2  3
     4  5  6
     -------  ↓
     7  8  9
     10 11 12
 
 2.垂直数量约束流式布局的wrapContentWidth设置为YES时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的高度你也可以自定义)，整体的分页滚动是从左到右滚动。(每页布局时从左到右再从上到下排列，新页往右滚动继续排列)
     1  2  3 | 7  8  9
     4  5  6 | 10 11 12
             →
 1.水平数量约束流式布局的wrapContentWidth设置为YES时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的高度你也可以自定义)，整体的分页滚动是从左到右滚动。(每页布局时从上到下再从左到右排列，新页往右滚动继续排列)
     1  3  5 | 7  9   11
     2  4  6 | 8  10  12
             →
 
 2.水平数量约束流式布局的wrapContentHeight设置为YES时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的宽度你也可以自定义)，整体的分页滚动是从上到下滚动。(每页布局时从上到下再从左到右排列，新页往下滚动继续排列)
   
     1  3  5
     2  4  6
    --------- ↓
     7  9  11
     8  10 12
 
 */
@property(nonatomic, assign) IBInspectable NSInteger pagedCount;



/**
 *子视图自动排列,这个属性只有在内容填充约束流式布局下才有用,默认为NO.当设置为YES时则根据子视图的内容自动填充，而不是根据加入的顺序来填充，以便保证不会出现多余空隙的情况。
 *请在将所有子视图添加完毕并且初始布局完成后再设置这个属性，否则如果预先设置这个属性则在后续添加子视图时非常耗性能。
 */
@property(nonatomic,assign) IBInspectable BOOL autoArrange;


/**
 *设置流式布局中每排子视图的对齐方式。
 如果布局的方向是MyLayoutViewOrientation_Vert则表示每排子视图的上中下对齐方式，这里的对齐基础是以每排中的最高的子视图为基准。这个属性只支持：
    MyMarginGravity_Vert_Top     顶部对齐
    MyMarginGravity_Vert_Center  垂直居中对齐
    MyMarginGravity_Vert_Bottom  底部对齐
    MyMarginGravity_Vert_Fill    两端对齐
 如果布局的方向是MyLayoutViewOrientation_Horz则表示每排子视图的左中右对齐方式，这里的对齐基础是以每排中的最宽的子视图为基准。这个属性只支持：MyMarginGravity_Horz_Left    左边对齐
     MyMarginGravity_Horz_Center  水平居中对齐
     MyMarginGravity_Horz_Right   右边对齐
     MyMarginGravity_Horz_Fill    两端对齐
 */
@property(nonatomic,assign)  MyMarginGravity arrangedGravity;


/**
 *布局内所有子视图之间的垂直和水平的间距，默认为0。当每个子视图之间的间距都是一样时可以通过直接设置这三个属性值来指定间距而不需要为每个子视图来单独设置。
 */
@property(nonatomic ,assign) IBInspectable CGFloat subviewVertMargin;
@property(nonatomic, assign) IBInspectable CGFloat subviewHorzMargin;
@property(nonatomic, assign) IBInspectable CGFloat subviewMargin;  //同时设置水平和垂直间距。




/**
 *在内容约束流式布局的一些应用场景中我们有时候希望某些子视图的宽度是固定的情况下，子视图的间距是浮动的而不是固定的，这样就可以尽可能的容纳更多的子视图。比如每个子视图的宽度是固定80，那么在小屏幕下每行只能放3个，而我们希望大屏幕每行能放4个或者5个子视图。 因此您可以通过如下方法来设置浮动间距，这个方法会根据您当前布局的orientation方向不同而意义不同：
 1.如果您的布局方向是.vert表示设置的是子视图的水平间距，其中的size指定的是子视图的宽度，minSpace指定的是最小的水平间距,maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的宽度。
 2.如果您的布局方向是.horz表示设置的是子视图的垂直间距，其中的size指定的是子视图的高度，minSpace指定的是最小的垂直间距,maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的高度。
 3.如果您不想使用浮动间距则请将subviewSize设置为0就可以了。
 4.这个方法只在内容约束流式布局里面设置才有意义。
 */
-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace;
-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass;



@end


@interface MyFlowLayout(MyFlowLayoutDeprecated)

/**
 *指定是否均分布局方向上的子视图的宽度或者高度，或者拉伸子视图的尺寸，默认是NO。
 如果是MyLayoutViewOrientation_Vert则表示每行的子视图的宽度会被均分，这样子视图不需要指定宽度，但是布局视图必须要指定一个明确的宽度值，如果设置为YES则wrapContentWidth会失效。
 如果是MyLayoutViewOrientation_Horz则表示每列的子视图的高度会被均分，这样子视图不需要指定高度，但是布局视图必须要指定一个明确的高度值，如果设置为YES则wrapContentHeight会失效。
 内容填充约束流式布局下averageArrange设置为YES时表示拉伸子视图的宽度或者高度以便填充满整个布局视图。
 */
@property(nonatomic,assign)  BOOL averageArrange MYDEPRECATED("use gravity = MyMarginGravity_Horz_Fill or gravity = MyMarginGravity_Vert_Fill to instead");


@end




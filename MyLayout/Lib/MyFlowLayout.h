//
//  MyFlowLayout.h
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"



/**
 流式布局是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一排再重新排列的多行多列展示的布局视图。这里的约束限制主要有数量约束限制和内容尺寸约束限制两种，排列的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些有规律排列的场景，在某种程度上可以作为UICollectionView的替代品，同时流式布局实现了CSS3的flexbox的几乎全部功能。

 1.垂直数量约束流式布局
 orientation为MyOrientation_Vert,arrangedCount不为0,支持wrapContentHeight,支持wrapContentWidth,不支持autoArrange。
 
 @code
每排数量为3的垂直数量约束流式布局
            =>
   +------+---+-----+
   |  A   | B |  C  |
   +---+--+-+-+-----+
   | D |  E |   F   |  |
   +---+-+--+--+----+  v
   |  G  |  H  | I  |
   +-----+-----+----+

 @endcode
 
 2.垂直内容约束流式布局.
    orientation为MyOrientation_Vert,arrangedCount为0,支持wrapContentHeight,不支持wrapContentWidth,支持autoArrange。
 @code
     垂直内容约束流式布局
           =>
   +-----+-----------+
   |  A  |     B     |
   +-----+-----+-----+
   |  C  |  D  |  E  |  |
   +-----+-----+-----+  v
   |        F        |
   +-----------------+
 
 @endcode
 
 3.水平数量约束流式布局。
 orientation为MyOrientation_Horz,arrangedCount不为0,支持wrapContentHeight,支持wrapContentWidth,不支持autoArrange。
 
 @code
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

 @endcode
 
 4.水平内容约束流式布局
    orientation为MyOrientation_Horz,arrangedCount为0,不支持wrapContentHeight,支持wrapContentWidth,支持autoArrange。
 
 @code
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
 
@endcode
 
 @note
 流式布局中排的概念是一个通用的称呼，对于垂直方向的流式布局来说一排就是一行，垂直流式布局每排依次从上到下排列，每排内的子视图则是由左往右依次排列；对于水平方向的流式布局来说一排就是一列，水平流式布局每排依次从左到右排列，每排内的子视图则是由上往下依次排列
 
 */
@interface MyFlowLayout : MyBaseLayout

/**
 初始化一个流式布局并指定布局的方向和布局的数量,如果数量为0则表示内容约束流式布局。
 
 @param orientation 布局的方向，这个方向是指的排与排之间排列方向，而不是排内的子视图的排列方向。
 @param arrangedCount 每排内的子视图的数量，如果每排内的子视图的数量不固定则设置为0表示为内容约束流式布局。
 @return 返回流式布局对象实例。
 */
-(instancetype)initWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount;

/**
 初始化一个流式布局并指定布局视图的frame值以及方向和布局的数量,如果数量为0则表示内容约束流式布局。

 @param frame 布局视图的frame值，当布局视图的父视图是非布局视图时就可以用这个方法来初始化视图的frame。
 @param orientation 布局的方向，这个方向是指的排与排之间排列方向，而不是排内的子视图的排列方向。
 @param arrangedCount 每排内的子视图的数量，如果每排内的子视图的数量不固定则设置为0表示为内容约束流式布局。
 @return 返回流式布局对象实例
 */
-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount;


/**
 初始化一个流式布局并指定布局的方向和布局的数量,如果数量为0则表示内容约束流式布局。

 @param orientation 布局的方向，这个方向是指的排与排之间排列方向，而不是排内的子视图的排列方向。
 @param arrangedCount 每排内的子视图的数量，如果每排内的子视图的数量不固定则设置为0表示为内容约束流式布局。
 @return 返回流式布局对象实例。
 */
+(instancetype)flowLayoutWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount;


/**
 流式布局的布局方向:
 
 1. MyOrientation_Vert 表示排内子视图从左到右(RTL从右到左)水平排列，排与排之间依次从上到下垂直排列。这个方向是默认方向。
 
 2. MyOrientation_Horz 表示排内子视图从上到下垂直排列，排与排之间依次从左到右(RTL从右到左)水平排列。
 */
@property(nonatomic,assign) IBInspectable MyOrientation orientation;



/**
 每排内的子视图数量。默认是0表示每排内的子视图的数量不固定，而是根据子视图的尺寸自动换行或者换列处理。如果非0则每排内的子视图数量等于这个值后会自动换行或者换列
 */
@property(nonatomic, assign) IBInspectable  NSInteger arrangedCount;



/**
 为流式布局提供分页展示的能力,默认是0表不支持分页展示。当设置为非0时则要求必须是arrangedCount的整数倍数，表示每页的子视图的数量。而arrangedCount则表示每排内的子视图的数量。当启用pagedCount时要求将流式布局加入到UIScrollView或者其派生类中才能生效。只有数量约束流式布局才支持分页展示的功能，通过pagedCount和wrapContentHeight以及wrapContentWidth配合使用能实现不同的分页展示能力:
 @note
 1. 垂直数量约束流式布局的wrapContentHeight设置为YES时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的宽度你也可以自定义)，整体的分页滚动是从上到下滚动。(每页布局时从左到右再从上到下排列，新页往下滚动继续排列)：
 @code
     1  2  3
     4  5  6
     -------  ↓
     7  8  9
     10 11 12
 @endcode 
 
 2. 垂直数量约束流式布局的wrapContentWidth设置为YES时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的高度你也可以自定义)，整体的分页滚动是从左到右滚动。(每页布局时从左到右再从上到下排列，新页往右滚动继续排列)
 @code
     1  2  3 | 7  8  9
     4  5  6 | 10 11 12
             →
 @endcode
 
 3. 水平数量约束流式布局的wrapContentWidth设置为YES时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的高度你也可以自定义)，整体的分页滚动是从左到右滚动。(每页布局时从上到下再从左到右排列，新页往右滚动继续排列)
 @code
     1  3  5 | 7  9   11
     2  4  6 | 8  10  12
             →
 @endcode
 
 4. 水平数量约束流式布局的wrapContentHeight设置为YES时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的宽度你也可以自定义)，整体的分页滚动是从上到下滚动。(每页布局时从上到下再从左到右排列，新页往下滚动继续排列)
  @code
     1  3  5
     2  4  6
    --------- ↓
     7  9  11
     8  10 12
 @endcode
 */
@property(nonatomic, assign) IBInspectable NSInteger pagedCount;



/**
 布局内子视图自动排列。这个属性只有在内容填充约束流式布局下才有用，默认为NO。当设置为YES时则根据子视图的尺寸自动填充，而不是根据加入的顺序来填充，以便保证不会出现多余空隙的情况。
 
 @note
 请在将所有子视图添加完毕并且初始布局完成后再设置这个属性，否则如果预先设置这个属性则在后续添加子视图时可能会非常耗性能。
 */
@property(nonatomic,assign) IBInspectable BOOL autoArrange;


/**
 *设置流式布局中每排内所有子视图的对齐停靠方式。具体的对齐停靠方式依赖于布局视图的方向：
 
 1. 如果是垂直流式布局则表示每排内子视图的上中下对齐方式，这里的对齐基础是以每排中的最高的子视图为基准。这个属性只支持：
   @code
    MyGravity_Vert_Top     顶部对齐
    MyGravity_Vert_Center  垂直居中对齐
    MyGravity_Vert_Bottom  底部对齐
    MyGravity_Vert_Fill    两端对齐
  @endcode
 2. 如果是水平流式布局则表示每排内子视图的左中右对齐方式，这里的对齐基础是以每排中的最宽的子视图为基准。这个属性只支持：
    @code
     MyGravity_Horz_Left    左边对齐
     MyGravity_Horz_Center  水平居中对齐
     MyGravity_Horz_Right   右边对齐
     MyGravity_Horz_Fill    两端对齐
   @endcode
 @note 如果您想单独设置某个子视图在排内的对齐方式则请使用子视图的扩展属性myAlignment。
 
 */
@property(nonatomic,assign)  MyGravity arrangedGravity;




/**
 在内容约束流式布局的一些应用场景中我们希望子视图的宽度是固定的但间距是浮动的，这样就尽可能在一排中容纳更多的子视图。比如设置每个子视图的宽度固定为80，那么在小屏幕下每排只能放3个，而大屏幕则每排能放4个或者5个子视图。 因此您可以通过如下方法来设置子视图的固定尺寸和最小最大浮动间距。这个方法会根据您当前布局的方向不同而具有不同的意义：
 
 1.如果您的布局方向是垂直的则设置的是每排内子视图的水平浮动间距，其中的subviewSize指定的是子视图的固定宽度；minSpace指定的是最小的水平间距；maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于最大间距maxSpace则会缩小subviewSize的宽度值。
 
 2.如果您的布局方向是水平的则设置的是每排内子视图的垂直浮动间距，其中的subviewSize指定的是子视图的固定高度；minSpace指定的是最小的垂直间距；maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于最大间距maxSpace则会调整subviewSize的高度值。
 
 @note 如果您不想使用浮动间距则请将subviewSize设置为0就可以了。这个方法只在内容约束流式布局里面设置才有意义。
 
 @param subviewSize 指定子视图的尺寸。
 @param minSpace 指定子视图之间的最小间距
 @param maxSpace 指定子视图之间的最大间距
 */
-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace;
-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass;


@end


@interface MyFlowLayout(MyFlowLayoutDeprecated)

/**
 指定是否均分布局方向上的子视图的宽度或者高度，或者拉伸子视图的尺寸，默认是NO。
 如果是MyOrientation_Vert则表示每行的子视图的宽度会被均分，这样子视图不需要指定宽度，但是布局视图必须要指定一个明确的宽度值，如果设置为YES则wrapContentWidth会失效。
 如果是MyOrientation_Horz则表示每列的子视图的高度会被均分，这样子视图不需要指定高度，但是布局视图必须要指定一个明确的高度值，如果设置为YES则wrapContentHeight会失效。
 内容填充约束流式布局下averageArrange设置为YES时表示拉伸子视图的宽度或者高度以便填充满整个布局视图。
 */
@property(nonatomic,assign)  BOOL averageArrange MYMETHODDEPRECATED("use gravity = MyGravity_Horz_Fill or gravity = MyGravity_Vert_Fill to instead");


@end




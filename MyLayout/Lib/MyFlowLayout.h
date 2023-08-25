//
//  MyFlowLayout.h
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"

/**
 流式布局是一种条目按照添加的顺序依次排列，当满足某种规则后会另起一排再重新排列，最终呈现为多行多列展示的布局形态。
 这里的换排规则主要有数量限制和尺寸限制两种，整体排列方向又分为垂直和水平两个方向，因此流式布局一共有垂直数量限制、垂直尺寸限制、水平数量限制、水平尺寸限制四种布局。流式布局主要应用于那些有规律排列的场景，在某种程度上可以作为UICollectionView的替代品，同时流式布局实现了CSS3的flexbox的几乎全部功能。
 
 @note
   需要注意的是这里的方向和排的概念，排的概念它是相对于流式布局的方向而具体定义的：如果是垂直流式布局那么一排内的子视图将是水平排列，而整体则是每排从上往下垂直排列；如果是水平流式布局那么一排内的子视图将是垂直排列，而整体则是每排从左往右水平排列。因此流式布局的方向所描述的是排整体的排列方向。

 @note
   所谓数量限制流式布局是指事先约定每排的条目视图的数量，当一排的条目视图数量超过约定的数量后新添加的条目视图就会换按约定的方向新起一排重新排列；而尺寸限制流式布局就是当一排内添加到布局中的条目视图的宽度(垂直流式布局)之和或者高度(水平流式布局)之和超过布局视图的宽度或者高度时新添加条目视图就会按约定的方向新起一排重新排列。
 
 1.垂直数量限制流式布局
 orientation为MyOrientation_Vert,arrangedCount不为0
 
 @code
  每排数量为3的垂直数量限制流式布局
            =>
   +------+---+-----+
   |  A   | B |  C  |
   +---+--+-+-+-----+
   | D |  E |   F   |  |
   +---+-+--+--+----+  v
   |  G  |  H  | I  |
   +-----+-----+----+

 @endcode
 
 2.垂直尺寸限制流式布局.
    orientation为MyOrientation_Vert,arrangedCount为0
 @code
     垂直尺寸限制流式布局
           =>
   +-----+-----------+
   |  A  |     B     |
   +-----+-----+-----+
   |  C  |  D  |  E  |  |
   +-----+-----+-----+  v
   |        F        |
   +-----------------+
 
 @endcode
 
 3.水平数量限制流式布局。
 orientation为MyOrientation_Horz,arrangedCount不为0
 
 @code
 每排数量为3的水平数量限制流式布局
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
 
 4.水平尺寸限制流式布局
    orientation为MyOrientation_Horz,arrangedCount为0
 
 @code
     水平尺寸限制流式布局
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
 
 */
@interface MyFlowLayout : MyBaseLayout

/**
 初始化一个流式布局并指定布局的方向和每排条目视图的数量,如果数量为0则表示尺寸限制流式布局。
 
 @param orientation 布局的方向，这个方向是指的排与排之间排列方向，而不是排内的子视图的排列方向。
 @param arrangedCount 每排内的子条目视图的数量，如果每排内的子条目视图的数量不固定则设置为0表示为尺寸限制流式布局。
 @return 返回流式布局对象实例。
 */
- (instancetype)initWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount;
/**
 初始化一个流式布局并指定布局视图的frame值以及方向和每排条目视图的数量,如果数量为0则表示尺寸限制流式布局。

 @param frame 布局视图的frame值，当布局视图的父视图是非布局视图时就可以用这个方法来初始化视图的frame。
 @param orientation 布局的方向，这个方向是指的排与排之间排列方向，而不是排内的子视图的排列方向。
 @param arrangedCount 每排内的子条目视图的数量，如果每排内的子条目视图的数量不固定则设置为0表示为尺寸限制流式布局。
 @return 返回流式布局对象实例
 */
- (instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount;
/**
 初始化一个流式布局并指定布局的方向和排内条目视图的数量,如果数量为0则表示尺寸限制流式布局。

 @param orientation 布局的方向，这个方向是指的排与排之间排列方向，而不是排内的子视图的排列方向。
 @param arrangedCount 每排内的子条目视图的数量，如果每排内的子视图的数量不固定则设置为0表示为尺寸限制流式布局。
 @return 返回流式布局对象实例。
 */
+ (instancetype)flowLayoutWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount;

/**
 流式布局的布局方向:
 
 1. MyOrientation_Vert 表示排内子视图从左到右(RTL从右到左)水平排列，排与排之间依次从上到下垂直排列。这个方向是默认方向。
 
 2. MyOrientation_Horz 表示排内子视图从上到下垂直排列，排与排之间依次从左到右(RTL从右到左)水平排列。
 */
@property (nonatomic, assign) MyOrientation orientation;

/**
 每排内的子条目视图数量。默认是0表示每排内的子条目视图的数量不固定，而是根据子视图的尺寸自动换行或者换列处理。如果非0则每排内的子视图数量等于这个值后会自动换排。
 */
@property (nonatomic, assign) NSInteger arrangedCount;

/**
 为流式布局提供分页展示的能力,默认是0表不支持分页展示。当设置为非0时则要求必须是arrangedCount的整数倍数，表示每页的子视图的数量。而arrangedCount则表示每排内的子视图的数量。当启用pagedCount时如果流式布局的父视图是UIScrollView或者其派生类就会有分页滚动的效果。只有数量限制流式布局才支持分页展示的功能，通过pagedCount和设置尺寸的高度或者宽度自适应配合使用能实现不同的分页展示能力:
 @note
 1. 垂直数量限制流式布局的高度设置为自适应时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的宽度你也可以自定义)，整体的分页滚动是从上到下滚动。(每页布局时从左到右再从上到下排列，新页往下滚动继续排列)：
 @code
     1  2  3
     4  5  6
     -------  ↓
     7  8  9
     10 11 12
 @endcode 
 
 2. 垂直数量限制流式布局的宽度设置为自适应时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的高度你也可以自定义)，整体的分页滚动是从左到右滚动。(每页布局时从左到右再从上到下排列，新页往右滚动继续排列)
 @code
     1  2  3 | 7  8  9
     4  5  6 | 10 11 12
             →
 @endcode
 
 3. 水平数量限制流式布局的宽度设置为自适应时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的高度你也可以自定义)，整体的分页滚动是从左到右滚动。(每页布局时从上到下再从左到右排列，新页往右滚动继续排列)
 @code
     1  3  5 | 7  9   11
     2  4  6 | 8  10  12
             →
 @endcode
 
 4. 水平数量限制流式布局的高度设置为自适应时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的宽度你也可以自定义)，整体的分页滚动是从上到下滚动。(每页布局时从上到下再从左到右排列，新页往下滚动继续排列)
  @code
     1  3  5
     2  4  6
    --------- ↓
     7  9  11
     8  10 12
 @endcode
 */
@property (nonatomic, assign) NSInteger pagedCount;

/**
 布局内子视图自动排列或者让布局内的子视图的排列尽可能的紧凑，默认为NO。
 
 当流式布局是尺寸限制流式布局时，则当设置为YES时则根据子视图的尺寸自动填充，而不是根据加入的顺序来填充，以便保证不会出现多余空隙的情况。
 当流式布局是数量限制流式布局时，则当设置为YES时每个子视图会按顺序找一个最佳的存放地点进行填充。
 
 @note
 如果在尺寸限制流式布局中使用此属性时，请在将所有子视图添加完毕并且初始布局完成后再设置这个属性，否则如果预先设置这个属性则在后续添加子视图时可能会非常耗性能。
 */
@property (nonatomic, assign) BOOL autoArrange;

/**
 布局是否是兼容flexbox规则的布局，默认是NO。当设置为YES时有两个特性会产生差异：
 1.停靠属性gravity在所有排中都有效。在一些场景中，往往最后一排的子视图个数并没有填充满布局视图，如果这时候设置了gravity时产生的效果并不美观。
 所以默认情况下最后一排的子视图并不会受到gravity设置的影响，但是特殊情况除外：1.只有一排时，2.最后一排的数量和其他排的数量一样时 这两种情况gravity会影响所有子视图。 因此当isFlex为YES时则所有行和列都会受到gravity属性的影响。
 
 2.子视图的weight属性可以和子视图的尺寸约束共存。默认情况下在垂直流式布局中如果子视图设置了weight属性则子视图的宽度约束将不起作用，
    而在水平流式布局中如果子视图设置了weight属性则子视图的高度约束将不起作用。另外在流式尺寸限制布局中weight表示的是剩余空间的比重。
    因此当isFlex设置为YES时，表示子视图的weight可以和尺寸约束共存，并且weight就是表示排内的剩余空间的比重。
 */
@property (nonatomic, assign) BOOL isFlex;

/**
 设置流式布局中每排内所有子视图的对齐停靠方式。具体的对齐停靠方式依赖于布局视图的方向：
 
 1. 如果是垂直流式布局则表示每排内子视图的上中下对齐方式，这里的对齐基础是以每排中的最高的子视图为基准。这个属性只支持：
   @code
    MyGravity_Vert_Top     顶部对齐
    MyGravity_Vert_Center  垂直居中对齐
    MyGravity_Vert_Bottom  底部对齐
    MyGravity_Vert_Fill    两端对齐
    MyGravity_Vert_Stretch 如果子视图未设置约束或者非布局子视图高度自适应则子视图高度被拉伸
    MyGravity_Vert_Baseline 基线对齐，以每一行的第一个带有文字的视图作为基线进行对齐。
    MyGravity_Vert_Between  数量限制垂直流式布局有效，子视图会紧凑进行排列,当设置为这个属性值时，子视图的y轴的位置总是从对应列的上一行的结尾开始，而不是上一行的最高位置开始。
    MyGravity_Vert_Around 如果行内子视图没有设置高度约束，则子视图的高度填充整行，否则按子视图的高度是高度约束决定。
  @endcode
 2. 如果是水平流式布局则表示每排内子视图的左中右对齐方式，这里的对齐基础是以每排中的最宽的子视图为基准。这个属性只支持：
    @code
     MyGravity_Horz_Left    左边对齐
     MyGravity_Horz_Center  水平居中对齐
     MyGravity_Horz_Right   右边对齐
     MyGravity_Horz_Fill    两端对齐
     MyGravity_Horz_Stretch 如果子视图未设置约束或者非布局子视图宽度自适应则子视图宽度被拉伸
     MyGravity_Horz_Between  数量限制水平流式布局有效，子视图会紧凑进行排列，当设置为这个属性值时，子视图的x轴的位置总是从对应行的上一列的结尾开始，而不是上一列的最宽位置开始。
     MyGravity_Horz_Around 如果列内子视图没有设置宽度约束，则子视图的宽度填充整行，否则按子视图的宽度是宽度约束决定。
   @endcode
 @note
 如果您想单独设置某个子视图在行内的对齐方式则请使用子视图的扩展属性alignment。
 
 */
@property (nonatomic, assign) MyGravity arrangedGravity;

/**
指定流式布局最后一排的尺寸或间距的拉伸策略。默认值是MyGravityPolicy_No表示最后一排的尺寸或间接拉伸策略不生效。
在流式布局中我们可以通过gravity属性来对每一排的尺寸或间距进行拉伸处理。但是在实际情况中最后一排的子视图数量可能会小于等于前面排的数量。
在这种情况下如果对最后一排进行相同的尺寸或间距的拉伸处理则有可能会影响整体的布局效果。因此我们可通过这个属性来指定最后一排的尺寸或间距的生效策略。
这个策略在不同的流式布局中效果不一样：

1.在数量限制布局中如果最后一排的子视图数量小于arrangedCount的值时，那么当我们使用gravity来对行内视图进间距拉伸时(between,around,among)
可以指定三种策略：no表示最后一排不进行任何间距拉伸处理，always表示最后一排总是进行间距拉伸处理，auto表示最后一排的每个子视图都和上一排对应位置视图左对齐。

2.在尺寸限制布局中因为每排的子视图数量不固定,所以只有no和always两种策略有效，并且这两种策略不仅影响子视图的尺寸的拉伸(fill,stretch)还影响间距的拉伸效果(between,around,among)。
 */
@property (nonatomic, assign) MyGravityPolicy lastlineGravityPolicy;

/**
 单独为某一排定制的水平和垂直停靠对齐属性，默认情况下布局视图的gravity和arrangedGravity作用于所有排以及排内的停靠对齐。如果你想单独定制某一排的停靠对齐方式时
 可以通过设置这个block属性。
 lineGravity的入参分别是布局对象、当前排的索引(0开始)、当前排的条目视图数量、是否是最后一排四个参数。
 函数返回的是此排以及排内的停靠对齐方式，如果返回MyGravity_None则表示使用布局默认的gravity和arrangedGravity停靠对齐属性。
 */
@property (nonatomic, copy) MyGravity (^lineGravity)(MyFlowLayout *layout, NSInteger lineIndex, NSInteger itemCount, BOOL isLastLine);

/**
 在流式布局的一些应用场景中我们希望子视图的宽度或者高度是固定的但间距是浮动的，这样就尽可能在一排中容纳更多的子视图。比如设置每个子视图的宽度固定为80，那么在小屏幕下每排只能放3个，而大屏幕则每排能放4个或者5个子视图。 因此您可以通过如下方法来设置子视图的固定尺寸和最小最大浮动间距。这个方法会根据您当前布局的方向不同而具有不同的意义：
 
 1.如果您的布局方向是垂直的则设置的是每排内子视图的水平浮动间距，其中的subviewSize指定的是子视图的固定宽度；minSpace指定的是最小的水平间距；maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于最大间距maxSpace则会缩小subviewSize的宽度值。
 
 2.如果您的布局方向是水平的则设置的是每排内子视图的垂直浮动间距，其中的subviewSize指定的是子视图的固定高度；minSpace指定的是最小的垂直间距；maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于最大间距maxSpace则会调整subviewSize的高度值。
 
 @note 如果您不想使用浮动间距则请将subviewSize设置为0就可以了。
 
 @note 对于数量限制流式布局来说，因为每排和每列的数量的固定的，因此不存在根据屏幕的大小自动换排的能力以及进行最佳数量的排列，但是可以使用这个方法来实现所有子视图尺寸固定但是间距是浮动的功能需求。
 
 @param subviewSize 指定子视图的尺寸。
 @param minSpace 指定子视图之间的最小间距
 @param maxSpace 指定子视图之间的最大间距
 */
- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace;
- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass;

/**
 上面函数的加强版本。

 @param subviewSize 指定子视图的尺寸
 @param minSpace 指定子视图之间的最小间距
 @param maxSpace 指定子视图之间的最大间距
 @param centered 指定是否所有子视图居中
 */
- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered;
- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered inSizeClass:(MySizeClass)sizeClass;

@end

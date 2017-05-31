//
//  MyFloatLayout.h
//  MyLayout
//
//  Created by oybq on 16/2/18.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"



@interface UIView(MyFloatLayoutExt)

/**
 是否反方向浮动，默认是NO表示正向浮动。正向浮动和反向浮动的意义根据所在的父浮动布局视图的方向的不同而不同：
 
    1. 如果父视图是垂直浮动布局则默认正向浮动是向左浮动的，而反向浮动则是向右浮动。
 
 @code
 下面是垂直浮动布局中的正向浮动和反向浮动的效果图(正向浮动:A,B,D; 反向浮动:C,E,F)：
 
 |<--A-- <---B---    -C->|
 |<-----D---- -F-> --E-->|
 @endcode
 
    2. 如果父视图是水平浮动布局则默认正向浮动是向上浮动的，而反向浮动则是向下浮动。
 
 @code
 下面是水平浮动布局中的正向浮动和反向浮动的效果图(正向浮动:A,B,D; 反向浮动:C,E,F):
 
  -----------
   ↑   ↑
   |   |
   A   |
   |   D
       |
   ↑   |
   B
   |   F
       ↓
   |   |
   C   E
   ↓   ↓
  ------------
 @endcode
 
 @note 这个属性的定义是完全参考CSS样式表中float属性的定义
 */
@property(nonatomic,assign,getter=isReverseFloat) IBInspectable BOOL reverseFloat;


/**
 清除浮动，默认是NO。这个属性的意义也跟父浮动布局视图的方向相关。如果设置为了清除浮动属性则表示本子视图不会在浮动方向上紧跟在前一个浮动子视图的后面，而是会另外新起一行或者一列来重新排列。
 
 @code
 垂直浮动布局下的浮动和清除浮动
 
 |<--A-- <---B--- <-C--|
 |<----D---            |
 |<--E-- <---F--       |
 |<-----G----          |
 |      ---I---> --H-->|
 |                -J-> |
 
 A(正向浮动);B(正向浮动);C(正向浮动);D(正向浮动);E(正向浮动);F(正向浮动);G(正向浮动，清除浮动);H(反向浮动);I(反向浮动);J(反向浮动，清除浮动)
 @endcode
 
 @note 这个属性的定义是完全参考CSS样式表中clear属性的定义。
 
 */
@property(nonatomic,assign) IBInspectable BOOL clearFloat;

@end



/**
 浮动布局是一种里面的子视图按照约定的方向浮动停靠，当浮动布局的剩余空间不足容纳要加入的子视图的尺寸时会自动寻找最佳的位置进行浮动停靠的布局视图。浮动布局的理念源于HTML/CSS中的浮动定位技术,因此浮动布局可以专门用来实现那些不规则布局或者图文环绕的布局。
 
 @note
 根据浮动的方向不同，浮动布局可以分为左右浮动布局和上下浮动布局。我们称左右浮动的浮动布局为垂直浮动布局，因为左右浮动时最终整个方向是从上到下的；称上下浮动的浮动布局为水平浮动布局，因为上下浮动时最终整个方向是从左到右的。
 */
@interface MyFloatLayout : MyBaseLayout


/**
 初始化一个浮动布局并指定布局的方向。当方向设置为MyOrientation_Vert时表示为左右浮动布局视图，而设置为MyOrientation_Horz则表示为上下浮动布局视图。
 
 @param orientation 指定浮动布局的方向，要注意的这个方向是整体排列的方向。
 @return 返回浮动布局的实例对象。
 */
+(instancetype)floatLayoutWithOrientation:(MyOrientation)orientation;
-(instancetype)initWithOrientation:(MyOrientation)orientation;
-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation;

/**
  浮动布局的方向。
 
 1.MyOrientation_Vert 表示里面的子视图可以进行左右的浮动，但整体从上到下进行排列的布局方式，这个方式是默认方式。

 2.MyOrientation_Horz 表示里面的子视图可以进行上下的浮动，但整体从左到右进行排列的布局方式，这个方式是默认方式。
 */
@property(nonatomic,assign) IBInspectable MyOrientation orientation;




/**
 不做布局边界尺寸的限制，子视图不会自动换行。因此当设置为YES时，子视图需要明确设置clearFloat来实现主动换行的处理。默认为NO。这个属性设置的意义使得我们可以自定义子视图的换行，而不是让子视图根据布局视图的尺寸限制自动换行。
 
 1. 当布局的orientation为MyOrientation_Vert并且wrapContentWidth为YES时,这个属性设置为YES才生效。
 
 2. 当布局的orientation为MyOrientation_Horz并且wrapContentHeight为YES时，这个属性设置为YES才生效。
 
 @note 当属性设置为YES时，子视图不能将扩展属性reverseFloat设置为YES，同时不能设置weight属性，否则将导致结果异常。
 @note 这个属性设置为YES时，在左右浮动布局中，子视图只能向左浮动，并且没有右边界的限制，因此如果子视图没有clearFloat时则总是排列在前一个子视图的右边，并不会自动换行,因此为了让这个属性生效，布局视图必须要同时设置wrapContentWidth为YES。
 @note 这个属性设置为YES时，在上下浮动布局中，子视图只能向上浮动，并且没有下边界的限制，因此如果子视图没有设置clearFloat时则总是排列在前一个子视图的下边，并不会自动换行，因此为了让这个属性生效，布局视图必须要同时设置wrapContentHeight为YES.
 */
@property(nonatomic,assign) IBInspectable BOOL noBoundaryLimit;

/**
 在一些应用场景中我们希望子视图的宽度是固定的但间距是浮动的，这样就尽可能在一排中容纳更多的子视图。比如设置每个子视图的宽度固定为80，那么在小屏幕下每排只能放3个，而大屏幕则每排能放4个或者5个子视图。 因此您可以通过如下方法来设置子视图的固定尺寸和最小最大浮动间距。这个方法会根据您当前布局的方向不同而具有不同的意义：
 
 1.如果您的布局方向是垂直的则设置的是每行内子视图的水平浮动间距，其中的subviewSize指定的是子视图的固定宽度；minSpace指定的是最小的水平间距；maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于最大间距maxSpace则会缩小subviewSize的宽度值。
 
 2.如果您的布局方向是水平的则设置的是每列内子视图的垂直浮动间距，其中的subviewSize指定的是子视图的固定高度；minSpace指定的是最小的垂直间距；maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于最大间距maxSpace则会调整subviewSize的高度值。
 
 @note 如果您不想使用浮动间距则请将subviewSize设置为0就可以了。
 
 @param subviewSize 指定子视图的尺寸。
 @param minSpace 指定子视图之间的最小间距
 @param maxSpace 指定子视图之间的最大间距
 */
-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace;
-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass;



@end



@interface MyFloatLayout(MyFloatLayoutDeprecated)

-(void)setSubviewFloatMargin:(CGFloat)subviewSize minMargin:(CGFloat)minMargin  MYMETHODDEPRECATED("use method: setSubviews:minSpace:maxSpace to replace");
-(void)setSubviewFloatMargin:(CGFloat)subviewSize minMargin:(CGFloat)minMargin inSizeClass:(MySizeClass)sizeClass  MYMETHODDEPRECATED("use method: setSubviews:minSpace:maxSpace:inSizeClass to replace");


@end


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
 *是否反方向浮动，默认是NO表示正向浮动，正向浮动和反向浮动的意义根据所在的父浮动布局视图的方向的不同而不同：
    1.如果父视图是垂直浮动布局则默认正向浮动是向左浮动的，而反向浮动则是向右浮动。
    2.如果父视图是水平浮动布局则默认正向浮动是向上浮动的，而反向浮动则是向下浮动。
 
 下面是垂直浮动布局中的正向浮动和反向浮动的效果图(正向浮动:A,B,D; 反向浮动:C,E,F)：
 
   |<--A-- <---B---    -C->|
   |<-----D---- -F-> --E-->|
 
 
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
 
 */
@property(nonatomic,assign,getter=isReverseFloat) IBInspectable BOOL reverseFloat;

/**
 *清除浮动，默认是NO。这个属性的意义也跟父浮动布局视图的方向相关。如果设置为了清除浮动属性则表示本视图不会在浮动方向上紧跟在前一个浮动视图的后面，而是会另外新起一行或者一列来重新排列。reverseFloat和clearFloat这两个属性的定义是完全参考CSS样式表中浮动布局中的float和clear这两个属性。
 
     
 垂直浮动布局下的浮动和清除浮动
 
 |<--A-- <---B--- <-C--|
 |<----D---            |
 |<--E-- <---F--       |
 |<-----G----          |
 |      ---I---> --H-->|
 |                -J-> |
 
 A(正向浮动);B(正向浮动);C(正向浮动);D(正向浮动);E(正向浮动);F(正向浮动);G(正向浮动，清除浮动);H(反向浮动);I(反向浮动);J(反向浮动，清除浮动)
 
 */
@property(nonatomic,assign) IBInspectable BOOL clearFloat;


/**
 *设置视图在流式布局中的尺寸的比重。默认值是0,表示默认不使用比重。这个属性的意义根据浮动布局视图的方向的不同而不同：
  1.当浮动布局的方向是垂直布局时，这个属性用来设置视图宽度占用当前浮动布局父视图剩余宽度的比重，这样视图就不需要明确的设定宽度值。
  2.当浮动布局的方向是水平布局时，这个属性用来设置视图高度占用当前浮动布局父视图剩余高度的比重，这样子视图就不需要明确的设定高度值。
        
     视图的真实尺寸 = 布局父视图的剩余尺寸 * 视图的weight比重值。
 
 举例来说：假设一个垂直浮动布局视图的宽度是100，A子视图占据了20的固定宽度，B子视图的weight设置为0.4，C子视图的weight设置为0.6 那么：
    A子视图的宽度 = 20
    B子视图的宽度 = (100-20)*0.4 = 32
    C子视图的宽度 = (100-20-32)*0.6 = 28.8
 
 */
@property(nonatomic, assign) IBInspectable  CGFloat weight;



@end



/**
 * 浮动布局是一种里面的子视图按照约定的方向浮动停靠，当浮动布局的剩余空间不足容纳子视图的尺寸时会自动寻找最佳的位置进行浮动停靠的布局视图。
 *浮动布局的理念源于HTML/CSS中的浮动定位技术,因此浮动布局可以专门用来实现那些不规则布局或者图文环绕的布局。
 *根据浮动的方向不同，浮动布局可以分为左右浮动布局和上下浮动布局。我们称左右浮动的浮动布局为垂直浮动布局，因为左右浮动时最终整个方向是从上到下的；称上下浮动的浮动布局为水平浮动布局，因为上下浮动时最终整个方向是从左到右的。
 */
@interface MyFloatLayout : MyBaseLayout


/**
 *初始化一个浮动布局并指定布局的方向。当方向设置为MyLayoutViewOrientation_Vert时表示为左右浮动布局视图，而设置为MyLayoutViewOrientation_Horz则表示为上下浮动布局视图。
 */
-(instancetype)initWithOrientation:(MyLayoutViewOrientation)orientation;
-(instancetype)initWithFrame:(CGRect)frame orientation:(MyLayoutViewOrientation)orientation;
+(instancetype)floatLayoutWithOrientation:(MyLayoutViewOrientation)orientation;

/**
 *浮动布局的方向。
 *如果是MyLayoutViewOrientation_Vert则表示里面的子视图可以进行左右的浮动，整体从上到下进行排列的布局方式，这个方式是默认方式。
 *如果是MyLayoutViewOrientation_Horz则表示里面的子视图可以进行上下的浮动，整体从左到右进行排列的布局方式，这个方式是默认方式。
 */
@property(nonatomic,assign) IBInspectable MyLayoutViewOrientation orientation;



/**
 *浮动布局内所有子视图的整体停靠对齐位置设定，默认是MyMarginGravity_None
 *如果视图方向为MyLayoutViewOrientation_Vert时则水平方向的停靠失效。只能设置：
  MyMarginGravity_Vert_Top  整体顶部停靠
  MyMarginGravity_Vert_Center  整体垂直居中停靠
  MyMarginGravity_Vert_Bottom  整体底部停靠
 *如果视图方向为MyLayoutViewOrientation_Horz时则垂直方向的停靠失效。只能设置：
  MyMarginGravity_Horz_Left 整体左边停靠
  MyMarginGravity_Horz_Center 整体水平居中停靠
  MyMarginGravity_Horz_Right 整体右边停靠
 */
@property(nonatomic,assign) IBInspectable MyMarginGravity gravity;



/**
 *子视图之间的垂直和水平的间距，默认为0。当子视图之间的间距是固定时可以通过直接设置这两个属性值来指定间距而不需要为每个子视图来设置margin值。
 */
@property(nonatomic ,assign) IBInspectable CGFloat subviewVertMargin;
@property(nonatomic, assign) IBInspectable CGFloat subviewHorzMargin;
@property(nonatomic, assign) IBInspectable CGFloat subviewMargin;  //同时设置水平和垂直间距。

/**
 *不做布局边界尺寸的限制，子视图不会自动换行，因此当设置为YES时，子视图需要设置clearFloat来实现主动换行的处理。默认为NO。这个属性设置的意义是我们可以自定义子视图的换行而不受布局边界尺寸的限制。
 *当布局的orientation为MyLayoutViewOrientation_Vert并且wrapContentWidth为YES时,这个属性设置为YES才生效。
 *当布局的orientation为MyLayoutViewOrientation_Horz并且wrapContentHeight为YES时，这个属性设置为YES才生效。
 *当属性设置为YES时，子视图不能将扩展属性reverseFloat设置为YES，同时不能设置weight属性，否则将导致结果异常。
 *这个属性设置为YES时，在左右浮动布局中，子视图只能向左浮动，并且没有右边界的限制，因此如果子视图没有clearFloat时则总是排列在前一个子视图的右边，并不会自动换行,因此为了让这个属性生效，布局视图必须要同时设置wrapContentWidth为YES。
 *这个属性设置为YES时，在上下浮动布局中，子视图只能向上浮动，并且没有下边界的限制，因此如果子视图没有设置clearFloat时则总是排列在前一个子视图的下边，并不会自动换行，因此为了让这个属性生效，布局视图必须要同时设置wrapContentHeight为YES.
 */
@property(nonatomic,assign) IBInspectable BOOL noBoundaryLimit;

/**
 *根据浮动布局视图的方向设置子视图的固定尺寸和视图之间的最小间距。在一些应用场景我们有时候希望某些子视图的宽度是固定的情况下，子视图的间距是浮动的而不是固定的，这样就可以尽可能的容纳更多的子视图。比如每个子视图的宽度是固定80，那么在小屏幕下每行只能放3个，而我们希望大屏幕每行能放4个或者5个子视图。因此您可以通过如下方法来设置浮动间距。这个方法会根据您当前布局的orientation方向不同而意义不同：
 1.如果您的布局方向是MyLayoutViewOrientation_Vert表示设置的是子视图的水平间距，其中的subviewSize指定的是子视图的宽度，minSpace指定的是最小的水平间距，maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的宽度。
 2.如果您的布局方向是MyLayoutViewOrientation_Horz表示设置的是子视图的垂直间距，其中的subviewSize指定的是子视图的高度，minSpace指定的是最小的垂直间距，maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的高度。
 3.如果您不想使用浮动间距则请将subviewSize设置为0就可以了。
 */
-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace;
-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass;



@end



@interface MyFloatLayout(MyFloatLayoutDeprecated)

-(void)setSubviewFloatMargin:(CGFloat)subviewSize minMargin:(CGFloat)minMargin  MYDEPRECATED("use method: setSubviews:minSpace:maxSpace to replace");
-(void)setSubviewFloatMargin:(CGFloat)subviewSize minMargin:(CGFloat)minMargin inSizeClass:(MySizeClass)sizeClass  MYDEPRECATED("use method: setSubviews:minSpace:maxSpace:inSizeClass to replace");

@end


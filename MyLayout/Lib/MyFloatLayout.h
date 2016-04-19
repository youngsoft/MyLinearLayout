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
 *是否反方向浮动，默认是NO表示正向浮动，具体方向则根据浮动布局视图的方向。如果是垂直布局则默认是向左浮动的，如果是水平布局则默认是向上浮动的。
  如果这个值设置为YES则当布局是垂直布局时则向右浮动，而如果是水平布局则向下浮动。
 */
@property(nonatomic,assign,getter=isReverseFloat) IBInspectable BOOL reverseFloat;

/**
 *清除浮动，默认是NO。这个属性也跟布局视图的方向相关。如果设置为了清除浮动属性则表示本子视图不会在浮动方向上紧跟在前一个浮动子视图的后面，而是会另外新起一行或者一列来进行布局。reverseFloat和clearFloat这两个属性的定义是完全参考CSS样式表中浮动布局中的float和clear这两个属性。
 */
@property(nonatomic,assign) IBInspectable BOOL clearFloat;


/**
 *浮动视图的尺寸的比重。默认值是0, 值的设定指定在0和1之间。这个属性的意义根据浮动布局视图的方向而不同。
 *当浮动布局视图是垂直布局时，这个属性用来设置宽度占用当前的剩余宽度的比重，这样子视图就不需要明确的设定宽度值。
 *当浮动布局视图是水平布局时，这个属性用来设置高度占用当前的剩余高度的比重，这样子视图就不需要明确的设定高度值。
 
 举例来说，假设布局视图的宽度是100，而当前视图的前面一个视图已经占据了20的宽度，那么当设置当前视图的weight为1时则当前视图的宽度就会被设定为80。这样当前视图是不会浮动
 到一个新的行的。而如果设定为0.8则当前视图的宽度则为(100-20)*0.8 = 16了。
 */
@property(nonatomic, assign) IBInspectable CGFloat weight;



@end



/**
 *  浮动布局，里面的子视图通过设定的向左向右浮动或者向上浮动来实现那些不规则的布局视图。
 */
@interface MyFloatLayout : MyBaseLayout


/**
 *初始化一个浮动布局并指定布局的方向。当方向设置为MyLayoutViewOrientation_Vert时表示为左右浮动布局视图，而设置为MyLayoutViewOrientation_Horz则表示为上下浮动布局视图。
 */
-(id)initWithOrientation:(MyLayoutViewOrientation)orientation;
+(id)floatLayoutWithOrientation:(MyLayoutViewOrientation)orientation;

/**
 *浮动布局的方向。
 *如果是MyLayoutViewOrientation_Vert则表示从左到右，从上到下的垂直布局方式，这个方式是默认方式。
 *如果是MyLayoutViewOrientation_Horz则表示从上到下，从左到右的水平布局方式
 */
@property(nonatomic,assign) MyLayoutViewOrientation orientation;


/**
 *浮动布局内所有子视图的整体停靠对齐位置设定，默认是MyMarginGravity_None
 *如果视图方向为MyLayoutViewOrientation_Vert时则水平方向的停靠失效。只能设置MyMarginGravity_Vert_Top,MyMarginGravity_Vert_Center,MyMarginGravity_Vert_Bottom 三个值。
 *如果视图方向为MyLayoutViewOrientation_Horz时则垂直方向的停靠失效。只能设置MyMarginGravity_Horz_Left,MyMarginGravity_Horz_Center,MyMarginGravity_Horz_Right
 */
@property(nonatomic,assign) IBInspectable MyMarginGravity gravity;







@end

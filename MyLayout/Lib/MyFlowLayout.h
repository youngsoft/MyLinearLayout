//
//  MyFlowLayout.h
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"

/**
 *流式布局是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一行再重新排列的多行多列展示的布局视图。这里的约束限制主要有数量约束限制和内容尺寸约束限制两种，而换行的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些有规律排列的场景，在某种程度上可以作为UICollectionView的替代品。
 1.垂直数量约束流式布局
 orientation为MyLayoutViewOrientation_Vert,arrangedCount不为0,支持wrapContentHeight,支持wrapContentWidth,支持averageArrange,不支持autoArrange。

 2.垂直内容约束流式布局.
    orientation为MyLayoutViewOrientation_Vert,arrangedCount为0,支持wrapContentHeight,不支持wrapContentWidth,支持averageArrange,支持autoArrange。
 
 
 3.水平数量约束流式布局。
 orientation为MyLayoutViewOrientation_Horz,arrangedCount不为0,支持wrapContentHeight,支持wrapContentWidth,支持averageArrange,不支持autoArrange。
 
 4.水平内容约束流式布局
    orientation为MyLayoutViewOrientation_Horz,arrangedCount为0,不支持wrapContentHeight,支持wrapContentWidth,支持averageArrange,支持autoArrange。
 
 流式布局支持子视图的宽度依赖于高度或者高度依赖于宽度,以及高度或者宽度依赖于流式布局本身的高度或者宽度
 */
@interface MyFlowLayout : MyBaseLayout

/**
 *初始化一个流式布局并指定布局的方向和布局的数量,如果数量为0则表示内容约束流式布局
 */
-(id)initWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount;
+(id)flowLayoutWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount;

/**
 *流式布局的方向：
 *如果是MyLayoutViewOrientation_Vert则表示从左到右，从上到下的垂直布局方式，这个方式是默认方式。
 *如果是MyLayoutViewOrientation_Horz则表示从上到下，从左到右的水平布局方式
 */
@property(nonatomic,assign) IBInspectable MyLayoutViewOrientation orientation;


/**
 *流式布局内所有子视图的整体停靠对齐位置设定。
 *如果视图方向为MyLayoutViewOrientation_Vert时且averageArrange为YES时则水平方向的停靠失效。
 *如果视图方向为MyLayoutViewOrientation_Horz时且averageArrange为YES时则垂直方向的停靠失效。
 *对于内容填充布局来说如果设置为MyMarginGravity_Horz_Fill或者MyMarginGravity_Vert_Fill则表示间距的拉伸
 */
@property(nonatomic,assign) IBInspectable MyMarginGravity gravity;


/**
 *指定方向上的子视图的数量，默认是0表示为内容约束流式布局，当数量不为0时则是数量约束流式布局。当值为0时则表示当子视图在方向上的尺寸超过布局视图时则会新起一行或者一列。而如果数量不为0时则：
 如果方向为MyLayoutViewOrientation_Vert，则表示从左到右的数量，当子视图从左往右满足这个数量后新的子视图将会换行再排列
 如果方向为MyLayoutViewOrientation_Horz，则表示从上到下的数量，当子视图从上往下满足这个数量后新的子视图将会换列再排列
 */
@property(nonatomic, assign) IBInspectable NSInteger arrangedCount;

/**
 *指定是否均分布局方向上的子视图的宽度或者高度，或者拉伸子视图的尺寸，默认是NO。
 如果是MyLayoutViewOrientation_Vert则表示每行的子视图的宽度会被均分，这样子视图不需要指定宽度，但是布局视图必须要指定一个明确的宽度值，如果设置为YES则wrapContentWidth会失效。
 如果是MyLayoutViewOrientation_Horz则表示每列的子视图的高度会被均分，这样子视图不需要指定高度，但是布局视图必须要指定一个明确的高度值，如果设置为YES则wrapContentHeight会失效。
内容填充约束流式布局下averageArrange设置为YES时表示拉伸子视图的宽度或者高度以便填充满整个布局视图。
 */
@property(nonatomic,assign) IBInspectable BOOL averageArrange;

/**
 *子视图自动排列,这个属性只有在内容填充约束流式布局下才有用,默认为NO.当设置为YES时则根据子视图的内容自动填充，而不是根据加入的顺序来填充，以便保证不会出现多余空隙的情况。
 */
@property(nonatomic,assign) IBInspectable BOOL autoArrange;


/**
 *流式布局中每排子视图的停靠对齐位置设定。
 如果是MyLayoutViewOrientation_Vert则只用于表示每行子视图的上中下停靠对齐位置，这个属性只支持MyMarginGravity_Vert_Top，MyMarginGravity_Vert_Center,MyMarginGravity_Vert_Bottom,MyMarginGravity_Vert_Fill这里的对齐基础是以每行中的最高的子视图为基准。
 如果是MyLayoutViewOrientation_Horz则只用于表示每列子视图的左中右停靠对齐位置，这个属性只支持MyMarginGravity_Horz_Left，MyMarginGravity_Horz_Center,MyMarginGravity_Horz_Right,MyMarginGravity_Horz_Fill这里的对齐基础是以每列中的最宽的子视图为基准。
 */
@property(nonatomic,assign) IBInspectable MyMarginGravity arrangedGravity;


/**
 *子视图之间的垂直和水平的间距，默认为0。当子视图之间的间距是固定时可以通过直接设置这两个属性值来指定间距而不需要为每个子视图来设置margin值。
 */
@property(nonatomic ,assign) IBInspectable CGFloat subviewVertMargin;
@property(nonatomic, assign) IBInspectable CGFloat subviewHorzMargin;
@property(nonatomic, assign) IBInspectable CGFloat subviewMargin;  //同时设置水平和垂直间距。



@end




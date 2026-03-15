//
//  MyFloatLayout.h
//  MyLayout
//
//  Created by oybq on 16/2/18.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"

/**
 浮动布局是一种里面的子视图按照约定的方向浮动停靠，当浮动布局的剩余空间不足容纳要加入的子视图的尺寸时会自动寻找最佳的位置进行浮动停靠的布局视图。浮动布局的理念源于HTML/CSS中的浮动定位技术,因此浮动布局可以专门用来实现那些不规则布局或者图文环绕的布局。
 
 @note
 根据浮动的方向不同，浮动布局可以分为左右浮动布局和上下浮动布局。我们称左右浮动的浮动布局为垂直浮动布局，因为左右浮动时最终整个方向是从上到下的；称上下浮动的浮动布局为水平浮动布局，因为上下浮动时最终整个方向是从左到右的。
 */
@interface MyFloatLayout : MyBaseLayout<id<MyFloatLayoutTraits>> <MyFloatLayoutTraits>

/**
 初始化一个浮动布局并指定布局的方向。当方向设置为MyOrientation_Vert时表示为左右浮动布局视图，而设置为MyOrientation_Horz则表示为上下浮动布局视图。
 
 @param orientation 指定浮动布局的方向，要注意的这个方向是整体排列的方向。
 @return 返回浮动布局的实例对象。
 */
+ (instancetype)floatLayoutWithOrientation:(MyOrientation)orientation;
- (instancetype)initWithOrientation:(MyOrientation)orientation;
- (instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation;

/**
  浮动布局的方向。
 
 1.MyOrientation_Vert 表示里面的子视图可以进行左右的浮动，但整体从上到下进行排列的布局方式，这个方式是默认方式。

 2.MyOrientation_Horz 表示里面的子视图可以进行上下的浮动，但整体从左到右进行排列的布局方式，这个方式是默认方式。
 */
@property (nonatomic, assign) MyOrientation orientation;

/**
 在一些应用场景中我们希望子视图的宽度是固定的但间距是浮动的，这样就尽可能在一排中容纳更多的子视图。比如设置每个子视图的宽度固定为80，那么在小屏幕下每排只能放3个，而大屏幕则每排能放4个或者5个子视图。 因此您可以通过如下方法来设置子视图的固定尺寸和最小最大浮动间距。这个方法会根据您当前布局的方向不同而具有不同的意义：
 
 1.如果您的布局方向是垂直的则设置的是每行内子视图的水平浮动间距，其中的subviewsSize指定的是子视图的固定宽度；minSpacing指定的是最小的水平间距；maxSpacing指定的是最大的水平间距，如果指定的subviewsSize计算出的间距大于最大间距maxSpacing则会缩小subviewsSize的宽度值。
 
 2.如果您的布局方向是水平的则设置的是每列内子视图的垂直浮动间距，其中的subviewsSize指定的是子视图的固定高度；minSpacing指定的是最小的垂直间距；maxSpacing指定的是最大的垂直间距，如果指定的subviewsSize计算出的间距大于最大间距maxSpacing则会调整subviewsSize的高度值。
 
 @note 如果您不想使用浮动间距则请将subviewsSize设置为0就可以了。
 
 @param subviewsSize 指定子视图的尺寸。
 @param minSpacing 指定子视图之间的最小间距
 @param maxSpacing 指定子视图之间的最大间距
 */
- (void)setSubviewsSize:(CGFloat)subviewsSize minSpacing:(CGFloat)minSpacing maxSpacing:(CGFloat)maxSpacing;
- (void)setSubviewsSize:(CGFloat)subviewsSize minSpacing:(CGFloat)minSpacing maxSpacing:(CGFloat)maxSpacing inSizeClass:(MySizeClass)sizeClass;

/**
 上面函数的加强版本。
 
 @param subviewsSize 指定子视图的尺寸
 @param minSpacing 指定子视图之间的最小间距
 @param maxSpacing 指定子视图之间的最大间距
 @param centered 指定是否所有子视图居中
 */
- (void)setSubviewsSize:(CGFloat)subviewsSize minSpacing:(CGFloat)minSpacing maxSpacing:(CGFloat)maxSpacing centered:(BOOL)centered;
- (void)setSubviewsSize:(CGFloat)subviewsSize minSpacing:(CGFloat)minSpacing maxSpacing:(CGFloat)maxSpacing centered:(BOOL)centered inSizeClass:(MySizeClass)sizeClass;

@end

@interface MyFloatLayout (MyDeprecated)

- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace MYDEPRECATED("use setSubviewsSize:minSpacing:maxSpacing: instead");
- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass MYDEPRECATED("use setSubviewsSize:minSpacing:maxSpacing:inSizeClass: instead");
- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered MYDEPRECATED("use setSubviewsSize:minSpacing:maxSpacing:centered: instead");
- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered inSizeClass:(MySizeClass)sizeClass MYDEPRECATED("use setSubviewsSize:minSpacing:maxSpacing:centered:inSizeClass: instead");

@end


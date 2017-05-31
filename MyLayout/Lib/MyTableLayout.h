//
//  MyTableLayout.h
//  MyLayout
//
//  Created by oybq on 15/8/26.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLinearLayout.h"


/**
  表格布局行列索引描述扩展对象。
 */
@interface NSIndexPath(MyTableLayoutEx)


/**
 构建一个单元格索引对象

 @param col 列索引
 @param row 行索引
 @return 返回单元格索引实例对象
 */
+(instancetype)indexPathForCol:(NSInteger)col inRow:(NSInteger)row;

@property(nonatomic,assign,readonly) NSInteger col;

@end

//定义特殊的表格行列尺寸,参考下面addRow方法中的描述。
#define MTLSIZE_AVERAGE 0
#define MTLSIZE_WRAPCONTENT -1
#define MTLSIZE_MATCHPARENT -2


/**
 表格布局是一种里面的子视图可以像表格一样进行多行多列排列的布局视图。子视图添加到表格布局视图前必须先要建立并添加行子视图，然后再将列子视图添加到行子视图里面。
 表格里面的行子视图和列子视图的排列方向的概念是相对的，他根据表格布局方向的不同而不同。表格布局根据方向可分为垂直表格布局和水平表格布局。
 
 1. 对于垂直表格布局来说，行子视图是从上到下依次排列的，而列子视图则是在行子视图里面从左到右依次排列。
 
 2. 对于水平表格布局来说，行子视图是从左到右依次排列的，而列子视图则是在行子视图里面从上到下依次排列。
 */
@interface MyTableLayout : MyLinearLayout


/**
 构建一个表格布局视图

 @param orientation 表格布局的方向
 @return 表格布局实例对象
 */
+(instancetype)tableLayoutWithOrientation:(MyOrientation)orientation;



/**
  添加一个新行。对于垂直表格来说每一行是从上往下排列的，而水平表格则每一行是从左往右排列的。
 
 @note 行能设置的值：
 
 1. MTLSIZE_WRAPCONTENT表示由列子视图决定本行尺寸(垂直表格为行高，水平表格为行宽)，每个列子视图都需要自己设置尺寸(垂直表格为高度，水平表格为宽度)
 
 2. MTLSIZE_AVERAGE表示均分尺寸(垂直表格为行高 = 总行高/行数，水平表格为行宽 = 总行宽/行数)，列子视图不需要设置尺寸(垂直表格为高度，水平表格为宽度)
 
 3. 大于0表示固定尺寸，表示这行的尺寸为这个固定的数值(垂直表格为行高，水平表格为行宽)，列子视图不需要设置尺寸(垂直表格为高度，水平表格为宽度)。
 
 4. 不能设置为MTLSIZE_MATCHPARENT。

 @note 列能设置的值：
 
 1. MTLSIZE_MATCHPARENT表示整列尺寸和父视图一样的尺寸(垂直表格为列宽，水平表格为列高)，每个子视图需要设置自己的尺寸(垂直表格为宽度，水平表格为高度)
 
 2. MTLSIZE_WRAPCONTENT表示整列的尺寸由列内所有子视图包裹(垂直表格为列宽，水平表格为列高).每个子视图需要设置自己的尺寸(垂直表格为宽度，水平表格为高度)
 
 3. MTLSIZE_AVERAGE表示整列的尺寸和父视图一样的尺寸(垂直表格为列宽，水平表格为列高)，每列内子视图的尺寸均分(垂直表格 = 列宽/行内子视图数，水平表格 = 行高/列内子视图数)
 
 4. 大于0表示列内每个子视图都具有固定尺寸(垂直表格为宽度，水平表格为高度)，这时候子视图可以不必设置尺寸。

 
 @param rowSize 行的尺寸值，请参考上面的行能设置的值。
 @param colSize 列的尺寸值，请参考上面的列能设置的值。
 @return 返回行布局视图对象
 */
-(MyLinearLayout*)addRow:(CGFloat)rowSize colSize:(CGFloat)colSize;

/**
 * 在指定的位置插入一个新行
 */
-(MyLinearLayout*)insertRow:(CGFloat)rowSize colSize:(CGFloat)colSize atIndex:(NSInteger)rowIndex;

/**
 * 删除一行
 */
-(void)removeRowAt:(NSInteger)rowIndex;

/**
 * 交换两行的位置
 */
-(void)exchangeRowAt:(NSInteger)rowIndex1 withRow:(NSInteger)rowIndex2;

/**
 *返回行对象
 */
-(MyLinearLayout*)viewAtRowIndex:(NSInteger)rowIndex;

/**
 *返回行的数量
 */
-(NSUInteger)countOfRow;

/**
 * 添加一个新的列。再添加一个新的列前必须要先添加行，对于垂直表格来说每一列是从左到右排列的，而对于水平表格来说每一列是从上到下排列的。
 * @param colView  列视图
 * @param rowIndex 指定要添加列的行的索引
 */
-(void)addCol:(UIView*)colView atRow:(NSInteger)rowIndex;

/**
 * 在指定的indexPath下插入一个新的列indexPath用[NSIndexPath indexPathForCol:inRow:]来构建
 */
-(void)insertCol:(UIView*)colView atIndexPath:(NSIndexPath*)indexPath;

/**
 * 删除一列
 */
-(void)removeColAt:(NSIndexPath*)indexPath;

/**
 * 交换两个列视图，这两个列视图是可以跨行的
 */
-(void)exchangeColAt:(NSIndexPath*)indexPath1 withCol:(NSIndexPath*)indexPath2;

/**
 * 返回列视图
 */
-(UIView*)viewAtIndexPath:(NSIndexPath*)indexPath;

/**
 * 返回某行的列的数量
 */
-(NSUInteger)countOfColInRow:(NSInteger)rowIndex;


/**
 *表格布局的addSubView被重新定义，是addCol:atRow的精简版本，表示插入当前行的最后一列
 */
- (void)addSubview:(UIView *)view;


//不能直接调用如下的函数，否则会崩溃。
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;
- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;


@end


@interface MyTableLayout(MyTableDeprecated)


/**
 *  不再单独设置表格的行间距和列间距了，而是复用视图的水平间距和垂直间距。原来表格的行间距和列间距会根据不同的表格方向定义不同而不同，现在统一为水平和垂直间距，不管表格的方向如何，水平间距都是定义左右的间距，垂直间距都是定义上下的间距。
 */
@property(nonatomic ,assign, getter=subviewVSpace, setter=setSubviewVSpace:)  CGFloat rowSpacing MYMETHODDEPRECATED("use subviewVSpace to instead");
@property(nonatomic, assign, getter=subviewHSpace, setter=setSubviewHSpace:)  CGFloat colSpacing MYMETHODDEPRECATED("use subviewHSpace to instead");


@end


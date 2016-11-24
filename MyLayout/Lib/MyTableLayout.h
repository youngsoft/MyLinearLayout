//
//  MyTableLayout.h
//  MyLayout
//
//  Created by oybq on 15/8/26.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLinearLayout.h"


/**
 *  行列描述扩展对象。
 */
@interface NSIndexPath(MyTableLayoutEx)

+(instancetype)indexPathForCol:(NSInteger)col inRow:(NSInteger)row;

@property(nonatomic,assign,readonly) NSInteger col;

@end

//定义特殊的尺寸
#define MTLSIZE_AVERAGE 0
#define MTLSIZE_WRAPCONTENT -1
#define MTLSIZE_MATCHPARENT -2


/**
 *表格布局是一种里面的子视图可以像表格一样多行多列排列的布局视图。子视图添加到表格布局视图前必须先要建立并添加行视图，然后再将子视图添加到行视图里面。
 *如果行视图在表格布局里面是从上到下排列的则表格布局为垂直表格布局，垂直表格布局里面的子视图在行视图里面是从左到右排列的；
 *如果行视图在表格布局里面是从左到右排列的则表格布局为水平表格布局，水平表格布局里面的子视图在行视图里面是从上到下排列的。
 */
@interface MyTableLayout : MyLinearLayout

+(id)tableLayoutWithOrientation:(MyLayoutViewOrientation)orientation;


/**
 *  设置表格的行间距和列间距
 */
@property(nonatomic ,assign)  CGFloat rowSpacing;
@property(nonatomic, assign)  CGFloat colSpacing;



/**
 *  添加一个新行。对于垂直表格来说每一行是从上往下排列的，而水平表格则每一行是从左往右排列的。
 *
 *  @param rowSize 为MTLSIZE_WRAPCONTENT表示由子视图决定本行尺寸，子视图需要自己设置尺寸；为MTLSIZE_AVERAGE表示均分尺寸，子视图不需要设置尺寸；大于0表示固定尺寸，子视图不需要设置尺寸;不能设置为MTLSIZE_MATCHPARENT。
 *  @param colSize  为MTLSIZE_MATCHPARENT表示子视图需要自己指定尺寸，整体列尺寸和父视图一样的尺寸；为MTLSIZE_WRAPCONTENT表示由子视图需要自己设置尺寸，列尺寸包裹所有子视图；为MTLSIZE_AVERAGE表示均分尺寸，这时候子视图不必设置尺寸；大于0表示子视图固定尺寸，这时候子视图可以不必设置尺寸。
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
 * @colView:  列视图
 * @rowIndex: 指定要添加列的行的索引
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

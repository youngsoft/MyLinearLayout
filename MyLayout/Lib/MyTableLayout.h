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

//定义特殊的行高
#define MTLROWHEIGHT_AVERAGE 0
#define MTLROWHEIGHT_WRAPCONTENT -1

//定义特殊的列宽
#define MTLCOLWIDTH_AVERAGE 0
#define MTLCOLWIDTH_WRAPCONTENT -1
#define MTLCOLWIDTH_MATCHPARENT -2


/**
 * 表格布局，用来实现多行多列表格样式的布局，可以用表格布局来实现瀑布流的功能。一个垂直表格外部是一个垂直线性布局而里面的行则是水平线性布局，而一个水平表格外部是一个水平线性布局而
 */
@interface MyTableLayout : MyLinearLayout

+(id)tableLayoutWithOrientation:(MyLayoutViewOrientation)orientation;



/**
 *  添加一个新行。对于垂直表格来说每一行是从上往下排列的，而水平表格则每一行是从左往右排列的。
 *
 *  @param rowHeight 为MTLROWHEIGHT_WRAPCONTENT表示由子视图决定本行高度，子视图需要自己设置高度；为MTLROWHEIGHT_AVERAGE表示均分高度，子视图不需要设置高度；大于0表示固定高度，子视图不需要设置高度.
 *  @param colWidth  为MTLCOLWIDTH_MATCHPARENT表示子视图需要自己指定宽度，整体行宽和父视图一样宽；为MTLCOLWIDTH_WRAPCONTENT表示由子视图需要自己设置宽度，行宽包裹所有子视图；为MTLCOLWIDTH_AVERAGE表示均分宽度，这时候子视图不必设置宽度；大于0表示子视图固定宽度，这时候子视图可以不必设置宽度。
 */
-(void)addRow:(CGFloat)rowHeight colWidth:(CGFloat)colWidth;

/**
 * 在指定的位置插入一个新行
 */
-(void)insertRow:(CGFloat)rowHeight colWidth:(CGFloat)colWidth atIndex:(NSInteger)rowIndex;

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

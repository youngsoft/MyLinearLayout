//
//  MyTableLayout.h
//  MyLayout
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
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
 *  表格布局.用于方便的进行表格布局视图的操作。可以添加任意行，每行可以添加任意的列
 *  表格布局也可以用数据量不大的瀑布流式布局。
 *  因为是从线性布局派生，因此表格也分为垂直表格和水平表格
 *  所谓垂直表格就是行是从上往下排列，而水平表格则行是从左往右排列
 *  表格布局支持wrapContentHeight,wrapContentWidth属性
 */
@interface MyTableLayout : MyLinearLayout

+(id)tableLayoutWithOrientation:(MyLayoutViewOrientation)orientation;



/**
 *  添加行，这里需要注意的是如果是水平表格则行是从左到右的，而列是从上到下的。
 *
 *  @param rowHeight 为MTLROWHEIGHT_WRAPCONTENT表示由子视图决定本行高度，子视图需要自己设置高度；为MTLROWHEIGHT_AVERAGE表示均分高度，子视图不需要设置高度；大于0表示固定高度，子视图不需要设置高度.
 *  @param colWidth  为MTLCOLWIDTH_MATCHPARENT表示子视图需要自己指定宽度，整体行宽和父视图一样宽；为MTLCOLWIDTH_WRAPCONTENT表示由子视图需要自己设置宽度，行宽包裹所有子视图；为MTLCOLWIDTH_AVERAGE表示均分宽度，这时候子视图不必设置宽度；大于0表示子视图固定宽度，这时候子视图可以不必设置宽度。
 */
-(void)addRow:(CGFloat)rowHeight colWidth:(CGFloat)colWidth;
-(void)insertRow:(CGFloat)rowHeight colWidth:(CGFloat)colWidth atIndex:(NSInteger)rowIndex;
-(void)removeRowAt:(NSInteger)rowIndex;
-(void)exchangeRowAt:(NSInteger)rowIndex1 withRow:(NSInteger)rowIndex2;
//取指定的行的视图
-(MyLinearLayout*)viewAtRowIndex:(NSInteger)rowIndex;
//返回当前有多少行
-(NSUInteger)countOfRow;

//列操作
-(void)addCol:(UIView*)colView atRow:(NSInteger)rowIndex;
-(void)insertCol:(UIView*)colView atIndexPath:(NSIndexPath*)indexPath;
-(void)removeColAt:(NSIndexPath*)indexPath;
-(void)exchangeColAt:(NSIndexPath*)indexPath1 withCol:(NSIndexPath*)indexPath2;
//返回列视图
-(UIView*)viewAtIndexPath:(NSIndexPath*)indexPath;
//返回指定行的列的数量。
-(NSUInteger)countOfColInRow:(NSInteger)rowIndex;


//表格布局的addSubView被重新定义，是addCol:atRow的精简版本，表示插入当前行的最后一列
- (void)addSubview:(UIView *)view;


//不能直接调用如下的函数，否则会崩溃。
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;
- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;


@end

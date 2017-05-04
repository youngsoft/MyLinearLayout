//
//  MyTableLayout.m
//  MyLayout
//
//  Created by oybq on 15/8/26.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyTableLayout.h"
#import "MyLayoutInner.h"



@interface MyTableRowLayout : MyLinearLayout


+(id)rowSize:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(MyOrientation)orientation;

@property(nonatomic,assign, readonly) CGFloat rowSize;
@property(nonatomic,assign, readonly) CGFloat colSize;

@end

@implementation MyTableRowLayout
{
   CGFloat _rowSize;
   CGFloat _colSize;
}

-(id)initWith:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(MyOrientation)orientation
{
    self = [super initWithOrientation:orientation];
    if (self != nil)
    {
        _rowSize = rowSize;
        _colSize = colSize;
        
        UIView *lsc = self.myCurrentSizeClass;
        
        if (rowSize == MTLSIZE_AVERAGE)
            lsc.weight = 1;
        else if (rowSize > 0)
        {
            if (orientation == MyOrientation_Horz)
                lsc.myHeight = rowSize;
            else
                lsc.myWidth = rowSize;
        }
        else if (rowSize == MTLSIZE_WRAPCONTENT)
        {
            if (orientation == MyOrientation_Horz)
                lsc.wrapContentHeight = YES;
            else
                lsc.wrapContentWidth = YES;
        }
        else
        {
            NSCAssert(0, @"Constraint exception !! rowSize can not set to MTLSIZE_MATCHPARENT");
        }
        
        if (colSize == MTLSIZE_AVERAGE)
        {
            if (orientation == MyOrientation_Horz)
            {
                lsc.wrapContentWidth = NO;
                lsc.myHorzMargin = 0;
            }
            else
            {
                lsc.wrapContentHeight = NO;
                lsc.myVertMargin = 0;
            }
            
        }
        else if (colSize == MTLSIZE_MATCHPARENT)
        {
            if (orientation == MyOrientation_Horz)
            {
                lsc.wrapContentWidth = NO;
                lsc.myHorzMargin = 0;
            }
            else
            {
                lsc.wrapContentHeight = NO;
                lsc.myVertMargin = 0;
            }
        }
    }
    
    return self;
}

+(id)rowSize:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(MyOrientation)orientation
{
    return [[self alloc] initWith:rowSize colSize:colSize orientation:orientation];
}


@end


@implementation NSIndexPath(MyTableLayoutEx)

+(instancetype)indexPathForCol:(NSInteger)col inRow:(NSInteger)row
{
    return [self indexPathForRow:row inSection:col];
}

-(NSInteger)col
{
    return self.section;
}

@end


@implementation MyTableLayout

+(instancetype)tableLayoutWithOrientation:(MyOrientation)orientation
{
    return [self linearLayoutWithOrientation:orientation];
}


-(MyLinearLayout*)addRow:(CGFloat)rowSize colSize:(CGFloat)colSize
{
    return [self insertRow:rowSize colSize:colSize atIndex:self.countOfRow];
}

-(MyLinearLayout*)insertRow:(CGFloat)rowSize colSize:(CGFloat)colSize atIndex:(NSInteger)rowIndex
{
    MyTableLayout *lsc = self.myCurrentSizeClass;
    
    MyOrientation ori = MyOrientation_Vert;
    if (lsc.orientation == MyOrientation_Vert)
        ori = MyOrientation_Horz;
    else
        ori = MyOrientation_Vert;
    
    MyTableRowLayout *rowView = [MyTableRowLayout rowSize:rowSize colSize:colSize orientation:ori];
    if (ori == MyOrientation_Horz)
    {
        rowView.subviewHSpace = lsc.subviewHSpace;
    }
    else
    {
        rowView.subviewVSpace = lsc.subviewVSpace;
    }
    rowView.intelligentBorderline = self.intelligentBorderline;
    [super insertSubview:rowView atIndex:rowIndex];
    return rowView;
}

-(void)removeRowAt:(NSInteger)rowIndex
{
    [[self viewAtRowIndex:rowIndex] removeFromSuperview];
}

-(void)exchangeRowAt:(NSInteger)rowIndex1 withRow:(NSInteger)rowIndex2
{
    [super exchangeSubviewAtIndex:rowIndex1 withSubviewAtIndex:rowIndex2];
}

-(MyLinearLayout*)viewAtRowIndex:(NSInteger)rowIndex;
{
    return [self.subviews objectAtIndex:rowIndex];
}

-(NSUInteger)countOfRow
{
    return self.subviews.count;
}

//列操作
-(void)addCol:(UIView*)colView atRow:(NSInteger)rowIndex
{
    [self insertCol:colView atIndexPath:[NSIndexPath indexPathForCol:[self countOfColInRow:rowIndex] inRow:rowIndex]];
}

-(void)insertCol:(UIView*)colView atIndexPath:(NSIndexPath*)indexPath
{
    MyTableRowLayout *rowView = (MyTableRowLayout*)[self viewAtRowIndex:indexPath.row];
    
    MyLinearLayout *rowsc = rowView.myCurrentSizeClass;
    UIView *colsc = colView.myCurrentSizeClass;
    
    //colSize为0表示均分尺寸，为-1表示由子视图决定尺寸，大于0表示固定尺寸。
    if (rowView.colSize == MTLSIZE_AVERAGE)
        colsc.weight = 1;
    else if (rowView.colSize > 0)
    {
        if (rowsc.orientation == MyOrientation_Horz)
            colsc.myWidth = rowView.colSize;
        else
            colsc.myHeight = rowView.colSize;
    }
    
    if (rowsc.orientation == MyOrientation_Horz)
    {
        if (CGRectGetHeight(colView.bounds) == 0 && colsc.heightSizeInner.dimeVal == nil)
        {
            if ([colView isKindOfClass:[MyBaseLayout class]])
            {
                if (!colsc.wrapContentHeight)
                    [colsc.heightSize __equalTo:rowsc.heightSize];
            }
            else
                [colsc.heightSize __equalTo:rowsc.heightSize];
        }
    }
    else
    {
        if (CGRectGetWidth(colView.bounds) == 0 && colsc.widthSizeInner.dimeVal == nil)
        {
            
            if ([colView isKindOfClass:[MyBaseLayout class]])
            {
                if (!colsc.wrapContentWidth)
                    [colsc.widthSize __equalTo:rowsc.widthSize];
            }
            else
                [colsc.widthSize __equalTo:rowsc.widthSize];
        }
        
    }
    
    
    [rowView insertSubview:colView atIndex:indexPath.col];
}

-(void)removeColAt:(NSIndexPath*)indexPath
{
    [[self viewAtIndexPath:indexPath] removeFromSuperview];
}

-(void)exchangeColAt:(NSIndexPath*)indexPath1 withCol:(NSIndexPath*)indexPath2
{
    UIView * colView1 = [self viewAtIndexPath:indexPath1];
    UIView * colView2 = [self viewAtIndexPath:indexPath2];
    
    if (colView1 == colView2)
        return;
    
    
    [self removeColAt:indexPath1];
    [self removeColAt:indexPath2];
    
    [self insertCol:colView1 atIndexPath:indexPath2];
    [self insertCol:colView2 atIndexPath:indexPath1];
}

-(UIView*)viewAtIndexPath:(NSIndexPath*)indexPath
{
    return [[self viewAtRowIndex:indexPath.row].subviews objectAtIndex:indexPath.col];
}

-(NSUInteger)countOfColInRow:(NSInteger)rowIndex
{
    return [self viewAtRowIndex:rowIndex].subviews.count;
}

#pragma mark -- Override Method



-(void)setSubviewVSpace:(CGFloat)subviewVSpace
{
    [super setSubviewVSpace:subviewVSpace];
    if (self.orientation == MyOrientation_Horz)
    {
        for (NSInteger i  = 0; i < self.countOfRow; i++)
        {
            [self viewAtRowIndex:i].subviewVSpace = subviewVSpace;
        }
    }
}

-(void)setSubviewHSpace:(CGFloat)subviewHSpace
{
    [super setSubviewHSpace:subviewHSpace];
    if (self.orientation == MyOrientation_Vert)
    {
        for (NSInteger i  = 0; i < self.countOfRow; i++)
        {
            [self viewAtRowIndex:i].subviewHSpace = subviewHSpace;
        }
    }
    
}


//不能直接调用如下的函数。
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    NSCAssert(0, @"Constraint exception!! Can't call insertSubview");
}

- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2
{
    NSCAssert(0, @"Constraint exception!! Can't call exchangeSubviewAtIndex");
}

- (void)addSubview:(UIView *)view
{
    [self addCol:view atRow:[self countOfRow] - 1];
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
{
    NSCAssert(0, @"Constraint exception!! Can't call insertSubview");
}
- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
{
    NSCAssert(0, @"Constraint exception!! Can't call insertSubview");
}


-(id)createSizeClassInstance
{
    return [MyTableLayoutViewSizeClass new];
}

#pragma mark -- Deprecated Method


@end

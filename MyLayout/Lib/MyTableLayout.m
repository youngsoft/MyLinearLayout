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


+(id)rowSize:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(MyLayoutViewOrientation)orientation;

@property(nonatomic,assign, readonly) CGFloat rowSize;
@property(nonatomic,assign, readonly) CGFloat colSize;

@end

@implementation MyTableRowLayout
{
   CGFloat _rowSize;
   CGFloat _colSize;
}

-(id)initWith:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(MyLayoutViewOrientation)orientation
{
    self = [super initWithOrientation:orientation];
    if (self != nil)
    {
        _rowSize = rowSize;
        _colSize = colSize;
        
        if (rowSize == MTLSIZE_AVERAGE)
            self.weight = 1;
        else if (rowSize > 0)
        {
            if (orientation == MyLayoutViewOrientation_Horz)
                self.myHeight = rowSize;
            else
                self.myWidth = rowSize;
        }
        else if (rowSize == MTLSIZE_WRAPCONTENT)
        {
            if (orientation == MyLayoutViewOrientation_Horz)
                self.wrapContentHeight = YES;
            else
                self.wrapContentWidth = YES;
        }
        else
        {
            NSCAssert(0, @"Constraint exception !! rowSize can not set to MTLSIZE_MATCHPARENT");
        }
        
        if (colSize == MTLSIZE_AVERAGE)
        {
            if (orientation == MyLayoutViewOrientation_Horz)
            {
                self.wrapContentWidth = NO;
                self.myLeftMargin = self.myRightMargin = 0;
            }
            else
            {
                self.wrapContentHeight = NO;
                self.myTopMargin = self.myBottomMargin = 0;
            }
            
        }
        else if (colSize == MTLSIZE_MATCHPARENT)
        {
            if (orientation == MyLayoutViewOrientation_Horz)
            {
                self.wrapContentWidth = NO;
                self.myLeftMargin = self.myRightMargin = 0;
            }
            else
            {
                self.wrapContentHeight = NO;
                self.myTopMargin = self.myBottomMargin = 0;
            }
        }
    }
    
    return self;
}

+(id)rowSize:(CGFloat)rowSize colSize:(CGFloat)colSize orientation:(MyLayoutViewOrientation)orientation
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

+(id)tableLayoutWithOrientation:(MyLayoutViewOrientation)orientation
{
    return [self linearLayoutWithOrientation:orientation];
}

-(void)setRowSpacing:(CGFloat)rowSpacing
{
    self.subviewMargin = rowSpacing;
}

-(CGFloat)rowSpacing
{
    return self.subviewMargin;
}

-(void)setColSpacing:(CGFloat)colSpacing
{
    MyTableLayout *lsc = self.myCurrentSizeClass;
    if (lsc.colSpacing != colSpacing)
    {
        lsc.colSpacing = colSpacing;
        
        for (int i = 0; i < self.countOfRow; i++)
        {
            [self viewAtRowIndex:i].subviewMargin = colSpacing;
        }
        
    }

}

-(CGFloat)colSpacing
{
    return self.myCurrentSizeClass.colSpacing;
}


-(MyLinearLayout*)addRow:(CGFloat)rowSize colSize:(CGFloat)colSize
{
    return [self insertRow:rowSize colSize:colSize atIndex:self.countOfRow];
}

-(MyLinearLayout*)insertRow:(CGFloat)rowSize colSize:(CGFloat)colSize atIndex:(NSInteger)rowIndex
{
    MyLayoutViewOrientation ori = MyLayoutViewOrientation_Vert;
    if (self.orientation == MyLayoutViewOrientation_Vert)
        ori = MyLayoutViewOrientation_Horz;
    else
        ori = MyLayoutViewOrientation_Vert;
    
    MyTableRowLayout *rowView = [MyTableRowLayout rowSize:rowSize colSize:colSize orientation:ori];
    rowView.subviewMargin = self.colSpacing;
    rowView.IntelligentBorderLine = self.IntelligentBorderLine;
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
    
    //colSize为0表示均分尺寸，为-1表示由子视图决定尺寸，大于0表示固定尺寸。
    if (rowView.colSize == MTLSIZE_AVERAGE)
        colView.weight = 1;
    else if (rowView.colSize > 0)
    {
        if (rowView.orientation == MyLayoutViewOrientation_Horz)
            colView.myWidth = rowView.colSize;
        else
            colView.myHeight = rowView.colSize;
    }
    
    if (rowView.orientation == MyLayoutViewOrientation_Horz)
    {
        if (CGRectGetHeight(colView.bounds) == 0 && colView.heightDime.dimeVal == nil)
        {
            if ([colView isKindOfClass:[MyBaseLayout class]])
            {
                if (!((MyBaseLayout*)colView).wrapContentHeight)
                    colView.heightDime.equalTo(rowView.heightDime);
            }
            else
                colView.heightDime.equalTo(rowView.heightDime);
        }
    }
    else
    {
        if (CGRectGetWidth(colView.bounds) == 0 && colView.widthDime.dimeVal == nil)
        {
            
            if ([colView isKindOfClass:[MyBaseLayout class]])
            {
                if (!((MyBaseLayout*)colView).wrapContentWidth)
                     colView.widthDime.equalTo(rowView.widthDime);
            }
            else
                colView.widthDime.equalTo(rowView.widthDime);
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)createSizeClassInstance
{
    return [MyLayoutSizeClassTableLayout new];
}


@end

//
//  MyTableLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyTableLayout.h"
#import "MyLayoutInner.h"



@interface MyTableRowLayout : MyLinearLayout


+(id)rowWith:(CGFloat)rowHeight colWidth:(CGFloat)colWidth orientation:(LineViewOrientation)orientation;

@property(nonatomic,assign, readonly) CGFloat rowHeight;
@property(nonatomic,assign, readonly) CGFloat colWidth;

@end

@implementation MyTableRowLayout
{
   CGFloat _rowHeight;
   CGFloat _colWidth;
}

-(id)initWith:(CGFloat)rowHeight colWidth:(CGFloat)colWidth orientation:(LineViewOrientation)orientation
{
    self = [self init];
    if (self != nil)
    {
        _rowHeight = rowHeight;
        _colWidth = colWidth;
        self.orientation = orientation;
        
        if (rowHeight == 0)
            self.weight = 1;
        else if (rowHeight > 0)
        {
            if (orientation == LVORIENTATION_HORZ)
                self.height = rowHeight;
            else
                self.width = rowHeight;
        }
        else
        {
            if (orientation == LVORIENTATION_HORZ)
                self.wrapContentHeight = YES;
            else
                self.wrapContentWidth = YES;
        }
        
        if (colWidth == 0)
        {
            if (orientation == LVORIENTATION_HORZ)
            {
                self.wrapContentWidth = NO;
                self.leftMargin = self.rightMargin = 0;
            }
            else
            {
                self.wrapContentHeight = NO;
                self.topMargin = self.bottomMargin = 0;
            }
            
        }
        else if (colWidth == -2)
        {
            if (orientation == LVORIENTATION_HORZ)
            {
                self.wrapContentWidth = NO;
                self.leftMargin = self.rightMargin = 0;
            }
            else
            {
                self.wrapContentHeight = NO;
                self.topMargin = self.bottomMargin = 0;
            }
        }
    }
    
    return self;
}

+(id)rowWith:(CGFloat)rowHeight colWidth:(CGFloat)colWidth orientation:(LineViewOrientation)orientation
{
    return [[self alloc] initWith:rowHeight colWidth:colWidth orientation:orientation];
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


-(void)construct
{
    [super construct];
}


-(void)addRow:(CGFloat)rowHeight colWidth:(CGFloat)colWidth
{
    [self insertRow:rowHeight colWidth:colWidth atIndex:self.countOfRow];
}

-(void)insertRow:(CGFloat)rowHeight colWidth:(CGFloat)colWidth atIndex:(NSInteger)rowIndex
{
    LineViewOrientation ori = 0;
    if (self.orientation == LVORIENTATION_VERT)
        ori = LVORIENTATION_HORZ;
    else
        ori = LVORIENTATION_VERT;
    
    MyTableRowLayout *rowView = [MyTableRowLayout rowWith:rowHeight colWidth:colWidth orientation:ori];
    [super insertSubview:rowView atIndex:rowIndex];
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
    
    //colWidth为0表示均分宽度，为-1表示由子视图决定宽度，大于0表示固定宽度。
    if (rowView.colWidth == 0)
        colView.weight = 1;
    else if (rowView.colWidth > 0)
    {
        if (rowView.orientation == LVORIENTATION_HORZ)
            colView.width = rowView.colWidth;
        else
            colView.height = rowView.colWidth;
    }
    
    if (rowView.orientation == LVORIENTATION_HORZ)
    {
        if (colView.frame.size.height == 0 && colView.heightDime.dimeVal == nil)
        {
            colView.heightDime.equalTo(rowView.heightDime);
        }
    }
    else
    {
        if (colView.frame.size.width == 0 && colView.widthDime.dimeVal == nil)
        {
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


#pragma mark -- Private Method

- (void)calcScrollViewContentSize:(CGRect)oldRect autoAdjustSize:(BOOL)autoAdjustSize
{
    if (self.adjustScrollViewContentSize && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrolv = (UIScrollView*)self.superview;
        CGRect newRect = self.frame;
        
        CGSize contsize = scrolv.contentSize;
        
        if (newRect.size.height != oldRect.size.height)
        {
            contsize.height = newRect.size.height;
            
        }
        
        if(newRect.size.width != oldRect.size.width)
        {
            contsize.width = newRect.size.width;
            
        }
        
        scrolv.contentSize = contsize;

    }
}




//不能直接调用如下的函数。
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    NSAssert(0, @"Can't call insertSubview");
}

- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2
{
    NSAssert(0, @"Can't call exchangeSubviewAtIndex");
}

- (void)addSubview:(UIView *)view
{
    NSAssert(0, @"Can't call addSubview");
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
{
    NSAssert(0, @"Can't call insertSubview");
}
- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
{
    NSAssert(0, @"Can't call insertSubview");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  YSTableLayout.m
//  YSLayout
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "YSTableLayout.h"
#import "YSLayoutInner.h"



@interface YSTableRowLayout : YSLinearLayout


+(id)rowWith:(CGFloat)rowHeight colWidth:(CGFloat)colWidth orientation:(YSLayoutViewOrientation)orientation;

@property(nonatomic,assign, readonly) CGFloat rowHeight;
@property(nonatomic,assign, readonly) CGFloat colWidth;

@end

@implementation YSTableRowLayout
{
   CGFloat _rowHeight;
   CGFloat _colWidth;
}

-(id)initWith:(CGFloat)rowHeight colWidth:(CGFloat)colWidth orientation:(YSLayoutViewOrientation)orientation
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
            if (orientation == YSLayoutViewOrientation_Horz)
                self.ysHeight = rowHeight;
            else
                self.ysWidth = rowHeight;
        }
        else
        {
            if (orientation == YSLayoutViewOrientation_Horz)
                self.wrapContentHeight = YES;
            else
                self.wrapContentWidth = YES;
        }
        
        if (colWidth == 0)
        {
            if (orientation == YSLayoutViewOrientation_Horz)
            {
                self.wrapContentWidth = NO;
                self.ysLeftMargin = self.ysRightMargin = 0;
            }
            else
            {
                self.wrapContentHeight = NO;
                self.ysTopMargin = self.ysBottomMargin = 0;
            }
            
        }
        else if (colWidth == -2)
        {
            if (orientation == YSLayoutViewOrientation_Horz)
            {
                self.wrapContentWidth = NO;
                self.ysLeftMargin = self.ysRightMargin = 0;
            }
            else
            {
                self.wrapContentHeight = NO;
                self.ysTopMargin = self.ysBottomMargin = 0;
            }
        }
    }
    
    return self;
}

+(id)rowWith:(CGFloat)rowHeight colWidth:(CGFloat)colWidth orientation:(YSLayoutViewOrientation)orientation
{
    return [[self alloc] initWith:rowHeight colWidth:colWidth orientation:orientation];
}


@end


@implementation NSIndexPath(YSTableLayoutEx)

+(instancetype)indexPathForCol:(NSInteger)col inRow:(NSInteger)row
{
    return [self indexPathForRow:row inSection:col];
}

-(NSInteger)col
{
    return self.section;
}

@end


@implementation YSTableLayout

+(id)tableLayoutWithOrientation:(YSLayoutViewOrientation)orientation
{
    return [self linearLayoutWithOrientation:orientation];
}


-(void)addRow:(CGFloat)rowHeight colWidth:(CGFloat)colWidth
{
    [self insertRow:rowHeight colWidth:colWidth atIndex:self.countOfRow];
}

-(void)insertRow:(CGFloat)rowHeight colWidth:(CGFloat)colWidth atIndex:(NSInteger)rowIndex
{
    YSLayoutViewOrientation ori = 0;
    if (self.orientation == YSLayoutViewOrientation_Vert)
        ori = YSLayoutViewOrientation_Horz;
    else
        ori = YSLayoutViewOrientation_Vert;
    
    YSTableRowLayout *rowView = [YSTableRowLayout rowWith:rowHeight colWidth:colWidth orientation:ori];
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

-(YSLinearLayout*)viewAtRowIndex:(NSInteger)rowIndex;
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
    YSTableRowLayout *rowView = (YSTableRowLayout*)[self viewAtRowIndex:indexPath.row];
    
    //colWidth为0表示均分宽度，为-1表示由子视图决定宽度，大于0表示固定宽度。
    if (rowView.colWidth == 0)
        colView.weight = 1;
    else if (rowView.colWidth > 0)
    {
        if (rowView.orientation == YSLayoutViewOrientation_Horz)
            colView.ysWidth = rowView.colWidth;
        else
            colView.ysHeight = rowView.colWidth;
    }
    
    if (rowView.orientation == YSLayoutViewOrientation_Horz)
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
    NSAssert(0, @"Can't call insertSubview");
}

- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2
{
    NSAssert(0, @"Can't call exchangeSubviewAtIndex");
}

- (void)addSubview:(UIView *)view
{
    [self addCol:view atRow:[self countOfRow] - 1];
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

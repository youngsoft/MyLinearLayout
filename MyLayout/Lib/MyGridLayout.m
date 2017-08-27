//
//  MyGridLayout.m
//  MyLayout
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyGridLayout.h"
#import "MyLayoutInner.h"
#import "MyGridNode.h"

 NSString * const kMyGridRows = @"rows";
 NSString * const kMyGridCols = @"cols";
 NSString * const kMyGridSize = @"size";
 NSString * const kMyGridPadding = @"padding";
 NSString * const kMyGridSpace = @"space";
 NSString * const kMyGridGravity = @"gravity";
 NSString * const kMyGridTopBorderline = @"top-borderline";
 NSString * const kMyGridBottomBorderline = @"bottom-borderline";
 NSString * const kMyGridLeftBorderline = @"left-borderline";
 NSString * const kMyGridRightBorderline = @"right-borderline";

 NSString * const kMyGridBorderlineColor = @"color";
 NSString * const kMyGridBorderlineThick = @"thick";
 NSString * const kMyGridBorderlineHeadIndent = @"head";
 NSString * const kMyGridBorderlineTailIndent = @"tail";
 NSString * const kMyGridBorderlineOffset = @"offset";


 NSString * const vMyGridSizeWrap = @"wrap";
 NSString * const vMyGridSizeFill = @"fill";


 NSString * const vMyGridGravityTop = @"top";
 NSString * const vMyGridGravityBottom = @"bottom";
 NSString * const vMyGridGravityLeft = @"left";
 NSString * const vMyGridGravityRight = @"right";
 NSString * const vMyGridGravityCenterX = @"centerX";
 NSString * const vMyGridGravityCenterY = @"centerY";
 NSString * const vMyGridGravityWidthFill = @"width";
 NSString * const vMyGridGravityHeightFill = @"height";


@interface MyGridLayout()<MyGridNode>

@property(nonatomic, weak) MyGridLayoutViewSizeClass *lastSizeClass;

@end


@implementation MyGridLayout

#pragma mark -- Public Method


//删除所有子栅格
-(void)removeGrids
{
    [self removeGridsIn:MySizeClass_hAny | MySizeClass_wAny];
}

-(void)removeGridsIn:(MySizeClass)sizeClass
{
    id<MyGridNode> lsc = (id<MyGridNode>)[self fetchLayoutSizeClass:sizeClass];
    [lsc.subGrids removeAllObjects];
    lsc.subGridsType = MySubGridsType_Unknown;
}


#pragma mark -- MyGrid
//添加行。返回新的栅格。
-(id<MyGrid>)addRow:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列。返回新的栅格。
-(id<MyGrid>)addCol:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addCol:measure];
    node.superGrid = self;
    return node;
}

-(id<MyGrid>)addRowGrid:(id<MyGrid>)grid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addRowGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<MyGrid>)addColGrid:(id<MyGrid>)grid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addColGrid:grid];
    node.superGrid = self;
    return node;
}


-(id<MyGrid>)cloneGrid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc cloneGrid];
}

-(void)removeFromSuperGrid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc removeFromSuperGrid];
    
}

-(id<MyGrid>)superGrid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;

    return lsc.superGrid;
}

-(void)setSuperGrid:(id<MyGridNode>)superGrid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.superGrid = superGrid;
}

-(NSDictionary*)gridDictionary
{
    return nil;
}

-(void)setGridDictionary:(NSDictionary *)gridDictionary
{
    
}

#pragma mark -- MyGridNode


-(NSMutableArray<id<MyGridNode>> *)subGrids
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return (NSMutableArray<id<MyGridNode>> *)(lsc.subGrids);
}

-(void)setSubGrids:(NSMutableArray<id<MyGridNode>> *)subGrids
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.subGrids = subGrids;
}

-(MySubGridsType)subGridsType
{
    MyGridLayout *lsc = self.myCurrentSizeClass;

    return lsc.subGridsType;
}

-(void)setSubGridsType:(MySubGridsType)subGridsType
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.subGridsType = subGridsType;
}

-(CGFloat)gridMeasure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return lsc.gridMeasure;
}

-(void)setGridMeasure:(CGFloat)gridMeasure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.gridMeasure = gridMeasure;
}

-(CGSize)gridSize
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return lsc.gridSize;
}

-(void)setGridSize:(CGSize)gridSize
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.gridSize = gridSize;
}

//更新格子尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

-(CALayer*)gridLayoutLayer
{
    return self.layer;
}


-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    [lsc setBorderlineNeedLayoutIn:rect withLayer:layer];

}

-(void)showBorderline:(BOOL)show
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    [lsc showBorderline:show];

}


#pragma mark -- Override Method

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    
    MyFrame *myFrame = self.myFrame;
    
    MyGridLayout *lsc =  [self myCurrentSizeClassFrom:myFrame];
    
    //只有在非评估，并且当sizeclass的数量大于1个，并且当前的sizeclass和lastSizeClass不一致的时候
    if (!isEstimate && myFrame.multiple)
    {
        //将子栅格中的layer隐藏。
        if (self.lastSizeClass != nil && ((MyGridLayoutViewSizeClass*)lsc) != self.lastSizeClass)
            [((id<MyGridNode>)self.lastSizeClass) showBorderline:NO];
        
        self.lastSizeClass = (MyGridLayoutViewSizeClass*)lsc;
    }
    
    
    //设置根格子的rect为布局视图的大小。
    lsc.gridSize = selfSize;
    
    //遍历尺寸
    CGFloat selfMeasure = [self myTraversalGridSize:lsc gridSize:selfSize];
    if (lsc.wrapContentHeight)
    {
        selfSize.height =  selfMeasure;
    }
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = selfMeasure;
    }
    
    //遍历位置。
    [self myTraversalGridOrigin:lsc gridOrigin:CGPointMake(0, 0) lsc:lsc sbvEnumerator:sbs.objectEnumerator isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    
    
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    [self myAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [MyGridLayoutViewSizeClass new];
}

//遍历位置
-(void)myTraversalGridOrigin:(id<MyGridNode>)grid  gridOrigin:(CGPoint)gridOrigin lsc:(MyGridLayout*)lsc sbvEnumerator:(NSEnumerator<UIView*>*)sbvEnumerator isEstimate:(BOOL)isEstimate sizeClass:(MySizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout
{
    //这要优化减少不必要的空数组的建立。。
    NSArray<id<MyGridNode>> * subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown)
         subGrids = grid.subGrids;

    //绘制边界线。。
    if (!isEstimate)
    {
        [grid setBorderlineNeedLayoutIn:CGRectMake(gridOrigin.x, gridOrigin.y, grid.gridSize.width, grid.gridSize.height) withLayer:self.layer];
    }
    
    //处理叶子节点。
    if (subGrids.count == 0)
    {
        //设置子视图的位置和尺寸。。
        UIView *sbv = sbvEnumerator.nextObject;
        if (sbv != nil)
        {
            //调整位置和尺寸。。。
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
            
            //取垂直和水平对齐
            MyGravity vertGravity = grid.gravity & MyGravity_Horz_Mask;
            if (vertGravity == MyGravity_None)
                vertGravity = MyGravity_Vert_Fill;
            
            MyGravity horzGravity = grid.gravity & MyGravity_Vert_Mask;
            if (horzGravity == MyGravity_None)
                horzGravity = MyGravity_Horz_Fill;
            
            CGFloat paddingTop = grid.padding.top;
            CGFloat paddingLeading = [MyBaseLayout isRTL] ? grid.padding.right : grid.padding.left;
            CGFloat paddingBottom = grid.padding.bottom;
            CGFloat paddingTrailing = [MyBaseLayout isRTL] ? grid.padding.left : grid.padding.right;
            
            [self myAdjustSubviewWrapContentSet:sbv isEstimate:isEstimate sbvmyFrame:sbvmyFrame sbvsc:sbvsc selfSize:grid.gridSize sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
            
            
            [self myCalcSubViewRect:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame lsc:lsc vertGravity:vertGravity horzGravity:horzGravity inSelfSize:grid.gridSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:NULL];
            
            sbvmyFrame.leading += gridOrigin.x;
            sbvmyFrame.top += gridOrigin.y;
            
        }
        else
            return;
    }



    //处理子格子的位置。
    
    CGFloat offset = 0;
    if (grid.subGridsType == MySubGridsType_Col)
        offset = gridOrigin.x + grid.padding.left;
    else if (grid.subGridsType == MySubGridsType_Row)
        offset = gridOrigin.y + grid.padding.top;
    else;

    for (id<MyGridNode> sbvGrid in subGrids)
    {
     
        CGPoint sbvGridOrigin;
        if (grid.subGridsType == MySubGridsType_Col)
        {
            sbvGridOrigin.x = offset;
            sbvGridOrigin.y = gridOrigin.y + grid.padding.top;
            offset += sbvGrid.gridSize.width;
        }
        else if (grid.subGridsType == MySubGridsType_Row)
        {
            sbvGridOrigin.x = gridOrigin.x + grid.padding.left;
            sbvGridOrigin.y = offset;
            
            offset += sbvGrid.gridSize.height;
        }
        else
        {
            sbvGridOrigin = CGPointZero;
        }
        
        offset += grid.subviewSpace;
        
        [self myTraversalGridOrigin:sbvGrid gridOrigin:sbvGridOrigin lsc:lsc sbvEnumerator:sbvEnumerator isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    }
}

//遍历尺寸。
-(CGFloat)myTraversalGridSize:(id<MyGridNode>)grid gridSize:(CGSize)gridSize
{
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown)
         subGrids = grid.subGrids;

    CGFloat fixedMeasure = 0;  //固定部分的尺寸
    CGFloat validMeasure = 0;  //整体有效的尺寸
    if (subGrids.count > 1)
        fixedMeasure += (subGrids.count - 1) * grid.subviewSpace;
    
    if (grid.subGridsType == MySubGridsType_Col)
    {
        fixedMeasure += grid.padding.left + grid.padding.right;
        validMeasure = grid.gridSize.width - fixedMeasure;
    }
    else if(grid.subGridsType == MySubGridsType_Row)
    {
        fixedMeasure += grid.padding.top + grid.padding.bottom;
        validMeasure = grid.gridSize.height - fixedMeasure;
    }
    else;

    
    NSMutableArray<id<MyGridNode>> *weightSubGrids = [NSMutableArray new];  //比重尺寸子格子数组
    NSMutableArray<id<MyGridNode>> *fillSubGrids = [NSMutableArray new];    //填充尺寸格子数组
    
    for (id<MyGridNode> sbvGrid in subGrids)
    {
        if (sbvGrid.gridMeasure == MyLayoutSize.wrap)
        {
            //包裹尺寸先遍历所有子格子
            CGFloat gridMeasure = [self myTraversalGridSize:sbvGrid gridSize:gridSize];
            fixedMeasure += [sbvGrid updateGridSize:gridSize superGrid:grid  withMeasure:gridMeasure];
            
        }
        else if (sbvGrid.gridMeasure >= 1)
        {
            fixedMeasure += [sbvGrid updateGridSize:gridSize superGrid:grid withMeasure:sbvGrid.gridMeasure];
            
            //遍历儿子节点。。
            [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridSize];
            
        }
        else if (sbvGrid.gridMeasure > 0 && sbvGrid.gridMeasure < 1)
        {
            fixedMeasure += [sbvGrid updateGridSize:gridSize superGrid:grid withMeasure:validMeasure * sbvGrid.gridMeasure];
            
            //遍历儿子节点。。
            [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridSize];

        }
        else if (sbvGrid.gridMeasure < 0 && sbvGrid.gridMeasure > -1)
        {
            [weightSubGrids addObject:sbvGrid];
        }
        else if (sbvGrid.gridMeasure == MyLayoutSize.fill)
        {
            [fillSubGrids addObject:sbvGrid];
        }
        else
        {
            NSAssert(0, @"oops!");
        }
    }
    
    
    //算出剩余的尺寸。
    CGFloat remainedMeasure = 0;
    if (grid.subGridsType == MySubGridsType_Col)
    {
        remainedMeasure = grid.gridSize.width - fixedMeasure;
    }
    else if (grid.subGridsType == MySubGridsType_Row)
    {
        remainedMeasure = grid.gridSize.height - fixedMeasure;
    }
    else;
    
    if (weightSubGrids.count > 0)
    {
        for (id<MyGridNode> sbvGrid in weightSubGrids)
        {
            remainedMeasure -= [sbvGrid updateGridSize:gridSize superGrid:grid withMeasure:-1 * remainedMeasure * sbvGrid.gridMeasure];
            [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridSize];
        }
    }
    
    if (fillSubGrids.count > 0)
    {
       CGFloat averageMeasure = remainedMeasure / fillSubGrids.count;
        
        for (id<MyGridNode> sbvGrid in fillSubGrids)
        {
            [sbvGrid updateGridSize:gridSize superGrid:grid withMeasure:averageMeasure];
            [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridSize];
        }
    }
    
    return fixedMeasure;
}


@end

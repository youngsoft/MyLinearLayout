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

 NSString * const kMyGridTag = @"tag";
 NSString * const kMyGridAction = @"action";
 NSString * const kMyGridActionData = @"action-data";
 NSString * const kMyGridRows = @"rows";
 NSString * const kMyGridCols = @"cols";
 NSString * const kMyGridSize = @"size";
 NSString * const kMyGridPadding = @"padding";
 NSString * const kMyGridSpace = @"space";
 NSString * const kMyGridGravity = @"gravity";
 NSString * const kMyGridPlaceholder = @"placeholder";
 NSString * const kMyGridAnchor = @"anchor";
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

-(id)actionData
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return lsc.actionData;
}

-(void)setActionData:(id)actionData
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.actionData = actionData;
}

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

-(BOOL)placeholder
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    
    return lsc.placeholder;
}

-(void)setPlaceholder:(BOOL)placeholder
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.placeholder = placeholder;
}

-(BOOL)anchor
{
    
    MyGridLayout *lsc = self.myCurrentSizeClass;
    
    return lsc.anchor;
}

-(void)setAnchor:(BOOL)anchor
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.anchor = anchor;
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

-(CGRect)gridRect
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return lsc.gridRect;
}

-(void)setGridRect:(CGRect)gridRect
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.gridRect = gridRect;
}

//更新格子尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<MyGridNode>)superGrid withOffset:(CGFloat)offset
{
    MyGridLayout *lsc = self.myCurrentSizeClass;

    return [lsc updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}



-(UIView*)gridLayoutView
{
    return self;
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

-(id<MyGridNode>)gridhitTest:(CGPoint *)pt
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc gridhitTest:pt];
}


#pragma mark -- Touches Event

-(id<MyGridNode>)myBestHitGrid:(NSSet *)touches
{
    MySizeClass sizeClass = [self myGetGlobalSizeClass];
    id<MyGridNode> bestSC = (id<MyGridNode>)[self myBestSizeClass:sizeClass];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return  [bestSC gridhitTest:&point];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [[self myBestHitGrid:touches] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myBestHitGrid:touches] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myBestHitGrid:touches] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myBestHitGrid:touches] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
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
    lsc.gridRect = CGRectMake(0, 0, selfSize.width, selfSize.height);
    
    //遍历尺寸
    NSInteger index = 0;
    CGFloat selfMeasure = [self myTraversalGridSize:lsc gridSize:selfSize lsc:lsc sbs:sbs pIndex:&index];
    if (lsc.wrapContentHeight)
    {
        selfSize.height =  selfMeasure;
    }
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = selfMeasure;
    }
    
    //遍历位置。
    NSEnumerator<UIView*> *enumerator = sbs.objectEnumerator;
    [self myTraversalGridOrigin:lsc gridOrigin:CGPointMake(0, 0) lsc:lsc sbvEnumerator:enumerator isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    
    
    //处理那些剩余没有放入格子的子视图的frame设置为0
    for (UIView *sbv = enumerator.nextObject; sbv; sbv = enumerator.nextObject)
    {
        sbv.myFrame.frame = CGRectZero;
    }
    
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    [self myAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [MyGridLayoutViewSizeClass new];
}

#pragma mark -- Private Method

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
        [grid setBorderlineNeedLayoutIn:grid.gridRect withLayer:self.layer];
    }
    
    //处理叶子节点。
    if (grid.anchor || (subGrids.count == 0 && !grid.placeholder))
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
            
            [self myAdjustSubviewWrapContentSet:sbv isEstimate:isEstimate sbvmyFrame:sbvmyFrame sbvsc:sbvsc selfSize:grid.gridRect.size sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
            
            
            [self myCalcSubViewRect:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame lsc:lsc vertGravity:vertGravity horzGravity:horzGravity inSelfSize:grid.gridRect.size paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:NULL];
            
            sbvmyFrame.leading += gridOrigin.x;
            sbvmyFrame.top += gridOrigin.y;
            
        }
    }



    //处理子格子的位置。
    
    CGFloat offset = 0;
    if (grid.subGridsType == MySubGridsType_Col)
    {
        offset = gridOrigin.x + grid.padding.left;
        
        MyGravity horzGravity = grid.gravity & MyGravity_Vert_Mask;
        if (horzGravity == MyGravity_Horz_Center || horzGravity == MyGravity_Horz_Right)
        {
            //得出所有子栅格的宽度综合
            CGFloat subGridsWidth = 0;
            for (id<MyGridNode> sbvGrid in subGrids)
            {
                subGridsWidth += sbvGrid.gridRect.size.width;
            }
            
            if (subGrids.count > 1)
                subGridsWidth += grid.subviewSpace * (subGrids.count - 1);

            
            if (horzGravity == MyGravity_Horz_Center)
            {
                offset += (grid.gridRect.size.width - grid.padding.left - grid.padding.right - subGridsWidth)/2;
            }
            else
            {
                offset += grid.gridRect.size.width - grid.padding.left - grid.padding.right - subGridsWidth;
            }
        }
        
        
    }
    else if (grid.subGridsType == MySubGridsType_Row)
    {
        offset = gridOrigin.y + grid.padding.top;
        
        MyGravity vertGravity = grid.gravity & MyGravity_Horz_Mask;
        if (vertGravity == MyGravity_Vert_Center || vertGravity == MyGravity_Vert_Bottom)
        {
            //得出所有子栅格的宽度综合
            CGFloat subGridsHeight = 0;
            for (id<MyGridNode> sbvGrid in subGrids)
            {
                subGridsHeight += sbvGrid.gridRect.size.height;
            }
            
            if (subGrids.count > 1)
                subGridsHeight += grid.subviewSpace * (subGrids.count - 1);
            
            if (vertGravity == MyGravity_Vert_Center)
            {
                offset += (grid.gridRect.size.height - grid.padding.top - grid.padding.bottom - subGridsHeight)/2;
            }
            else
            {
                offset += grid.gridRect.size.height - grid.padding.top - grid.padding.bottom - subGridsHeight;
            }
        }
        
    }
    else
    {
        
    }
    
    

    for (id<MyGridNode> sbvGrid in subGrids)
    {
        offset += [sbvGrid updateGridOrigin:gridOrigin superGrid:grid withOffset:offset];
        offset += grid.subviewSpace;
        [self myTraversalGridOrigin:sbvGrid gridOrigin:sbvGrid.gridRect.origin lsc:lsc sbvEnumerator:sbvEnumerator isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    }
}

-(void)myBlankTraverse:(id<MyGridNode>)grid sbs:(NSArray<UIView*>*)sbs pIndex:(NSInteger*)pIndex
{
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown)
        subGrids = grid.subGrids;
    
    if (grid.anchor || (subGrids.count == 0 && !grid.placeholder))
    {
        *pIndex = *pIndex + 1;
    }
    
    for (id<MyGridNode> sbvGrid in subGrids)
    {
        [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex];
    }
}

//遍历尺寸。
-(CGFloat)myTraversalGridSize:(id<MyGridNode>)grid gridSize:(CGSize)gridSize lsc:(MyGridLayout*)lsc sbs:(NSArray<UIView*>*)sbs pIndex:(NSInteger*)pIndex
{
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown)
         subGrids = grid.subGrids;

    UIEdgeInsets padding = grid.padding;
    CGFloat fixedMeasure = 0;  //固定部分的尺寸
    CGFloat validMeasure = 0;  //整体有效的尺寸
    if (subGrids.count > 1)
        fixedMeasure += (subGrids.count - 1) * grid.subviewSpace;
    
    if (grid.subGridsType == MySubGridsType_Col)
    {
        fixedMeasure += padding.left + padding.right;
        validMeasure = grid.gridRect.size.width - fixedMeasure;
    }
    else if(grid.subGridsType == MySubGridsType_Row)
    {
        fixedMeasure += padding.top + padding.bottom;
        validMeasure = grid.gridRect.size.height - fixedMeasure;
    }
    else;
    
    //叶子节点
    if (grid.anchor || (subGrids.count == 0 && !grid.placeholder))
    {
        //如果尺寸是包裹
        if (grid.gridMeasure == MyLayoutSize.wrap)
        {
            if (*pIndex < sbs.count)
            {
                //加这个条件是根栅格如果是叶子栅格的话不处理这种情况。
                if (grid.superGrid != nil)
                {
                    UIView *sbv = sbs[*pIndex];
                    
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
                    sbvmyFrame.frame = sbv.bounds;

                    //如果子视图不设置任何约束但是又是包裹的则这里特殊处理。
                    if (sbvsc.widthSizeInner == nil && sbvsc.heightSizeInner == nil && !sbvsc.wrapContentSize)
                    {
                        CGSize size = CGSizeZero;
                        if (grid.superGrid.subGridsType == MySubGridsType_Row)
                        {
                            size.width = gridSize.width - padding.left - padding.right;
                        }
                        else
                        {
                            size.height = gridSize.height - padding.top - padding.bottom;
                        }
                        
                        size = [sbv sizeThatFits:size];
                        sbvmyFrame.width = size.width;
                        sbvmyFrame.height = size.height;
                    }
                    else
                    {
                        
                        [self myCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame];
                        
                        [self myCalcSubViewRect:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame lsc:lsc vertGravity:MyGravity_None horzGravity:MyGravity_None inSelfSize:grid.gridRect.size paddingTop:padding.top paddingLeading:padding.left paddingBottom:padding.bottom paddingTrailing:padding.right pMaxWrapSize:NULL];
                    }

                    if (grid.superGrid.subGridsType == MySubGridsType_Row)
                    {
                        fixedMeasure = padding.top + padding.bottom + sbvmyFrame.height;
                    }
                    else
                    {
                        fixedMeasure = padding.left + padding.right + sbvmyFrame.width;
                    }
                }
            }
        }
        
        //索引加1跳转到下一个节点。
        *pIndex = *pIndex + 1;
    }

    
    NSMutableArray<id<MyGridNode>> *weightSubGrids = [NSMutableArray new];  //比重尺寸子格子数组
    NSMutableArray<NSNumber*> *weightSubGridsIndexs = [NSMutableArray new]; //比重尺寸格子的开头子视图位置索引
    
    NSMutableArray<id<MyGridNode>> *fillSubGrids = [NSMutableArray new];    //填充尺寸格子数组
    NSMutableArray<NSNumber*> *fillSubGridsIndexs = [NSMutableArray new];   //填充尺寸格子的开头子视图位置索引
    
    //包裹尺寸先遍历所有子格子
    CGSize gridSize2 = gridSize;
    if (grid.subGridsType == MySubGridsType_Row)
    {
        gridSize2.width -= (padding.left + padding.right);
    }
    else
    {
        gridSize2.height -= (padding.top + padding.bottom);
    }

    for (id<MyGridNode> sbvGrid in subGrids)
    {
        if (sbvGrid.gridMeasure == MyLayoutSize.wrap)
        {
            
            CGFloat gridMeasure = [self myTraversalGridSize:sbvGrid gridSize:gridSize2 lsc:lsc sbs:sbs pIndex:pIndex];
            fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid  withMeasure:gridMeasure];
            
        }
        else if (sbvGrid.gridMeasure >= 1)
        {
            fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:sbvGrid.gridMeasure];
            
            //遍历儿子节点。。
            [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex];
            
        }
        else if (sbvGrid.gridMeasure > 0 && sbvGrid.gridMeasure < 1)
        {
            fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:validMeasure * sbvGrid.gridMeasure];
            
            //遍历儿子节点。。
            [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex];

        }
        else if (sbvGrid.gridMeasure < 0 && sbvGrid.gridMeasure > -1)
        {
            [weightSubGrids addObject:sbvGrid];
            [weightSubGridsIndexs addObject:@(*pIndex)];
            
            //这里面空转一下。
            [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex];

            
        }
        else if (sbvGrid.gridMeasure == MyLayoutSize.fill)
        {
            [fillSubGrids addObject:sbvGrid];
            
            [fillSubGridsIndexs addObject:@(*pIndex)];
            
            //这里面空转一下。
            [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex];
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
        remainedMeasure = grid.gridRect.size.width - fixedMeasure;
    }
    else if (grid.subGridsType == MySubGridsType_Row)
    {
        remainedMeasure = grid.gridRect.size.height - fixedMeasure;
    }
    else;
    
    NSInteger weightSubGridCount = weightSubGrids.count;
    if (weightSubGridCount > 0)
    {
        for (NSInteger i = 0; i < weightSubGridCount; i++)
        {
            id<MyGridNode> sbvGrid = weightSubGrids[i];
            remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:-1 * remainedMeasure * sbvGrid.gridMeasure];
            
            NSInteger index = weightSubGridsIndexs[i].integerValue;
            [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index];
        }
    }
    
    NSInteger fillSubGridsCount = fillSubGrids.count;
    if (fillSubGridsCount > 0)
    {
        NSInteger totalCount = fillSubGridsCount;
        for (NSInteger i = 0; i < fillSubGridsCount; i++)
        {
            id<MyGridNode> sbvGrid = fillSubGrids[i];
           remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:_myCGFloatRound(remainedMeasure * (1.0/totalCount))];
            totalCount -= 1;
            
            NSInteger index = fillSubGridsIndexs[i].integerValue;
            [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index];
        }
    }
    
    return fixedMeasure;
}


@end

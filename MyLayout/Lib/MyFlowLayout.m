//
//  MyFlowLayout.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyFlowLayout.h"
#import "MyLayoutInner.h"


@implementation MyFlowLayout


-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.myCurrentSizeClass.orientation = orientation;
        self.myCurrentSizeClass.arrangedCount = arrangedCount;
    }
    
    return  self;
}

-(instancetype)initWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    return [self initWithFrame:CGRectZero orientation:orientation arrangedCount:arrangedCount];
}


+(instancetype)flowLayoutWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    MyFlowLayout *layout = [[[self class] alloc] initWithOrientation:orientation arrangedCount:arrangedCount];
    return layout;
}

-(void)setOrientation:(MyOrientation)orientation
{
     MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.orientation != orientation)
    {
        lsc.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(MyOrientation)orientation
{
    return self.myCurrentSizeClass.orientation;
}


-(void)setArrangedCount:(NSInteger)arrangedCount
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.arrangedCount != arrangedCount)
    {
        lsc.arrangedCount = arrangedCount;
        [self setNeedsLayout];
    }
}

-(NSInteger)arrangedCount
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    return lsc.arrangedCount;
}


-(NSInteger)pagedCount
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    return lsc.pagedCount;
}

-(void)setPagedCount:(NSInteger)pagedCount
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.pagedCount != pagedCount)
    {
        lsc.pagedCount = pagedCount;
        [self setNeedsLayout];
    }
}


-(void)setAutoArrange:(BOOL)autoArrange
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.autoArrange != autoArrange)
    {
        lsc.autoArrange = autoArrange;
        [self setNeedsLayout];
    }
}

-(BOOL)autoArrange
{
    return self.myCurrentSizeClass.autoArrange;
}


-(void)setArrangedGravity:(MyGravity)arrangedGravity
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.arrangedGravity != arrangedGravity)
    {
        lsc.arrangedGravity = arrangedGravity;
        [self setNeedsLayout];
    }
}

-(MyGravity)arrangedGravity
{
    return self.myCurrentSizeClass.arrangedGravity;
}


-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace
{
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass
{
    MyFlowLayoutViewSizeClass *lsc = (MyFlowLayoutViewSizeClass*)[self fetchLayoutSizeClass:sizeClass];
    lsc.subviewSize = subviewSize;
    lsc.maxSpace = maxSpace;
    lsc.minSpace = minSpace;
    [self setNeedsLayout];
}

#pragma mark -- Deprecated Method


-(void)setAverageArrange:(BOOL)averageArrange
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.orientation == MyOrientation_Vert)
    {
        if (averageArrange)
            lsc.gravity = (lsc.gravity & MyGravity_Horz_Mask) | MyGravity_Horz_Fill;
        else
            lsc.gravity = (lsc.gravity & MyGravity_Horz_Mask) | MyGravity_None;
    }
    else
    {
        if (averageArrange)
            lsc.gravity = (lsc.gravity & MyGravity_Vert_Mask) | MyGravity_Vert_Fill;
        else
            lsc.gravity = (lsc.gravity & MyGravity_Vert_Mask) | MyGravity_None;
    }
    
}

-(BOOL)averageArrange
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;

    if (lsc.orientation == MyOrientation_Vert)
        return (lsc.gravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill;
    else
        return (lsc.gravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill;
}


#pragma mark -- Override Method

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    
    MyOrientation orientation = lsc.orientation;
    MyGravity gravity = lsc.gravity;
    MyGravity arrangedGravity = lsc.arrangedGravity;
    
    for (UIView *sbv in sbs)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        if (!isEstimate)
        {
            sbvmyFrame.frame = sbv.bounds;
            [self myCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame selfLayoutSize:selfSize];
        }
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            if (sbvsc.wrapContentWidth)
            {
                if (sbvsc.widthSizeInner.dimeVal != nil ||
                    (orientation == MyOrientation_Horz && (arrangedGravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill) ||
                    (orientation == MyOrientation_Vert && ((gravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill || sbvsc.weight != 0)))
                {
                    sbvsc.wrapContentWidth = NO;
                }
            }
            
            if (sbvsc.wrapContentHeight)
            {
                if (sbvsc.heightSizeInner.dimeVal != nil ||
                    (orientation == MyOrientation_Vert && (arrangedGravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill) ||
                    (orientation == MyOrientation_Horz && ((gravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill || sbvsc.weight != 0)))
                {
                    sbvsc.wrapContentHeight = NO;
                }
            }

            
            BOOL isSbvWrap = sbvsc.wrapContentHeight || sbvsc.wrapContentWidth;

            if (pHasSubLayout != nil && isSbvWrap)
                *pHasSubLayout = YES;
            
            if (isEstimate && isSbvWrap)
            {
                [(MyBaseLayout*)sbv estimateLayoutRect:sbvmyFrame.frame.size inSizeClass:sizeClass];
                if (sbvmyFrame.multiple)
                {
                    sbvmyFrame.sizeClass = [sbv myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    sbvsc = sbvmyFrame.sizeClass;
                }
            }
        }
    }

    
    
    if (orientation == MyOrientation_Vert)
    {
        if (lsc.arrangedCount == 0)
            selfSize = [self myLayoutSubviewsForVertContent:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
        else
            selfSize = [self myLayoutSubviewsForVert:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    }
    else
    {
        if (lsc.arrangedCount == 0)
            selfSize = [self myLayoutSubviewsForHorzContent:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
        else
            selfSize = [self myLayoutSubviewsForHorz:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    }
    
    //调整布局视图自己的尺寸。
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    //如果是反向则调整所有子视图的左右位置。
    [self myAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [MyFlowLayoutViewSizeClass new];
}

#pragma mark -- Private Method


- (void)myCalcVertLayoutSinglelineWeight:(CGSize)selfSize totalFloatWidth:(CGFloat)totalFloatWidth totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.weight != 0)
        {
            CGFloat tempWidth = (totalFloatWidth * sbvsc.weight / totalWeight);
            if (sbvsc.widthSizeInner != nil)
                tempWidth = [sbvsc.widthSizeInner measureWith:tempWidth];
            
            sbvmyFrame.width =  [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:tempWidth sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
        }
    }
}

- (void)myCalcHorzLayoutSinglelineWeight:(CGSize)selfSize totalFloatHeight:(CGFloat)totalFloatHeight totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.weight != 0)
        {
            CGFloat tempHeight = (totalFloatHeight * sbvsc.weight / totalWeight);
            if (sbvsc.heightSizeInner != nil)
                tempHeight = [sbvsc.heightSizeInner measureWith:tempHeight];
            
            sbvmyFrame.height =  [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:tempHeight sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: sbvmyFrame.height ] sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
    }
}



- (void)myCalcVertLayoutSinglelineAlignment:(CGSize)selfSize rowMaxHeight:(CGFloat)rowMaxHeight rowMaxWidth:(CGFloat)rowMaxWidth horzGravity:(MyGravity)horzGravity vertAlignment:(MyGravity)vertAlignment sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertSpace:(CGFloat)vertSpace horzSpace:(CGFloat)horzSpace isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{
    
    CGFloat paddingLeading = lsc.leadingPadding;
    CGFloat paddingTrailing = lsc.trailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
 
    CGFloat addXPos = 0; //多出来的空隙区域，用于停靠处理。
    CGFloat addXFill = 0;  //多出来的平均区域，用于拉伸间距或者尺寸
    BOOL averageArrange = (horzGravity == MyGravity_Horz_Fill);
    
    if (!averageArrange || lsc.arrangedCount == 0)
    {
        switch (horzGravity) {
            case MyGravity_Horz_Center:
            {
                addXPos = (selfSize.width - paddingHorz - rowMaxWidth) / 2;
            }
                break;
            case MyGravity_Horz_Trailing:
            {
                addXPos = selfSize.width - paddingHorz - rowMaxWidth; //因为具有不考虑左边距，而原来的位置增加了左边距，因此
            }
                break;
            case MyGravity_Horz_Between:
            {
                //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效(如果最后一行的数量和其他行的数量一样除外)。
                if ((startIndex != sbs.count || count == lsc.arrangedCount) && count > 1)
                {
                    addXFill = (selfSize.width - paddingHorz - rowMaxWidth) / (count - 1);
                }
            }
                break;
            default:
                break;
        }
        
        //处理内容拉伸的情况。这里是只有内容约束布局才支持尺寸拉伸。
        if (lsc.arrangedCount == 0 && averageArrange)
        {
            //不是最后一行。。
            if (startIndex != sbs.count)
            {
                addXFill = (selfSize.width - paddingHorz - rowMaxWidth) / count;
            }
            
        }
    }
    
    
    //将整行的位置进行调整。
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        if (!isEstimate && self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leadingBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.trailingBorderline = nil;
                    sbvl.bottomBorderline = nil;
                    
                    //如果不是最后一行就画下面，
                    if (startIndex != sbs.count)
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果不是最后一列就画右边,
                    if (j < startIndex - 1)
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    }
                    
                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && lsc.arrangedCount != count )
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertSpace != 0 && startIndex - count != 0)
                    {
                        sbvl.topBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzSpace != 0 && j != startIndex - count)
                    {
                        sbvl.leadingBorderline = self.intelligentBorderline;
                    }
                    
                }
            }
        }
        
        MyGravity sbvVertAlignment = sbvsc.myAlignment & MyGravity_Horz_Mask;
        if (sbvVertAlignment != MyGravity_None)
            vertAlignment = sbvVertAlignment;
        
        if ((vertAlignment != MyGravity_None && vertAlignment != MyGravity_Vert_Top) || _myCGFloatNotEqual(addXPos, 0)  ||  _myCGFloatNotEqual(addXFill, 0))
        {
            
            sbvmyFrame.leading += addXPos;
            
            //内容约束布局并且是拉伸尺寸。。
            if (lsc.arrangedCount == 0 && averageArrange)
            {
                //只拉伸宽度不拉伸间距
                sbvmyFrame.width += addXFill;
                
                if (j != startIndex - count)
                {
                    sbvmyFrame.leading += addXFill * (j - (startIndex - count));
                    
                }
            }
            else
            {
                //其他的只拉伸间距
                sbvmyFrame.leading += addXFill * (j - (startIndex - count));
            }
            
            
            switch (vertAlignment) {
                case MyGravity_Vert_Center:
                {
                    sbvmyFrame.top += (rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal - sbvmyFrame.height) / 2;
                    
                }
                    break;
                case MyGravity_Vert_Bottom:
                {
                    sbvmyFrame.top += rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal - sbvmyFrame.height;
                }
                    break;
                case MyGravity_Vert_Fill:
                {
                    sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}

- (void)myCalcHorzLayoutSinglelineAlignment:(CGSize)selfSize colMaxWidth:(CGFloat)colMaxWidth colMaxHeight:(CGFloat)colMaxHeight vertGravity:(MyGravity)vertGravity  horzAlignment:(MyGravity)horzAlignment sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertSpace:(CGFloat)vertSpace horzSpace:(CGFloat)horzSpace isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{
    
    CGFloat paddingTop = lsc.topPadding;
    CGFloat paddingBottom = lsc.bottomPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    CGFloat addYPos = 0;
    CGFloat addYFill = 0;
    
    BOOL averageArrange = (vertGravity == MyGravity_Vert_Fill);
    
    if (!averageArrange || lsc.arrangedCount == 0)
    {
        switch (vertGravity) {
            case MyGravity_Vert_Center:
            {
                addYPos = (selfSize.height - paddingVert - colMaxHeight) / 2;
            }
                break;
            case MyGravity_Vert_Bottom:
            {
                addYPos = selfSize.height - paddingVert - colMaxHeight;
            }
                break;
            case MyGravity_Vert_Between:
            {
                //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效(如果数量和单行的数量相等除外)。
                if ((startIndex != sbs.count || count == lsc.arrangedCount) && count > 1)
                {
                    addYFill = (selfSize.height - paddingVert - colMaxHeight) / (count - 1);
                }
                
            }
            default:
                break;
        }
        
        //处理内容拉伸的情况。
        if (lsc.arrangedCount == 0 && averageArrange)
        {
            if (startIndex != sbs.count)
            {
                addYFill = (selfSize.height  - paddingVert - colMaxHeight) / count;
            }
            
        }
        
    }
    
    
    
    
    //将整行的位置进行调整。
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        
        if (!isEstimate && self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leadingBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.trailingBorderline = nil;
                    sbvl.bottomBorderline = nil;
                    
                    
                    //如果不是最后一行就画下面，
                    if (j < startIndex - 1)
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果不是最后一列就画右边,
                    if (startIndex != sbs.count )
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;
                        
                    }
                    
                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && lsc.arrangedCount != count )
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertSpace != 0 && j != startIndex - count)
                    {
                        sbvl.topBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzSpace != 0 && startIndex - count != 0  )
                    {
                       sbvl.leadingBorderline = self.intelligentBorderline;
                        
                    }
                    
                    
                    
                }
            }
        }
        
        CGFloat sbvHorzAlignment = [self myConvertLeftRightGravityToLeadingTrailing:sbvsc.myAlignment & MyGravity_Vert_Mask];
        if (sbvHorzAlignment != MyGravity_None)
            horzAlignment = sbvHorzAlignment;
        
        if ((horzAlignment != MyGravity_None && horzAlignment != MyGravity_Horz_Leading) || _myCGFloatNotEqual(addYPos, 0) || _myCGFloatNotEqual(addYFill, 0) )
        {
            sbvmyFrame.top += addYPos;
            
            if (lsc.arrangedCount == 0 && averageArrange)
            {
                //只拉伸宽度不拉伸间距
                sbvmyFrame.height += addYFill;
                
                if (j != startIndex - count)
                {
                    sbvmyFrame.top += addYFill * (j - (startIndex - count));
                    
                }
            }
            else
            {
                //只拉伸间距
                sbvmyFrame.top += addYFill * (j - (startIndex - count));
            }
            
            
            switch (horzAlignment) {
                case MyGravity_Horz_Center:
                {
                    sbvmyFrame.leading += (colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal - sbvmyFrame.width) / 2;
                    
                }
                    break;
                case MyGravity_Horz_Trailing:
                {
                    sbvmyFrame.leading += colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal - sbvmyFrame.width;
                }
                    break;
                case MyGravity_Horz_Fill:
                {
                    sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }
}


-(CGFloat)myCalcSinglelineSize:(NSArray*)sbs space:(CGFloat)space
{
    CGFloat size = 0;
    for (UIView *sbv in sbs)
    {
        size += sbv.myFrame.trailing;
        if (sbv != sbs.lastObject)
            size += space;
    }
    
    return size;
}

-(NSArray*)myGetAutoArrangeSubviews:(NSMutableArray*)sbs selfSize:(CGFloat)selfSize space:(CGFloat)space
{
    
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:sbs.count];
    
    NSMutableArray *bestSinglelineArray = [NSMutableArray arrayWithCapacity:sbs.count /2];
    
    while (sbs.count) {
        
        [self myCalcAutoArrangeSinglelineSubviews:sbs
                                          index:0
                                      calcArray:@[]
                                       selfSize:selfSize
                                         space:space
                            bestSinglelineArray:bestSinglelineArray];
        
        [retArray addObjectsFromArray:bestSinglelineArray];
        
        [bestSinglelineArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            [sbs removeObject:obj];
        }];
        
        [bestSinglelineArray removeAllObjects];
    }
    
    return retArray;
}

-(void)myCalcAutoArrangeSinglelineSubviews:(NSMutableArray*)sbs
                                   index:(NSInteger)index
                               calcArray:(NSArray*)calcArray
                                selfSize:(CGFloat)selfSize
                                  space:(CGFloat)space
                     bestSinglelineArray:(NSMutableArray*)bestSinglelineArray
{
    if (index >= sbs.count)
    {
        CGFloat s1 = [self myCalcSinglelineSize:calcArray space:space];
        CGFloat s2 = [self myCalcSinglelineSize:bestSinglelineArray space:space];
        if (fabs(selfSize - s1) < fabs(selfSize - s2) && /*s1 <= selfSize*/ _myCGFloatLessOrEqual(s1, selfSize) )
        {
            [bestSinglelineArray setArray:calcArray];
        }
        
        return;
    }
    
    
    for (NSInteger i = index; i < sbs.count; i++) {
        
        
        NSMutableArray *calcArray2 = [NSMutableArray arrayWithArray:calcArray];
        [calcArray2 addObject:sbs[i]];
        
        CGFloat s1 = [self myCalcSinglelineSize:calcArray2 space:space];
        if (_myCGFloatLessOrEqual(s1, selfSize))
        {
            CGFloat s2 = [self myCalcSinglelineSize:bestSinglelineArray space:space];
            if (fabs(selfSize - s1) < fabs(selfSize - s2))
            {
                [bestSinglelineArray setArray:calcArray2];
            }
            
            if (_myCGFloatEqual(s1, selfSize))
                break;
            
            [self myCalcAutoArrangeSinglelineSubviews:sbs
                                              index:i + 1
                                          calcArray:calcArray2
                                           selfSize:selfSize
                                             space:space
                                bestSinglelineArray:bestSinglelineArray];
            
        }
        else
            break;
        
    }
    
}


-(CGSize)myLayoutSubviewsForVertContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{
    
    CGFloat paddingTop = lsc.topPadding;
    CGFloat paddingBottom = lsc.bottomPadding;
    CGFloat paddingLeading = lsc.leadingPadding;
    CGFloat paddingTrailing = lsc.trailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;

    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity vertAlign = lsc.arrangedGravity & MyGravity_Horz_Mask;
    
    //支持浮动水平间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat minSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).maxSpace;
        
        NSInteger rowCount =  floor((selfSize.width - paddingHorz  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            horzSpace = (selfSize.width - paddingHorz - subviewSize * rowCount)/(rowCount - 1);
            if (horzSpace > maxSpace)
            {
                horzSpace = maxSpace;
                
                subviewSize =  (selfSize.width - paddingHorz -  horzSpace * (rowCount - 1)) / rowCount;
                
            }
        }
    }
    
    
    if (lsc.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
            
#ifdef DEBUG
            //约束异常：垂直流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbvsc.weight == 0, @"Constraint exception!! vertical flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
            CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
            CGRect rect = sbvmyFrame.frame;
            
            if (sbvsc.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbvsc.widthSizeInner.measure;
            
            
            [self mySetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            //暂时把宽度存放sbv.myFrame.trailing上。因为浮动布局来说这个属性无用。
            sbvmyFrame.trailing = leadingSpace + rect.size.width + trailingSpace;
            if (sbvmyFrame.trailing > selfSize.width - paddingHorz)
                sbvmyFrame.trailing = selfSize.width - paddingHorz;
        }
        
        [sbs setArray:[self myGetAutoArrangeSubviews:sbs selfSize:selfSize.width - paddingHorz space:horzSpace]];
        
    }
    
    
    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
       
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        
        if (subviewSize != 0)
            rect.size.width = subviewSize;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        
        [self mySetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        [self mySetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        
        if (sbvsc.weight != 0)
        {
            //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
            CGFloat floatWidth = selfSize.width - paddingHorz - rowMaxWidth;
            if (_myCGFloatLessOrEqual(floatWidth, 0))
            {
                floatWidth += rowMaxWidth;
                arrangedIndex = 0;
            }
            
            if (arrangedIndex != 0)
                floatWidth -= horzSpace;
            
            rect.size.width = (floatWidth + sbvsc.widthSizeInner.addVal) * sbvsc.weight - leadingSpace - trailingSpace;
            
        }
        
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width ];
        
        
        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算xPos的值加上leadingSpace + rect.size.width + trailingSpace 的值要小于整体的宽度。
        CGFloat place = xPos + leadingSpace + rect.size.width + trailingSpace;
        if (arrangedIndex != 0)
            place += horzSpace;
        place += paddingTrailing;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.width > 0.0001)
        {
            xPos = paddingLeading;
            yPos += vertSpace;
            yPos += rowMaxHeight;
            
            
            [arrangeIndexSet addIndex:i - arrangedIndex];
            //计算每行的gravity情况。
            [self myCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            
            //计算单独的sbv的宽度是否大于整体的宽度。如果大于则缩小宽度。
            if (leadingSpace + trailingSpace + rect.size.width > selfSize.width - paddingHorz)
            {
                
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:selfSize.width - paddingHorz - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
                {
                    rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
                    rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }
                
            }
            
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            arrangedIndex = 0;
            
        }
        
        if (arrangedIndex != 0)
            xPos += horzSpace;
        
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;
        
        if (rowMaxHeight < topSpace + bottomSpace + rect.size.height)
            rowMaxHeight = topSpace + bottomSpace + rect.size.height;
        
        if (rowMaxWidth < (xPos - paddingLeading))
            rowMaxWidth = (xPos - paddingLeading);
        
        
        
        sbvmyFrame.frame = rect;
        
        arrangedIndex++;
        
        
        
    }
    
    //最后一行
    [arrangeIndexSet addIndex:i - arrangedIndex];
    
    [self myCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
    
    
    if (lsc.wrapContentHeight)
        selfSize.height = yPos + paddingBottom + rowMaxHeight;
    else
    {
        CGFloat addYPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        
        if (vertGravity == MyGravity_Vert_Center)
        {
            addYPos = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / 2;
        }
        else if (vertGravity == MyGravity_Vert_Bottom)
        {
            addYPos = selfSize.height - paddingBottom - rowMaxHeight - yPos;
        }
        else if (vertGravity == MyGravity_Vert_Fill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / arrangeIndexSet.count;
        }
        else if (vertGravity == MyGravity_Vert_Between)
        {
            if (arrangeIndexSet.count > 1)
                between = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / (arrangeIndexSet.count - 1);
        }
        
        if (addYPos != 0 || between != 0 || fill != 0)
        {
            int line = 0;
            NSUInteger lastIndex = 0;
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                MyFrame *sbvmyFrame = sbv.myFrame;
                
                sbvmyFrame.top += addYPos;
                
                //找到行的最初索引。
                NSUInteger index = [arrangeIndexSet indexLessThanOrEqualToIndex:i];
                if (lastIndex != index)
                {
                    lastIndex = index;
                    line ++;
                }
                
                sbvmyFrame.height += fill;
                sbvmyFrame.top += fill * line;
                
                sbvmyFrame.top += between * line;
                
            }
        }
        
    }
    
    
    return selfSize;
    
}


-(CGSize)myLayoutSubviewsForVert:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{
    CGFloat paddingTop = lsc.topPadding;
    CGFloat paddingBottom = lsc.bottomPadding;
    CGFloat paddingLeading = lsc.leadingPadding;
    CGFloat paddingTrailing = lsc.trailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    NSInteger arrangedCount = lsc.arrangedCount;
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    CGFloat maxWidth = paddingLeading;  //全部行的最宽值
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity vertAlign = lsc.arrangedGravity & MyGravity_Horz_Mask;
    
   
    
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] &&
                           ((UIScrollView*)self.superview).isPagingEnabled);
    CGFloat pagingItemHeight = 0;
    CGFloat pagingItemWidth = 0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (lsc.pagedCount > 0 && self.superview != nil)
    {
        NSInteger rows = lsc.pagedCount / arrangedCount;  //每页的行数。
        
        //对于垂直流式布局来说，要求要有明确的宽度。因此如果我们启用了分页又设置了宽度包裹时则我们的分页是从左到右的排列。否则分页是从上到下的排列。
        if (lsc.wrapContentWidth)
        {
            isHorzPaging = YES;
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (arrangedCount - 1) * horzSpace ) / arrangedCount;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingLeading - arrangedCount * horzSpace ) / arrangedCount;
            
            pagingItemHeight = (selfSize.height - paddingVert - (rows - 1) * vertSpace) / rows;
        }
        else
        {
            isVertPaging = YES;
            pagingItemWidth = (selfSize.width - paddingHorz - (arrangedCount - 1) * horzSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的高度计算是不一样的。
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (rows - 1) * vertSpace) / rows;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingTop - rows * vertSpace) / rows;
            
        }
        
    }
    
    
    BOOL averageArrange = (horzGravity == MyGravity_Horz_Fill);
    
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    CGFloat rowTotalWeight = 0;
    CGFloat rowTotalFixedWidth = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        if (arrangedIndex >= arrangedCount)
        {
            arrangedIndex = 0;
            
            if (rowTotalWeight != 0 && !averageArrange)
            {
                [self myCalcVertLayoutSinglelineWeight:selfSize totalFloatWidth:selfSize.width - paddingHorz - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }
            
            rowTotalWeight = 0;
            rowTotalFixedWidth = 0;
            
        }
        
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        
        if (sbvsc.weight != 0)
        {
            
            rowTotalWeight += sbvsc.weight;
        }
        else
        {
            if (pagingItemWidth != 0)
                rect.size.width = pagingItemWidth;
            
            if (sbvsc.widthSizeInner.dimeNumVal != nil && !averageArrange)
                rect.size.width = sbvsc.widthSizeInner.measure;
            
            
            [self mySetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            rowTotalFixedWidth += rect.size.width;
        }
        
        rowTotalFixedWidth += leadingSpace + trailingSpace;
        
        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedWidth += horzSpace;
        
        
        sbvmyFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedWidth -= horzSpace;
        
        [self myCalcVertLayoutSinglelineWeight:selfSize totalFloatWidth:selfSize.width - paddingHorz - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }
    
    
    CGFloat pageWidth  = 0; //页宽。
    CGFloat averageWidth = (selfSize.width - paddingHorz - (arrangedCount - 1) * horzSpace) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        //新的一行
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            yPos += rowMaxHeight;
            yPos += vertSpace;
            
            //分别处理水平分页和垂直分页。
            if (isHorzPaging)
            {
                if (i % lsc.pagedCount == 0)
                {
                    pageWidth += CGRectGetWidth(self.superview.bounds);
                    
                    if (!isPagingScroll)
                        pageWidth -= paddingLeading;
                    
                    yPos = paddingTop;
                }
                
            }
            
            if (isVertPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % lsc.pagedCount == 0)
                {
                    
                    if (isPagingScroll)
                    {
                        yPos -= vertSpace;
                        yPos += paddingVert;
                        
                    }
                }
            }
            
            
            xPos = paddingLeading + pageWidth;
            
            
            //计算每行的gravity情况。
            [self myCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedCount vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            
        }
        
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        BOOL isFlexedHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && sbvsc.heightSizeInner.dimeRelaVal.view != self;
        
        if (pagingItemHeight != 0)
            rect.size.height = pagingItemHeight;
        
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        if (averageArrange)
        {
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:averageWidth - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        [self mySetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;
        
        if (arrangedIndex != (arrangedCount - 1))
            xPos += horzSpace;
        
        
        if (rowMaxHeight < topSpace + bottomSpace + rect.size.height)
            rowMaxHeight = topSpace + bottomSpace + rect.size.height;
        
        if (rowMaxWidth < (xPos - paddingLeading))
            rowMaxWidth = (xPos - paddingLeading);
        
        if (maxWidth < xPos)
            maxWidth = xPos;
        
        
        
        sbvmyFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行
    [self myCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
    
    if (lsc.wrapContentHeight)
    {
        selfSize.height = yPos + paddingBottom + rowMaxHeight;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (selfSize.height < totalPages * CGRectGetHeight(self.superview.bounds))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }
        
    }
    else
    {
        CGFloat addYPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        int arranges = floor((sbs.count + arrangedCount - 1.0) / arrangedCount);
        
        if (vertGravity == MyGravity_Vert_Center)
        {
            addYPos = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / 2;
        }
        else if (vertGravity == MyGravity_Vert_Bottom)
        {
            addYPos = selfSize.height - paddingBottom - rowMaxHeight - yPos;
        }
        else if (vertGravity == MyGravity_Vert_Fill)
        {
            if (arranges > 0)
                fill = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / arranges;
        }
        else if (vertGravity == MyGravity_Vert_Between)
        {
            
            if (arranges > 1)
                between = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / (arranges - 1);
        }
        
        
        if (addYPos != 0 || between != 0 || fill != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                MyFrame *sbvmyFrame = sbv.myFrame;
                
                int lines = i / arrangedCount;
                sbvmyFrame.height += fill;
                sbvmyFrame.top += fill * lines;
                
                sbvmyFrame.top += addYPos;
                
                sbvmyFrame.top += between * lines;
                
            }
        }
        
    }
    
    if (lsc.wrapContentWidth && !averageArrange)
    {
        selfSize.width = maxWidth + paddingTrailing;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (selfSize.width < totalPages * CGRectGetWidth(self.superview.bounds))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }
        
    }
    
    return selfSize;
}





-(CGSize)myLayoutSubviewsForHorzContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{

    CGFloat paddingTop = lsc.topPadding;
    CGFloat paddingBottom = lsc.bottomPadding;
    CGFloat paddingLeading = lsc.leadingPadding;
    CGFloat paddingTrailing = lsc.trailingPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;

    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat colMaxWidth = 0;  //某一列的最宽值。
    CGFloat colMaxHeight = 0;   //某一列的最高值
    
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity horzAlign =  [self myConvertLeftRightGravityToLeadingTrailing:lsc.arrangedGravity & MyGravity_Vert_Mask];
        
    
    //支持浮动垂直间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat minSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).maxSpace;
        NSInteger rowCount =  floor((selfSize.height - paddingVert  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            vertSpace = (selfSize.height - paddingVert - subviewSize * rowCount)/(rowCount - 1);
            if (vertSpace > maxSpace)
            {
                vertSpace = maxSpace;
                
                subviewSize =  (selfSize.height - paddingVert -  vertSpace * (rowCount - 1)) / rowCount;
                
            }
        }
    }
    
    
    if (lsc.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
            
#ifdef DEBUG
            //约束异常：水平流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbvsc.weight == 0, @"Constraint exception!! horizontal flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            
            
            CGFloat topSpace = sbvsc.topPosInner.absVal;
            CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
            CGRect rect = sbvmyFrame.frame;
            
            if (sbvsc.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbvsc.widthSizeInner.measure;
            
            if (sbvsc.heightSizeInner.dimeNumVal != nil)
                rect.size.height = sbvsc.heightSizeInner.measure;
            
            [self mySetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            [self mySetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            
            //如果高度是浮动的则需要调整高度。
            if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
            {
                rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            
            //暂时把宽度存放sbv.myFrame.trailing上。因为浮动布局来说这个属性无用。
            sbvmyFrame.trailing = topSpace + rect.size.height + bottomSpace;
            if (sbvmyFrame.trailing > selfSize.height - paddingVert)
                sbvmyFrame.trailing = selfSize.height - paddingVert;
        }
        
        [sbs setArray:[self myGetAutoArrangeSubviews:sbs selfSize:selfSize.height - paddingVert space:vertSpace]];
        
    }
    
    
    
    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];

        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        [self mySetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        if (subviewSize != 0)
            rect.size.height = subviewSize;
        
        
        [self mySetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        
        if (sbvsc.weight != 0)
        {
            //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
            CGFloat floatHeight = selfSize.height - paddingVert - colMaxHeight;
            if (_myCGFloatLessOrEqual(floatHeight, 0))
            {
                floatHeight += colMaxHeight;
                arrangedIndex = 0;
            }
            
            if (arrangedIndex != 0)
                floatHeight -= vertSpace;
            
            rect.size.height = (floatHeight + sbvsc.heightSizeInner.addVal) * sbvsc.weight - topSpace - bottomSpace;
            
        }
        
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height ];
        
        
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
            
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算yPos的值加上topSpace + rect.size.height + bottomSpace的值要小于整体的高度。
        CGFloat place = yPos + topSpace + rect.size.height + bottomSpace;
        if (arrangedIndex != 0)
            place += vertSpace;
        place += paddingBottom;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.height > 0.0001)
        {
            yPos = paddingTop;
            xPos += horzSpace;
            xPos += colMaxWidth;
            
            
            //计算每行的gravity情况。
            [arrangeIndexSet addIndex:i - arrangedIndex];
            [self myCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            
            //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
            if (topSpace + bottomSpace + rect.size.height > selfSize.height - paddingVert)
            {
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:selfSize.height - paddingVert - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            colMaxWidth = 0;
            colMaxHeight = 0;
            arrangedIndex = 0;
            
        }
        
        if (arrangedIndex != 0)
            yPos += vertSpace;
        
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        yPos += topSpace + rect.size.height + bottomSpace;
        
        if (colMaxWidth < leadingSpace + trailingSpace + rect.size.width)
            colMaxWidth = leadingSpace + trailingSpace + rect.size.width;
        
        if (colMaxHeight < (yPos - paddingTop))
            colMaxHeight = (yPos - paddingTop);
        
        
        
        sbvmyFrame.frame = rect;
        
        arrangedIndex++;
        
        
        
    }
    
    //最后一行
    [arrangeIndexSet addIndex:i - arrangedIndex];
    [self myCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
    
    
    if (lsc.wrapContentWidth)
        selfSize.width = xPos + paddingTrailing + colMaxWidth;
    else
    {
        CGFloat addXPos = 0;
        CGFloat fill = 0;
        CGFloat between = 0;
        
        if (horzGravity == MyGravity_Horz_Center)
        {
            addXPos = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / 2;
        }
        else if (horzGravity == MyGravity_Horz_Trailing)
        {
            addXPos = selfSize.width - paddingTrailing - colMaxWidth - xPos;
        }
        else if (horzGravity == MyGravity_Horz_Fill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / arrangeIndexSet.count;
        }
        else if (horzGravity == MyGravity_Horz_Between)
        {
            if (arrangeIndexSet.count > 1)
                between = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / (arrangeIndexSet.count - 1);
        }
        
        
        if (addXPos != 0 || between != 0 || fill != 0)
        {
            int line = 0;
            NSUInteger lastIndex = 0;
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                MyFrame *sbvmyFrame = sbv.myFrame;
                
                sbvmyFrame.leading += addXPos;
                
                //找到行的最初索引。
                NSUInteger index = [arrangeIndexSet indexLessThanOrEqualToIndex:i];
                if (lastIndex != index)
                {
                    lastIndex = index;
                    line ++;
                }
                
                sbvmyFrame.width += fill;
                sbvmyFrame.leading += fill * line;
                
                sbvmyFrame.leading += between * line;
                
            }
        }
        
    }
    
   
    return selfSize;
}



-(CGSize)myLayoutSubviewsForHorz:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{
    CGFloat paddingTop = lsc.topPadding;
    CGFloat paddingBottom = lsc.bottomPadding;
    CGFloat paddingLeading = lsc.leadingPadding;
    CGFloat paddingTrailing = lsc.trailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;

    NSInteger arrangedCount = lsc.arrangedCount;
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat colMaxWidth = 0;  //每列的最大宽度
    CGFloat colMaxHeight = 0; //每列的最大高度
    CGFloat maxHeight = paddingTop;
    
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity horzAlign =  [self myConvertLeftRightGravityToLeadingTrailing:lsc.arrangedGravity & MyGravity_Vert_Mask];
    

    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    
    //父滚动视图是否分页滚动。
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] &&
                           ((UIScrollView*)self.superview).isPagingEnabled);
    
    CGFloat pagingItemHeight = 0;
    CGFloat pagingItemWidth = 0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (lsc.pagedCount > 0 && self.superview != nil)
    {
        NSInteger cols = lsc.pagedCount / arrangedCount;  //每页的列数。
        
        //对于水平流式布局来说，要求要有明确的高度。因此如果我们启用了分页又设置了高度包裹时则我们的分页是从上到下的排列。否则分页是从左到右的排列。
        if (lsc.wrapContentHeight)
        {
            isVertPaging = YES;
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (arrangedCount - 1) * vertSpace ) / arrangedCount;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingTop - arrangedCount * vertSpace ) / arrangedCount;
            
            pagingItemWidth = (selfSize.width - paddingHorz - (cols - 1) * horzSpace) / cols;
        }
        else
        {
            isHorzPaging = YES;
            pagingItemHeight = (selfSize.height - paddingVert - (arrangedCount - 1) * vertSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的宽度计算是不一样的。
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (cols - 1) * horzSpace) / cols;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingLeading - cols * horzSpace) / cols;
            
        }
        
    }
    
    BOOL averageArrange = (vertGravity == MyGravity_Vert_Fill);
    
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    CGFloat rowTotalWeight = 0;
    CGFloat rowTotalFixedHeight = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        if (arrangedIndex >= arrangedCount)
        {
            arrangedIndex = 0;
            
            if (rowTotalWeight != 0 && !averageArrange)
            {
                [self myCalcHorzLayoutSinglelineWeight:selfSize totalFloatHeight:selfSize.height - paddingVert - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }
            
            rowTotalWeight = 0;
            rowTotalFixedHeight = 0;
            
        }
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        
        if (pagingItemWidth != 0)
            rect.size.width = pagingItemWidth;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        //当子视图的尺寸是相对依赖于其他尺寸的值。
        [self mySetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        if (sbvsc.weight != 0)
        {
            
            rowTotalWeight += sbvsc.weight;
        }
        else
        {
            
            BOOL isFlexedHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && sbvsc.heightSizeInner.dimeRelaVal.view != self;
            
            if (pagingItemHeight != 0)
                rect.size.height = pagingItemHeight;
            
            if (sbvsc.heightSizeInner.dimeNumVal != nil && !averageArrange)
                rect.size.height = sbvsc.heightSizeInner.measure;
            
            //当子视图的尺寸是相对依赖于其他尺寸的值。
            [self mySetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            
            //如果高度是浮动的则需要调整高度。
            if (isFlexedHeight)
                rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
            
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
            
            rowTotalFixedHeight += rect.size.height;
        }
        
        rowTotalFixedHeight += topSpace + bottomSpace;
        
        
        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedHeight += vertSpace;
        
        
        sbvmyFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedHeight -= vertSpace;
        
        [self myCalcHorzLayoutSinglelineWeight:selfSize totalFloatHeight:selfSize.height - paddingVert - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }
    
    
    CGFloat pageHeight = 0; //页高
    CGFloat averageHeight = (selfSize.height - paddingVert - (arrangedCount - 1) * vertSpace) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
       
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            xPos += colMaxWidth;
            xPos += horzSpace;
            
            //分别处理水平分页和垂直分页。
            if (isVertPaging)
            {
                if (i % lsc.pagedCount == 0)
                {
                    pageHeight += CGRectGetHeight(self.superview.bounds);
                    
                    if (!isPagingScroll)
                        pageHeight -= paddingTop;
                    
                    xPos = paddingLeading;
                }
                
            }
            
            if (isHorzPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % lsc.pagedCount == 0)
                {
                    
                    if (isPagingScroll)
                    {
                        xPos -= horzSpace;
                        xPos += paddingTrailing;
                        xPos += paddingLeading;
                    }
                }
            }
            
            
            yPos = paddingTop + pageHeight;
            
            
            //计算每行的gravity情况。
            [self myCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedCount vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            
            colMaxWidth = 0;
            colMaxHeight = 0;
        }
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        
        if (averageArrange)
        {
            
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:averageHeight - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        rect.origin.y = yPos + topSpace;
        rect.origin.x = xPos + leadingSpace;
        yPos += topSpace + rect.size.height + bottomSpace;
        
        if (arrangedIndex != (arrangedCount - 1))
            yPos += vertSpace;
        
        
        if (colMaxWidth < leadingSpace + trailingSpace + rect.size.width)
            colMaxWidth = leadingSpace + trailingSpace + rect.size.width;
        
        if (colMaxHeight < (yPos - paddingTop))
            colMaxHeight = yPos - paddingTop;
        
        if (maxHeight < yPos)
            maxHeight = yPos;
        
        
        sbvmyFrame.frame = rect;
        
        
        arrangedIndex++;
        
    }
    
    //最后一列
    [self myCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
    
    if (lsc.wrapContentHeight && !averageArrange)
    {
        selfSize.height = maxHeight + paddingBottom;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (selfSize.height < totalPages * CGRectGetHeight(self.superview.bounds))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }
        
        
    }
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = xPos + paddingTrailing + colMaxWidth;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (selfSize.width < totalPages * CGRectGetWidth(self.superview.bounds))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }
        
    }
    else
    {
        
        CGFloat addXPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        int arranges = floor((sbs.count + arrangedCount - 1.0) / arrangedCount);
        
        if (horzGravity == MyGravity_Horz_Center)
        {
            addXPos = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / 2;
        }
        else if (horzGravity == MyGravity_Horz_Trailing)
        {
            addXPos = selfSize.width - paddingTrailing - colMaxWidth - xPos;
        }
        else if (horzGravity == MyGravity_Horz_Fill)
        {
            if (arranges > 0)
                fill = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / arranges;
        }
        else if (horzGravity == MyGravity_Horz_Between)
        {
            if (arranges > 1)
                between = (selfSize.width - paddingLeading - colMaxWidth - xPos) / (arranges - 1);
        }
        
        if (addXPos != 0 || between != 0 || fill != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                MyFrame *sbvmyFrame = sbv.myFrame;
                
                int lines = i / arrangedCount;
                sbvmyFrame.width += fill;
                sbvmyFrame.leading += fill * lines;
                
                sbvmyFrame.leading += addXPos;
                
                sbvmyFrame.leading += between * lines;
                
            }
        }
    }
    
    
    return selfSize;
    
}



@end

//
//  MyFlowLayout.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyFlowLayout.h"
#import "MyLayoutInner.h"


@implementation  UIView(MyFlowLayoutExt)


-(CGFloat)weight
{
    return self.myCurrentSizeClass.weight;
}

-(void)setWeight:(CGFloat)weight
{
    if (self.myCurrentSizeClass.weight != weight)
    {
        self.myCurrentSizeClass.weight = weight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

@end


@implementation MyFlowLayout


-(instancetype)initWithFrame:(CGRect)frame orientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.myCurrentSizeClass.orientation = orientation;
        self.myCurrentSizeClass.arrangedCount = arrangedCount;
    }
    
    return  self;
}

-(instancetype)initWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    return [self initWithFrame:CGRectZero orientation:orientation arrangedCount:arrangedCount];
}


+(instancetype)flowLayoutWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    MyFlowLayout *layout = [[[self class] alloc] initWithOrientation:orientation arrangedCount:arrangedCount];
    return layout;
}

-(void)setOrientation:(MyLayoutViewOrientation)orientation
{
     MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.orientation != orientation)
    {
        lsc.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(MyLayoutViewOrientation)orientation
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

-(void)setGravity:(MyGravity)gravity
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.gravity != gravity)
    {
        lsc.gravity = gravity;
        [self setNeedsLayout];
    }
}

-(MyGravity)gravity
{
    return self.myCurrentSizeClass.gravity;
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
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        if (averageArrange)
            self.gravity = (self.gravity & MyGravity_Horz_Mask) | MyGravity_Horz_Fill;
        else
            self.gravity = (self.gravity & MyGravity_Horz_Mask) | MyGravity_None;
    }
    else
    {
        if (averageArrange)
            self.gravity = (self.gravity & MyGravity_Vert_Mask) | MyGravity_Vert_Fill;
        else
            self.gravity = (self.gravity & MyGravity_Vert_Mask) | MyGravity_None;
    }
    
}

-(BOOL)averageArrange
{
    if (self.orientation == MyLayoutViewOrientation_Vert)
        return (self.gravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill;
    else
        return (self.gravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill;
}


#pragma mark -- Override Method

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    
    for (UIView *sbv in sbs)
    {
        
        if (!isEstimate)
        {
            sbv.myFrame.frame = sbv.bounds;
            [self myCalcSizeOfWrapContentSubview:sbv selfLayoutSize:selfSize];
        }
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
            
            if (sbvl.wrapContentWidth)
            {
                if (sbvl.widthSizeInner.dimeVal != nil ||
                    (self.orientation == MyLayoutViewOrientation_Horz && (self.arrangedGravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill) ||
                    (self.orientation == MyLayoutViewOrientation_Vert && ((self.gravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill || sbvl.weight != 0)))
                {
                    [sbvl mySetWrapContentWidthNoLayout:NO];
                }
            }
            
            if (sbvl.wrapContentHeight)
            {
                if (sbvl.heightSizeInner.dimeVal != nil ||
                    (self.orientation == MyLayoutViewOrientation_Vert && (self.arrangedGravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill) ||
                    (self.orientation == MyLayoutViewOrientation_Horz && ((self.gravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill || sbvl.weight != 0)))
                {
                    [sbvl mySetWrapContentHeightNoLayout:NO];
                }
            }

            if (pHasSubLayout != nil && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                *pHasSubLayout = YES;
            
            if (isEstimate && (sbvl.wrapContentWidth || sbvl.wrapContentHeight))
            {
                [sbvl estimateLayoutRect:sbvl.myFrame.frame.size inSizeClass:sizeClass];
                sbvl.myFrame.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
        }
    }

    
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        if (self.arrangedCount == 0)
            selfSize = [self myLayoutSubviewsForVertContent:selfSize sbs:sbs];
        else
            selfSize = [self myLayoutSubviewsForVert:selfSize sbs:sbs];
    }
    else
    {
        if (self.arrangedCount == 0)
            selfSize = [self myLayoutSubviewsForHorzContent:selfSize sbs:sbs];
        else
            selfSize = [self myLayoutSubviewsForHorz:selfSize sbs:sbs];
    }
    
    selfSize.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs];
}

-(id)createSizeClassInstance
{
    return [MyFlowLayoutViewSizeClass new];
}

#pragma mark -- Private Method


- (void)myCalcVertLayoutWeight:(CGSize)selfSize totalFloatWidth:(CGFloat)totalFloatWidth totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        if (sbv.weight != 0)
        {
            CGFloat tempWidth = (totalFloatWidth * sbv.weight / totalWeight);
            if (sbv.widthSizeInner != nil)
                tempWidth = [sbv.widthSizeInner measureWith:tempWidth];
            
            sbv.myFrame.width =  [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:tempWidth sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            sbv.myFrame.rightPos = sbv.myFrame.leftPos + sbv.myFrame.width;
        }
    }
}

- (void)myCalcHorzLayoutWeight:(CGSize)selfSize totalFloatHeight:(CGFloat)totalFloatHeight totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        if (sbv.weight != 0)
        {
            CGFloat tempHeight = (totalFloatHeight * sbv.weight / totalWeight);
            if (sbv.heightSizeInner != nil)
                tempHeight = [sbv.heightSizeInner measureWith:tempHeight];
            
            sbv.myFrame.height =  [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:tempHeight sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            sbv.myFrame.bottomPos = sbv.myFrame.topPos + sbv.myFrame.height;
            
            if (sbv.widthSizeInner.dimeRelaVal != nil && sbv.widthSizeInner.dimeRelaVal == sbv.heightSizeInner)
                sbv.myFrame.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:[sbv.widthSizeInner measureWith: sbv.myFrame.height ] sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            
        }
    }
}



- (void)myCalcVertLayoutGravity:(CGSize)selfSize rowMaxHeight:(CGFloat)rowMaxHeight rowMaxWidth:(CGFloat)rowMaxWidth mg:(MyGravity)mg amg:(MyGravity)amg sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertMargin:(CGFloat)vertMargin horzMargin:(CGFloat)horzMargin
{
    
    UIEdgeInsets padding = self.padding;
    CGFloat addXPos = 0; //多出来的空隙区域，用于停靠处理。
    CGFloat addXFill = 0;  //多出来的平均区域，用于拉伸间距或者尺寸
    BOOL averageArrange = (mg == MyGravity_Horz_Fill);
    
    if (!averageArrange || self.arrangedCount == 0)
    {
        switch (mg) {
            case MyGravity_Horz_Center:
            {
                addXPos = (selfSize.width - padding.left - padding.right - rowMaxWidth) / 2;
            }
                break;
            case MyGravity_Horz_Right:
            {
                addXPos = selfSize.width - padding.left - padding.right - rowMaxWidth; //因为具有不考虑左边距，而原来的位置增加了左边距，因此
            }
                break;
            case MyGravity_Horz_Between:
            {
                //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效(如果最后一行的数量和其他行的数量一样除外)。
                if ((startIndex != sbs.count || count == self.arrangedCount) && count > 1)
                {
                    addXFill = (selfSize.width - padding.left - padding.right - rowMaxWidth) / (count - 1);
                }
            }
                break;
            default:
                break;
        }
        
        //处理内容拉伸的情况。这里是只有内容约束布局才支持尺寸拉伸。
        if (self.arrangedCount == 0 && averageArrange)
        {
            //不是最后一行。。
            if (startIndex != sbs.count)
            {
                addXFill = (selfSize.width - padding.left - padding.right - rowMaxWidth) / count;
            }
            
        }
    }
    
    
    //将整行的位置进行调整。
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        
        if (self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leftBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.rightBorderline = nil;
                    sbvl.bottomBorderline = nil;
                    
                    //如果不是最后一行就画下面，
                    if (startIndex != sbs.count)
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果不是最后一列就画右边,
                    if (j < startIndex - 1)
                    {
                        sbvl.rightBorderline = self.intelligentBorderline;
                    }
                    
                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && self.arrangedCount != count )
                    {
                        sbvl.rightBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertMargin != 0 && startIndex - count != 0)
                    {
                        sbvl.topBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzMargin != 0 && j != startIndex - count)
                    {
                        sbvl.leftBorderline = self.intelligentBorderline;
                    }
                    
                }
            }
        }
        
        if ((amg != MyGravity_None && amg != MyGravity_Vert_Top) || /*addXPos != 0*/_myCGFloatNotEqual(addXPos, 0)  || /*addXFill != 0*/ _myCGFloatNotEqual(addXFill, 0))
        {
            
            sbv.myFrame.leftPos += addXPos;
            
            //内容约束布局并且是拉伸尺寸。。
            if (self.arrangedCount == 0 && averageArrange)
            {
                //只拉伸宽度不拉伸间距
                sbv.myFrame.width += addXFill;
                
                if (j != startIndex - count)
                {
                    sbv.myFrame.leftPos += addXFill * (j - (startIndex - count));
                    
                }
            }
            else
            {
                //其他的只拉伸间距
                sbv.myFrame.leftPos += addXFill * (j - (startIndex - count));
            }
            
            
            switch (amg) {
                case MyGravity_Vert_Center:
                {
                    sbv.myFrame.topPos += (rowMaxHeight - sbv.topPosInner.margin - sbv.bottomPosInner.margin - sbv.myFrame.height) / 2;
                    
                }
                    break;
                case MyGravity_Vert_Bottom:
                {
                    sbv.myFrame.topPos += rowMaxHeight - sbv.topPosInner.margin - sbv.bottomPosInner.margin - sbv.myFrame.height;
                }
                    break;
                case MyGravity_Vert_Fill:
                {
                    sbv.myFrame.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rowMaxHeight - sbv.topPosInner.margin - sbv.bottomPosInner.margin sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}

- (void)myCalcHorzLayoutGravity:(CGSize)selfSize colMaxWidth:(CGFloat)colMaxWidth colMaxHeight:(CGFloat)colMaxHeight mg:(MyGravity)mg  amg:(MyGravity)amg sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertMargin:(CGFloat)vertMargin horzMargin:(CGFloat)horzMargin
{
    
    CGFloat addYPos = 0;
    CGFloat addYFill = 0;
    UIEdgeInsets padding = self.padding;
    BOOL averageArrange = (mg == MyGravity_Vert_Fill);
    
    if (!averageArrange || self.arrangedCount == 0)
    {
        switch (mg) {
            case MyGravity_Vert_Center:
            {
                addYPos = (selfSize.height - padding.top - padding.bottom - colMaxHeight) / 2;
            }
                break;
            case MyGravity_Vert_Bottom:
            {
                addYPos = selfSize.height - padding.top - padding.bottom - colMaxHeight;
            }
                break;
            case MyGravity_Vert_Between:
            {
                //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效(如果数量和单行的数量相等除外)。
                if ((startIndex != sbs.count || count == self.arrangedCount) && count > 1)
                {
                    addYFill = (selfSize.height - padding.top - padding.bottom - colMaxHeight) / (count - 1);
                }
                
            }
            default:
                break;
        }
        
        //处理内容拉伸的情况。
        if (self.arrangedCount == 0 && averageArrange)
        {
            if (startIndex != sbs.count)
            {
                addYFill = (selfSize.height  - padding.top - padding.bottom - colMaxHeight) / count;
            }
            
        }
        
    }
    
    
    
    
    //将整行的位置进行调整。
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        
        if (self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leftBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.rightBorderline = nil;
                    sbvl.bottomBorderline = nil;
                    
                    
                    //如果不是最后一行就画下面，
                    if (j < startIndex - 1)
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果不是最后一列就画右边,
                    if (startIndex != sbs.count )
                    {
                        sbvl.rightBorderline = self.intelligentBorderline;
                    }
                    
                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && self.arrangedCount != count )
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertMargin != 0 && j != startIndex - count)
                    {
                        sbvl.topBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzMargin != 0 && startIndex - count != 0  )
                    {
                        sbvl.leftBorderline = self.intelligentBorderline;
                    }
                    
                    
                    
                }
            }
        }
        
        
        if ((amg != MyGravity_None && amg != MyGravity_Horz_Left) || /*addYPos != 0*/_myCGFloatNotEqual(addYPos, 0) || /*addYFill != 0*/_myCGFloatNotEqual(addYFill, 0) )
        {
            sbv.myFrame.topPos += addYPos;
            
            if (self.arrangedCount == 0 && averageArrange)
            {
                //只拉伸宽度不拉伸间距
                sbv.myFrame.height += addYFill;
                
                if (j != startIndex - count)
                {
                    sbv.myFrame.topPos += addYFill * (j - (startIndex - count));
                    
                }
            }
            else
            {
                //只拉伸间距
                sbv.myFrame.topPos += addYFill * (j - (startIndex - count));
            }
            
            
            switch (amg) {
                case MyGravity_Horz_Center:
                {
                    sbv.myFrame.leftPos += (colMaxWidth - sbv.leftPosInner.margin - sbv.rightPosInner.margin - sbv.myFrame.width) / 2;
                    
                }
                    break;
                case MyGravity_Horz_Right:
                {
                    sbv.myFrame.leftPos += colMaxWidth - sbv.leftPosInner.margin - sbv.rightPosInner.margin - sbv.myFrame.width;
                }
                    break;
                case MyGravity_Horz_Fill:
                {
                    sbv.myFrame.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:colMaxWidth - sbv.leftPosInner.margin - sbv.rightPosInner.margin sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }
}


-(CGFloat)myCalcSingleLineSize:(NSArray*)sbs margin:(CGFloat)margin
{
    CGFloat size = 0;
    for (UIView *sbv in sbs)
    {
        size += sbv.myFrame.rightPos;
        if (sbv != sbs.lastObject)
            size += margin;
    }
    
    return size;
}

-(NSArray*)myGetAutoArrangeSubviews:(NSMutableArray*)sbs selfSize:(CGFloat)selfSize margin:(CGFloat)margin
{
    
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:sbs.count];
    
    NSMutableArray *bestSingleLineArray = [NSMutableArray arrayWithCapacity:sbs.count /2];
    
    while (sbs.count) {
        
        [self myCalcAutoArrangeSingleLineSubviews:sbs
                                          index:0
                                      calcArray:@[]
                                       selfSize:selfSize
                                         margin:margin
                            bestSingleLineArray:bestSingleLineArray];
        
        [retArray addObjectsFromArray:bestSingleLineArray];
        
        [bestSingleLineArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            [sbs removeObject:obj];
        }];
        
        [bestSingleLineArray removeAllObjects];
    }
    
    return retArray;
}

-(void)myCalcAutoArrangeSingleLineSubviews:(NSMutableArray*)sbs
                                   index:(NSInteger)index
                               calcArray:(NSArray*)calcArray
                                selfSize:(CGFloat)selfSize
                                  margin:(CGFloat)margin
                     bestSingleLineArray:(NSMutableArray*)bestSingleLineArray
{
    if (index >= sbs.count)
    {
        CGFloat s1 = [self myCalcSingleLineSize:calcArray margin:margin];
        CGFloat s2 = [self myCalcSingleLineSize:bestSingleLineArray margin:margin];
        if (fabs(selfSize - s1) < fabs(selfSize - s2) && /*s1 <= selfSize*/ _myCGFloatLessOrEqual(s1, selfSize) )
        {
            [bestSingleLineArray setArray:calcArray];
        }
        
        return;
    }
    
    
    for (NSInteger i = index; i < sbs.count; i++) {
        
        
        NSMutableArray *calcArray2 = [NSMutableArray arrayWithArray:calcArray];
        [calcArray2 addObject:sbs[i]];
        
        CGFloat s1 = [self myCalcSingleLineSize:calcArray2 margin:margin];
        if (/*s1 <= selfSize*/ _myCGFloatLessOrEqual(s1, selfSize))
        {
            CGFloat s2 = [self myCalcSingleLineSize:bestSingleLineArray margin:margin];
            if (fabs(selfSize - s1) < fabs(selfSize - s2))
            {
                [bestSingleLineArray setArray:calcArray2];
            }
            
            if (/*s1 == selfSize*/ _myCGFloatEqual(s1, selfSize))
                break;
            
            [self myCalcAutoArrangeSingleLineSubviews:sbs
                                              index:i + 1
                                          calcArray:calcArray2
                                           selfSize:selfSize
                                             margin:margin
                                bestSingleLineArray:bestSingleLineArray];
            
        }
        else
            break;
        
    }
    
}


-(CGSize)myLayoutSubviewsForVertContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs
{
    
    UIEdgeInsets padding = self.padding;
    CGFloat xPos = padding.left;
    CGFloat yPos = padding.top;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    
    MyGravity mgvert = self.gravity & MyGravity_Horz_Mask;
    MyGravity mghorz = self.gravity & MyGravity_Vert_Mask;
    MyGravity amgvert = self.arrangedGravity & MyGravity_Horz_Mask;
    
    //支持浮动水平间距。
    CGFloat vertSpace = self.subviewVSpace;
    CGFloat horzSpace = self.subviewHSpace;
    CGFloat subviewSize = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat minSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).maxSpace;
        
        NSInteger rowCount =  floor((selfSize.width - padding.left - padding.right  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            horzSpace = (selfSize.width - padding.left - padding.right - subviewSize * rowCount)/(rowCount - 1);
            if (horzSpace > maxSpace)
            {
                horzSpace = maxSpace;
                
                subviewSize =  (selfSize.width - padding.left - padding.right -  horzSpace * (rowCount - 1)) / rowCount;
                
            }
        }
    }
    
    
    if (self.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            
#ifdef DEBUG
            //约束异常：垂直流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbv.weight == 0, @"Constraint exception!! vertical flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            CGFloat leftMargin = sbv.leftPosInner.margin;
            CGFloat rightMargin = sbv.rightPosInner.margin;
            CGRect rect = sbv.myFrame.frame;
            
            if (sbv.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbv.widthSizeInner.measure;
            
            
            [self mySetSubviewRelativeDimeSize:sbv.widthSizeInner selfSize:selfSize pRect:&rect];
            
            rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            //暂时把宽度存放sbv.myFrame.rightPos上。因为浮动布局来说这个属性无用。
            sbv.myFrame.rightPos = leftMargin + rect.size.width + rightMargin;
            if (sbv.myFrame.rightPos > selfSize.width - padding.left - padding.right)
                sbv.myFrame.rightPos = selfSize.width - padding.left - padding.right;
        }
        
        [sbs setArray:[self myGetAutoArrangeSubviews:sbs selfSize:selfSize.width - padding.left - padding.right margin:horzSpace]];
        
    }
    
    
    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        CGFloat topMargin = sbv.topPosInner.margin;
        CGFloat leftMargin = sbv.leftPosInner.margin;
        CGFloat bottomMargin = sbv.bottomPosInner.margin;
        CGFloat rightMargin = sbv.rightPosInner.margin;
        CGRect rect = sbv.myFrame.frame;
        
        
        if (subviewSize != 0)
            rect.size.width = subviewSize;
        
        if (sbv.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbv.widthSizeInner.measure;
        
        if (sbv.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbv.heightSizeInner.measure;
        
        
        [self mySetSubviewRelativeDimeSize:sbv.widthSizeInner selfSize:selfSize pRect:&rect];
        
        [self mySetSubviewRelativeDimeSize:sbv.heightSizeInner selfSize:selfSize pRect:&rect];
        
        
        if (sbv.weight != 0)
        {
            //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
            CGFloat floatWidth = selfSize.width - padding.left - padding.right - rowMaxWidth;
            if (/*floatWidth <= 0*/ _myCGFloatLessOrEqual(floatWidth, 0))
            {
                floatWidth += rowMaxWidth;
                arrangedIndex = 0;
            }
            
            if (arrangedIndex != 0)
                floatWidth -= horzSpace;
            
            rect.size.width = (floatWidth + sbv.widthSizeInner.addVal) * sbv.weight - leftMargin - rightMargin;
            
        }
        
        
        rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbv.heightSizeInner.dimeRelaVal != nil && sbv.heightSizeInner.dimeRelaVal == sbv.widthSizeInner)
            rect.size.height = [sbv.heightSizeInner measureWith:rect.size.width ];
        
        
        //如果高度是浮动的则需要调整高度。
        if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
            rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
        
        rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算xPos的值加上leftMargin + rect.size.width + rightMargin + horzMargin 的值要小于整体的宽度。
        CGFloat place = xPos + leftMargin + rect.size.width + rightMargin;
        if (arrangedIndex != 0)
            place += horzSpace;
        place += padding.right;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.width > 0.0001)
        {
            xPos = padding.left;
            yPos += vertSpace;
            yPos += rowMaxHeight;
            
            
            [arrangeIndexSet addIndex:i - arrangedIndex];
            //计算每行的gravity情况。
            [self myCalcVertLayoutGravity:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertSpace horzMargin:horzSpace];
            
            //计算单独的sbv的宽度是否大于整体的宽度。如果大于则缩小宽度。
            if (leftMargin + rightMargin + rect.size.width > selfSize.width - padding.left - padding.right)
            {
                
                rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:selfSize.width - padding.left - padding.right - leftMargin - rightMargin sbvSize:rect.size selfLayoutSize:selfSize];
                
                if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
                {
                    rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
                    rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }
                
            }
            
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            arrangedIndex = 0;
            
        }
        
        if (arrangedIndex != 0)
            xPos += horzSpace;
        
        
        rect.origin.x = xPos + leftMargin;
        rect.origin.y = yPos + topMargin;
        xPos += leftMargin + rect.size.width + rightMargin;
        
        if (rowMaxHeight < topMargin + bottomMargin + rect.size.height)
            rowMaxHeight = topMargin + bottomMargin + rect.size.height;
        
        if (rowMaxWidth < (xPos - padding.left))
            rowMaxWidth = (xPos - padding.left);
        
        
        
        sbv.myFrame.frame = rect;
        
        arrangedIndex++;
        
        
        
    }
    
    //最后一行
    [arrangeIndexSet addIndex:i - arrangedIndex];
    
    [self myCalcVertLayoutGravity:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertSpace horzMargin:horzSpace];
    
    
    if (self.wrapContentHeight)
        selfSize.height = yPos + padding.bottom + rowMaxHeight;
    else
    {
        CGFloat addYPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        
        if (mgvert == MyGravity_Vert_Center)
        {
            addYPos = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / 2;
        }
        else if (mgvert == MyGravity_Vert_Bottom)
        {
            addYPos = selfSize.height - padding.bottom - rowMaxHeight - yPos;
        }
        else if (mgvert == MyGravity_Vert_Fill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / arrangeIndexSet.count;
        }
        else if (mgvert == MyGravity_Vert_Between)
        {
            if (arrangeIndexSet.count > 1)
                between = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / (arrangeIndexSet.count - 1);
        }
        
        if (addYPos != 0 || between != 0 || fill != 0)
        {
            int line = 0;
            NSUInteger lastIndex = 0;
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                sbv.myFrame.topPos += addYPos;
                
                //找到行的最初索引。
                NSUInteger index = [arrangeIndexSet indexLessThanOrEqualToIndex:i];
                if (lastIndex != index)
                {
                    lastIndex = index;
                    line ++;
                }
                
                sbv.myFrame.height += fill;
                sbv.myFrame.topPos += fill * line;
                
                sbv.myFrame.topPos += between * line;
                
            }
        }
        
    }
    
    
    return selfSize;
    
}


-(CGSize)myLayoutSubviewsForVert:(CGSize)selfSize sbs:(NSMutableArray*)sbs
{
    UIEdgeInsets padding = self.padding;
    NSInteger arrangedCount = self.arrangedCount;
    CGFloat xPos = padding.left;
    CGFloat yPos = padding.top;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    CGFloat maxWidth = padding.left;  //全部行的最宽值
    MyGravity mgvert = self.gravity & MyGravity_Horz_Mask;
    MyGravity mghorz = self.gravity & MyGravity_Vert_Mask;
    MyGravity amgvert = self.arrangedGravity & MyGravity_Horz_Mask;
    
    CGFloat vertSpace = self.subviewVSpace;
    CGFloat horzSpace = self.subviewHSpace;
    
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] &&
                           ((UIScrollView*)self.superview).isPagingEnabled);
    CGFloat pagingItemHeight = 0;
    CGFloat pagingItemWidth = 0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (self.pagedCount > 0 && self.superview != nil)
    {
        NSInteger rows = self.pagedCount / arrangedCount;  //每页的行数。
        
        //对于垂直流式布局来说，要求要有明确的宽度。因此如果我们启用了分页又设置了宽度包裹时则我们的分页是从左到右的排列。否则分页是从上到下的排列。
        if (self.wrapContentWidth)
        {
            isHorzPaging = YES;
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - padding.left - padding.right - (arrangedCount - 1) * horzSpace ) / arrangedCount;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - padding.left - arrangedCount * horzSpace ) / arrangedCount;
            
            pagingItemHeight = (selfSize.height - padding.top - padding.bottom - (rows - 1) * vertSpace) / rows;
        }
        else
        {
            isVertPaging = YES;
            pagingItemWidth = (selfSize.width - padding.left - padding.right - (arrangedCount - 1) * horzSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的高度计算是不一样的。
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - padding.top - padding.bottom - (rows - 1) * vertSpace) / rows;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - padding.top - rows * vertSpace) / rows;
            
        }
        
    }
    
    
    BOOL averageArrange = (mghorz == MyGravity_Horz_Fill);
    
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    CGFloat rowTotalWeight = 0;
    CGFloat rowTotalFixedWidth = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        if (arrangedIndex >= arrangedCount)
        {
            arrangedIndex = 0;
            
            if (rowTotalWeight != 0 && !averageArrange)
            {
                [self myCalcVertLayoutWeight:selfSize totalFloatWidth:selfSize.width - padding.left - padding.right - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }
            
            rowTotalWeight = 0;
            rowTotalFixedWidth = 0;
            
        }
        
        CGFloat leftMargin = sbv.leftPosInner.margin;
        CGFloat rightMargin = sbv.rightPosInner.margin;
        CGRect rect = sbv.myFrame.frame;
        
        
        if (sbv.weight != 0)
        {
            
            rowTotalWeight += sbv.weight;
        }
        else
        {
            if (pagingItemWidth != 0)
                rect.size.width = pagingItemWidth;
            
            if (sbv.widthSizeInner.dimeNumVal != nil && !averageArrange)
                rect.size.width = sbv.widthSizeInner.measure;
            
            
            [self mySetSubviewRelativeDimeSize:sbv.widthSizeInner selfSize:selfSize pRect:&rect];
            
            
            rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            rowTotalFixedWidth += rect.size.width;
        }
        
        rowTotalFixedWidth += leftMargin + rightMargin;
        
        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedWidth += horzSpace;
        
        
        sbv.myFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedWidth -= horzSpace;
        
        [self myCalcVertLayoutWeight:selfSize totalFloatWidth:selfSize.width - padding.left - padding.right - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }
    
    
    CGFloat pageWidth  = 0; //页宽。
    CGFloat averageWidth = (selfSize.width - padding.left - padding.right - (arrangedCount - 1) * horzSpace) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        //新的一行
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            yPos += rowMaxHeight;
            yPos += vertSpace;
            
            //分别处理水平分页和垂直分页。
            if (isHorzPaging)
            {
                if (i % self.pagedCount == 0)
                {
                    pageWidth += CGRectGetWidth(self.superview.bounds);
                    
                    if (!isPagingScroll)
                        pageWidth -= padding.left;
                    
                    yPos = padding.top;
                }
                
            }
            
            if (isVertPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % self.pagedCount == 0)
                {
                    
                    if (isPagingScroll)
                    {
                        yPos -= vertSpace;
                        yPos += padding.bottom;
                        yPos += padding.top;
                    }
                }
            }
            
            
            xPos = padding.left + pageWidth;
            
            
            //计算每行的gravity情况。
            [self myCalcVertLayoutGravity:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedCount vertMargin:vertSpace horzMargin:horzSpace];
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            
        }
        
        
        CGFloat topMargin = sbv.topPosInner.margin;
        CGFloat leftMargin = sbv.leftPosInner.margin;
        CGFloat bottomMargin = sbv.bottomPosInner.margin;
        CGFloat rightMargin = sbv.rightPosInner.margin;
        CGRect rect = sbv.myFrame.frame;
        BOOL isFlexedHeight = sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && !sbv.heightSizeInner.isMatchParent;
        
        if (pagingItemHeight != 0)
            rect.size.height = pagingItemHeight;
        
        
        if (sbv.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbv.heightSizeInner.measure;
        
        if (averageArrange)
        {
            rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:averageWidth - leftMargin - rightMargin sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        [self mySetSubviewRelativeDimeSize:sbv.heightSizeInner selfSize:selfSize pRect:&rect];
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
            rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
        
        
        rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        rect.origin.x = xPos + leftMargin;
        rect.origin.y = yPos + topMargin;
        xPos += leftMargin + rect.size.width + rightMargin;
        
        if (arrangedIndex != (arrangedCount - 1))
            xPos += horzSpace;
        
        
        if (rowMaxHeight < topMargin + bottomMargin + rect.size.height)
            rowMaxHeight = topMargin + bottomMargin + rect.size.height;
        
        if (rowMaxWidth < (xPos - padding.left))
            rowMaxWidth = (xPos - padding.left);
        
        if (maxWidth < xPos)
            maxWidth = xPos;
        
        
        
        sbv.myFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行
    [self myCalcVertLayoutGravity:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertSpace horzMargin:horzSpace];
    
    if (self.wrapContentHeight)
    {
        selfSize.height = yPos + padding.bottom + rowMaxHeight;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + self.pagedCount - 1.0 ) / self.pagedCount);
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
        
        if (mgvert == MyGravity_Vert_Center)
        {
            addYPos = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / 2;
        }
        else if (mgvert == MyGravity_Vert_Bottom)
        {
            addYPos = selfSize.height - padding.bottom - rowMaxHeight - yPos;
        }
        else if (mgvert == MyGravity_Vert_Fill)
        {
            if (arranges > 0)
                fill = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / arranges;
        }
        else if (mgvert == MyGravity_Vert_Between)
        {
            
            if (arranges > 1)
                between = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / (arranges - 1);
        }
        
        
        if (addYPos != 0 || between != 0 || fill != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                int lines = i / arrangedCount;
                sbv.myFrame.height += fill;
                sbv.myFrame.topPos += fill * lines;
                
                sbv.myFrame.topPos += addYPos;
                
                sbv.myFrame.topPos += between * lines;
                
            }
        }
        
    }
    
    if (self.wrapContentWidth && !averageArrange)
    {
        selfSize.width = maxWidth + padding.right;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + self.pagedCount - 1.0 ) / self.pagedCount);
            if (selfSize.width < totalPages * CGRectGetWidth(self.superview.bounds))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }
        
    }
    
    
    return selfSize;
}





-(CGSize)myLayoutSubviewsForHorzContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs
{
    
    UIEdgeInsets padding = self.padding;
    CGFloat xPos = padding.left;
    CGFloat yPos = padding.top;
    CGFloat colMaxWidth = 0;  //某一列的最宽值。
    CGFloat colMaxHeight = 0;   //某一列的最高值
    
    MyGravity mgvert = self.gravity & MyGravity_Horz_Mask;
    MyGravity mghorz = self.gravity & MyGravity_Vert_Mask;
    MyGravity amghorz = self.arrangedGravity & MyGravity_Vert_Mask;
    
    
    //支持浮动垂直间距。
    CGFloat vertSpace = self.subviewVSpace;
    CGFloat horzSpace = self.subviewHSpace;
    CGFloat subviewSize = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat minSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).maxSpace;
        NSInteger rowCount =  floor((selfSize.height - padding.top - padding.bottom  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            vertSpace = (selfSize.height - padding.top - padding.bottom - subviewSize * rowCount)/(rowCount - 1);
            if (vertSpace > maxSpace)
            {
                vertSpace = maxSpace;
                
                subviewSize =  (selfSize.height - padding.top - padding.bottom -  vertSpace * (rowCount - 1)) / rowCount;
                
            }
        }
    }
    
    
    if (self.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            
#ifdef DEBUG
            //约束异常：水平流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbv.weight == 0, @"Constraint exception!! horizontal flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            
            
            CGFloat topMargin = sbv.topPosInner.margin;
            CGFloat bottomMargin = sbv.bottomPosInner.margin;
            CGRect rect = sbv.myFrame.frame;
            
            if (sbv.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbv.widthSizeInner.measure;
            
            if (sbv.heightSizeInner.dimeNumVal != nil)
                rect.size.height = sbv.heightSizeInner.measure;
            
            [self mySetSubviewRelativeDimeSize:sbv.heightSizeInner selfSize:selfSize pRect:&rect];
            
            rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            [self mySetSubviewRelativeDimeSize:sbv.widthSizeInner selfSize:selfSize pRect:&rect];
            
            rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            
            //如果高度是浮动的则需要调整高度。
            if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
            {
                rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
                
                rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            
            //暂时把宽度存放sbv.myFrame.rightPos上。因为浮动布局来说这个属性无用。
            sbv.myFrame.rightPos = topMargin + rect.size.height + bottomMargin;
            if (sbv.myFrame.rightPos > selfSize.height - padding.top - padding.bottom)
                sbv.myFrame.rightPos = selfSize.height - padding.top - padding.bottom;
        }
        
        [sbs setArray:[self myGetAutoArrangeSubviews:sbs selfSize:selfSize.height - padding.top - padding.bottom margin:vertSpace]];
        
    }
    
    
    
    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        CGFloat topMargin = sbv.topPosInner.margin;
        CGFloat leftMargin = sbv.leftPosInner.margin;
        CGFloat bottomMargin = sbv.bottomPosInner.margin;
        CGFloat rightMargin = sbv.rightPosInner.margin;
        CGRect rect = sbv.myFrame.frame;
        
        if (sbv.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbv.widthSizeInner.measure;
        
        if (sbv.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbv.heightSizeInner.measure;
        
        [self mySetSubviewRelativeDimeSize:sbv.heightSizeInner selfSize:selfSize pRect:&rect];
        
        if (subviewSize != 0)
            rect.size.height = subviewSize;
        
        
        [self mySetSubviewRelativeDimeSize:sbv.widthSizeInner selfSize:selfSize pRect:&rect];
        
        
        if (sbv.weight != 0)
        {
            //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
            CGFloat floatHeight = selfSize.height - padding.top - padding.bottom - colMaxHeight;
            if (/*floatHeight <= 0*/ _myCGFloatLessOrEqual(floatHeight, 0))
            {
                floatHeight += colMaxHeight;
                arrangedIndex = 0;
            }
            
            if (arrangedIndex != 0)
                floatHeight -= vertSpace;
            
            rect.size.height = (floatHeight + sbv.heightSizeInner.addVal) * sbv.weight - topMargin - bottomMargin;
            
        }
        
        
        rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbv.widthSizeInner.dimeRelaVal != nil && sbv.widthSizeInner.dimeRelaVal == sbv.heightSizeInner)
            rect.size.width = [sbv.widthSizeInner measureWith:rect.size.height ];
        
        
        
        rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果高度是浮动的则需要调整高度。
        if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
            
            rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算yPos的值加上topMargin + rect.size.height + bottomMargin + vertMargin 的值要小于整体的宽度。
        CGFloat place = yPos + topMargin + rect.size.height + bottomMargin;
        if (arrangedIndex != 0)
            place += vertSpace;
        place += padding.bottom;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.height > 0.0001)
        {
            yPos = padding.top;
            xPos += horzSpace;
            xPos += colMaxWidth;
            
            
            //计算每行的gravity情况。
            [arrangeIndexSet addIndex:i - arrangedIndex];
            [self myCalcHorzLayoutGravity:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertSpace horzMargin:horzSpace];
            
            //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
            if (topMargin + bottomMargin + rect.size.height > selfSize.height - padding.top - padding.bottom)
            {
                rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:selfSize.height - padding.top - padding.bottom - topMargin - bottomMargin sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            colMaxWidth = 0;
            colMaxHeight = 0;
            arrangedIndex = 0;
            
        }
        
        if (arrangedIndex != 0)
            yPos += vertSpace;
        
        
        rect.origin.x = xPos + leftMargin;
        rect.origin.y = yPos + topMargin;
        yPos += topMargin + rect.size.height + bottomMargin;
        
        if (colMaxWidth < leftMargin + rightMargin + rect.size.width)
            colMaxWidth = leftMargin + rightMargin + rect.size.width;
        
        if (colMaxHeight < (yPos - padding.top))
            colMaxHeight = (yPos - padding.top);
        
        
        
        sbv.myFrame.frame = rect;
        
        arrangedIndex++;
        
        
        
    }
    
    //最后一行
    [arrangeIndexSet addIndex:i - arrangedIndex];
    [self myCalcHorzLayoutGravity:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertSpace horzMargin:horzSpace];
    
    
    if (self.wrapContentWidth)
        selfSize.width = xPos + padding.right + colMaxWidth;
    else
    {
        CGFloat addXPos = 0;
        CGFloat fill = 0;
        CGFloat between = 0;
        
        if (mghorz == MyGravity_Horz_Center)
        {
            addXPos = (selfSize.width - padding.right - colMaxWidth - xPos) / 2;
        }
        else if (mghorz == MyGravity_Horz_Right)
        {
            addXPos = selfSize.width - padding.right - colMaxWidth - xPos;
        }
        else if (mghorz == MyGravity_Horz_Fill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.width - padding.right - colMaxWidth - xPos) / arrangeIndexSet.count;
        }
        else if (mghorz == MyGravity_Horz_Between)
        {
            if (arrangeIndexSet.count > 1)
                between = (selfSize.width - padding.right - colMaxWidth - xPos) / (arrangeIndexSet.count - 1);
        }
        
        
        if (addXPos != 0 || between != 0 || fill != 0)
        {
            int line = 0;
            NSUInteger lastIndex = 0;
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                sbv.myFrame.leftPos += addXPos;
                
                //找到行的最初索引。
                NSUInteger index = [arrangeIndexSet indexLessThanOrEqualToIndex:i];
                if (lastIndex != index)
                {
                    lastIndex = index;
                    line ++;
                }
                
                sbv.myFrame.width += fill;
                sbv.myFrame.leftPos += fill * line;
                
                sbv.myFrame.leftPos += between * line;
                
            }
        }
        
    }
    
    
    return selfSize;
}



-(CGSize)myLayoutSubviewsForHorz:(CGSize)selfSize sbs:(NSMutableArray*)sbs
{
    UIEdgeInsets padding = self.padding;
    NSInteger arrangedCount = self.arrangedCount;
    CGFloat xPos = padding.left;
    CGFloat yPos = padding.top;
    CGFloat colMaxWidth = 0;  //每列的最大宽度
    CGFloat colMaxHeight = 0; //每列的最大高度
    CGFloat maxHeight = padding.top;
    
    MyGravity mgvert = self.gravity & MyGravity_Horz_Mask;
    MyGravity mghorz = self.gravity & MyGravity_Vert_Mask;
    MyGravity amghorz = self.arrangedGravity & MyGravity_Vert_Mask;
    
    CGFloat vertSpace = self.subviewVSpace;
    CGFloat horzSpace = self.subviewHSpace;
    
    //父滚动视图是否分页滚动。
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] &&
                           ((UIScrollView*)self.superview).isPagingEnabled);
    
    CGFloat pagingItemHeight = 0;
    CGFloat pagingItemWidth = 0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (self.pagedCount > 0 && self.superview != nil)
    {
        NSInteger cols = self.pagedCount / arrangedCount;  //每页的列数。
        
        //对于水平流式布局来说，要求要有明确的高度。因此如果我们启用了分页又设置了高度包裹时则我们的分页是从上到下的排列。否则分页是从左到右的排列。
        if (self.wrapContentHeight)
        {
            isVertPaging = YES;
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - padding.top - padding.bottom - (arrangedCount - 1) * vertSpace ) / arrangedCount;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - padding.top - arrangedCount * vertSpace ) / arrangedCount;
            
            pagingItemWidth = (selfSize.width - padding.left - padding.right - (cols - 1) * horzSpace) / cols;
        }
        else
        {
            isHorzPaging = YES;
            pagingItemHeight = (selfSize.height - padding.top - padding.bottom - (arrangedCount - 1) * vertSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的宽度计算是不一样的。
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - padding.left - padding.right - (cols - 1) * horzSpace) / cols;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - padding.left - cols * horzSpace) / cols;
            
        }
        
    }
    
    BOOL averageArrange = (mgvert == MyGravity_Vert_Fill);
    
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    CGFloat rowTotalWeight = 0;
    CGFloat rowTotalFixedHeight = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        if (arrangedIndex >= arrangedCount)
        {
            arrangedIndex = 0;
            
            if (rowTotalWeight != 0 && !averageArrange)
            {
                [self myCalcHorzLayoutWeight:selfSize totalFloatHeight:selfSize.height - padding.top - padding.bottom - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }
            
            rowTotalWeight = 0;
            rowTotalFixedHeight = 0;
            
        }
        
        CGFloat topMargin = sbv.topPosInner.margin;
        CGFloat bottomMargin = sbv.bottomPosInner.margin;
        CGRect rect = sbv.myFrame.frame;
        
        
        if (pagingItemWidth != 0)
            rect.size.width = pagingItemWidth;
        
        if (sbv.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbv.widthSizeInner.measure;
        
        //当子视图的尺寸是相对依赖于其他尺寸的值。
        [self mySetSubviewRelativeDimeSize:sbv.widthSizeInner selfSize:selfSize pRect:&rect];
        
        
        rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        if (sbv.weight != 0)
        {
            
            rowTotalWeight += sbv.weight;
        }
        else
        {
            
            BOOL isFlexedHeight = sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && !sbv.heightSizeInner.isMatchParent;
            
            if (pagingItemHeight != 0)
                rect.size.height = pagingItemHeight;
            
            if (sbv.heightSizeInner.dimeNumVal != nil && !averageArrange)
                rect.size.height = sbv.heightSizeInner.measure;
            
            //当子视图的尺寸是相对依赖于其他尺寸的值。
            [self mySetSubviewRelativeDimeSize:sbv.heightSizeInner selfSize:selfSize pRect:&rect];
            
            
            //如果高度是浮动的则需要调整高度。
            if (isFlexedHeight)
                rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
            
            rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (sbv.widthSizeInner.dimeRelaVal != nil && sbv.widthSizeInner.dimeRelaVal == sbv.heightSizeInner)
                rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:[sbv.widthSizeInner measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
            
            rowTotalFixedHeight += rect.size.height;
        }
        
        rowTotalFixedHeight += topMargin + bottomMargin;
        
        
        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedHeight += vertSpace;
        
        
        sbv.myFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedHeight -= vertSpace;
        
        [self myCalcHorzLayoutWeight:selfSize totalFloatHeight:selfSize.height - padding.top - padding.bottom - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }
    
    
    CGFloat pageHeight = 0; //页高
    CGFloat averageHeight = (selfSize.height - padding.top - padding.bottom - (arrangedCount - 1) * vertSpace) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            xPos += colMaxWidth;
            xPos += horzSpace;
            
            //分别处理水平分页和垂直分页。
            if (isVertPaging)
            {
                if (i % self.pagedCount == 0)
                {
                    pageHeight += CGRectGetHeight(self.superview.bounds);
                    
                    if (!isPagingScroll)
                        pageHeight -= padding.top;
                    
                    xPos = padding.left;
                }
                
            }
            
            if (isHorzPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % self.pagedCount == 0)
                {
                    
                    if (isPagingScroll)
                    {
                        xPos -= horzSpace;
                        xPos += padding.right;
                        xPos += padding.left;
                    }
                }
            }
            
            
            yPos = padding.top + pageHeight;
            
            
            //计算每行的gravity情况。
            [self myCalcHorzLayoutGravity:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedCount vertMargin:vertSpace horzMargin:horzSpace];
            
            colMaxWidth = 0;
            colMaxHeight = 0;
        }
        
        CGFloat topMargin = sbv.topPosInner.margin;
        CGFloat leftMargin = sbv.leftPosInner.margin;
        CGFloat bottomMargin = sbv.bottomPosInner.margin;
        CGFloat rightMargin = sbv.rightPosInner.margin;
        CGRect rect = sbv.myFrame.frame;
        
        
        if (averageArrange)
        {
            
            rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:averageHeight - topMargin - bottomMargin sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (sbv.widthSizeInner.dimeRelaVal != nil && sbv.widthSizeInner.dimeRelaVal == sbv.heightSizeInner)
                rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:[sbv.widthSizeInner measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        rect.origin.y = yPos + topMargin;
        rect.origin.x = xPos + leftMargin;
        yPos += topMargin + rect.size.height + bottomMargin;
        
        if (arrangedIndex != (arrangedCount - 1))
            yPos += vertSpace;
        
        
        if (colMaxWidth < leftMargin + rightMargin + rect.size.width)
            colMaxWidth = leftMargin + rightMargin + rect.size.width;
        
        if (colMaxHeight < (yPos - padding.top))
            colMaxHeight = yPos - padding.top;
        
        if (maxHeight < yPos)
            maxHeight = yPos;
        
        
        sbv.myFrame.frame = rect;
        
        
        arrangedIndex++;
        
    }
    
    //最后一列
    [self myCalcHorzLayoutGravity:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertSpace horzMargin:horzSpace];
    
    if (self.wrapContentHeight && !averageArrange)
    {
        selfSize.height = maxHeight + padding.bottom;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + self.pagedCount - 1.0 ) / self.pagedCount);
            if (selfSize.height < totalPages * CGRectGetHeight(self.superview.bounds))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }
        
        
    }
    
    if (self.wrapContentWidth)
    {
        selfSize.width = xPos + padding.right + colMaxWidth;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + self.pagedCount - 1.0 ) / self.pagedCount);
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
        
        if (mghorz == MyGravity_Horz_Center)
        {
            addXPos = (selfSize.width - padding.right - colMaxWidth - xPos) / 2;
        }
        else if (mghorz == MyGravity_Horz_Right)
        {
            addXPos = selfSize.width - padding.right - colMaxWidth - xPos;
        }
        else if (mghorz == MyGravity_Horz_Fill)
        {
            if (arranges > 0)
                fill = (selfSize.width - padding.right - colMaxWidth - xPos) / arranges;
        }
        else if (mghorz == MyGravity_Horz_Between)
        {
            if (arranges > 1)
                between = (selfSize.width - padding.left - colMaxWidth - xPos) / (arranges - 1);
        }
        
        if (addXPos != 0 || between != 0 || fill != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                int lines = i / arrangedCount;
                sbv.myFrame.width += fill;
                sbv.myFrame.leftPos += fill * lines;
                
                sbv.myFrame.leftPos += addXPos;
                
                sbv.myFrame.leftPos += between * lines;
                
            }
        }
    }
    
    
    
    
    return selfSize;
    
}



@end

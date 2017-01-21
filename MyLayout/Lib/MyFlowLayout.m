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

-(id)initWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    self = [super init];
    if (self != nil)
    {
        self.myCurrentSizeClass.orientation = orientation;
        self.myCurrentSizeClass.arrangedCount = arrangedCount;
    }
    
    return self;
}


+(id)flowLayoutWithOrientation:(MyLayoutViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount
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


-(void)setAverageArrange:(BOOL)averageArrange
{
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        if (averageArrange)
            self.gravity = (self.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Fill;
        else
            self.gravity = (self.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_None;
    }
    else
    {
        if (averageArrange)
            self.gravity = (self.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Fill;
        else
            self.gravity = (self.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_None;
    }

}

-(BOOL)averageArrange
{
    if (self.orientation == MyLayoutViewOrientation_Vert)
        return (self.gravity & MyMarginGravity_Vert_Mask) == MyMarginGravity_Horz_Fill;
    else
        return (self.gravity & MyMarginGravity_Horz_Mask) == MyMarginGravity_Vert_Fill;
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

-(void)setGravity:(MyMarginGravity)gravity
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.gravity != gravity)
    {
        lsc.gravity = gravity;
        [self setNeedsLayout];
    }
}

-(MyMarginGravity)gravity
{
    return self.myCurrentSizeClass.gravity;
}

-(void)setArrangedGravity:(MyMarginGravity)arrangedGravity
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.arrangedGravity != arrangedGravity)
    {
        lsc.arrangedGravity = arrangedGravity;
        [self setNeedsLayout];
    }
}

-(MyMarginGravity)arrangedGravity
{
    return self.myCurrentSizeClass.arrangedGravity;
}

-(void)setSubviewHorzMargin:(CGFloat)subviewHorzMargin
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;

    if (lsc.subviewHorzMargin != subviewHorzMargin)
    {
        lsc.subviewHorzMargin = subviewHorzMargin;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewHorzMargin
{
    return self.myCurrentSizeClass.subviewHorzMargin;
}

-(void)setSubviewVertMargin:(CGFloat)subviewVertMargin
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.subviewVertMargin != subviewVertMargin)
    {
        lsc.subviewVertMargin = subviewVertMargin;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewVertMargin
{
    return self.myCurrentSizeClass.subviewVertMargin;
}

-(CGFloat)subviewMargin
{
    return self.myCurrentSizeClass.subviewMargin;
}

-(void)setSubviewMargin:(CGFloat)subviewMargin
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.subviewMargin != subviewMargin)
    {
        lsc.subviewMargin = subviewMargin;
        [self setNeedsLayout];
    }
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


- (void)calcVertLayoutWeight:(CGSize)selfSize totalFloatWidth:(CGFloat)totalFloatWidth totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        if (sbv.weight != 0)
        {
            sbv.myFrame.width =  [self validMeasure:sbv.widthDime sbv:sbv calcSize:[sbv.widthDime measureWith: (totalFloatWidth * sbv.weight / totalWeight) ] sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            sbv.myFrame.rightPos = sbv.myFrame.leftPos + sbv.myFrame.width;
        }
    }
}

- (void)calcHorzLayoutWeight:(CGSize)selfSize totalFloatHeight:(CGFloat)totalFloatHeight totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        if (sbv.weight != 0)
        {
            sbv.myFrame.height =  [self validMeasure:sbv.heightDime sbv:sbv calcSize:[sbv.heightDime measureWith:(totalFloatHeight * sbv.weight / totalWeight) ] sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            sbv.myFrame.bottomPos = sbv.myFrame.topPos + sbv.myFrame.height;
            
            if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
                sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:[sbv.widthDime measureWith: sbv.myFrame.height ] sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            
        }
    }
}



- (void)calcVertLayoutGravity:(CGSize)selfSize rowMaxHeight:(CGFloat)rowMaxHeight rowMaxWidth:(CGFloat)rowMaxWidth mg:(MyMarginGravity)mg amg:(MyMarginGravity)amg sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertMargin:(CGFloat)vertMargin horzMargin:(CGFloat)horzMargin
{
    
    UIEdgeInsets padding = self.padding;
    CGFloat addXPos = 0;
    CGFloat addXFill = 0;
    BOOL averageArrange = (mg == MyMarginGravity_Horz_Fill);
    
    if (!averageArrange || self.arrangedCount == 0)
    {
        switch (mg) {
            case MyMarginGravity_Horz_Center:
            {
                addXPos = (selfSize.width - padding.left - padding.right - rowMaxWidth) / 2;
            }
                break;
            case MyMarginGravity_Horz_Right:
            {
                addXPos = selfSize.width - padding.left - padding.right - rowMaxWidth; //因为具有不考虑左边距，而原来的位置增加了左边距，因此
            }
                break;
            case MyMarginGravity_Horz_Between:
            {
                //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效。
                if (startIndex != sbs.count && count > 1)
                {
                  addXFill = (selfSize.width - padding.left - padding.right - rowMaxWidth) / (count - 1);
                }
            }
                break;
            default:
                break;
        }
        
        //处理内容拉伸的情况。
        if (self.arrangedCount == 0 && averageArrange)
        {
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
        
        if (self.IntelligentBorderLine != nil)
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderLine)
                {
                    sbvl.leftBorderLine = nil;
                    sbvl.topBorderLine = nil;
                    sbvl.rightBorderLine = nil;
                    sbvl.bottomBorderLine = nil;
                    
                    //如果不是最后一行就画下面，
                    if (startIndex != sbs.count)
                    {
                        sbvl.bottomBorderLine = self.IntelligentBorderLine;
                    }
                    
                    //如果不是最后一列就画右边,
                    if (j < startIndex - 1)
                    {
                        sbvl.rightBorderLine = self.IntelligentBorderLine;
                    }
                    
                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && self.arrangedCount != count )
                    {
                        sbvl.rightBorderLine = self.IntelligentBorderLine;
                    }
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertMargin != 0 && startIndex - count != 0)
                    {
                        sbvl.topBorderLine = self.IntelligentBorderLine;
                    }
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzMargin != 0 && j != startIndex - count)
                    {
                        sbvl.leftBorderLine = self.IntelligentBorderLine;
                    }
                    
                }
            }
        }
        
        if ((amg != MyMarginGravity_None && amg != MyMarginGravity_Vert_Top) || /*addXPos != 0*/_myCGFloatNotEqual(addXPos, 0)  || /*addXFill != 0*/ _myCGFloatNotEqual(addXFill, 0))
        {
            
            sbv.myFrame.leftPos += addXPos;
            
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
                //只拉伸间距
                sbv.myFrame.leftPos += addXFill * (j - (startIndex - count));
            }
            
            
            switch (amg) {
                case MyMarginGravity_Vert_Center:
                {
                    sbv.myFrame.topPos += (rowMaxHeight - sbv.topPos.margin - sbv.bottomPos.margin - sbv.myFrame.height) / 2;
                    
                }
                    break;
                case MyMarginGravity_Vert_Bottom:
                {
                    sbv.myFrame.topPos += rowMaxHeight - sbv.topPos.margin - sbv.bottomPos.margin - sbv.myFrame.height;
                }
                    break;
                case MyMarginGravity_Vert_Fill:
                {
                    sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rowMaxHeight - sbv.topPos.margin - sbv.bottomPos.margin sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }

}

- (void)calcHorzLayoutGravity:(CGSize)selfSize colMaxWidth:(CGFloat)colMaxWidth colMaxHeight:(CGFloat)colMaxHeight mg:(MyMarginGravity)mg  amg:(MyMarginGravity)amg sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertMargin:(CGFloat)vertMargin horzMargin:(CGFloat)horzMargin
{
    
    CGFloat addYPos = 0;
    CGFloat addYFill = 0;
    UIEdgeInsets padding = self.padding;
    BOOL averageArrange = (mg == MyMarginGravity_Vert_Fill);
    
    if (!averageArrange || self.arrangedCount == 0)
    {
        switch (mg) {
            case MyMarginGravity_Vert_Center:
            {
                addYPos = (selfSize.height - padding.top - padding.bottom - colMaxHeight) / 2;
            }
                break;
            case MyMarginGravity_Vert_Bottom:
            {
                addYPos = selfSize.height - padding.top - padding.bottom - colMaxHeight;
            }
                break;
            case MyMarginGravity_Vert_Between:
            {
                //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效。
                if (startIndex != sbs.count && count > 1)
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
        
        if (self.IntelligentBorderLine != nil)
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderLine)
                {
                    sbvl.leftBorderLine = nil;
                    sbvl.topBorderLine = nil;
                    sbvl.rightBorderLine = nil;
                    sbvl.bottomBorderLine = nil;
                    
                  
                    //如果不是最后一行就画下面，
                    if (j < startIndex - 1)
                    {
                        sbvl.bottomBorderLine = self.IntelligentBorderLine;
                    }
                    
                    //如果不是最后一列就画右边,
                    if (startIndex != sbs.count )
                    {
                        sbvl.rightBorderLine = self.IntelligentBorderLine;
                    }
                    
                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && self.arrangedCount != count )
                    {
                        sbvl.bottomBorderLine = self.IntelligentBorderLine;
                    }
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertMargin != 0 && j != startIndex - count)
                    {
                        sbvl.topBorderLine = self.IntelligentBorderLine;
                    }
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzMargin != 0 && startIndex - count != 0  )
                    {
                        sbvl.leftBorderLine = self.IntelligentBorderLine;
                    }


                    
                }
            }
        }
        
        
        if ((amg != MyMarginGravity_None && amg != MyMarginGravity_Horz_Left) || /*addYPos != 0*/_myCGFloatNotEqual(addYPos, 0) || /*addYFill != 0*/_myCGFloatNotEqual(addYFill, 0) )
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
                case MyMarginGravity_Horz_Center:
                {
                    sbv.myFrame.leftPos += (colMaxWidth - sbv.leftPos.margin - sbv.rightPos.margin - sbv.myFrame.width) / 2;
                    
                }
                    break;
                case MyMarginGravity_Horz_Right:
                {
                    sbv.myFrame.leftPos += colMaxWidth - sbv.leftPos.margin - sbv.rightPos.margin - sbv.myFrame.width;
                }
                    break;
                case MyMarginGravity_Horz_Fill:
                {
                    sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:colMaxWidth - sbv.leftPos.margin - sbv.rightPos.margin sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }
}


-(CGFloat)calcSingleLineSize:(NSArray*)sbs margin:(CGFloat)margin
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

-(NSArray*)getAutoArrangeSubviews:(NSMutableArray*)sbs selfSize:(CGFloat)selfSize margin:(CGFloat)margin
{
    
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:sbs.count];
    
    NSMutableArray *bestSingleLineArray = [NSMutableArray arrayWithCapacity:sbs.count /2];
    
    while (sbs.count) {
        
        [self calcAutoArrangeSingleLineSubviews:sbs
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

-(void)calcAutoArrangeSingleLineSubviews:(NSMutableArray*)sbs
     index:(NSInteger)index
 calcArray:(NSArray*)calcArray
selfSize:(CGFloat)selfSize
    margin:(CGFloat)margin
bestSingleLineArray:(NSMutableArray*)bestSingleLineArray
{
    if (index >= sbs.count)
    {
        CGFloat s1 = [self calcSingleLineSize:calcArray margin:margin];
        CGFloat s2 = [self calcSingleLineSize:bestSingleLineArray margin:margin];
        if (fabs(selfSize - s1) < fabs(selfSize - s2) && /*s1 <= selfSize*/ _myCGFloatLessOrEqual(s1, selfSize) )
        {
            [bestSingleLineArray setArray:calcArray];
        }
        
        return;
    }
    
    
    for (NSInteger i = index; i < sbs.count; i++) {
        
        
        NSMutableArray *calcArray2 = [NSMutableArray arrayWithArray:calcArray];
        [calcArray2 addObject:sbs[i]];
        
        CGFloat s1 = [self calcSingleLineSize:calcArray2 margin:margin];
        if (/*s1 <= selfSize*/ _myCGFloatLessOrEqual(s1, selfSize))
        {
            CGFloat s2 = [self calcSingleLineSize:bestSingleLineArray margin:margin];
            if (fabs(selfSize - s1) < fabs(selfSize - s2))
            {
                [bestSingleLineArray setArray:calcArray2];
            }
            
            if (/*s1 == selfSize*/ _myCGFloatEqual(s1, selfSize))
                break;
            
            [self calcAutoArrangeSingleLineSubviews:sbs
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


-(CGSize)layoutSubviewsForVertContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs
{
    
    UIEdgeInsets padding = self.padding;
    CGFloat xPos = padding.left;
    CGFloat yPos = padding.top;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    
    MyMarginGravity mgvert = self.gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity mghorz = self.gravity & MyMarginGravity_Vert_Mask;
    MyMarginGravity amgvert = self.arrangedGravity & MyMarginGravity_Horz_Mask;
    
    //支持浮动水平间距。
    CGFloat vertMargin = self.subviewVertMargin;
    CGFloat horzMargin = self.subviewHorzMargin;
    CGFloat subviewSize = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat minSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).maxSpace;
        
        NSInteger rowCount =  floor((selfSize.width - padding.left - padding.right  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            horzMargin = (selfSize.width - padding.left - padding.right - subviewSize * rowCount)/(rowCount - 1);
            if (horzMargin > maxSpace)
            {
                horzMargin = maxSpace;
                
                subviewSize =  (selfSize.width - padding.left - padding.right -  horzMargin * (rowCount - 1)) / rowCount;
                
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
            CGFloat leftMargin = sbv.leftPos.margin;
            CGFloat rightMargin = sbv.rightPos.margin;
            CGRect rect = sbv.myFrame.frame;
            
            if (sbv.widthDime.dimeNumVal != nil)
                rect.size.width = sbv.widthDime.measure;
            
            
            [self setSubviewRelativeDimeSize:sbv.widthDime selfSize:selfSize pRect:&rect];
            
            rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            //暂时把宽度存放sbv.myFrame.rightPos上。因为浮动布局来说这个属性无用。
            sbv.myFrame.rightPos = leftMargin + rect.size.width + rightMargin;
            if (sbv.myFrame.rightPos > selfSize.width - self.leftPadding - self.rightPadding)
                sbv.myFrame.rightPos = selfSize.width - self.leftPadding - self.rightPadding;
        }
        
        [sbs setArray:[self getAutoArrangeSubviews:sbs selfSize:selfSize.width - self.leftPadding - self.rightPadding margin:horzMargin]];
        
    }
    
    
    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.myFrame.frame;
        
        
        if (subviewSize != 0)
            rect.size.width = subviewSize;
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        
        [self setSubviewRelativeDimeSize:sbv.widthDime selfSize:selfSize pRect:&rect];
        
        [self setSubviewRelativeDimeSize:sbv.heightDime selfSize:selfSize pRect:&rect];

        
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
                floatWidth -= horzMargin;
            
            rect.size.width = (floatWidth + sbv.widthDime.addVal) * sbv.weight - leftMargin - rightMargin;
            
        }

        
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
            rect.size.height = [sbv.heightDime measureWith:rect.size.width ];
        
        
        //如果高度是浮动的则需要调整高度。
        if (sbv.isFlexedHeight)
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算xPos的值加上leftMargin + rect.size.width + rightMargin + horzMargin 的值要小于整体的宽度。
        CGFloat place = xPos + leftMargin + rect.size.width + rightMargin;
        if (arrangedIndex != 0)
            place += horzMargin;
        place += padding.right;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.width > 0.0001)
        {
            xPos = padding.left;
            yPos += vertMargin;
            yPos += rowMaxHeight;

            
            [arrangeIndexSet addIndex:i - arrangedIndex];
            //计算每行的gravity情况。
            [self calcVertLayoutGravity:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertMargin horzMargin:horzMargin];

            //计算单独的sbv的宽度是否大于整体的宽度。如果大于则缩小宽度。
            if (leftMargin + rightMargin + rect.size.width > selfSize.width - padding.left - padding.right)
            {
                
                rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:selfSize.width - padding.left - padding.right - leftMargin - rightMargin sbvSize:rect.size selfLayoutSize:selfSize];
                
                if (sbv.isFlexedHeight)
                {
                    rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
                    rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }
                
            }
            
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            arrangedIndex = 0;
            
        }
        
        if (arrangedIndex != 0)
            xPos += horzMargin;
        
        
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
    
    [self calcVertLayoutGravity:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertMargin horzMargin:horzMargin];

    
    if (self.wrapContentHeight)
        selfSize.height = yPos + padding.bottom + rowMaxHeight;
    else
    {
        CGFloat addYPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        
        if (mgvert == MyMarginGravity_Vert_Center)
        {
            addYPos = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / 2;
        }
        else if (mgvert == MyMarginGravity_Vert_Bottom)
        {
            addYPos = selfSize.height - padding.bottom - rowMaxHeight - yPos;
        }
        else if (mgvert == MyMarginGravity_Vert_Fill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / arrangeIndexSet.count;
        }
        else if (mgvert == MyMarginGravity_Vert_Between)
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


-(CGSize)layoutSubviewsForVert:(CGSize)selfSize sbs:(NSMutableArray*)sbs
{
    UIEdgeInsets padding = self.padding;
    NSInteger arrangedCount = self.arrangedCount;
    CGFloat xPos = padding.left;
    CGFloat yPos = padding.top;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    CGFloat maxWidth = padding.left;  //全部行的最宽值
    MyMarginGravity mgvert = self.gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity mghorz = self.gravity & MyMarginGravity_Vert_Mask;
    MyMarginGravity amgvert = self.arrangedGravity & MyMarginGravity_Horz_Mask;
    
    CGFloat vertMargin = self.subviewVertMargin;
    CGFloat horzMargin = self.subviewHorzMargin;
    
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
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - padding.left - padding.right - (arrangedCount - 1) * horzMargin ) / arrangedCount;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - padding.left - arrangedCount * horzMargin ) / arrangedCount;
            
            pagingItemHeight = (selfSize.height - padding.top - padding.bottom - (rows - 1) * vertMargin) / rows;
        }
        else
        {
            isVertPaging = YES;
            pagingItemWidth = (selfSize.width - padding.left - padding.right - (arrangedCount - 1) * horzMargin) / arrangedCount;
            //分页滚动时和非分页滚动时的高度计算是不一样的。
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - padding.top - padding.bottom - (rows - 1) * vertMargin) / rows;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - padding.top - rows * vertMargin) / rows;
            
        }
        
    }

    
    BOOL averageArrange = (mghorz == MyMarginGravity_Horz_Fill);
    
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
                [self calcVertLayoutWeight:selfSize totalFloatWidth:selfSize.width - padding.left - padding.right - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }
            
            rowTotalWeight = 0;
            rowTotalFixedWidth = 0;

        }
        
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.myFrame.frame;
        

        if (sbv.weight != 0)
        {
            
            rowTotalWeight += sbv.weight;
        }
        else
        {
            if (pagingItemWidth != 0)
                rect.size.width = pagingItemWidth;
            
            if (sbv.widthDime.dimeNumVal != nil && !averageArrange)
                rect.size.width = sbv.widthDime.measure;
            
            
            [self setSubviewRelativeDimeSize:sbv.widthDime selfSize:selfSize pRect:&rect];
            
            
            rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            rowTotalFixedWidth += rect.size.width;
        }
        
        rowTotalFixedWidth += leftMargin + rightMargin;
        
         if (arrangedIndex != (arrangedCount - 1))
             rowTotalFixedWidth += horzMargin;
        
        
        sbv.myFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedWidth -= horzMargin;
        
        [self calcVertLayoutWeight:selfSize totalFloatWidth:selfSize.width - padding.left - padding.right - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }
    
    
    CGFloat pageWidth  = 0; //页宽。
    CGFloat averageWidth = (selfSize.width - padding.left - padding.right - (arrangedCount - 1) * horzMargin) / arrangedCount;
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
            yPos += vertMargin;
            
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
                        yPos -= vertMargin;
                        yPos += padding.bottom;
                        yPos += padding.top;
                    }
                }
            }
            
            
            xPos = padding.left + pageWidth;

            
            //计算每行的gravity情况。
            [self calcVertLayoutGravity:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedCount vertMargin:vertMargin horzMargin:horzMargin];
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            
        }
        
        
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.myFrame.frame;
        BOOL isFlexedHeight = sbv.isFlexedHeight && !sbv.heightDime.isMatchParent;
        
        if (pagingItemHeight != 0)
            rect.size.height = pagingItemHeight;
        
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        if (averageArrange)
        {
            rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:averageWidth - leftMargin - rightMargin sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        [self setSubviewRelativeDimeSize:sbv.heightDime selfSize:selfSize pRect:&rect];
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
        
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
    
        rect.origin.x = xPos + leftMargin;
        rect.origin.y = yPos + topMargin;
        xPos += leftMargin + rect.size.width + rightMargin;
        
        if (arrangedIndex != (arrangedCount - 1))
            xPos += horzMargin;

        
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
    [self calcVertLayoutGravity:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertMargin horzMargin:horzMargin];

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
        
        if (mgvert == MyMarginGravity_Vert_Center)
        {
            addYPos = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / 2;
        }
        else if (mgvert == MyMarginGravity_Vert_Bottom)
        {
            addYPos = selfSize.height - padding.bottom - rowMaxHeight - yPos;
        }
        else if (mgvert == MyMarginGravity_Vert_Fill)
        {
            if (arranges > 0)
                fill = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / arranges;
        }
        else if (mgvert == MyMarginGravity_Vert_Between)
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





-(CGSize)layoutSubviewsForHorzContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs
{
    
    UIEdgeInsets padding = self.padding;
    CGFloat xPos = padding.left;
    CGFloat yPos = padding.top;
    CGFloat colMaxWidth = 0;  //某一列的最宽值。
    CGFloat colMaxHeight = 0;   //某一列的最高值
    
    MyMarginGravity mgvert = self.gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity mghorz = self.gravity & MyMarginGravity_Vert_Mask;
    MyMarginGravity amghorz = self.arrangedGravity & MyMarginGravity_Vert_Mask;
    
    
    //支持浮动垂直间距。
    CGFloat vertMargin = self.subviewVertMargin;
    CGFloat horzMargin = self.subviewHorzMargin;
    CGFloat subviewSize = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {

        CGFloat minSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((MyFlowLayoutViewSizeClass*)self.myCurrentSizeClass).maxSpace;
        NSInteger rowCount =  floor((selfSize.height - padding.top - padding.bottom  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            vertMargin = (selfSize.height - padding.top - padding.bottom - subviewSize * rowCount)/(rowCount - 1);
            if (vertMargin > maxSpace)
            {
                vertMargin = maxSpace;
                
                subviewSize =  (selfSize.height - padding.top - padding.bottom -  vertMargin * (rowCount - 1)) / rowCount;
                
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

            
            CGFloat topMargin = sbv.topPos.margin;
            CGFloat bottomMargin = sbv.bottomPos.margin;
            CGRect rect = sbv.myFrame.frame;
            
            if (sbv.widthDime.dimeNumVal != nil)
                rect.size.width = sbv.widthDime.measure;
            
            if (sbv.heightDime.dimeNumVal != nil)
                rect.size.height = sbv.heightDime.measure;
            
            [self setSubviewRelativeDimeSize:sbv.heightDime selfSize:selfSize pRect:&rect];
            
            rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            [self setSubviewRelativeDimeSize:sbv.widthDime selfSize:selfSize pRect:&rect];
            
            rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            
            //如果高度是浮动的则需要调整高度。
            if (sbv.isFlexedHeight)
            {
                rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
                
                rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            }

            
            //暂时把宽度存放sbv.myFrame.rightPos上。因为浮动布局来说这个属性无用。
            sbv.myFrame.rightPos = topMargin + rect.size.height + bottomMargin;
            if (sbv.myFrame.rightPos > selfSize.height - self.topPadding - self.bottomPadding)
                sbv.myFrame.rightPos = selfSize.height - self.topPadding - self.bottomPadding;
        }
        
        [sbs setArray:[self getAutoArrangeSubviews:sbs selfSize:selfSize.height - self.topPadding - self.bottomPadding margin:vertMargin]];
        
    }

    
    
    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.myFrame.frame;
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        [self setSubviewRelativeDimeSize:sbv.heightDime selfSize:selfSize pRect:&rect];

        if (subviewSize != 0)
            rect.size.height = subviewSize;
        
        
        [self setSubviewRelativeDimeSize:sbv.widthDime selfSize:selfSize pRect:&rect];

        
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
                floatHeight -= vertMargin;
            
            rect.size.height = (floatHeight + sbv.heightDime.addVal) * sbv.weight - topMargin - bottomMargin;
            
        }

        
         rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
       
        if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
            rect.size.width = [sbv.widthDime measureWith:rect.size.height ];
        
        
        
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果高度是浮动的则需要调整高度。
        if (sbv.isFlexedHeight)
        {
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
            
            rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算yPos的值加上topMargin + rect.size.height + bottomMargin + vertMargin 的值要小于整体的宽度。
        CGFloat place = yPos + topMargin + rect.size.height + bottomMargin;
        if (arrangedIndex != 0)
            place += vertMargin;
        place += padding.bottom;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.height > 0.0001)
        {
            yPos = padding.top;
            xPos += horzMargin;
            xPos += colMaxWidth;
            
            
            //计算每行的gravity情况。
            [arrangeIndexSet addIndex:i - arrangedIndex];
            [self calcHorzLayoutGravity:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertMargin horzMargin:horzMargin];
            
            //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
            if (topMargin + bottomMargin + rect.size.height > selfSize.height - padding.top - padding.bottom)
            {
                rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:selfSize.height - padding.top - padding.bottom - topMargin - bottomMargin sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            colMaxWidth = 0;
            colMaxHeight = 0;
            arrangedIndex = 0;
            
        }
        
        if (arrangedIndex != 0)
            yPos += vertMargin;
        
        
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
    [self calcHorzLayoutGravity:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertMargin horzMargin:horzMargin];
    
    
    if (self.wrapContentWidth)
        selfSize.width = xPos + padding.right + colMaxWidth;
    else
    {
        CGFloat addXPos = 0;
        CGFloat fill = 0;
        CGFloat between = 0;

        if (mghorz == MyMarginGravity_Horz_Center)
        {
            addXPos = (selfSize.width - padding.right - colMaxWidth - xPos) / 2;
        }
        else if (mghorz == MyMarginGravity_Horz_Right)
        {
            addXPos = selfSize.width - padding.right - colMaxWidth - xPos;
        }
        else if (mghorz == MyMarginGravity_Horz_Fill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.width - padding.right - colMaxWidth - xPos) / arrangeIndexSet.count;
        }
        else if (mghorz == MyMarginGravity_Horz_Between)
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



-(CGSize)layoutSubviewsForHorz:(CGSize)selfSize sbs:(NSMutableArray*)sbs
{
    UIEdgeInsets padding = self.padding;
    NSInteger arrangedCount = self.arrangedCount;
    CGFloat xPos = padding.left;
    CGFloat yPos = padding.top;
    CGFloat colMaxWidth = 0;  //每列的最大宽度
    CGFloat colMaxHeight = 0; //每列的最大高度
    CGFloat maxHeight = padding.top;
    
    MyMarginGravity mgvert = self.gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity mghorz = self.gravity & MyMarginGravity_Vert_Mask;
    MyMarginGravity amghorz = self.arrangedGravity & MyMarginGravity_Vert_Mask;
    
    CGFloat vertMargin = self.subviewVertMargin;
    CGFloat horzMargin = self.subviewHorzMargin;
    
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
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - padding.top - padding.bottom - (arrangedCount - 1) * vertMargin ) / arrangedCount;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - padding.top - arrangedCount * vertMargin ) / arrangedCount;
            
            pagingItemWidth = (selfSize.width - padding.left - padding.right - (cols - 1) * horzMargin) / cols;
        }
        else
        {
            isHorzPaging = YES;
            pagingItemHeight = (selfSize.height - padding.top - padding.bottom - (arrangedCount - 1) * vertMargin) / arrangedCount;
            //分页滚动时和非分页滚动时的宽度计算是不一样的。
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - padding.left - padding.right - (cols - 1) * horzMargin) / cols;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - padding.left - cols * horzMargin) / cols;
            
        }
        
    }
    
    BOOL averageArrange = (mgvert == MyMarginGravity_Vert_Fill);
    
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
                [self calcHorzLayoutWeight:selfSize totalFloatHeight:selfSize.height - padding.top - padding.bottom - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }
            
            rowTotalWeight = 0;
            rowTotalFixedHeight = 0;
            
        }
        
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGRect rect = sbv.myFrame.frame;
        
        
        if (pagingItemWidth != 0)
            rect.size.width = pagingItemWidth;
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        //当子视图的尺寸是相对依赖于其他尺寸的值。
        [self setSubviewRelativeDimeSize:sbv.widthDime selfSize:selfSize pRect:&rect];
        
        
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];

        
        if (sbv.weight != 0)
        {
            
            rowTotalWeight += sbv.weight;
        }
        else
        {
           
            BOOL isFlexedHeight = sbv.isFlexedHeight && !sbv.heightDime.isMatchParent;
            
            if (pagingItemHeight != 0)
                rect.size.height = pagingItemHeight;
            
            if (sbv.heightDime.dimeNumVal != nil && !averageArrange)
                rect.size.height = sbv.heightDime.measure;
            
            //当子视图的尺寸是相对依赖于其他尺寸的值。
            [self setSubviewRelativeDimeSize:sbv.heightDime selfSize:selfSize pRect:&rect];

            
            //如果高度是浮动的则需要调整高度。
            if (isFlexedHeight)
                rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
            
             rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
                rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:[sbv.widthDime measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
            
            rowTotalFixedHeight += rect.size.height;
        }
        
        rowTotalFixedHeight += topMargin + bottomMargin;

        
        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedHeight += vertMargin;
        
        
        sbv.myFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedHeight -= vertMargin;
        
        [self calcHorzLayoutWeight:selfSize totalFloatHeight:selfSize.height - padding.top - padding.bottom - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }


    CGFloat pageHeight = 0; //页高
    CGFloat averageHeight = (selfSize.height - padding.top - padding.bottom - (arrangedCount - 1) * vertMargin) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            xPos += colMaxWidth;
            xPos += horzMargin;
           
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
                        xPos -= horzMargin;
                        xPos += padding.right;
                        xPos += padding.left;
                    }
                }
            }
            

            yPos = padding.top + pageHeight;

            
            //计算每行的gravity情况。
            [self calcHorzLayoutGravity:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedCount vertMargin:vertMargin horzMargin:horzMargin];
            
            colMaxWidth = 0;
            colMaxHeight = 0;
        }
        
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.myFrame.frame;
        
        
        if (averageArrange)
        {
        
            rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:averageHeight - topMargin - bottomMargin sbvSize:rect.size selfLayoutSize:selfSize];
            
           if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
              rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:[sbv.widthDime measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
        }

        
        rect.origin.y = yPos + topMargin;
        rect.origin.x = xPos + leftMargin;
        yPos += topMargin + rect.size.height + bottomMargin;
        
        if (arrangedIndex != (arrangedCount - 1))
            yPos += vertMargin;

        
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
    [self calcHorzLayoutGravity:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedIndex vertMargin:vertMargin horzMargin:horzMargin];

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

        if (mghorz == MyMarginGravity_Horz_Center)
        {
            addXPos = (selfSize.width - padding.right - colMaxWidth - xPos) / 2;
        }
        else if (mghorz == MyMarginGravity_Horz_Right)
        {
            addXPos = selfSize.width - padding.right - colMaxWidth - xPos;
        }
        else if (mghorz == MyMarginGravity_Horz_Fill)
        {
            if (arranges > 0)
                fill = (selfSize.width - padding.right - colMaxWidth - xPos) / arranges;
        }
        else if (mghorz == MyMarginGravity_Horz_Between)
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

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass];
    
    
    NSMutableArray *sbs = [self getLayoutSubviews];
    
    
    for (UIView *sbv in sbs)
    {
        
        if (!isEstimate)
        {
            sbv.myFrame.frame = sbv.bounds;
            [self calcSizeOfWrapContentSubview:sbv selfLayoutSize:selfSize];
        }
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
            
            if (sbvl.wrapContentWidth)
            {
                if (sbvl.widthDime.dimeVal != nil ||
                    (self.orientation == MyLayoutViewOrientation_Horz && (self.arrangedGravity & MyMarginGravity_Vert_Mask) == MyMarginGravity_Horz_Fill) ||
                    (self.orientation == MyLayoutViewOrientation_Vert && ((self.gravity & MyMarginGravity_Vert_Mask) == MyMarginGravity_Horz_Fill || sbvl.weight != 0)))
                {
                    [sbvl setWrapContentWidthNoLayout:NO];
                }
            }
            
            if (sbvl.wrapContentHeight)
            {
                if (sbvl.heightDime.dimeVal != nil ||
                    (self.orientation == MyLayoutViewOrientation_Vert && (self.arrangedGravity & MyMarginGravity_Horz_Mask) == MyMarginGravity_Vert_Fill) ||
                    (self.orientation == MyLayoutViewOrientation_Horz && ((self.gravity & MyMarginGravity_Horz_Mask) == MyMarginGravity_Vert_Fill || sbvl.weight != 0)))
                {
                    [sbvl setWrapContentHeightNoLayout:NO];
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
            selfSize = [self layoutSubviewsForVertContent:selfSize sbs:sbs];
        else
            selfSize = [self layoutSubviewsForVert:selfSize sbs:sbs];
    }
    else
    {
        if (self.arrangedCount == 0)
            selfSize = [self layoutSubviewsForHorzContent:selfSize sbs:sbs];
        else
            selfSize = [self layoutSubviewsForHorz:selfSize sbs:sbs];
    }
    
    selfSize.height = [self validMeasure:self.heightDime sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self validMeasure:self.widthDime sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    return selfSize;
}

-(id)createSizeClassInstance
{
    return [MyFlowLayoutViewSizeClass new];
}



@end

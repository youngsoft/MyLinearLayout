//
//  MyFlowLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/10/31.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyFlowLayout.h"
#import "MyLayoutInner.h"

@implementation MyFlowLayout
{
    NSInteger _arrangedCount;
}

-(id)initWithOrientation:(LineViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    self = [self init];
    if (self != nil)
    {
        _orientation = orientation;
        _arrangedCount = arrangedCount;
        if (_arrangedCount < 1)
            _arrangedCount = 1;
    }
    
    return self;
}


+(id)flowLayoutWithOrientation:(LineViewOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    MyFlowLayout *layout = [[MyFlowLayout alloc] initWithOrientation:orientation arrangedCount:arrangedCount];
    return layout;
}

-(void)setOrientation:(LineViewOrientation)orientation
{
    if (_orientation != orientation)
    {
        _orientation = orientation;
        [self setNeedsLayout];
    }
}

-(void)setArrangedCount:(NSInteger)arrangedCount
{
    if (_arrangedCount != arrangedCount)
    {
        _arrangedCount = arrangedCount;
        if (_arrangedCount < 1)
            _arrangedCount = 1;
        
        [self setNeedsLayout];
    }
}

-(NSInteger)arrangedCount
{
    if (_arrangedCount < 1)
        _arrangedCount = 1;
    
    return _arrangedCount;
}


-(void)setAverageArrange:(BOOL)averageArrange
{
    if (_averageArrange != averageArrange)
    {
        _averageArrange = averageArrange;
        [self setNeedsLayout];
    }
}

-(void)setGravity:(MarignGravity)gravity
{
    if (_gravity != gravity)
    {
        _gravity = gravity;
        [self setNeedsLayout];
    }
}

-(void)setArrangedGravity:(MarignGravity)arrangedGravity
{
    if (_arrangedGravity != arrangedGravity)
    {
        _arrangedGravity = arrangedGravity;
        [self setNeedsLayout];
    }
}

-(void)setSubviewHorzMargin:(CGFloat)subviewHorzMargin
{
    if (_subviewHorzMargin != subviewHorzMargin)
    {
        _subviewHorzMargin = subviewHorzMargin;
        [self setNeedsLayout];
    }
}

-(void)setSubviewVertMargin:(CGFloat)subviewVertMargin
{
    if (_subviewVertMargin != subviewVertMargin)
    {
        _subviewVertMargin = subviewVertMargin;
        [self setNeedsLayout];
    }
}


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview != nil)
    {
        //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
        if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
            self.adjustScrollViewContentSize = YES;
    }

    
}


- (void)calcVertLayoutGravity:(CGFloat)selfWidth rowMaxHeight:(CGFloat)rowMaxHeight rowMaxWidth:(CGFloat)rowMaxWidth mg:(MarignGravity)mg amg:(MarignGravity)amg sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    
    CGFloat addXPos = 0;
    if (!self.averageArrange)
    {
        switch (mg) {
            case MGRAVITY_HORZ_CENTER:
            {
                addXPos = (selfWidth - self.leftPadding - self.rightPadding - rowMaxWidth) / 2;
            }
                break;
            case MGRAVITY_HORZ_RIGHT:
            {
                addXPos = selfWidth - self.leftPadding - self.rightPadding - rowMaxWidth; //因为具有不考虑左边距，而原来的位置增加了左边距，因此
            }
                break;
            default:
                break;
        }
    }
    
    
    //最后一排。
    if ((amg != MGRAVITY_NONE && amg != MGRAVITY_VERT_TOP) || addXPos != 0)
    {
        //将整行的位置进行调整。
        for (NSInteger j = startIndex - count; j < startIndex; j++)
        {
            UIView *sbv = sbs[j];
            
            sbv.absPos.leftPos += addXPos;
            
            switch (amg) {
                case MGRAVITY_VERT_CENTER:
                {
                    sbv.absPos.topPos += (rowMaxHeight - sbv.topPos.margin - sbv.bottomPos.margin - sbv.absPos.height) / 2;
                    
                }
                    break;
                case MGRAVITY_VERT_BOTTOM:
                {
                    sbv.absPos.topPos += rowMaxHeight - sbv.topPos.margin - sbv.bottomPos.margin - sbv.absPos.height;
                }
                    break;
                case MGRAVITY_VERT_FILL:
                {
                    sbv.absPos.height = [sbv.heightDime validMeasure:rowMaxHeight - sbv.topPos.margin - sbv.bottomPos.margin] ;
                }
                    break;
                default:
                    break;
            }
        }
    }
}

-(CGRect)layoutSubviewsForVert:(CGRect)selfRect
{
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || ( sbv.isHidden && self.hideSubviewReLayout))
            continue;
        
        [sbs addObject:sbv];
    }
    
    
    NSInteger arrangedCount = self.arrangedCount;
    CGFloat xPos = self.leftPadding;
    CGFloat yPos = self.topPadding;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    CGFloat maxWidth = self.leftPadding;  //全部行的最宽值
    MarignGravity mgvert = self.gravity & MGRAVITY_HORZ_MASK;
    MarignGravity mghorz = self.gravity & MGRAVITY_VERT_MASK;
    MarignGravity amgvert = self.arrangedGravity & MGRAVITY_HORZ_MASK;
    
    CGFloat averageWidth = (selfRect.size.width - self.leftPadding - self.rightPadding - (arrangedCount - 1) * self.subviewHorzMargin) / arrangedCount;
    
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        //新的一行
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            xPos = self.leftPadding;
            yPos += rowMaxHeight;
            yPos += self.subviewVertMargin;
            
            //计算每行的gravity情况。
            [self calcVertLayoutGravity:selfRect.size.width rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedCount];
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            
        }
        
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.absPos.frame;
    
        //控制最大最小尺寸
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width  = [sbv.widthDime validMeasure:rect.size.width];
    
        BOOL isFlexedHeight = sbv.isFlexedHeight && !sbv.heightDime.isMatchParent;
        
        if (self.averageArrange)
            rect.size.width = [sbv.widthDime validMeasure:averageWidth - leftMargin - rightMargin];
        
        if (sbv.widthDime.dimeNumVal != nil && !self.averageArrange)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
            rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }

        
        rect.origin.x = xPos + leftMargin;
        rect.origin.y = yPos + topMargin;
        xPos += leftMargin + rect.size.width + rightMargin;
        
        if (arrangedIndex != (arrangedCount - 1))
            xPos += self.subviewHorzMargin;

        
        if (rowMaxHeight < topMargin + bottomMargin + rect.size.height)
            rowMaxHeight = topMargin + bottomMargin + rect.size.height;
        
        if (rowMaxWidth < (xPos - self.leftPadding))
            rowMaxWidth = (xPos - self.leftPadding);
        
        if (maxWidth < xPos)
            maxWidth = xPos;
        
        
        
        sbv.absPos.frame = rect;
        
        
        arrangedIndex++;
        
    }
    
    //最后一行
    [self calcVertLayoutGravity:selfRect.size.width rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth mg:mghorz amg:amgvert sbs:sbs startIndex:i count:arrangedIndex];

    if (self.wrapContentHeight)
        selfRect.size.height = yPos + self.bottomPadding + rowMaxHeight;
    else
    {
        CGFloat addYPos = 0;
        if (mgvert == MGRAVITY_VERT_CENTER)
        {
            addYPos = (selfRect.size.height - self.bottomPadding - rowMaxHeight - yPos) / 2;
        }
        else if (mgvert == MGRAVITY_VERT_BOTTOM)
        {
            addYPos = selfRect.size.height - self.bottomPadding - rowMaxHeight - yPos;
        }
        
        if (addYPos != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                sbv.absPos.topPos += addYPos;
            }
        }

    }
    
    if (self.wrapContentWidth && !self.averageArrange)
        selfRect.size.width = maxWidth + self.rightPadding;
    
    
    return selfRect;
}



- (void)calcHorzLayoutGravity:(CGFloat)selfHeight colMaxWidth:(CGFloat)colMaxWidth colMaxHeight:(CGFloat)colMaxHeight mg:(MarignGravity)mg  amg:(MarignGravity)amg sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    
    CGFloat addYPos = 0;
    if (!self.averageArrange)
    {
        switch (mg) {
            case MGRAVITY_VERT_CENTER:
            {
                addYPos = (selfHeight - self.topPadding - self.bottomPadding - colMaxHeight) / 2;
            }
                break;
            case MGRAVITY_VERT_BOTTOM:
            {
                addYPos = selfHeight - self.topPadding - self.bottomPadding - colMaxHeight;
            }
                break;
            default:
                break;
        }
    }
    

    
    if ((amg != MGRAVITY_NONE && amg != MGRAVITY_HORZ_LEFT) || addYPos != 0)
    {
        //将整行的位置进行调整。
        for (NSInteger j = startIndex - count; j < startIndex; j++)
        {
            UIView *sbv = sbs[j];
            
            sbv.absPos.topPos += addYPos;
            
            switch (amg) {
                case MGRAVITY_HORZ_CENTER:
                {
                    sbv.absPos.leftPos += (colMaxWidth - sbv.leftPos.margin - sbv.rightPos.margin - sbv.absPos.width) / 2;
                    
                }
                    break;
                case MGRAVITY_HORZ_RIGHT:
                {
                    sbv.absPos.leftPos += colMaxWidth - sbv.leftPos.margin - sbv.rightPos.margin - sbv.absPos.width;
                }
                    break;
                case MGRAVITY_HORZ_FILL:
                {
                    sbv.absPos.width = [sbv.widthDime validMeasure:colMaxWidth - sbv.leftPos.margin - sbv.rightPos.margin];
                }
                    break;
                default:
                    break;
            }
        }
    }
}




-(CGRect)layoutSubviewsForHorz:(CGRect)selfRect
{
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout))
            continue;
        
        [sbs addObject:sbv];
    }
    
    
    
    NSInteger arrangedIndex = 0;
    NSInteger arrangedCount = self.arrangedCount;
    CGFloat xPos = self.leftPadding;
    CGFloat yPos = self.topPadding;
    CGFloat colMaxWidth = 0;  //每列的最大宽度
    CGFloat colMaxHeight = 0; //每列的最大高度
    CGFloat maxHeight = self.topPadding;
    
    MarignGravity mgvert = self.gravity & MGRAVITY_HORZ_MASK;
    MarignGravity mghorz = self.gravity & MGRAVITY_VERT_MASK;
    MarignGravity amghorz = self.arrangedGravity & MGRAVITY_VERT_MASK;

    
    CGFloat averageHeight = (selfRect.size.height - self.topPadding - self.bottomPadding - (arrangedCount - 1) * self.subviewVertMargin) / arrangedCount;
    
    int i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            xPos += colMaxWidth;
            xPos += self.subviewHorzMargin;
            yPos = self.topPadding;
            
            //计算每行的gravity情况。
            [self calcHorzLayoutGravity:selfRect.size.height colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedCount];
            
            colMaxWidth = 0;
            colMaxHeight = 0;
        }
        
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.absPos.frame;
        
        //控制最大最小尺寸
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width  = [sbv.widthDime validMeasure:rect.size.width];

        
        BOOL isFlexedHeight = sbv.isFlexedHeight && !sbv.heightDime.isMatchParent;
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil && !self.averageArrange)
            rect.size.height = sbv.heightDime.measure;
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        if (self.averageArrange)
            rect.size.height = [sbv.heightDime validMeasure:averageHeight - topMargin - bottomMargin];
        
        if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
            rect.size.width = [sbv.widthDime validMeasure:rect.size.height * sbv.widthDime.mutilVal + sbv.widthDime.addVal];

        
        rect.origin.y = yPos + topMargin;
        rect.origin.x = xPos + leftMargin;
        yPos += topMargin + rect.size.height + bottomMargin;
        
        if (arrangedIndex != (arrangedCount - 1))
            yPos += self.subviewVertMargin;

        
        if (colMaxWidth < leftMargin + rightMargin + rect.size.width)
            colMaxWidth = leftMargin + rightMargin + rect.size.width;
        
        if (colMaxHeight < (yPos - self.topPadding))
            colMaxHeight = yPos - self.topPadding;
        
        if (maxHeight < yPos)
            maxHeight = yPos;
        
        
        sbv.absPos.frame = rect;
        
        
        arrangedIndex++;
        
    }
    
    //最后一列
    [self calcHorzLayoutGravity:selfRect.size.height colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight mg:mgvert amg:amghorz sbs:sbs startIndex:i count:arrangedIndex];

    if (self.wrapContentHeight && !self.averageArrange)
        selfRect.size.height = maxHeight + self.bottomPadding;
    
    if (self.wrapContentWidth)
        selfRect.size.width = xPos + self.rightPadding + colMaxWidth;
    else
    {
     
        CGFloat addXPos = 0;
        if (mghorz == MGRAVITY_HORZ_CENTER)
        {
            addXPos = (selfRect.size.width - self.rightPadding - colMaxWidth - xPos) / 2;
        }
        else if (mghorz == MGRAVITY_HORZ_RIGHT)
        {
            addXPos = selfRect.size.width - self.rightPadding - colMaxWidth - xPos;
        }
        
        if (addXPos != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                sbv.absPos.leftPos += addXPos;
            }
        }
    }
    
    
    
    
    return selfRect;
    
}

-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout
{
    CGRect selfRect = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout];
    
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout))
            continue;
        
        if (!isEstimate)
        {
            sbv.absPos.frame = sbv.frame;
        }
        
        if ([sbv isKindOfClass:[MyLayoutBase class]])
        {
            if (pHasSubLayout != NULL)
                *pHasSubLayout = YES;
            
            //流式布局因为左右边距和自身的宽高没有限制所以这里不需要进行wrapContent的约束控制。
            MyLayoutBase *sbvl = (MyLayoutBase*)sbv;
            if (isEstimate)
            {
                [sbvl estimateLayoutRect:sbvl.absPos.frame.size];
            }
        }
    }

    
    
    if (_orientation == LVORIENTATION_VERT)
    {
        selfRect = [self layoutSubviewsForVert:selfRect];
    }
    else
    {
        selfRect = [self layoutSubviewsForHorz:selfRect];
    }
    
    selfRect.size.height = [self.heightDime validMeasure:selfRect.size.height];
    selfRect.size.width = [self.widthDime validMeasure:selfRect.size.width];
    
    
    return selfRect;
}


@end

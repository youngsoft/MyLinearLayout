//
//  MyFloatLayout.m
//  MyLayout
//
//  Created by oybq on 16/2/18.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyFloatLayout.h"
#import "MyLayoutInner.h"

@implementation  UIView(MyFloatLayoutExt)


-(void)setReverseFloat:(BOOL)reverseFloat
{
    if (self.myCurrentSizeClass.isReverseFloat != reverseFloat)
    {
        self.myCurrentSizeClass.reverseFloat = reverseFloat;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)isReverseFloat
{
    return self.myCurrentSizeClass.isReverseFloat;
    
}

-(void)setClearFloat:(BOOL)clearFloat
{
    if (self.myCurrentSizeClass.clearFloat != clearFloat)
    {
        self.myCurrentSizeClass.clearFloat = clearFloat;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)clearFloat
{
    return self.myCurrentSizeClass.clearFloat;
}


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




@implementation MyFloatLayout


-(id)initWithOrientation:(MyLayoutViewOrientation)orientation
{
    self = [super init];
    if (self != nil)
    {
        self.myCurrentSizeClass.orientation = orientation;
    }
    
    return self;
}


+(id)floatLayoutWithOrientation:(MyLayoutViewOrientation)orientation
{
    MyFloatLayout *layout = [[[self class] alloc] initWithOrientation:orientation];
    return layout;
}

-(void)setOrientation:(MyLayoutViewOrientation)orientation
{
    MyFloatLayout *lsc = self.myCurrentSizeClass;
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

-(void)setGravity:(MyMarginGravity)gravity
{
    MyFloatLayout *lsc = self.myCurrentSizeClass;
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


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(CGPoint)findRightCandidatePoint:(CGRect)leftCandidateRect  width:(CGFloat)width rightBoundary:(CGFloat)rightBoundary rightCandidateRects:(NSArray*)rightCandidateRects hasWeight:(BOOL)hasWeight
{
    
    CGPoint retPoint = {rightBoundary,CGFLOAT_MAX};
    
    CGFloat lastHeight = self.topPadding;
    for (NSInteger i = rightCandidateRects.count - 1; i >= 0; i--)
    {
        
        CGRect rightCandidateRect = ((NSValue*)rightCandidateRects[i]).CGRectValue;
        //如果有比重则不能相等只能小于。
        if ((hasWeight ? CGRectGetMaxX(leftCandidateRect) + width < CGRectGetMinX(rightCandidateRect) : CGRectGetMaxX(leftCandidateRect) + width <= CGRectGetMinX(rightCandidateRect)) &&
            CGRectGetMaxY(leftCandidateRect) > lastHeight)
        {
            retPoint.y = MAX(CGRectGetMinY(leftCandidateRect),lastHeight);
            retPoint.x = CGRectGetMinX(rightCandidateRect);
            break;
        }
        
        lastHeight = CGRectGetMaxY(rightCandidateRect);
        
    }
    
    if (retPoint.y == CGFLOAT_MAX)
    {
        if ((hasWeight ? CGRectGetMaxX(leftCandidateRect) + width < rightBoundary : CGRectGetMaxX(leftCandidateRect) + width <= rightBoundary ) &&
            CGRectGetMaxY(leftCandidateRect) > lastHeight)
        {
            retPoint.y =  MAX(CGRectGetMinY(leftCandidateRect),lastHeight);
        }
    }
    
    return retPoint;
}

-(CGPoint)findBottomCandidatePoint:(CGRect)topCandidateRect  height:(CGFloat)height bottomBoundary:(CGFloat)bottomBoundary bottomCandidateRects:(NSArray*)bottomCandidateRects hasWeight:(BOOL)hasWeight
{
    
    CGPoint retPoint = {CGFLOAT_MAX,bottomBoundary};
    
    CGFloat lastWidth = self.leftPadding;
    for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
    {
        
        CGRect bottomCandidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;
        if ((hasWeight ? CGRectGetMaxY(topCandidateRect) + height < CGRectGetMinY(bottomCandidateRect) : CGRectGetMaxY(topCandidateRect) + height <= CGRectGetMinY(bottomCandidateRect)) &&
            CGRectGetMaxX(topCandidateRect) > lastWidth)
        {
            retPoint.x = MAX(CGRectGetMinX(topCandidateRect),lastWidth);
            retPoint.y = CGRectGetMinY(bottomCandidateRect);
            break;
        }
        
        lastWidth = CGRectGetMaxX(bottomCandidateRect);
        
    }
    
    if (retPoint.x == CGFLOAT_MAX)
    {
        if ((hasWeight ? CGRectGetMaxY(topCandidateRect) + height < bottomBoundary : CGRectGetMaxY(topCandidateRect) + height <= bottomBoundary ) &&
            CGRectGetMaxX(topCandidateRect) > lastWidth)
        {
            retPoint.x =  MAX(CGRectGetMinX(topCandidateRect),lastWidth);
        }
    }
    
    return retPoint;
}


-(CGPoint)findLeftCandidatePoint:(CGRect)rightCandidateRect  width:(CGFloat)width leftBoundary:(CGFloat)leftBoundary leftCandidateRects:(NSArray*)leftCandidateRects hasWeight:(BOOL)hasWeight
{
    
    CGPoint retPoint = {leftBoundary,CGFLOAT_MAX};
    
    CGFloat lastHeight = self.topPadding;
    for (NSInteger i = leftCandidateRects.count - 1; i >= 0; i--)
    {
        
        CGRect leftCandidateRect = ((NSValue*)leftCandidateRects[i]).CGRectValue;
        if ((hasWeight ? CGRectGetMinX(rightCandidateRect) - width > CGRectGetMaxX(leftCandidateRect) : CGRectGetMinX(rightCandidateRect) - width >= CGRectGetMaxX(leftCandidateRect)) &&
            CGRectGetMaxY(rightCandidateRect) > lastHeight)
        {
            retPoint.y = MAX(CGRectGetMinY(rightCandidateRect),lastHeight);
            retPoint.x = CGRectGetMaxX(leftCandidateRect);
            break;
        }
        
        lastHeight = CGRectGetMaxY(leftCandidateRect);
        
    }
    
    if (retPoint.y == CGFLOAT_MAX)
    {
        if ((hasWeight ? CGRectGetMinX(rightCandidateRect) - width > leftBoundary : CGRectGetMinX(rightCandidateRect) - width >= leftBoundary) &&
            CGRectGetMaxY(rightCandidateRect) > lastHeight)
        {
            retPoint.y =  MAX(CGRectGetMinY(rightCandidateRect),lastHeight);
        }
    }
    
    return retPoint;
}

-(CGPoint)findTopCandidatePoint:(CGRect)bottomCandidateRect  height:(CGFloat)height topBoundary:(CGFloat)topBoundary topCandidateRects:(NSArray*)topCandidateRects hasWeight:(BOOL)hasWeight
{
    
    CGPoint retPoint = {CGFLOAT_MAX, topBoundary};
    
    CGFloat lastWidth = self.leftPadding;
    for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
    {
        
        CGRect topCandidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;
        if ((hasWeight ? CGRectGetMinY(bottomCandidateRect) - height > CGRectGetMaxY(topCandidateRect) : CGRectGetMinY(bottomCandidateRect) - height >= CGRectGetMaxY(topCandidateRect)) &&
            CGRectGetMaxX(bottomCandidateRect) > lastWidth)
        {
            retPoint.x = MAX(CGRectGetMinX(bottomCandidateRect),lastWidth);
            retPoint.y = CGRectGetMaxY(topCandidateRect);
            break;
        }
        
        lastWidth = CGRectGetMaxX(topCandidateRect);
        
    }
    
    if (retPoint.x == CGFLOAT_MAX)
    {
        if ((hasWeight ? CGRectGetMinY(bottomCandidateRect) - height > topBoundary : CGRectGetMinY(bottomCandidateRect) - height >= topBoundary) &&
            CGRectGetMaxX(bottomCandidateRect) > lastWidth)
        {
            retPoint.x =  MAX(CGRectGetMinX(bottomCandidateRect),lastWidth);
        }
    }
    
    return retPoint;
}



-(CGRect)layoutSubviewsForVert:(CGRect)selfRect
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    UIEdgeInsets padding = self.padding;
    
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || ( sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
    }
    
    //遍历所有的子视图，查看是否有子视图的宽度会比视图自身要宽，如果有且有包裹属性则扩充自身的宽度
    if (self.wrapContentWidth)
    {
        CGFloat maxContentWidth = selfRect.size.width - padding.left - padding.right;
        for (UIView *sbv in sbs)
        {
            CGFloat leftMargin = sbv.leftPos.margin;
            CGFloat rightMargin = sbv.rightPos.margin;
            CGRect rect = sbv.absPos.frame;
            
            //因为这里是计算包裹宽度属性，所以只会计算那些设置了固定宽度的子视图
            rect.size.width  = [sbv.widthDime validMeasure:rect.size.width];
            
            //这里有可能设置了固定的宽度
            if (sbv.widthDime.dimeNumVal != nil)
                rect.size.width = sbv.widthDime.measure;
            
            //有可能宽度是和他的高度相等。
            if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
            {
                rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
                if (sbv.heightDime.dimeNumVal != nil)
                    rect.size.height = sbv.heightDime.measure;
                
                if (sbv.heightDime.dimeRelaVal == self.heightDime)
                    rect.size.height = [sbv.heightDime validMeasure:(selfRect.size.height - padding.top - padding.bottom) * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
                
                rect.size.width = [sbv.widthDime validMeasure:rect.size.height * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
            }
            
            
            if (leftMargin + rect.size.width + rightMargin > maxContentWidth &&
                sbv.widthDime.dimeRelaVal != self.widthDime &&
                sbv.weight == 0)
            {
                maxContentWidth = leftMargin + rect.size.width + rightMargin;
            }
        }
        
        selfRect.size.width = padding.left + maxContentWidth + padding.right;
    }
    
    
    
    //左边候选区域数组，保存的是CGRect值。
    NSMutableArray *leftCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最左边的个虚拟区域作为一个候选区域
    [leftCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(padding.left, padding.top, 0, CGFLOAT_MAX)]];
    
    //右边候选区域数组，保存的是CGRect值。
    NSMutableArray *rightCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最右边的个虚拟区域作为一个候选区域
    [rightCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(selfRect.size.width - padding.right, padding.top, 0, CGFLOAT_MAX)]];
    
    //分别记录左边和右边的最后一个视图在Y轴的偏移量
    CGFloat leftLastYOffset = padding.top;
    CGFloat rightLastYOffset = padding.top;
    
    //分别记录左右边和全局浮动视图的最高占用的Y轴的值
    CGFloat leftMaxHeight = padding.top;
    CGFloat rightMaxHeight = padding.top;
    CGFloat maxHeight = padding.top;
    
    for (UIView *sbv in sbs)
    {
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.absPos.frame;
        
        //控制最大最小尺寸
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width  = [sbv.widthDime validMeasure:rect.size.width];
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        if (sbv.heightDime.dimeRelaVal == self.heightDime && !self.wrapContentHeight)
            rect.size.height = [sbv.heightDime validMeasure:(selfRect.size.height - padding.top - padding.bottom) * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        if (sbv.widthDime.dimeRelaVal == self.widthDime)
            rect.size.width = [sbv.widthDime validMeasure:(selfRect.size.width - padding.left - padding.right) * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        
        if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
            rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
            rect.size.width = [sbv.widthDime validMeasure:rect.size.height * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        
        if (sbv.widthDime.dimeRelaVal != nil &&  sbv.widthDime.dimeRelaVal.view != nil &&  sbv.widthDime.dimeRelaVal.view != self && sbv.widthDime.dimeRelaVal.view != sbv)
        {
            rect.size.width = [sbv.widthDime validMeasure:sbv.widthDime.dimeRelaVal.view.absPos.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        }
        
        if (sbv.heightDime.dimeRelaVal != nil &&  sbv.heightDime.dimeRelaVal.view != nil &&  sbv.heightDime.dimeRelaVal.view != self && sbv.heightDime.dimeRelaVal.view != sbv)
        {
            rect.size.height = [sbv.heightDime validMeasure:sbv.heightDime.dimeRelaVal.view.absPos.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        }

        
        
        //如果高度是浮动的则需要调整高度。
        if (sbv.isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        if (sbv.reverseFloat)
        {
            CGPoint nextPoint = {selfRect.size.width - padding.right, leftLastYOffset};
            CGFloat leftCandidateXBoundary = padding.left;
            if (sbv.clearFloat)
            {
                //找到最底部的位置。
                nextPoint.y = MAX(rightMaxHeight, leftLastYOffset);
                CGPoint leftPoint = [self findLeftCandidatePoint:CGRectMake(selfRect.size.width - padding.right, nextPoint.y, 0, CGFLOAT_MAX) width:leftMargin + (sbv.weight != 0 ? 0 : rect.size.width) + rightMargin leftBoundary:padding.left leftCandidateRects:leftCandidateRects hasWeight:NO];
                if (leftPoint.y != CGFLOAT_MAX)
                {
                    nextPoint.y = MAX(rightMaxHeight, leftPoint.y);
                    leftCandidateXBoundary = leftPoint.x;
                }
            }
            else
            {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = rightCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)rightCandidateRects[i]).CGRectValue;
                    CGPoint leftPoint = [self findLeftCandidatePoint:candidateRect width:leftMargin + (sbv.weight != 0 ? 0 : rect.size.width) + rightMargin leftBoundary:padding.left leftCandidateRects:leftCandidateRects hasWeight:sbv.weight != 0 ];
                    if (leftPoint.y != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(CGRectGetMinX(candidateRect), MAX(nextPoint.y, leftPoint.y));
                        leftCandidateXBoundary = leftPoint.x;
                        break;
                    }
                    
                    nextPoint.y = CGRectGetMaxY(candidateRect);
                }
            }
            
            //重新设置宽度
            if (sbv.weight != 0)
            {
                rect.size.width = [sbv.widthDime validMeasure:(nextPoint.x - leftCandidateXBoundary - leftMargin - rightMargin) * sbv.weight];
                
                if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
                    rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
                
                if (sbv.isFlexedHeight)
                {
                    CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
                    rect.size.height = [sbv.heightDime validMeasure:sz.height];
                }
            }
            
            
            rect.origin.x = nextPoint.x - rightMargin - rect.size.width;
            rect.origin.y = MIN(nextPoint.y, maxHeight) + topMargin;
            
            //如果有智能边界线则找出所有智能边界线。
            if (self.IntelligentBorderLine != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderLine)
                    {
                        sbvl.bottomBorderLine = nil;
                        sbvl.topBorderLine = nil;
                        sbvl.rightBorderLine = nil;
                        sbvl.leftBorderLine = nil;
                        
                        //如果自己的上边和左边有子视图。
                        if (rect.origin.x + rect.size.width + rightMargin < selfRect.size.width - padding.right)
                        {
                            sbvl.rightBorderLine = self.IntelligentBorderLine;
                        }
                        
                        if (rect.origin.y - topMargin > padding.top)
                        {
                            sbvl.topBorderLine = self.IntelligentBorderLine;
                        }
                    }
                    
                }
            }
            

            
            //这里有可能子视图本身的宽度会超过布局视图本身，但是我们的候选区域则不存储超过的宽度部分。
            CGRect cRect = CGRectMake(rect.origin.x - leftMargin, rect.origin.y - topMargin, MIN((rect.size.width + leftMargin + rightMargin),(selfRect.size.width - padding.left - padding.right)), rect.size.height + topMargin + bottomMargin);
            
            
            //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
            for (NSInteger i = rightCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)rightCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxY(candidateRect) <= CGRectGetMaxY(cRect))
                    [rightCandidateRects removeObjectAtIndex:i];
            }
            
            //删除左边高度小于新添加区域的顶部的候选区域
            for (NSInteger i = leftCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)leftCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxY(candidateRect) <= CGRectGetMinY(cRect))
                    [leftCandidateRects removeObjectAtIndex:i];
            }

            
            [rightCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            rightLastYOffset = rect.origin.y - topMargin;
            
            if (rect.origin.y + rect.size.height + bottomMargin > rightMaxHeight)
                rightMaxHeight = rect.origin.y + rect.size.height + bottomMargin;
        }
        else
        {
            CGPoint nextPoint = {padding.left, rightLastYOffset};
            CGFloat rightCandidateXBoundary = selfRect.size.width - padding.right;

            //如果是清除了浮动则直换行移动到最下面。
            if (sbv.clearFloat)
            {
                //找到最低点。
                nextPoint.y = MAX(leftMaxHeight, rightLastYOffset);
                
                CGPoint rightPoint = [self findRightCandidatePoint:CGRectMake(padding.left, nextPoint.y, 0, CGFLOAT_MAX) width:leftMargin + (sbv.weight != 0 ? 0 : rect.size.width) + rightMargin rightBoundary:selfRect.size.width - padding.right rightCandidateRects:rightCandidateRects hasWeight:NO ];
                if (rightPoint.y != CGFLOAT_MAX)
                {
                    nextPoint.y = MAX(leftMaxHeight, rightPoint.y);
                    rightCandidateXBoundary = rightPoint.x;
                }
            }
            else
            {
                
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = leftCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)leftCandidateRects[i]).CGRectValue;
                    CGPoint rightPoint = [self findRightCandidatePoint:candidateRect width:leftMargin + (sbv.weight != 0 ? 0 : rect.size.width) + rightMargin rightBoundary:selfRect.size.width - padding.right rightCandidateRects:rightCandidateRects hasWeight:sbv.weight != 0 ];
                    if (rightPoint.y != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(CGRectGetMaxX(candidateRect), MAX(nextPoint.y, rightPoint.y));
                        rightCandidateXBoundary = rightPoint.x;
                        break;
                    }
                    
                    nextPoint.y = CGRectGetMaxY(candidateRect);
                }
            }
            
            //重新设置宽度
            if (sbv.weight != 0)
            {
                rect.size.width = [sbv.widthDime validMeasure:(rightCandidateXBoundary - nextPoint.x - leftMargin - rightMargin) * sbv.weight];
                
                if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
                    rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
                
                if (sbv.isFlexedHeight)
                {
                    CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
                    rect.size.height = [sbv.heightDime validMeasure:sz.height];
                }
            }
            
            rect.origin.x = nextPoint.x + leftMargin;
            rect.origin.y = MIN(nextPoint.y,maxHeight) + topMargin;
            
            
            if (self.IntelligentBorderLine != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    
                    if (!sbvl.notUseIntelligentBorderLine)
                    {
                        sbvl.bottomBorderLine = nil;
                        sbvl.topBorderLine = nil;
                        sbvl.rightBorderLine = nil;
                        sbvl.leftBorderLine = nil;
                        
                        //如果自己的上边和左边有子视图。
                        if (rect.origin.x - leftMargin > padding.left)
                        {
                            sbvl.leftBorderLine = self.IntelligentBorderLine;
                        }
                        
                        if (rect.origin.y - topMargin > padding.top)
                        {
                            sbvl.topBorderLine = self.IntelligentBorderLine;
                        }
                    }
                    
                }
            }
            

            
            CGRect cRect = CGRectMake(rect.origin.x - leftMargin, rect.origin.y - topMargin, MIN((rect.size.width + leftMargin + rightMargin),(selfRect.size.width - padding.left - padding.right)), rect.size.height + topMargin + bottomMargin);
            
            
            //把新添加到候选中去。并删除高度小于的候选键。和高度
            for (NSInteger i = leftCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)leftCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxY(candidateRect) <= CGRectGetMaxY(cRect))
                    [leftCandidateRects removeObjectAtIndex:i];
            }
            
            //删除右边高度小于新添加区域的顶部的候选区域
            for (NSInteger i = rightCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)rightCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxY(candidateRect) <= CGRectGetMinY(cRect))
                    [rightCandidateRects removeObjectAtIndex:i];
            }
            
            [leftCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            leftLastYOffset = rect.origin.y - topMargin;
            
            if (rect.origin.y + rect.size.height + bottomMargin > leftMaxHeight)
                leftMaxHeight = rect.origin.y + rect.size.height + bottomMargin;
            
        }
        
        if (rect.origin.y + rect.size.height + bottomMargin > maxHeight)
            maxHeight = rect.origin.y + rect.size.height + bottomMargin;
        
        sbv.absPos.frame = rect;
        
    }
    
    maxHeight += padding.bottom;
    
    if (self.wrapContentHeight)
        selfRect.size.height = maxHeight;
    else
    {
        CGFloat addYPos = 0;
        MyMarginGravity mgvert = self.gravity & MyMarginGravity_Horz_Mask;
        if (mgvert == MyMarginGravity_Vert_Center)
        {
            addYPos = (selfRect.size.height - maxHeight) / 2;
        }
        else if (mgvert == MyMarginGravity_Vert_Bottom)
        {
            addYPos = selfRect.size.height - maxHeight;
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
    
    return selfRect;
}

-(CGRect)layoutSubviewsForHorz:(CGRect)selfRect
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    UIEdgeInsets padding = self.padding;
    
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || ( sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
    }
    
    //遍历所有的子视图，查看是否有子视图的宽度会比视图自身要宽，如果有且有包裹属性则扩充自身的宽度
    if (self.wrapContentHeight)
    {
        CGFloat maxContentHeight = selfRect.size.height - padding.top - padding.bottom;
        for (UIView *sbv in sbs)
        {
            CGFloat topMargin = sbv.topPos.margin;
            CGFloat bottomMargin = sbv.bottomPos.margin;
            CGRect rect = sbv.absPos.frame;
            
            //因为这里是计算包裹高度属性，所以只会计算那些设置了固定高度的子视图
            rect.size.height  = [sbv.heightDime validMeasure:rect.size.height];
            
            //这里有可能设置了固定的高度
            if (sbv.heightDime.dimeNumVal != nil)
                rect.size.height = sbv.heightDime.measure;
            
            //有可能高度是和他的宽度相等。
            if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
            {
                rect.size.width = [sbv.widthDime validMeasure:rect.size.width];
                if (sbv.widthDime.dimeNumVal != nil)
                    rect.size.width = sbv.widthDime.measure;
                
                if (sbv.widthDime.dimeRelaVal == self.widthDime)
                    rect.size.width = [sbv.widthDime validMeasure:(selfRect.size.width - padding.left - padding.right) * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
                
                rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
            }
            
            if (sbv.isFlexedHeight)
            {
                CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
                rect.size.height = [sbv.heightDime validMeasure:sz.height];
            }
            
            if (topMargin + rect.size.height + bottomMargin > maxContentHeight &&
                sbv.heightDime.dimeRelaVal != self.heightDime &&
                sbv.weight == 0)
            {
                maxContentHeight = topMargin + rect.size.height + bottomMargin;
            }
        }
        
        selfRect.size.height = padding.top + maxContentHeight + padding.bottom;
    }
    
    
    
    //上边候选区域数组，保存的是CGRect值。
    NSMutableArray *topCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最上边的个虚拟区域作为一个候选区域
    [topCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(padding.left, padding.top,CGFLOAT_MAX,0)]];
    
    //右边候选区域数组，保存的是CGRect值。
    NSMutableArray *bottomCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最下边的个虚拟区域作为一个候选区域
    [bottomCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(padding.left, selfRect.size.height - padding.bottom,CGFLOAT_MAX, 0)]];
    
    //分别记录上边和下边的最后一个视图在X轴的偏移量
    CGFloat topLastXOffset = padding.left;
    CGFloat bottomLastXOffset = padding.left;
    
    //分别记录上下边和全局浮动视图的最宽占用的X轴的值
    CGFloat topMaxWidth = padding.left;
    CGFloat bottomMaxWidth = padding.left;
    CGFloat maxWidth = padding.left;
    
    for (UIView *sbv in sbs)
    {
        CGFloat topMargin = sbv.topPos.margin;
        CGFloat leftMargin = sbv.leftPos.margin;
        CGFloat bottomMargin = sbv.bottomPos.margin;
        CGFloat rightMargin = sbv.rightPos.margin;
        CGRect rect = sbv.absPos.frame;
        
        //控制最大最小尺寸
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width  = [sbv.widthDime validMeasure:rect.size.width];
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        if (sbv.heightDime.dimeRelaVal == self.heightDime)
            rect.size.height = [sbv.heightDime validMeasure:(selfRect.size.height - padding.top - padding.bottom) * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        if (sbv.widthDime.dimeRelaVal == self.widthDime && !self.wrapContentWidth)
            rect.size.width = [sbv.widthDime validMeasure:(selfRect.size.width - padding.left - padding.right) * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        
        if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
            rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
            rect.size.width = [sbv.widthDime validMeasure:rect.size.height * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        
        if (sbv.widthDime.dimeRelaVal != nil &&  sbv.widthDime.dimeRelaVal.view != nil &&  sbv.widthDime.dimeRelaVal.view != self && sbv.widthDime.dimeRelaVal.view != sbv)
        {
            rect.size.width = [sbv.widthDime validMeasure:sbv.widthDime.dimeRelaVal.view.absPos.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        }
        
        if (sbv.heightDime.dimeRelaVal != nil &&  sbv.heightDime.dimeRelaVal.view != nil &&  sbv.heightDime.dimeRelaVal.view != self && sbv.heightDime.dimeRelaVal.view != sbv)
        {
            rect.size.height = [sbv.heightDime validMeasure:sbv.heightDime.dimeRelaVal.view.absPos.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        }

        
        //如果高度是浮动的则需要调整高度。
        if (sbv.isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        if (sbv.reverseFloat)
        {
            CGPoint nextPoint = {topLastXOffset, selfRect.size.height - padding.bottom};
            CGFloat topCandidateYBoundary = padding.top;
            if (sbv.clearFloat)
            {
                //找到最底部的位置。
                nextPoint.x = MAX(bottomMaxWidth, topLastXOffset);
                CGPoint topPoint = [self findTopCandidatePoint:CGRectMake(nextPoint.x, selfRect.size.height - padding.bottom, CGFLOAT_MAX, 0) height:topMargin + (sbv.weight != 0 ? 0 : rect.size.height) + bottomMargin topBoundary:padding.top topCandidateRects:topCandidateRects hasWeight:NO ];
                if (topPoint.x != CGFLOAT_MAX)
                {
                    nextPoint.x = MAX(bottomMaxWidth, topPoint.x);
                    topCandidateYBoundary = topPoint.y;
                }
            }
            else
            {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;
                    CGPoint topPoint = [self findTopCandidatePoint:candidateRect height:topMargin + (sbv.weight != 0 ? 0 : rect.size.height) + bottomMargin topBoundary:padding.top topCandidateRects:topCandidateRects hasWeight:sbv.weight != 0 ];
                    if (topPoint.x != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(MAX(nextPoint.x, topPoint.x),CGRectGetMinY(candidateRect));
                        topCandidateYBoundary = topPoint.y;
                        break;
                    }
                    
                    nextPoint.x = CGRectGetMaxX(candidateRect);
                }
            }
            
            if (sbv.weight != 0)
            {
                rect.size.height = [sbv.heightDime validMeasure:(nextPoint.y - topCandidateYBoundary - topMargin - bottomMargin) * sbv.weight];
                
                if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
                    rect.size.width = [sbv.widthDime validMeasure:rect.size.height * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
                
            }
            
            
            rect.origin.y = nextPoint.y - bottomMargin - rect.size.height;
            rect.origin.x = MIN(nextPoint.x, maxWidth) + leftMargin;
            
            //如果有智能边界线则找出所有智能边界线。
            if (self.IntelligentBorderLine != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    
                    if (!sbvl.notUseIntelligentBorderLine)
                    {
                        sbvl.bottomBorderLine = nil;
                        sbvl.topBorderLine = nil;
                        sbvl.rightBorderLine = nil;
                        sbvl.leftBorderLine = nil;
                        
                        //如果自己的上边和左边有子视图。
                        if (rect.origin.x - leftMargin > padding.left)
                        {
                            sbvl.leftBorderLine = self.IntelligentBorderLine;
                        }
                        
                        if (rect.origin.y + rect.size.height + bottomMargin < selfRect.size.height - padding.bottom)
                        {
                            sbvl.bottomBorderLine = self.IntelligentBorderLine;
                        }
                    }
                    
                }
            }

            
            //这里有可能子视图本身的宽度会超过布局视图本身，但是我们的候选区域则不存储超过的宽度部分。
            CGRect cRect = CGRectMake(rect.origin.x - leftMargin, rect.origin.y - topMargin, rect.size.width + leftMargin + rightMargin, MIN((rect.size.height + topMargin + bottomMargin),(selfRect.size.height - padding.top - padding.bottom)));
            
            //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
            for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxX(candidateRect) <= CGRectGetMaxX(cRect))
                    [bottomCandidateRects removeObjectAtIndex:i];
            }
            
            //删除顶部宽度小于新添加区域的顶部的候选区域
            for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxX(candidateRect) <= CGRectGetMinX(cRect))
                    [topCandidateRects removeObjectAtIndex:i];
            }
            
            [bottomCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            bottomLastXOffset = rect.origin.x - leftMargin;
            
            if (rect.origin.x + rect.size.width + rightMargin > bottomMaxWidth)
                bottomMaxWidth = rect.origin.x + rect.size.width + rightMargin;
        }
        else
        {
            CGPoint nextPoint = {bottomLastXOffset,padding.top};
            CGFloat bottomCandidateYBoundary = selfRect.size.height - padding.bottom;
            //如果是清除了浮动则直换行移动到最下面。
            if (sbv.clearFloat)
            {
                //找到最低点。
                nextPoint.x = MAX(topMaxWidth, bottomLastXOffset);
                
                CGPoint bottomPoint = [self findBottomCandidatePoint:CGRectMake(nextPoint.x, padding.top,CGFLOAT_MAX,0) height:topMargin + (sbv.weight != 0 ? 0: rect.size.height) + bottomMargin bottomBoundary:selfRect.size.height - padding.bottom bottomCandidateRects:bottomCandidateRects hasWeight:NO];
                if (bottomPoint.x != CGFLOAT_MAX)
                {
                    nextPoint.x = MAX(topMaxWidth, bottomPoint.x);
                    bottomCandidateYBoundary = bottomPoint.y;
                }
            }
            else
            {
                
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;
                    CGPoint bottomPoint = [self findBottomCandidatePoint:candidateRect height:topMargin + (sbv.weight != 0 ? 0: rect.size.height) + bottomMargin bottomBoundary:selfRect.size.height - padding.bottom bottomCandidateRects:bottomCandidateRects hasWeight:sbv.weight != 0];
                    if (bottomPoint.x != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(MAX(nextPoint.x, bottomPoint.x),CGRectGetMaxY(candidateRect));
                        bottomCandidateYBoundary = bottomPoint.y;
                        break;
                    }
                    
                    nextPoint.x = CGRectGetMaxX(candidateRect);
                }
            }
            
            if (sbv.weight != 0)
            {
                rect.size.height = [sbv.heightDime validMeasure:(bottomCandidateYBoundary - nextPoint.y - topMargin - bottomMargin) * sbv.weight];
                
                if (sbv.widthDime.dimeRelaVal == sbv.heightDime)
                    rect.size.width = [sbv.widthDime validMeasure:rect.size.height * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
                
            }
            
            rect.origin.y = nextPoint.y + topMargin;
            rect.origin.x = MIN(nextPoint.x,maxWidth) + leftMargin;
            
            //如果有智能边界线则找出所有智能边界线。
            if (self.IntelligentBorderLine != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderLine)
                    {
                        sbvl.bottomBorderLine = nil;
                        sbvl.topBorderLine = nil;
                        sbvl.rightBorderLine = nil;
                        sbvl.leftBorderLine = nil;
                        
                        //如果自己的上边和左边有子视图。
                        if (rect.origin.x - leftMargin > padding.left)
                        {
                            sbvl.leftBorderLine = self.IntelligentBorderLine;
                        }
                        
                        if (rect.origin.y - topMargin > padding.top)
                        {
                            sbvl.topBorderLine = self.IntelligentBorderLine;
                        }
                    }
                    
                }
            }

            
            CGRect cRect = CGRectMake(rect.origin.x - leftMargin, rect.origin.y - topMargin,rect.size.width + leftMargin + rightMargin,MIN((rect.size.height + topMargin + bottomMargin),(selfRect.size.height - padding.top - padding.bottom)));
            
            
            //把新添加到候选中去。并删除宽度小于的最新候选区域的候选区域
            for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxX(candidateRect) <= CGRectGetMaxX(cRect))
                    [topCandidateRects removeObjectAtIndex:i];
            }
            
            //删除顶部宽度小于新添加区域的顶部的候选区域
            for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxX(candidateRect) <= CGRectGetMinX(cRect))
                    [bottomCandidateRects removeObjectAtIndex:i];
            }

            
            [topCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            topLastXOffset = rect.origin.x - leftMargin;
            
            if (rect.origin.x + rect.size.width + rightMargin > topMaxWidth)
                topMaxWidth = rect.origin.x + rect.size.width + rightMargin;
            
        }
        
        if (rect.origin.x + rect.size.width + rightMargin > maxWidth)
            maxWidth = rect.origin.x + rect.size.width + rightMargin;
        
        sbv.absPos.frame = rect;
        
    }
    
    maxWidth += padding.right;
    
    if (self.wrapContentWidth)
        selfRect.size.width = maxWidth;
    else
    {
        CGFloat addXPos = 0;
        MyMarginGravity mghorz = self.gravity & MyMarginGravity_Vert_Mask;
        if (mghorz == MyMarginGravity_Horz_Center)
        {
            addXPos = (selfRect.size.width - maxWidth) / 2;
        }
        else if (mghorz == MyMarginGravity_Horz_Right)
        {
            addXPos = selfRect.size.width - maxWidth;
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


-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
{
    CGRect selfRect = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass];
    
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            continue;
        
        if (!isEstimate)
        {
            sbv.absPos.frame = sbv.frame;
            
            //处理尺寸等于内容时并且需要添加额外尺寸的情况。
            if (sbv.widthDime.dimeSelfVal != nil || sbv.heightDime.dimeSelfVal != nil)
            {
                CGSize fitSize = [sbv sizeThatFits:CGSizeZero];
                if (sbv.widthDime.dimeSelfVal != nil)
                {
                    sbv.absPos.width = [sbv.widthDime validMeasure:fitSize.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
                }
                
                if (sbv.heightDime.dimeSelfVal != nil)
                {
                    sbv.absPos.height = [sbv.heightDime validMeasure:fitSize.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
                }
            }

            
        }
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            if (pHasSubLayout != NULL)
                *pHasSubLayout = YES;
            
            //流式布局因为左右边距和自身的宽高没有限制所以这里不需要进行wrapContent的约束控制。
            MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
            if (isEstimate)
            {
                [sbvl estimateLayoutRect:sbvl.absPos.frame.size inSizeClass:sizeClass];
                sbvl.absPos.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
        }
    }
    
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
        selfRect = [self layoutSubviewsForVert:selfRect];
    else
        selfRect = [self layoutSubviewsForHorz:selfRect];
    
    
    
    
    selfRect.size.height = [self.heightDime validMeasure:selfRect.size.height];
    selfRect.size.width = [self.widthDime validMeasure:selfRect.size.width];
    
    
    return selfRect;
}

-(id)createSizeClassInstance
{
    return [MyLayoutSizeClassLinearLayout new];
}


@end

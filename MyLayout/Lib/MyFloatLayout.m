//
//  MyFloatLayout.m
//  MyLayout
//
//  Created by apple on 16/2/18.
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)layoutSubviewsForVert2:(CGRect)selfRect
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || ( sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
    }
    
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
        
        
        if (sbv.widthDime.dimeRelaVal != nil)
        {
            if (sbv.widthDime.dimeRelaVal == self.widthDime)
                rect.size.width = [sbv.widthDime validMeasure:(selfRect.size.width - self.leftPadding - self.rightPadding) * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
            else
                ;// rect.size.width = [sbv.widthDime validMeasure:(sbv.widthDime.dimeRelaVal.view.absPos.width) * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        }
        
        if (sbv.heightDime.dimeRelaVal == self.heightDime)
            rect.size.height = [sbv.heightDime validMeasure:(selfRect.size.height - self.topPadding - self.bottomPadding) * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        
        
        // if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
        //   rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        //宽度可以等于其他的宽度，而高度可以等于其他的宽度。
        
        //非浮动的顺序
        //浮动的顺序。
        
        
        //如果高度是浮动的则需要调整高度。
        if (sbv.isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
    }
    
   

    
    
    return selfRect;
}

-(CGRect)layoutSubviewsForVert:(CGRect)selfRect
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || ( sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
    }
    
    
    //候选的换行点
    NSMutableArray *candidatePoints = [NSMutableArray new];
    CGPoint nextFloatPoint = {self.leftPadding,self.topPadding};
    CGFloat maxHeight = self.topPadding;
    CGFloat floatBoundary = self.leftPadding;  //左边的边界
    CGFloat reverseFloatBoundary = selfRect.size.width - self.rightPadding;  //右边的边界
    
    
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
     
        
        if (sbv.widthDime.dimeRelaVal != nil)
        {
            if (sbv.widthDime.dimeRelaVal == self.widthDime)
                rect.size.width = [sbv.widthDime validMeasure:(selfRect.size.width - self.leftPadding - self.rightPadding) * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
            else
                ;// rect.size.width = [sbv.widthDime validMeasure:(sbv.widthDime.dimeRelaVal.view.absPos.width) * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        }
        
        if (sbv.heightDime.dimeRelaVal == self.heightDime)
            rect.size.height = [sbv.heightDime validMeasure:(selfRect.size.height - self.topPadding - self.bottomPadding) * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        
        
       // if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
         //   rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        //宽度可以等于其他的宽度，而高度可以等于其他的宽度。
         
        //如果高度是浮动的则需要调整高度。
        if (sbv.isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        
        
        //计算nextPoint 加上自身的宽度是否超过总的宽度，如果超过则换行。
        if (nextFloatPoint.x + leftMargin + rect.size.width + rightMargin > selfRect.size.width - self.rightPadding)
        {
            
            //从候选的位置中选择一个位置。
            NSInteger candidateCount = candidatePoints.count;
            CGPoint candidatePoint = {self.leftPadding,self.topPadding};
            for (NSInteger i = candidateCount - 1; i >= 0; i--)
            {
                NSValue *candidateValue = candidatePoints[i];
                candidatePoint = candidateValue.CGPointValue;
                
                if (candidatePoint.x + leftMargin + rect.size.width + rightMargin <= selfRect.size.width - self.rightPadding)
                    break;
            }
            
            
            rect.origin.x = candidatePoint.x + leftMargin;
            rect.origin.y = candidatePoint.y + topMargin;
            
            //y值最后一个加入的顶部，而x则是按浮动的顺序调整。
            nextFloatPoint.x = rect.origin.x + rect.size.width + rightMargin;
            nextFloatPoint.y = rect.origin.y - topMargin;
            
            
        }
        else
        {
            
            rect.origin.x = nextFloatPoint.x + leftMargin;
            rect.origin.y = nextFloatPoint.y + topMargin;
            
            nextFloatPoint.x += rect.size.width + rightMargin + leftMargin;
        }
        
        
        CGFloat newCandidateXOffset = self.leftPadding;
        BOOL hasDel = NO;
        NSInteger candidateCount = candidatePoints.count;
        for (NSInteger i = candidateCount - 1; i >= 0; i--)
        {
            NSValue *candidateValue = candidatePoints[i];
            CGPoint candidatePoint = candidateValue.CGPointValue;
            
            //如果当前的高度高于前面候选的则要将前面候选换行点删除
            if (rect.origin.y + rect.size.height + bottomMargin >= candidatePoint.y)
            {
                [candidatePoints removeObjectAtIndex:i];
                newCandidateXOffset = candidatePoint.x;
                hasDel = YES;
            }
            else
            {
                if (!hasDel)
                    newCandidateXOffset = rect.origin.x - leftMargin;
                break;
            }
        }
        
        NSValue *candidateValue = [NSValue valueWithCGPoint:CGPointMake(newCandidateXOffset, rect.size.height + rect.origin.y + bottomMargin)];
        [candidatePoints addObject:candidateValue];
        
        
        if (rect.origin.y + rect.size.height + bottomMargin > maxHeight)
            maxHeight = rect.origin.y + rect.size.height + bottomMargin;
        
        sbv.absPos.frame = rect;

    }
    
    maxHeight += self.bottomPadding;
    if (self.wrapContentHeight)
        selfRect.size.height = maxHeight;
    
    
    return selfRect;
}

-(CGRect)layoutSubviewsForHorz:(CGRect)selfRect
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || ( sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
    }
    
    
    //候选的换行点
    NSMutableArray *candidatePoints = [NSMutableArray new];
    CGPoint nextPoint = {self.leftPadding,self.topPadding};
    CGFloat maxWidth = self.leftPadding;
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
        
        
        if (sbv.widthDime.dimeRelaVal == self.widthDime)
            rect.size.width = [sbv.widthDime validMeasure:(selfRect.size.width - self.leftPadding - self.rightPadding) * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
        
        if (sbv.heightDime.dimeRelaVal == self.heightDime)
            rect.size.height = [sbv.heightDime validMeasure:(selfRect.size.height - self.topPadding - self.bottomPadding) * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        
        
        // if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
        //   rect.size.height = [sbv.heightDime validMeasure:rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
        
        
        
        //如果高度是浮动的则需要调整高度。
        if (sbv.isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        
        
        //计算nextPoint 加上自身的宽度是否超过总的宽度，如果超过则换行。
        if (nextPoint.y + topMargin + rect.size.height + bottomMargin > selfRect.size.height - self.bottomPadding)
        {
            
            //从候选的位置中选择一个位置。
            NSInteger candidateCount = candidatePoints.count;
            CGPoint candidatePoint = {self.leftPadding,self.topPadding};
            for (NSInteger i = candidateCount - 1; i >= 0; i--)
            {
                NSValue *candidateValue = candidatePoints[i];
                candidatePoint = candidateValue.CGPointValue;
                
                if (candidatePoint.y + topMargin + rect.size.height + bottomMargin <= selfRect.size.height - self.bottomPadding)
                    break;
            }
            
            
            rect.origin.x = candidatePoint.x + leftMargin;
            rect.origin.y = candidatePoint.y + topMargin;
            
            //y值最后一个加入的顶部，而x则是按浮动的顺序调整。
            nextPoint.y = rect.origin.y + rect.size.height + bottomMargin;
            nextPoint.x = rect.origin.x - leftMargin;
            
            
        }
        else
        {
            
            rect.origin.x = nextPoint.x + leftMargin;
            rect.origin.y = nextPoint.y + topMargin;
            
            nextPoint.y += rect.size.height + bottomMargin + topMargin;
        }
        
        
        CGFloat newCandidateYOffset = self.topPadding;
        BOOL hasDel = NO;
        NSInteger candidateCount = candidatePoints.count;
        for (NSInteger i = candidateCount - 1; i >= 0; i--)
        {
            NSValue *candidateValue = candidatePoints[i];
            CGPoint candidatePoint = candidateValue.CGPointValue;
            
            //如果当前的高度高于前面候选的则要将前面候选换行点删除
            if (rect.origin.x + rect.size.width + rightMargin >= candidatePoint.x)
            {
                [candidatePoints removeObjectAtIndex:i];
                newCandidateYOffset = candidatePoint.y;
                hasDel = YES;
            }
            else
            {
                if (!hasDel)
                    newCandidateYOffset = rect.origin.y - topMargin;
                break;
            }
        }
        
        NSValue *candidateValue = [NSValue valueWithCGPoint:CGPointMake(rect.size.width + rect.origin.x + rightMargin,newCandidateYOffset)];
        [candidatePoints addObject:candidateValue];
        
        
        if (rect.origin.x + rect.size.width+ rightMargin > maxWidth)
            maxWidth = rect.origin.x + rect.size.width + rightMargin;
        
        sbv.absPos.frame = rect;
        
    }
    
    maxWidth += self.rightPadding;
    if (self.wrapContentWidth)
        selfRect.size.width = maxWidth;
    
    
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
    
    
    //定义数组
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

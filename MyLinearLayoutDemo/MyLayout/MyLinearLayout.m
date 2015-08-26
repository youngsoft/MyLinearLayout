//
//  MyLinearLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/2/12.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLinearLayout.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>

@implementation UIView(LinearLayoutExt)

const char * const ASSOCIATEDOBJECT_KEY_WEIGHT = "associatedobject_key_weight";


-(CGFloat)weight
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_WEIGHT);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setWeight:(CGFloat)weight
{
    if (weight < 0)
        return;
    
    CGFloat oldVal = [self weight];
    if (oldVal != weight)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_WEIGHT, [NSNumber numberWithFloat:weight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}




@end



@implementation MyLinearLayout


-(void)construct
{
    [super construct];
    _orientation = LVORIENTATION_VERT;
    self.wrapContentHeight = YES;
    self.wrapContentWidth = NO;
    _gravity = MGRAVITY_NONE;
}


-(void)setOrientation:(LineViewOrientation)orientation
{
    if (_orientation != orientation)
    {
        if (orientation == LVORIENTATION_VERT)
        {
            self.wrapContentHeight = YES;
            self.wrapContentWidth = NO;
        }
        else
        {
            self.wrapContentHeight = NO;
            self.wrapContentWidth = YES;
        }
        
        _orientation = orientation;
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



-(void)averageSubviews:(BOOL)centered
{
    if (_orientation == LVORIENTATION_VERT)
    {
        [self averageSubviewsForVert:centered];
    }
    else
    {
        [self averageSubviewsForHorz:centered];
    }
}

-(void)averageMargin:(BOOL)centered
{
    if (_orientation == LVORIENTATION_VERT)
    {
        [self averageMarginForVert:centered];
    }
    else
    {
        [self averageMarginForHorz:centered];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if ([newSuperview isKindOfClass:[UIScrollView class]])
        self.adjustScrollViewContentSize = YES;
    
}



- (CGFloat)AdjustSelfWidth:(NSArray *)sbs
{
    CGFloat selfWidth=self.frame.size.width;
    CGFloat maxSubviewWidth = 0;
    
    //计算最宽的子视图的宽度
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        
        //计算最大的视图的宽度
        if (self.wrapContentWidth &&  !v.widthDime.isMatchParent)
        {
            CGFloat leftMargin =  v.leftPos.margin;
            CGFloat rightMargin = v.rightPos.margin;
            CGFloat centerMargin = v.centerXPos.margin;
            
            CGFloat vWidth = v.frame.size.width;
            if (v.widthDime.dimeNumVal != nil)
                vWidth = v.widthDime.measure;
            
            //左边 + 中间偏移+ 宽度 + 右边
            maxSubviewWidth = [self calcSelfMeasure:maxSubviewWidth
                                     subviewMeasure:vWidth
                                         headMargin:leftMargin
                                         centerMargin:centerMargin
                                         tailMargin:rightMargin];
            
            
        }
    }
    
    //调整自己的宽度
    if (self.wrapContentWidth)
    {
        selfWidth = maxSubviewWidth + self.padding.left + self.padding.right;
        CGRect rectSelf = self.frame;
        rectSelf.size.width = selfWidth;
        self.frame = rectSelf;
    }
    return selfWidth;
}

-(void)layoutSubviewsForVert
{
    

    NSArray *sbs = self.subviews;
    
    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat floatingHeight = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat selfHeight = self.frame.size.height;
    CGFloat selfWidth = [self AdjustSelfWidth:sbs];
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGRect rect = v.frame;
        CGFloat leftMargin =  v.leftPos.margin;
        CGFloat rightMargin = v.rightPos.margin;
        CGFloat centerMargin = v.centerXPos.margin;
        CGFloat topMargin = v.topPos.margin;
        CGFloat bottomMargin = v.bottomPos.margin;
        BOOL isFlexedHeight = v.isFlexedHeight && v.weight == 0;
        
        
        if (v.widthDime.dimeNumVal != nil)
            rect.size.width = v.widthDime.measure;
        if (v.heightDime.dimeNumVal != nil)
            rect.size.height = v.heightDime.measure;
        
        
        //调整子视图的宽度，如果子视图为matchParent的话
        if (v.widthDime.isMatchParent)
            [self calcMatchParentWidth:v.widthDime selfWidth:selfWidth leftMargin:leftMargin  centerMargin:centerMargin rightMargin:rightMargin leftPadding:self.leftPadding rightPadding:self.rightPadding rect:&rect];
        
        
        MarignGravity mg = MGRAVITY_HORZ_LEFT;
        if ((_gravity & 0x0F)!= MGRAVITY_NONE)
            mg =_gravity & 0x0F;
        else
        {
            if (v.centerXPos.posVal != nil)
                mg = MGRAVITY_HORZ_CENTER;
            else if (v.leftPos.posVal != nil && v.rightPos.posVal != nil)
                mg = MGRAVITY_HORZ_FILL;
            else if (v.leftPos.posVal != nil)
                mg = MGRAVITY_HORZ_LEFT;
            else if (v.rightPos.posVal != nil)
                mg = MGRAVITY_HORZ_RIGHT;
        }
        
        [self horzGravity:mg selfWidth:selfWidth leftMargin:leftMargin centerMargin:centerMargin rightMargin:rightMargin rect:&rect];
        
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, rect.size.height)];
            rect.size.height = sz.height;
        }
        
        
        //计算固定高度和浮动高度。
        if ([self isRelativeMargin:topMargin])
            totalWeight += topMargin;
        else
            fixedHeight += topMargin;
        
        if ([self isRelativeMargin:bottomMargin])
            totalWeight += bottomMargin;
        else
            fixedHeight += bottomMargin;
        
        if (v.weight > 0.0)
        {
            totalWeight += v.weight;
        }
        else
        {
            fixedHeight += rect.size.height;
        }
        
        v.frame = rect;  //这里调整宽度
    }

    //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    floatingHeight = selfHeight - fixedHeight - self.padding.top - self.padding.bottom;
    if (floatingHeight <= 0 || floatingHeight == -0.0)
        floatingHeight = 0;
    
    CGFloat pos = self.padding.top;
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGFloat topMargin = v.topPos.margin;
        CGFloat bottomMargin = v.bottomPos.margin;
        CGFloat weight = v.weight;
        CGRect rect = v.frame;
        
        //布局顶部边距
        if ([self isRelativeMargin:topMargin])
        {
            CGFloat hh = (topMargin / totalWeight) * floatingHeight;
            if (hh <= 0 || hh == -0.0)
                hh = 0;
            
            pos += hh;
        }
        else
            pos += topMargin;
        
        //布局高度
        if (weight > 0)
        {
            //计算浮动的高度，将剩余的总高度和 高度比重以及总高度比重减去上下的边距来计算自身的高度。
            CGFloat hh = (weight / totalWeight) * floatingHeight;
            if (hh <= 0 || hh == -0.0)
                hh = 0;
            
            rect.origin.y = pos;
            rect.size.height = hh;
            
        }
        else
        {
            rect.origin.y = pos;
        }
        
        pos += rect.size.height;
        
        //布局底部边距
        if ([self isRelativeMargin:bottomMargin])
        {
            CGFloat th = (bottomMargin / totalWeight) * floatingHeight;
            if (th <= 0 || th == -0.0)
                th = 0;
            
            pos += th;
            
        }
        else
            pos += bottomMargin;
        
        
        v.frame = rect;
    }
    
    pos += self.padding.bottom;
    
    if (self.wrapContentHeight && totalWeight == 0)
    {
        CGRect rectSelf = self.frame;
        
        rectSelf.size.height = pos;
        
        self.frame = rectSelf;
    }
    
}

-(void)layoutSubviewsForHorz
{
    
    
    NSArray *sbs = self.subviews;
    
    CGFloat fixedWidth = 0;   //计算固定部分的高度
    CGFloat floatingWidth = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    CGFloat maxSubviewHeight = 0;
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        if ([self isRelativeMargin:v.leftPos.margin])
            totalWeight += v.leftPos.margin;
        else
            fixedWidth += v.leftPos.margin;
        
        if ([self isRelativeMargin:v.rightPos.margin])
            totalWeight += v.rightPos.margin;
        else
            fixedWidth += v.rightPos.margin;
        
        if (v.weight > 0.0)
        {
            totalWeight += v.weight;
        }
        else
        {
            if (v.widthDime.dimeNumVal != nil)
                fixedWidth += v.widthDime.measure;
            else
                fixedWidth += v.frame.size.width;
        }
    }
    
    //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
    floatingWidth = selfWidth - fixedWidth - self.padding.left - self.padding.right;
    if (floatingWidth <= 0 || floatingWidth == -0.0)
        floatingWidth = 0;
    
    //调整宽度。
    CGFloat pos = self.padding.left;
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGFloat leftMargin = v.leftPos.margin;
        CGFloat rightMargin = v.rightPos.margin;
        CGFloat weight = v.weight;
        BOOL isFlexedHeight = v.isFlexedHeight && !v.heightDime.isMatchParent;
        CGRect rect = v.frame;
        
        if (v.widthDime.dimeNumVal != nil)
            rect.size.width = v.widthDime.measure;
        if (v.heightDime.dimeNumVal != nil)
            rect.size.height = v.heightDime.measure;
        
        //布局顶部边距
        if ([self isRelativeMargin:leftMargin])
        {
            CGFloat hh = (leftMargin / totalWeight) * floatingWidth;
            if (hh <= 0 || hh == -0.0)
                hh = 0;
            
            pos += hh;
        }
        else
            pos += leftMargin;
        
        if (weight > 0)
        {
            CGFloat h = (weight / totalWeight) * floatingWidth;
            if (h <= 0 || h == -0.0)
                h = 0;
            
            rect.origin.x = pos;
            rect.size.width = h;
            
        }
        else
        {
            rect.origin.x = pos;
        }
        
        pos += rect.size.width;
        
        //布局底部边距
        if ([self isRelativeMargin:rightMargin])
        {
            CGFloat th = (rightMargin / totalWeight) * floatingWidth;
            if (th <= 0 || th == -0.0)
                th = 0;
            
            pos += th;
            
        }
        else
            pos += rightMargin;
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, rect.size.height)];
            rect.size.height = sz.height;
        }
        
        //计算最高的高度。
        if (self.wrapContentHeight && !v.heightDime.isMatchParent)
        {
            CGFloat topMargin = v.topPos.margin;
            CGFloat centerMargin = v.centerYPos.margin;
            CGFloat bottomMargin = v.bottomPos.margin;
            
            
            maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headMargin:topMargin centerMargin:centerMargin tailMargin:bottomMargin];
            
        }
        
        v.frame = rect;
    }
    
    if (self.wrapContentHeight)
    {
        selfHeight = maxSubviewHeight + self.padding.top + self.padding.bottom;
        CGRect rectSelf = self.frame;
        rectSelf.size.height = selfHeight;
        self.frame = rectSelf;
    }
    
    
    //调整高度
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGFloat topMargin =   v.topPos.margin;
        CGFloat centerMargin = v.centerYPos.margin;
        CGFloat bottomMargin = v.bottomPos.margin;
        
        CGRect rect = v.frame;
        
        //布局高度
        if (v.heightDime.isMatchParent)
            [self calcMatchParentHeight:v.heightDime selfHeight:selfHeight topMargin:topMargin centerMargin:centerMargin bottomMargin:bottomMargin topPadding:self.topPadding bottomPadding:self.bottomPadding rect:&rect];
        
        //优先以容器中的指定为标准
        
        MarignGravity mg = MGRAVITY_VERT_TOP;
        if ((_gravity & 0xF0)!= MGRAVITY_NONE)
            mg =_gravity & 0xF0;
        else
        {
            if (v.centerYPos.posVal != nil)
                mg = MGRAVITY_VERT_CENTER;
            else if (v.topPos.posVal != nil && v.bottomPos.posVal != nil)
                mg = MGRAVITY_VERT_FILL;
            else if (v.topPos.posVal != nil)
                mg = MGRAVITY_VERT_TOP;
            else if (v.bottomPos.posVal != nil)
                mg = MGRAVITY_VERT_BOTTOM;
        }
        
        [self vertGravity:mg selfHeight:selfHeight topMargin:topMargin centerMargin:centerMargin bottomMargin:bottomMargin rect:&rect];
        
        v.frame = rect;
    }
    
    pos += self.padding.right;
    
    if (self.wrapContentWidth && totalWeight == 0)
    {
        CGRect rectSelf = self.frame;
        rectSelf.size.width = pos;
        self.frame = rectSelf;
    }
    
}


-(void)layoutSubviewsForVertGravity
{
    //计算子视图。
    NSArray *sbs = self.subviews;
    
    CGFloat totalHeight = 0;
    
    
    CGFloat selfHeight = self.frame.size.height;
    CGFloat selfWidth = [self AdjustSelfWidth:sbs];
   
    CGFloat floatingHeight = selfHeight - self.padding.top - self.padding.bottom;
    if (floatingHeight <=0)
        floatingHeight = 0;
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGRect rect = v.frame;
        CGFloat leftMargin =   v.leftPos.margin;
        CGFloat centerMaring = v.centerXPos.margin;
        CGFloat rightMargin =  v.rightPos.margin;
        CGFloat topMargin = v.topPos.margin;
        CGFloat bottomMargin = v.bottomPos.margin;
        BOOL isFlexedHeight = v.isFlexedHeight && v.weight == 0;
        
        if (v.widthDime.dimeNumVal != nil)
            rect.size.width = v.widthDime.measure;
        if (v.heightDime.dimeNumVal != nil)
            rect.size.height = v.heightDime.measure;
        
        
        //调整子视图的宽度，如果子视图为matchParent的话
        if (v.widthDime.isMatchParent)
            [self calcMatchParentWidth:v.widthDime selfWidth:selfWidth leftMargin:leftMargin centerMargin:centerMaring rightMargin:rightMargin leftPadding:self.leftPadding rightPadding:self.rightPadding rect:&rect];
        
        //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
        MarignGravity mg = MGRAVITY_HORZ_LEFT;
        if ((_gravity & 0x0F)!= MGRAVITY_NONE)
            mg =_gravity & 0x0F;
        else
        {
            if (v.centerXPos.posVal != nil)
                mg = MGRAVITY_HORZ_CENTER;
            else if (v.leftPos.posVal != nil && v.rightPos.posVal != nil)
                mg = MGRAVITY_HORZ_FILL;
            else if (v.leftPos.posVal != nil)
                mg = MGRAVITY_HORZ_LEFT;
            else if (v.rightPos.posVal != nil)
                mg = MGRAVITY_HORZ_RIGHT;
        }
        
        [self horzGravity:mg selfWidth:selfWidth leftMargin:leftMargin centerMargin:centerMaring rightMargin:rightMargin rect:&rect];
        
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, rect.size.height)];
            rect.size.height = sz.height;
        }
        
        
        if ([self isRelativeMargin:topMargin])
            totalHeight += floatingHeight * topMargin;
        else
            totalHeight += topMargin;
        
        totalHeight += rect.size.height;
        
        if ([self isRelativeMargin:bottomMargin])
            totalHeight += floatingHeight * bottomMargin;
        else
            totalHeight += bottomMargin;

        
        
        
        v.frame = rect;  //这里调整宽度
    }

    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    if ((_gravity & 0xF0) == MGRAVITY_VERT_TOP)
    {
        pos = self.padding.top;
    }
    else if ((_gravity & 0xF0) == MGRAVITY_VERT_CENTER)
    {
        pos = (self.frame.size.height - totalHeight - self.padding.bottom - self.padding.top)/2.0;
        pos += self.padding.top;
    }
    else
    {
        pos = self.frame.size.height - totalHeight - self.padding.bottom;
    }
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
       CGFloat topMargin = v.topPos.margin;
       CGFloat bottomMargin = v.bottomPos.margin;
        
       if ([self isRelativeMargin:topMargin])
            pos += floatingHeight * topMargin;
        else
            pos += topMargin;
        
        CGRect rect = v.frame;
        rect.origin.y = pos;
        
        v.frame = rect;
        
        pos += rect.size.height;
        
        if ([self isRelativeMargin:bottomMargin])
            pos += floatingHeight * bottomMargin;
        else
            pos += bottomMargin;
    }
    
    
}

-(void)layoutSubviewsForHorzGravity
{
    //计算子视图。
    NSArray *sbs = self.subviews;
    
    CGFloat totalWidth = 0;
    CGFloat floatingWidth = 0;
    
    CGFloat selfHeight = self.frame.size.height;
    CGFloat selfWidth = self.frame.size.width;
    CGFloat maxSubviewHeight = 0;
    
    floatingWidth = selfWidth - self.padding.left - self.padding.right;
    if (floatingWidth <= 0)
        floatingWidth = 0;
    
    //计算出固定的高度
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGFloat topMargin =  v.topPos.margin;
        CGFloat centerMarin = v.centerYPos.margin;
        CGFloat bottomMargin = v.bottomPos.margin;
        CGRect rect = v.frame;
        BOOL isFlexedHeight = v.isFlexedHeight && !v.heightDime.isMatchParent;
        
        if (v.widthDime.dimeNumVal != nil)
            rect.size.width = v.widthDime.measure;
        
        if (v.heightDime.dimeNumVal != nil)
            rect.size.height = v.heightDime.measure;
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, rect.size.height)];
            rect.size.height = sz.height;
        }
        
        
        //计算以子视图为大小的情况
        if (self.wrapContentHeight && !v.heightDime.isMatchParent)
        {
                maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headMargin:topMargin centerMargin:centerMarin tailMargin:bottomMargin];
        }
        
        if ([self isRelativeMargin:v.leftPos.margin])
            totalWidth += floatingWidth * v.leftPos.margin;
        else
            totalWidth += v.leftPos.margin;
        
        totalWidth += rect.size.width;
        
        if ([self isRelativeMargin:v.rightPos.margin])
            totalWidth += floatingWidth * v.rightPos.margin;
        else
            totalWidth += v.rightPos.margin;
        
        v.frame = rect;
    }
    
    
    //调整自己的高度。
    if (self.wrapContentHeight)
    {
        selfHeight = maxSubviewHeight + self.padding.top + self.padding.bottom;
        CGRect rectSelf = self.frame;
        rectSelf.size.height = selfHeight;
        self.frame = rectSelf;
    }
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    if ((_gravity & 0x0F) == MGRAVITY_HORZ_LEFT)
    {
        pos = self.padding.left;
    }
    else if ((_gravity & 0x0F) == MGRAVITY_HORZ_CENTER)
    {
        pos = (selfWidth - totalWidth - self.padding.left - self.padding.right)/2.0;
        pos += self.padding.left;
    }
    else
    {
        pos = self.frame.size.width - totalWidth - self.padding.right;
    }
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGFloat leftMargin = v.leftPos.margin;
        CGFloat rightMargin = v.rightPos.margin;
        CGFloat topMargin =  v.topPos.margin;
        CGFloat centerMargin = v.centerYPos.margin;
        CGFloat bottomMargin = v.bottomPos.margin;
        
        if ([self isRelativeMargin:leftMargin])
            pos += floatingWidth * v.leftPos.margin;
        else
            pos += v.leftPos.margin;
        
        CGRect rect = v.frame;
        rect.origin.x = pos;
        
        //计算高度
        if (v.heightDime.isMatchParent)
            [self calcMatchParentHeight:v.heightDime selfHeight:selfHeight topMargin:topMargin centerMargin:centerMargin bottomMargin:bottomMargin topPadding:self.topPadding bottomPadding:self.bottomPadding rect:&rect];
        
      
        MarignGravity mg = MGRAVITY_VERT_TOP;
        if ((_gravity & 0xF0)!= MGRAVITY_NONE)
            mg =_gravity & 0xF0;
        else
        {
            if (v.centerYPos.posVal != nil)
                mg = MGRAVITY_VERT_CENTER;
            else if (v.topPos.posVal != nil && v.bottomPos.posVal != nil)
                mg = MGRAVITY_VERT_FILL;
            else if (v.topPos.posVal != nil)
                mg = MGRAVITY_VERT_TOP;
            else if (v.bottomPos.posVal != nil)
                mg = MGRAVITY_VERT_BOTTOM;
        }
        
        [self vertGravity:mg selfHeight:selfHeight topMargin:topMargin centerMargin:centerMargin bottomMargin:bottomMargin rect:&rect];
        
        v.frame = rect;
        
        pos += rect.size.width;
        
        if ([self isRelativeMargin:rightMargin])
            pos += floatingWidth * rightMargin;
        else
            pos += rightMargin;
    }
    
    
}




- (void)calcScrollViewContentSize:(CGRect)oldRect autoAdjustSize:(BOOL)autoAdjustSize
{
    if (autoAdjustSize && self.adjustScrollViewContentSize && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrolv = (UIScrollView*)self.superview;
        CGRect newRect = self.frame;
        
        CGSize contsize = scrolv.contentSize;
        
        if (_orientation == LVORIENTATION_VERT && newRect.size.height != oldRect.size.height)
        {
            contsize.height = newRect.size.height;
            scrolv.contentSize = contsize;
            
        }
        else if(_orientation == LVORIENTATION_HORZ && newRect.size.width != oldRect.size.width)
        {
            contsize.width = newRect.size.width;
            scrolv.contentSize = contsize;
            
        }
    }
}

-(void)doLayoutSubviews
{
    
    [super doLayoutSubviews];
    
    CGRect oldRect = self.frame;
    BOOL autoAdjustSize = NO;

    if (_orientation == LVORIENTATION_VERT)
    {
        autoAdjustSize = self.wrapContentHeight;
         if ((_gravity & 0xF0) != MGRAVITY_NONE)
         {
             [self layoutSubviewsForVertGravity];
             autoAdjustSize = NO;
         }
         else
              [self layoutSubviewsForVert];
    }
    else
    {
        autoAdjustSize = self.wrapContentWidth;
        if ((_gravity & 0x0F) != MGRAVITY_NONE)
        {
            [self layoutSubviewsForHorzGravity];
            autoAdjustSize = NO;
        }
        else
            [self layoutSubviewsForHorz];
        
    }
    
    
    [self calcScrollViewContentSize:oldRect autoAdjustSize:autoAdjustSize];
}

#pragma mark -- Private Method

-(CGFloat)calcSelfMeasure:(CGFloat)selfMeasure subviewMeasure:(CGFloat)subviewMeasure headMargin:(CGFloat)headMargin centerMargin:(CGFloat)centerMargin tailMargin:(CGFloat)tailMargin
{
    //计算以子视图为大小的情况
    CGFloat temp = subviewMeasure;
    CGFloat tempWeight = 0;
    
    if (![self isRelativeMargin:headMargin])
        temp += headMargin;
    else
        tempWeight += headMargin;
    
    if (![self isRelativeMargin:centerMargin])
        temp += centerMargin;
    else
        tempWeight += centerMargin;
    
    if (![self isRelativeMargin:tailMargin])
        temp += tailMargin;
    else
        tempWeight += tailMargin;
    
    
    if (1  <= tempWeight)
        temp = 0;
    else
        temp /=(1 - tempWeight);
    
    if (temp > selfMeasure)
    {
        selfMeasure = temp;
    }
    
    //宽度优先取widthDime.如果没有设置则取视图设置的宽度。
    
    //如果指定了宽度那么总的就是 左边距 + 宽度 + 右边距
    //如果没有指定宽度
    
    return selfMeasure;

}

-(void)averageSubviewsForVert:(BOOL)centered
{
    NSArray *arr = self.subviews;
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:arr.count];
    for (UIView *v in arr)
    {
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        [sbs addObject:v];
        
    }
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
    CGFloat scale = 1 / fragments;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        
        v.bottomPos.equalTo(@0);
        v.topPos.equalTo(@(scale));
        v.weight = scale;
        
        if (i == 0 && !centered)
            v.topPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            v.bottomPos.equalTo(@(scale));
    }
    
    [self setNeedsLayout];
}

-(void)averageSubviewsForHorz:(BOOL)centered
{
    NSArray *arr = self.subviews;
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:arr.count];
    for (UIView *v in arr)
    {
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        [sbs addObject:v];
        
    }

    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
    CGFloat scale = 1 / fragments;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        
        v.leftPos.equalTo(@(scale));
        v.weight = scale;
        
        if (i == 0 && !centered)
            v.leftPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            v.rightPos.equalTo(@(scale));
    }
    
    [self setNeedsLayout];

}


-(void)averageMarginForVert:(BOOL)centered
{
    NSArray *arr = self.subviews;
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:arr.count];
    for (UIView *v in arr)
    {
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        [sbs addObject:v];
        
    }

    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        
        v.topPos.equalTo(@(scale));
        
        if (i == 0 && !centered)
            v.topPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            v.bottomPos.equalTo(@(scale));
    }
    
    [self setNeedsLayout];
    
    
}

-(void)averageMarginForHorz:(BOOL)centered
{
    NSArray *arr = self.subviews;
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:arr.count];
    for (UIView *v in arr)
    {
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        [sbs addObject:v];
        
    }

    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        
        v.leftPos.equalTo(@(scale));
        
        if (i == 0 && !centered)
            v.leftPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            v.rightPos.equalTo(@(scale));
    }
    
    [self setNeedsLayout];

}




@end

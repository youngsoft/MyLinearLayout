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



-(id)initWithOrientation:(LineViewOrientation)orientation
{
    self = [self init];
    if (self)
    {
        self.orientation = orientation;
    }
    
    return self;
}

+(id)linearLayoutWithOrientation:(LineViewOrientation)orientation
{
    return [[self alloc] initWithOrientation:orientation];
}


-(void)setOrientation:(LineViewOrientation)orientation
{
    if (orientation == LVORIENTATION_VERT)
        self.wrapContentHeight = YES;
    else
        self.wrapContentWidth = YES;
    _orientation = orientation;
    [self setNeedsLayout];
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
        [self averageSubviewsForVert:centered withMargin:CGFLOAT_MAX];
    }
    else
    {
        [self averageSubviewsForHorz:centered withMargin:CGFLOAT_MAX];
    }
}

-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin
{
    if (_orientation == LVORIENTATION_VERT)
    {
        [self averageSubviewsForVert:centered withMargin:margin];
    }
    else
    {
        [self averageSubviewsForHorz:centered withMargin:margin];
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



- (CGRect)AdjustSelfWidth:(NSArray *)sbs newSelfRect:(CGRect)newSelfRect
{
    
    CGFloat maxSubviewWidth = 0;
    
    //计算出最宽的子视图所占用的宽度
    if (self.wrapContentWidth)
    {
        for (int i = 0; i < sbs.count; i++)
        {
            UIView *v = [sbs objectAtIndex:i];
            if (v.isHidden && self.hideSubviewReLayout)
                continue;
            
            if (!v.widthDime.isMatchParent)
            {
                CGFloat leftMargin =  v.leftPos.margin;
                CGFloat rightMargin = v.rightPos.margin;
                CGFloat centerMargin = v.centerXPos.margin;
                
                CGFloat vWidth = v.absPos.width;
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
        
        newSelfRect.size.width = maxSubviewWidth + self.padding.left + self.padding.right;
    }
    
    return newSelfRect;
}

-(CGRect)layoutSubviewsForVert:(CGRect)newSelfRect
{
    

    NSArray *sbs = self.subviews;
    
    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat floatingHeight = 0; //浮动的高度。
    CGFloat totalWeight = 0;    //剩余部分的总比重
    newSelfRect = [self AdjustSelfWidth:sbs newSelfRect:newSelfRect];   //调整自身的宽度
   
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGRect rect = v.absPos.frame;
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
        if (v.widthDime.isMatchParent || (v.leftPos.posVal != nil && v.rightPos.posVal != nil))
            [self calcMatchParentWidth:v.widthDime selfWidth:newSelfRect.size.width leftMargin:leftMargin  centerMargin:centerMargin rightMargin:rightMargin leftPadding:self.leftPadding rightPadding:self.rightPadding rect:&rect];
        
        
        MarignGravity mg = MGRAVITY_HORZ_LEFT;
        if ((_gravity & MGRAVITY_VERT_MASK)!= MGRAVITY_NONE)
            mg =_gravity & MGRAVITY_VERT_MASK;
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
        
        [self horzGravity:mg selfWidth:newSelfRect.size.width leftMargin:leftMargin centerMargin:centerMargin rightMargin:rightMargin rect:&rect];
        
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, 0)];
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
        
        v.absPos.frame = rect;
    }

    //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    floatingHeight = newSelfRect.size.height - fixedHeight - self.padding.top - self.padding.bottom;
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
        CGRect rect =  v.absPos.frame;
        
        //分别处理相对顶部边距和绝对顶部边距
        if ([self isRelativeMargin:topMargin])
        {
            CGFloat hh = (topMargin / totalWeight) * floatingHeight;
            if (hh <= 0 || hh == -0.0)
                hh = 0;
            
            pos += hh;
        }
        else
            pos += topMargin;
        
        //分别处理相对高度和绝对高度
        if (weight > 0)
        {
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
        
        //分别处理相对底部边距和绝对底部边距
        if ([self isRelativeMargin:bottomMargin])
        {
            CGFloat th = (bottomMargin / totalWeight) * floatingHeight;
            if (th <= 0 || th == -0.0)
                th = 0;
            
            pos += th;
            
        }
        else
            pos += bottomMargin;
        
        
        v.absPos.frame = rect;
    }
    
    pos += self.padding.bottom;
    

    if (self.wrapContentHeight && totalWeight == 0)
    {
        newSelfRect.size.height = pos;
    }
    
    return newSelfRect;
}

-(CGRect)layoutSubviewsForHorz:(CGRect)newSelfRect
{
    
    NSArray *sbs = self.subviews;
    
    CGFloat fixedWidth = 0;   //计算固定部分的高度
    CGFloat floatingWidth = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat maxSubviewHeight = 0;
    
    //计算出固定的子视图宽度的总和以及宽度比例总和
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
                fixedWidth += v.absPos.width;
        }
    }
    
    //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
    floatingWidth = newSelfRect.size.width - fixedWidth - self.padding.left - self.padding.right;
    if (floatingWidth <= 0 || floatingWidth == -0.0)
        floatingWidth = 0;
    
    //调整所有子视图的宽度
    CGFloat pos = self.padding.left;
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGFloat leftMargin = v.leftPos.margin;
        CGFloat rightMargin = v.rightPos.margin;
        CGFloat weight = v.weight;
        BOOL isFlexedHeight = v.isFlexedHeight && !v.heightDime.isMatchParent;
        CGRect rect =  v.absPos.frame;
        
        if (v.widthDime.dimeNumVal != nil)
            rect.size.width = v.widthDime.measure;
        if (v.heightDime.dimeNumVal != nil)
            rect.size.height = v.heightDime.measure;
        
        //计算出先对左边边距和绝对左边边距
        if ([self isRelativeMargin:leftMargin])
        {
            CGFloat hh = (leftMargin / totalWeight) * floatingWidth;
            if (hh <= 0 || hh == -0.0)
                hh = 0;
            
            pos += hh;
        }
        else
            pos += leftMargin;
        
        //计算出相对宽度和绝对宽度
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
        
        //计算相对的右边边距和绝对的右边边距
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
        
        v.absPos.frame = rect;
    }
    
    if (self.wrapContentHeight)
    {
        newSelfRect.size.height = maxSubviewHeight + self.padding.top + self.padding.bottom;
    }
    
    
    //调整高度
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGFloat topMargin =   v.topPos.margin;
        CGFloat centerMargin = v.centerYPos.margin;
        CGFloat bottomMargin = v.bottomPos.margin;
        
        CGRect rect = v.absPos.frame;
        
        //布局高度
        if (v.heightDime.isMatchParent || (v.topPos.posVal != nil && v.bottomPos.posVal != nil))
            [self calcMatchParentHeight:v.heightDime selfHeight:newSelfRect.size.height topMargin:topMargin centerMargin:centerMargin bottomMargin:bottomMargin topPadding:self.topPadding bottomPadding:self.bottomPadding rect:&rect];
        
        //优先以容器中的指定为标准
        MarignGravity mg = MGRAVITY_VERT_TOP;
        if ((_gravity & MGRAVITY_HORZ_MASK)!= MGRAVITY_NONE)
            mg =_gravity & MGRAVITY_HORZ_MASK;
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
        
        [self vertGravity:mg selfHeight:newSelfRect.size.height topMargin:topMargin centerMargin:centerMargin bottomMargin:bottomMargin rect:&rect];
        
        v.absPos.frame = rect;
    }
    
    pos += self.padding.right;
    
    if (self.wrapContentWidth && totalWeight == 0)
    {
        newSelfRect.size.width = pos;
    }
    
    return newSelfRect;
}


-(CGRect)layoutSubviewsForVertGravity:(CGRect)newSelfRect
{
    //计算子视图。
    NSArray *sbs = self.subviews;
    
    CGFloat totalHeight = 0;
    
    newSelfRect = [self AdjustSelfWidth:sbs newSelfRect:newSelfRect];
   
    CGFloat floatingHeight = newSelfRect.size.height - self.padding.top - self.padding.bottom;
    if (floatingHeight <=0)
        floatingHeight = 0;
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden && self.hideSubviewReLayout)
            continue;
        
        CGRect rect =  v.absPos.frame;
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
        if (v.widthDime.isMatchParent || (v.leftPos.posVal != nil && v.rightPos.posVal != nil))
            [self calcMatchParentWidth:v.widthDime selfWidth:newSelfRect.size.width leftMargin:leftMargin centerMargin:centerMaring rightMargin:rightMargin leftPadding:self.leftPadding rightPadding:self.rightPadding rect:&rect];
        
        //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
        MarignGravity mg = MGRAVITY_HORZ_LEFT;
        if ((_gravity & MGRAVITY_VERT_MASK)!= MGRAVITY_NONE)
            mg =_gravity & MGRAVITY_VERT_MASK;
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
        
        [self horzGravity:mg selfWidth:newSelfRect.size.width leftMargin:leftMargin centerMargin:centerMaring rightMargin:rightMargin rect:&rect];
        
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, 0)];
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

        
        
        v.absPos.frame = rect;
    }

    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    if ((_gravity & MGRAVITY_HORZ_MASK) == MGRAVITY_VERT_TOP)
    {
        pos = self.padding.top;
    }
    else if ((_gravity & MGRAVITY_HORZ_MASK) == MGRAVITY_VERT_CENTER)
    {
        pos = (newSelfRect.size.height - totalHeight - self.padding.bottom - self.padding.top)/2.0;
        pos += self.padding.top;
    }
    else
    {
        pos = newSelfRect.size.height - totalHeight - self.padding.bottom;
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
        
        v.absPos.topPos = pos;
        
        pos +=  v.absPos.height; //rect.size.height;
        
        if ([self isRelativeMargin:bottomMargin])
            pos += floatingHeight * bottomMargin;
        else
            pos += bottomMargin;
    }
    
    return newSelfRect;
    
}

-(CGRect)layoutSubviewsForHorzGravity:(CGRect)newSelfRect
{
    //计算子视图。
    NSArray *sbs = self.subviews;
    
    CGFloat totalWidth = 0;
    CGFloat floatingWidth = 0;
    
    CGFloat maxSubviewHeight = 0;
    
    floatingWidth = newSelfRect.size.width - self.padding.left - self.padding.right;
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
        CGRect rect = v.absPos.frame;
        BOOL isFlexedHeight = v.isFlexedHeight && !v.heightDime.isMatchParent;
        
        if (v.widthDime.dimeNumVal != nil)
            rect.size.width = v.widthDime.measure;
        
        if (v.heightDime.dimeNumVal != nil)
            rect.size.height = v.heightDime.measure;
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, 0)];
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
        
        v.absPos.frame = rect;
    }
    
    
    //调整自己的高度。
    if (self.wrapContentHeight)
    {
        newSelfRect.size.height = maxSubviewHeight + self.padding.top + self.padding.bottom;
    }
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    if ((_gravity & MGRAVITY_VERT_MASK) == MGRAVITY_HORZ_LEFT)
    {
        pos = self.padding.left;
    }
    else if ((_gravity & MGRAVITY_VERT_MASK) == MGRAVITY_HORZ_CENTER)
    {
        pos = (newSelfRect.size.width - totalWidth - self.padding.left - self.padding.right)/2.0;
        pos += self.padding.left;
    }
    else
    {
        pos = newSelfRect.size.width - totalWidth - self.padding.right;
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
        
        CGRect rect = v.absPos.frame;
        rect.origin.x = pos;
        
        //计算高度
        if (v.heightDime.isMatchParent || (v.topPos.posVal != nil && v.bottomPos.posVal != nil))
            [self calcMatchParentHeight:v.heightDime selfHeight:newSelfRect.size.height topMargin:topMargin centerMargin:centerMargin bottomMargin:bottomMargin topPadding:self.topPadding bottomPadding:self.bottomPadding rect:&rect];
        
      
        MarignGravity mg = MGRAVITY_VERT_TOP;
        if ((_gravity & MGRAVITY_HORZ_MASK)!= MGRAVITY_NONE)
            mg =_gravity & MGRAVITY_HORZ_MASK;
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
        
        [self vertGravity:mg selfHeight:newSelfRect.size.height topMargin:topMargin centerMargin:centerMargin bottomMargin:bottomMargin rect:&rect];
        
        v.absPos.frame = rect;
        
        pos += rect.size.width;
        
        if ([self isRelativeMargin:rightMargin])
            pos += floatingWidth * rightMargin;
        else
            pos += rightMargin;
    }

    return newSelfRect;
}


-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate
{
    CGRect newSelfRect;
    
    if (isEstimate)
        newSelfRect = self.absPos.frame;
    else
        newSelfRect = [super estimateLayoutRect:size];
    
    
    if (_orientation == LVORIENTATION_VERT)
    {
        
        //如果是垂直的布局，但是子视图设置了左右的边距或者设置了宽度则wrapContentWidth应该设置为NO
        for (UIView *sbv in self.subviews)
        {
            if (!isEstimate)
            {
                sbv.absPos.frame = sbv.frame;
            }
            
            if ([sbv isKindOfClass:[MyLayoutBase class]])
            {
                MyLayoutBase *sbvl = (MyLayoutBase*)sbv;
                if (sbvl.wrapContentWidth)
                {
                    //只要同时设置了左右边距或者设置了宽度则应该把wrapContentWidth置为NO
                    if ((sbvl.leftPos.posVal != nil && sbvl.rightPos.posVal != nil) || sbvl.widthDime.dimeVal != nil)
                        [sbvl setWrapContentWidthNoLayout:NO];
                }
                
                if (isEstimate)
                {
                    [sbvl estimateLayoutRect:sbvl.absPos.frame.size];
                }
            }
            
        }
        
        
        if ((_gravity & MGRAVITY_HORZ_MASK) != MGRAVITY_NONE)
            newSelfRect = [self layoutSubviewsForVertGravity:newSelfRect];
        else
            newSelfRect = [self layoutSubviewsForVert:newSelfRect];
    }
    else
    {
        //如果是水平的布局，但是子视图设置了上下的边距或者设置了高度则wrapContentWidth应该设置为NO
        for (UIView *sbv in self.subviews)
        {
            if (!isEstimate)
            {
                sbv.absPos.frame = sbv.frame;
            }
            
            if ([sbv isKindOfClass:[MyLayoutBase class]])
            {
                MyLayoutBase *sbvl = (MyLayoutBase*)sbv;
                if (sbvl.wrapContentHeight)
                {
                    //只要同时设置了左右边距或者设置了宽度则应该把wrapContentWidth置为NO
                    if ((sbvl.topPos.posVal != nil && sbvl.bottomPos.posVal != nil) || sbvl.heightDime.dimeVal != nil)
                        [sbvl setWrapContentHeightNoLayout:NO];
                }
                
                if (isEstimate)
                {
                    [sbvl estimateLayoutRect:sbvl.absPos.frame.size];
                }
            }
            
        }
        
        
        if ((_gravity & MGRAVITY_VERT_MASK) != MGRAVITY_NONE)
            newSelfRect = [self layoutSubviewsForHorzGravity:newSelfRect];
        else
            newSelfRect = [self layoutSubviewsForHorz:newSelfRect];
        
    }
    
    return newSelfRect;
   
}


-(CGRect)estimateLayoutRect:(CGSize)size
{
    self.absPos.frame = [self calcLayoutRect:size isEstimate:NO];
    return [self calcLayoutRect:CGSizeZero isEstimate:YES];
}


-(CGRect)doLayoutSubviews
{
    return [self calcLayoutRect:CGSizeZero isEstimate:NO];
}

#pragma mark -- Private Method

-(CGFloat)calcSelfMeasure:(CGFloat)selfMeasure subviewMeasure:(CGFloat)subviewMeasure headMargin:(CGFloat)headMargin centerMargin:(CGFloat)centerMargin tailMargin:(CGFloat)tailMargin
{
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
    
    return selfMeasure;

}

-(void)averageSubviewsForVert:(BOOL)centered withMargin:(CGFloat)margin
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
    
    CGFloat scale;
    CGFloat scale2;
    
    if (margin == CGFLOAT_MAX)
    {
       CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
        scale = 1 / fragments;
        scale2 = scale;

    }
    else
    {
        scale = 1.0;
        scale2 = margin;
    }
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        
        v.bottomPos.equalTo(@0);
        v.topPos.equalTo(@(scale2));
        v.weight = scale;
        
        if (i == 0 && !centered)
            v.topPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            v.bottomPos.equalTo(@(scale2));
    }
    
    [self setNeedsLayout];
}

-(void)averageSubviewsForHorz:(BOOL)centered withMargin:(CGFloat)margin
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
    CGFloat scale;
    CGFloat scale2;
    
    if (margin == CGFLOAT_MAX)
    {
        CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
        scale = 1 / fragments;
        scale2 = scale;
        
    }
    else
    {
        scale = 1.0;
        scale2 = margin;
    }

    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        
        v.leftPos.equalTo(@(scale2));
        v.weight = scale;
        
        if (i == 0 && !centered)
            v.leftPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            v.rightPos.equalTo(@(scale2));
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

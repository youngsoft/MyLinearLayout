//
//  MyLineView.m
//  MiniClient
//
//  Created by apple on 15/2/12.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyLinearLayout.h"
#import <objc/runtime.h>

@implementation UIView(LinearLayoutExtra)

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
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_WEIGHT, [NSNumber numberWithFloat:weight], OBJC_ASSOCIATION_RETAIN);
        
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
    _adjustScrollViewContentSize = NO;
    _autoAdjustSize = YES;
    _gravity = MGRAVITY_NONE;
    _autoAdjustDir = LVAUTOADJUSTDIR_TAIL;
    _wrapContent = NO;
}


-(void)setOrientation:(LineViewOrientation)orientation
{
    if (_orientation != orientation)
    {
       
        _orientation = orientation;
         [self setNeedsLayout];
    }
}

-(void)setAutoAdjustSize:(BOOL)autoAdjustSize
{
    if (_autoAdjustSize != autoAdjustSize)
    {
        
        _autoAdjustSize = autoAdjustSize;
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

-(void)setAutoAdjustDir:(LineViewAutoAdjustDir)autoAdjustDir
{
    if (_autoAdjustDir != autoAdjustDir)
    {
        _autoAdjustDir = autoAdjustDir;
        [self setNeedsLayout];
    }
}

-(void)setWrapContent:(BOOL)wrapContent
{
    if (_wrapContent != wrapContent)
    {
        _wrapContent = wrapContent;
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




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(void)layoutSubviewsForVert
{
    

    NSArray *sbs = self.subviews;
    
    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat floatingHeight = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat maxSubviewWidth = 0;
    
    //计算最宽的子视图的宽度
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        //计算最大子视图的尺寸
        if (self.wrapContent && v.matchParentWidth == 0)
        {
            //如果不用停靠则采用原始的origin.x的值。
            if ((v.marginGravity & 0x0F) == MGRAVITY_NONE && (self.gravity & 0x0F) == MGRAVITY_NONE)
                maxSubviewWidth = [self calcSelfMeasure:maxSubviewWidth subviewMeasure:v.frame.size.width headMargin:v.frame.origin.x - self.leftPadding - self.padding.right tailMargin:0];
            else
                maxSubviewWidth = [self calcSelfMeasure:maxSubviewWidth subviewMeasure:v.frame.size.width headMargin:v.leftMargin tailMargin:v.rightMargin];
        }
    }
    
    //调整自己的宽度
    if (self.wrapContent)
    {
        selfWidth = maxSubviewWidth + self.padding.left + self.padding.right;
        CGRect rectSelf = self.bounds;
        rectSelf.size.width = selfWidth;
        self.bounds = rectSelf;
    }
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        CGRect rect = v.frame;
        CGFloat matchParentWidth = v.matchParentWidth;
        CGFloat leftMargin = v.leftMargin;
        CGFloat rightMargin = v.rightMargin;
        CGFloat topMargin = v.topMargin;
        CGFloat bottomMargin = v.bottomMargin;
        MarignGravity marginGravity = v.marginGravity;
        BOOL isFlexedHeight = v.isFlexedHeight && v.weight == 0;
        
        
        //调整子视图的宽度，如果子视图为matchParent的话
        [self calcMatchParentWidth:matchParentWidth selfWidth:selfWidth leftMargin:leftMargin rightMargin:rightMargin leftPadding:self.leftPadding rightPadding:self.rightPadding rect:&rect];
        
        //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
        if ((_gravity & 0x0F)!= MGRAVITY_NONE)
        {
            [self horzGravity:_gravity & 0x0F selfWidth:selfWidth leftMargin:leftMargin rightMargin:rightMargin rect:&rect];
        }
        else
        {
            [self horzGravity:marginGravity & 0x0F selfWidth:selfWidth leftMargin:leftMargin rightMargin:rightMargin rect:&rect];
        }
        
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
        if (v.isHidden)
            continue;
        
        CGFloat topMargin = v.topMargin;
        CGFloat bottomMargin = v.bottomMargin;
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
    
    if (self.autoAdjustSize && totalWeight == 0)
    {
        CGRect rectSelf = self.frame;
        
        if (_autoAdjustDir == LVAUTOADJUSTDIR_TAIL)
        {
            rectSelf.size.height = pos;
        }
        else if (_autoAdjustDir == LVAUTOADJUSTDIR_HEAD)
        {
            CGFloat endpos = selfHeight + self.frame.origin.y;
            rectSelf.size.height = pos;
            rectSelf.origin.y = endpos - rectSelf.size.height;
            
        }
        else
        {
            rectSelf.size.height = pos;
            rectSelf.origin.y -= (pos - selfHeight)/2;
        }
        
        self.frame = rectSelf;
    }
    
}

-(void)layoutSubviewsForHorz
{
    
    
    NSArray *sbs = self.subviews;
    
    CGFloat fixedWidth = 0;   //计算固定部分的高度
    CGFloat floatingWidth = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat maxSubviewHeight = 0;
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        if ([self isRelativeMargin:v.leftMargin])
            totalWeight += v.leftMargin;
        else
            fixedWidth += v.leftMargin;
        
        if ([self isRelativeMargin:v.rightMargin])
            totalWeight += v.rightMargin;
        else
            fixedWidth += v.rightMargin;
        
        if (v.weight > 0.0)
        {
            totalWeight += v.weight;
        }
        else
        {
            
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
        if (v.isHidden)
            continue;
        
        CGFloat leftMargin = v.leftMargin;
        CGFloat rightMargin = v.rightMargin;
        CGFloat weight = v.weight;
        BOOL isFlexedHeight = v.isFlexedHeight && v.matchParentHeight == 0;
        CGRect rect = v.frame;
        
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
        
        //布局高度
        if (weight > 0)
        {
            //计算浮动的高度，将剩余的总高度和 高度比重以及总高度比重减去上下的边距来计算自身的高度。
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
        if (self.wrapContent && v.matchParentHeight == 0)
        {
            if ((v.marginGravity & 0xF0) == MGRAVITY_NONE && (self.gravity & 0xF0) == MGRAVITY_NONE)
                maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headMargin:rect.origin.y - self.topPadding - self.bottomPadding tailMargin:0];
            else
                maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headMargin:v.topMargin tailMargin:v.bottomMargin];
            
        }
        
        v.frame = rect;
    }
    
    if (self.wrapContent)
    {
        selfHeight = maxSubviewHeight + self.padding.top + self.padding.bottom;
        CGRect rectSelf = self.bounds;
        rectSelf.size.height = selfHeight;
        self.bounds = rectSelf;
    }
    
    
    //调整高度
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        CGFloat topMargin = v.topMargin;
        CGFloat bottomMargin = v.bottomMargin;
        CGFloat matchParentHeight = v.matchParentHeight;
        CGRect rect = v.frame;
        
        //布局高度
        [self calcMatchParentHeight:matchParentHeight selfHeight:selfHeight topMargin:topMargin bottomMargin:bottomMargin topPadding:self.topPadding bottomPadding:self.bottomPadding rect:&rect];
        
        //优先以容器中的指定为标准
        if ((_gravity & 0xF0) != MGRAVITY_NONE)
        {
            [self vertGravity:_gravity & 0xF0 selfHeight:selfHeight topMargin:topMargin bottomMargin:bottomMargin rect:&rect];
        }
        else
        {
            [self vertGravity:v.marginGravity & 0xF0 selfHeight:selfHeight topMargin:topMargin bottomMargin:bottomMargin rect:&rect];
        }
        
        v.frame = rect;
    }
    
    pos += self.padding.right;
    
    if (self.autoAdjustSize && totalWeight == 0)
    {
        CGRect rectSelf = self.frame;
        
        if (_autoAdjustDir == LVAUTOADJUSTDIR_TAIL)
        {
            rectSelf.size.width = pos;
        }
        else if (_autoAdjustDir == LVAUTOADJUSTDIR_HEAD)
        {
            CGFloat endpos = selfWidth + self.frame.origin.x;
            rectSelf.size.width = pos;
            rectSelf.origin.x = endpos - rectSelf.size.width;
            
        }
        else
        {
            rectSelf.size.width = pos;
            rectSelf.origin.x -= (pos - selfWidth)/2;
        }
        
        self.frame = rectSelf;
    }
    
}


-(void)layoutSubviewsForVertGravity
{
    //计算子视图。
    NSArray *sbs = self.subviews;
    
    CGFloat totalHeight = 0;
    
    
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat maxSubviewWidth = 0;
   
    CGFloat floatingHeight = selfHeight - self.padding.top - self.padding.bottom;
    if (floatingHeight <=0)
        floatingHeight = 0;
    
    
    
    //计算最宽的子视图的宽度
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        //计算最大子视图的尺寸
        if (self.wrapContent && v.matchParentWidth == 0)
        {
            if ((v.marginGravity & 0x0F) == MGRAVITY_NONE && (self.gravity & 0x0F) == MGRAVITY_NONE)
                maxSubviewWidth = [self calcSelfMeasure:maxSubviewWidth subviewMeasure:v.frame.size.width headMargin:v.frame.origin.x - self.leftPadding - self.padding.right tailMargin:0];
            else
                maxSubviewWidth = [self calcSelfMeasure:maxSubviewWidth subviewMeasure:v.frame.size.width headMargin:v.leftMargin tailMargin:v.rightMargin];
        }
    }
    
    //调整自己的宽度
    if (self.wrapContent)
    {
        selfWidth = maxSubviewWidth + self.padding.left + self.padding.right;
        CGRect rectSelf = self.bounds;
        rectSelf.size.width = selfWidth;
        self.bounds = rectSelf;
    }

    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        CGRect rect = v.frame;
        CGFloat matchParentWidth = v.matchParentWidth;
        CGFloat leftMargin = v.leftMargin;
        CGFloat rightMargin = v.rightMargin;
        CGFloat topMargin = v.topMargin;
        CGFloat bottomMargin = v.bottomMargin;
        MarignGravity marginGravity = v.marginGravity;
        BOOL isFlexedHeight = v.isFlexedHeight && v.weight == 0;
        
        
        //调整子视图的宽度，如果子视图为matchParent的话
        [self calcMatchParentWidth:matchParentWidth selfWidth:selfWidth leftMargin:leftMargin rightMargin:rightMargin leftPadding:self.leftPadding rightPadding:self.rightPadding rect:&rect];
        
        //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
        if ((_gravity & 0x0F) != MGRAVITY_NONE)
        {
            [self horzGravity:_gravity & 0x0F selfWidth:selfWidth leftMargin:leftMargin rightMargin:rightMargin rect:&rect];
        }
        else
        {
            [self horzGravity:marginGravity & 0x0F selfWidth:selfWidth leftMargin:leftMargin rightMargin:rightMargin rect:&rect];
        }
        
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
        pos = (self.bounds.size.height - totalHeight - self.padding.bottom - self.padding.top)/2.0;
        pos += self.padding.top;
    }
    else
    {
        pos = self.bounds.size.height - totalHeight - self.padding.bottom;
    }
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
       CGFloat topMargin = v.topMargin;
       CGFloat bottomMargin = v.bottomMargin;
        
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
    
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat maxSubviewHeight = 0;
    
    floatingWidth = selfWidth - self.padding.left - self.padding.right;
    if (floatingWidth <= 0)
        floatingWidth = 0;
    
    //计算出固定的高度
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        CGFloat topMargin = v.topMargin;
        CGFloat bottomMargin = v.bottomMargin;
        CGRect rect = v.frame;
        BOOL isFlexedHeight = v.isFlexedHeight && v.matchParentHeight == 0;
        
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, rect.size.height)];
            rect.size.height = sz.height;
        }
        
        
        //计算以子视图为大小的情况
        if (self.wrapContent && v.matchParentHeight == 0)
        {
            if ((v.marginGravity & 0xF0) == MGRAVITY_NONE && (self.gravity & 0xF0) == MGRAVITY_NONE)
                maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headMargin:rect.origin.y - self.topPadding - self.bottomPadding tailMargin:0];
            else
                maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headMargin:topMargin tailMargin:bottomMargin];
        }
        
        if ([self isRelativeMargin:v.leftMargin])
            totalWidth += floatingWidth * v.leftMargin;
        else
            totalWidth += v.leftMargin;
        
        totalWidth += rect.size.width;
        
        if ([self isRelativeMargin:v.rightMargin])
            totalWidth += floatingWidth * v.rightMargin;
        else
            totalWidth += v.rightMargin;
        
        v.frame = rect;
    }
    
    
    //调整自己的宽度。
    if (self.wrapContent)
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
        pos = self.bounds.size.width - totalWidth - self.padding.right;
    }
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        CGFloat leftMargin = v.leftMargin;
        CGFloat rightMargin = v.rightMargin;
        CGFloat topMargin = v.topMargin;
        CGFloat bottomMargin = v.bottomMargin;
        CGFloat matchParentHeight = v.matchParentHeight;
        
        if ([self isRelativeMargin:leftMargin])
            pos += floatingWidth * v.leftMargin;
        else
            pos += v.leftMargin;
        
        CGRect rect = v.frame;
        rect.origin.x = pos;
        
        //计算高度
        [self calcMatchParentHeight:matchParentHeight selfHeight:selfHeight topMargin:topMargin bottomMargin:bottomMargin topPadding:self.topPadding bottomPadding:self.bottomPadding rect:&rect];
        
        if ((_gravity & 0xF0) != MGRAVITY_NONE)
            [self vertGravity:_gravity & 0xF0 selfHeight:selfHeight topMargin:topMargin bottomMargin:bottomMargin rect:&rect];
        else
            [self vertGravity:v.marginGravity & 0xF0 selfHeight:selfHeight topMargin:topMargin bottomMargin:bottomMargin rect:&rect];
        
        v.frame = rect;
        
        pos += rect.size.width;
        
        if ([self isRelativeMargin:rightMargin])
            pos += floatingWidth * rightMargin;
        else
            pos += rightMargin;
    }
    
    
}




-(void)doLayoutSubviews
{
    
    [super doLayoutSubviews];
    
    CGRect oldRect = self.bounds;
    BOOL autoAdjustSize = _autoAdjustSize;

    if (_orientation == LVORIENTATION_VERT)
    {
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
        if ((_gravity & 0x0F) != MGRAVITY_NONE)
        {
            [self layoutSubviewsForHorzGravity];
            autoAdjustSize = NO;
        }
        else
            [self layoutSubviewsForHorz];
        
    }
    
    
    if (autoAdjustSize && self.adjustScrollViewContentSize && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrolv = (UIScrollView*)self.superview;
        CGRect newRect = self.bounds;
        
        CGSize contsize = scrolv.contentSize;
        
        if (_orientation == LVORIENTATION_VERT && newRect.size.height != oldRect.size.height)
        {
            contsize.height = self.bounds.size.height;
            scrolv.contentSize = contsize;
            
        }
        else if(_orientation == LVORIENTATION_HORZ && newRect.size.width != oldRect.size.width)
        {
            contsize.width = self.bounds.size.width;
            scrolv.contentSize = contsize;
            
        }
    }
}

#pragma mark -- Private Method

-(CGFloat)calcSelfMeasure:(CGFloat)selfMeasure subviewMeasure:(CGFloat)subviewMeasure headMargin:(CGFloat)headMargin tailMargin:(CGFloat)tailMargin
{
    //计算以子视图为大小的情况
    CGFloat temp = subviewMeasure;
    CGFloat tempWeight = 0;
    
    if (![self isRelativeMargin:headMargin])
        temp += headMargin;
    else
        tempWeight += headMargin;
    
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

-(void)averageSubviewsForVert:(BOOL)centered
{
    NSArray *sbs = self.subviews;
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
    CGFloat scale = 1 / fragments;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        
        v.bottomMargin = 0;
        v.topMargin = scale;
        v.weight = scale;
        
        if (i == 0 && !centered)
            v.topMargin = 0;
        
        if (i == sbs.count - 1 && centered)
            v.bottomMargin = scale;
    }
    
    [self setNeedsLayout];
}

-(void)averageSubviewsForHorz:(BOOL)centered
{
    NSArray *sbs = self.subviews;
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
    CGFloat scale = 1 / fragments;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        
        v.leftMargin = scale;
        v.weight = scale;
        
        if (i == 0 && !centered)
            v.leftMargin = 0;
        
        if (i == sbs.count - 1 && centered)
            v.rightMargin = scale;
    }
    
    [self setNeedsLayout];

}





@end

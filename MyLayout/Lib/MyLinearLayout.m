//
//  MyLinearLayout.m
//  MyLayout
//
//  Created by oybq on 15/2/12.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLinearLayout.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>

@implementation UIView(MyLinearLayoutExt)

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

IB_DESIGNABLE
@implementation MyLinearLayout


-(id)initWithOrientation:(MyLayoutViewOrientation)orientation
{
    self = [super init];
    if (self)
    {
        if (orientation == MyLayoutViewOrientation_Vert)
            self.myCurrentSizeClass.wrapContentHeight = YES;
        else
            self.myCurrentSizeClass.wrapContentWidth = YES;
        self.myCurrentSizeClass.orientation = orientation;
        
    }
    
    return self;
}

+(id)linearLayoutWithOrientation:(MyLayoutViewOrientation)orientation
{
    return [[[self class] alloc] initWithOrientation:orientation];
}

-(void)setOrientation:(MyLayoutViewOrientation)orientation
{
    if (self.myCurrentSizeClass.orientation != orientation)
    {
        self.myCurrentSizeClass.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(MyLayoutViewOrientation)orientation
{
    return self.myCurrentSizeClass.orientation;
}



-(void)setGravity:(MyMarginGravity)gravity
{
    
    MyLinearLayout *lsc = self.myCurrentSizeClass;
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

-(void)setSubviewMargin:(CGFloat)subviewMargin
{
    MyLinearLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.subviewMargin != subviewMargin)
    {
        lsc.subviewMargin = subviewMargin;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewMargin
{
    return self.myCurrentSizeClass.subviewMargin;
}


-(void)averageSubviews:(BOOL)centered
{
    [self averageSubviews:centered withMargin:CGFLOAT_MAX];
}

-(void)averageSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    [self averageSubviews:centered withMargin:CGFLOAT_MAX inSizeClass:sizeClass];
}


-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin
{
    [self averageSubviews:centered withMargin:margin inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
    [self setNeedsLayout];
}

-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin inSizeClass:(MySizeClass)sizeClass
{
    self.absPos.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.absPos.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        [self averageSubviewsForVert:centered withMargin:margin];
    }
    else
    {
        [self averageSubviewsForHorz:centered withMargin:margin];
    }
    
    self.absPos.sizeClass = self.myDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.absPos.sizeClass = sbv.myDefaultSizeClass;
}



-(void)averageMargin:(BOOL)centered
{
    [self averageMargin:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
    [self setNeedsLayout];
    
}

-(void)averageMargin:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    self.absPos.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.absPos.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        [self averageMarginForVert:centered];
    }
    else
    {
        [self averageMarginForHorz:centered];
    }
    
    self.absPos.sizeClass = self.myDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.absPos.sizeClass = sbv.myDefaultSizeClass;
    
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
    
    if (newSuperview != nil)
    {
        //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
        if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
            self.adjustScrollViewContentSize = YES;
    }
}

#pragma mark -- Private Method


- (CGRect)AdjustSelfWidth:(NSArray *)sbs newSelfRect:(CGRect)newSelfRect
{
    
    CGFloat maxSubviewWidth = 0;
    
    //计算出最宽的子视图所占用的宽度
    if (self.wrapContentWidth)
    {
        for (UIView *sbv in sbs)
        {
            if (!sbv.widthDime.isMatchParent && (sbv.leftPos.posVal == nil || sbv.rightPos.posVal == nil))
            {
                
                CGFloat vWidth =  [sbv.widthDime validMeasure:sbv.absPos.width];
                if (sbv.widthDime.dimeNumVal != nil)
                    vWidth = sbv.widthDime.measure;
                
                //左边 + 中间偏移+ 宽度 + 右边
                maxSubviewWidth = [self calcSelfMeasure:maxSubviewWidth
                                         subviewMeasure:vWidth
                                                headPos:sbv.leftPos
                                              centerPos:sbv.centerXPos
                                                tailPos:sbv.rightPos];
                
                
            }
        }
        
        newSelfRect.size.width = maxSubviewWidth + self.leftPadding + self.rightPadding;
    }
    
    return newSelfRect;
}

-(CGRect)layoutSubviewsForVert:(CGRect)newSelfRect sbs:(NSArray*)sbs
{
    
    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat floatingHeight = 0; //浮动的高度。
    CGFloat totalWeight = 0;    //剩余部分的总比重
    newSelfRect = [self AdjustSelfWidth:sbs newSelfRect:newSelfRect];   //调整自身的宽度
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    for (UIView *sbv in sbs)
    {
        
        CGRect rect = sbv.absPos.frame;
        
        CGFloat lm = sbv.leftPos.posNumVal.doubleValue;
        CGFloat rm = sbv.rightPos.posNumVal.doubleValue;
        CGFloat cxm = sbv.centerXPos.posNumVal.doubleValue;
        CGFloat tm = sbv.topPos.posNumVal.doubleValue;
        CGFloat bm = sbv.bottomPos.posNumVal.doubleValue;
        
        
        BOOL isFlexedHeight = sbv.isFlexedHeight && sbv.weight == 0;
        
        
        //控制最大最小尺寸限制
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width = [sbv.widthDime validMeasure:rect.size.width];
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        
        
        //调整子视图的宽度，如果子视图为matchParent的话
        if (sbv.widthDime.isMatchParent || (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil))
        {
            
            CGFloat vTotalWidth = (newSelfRect.size.width - self.leftPadding - self.rightPadding)*sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            
            if ([self isRelativeMargin:lm])
                lm = vTotalWidth * lm;
            lm = [sbv.leftPos validMargin:lm + sbv.leftPos.offsetVal];
            
            if ([self isRelativeMargin:cxm])
                cxm = vTotalWidth * cxm;
            cxm = [sbv.centerXPos validMargin:cxm + sbv.centerXPos.offsetVal];
            
            if ([self isRelativeMargin:rm])
                rm = vTotalWidth *rm;
            rm = [sbv.rightPos validMargin:rm + sbv.rightPos.offsetVal];
            
            
            [self calcMatchParentWidth:sbv.widthDime selfWidth:newSelfRect.size.width leftMargin:lm  centerMargin:cxm rightMargin:rm leftPadding:self.leftPadding rightPadding:self.rightPadding rect:&rect];
        }
        
        
        MyMarginGravity mg = MyMarginGravity_Horz_Left;
        if ((self.gravity & MyMarginGravity_Vert_Mask)!= MyMarginGravity_None)
            mg =self.gravity & MyMarginGravity_Vert_Mask;
        else
        {
            if (sbv.centerXPos.posVal != nil)
                mg = MyMarginGravity_Horz_Center;
            else if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
                mg = MyMarginGravity_Horz_Fill;
            else if (sbv.leftPos.posVal != nil)
                mg = MyMarginGravity_Horz_Left;
            else if (sbv.rightPos.posVal != nil)
                mg = MyMarginGravity_Horz_Right;
        }
        
        [self horzGravity:mg selfWidth:newSelfRect.size.width sbv:sbv rect:&rect];
        
        
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        
        //计算固定高度和浮动高度。
        if ([self isRelativeMargin:tm])
        {
            totalWeight += tm;
            fixedHeight += sbv.topPos.offsetVal;
        }
        else
            fixedHeight += sbv.topPos.margin;
        
        
        
        if ([self isRelativeMargin:bm])
        {
            totalWeight += bm;
            fixedHeight += sbv.bottomPos.offsetVal;
        }
        else
            fixedHeight += sbv.bottomPos.margin;
        
        
        if (sbv.weight > 0.0)
        {
            totalWeight += sbv.weight;
        }
        else
        {
            fixedHeight += rect.size.height;
        }
        
        if (sbv != sbs.lastObject)
            fixedHeight += self.subviewMargin;
        
        sbv.absPos.frame = rect;
    }
    
    //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    floatingHeight = newSelfRect.size.height - fixedHeight - self.topPadding - self.bottomPadding;
    if (floatingHeight <= 0 || floatingHeight == -0.0)
        floatingHeight = 0;
    
    CGFloat pos = self.topPadding;
    for (UIView *sbv in sbs) {
        
        
        CGFloat topMargin = sbv.topPos.posNumVal.doubleValue;
        CGFloat bottomMargin = sbv.bottomPos.posNumVal.doubleValue;
        CGFloat weight = sbv.weight;
        CGRect rect =  sbv.absPos.frame;
        
        //分别处理相对顶部边距和绝对顶部边距
        if ([self isRelativeMargin:topMargin])
        {
            CGFloat th = (topMargin / totalWeight) * floatingHeight;
            if (th <= 0 || th == -0.0)
                th = 0;
            
            pos += [sbv.topPos validMargin:th + sbv.topPos.offsetVal];
        }
        else
            pos += [sbv.topPos validMargin:topMargin + sbv.topPos.offsetVal];
        
        //分别处理相对高度和绝对高度
        if (weight > 0)
        {
            CGFloat h = (weight / totalWeight) * floatingHeight;
            if (h <= 0 || h == -0.0)
                h = 0;
            
            rect.origin.y = pos;
            rect.size.height = [sbv.heightDime validMeasure:h];
            
        }
        else
        {
            rect.origin.y = pos;
        }
        
        pos += rect.size.height;
        
        //分别处理相对底部边距和绝对底部边距
        if ([self isRelativeMargin:bottomMargin])
        {
            CGFloat bh = (bottomMargin / totalWeight) * floatingHeight;
            if (bh <= 0 || bh == -0.0)
                bh = 0;
            
            pos += [sbv.bottomPos validMargin:bh + sbv.bottomPos.offsetVal];
            
        }
        else
            pos += [sbv.bottomPos validMargin:bottomMargin + sbv.bottomPos.offsetVal];
        
        if (sbv != sbs.lastObject)
            pos += self.subviewMargin;
        
        sbv.absPos.frame = rect;
    }
    
    pos += self.bottomPadding;
    
    
    if (self.wrapContentHeight && totalWeight == 0)
    {
        newSelfRect.size.height = pos;
    }
    
    return newSelfRect;
}

-(CGRect)layoutSubviewsForHorz:(CGRect)newSelfRect sbs:(NSArray*)sbs
{
    
    CGFloat fixedWidth = 0;   //计算固定部分的高度
    CGFloat floatingWidth = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat maxSubviewHeight = 0;
    
    //计算出固定的子视图宽度的总和以及宽度比例总和
    for (UIView *sbv in sbs)
    {
        
        if ([self isRelativeMargin:sbv.leftPos.posNumVal.doubleValue])
        {
            totalWeight += sbv.leftPos.posNumVal.doubleValue;
            fixedWidth += sbv.leftPos.offsetVal;
        }
        else
            fixedWidth += sbv.leftPos.margin;
        
        if ([self isRelativeMargin:sbv.rightPos.posNumVal.doubleValue])
        {
            totalWeight += sbv.rightPos.posNumVal.doubleValue;
            fixedWidth += sbv.rightPos.offsetVal;
        }
        else
            fixedWidth += sbv.rightPos.margin;
        
        if (sbv.weight > 0.0)
        {
            totalWeight += sbv.weight;
        }
        else
        {
            if (sbv.widthDime.dimeNumVal != nil)
                fixedWidth += sbv.widthDime.measure;
            else
                fixedWidth += [sbv.widthDime validMeasure:sbv.absPos.width];
        }
        
        if (sbv != sbs.lastObject)
            fixedWidth += self.subviewMargin;
    }
    
    //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
    floatingWidth = newSelfRect.size.width - fixedWidth - self.leftPadding - self.rightPadding;
    if (floatingWidth <= 0 || floatingWidth == -0.0)
        floatingWidth = 0;
    
    //调整所有子视图的宽度
    CGFloat pos = self.leftPadding;
    for (UIView *sbv in sbs) {
        
        CGFloat leftMargin = sbv.leftPos.posNumVal.doubleValue;
        CGFloat rightMargin = sbv.rightPos.posNumVal.doubleValue;
        CGFloat weight = sbv.weight;
        BOOL isFlexedHeight = sbv.isFlexedHeight && !sbv.heightDime.isMatchParent;
        CGRect rect =  sbv.absPos.frame;
        
        //控制最大最小尺寸限制
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width = [sbv.widthDime validMeasure:rect.size.width];
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        
        //计算出先对左边边距和绝对左边边距
        if ([self isRelativeMargin:leftMargin])
        {
            CGFloat lw = (leftMargin / totalWeight) * floatingWidth;
            if (lw <= 0 || lw == -0.0)
                lw = 0;
            
            pos += [sbv.leftPos validMargin:lw + sbv.leftPos.offsetVal];
        }
        else
            pos += [sbv.leftPos validMargin:leftMargin + sbv.leftPos.offsetVal];
        
        //计算出相对宽度和绝对宽度
        if (weight > 0)
        {
            CGFloat w = (weight / totalWeight) * floatingWidth;
            if (w <= 0 || w == -0.0)
                w = 0;
            
            rect.origin.x = pos;
            rect.size.width = [sbv.widthDime validMeasure:w];
            
        }
        else
        {
            rect.origin.x = pos;
        }
        
        pos += rect.size.width;
        
        //计算相对的右边边距和绝对的右边边距
        if ([self isRelativeMargin:rightMargin])
        {
            CGFloat rw = (rightMargin / totalWeight) * floatingWidth;
            if (rw <= 0 || rw == -0.0)
                rw = 0;
            
            pos += [sbv.rightPos validMargin:rw + sbv.rightPos.offsetVal];
            
        }
        else
            pos += [sbv.rightPos validMargin:rightMargin + sbv.rightPos.offsetVal];
        
        
        if (sbv != sbs.lastObject)
            pos += self.subviewMargin;
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        //计算最高的高度。
        if (self.wrapContentHeight && !sbv.heightDime.isMatchParent && (sbv.topPos.posVal == nil || sbv.bottomPos.posVal == nil))
        {
            maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headPos:sbv.topPos centerPos:sbv.centerYPos tailPos:sbv.bottomPos];
            
        }
        
        sbv.absPos.frame = rect;
    }
    
    if (self.wrapContentHeight)
    {
        newSelfRect.size.height = maxSubviewHeight + self.topPadding + self.bottomPadding;
    }
    
    
    //调整所有子视图的高度
    for (UIView *sbv in sbs)
    {
        
        CGRect rect = sbv.absPos.frame;
        
        //布局高度
        if (sbv.heightDime.isMatchParent || (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil))
        {
            
            CGFloat tm = sbv.topPos.posNumVal.doubleValue;
            CGFloat cym = sbv.centerYPos.posNumVal.doubleValue;
            CGFloat bm = sbv.bottomPos.posNumVal.doubleValue;
            
            
            CGFloat vTotalHeight = (newSelfRect.size.height - self.topPadding - self.bottomPadding)*sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            
            
            if ([self isRelativeMargin:tm])
                tm = vTotalHeight * tm;
            tm = [sbv.topPos validMargin:tm + sbv.topPos.offsetVal];
            
            if ([self isRelativeMargin:cym])
                cym = vTotalHeight * cym;
            cym = [sbv.centerYPos validMargin:cym + sbv.centerYPos.offsetVal];
            
            if ([self isRelativeMargin:bm])
                bm = vTotalHeight *bm;
            bm = [sbv.bottomPos validMargin:bm + sbv.bottomPos.offsetVal];
            
            
            [self calcMatchParentHeight:sbv.heightDime selfHeight:newSelfRect.size.height topMargin:tm centerMargin:cym bottomMargin:bm topPadding:self.topPadding bottomPadding:self.bottomPadding rect:&rect];
        }
        
        //优先以容器中的指定为标准
        MyMarginGravity mg = MyMarginGravity_Vert_Top;
        if ((self.gravity & MyMarginGravity_Horz_Mask)!= MyMarginGravity_None)
            mg =self.gravity & MyMarginGravity_Horz_Mask;
        else
        {
            if (sbv.centerYPos.posVal != nil)
                mg = MyMarginGravity_Vert_Center;
            else if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
                mg = MyMarginGravity_Vert_Fill;
            else if (sbv.topPos.posVal != nil)
                mg = MyMarginGravity_Vert_Top;
            else if (sbv.bottomPos.posVal != nil)
                mg = MyMarginGravity_Vert_Bottom;
        }
        
        [self vertGravity:mg selfHeight:newSelfRect.size.height sbv:sbv rect:&rect];
        
        sbv.absPos.frame = rect;
    }
    
    pos += self.rightPadding;
    
    if (self.wrapContentWidth && totalWeight == 0)
    {
        newSelfRect.size.width = pos;
    }
    
    return newSelfRect;
}


-(CGRect)layoutSubviewsForVertGravity:(CGRect)newSelfRect sbs:(NSArray*)sbs
{
    
    CGFloat totalHeight = 0;
    if (sbs.count > 1)
        totalHeight += (sbs.count - 1) * self.subviewMargin;
    
    newSelfRect = [self AdjustSelfWidth:sbs newSelfRect:newSelfRect];
    
    CGFloat floatingHeight = newSelfRect.size.height - self.topPadding - self.bottomPadding - totalHeight;
    if (floatingHeight <=0)
        floatingHeight = 0;
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    for (UIView *sbv in sbs)
    {
        
        CGRect rect =  sbv.absPos.frame;
        BOOL isFlexedHeight = sbv.isFlexedHeight && sbv.weight == 0;
        
        CGFloat lm = sbv.leftPos.posNumVal.doubleValue;
        CGFloat rm = sbv.rightPos.posNumVal.doubleValue;
        CGFloat cxm = sbv.centerXPos.posNumVal.doubleValue;
        CGFloat tm = sbv.topPos.posNumVal.doubleValue;
        CGFloat bm = sbv.bottomPos.posNumVal.doubleValue;
        
        
        
        //控制最大最小尺寸限制
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width = [sbv.widthDime validMeasure:rect.size.width];
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        
        //调整子视图的宽度，如果子视图为matchParent的话
        if (sbv.widthDime.isMatchParent || (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil))
        {
            
            CGFloat vTotalWidth = (newSelfRect.size.width - self.leftPadding - self.rightPadding)*sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            
            if ([self isRelativeMargin:lm])
                lm = vTotalWidth * lm;
            lm = [sbv.leftPos validMargin:lm + sbv.leftPos.offsetVal];
            
            if ([self isRelativeMargin:cxm])
                cxm = vTotalWidth * cxm;
            cxm = [sbv.centerXPos validMargin:cxm + sbv.centerXPos.offsetVal];
            
            if ([self isRelativeMargin:rm])
                rm = vTotalWidth *rm;
            rm = [sbv.rightPos validMargin:rm + sbv.rightPos.offsetVal];
            
            
            [self calcMatchParentWidth:sbv.widthDime selfWidth:newSelfRect.size.width leftMargin:lm centerMargin:cxm rightMargin:rm leftPadding:self.leftPadding rightPadding:self.rightPadding rect:&rect];
        }
        
        //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
        MyMarginGravity mg = MyMarginGravity_Horz_Left;
        if ((self.gravity & MyMarginGravity_Vert_Mask)!= MyMarginGravity_None)
            mg =self.gravity & MyMarginGravity_Vert_Mask;
        else
        {
            if (sbv.centerXPos.posVal != nil)
                mg = MyMarginGravity_Horz_Center;
            else if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
                mg = MyMarginGravity_Horz_Fill;
            else if (sbv.leftPos.posVal != nil)
                mg = MyMarginGravity_Horz_Left;
            else if (sbv.rightPos.posVal != nil)
                mg = MyMarginGravity_Horz_Right;
        }
        
        [self horzGravity:mg selfWidth:newSelfRect.size.width sbv:sbv rect:&rect];
        
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        
        if ([self isRelativeMargin:tm])
            tm = floatingHeight * tm;
        
        totalHeight += [sbv.topPos validMargin:tm + sbv.topPos.offsetVal];
        
        totalHeight += rect.size.height;
        
        if ([self isRelativeMargin:bm])
            bm = floatingHeight * bm;
        
        totalHeight += [sbv.bottomPos validMargin:bm + sbv.bottomPos.offsetVal];
        
        sbv.absPos.frame = rect;
    }
    
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    if ((self.gravity & MyMarginGravity_Horz_Mask) == MyMarginGravity_Vert_Top)
    {
        pos = self.topPadding;
    }
    else if ((self.gravity & MyMarginGravity_Horz_Mask) == MyMarginGravity_Vert_Center)
    {
        pos = (newSelfRect.size.height - totalHeight - self.bottomPadding - self.topPadding)/2.0;
        pos += self.topPadding;
    }
    else if ((self.gravity & MyMarginGravity_Horz_Mask) == MyMarginGravity_Vert_Window_Center)
    {
        if (self.window != nil)
        {
            pos = (self.window.frame.size.height - totalHeight)/2.0;
            
            CGPoint pt = CGPointMake(0, pos);
            pos = [self.window convertPoint:pt toView:self].y;
            
            
        }
    }
    else
    {
        pos = newSelfRect.size.height - totalHeight - self.bottomPadding;
    }
    
    
    for (UIView *sbv in sbs)
    {
        
        CGFloat tm = sbv.topPos.posNumVal.doubleValue;
        CGFloat bm = sbv.bottomPos.posNumVal.doubleValue;
        
        if ([self isRelativeMargin:tm])
            pos += [sbv.topPos validMargin:floatingHeight * tm + sbv.topPos.offsetVal];
        else
            pos += [sbv.topPos validMargin:tm + sbv.topPos.offsetVal];
        
        sbv.absPos.topPos = pos;
        
        pos +=  sbv.absPos.height;
        
        if ([self isRelativeMargin:bm])
            pos += [sbv.bottomPos validMargin:floatingHeight * bm  + sbv.bottomPos.offsetVal];
        else
            pos += [sbv.bottomPos validMargin:bm + sbv.bottomPos.offsetVal];
        
        
        if (sbv != sbs.lastObject)
            pos += self.subviewMargin;
    }
    
    return newSelfRect;
    
}

-(CGRect)layoutSubviewsForHorzGravity:(CGRect)newSelfRect sbs:(NSArray*)sbs
{
    
    CGFloat totalWidth = 0;
    if (sbs.count > 1)
        totalWidth += (sbs.count - 1) * self.subviewMargin;
    
    
    CGFloat floatingWidth = 0;
    
    CGFloat maxSubviewHeight = 0;
    
    floatingWidth = newSelfRect.size.width - self.leftPadding - self.rightPadding - totalWidth;
    if (floatingWidth <= 0)
        floatingWidth = 0;
    
    //计算出固定的高度
    for (UIView *sbv in sbs)
    {
        
        CGRect rect = sbv.absPos.frame;
        BOOL isFlexedHeight = sbv.isFlexedHeight && !sbv.heightDime.isMatchParent;
        
        //控制最大最小尺寸限制
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width = [sbv.widthDime validMeasure:rect.size.width];
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(rect.size.width, 0)];
            rect.size.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        
        //计算以子视图为大小的情况
        if (self.wrapContentHeight && !sbv.heightDime.isMatchParent && (sbv.topPos.posVal == nil || sbv.bottomPos.posVal == nil))
        {
            maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headPos:sbv.topPos centerPos:sbv.centerYPos tailPos:sbv.bottomPos];
        }
        
        
        CGFloat lm = sbv.leftPos.posNumVal.doubleValue;
        CGFloat rm = sbv.rightPos.posNumVal.doubleValue;
        
        if ([self isRelativeMargin:lm])
            lm *= floatingWidth;
        totalWidth += [sbv.leftPos validMargin:lm + sbv.leftPos.offsetVal];
        
        totalWidth += rect.size.width;
        
        
        if ([self isRelativeMargin:rm])
            rm *= floatingWidth;
        totalWidth += [sbv.rightPos validMargin:rm + sbv.rightPos.offsetVal];
        
        sbv.absPos.frame = rect;
    }
    
    
    //调整自己的高度。
    if (self.wrapContentHeight)
    {
        newSelfRect.size.height = maxSubviewHeight + self.topPadding + self.bottomPadding;
    }
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    if ((self.gravity & MyMarginGravity_Vert_Mask) == MyMarginGravity_Horz_Left)
    {
        pos = self.leftPadding;
    }
    else if ((self.gravity & MyMarginGravity_Vert_Mask) == MyMarginGravity_Horz_Center)
    {
        pos = (newSelfRect.size.width - totalWidth - self.leftPadding - self.rightPadding)/2.0;
        pos += self.leftPadding;
    }
    else if ((self.gravity & MyMarginGravity_Vert_Mask) == MyMarginGravity_Horz_Window_Center)
    {
        if (self.window != nil)
        {
            pos = (self.window.frame.size.width - totalWidth)/2.0;
            
            CGPoint pt = CGPointMake(pos, 0);
            pos = [self.window convertPoint:pt toView:self].x;
        }
    }
    else
    {
        pos = newSelfRect.size.width - totalWidth - self.rightPadding;
    }
    
    
    for (UIView *sbv in sbs)
    {
        
        CGFloat lm = sbv.leftPos.posNumVal.doubleValue;
        CGFloat rm = sbv.rightPos.posNumVal.doubleValue;
        
        if ([self isRelativeMargin:lm])
            pos += [sbv.leftPos validMargin:floatingWidth * lm + sbv.leftPos.offsetVal];
        else
            pos += [sbv.leftPos validMargin:lm + sbv.leftPos.offsetVal];
        
        
        CGRect rect = sbv.absPos.frame;
        rect.origin.x = pos;
        
        //计算高度
        if (sbv.heightDime.isMatchParent || (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil))
        {
            CGFloat tm = sbv.topPos.posNumVal.doubleValue;
            CGFloat cym = sbv.centerYPos.posNumVal.doubleValue;
            CGFloat bm = sbv.bottomPos.posNumVal.doubleValue;
            
            
            CGFloat vTotalHeight = (newSelfRect.size.height - self.topPadding - self.bottomPadding)*sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            
            
            if ([self isRelativeMargin:tm])
                tm = vTotalHeight * tm;
            tm = [sbv.topPos validMargin:tm + sbv.topPos.offsetVal];
            
            if ([self isRelativeMargin:cym])
                cym = vTotalHeight * cym;
            cym = [sbv.centerYPos validMargin:cym + sbv.centerYPos.offsetVal];
            
            if ([self isRelativeMargin:bm])
                bm = vTotalHeight *bm;
            bm = [sbv.bottomPos validMargin:bm + sbv.bottomPos.offsetVal];
            
            
            [self calcMatchParentHeight:sbv.heightDime selfHeight:newSelfRect.size.height topMargin:tm centerMargin:cym bottomMargin:bm topPadding:self.topPadding bottomPadding:self.bottomPadding rect:&rect];
        }
        
        
        MyMarginGravity mg = MyMarginGravity_Vert_Top;
        if ((self.gravity & MyMarginGravity_Horz_Mask)!= MyMarginGravity_None)
            mg =self.gravity & MyMarginGravity_Horz_Mask;
        else
        {
            if (sbv.centerYPos.posVal != nil)
                mg = MyMarginGravity_Vert_Center;
            else if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
                mg = MyMarginGravity_Vert_Fill;
            else if (sbv.topPos.posVal != nil)
                mg = MyMarginGravity_Vert_Top;
            else if (sbv.bottomPos.posVal != nil)
                mg = MyMarginGravity_Vert_Bottom;
        }
        
        [self vertGravity:mg selfHeight:newSelfRect.size.height sbv:sbv rect:&rect];
        
        sbv.absPos.frame = rect;
        
        pos += rect.size.width;
        
        if ([self isRelativeMargin:rm])
            pos += [sbv.rightPos validMargin:floatingWidth * rm + sbv.rightPos.offsetVal];
        else
            pos += [sbv.rightPos validMargin:rm + sbv.rightPos.offsetVal];
        
        
        if (sbv != sbs.lastObject)
            pos += self.subviewMargin;
    }
    
    return newSelfRect;
}


-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
{
    CGRect selfRect = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass];
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if ((sbv.isHidden && self.hideSubviewReLayout) || sbv.useFrame || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
    }
    
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        
        //如果是垂直的布局，但是子视图设置了左右的边距或者设置了宽度则wrapContentWidth应该设置为NO
        for (UIView *sbv in sbs)
        {
            
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
                if (pHasSubLayout != nil)
                    *pHasSubLayout = YES;
                
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (sbvl.wrapContentWidth)
                {
                    //只要同时设置了左右边距或者设置了宽度则应该把wrapContentWidth置为NO
                    if ((sbvl.leftPos.posVal != nil && sbvl.rightPos.posVal != nil) || sbvl.widthDime.dimeVal != nil)
                        [sbvl setWrapContentWidthNoLayout:NO];
                }
                
                if (sbvl.wrapContentHeight)
                {
                    if (sbvl.heightDime.dimeVal != nil)
                        [sbvl setWrapContentHeightNoLayout:NO];
                }
                
                if (isEstimate)
                {
                    [sbvl estimateLayoutRect:sbvl.absPos.frame.size inSizeClass:sizeClass];
                    sbvl.absPos.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                }
            }
            
        }
        
        
        if ((self.gravity & MyMarginGravity_Horz_Mask) != MyMarginGravity_None)
            selfRect = [self layoutSubviewsForVertGravity:selfRect sbs:sbs];
        else
            selfRect = [self layoutSubviewsForVert:selfRect sbs:sbs];
        
        //绘制智能线。
        if (!isEstimate && self.IntelligentBorderLine != nil)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderLine)
                    {
                        sbvl.topBorderLine = nil;
                        sbvl.bottomBorderLine = nil;
                        
                        //取前一个视图和后一个视图。
                        UIView *prevSiblingView = nil;
                        UIView *nextSiblingView = nil;
                        
                        if (i != 0)
                        {
                            prevSiblingView = sbs[i - 1];
                        }
                        
                        if (i + 1 != sbs.count)
                        {
                            nextSiblingView = sbs[i + 1];
                        }
                        
                        if (prevSiblingView != nil)
                        {
                            sbvl.topBorderLine = self.IntelligentBorderLine;
                        }
                        
                        if (nextSiblingView != nil && ![nextSiblingView isKindOfClass:[MyBaseLayout class]])
                        {
                            sbvl.bottomBorderLine = self.IntelligentBorderLine;
                        }
                    }
                }
            
            }
        }
        
    }
    else
    {
        //如果是水平的布局，但是子视图设置了上下的边距或者设置了高度则wrapContentWidth应该设置为NO
        for (UIView *sbv in sbs)
        {
            
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
                if (pHasSubLayout != nil)
                    *pHasSubLayout = YES;
                
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (sbvl.wrapContentHeight)
                {
                    //只要同时设置了左右边距或者设置了宽度则应该把wrapContentWidth置为NO
                    if ((sbvl.topPos.posVal != nil && sbvl.bottomPos.posVal != nil) || sbvl.heightDime.dimeVal != nil)
                        [sbvl setWrapContentHeightNoLayout:NO];
                }
                
                if (sbvl.wrapContentWidth)
                {
                    if (sbvl.widthDime.dimeVal != nil)
                        [sbvl setWrapContentWidthNoLayout:NO];
                }
                
                if (isEstimate)
                {
                    [sbvl estimateLayoutRect:sbvl.absPos.frame.size inSizeClass:sizeClass];
                    sbvl.absPos.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    
                }
            }
            
        }
        
        
        if ((self.gravity & MyMarginGravity_Vert_Mask) != MyMarginGravity_None)
            selfRect = [self layoutSubviewsForHorzGravity:selfRect sbs:sbs];
        else
            selfRect = [self layoutSubviewsForHorz:selfRect sbs:sbs];
        
        //绘制智能线。
        if (!isEstimate && self.IntelligentBorderLine != nil)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderLine)
                    {
                        sbvl.leftBorderLine = nil;
                        sbvl.rightBorderLine = nil;
                        
                        //取前一个视图和后一个视图。
                        UIView *prevSiblingView = nil;
                        UIView *nextSiblingView = nil;
                        
                        if (i != 0)
                        {
                            prevSiblingView = sbs[i - 1];
                        }
                        
                        if (i + 1 != sbs.count)
                        {
                            nextSiblingView = sbs[i + 1];
                        }
                        
                        if (prevSiblingView != nil)
                        {
                            sbvl.leftBorderLine = self.IntelligentBorderLine;
                        }
                        
                        if (nextSiblingView != nil && ![nextSiblingView isKindOfClass:[MyBaseLayout class]])
                        {
                            sbvl.rightBorderLine = self.IntelligentBorderLine;
                        }
                    }
                }
                
            }
        }

        
    }
    
    selfRect.size.height = [self.heightDime validMeasure:selfRect.size.height];
    selfRect.size.width = [self.widthDime validMeasure:selfRect.size.width];
    
    
    return selfRect;
    
}


-(CGFloat)calcSelfMeasure:(CGFloat)selfMeasure subviewMeasure:(CGFloat)subviewMeasure headPos:(MyLayoutPos*)headPos centerPos:(MyLayoutPos*)centerPos tailPos:(MyLayoutPos*)tailPos
{
    CGFloat temp = subviewMeasure;
    CGFloat tempWeight = 0;
    
    CGFloat hm = headPos.posNumVal.doubleValue;
    CGFloat cm = centerPos.posNumVal.doubleValue;
    CGFloat tm = tailPos.posNumVal.doubleValue;
    
    //这里是求父视图的最大尺寸,因此如果使用了相对边距的话，最大最小要参与计算。
    
    if (![self isRelativeMargin:hm])
        temp += hm;
    else
        tempWeight += hm;
    
    temp += headPos.offsetVal;
    
    if (![self isRelativeMargin:cm])
        temp += cm;
    else
        tempWeight += cm;
    
    temp += centerPos.offsetVal;
    
    if (![self isRelativeMargin:tm])
        temp += tm;
    else
        tempWeight += tm;
    
    temp += tailPos.offsetVal;
    
    
    if (1  <= tempWeight)
        temp = 0;
    else
        temp /=(1 - tempWeight);  //在有相对
    
    //得到最真实的
    CGFloat headMargin;
    CGFloat centerMargin;
    CGFloat tailMargin;
    
    if (![self isRelativeMargin:hm])
        headMargin = hm;
    else
        headMargin = temp * hm;
    
    headMargin = [headPos validMargin:headMargin + headPos.offsetVal];
    
    if (![self isRelativeMargin:cm])
        centerMargin = cm;
    else
        centerMargin = temp *cm;
    
    centerMargin = [centerPos validMargin:centerMargin + centerPos.offsetVal];
    
    if (![self isRelativeMargin:tm])
        tailMargin = tm;
    else
        tailMargin = temp * tm;
    
    tailMargin = [tailPos validMargin:tailMargin + tailPos.offsetVal];
    
    temp = subviewMeasure + headMargin + centerMargin + tailMargin;
    if (temp > selfMeasure)
    {
        selfMeasure = temp;
    }
    
    return selfMeasure;
    
}

-(void)averageSubviewsForVert:(BOOL)centered withMargin:(CGFloat)margin
{
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if ((sbv.isHidden && self.hideSubviewReLayout) || sbv.useFrame || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
        
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
        UIView *sbv = [sbs objectAtIndex:i];
        
        sbv.bottomPos.equalTo(@0);
        sbv.topPos.equalTo(@(scale2));
        sbv.weight = scale;
        
        if (i == 0 && !centered)
            sbv.topPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            sbv.bottomPos.equalTo(@(scale2));
    }
    
}

-(void)averageSubviewsForHorz:(BOOL)centered withMargin:(CGFloat)margin
{
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if ((sbv.isHidden && self.hideSubviewReLayout) || sbv.useFrame || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
        
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
        UIView *sbv = [sbs objectAtIndex:i];
        
        sbv.leftPos.equalTo(@(scale2));
        sbv.weight = scale;
        
        if (i == 0 && !centered)
            sbv.leftPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            sbv.rightPos.equalTo(@(scale2));
    }
    
}


-(void)averageMarginForVert:(BOOL)centered
{
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if ((sbv.isHidden && self.hideSubviewReLayout) || sbv.useFrame || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
        
    }
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *sbv = [sbs objectAtIndex:i];
        
        sbv.topPos.equalTo(@(scale));
        
        if (i == 0 && !centered)
            sbv.topPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            sbv.bottomPos.equalTo(@(scale));
    }
    
    
}

-(void)averageMarginForHorz:(BOOL)centered
{
    
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for (UIView *sbv in self.subviews)
    {
        if ((sbv.isHidden && self.hideSubviewReLayout) || sbv.useFrame || sbv.absPos.sizeClass.isHidden)
            continue;
        
        [sbs addObject:sbv];
        
    }
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *sbv = [sbs objectAtIndex:i];
        
        sbv.leftPos.equalTo(@(scale));
        
        if (i == 0 && !centered)
            sbv.leftPos.equalTo(@0);
        
        if (i == sbs.count - 1 && centered)
            sbv.rightPos.equalTo(@(scale));
    }
}

-(id)createSizeClassInstance
{
    return [MyLayoutSizeClassLinearLayout new];
}




@end

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


@implementation MyLinearLayout

-(instancetype)initWithFrame:(CGRect)frame orientation:(MyLayoutViewOrientation)orientation
{
    self = [super initWithFrame:frame];
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


-(instancetype)initWithOrientation:(MyLayoutViewOrientation)orientation
{
    return [self initWithFrame:CGRectZero orientation:orientation];
}

+(instancetype)linearLayoutWithOrientation:(MyLayoutViewOrientation)orientation
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



-(void)setGravity:(MyGravity)gravity
{
    
    MyLinearLayout *lsc = self.myCurrentSizeClass;
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


-(void)setShrinkType:(MySubviewsShrinkType)shrinkType
{
    MyLinearLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.shrinkType != shrinkType)
    {
        lsc.shrinkType = shrinkType;
        [self setNeedsLayout];
    }
}

-(MySubviewsShrinkType)shrinkType
{
    return self.myCurrentSizeClass.shrinkType;
}


-(void)equalizeSubviews:(BOOL)centered
{
    [self equalizeSubviews:centered withSpace:CGFLOAT_MAX];
}

-(void)equalizeSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    [self equalizeSubviews:centered withSpace:CGFLOAT_MAX inSizeClass:sizeClass];
}

-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space
{
    [self equalizeSubviews:centered withSpace:space inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
    [self setNeedsLayout];
}

-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space inSizeClass:(MySizeClass)sizeClass
{
    self.myFrame.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        [self myEqualizeSubviewsForVert:centered withSpace:space];
    }
    else
    {
        [self myEqualizeSubviewsForHorz:centered withSpace:space];
    }
    
    self.myFrame.sizeClass = self.myDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = sbv.myDefaultSizeClass;

}

-(void)equalizeSubviewsSpace:(BOOL)centered
{
    [self equalizeSubviewsSpace:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
    [self setNeedsLayout];

}

-(void)equalizeSubviewsSpace:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    self.myFrame.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        [self myEqualizeSubviewsSpaceForVert:centered];
    }
    else
    {
        [self myEqualizeSubviewsSpaceForHorz:centered];
    }
    
    self.myFrame.sizeClass = self.myDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = sbv.myDefaultSizeClass;

}


#pragma mark -- Deprecated Method

-(void)averageSubviews:(BOOL)centered
{
    [self equalizeSubviews:centered];
}

-(void)averageSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    [self equalizeSubviews:centered inSizeClass:sizeClass];
}


-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin
{
    [self equalizeSubviews:centered withSpace:margin];
}

-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin inSizeClass:(MySizeClass)sizeClass
{
    [self equalizeSubviews:centered withSpace:margin inSizeClass:sizeClass];
}



-(void)averageMargin:(BOOL)centered
{
    [self equalizeSubviewsSpace:centered];
}

-(void)averageMargin:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    [self equalizeSubviewsSpace:centered inSizeClass:sizeClass];
}


#pragma mark -- Override Method

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    //减少约束冲突的提示。。
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        if (self.heightSizeInner.dimeVal != nil && self.wrapContentHeight)
        {
            [self mySetWrapContentHeightNoLayout:NO];
        }
            
    }
    else
    {
        if (self.widthSizeInner.dimeVal != nil && self.wrapContentWidth)
        {
            [self mySetWrapContentWidthNoLayout:NO];
        }
        
    }
    
    [super willMoveToSuperview:newSuperview];
}


-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray *)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        CGFloat subviewSpace = self.subviewVSpace;
        
        //如果是垂直的布局，但是子视图设置了左右的边距或者设置了宽度则wrapContentWidth应该设置为NO
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
                    //只要同时设置了左右边距或者设置了宽度或者设置了子视图宽度填充则应该把wrapContentWidth置为NO
                    if ((sbvl.leftPosInner.posVal != nil && sbvl.rightPosInner.posVal != nil) ||
                        sbvl.widthSizeInner.dimeVal != nil ||
                        (self.gravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill)
                    {
                        [sbvl mySetWrapContentWidthNoLayout:NO];
                    }
                }
                
                if (sbvl.wrapContentHeight)
                {
                    if (sbvl.heightSizeInner.dimeVal != nil || sbvl.weight != 0)
                    {
                        [sbvl mySetWrapContentHeightNoLayout:NO];
                    }
                }
                
                if (pHasSubLayout != nil && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                    *pHasSubLayout = YES;
                
                
                if (isEstimate && (sbvl.wrapContentHeight || sbvl.wrapContentWidth ))
                {
                    [sbvl estimateLayoutRect:sbvl.myFrame.frame.size inSizeClass:sizeClass];
                    sbvl.myFrame.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                }
            }
            
        }
        
        if ((self.gravity & MyGravity_Horz_Mask) != MyGravity_None)
        {
            selfSize = [self myLayoutSubviewsForVertGravity:selfSize sbs:sbs];
        }
        else
        {
            selfSize = [self myLayoutSubviewsForVert:selfSize sbs:sbs];
        }
        
        //绘制智能线。
        if (!isEstimate && self.intelligentBorderline != nil)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.topBorderline = nil;
                        sbvl.bottomBorderline = nil;
                        
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
                            BOOL ok = YES;
                            if ([prevSiblingView isKindOfClass:[MyBaseLayout class]] && subviewSpace == 0)
                            {
                                MyBaseLayout *prevSiblingLayout = (MyBaseLayout*)prevSiblingView;
                                if (prevSiblingLayout.notUseIntelligentBorderline)
                                    ok = NO;
                            }
                            
                            if (ok)
                                sbvl.topBorderline = self.intelligentBorderline;
                        }
                        
                        if (nextSiblingView != nil && (![nextSiblingView isKindOfClass:[MyBaseLayout class]] || subviewSpace != 0))
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                    }
                }
                
            }
        }
        
    }
    else
    {
        CGFloat subviewSpace = self.subviewHSpace;

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
                if (sbvl.wrapContentHeight)
                {
                    //只要同时设置了上下边距或者设置了高度或者设置了比重或者父视图的填充属性则应该把wrapContentHeight置为NO
                    if ((sbvl.topPosInner.posVal != nil && sbvl.bottomPosInner.posVal != nil) ||
                        sbvl.heightSizeInner.dimeVal != nil ||
                        (self.gravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill)
                    {
                        [sbvl mySetWrapContentHeightNoLayout:NO];
                    }
                }
                
                if (sbvl.wrapContentWidth)
                {
                    if (sbvl.widthSizeInner.dimeVal != nil || sbvl.weight != 0)
                    {
                        [sbvl mySetWrapContentWidthNoLayout:NO];
                    }
                }
                
                if (pHasSubLayout != nil && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                    *pHasSubLayout = YES;
                
                if (isEstimate && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                {
                    [sbvl estimateLayoutRect:sbvl.myFrame.frame.size inSizeClass:sizeClass];
                    sbvl.myFrame.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    
                }
            }
            
        }
        
        
        if ((self.gravity & MyGravity_Vert_Mask) != MyGravity_None)
            selfSize = [self myLayoutSubviewsForHorzGravity:selfSize sbs:sbs];
        else
            selfSize = [self myLayoutSubviewsForHorz:selfSize sbs:sbs];
        
        //绘制智能线。
        if (!isEstimate && self.intelligentBorderline != nil)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.leftBorderline = nil;
                        sbvl.rightBorderline = nil;
                        
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
                            BOOL ok = YES;
                            if ([prevSiblingView isKindOfClass:[MyBaseLayout class]] && subviewSpace == 0)
                            {
                                MyBaseLayout *prevSiblingLayout = (MyBaseLayout*)prevSiblingView;
                                if (prevSiblingLayout.notUseIntelligentBorderline)
                                    ok = NO;
                            }
                            
                            if (ok)
                                sbvl.leftBorderline = self.intelligentBorderline;
                        }
                        
                        if (nextSiblingView != nil && (![nextSiblingView isKindOfClass:[MyBaseLayout class]] || subviewSpace != 0))
                        {
                            sbvl.rightBorderline = self.intelligentBorderline;
                        }
                    }
                }
                
            }
        }
        
        
    }
    
    selfSize.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs];
    
}

-(id)createSizeClassInstance
{
    return [MyLinearLayoutViewSizeClass new];
}


#pragma mark -- Private Method


- (CGSize)myAdjustSelfWidth:(NSArray *)sbs selfSize:(CGSize)selfSize
{
    
    CGFloat maxSubviewWidth = 0;
    
    //计算出最宽的子视图所占用的宽度
    if (self.wrapContentWidth)
    {
        for (UIView *sbv in sbs)
        {
            if (!sbv.widthSizeInner.isMatchParent && (sbv.leftPosInner.posVal == nil || sbv.rightPosInner.posVal == nil))
            {
                
                CGFloat vWidth =  sbv.myFrame.width;
                if (sbv.widthSizeInner.dimeNumVal != nil)
                    vWidth = sbv.widthSizeInner.measure;
                
                vWidth = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:vWidth sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                
                //左边 + 中间偏移+ 宽度 + 右边
                maxSubviewWidth = [self myCalcSelfMeasure:maxSubviewWidth
                                         subviewMeasure:vWidth
                                                headPos:sbv.leftPosInner
                                              centerPos:sbv.centerXPosInner
                                                tailPos:sbv.rightPosInner];
                
                
            }
        }
        
        selfSize.width = maxSubviewWidth + self.leftPadding + self.rightPadding;
    }
    
    return selfSize;
}

-(CGSize)myLayoutSubviewsForVert:(CGSize)selfSize sbs:(NSArray*)sbs
{
    
    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat floatingHeight = 0; //浮动的高度。
    CGFloat totalWeight = 0;    //剩余部分的总比重
    CGFloat addSpace = 0;      //用于压缩时的间距压缩增量。
    CGFloat subviewSpace = self.subviewVSpace;
    UIEdgeInsets padding = self.padding;
    MyGravity gravity = self.gravity;

    selfSize = [self myAdjustSelfWidth:sbs selfSize:selfSize];   //调整自身的宽度
    
    NSMutableArray *fixedSizeSbs = [NSMutableArray new];
    CGFloat fixedSizeHeight = 0;
    NSInteger fixedSpaceCount = 0;  //固定间距的子视图数量。
    CGFloat  fixedSpaceHeight = 0;  //固定间距的子视图的宽度。
     for (UIView *sbv in sbs)
    {
        
        CGRect rect = sbv.myFrame.frame;
        
        BOOL isFlexedHeight = sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && sbv.weight == 0;
        
        
        if (sbv.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbv.widthSizeInner.measure;
        
        if (sbv.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbv.heightSizeInner.measure;
        
        if (sbv.heightSizeInner.isMatchParent && !self.wrapContentHeight)
             rect.size.height = [sbv.heightSizeInner measureWith:(selfSize.height - padding.top - padding.bottom) ];
        
        //调整子视图的宽度，如果子视图为matchParent的话
        if (sbv.widthSizeInner.isMatchParent)
            rect.size.width = [sbv.widthSizeInner measureWith:(selfSize.width - padding.left - padding.right) ];
        
        if (sbv.leftPosInner.posVal != nil && sbv.rightPosInner.posVal != nil)
            rect.size.width = selfSize.width - padding.left - padding.right - sbv.leftPosInner.margin - sbv.rightPosInner.margin;
        
        MyGravity mg = MyGravity_Horz_Left;
        if ((gravity & MyGravity_Vert_Mask)!= MyGravity_None)
            mg = gravity & MyGravity_Vert_Mask;
        else
        {
            if (sbv.centerXPosInner.posVal != nil)
                mg = MyGravity_Horz_Center;
            else if (sbv.leftPosInner.posVal != nil && sbv.rightPosInner.posVal != nil)
                mg = MyGravity_Horz_Fill;
            else if (sbv.leftPosInner.posVal != nil)
                mg = MyGravity_Horz_Left;
            else if (sbv.rightPosInner.posVal != nil)
                mg = MyGravity_Horz_Right;
        }
        
        rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        [self myHorzGravity:mg selfSize:selfSize sbv:sbv rect:&rect];
        
        
        if (sbv.heightSizeInner.dimeRelaVal != nil && sbv.heightSizeInner.dimeRelaVal == sbv.widthSizeInner)
        {
            rect.size.height = [sbv.heightSizeInner measureWith:rect.size.width ];
        }
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
            rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
        
        rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        
        //计算固定高度和浮动高度。
        if (sbv.topPosInner.isRelativeMargin)
        {
            totalWeight += sbv.topPosInner.posNumVal.doubleValue;
            
            fixedHeight += sbv.topPosInner.offsetVal;
        }
        else
        {
            fixedHeight += sbv.topPosInner.margin;
            
            if (sbv.topPosInner.margin != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += sbv.topPosInner.margin;
            }

        }
        
        
        
        if (sbv.bottomPosInner.isRelativeMargin)
        {
            totalWeight += sbv.bottomPosInner.posNumVal.doubleValue;
            fixedHeight += sbv.bottomPosInner.offsetVal;
        }
        else
        {
            fixedHeight += sbv.bottomPosInner.margin;
            
            if (sbv.bottomPosInner.margin != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += sbv.bottomPosInner.margin;
            }

        }
        
        
        if (sbv.weight > 0.0)
        {
            totalWeight += sbv.weight;
        }
        else
        {
            fixedHeight += rect.size.height;
            
            //如果最小高度不为自身并且高度不是包裹的则可以进行缩小。
            if (sbv.heightSizeInner.lBoundValInner.dimeSelfVal == nil && !sbv.wrapContentHeight)
            {
                fixedSizeHeight += rect.size.height;
                [fixedSizeSbs addObject:sbv];
            }
        }
        
        if (sbv != sbs.lastObject)
        {
            fixedHeight += subviewSpace;
            
            if (subviewSpace != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += subviewSpace;
            }
        }
        
        sbv.myFrame.frame = rect;
    }
    
    
    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (self.wrapContentHeight && totalWeight != 0)
    {
        CGFloat tempSelfHeight = padding.top + padding.bottom;
        if (sbs.count > 1)
            tempSelfHeight += (sbs.count - 1) * subviewSpace;
        
        selfSize.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:tempSelfHeight sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        
    }

    
    BOOL isWeightShrinkSpace = NO;   //是否按比重缩小间距。。。
    CGFloat weightShrinkSpaceTotalHeight = 0;
    //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    floatingHeight = selfSize.height - fixedHeight - padding.top - padding.bottom;
    if (/*floatingHeight <= 0 || floatingHeight == -0.0*/ _myCGFloatLessOrEqual(floatingHeight, 0))
    {
        //取出shrinkType中的方式和压缩的类型：
        MySubviewsShrinkType sstMode = self.shrinkType & 0x0F; //压缩的策略
        MySubviewsShrinkType sstContent = self.shrinkType & 0xF0; //压缩内容

        if (sstMode != MySubviewsShrink_None)
        {
            if (sstContent == MySubviewsShrink_Size)
            {
                if (fixedSizeSbs.count > 0 && totalWeight != 0 && floatingHeight < 0 && selfSize.height > 0)
                {
                    //均分。
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        CGFloat averageHeight = floatingHeight / fixedSizeSbs.count;
                        
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.myFrame.height += averageHeight;
                        }
                    }
                    else if (/*fixedSizeHeight != 0*/ _myCGFloatNotEqual(fixedSizeHeight, 0))
                    {//按比例分配。
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.myFrame.height += floatingHeight * (fsbv.myFrame.height / fixedSizeHeight);
                        }
                        
                    }
                }
            }
            else if (sstContent == MySubviewsShrink_Space)
            {
                if (fixedSpaceCount > 0 && floatingHeight < 0 && selfSize.height > 0 && fixedSpaceHeight > 0)
                {
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        addSpace = floatingHeight / fixedSpaceCount;
                    }
                    else if (sstMode == MySubviewsShrink_Weight)
                    {
                        isWeightShrinkSpace = YES;
                        weightShrinkSpaceTotalHeight = floatingHeight;
                    }
                }
                
            }
            else
            {
                ;
            }

        }

        
        floatingHeight = 0;
    }
    
    CGFloat pos = padding.top;
    for (UIView *sbv in sbs) {
        
        
        CGFloat topMargin = sbv.topPosInner.posNumVal.doubleValue;
        CGFloat bottomMargin = sbv.bottomPosInner.posNumVal.doubleValue;
        CGFloat weight = sbv.weight;
        CGRect rect =  sbv.myFrame.frame;
        
        //分别处理相对顶部边距和绝对顶部边距
        if ([self myIsRelativeMargin:topMargin])
        {
            topMargin = (topMargin / totalWeight) * floatingHeight;
            if (_myCGFloatLessOrEqual(topMargin, 0))
                topMargin = 0;
            
        }
        else
        {
            if (topMargin + sbv.topPosInner.offsetVal != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalHeight * (topMargin + sbv.topPosInner.offsetVal) / fixedSpaceHeight;
                }
            }
            
        }
        
        pos += [self myValidMargin:sbv.topPosInner sbv:sbv calcPos:topMargin + sbv.topPosInner.offsetVal selfLayoutSize:selfSize];
        
        //分别处理相对高度和绝对高度
        rect.origin.y = pos;
        if (weight > 0)
        {
            CGFloat h = (weight / totalWeight) * floatingHeight;
            if (_myCGFloatLessOrEqual(h, 0))
                h = 0;
            
            rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:h sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        pos += rect.size.height;
        
        //分别处理相对底部边距和绝对底部边距
        if ([self myIsRelativeMargin:bottomMargin])
        {
            bottomMargin = (bottomMargin / totalWeight) * floatingHeight;
            if ( _myCGFloatLessOrEqual(bottomMargin, 0))
                bottomMargin = 0;
            
        }
        else
        {
            if (bottomMargin + sbv.bottomPosInner.offsetVal != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalHeight * (bottomMargin + sbv.bottomPosInner.offsetVal) / fixedSpaceHeight;
                }
            }

        }
        
        pos += [self myValidMargin:sbv.bottomPosInner sbv:sbv calcPos:bottomMargin + sbv.bottomPosInner.offsetVal selfLayoutSize:selfSize];
        
        if (sbv != sbs.lastObject)
        {
            pos += subviewSpace;
            
            if (subviewSpace != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalHeight * subviewSpace / fixedSpaceHeight;
                }
            }

        }
        
        sbv.myFrame.frame = rect;
    }
    
    pos += padding.bottom;
    
    
    if (self.wrapContentHeight)
    {
        selfSize.height = pos;
    }
    
    return selfSize;
}

-(CGSize)myLayoutSubviewsForHorz:(CGSize)selfSize sbs:(NSArray*)sbs
{
    
    CGFloat fixedWidth = 0;   //计算固定部分的高度
    CGFloat floatingWidth = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat maxSubviewHeight = 0;
    CGFloat addSpace = 0;   //用于压缩时的间距压缩增量。
    CGFloat subviewSpace = self.subviewHSpace;
    UIEdgeInsets padding = self.padding;
    MyGravity gravity = self.gravity;
    
    
    //计算出固定的子视图宽度的总和以及宽度比例总和
    
    NSMutableArray *fixedSizeSbs = [NSMutableArray new];
    NSMutableArray *flexedSizeSbs = [NSMutableArray new];
    CGFloat fixedSizeWidth = 0;   //固定尺寸的宽度
    NSInteger fixedSpaceCount = 0;  //固定间距的子视图数量。
    CGFloat  fixedSpaceWidth = 0;  //固定间距的子视图的宽度。
    for (UIView *sbv in sbs)
    {
        
        if (sbv.leftPosInner.isRelativeMargin)
        {
            totalWeight += sbv.leftPosInner.posNumVal.doubleValue;
            fixedWidth += sbv.leftPosInner.offsetVal;
        }
        else
        {
            fixedWidth += sbv.leftPosInner.margin;
            if (sbv.leftPosInner.margin != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += sbv.leftPosInner.margin;
            }
        }
        
        if (sbv.rightPosInner.isRelativeMargin)
        {
            totalWeight += sbv.rightPosInner.posNumVal.doubleValue;
            fixedWidth += sbv.rightPosInner.offsetVal;
        }
        else
        {
            fixedWidth += sbv.rightPosInner.margin;
            if (sbv.rightPosInner.margin != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += sbv.rightPosInner.margin;
            }

        }
        
        if (sbv.weight > 0.0)
        {
            totalWeight += sbv.weight;
        }
        else
        {
            CGFloat vWidth = sbv.myFrame.width;
            if (sbv.widthSizeInner.dimeNumVal != nil)
                vWidth = sbv.widthSizeInner.measure;

            if (sbv.widthSizeInner.isMatchParent && !self.wrapContentWidth)
                  vWidth = [sbv.widthSizeInner measureWith:(selfSize.width - padding.left - padding.right) ];
            
            vWidth = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:vWidth sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            sbv.myFrame.width = vWidth;
            fixedWidth += vWidth;
            
            //如果最小宽度不为自身并且宽度不是包裹的则可以进行缩小。
            if (sbv.widthSizeInner.lBoundValInner.dimeSelfVal == nil && !sbv.wrapContentWidth)
            {
               fixedSizeWidth += vWidth;
               [fixedSizeSbs addObject:sbv];
            }
            
            if (sbv.widthSizeInner.dimeSelfVal != nil)
            {
                [flexedSizeSbs addObject:sbv];
            }
        }
        
        if (sbv != sbs.lastObject)
        {
            fixedWidth += subviewSpace;
            if (subviewSpace != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += subviewSpace;
            }
        }
    }
    
    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (self.wrapContentWidth && totalWeight != 0)
    {
        CGFloat tempSelfWidth = padding.left + padding.right;
        if (sbs.count > 1)
            tempSelfWidth += (sbs.count - 1) * subviewSpace;
        
        selfSize.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:tempSelfWidth sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];

    }
    
    //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
    BOOL isWeightShrinkSpace = NO;   //是否按比重缩小间距。。。
    CGFloat weightShrinkSpaceTotalWidth = 0;
    floatingWidth = selfSize.width - fixedWidth - self.leftPadding - self.rightPadding;
    if (/*floatingWidth <= 0 || floatingWidth == -0.0*/ _myCGFloatLessOrEqual(floatingWidth, 0))
    {
        //取出shrinkType中的方式和压缩的类型：
        MySubviewsShrinkType sstMode = self.shrinkType & 0x0F;    //压缩的模式
        MySubviewsShrinkType sstContent = self.shrinkType & 0xF0; //压缩内容
        //如果压缩方式为自动，但是浮动宽度子视图数量不为2则压缩类型无效。
        if (sstMode == MySubviewsShrink_Auto && flexedSizeSbs.count != 2)
            sstMode = MySubviewsShrink_None;
        
        if (sstMode != MySubviewsShrink_None)
        {
            if (sstContent == MySubviewsShrink_Size)
            {
                if (fixedSizeSbs.count > 0 && totalWeight != 0 && floatingWidth < 0 && selfSize.width > 0)
                {
                    //均分。
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        CGFloat averageWidth = floatingWidth / fixedSizeSbs.count;
                        
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.myFrame.width += averageWidth;
                            
                        }
                    }
                    else if (sstMode == MySubviewsShrink_Auto)
                    {
                        
                        UIView *leftView = flexedSizeSbs[0];
                        UIView *rightView = flexedSizeSbs[1];
                        
                        CGFloat leftWidth = leftView.myFrame.width;
                        CGFloat righWidth = rightView.myFrame.width;
                        
                        //如果2个都超过一半则总是一半显示。
                        //如果1个超过了一半则 如果两个没有超过总宽度则正常显示，如果超过了总宽度则超过一半的视图的宽度等于总宽度减去未超过一半的视图的宽度。
                        //如果没有一个超过一半。则正常显示
                        CGFloat layoutWidth = floatingWidth + leftWidth + righWidth;
                        CGFloat halfLayoutWidth = layoutWidth / 2;
                        
                        if (leftWidth > halfLayoutWidth && righWidth > halfLayoutWidth)
                        {
                            leftView.myFrame.width = halfLayoutWidth;
                            rightView.myFrame.width = halfLayoutWidth;
                        }
                        else if ((leftWidth > halfLayoutWidth || righWidth > halfLayoutWidth) && (leftWidth + righWidth > layoutWidth))
                        {
                            
                            if (leftWidth > halfLayoutWidth)
                            {
                                rightView.myFrame.width = righWidth;
                                leftView.myFrame.width = layoutWidth - righWidth;
                            }
                            else
                            {
                                leftView.myFrame.width = leftWidth;
                                rightView.myFrame.width = layoutWidth - leftWidth;
                            }
                            
                        }
                        else ;
                        
                        
                    }
                    else if (/*fixedSizeWidth != 0*/_myCGFloatNotEqual(fixedSizeWidth, 0))
                    {//按比例分配。
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.myFrame.width += floatingWidth * (fsbv.myFrame.width / fixedSizeWidth);
                        }
                        
                    }
                }
            }
            else if (sstContent == MySubviewsShrink_Space)
            {
                if (fixedSpaceCount > 0 && floatingWidth < 0 && selfSize.width > 0 && fixedSpaceWidth > 0)
                {
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        addSpace = floatingWidth / fixedSpaceCount;
                    }
                    else if (sstMode == MySubviewsShrink_Weight)
                    {
                        isWeightShrinkSpace = YES;
                        weightShrinkSpaceTotalWidth = floatingWidth;
                    }
                }
                
            }
            else
            {
                ;
            }
            
        }
        
        
        floatingWidth = 0;
    }
    
    //调整所有子视图的宽度
    CGFloat pos = padding.left;
    for (UIView *sbv in sbs) {
        
        CGFloat leftMargin = sbv.leftPosInner.posNumVal.doubleValue;
        CGFloat rightMargin = sbv.rightPosInner.posNumVal.doubleValue;
        CGFloat weight = sbv.weight;
        BOOL isFlexedHeight = sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && !sbv.heightSizeInner.isMatchParent;
        CGRect rect =  sbv.myFrame.frame;
        
        if (sbv.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbv.heightSizeInner.measure;
        
        
        if (sbv.heightSizeInner.isMatchParent)
            rect.size.height= [sbv.heightSizeInner measureWith:(selfSize.height - padding.top - padding.bottom) ];
        
        
        //计算出先对左边边距和绝对左边边距
        if ([self myIsRelativeMargin:leftMargin])
        {
            leftMargin = (leftMargin / totalWeight) * floatingWidth;
            if (/*leftMargin <= 0 || leftMargin == -0.0*/ _myCGFloatLessOrEqual(leftMargin, 0))
                leftMargin = 0;
            
        }
        else
        {
            if (leftMargin + sbv.leftPosInner.offsetVal != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalWidth * (leftMargin + sbv.leftPosInner.offsetVal) / fixedSpaceWidth;
                }
            }
            
        }
        
       pos += [self myValidMargin:sbv.leftPosInner sbv:sbv calcPos:leftMargin + sbv.leftPosInner.offsetVal selfLayoutSize:selfSize];
        
        //计算出相对宽度和绝对宽度
        rect.origin.x = pos;
        if (weight > 0)
        {
            CGFloat w = (weight / totalWeight) * floatingWidth;
            if (/*w <= 0 || w == -0.0*/ _myCGFloatLessOrEqual(w, 0))
                w = 0;
            
            rect.size.width = w;
            
        }
        rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        pos += rect.size.width;
        
        //计算相对的右边边距和绝对的右边边距
        if ([self myIsRelativeMargin:rightMargin])
        {
            rightMargin = (rightMargin / totalWeight) * floatingWidth;
            if (/*rightMargin <= 0 || rightMargin == -0.0*/ _myCGFloatLessOrEqual(rightMargin, 0))
                rightMargin = 0;
        }
        else
        {
            if (rightMargin + sbv.rightPosInner.offsetVal != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalWidth * (rightMargin + sbv.rightPosInner.offsetVal) / fixedSpaceWidth;
                }
            }
        }
        
        pos += [self myValidMargin:sbv.rightPosInner sbv:sbv calcPos:rightMargin + sbv.rightPosInner.offsetVal selfLayoutSize:selfSize];
        
        
        if (sbv != sbs.lastObject)
        {
            pos += subviewSpace;
            
            if (subviewSpace != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalWidth * subviewSpace / fixedSpaceWidth;
                }
            }
        }
        
        
        if (sbv.heightSizeInner.dimeRelaVal != nil && sbv.heightSizeInner.dimeRelaVal == sbv.widthSizeInner)
                rect.size.height = [sbv.heightSizeInner measureWith:rect.size.width ];
        
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
        }
        
        rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        //计算最高的高度。
        if (self.wrapContentHeight && !sbv.heightSizeInner.isMatchParent && (sbv.topPosInner.posVal == nil || sbv.bottomPosInner.posVal == nil))
        {
            maxSubviewHeight = [self myCalcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headPos:sbv.topPosInner centerPos:sbv.centerYPosInner tailPos:sbv.bottomPosInner];
            
        }
        
        sbv.myFrame.frame = rect;
    }
    
    if (self.wrapContentHeight)
    {
        selfSize.height = maxSubviewHeight + padding.top + padding.bottom;
    }
    
    
    //调整所有子视图的高度
    for (UIView *sbv in sbs)
    {
        
        CGRect rect = sbv.myFrame.frame;
        
        //计算高度
        if (sbv.heightSizeInner.isMatchParent)
        {
            rect.size.height = [sbv.heightSizeInner measureWith:(selfSize.height - padding.top - padding.bottom) ];
        }
        
        if (sbv.topPosInner.posVal != nil && sbv.bottomPosInner.posVal != nil)
            rect.size.height = selfSize.height - padding.top - padding.bottom - sbv.topPosInner.margin - sbv.bottomPosInner.margin;

        //优先以容器中的指定为标准
        MyGravity mg = MyGravity_Vert_Top;
        if ((gravity & MyGravity_Horz_Mask)!= MyGravity_None)
            mg =gravity & MyGravity_Horz_Mask;
        else
        {
            if (sbv.centerYPosInner.posVal != nil)
                mg = MyGravity_Vert_Center;
            else if (sbv.topPosInner.posVal != nil && sbv.bottomPosInner.posVal != nil)
                mg = MyGravity_Vert_Fill;
            else if (sbv.topPosInner.posVal != nil)
                mg = MyGravity_Vert_Top;
            else if (sbv.bottomPosInner.posVal != nil)
                mg = MyGravity_Vert_Bottom;
        }
        
        rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        [self myVertGravity:mg selfSize:selfSize sbv:sbv rect:&rect];
        
        sbv.myFrame.frame = rect;
    }
    
    pos += padding.right;
    
    if (self.wrapContentWidth)
    {
        selfSize.width = pos;
    }
    
    return selfSize;
}


-(CGSize)myLayoutSubviewsForVertGravity:(CGSize)selfSize sbs:(NSArray*)sbs
{
    MyGravity mgvert = self.gravity & MyGravity_Horz_Mask;
    MyGravity mghorz = self.gravity & MyGravity_Vert_Mask;
    UIEdgeInsets padding = self.padding;
    CGFloat subviewSpace = self.subviewVSpace;
    CGFloat totalHeight = 0;
    if (sbs.count > 1)
        totalHeight += (sbs.count - 1) * subviewSpace;
    
    selfSize = [self myAdjustSelfWidth:sbs selfSize:selfSize];
    
    CGFloat floatingHeight = selfSize.height - padding.top - padding.bottom - totalHeight;
    if (/*floatingHeight <=0*/ _myCGFloatLessOrEqual(floatingHeight, 0))
        floatingHeight = 0;
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    NSMutableSet *noWrapsbsSet = [NSMutableSet new];
    for (UIView *sbv in sbs)
    {
        BOOL canAddToNoWrapSbs = YES;
        CGRect rect =  sbv.myFrame.frame;
        BOOL isFlexedHeight = sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && sbv.weight == 0;
        
        if (sbv.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbv.widthSizeInner.measure;
        
        if (sbv.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbv.heightSizeInner.measure;
        
        if (sbv.heightSizeInner.isMatchParent && !self.wrapContentHeight)
        {
            rect.size.height = [sbv.heightSizeInner measureWith:selfSize.height - padding.top - padding.bottom];
            canAddToNoWrapSbs = NO;
        }
        
        //调整子视图的宽度，如果子视图为matchParent的话
        if (sbv.widthSizeInner.isMatchParent)
        {
            rect.size.width = [sbv.widthSizeInner measureWith:selfSize.width - padding.left - padding.right];
        }
        
        if (sbv.leftPosInner.posVal != nil && sbv.rightPosInner.posVal != nil)
            rect.size.width = selfSize.width - padding.left - padding.right - sbv.leftPosInner.margin - sbv.rightPosInner.margin;
        
        //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
        MyGravity sbvmghorz = MyGravity_Horz_Left;
        if ( mghorz != MyGravity_None)
            sbvmghorz = mghorz;
        else
        {
            if (sbv.centerXPosInner.posVal != nil)
                sbvmghorz = MyGravity_Horz_Center;
            else if (sbv.leftPosInner.posVal != nil && sbv.rightPosInner.posVal != nil)
                sbvmghorz = MyGravity_Horz_Fill;
            else if (sbv.leftPosInner.posVal != nil)
                sbvmghorz = MyGravity_Horz_Left;
            else if (sbv.rightPosInner.posVal != nil)
                sbvmghorz = MyGravity_Horz_Right;
        }
        
        rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        [self myHorzGravity:sbvmghorz selfSize:selfSize sbv:sbv rect:&rect];
        
        
        if (sbv.heightSizeInner.dimeRelaVal != nil && sbv.heightSizeInner.dimeRelaVal == sbv.widthSizeInner)
        {
            rect.size.height = [sbv.heightSizeInner measureWith:rect.size.width];
        }
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
            canAddToNoWrapSbs = NO;
       }
        
        rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
    
        //如果子视图的最小高度就是自身则也不进行扩展。
        if (sbv.heightSizeInner.lBoundValInner.dimeSelfVal != nil)
        {
            canAddToNoWrapSbs = NO;
        }

        
        CGFloat realTop = 0;
        if (sbv.topPosInner != nil)
            realTop = [sbv.topPosInner realMarginInSize:floatingHeight];
        totalHeight += [self myValidMargin:sbv.topPosInner sbv:sbv calcPos:realTop selfLayoutSize:selfSize];
        
        totalHeight += rect.size.height;
        
        CGFloat realBottom = 0;
        if (sbv.bottomPosInner != nil)
            realBottom = [sbv.bottomPosInner realMarginInSize:floatingHeight];
        totalHeight += [self myValidMargin:sbv.bottomPosInner sbv:sbv calcPos:realBottom selfLayoutSize:selfSize];
        
        sbv.myFrame.frame = rect;
        
        //如果子布局视图是wrap属性则不进行扩展。
        if (mgvert == MyGravity_Vert_Fill && [sbv isKindOfClass:[MyBaseLayout class]])
        {
            if (((MyBaseLayout*)sbv).wrapContentHeight)
            {
                canAddToNoWrapSbs = NO;
            }
        }
        
        if (canAddToNoWrapSbs)
            [noWrapsbsSet addObject:sbv];
        
    }
    
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;  //位置偏移
    CGFloat between = 0; //间距扩充
    CGFloat fill = 0;    //尺寸扩充
    if (mgvert == MyGravity_Vert_Top)
    {
        pos = padding.top;
    }
    else if (mgvert == MyGravity_Vert_Center)
    {
        pos = (selfSize.height - totalHeight - padding.top - padding.bottom)/2.0;
        pos += padding.top;
    }
    else if (mgvert == MyGravity_Vert_Window_Center)
    {
        if (self.window != nil)
        {
            pos = (CGRectGetHeight(self.window.bounds) - totalHeight)/2.0;
            
            CGPoint pt = CGPointMake(0, pos);
            pos = [self.window convertPoint:pt toView:self].y;
            
            
        }
    }
    else if (mgvert == MyGravity_Vert_Bottom)
    {
        pos = selfSize.height - totalHeight - padding.bottom;
    }
    else if (mgvert == MyGravity_Vert_Between)
    {
        pos = padding.top;
        
        if (sbs.count > 1)
            between = (selfSize.height - totalHeight - padding.top - padding.bottom) / (sbs.count - 1);
    }
    else if (mgvert == MyGravity_Vert_Fill)
    {
        pos = padding.top;
        if (noWrapsbsSet.count > 0)
             fill = (selfSize.height - totalHeight - padding.top - padding.bottom) / noWrapsbsSet.count;
    }
    else
    {
        pos = padding.top;
    }
    
    
    
    for (UIView *sbv in sbs)
    {
        CGFloat realTop = 0;
        if (sbv.topPosInner != nil)
            realTop = [sbv.topPosInner realMarginInSize:floatingHeight];
        
        pos += [self myValidMargin:sbv.topPosInner sbv:sbv calcPos:realTop selfLayoutSize:selfSize];
        
        sbv.myFrame.topPos = pos;
        
        //加上扩充的宽度。
        if (fill != 0 && [noWrapsbsSet containsObject:sbv])
            sbv.myFrame.height += fill;
        
        pos +=  sbv.myFrame.height;
    
        CGFloat realBottom = 0;
        if (sbv.bottomPosInner != nil)
            realBottom = [sbv.bottomPosInner realMarginInSize:floatingHeight];
        pos += [self myValidMargin:sbv.bottomPosInner sbv:sbv calcPos:realBottom selfLayoutSize:selfSize];
        
        if (sbv != sbs.lastObject)
            pos += subviewSpace;
        
        pos += between;  //只有mgvert为between才加这个间距拉伸。
    }
    
    return selfSize;
    
}

-(CGSize)myLayoutSubviewsForHorzGravity:(CGSize)selfSize sbs:(NSArray*)sbs
{
    
    MyGravity mgvert = self.gravity & MyGravity_Horz_Mask;
    MyGravity mghorz = self.gravity & MyGravity_Vert_Mask;
    UIEdgeInsets padding = self.padding;
    CGFloat subviewSpace = self.subviewHSpace;
    CGFloat totalWidth = 0;
    if (sbs.count > 1)
        totalWidth += (sbs.count - 1) * subviewSpace;
    
    
    CGFloat floatingWidth = 0;
    
    CGFloat maxSubviewHeight = 0;
    
    floatingWidth = selfSize.width - padding.left - padding.right - totalWidth;
    if (/*floatingWidth <= 0*/ _myCGFloatLessOrEqual(floatingWidth, 0))
        floatingWidth = 0;
    
    //计算出固定的高度
    NSMutableSet *noWrapsbsSet = [NSMutableSet new];
    for (UIView *sbv in sbs)
    {
        BOOL canAddToNoWrapSbs = YES;

        CGRect rect = sbv.myFrame.frame;
        BOOL isFlexedHeight = sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && !sbv.heightSizeInner.isMatchParent;
        
        
        if (sbv.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbv.widthSizeInner.measure;
        
        if (sbv.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbv.heightSizeInner.measure;
        
        if (sbv.widthSizeInner.isMatchParent && !self.wrapContentWidth)
        {
            rect.size.width= [sbv.widthSizeInner measureWith:selfSize.width - padding.left - padding.right];
            canAddToNoWrapSbs = NO;
        }
        
        if (sbv.heightSizeInner.isMatchParent)
            rect.size.height= [sbv.heightSizeInner measureWith:selfSize.height - padding.top - padding.bottom];
        
        if (sbv.widthSizeInner.dimeRelaVal != nil && sbv.widthSizeInner.dimeRelaVal == sbv.heightSizeInner)
            rect.size.width = [sbv.widthSizeInner measureWith:rect.size.height];
        
        rect.size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果最小宽度不能被缩小则不加入。
        if (sbv.widthSizeInner.lBoundValInner.dimeSelfVal != nil)
        {
            canAddToNoWrapSbs = NO;
        }

        if (sbv.heightSizeInner.dimeRelaVal != nil && sbv.heightSizeInner.dimeRelaVal == sbv.widthSizeInner)
            rect.size.height = [sbv.heightSizeInner measureWith:rect.size.width];
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv inWidth:rect.size.width];
        }
        
        rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算以子视图为大小的情况
        if (self.wrapContentHeight && !sbv.heightSizeInner.isMatchParent && (sbv.topPosInner.posVal == nil || sbv.bottomPosInner.posVal == nil))
        {
            maxSubviewHeight = [self myCalcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headPos:sbv.topPosInner centerPos:sbv.centerYPosInner tailPos:sbv.bottomPosInner];
        }
        
        CGFloat realLeft = 0;
        if (sbv.leftPosInner != nil)
            realLeft = [sbv.leftPosInner realMarginInSize:floatingWidth];
        totalWidth += [self myValidMargin:sbv.leftPosInner sbv:sbv calcPos:realLeft selfLayoutSize:selfSize];
        
        totalWidth += rect.size.width;
    
        CGFloat realRight = 0;
        if (sbv.rightPosInner != nil)
            realRight = [sbv.rightPosInner realMarginInSize:floatingWidth];
        totalWidth += [self myValidMargin:sbv.rightPosInner sbv:sbv calcPos:realRight selfLayoutSize:selfSize];
        
        
        sbv.myFrame.frame = rect;
        
        //如果子视图是包裹属性则也不加入。
        if (mghorz == MyGravity_Horz_Fill && [sbv isKindOfClass:[MyBaseLayout class]])
        {
            if (((MyBaseLayout*)sbv).wrapContentWidth)
            {
                canAddToNoWrapSbs = NO;
            }
        }
        
        if (canAddToNoWrapSbs)
            [noWrapsbsSet addObject:sbv];

    }
    
    
    //调整自己的高度。
    if (self.wrapContentHeight)
    {
        selfSize.height = maxSubviewHeight + padding.top + padding.bottom;
    }
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    CGFloat between = 0;
    CGFloat fill = 0;

    if (mghorz == MyGravity_Horz_Left)
    {
        pos = padding.left;
    }
    else if (mghorz == MyGravity_Horz_Center)
    {
        pos = (selfSize.width - totalWidth - padding.left - padding.right)/2.0;
        pos += padding.left;
    }
    else if (mghorz == MyGravity_Horz_Window_Center)
    {
        if (self.window != nil)
        {
            pos = (CGRectGetWidth(self.window.bounds) - totalWidth)/2.0;
            
            CGPoint pt = CGPointMake(pos, 0);
            pos = [self.window convertPoint:pt toView:self].x;
        }
    }
    else if (mghorz == MyGravity_Horz_Right)
    {
        pos = selfSize.width - totalWidth - padding.right;
    }
    else if (mghorz == MyGravity_Horz_Between)
    {
        pos = padding.left;
        
        if (sbs.count > 1)
            between = (selfSize.width - totalWidth - padding.left - padding.right) / (sbs.count - 1);
    }
    else if (mghorz == MyGravity_Horz_Fill)
    {
        pos = padding.left;
        if (noWrapsbsSet.count > 0)
            fill = (selfSize.width - totalWidth - padding.left - padding.right) / noWrapsbsSet.count;
    }
    else
    {
        pos = padding.left;
    }

    
    
    
    for (UIView *sbv in sbs)
    {
        
        CGFloat realLeft = 0;
        if (sbv.leftPosInner != nil)
            realLeft = [sbv.leftPosInner realMarginInSize:floatingWidth];
        pos += [self myValidMargin:sbv.leftPosInner sbv:sbv calcPos:realLeft selfLayoutSize:selfSize];
        
        
        CGRect rect = sbv.myFrame.frame;
        rect.origin.x = pos;
        
        //计算高度
        if (sbv.heightSizeInner.isMatchParent)
        {
            rect.size.height = [sbv.heightSizeInner measureWith:(selfSize.height - padding.top - padding.bottom) ];
        }
        
        
        if (sbv.topPosInner.posVal != nil && sbv.bottomPosInner.posVal != nil)
            rect.size.height = selfSize.height - padding.top - padding.bottom - sbv.topPosInner.margin - sbv.bottomPosInner.margin;
        
        MyGravity sbvmgvert = MyGravity_Vert_Top;
        if (mgvert != MyGravity_None)
            sbvmgvert = mgvert;
        else
        {
            if (sbv.centerYPosInner.posVal != nil)
                sbvmgvert = MyGravity_Vert_Center;
            else if (sbv.topPosInner.posVal != nil && sbv.bottomPosInner.posVal != nil)
                sbvmgvert = MyGravity_Vert_Fill;
            else if (sbv.topPosInner.posVal != nil)
                sbvmgvert = MyGravity_Vert_Top;
            else if (sbv.bottomPosInner.posVal != nil)
                sbvmgvert = MyGravity_Vert_Bottom;
        }
        
         rect.size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        [self myVertGravity:sbvmgvert selfSize:selfSize sbv:sbv rect:&rect];
        
        if (fill != 0 &&  [noWrapsbsSet containsObject:sbv])
            rect.size.width += fill;

        sbv.myFrame.frame = rect;
        
        pos += rect.size.width;
        
        CGFloat realRight = 0;
        if (sbv.rightPosInner != nil)
            realRight = [sbv.rightPosInner realMarginInSize:floatingWidth];
        
        pos += [self myValidMargin:sbv.rightPosInner sbv:sbv calcPos:realRight selfLayoutSize:selfSize];
        
        
        if (sbv != sbs.lastObject)
            pos += subviewSpace;
        
        pos += between;  //只有mghorz为between才加这个间距拉伸。

    }
    
    return selfSize;
}



-(CGFloat)myCalcSelfMeasure:(CGFloat)selfMeasure subviewMeasure:(CGFloat)subviewMeasure headPos:(MyLayoutPos*)headPos centerPos:(MyLayoutPos*)centerPos tailPos:(MyLayoutPos*)tailPos
{
    CGFloat temp = subviewMeasure;
    CGFloat tempWeight = 0;
    
    CGFloat hm = headPos.posNumVal.doubleValue;
    CGFloat cm = centerPos.posNumVal.doubleValue;
    CGFloat tm = tailPos.posNumVal.doubleValue;
    
    //这里是求父视图的最大尺寸,因此如果使用了相对边距的话，最大最小要参与计算。
    
    if (![self myIsRelativeMargin:hm])
        temp += hm;
    else
        tempWeight += hm;
    
    temp += headPos.offsetVal;
    
    if (![self myIsRelativeMargin:cm])
        temp += cm;
    else
        tempWeight += cm;
    
    temp += centerPos.offsetVal;
    
    if (![self myIsRelativeMargin:tm])
        temp += tm;
    else
        tempWeight += tm;
    
    temp += tailPos.offsetVal;
    
    
    if (/*1 <= tempWeight*/ _myCGFloatLessOrEqual(1, tempWeight))
        temp = 0;
    else
        temp /=(1 - tempWeight);  //在有相对
    
    
    CGFloat headMargin = 0;
    if (headPos != nil)
        headMargin = [headPos realMarginInSize:temp];
    headMargin = [self myValidMargin:headPos sbv:headPos.view calcPos:headMargin selfLayoutSize:CGSizeZero];
    
    CGFloat centerMargin = 0;
    if (centerPos != nil)
        centerMargin = [centerPos realMarginInSize:temp];
    centerMargin = [self myValidMargin:centerPos sbv:centerPos.view calcPos:centerMargin selfLayoutSize:CGSizeZero];
    
    CGFloat tailMargin = 0;
    if (tailPos != nil)
        tailMargin = [tailPos realMarginInSize:temp];
    tailMargin = [self myValidMargin:tailPos sbv:tailPos.view calcPos:tailMargin selfLayoutSize:CGSizeZero];
    
    temp = subviewMeasure + headMargin + centerMargin + tailMargin;
    if (temp > selfMeasure)
    {
        selfMeasure = temp;
    }
    
    return selfMeasure;
    
}

-(void)myEqualizeSubviewsForVert:(BOOL)centered withSpace:(CGFloat)margin
{
    
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    
    CGFloat scale;
    CGFloat scale2;
    NSArray *sbs = [self myGetLayoutSubviews];
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
    
    
    for (UIView *sbv in sbs)
    {
        
        [sbv.bottomPos __equalTo:@0];
        [sbv.topPos __equalTo:@(scale2)];
        sbv.weight = scale;
        
        if (sbv == sbs.firstObject && !centered)
            [sbv.topPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbv.bottomPos __equalTo:@(scale2)];
    }
    
}

-(void)myEqualizeSubviewsForHorz:(BOOL)centered withSpace:(CGFloat)space
{
    
    
    NSArray *sbs = [self myGetLayoutSubviews];
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat scale;
    CGFloat scale2;
    
    if (space == CGFLOAT_MAX)
    {
        CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
        scale = 1 / fragments;
        scale2 = scale;
        
    }
    else
    {
        scale = 1.0;
        scale2 = space;
    }
    
    for (UIView *sbv in sbs)
    {
        [sbv.rightPos __equalTo:@0];
        [sbv.leftPos __equalTo:@(scale2)];
        sbv.weight = scale;
        
        if (sbv == sbs.firstObject && !centered)
            [sbv.leftPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbv.rightPos __equalTo:@(scale2)];
    }
    
}


-(void)myEqualizeSubviewsSpaceForVert:(BOOL)centered
{
    
    
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    NSArray *sbs = [self myGetLayoutSubviews];
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (UIView *sbv in sbs)
    {
        
        [sbv.topPos __equalTo:@(scale)];
        
        if (sbv == sbs.firstObject && !centered)
            [sbv.topPos __equalTo:@0];
        
        if (sbv == sbs.lastObject)
            [sbv.bottomPos __equalTo: centered? @(scale) : @0];
    }
    
    
}

-(void)myEqualizeSubviewsSpaceForHorz:(BOOL)centered
{
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    NSArray *sbs = [self myGetLayoutSubviews];
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (UIView *sbv in sbs)
    {
        [sbv.leftPos __equalTo:@(scale)];
        
        if (sbv == sbs.firstObject && !centered)
            [sbv.leftPos __equalTo:@0];
        
        if (sbv == sbs.lastObject)
            [sbv.rightPos __equalTo:centered? @(scale) : @0];
    }
}






@end

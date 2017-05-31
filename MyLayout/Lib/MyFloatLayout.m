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
    UIView *sc = self.myCurrentSizeClass;
    if (sc.isReverseFloat != reverseFloat)
    {
        sc.reverseFloat = reverseFloat;
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
    UIView *sc = self.myCurrentSizeClass;
    if (sc.clearFloat != clearFloat)
    {
        sc.clearFloat = clearFloat;
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

-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.myCurrentSizeClass.orientation = orientation;
    }
    
    return self;
}

-(instancetype)initWithOrientation:(MyOrientation)orientation
{
    return [self initWithFrame:CGRectZero orientation:orientation];
}


+(instancetype)floatLayoutWithOrientation:(MyOrientation)orientation
{
    MyFloatLayout *layout = [[[self class] alloc] initWithOrientation:orientation];
    return layout;
}

-(void)setOrientation:(MyOrientation)orientation
{
    MyFloatLayout *lsc = self.myCurrentSizeClass;
    if (lsc.orientation != orientation)
    {
        lsc.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(MyOrientation)orientation
{
    return self.myCurrentSizeClass.orientation;
}


-(void)setNoBoundaryLimit:(BOOL)noBoundaryLimit
{
    MyFloatLayout *lsc = self.myCurrentSizeClass;
    if (lsc.noBoundaryLimit != noBoundaryLimit)
    {
        lsc.noBoundaryLimit = noBoundaryLimit;
        [self setNeedsLayout];
    }
}

-(BOOL)noBoundaryLimit
{
    return self.myCurrentSizeClass.noBoundaryLimit;
}


-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace
{
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass
{
    MyFloatLayoutViewSizeClass *lsc = (MyFloatLayoutViewSizeClass*)[self fetchLayoutSizeClass:sizeClass];
    lsc.subviewSize = subviewSize;
    lsc.minSpace = minSpace;
    lsc.maxSpace = maxSpace;
    [self setNeedsLayout];
}


#pragma mark -- Deprecated Method


-(void)setSubviewFloatMargin:(CGFloat)subviewSize minMargin:(CGFloat)minMargin
{
    [self setSubviewsSize:subviewSize minSpace:minMargin maxSpace:CGFLOAT_MAX];
}

-(void)setSubviewFloatMargin:(CGFloat)subviewSize minMargin:(CGFloat)minMargin inSizeClass:(MySizeClass)sizeClass
{
    [self setSubviewsSize:subviewSize minSpace:minMargin maxSpace:CGFLOAT_MAX inSizeClass:sizeClass];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


#pragma mark -- Override Method

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    MyFloatLayout *lsc = self.myCurrentSizeClass;
    
    MyOrientation orientation = lsc.orientation;
    
    for (UIView *sbv in sbs)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        if (!isEstimate)
        {
            sbvmyFrame.frame = sbv.bounds;
            [self myCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame selfLayoutSize:selfSize];
        }
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            if (sbvsc.wrapContentWidth)
            {
                if (sbvsc.widthSizeInner.dimeVal != nil || (orientation == MyOrientation_Vert && sbvsc.weight != 0))
                {
                    sbvsc.wrapContentWidth = NO;
                }
            }
            
            if (sbvsc.wrapContentHeight)
            {
                if (sbvsc.heightSizeInner.dimeVal != nil || (orientation == MyOrientation_Horz && sbvsc.weight != 0))
                {
                    sbvsc.wrapContentHeight = NO;
                }
            }
            
            BOOL isSbvWrap = sbvsc.wrapContentHeight || sbvsc.wrapContentWidth;

            if (pHasSubLayout != nil && isSbvWrap)
                *pHasSubLayout = YES;
                        
            if (isEstimate && isSbvWrap)
            {
                [(MyBaseLayout*)sbv estimateLayoutRect:sbvmyFrame.frame.size inSizeClass:sizeClass];
                if (sbvmyFrame.multiple)
                {
                    sbvmyFrame.sizeClass = [sbv myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    sbvsc = sbvmyFrame.sizeClass;
                }
            }
        }
    }
    
    
    if (orientation == MyOrientation_Vert)
        selfSize = [self myLayoutSubviewsForVert:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    else
        selfSize = [self myLayoutSubviewsForHorz:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    
    
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    [self myAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [MyFloatLayoutViewSizeClass new];
}

#pragma mark -- Private Method

-(CGPoint)myFindTrailingCandidatePoint:(CGRect)leadingCandidateRect  width:(CGFloat)width trailingBoundary:(CGFloat)trailingBoundary trailingCandidateRects:(NSArray*)trailingCandidateRects hasWeight:(BOOL)hasWeight paddingTop:(CGFloat)paddingTop
{
    
    CGPoint retPoint = {trailingBoundary,CGFLOAT_MAX};
    
    CGFloat lastHeight = paddingTop;
    for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--)
    {
        
        CGRect trailingCandidateRect = ((NSValue*)trailingCandidateRects[i]).CGRectValue;
        
        //如果有比重则不能相等只能小于。
        if ((hasWeight ? CGRectGetMaxX(leadingCandidateRect) + width < CGRectGetMinX(trailingCandidateRect) : _myCGFloatLessOrEqual(CGRectGetMaxX(leadingCandidateRect) + width, CGRectGetMinX(trailingCandidateRect))
             ) &&
            CGRectGetMaxY(leadingCandidateRect) > lastHeight)
        {
            retPoint.y = MAX(CGRectGetMinY(leadingCandidateRect),lastHeight);
            retPoint.x = CGRectGetMinX(trailingCandidateRect);
            break;
        }
        
        lastHeight = CGRectGetMaxY(trailingCandidateRect);
        
    }
    
    if (retPoint.y == CGFLOAT_MAX)
    {
        if ((hasWeight ? CGRectGetMaxX(leadingCandidateRect) + width < trailingBoundary :_myCGFloatLessOrEqual(CGRectGetMaxX(leadingCandidateRect) + width, trailingBoundary) ) &&
            CGRectGetMaxY(leadingCandidateRect) > lastHeight)
        {
            retPoint.y =  MAX(CGRectGetMinY(leadingCandidateRect),lastHeight);
        }
    }
    
    return retPoint;
}

-(CGPoint)myFindBottomCandidatePoint:(CGRect)topCandidateRect  height:(CGFloat)height bottomBoundary:(CGFloat)bottomBoundary bottomCandidateRects:(NSArray*)bottomCandidateRects hasWeight:(BOOL)hasWeight paddingLeading:(CGFloat)paddingLeading
{
    
    CGPoint retPoint = {CGFLOAT_MAX,bottomBoundary};
    
    CGFloat lastWidth = paddingLeading;
    for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
    {
        
        CGRect bottomCandidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;

        if ((hasWeight ? CGRectGetMaxY(topCandidateRect) + height < CGRectGetMinY(bottomCandidateRect) :
             _myCGFloatLessOrEqual(CGRectGetMaxY(topCandidateRect) + height, CGRectGetMinY(bottomCandidateRect))) &&
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
        if ((hasWeight ? CGRectGetMaxY(topCandidateRect) + height < bottomBoundary : _myCGFloatLessOrEqual(CGRectGetMaxY(topCandidateRect) + height, bottomBoundary) ) &&
            CGRectGetMaxX(topCandidateRect) > lastWidth)
        {
            retPoint.x =  MAX(CGRectGetMinX(topCandidateRect),lastWidth);
        }
    }
    
    return retPoint;
}


-(CGPoint)myFindLeadingCandidatePoint:(CGRect)trailingCandidateRect  width:(CGFloat)width leadingBoundary:(CGFloat)leadingBoundary leadingCandidateRects:(NSArray*)leadingCandidateRects hasWeight:(BOOL)hasWeight paddingTop:(CGFloat)paddingTop
{
    
    CGPoint retPoint = {leadingBoundary,CGFLOAT_MAX};
    
    CGFloat lastHeight = paddingTop;
    for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--)
    {
        
       CGRect leadingCandidateRect = ((NSValue*)leadingCandidateRects[i]).CGRectValue;

        if ((hasWeight ? CGRectGetMinX(trailingCandidateRect) - width > CGRectGetMaxX(leadingCandidateRect) :
             _myCGFloatGreatOrEqual(CGRectGetMinX(trailingCandidateRect) - width, CGRectGetMaxX(leadingCandidateRect))) &&
            CGRectGetMaxY(trailingCandidateRect) > lastHeight)
        {
            retPoint.y = MAX(CGRectGetMinY(trailingCandidateRect),lastHeight);
            retPoint.x = CGRectGetMaxX(leadingCandidateRect);
            break;
        }
        
        lastHeight = CGRectGetMaxY(leadingCandidateRect);
        
    }
    
    if (retPoint.y == CGFLOAT_MAX)
    {
        if ((hasWeight ? CGRectGetMinX(trailingCandidateRect) - width > leadingBoundary :
             _myCGFloatGreatOrEqual(CGRectGetMinX(trailingCandidateRect) - width, leadingBoundary)) &&
            CGRectGetMaxY(trailingCandidateRect) > lastHeight)
        {
            retPoint.y =  MAX(CGRectGetMinY(trailingCandidateRect),lastHeight);
        }
    }
    
    return retPoint;
}

-(CGPoint)myFindTopCandidatePoint:(CGRect)bottomCandidateRect  height:(CGFloat)height topBoundary:(CGFloat)topBoundary topCandidateRects:(NSArray*)topCandidateRects hasWeight:(BOOL)hasWeight paddingLeading:(CGFloat)paddingLeading
{
    
    CGPoint retPoint = {CGFLOAT_MAX, topBoundary};
    
    CGFloat lastWidth = paddingLeading;
    for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
    {
        
        CGRect topCandidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;

        if ((hasWeight ? CGRectGetMinY(bottomCandidateRect) - height > CGRectGetMaxY(topCandidateRect) :
             _myCGFloatGreatOrEqual(CGRectGetMinY(bottomCandidateRect) - height, CGRectGetMaxY(topCandidateRect))) &&
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
        if ((hasWeight ? CGRectGetMinY(bottomCandidateRect) - height > topBoundary :
             _myCGFloatGreatOrEqual(CGRectGetMinY(bottomCandidateRect) - height, topBoundary)) &&
            CGRectGetMaxX(bottomCandidateRect) > lastWidth)
        {
            retPoint.x =  MAX(CGRectGetMinX(bottomCandidateRect),lastWidth);
        }
    }
    
    return retPoint;
}



-(CGSize)myLayoutSubviewsForVert:(CGSize)selfSize sbs:(NSArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFloatLayout*)lsc
{
    //对于垂直浮动布局来说，默认是左浮动,当设置为RTL时则默认是右浮动，因此我们只需要改变一下sbv.reverseFloat的定义就好了。
    
    CGFloat paddingTop = lsc.topPadding;
    CGFloat paddingBottom = lsc.bottomPadding;
    CGFloat paddingLeading = lsc.leadingPadding;
    CGFloat paddingTrailing = lsc.trailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    BOOL hasBoundaryLimit = YES;
    if (lsc.wrapContentWidth && lsc.noBoundaryLimit)
        hasBoundaryLimit = NO;
    
    //如果没有边界限制我们将高度设置为最大。。
    if (!hasBoundaryLimit)
        selfSize.width = CGFLOAT_MAX;
    
    //遍历所有的子视图，查看是否有子视图的宽度会比视图自身要宽，如果有且有包裹属性则扩充自身的宽度
    if (lsc.wrapContentWidth && hasBoundaryLimit)
    {
        CGFloat maxContentWidth = selfSize.width - paddingHorz;
        for (UIView *sbv in sbs)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
           
            CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
            CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
            CGRect rect = sbvmyFrame.frame;
            
            //因为这里是计算包裹宽度属性，所以只会计算那些设置了固定宽度的子视图
            
            //这里有可能设置了固定的宽度
            if (sbvsc.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbvsc.widthSizeInner.measure;
            
            //有可能宽度是和他的高度相等。
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            {
                if (sbvsc.heightSizeInner.dimeNumVal != nil)
                    rect.size.height = sbvsc.heightSizeInner.measure;
                
                if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
                    rect.size.height = [sbvsc.heightSizeInner measureWith:(selfSize.height - paddingVert) ];
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                
                rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            }
            
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (leadingSpace + rect.size.width + trailingSpace > maxContentWidth &&
                (sbvsc.widthSizeInner.dimeRelaVal == nil || sbvsc.widthSizeInner.dimeRelaVal != lsc.widthSizeInner)  &&
                sbvsc.weight == 0)
            {
                maxContentWidth = leadingSpace + rect.size.width + trailingSpace;
            }
        }
        
        selfSize.width = paddingHorz + maxContentWidth;
    }
    
    //支持浮动水平间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((MyFloatLayoutViewSizeClass*)self.myCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
#ifdef DEBUG
        //异常崩溃：当布局视图设置了noBoundaryLimit为YES时，不能设置最小垂直间距。
        NSCAssert(hasBoundaryLimit, @"Constraint exception！！, vertical float layout:%@ can not set noBoundaryLimit to YES when call setSubviewsSize:minSpace:maxSpace  method",self);
#endif
        
        
        CGFloat minSpace = ((MyFloatLayoutViewSizeClass*)self.myCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((MyFloatLayoutViewSizeClass*)self.myCurrentSizeClass).maxSpace;
        
        NSInteger rowCount =  floor((selfSize.width - paddingHorz  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            horzSpace = (selfSize.width - paddingHorz - subviewSize * rowCount)/(rowCount - 1);
            
            //如果超过最大间距则调整子视图的宽度。
            if (horzSpace > maxSpace)
            {
                horzSpace = maxSpace;
                
                subviewSize =  (selfSize.width - paddingHorz -  horzSpace * (rowCount - 1)) / rowCount;
                
            }
            
        }
    }
    
    
    //左边候选区域数组，保存的是CGRect值。
    NSMutableArray *leadingCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最左边的个虚拟区域作为一个候选区域
   [leadingCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(paddingLeading, paddingTop, 0, CGFLOAT_MAX)]];
    
    //右边候选区域数组，保存的是CGRect值。
    NSMutableArray *trailingCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最右边的个虚拟区域作为一个候选区域
    [trailingCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(selfSize.width - paddingTrailing, paddingTop, 0, CGFLOAT_MAX)]];
    
    //分别记录左边和右边的最后一个视图在Y轴的偏移量
    CGFloat leadingLastYOffset = paddingTop;
    CGFloat trailingLastYOffset = paddingTop;
    
    //分别记录左右边和全局浮动视图的最高占用的Y轴的值
    CGFloat leadingMaxHeight = paddingTop;
    CGFloat trailingMaxHeight = paddingTop;
    CGFloat maxHeight = paddingTop;
    CGFloat maxWidth = paddingLeading;
    
    for (UIView *sbv in sbs)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        
        if (subviewSize != 0)
            rect.size.width = subviewSize;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner && !lsc.wrapContentHeight)
            rect.size.height = [sbvsc.heightSizeInner measureWith:(selfSize.height - paddingVert) ];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:(selfSize.width - paddingHorz) ];
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height ];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil &&  sbvsc.widthSizeInner.dimeRelaVal.view != nil &&  sbvsc.widthSizeInner.dimeRelaVal.view != self && sbvsc.widthSizeInner.dimeRelaVal.view != sbv)
        {
            rect.size.width = [sbvsc.widthSizeInner measureWith:sbvsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
        }
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil &&  sbvsc.heightSizeInner.dimeRelaVal.view != nil &&  sbvsc.heightSizeInner.dimeRelaVal.view != self && sbvsc.heightSizeInner.dimeRelaVal.view != sbv)
        {
            rect.size.height = [sbvsc.heightSizeInner measureWith:sbvsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
        }
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果是RTL的场景则默认是右对齐的。
        if (sbvsc.isReverseFloat)
        {
#ifdef DEBUG
            //异常崩溃：当布局视图设置了noBoundaryLimit为YES时子视图不能设置逆向浮动
            NSCAssert(hasBoundaryLimit, @"Constraint exception！！, vertical float layout:%@ can not set noBoundaryLimit to YES when the subview:%@ set reverseFloat to YES.",self, sbv);
#endif
            
            CGPoint nextPoint = {selfSize.width - paddingTrailing, leadingLastYOffset};
            CGFloat leadingCandidateXBoundary = paddingLeading;
            if (sbvsc.clearFloat)
            {
                //找到最底部的位置。
                nextPoint.y = MAX(trailingMaxHeight, leadingLastYOffset);
                CGPoint leadingPoint = [self myFindLeadingCandidatePoint:CGRectMake(selfSize.width - paddingTrailing, nextPoint.y, 0, CGFLOAT_MAX) width:leadingSpace + (sbvsc.weight != 0 ? 0 : rect.size.width) + trailingSpace leadingBoundary:paddingLeading leadingCandidateRects:leadingCandidateRects hasWeight:NO paddingTop:paddingTop];
                if (leadingPoint.y != CGFLOAT_MAX)
                {
                    nextPoint.y = MAX(trailingMaxHeight, leadingPoint.y);
                    leadingCandidateXBoundary = leadingPoint.x;
                }
            }
            else
            {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)trailingCandidateRects[i]).CGRectValue;
                    CGPoint leadingPoint = [self myFindLeadingCandidatePoint:candidateRect width:leadingSpace + (sbvsc.weight != 0 ? 0 : rect.size.width) + trailingSpace leadingBoundary:paddingLeading leadingCandidateRects:leadingCandidateRects hasWeight:sbvsc.weight != 0 paddingTop:paddingTop];
                    if (leadingPoint.y != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(CGRectGetMinX(candidateRect), MAX(nextPoint.y, leadingPoint.y));
                        leadingCandidateXBoundary = leadingPoint.x;
                        break;
                    }
                    
                    nextPoint.y = CGRectGetMaxY(candidateRect);
                }
            }
            
            //重新设置宽度
            if (sbvsc.weight != 0)
            {
                
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:(nextPoint.x - leadingCandidateXBoundary + sbvsc.widthSizeInner.addVal) * sbvsc.weight - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                
                if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
                    rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
                
                if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
                    rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                
            }
            
            
            rect.origin.x = nextPoint.x - trailingSpace - rect.size.width;
            rect.origin.y = MIN(nextPoint.y, maxHeight) + topSpace;
            
            //如果有智能边界线则找出所有智能边界线。
            if (!isEstimate && self.intelligentBorderline != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.bottomBorderline = nil;
                        sbvl.topBorderline = nil;
                        sbvl.trailingBorderline = nil;
                        sbvl.leadingBorderline = nil;
                        
                        
                        if (rect.origin.x + rect.size.width + trailingSpace < selfSize.width - paddingTrailing)
                        {
                           
                            sbvl.trailingBorderline = self.intelligentBorderline;
                        }
                        
                        if (rect.origin.y + rect.size.height + bottomSpace < selfSize.height - paddingBottom)
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                        
                        if (rect.origin.x > leadingCandidateXBoundary && sbvl == sbs.lastObject)
                        {
                            sbvl.leadingBorderline = self.intelligentBorderline;
                        }
                        
                    }
                    
                }
            }
            
            
            //这里有可能子视图本身的宽度会超过布局视图本身，但是我们的候选区域则不存储超过的宽度部分。
            CGRect cRect = CGRectMake(MAX((rect.origin.x - leadingSpace - horzSpace),paddingLeading), rect.origin.y - topSpace, MIN((rect.size.width + leadingSpace + trailingSpace),(selfSize.width - paddingHorz)), rect.size.height + topSpace + bottomSpace + vertSpace);
            
            //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
            for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)trailingCandidateRects[i]).CGRectValue;
                if (CGRectGetMaxY(candidateRect) <= CGRectGetMaxY(cRect))
                {
                    [trailingCandidateRects removeObjectAtIndex:i];
                }
            }
            
            //删除左边高度小于新添加区域的顶部的候选区域
            for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)leadingCandidateRects[i]).CGRectValue;
                if (_myCGFloatLessOrEqual(CGRectGetMaxY(candidateRect), CGRectGetMinY(cRect)))
                {
                  [leadingCandidateRects removeObjectAtIndex:i];
                }
            }
            
            
            [trailingCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            trailingLastYOffset = rect.origin.y - topSpace;
            
            if (rect.origin.y + rect.size.height + bottomSpace + vertSpace > trailingMaxHeight)
                trailingMaxHeight = rect.origin.y + rect.size.height + bottomSpace + vertSpace;
        }
        else
        {
            CGPoint nextPoint = {paddingLeading, trailingLastYOffset};
            CGFloat trailingCandidateXBoundary = selfSize.width - paddingTrailing;
            
            //如果是清除了浮动则直换行移动到最下面。
            if (sbvsc.clearFloat)
            {
                //找到最低点。
                nextPoint.y = MAX(leadingMaxHeight, trailingLastYOffset);
                
                CGPoint trailingPoint = [self myFindTrailingCandidatePoint:CGRectMake(paddingLeading, nextPoint.y, 0, CGFLOAT_MAX) width:leadingSpace + (sbvsc.weight != 0 ? 0 : rect.size.width) + trailingSpace trailingBoundary:trailingCandidateXBoundary trailingCandidateRects:trailingCandidateRects hasWeight:NO paddingTop:paddingTop];
                if (trailingPoint.y != CGFLOAT_MAX)
                {
                    nextPoint.y = MAX(leadingMaxHeight, trailingPoint.y);
                    trailingCandidateXBoundary = trailingPoint.x;
                }
            }
            else
            {
                
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)leadingCandidateRects[i]).CGRectValue;

                    CGPoint trailingPoint = [self myFindTrailingCandidatePoint:candidateRect width:leadingSpace + (sbvsc.weight != 0 ? 0 : rect.size.width) + trailingSpace trailingBoundary:selfSize.width - paddingTrailing trailingCandidateRects:trailingCandidateRects hasWeight:sbvsc.weight != 0 paddingTop:paddingTop];
                    if (trailingPoint.y != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(CGRectGetMaxX(candidateRect), MAX(nextPoint.y, trailingPoint.y));
                        trailingCandidateXBoundary = trailingPoint.x;
                        break;
                    }
                    
                    nextPoint.y = CGRectGetMaxY(candidateRect);
                }
            }
            
            //重新设置宽度
            if (sbvsc.weight != 0)
            {
#ifdef DEBUG
                //异常崩溃：当布局视图设置了noBoundaryLimit为YES时子视图不能设置weight大于0
                NSCAssert(hasBoundaryLimit, @"Constraint exception！！, vertical float layout:%@ can not set noBoundaryLimit to YES when the subview:%@ set weight big than zero.",self, sbv);
#endif
                
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:(trailingCandidateXBoundary - nextPoint.x + sbvsc.widthSizeInner.addVal) * sbvsc.weight - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
                    rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
                
                if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
                    rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                
            }
            
            rect.origin.x = nextPoint.x + leadingSpace;
            rect.origin.y = MIN(nextPoint.y,maxHeight) + topSpace;
            
            if (!isEstimate && self.intelligentBorderline != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.bottomBorderline = nil;
                        sbvl.topBorderline = nil;
                        sbvl.trailingBorderline = nil;
                        sbvl.leadingBorderline = nil;
                        
                        if (rect.origin.x + rect.size.width + trailingSpace < selfSize.width - paddingTrailing)
                        {
                        
                            sbvl.trailingBorderline = self.intelligentBorderline;
                        }
                        
                        if (rect.origin.y + rect.size.height + bottomSpace < selfSize.height - paddingBottom)
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                        
                        
                    }
                    
                }
            }
            
            
            CGRect cRect = CGRectMake(rect.origin.x - leadingSpace, rect.origin.y - topSpace, MIN((rect.size.width + leadingSpace + trailingSpace + horzSpace),(selfSize.width - paddingHorz)), rect.size.height + topSpace + bottomSpace + vertSpace);
            
            
            //把新添加到候选中去。并删除高度小于的候选键。和高度
            for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)leadingCandidateRects[i]).CGRectValue;

                if (_myCGFloatLessOrEqual(CGRectGetMaxY(candidateRect), CGRectGetMaxY(cRect)))
                {
                    [leadingCandidateRects removeObjectAtIndex:i];
                }
            }
            
            //删除右边高度小于新添加区域的顶部的候选区域
            for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)trailingCandidateRects[i]).CGRectValue;
                if (_myCGFloatLessOrEqual(CGRectGetMaxY(candidateRect), CGRectGetMinY(cRect)))
                {
                    [trailingCandidateRects removeObjectAtIndex:i];
                 }
            }
            
            [leadingCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            leadingLastYOffset = rect.origin.y - topSpace;
            
            if (rect.origin.y + rect.size.height + bottomSpace + vertSpace > leadingMaxHeight)
                leadingMaxHeight = rect.origin.y + rect.size.height + bottomSpace + vertSpace;
            
        }
        
        if (rect.origin.y + rect.size.height + bottomSpace + vertSpace > maxHeight)
            maxHeight = rect.origin.y + rect.size.height + bottomSpace + vertSpace;
        
        if (rect.origin.x + rect.size.width + trailingSpace + horzSpace > maxWidth)
            maxWidth = rect.origin.x + rect.size.width + trailingSpace + horzSpace;
        
        sbvmyFrame.frame = rect;
        
    }
    
    if (sbs.count > 0)
    {
        maxHeight -= vertSpace;
        maxWidth -= horzSpace;
    }
    
    maxHeight += paddingBottom;
    maxWidth += paddingTrailing;
    
    if (!hasBoundaryLimit)
        selfSize.width = maxWidth;
    
    if (lsc.wrapContentHeight)
        selfSize.height = maxHeight;
    else
    {
        CGFloat addYPos = 0;
        MyGravity mgvert = lsc.gravity & MyGravity_Horz_Mask;
        if (mgvert == MyGravity_Vert_Center)
        {
            addYPos = (selfSize.height - maxHeight) / 2;
        }
        else if (mgvert == MyGravity_Vert_Bottom)
        {
            addYPos = selfSize.height - maxHeight;
        }
        
        if (addYPos != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                sbv.myFrame.top += addYPos;
            }
        }
        
    }
   
    return selfSize;
}

-(CGSize)myLayoutSubviewsForHorz:(CGSize)selfSize sbs:(NSArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFloatLayout*)lsc
{
    //对于水平浮动布局来说，最终是从左到右排列，而对于RTL则是从右到左排列，因此这里先抽象定义头尾的概念，然后最后再计算时统一将抽象位置转化为CGRect的左边值。

    CGFloat paddingTop = lsc.topPadding;
    CGFloat paddingBottom = lsc.bottomPadding;
    CGFloat paddingLeading = lsc.leadingPadding;
    CGFloat paddingTrailing = lsc.trailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    BOOL hasBoundaryLimit = YES;
    if (lsc.wrapContentHeight && lsc.noBoundaryLimit)
        hasBoundaryLimit = NO;
    
    //如果没有边界限制我们将高度设置为最大。。
    if (!hasBoundaryLimit)
        selfSize.height = CGFLOAT_MAX;
    
    //遍历所有的子视图，查看是否有子视图的宽度会比视图自身要宽，如果有且有包裹属性则扩充自身的宽度
    if (lsc.wrapContentHeight && hasBoundaryLimit)
    {
        CGFloat maxContentHeight = selfSize.height - paddingVert;
        for (UIView *sbv in sbs)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
            
            CGFloat topSpace = sbvsc.topPosInner.absVal;
            CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
            CGRect rect = sbvmyFrame.frame;
            
            
            //这里有可能设置了固定的高度
            if (sbvsc.heightSizeInner.dimeNumVal != nil)
                rect.size.height = sbvsc.heightSizeInner.measure;
            
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            //有可能高度是和他的宽度相等。
            if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            {
                if (sbvsc.widthSizeInner.dimeNumVal != nil)
                    rect.size.width = sbvsc.widthSizeInner.measure;
                
                if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner)
                    rect.size.width = [sbvsc.widthSizeInner measureWith:(selfSize.width - paddingHorz) ];
                
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
                
                
                rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            }
            
            if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
                rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
            
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (topSpace + rect.size.height + bottomSpace > maxContentHeight &&
                (sbvsc.heightSizeInner.dimeRelaVal == nil || sbvsc.heightSizeInner.dimeRelaVal != lsc.heightSizeInner) &&
                sbvsc.weight == 0)
            {
                maxContentHeight = topSpace + rect.size.height + bottomSpace;
            }
        }
        
        selfSize.height = paddingVert + maxContentHeight;
    }
    
    //支持浮动垂直间距。
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat subviewSize = ((MyFloatLayoutViewSizeClass*)self.myCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
#ifdef DEBUG
        //异常崩溃：当布局视图设置了noBoundaryLimit为YES时，不能设置最小垂直间距。
        NSCAssert(hasBoundaryLimit, @"Constraint exception！！, horizontal float layout:%@ can not set noBoundaryLimit to YES when call setSubviewsSize:minSpace:maxSpace  method",self);
#endif
        
        CGFloat minSpace = ((MyFloatLayoutViewSizeClass*)self.myCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((MyFloatLayoutViewSizeClass*)self.myCurrentSizeClass).maxSpace;
        
        NSInteger rowCount =  floor((selfSize.height - paddingVert  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            vertSpace = (selfSize.height - paddingVert - subviewSize * rowCount)/(rowCount - 1);
            
            if (vertSpace > maxSpace)
            {
                vertSpace = maxSpace;
                
                subviewSize =  (selfSize.height - paddingVert -  vertSpace * (rowCount - 1)) / rowCount;
                
            }
            
        }
    }
    
    
    //上边候选区域数组，保存的是CGRect值。
    NSMutableArray *topCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最上边的个虚拟区域作为一个候选区域
    [topCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(paddingLeading, paddingTop,CGFLOAT_MAX,0)]];
    
    //右边候选区域数组，保存的是CGRect值。
    NSMutableArray *bottomCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最下边的个虚拟区域作为一个候选区域,如果没有边界限制则
    [bottomCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(paddingLeading, selfSize.height - paddingBottom, CGFLOAT_MAX, 0)]];
    
    //分别记录上边和下边的最后一个视图在X轴的偏移量
    CGFloat topLastXOffset = paddingLeading;
    CGFloat bottomLastXOffset = paddingLeading;
    
    //分别记录上下边和全局浮动视图的最宽占用的X轴的值
    CGFloat topMaxWidth = paddingLeading;
    CGFloat bottomMaxWidth = paddingLeading;
    CGFloat maxWidth = paddingLeading;
    CGFloat maxHeight = paddingTop;
    
    for (UIView *sbv in sbs)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];

        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (subviewSize != 0)
            rect.size.height = subviewSize;
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:(selfSize.height - paddingVert) ];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner && !lsc.wrapContentWidth)
            rect.size.width = [sbvsc.widthSizeInner measureWith:(selfSize.width - paddingHorz) ];
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil &&  sbvsc.widthSizeInner.dimeRelaVal.view != nil &&  sbvsc.widthSizeInner.dimeRelaVal.view != self && sbvsc.widthSizeInner.dimeRelaVal.view != sbv)
        {
            rect.size.width = [sbvsc.widthSizeInner measureWith:sbvsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
        }
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil &&  sbvsc.heightSizeInner.dimeRelaVal.view != nil &&  sbvsc.heightSizeInner.dimeRelaVal.view != self && sbvsc.heightSizeInner.dimeRelaVal.view != sbv)
        {
            rect.size.height = [sbvsc.heightSizeInner measureWith:sbvsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
        }
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        
        if (sbvsc.reverseFloat)
        {
#ifdef DEBUG
            //异常崩溃：当布局视图设置了noBoundaryLimit为YES时子视图不能设置逆向浮动
            NSCAssert(hasBoundaryLimit, @"Constraint exception！！, horizontal float layout:%@ can not set noBoundaryLimit to YES when the subview:%@ set reverseFloat to YES.",self, sbv);
#endif
            
            CGPoint nextPoint = {topLastXOffset, selfSize.height - paddingBottom};
            CGFloat topCandidateYBoundary = paddingTop;
            if (sbvsc.clearFloat)
            {
                //找到最底部的位置。
                nextPoint.x = MAX(bottomMaxWidth, topLastXOffset);
                CGPoint topPoint = [self myFindTopCandidatePoint:CGRectMake(nextPoint.x, selfSize.height - paddingBottom, CGFLOAT_MAX, 0) height:topSpace + (sbvsc.weight != 0 ? 0 : rect.size.height) + bottomSpace topBoundary:topCandidateYBoundary topCandidateRects:topCandidateRects hasWeight:NO paddingLeading:paddingLeading];
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

                    CGPoint topPoint = [self myFindTopCandidatePoint:candidateRect height:topSpace + (sbvsc.weight != 0 ? 0 : rect.size.height) + bottomSpace topBoundary:paddingTop topCandidateRects:topCandidateRects hasWeight:sbvsc.weight != 0 paddingLeading:paddingLeading];
                    if (topPoint.x != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(MAX(nextPoint.x, topPoint.x),CGRectGetMinY(candidateRect));
                        topCandidateYBoundary = topPoint.y;
                        break;
                    }
                    
                    nextPoint.x = CGRectGetMaxX(candidateRect);
                }
            }
            
            if (sbvsc.weight != 0)
            {
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:(nextPoint.y - topCandidateYBoundary + sbvsc.heightSizeInner.addVal) * sbvsc.weight - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                    rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height] sbvSize:rect.size selfLayoutSize:selfSize];
                
            }
            
            
            rect.origin.y = nextPoint.y - bottomSpace - rect.size.height;
            rect.origin.x = MIN(nextPoint.x, maxWidth) + leadingSpace;
            
            //如果有智能边界线则找出所有智能边界线。
            if (!isEstimate && self.intelligentBorderline != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.bottomBorderline = nil;
                        sbvl.topBorderline = nil;
                        sbvl.trailingBorderline = nil;
                        sbvl.leadingBorderline = nil;
                        
                        //如果自己的上边和左边有子视图。
                        if (rect.origin.x + rect.size.width + trailingSpace < selfSize.width - paddingTrailing)
                        {
                           sbvl.trailingBorderline = self.intelligentBorderline;
                        }
                        
                        if (rect.origin.y + rect.size.height + bottomSpace < selfSize.height - paddingBottom)
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                        
                        if (rect.origin.y > topCandidateYBoundary && sbvl == sbs.lastObject)
                        {
                            sbvl.topBorderline = self.intelligentBorderline;
                        }
                        
                    }
                    
                }
            }
            
            
            //这里有可能子视图本身的高度会超过布局视图本身，但是我们的候选区域则不存储超过的高度部分。
            CGRect cRect = CGRectMake(rect.origin.x - leadingSpace, MAX((rect.origin.y - topSpace - vertSpace),paddingTop), rect.size.width + leadingSpace + trailingSpace + horzSpace, MIN((rect.size.height + topSpace + bottomSpace),(selfSize.height - paddingVert)));
            
            //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
            for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;
                if (_myCGFloatLessOrEqual(CGRectGetMaxX(candidateRect), CGRectGetMaxX(cRect)))
                {
                    [bottomCandidateRects removeObjectAtIndex:i];
                }
            }
            
            //删除顶部宽度小于新添加区域的顶部的候选区域
            for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;

                if (_myCGFloatLessOrEqual(CGRectGetMaxX(candidateRect), CGRectGetMinX(cRect)))
                {
                    [topCandidateRects removeObjectAtIndex:i];
                }
            }
            
            [bottomCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            bottomLastXOffset = rect.origin.x - leadingSpace;
            
            if (rect.origin.x + rect.size.width + trailingSpace + horzSpace > bottomMaxWidth)
                bottomMaxWidth = rect.origin.x + rect.size.width + trailingSpace + horzSpace;
        }
        else
        {
            CGPoint nextPoint = {bottomLastXOffset,paddingTop};
            CGFloat bottomCandidateYBoundary = selfSize.height - paddingBottom;
            //如果是清除了浮动则直换行移动到最下面。
            if (sbvsc.clearFloat)
            {
                //找到最低点。
                nextPoint.x = MAX(topMaxWidth, bottomLastXOffset);
                
                CGPoint bottomPoint = [self myFindBottomCandidatePoint:CGRectMake(nextPoint.x, paddingTop,CGFLOAT_MAX,0) height:topSpace + (sbvsc.weight != 0 ? 0: rect.size.height) + bottomSpace bottomBoundary:bottomCandidateYBoundary bottomCandidateRects:bottomCandidateRects hasWeight:NO paddingLeading:paddingLeading];
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
                    CGPoint bottomPoint = [self myFindBottomCandidatePoint:candidateRect height:topSpace + (sbvsc.weight != 0 ? 0: rect.size.height) + bottomSpace bottomBoundary:selfSize.height - paddingBottom bottomCandidateRects:bottomCandidateRects hasWeight:sbvsc.weight != 0 paddingLeading:paddingLeading];
                    if (bottomPoint.x != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(MAX(nextPoint.x, bottomPoint.x),CGRectGetMaxY(candidateRect));
                        bottomCandidateYBoundary = bottomPoint.y;
                        break;
                    }
                    
                    nextPoint.x = CGRectGetMaxX(candidateRect);
                }
            }
            
            if (sbvsc.weight != 0)
            {
                
#ifdef DEBUG
                //异常崩溃：当布局视图设置了noBoundaryLimit为YES时子视图不能设置weight大于0
                NSCAssert(hasBoundaryLimit, @"Constraint exception！！, horizontal float layout:%@ can not set noBoundaryLimit to YES when the subview:%@ set weight big than zero.",self, sbv);
#endif
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:(bottomCandidateYBoundary - nextPoint.y + sbvsc.heightSizeInner.addVal) * sbvsc.weight - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                    rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height] sbvSize:rect.size selfLayoutSize:selfSize];
                
            }
            
            rect.origin.y = nextPoint.y + topSpace;
            rect.origin.x = MIN(nextPoint.x,maxWidth) + leadingSpace;
            
            //如果有智能边界线则找出所有智能边界线。
            if (!isEstimate && self.intelligentBorderline != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.bottomBorderline = nil;
                        sbvl.topBorderline = nil;
                        sbvl.trailingBorderline = nil;
                        sbvl.leadingBorderline = nil;
                        
                        //如果自己的上边和左边有子视图。
                        if (rect.origin.x + rect.size.width + trailingSpace < selfSize.width - paddingTrailing)
                        {
                            sbvl.trailingBorderline = self.intelligentBorderline;
                        }
                        
                        if (rect.origin.y + rect.size.height + bottomSpace <  selfSize.height - paddingBottom)
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                    }
                    
                }
            }
            
            
            CGRect cRect = CGRectMake(rect.origin.x - leadingSpace, rect.origin.y - topSpace,rect.size.width + leadingSpace + trailingSpace + horzSpace,MIN((rect.size.height + topSpace + bottomSpace + vertSpace),(selfSize.height - paddingVert)));
            
            
            //把新添加到候选中去。并删除宽度小于的最新候选区域的候选区域
            for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;

                if (_myCGFloatLessOrEqual(CGRectGetMaxX(candidateRect), CGRectGetMaxX(cRect)))
                {
                    [topCandidateRects removeObjectAtIndex:i];
                }
            }
            
            //删除顶部宽度小于新添加区域的顶部的候选区域
            for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;
                if (_myCGFloatLessOrEqual(CGRectGetMaxX(candidateRect), CGRectGetMinX(cRect)))
                {
                    [bottomCandidateRects removeObjectAtIndex:i];
                }
            }
            
            
            [topCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            topLastXOffset = rect.origin.x - leadingSpace;
            
            if (rect.origin.x + rect.size.width + trailingSpace + horzSpace > topMaxWidth)
                topMaxWidth = rect.origin.x + rect.size.width + trailingSpace + horzSpace;
            
        }
        
        if (rect.origin.x + rect.size.width + trailingSpace + horzSpace > maxWidth)
            maxWidth = rect.origin.x + rect.size.width + trailingSpace + horzSpace;
        
        if (rect.origin.y + rect.size.height + bottomSpace + vertSpace > maxHeight)
            maxHeight = rect.origin.y + rect.size.height + bottomSpace + vertSpace;
        
        sbvmyFrame.frame = rect;
        
    }
    
    if (sbs.count > 0)
    {
        maxWidth -= horzSpace;
        maxHeight -= vertSpace;
    }
    
    maxWidth += paddingTrailing;
    
    maxHeight += paddingBottom;
    if (!hasBoundaryLimit)
        selfSize.height = maxHeight;
    
    if (lsc.wrapContentWidth)
        selfSize.width = maxWidth;
    else
    {
        CGFloat addXPos = 0;
        MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
        
        if (horzGravity == MyGravity_Horz_Center)
        {
            addXPos = (selfSize.width - maxWidth) / 2;
        }
        else if (horzGravity == MyGravity_Horz_Trailing)
        {
            addXPos = selfSize.width - maxWidth;
        }
        
        if (addXPos != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                sbv.myFrame.leading += addXPos;
            }
        }
        
    }
    
    return selfSize;
}


@end

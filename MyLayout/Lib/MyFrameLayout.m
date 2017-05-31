//
//  MyFrameLayout.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyFrameLayout.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>



@implementation MyFrameLayout

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


#pragma mark -- Override Method

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray *)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    MyFrameLayout *lsc = self.myCurrentSizeClass;
    CGFloat paddingTop = lsc.topPadding;
    CGFloat paddingLeading = lsc.leadingPadding;
    CGFloat paddingBottom = lsc.bottomPadding;
    CGFloat paddingTrailing = lsc.trailingPadding;
    
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    
    
    CGSize maxWrapSize = CGSizeMake(paddingLeading + paddingTrailing, paddingTop + paddingBottom);
    CGSize *pMaxWrapSize = &maxWrapSize;
    if (!lsc.wrapContentHeight && !lsc.wrapContentWidth)
        pMaxWrapSize = NULL;
    
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
            
            if (sbvsc.wrapContentHeight && (sbvsc.heightSizeInner.dimeVal != nil || (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)))
            {
                sbvsc.wrapContentHeight = NO;
            }
            
            if (sbvsc.wrapContentWidth && (sbvsc.widthSizeInner.dimeVal != nil || (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)))
            {
                sbvsc.wrapContentWidth = NO;
            }
            
            
            if (pHasSubLayout != nil && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
                *pHasSubLayout = YES;
            
            if (isEstimate && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
            {
                [(MyBaseLayout*)sbv estimateLayoutRect:sbvmyFrame.frame.size inSizeClass:sizeClass];
                if (sbvmyFrame.multiple)
                {
                    sbvmyFrame.sizeClass = [sbv myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    sbvsc = sbvmyFrame.sizeClass;
                }
            }
        }
        
        
        //计算自己的位置和高宽
        [self myCalcSubViewRect:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame lsc:lsc vertGravity:vertGravity horzGravity:horzGravity inSelfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:pMaxWrapSize];
        
    }
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = maxWrapSize.width;
    }
    
    if (lsc.wrapContentHeight)
    {
        selfSize.height = maxWrapSize.height;
    }
    
    //调整布局视图自己的尺寸。
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    //如果布局视图具有包裹属性这里要调整那些依赖父视图宽度和高度的子视图的位置和尺寸。
    if ((lsc.wrapContentWidth && horzGravity != MyGravity_Horz_Fill) || (lsc.wrapContentHeight && vertGravity != MyGravity_Vert_Fill))
    {
        for (UIView *sbv in sbs)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
           
            
            //只有子视图的尺寸或者位置依赖父视图的情况下才需要重新计算位置和尺寸。
            if ((sbvsc.trailingPosInner.posVal != nil) ||
                (sbvsc.bottomPosInner.posVal != nil) ||
                (sbvsc.centerXPosInner.posVal != nil) ||
                (sbvsc.centerYPosInner.posVal != nil) ||
                (sbvsc.widthSizeInner.dimeRelaVal.view == self) ||
                (sbvsc.heightSizeInner.dimeRelaVal.view == self)
                )
            {
                [self myCalcSubViewRect:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame lsc:lsc  vertGravity:vertGravity horzGravity:horzGravity inSelfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:NULL];
            }
            
        }
    }
    
    
    //如果是反向则调整左右位置。
    [self myAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
    
}

-(id)createSizeClassInstance
{
    return [MyFrameLayoutViewSizeClass new];
}


#pragma mark -- Private Method


-(void)myCalcSubViewRect:(UIView*)sbv
                   sbvsc:(UIView*)sbvsc
              sbvmyFrame:(MyFrame*)sbvmyFrame
                     lsc:(MyFrameLayout*)lsc
             vertGravity:(MyGravity)vertGravity
             horzGravity:(MyGravity)horzGravity
              inSelfSize:(CGSize)selfSize
              paddingTop:(CGFloat)paddingTop
          paddingLeading:(CGFloat)paddingLeading
           paddingBottom:(CGFloat)paddingBottom
         paddingTrailing:(CGFloat)paddingTrailing
            pMaxWrapSize:(CGSize*)pMaxWrapSize
{
    
    
    CGRect rect = sbvmyFrame.frame;
    
    if (sbvsc.widthSizeInner.dimeNumVal != nil)
    {//宽度等于固定的值。
        
        rect.size.width = sbvsc.widthSizeInner.measure;
    }
    else if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal.view != sbv)
    {//宽度等于其他的依赖的视图。
        
        if (sbvsc.widthSizeInner.dimeRelaVal == self.widthSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:selfSize.width - paddingLeading - paddingTrailing];
        else
            rect.size.width = [sbvsc.widthSizeInner measureWith:sbvsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
    }
    
    rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
    [self myCalcHorzGravity:[self myGetSubviewHorzGravity:sbv sbvsc:sbvsc horzGravity:horzGravity] sbv:sbv sbvsc:sbvsc paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:&rect];
    
    
    
    if (sbvsc.heightSizeInner.dimeNumVal != nil)
    {//高度等于固定的值。
        rect.size.height = sbvsc.heightSizeInner.measure;
    }
    else if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal.view != sbv)
    {//高度等于其他依赖的视图
        if (sbvsc.heightSizeInner.dimeRelaVal == self.heightSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:selfSize.height - paddingTop - paddingBottom];
        else
            rect.size.height = [sbvsc.heightSizeInner measureWith:sbvsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
    }
    
    if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
    {//高度等于内容的高度
        rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
    }
    
    rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
    [self myCalcVertGravity:[self myGetSubviewVertGravity:sbv sbvsc:sbvsc vertGravity:vertGravity] sbv:sbv sbvsc:sbvsc paddingTop:paddingTop paddingBottom:paddingBottom selfSize:selfSize pRect:&rect];
    
    
    //特殊处理宽度等于高度
    if (sbvsc.widthSizeInner.dimeRelaVal.view == sbv && sbvsc.widthSizeInner.dimeRelaVal.dime == MyGravity_Vert_Fill)
    {
        rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        [self myCalcHorzGravity:[self myGetSubviewHorzGravity:sbv sbvsc:sbvsc horzGravity:horzGravity] sbv:sbv sbvsc:sbvsc paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:&rect];
    }
    
    //特殊处理高度等于宽度。
    if (sbvsc.heightSizeInner.dimeRelaVal.view == sbv && sbvsc.heightSizeInner.dimeRelaVal.dime == MyGravity_Horz_Fill)
    {
        rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        }
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        [self myCalcVertGravity:[self myGetSubviewVertGravity:sbv sbvsc:sbvsc vertGravity:vertGravity] sbv:sbv sbvsc:sbvsc paddingTop:paddingTop paddingBottom:paddingBottom selfSize:selfSize pRect:&rect];
        
    }
    
    sbvmyFrame.frame = rect;
    
    if (pMaxWrapSize != NULL)
    {
        if (lsc.wrapContentWidth)
        {
            //如果同时设置左右边界则左右边界为最小的宽度
            if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
            {
                if (pMaxWrapSize->width < sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing)
                    pMaxWrapSize->width = sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing;
            }
            
            //宽度不依赖布局并且没有同时设置左右边距则参与最大宽度计算。
            if ((sbvsc.widthSizeInner.dimeRelaVal.view != self) &&
                (sbvsc.leadingPosInner.posVal == nil || sbvsc.trailingPosInner.posVal == nil))
            {
                
                if (pMaxWrapSize->width < sbvmyFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.centerXPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing)
                    pMaxWrapSize->width = sbvmyFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.centerXPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing;
                
                if (pMaxWrapSize->width < sbvmyFrame.trailing + sbvsc.trailingPosInner.absVal + paddingTrailing)
                    pMaxWrapSize->width = sbvmyFrame.trailing + sbvsc.trailingPosInner.absVal + paddingTrailing;
                
            }
        }
        
        if (lsc.wrapContentHeight)
        {
            //如果同时设置上下边界则上下边界为最小的高度
            if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
            {
                if (pMaxWrapSize->height < sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom)
                    pMaxWrapSize->height = sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom;
            }
            
            //高度不依赖布局并且没有同时设置上下边距则参与最大高度计算。
            if ((sbvsc.heightSizeInner.dimeRelaVal.view != self) &&
                (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil))
            {
                if (pMaxWrapSize->height < sbvmyFrame.height + sbvsc.topPosInner.absVal + sbvsc.centerYPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom)
                    pMaxWrapSize->height = sbvmyFrame.height + sbvsc.topPosInner.absVal + sbvsc.centerYPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom;
                
                if (pMaxWrapSize->height < sbvmyFrame.bottom + sbvsc.bottomPosInner.absVal + paddingBottom)
                    pMaxWrapSize->height = sbvmyFrame.bottom + sbvsc.bottomPosInner.absVal + paddingBottom;
            }
        }
    }
    
    
}


@end

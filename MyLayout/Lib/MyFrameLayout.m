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
    CGFloat maxWidth = self.leftPadding;
    CGFloat maxHeight = self.topPadding;
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
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
            
            if (sbvl.wrapContentHeight && (sbvl.heightSizeInner.dimeVal != nil || (sbvl.topPosInner.posVal != nil && sbvl.bottomPosInner.posVal != nil)))
            {
                [sbvl mySetWrapContentHeightNoLayout:NO];
            }
            
            if (sbvl.wrapContentWidth && (sbvl.widthSizeInner.dimeVal != nil || (sbvl.leftPosInner.posVal != nil && sbvl.rightPosInner.posVal != nil)))
            {
                [sbvl mySetWrapContentWidthNoLayout:NO];
            }
            
            
            if (pHasSubLayout != nil && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                *pHasSubLayout = YES;
            
            if (isEstimate && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
            {
               [sbvl estimateLayoutRect:sbvl.myFrame.frame.size inSizeClass:sizeClass];
                sbvl.myFrame.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
        }
        
    
        //计算自己的位置和高宽
        CGRect rect = sbv.myFrame.frame;
        [self myCalcSubView:sbv pRect:&rect inSize:selfSize];
        sbv.myFrame.frame = rect;
        
        if (sbv.widthSizeInner.dimeRelaVal == nil || sbv.widthSizeInner.dimeRelaVal != self.widthSizeInner)
        {
            if (maxWidth < CGRectGetMaxX(rect))
                maxWidth = CGRectGetMaxX(rect);
        }
        
        if (sbv.heightSizeInner.dimeRelaVal == nil || sbv.heightSizeInner.dimeRelaVal != self.heightSizeInner)
        {
            if (maxHeight < CGRectGetMaxY(rect))
                maxHeight = CGRectGetMaxY(rect);
        }

    }
    
    if (self.wrapContentWidth)
    {
        selfSize.width = maxWidth + self.rightPadding;
    }
    
    if (self.wrapContentHeight)
    {
        selfSize.height = maxHeight + self.bottomPadding;
    }
    
    selfSize.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    //调整尺寸和父布局相等的视图的尺寸。
    if (self.wrapContentWidth || self.wrapContentHeight)
    {
        for (UIView *sbv in sbs)
        {
            if ((sbv.widthSizeInner.dimeRelaVal != nil && sbv.widthSizeInner.dimeRelaVal == self.widthSizeInner) ||
                (sbv.leftPosInner.posVal != nil && sbv.rightPosInner.posVal != nil) ||
                (sbv.heightSizeInner.dimeRelaVal != nil && sbv.heightSizeInner.dimeRelaVal == self.heightSizeInner) ||
                (sbv.topPosInner.posVal != nil && sbv.bottomPosInner.posVal != nil))
            {
                CGRect rect = sbv.myFrame.frame;
                [self myCalcSubView:sbv pRect:&rect inSize:selfSize];
                sbv.myFrame.frame = rect;
            }
            
        }
    }
    
       
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs];

}

-(id)createSizeClassInstance
{
    return [MyFrameLayoutViewSizeClass new];
}


#pragma mark -- Private Method


-(void)myCalcSubView:(UIView*)sbv pRect:(CGRect*)pRect inSize:(CGSize)selfSize
{
    
    MyGravity horz = MyGravity_Horz_Left;
    MyGravity vert = MyGravity_Vert_Top;
    
    if (sbv.leftPosInner.posVal != nil && sbv.rightPosInner.posVal != nil)
        horz = MyGravity_Horz_Fill;
    else if (sbv.centerXPosInner.posVal != nil)
        horz = MyGravity_Horz_Center;
    else if (sbv.rightPosInner.posVal != nil)
        horz = MyGravity_Horz_Right;
    else
        ;
    
    if (sbv.topPosInner.posVal != nil && sbv.bottomPosInner.posVal != nil)
        vert = MyGravity_Vert_Fill;
    else if (sbv.centerYPosInner.posVal != nil)
        vert = MyGravity_Vert_Center;
    else if (sbv.bottomPosInner.posVal != nil)
        vert = MyGravity_Vert_Bottom;
    else
        ;
    
    
    MyLayoutSize *sbvWidthSize = sbv.widthSizeInner;
    MyLayoutSize *sbvHeightSize = sbv.heightSizeInner;
    
    //优先用设定的宽度尺寸。
    if (sbvWidthSize.dimeNumVal != nil)
        pRect->size.width = sbvWidthSize.measure;
    
    if (sbvHeightSize.dimeNumVal != nil)
        pRect->size.height = sbvHeightSize.measure;
    
    if (sbvWidthSize.dimeRelaVal != nil && sbvWidthSize.dimeRelaVal.view != sbv)
    {
        if (sbvWidthSize.dimeRelaVal.view == self)
            pRect->size.width = [sbvWidthSize measureWith:(selfSize.width - self.leftPadding - self.rightPadding)];
        else
            pRect->size.width = [sbvWidthSize measureWith:sbvWidthSize.dimeRelaVal.view.estimatedRect.size.width];
    }
    
    if (sbvHeightSize.dimeRelaVal != nil && sbvHeightSize.dimeRelaVal.view != sbv)
    {
        if (sbvHeightSize.dimeRelaVal.view == self)
            pRect->size.height = [sbvHeightSize measureWith:(selfSize.height - self.topPadding - self.bottomPadding)];
        else
            pRect->size.height = [sbvHeightSize measureWith:sbvHeightSize.dimeRelaVal.view.estimatedRect.size.height];
        
    }
    
    pRect->size.width = [self myValidMeasure:sbvWidthSize sbv:sbv calcSize:pRect->size.width sbvSize:pRect->size selfLayoutSize:selfSize];
    
    
    [self myHorzGravity:horz selfSize:selfSize sbv:sbv rect:pRect];
    
    
    
    if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
    {
        pRect->size.height = [self myHeightFromFlexedHeightView:sbv inWidth:pRect->size.width];
        
    }
    
    pRect->size.height = [self myValidMeasure:sbvHeightSize sbv:sbv calcSize:pRect->size.height sbvSize:pRect->size selfLayoutSize:selfSize];
    
    
    [self myVertGravity:vert selfSize:selfSize sbv:sbv rect:pRect];
    
    
    if (sbvWidthSize.dimeRelaVal != nil && sbvWidthSize.dimeRelaVal.view == sbv && sbvWidthSize.dimeRelaVal.dime == MyGravity_Vert_Fill)
    {
        pRect->size.width = [sbvWidthSize measureWith:pRect->size.height];
        pRect->size.width = [self myValidMeasure:sbvWidthSize sbv:sbv calcSize:pRect->size.width sbvSize:pRect->size selfLayoutSize:selfSize];
        
        [self myHorzGravity:horz selfSize:selfSize sbv:sbv rect:pRect];
        
    }
    
    if (sbvHeightSize.dimeRelaVal != nil && sbvHeightSize.dimeRelaVal.view == sbv && sbvHeightSize.dimeRelaVal.dime == MyGravity_Horz_Fill)
    {
        pRect->size.height = [sbvHeightSize measureWith:pRect->size.width];
        
        if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            pRect->size.height = [self myHeightFromFlexedHeightView:sbv inWidth:pRect->size.width];
        }
        
        pRect->size.height = [self myValidMeasure:sbvHeightSize sbv:sbv calcSize:pRect->size.height sbvSize:pRect->size selfLayoutSize:selfSize];
        
        [self myVertGravity:vert selfSize:selfSize sbv:sbv rect:pRect];
        
        
    }
    
    
    
    
}


@end

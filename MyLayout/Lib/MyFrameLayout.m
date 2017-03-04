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


-(void)calcSubView:(UIView*)sbv pRect:(CGRect*)pRect inSize:(CGSize)selfSize
{
    
    MyMarginGravity horz = MyMarginGravity_Horz_Left;
    MyMarginGravity vert = MyMarginGravity_Vert_Top;
    
    if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
        horz = MyMarginGravity_Horz_Fill;
    else if (sbv.centerXPos.posVal != nil)
        horz = MyMarginGravity_Horz_Center;
    else if (sbv.rightPos.posVal != nil)
        horz = MyMarginGravity_Horz_Right;
    else
        ;
    
    if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
        vert = MyMarginGravity_Vert_Fill;
    else if (sbv.centerYPos.posVal != nil)
        vert = MyMarginGravity_Vert_Center;
    else if (sbv.bottomPos.posVal != nil)
        vert = MyMarginGravity_Vert_Bottom;
    else
        ;
    
    
    MyLayoutSize *sbvWidthDime = sbv.widthDime;
    MyLayoutSize *sbvHeightDime = sbv.heightDime;
     
    //优先用设定的宽度尺寸。
    if (sbvWidthDime.dimeNumVal != nil)
        pRect->size.width = sbvWidthDime.measure;
    
    if (sbvHeightDime.dimeNumVal != nil)
        pRect->size.height = sbvHeightDime.measure;
    
    if (sbvWidthDime.dimeRelaVal != nil && sbvWidthDime.dimeRelaVal.view != sbv)
    {
        if (sbvWidthDime.dimeRelaVal.view == self)
            pRect->size.width = [sbvWidthDime measureWith:(selfSize.width - self.leftPadding - self.rightPadding)];
        else
            pRect->size.width = [sbvWidthDime measureWith:sbvWidthDime.dimeRelaVal.view.estimatedRect.size.width];
    }
    
    if (sbvHeightDime.dimeRelaVal != nil && sbvHeightDime.dimeRelaVal.view != sbv)
    {
        if (sbvHeightDime.dimeRelaVal.view == self)
            pRect->size.height = [sbvHeightDime measureWith:(selfSize.height - self.topPadding - self.bottomPadding)];
        else
            pRect->size.height = [sbvHeightDime measureWith:sbvHeightDime.dimeRelaVal.view.estimatedRect.size.height];
        
    }
    
    pRect->size.width = [self validMeasure:sbvWidthDime sbv:sbv calcSize:pRect->size.width sbvSize:pRect->size selfLayoutSize:selfSize];
    
    
    [self horzGravity:horz selfSize:selfSize sbv:sbv rect:pRect];
   
    
    
    if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
    {
        pRect->size.height = [self heightFromFlexedHeightView:sbv inWidth:pRect->size.width];

    }
    
     pRect->size.height = [self validMeasure:sbvHeightDime sbv:sbv calcSize:pRect->size.height sbvSize:pRect->size selfLayoutSize:selfSize];
    
    
    [self vertGravity:vert selfSize:selfSize sbv:sbv rect:pRect];
    
    
    if (sbvWidthDime.dimeRelaVal != nil && sbvWidthDime.dimeRelaVal.view == sbv && sbvWidthDime.dimeRelaVal.dime == MyMarginGravity_Vert_Fill)
    {
        pRect->size.width = [sbvWidthDime measureWith:pRect->size.height];
        pRect->size.width = [self validMeasure:sbvWidthDime sbv:sbv calcSize:pRect->size.width sbvSize:pRect->size selfLayoutSize:selfSize];
    
        [self horzGravity:horz selfSize:selfSize sbv:sbv rect:pRect];
        
    }
    
    if (sbvHeightDime.dimeRelaVal != nil && sbvHeightDime.dimeRelaVal.view == sbv && sbvHeightDime.dimeRelaVal.dime == MyMarginGravity_Horz_Fill)
    {
        pRect->size.height = [sbvHeightDime measureWith:pRect->size.width];
        
        if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            pRect->size.height = [self heightFromFlexedHeightView:sbv inWidth:pRect->size.width];
        }
        
        pRect->size.height = [self validMeasure:sbvHeightDime sbv:sbv calcSize:pRect->size.height sbvSize:pRect->size selfLayoutSize:selfSize];
        
        [self vertGravity:vert selfSize:selfSize sbv:sbv rect:pRect];


    }

    
 
    
}

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray *)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    CGFloat maxWidth = self.leftPadding;
    CGFloat maxHeight = self.topPadding;
    
    if (sbs == nil)
        sbs = [self getLayoutSubviews];
    
    for (UIView *sbv in sbs)
    {
        
        if (!isEstimate)
        {
            sbv.myFrame.frame = sbv.bounds;
            [self calcSizeOfWrapContentSubview:sbv selfLayoutSize:selfSize];
        }

        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
            
            if (sbvl.wrapContentHeight && (sbvl.heightDime.dimeVal != nil || (sbvl.topPos.posVal != nil && sbvl.bottomPos.posVal != nil)))
            {
                [sbvl setWrapContentHeightNoLayout:NO];
            }
            
            if (sbvl.wrapContentWidth && (sbvl.widthDime.dimeVal != nil || (sbvl.leftPos.posVal != nil && sbvl.rightPos.posVal != nil)))
            {
                [sbvl setWrapContentWidthNoLayout:NO];
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
        [self calcSubView:sbv pRect:&rect inSize:selfSize];
        sbv.myFrame.frame = rect;
        
        if (sbv.widthDime.dimeRelaVal != self.widthDime)
        {
            if (maxWidth < CGRectGetMaxX(rect))
                maxWidth = CGRectGetMaxX(rect);
        }
        
        if (sbv.heightDime.dimeRelaVal != self.heightDime)
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
    
    selfSize.height = [self validMeasure:self.heightDime sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self validMeasure:self.widthDime sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    //调整尺寸和父布局相等的视图的尺寸。
    if (self.wrapContentWidth || self.wrapContentHeight)
    {
        for (UIView *sbv in sbs)
        {
            if (sbv.widthDime.dimeRelaVal == self.widthDime ||
                (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil) ||
                sbv.heightDime.dimeRelaVal == self.heightDime ||
                (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil))
            {
                CGRect rect = sbv.myFrame.frame;
                [self calcSubView:sbv pRect:&rect inSize:selfSize];
                sbv.myFrame.frame = rect;
            }
            
        }
    }
    
       
    return [self adjustSizeWhenNoSubviews:selfSize sbs:sbs];

}

-(id)createSizeClassInstance
{
    return [MyFrameLayoutViewSizeClass new];
}

@end

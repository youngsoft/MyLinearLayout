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


@implementation UIView(MyFrameLayoutExt)


-(MyMarginGravity)marginGravity
{
    return self.myCurrentSizeClass.marginGravity;
}


-(void)setMarginGravity:(MyMarginGravity)marginGravity
{
    if (self.myCurrentSizeClass.marginGravity != marginGravity)
    {
        self.myCurrentSizeClass.marginGravity = marginGravity;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

@end

IB_DESIGNABLE
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
    
    MyMarginGravity gravity = sbv.marginGravity;
    MyMarginGravity vert = gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity horz = gravity & MyMarginGravity_Vert_Mask;
    
     
    //优先用设定的宽度尺寸。
    if (sbv.widthDime.dimeNumVal != nil)
        pRect->size.width = sbv.widthDime.measure;
    
    if (sbv.heightDime.dimeNumVal != nil)
        pRect->size.height = sbv.heightDime.measure;
    
    if (sbv.widthDime.dimeRelaVal != nil && sbv.widthDime.dimeRelaVal.view != sbv)
    {
        if (sbv.widthDime.dimeRelaVal.view == self)
            pRect->size.width = (selfSize.width - self.leftPadding - self.rightPadding) * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
        else
            pRect->size.width = sbv.widthDime.dimeRelaVal.view.estimatedRect.size.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
        pRect->size.width = [sbv.widthDime validMeasure:pRect->size.width];
    }
    
    if (sbv.heightDime.dimeRelaVal != nil && sbv.heightDime.dimeRelaVal.view != sbv)
    {
        if (sbv.heightDime.dimeRelaVal.view == self)
            pRect->size.height = (selfSize.height - self.topPadding - self.bottomPadding) * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        else
            pRect->size.height = sbv.heightDime.dimeRelaVal.view.estimatedRect.size.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        
        pRect->size.height = [sbv.heightDime validMeasure:pRect->size.height];
    }
    
   
    [self horzGravity:horz selfWidth:selfSize.width sbv:sbv rect:pRect];
   
    
    
    if (sbv.isFlexedHeight)
    {
        CGSize sz = [sbv sizeThatFits:CGSizeMake(pRect->size.width, 0)];
        pRect->size.height = [sbv.heightDime validMeasure:sz.height];
    }
    
    [self vertGravity:vert selfHeight:selfSize.height sbv:sbv rect:pRect];
    
    
    if (sbv.widthDime.dimeRelaVal != nil && sbv.widthDime.dimeRelaVal.view == sbv)
    {
        pRect->size.width =  pRect->size.height * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
        pRect->size.width = [sbv.widthDime validMeasure:pRect->size.width];
    }
    
    if (sbv.heightDime.dimeRelaVal != nil && sbv.heightDime.dimeRelaVal.view == sbv)
    {
        pRect->size.height = pRect->size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        pRect->size.height = [sbv.heightDime validMeasure:pRect->size.height];
        
        if (sbv.isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(pRect->size.width, 0)];
            pRect->size.height = [sbv.heightDime validMeasure:sz.height];
        }
    }

    
 
    
}

-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
{
    
    CGRect selfRect = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass];
    CGSize selfSize = selfRect.size;
    NSArray *sbs = self.subviews;
    CGFloat maxWidth = self.leftPadding;
    CGFloat maxHeight = self.topPadding;
    for (UIView *sbv in sbs)
    {
        
        if (sbv.useFrame)
            continue;
        
        CGRect rect;
    
        if (!isEstimate)
        {
            rect  = sbv.frame;
            
            //处理尺寸等于内容时并且需要添加额外尺寸的情况。
            if (sbv.widthDime.dimeSelfVal != nil || sbv.heightDime.dimeSelfVal != nil)
            {
                CGSize fitSize = [sbv sizeThatFits:CGSizeZero];
                if (sbv.widthDime.dimeSelfVal != nil)
                {
                    rect.size.width = [sbv.widthDime validMeasure:fitSize.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
                }
                
                if (sbv.heightDime.dimeSelfVal != nil)
                {
                    rect.size.height = [sbv.heightDime validMeasure:fitSize.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
                }
            }

            
        }
        else
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                if (pHasSubLayout != nil)
                    *pHasSubLayout = YES;
                
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                rect = [sbvl estimateLayoutRect:sbvl.absPos.frame.size inSizeClass:sizeClass];
                sbvl.absPos.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
            else
                rect = sbv.absPos.frame;
        }
        
        rect.size.height = [sbv.heightDime validMeasure:rect.size.height];
        rect.size.width  = [sbv.widthDime validMeasure:rect.size.width];
        
        //计算自己的位置和高宽
        [self calcSubView:sbv pRect:&rect inSize:selfSize];
        sbv.absPos.frame = rect;
        
        if ((sbv.marginGravity & MyMarginGravity_Vert_Mask) != MyMarginGravity_Horz_Fill && sbv.widthDime.dimeRelaVal != self.widthDime)
        {
            if (maxWidth < CGRectGetMaxX(rect))
                maxWidth = CGRectGetMaxX(rect);
        }
        
        if ((sbv.marginGravity & MyMarginGravity_Horz_Mask) != MyMarginGravity_Vert_Fill && sbv.heightDime.dimeRelaVal != self.heightDime)
        {
            if (maxHeight < CGRectGetMaxY(rect))
                maxHeight = CGRectGetMaxY(rect);
        }

    }
    
    if (self.wrapContentWidth)
    {
        selfRect.size.width = maxWidth + self.rightPadding;
    }
    
    if (self.wrapContentHeight)
    {
        selfRect.size.height = maxHeight + self.bottomPadding;
    }
    
    selfRect.size.height = [self.heightDime validMeasure:selfRect.size.height];
    selfRect.size.width = [self.widthDime validMeasure:selfRect.size.width];
    
    
    return selfRect;

}

@end

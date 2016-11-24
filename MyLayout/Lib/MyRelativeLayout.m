//
//  MyRelativeLayout.m
//  MyLayout
//
//  Created by oybq on 15/7/1.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyRelativeLayout.h"
#import "MyLayoutInner.h"


@implementation MyRelativeLayout

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(void)setFlexOtherViewWidthWhenSubviewHidden:(BOOL)flexOtherViewWidthWhenSubviewHidden
{
    MyRelativeLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.flexOtherViewWidthWhenSubviewHidden != flexOtherViewWidthWhenSubviewHidden)
    {
        lsc.flexOtherViewWidthWhenSubviewHidden = flexOtherViewWidthWhenSubviewHidden;
        [self setNeedsLayout];
    }
}

-(BOOL)flexOtherViewWidthWhenSubviewHidden
{
    return self.myCurrentSizeClass.flexOtherViewWidthWhenSubviewHidden;
}

-(void)setFlexOtherViewHeightWhenSubviewHidden:(BOOL)flexOtherViewHeightWhenSubviewHidden
{
    MyRelativeLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.flexOtherViewHeightWhenSubviewHidden != flexOtherViewHeightWhenSubviewHidden)
    {
        lsc.flexOtherViewHeightWhenSubviewHidden = flexOtherViewHeightWhenSubviewHidden;
        [self setNeedsLayout];
    }
}

-(BOOL)flexOtherViewHeightWhenSubviewHidden
{
    return self.myCurrentSizeClass.flexOtherViewHeightWhenSubviewHidden;
}


#pragma mark -- Private Method
-(void)calcSubViewLeftRight:(UIView*)sbv selfSize:(CGSize)selfSize
{
    
    
    //确定宽度，如果跟父一样宽则设置宽度和设置左右值，这时候三个参数设置完毕
    //如果和其他视图的宽度一样，则先计算其他视图的宽度并返回其他视图的宽度
    //如果没有指定宽度
    //检测左右设置。
    //如果设置了左右值则计算左右值。然后再计算宽度为两者之间的差
    //如果没有设置则宽度为width
    
    //检测是否有centerX，如果设置了centerX的值为父视图则左右值都设置OK，这时候三个参数完毕
    //如果不是父视图则计算其他视图的centerX的值。并返回位置，根据宽度设置后，三个参数完毕。
    
    //如果没有设置则计算左边的位置。
    
    //如果设置了左边，计算左边的值， 右边的值确定。
    
    //如果设置右边，则计算右边的值，左边的值确定。
    
    //如果都没有设置则，左边为左边距，右边为左边+宽度。
    
    //左右和宽度设置完毕。
    
    
    if (sbv.myFrame.leftPos != CGFLOAT_MAX && sbv.myFrame.rightPos != CGFLOAT_MAX && sbv.myFrame.width != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcWidth:sbv selfSize:selfSize])
        return;
    
    
    if (sbv.centerXPos.posRelaVal != nil)
    {
        UIView *relaView = sbv.centerXPos.posRelaVal.view;

        sbv.myFrame.leftPos = [self calcSubView:relaView gravity:sbv.centerXPos.posRelaVal.pos selfSize:selfSize] - sbv.myFrame.width / 2 + sbv.centerXPos.margin;
        
        if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
        {
            sbv.myFrame.leftPos -= sbv.centerXPos.margin;
        }

        sbv.myFrame.rightPos = sbv.myFrame.leftPos + sbv.myFrame.width;
        return;
    }
    else if (sbv.centerXPos.posNumVal != nil)
    {
        sbv.myFrame.leftPos = (selfSize.width - self.rightPadding - self.leftPadding - sbv.myFrame.width) / 2 + self.leftPadding + sbv.centerXPos.margin;
        sbv.myFrame.rightPos = sbv.myFrame.leftPos + sbv.myFrame.width;
        return;
    }
    else
    {
        if (sbv.leftPos.posRelaVal != nil)
        {
            UIView *relaView = sbv.leftPos.posRelaVal.view;
            
            sbv.myFrame.leftPos = [self calcSubView:relaView gravity:sbv.leftPos.posRelaVal.pos selfSize:selfSize] + sbv.leftPos.margin;
            
            if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
            {
                sbv.myFrame.leftPos -= sbv.leftPos.margin;
            }

            sbv.myFrame.rightPos = sbv.myFrame.leftPos + sbv.myFrame.width;
            return;
        }
        else if (sbv.leftPos.posNumVal != nil)
        {
            sbv.myFrame.leftPos = sbv.leftPos.margin + self.leftPadding;
            sbv.myFrame.rightPos = sbv.myFrame.leftPos + sbv.myFrame.width;
            return;
        }
        
        if (sbv.rightPos.posRelaVal != nil)
        {
            UIView *relaView = sbv.rightPos.posRelaVal.view;
            
            
            sbv.myFrame.rightPos = [self calcSubView:relaView gravity:sbv.rightPos.posRelaVal.pos selfSize:selfSize] - sbv.rightPos.margin + sbv.leftPos.margin;
            
            if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
            {
                sbv.myFrame.rightPos += sbv.rightPos.margin;
            }
            
            sbv.myFrame.leftPos = sbv.myFrame.rightPos - sbv.myFrame.width;
            
            return;
        }
        else if (sbv.rightPos.posNumVal != nil)
        {
            sbv.myFrame.rightPos = selfSize.width -  self.rightPadding -  sbv.rightPos.margin + sbv.leftPos.margin;
            sbv.myFrame.leftPos = sbv.myFrame.rightPos - sbv.myFrame.width;
            return;
        }
        
        sbv.myFrame.leftPos = sbv.leftPos.margin + self.leftPadding;
        sbv.myFrame.rightPos = sbv.myFrame.leftPos + sbv.myFrame.width;
        
    }
    
}

-(void)calcSubViewTopBottom:(UIView*)sbv selfSize:(CGSize)selfSize
{
    if (sbv.myFrame.topPos != CGFLOAT_MAX && sbv.myFrame.bottomPos != CGFLOAT_MAX && sbv.myFrame.height != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcHeight:sbv selfSize:selfSize])
        return;
    
    if (sbv.centerYPos.posRelaVal != nil)
    {
        UIView *relaView = sbv.centerYPos.posRelaVal.view;
        
        sbv.myFrame.topPos = [self calcSubView:relaView gravity:sbv.centerYPos.posRelaVal.pos selfSize:selfSize] - sbv.myFrame.height / 2 + sbv.centerYPos.margin;
        
        
        if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
        {
            sbv.myFrame.topPos -= sbv.centerYPos.margin;
        }

        
        
        sbv.myFrame.bottomPos = sbv.myFrame.topPos + sbv.myFrame.height;
        return;
    }
    else if (sbv.centerYPos.posNumVal != nil)
    {
        sbv.myFrame.topPos = (selfSize.height - self.topPadding - self.bottomPadding -  sbv.myFrame.height) / 2 + self.topPadding + sbv.centerYPos.margin;
        sbv.myFrame.bottomPos = sbv.myFrame.topPos + sbv.myFrame.height;
        return;
    }
    else
    {
        if (sbv.topPos.posRelaVal != nil)
        {
            UIView *relaView = sbv.topPos.posRelaVal.view;

            sbv.myFrame.topPos = [self calcSubView:relaView gravity:sbv.topPos.posRelaVal.pos selfSize:selfSize] + sbv.topPos.margin;
            
            if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
            {
                sbv.myFrame.topPos -= sbv.topPos.margin;
            }
            
            sbv.myFrame.bottomPos = sbv.myFrame.topPos + sbv.myFrame.height;
            return;
        }
        else if (sbv.topPos.posNumVal != nil)
        {
            sbv.myFrame.topPos = sbv.topPos.margin;
            sbv.myFrame.bottomPos = sbv.myFrame.topPos + sbv.myFrame.height;
            return;
        }
        
        if (sbv.bottomPos.posRelaVal != nil)
        {
            UIView *relaView = sbv.bottomPos.posRelaVal.view;
            
            sbv.myFrame.bottomPos = [self calcSubView:relaView gravity:sbv.bottomPos.posRelaVal.pos selfSize:selfSize] - sbv.bottomPos.margin + sbv.topPos.margin;
            
            if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
            {
                sbv.myFrame.bottomPos += sbv.bottomPos.margin;
            }
            
            sbv.myFrame.topPos = sbv.myFrame.bottomPos - sbv.myFrame.height;
            
            return;
        }
        else if (sbv.bottomPos.posNumVal != nil)
        {
            sbv.myFrame.bottomPos = selfSize.height -  sbv.bottomPos.margin - self.bottomPadding + sbv.topPos.margin;
            sbv.myFrame.topPos = sbv.myFrame.bottomPos - sbv.myFrame.height;
            return;
        }
        
        sbv.myFrame.topPos = sbv.topPos.margin + self.topPadding;
        sbv.myFrame.bottomPos = sbv.myFrame.topPos + sbv.myFrame.height;
        
    }
    
}



-(CGFloat)calcSubView:(UIView*)sbv gravity:(MyMarginGravity)gravity selfSize:(CGSize)selfSize
{
    switch (gravity) {
        case MyMarginGravity_Horz_Left:
        {
            if (sbv == self || sbv == nil)
                return self.leftPadding;
            
            
            if (sbv.myFrame.leftPos != CGFLOAT_MAX)
                return sbv.myFrame.leftPos;
            
            [self calcSubViewLeftRight:sbv selfSize:selfSize];
            
            return sbv.myFrame.leftPos;
            
        }
            break;
        case MyMarginGravity_Horz_Right:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - self.rightPadding;
            
            if (sbv.myFrame.rightPos != CGFLOAT_MAX)
                return sbv.myFrame.rightPos;
            
            [self calcSubViewLeftRight:sbv selfSize:selfSize];
            
            return sbv.myFrame.rightPos;
            
        }
            break;
        case MyMarginGravity_Vert_Top:
        {
            if (sbv == self || sbv == nil)
                return self.topPadding;
            
            
            if (sbv.myFrame.topPos != CGFLOAT_MAX)
                return sbv.myFrame.topPos;
            
            [self calcSubViewTopBottom:sbv selfSize:selfSize];
            
            return sbv.myFrame.topPos;
            
        }
            break;
        case MyMarginGravity_Vert_Bottom:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - self.bottomPadding;
            
            
            if (sbv.myFrame.bottomPos != CGFLOAT_MAX)
                return sbv.myFrame.bottomPos;
            
            [self calcSubViewTopBottom:sbv selfSize:selfSize];
            
            return sbv.myFrame.bottomPos;
        }
            break;
        case MyMarginGravity_Horz_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - self.leftPadding - self.rightPadding;
            
            
            if (sbv.myFrame.width != CGFLOAT_MAX)
                return sbv.myFrame.width;
            
            [self calcSubViewLeftRight:sbv selfSize:selfSize];
            
            return sbv.myFrame.width;
            
        }
            break;
        case MyMarginGravity_Vert_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - self.topPadding - self.bottomPadding;
            
            
            if (sbv.myFrame.height != CGFLOAT_MAX)
                return sbv.myFrame.height;
            
            [self calcSubViewTopBottom:sbv selfSize:selfSize];
            
            return sbv.myFrame.height;
        }
            break;
        case MyMarginGravity_Horz_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.width - self.leftPadding - self.rightPadding) / 2 + self.leftPadding;
            
            if (sbv.myFrame.leftPos != CGFLOAT_MAX && sbv.myFrame.rightPos != CGFLOAT_MAX &&  sbv.myFrame.width != CGFLOAT_MAX)
                return sbv.myFrame.leftPos + sbv.myFrame.width / 2;
            
            [self calcSubViewLeftRight:sbv selfSize:selfSize];
            
            return sbv.myFrame.leftPos + sbv.myFrame.width / 2;
            
        }
            break;
            
        case MyMarginGravity_Vert_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.height - self.topPadding - self.bottomPadding) / 2 + self.topPadding;
            
            if (sbv.myFrame.topPos != CGFLOAT_MAX && sbv.myFrame.bottomPos != CGFLOAT_MAX &&  sbv.myFrame.height != CGFLOAT_MAX)
                return sbv.myFrame.topPos + sbv.myFrame.height / 2;
            
            [self calcSubViewTopBottom:sbv selfSize:selfSize];
            
            return sbv.myFrame.topPos + sbv.myFrame.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)calcWidth:(UIView*)sbv selfSize:(CGSize)selfSize
{
    if (sbv.myFrame.width == CGFLOAT_MAX)
    {
        
        if (sbv.widthDime.dimeRelaVal != nil)
        {
            
            sbv.myFrame.width = [self calcSubView:sbv.widthDime.dimeRelaVal.view gravity:sbv.widthDime.dimeRelaVal.dime selfSize:selfSize] * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            
            sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:sbv.myFrame.width sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbv.widthDime.dimeNumVal != nil)
        {
            sbv.myFrame.width = sbv.widthDime.dimeNumVal.doubleValue * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:sbv.myFrame.width sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self isNoLayoutSubview:sbv])
        {
            sbv.myFrame.width = 0;
        }
        
        if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
        {
            if (sbv.leftPos.posRelaVal != nil)
                sbv.myFrame.leftPos = [self calcSubView:sbv.leftPos.posRelaVal.view gravity:sbv.leftPos.posRelaVal.pos selfSize:selfSize] + sbv.leftPos.margin;
            else
                sbv.myFrame.leftPos = sbv.leftPos.margin + self.leftPadding;
            
            if (sbv.rightPos.posRelaVal != nil)
                sbv.myFrame.rightPos = [self calcSubView:sbv.rightPos.posRelaVal.view gravity:sbv.rightPos.posRelaVal.pos selfSize:selfSize] - sbv.rightPos.margin;
            else
                sbv.myFrame.rightPos = selfSize.width - sbv.rightPos.margin - self.rightPadding;
            
            sbv.myFrame.width = sbv.myFrame.rightPos - sbv.myFrame.leftPos;
            sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:sbv.myFrame.width sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self isNoLayoutSubview:sbv])
            {
                sbv.myFrame.width = 0;
                sbv.myFrame.rightPos = sbv.myFrame.leftPos + sbv.myFrame.width;
            }

            
            return YES;
            
        }
        
        
        if (sbv.myFrame.width == CGFLOAT_MAX)
        {
            sbv.myFrame.width = CGRectGetWidth(sbv.bounds);
            sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:sbv.myFrame.width sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
        }
    }
    
    if (sbv.widthDime.lBoundVal.dimeNumVal.doubleValue != -CGFLOAT_MAX || sbv.widthDime.uBoundVal.dimeNumVal.doubleValue != CGFLOAT_MAX)
    {
        sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:sbv.myFrame.width sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
    }

    
    return NO;
}


-(BOOL)calcHeight:(UIView*)sbv selfSize:(CGSize)selfSize
{
    if (sbv.myFrame.height == CGFLOAT_MAX)
    {
        if (sbv.heightDime.dimeRelaVal != nil)
        {
            
            sbv.myFrame.height = [self calcSubView:sbv.heightDime.dimeRelaVal.view gravity:sbv.heightDime.dimeRelaVal.dime selfSize:selfSize] * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            
            sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbv.heightDime.dimeNumVal != nil)
        {
            sbv.myFrame.height = sbv.heightDime.dimeNumVal.doubleValue * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self isNoLayoutSubview:sbv])
        {
            sbv.myFrame.height = 0;
        }

        
        if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
        {
            if (sbv.topPos.posRelaVal != nil)
                sbv.myFrame.topPos = [self calcSubView:sbv.topPos.posRelaVal.view gravity:sbv.topPos.posRelaVal.pos selfSize:selfSize] + sbv.topPos.margin;
            else
                sbv.myFrame.topPos = sbv.topPos.margin + self.topPadding;
            
            if (sbv.bottomPos.posRelaVal != nil)
                sbv.myFrame.bottomPos = [self calcSubView:sbv.bottomPos.posRelaVal.view gravity:sbv.bottomPos.posRelaVal.pos selfSize:selfSize] - sbv.bottomPos.margin;
            else
                sbv.myFrame.bottomPos = selfSize.height - sbv.bottomPos.margin - self.bottomPadding;
            
            sbv.myFrame.height = sbv.myFrame.bottomPos - sbv.myFrame.topPos;
            sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self isNoLayoutSubview:sbv])
            {
                sbv.myFrame.height = 0;
                sbv.myFrame.bottomPos = sbv.myFrame.topPos + sbv.myFrame.height;
            }
            

            return YES;
            
        }
        
        
        if (sbv.myFrame.height == CGFLOAT_MAX)
        {
           sbv.myFrame.height = CGRectGetHeight(sbv.bounds);
            sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
        }
    }
    
    if (sbv.heightDime.lBoundVal.dimeNumVal.doubleValue != -CGFLOAT_MAX || sbv.heightDime.uBoundVal.dimeNumVal.doubleValue != CGFLOAT_MAX)
    {
        sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
    }
    
    return NO;
    
}


-(CGSize)calcLayout:(BOOL*)pRecalc selfSize:(CGSize)selfSize
{
    *pRecalc = NO;
    
    
    //遍历所有子视图，算出所有宽度和高度根据自身内容确定的子视图的尺寸.以及计算出那些有依赖关系的尺寸限制。。。
    for (UIView *sbv in self.subviews)
    {
        [self calcSizeOfWrapContentSubview:sbv selfLayoutSize:selfSize];
        
        if (sbv.myFrame.width != CGFLOAT_MAX)
        {
            if (sbv.widthDime.uBoundVal.dimeRelaVal != nil && sbv.widthDime.uBoundVal.dimeRelaVal.view != self)
            {
                [self calcWidth:sbv.widthDime.uBoundVal.dimeRelaVal.view selfSize:selfSize];
            }
            
            if (sbv.widthDime.lBoundVal.dimeRelaVal != nil && sbv.widthDime.lBoundVal.dimeRelaVal.view != self)
            {
                [self calcWidth:sbv.widthDime.lBoundVal.dimeRelaVal.view selfSize:selfSize];
            }
            
            sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:sbv.myFrame.width sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
        }
        
        if (sbv.myFrame.height != CGFLOAT_MAX)
        {
            if (sbv.heightDime.uBoundVal.dimeRelaVal != nil && sbv.heightDime.uBoundVal.dimeRelaVal.view != self)
            {
                [self calcHeight:sbv.heightDime.uBoundVal.dimeRelaVal.view selfSize:selfSize];
            }
            
            if (sbv.heightDime.lBoundVal.dimeRelaVal != nil && sbv.heightDime.lBoundVal.dimeRelaVal.view != self)
            {
                [self calcHeight:sbv.heightDime.lBoundVal.dimeRelaVal.view selfSize:selfSize];
            }
            
            sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
        }
        
    }
    
    //均分宽度和高度。把这部分提出来是为了实现不管数组是哪个视图指定都可以。
    for (UIView *sbv in self.subviews)
    {
        
        if (sbv.widthDime.dimeArrVal != nil)
        {
            *pRecalc = YES;
            
            NSArray *dimeArray = sbv.widthDime.dimeArrVal;
            
            BOOL isViewHidden = [self isNoLayoutSubview:sbv] && self.flexOtherViewWidthWhenSubviewHidden;
            CGFloat totalMutil = isViewHidden ? 0 : sbv.widthDime.mutilVal;
            CGFloat totalAdd =  isViewHidden ? 0 : sbv.widthDime.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                isViewHidden = [self isNoLayoutSubview:dime.view] && self.flexOtherViewWidthWhenSubviewHidden;
                if (!isViewHidden)
                {
                    if (dime.dimeNumVal != nil)
                        totalAdd += -1 * dime.dimeNumVal.doubleValue;
                    else if (dime.dimeSelfVal != nil)
                    {
                        totalAdd += -1 * dime.view.myFrame.width;
                    }
                    else
                        totalMutil += dime.mutilVal;
                    
                    totalAdd += dime.addVal;
                    
                }
                
                
            }
            
            CGFloat floatWidth = selfSize.width - self.leftPadding - self.rightPadding + totalAdd;
            if (/*floatWidth <= 0*/ _myCGFloatLessOrEqual(floatWidth, 0))
                floatWidth = 0;
            
            if (totalMutil != 0)
            {
                sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:floatWidth * (sbv.widthDime.mutilVal / totalMutil) sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self isNoLayoutSubview:sbv])
                    sbv.myFrame.width = 0;
                
                for (MyLayoutSize *dime in dimeArray) {
                    
                    if (dime.dimeNumVal == nil)
                        dime.view.myFrame.width = floatWidth * (dime.mutilVal / totalMutil);
                    else
                        dime.view.myFrame.width = dime.dimeNumVal.doubleValue;
                    
                    dime.view.myFrame.width = [self validMeasure:dime.view.widthDime sbv:dime.view calcSize:dime.view.myFrame.width sbvSize:dime.view.myFrame.frame.size selfLayoutSize:selfSize];
                    
                    if ([self isNoLayoutSubview:dime.view])
                        dime.view.myFrame.width = 0;
                }
            }
        }
        
        if (sbv.heightDime.dimeArrVal != nil)
        {
            *pRecalc = YES;
            
            NSArray *dimeArray = sbv.heightDime.dimeArrVal;
            
            BOOL isViewHidden = [self isNoLayoutSubview:sbv] && self.flexOtherViewHeightWhenSubviewHidden;
            
            CGFloat totalMutil = isViewHidden ? 0 : sbv.heightDime.mutilVal;
            CGFloat totalAdd = isViewHidden ? 0 : sbv.heightDime.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                 isViewHidden = [self isNoLayoutSubview:dime.view] && self.flexOtherViewHeightWhenSubviewHidden;
                if (!isViewHidden)
                {
                    if (dime.dimeNumVal != nil)
                        totalAdd += -1 * dime.dimeNumVal.doubleValue;
                    else if (dime.dimeSelfVal != nil)
                    {
                        totalAdd += -1 *dime.view.myFrame.height;
                    }
                    else
                        totalMutil += dime.mutilVal;
                    
                    totalAdd += dime.addVal;
                }
                
            }
            
            CGFloat floatHeight = selfSize.height - self.topPadding - self.bottomPadding + totalAdd;
            if (/*floatHeight <= 0*/ _myCGFloatLessOrEqual(floatHeight, 0))
                floatHeight = 0;
            
            if (totalMutil != 0)
            {
                sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:floatHeight * (sbv.heightDime.mutilVal / totalMutil) sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self isNoLayoutSubview:sbv])
                    sbv.myFrame.height = 0;
                
                for (MyLayoutSize *dime in dimeArray) {
                    
                    if (dime.dimeNumVal == nil)
                        dime.view.myFrame.height = floatHeight * (dime.mutilVal / totalMutil);
                    else
                        dime.view.myFrame.height = dime.dimeNumVal.doubleValue;
                    
                    dime.view.myFrame.height = [self validMeasure:dime.view.heightDime sbv:dime.view calcSize:dime.view.myFrame.height sbvSize:dime.view.myFrame.frame.size selfLayoutSize:selfSize];
                    
                    if ([self isNoLayoutSubview:dime.view])
                        dime.view.myFrame.height = 0;
                }
            }
        }
        
        
        //表示视图数组水平居中
        if (sbv.centerXPos.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *centerArray = sbv.centerXPos.posArrVal;
            
            CGFloat totalWidth = 0;
            CGFloat totalOffset = 0;
            
            MyLayoutPos *nextPos = nil;
            for (NSInteger i = centerArray.count - 1; i >= 0; i--)
            {
                MyLayoutPos *pos = centerArray[i];
                if (![self isNoLayoutSubview:pos.view])
                {
                    if (totalWidth != 0)
                    {
                        if (nextPos != nil)
                            totalOffset += nextPos.view.centerXPos.margin;
                    }
                    
                    [self calcWidth:pos.view selfSize:selfSize];
                    totalWidth += pos.view.myFrame.width;
                }
                
                nextPos = pos;
            }
            
            if (![self isNoLayoutSubview:sbv])
            {
                if (totalWidth != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerXPos.margin;
                }
                
                [self calcWidth:sbv selfSize:selfSize];
                totalWidth += sbv.myFrame.width;
                totalOffset += sbv.centerXPos.margin;
            }
            
            
            //所有宽度算出后，再分别设置
            CGFloat leftOffset = (selfSize.width - self.leftPadding - self.rightPadding - totalWidth - totalOffset) / 2;
            leftOffset += self.leftPadding;
            
            id prev = @(leftOffset);
            [sbv.leftPos __equalTo:prev];
            prev = sbv.rightPos;
            for (MyLayoutPos *pos in centerArray)
            {
                [[pos.view.leftPos __equalTo:prev] __offset:pos.view.centerXPos.margin];
                prev = pos.view.rightPos;
            }
        }
        
        //表示视图数组垂直居中
        if (sbv.centerYPos.posArrVal != nil)
        {
            NSArray *centerArray = sbv.centerYPos.posArrVal;
            
            CGFloat totalHeight = 0;
            CGFloat totalOffset = 0;
            
            MyLayoutPos *nextPos = nil;
            for (NSInteger i = centerArray.count - 1; i >= 0; i--)
            {
                MyLayoutPos *pos = centerArray[i];
                if (![self isNoLayoutSubview:pos.view])
                {
                    if (totalHeight != 0)
                    {
                        if (nextPos != nil)
                            totalOffset += nextPos.view.centerYPos.margin;
                    }
                    
                    [self calcHeight:pos.view selfSize:selfSize];
                    totalHeight += pos.view.myFrame.height;
                }
                
                nextPos = pos;
            }
            
            if (![self isNoLayoutSubview:sbv])
            {
                if (totalHeight != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerYPos.margin;
                }
                
                [self calcHeight:sbv selfSize:selfSize];
                totalHeight += sbv.myFrame.height;
                totalOffset += sbv.centerYPos.margin;
            }
            
            
            //所有宽度算出后，再分别设置
            CGFloat topOffset = (selfSize.height - self.topPadding - self.bottomPadding - totalHeight - totalOffset) / 2;
            topOffset += self.topPadding;
            
            id prev = @(topOffset);
            [sbv.topPos __equalTo:prev];
            prev = sbv.bottomPos;
            for (MyLayoutPos *pos in centerArray)
            {
                [[pos.view.topPos __equalTo:prev] __offset:pos.view.centerYPos.margin];
                prev = pos.view.bottomPos;
            }

        }
        
        
    }
    
    //计算最大的宽度和高度
    CGFloat maxWidth = self.leftPadding;
    CGFloat maxHeight = self.topPadding;
    
    for (UIView *sbv in self.subviews)
    {
        
        BOOL canCalcMaxWidth = YES;
        BOOL canCalcMaxHeight = YES;
        
        [self calcSubViewLeftRight:sbv selfSize:selfSize];
        
        if (sbv.rightPos.posRelaVal != nil && sbv.rightPos.posRelaVal.view == self)
        {
            *pRecalc = YES;
        }
        
        if (sbv.widthDime.dimeRelaVal != nil && sbv.widthDime.dimeRelaVal.view == self)
        {
            canCalcMaxWidth = NO;
            *pRecalc = YES;
        }
        
        if (sbv.leftPos.posRelaVal != nil && sbv.leftPos.posRelaVal.view == self &&
            sbv.rightPos.posRelaVal != nil && sbv.rightPos.posRelaVal.view == self)
        {
            canCalcMaxWidth = NO;
        }
        
        
        if (sbv.isFlexedHeight)
        {
            sbv.myFrame.height = [self heightFromFlexedHeightView:sbv inWidth:sbv.myFrame.width];
        }
        
        [self calcSubViewTopBottom:sbv selfSize:selfSize];
        
        if (sbv.bottomPos.posRelaVal != nil && sbv.bottomPos.posRelaVal.view == self)
            *pRecalc = YES;
        
        if (sbv.heightDime.dimeRelaVal != nil && sbv.heightDime.dimeRelaVal.view == self)
        {
            *pRecalc = YES;
            canCalcMaxHeight = NO;
        }
        
        if (sbv.topPos.posRelaVal != nil && sbv.topPos.posRelaVal.view == self &&
            sbv.bottomPos.posRelaVal != nil && sbv.bottomPos.posRelaVal.view == self)
        {
            canCalcMaxHeight = NO;
        }
        
        
        if ([self isNoLayoutSubview:sbv])
            continue;
        
        if (canCalcMaxWidth &&  maxWidth < sbv.myFrame.rightPos + sbv.rightPos.margin)
            maxWidth = sbv.myFrame.rightPos + sbv.rightPos.margin;
        
        if (canCalcMaxHeight && maxHeight < sbv.myFrame.bottomPos + sbv.bottomPos.margin)
            maxHeight = sbv.myFrame.bottomPos + sbv.bottomPos.margin;
    }
    
    maxWidth += self.rightPadding;
    maxHeight += self.bottomPadding;
    
    return CGSizeMake(maxWidth, maxHeight);
    
}

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass];
    
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame)
            continue;
        
        if (!isEstimate || (pHasSubLayout != nil && (*pHasSubLayout) == YES))
            [sbv.myFrame reset];
        
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
           
            MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
            
            if (sbvl.wrapContentWidth)
            {
                //只要同时设置了左右边距或者设置了宽度则应该把wrapContentWidth置为NO
                if ((sbvl.leftPos.posVal != nil && sbvl.rightPos.posVal != nil) || sbvl.widthDime.dimeVal != nil)
                    [sbvl setWrapContentWidthNoLayout:NO];
            }
            
            if (sbvl.wrapContentHeight)
            {
                if ((sbvl.topPos.posVal != nil && sbvl.bottomPos.posVal != nil) || sbvl.heightDime.dimeVal != nil)
                    [sbvl setWrapContentHeightNoLayout:NO];
            }
            
            if (pHasSubLayout != nil && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                *pHasSubLayout = YES;
            
            if (isEstimate && (sbvl.wrapContentWidth || sbvl.wrapContentHeight))
            {
                [sbvl estimateLayoutRect:sbvl.myFrame.frame.size inSizeClass:sizeClass];
                
                sbvl.myFrame.leftPos = sbvl.myFrame.rightPos = sbvl.myFrame.topPos = sbvl.myFrame.bottomPos = CGFLOAT_MAX;
                
                sbvl.myFrame.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
        }
    }
    
    
    BOOL reCalc = NO;
    CGSize maxSize = [self calcLayout:&reCalc selfSize:selfSize];
    
    if (self.wrapContentWidth || self.wrapContentHeight)
    {
        if (/*selfSize.height != maxSize.height*/_myCGFloatNotEqual(selfSize.height, maxSize.height)  || /*selfSize.width != maxSize.width*/ _myCGFloatNotEqual(selfSize.width, maxSize.width))
        {
            
            if (self.wrapContentWidth)
            {
                selfSize.width = maxSize.width;
            }
            
            if (self.wrapContentHeight)
            {
                selfSize.height = maxSize.height;
            }
            
            //如果里面有需要重新计算的就重新计算布局
            if (reCalc)
            {
                for (UIView *sbv in self.subviews)
                {
                    //如果是布局视图则不清除尺寸，其他清除。
                    if (isEstimate  && [sbv isKindOfClass:[MyBaseLayout class]])
                    {
                        sbv.myFrame.leftPos = sbv.myFrame.rightPos = sbv.myFrame.topPos = sbv.myFrame.bottomPos = CGFLOAT_MAX;
                    }
                    else
                        [sbv.myFrame reset];
                }
                
                [self calcLayout:&reCalc selfSize:selfSize];
            }
        }
        
    }
    
    selfSize.height = [self validMeasure:self.heightDime sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self validMeasure:self.widthDime sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    return selfSize;
    
}

-(id)createSizeClassInstance
{
    return [MyRelativeLayoutViewSizeClass new];
}


@end

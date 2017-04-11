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

#pragma mark -- Override Method

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
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
                if ((sbvl.leftPosInner.posVal != nil && sbvl.rightPosInner.posVal != nil) || sbvl.widthSizeInner.dimeVal != nil)
                    [sbvl mySetWrapContentWidthNoLayout:NO];
            }
            
            if (sbvl.wrapContentHeight)
            {
                if ((sbvl.topPosInner.posVal != nil && sbvl.bottomPosInner.posVal != nil) || sbvl.heightSizeInner.dimeVal != nil)
                    [sbvl mySetWrapContentHeightNoLayout:NO];
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
    CGSize maxSize = [self myCalcLayout:&reCalc selfSize:selfSize];
    
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
                
                [self myCalcLayout:&reCalc selfSize:selfSize];
            }
        }
        
    }
    
    selfSize.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:[self myGetLayoutSubviews]];
    
}

-(id)createSizeClassInstance
{
    return [MyRelativeLayoutViewSizeClass new];
}



#pragma mark -- Private Method
-(void)myCalcSubViewLeftRight:(UIView*)sbv selfSize:(CGSize)selfSize
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
    
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyLayoutPos *sbvLeftPos = sbv.leftPosInner;
    MyLayoutPos *sbvRightPos = sbv.rightPosInner;
    MyLayoutPos *sbvCenterXPos = sbv.centerXPosInner;
    
    
    
    if (sbvmyFrame.leftPos != CGFLOAT_MAX && sbvmyFrame.rightPos != CGFLOAT_MAX && sbvmyFrame.width != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self myCalcWidth:sbv selfSize:selfSize])
        return;
    
    
    if (sbvCenterXPos.posRelaVal != nil)
    {
        UIView *relaView = sbvCenterXPos.posRelaVal.view;
        
        sbvmyFrame.leftPos = [self myCalcSubView:relaView gravity:sbvCenterXPos.posRelaVal.pos selfSize:selfSize] - sbvmyFrame.width / 2 + sbvCenterXPos.margin;
        
        if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
        {
            sbvmyFrame.leftPos -= sbvCenterXPos.margin;
        }
        
        sbvmyFrame.rightPos = sbvmyFrame.leftPos + sbvmyFrame.width;
    }
    else if (sbvCenterXPos.posNumVal != nil)
    {
        sbvmyFrame.leftPos = (selfSize.width - self.rightPadding - self.leftPadding - sbvmyFrame.width) / 2 + self.leftPadding + sbvCenterXPos.margin;
        sbvmyFrame.rightPos = sbvmyFrame.leftPos + sbvmyFrame.width;
    }
    else
    {
        //如果左右都设置了则上上面的calcWidth会直接返回不会进入这个流程。
        if (sbvLeftPos.posRelaVal != nil)
        {
            UIView *relaView = sbvLeftPos.posRelaVal.view;
            
            sbvmyFrame.leftPos = [self myCalcSubView:relaView gravity:sbvLeftPos.posRelaVal.pos selfSize:selfSize] + sbvLeftPos.margin;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvmyFrame.leftPos -= sbvLeftPos.margin;
            }
            
            sbvmyFrame.rightPos = sbvmyFrame.leftPos + sbvmyFrame.width;
        }
        else if (sbvLeftPos.posNumVal != nil)
        {
            sbvmyFrame.leftPos = sbvLeftPos.margin + self.leftPadding;
            sbvmyFrame.rightPos = sbvmyFrame.leftPos + sbvmyFrame.width;
        }
        else if (sbvRightPos.posRelaVal != nil)
        {
            UIView *relaView = sbvRightPos.posRelaVal.view;
            
            
            sbvmyFrame.rightPos = [self myCalcSubView:relaView gravity:sbvRightPos.posRelaVal.pos selfSize:selfSize] - sbvRightPos.margin + sbvLeftPos.margin;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvmyFrame.rightPos += sbvRightPos.margin;
            }
            
            sbvmyFrame.leftPos = sbvmyFrame.rightPos - sbvmyFrame.width;
            
        }
        else if (sbvRightPos.posNumVal != nil)
        {
            sbvmyFrame.rightPos = selfSize.width -  self.rightPadding -  sbvRightPos.margin + sbvLeftPos.margin;
            sbvmyFrame.leftPos = sbvmyFrame.rightPos - sbvmyFrame.width;
        }
        else
        {
            sbvmyFrame.leftPos = sbvLeftPos.margin + self.leftPadding;
            sbvmyFrame.rightPos = sbvmyFrame.leftPos + sbvmyFrame.width;
        }
        
    }
    
    //这里要更新左边最小和右边最大约束的情况。
    
    if (sbvLeftPos.lBoundValInner.posRelaVal != nil && sbvRightPos.uBoundValInner.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minLeft = [self myCalcSubView:sbvLeftPos.lBoundValInner.posRelaVal.view gravity:sbvLeftPos.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvLeftPos.lBoundValInner.offsetVal;
        
        CGFloat   maxRight = [self myCalcSubView:sbvRightPos.uBoundValInner.posRelaVal.view gravity:sbvRightPos.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvRightPos.uBoundValInner.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        if (maxRight - minLeft < sbvmyFrame.width)
        {
            sbvmyFrame.width = maxRight - minLeft;
            sbvmyFrame.leftPos = minLeft;
        }
        else
        {
            sbvmyFrame.leftPos = (maxRight - minLeft - sbvmyFrame.width) / 2 + minLeft;
        }
        
        sbvmyFrame.rightPos = sbvmyFrame.leftPos + sbvmyFrame.width;
        
        
    }
    else if (sbvLeftPos.lBoundValInner.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minLeft = [self myCalcSubView:sbvLeftPos.lBoundValInner.posRelaVal.view gravity:sbvLeftPos.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvLeftPos.lBoundValInner.offsetVal;
        
        if (sbvmyFrame.leftPos < minLeft)
        {
            sbvmyFrame.leftPos = minLeft;
            sbvmyFrame.width = sbvmyFrame.rightPos - sbvmyFrame.leftPos;
        }
        
    }
    else if (sbvRightPos.uBoundValInner.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxRight = [self myCalcSubView:sbvRightPos.uBoundValInner.posRelaVal.view gravity:sbvRightPos.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvRightPos.uBoundValInner.offsetVal;
        if (sbvmyFrame.rightPos > maxRight)
        {
            sbvmyFrame.rightPos = maxRight;
            sbvmyFrame.width = sbvmyFrame.rightPos - sbvmyFrame.leftPos;
        }
        
    }
    
    
}

-(void)myCalcSubViewTopBottom:(UIView*)sbv selfSize:(CGSize)selfSize
{
    
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyLayoutPos *sbvTopPos = sbv.topPosInner;
    MyLayoutPos *sbvBottomPos = sbv.bottomPosInner;
    MyLayoutPos *sbvCenterYPos = sbv.centerYPosInner;
    
    
    if (sbvmyFrame.topPos != CGFLOAT_MAX && sbvmyFrame.bottomPos != CGFLOAT_MAX && sbvmyFrame.height != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self myCalcHeight:sbv selfSize:selfSize])
        return;
    
    if (sbvCenterYPos.posRelaVal != nil)
    {
        UIView *relaView = sbvCenterYPos.posRelaVal.view;
        
        sbvmyFrame.topPos = [self myCalcSubView:relaView gravity:sbvCenterYPos.posRelaVal.pos selfSize:selfSize] - sbvmyFrame.height / 2 + sbvCenterYPos.margin;
        
        
        if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
        {
            sbvmyFrame.topPos -= sbvCenterYPos.margin;
        }
        
        
        
        sbvmyFrame.bottomPos = sbvmyFrame.topPos + sbvmyFrame.height;
    }
    else if (sbvCenterYPos.posNumVal != nil)
    {
        sbvmyFrame.topPos = (selfSize.height - self.topPadding - self.bottomPadding -  sbvmyFrame.height) / 2 + self.topPadding + sbvCenterYPos.margin;
        sbvmyFrame.bottomPos = sbvmyFrame.topPos + sbvmyFrame.height;
    }
    else
    {
        if (sbvTopPos.posRelaVal != nil)
        {
            UIView *relaView = sbvTopPos.posRelaVal.view;
            
            sbvmyFrame.topPos = [self myCalcSubView:relaView gravity:sbvTopPos.posRelaVal.pos selfSize:selfSize] + sbvTopPos.margin;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvmyFrame.topPos -= sbvTopPos.margin;
            }
            
            sbvmyFrame.bottomPos = sbvmyFrame.topPos + sbvmyFrame.height;
        }
        else if (sbvTopPos.posNumVal != nil)
        {
            sbvmyFrame.topPos = sbvTopPos.margin + self.topPadding;
            sbvmyFrame.bottomPos = sbvmyFrame.topPos + sbvmyFrame.height;
        }
        else if (sbvBottomPos.posRelaVal != nil)
        {
            UIView *relaView = sbvBottomPos.posRelaVal.view;
            
            sbvmyFrame.bottomPos = [self myCalcSubView:relaView gravity:sbvBottomPos.posRelaVal.pos selfSize:selfSize] - sbvBottomPos.margin + sbvTopPos.margin;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvmyFrame.bottomPos += sbvBottomPos.margin;
            }
            
            sbvmyFrame.topPos = sbvmyFrame.bottomPos - sbvmyFrame.height;
            
        }
        else if (sbvBottomPos.posNumVal != nil)
        {
            sbvmyFrame.bottomPos = selfSize.height -  sbvBottomPos.margin - self.bottomPadding + sbvTopPos.margin;
            sbvmyFrame.topPos = sbvmyFrame.bottomPos - sbvmyFrame.height;
        }
        else
        {
            sbvmyFrame.topPos = sbvTopPos.margin + self.topPadding;
            sbvmyFrame.bottomPos = sbvmyFrame.topPos + sbvmyFrame.height;
        }
    }
    
    //这里要更新上边最小和下边最大约束的情况。
    if (sbvTopPos.lBoundValInner.posRelaVal != nil && sbvBottomPos.uBoundValInner.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minTop = [self myCalcSubView:sbvTopPos.lBoundValInner.posRelaVal.view gravity:sbvTopPos.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvTopPos.lBoundValInner.offsetVal;
        
        CGFloat   maxBottom = [self myCalcSubView:sbvBottomPos.uBoundValInner.posRelaVal.view gravity:sbvBottomPos.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvBottomPos.uBoundValInner.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        if (maxBottom - minTop < sbvmyFrame.height)
        {
            sbvmyFrame.height = maxBottom - minTop;
            sbvmyFrame.topPos = minTop;
        }
        else
        {
            sbvmyFrame.topPos = (maxBottom - minTop - sbvmyFrame.height) / 2 + minTop;
        }
        
        sbvmyFrame.bottomPos = sbvmyFrame.topPos + sbvmyFrame.height;
        
        
    }
    else if (sbvTopPos.lBoundValInner.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minTop = [self myCalcSubView:sbvTopPos.lBoundValInner.posRelaVal.view gravity:sbvTopPos.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvTopPos.lBoundValInner.offsetVal;
        
        if (sbvmyFrame.topPos < minTop)
        {
            sbvmyFrame.topPos = minTop;
            sbvmyFrame.height = sbvmyFrame.bottomPos - sbvmyFrame.topPos;
        }
        
    }
    else if (sbvBottomPos.uBoundValInner.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxBottom = [self myCalcSubView:sbvBottomPos.uBoundValInner.posRelaVal.view gravity:sbvBottomPos.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvBottomPos.uBoundValInner.offsetVal;
        if (sbvmyFrame.bottomPos > maxBottom)
        {
            sbvmyFrame.bottomPos = maxBottom;
            sbvmyFrame.height = sbvmyFrame.bottomPos - sbvmyFrame.topPos;
        }
        
    }
    
    
}



-(CGFloat)myCalcSubView:(UIView*)sbv gravity:(MyGravity)gravity selfSize:(CGSize)selfSize
{
    switch (gravity) {
        case MyGravity_Horz_Left:
        {
            if (sbv == self || sbv == nil)
                return self.leftPadding;
            
            
            if (sbv.myFrame.leftPos != CGFLOAT_MAX)
                return sbv.myFrame.leftPos;
            
            [self myCalcSubViewLeftRight:sbv selfSize:selfSize];
            
            return sbv.myFrame.leftPos;
            
        }
            break;
        case MyGravity_Horz_Right:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - self.rightPadding;
            
            if (sbv.myFrame.rightPos != CGFLOAT_MAX)
                return sbv.myFrame.rightPos;
            
            [self myCalcSubViewLeftRight:sbv selfSize:selfSize];
            
            return sbv.myFrame.rightPos;
            
        }
            break;
        case MyGravity_Vert_Top:
        {
            if (sbv == self || sbv == nil)
                return self.topPadding;
            
            
            if (sbv.myFrame.topPos != CGFLOAT_MAX)
                return sbv.myFrame.topPos;
            
            [self myCalcSubViewTopBottom:sbv selfSize:selfSize];
            
            return sbv.myFrame.topPos;
            
        }
            break;
        case MyGravity_Vert_Bottom:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - self.bottomPadding;
            
            
            if (sbv.myFrame.bottomPos != CGFLOAT_MAX)
                return sbv.myFrame.bottomPos;
            
            [self myCalcSubViewTopBottom:sbv selfSize:selfSize];
            
            return sbv.myFrame.bottomPos;
        }
            break;
        case MyGravity_Horz_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - self.leftPadding - self.rightPadding;
            
            
            if (sbv.myFrame.width != CGFLOAT_MAX)
                return sbv.myFrame.width;
            
            [self myCalcSubViewLeftRight:sbv selfSize:selfSize];
            
            return sbv.myFrame.width;
            
        }
            break;
        case MyGravity_Vert_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - self.topPadding - self.bottomPadding;
            
            
            if (sbv.myFrame.height != CGFLOAT_MAX)
                return sbv.myFrame.height;
            
            [self myCalcSubViewTopBottom:sbv selfSize:selfSize];
            
            return sbv.myFrame.height;
        }
            break;
        case MyGravity_Horz_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.width - self.leftPadding - self.rightPadding) / 2 + self.leftPadding;
            
            if (sbv.myFrame.leftPos != CGFLOAT_MAX && sbv.myFrame.rightPos != CGFLOAT_MAX &&  sbv.myFrame.width != CGFLOAT_MAX)
                return sbv.myFrame.leftPos + sbv.myFrame.width / 2;
            
            [self myCalcSubViewLeftRight:sbv selfSize:selfSize];
            
            return sbv.myFrame.leftPos + sbv.myFrame.width / 2;
            
        }
            break;
            
        case MyGravity_Vert_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.height - self.topPadding - self.bottomPadding) / 2 + self.topPadding;
            
            if (sbv.myFrame.topPos != CGFLOAT_MAX && sbv.myFrame.bottomPos != CGFLOAT_MAX &&  sbv.myFrame.height != CGFLOAT_MAX)
                return sbv.myFrame.topPos + sbv.myFrame.height / 2;
            
            [self myCalcSubViewTopBottom:sbv selfSize:selfSize];
            
            return sbv.myFrame.topPos + sbv.myFrame.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)myCalcWidth:(UIView*)sbv selfSize:(CGSize)selfSize
{
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyLayoutSize *sbvWidthSize = sbv.widthSizeInner;
    MyLayoutPos *sbvLeftPos = sbv.leftPosInner;
    MyLayoutPos *sbvRightPos = sbv.rightPosInner;
    
    if (sbvmyFrame.width == CGFLOAT_MAX)
    {
        
        if (sbvWidthSize.dimeRelaVal != nil)
        {
            
            sbvmyFrame.width = [sbvWidthSize measureWith:[self myCalcSubView:sbvWidthSize.dimeRelaVal.view gravity:sbvWidthSize.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvmyFrame.width = [self myValidMeasure:sbvWidthSize sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvWidthSize.dimeNumVal != nil)
        {
            sbvmyFrame.width = sbvWidthSize.measure;
            sbvmyFrame.width = [self myValidMeasure:sbvWidthSize sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self myIsNoLayoutSubview:sbv])
        {
            sbvmyFrame.width = 0;
        }
        
        if (sbvLeftPos.posVal != nil && sbvRightPos.posVal != nil)
        {
            if (sbvLeftPos.posRelaVal != nil)
                sbvmyFrame.leftPos = [self myCalcSubView:sbvLeftPos.posRelaVal.view gravity:sbvLeftPos.posRelaVal.pos selfSize:selfSize] + sbvLeftPos.margin;
            else
                sbvmyFrame.leftPos = sbvLeftPos.margin + self.leftPadding;
            
            if (sbvRightPos.posRelaVal != nil)
                sbvmyFrame.rightPos = [self myCalcSubView:sbvRightPos.posRelaVal.view gravity:sbvRightPos.posRelaVal.pos selfSize:selfSize] - sbvRightPos.margin;
            else
                sbvmyFrame.rightPos = selfSize.width - sbvRightPos.margin - self.rightPadding;
            
            sbvmyFrame.width = sbvmyFrame.rightPos - sbvmyFrame.leftPos;
            sbvmyFrame.width = [self myValidMeasure:sbvWidthSize sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self myIsNoLayoutSubview:sbv])
            {
                sbvmyFrame.width = 0;
                sbvmyFrame.rightPos = sbvmyFrame.leftPos + sbvmyFrame.width;
            }
            
            
            return YES;
            
        }
        
        
        if (sbvmyFrame.width == CGFLOAT_MAX)
        {
            sbvmyFrame.width = CGRectGetWidth(sbv.bounds);
            sbvmyFrame.width = [self myValidMeasure:sbvWidthSize sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        }
    }
    
    if ((sbvWidthSize.lBoundValInner != nil && sbvWidthSize.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvWidthSize.uBoundValInner != nil && sbvWidthSize.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX) )
    {
        sbvmyFrame.width = [self myValidMeasure:sbvWidthSize sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
    }
    
    
    return NO;
}


-(BOOL)myCalcHeight:(UIView*)sbv selfSize:(CGSize)selfSize
{
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyLayoutSize *sbvHeightSize = sbv.heightSizeInner;
    MyLayoutPos *sbvTopPos = sbv.topPosInner;
    MyLayoutPos *sbvBottomPos = sbv.bottomPosInner;
    
    
    if (sbvmyFrame.height == CGFLOAT_MAX)
    {
        if (sbvHeightSize.dimeRelaVal != nil)
        {
            
            sbvmyFrame.height = [sbvHeightSize measureWith:[self myCalcSubView:sbvHeightSize.dimeRelaVal.view gravity:sbvHeightSize.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvmyFrame.height = [self myValidMeasure:sbvHeightSize sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvHeightSize.dimeNumVal != nil)
        {
            sbvmyFrame.height = sbvHeightSize.measure;
            sbvmyFrame.height = [self myValidMeasure:sbvHeightSize sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self myIsNoLayoutSubview:sbv])
        {
            sbvmyFrame.height = 0;
        }
        
        
        if (sbvTopPos.posVal != nil && sbvBottomPos.posVal != nil)
        {
            if (sbvTopPos.posRelaVal != nil)
                sbvmyFrame.topPos = [self myCalcSubView:sbvTopPos.posRelaVal.view gravity:sbvTopPos.posRelaVal.pos selfSize:selfSize] + sbvTopPos.margin;
            else
                sbvmyFrame.topPos = sbvTopPos.margin + self.topPadding;
            
            if (sbvBottomPos.posRelaVal != nil)
                sbvmyFrame.bottomPos = [self myCalcSubView:sbvBottomPos.posRelaVal.view gravity:sbvBottomPos.posRelaVal.pos selfSize:selfSize] - sbvBottomPos.margin;
            else
                sbvmyFrame.bottomPos = selfSize.height - sbvBottomPos.margin - self.bottomPadding;
            
            sbvmyFrame.height = sbvmyFrame.bottomPos - sbvmyFrame.topPos;
            sbvmyFrame.height = [self myValidMeasure:sbvHeightSize sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self myIsNoLayoutSubview:sbv])
            {
                sbvmyFrame.height = 0;
                sbvmyFrame.bottomPos = sbvmyFrame.topPos + sbvmyFrame.height;
            }
            
            
            return YES;
            
        }
        
        
        if (sbvmyFrame.height == CGFLOAT_MAX)
        {
            sbvmyFrame.height = CGRectGetHeight(sbv.bounds);
            
            if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && ![self myIsNoLayoutSubview:sbv])
            {
                if (sbvmyFrame.width == CGFLOAT_MAX)
                    [self myCalcWidth:sbv selfSize:selfSize];
                
                sbvmyFrame.height = [self myHeightFromFlexedHeightView:sbv inWidth:sbvmyFrame.width];
            }
            
            sbvmyFrame.height = [self myValidMeasure:sbvHeightSize sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            
        }
    }
    
    if ( (sbvHeightSize.lBoundValInner != nil && sbvHeightSize.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
         (sbvHeightSize.uBoundValInner != nil && sbvHeightSize.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX))
    {
        sbvmyFrame.height = [self myValidMeasure:sbvHeightSize sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
    }
    
    return NO;
    
}


-(CGSize)myCalcLayout:(BOOL*)pRecalc selfSize:(CGSize)selfSize
{
    *pRecalc = NO;
    
    
    //遍历所有子视图，算出所有宽度和高度根据自身内容确定的子视图的尺寸.以及计算出那些有依赖关系的尺寸限制。。。
    for (UIView *sbv in self.subviews)
    {
        [self myCalcSizeOfWrapContentSubview:sbv selfLayoutSize:selfSize];
        
        if (sbv.myFrame.width != CGFLOAT_MAX)
        {
            if (sbv.widthSizeInner.uBoundValInner.dimeRelaVal != nil && sbv.widthSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcWidth:sbv.widthSizeInner.uBoundValInner.dimeRelaVal.view selfSize:selfSize];
            }
            
            if (sbv.widthSizeInner.lBoundValInner.dimeRelaVal != nil && sbv.widthSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcWidth:sbv.widthSizeInner.lBoundValInner.dimeRelaVal.view selfSize:selfSize];
            }
            
            sbv.myFrame.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:sbv.myFrame.width sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
        }
        
        if (sbv.myFrame.height != CGFLOAT_MAX)
        {
            if (sbv.heightSizeInner.uBoundValInner.dimeRelaVal != nil && sbv.heightSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcHeight:sbv.heightSizeInner.uBoundValInner.dimeRelaVal.view selfSize:selfSize];
            }
            
            if (sbv.heightSizeInner.lBoundValInner.dimeRelaVal != nil && sbv.heightSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcHeight:sbv.heightSizeInner.lBoundValInner.dimeRelaVal.view selfSize:selfSize];
            }
            
            sbv.myFrame.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
        }
        
    }
    
    //均分宽度和高度。把这部分提出来是为了实现不管数组是哪个视图指定都可以。
    for (UIView *sbv in self.subviews)
    {
        
        if (sbv.widthSizeInner.dimeArrVal != nil)
        {
            *pRecalc = YES;
            
            NSArray *dimeArray = sbv.widthSizeInner.dimeArrVal;
            
            BOOL isViewHidden = [self myIsNoLayoutSubview:sbv] && self.flexOtherViewWidthWhenSubviewHidden;
            CGFloat totalMulti = isViewHidden ? 0 : sbv.widthSizeInner.multiVal;
            CGFloat totalAdd =  isViewHidden ? 0 : sbv.widthSizeInner.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                
                if (dime.isActive)
                {
                    isViewHidden = [self myIsNoLayoutSubview:dime.view] && self.flexOtherViewWidthWhenSubviewHidden;
                    if (!isViewHidden)
                    {
                        if (dime.dimeNumVal != nil)
                            totalAdd += -1 * dime.dimeNumVal.doubleValue;
                        else if (dime.dimeSelfVal != nil)
                        {
                            totalAdd += -1 * dime.view.myFrame.width;
                        }
                        else
                            totalMulti += dime.multiVal;
                        
                        totalAdd += dime.addVal;
                        
                    }
                }
                
            }
            
            CGFloat floatWidth = selfSize.width - self.leftPadding - self.rightPadding + totalAdd;
            if (/*floatWidth <= 0*/ _myCGFloatLessOrEqual(floatWidth, 0))
                floatWidth = 0;
            
            if (totalMulti != 0)
            {
                sbv.myFrame.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:floatWidth * (sbv.widthSizeInner.multiVal / totalMulti) sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self myIsNoLayoutSubview:sbv])
                    sbv.myFrame.width = 0;
                
                for (MyLayoutSize *dime in dimeArray)
                {
                    if (dime.isActive)
                    {
                        if (dime.dimeNumVal == nil)
                            dime.view.myFrame.width = floatWidth * (dime.multiVal / totalMulti);
                        else
                            dime.view.myFrame.width = dime.dimeNumVal.doubleValue;
                        
                        dime.view.myFrame.width = [self myValidMeasure:dime.view.widthSize sbv:dime.view calcSize:dime.view.myFrame.width sbvSize:dime.view.myFrame.frame.size selfLayoutSize:selfSize];
                        
                        if ([self myIsNoLayoutSubview:dime.view])
                            dime.view.myFrame.width = 0;
                    }
                }
            }
        }
        
        if (sbv.heightSizeInner.dimeArrVal != nil)
        {
            *pRecalc = YES;
            
            NSArray *dimeArray = sbv.heightSizeInner.dimeArrVal;
            
            BOOL isViewHidden = [self myIsNoLayoutSubview:sbv] && self.flexOtherViewHeightWhenSubviewHidden;
            
            CGFloat totalMulti = isViewHidden ? 0 : sbv.heightSizeInner.multiVal;
            CGFloat totalAdd = isViewHidden ? 0 : sbv.heightSizeInner.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                if (dime.isActive)
                {
                    isViewHidden = [self myIsNoLayoutSubview:dime.view] && self.flexOtherViewHeightWhenSubviewHidden;
                    if (!isViewHidden)
                    {
                        if (dime.dimeNumVal != nil)
                            totalAdd += -1 * dime.dimeNumVal.doubleValue;
                        else if (dime.dimeSelfVal != nil)
                        {
                            totalAdd += -1 *dime.view.myFrame.height;
                        }
                        else
                            totalMulti += dime.multiVal;
                        
                        totalAdd += dime.addVal;
                    }
                }
            }
            
            CGFloat floatHeight = selfSize.height - self.topPadding - self.bottomPadding + totalAdd;
            if (/*floatHeight <= 0*/ _myCGFloatLessOrEqual(floatHeight, 0))
                floatHeight = 0;
            
            if (totalMulti != 0)
            {
                sbv.myFrame.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:floatHeight * (sbv.heightSizeInner.multiVal / totalMulti) sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self myIsNoLayoutSubview:sbv])
                    sbv.myFrame.height = 0;
                
                for (MyLayoutSize *dime in dimeArray)
                {
                    if (dime.isActive)
                    {
                        if (dime.dimeNumVal == nil)
                            dime.view.myFrame.height = floatHeight * (dime.multiVal / totalMulti);
                        else
                            dime.view.myFrame.height = dime.dimeNumVal.doubleValue;
                        
                        dime.view.myFrame.height = [self myValidMeasure:dime.view.heightSize sbv:dime.view calcSize:dime.view.myFrame.height sbvSize:dime.view.myFrame.frame.size selfLayoutSize:selfSize];
                        
                        if ([self myIsNoLayoutSubview:dime.view])
                            dime.view.myFrame.height = 0;
                    }
                }
            }
        }
        
        
        //表示视图数组水平居中
        if (sbv.centerXPosInner.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *centerArray = sbv.centerXPosInner.posArrVal;
            
            CGFloat totalWidth = 0;
            CGFloat totalOffset = 0;
            
            MyLayoutPos *nextPos = nil;
            for (NSInteger i = centerArray.count - 1; i >= 0; i--)
            {
                MyLayoutPos *pos = centerArray[i];
                if (![self myIsNoLayoutSubview:pos.view])
                {
                    if (totalWidth != 0)
                    {
                        if (nextPos != nil)
                            totalOffset += nextPos.view.centerXPos.margin;
                    }
                    
                    [self myCalcWidth:pos.view selfSize:selfSize];
                    totalWidth += pos.view.myFrame.width;
                }
                
                nextPos = pos;
            }
            
            if (![self myIsNoLayoutSubview:sbv])
            {
                if (totalWidth != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerXPos.margin;
                }
                
                [self myCalcWidth:sbv selfSize:selfSize];
                totalWidth += sbv.myFrame.width;
                totalOffset += sbv.centerXPosInner.margin;
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
        if (sbv.centerYPosInner.posArrVal != nil)
        {
            NSArray *centerArray = sbv.centerYPosInner.posArrVal;
            
            CGFloat totalHeight = 0;
            CGFloat totalOffset = 0;
            
            MyLayoutPos *nextPos = nil;
            for (NSInteger i = centerArray.count - 1; i >= 0; i--)
            {
                MyLayoutPos *pos = centerArray[i];
                if (![self myIsNoLayoutSubview:pos.view])
                {
                    if (totalHeight != 0)
                    {
                        if (nextPos != nil)
                            totalOffset += nextPos.view.centerYPos.margin;
                    }
                    
                    [self myCalcHeight:pos.view selfSize:selfSize];
                    totalHeight += pos.view.myFrame.height;
                }
                
                nextPos = pos;
            }
            
            if (![self myIsNoLayoutSubview:sbv])
            {
                if (totalHeight != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerYPos.margin;
                }
                
                [self myCalcHeight:sbv selfSize:selfSize];
                totalHeight += sbv.myFrame.height;
                totalOffset += sbv.centerYPosInner.margin;
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
        
        [self myCalcSubViewLeftRight:sbv selfSize:selfSize];
        
        if (sbv.rightPosInner.posRelaVal != nil && sbv.rightPosInner.posRelaVal.view == self)
        {
            *pRecalc = YES;
        }
        
        if (sbv.widthSizeInner.dimeRelaVal != nil && sbv.widthSizeInner.dimeRelaVal.view == self)
        {
            canCalcMaxWidth = NO;
            *pRecalc = YES;
        }
        
        if (sbv.leftPosInner.posRelaVal != nil && sbv.leftPosInner.posRelaVal.view == self &&
            sbv.rightPosInner.posRelaVal != nil && sbv.rightPosInner.posRelaVal.view == self)
        {
            canCalcMaxWidth = NO;
        }
        
        
        if (sbv.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            sbv.myFrame.height = [self myHeightFromFlexedHeightView:sbv inWidth:sbv.myFrame.width];
            sbv.myFrame.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
        }
        
        [self myCalcSubViewTopBottom:sbv selfSize:selfSize];
        
        if (sbv.bottomPosInner.posRelaVal != nil && sbv.bottomPosInner.posRelaVal.view == self)
            *pRecalc = YES;
        
        if (sbv.heightSizeInner.dimeRelaVal != nil && sbv.heightSizeInner.dimeRelaVal.view == self)
        {
            *pRecalc = YES;
            canCalcMaxHeight = NO;
        }
        
        if (sbv.topPosInner.posRelaVal != nil && sbv.topPosInner.posRelaVal.view == self &&
            sbv.bottomPosInner.posRelaVal != nil && sbv.bottomPosInner.posRelaVal.view == self)
        {
            canCalcMaxHeight = NO;
        }
        
        
        if ([self myIsNoLayoutSubview:sbv])
            continue;
        
        if (canCalcMaxWidth &&  maxWidth < sbv.myFrame.rightPos + sbv.rightPosInner.margin)
            maxWidth = sbv.myFrame.rightPos + sbv.rightPosInner.margin;
        
        if (canCalcMaxHeight && maxHeight < sbv.myFrame.bottomPos + sbv.bottomPosInner.margin)
            maxHeight = sbv.myFrame.bottomPos + sbv.bottomPosInner.margin;
    }
    
    maxWidth += self.rightPadding;
    maxHeight += self.bottomPadding;
    
    return CGSizeMake(maxWidth, maxHeight);
    
}



@end

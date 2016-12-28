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
    
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyLayoutPos *sbvLeftPos = sbv.leftPos;
    MyLayoutPos *sbvRightPos = sbv.rightPos;
    MyLayoutPos *sbvCenterXPos = sbv.centerXPos;
    
    
    
    if (sbvmyFrame.leftPos != CGFLOAT_MAX && sbvmyFrame.rightPos != CGFLOAT_MAX && sbvmyFrame.width != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcWidth:sbv selfSize:selfSize])
        return;
    
    
    if (sbvCenterXPos.posRelaVal != nil)
    {
        UIView *relaView = sbvCenterXPos.posRelaVal.view;

        sbvmyFrame.leftPos = [self calcSubView:relaView gravity:sbvCenterXPos.posRelaVal.pos selfSize:selfSize] - sbvmyFrame.width / 2 + sbvCenterXPos.margin;
        
        if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
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
            
            sbvmyFrame.leftPos = [self calcSubView:relaView gravity:sbvLeftPos.posRelaVal.pos selfSize:selfSize] + sbvLeftPos.margin;
            
            if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
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
            
            
            sbvmyFrame.rightPos = [self calcSubView:relaView gravity:sbvRightPos.posRelaVal.pos selfSize:selfSize] - sbvRightPos.margin + sbvLeftPos.margin;
            
            if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
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
    
    if (sbvLeftPos.lBoundVal.posRelaVal != nil && sbvRightPos.uBoundVal.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
         CGFloat   minLeft = [self calcSubView:sbvLeftPos.lBoundVal.posRelaVal.view gravity:sbvLeftPos.lBoundVal.posRelaVal.pos selfSize:selfSize] + sbvLeftPos.lBoundVal.offsetVal;
        
         CGFloat   maxRight = [self calcSubView:sbvRightPos.uBoundVal.posRelaVal.view gravity:sbvRightPos.uBoundVal.posRelaVal.pos selfSize:selfSize] - sbvRightPos.uBoundVal.offsetVal;
        
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
    else if (sbvLeftPos.lBoundVal.posRelaVal != nil)
    {
         //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minLeft = [self calcSubView:sbvLeftPos.lBoundVal.posRelaVal.view gravity:sbvLeftPos.lBoundVal.posRelaVal.pos selfSize:selfSize] + sbvLeftPos.lBoundVal.offsetVal;
        
        if (sbvmyFrame.leftPos < minLeft)
        {
            sbvmyFrame.leftPos = minLeft;
            sbvmyFrame.width = sbvmyFrame.rightPos - sbvmyFrame.leftPos;
        }

    }
    else if (sbvRightPos.uBoundVal.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxRight = [self calcSubView:sbvRightPos.uBoundVal.posRelaVal.view gravity:sbvRightPos.uBoundVal.posRelaVal.pos selfSize:selfSize] - sbvRightPos.uBoundVal.offsetVal;
        if (sbvmyFrame.rightPos > maxRight)
        {
            sbvmyFrame.rightPos = maxRight;
            sbvmyFrame.width = sbvmyFrame.rightPos - sbvmyFrame.leftPos;
        }

    }
    
    
}

-(void)calcSubViewTopBottom:(UIView*)sbv selfSize:(CGSize)selfSize
{
    
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyLayoutPos *sbvTopPos = sbv.topPos;
    MyLayoutPos *sbvBottomPos = sbv.bottomPos;
    MyLayoutPos *sbvCenterYPos = sbv.centerYPos;

    
    if (sbvmyFrame.topPos != CGFLOAT_MAX && sbvmyFrame.bottomPos != CGFLOAT_MAX && sbvmyFrame.height != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcHeight:sbv selfSize:selfSize])
        return;
    
    if (sbvCenterYPos.posRelaVal != nil)
    {
        UIView *relaView = sbvCenterYPos.posRelaVal.view;
        
        sbvmyFrame.topPos = [self calcSubView:relaView gravity:sbvCenterYPos.posRelaVal.pos selfSize:selfSize] - sbvmyFrame.height / 2 + sbvCenterYPos.margin;
        
        
        if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
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

            sbvmyFrame.topPos = [self calcSubView:relaView gravity:sbvTopPos.posRelaVal.pos selfSize:selfSize] + sbvTopPos.margin;
            
            if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
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
            
            sbvmyFrame.bottomPos = [self calcSubView:relaView gravity:sbvBottomPos.posRelaVal.pos selfSize:selfSize] - sbvBottomPos.margin + sbvTopPos.margin;
            
            if (relaView != nil && relaView != self && [self isNoLayoutSubview:relaView])
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
    if (sbvTopPos.lBoundVal.posRelaVal != nil && sbvBottomPos.uBoundVal.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minTop = [self calcSubView:sbvTopPos.lBoundVal.posRelaVal.view gravity:sbvTopPos.lBoundVal.posRelaVal.pos selfSize:selfSize] + sbvTopPos.lBoundVal.offsetVal;
        
        CGFloat   maxBottom = [self calcSubView:sbvBottomPos.uBoundVal.posRelaVal.view gravity:sbvBottomPos.uBoundVal.posRelaVal.pos selfSize:selfSize] - sbvBottomPos.uBoundVal.offsetVal;
        
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
    else if (sbvTopPos.lBoundVal.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minTop = [self calcSubView:sbvTopPos.lBoundVal.posRelaVal.view gravity:sbvTopPos.lBoundVal.posRelaVal.pos selfSize:selfSize] + sbvTopPos.lBoundVal.offsetVal;
        
        if (sbvmyFrame.topPos < minTop)
        {
            sbvmyFrame.topPos = minTop;
            sbvmyFrame.height = sbvmyFrame.bottomPos - sbvmyFrame.topPos;
        }
        
    }
    else if (sbvBottomPos.uBoundVal.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxBottom = [self calcSubView:sbvBottomPos.uBoundVal.posRelaVal.view gravity:sbvBottomPos.uBoundVal.posRelaVal.pos selfSize:selfSize] - sbvBottomPos.uBoundVal.offsetVal;
        if (sbvmyFrame.bottomPos > maxBottom)
        {
            sbvmyFrame.bottomPos = maxBottom;
            sbvmyFrame.height = sbvmyFrame.bottomPos - sbvmyFrame.topPos;
        }
        
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
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyLayoutSize *sbvWidthDime = sbv.widthDime;
    MyLayoutPos *sbvLeftPos = sbv.leftPos;
    MyLayoutPos *sbvRightPos = sbv.rightPos;
    
    if (sbvmyFrame.width == CGFLOAT_MAX)
    {
        
        if (sbvWidthDime.dimeRelaVal != nil)
        {
            
            sbvmyFrame.width = [sbvWidthDime measureWith:[self calcSubView:sbvWidthDime.dimeRelaVal.view gravity:sbvWidthDime.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvmyFrame.width = [self validMeasure:sbvWidthDime sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvWidthDime.dimeNumVal != nil)
        {
            sbvmyFrame.width = sbvWidthDime.measure;
            sbvmyFrame.width = [self validMeasure:sbvWidthDime sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self isNoLayoutSubview:sbv])
        {
            sbvmyFrame.width = 0;
        }
        
        if (sbvLeftPos.posVal != nil && sbvRightPos.posVal != nil)
        {
            if (sbvLeftPos.posRelaVal != nil)
                sbvmyFrame.leftPos = [self calcSubView:sbvLeftPos.posRelaVal.view gravity:sbvLeftPos.posRelaVal.pos selfSize:selfSize] + sbvLeftPos.margin;
            else
                sbvmyFrame.leftPos = sbvLeftPos.margin + self.leftPadding;
            
            if (sbvRightPos.posRelaVal != nil)
                sbvmyFrame.rightPos = [self calcSubView:sbvRightPos.posRelaVal.view gravity:sbvRightPos.posRelaVal.pos selfSize:selfSize] - sbvRightPos.margin;
            else
                sbvmyFrame.rightPos = selfSize.width - sbvRightPos.margin - self.rightPadding;
            
            sbvmyFrame.width = sbvmyFrame.rightPos - sbvmyFrame.leftPos;
            sbvmyFrame.width = [self validMeasure:sbvWidthDime sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self isNoLayoutSubview:sbv])
            {
                sbvmyFrame.width = 0;
                sbvmyFrame.rightPos = sbvmyFrame.leftPos + sbvmyFrame.width;
            }

            
            return YES;
            
        }
        
        
        if (sbvmyFrame.width == CGFLOAT_MAX)
        {
            sbvmyFrame.width = CGRectGetWidth(sbv.bounds);
            sbvmyFrame.width = [self validMeasure:sbvWidthDime sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        }
    }
    
    if (sbvWidthDime.lBoundVal.dimeNumVal.doubleValue != -CGFLOAT_MAX || sbvWidthDime.uBoundVal.dimeNumVal.doubleValue != CGFLOAT_MAX)
    {
        sbvmyFrame.width = [self validMeasure:sbvWidthDime sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
    }

    
    return NO;
}


-(BOOL)calcHeight:(UIView*)sbv selfSize:(CGSize)selfSize
{
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyLayoutSize *sbvHeightDime = sbv.heightDime;
    MyLayoutPos *sbvTopPos = sbv.topPos;
    MyLayoutPos *sbvBottomPos = sbv.bottomPos;


    if (sbvmyFrame.height == CGFLOAT_MAX)
    {
        if (sbvHeightDime.dimeRelaVal != nil)
        {
            
            sbvmyFrame.height = [sbvHeightDime measureWith:[self calcSubView:sbvHeightDime.dimeRelaVal.view gravity:sbvHeightDime.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvmyFrame.height = [self validMeasure:sbvHeightDime sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvHeightDime.dimeNumVal != nil)
        {
            sbvmyFrame.height = sbvHeightDime.measure;
            sbvmyFrame.height = [self validMeasure:sbvHeightDime sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self isNoLayoutSubview:sbv])
        {
            sbvmyFrame.height = 0;
        }

        
        if (sbvTopPos.posVal != nil && sbvBottomPos.posVal != nil)
        {
            if (sbvTopPos.posRelaVal != nil)
                sbvmyFrame.topPos = [self calcSubView:sbvTopPos.posRelaVal.view gravity:sbvTopPos.posRelaVal.pos selfSize:selfSize] + sbvTopPos.margin;
            else
                sbvmyFrame.topPos = sbvTopPos.margin + self.topPadding;
            
            if (sbvBottomPos.posRelaVal != nil)
                sbvmyFrame.bottomPos = [self calcSubView:sbvBottomPos.posRelaVal.view gravity:sbvBottomPos.posRelaVal.pos selfSize:selfSize] - sbvBottomPos.margin;
            else
                sbvmyFrame.bottomPos = selfSize.height - sbvBottomPos.margin - self.bottomPadding;
            
            sbvmyFrame.height = sbvmyFrame.bottomPos - sbvmyFrame.topPos;
            sbvmyFrame.height = [self validMeasure:sbvHeightDime sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self isNoLayoutSubview:sbv])
            {
                sbvmyFrame.height = 0;
                sbvmyFrame.bottomPos = sbvmyFrame.topPos + sbvmyFrame.height;
            }
            

            return YES;
            
        }
        
        
        if (sbvmyFrame.height == CGFLOAT_MAX)
        {
           sbvmyFrame.height = CGRectGetHeight(sbv.bounds);
            
            if (sbv.isFlexedHeight && ![self isNoLayoutSubview:sbv])
            {
                if (sbvmyFrame.width == CGFLOAT_MAX)
                    [self calcWidth:sbv selfSize:selfSize];
                
                sbvmyFrame.height = [self heightFromFlexedHeightView:sbv inWidth:sbvmyFrame.width];
            }
            
            sbvmyFrame.height = [self validMeasure:sbvHeightDime sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];


        }
    }
    
    if (sbvHeightDime.lBoundVal.dimeNumVal.doubleValue != -CGFLOAT_MAX || sbvHeightDime.uBoundVal.dimeNumVal.doubleValue != CGFLOAT_MAX)
    {
        sbvmyFrame.height = [self validMeasure:sbvHeightDime sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
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
            CGFloat totalMulti = isViewHidden ? 0 : sbv.widthDime.multiVal;
            CGFloat totalAdd =  isViewHidden ? 0 : sbv.widthDime.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
             
                if (dime.isActive)
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
                sbv.myFrame.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:floatWidth * (sbv.widthDime.multiVal / totalMulti) sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self isNoLayoutSubview:sbv])
                    sbv.myFrame.width = 0;
                
                for (MyLayoutSize *dime in dimeArray)
                {
                    if (dime.isActive)
                    {
                        if (dime.dimeNumVal == nil)
                            dime.view.myFrame.width = floatWidth * (dime.multiVal / totalMulti);
                        else
                            dime.view.myFrame.width = dime.dimeNumVal.doubleValue;
                        
                        dime.view.myFrame.width = [self validMeasure:dime.view.widthDime sbv:dime.view calcSize:dime.view.myFrame.width sbvSize:dime.view.myFrame.frame.size selfLayoutSize:selfSize];
                        
                        if ([self isNoLayoutSubview:dime.view])
                            dime.view.myFrame.width = 0;
                    }
                }
            }
        }
        
        if (sbv.heightDime.dimeArrVal != nil)
        {
            *pRecalc = YES;
            
            NSArray *dimeArray = sbv.heightDime.dimeArrVal;
            
            BOOL isViewHidden = [self isNoLayoutSubview:sbv] && self.flexOtherViewHeightWhenSubviewHidden;
            
            CGFloat totalMulti = isViewHidden ? 0 : sbv.heightDime.multiVal;
            CGFloat totalAdd = isViewHidden ? 0 : sbv.heightDime.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                if (dime.isActive)
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
                sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:floatHeight * (sbv.heightDime.multiVal / totalMulti) sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self isNoLayoutSubview:sbv])
                    sbv.myFrame.height = 0;
                
                for (MyLayoutSize *dime in dimeArray)
                {
                    if (dime.isActive)
                    {
                        if (dime.dimeNumVal == nil)
                            dime.view.myFrame.height = floatHeight * (dime.multiVal / totalMulti);
                        else
                            dime.view.myFrame.height = dime.dimeNumVal.doubleValue;
                        
                        dime.view.myFrame.height = [self validMeasure:dime.view.heightDime sbv:dime.view calcSize:dime.view.myFrame.height sbvSize:dime.view.myFrame.frame.size selfLayoutSize:selfSize];
                        
                        if ([self isNoLayoutSubview:dime.view])
                            dime.view.myFrame.height = 0;
                    }
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
            sbv.myFrame.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:sbv.myFrame.height sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
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

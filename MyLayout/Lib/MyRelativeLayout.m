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
    
    MyRelativeLayout *lsc = self.myCurrentSizeClass;
    
    
    for (UIView *sbv in self.subviews)
    {
        UIView *sbvsc = sbv.myCurrentSizeClass;
        MyFrame *sbvMyFrame = sbv.myFrame;
        
        if (sbvsc.useFrame)
            continue;
        
        if (!isEstimate || (pHasSubLayout != nil && (*pHasSubLayout) == YES))
            [sbvMyFrame reset];
        
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            if (sbvsc.wrapContentWidth)
            {
                //只要同时设置了左右边距或者设置了宽度则应该把wrapContentWidth置为NO
                if ((sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil) || sbvsc.widthSizeInner.dimeVal != nil)
                    sbvsc.wrapContentWidth = NO;
            }
            
            if (sbvsc.wrapContentHeight)
            {
                if ((sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil) || sbvsc.heightSizeInner.dimeVal != nil)
                    sbvsc.wrapContentHeight = NO;
            }
            
            if (pHasSubLayout != nil && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
                *pHasSubLayout = YES;
            
            if (isEstimate && (sbvsc.wrapContentWidth || sbvsc.wrapContentHeight))
            {
                [(MyBaseLayout*)sbv estimateLayoutRect:sbvMyFrame.frame.size inSizeClass:sizeClass];
                
                sbvMyFrame.leading = sbvMyFrame.trailing = sbvMyFrame.top = sbvMyFrame.bottom = CGFLOAT_MAX;
                
                if (sbvMyFrame.multiple)
                {
                    sbvMyFrame.sizeClass = [sbv myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    sbvsc = sbvMyFrame.sizeClass;
                }
            }
        }
    }
    
    
    BOOL reCalc = NO;
    CGSize maxSize = [self myCalcLayout:&reCalc lsc:lsc selfSize:selfSize];
    
    if (lsc.wrapContentWidth || lsc.wrapContentHeight)
    {
        if (_myCGFloatNotEqual(selfSize.height, maxSize.height)  || _myCGFloatNotEqual(selfSize.width, maxSize.width))
        {
            
            if (lsc.wrapContentWidth)
            {
                selfSize.width = maxSize.width;
            }
            
            if (lsc.wrapContentHeight)
            {
                selfSize.height = maxSize.height;
            }
            
            //如果里面有需要重新计算的就重新计算布局
            if (reCalc)
            {
                for (UIView *sbv in self.subviews)
                {
                    MyFrame *sbvMyFrame = sbv.myFrame;
                    //如果是布局视图则不清除尺寸，其他清除。
                    if (isEstimate  && [sbv isKindOfClass:[MyBaseLayout class]])
                    {
                        sbvMyFrame.leading = sbvMyFrame.trailing = sbvMyFrame.top = sbvMyFrame.bottom = CGFLOAT_MAX;
                    }
                    else
                        [sbvMyFrame reset];
                }
                
                [self myCalcLayout:NULL lsc:lsc selfSize:selfSize];
            }
        }
        
    }
    
    
    //调整布局视图自己的尺寸。
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    //如果是反向则调整所有子视图的左右位置。
    [self myAdjustSubviewsRTLPos:self.subviews selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:[self myGetLayoutSubviews] lsc:lsc];
    
}

-(id)createSizeClassInstance
{
    return [MyRelativeLayoutViewSizeClass new];
}



#pragma mark -- Private Method
-(void)myCalcSubViewLeadingTrailing:(UIView*)sbv
                              sbvsc:(UIView*)sbvsc
                                lsc:(MyRelativeLayout*)lsc
                         sbvMyFrame:(MyFrame*)sbvMyFrame
                           selfSize:(CGSize)selfSize
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
    
    
    
    if (sbvMyFrame.leading != CGFLOAT_MAX && sbvMyFrame.trailing != CGFLOAT_MAX && sbvMyFrame.width != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self myCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize])
        return;
    
    
    if (sbvsc.centerXPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerXPosInner.posRelaVal.view;
        
        sbvMyFrame.leading = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.centerXPosInner.posRelaVal.pos selfSize:selfSize] - sbvMyFrame.width / 2 +  sbvsc.centerXPosInner.absVal;
        
        if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
        {
            sbvMyFrame.leading -= sbvsc.centerXPosInner.absVal;
        }
        
        if (sbvMyFrame.leading < 0 && relaView == self && lsc.wrapContentWidth)
            sbvMyFrame.leading = 0;
        
        sbvMyFrame.trailing = sbvMyFrame.leading + sbvMyFrame.width;
    }
    else if (sbvsc.centerXPosInner.posNumVal != nil)
    {
        sbvMyFrame.leading = (selfSize.width - lsc.leadingPadding - lsc.trailingPadding - sbvMyFrame.width) / 2 + lsc.leadingPadding + sbvsc.centerXPosInner.absVal;
        
        if (sbvMyFrame.leading < 0 && lsc.wrapContentWidth)
            sbvMyFrame.leading = 0;
        
        sbvMyFrame.trailing = sbvMyFrame.leading + sbvMyFrame.width;
    }
    else
    {
        //如果左右都设置了则上上面的calcWidth会直接返回不会进入这个流程。
        if (sbvsc.leadingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.leadingPosInner.posRelaVal.view;
            
            sbvMyFrame.leading = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvMyFrame.leading -= sbvsc.leadingPosInner.absVal;
            }
            
            sbvMyFrame.trailing = sbvMyFrame.leading + sbvMyFrame.width;
        }
        else if (sbvsc.leadingPosInner.posNumVal != nil)
        {
            sbvMyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.leadingPadding;
            sbvMyFrame.trailing = sbvMyFrame.leading + sbvMyFrame.width;
        }
        else if (sbvsc.trailingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.trailingPosInner.posRelaVal.view;
            
            
            sbvMyFrame.trailing = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvMyFrame.trailing += sbvsc.trailingPosInner.absVal;
            }
            
            sbvMyFrame.leading = sbvMyFrame.trailing - sbvMyFrame.width;
            
        }
        else if (sbvsc.trailingPosInner.posNumVal != nil)
        {
            sbvMyFrame.trailing = selfSize.width -  lsc.trailingPadding -  sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            sbvMyFrame.leading = sbvMyFrame.trailing - sbvMyFrame.width;
        }
        else
        {
            
            sbvMyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.leadingPadding;
            sbvMyFrame.trailing = sbvMyFrame.leading + sbvMyFrame.width;
        }
        
    }
    
    //这里要更新左边最小和右边最大约束的情况。
    MyLayoutPos *lBoundPos = sbvsc.leadingPosInner.lBoundValInner;
    MyLayoutPos *uBoundPos = sbvsc.trailingPosInner.uBoundValInner;
    
    if (lBoundPos.posRelaVal != nil && uBoundPos.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minLeading = [self myCalcSubView:lBoundPos.posRelaVal.view lsc:lsc gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        
        CGFloat  maxTrailing = [self myCalcSubView:uBoundPos.posRelaVal.view lsc:lsc gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] - uBoundPos.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        CGFloat intervalWidth = maxTrailing - minLeading;
        if (intervalWidth < sbvMyFrame.width)
        {
            sbvMyFrame.width = intervalWidth;
            sbvMyFrame.leading = minLeading;
        }
        else
        {
            sbvMyFrame.leading = (intervalWidth - sbvMyFrame.width) / 2 + minLeading;
        }
        
        sbvMyFrame.trailing = sbvMyFrame.leading + sbvMyFrame.width;
        
        
    }
    else if (lBoundPos.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minLeading = [self myCalcSubView:lBoundPos.posRelaVal.view lsc:lsc gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        
        
        if (sbvMyFrame.leading < minLeading)
        {
            sbvMyFrame.leading = minLeading;
            sbvMyFrame.width = sbvMyFrame.trailing - sbvMyFrame.leading;
        }
    }
    else if (uBoundPos.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxTrailing = [self myCalcSubView:uBoundPos.posRelaVal.view lsc:lsc gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] -  uBoundPos.offsetVal;
        
        if (sbvMyFrame.trailing > maxTrailing)
        {
            sbvMyFrame.trailing = maxTrailing;
            sbvMyFrame.width = sbvMyFrame.trailing - sbvMyFrame.leading;
        }
    }
    
    
}

-(void)myCalcSubViewTopBottom:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(MyRelativeLayout*)lsc sbvMyFrame:(MyFrame*)sbvMyFrame selfSize:(CGSize)selfSize
{
    
    
    if (sbvMyFrame.top != CGFLOAT_MAX && sbvMyFrame.bottom != CGFLOAT_MAX && sbvMyFrame.height != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self myCalcHeight:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize])
        return;
    
    if (sbvsc.centerYPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerYPosInner.posRelaVal.view;
        
        sbvMyFrame.top = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.centerYPosInner.posRelaVal.pos selfSize:selfSize] - sbvMyFrame.height / 2 + sbvsc.centerYPosInner.absVal;
        
        
        if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
        {
            sbvMyFrame.top -= sbvsc.centerYPosInner.absVal;
        }
        
        if (sbvMyFrame.top < 0 && relaView == self && lsc.wrapContentHeight)
            sbvMyFrame.top = 0;
        
        sbvMyFrame.bottom = sbvMyFrame.top + sbvMyFrame.height;
    }
    else if (sbvsc.centerYPosInner.posNumVal != nil)
    {
        sbvMyFrame.top = (selfSize.height - lsc.topPadding - lsc.bottomPadding -  sbvMyFrame.height) / 2 + lsc.topPadding + sbvsc.centerYPosInner.absVal;
        
        if (sbvMyFrame.top < 0 && lsc.wrapContentHeight)
            sbvMyFrame.top = 0;
        
        sbvMyFrame.bottom = sbvMyFrame.top + sbvMyFrame.height;
    }
    else
    {
        if (sbvsc.topPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.topPosInner.posRelaVal.view;
            
            sbvMyFrame.top = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvMyFrame.top -= sbvsc.topPosInner.absVal;
            }
            
            sbvMyFrame.bottom = sbvMyFrame.top + sbvMyFrame.height;
        }
        else if (sbvsc.topPosInner.posNumVal != nil)
        {
            sbvMyFrame.top = sbvsc.topPosInner.absVal + lsc.topPadding;
            sbvMyFrame.bottom = sbvMyFrame.top + sbvMyFrame.height;
        }
        else if (sbvsc.bottomPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.bottomPosInner.posRelaVal.view;
            
            sbvMyFrame.bottom = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal + sbvsc.topPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvMyFrame.bottom += sbvsc.bottomPosInner.absVal;
            }
            
            sbvMyFrame.top = sbvMyFrame.bottom - sbvMyFrame.height;
            
        }
        else if (sbvsc.bottomPosInner.posNumVal != nil)
        {
            if (selfSize.height == 0 && lsc.wrapContentHeight)
            {
                sbvMyFrame.top = lsc.topPadding;
                sbvMyFrame.bottom = sbvMyFrame.top + sbvMyFrame.height;
            }
            else
            {
                
                sbvMyFrame.bottom = selfSize.height -  sbvsc.bottomPosInner.absVal - lsc.bottomPadding + sbvsc.topPosInner.absVal;
                sbvMyFrame.top = sbvMyFrame.bottom - sbvMyFrame.height;
            }
        }
        else
        {
            sbvMyFrame.top = sbvsc.topPosInner.absVal + lsc.topPadding;
            sbvMyFrame.bottom = sbvMyFrame.top + sbvMyFrame.height;
        }
    }
    
    //这里要更新上边最小和下边最大约束的情况。
    if (sbvsc.topPosInner.lBoundValInner.posRelaVal != nil && sbvsc.bottomPosInner.uBoundValInner.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minTop = [self myCalcSubView:sbvsc.topPosInner.lBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.topPosInner.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.lBoundValInner.offsetVal;
        
        CGFloat   maxBottom = [self myCalcSubView:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.uBoundValInner.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        if (maxBottom - minTop < sbvMyFrame.height)
        {
            sbvMyFrame.height = maxBottom - minTop;
            sbvMyFrame.top = minTop;
        }
        else
        {
            sbvMyFrame.top = (maxBottom - minTop - sbvMyFrame.height) / 2 + minTop;
        }
        
        sbvMyFrame.bottom = sbvMyFrame.top + sbvMyFrame.height;
        
        
    }
    else if (sbvsc.topPosInner.lBoundValInner.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minTop = [self myCalcSubView:sbvsc.topPosInner.lBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.topPosInner.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.lBoundValInner.offsetVal;
        
        if (sbvMyFrame.top < minTop)
        {
            sbvMyFrame.top = minTop;
            sbvMyFrame.height = sbvMyFrame.bottom - sbvMyFrame.top;
        }
        
    }
    else if (sbvsc.bottomPosInner.uBoundValInner.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxBottom = [self myCalcSubView:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.uBoundValInner.offsetVal;
        if (sbvMyFrame.bottom > maxBottom)
        {
            sbvMyFrame.bottom = maxBottom;
            sbvMyFrame.height = sbvMyFrame.bottom - sbvMyFrame.top;
        }
        
    }
    
    
}



-(CGFloat)myCalcSubView:(UIView*)sbv lsc:(MyRelativeLayout*)lsc gravity:(MyGravity)gravity selfSize:(CGSize)selfSize
{
    UIView *sbvsc = sbv.myCurrentSizeClass;
    MyFrame *sbvMyFrame = sbv.myFrame;
    
    switch (gravity) {
        case MyGravity_Horz_Leading:
        {
            if (sbv == self || sbv == nil)
                return lsc.leadingPadding;
            
            
            if (sbvMyFrame.leading != CGFLOAT_MAX)
                return sbvMyFrame.leading;
            
            [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
            
            return sbvMyFrame.leading;
            
        }
            break;
        case MyGravity_Horz_Trailing:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.trailingPadding;
            
            if (sbvMyFrame.trailing != CGFLOAT_MAX)
                return sbvMyFrame.trailing;
            
            [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
            
            return sbvMyFrame.trailing;
            
        }
            break;
        case MyGravity_Vert_Top:
        {
            if (sbv == self || sbv == nil)
                return lsc.topPadding;
            
            
            if (sbvMyFrame.top != CGFLOAT_MAX)
                return sbvMyFrame.top;
            
            [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
            
            return sbvMyFrame.top;
            
        }
            break;
        case MyGravity_Vert_Bottom:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.bottomPadding;
            
            
            if (sbvMyFrame.bottom != CGFLOAT_MAX)
                return sbvMyFrame.bottom;
            
            [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
            
            return sbvMyFrame.bottom;
        }
            break;
        case MyGravity_Horz_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.leadingPadding - lsc.trailingPadding;
            
            
            if (sbvMyFrame.width != CGFLOAT_MAX)
                return sbvMyFrame.width;
            
            [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
            
            return sbvMyFrame.width;
            
        }
            break;
        case MyGravity_Vert_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.topPadding - lsc.bottomPadding;
            
            
            if (sbvMyFrame.height != CGFLOAT_MAX)
                return sbvMyFrame.height;
            
            [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
            
            return sbvMyFrame.height;
        }
            break;
        case MyGravity_Horz_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.width - lsc.leadingPadding - lsc.trailingPadding) / 2 + lsc.leadingPadding;
            
            if (sbvMyFrame.leading != CGFLOAT_MAX && sbvMyFrame.trailing != CGFLOAT_MAX &&  sbvMyFrame.width != CGFLOAT_MAX)
                return sbvMyFrame.leading + sbvMyFrame.width / 2;
            
            [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
            
            return sbvMyFrame.leading + sbvMyFrame.width / 2;
            
        }
            break;
            
        case MyGravity_Vert_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.height - lsc.topPadding - lsc.bottomPadding) / 2 + lsc.topPadding;
            
            if (sbvMyFrame.top != CGFLOAT_MAX && sbvMyFrame.bottom != CGFLOAT_MAX &&  sbvMyFrame.height != CGFLOAT_MAX)
                return sbvMyFrame.top + sbvMyFrame.height / 2;
            
            [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
            
            return sbvMyFrame.top + sbvMyFrame.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)myCalcWidth:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(MyRelativeLayout*)lsc sbvMyFrame:(MyFrame*)sbvMyFrame selfSize:(CGSize)selfSize
{
    
    if (sbvMyFrame.width == CGFLOAT_MAX)
    {
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil)
        {
            
            sbvMyFrame.width = [sbvsc.widthSizeInner measureWith:[self myCalcSubView:sbvsc.widthSizeInner.dimeRelaVal.view lsc:lsc gravity:sbvsc.widthSizeInner.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvMyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvMyFrame.width sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvsc.widthSizeInner.dimeNumVal != nil)
        {
            sbvMyFrame.width = sbvsc.widthSizeInner.measure;
            sbvMyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvMyFrame.width sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self myIsNoLayoutSubview:sbv])
        {
            sbvMyFrame.width = 0;
        }
        
        if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        {
            if (sbvsc.leadingPosInner.posRelaVal != nil)
                sbvMyFrame.leading = [self myCalcSubView:sbvsc.leadingPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
            else
                sbvMyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.leadingPadding;
            
            if (sbvsc.trailingPosInner.posRelaVal != nil)
                sbvMyFrame.trailing = [self myCalcSubView:sbvsc.trailingPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal;
            else
                sbvMyFrame.trailing = selfSize.width - sbvsc.trailingPosInner.absVal - lsc.trailingPadding;
            
            sbvMyFrame.width = sbvMyFrame.trailing - sbvMyFrame.leading;
            sbvMyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvMyFrame.width sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self myIsNoLayoutSubview:sbv])
            {
                sbvMyFrame.width = 0;
                sbvMyFrame.trailing = sbvMyFrame.leading + sbvMyFrame.width;
            }
            
            
            return YES;
            
        }
        
        
        if (sbvMyFrame.width == CGFLOAT_MAX)
        {
            sbvMyFrame.width = CGRectGetWidth(sbv.bounds);
            sbvMyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvMyFrame.width sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
        }
    }
    
    if ((sbvsc.widthSizeInner.lBoundValInner != nil && sbvsc.widthSizeInner.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvsc.widthSizeInner.uBoundValInner != nil && sbvsc.widthSizeInner.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX) )
    {
        sbvMyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvMyFrame.width sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
    }
    
    
    return NO;
}


-(BOOL)myCalcHeight:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(MyRelativeLayout*)lsc sbvMyFrame:(MyFrame*)sbvMyFrame selfSize:(CGSize)selfSize
{
    
    if (sbvMyFrame.height == CGFLOAT_MAX)
    {
        if (sbvsc.heightSizeInner.dimeRelaVal != nil)
        {
            
            sbvMyFrame.height = [sbvsc.heightSizeInner measureWith:[self myCalcSubView:sbvsc.heightSizeInner.dimeRelaVal.view lsc:lsc gravity:sbvsc.heightSizeInner.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvMyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvMyFrame.height sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvsc.heightSizeInner.dimeNumVal != nil)
        {
            sbvMyFrame.height = sbvsc.heightSizeInner.measure;
            sbvMyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvMyFrame.height sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self myIsNoLayoutSubview:sbv])
        {
            sbvMyFrame.height = 0;
        }
        
        
        if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        {
            if (sbvsc.topPosInner.posRelaVal != nil)
                sbvMyFrame.top = [self myCalcSubView:sbvsc.topPosInner.posRelaVal.view lsc:lsc  gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
            else
                sbvMyFrame.top = sbvsc.topPosInner.absVal + lsc.topPadding;
            
            if (sbvsc.bottomPosInner.posRelaVal != nil)
                sbvMyFrame.bottom = [self myCalcSubView:sbvsc.bottomPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal;
            else
                sbvMyFrame.bottom = selfSize.height - sbvsc.bottomPosInner.absVal - lsc.bottomPadding;
            
            sbvMyFrame.height = sbvMyFrame.bottom - sbvMyFrame.top;
            sbvMyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvMyFrame.height sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self myIsNoLayoutSubview:sbv])
            {
                sbvMyFrame.height = 0;
                sbvMyFrame.bottom = sbvMyFrame.top + sbvMyFrame.height;
            }
            
            
            return YES;
            
        }
        
        
        if (sbvMyFrame.height == CGFLOAT_MAX)
        {
            sbvMyFrame.height = CGRectGetHeight(sbv.bounds);
            
            if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && ![self myIsNoLayoutSubview:sbv])
            {
                if (sbvMyFrame.width == CGFLOAT_MAX)
                    [self myCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
                
                sbvMyFrame.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:sbvMyFrame.width];
            }
            
            sbvMyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvMyFrame.height sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
            
            
        }
    }
    
    if ( (sbvsc.heightSizeInner.lBoundValInner != nil && sbvsc.heightSizeInner.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvsc.heightSizeInner.uBoundValInner != nil && sbvsc.heightSizeInner.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX))
    {
        sbvMyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvMyFrame.height sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
    }
    
    return NO;
    
}


-(CGSize)myCalcLayout:(BOOL*)pRecalc lsc:(MyRelativeLayout*)lsc selfSize:(CGSize)selfSize
{
    if (pRecalc != NULL)
        *pRecalc = NO;
    
    
    //遍历所有子视图，算出所有宽度和高度根据自身内容确定的子视图的尺寸.以及计算出那些有依赖关系的尺寸限制。。。
    for (UIView *sbv in self.subviews)
    {
        UIView *sbvsc = sbv.myCurrentSizeClass;
        MyFrame *sbvMyFrame = sbv.myFrame;
        
        
        
        [self myCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvMyFrame:sbvMyFrame selfLayoutSize:selfSize];
        
        if (sbvMyFrame.width != CGFLOAT_MAX)
        {
            if (sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcWidth:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view
                            sbvsc:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                              lsc:lsc
                       sbvMyFrame:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.myFrame
                         selfSize:selfSize];
            }
            
            if (sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcWidth:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view
                            sbvsc:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                              lsc:lsc
                       sbvMyFrame:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.myFrame
                         selfSize:selfSize];
            }
            
            sbvMyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvMyFrame.width sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
        }
        
        if (sbvMyFrame.height != CGFLOAT_MAX)
        {
            if (sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcHeight:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view
                             sbvsc:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                               lsc:lsc
                        sbvMyFrame:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.myFrame
                          selfSize:selfSize];
            }
            
            if (sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcHeight:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view
                             sbvsc:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                               lsc:lsc
                        sbvMyFrame:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.myFrame
                          selfSize:selfSize];
            }
            
            sbvMyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvMyFrame.height sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
        }
        
    }
    
    //均分宽度和高度。把这部分提出来是为了实现不管数组是哪个视图指定都可以。
    for (UIView *sbv in self.subviews)
    {
        UIView *sbvsc = sbv.myCurrentSizeClass;
        MyFrame *sbvMyFrame = sbv.myFrame;
        
        
        
        if (sbvsc.widthSizeInner.dimeArrVal != nil)
        {
            if (pRecalc != NULL)
                *pRecalc = YES;
            
            NSArray *dimeArray = sbvsc.widthSizeInner.dimeArrVal;
            
            BOOL isViewHidden = [self myIsNoLayoutSubview:sbv] && lsc.flexOtherViewWidthWhenSubviewHidden;
            CGFloat totalMulti = isViewHidden ? 0 : sbvsc.widthSizeInner.multiVal;
            CGFloat totalAdd =  isViewHidden ? 0 : sbvsc.widthSizeInner.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                
                if (dime.isActive)
                {
                    isViewHidden = [self myIsNoLayoutSubview:dime.view] && lsc.flexOtherViewWidthWhenSubviewHidden;
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
            
            CGFloat floatWidth = selfSize.width - lsc.leadingPadding - lsc.trailingPadding + totalAdd;
            if ( _myCGFloatLessOrEqual(floatWidth, 0))
                floatWidth = 0;
            
            if (totalMulti != 0)
            {
                sbvMyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:floatWidth * (sbvsc.widthSizeInner.multiVal / totalMulti) sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self myIsNoLayoutSubview:sbv])
                    sbvMyFrame.width = 0;
                
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
        
        if (sbvsc.heightSizeInner.dimeArrVal != nil)
        {
            if (pRecalc != NULL)
                *pRecalc = YES;
            
            NSArray *dimeArray = sbvsc.heightSizeInner.dimeArrVal;
            
            BOOL isViewHidden = [self myIsNoLayoutSubview:sbv] && lsc.flexOtherViewHeightWhenSubviewHidden;
            
            CGFloat totalMulti = isViewHidden ? 0 : sbvsc.heightSizeInner.multiVal;
            CGFloat totalAdd = isViewHidden ? 0 : sbvsc.heightSizeInner.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                if (dime.isActive)
                {
                    isViewHidden = [self myIsNoLayoutSubview:dime.view] && lsc.flexOtherViewHeightWhenSubviewHidden;
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
            
            CGFloat floatHeight = selfSize.height - lsc.topPadding - lsc.bottomPadding + totalAdd;
            if (_myCGFloatLessOrEqual(floatHeight, 0))
                floatHeight = 0;
            
            if (totalMulti != 0)
            {
                sbvMyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:floatHeight * (sbvsc.heightSizeInner.multiVal / totalMulti) sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self myIsNoLayoutSubview:sbv])
                    sbvMyFrame.height = 0;
                
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
        if (sbvsc.centerXPosInner.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *centerArray = sbvsc.centerXPosInner.posArrVal;
            
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
                            totalOffset += nextPos.view.centerXPos.absVal;
                    }
                    
                    [self myCalcWidth:pos.view sbvsc:pos.view.myCurrentSizeClass lsc:lsc sbvMyFrame:pos.view.myFrame selfSize:selfSize];
                    totalWidth += pos.view.myFrame.width;
                }
                
                nextPos = pos;
            }
            
            if (![self myIsNoLayoutSubview:sbv])
            {
                if (totalWidth != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerXPos.absVal;
                }
                
                [self myCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
                totalWidth += sbvMyFrame.width;
                totalOffset += sbvsc.centerXPosInner.absVal;
            }
            
            
            //所有宽度算出后，再分别设置
            CGFloat leadingOffset = (selfSize.width - lsc.leadingPadding - lsc.trailingPadding - totalWidth - totalOffset) / 2;
            leadingOffset += lsc.leadingPadding;
            id prev = @(leadingOffset);
            [sbvsc.leadingPos __equalTo:prev];
            prev = sbvsc.trailingPos;
            for (MyLayoutPos *pos in centerArray)
            {
                [[pos.view.leadingPos __equalTo:prev] __offset:pos.view.centerXPos.absVal];
                prev = pos.view.trailingPos;
            }
        }
        
        //表示视图数组垂直居中
        if (sbvsc.centerYPosInner.posArrVal != nil)
        {
            NSArray *centerArray = sbvsc.centerYPosInner.posArrVal;
            
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
                            totalOffset += nextPos.view.centerYPos.absVal;
                    }
                    
                    [self myCalcHeight:pos.view sbvsc:pos.view.myCurrentSizeClass lsc:lsc sbvMyFrame:pos.view.myFrame selfSize:selfSize];
                    totalHeight += pos.view.myFrame.height;
                }
                
                nextPos = pos;
            }
            
            if (![self myIsNoLayoutSubview:sbv])
            {
                if (totalHeight != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerYPos.absVal;
                }
                
                [self myCalcHeight:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
                totalHeight += sbvMyFrame.height;
                totalOffset += sbvsc.centerYPosInner.absVal;
            }
            
            
            //所有高度算出后，再分别设置
            CGFloat topOffset = (selfSize.height - lsc.topPadding - lsc.bottomPadding - totalHeight - totalOffset) / 2;
            topOffset += lsc.topPadding;
            
            id prev = @(topOffset);
            [sbvsc.topPos __equalTo:prev];
            prev = sbvsc.bottomPos;
            for (MyLayoutPos *pos in centerArray)
            {
                [[pos.view.topPos __equalTo:prev] __offset:pos.view.centerYPos.absVal];
                prev = pos.view.bottomPos;
            }
            
        }
        
        
    }
    
    //计算最大的宽度和高度
    CGFloat maxWidth = lsc.leadingPadding + lsc.trailingPadding;
    CGFloat maxHeight = lsc.topPadding + lsc.bottomPadding;
    
    for (UIView *sbv in self.subviews)
    {
        
        UIView *sbvsc = sbv.myCurrentSizeClass;
        MyFrame *sbvMyFrame = sbv.myFrame;
        BOOL sbvWrapContentHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]];
        
        [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
        
        //特殊处理高度包裹的情况，如果高度包裹时则同时设置顶部和底部将无效。
        if (sbvWrapContentHeight)
        {
            sbvMyFrame.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:sbvMyFrame.width];
            sbvMyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvMyFrame.height sbvSize:sbvMyFrame.frame.size selfLayoutSize:selfSize];
        }
        
        [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvMyFrame:sbvMyFrame selfSize:selfSize];
        
        if ([self myIsNoLayoutSubview:sbv])
            continue;
        
        
        if (lsc.wrapContentWidth && pRecalc != NULL)
        {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了右边或者中间的值，或者宽度依赖父视图)
            if(sbvsc.trailingPosInner.posNumVal != nil ||
               sbvsc.trailingPosInner.posRelaVal.view == self ||
               sbvsc.centerXPosInner.posRelaVal.view == self ||
               sbvsc.centerXPosInner.posNumVal != nil ||
               sbvsc.widthSizeInner.dimeRelaVal.view == self
               )
            {
                *pRecalc = YES;
            }
            
            //宽度最小是任何一个子视图的左右偏移和外加内边距和。
            if (maxWidth < sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.leadingPadding + lsc.trailingPadding)
            {
                maxWidth = sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.leadingPadding + lsc.trailingPadding;
            }
            
            if (sbvsc.widthSizeInner.dimeRelaVal == nil || sbvsc.widthSizeInner.dimeRelaVal != self.widthSizeInner)
            {
                if (sbvsc.centerXPosInner.posVal != nil)
                {
                    if (maxWidth < sbvMyFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.leadingPadding + lsc.trailingPadding)
                        maxWidth = sbvMyFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.leadingPadding + lsc.trailingPadding;
                }
                else if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
                {
                    if (maxWidth < fabs(sbvMyFrame.trailing) + sbvsc.leadingPosInner.absVal + lsc.leadingPadding)
                    {
                        maxWidth = fabs(sbvMyFrame.trailing) + sbvsc.leadingPosInner.absVal + lsc.leadingPadding;
                    }
                    
                }
                else if (sbvsc.trailingPosInner.posVal != nil)
                {
                    if (maxWidth < fabs(sbvMyFrame.leading) + lsc.leadingPadding)
                        maxWidth = fabs(sbvMyFrame.leading) + lsc.leadingPadding;
                }
                else
                {
                    if (maxWidth < fabs(sbvMyFrame.trailing) + lsc.trailingPadding)
                        maxWidth = fabs(sbvMyFrame.trailing) + lsc.trailingPadding;
                }
                
                
                if (maxWidth < sbvMyFrame.trailing + sbvsc.trailingPosInner.absVal + lsc.trailingPadding)
                    maxWidth = sbvMyFrame.trailing + sbvsc.trailingPosInner.absVal + lsc.trailingPadding;
            }
        }
        
        if (lsc.wrapContentHeight && pRecalc != NULL)
        {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了下边或者中间的值，或者高度依赖父视图)
            if(sbvsc.bottomPosInner.posNumVal != nil ||
               sbvsc.bottomPosInner.posRelaVal.view == self ||
               sbvsc.centerYPosInner.posRelaVal.view == self ||
               sbvsc.centerYPosInner.posNumVal != nil ||
               sbvsc.heightSizeInner.dimeRelaVal.view == self
               )
            {
                *pRecalc = YES;
            }
            
            if (maxHeight < sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.topPadding + lsc.bottomPadding)
            {
                maxHeight = sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.topPadding + lsc.bottomPadding;
            }
            
            
            //这里加入特殊的条件sbvWrapContentHeight，因为有可能有同时设置顶部和底部位置又同时设置wrapContentHeight的情况，这种情况我们也让其加入最大高度计算行列。
            if (sbvsc.heightSizeInner.dimeRelaVal == nil || sbvsc.heightSizeInner.dimeRelaVal != self.heightSizeInner)
            {
                
                if (sbvsc.centerYPosInner.posVal != nil)
                {
                    if (maxHeight < sbvMyFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.topPadding + lsc.bottomPadding)
                        maxHeight = sbvMyFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.topPadding + lsc.bottomPadding;
                }
                else if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
                {
                    if (maxHeight < fabs(sbvMyFrame.bottom) + sbvsc.topPosInner.absVal + lsc.topPadding)
                    {
                        maxHeight = fabs(sbvMyFrame.bottom) + sbvsc.topPosInner.absVal + lsc.topPadding;
                    }
                }
                else if (sbvsc.bottomPosInner.posVal != nil)
                {
                    if (maxHeight < fabs(sbvMyFrame.top) + lsc.topPadding)
                        maxHeight = fabs(sbvMyFrame.top) + lsc.topPadding;
                }
                else
                {
                    if (maxHeight < fabs(sbvMyFrame.bottom) + lsc.bottomPadding)
                        maxHeight = fabs(sbvMyFrame.bottom) + lsc.bottomPadding;
                }
                
                
                if (maxHeight < sbvMyFrame.bottom + sbvsc.bottomPosInner.absVal + lsc.bottomPadding)
                    maxHeight = sbvMyFrame.bottom + sbvsc.bottomPosInner.absVal + lsc.bottomPadding;
                
            }
        }
    }
    
    
    return CGSizeMake(maxWidth, maxHeight);
    
}



@end

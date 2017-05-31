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
    NSAssert(0, @"oops!, flexOtherViewWidthWhenSubviewHidden is invalid please use subview's myVisibility to instead!!!");
}

-(BOOL)flexOtherViewWidthWhenSubviewHidden
{
    return NO;
}

-(void)setFlexOtherViewHeightWhenSubviewHidden:(BOOL)flexOtherViewHeightWhenSubviewHidden
{
    NSAssert(0, @"oops!, flexOtherViewHeightWhenSubviewHidden is invalid please use subview's myVisibility to instead!!!");
}

-(BOOL)flexOtherViewHeightWhenSubviewHidden
{
    return NO;
}

#pragma mark -- Override Method

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    MyRelativeLayout *lsc = self.myCurrentSizeClass;
    
    
    for (UIView *sbv in self.subviews)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
       
        if (sbvsc.useFrame)
            continue;
        
        if (!isEstimate || (pHasSubLayout != nil && (*pHasSubLayout) == YES))
            [sbvmyFrame reset];
        
        
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
                [(MyBaseLayout*)sbv estimateLayoutRect:sbvmyFrame.frame.size inSizeClass:sizeClass];
                
                sbvmyFrame.leading = sbvmyFrame.trailing = sbvmyFrame.top = sbvmyFrame.bottom = CGFLOAT_MAX;
                
                if (sbvmyFrame.multiple)
                {
                    sbvmyFrame.sizeClass = [sbv myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    sbvsc = sbvmyFrame.sizeClass;
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
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    //如果是布局视图则不清除尺寸，其他清除。
                    if (isEstimate  && [sbv isKindOfClass:[MyBaseLayout class]])
                    {
                        sbvmyFrame.leading = sbvmyFrame.trailing = sbvmyFrame.top = sbvmyFrame.bottom = CGFLOAT_MAX;
                    }
                    else
                        [sbvmyFrame reset];
                }
                
                [self myCalcLayout:NULL lsc:lsc selfSize:selfSize];
            }
        }
        
    }
    
    
    //调整布局视图自己的尺寸。
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    //如果是反向则调整所有子视图的左右位置。
    NSArray *sbs2 = [self myGetLayoutSubviews];
    
    [self myAdjustSubviewsRTLPos:sbs2 selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs2 lsc:lsc];
    
}

-(id)createSizeClassInstance
{
    return [MyRelativeLayoutViewSizeClass new];
}



#pragma mark -- Private Method
-(void)myCalcSubViewLeadingTrailing:(UIView*)sbv
                              sbvsc:(UIView*)sbvsc
                                lsc:(MyRelativeLayout*)lsc
                         sbvmyFrame:(MyFrame*)sbvmyFrame
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
    
    
    
    if (sbvmyFrame.leading != CGFLOAT_MAX && sbvmyFrame.trailing != CGFLOAT_MAX && sbvmyFrame.width != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self myCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize])
        return;
    
    
    if (sbvsc.centerXPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerXPosInner.posRelaVal.view;
        
        sbvmyFrame.leading = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.centerXPosInner.posRelaVal.pos selfSize:selfSize] - sbvmyFrame.width / 2 +  sbvsc.centerXPosInner.absVal;
        
        if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
        {
            sbvmyFrame.leading -= sbvsc.centerXPosInner.absVal;
        }
        
        if (sbvmyFrame.leading < 0 && relaView == self && lsc.wrapContentWidth)
            sbvmyFrame.leading = 0;
        
        sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
    }
    else if (sbvsc.centerXPosInner.posNumVal != nil)
    {
        sbvmyFrame.leading = (selfSize.width - lsc.leadingPadding - lsc.trailingPadding - sbvmyFrame.width) / 2 + lsc.leadingPadding + sbvsc.centerXPosInner.absVal;
        
        if (sbvmyFrame.leading < 0 && lsc.wrapContentWidth)
            sbvmyFrame.leading = 0;
        
        sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
    }
    else
    {
        //如果左右都设置了则上上面的calcWidth会直接返回不会进入这个流程。
        if (sbvsc.leadingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.leadingPosInner.posRelaVal.view;
            
            sbvmyFrame.leading = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvmyFrame.leading -= sbvsc.leadingPosInner.absVal;
            }
            
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
        }
        else if (sbvsc.leadingPosInner.posNumVal != nil)
        {
            sbvmyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.leadingPadding;
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
        }
        else if (sbvsc.trailingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.trailingPosInner.posRelaVal.view;
            
            
            sbvmyFrame.trailing = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvmyFrame.trailing += sbvsc.trailingPosInner.absVal;
            }
            
            sbvmyFrame.leading = sbvmyFrame.trailing - sbvmyFrame.width;
            
        }
        else if (sbvsc.trailingPosInner.posNumVal != nil)
        {
            sbvmyFrame.trailing = selfSize.width -  lsc.trailingPadding -  sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            sbvmyFrame.leading = sbvmyFrame.trailing - sbvmyFrame.width;
        }
        else
        {
            
            sbvmyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.leadingPadding;
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
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
        if (intervalWidth < sbvmyFrame.width)
        {
            sbvmyFrame.width = intervalWidth;
            sbvmyFrame.leading = minLeading;
        }
        else
        {
            sbvmyFrame.leading = (intervalWidth - sbvmyFrame.width) / 2 + minLeading;
        }
        
        sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
        
        
    }
    else if (lBoundPos.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minLeading = [self myCalcSubView:lBoundPos.posRelaVal.view lsc:lsc gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        
        
        if (sbvmyFrame.leading < minLeading)
        {
            sbvmyFrame.leading = minLeading;
            sbvmyFrame.width = sbvmyFrame.trailing - sbvmyFrame.leading;
        }
    }
    else if (uBoundPos.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxTrailing = [self myCalcSubView:uBoundPos.posRelaVal.view lsc:lsc gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] -  uBoundPos.offsetVal;
        
        if (sbvmyFrame.trailing > maxTrailing)
        {
            sbvmyFrame.trailing = maxTrailing;
            sbvmyFrame.width = sbvmyFrame.trailing - sbvmyFrame.leading;
        }
    }
    
    
}

-(void)myCalcSubViewTopBottom:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(MyRelativeLayout*)lsc sbvmyFrame:(MyFrame*)sbvmyFrame selfSize:(CGSize)selfSize
{
    
    
    if (sbvmyFrame.top != CGFLOAT_MAX && sbvmyFrame.bottom != CGFLOAT_MAX && sbvmyFrame.height != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self myCalcHeight:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize])
        return;
    
    if (sbvsc.centerYPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerYPosInner.posRelaVal.view;
        
        sbvmyFrame.top = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.centerYPosInner.posRelaVal.pos selfSize:selfSize] - sbvmyFrame.height / 2 + sbvsc.centerYPosInner.absVal;
        
        
        if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
        {
            sbvmyFrame.top -= sbvsc.centerYPosInner.absVal;
        }
        
        if (sbvmyFrame.top < 0 && relaView == self && lsc.wrapContentHeight)
            sbvmyFrame.top = 0;
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
    }
    else if (sbvsc.centerYPosInner.posNumVal != nil)
    {
        sbvmyFrame.top = (selfSize.height - lsc.topPadding - lsc.bottomPadding -  sbvmyFrame.height) / 2 + lsc.topPadding + sbvsc.centerYPosInner.absVal;
        
        if (sbvmyFrame.top < 0 && lsc.wrapContentHeight)
            sbvmyFrame.top = 0;
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
    }
    else
    {
        if (sbvsc.topPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.topPosInner.posRelaVal.view;
            
            sbvmyFrame.top = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvmyFrame.top -= sbvsc.topPosInner.absVal;
            }
            
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
        }
        else if (sbvsc.topPosInner.posNumVal != nil)
        {
            sbvmyFrame.top = sbvsc.topPosInner.absVal + lsc.topPadding;
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
        }
        else if (sbvsc.bottomPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.bottomPosInner.posRelaVal.view;
            
            sbvmyFrame.bottom = [self myCalcSubView:relaView lsc:lsc gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal + sbvsc.topPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            {
                sbvmyFrame.bottom += sbvsc.bottomPosInner.absVal;
            }
            
            sbvmyFrame.top = sbvmyFrame.bottom - sbvmyFrame.height;
            
        }
        else if (sbvsc.bottomPosInner.posNumVal != nil)
        {
            if (selfSize.height == 0 && lsc.wrapContentHeight)
            {
                sbvmyFrame.top = lsc.topPadding;
                sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
            }
            else
            {
                
                sbvmyFrame.bottom = selfSize.height -  sbvsc.bottomPosInner.absVal - lsc.bottomPadding + sbvsc.topPosInner.absVal;
                sbvmyFrame.top = sbvmyFrame.bottom - sbvmyFrame.height;
            }
        }
        else
        {
            sbvmyFrame.top = sbvsc.topPosInner.absVal + lsc.topPadding;
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
        }
    }
    
    //这里要更新上边最小和下边最大约束的情况。
    if (sbvsc.topPosInner.lBoundValInner.posRelaVal != nil && sbvsc.bottomPosInner.uBoundValInner.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minTop = [self myCalcSubView:sbvsc.topPosInner.lBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.topPosInner.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.lBoundValInner.offsetVal;
        
        CGFloat   maxBottom = [self myCalcSubView:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.uBoundValInner.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        if (maxBottom - minTop < sbvmyFrame.height)
        {
            sbvmyFrame.height = maxBottom - minTop;
            sbvmyFrame.top = minTop;
        }
        else
        {
            sbvmyFrame.top = (maxBottom - minTop - sbvmyFrame.height) / 2 + minTop;
        }
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
        
        
    }
    else if (sbvsc.topPosInner.lBoundValInner.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minTop = [self myCalcSubView:sbvsc.topPosInner.lBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.topPosInner.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.lBoundValInner.offsetVal;
        
        if (sbvmyFrame.top < minTop)
        {
            sbvmyFrame.top = minTop;
            sbvmyFrame.height = sbvmyFrame.bottom - sbvmyFrame.top;
        }
        
    }
    else if (sbvsc.bottomPosInner.uBoundValInner.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxBottom = [self myCalcSubView:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.uBoundValInner.offsetVal;
        if (sbvmyFrame.bottom > maxBottom)
        {
            sbvmyFrame.bottom = maxBottom;
            sbvmyFrame.height = sbvmyFrame.bottom - sbvmyFrame.top;
        }
        
    }
    
    
}



-(CGFloat)myCalcSubView:(UIView*)sbv lsc:(MyRelativeLayout*)lsc gravity:(MyGravity)gravity selfSize:(CGSize)selfSize
{
    MyFrame *sbvmyFrame = sbv.myFrame;
    UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
    
    switch (gravity) {
        case MyGravity_Horz_Leading:
        {
            if (sbv == self || sbv == nil)
                return lsc.leadingPadding;
            
            
            if (sbvmyFrame.leading != CGFLOAT_MAX)
                return sbvmyFrame.leading;
            
            [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.leading;
            
        }
            break;
        case MyGravity_Horz_Trailing:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.trailingPadding;
            
            if (sbvmyFrame.trailing != CGFLOAT_MAX)
                return sbvmyFrame.trailing;
            
            [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.trailing;
            
        }
            break;
        case MyGravity_Vert_Top:
        {
            if (sbv == self || sbv == nil)
                return lsc.topPadding;
            
            
            if (sbvmyFrame.top != CGFLOAT_MAX)
                return sbvmyFrame.top;
            
            [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.top;
            
        }
            break;
        case MyGravity_Vert_Bottom:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.bottomPadding;
            
            
            if (sbvmyFrame.bottom != CGFLOAT_MAX)
                return sbvmyFrame.bottom;
            
            [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.bottom;
        }
            break;
        case MyGravity_Horz_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.leadingPadding - lsc.trailingPadding;
            
            
            if (sbvmyFrame.width != CGFLOAT_MAX)
                return sbvmyFrame.width;
            
            [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.width;
            
        }
            break;
        case MyGravity_Vert_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.topPadding - lsc.bottomPadding;
            
            
            if (sbvmyFrame.height != CGFLOAT_MAX)
                return sbvmyFrame.height;
            
            [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.height;
        }
            break;
        case MyGravity_Horz_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.width - lsc.leadingPadding - lsc.trailingPadding) / 2 + lsc.leadingPadding;
            
            if (sbvmyFrame.leading != CGFLOAT_MAX && sbvmyFrame.trailing != CGFLOAT_MAX &&  sbvmyFrame.width != CGFLOAT_MAX)
                return sbvmyFrame.leading + sbvmyFrame.width / 2;
            
            [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.leading + sbvmyFrame.width / 2;
            
        }
            break;
            
        case MyGravity_Vert_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.height - lsc.topPadding - lsc.bottomPadding) / 2 + lsc.topPadding;
            
            if (sbvmyFrame.top != CGFLOAT_MAX && sbvmyFrame.bottom != CGFLOAT_MAX &&  sbvmyFrame.height != CGFLOAT_MAX)
                return sbvmyFrame.top + sbvmyFrame.height / 2;
            
            [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.top + sbvmyFrame.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)myCalcWidth:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(MyRelativeLayout*)lsc sbvmyFrame:(MyFrame*)sbvmyFrame selfSize:(CGSize)selfSize
{
    
    if (sbvmyFrame.width == CGFLOAT_MAX)
    {
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil)
        {
            
            sbvmyFrame.width = [sbvsc.widthSizeInner measureWith:[self myCalcSubView:sbvsc.widthSizeInner.dimeRelaVal.view lsc:lsc gravity:sbvsc.widthSizeInner.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvsc.widthSizeInner.dimeNumVal != nil)
        {
            sbvmyFrame.width = sbvsc.widthSizeInner.measure;
            sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self myIsNoLayoutSubview:sbv])
        {
            sbvmyFrame.width = 0;
        }
        
        if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        {
            if (sbvsc.leadingPosInner.posRelaVal != nil)
                sbvmyFrame.leading = [self myCalcSubView:sbvsc.leadingPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
            else
                sbvmyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.leadingPadding;
            
            if (sbvsc.trailingPosInner.posRelaVal != nil)
                sbvmyFrame.trailing = [self myCalcSubView:sbvsc.trailingPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal;
            else
                sbvmyFrame.trailing = selfSize.width - sbvsc.trailingPosInner.absVal - lsc.trailingPadding;
            
            sbvmyFrame.width = sbvmyFrame.trailing - sbvmyFrame.leading;
            sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self myIsNoLayoutSubview:sbv])
            {
                sbvmyFrame.width = 0;
                sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
            }
            
            
            return YES;
            
        }
        
        
        if (sbvmyFrame.width == CGFLOAT_MAX)
        {
            sbvmyFrame.width = CGRectGetWidth(sbv.bounds);
            sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        }
    }
    
    if ((sbvsc.widthSizeInner.lBoundValInner != nil && sbvsc.widthSizeInner.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvsc.widthSizeInner.uBoundValInner != nil && sbvsc.widthSizeInner.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX) )
    {
        sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
    }
    
    
    return NO;
}


-(BOOL)myCalcHeight:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(MyRelativeLayout*)lsc sbvmyFrame:(MyFrame*)sbvmyFrame selfSize:(CGSize)selfSize
{
    
    if (sbvmyFrame.height == CGFLOAT_MAX)
    {
        if (sbvsc.heightSizeInner.dimeRelaVal != nil)
        {
            
            sbvmyFrame.height = [sbvsc.heightSizeInner measureWith:[self myCalcSubView:sbvsc.heightSizeInner.dimeRelaVal.view lsc:lsc gravity:sbvsc.heightSizeInner.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvsc.heightSizeInner.dimeNumVal != nil)
        {
            sbvmyFrame.height = sbvsc.heightSizeInner.measure;
            sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self myIsNoLayoutSubview:sbv])
        {
            sbvmyFrame.height = 0;
        }
        
        
        if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        {
            if (sbvsc.topPosInner.posRelaVal != nil)
                sbvmyFrame.top = [self myCalcSubView:sbvsc.topPosInner.posRelaVal.view lsc:lsc  gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
            else
                sbvmyFrame.top = sbvsc.topPosInner.absVal + lsc.topPadding;
            
            if (sbvsc.bottomPosInner.posRelaVal != nil)
                sbvmyFrame.bottom = [self myCalcSubView:sbvsc.bottomPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal;
            else
                sbvmyFrame.bottom = selfSize.height - sbvsc.bottomPosInner.absVal - lsc.bottomPadding;
            
            sbvmyFrame.height = sbvmyFrame.bottom - sbvmyFrame.top;
            sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self myIsNoLayoutSubview:sbv])
            {
                sbvmyFrame.height = 0;
                sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
            }
            
            
            return YES;
            
        }
        
        
        if (sbvmyFrame.height == CGFLOAT_MAX)
        {
            sbvmyFrame.height = CGRectGetHeight(sbv.bounds);
            
            if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]] && ![self myIsNoLayoutSubview:sbv])
            {
                if (sbvmyFrame.width == CGFLOAT_MAX)
                    [self myCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
                
                sbvmyFrame.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:sbvmyFrame.width];
            }
            
            sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            
        }
    }
    
    if ( (sbvsc.heightSizeInner.lBoundValInner != nil && sbvsc.heightSizeInner.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvsc.heightSizeInner.uBoundValInner != nil && sbvsc.heightSizeInner.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX))
    {
        sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
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
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        
        [self myCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame selfLayoutSize:selfSize];
        
        if (sbvmyFrame.width != CGFLOAT_MAX)
        {
            if (sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcWidth:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view
                            sbvsc:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                              lsc:lsc
                       sbvmyFrame:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.myFrame
                         selfSize:selfSize];
            }
            
            if (sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcWidth:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view
                            sbvsc:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                              lsc:lsc
                       sbvmyFrame:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.myFrame
                         selfSize:selfSize];
            }
            
            sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        }
        
        if (sbvmyFrame.height != CGFLOAT_MAX)
        {
            if (sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcHeight:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view
                             sbvsc:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                               lsc:lsc
                        sbvmyFrame:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.myFrame
                          selfSize:selfSize];
            }
            
            if (sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self myCalcHeight:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view
                             sbvsc:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                               lsc:lsc
                        sbvmyFrame:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.myFrame
                          selfSize:selfSize];
            }
            
            sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        }
        
    }
    
    //均分宽度和高度。把这部分提出来是为了实现不管数组是哪个视图指定都可以。
    for (UIView *sbv in self.subviews)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.widthSizeInner.dimeArrVal != nil)
        {
            if (pRecalc != NULL)
                *pRecalc = YES;
            
            NSArray *dimeArray = sbvsc.widthSizeInner.dimeArrVal;
            
            BOOL isViewHidden = [self myIsNoLayoutSubview:sbv];
            CGFloat totalMulti = isViewHidden ? 0 : sbvsc.widthSizeInner.multiVal;
            CGFloat totalAdd =  isViewHidden ? 0 : sbvsc.widthSizeInner.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                
                if (dime.isActive)
                {
                    isViewHidden = [self myIsNoLayoutSubview:dime.view];
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
                sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:floatWidth * (sbvsc.widthSizeInner.multiVal / totalMulti) sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self myIsNoLayoutSubview:sbv])
                    sbvmyFrame.width = 0;
                
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
            
            BOOL isViewHidden = [self myIsNoLayoutSubview:sbv];
            
            CGFloat totalMulti = isViewHidden ? 0 : sbvsc.heightSizeInner.multiVal;
            CGFloat totalAdd = isViewHidden ? 0 : sbvsc.heightSizeInner.addVal;
            for (MyLayoutSize *dime in dimeArray)
            {
                if (dime.isActive)
                {
                    isViewHidden = [self myIsNoLayoutSubview:dime.view];
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
                sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:floatHeight * (sbvsc.heightSizeInner.multiVal / totalMulti) sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self myIsNoLayoutSubview:sbv])
                    sbvmyFrame.height = 0;
                
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
                    
                    [self myCalcWidth:pos.view sbvsc:pos.view.myCurrentSizeClass lsc:lsc sbvmyFrame:pos.view.myFrame selfSize:selfSize];
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
                
                [self myCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
                totalWidth += sbvmyFrame.width;
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
                    
                    [self myCalcHeight:pos.view sbvsc:pos.view.myCurrentSizeClass lsc:lsc sbvmyFrame:pos.view.myFrame selfSize:selfSize];
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
                
                [self myCalcHeight:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
                totalHeight += sbvmyFrame.height;
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
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        BOOL sbvWrapContentHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]];
        
        [self myCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
        
        //特殊处理高度包裹的情况，如果高度包裹时则同时设置顶部和底部将无效。
        if (sbvWrapContentHeight)
        {
            sbvmyFrame.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:sbvmyFrame.width];
            sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        }
        
        [self myCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
        
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
                    if (maxWidth < sbvmyFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.leadingPadding + lsc.trailingPadding)
                        maxWidth = sbvmyFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.leadingPadding + lsc.trailingPadding;
                }
                else if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
                {
                    if (maxWidth < fabs(sbvmyFrame.trailing) + sbvsc.leadingPosInner.absVal + lsc.leadingPadding)
                    {
                        maxWidth = fabs(sbvmyFrame.trailing) + sbvsc.leadingPosInner.absVal + lsc.leadingPadding;
                    }
                    
                }
                else if (sbvsc.trailingPosInner.posVal != nil)
                {
                    if (maxWidth < fabs(sbvmyFrame.leading) + lsc.leadingPadding)
                        maxWidth = fabs(sbvmyFrame.leading) + lsc.leadingPadding;
                }
                else
                {
                    if (maxWidth < fabs(sbvmyFrame.trailing) + lsc.trailingPadding)
                        maxWidth = fabs(sbvmyFrame.trailing) + lsc.trailingPadding;
                }
                
                
                if (maxWidth < sbvmyFrame.trailing + sbvsc.trailingPosInner.absVal + lsc.trailingPadding)
                    maxWidth = sbvmyFrame.trailing + sbvsc.trailingPosInner.absVal + lsc.trailingPadding;
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
                    if (maxHeight < sbvmyFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.topPadding + lsc.bottomPadding)
                        maxHeight = sbvmyFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.topPadding + lsc.bottomPadding;
                }
                else if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
                {
                    if (maxHeight < fabs(sbvmyFrame.bottom) + sbvsc.topPosInner.absVal + lsc.topPadding)
                    {
                        maxHeight = fabs(sbvmyFrame.bottom) + sbvsc.topPosInner.absVal + lsc.topPadding;
                    }
                }
                else if (sbvsc.bottomPosInner.posVal != nil)
                {
                    if (maxHeight < fabs(sbvmyFrame.top) + lsc.topPadding)
                        maxHeight = fabs(sbvmyFrame.top) + lsc.topPadding;
                }
                else
                {
                    if (maxHeight < fabs(sbvmyFrame.bottom) + lsc.bottomPadding)
                        maxHeight = fabs(sbvmyFrame.bottom) + lsc.bottomPadding;
                }
                
                
                if (maxHeight < sbvmyFrame.bottom + sbvsc.bottomPosInner.absVal + lsc.bottomPadding)
                    maxHeight = sbvmyFrame.bottom + sbvsc.bottomPosInner.absVal + lsc.bottomPadding;
                
            }
        }
    }
    
    
    return CGSizeMake(maxWidth, maxHeight);
    
}



@end

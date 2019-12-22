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


#pragma mark -- Override Methods

-(CGSize)calcLayoutSize:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutSize:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    MyRelativeLayoutViewSizeClass *lsc = (MyRelativeLayoutViewSizeClass*)self.myCurrentSizeClass;
    if (lsc.widthSizeInner.dimeWrapVal)
        selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:0 sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    if (lsc.heightSizeInner.dimeWrapVal)
        selfSize.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:0 sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    for (UIView *sbv in self.subviews)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
       
        if (sbvsc.useFrame)
            continue;
        
        if (!isEstimate)
            [sbvmyFrame reset];
        
       
        //只要同时设置了左右边距且宽度优先级很低则把宽度值置空
        if (sbvsc.leadingPosInner.posVal != nil &&
            sbvsc.trailingPosInner.posVal != nil &&
            (sbvsc.widthSizeInner.priority == MyPriority_Low || !lsc.widthSizeInner.dimeWrapVal))
            [sbvsc.widthSizeInner __equalTo:nil];
        
        //只要同时设置了上下边距且高度优先级很低则把高度值置空
        if (sbvsc.topPosInner.posVal != nil &&
            sbvsc.bottomPosInner.posVal != nil &&
            (sbvsc.heightSizeInner.priority == MyPriority_Low || !lsc.heightSizeInner.dimeWrapVal))
            [sbvsc.heightSizeInner __equalTo:nil];

        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            if (pHasSubLayout != nil && (sbvsc.heightSizeInner.dimeWrapVal || sbvsc.widthSizeInner.dimeWrapVal))
                *pHasSubLayout = YES;
            
            if (sbvsc.widthSizeInner.dimeWrapVal || sbvsc.heightSizeInner.dimeWrapVal)
            {
                if (isEstimate)
                {
                    [(MyBaseLayout*)sbv sizeThatFits:sbvmyFrame.frame.size inSizeClass:sizeClass];
                    
                    sbvmyFrame.leading = sbvmyFrame.trailing = sbvmyFrame.top = sbvmyFrame.bottom = CGFLOAT_MAX;
                    
                    //因为sizeThatFits执行后会还原，所以这里要重新设置
                    if (sbvmyFrame.multiple)
                        sbvmyFrame.sizeClass = [sbv myBestSizeClass:sizeClass myFrame:sbvmyFrame];
                }
            }
            else
                [sbvmyFrame reset];
        }
        else
        {
            [sbvmyFrame reset];
        }
    }
    
    
    BOOL reCalcWidth = NO;
    BOOL reCalcHeight = NO;
    CGSize maxSize = [self myLayout:lsc calcSelfSize:selfSize pRecalcWidth:&reCalcWidth pRecalcHeight:&reCalcHeight];
    
    //如果布局视图的尺寸自适应的，这里要调整一下布局视图的尺寸。但是因为有一些子视图的约束是依赖布局视图的而且可能会引发连锁反应，所以这里要再次进行重新布局处理
    if (lsc.widthSizeInner.dimeWrapVal || lsc.heightSizeInner.dimeWrapVal)
    {
        if (_myCGFloatNotEqual(selfSize.height, maxSize.height)  || _myCGFloatNotEqual(selfSize.width, maxSize.width))
        {
            if (lsc.widthSizeInner.dimeWrapVal)
                selfSize.width = maxSize.width;
            
            if (lsc.heightSizeInner.dimeWrapVal)
                selfSize.height = maxSize.height;
            
            //如果里面有需要重新计算的就重新计算布局
            if (reCalcWidth || reCalcHeight)
            {
                for (UIView *sbv in self.subviews)
                {
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    //如果是布局视图则不清除尺寸，其他清除。
                    if (isEstimate  && [sbv isKindOfClass:[MyBaseLayout class]])
                    {
                        if (reCalcWidth)
                            sbvmyFrame.leading = sbvmyFrame.trailing = CGFLOAT_MAX;
                        if (reCalcHeight)
                            sbvmyFrame.top = sbvmyFrame.bottom = CGFLOAT_MAX;
                    }
                    else
                    {
                        if (reCalcWidth)
                            sbvmyFrame.leading = sbvmyFrame.trailing = sbvmyFrame.width = CGFLOAT_MAX;
                        if (reCalcHeight)
                            sbvmyFrame.top = sbvmyFrame.bottom = sbvmyFrame.height = CGFLOAT_MAX;
                    }
                }
                
                [self myLayout:lsc calcSelfSize:selfSize pRecalcWidth:NULL pRecalcHeight:NULL];
            }
        }
        
    }

    //如果是反向则调整所有子视图的左右位置。
    sbs = [self myGetLayoutSubviews];
    return [self myLayout:lsc adjustSelfSize:selfSize withSubviews:sbs];
}

-(id)createSizeClassInstance
{
    return [MyRelativeLayoutViewSizeClass new];
}


#pragma mark -- Private Method
-(void)myLayout:(MyRelativeLayoutViewSizeClass*)lsc
calcLeadingTrailingOfSubview:(MyViewSizeClass*)sbvsc
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
    if ([self myLayout:lsc calcWidthOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize])
        return;
    
    UIView *sbv = sbvsc.view;
    
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
                
                [self myLayout:lsc calcWidthOfSubview:(MyViewSizeClass*)pos.view.myCurrentSizeClass sbvmyFrame:pos.view.myFrame selfSize:selfSize];
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
            
            [self myLayout:lsc calcWidthOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            totalWidth += sbvmyFrame.width;
            totalOffset += sbvsc.centerXPosInner.absVal;
        }
        
        
        //所有宽度算出后，再分别设置
        CGFloat leadingOffset = (selfSize.width - lsc.myLayoutLeadingPadding - lsc.myLayoutTrailingPadding - totalWidth - totalOffset) / 2;
        leadingOffset += lsc.myLayoutLeadingPadding;
        id prev = @(leadingOffset);
        [sbvsc.leadingPos __equalTo:prev];
        prev = sbvsc.trailingPos;
        for (MyLayoutPos *pos in centerArray)
        {
            [[pos.view.leadingPos __equalTo:prev] __offset:pos.view.centerXPos.absVal];
            prev = pos.view.trailingPos;
        }
    }
    
    if (sbvsc.centerXPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerXPosInner.posRelaVal.view;
        
        sbvmyFrame.leading = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.centerXPosInner.posRelaVal.pos selfSize:selfSize] - sbvmyFrame.width / 2 +  sbvsc.centerXPosInner.absVal;
        
        if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            sbvmyFrame.leading -= sbvsc.centerXPosInner.absVal;
        
        if (sbvmyFrame.leading < 0 && relaView == self && lsc.widthSizeInner.dimeWrapVal)
            sbvmyFrame.leading = 0;
        
        sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
    }
    else if (sbvsc.centerXPosInner.posMostVal != nil)
    {
        sbvmyFrame.leading = sbvsc.centerXPosInner.posMostVal.doubleValue - sbvmyFrame.width / 2 + sbvsc.centerXPosInner.absVal;
        sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
    }
    else if (sbvsc.centerXPosInner.posNumVal != nil)
    {
        sbvmyFrame.leading = (selfSize.width - lsc.myLayoutLeadingPadding - lsc.myLayoutTrailingPadding - sbvmyFrame.width) / 2 + lsc.myLayoutLeadingPadding + sbvsc.centerXPosInner.absVal;
        
        if (sbvmyFrame.leading < 0 && lsc.widthSizeInner.dimeWrapVal)
            sbvmyFrame.leading = 0;
        
        sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
    }
    else
    {
        //如果左右都设置了则上上面的calcWidth会直接返回不会进入这个流程。
        if (sbvsc.leadingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.leadingPosInner.posRelaVal.view;
            
            sbvmyFrame.leading = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                sbvmyFrame.leading -= sbvsc.leadingPosInner.absVal;
            
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width + sbvsc.trailingPosInner.absVal;
        }
        else if (sbvsc.leadingPosInner.posMostVal != nil)
        {
            sbvmyFrame.leading = sbvsc.leadingPosInner.posMostVal.doubleValue + sbvsc.leadingPosInner.absVal;
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width + sbvsc.trailingPosInner.absVal;
        }
        else if (sbvsc.leadingPosInner.posNumVal != nil)
        {
            sbvmyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.myLayoutLeadingPadding;
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width + sbvsc.trailingPosInner.absVal;
        }
        else if (sbvsc.trailingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.trailingPosInner.posRelaVal.view;
            
            sbvmyFrame.trailing = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                sbvmyFrame.trailing += sbvsc.trailingPosInner.absVal;
            
            sbvmyFrame.leading = sbvmyFrame.trailing - sbvmyFrame.width;
        }
        else if (sbvsc.trailingPosInner.posMostVal != nil)
        {
            sbvmyFrame.trailing = sbvsc.trailingPosInner.posMostVal.doubleValue - sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            sbvmyFrame.leading = sbvmyFrame.trailing - sbvmyFrame.width;
        }
        else if (sbvsc.trailingPosInner.posNumVal != nil)
        {
            sbvmyFrame.trailing = selfSize.width -
            sbvsc.trailingPosInner.absVal -
            lsc.myLayoutTrailingPadding;
            sbvmyFrame.leading = sbvmyFrame.trailing - sbvmyFrame.width;
        }
        else
        {
            sbvmyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.myLayoutLeadingPadding;
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
        }
    }
    
    //这里要更新左边最小和右边最大约束的情况。
    MyLayoutPos *lBoundPos = sbvsc.leadingPosInner.lBoundValInner;
    MyLayoutPos *uBoundPos = sbvsc.trailingPosInner.uBoundValInner;
    UIView *lBoundRelaView = lBoundPos.posRelaVal.view;
    UIView *uBoundRelaView = uBoundPos.posRelaVal.view;
    
    if (lBoundPos.posRelaVal != nil && uBoundPos.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minLeading = [self myLayout:lsc calcSizeOrPosOfSubview:lBoundRelaView gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        if (lBoundRelaView != nil && lBoundRelaView != self && [self myIsNoLayoutSubview:lBoundRelaView])
            minLeading -= lBoundPos.offsetVal;
        
        CGFloat  maxTrailing = [self myLayout:lsc calcSizeOrPosOfSubview:uBoundRelaView gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] - uBoundPos.offsetVal;
        if (uBoundRelaView != nil && uBoundRelaView != self && [self myIsNoLayoutSubview:uBoundRelaView])
            maxTrailing += uBoundPos.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        CGFloat intervalWidth = maxTrailing - minLeading;
        if (_myCGFloatLess(intervalWidth, sbvmyFrame.width))
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
        CGFloat minLeading = [self myLayout:lsc calcSizeOrPosOfSubview:lBoundRelaView gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        if (lBoundRelaView != nil && lBoundRelaView != self && [self myIsNoLayoutSubview:lBoundRelaView])
            minLeading -= lBoundPos.offsetVal;
        
        
        if (_myCGFloatLess(sbvmyFrame.leading, minLeading))
        {
            sbvmyFrame.leading = minLeading;
            sbvmyFrame.width = sbvmyFrame.trailing - sbvmyFrame.leading;
        }
    }
    else if (uBoundPos.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxTrailing = [self myLayout:lsc calcSizeOrPosOfSubview:uBoundRelaView gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] -  uBoundPos.offsetVal;
        if (uBoundRelaView != nil && uBoundRelaView != self && [self myIsNoLayoutSubview:uBoundRelaView])
            maxTrailing += uBoundPos.offsetVal;
        
        if (_myCGFloatGreat(sbvmyFrame.trailing, maxTrailing))
        {
            sbvmyFrame.trailing = maxTrailing;
            sbvmyFrame.width = sbvmyFrame.trailing - sbvmyFrame.leading;
        }
    }
    
}

-(void)myLayout:(MyRelativeLayoutViewSizeClass*)lsc calcTopBottomOfSubview:(MyViewSizeClass*)sbvsc sbvmyFrame:(MyFrame*)sbvmyFrame selfSize:(CGSize)selfSize
{
    
    if (sbvmyFrame.top != CGFLOAT_MAX && sbvmyFrame.bottom != CGFLOAT_MAX && sbvmyFrame.height != CGFLOAT_MAX)
        return;
    
    //先检测高度,如果高度是父亲的高度则高度和上下都确定
    if ([self myLayout:lsc calcHeightOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize])
        return;
    
    UIView *sbv = sbvsc.view;
    
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
                
                [self myLayout:lsc calcHeightOfSubview:(MyViewSizeClass*)pos.view.myCurrentSizeClass sbvmyFrame:pos.view.myFrame selfSize:selfSize];
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
            
            [self myLayout:lsc calcHeightOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            totalHeight += sbvmyFrame.height;
            totalOffset += sbvsc.centerYPosInner.absVal;
        }
        
        
        //所有高度算出后，再分别设置
        CGFloat topOffset = (selfSize.height - lsc.myLayoutTopPadding - lsc.myLayoutBottomPadding - totalHeight - totalOffset) / 2;
        topOffset += lsc.myLayoutTopPadding;
        
        id prev = @(topOffset);
        [sbvsc.topPos __equalTo:prev];
        prev = sbvsc.bottomPos;
        for (MyLayoutPos *pos in centerArray)
        {
            [[pos.view.topPos __equalTo:prev] __offset:pos.view.centerYPos.absVal];
            prev = pos.view.bottomPos;
        }
    }
    
    if (sbvsc.baselinePosInner.posRelaVal != nil)
    {
        //得到基线的位置。基线的位置等于top + (子视图的高度 - 字体的高度) / 2 + 字体基线以上的高度。
        UIFont *sbvFont = [self myGetSubviewFont:sbv];
        
        if (sbvFont != nil)
        {
            //得到基线的位置。
            UIView *relaView = sbvsc.baselinePosInner.posRelaVal.view;
            sbvmyFrame.top = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.baselinePosInner.posRelaVal.pos selfSize:selfSize] - sbvFont.ascender - (sbvmyFrame.height - sbvFont.lineHeight) / 2 + sbvsc.baselinePosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                sbvmyFrame.top -= sbvsc.baselinePosInner.absVal;
        }
        else
        {
            sbvmyFrame.top =  lsc.topPadding + sbvsc.baselinePosInner.absVal;
        }
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
    }
    else if (sbvsc.baselinePosInner.posMostVal != nil)
    {
        UIFont *sbvFont = [self myGetSubviewFont:sbv];
        if (sbvFont != nil)
        {
            sbvmyFrame.top = sbvsc.baselinePosInner.posMostVal.doubleValue + sbvsc.baselinePosInner.absVal - sbvFont.ascender - (sbvmyFrame.height - sbvFont.lineHeight) / 2;
        }
        else
        {
            sbvmyFrame.top = sbvsc.baselinePosInner.posMostVal.doubleValue + sbvsc.baselinePosInner.absVal;
        }
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
    }
    else if (sbvsc.baselinePosInner.posNumVal != nil)
    {
        UIFont *sbvFont = [self myGetSubviewFont:sbv];
        
        if (sbvFont != nil)
        {
            //根据基线位置反退顶部位置。
            sbvmyFrame.top = lsc.topPadding + sbvsc.baselinePosInner.absVal - sbvFont.ascender - (sbvmyFrame.height - sbvFont.lineHeight) / 2;
        }
        else
        {
            sbvmyFrame.top = lsc.topPadding + sbvsc.baselinePosInner.absVal;
        }
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;

    }
    else if (sbvsc.centerYPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerYPosInner.posRelaVal.view;
        
        sbvmyFrame.top = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.centerYPosInner.posRelaVal.pos selfSize:selfSize] - sbvmyFrame.height / 2 + sbvsc.centerYPosInner.absVal;
        
        
        if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
            sbvmyFrame.top -= sbvsc.centerYPosInner.absVal;
        
        if (sbvmyFrame.top < 0 && relaView == self && lsc.heightSizeInner.dimeWrapVal)
            sbvmyFrame.top = 0;
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
    }
    else if (sbvsc.centerYPosInner.posMostVal != nil)
    {
        sbvmyFrame.top = sbvsc.centerYPosInner.posMostVal.doubleValue  + sbvsc.centerYPosInner.absVal - sbvmyFrame.height / 2;
        
        if (sbvmyFrame.top < 0 && lsc.heightSizeInner.dimeWrapVal)
            sbvmyFrame.top = 0;
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
    }
    else if (sbvsc.centerYPosInner.posNumVal != nil)
    {
        sbvmyFrame.top = (selfSize.height - lsc.myLayoutTopPadding - lsc.myLayoutBottomPadding -  sbvmyFrame.height) / 2 + lsc.myLayoutTopPadding + sbvsc.centerYPosInner.absVal;
        
        if (sbvmyFrame.top < 0 && lsc.heightSizeInner.dimeWrapVal)
            sbvmyFrame.top = 0;
        
        sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
    }
    else
    {
        if (sbvsc.topPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.topPosInner.posRelaVal.view;
            
            sbvmyFrame.top = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                sbvmyFrame.top -= sbvsc.topPosInner.absVal;
            
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height + sbvsc.bottomPosInner.absVal;
        }
        else if (sbvsc.topPosInner.posMostVal != nil)
        {
            sbvmyFrame.top = sbvsc.topPosInner.posMostVal.doubleValue + sbvsc.topPosInner.absVal;
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height + sbvsc.bottomPosInner.absVal;
        }
        else if (sbvsc.topPosInner.posNumVal != nil)
        {
            sbvmyFrame.top = sbvsc.topPosInner.absVal + lsc.myLayoutTopPadding;
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height + sbvsc.bottomPosInner.absVal;
        }
        else if (sbvsc.bottomPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.bottomPosInner.posRelaVal.view;
            
            sbvmyFrame.bottom = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal + sbvsc.topPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                sbvmyFrame.bottom += sbvsc.bottomPosInner.absVal;
            
            sbvmyFrame.top = sbvmyFrame.bottom - sbvmyFrame.height;
            
        }
        else if (sbvsc.bottomPosInner.posMostVal != nil)
        {
            sbvmyFrame.bottom = sbvsc.bottomPosInner.posMostVal.doubleValue - sbvsc.bottomPosInner.absVal + sbvsc.topPosInner.absVal;
            sbvmyFrame.top = sbvmyFrame.bottom - sbvmyFrame.height;
        }
        else if (sbvsc.bottomPosInner.posNumVal != nil)
        {
            sbvmyFrame.bottom = selfSize.height -  sbvsc.bottomPosInner.absVal - lsc.myLayoutBottomPadding;
            sbvmyFrame.top = sbvmyFrame.bottom - sbvmyFrame.height;
        }
        else
        {
            sbvmyFrame.top = sbvsc.topPosInner.absVal + lsc.myLayoutTopPadding;
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
        }
    }
    
    //这里要更新上边最小和下边最大约束的情况。
    MyLayoutPos *lBoundPos = sbvsc.topPosInner.lBoundValInner;
    MyLayoutPos *uBoundPos = sbvsc.bottomPosInner.uBoundValInner;
    UIView *lBoundRelaView = lBoundPos.posRelaVal.view;
    UIView *uBoundRelaView = uBoundPos.posRelaVal.view;
    
    if (lBoundPos.posRelaVal != nil && uBoundPos.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minTop = [self myLayout:lsc calcSizeOrPosOfSubview:lBoundRelaView gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        if (lBoundRelaView != nil && lBoundRelaView != self && [self myIsNoLayoutSubview:lBoundRelaView])
            minTop -= lBoundPos.offsetVal;
        CGFloat   maxBottom = [self myLayout:lsc calcSizeOrPosOfSubview:uBoundRelaView gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] - uBoundPos.offsetVal;
        if (uBoundRelaView != nil && uBoundRelaView != self && [self myIsNoLayoutSubview:uBoundRelaView])
            maxBottom += uBoundPos.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        if (_myCGFloatLess(maxBottom - minTop, sbvmyFrame.height))
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
    else if (lBoundPos.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minTop = [self myLayout:lsc calcSizeOrPosOfSubview:lBoundRelaView gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        if (lBoundRelaView != nil && lBoundRelaView != self && [self myIsNoLayoutSubview:lBoundRelaView])
            minTop -= lBoundPos.offsetVal;
        
        if (_myCGFloatLess(sbvmyFrame.top, minTop))
        {
            sbvmyFrame.top = minTop;
            sbvmyFrame.height = sbvmyFrame.bottom - sbvmyFrame.top;
        }
        
    }
    else if (uBoundPos.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxBottom = [self myLayout:lsc calcSizeOrPosOfSubview:uBoundRelaView gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] - uBoundPos.offsetVal;
        if (uBoundRelaView != nil && uBoundRelaView != self && [self myIsNoLayoutSubview:uBoundRelaView])
            maxBottom += uBoundPos.offsetVal;
        
        if (_myCGFloatGreat(sbvmyFrame.bottom, maxBottom))
        {
            sbvmyFrame.bottom = maxBottom;
            sbvmyFrame.height = sbvmyFrame.bottom - sbvmyFrame.top;
        }
    }
}



-(CGFloat)myLayout:(MyRelativeLayoutViewSizeClass*)lsc calcSizeOrPosOfSubview:(UIView*)sbv gravity:(MyGravity)gravity selfSize:(CGSize)selfSize
{
    MyFrame *sbvmyFrame = sbv.myFrame;
    MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
    
    switch (gravity) {
        case MyGravity_Horz_Leading:
        {
            if (sbv == self || sbv == nil)
                return lsc.myLayoutLeadingPadding;
            
            if (sbvmyFrame.leading != CGFLOAT_MAX)
                return sbvmyFrame.leading;
            
            [self myLayout:lsc calcLeadingTrailingOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.leading;
        }
            break;
        case MyGravity_Horz_Trailing:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.myLayoutTrailingPadding;
            
            if (sbvmyFrame.trailing != CGFLOAT_MAX)
                return sbvmyFrame.trailing;
            
            [self myLayout:lsc calcLeadingTrailingOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];

            return sbvmyFrame.trailing;
        }
            break;
        case MyGravity_Vert_Top:
        {
            if (sbv == self || sbv == nil)
                return lsc.myLayoutTopPadding;
            
            if (sbvmyFrame.top != CGFLOAT_MAX)
                return sbvmyFrame.top;
            
            [self myLayout:lsc calcTopBottomOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.top;
            
        }
            break;
        case MyGravity_Vert_Bottom:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.myLayoutBottomPadding;
            
            if (sbvmyFrame.bottom != CGFLOAT_MAX)
                return sbvmyFrame.bottom;
            
            [self myLayout:lsc calcTopBottomOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];

            return sbvmyFrame.bottom;
        }
            break;
        case MyGravity_Vert_Baseline:
        {
            if (sbv == self || sbv == nil)
                return lsc.topPadding;
            
            UIFont *sbvFont = [self myGetSubviewFont:sbv];
            if (sbvFont != nil)
            {
                if (sbvmyFrame.top == CGFLOAT_MAX || sbvmyFrame.height == CGFLOAT_MAX)
                    [self myLayout:lsc calcTopBottomOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
                
                //得到基线的位置。
                return sbvmyFrame.top + (sbvmyFrame.height - sbvFont.lineHeight)/2.0 + sbvFont.ascender;
            }
            else
            {
                if (sbvmyFrame.top != CGFLOAT_MAX)
                    return sbvmyFrame.top;
                
                [self myLayout:lsc calcTopBottomOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
                
                return sbvmyFrame.top;
            }
        }
            break;
        case MyGravity_Horz_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.myLayoutLeadingPadding - lsc.myLayoutTrailingPadding;
            
            if (sbvmyFrame.width != CGFLOAT_MAX)
                return sbvmyFrame.width;
            
            [self myLayout:lsc calcLeadingTrailingOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.width;
        }
            break;
        case MyGravity_Vert_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.myLayoutTopPadding - lsc.myLayoutBottomPadding;
            
            if (sbvmyFrame.height != CGFLOAT_MAX)
                return sbvmyFrame.height;
            
            [self myLayout:lsc calcTopBottomOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.height;
        }
            break;
        case MyGravity_Horz_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.width - lsc.myLayoutLeadingPadding - lsc.myLayoutTrailingPadding) / 2 + lsc.myLayoutLeadingPadding;
            
            if (sbvmyFrame.leading != CGFLOAT_MAX && sbvmyFrame.trailing != CGFLOAT_MAX &&  sbvmyFrame.width != CGFLOAT_MAX)
                return sbvmyFrame.leading + sbvmyFrame.width / 2;
            
            [self myLayout:lsc calcLeadingTrailingOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.leading + sbvmyFrame.width / 2;
            
        }
            break;
            
        case MyGravity_Vert_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.height - lsc.myLayoutTopPadding - lsc.myLayoutBottomPadding) / 2 + lsc.myLayoutTopPadding;
            
            if (sbvmyFrame.top != CGFLOAT_MAX && sbvmyFrame.bottom != CGFLOAT_MAX &&  sbvmyFrame.height != CGFLOAT_MAX)
                return sbvmyFrame.top + sbvmyFrame.height / 2;
            
            [self myLayout:lsc calcTopBottomOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
            
            return sbvmyFrame.top + sbvmyFrame.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)myLayout:(MyRelativeLayoutViewSizeClass*)lsc calcWidthOfSubview:(MyViewSizeClass*)sbvsc sbvmyFrame:(MyFrame*)sbvmyFrame selfSize:(CGSize)selfSize
{
    UIView *sbv = sbvsc.view;
    BOOL hasMargin = NO;
    
    if (sbvmyFrame.width == CGFLOAT_MAX)
    {
        if (sbvsc.widthSizeInner.dimeArrVal != nil)
        {
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
                        if (dime.dimeVal != nil)
                        {
                            [self myLayout:lsc calcWidthOfSubview:(MyViewSizeClass*)dime.view.myCurrentSizeClass
                                   sbvmyFrame:dime.view.myFrame
                                     selfSize:selfSize];
                            
                            totalAdd += -1 * dime.view.myFrame.width;
                        }
                        else
                        {
                            totalMulti += dime.multiVal;
                        }
                        
                        totalAdd += dime.addVal;
                    }
                }
                
            }
            
            CGFloat spareWidth = selfSize.width - lsc.myLayoutLeadingPadding - lsc.myLayoutTrailingPadding + totalAdd;
            if ( _myCGFloatLessOrEqual(spareWidth, 0))
                spareWidth = 0;
            
            if (totalMulti != 0)
            {
                CGFloat tempWidth = _myCGFloatRound(spareWidth * (sbvsc.widthSizeInner.multiVal / totalMulti));
                sbvmyFrame.width = tempWidth;
                
                if ([self myIsNoLayoutSubview:sbv])
                {
                    sbvmyFrame.width = 0;
                }
                else
                {
                    spareWidth -= tempWidth;
                    totalMulti -= sbvsc.widthSizeInner.multiVal;
                }
                
                for (MyLayoutSize *dime in dimeArray)
                {
                    if (dime.isActive && ![self myIsNoLayoutSubview:dime.view])
                    {
                        if (dime.dimeVal == nil)
                        {
                            tempWidth = _myCGFloatRound(spareWidth * (dime.multiVal / totalMulti));
                            spareWidth -= tempWidth;
                            totalMulti -= dime.multiVal;
                            dime.view.myFrame.width = tempWidth;
                            
                        }
                        
                        dime.view.myFrame.width = [self myValidMeasure:dime.view.widthSizeInner sbv:dime.view calcSize:dime.view.myFrame.width sbvSize:dime.view.myFrame.frame.size selfLayoutSize:selfSize];
                    }
                    else
                    {
                        dime.view.myFrame.width = 0;
                    }
                }
            }
        }
        else if (sbvsc.widthSizeInner.dimeRelaVal != nil)
        {
            sbvmyFrame.width = [sbvsc.widthSizeInner measureWith:[self myLayout:lsc calcSizeOrPosOfSubview:sbvsc.widthSizeInner.dimeRelaVal.view gravity:sbvsc.widthSizeInner.dimeRelaVal.dime selfSize:selfSize] ];
        }
        else if (sbvsc.widthSizeInner.dimeNumVal != nil)
        {
            sbvmyFrame.width = sbvsc.widthSizeInner.measure;
        }
        else if (sbvsc.widthSizeInner.dimeFillVal)
        {
            sbvmyFrame.width = [sbvsc.widthSizeInner measureWith:selfSize.width - lsc.myLayoutLeadingPadding - lsc.myLayoutTrailingPadding];
        }
        else if (sbvsc.widthSizeInner.dimeWrapVal)
        {
            //对于非布局视图进行宽度自适应计算。
            if (![sbv isKindOfClass:[MyBaseLayout class]])
                sbvmyFrame.width = [sbvsc.widthSizeInner measureWith:[sbv sizeThatFits:CGSizeZero].width];
        }
        
        if (sbvmyFrame.width == CGFLOAT_MAX)
            sbvmyFrame.width = CGRectGetWidth(sbv.bounds);
        
        if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        {
            if (sbvsc.leadingPosInner.posRelaVal != nil)
            {
                UIView *relaView = sbvsc.leadingPosInner.posRelaVal.view;
                sbvmyFrame.leading = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
                if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                    sbvmyFrame.leading -= sbvsc.leadingPosInner.absVal;
            }
            else if (sbvsc.leadingPosInner.posMostVal != nil)
            {
                sbvmyFrame.leading = sbvsc.leadingPosInner.posMostVal.doubleValue + sbvsc.leadingPosInner.absVal;
            }
            else
            {
                sbvmyFrame.leading = sbvsc.leadingPosInner.absVal + lsc.myLayoutLeadingPadding;
            }
            
            if (sbvsc.trailingPosInner.posRelaVal != nil)
            {
                UIView *relaView = sbvsc.trailingPosInner.posRelaVal.view;
                sbvmyFrame.trailing = [self myLayout:lsc calcSizeOrPosOfSubview:sbvsc.trailingPosInner.posRelaVal.view gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal;
                if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                    sbvmyFrame.trailing += sbvsc.trailingPosInner.absVal;
            }
            else if (sbvsc.trailingPosInner.posMostVal != nil)
            {
                sbvmyFrame.trailing = sbvsc.trailingPosInner.posMostVal.doubleValue - sbvsc.trailingPosInner.absVal;
            }
            else
            {
                sbvmyFrame.trailing = selfSize.width - sbvsc.trailingPosInner.absVal - lsc.myLayoutTrailingPadding;
            }
            
            //只有在没有设置宽度时才计算宽度。
            if (sbvsc.widthSizeInner.dimeVal == nil)
                sbvmyFrame.width = sbvmyFrame.trailing - sbvmyFrame.leading;
            else
                sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width + sbvsc.trailingPosInner.absVal;
            
            hasMargin = YES;
        }
        
        
        //计算有最大和最小约束的情况。
        if (sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view != self)
        {
            [self myLayout:lsc calcWidthOfSubview:(MyViewSizeClass*)sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                   sbvmyFrame:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.myFrame
                     selfSize:selfSize];
        }
        
        if (sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view != self)
        {
            [self myLayout:lsc calcWidthOfSubview:(MyViewSizeClass*)sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                   sbvmyFrame:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.myFrame
                     selfSize:selfSize];
        }
        
        sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        
        if ([self myIsNoLayoutSubview:sbv])
        {
            sbvmyFrame.width = 0;
            sbvmyFrame.trailing = sbvmyFrame.leading + sbvmyFrame.width;
        }
    }
    
    return hasMargin;
}


-(BOOL)myLayout:(MyRelativeLayoutViewSizeClass*)lsc calcHeightOfSubview:(MyViewSizeClass*)sbvsc sbvmyFrame:(MyFrame*)sbvmyFrame selfSize:(CGSize)selfSize
{
    UIView *sbv = sbvsc.view;
    BOOL hasMargin = NO;
    
    if (sbvmyFrame.height == CGFLOAT_MAX)
    {
        if (sbvsc.heightSizeInner.dimeArrVal != nil)
        {
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
                        if (dime.dimeVal != nil)
                        {
                            [self myLayout:lsc calcHeightOfSubview:(MyViewSizeClass*)dime.view.myCurrentSizeClass
                                    sbvmyFrame:dime.view.myFrame
                                      selfSize:selfSize];
                            
                            totalAdd += -1 * dime.view.myFrame.height;
                        }
                        else
                            totalMulti += dime.multiVal;
                        
                        totalAdd += dime.addVal;
                    }
                }
            }
            
            CGFloat spareHeight = selfSize.height - lsc.myLayoutTopPadding - lsc.myLayoutBottomPadding + totalAdd;
            if (_myCGFloatLessOrEqual(spareHeight, 0))
                spareHeight = 0;
            
            if (totalMulti != 0)
            {
                CGFloat tempHeight = _myCGFloatRound(spareHeight * (sbvsc.heightSizeInner.multiVal / totalMulti));
                sbvmyFrame.height = tempHeight;
                if ([self myIsNoLayoutSubview:sbv])
                {
                    sbvmyFrame.height = 0;
                }
                else
                {
                    spareHeight -= tempHeight;
                    totalMulti -= sbvsc.heightSizeInner.multiVal;
                }
                
                for (MyLayoutSize *dime in dimeArray)
                {
                    if (dime.isActive && ![self myIsNoLayoutSubview:dime.view])
                    {
                        if (dime.dimeVal == nil)
                        {
                            tempHeight = _myCGFloatRound(spareHeight * (dime.multiVal / totalMulti));
                            spareHeight -= tempHeight;
                            totalMulti -= dime.multiVal;
                            dime.view.myFrame.height = tempHeight;
                        }
                        
                        dime.view.myFrame.height = [self myValidMeasure:dime.view.heightSizeInner sbv:dime.view calcSize:dime.view.myFrame.height sbvSize:dime.view.myFrame.frame.size selfLayoutSize:selfSize];
                        
                    }
                    else
                    {
                        dime.view.myFrame.height = 0;
                    }
                }
            }
        }
        else if (sbvsc.heightSizeInner.dimeRelaVal != nil)
        {
            sbvmyFrame.height = [sbvsc.heightSizeInner measureWith:[self myLayout:lsc calcSizeOrPosOfSubview:sbvsc.heightSizeInner.dimeRelaVal.view gravity:sbvsc.heightSizeInner.dimeRelaVal.dime selfSize:selfSize] ];
        }
        else if (sbvsc.heightSizeInner.dimeNumVal != nil)
        {
            sbvmyFrame.height = sbvsc.heightSizeInner.measure;
        }
        else if (sbvsc.heightSizeInner.dimeFillVal)
        {
            sbvmyFrame.height = [sbvsc.heightSizeInner measureWith:selfSize.height - lsc.myLayoutTopPadding - lsc.myLayoutBottomPadding];
        }
        else if (sbvsc.heightSizeInner.dimeWrapVal)
        {
             if (![sbv isKindOfClass:[MyBaseLayout class]])
             {
                 if (sbvmyFrame.width == CGFLOAT_MAX)
                     [self myLayout:lsc calcWidthOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
                 
                 sbvmyFrame.height = [self mySubview:sbvsc wrapHeightSizeFits:sbvmyFrame.width];
             }
            
        }
        
        if (sbvmyFrame.height == CGFLOAT_MAX)
            sbvmyFrame.height = CGRectGetHeight(sbv.bounds);
        
        if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        {
            if (sbvsc.topPosInner.posRelaVal != nil)
            {
                UIView *relaView = sbvsc.topPosInner.posRelaVal.view;
                sbvmyFrame.top = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
                
                if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                    sbvmyFrame.top -= sbvsc.topPosInner.absVal;
            }
            else if (sbvsc.topPosInner.posMostVal != nil)
            {
                sbvmyFrame.top = sbvsc.topPosInner.posMostVal.doubleValue + sbvsc.topPosInner.absVal;
            }
            else
            {
                sbvmyFrame.top = sbvsc.topPosInner.absVal + lsc.myLayoutTopPadding;
            }
            
            if (sbvsc.bottomPosInner.posRelaVal != nil)
            {
                UIView *relaView = sbvsc.bottomPosInner.posRelaVal.view;

                sbvmyFrame.bottom = [self myLayout:lsc calcSizeOrPosOfSubview:relaView gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal;
                
                if (relaView != nil && relaView != self && [self myIsNoLayoutSubview:relaView])
                    sbvmyFrame.bottom += sbvsc.bottomPosInner.absVal;
            }
            else if (sbvsc.bottomPosInner.posMostVal != nil)
            {
                sbvmyFrame.bottom = sbvsc.bottomPosInner.posMostVal.doubleValue - sbvsc.bottomPosInner.absVal;
            }
            else
            {
                sbvmyFrame.bottom = selfSize.height - sbvsc.bottomPosInner.absVal - lsc.myLayoutBottomPadding;
            }
            
            //只有在没有设置高度时才计算高度。
            if (sbvsc.heightSizeInner.dimeVal == nil)
                sbvmyFrame.height = sbvmyFrame.bottom - sbvmyFrame.top;
            else
                sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height + sbvsc.bottomPosInner.absVal;
            
            hasMargin = YES;
        }
        
        if (sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view != self)
        {
            [self myLayout:lsc calcHeightOfSubview:(MyViewSizeClass*)sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                    sbvmyFrame:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.myFrame
                      selfSize:selfSize];
        }
        
        if (sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view != self)
        {
            [self myLayout:lsc calcHeightOfSubview:(MyViewSizeClass*)sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.myCurrentSizeClass
                    sbvmyFrame:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.myFrame
                      selfSize:selfSize];
        }
        
        sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        
        if ([self myIsNoLayoutSubview:sbv])
        {
            sbvmyFrame.height = 0;
            sbvmyFrame.bottom = sbvmyFrame.top + sbvmyFrame.height;
        }
    }
    
    return hasMargin;
}


-(CGSize)myLayout:(MyRelativeLayoutViewSizeClass*)lsc calcSelfSize:(CGSize)selfSize pRecalcWidth:(BOOL*)pRecalcWidth pRecalcHeight:(BOOL*)pRecalcHeight
{
    if (pRecalcWidth != NULL)
        *pRecalcWidth = NO;
    if (pRecalcHeight != NULL)
        *pRecalcHeight = NO;
    
    //计算最大的宽度和高度
    CGFloat maxWidth = lsc.myLayoutLeadingPadding + lsc.myLayoutTrailingPadding;
    CGFloat maxHeight = lsc.myLayoutTopPadding + lsc.myLayoutBottomPadding;
    
    for (UIView *sbv in self.subviews)
    {
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        [self myLayout:lsc calcLeadingTrailingOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
        [self myLayout:lsc calcTopBottomOfSubview:sbvsc sbvmyFrame:sbvmyFrame selfSize:selfSize];
        
        if ([self myIsNoLayoutSubview:sbv])
            continue;
        
        if (lsc.widthSizeInner.dimeWrapVal && pRecalcWidth != NULL)
        {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了右边或者中间的值，或者宽度依赖父视图)
            if(sbvsc.trailingPosInner.posNumVal != nil ||
               sbvsc.trailingPosInner.posMostVal != nil ||
               sbvsc.trailingPosInner.posRelaVal.view == self ||
               sbvsc.centerXPosInner.posRelaVal.view == self ||
               sbvsc.centerXPosInner.posNumVal != nil ||
               sbvsc.widthSizeInner.dimeRelaVal.view == self ||
               sbvsc.widthSizeInner.dimeFillVal
               )
            {
                *pRecalcWidth = YES;
            }
            
            //宽度最小是任何一个子视图的左右偏移和外加内边距和。
            if (_myCGFloatLess(maxWidth, sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.myLayoutLeadingPadding + lsc.myLayoutTrailingPadding))
            {
                maxWidth = sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.myLayoutLeadingPadding + lsc.myLayoutTrailingPadding;
            }
            
            if ( (sbvsc.widthSizeInner.dimeRelaVal == nil || sbvsc.widthSizeInner.dimeRelaVal != lsc.widthSizeInner) && !sbvsc.widthSizeInner.dimeFillVal)
            {
                if (sbvsc.centerXPosInner.posVal != nil)
                {
                    if (_myCGFloatLess(maxWidth, sbvmyFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.myLayoutLeadingPadding + lsc.myLayoutTrailingPadding))
                        maxWidth = sbvmyFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.myLayoutLeadingPadding + lsc.myLayoutTrailingPadding;
                }
                else if (sbvsc.trailingPosInner.posVal != nil)
                {//如果只有右边约束，则可以认为宽度是反过来算的，所以这里是左边的绝对值加上左边的padding来计算最宽宽度。
                    if (_myCGFloatLess(maxWidth, fabs(sbvmyFrame.leading) + lsc.myLayoutLeadingPadding))
                        maxWidth = fabs(sbvmyFrame.leading) + lsc.myLayoutLeadingPadding;
                }
                else
                {
                    
                }
                
                if (_myCGFloatLess(maxWidth, fabs(sbvmyFrame.trailing) + lsc.myLayoutTrailingPadding))
                    maxWidth = fabs(sbvmyFrame.trailing) + lsc.myLayoutTrailingPadding;
            }
        }
        
        if (lsc.heightSizeInner.dimeWrapVal && pRecalcHeight != NULL)
        {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了下边或者中间的值，或者高度依赖父视图)
            if(sbvsc.bottomPosInner.posNumVal != nil ||
               sbvsc.bottomPosInner.posMostVal != nil ||
               sbvsc.bottomPosInner.posRelaVal.view == self ||
               sbvsc.centerYPosInner.posRelaVal.view == self ||
               sbvsc.centerYPosInner.posNumVal != nil ||
               sbvsc.heightSizeInner.dimeRelaVal.view == self ||
               sbvsc.heightSizeInner.dimeFillVal
               )
            {
                *pRecalcHeight = YES;
            }
            
            //每个视图最小的高度，在计算时要进行比较。
            if (_myCGFloatLess(maxHeight, sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.myLayoutTopPadding + lsc.myLayoutBottomPadding))
            {
                maxHeight = sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.myLayoutTopPadding + lsc.myLayoutBottomPadding;
            }
            
            //高度不依赖父视图
            if ((sbvsc.heightSizeInner.dimeRelaVal == nil || sbvsc.heightSizeInner.dimeRelaVal != lsc.heightSizeInner) && !sbvsc.heightSizeInner.dimeFillVal)
            {
                if (sbvsc.centerYPosInner.posVal != nil)
                {
                    if (_myCGFloatLess(maxHeight, sbvmyFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.myLayoutTopPadding + lsc.myLayoutBottomPadding))
                        maxHeight = sbvmyFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.myLayoutTopPadding + lsc.myLayoutBottomPadding;
                }
                else if (sbvsc.bottomPosInner.posVal != nil)
                {//如果只有底边约束，则可以认为高度是反过来算的，所以这里是上边的绝对值加上上边的padding来计算最高高度
                    if (_myCGFloatLess(maxHeight, fabs(sbvmyFrame.top) + lsc.myLayoutTopPadding))
                        maxHeight = fabs(sbvmyFrame.top) + lsc.myLayoutTopPadding;
                }
                else
                {
                    
                }
                
                if (_myCGFloatLess(maxHeight, fabs(sbvmyFrame.bottom) + lsc.myLayoutBottomPadding))
                    maxHeight = fabs(sbvmyFrame.bottom) + lsc.myLayoutBottomPadding;
            }
        }
    }
    
    return CGSizeMake(maxWidth, maxHeight);
}

@end

//
//  MyRelativeLayout.m
//  MyLayout
//
//  Created by oybq on 15/7/1.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyRelativeLayout.h"
#import "MyLayoutInner.h"

IB_DESIGNABLE
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

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview != nil)
    {
        //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
        if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
            self.adjustScrollViewContentSize = YES;
    }
    
    
}



#pragma mark -- Private Method
-(void)calcSubViewLeftRight:(UIView*)sbv selfRect:(CGRect)selfRect
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
    
    
    if ((sbv.absPos.leftPos != CGFLOAT_MAX && sbv.absPos.rightPos != CGFLOAT_MAX && sbv.absPos.width != CGFLOAT_MAX) || sbv.useFrame)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcWidth:sbv selfRect:selfRect])
        return;
    
    
    if (sbv.centerXPos.posRelaVal != nil)
    {
        sbv.absPos.leftPos = [self calcSubView:sbv.centerXPos.posRelaVal.view gravity:sbv.centerXPos.posRelaVal.pos selfRect:selfRect] - sbv.absPos.width / 2 + sbv.centerXPos.margin;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        return;
    }
    else if (sbv.centerXPos.posNumVal != nil)
    {
        sbv.absPos.leftPos = (selfRect.size.width - self.rightPadding - self.leftPadding - sbv.absPos.width) / 2 + self.leftPadding + sbv.centerXPos.margin;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        return;
    }
    else
    {
        if (sbv.leftPos.posRelaVal != nil)
        {
            sbv.absPos.leftPos = [self calcSubView:sbv.leftPos.posRelaVal.view gravity:sbv.leftPos.posRelaVal.pos selfRect:selfRect] + sbv.leftPos.margin;
            sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
            return;
        }
        else if (sbv.leftPos.posNumVal != nil)
        {
            sbv.absPos.leftPos = sbv.leftPos.margin + self.leftPadding;
            sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
            return;
        }
        
        if (sbv.rightPos.posRelaVal != nil)
        {
            
            sbv.absPos.rightPos = [self calcSubView:sbv.rightPos.posRelaVal.view gravity:sbv.rightPos.posRelaVal.pos selfRect:selfRect] - sbv.rightPos.margin + sbv.leftPos.margin;
            sbv.absPos.leftPos = sbv.absPos.rightPos - sbv.absPos.width;
            
            return;
        }
        else if (sbv.rightPos.posNumVal != nil)
        {
            sbv.absPos.rightPos = selfRect.size.width -  self.rightPadding -  sbv.rightPos.margin + sbv.leftPos.margin;
            sbv.absPos.leftPos = sbv.absPos.rightPos - sbv.absPos.width;
            return;
        }
        
        sbv.absPos.leftPos = sbv.leftPos.margin + self.leftPadding;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        
    }
    
}

-(void)calcSubViewTopBottom:(UIView*)sbv selfRect:(CGRect)selfRect
{
    if (sbv.useFrame || (sbv.absPos.topPos != CGFLOAT_MAX && sbv.absPos.bottomPos != CGFLOAT_MAX && sbv.absPos.height != CGFLOAT_MAX))
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcHeight:sbv selfRect:selfRect])
        return;
    
    if (sbv.centerYPos.posRelaVal != nil)
    {
        sbv.absPos.topPos = [self calcSubView:sbv.centerYPos.posRelaVal.view gravity:sbv.centerYPos.posRelaVal.pos selfRect:selfRect] - sbv.absPos.height / 2 + sbv.centerYPos.margin;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        return;
    }
    else if (sbv.centerYPos.posNumVal != nil)
    {
        sbv.absPos.topPos = (selfRect.size.height - self.topPadding - self.bottomPadding -  sbv.absPos.height) / 2 + self.topPadding + sbv.centerYPos.margin;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        return;
    }
    else
    {
        if (sbv.topPos.posRelaVal != nil)
        {
            sbv.absPos.topPos = [self calcSubView:sbv.topPos.posRelaVal.view gravity:sbv.topPos.posRelaVal.pos selfRect:selfRect] + sbv.topPos.margin;
            sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
            return;
        }
        else if (sbv.topPos.posNumVal != nil)
        {
            sbv.absPos.topPos = sbv.topPos.margin;
            sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
            return;
        }
        
        if (sbv.bottomPos.posRelaVal != nil)
        {
            
            sbv.absPos.bottomPos = [self calcSubView:sbv.bottomPos.posRelaVal.view gravity:sbv.bottomPos.posRelaVal.pos selfRect:selfRect] - sbv.bottomPos.margin + sbv.topPos.margin;
            sbv.absPos.topPos = sbv.absPos.bottomPos - sbv.absPos.height;
            
            return;
        }
        else if (sbv.bottomPos.posNumVal != nil)
        {
            sbv.absPos.bottomPos = selfRect.size.height -  sbv.bottomPos.margin - self.bottomPadding + sbv.topPos.margin;
            sbv.absPos.topPos = sbv.absPos.bottomPos - sbv.absPos.height;
            return;
        }
        
        sbv.absPos.topPos = sbv.topPos.margin + self.topPadding;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        
    }
    
}



-(CGFloat)calcSubView:(UIView*)sbv gravity:(MyMarginGravity)gravity selfRect:(CGRect)selfRect
{
    switch (gravity) {
        case MyMarginGravity_Horz_Left:
        {
            if (sbv == self || sbv == nil)
                return self.leftPadding;
            
            
            if (sbv.absPos.leftPos != CGFLOAT_MAX)
                return sbv.absPos.leftPos - ((sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden) ? sbv.leftPos.margin : 0);
            
            
            [self calcSubViewLeftRight:sbv selfRect:selfRect];
            
            return sbv.absPos.leftPos - ((sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden) ? sbv.leftPos.margin : 0);
            
        }
            break;
        case MyMarginGravity_Horz_Right:
        {
            if (sbv == self || sbv == nil)
                return selfRect.size.width - self.rightPadding;
            
            if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            {
                if (sbv.absPos.leftPos != CGFLOAT_MAX)
                    return sbv.absPos.leftPos - sbv.leftPos.margin;
                
                [self calcSubViewLeftRight:sbv selfRect:selfRect];
                
                return sbv.absPos.leftPos - sbv.leftPos.margin;
            }
            
            
            if (sbv.absPos.rightPos != CGFLOAT_MAX)
                return sbv.absPos.rightPos;
            
            [self calcSubViewLeftRight:sbv selfRect:selfRect];
            
            return sbv.absPos.rightPos;
            
        }
            break;
        case MyMarginGravity_Vert_Top:
        {
            if (sbv == self || sbv == nil)
                return self.topPadding;
            
            
            if (sbv.absPos.topPos != CGFLOAT_MAX)
                return sbv.absPos.topPos - ((sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden) ? sbv.topPos.margin : 0);
            
            [self calcSubViewTopBottom:sbv selfRect:selfRect];
            
            return sbv.absPos.topPos - ((sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden) ? sbv.topPos.margin : 0);
            
        }
            break;
        case MyMarginGravity_Vert_Bottom:
        {
            if (sbv == self || sbv == nil)
                return selfRect.size.height - self.bottomPadding;
            
            if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            {
                if (sbv.absPos.topPos != CGFLOAT_MAX)
                    return sbv.absPos.topPos - sbv.topPos.margin;
                
                [self calcSubViewTopBottom:sbv selfRect:selfRect];
                
                return sbv.absPos.topPos - sbv.topPos.margin;
            }
            
            
            
            if (sbv.absPos.bottomPos != CGFLOAT_MAX)
                return sbv.absPos.bottomPos;
            
            [self calcSubViewTopBottom:sbv selfRect:selfRect];
            
            return sbv.absPos.bottomPos;
        }
            break;
        case MyMarginGravity_Horz_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfRect.size.width - self.leftPadding - self.rightPadding;
            
            
            if (sbv.absPos.width != CGFLOAT_MAX)
                return sbv.absPos.width;
            
            [self calcSubViewLeftRight:sbv selfRect:selfRect];
            
            return sbv.absPos.width;
            
        }
            break;
        case MyMarginGravity_Vert_Fill:
        {
            if (sbv == self || sbv == nil)
                return selfRect.size.height - self.topPadding - self.bottomPadding;
            
            
            if (sbv.absPos.height != CGFLOAT_MAX)
                return sbv.absPos.height;
            
            [self calcSubViewTopBottom:sbv selfRect:selfRect];
            
            return sbv.absPos.height;
        }
            break;
        case MyMarginGravity_Horz_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfRect.size.width - self.leftPadding - self.rightPadding) / 2 + self.leftPadding;
            
            if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            {
                if (sbv.absPos.leftPos != CGFLOAT_MAX)
                    return sbv.absPos.leftPos - sbv.leftPos.margin;
                
                [self calcSubViewLeftRight:sbv selfRect:selfRect];
                
                return sbv.absPos.leftPos - sbv.leftPos.margin;
            }
            
            
            if (sbv.absPos.leftPos != CGFLOAT_MAX && sbv.absPos.rightPos != CGFLOAT_MAX &&  sbv.absPos.width != CGFLOAT_MAX)
                return sbv.absPos.leftPos + sbv.absPos.width / 2;
            
            [self calcSubViewLeftRight:sbv selfRect:selfRect];
            
            return sbv.absPos.leftPos + sbv.absPos.width / 2;
            
        }
            break;
            
        case MyMarginGravity_Vert_Center:
        {
            if (sbv == self || sbv == nil)
                return (selfRect.size.height - self.topPadding - self.bottomPadding) / 2 + self.topPadding;
            
            if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            {
                if (sbv.absPos.topPos != CGFLOAT_MAX)
                    return sbv.absPos.topPos - sbv.topPos.margin;
                
                [self calcSubViewTopBottom:sbv selfRect:selfRect];
                
                return sbv.absPos.topPos - sbv.topPos.margin;
            }
            
            
            if (sbv.absPos.topPos != CGFLOAT_MAX && sbv.absPos.bottomPos != CGFLOAT_MAX &&  sbv.absPos.height != CGFLOAT_MAX)
                return sbv.absPos.topPos + sbv.absPos.height / 2;
            
            [self calcSubViewTopBottom:sbv selfRect:selfRect];
            
            return sbv.absPos.topPos + sbv.absPos.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)calcWidth:(UIView*)sbv selfRect:(CGRect)selfRect
{
    if (sbv.absPos.width == CGFLOAT_MAX)
    {
        if (sbv.widthDime.dimeRelaVal != nil)
        {
            
            sbv.absPos.width = [self calcSubView:sbv.widthDime.dimeRelaVal.view gravity:sbv.widthDime.dimeRelaVal.dime selfRect:selfRect] * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            sbv.absPos.width = [sbv.widthDime validMeasure:sbv.absPos.width];
            
        }
        else if (sbv.widthDime.dimeNumVal != nil)
        {
            sbv.absPos.width = sbv.widthDime.dimeNumVal.doubleValue * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            sbv.absPos.width = [sbv.widthDime validMeasure:sbv.absPos.width];
            
        }
        else;
        
        
        if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
        {
            if (sbv.leftPos.posRelaVal != nil)
                sbv.absPos.leftPos = [self calcSubView:sbv.leftPos.posRelaVal.view gravity:sbv.leftPos.posRelaVal.pos selfRect:selfRect] + sbv.leftPos.margin;
            else
                sbv.absPos.leftPos = sbv.leftPos.margin + self.leftPadding;
            
            if (sbv.rightPos.posRelaVal != nil)
                sbv.absPos.rightPos = [self calcSubView:sbv.rightPos.posRelaVal.view gravity:sbv.rightPos.posRelaVal.pos selfRect:selfRect] - sbv.rightPos.margin;
            else
                sbv.absPos.rightPos = selfRect.size.width - sbv.rightPos.margin - self.rightPadding;
            
            sbv.absPos.width = sbv.absPos.rightPos - sbv.absPos.leftPos;
            sbv.absPos.width = [sbv.widthDime validMeasure:sbv.absPos.width];
            
            return YES;
            
        }
        
        
        if (sbv.absPos.width == CGFLOAT_MAX)
        {
            sbv.absPos.width = sbv.frame.size.width;
            sbv.absPos.width = [sbv.widthDime validMeasure:sbv.absPos.width];
        }
    }
    
    return NO;
}


-(BOOL)calcHeight:(UIView*)sbv selfRect:(CGRect)selfRect
{
    if (sbv.absPos.height == CGFLOAT_MAX)
    {
        if (sbv.heightDime.dimeRelaVal != nil)
        {
            
            sbv.absPos.height = [self calcSubView:sbv.heightDime.dimeRelaVal.view gravity:sbv.heightDime.dimeRelaVal.dime selfRect:selfRect] * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            sbv.absPos.height = [sbv.heightDime validMeasure:sbv.absPos.height];
            
        }
        else if (sbv.heightDime.dimeNumVal != nil)
        {
            sbv.absPos.height = sbv.heightDime.dimeNumVal.doubleValue * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            sbv.absPos.height = [sbv.heightDime validMeasure:sbv.absPos.height];
            
        }
        else;
        
        if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
        {
            if (sbv.topPos.posRelaVal != nil)
                sbv.absPos.topPos = [self calcSubView:sbv.topPos.posRelaVal.view gravity:sbv.topPos.posRelaVal.pos selfRect:selfRect] + sbv.topPos.margin;
            else
                sbv.absPos.topPos = sbv.topPos.margin + self.topPadding;
            
            if (sbv.bottomPos.posRelaVal != nil)
                sbv.absPos.bottomPos = [self calcSubView:sbv.bottomPos.posRelaVal.view gravity:sbv.bottomPos.posRelaVal.pos selfRect:selfRect] - sbv.bottomPos.margin;
            else
                sbv.absPos.bottomPos = selfRect.size.height - sbv.bottomPos.margin - self.bottomPadding;
            
            sbv.absPos.height = sbv.absPos.bottomPos - sbv.absPos.topPos;
            sbv.absPos.height = [sbv.heightDime validMeasure:sbv.absPos.height];
            
            
            return YES;
            
        }
        
        
        if (sbv.absPos.height == CGFLOAT_MAX)
        {
            sbv.absPos.height = sbv.frame.size.height;
            sbv.absPos.height = [sbv.heightDime validMeasure:sbv.absPos.height];
        }
    }
    
    return NO;
    
}


-(CGSize)calcLayout:(BOOL*)pRecalc selfRect:(CGRect)selfRect
{
    *pRecalc = NO;
    
    //均分宽度和高度。把这部分提出来是为了实现不管数组是哪个视图指定都可以。
    for (UIView *sbv in self.subviews)
    {
        if (sbv.widthDime.dimeArrVal != nil)
        {
            *pRecalc = YES;
            //平分视图。
            
            NSArray *arr = sbv.widthDime.dimeArrVal;
            
            BOOL ok1 = sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout && self.flexOtherViewWidthWhenSubviewHidden) || sbv.absPos.sizeClass.isHidden;
            
            
            CGFloat totalMutil = ok1 ? 0 : sbv.widthDime.mutilVal;
            CGFloat totalAdd =  ok1 ? 0 : sbv.widthDime.addVal;
            for (MyLayoutDime *d in arr)
            {
                BOOL ok = d.view.useFrame || (d.view.isHidden && self.hideSubviewReLayout && self.flexOtherViewWidthWhenSubviewHidden) || d.view.absPos.sizeClass.isHidden;
                
                if (!ok)
                {
                    if (d.dimeNumVal != nil)
                        totalAdd += -1 * d.dimeNumVal.doubleValue;
                    else
                        totalMutil += d.mutilVal;
                    
                    totalAdd += d.addVal;
                    
                }
                
                
            }
            
            CGFloat floatWidth = selfRect.size.width - self.leftPadding - self.rightPadding + totalAdd;
            if (floatWidth <= 0)
                floatWidth = 0;
            
            if (totalMutil != 0)
            {
                sbv.absPos.width = [sbv.widthDime validMeasure:floatWidth * (sbv.widthDime.mutilVal / totalMutil)];
                for (MyLayoutDime *d in arr) {
                    
                    if (d.dimeNumVal == nil)
                        d.view.absPos.width = [d.view.widthDime validMeasure:floatWidth * (d.mutilVal / totalMutil)];
                    else
                        d.view.absPos.width = [d.view.widthDime validMeasure:d.dimeNumVal.doubleValue];
                }
            }
        }
        
        if (sbv.heightDime.dimeArrVal != nil)
        {
            *pRecalc = YES;
            
            NSArray *arr = sbv.heightDime.dimeArrVal;
            
            BOOL ok1 = sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout && self.flexOtherViewHeightWhenSubviewHidden) || sbv.absPos.sizeClass.isHidden;
            
            CGFloat totalMutil = ok1 ? 0 : sbv.heightDime.mutilVal;
            CGFloat totalAdd = ok1 ? 0 : sbv.heightDime.addVal;
            for (MyLayoutDime *d in arr)
            {
                BOOL ok = d.view.useFrame || (d.view.isHidden && self.hideSubviewReLayout && self.flexOtherViewHeightWhenSubviewHidden) || d.view.absPos.sizeClass.isHidden;
                
                if (!ok)
                {
                    if (d.dimeNumVal != nil)
                        totalAdd += -1 * d.dimeNumVal.doubleValue;
                    else
                        totalMutil += d.mutilVal;
                    
                    totalAdd += d.addVal;
                }
                
            }
            
            CGFloat floatHeight = selfRect.size.height - self.topPadding - self.bottomPadding + totalAdd;
            if (floatHeight <= 0)
                floatHeight = 0;
            
            if (totalMutil != 0)
            {
                sbv.absPos.height = [sbv.heightDime validMeasure:floatHeight * (sbv.heightDime.mutilVal / totalMutil)];
                for (MyLayoutDime *d in arr) {
                    
                    if (d.dimeNumVal == nil)
                        d.view.absPos.height = [d.view.heightDime validMeasure:floatHeight * (d.mutilVal / totalMutil)];
                    else
                        d.view.absPos.height = [d.view.heightDime validMeasure:d.dimeNumVal.doubleValue];
                }
            }
        }
        
        //处理尺寸等于内容时并且需要添加额外尺寸的情况。
        if (sbv.widthDime.dimeSelfVal != nil || sbv.heightDime.dimeSelfVal != nil)
        {
            CGSize fitSize = [sbv sizeThatFits:CGSizeZero];
            if (sbv.widthDime.dimeSelfVal != nil)
            {
                sbv.absPos.width = [sbv.widthDime validMeasure:fitSize.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal];
            }
            
            if (sbv.heightDime.dimeSelfVal != nil)
            {
                sbv.absPos.height = [sbv.heightDime validMeasure:fitSize.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal];
            }
        }
        
        //表示视图数组水平居中
        if (sbv.centerXPos.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *arr = sbv.centerXPos.posArrVal;
            
            CGFloat totalWidth = 0;
            
            if (!(sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden))
            {
                [self calcWidth:sbv selfRect:selfRect];
                totalWidth += sbv.absPos.width + sbv.centerXPos.margin;
            }
            
            
            for (MyLayoutPos *p in arr)
            {
                if (!(p.view.useFrame || (p.view.isHidden && self.hideSubviewReLayout) || p.view.absPos.sizeClass.isHidden))
                {
                    [self calcWidth:p.view selfRect:selfRect];
                    totalWidth += p.view.absPos.width + p.view.centerXPos.margin;
                }
            }
            
            //所有宽度算出后，再分别设置
            CGFloat leftOffset = (selfRect.size.width - self.leftPadding - self.rightPadding - totalWidth) / 2;
            leftOffset += self.leftPadding;
            
            id prev = @(leftOffset);
            if (!(sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden))
            {
                sbv.leftPos.equalTo(prev);
                prev = sbv.rightPos;
            }
            
            for (MyLayoutPos *p in arr)
            {
                if (!(p.view.useFrame || (p.view.isHidden && self.hideSubviewReLayout) || p.view.absPos.sizeClass.isHidden))
                {
                    p.view.leftPos.equalTo(prev).offset(p.view.centerXPos.margin);
                    prev = p.view.rightPos;
                }
            }
        }
        
        //表示视图数组垂直居中
        if (sbv.centerYPos.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *arr = sbv.centerYPos.posArrVal;
            
            CGFloat totalHeight = 0;
            
            if (!(sbv.useFrame || ( sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden))
            {
                [self calcHeight:sbv selfRect:selfRect];
                totalHeight += sbv.absPos.height + sbv.centerYPos.margin;
            }
            
            
            for (MyLayoutPos *p in arr)
            {
                if (!( p.view.useFrame || (p.view.isHidden && self.hideSubviewReLayout) || p.view.absPos.sizeClass.isHidden))
                {
                    [self calcHeight:p.view selfRect:selfRect];
                    totalHeight += p.view.absPos.height + p.view.centerYPos.margin;
                }
            }
            
            //所有宽度算出后，再分别设置
            CGFloat topOffset = (selfRect.size.height - self.topPadding - self.bottomPadding - totalHeight) / 2;
            topOffset += self.topPadding;
            
            id prev = @(topOffset);
            if (!(sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden))
            {
                sbv.topPos.equalTo(prev);
                prev = sbv.bottomPos;
            }
            
            for (MyLayoutPos *p in arr)
            {
                if (!( p.view.useFrame || (p.view.isHidden && self.hideSubviewReLayout) || p.view.absPos.sizeClass.isHidden ))
                {
                    p.view.topPos.equalTo(prev).offset(p.view.centerYPos.margin);
                    prev = p.view.bottomPos;
                }
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
        
        [self calcSubViewLeftRight:sbv selfRect:selfRect];
        
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
            CGSize sz = [sbv sizeThatFits:CGSizeMake(sbv.absPos.width, 0)];
            sbv.absPos.height = [sbv.heightDime validMeasure:sz.height];
        }
        
        [self calcSubViewTopBottom:sbv selfRect:selfRect];
        
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
        
        
        if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            continue;
        
        if (canCalcMaxWidth &&  maxWidth < sbv.absPos.rightPos + sbv.rightPos.margin)
            maxWidth = sbv.absPos.rightPos + sbv.rightPos.margin;
        
        if (canCalcMaxHeight && maxHeight < sbv.absPos.bottomPos + sbv.bottomPos.margin)
            maxHeight = sbv.absPos.bottomPos + sbv.bottomPos.margin;
    }
    
    maxWidth += self.rightPadding;
    maxHeight += self.bottomPadding;
    
    return CGSizeMake(maxWidth, maxHeight);
    
}

-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
{
    CGRect selfRect = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass];
    
    for (UIView *sbv in self.subviews)
    {
        if (sbv.useFrame || (sbv.isHidden && self.hideSubviewReLayout) || sbv.absPos.sizeClass.isHidden)
            continue;
        
        if (!isEstimate)
            [sbv.absPos reset];
        
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            if (pHasSubLayout != NULL)
                *pHasSubLayout = YES;
            
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
            
            
            if (isEstimate)
            {
                [sbvl estimateLayoutRect:sbvl.absPos.frame.size inSizeClass:sizeClass];
                sbvl.absPos.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
        }
        
        
        
    }
    
    
    BOOL reCalc = NO;
    CGSize maxSize = [self calcLayout:&reCalc selfRect:selfRect];
    
    if (self.wrapContentWidth || self.wrapContentHeight)
    {
        if (selfRect.size.height != maxSize.height || selfRect.size.width != maxSize.width)
        {
            
            if (self.wrapContentWidth)
            {
                selfRect.size.width = maxSize.width;
            }
            
            if (self.wrapContentHeight)
            {
                selfRect.size.height = maxSize.height;
            }
            
            //如果里面有需要重新计算的就重新计算布局
            if (reCalc)
            {
                for (UIView *sbv in self.subviews)
                {
                    [sbv.absPos reset];
                }
                
                [self calcLayout:&reCalc selfRect:selfRect];
            }
        }
        
    }
    
    selfRect.size.height = [self.heightDime validMeasure:selfRect.size.height];
    selfRect.size.width = [self.widthDime validMeasure:selfRect.size.width];
    
    
    return selfRect;
    
}

-(id)createSizeClassInstance
{
    return [MyLayoutSizeClassRelativeLayout new];
}


@end

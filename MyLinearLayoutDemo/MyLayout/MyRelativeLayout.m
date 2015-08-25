//
//  MyRelativeLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyRelativeLayout.h"
#import "MyLayoutInner.h"

#import <objc/runtime.h>

const char * const ASSOCIATEDOBJECT_KEY_ABSOLUTE_POS = "associatedobject_key_absolutepos";



//绝度位置
@interface MyAbsolutePos : NSObject

@property(nonatomic, assign) CGFloat leftPos;
@property(nonatomic, assign) CGFloat rightPos;
@property(nonatomic, assign) CGFloat topPos;
@property(nonatomic, assign) CGFloat bottomPos;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@end

@implementation MyAbsolutePos

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _leftPos = CGFLOAT_MIN;
        _rightPos = CGFLOAT_MIN;
        _topPos = CGFLOAT_MIN;
        _bottomPos = CGFLOAT_MIN;
        _width = CGFLOAT_MIN;
        _height = CGFLOAT_MIN;
    }
    
    return self;
}

-(void)reset
{
    _leftPos = CGFLOAT_MIN;
    _rightPos = CGFLOAT_MIN;
    _topPos = CGFLOAT_MIN;
    _bottomPos = CGFLOAT_MIN;
    _width = CGFLOAT_MIN;
    _height = CGFLOAT_MIN;
}

@end

@interface UIView(MyRelativeLayoutAbsEx)

@property(nonatomic, strong) MyAbsolutePos *absPos;

@end



@implementation UIView(MyRelativeLayoutAbsEx)

-(MyAbsolutePos*)absPos
{
    MyAbsolutePos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_ABSOLUTE_POS);
    if (pos == nil)
    {
        pos = [MyAbsolutePos new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_ABSOLUTE_POS, pos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return pos;
}

-(void)setAbsPos:(MyAbsolutePos *)absPos
{
    objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_ABSOLUTE_POS, absPos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end


@implementation MyRelativeLayout

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)construct
{
    [super construct];
    _flexOtherViewHeightWhenSubviewHidden = NO;
    _flexOtherViewWidthWhenSubviewHidden = NO;
 
}


-(void)setFlexOtherViewWidthWhenSubviewHidden:(BOOL)flexOtherViewWidthWhenSubviewHidden
{
    if (_flexOtherViewWidthWhenSubviewHidden != flexOtherViewWidthWhenSubviewHidden)
    {
        _flexOtherViewWidthWhenSubviewHidden = flexOtherViewWidthWhenSubviewHidden;
        [self setNeedsLayout];
    }
}

-(void)setFlexOtherViewHeightWhenSubviewHidden:(BOOL)flexOtherViewHeightWhenSubviewHidden
{
    if (_flexOtherViewHeightWhenSubviewHidden != flexOtherViewHeightWhenSubviewHidden)
    {
        _flexOtherViewHeightWhenSubviewHidden = flexOtherViewHeightWhenSubviewHidden;
        [self setNeedsLayout];
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if ([newSuperview isKindOfClass:[UIScrollView class]])
        self.adjustScrollViewContentSize = YES;
    
}



#pragma mark -- Private Method
-(void)calcSubViewLeftRight:(UIView*)sbv
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
    
    
    if (sbv.absPos.leftPos != CGFLOAT_MIN && sbv.absPos.rightPos != CGFLOAT_MIN && sbv.absPos.width != CGFLOAT_MIN)
        return;

    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcWidth:sbv])
        return;
    
    
    if (sbv.centerXPos.posRelaVal != nil)
    {
        sbv.absPos.leftPos = [self calcSubView:sbv.centerXPos.posRelaVal.view gravity:sbv.centerXPos.posRelaVal.pos] - sbv.absPos.width / 2 + sbv.centerXPos.margin;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        return;
    }
    else if (sbv.centerXPos.posNumVal != nil)
    {
        sbv.absPos.leftPos = (self.frame.size.width - self.rightPadding - self.leftPadding - sbv.absPos.width) / 2 + self.leftPadding + sbv.centerXPos.margin;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        return;
    }
    else
    {
        if (sbv.leftPos.posRelaVal != nil)
        {
            sbv.absPos.leftPos = [self calcSubView:sbv.leftPos.posRelaVal.view gravity:sbv.leftPos.posRelaVal.pos] + sbv.leftPos.margin;
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
            
            sbv.absPos.rightPos = [self calcSubView:sbv.rightPos.posRelaVal.view gravity:sbv.rightPos.posRelaVal.pos] - sbv.rightPos.margin + sbv.leftPos.margin;
            sbv.absPos.leftPos = sbv.absPos.rightPos - sbv.absPos.width;
            
            return;
        }
        else if (sbv.rightPos.posNumVal != nil)
        {
            sbv.absPos.rightPos = self.frame.size.width -  self.rightPadding -  sbv.rightPos.margin + sbv.leftPos.margin;
            sbv.absPos.leftPos = sbv.absPos.rightPos - sbv.absPos.width;
            return;
        }
        
        sbv.absPos.leftPos = sbv.leftPos.margin + self.leftPadding;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        
    }
    
}

-(void)calcSubViewTopBottom:(UIView*)sbv
{
    if (sbv.absPos.topPos != CGFLOAT_MIN && sbv.absPos.bottomPos != CGFLOAT_MIN && sbv.absPos.height != CGFLOAT_MIN)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcHeight:sbv])
        return;
    
    if (sbv.centerYPos.posRelaVal != nil)
    {
        sbv.absPos.topPos = [self calcSubView:sbv.centerYPos.posRelaVal.view gravity:sbv.centerYPos.posRelaVal.pos] - sbv.absPos.height / 2 + sbv.centerYPos.margin;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        return;
    }
    else if (sbv.centerYPos.posNumVal != nil)
    {
        sbv.absPos.topPos = (self.frame.size.height - self.topPadding - self.bottomPadding -  sbv.absPos.height) / 2 + self.topPadding + sbv.centerYPos.margin;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        return;
    }
    else
    {
        if (sbv.topPos.posRelaVal != nil)
        {
            sbv.absPos.topPos = [self calcSubView:sbv.topPos.posRelaVal.view gravity:sbv.topPos.posRelaVal.pos] + sbv.topPos.margin;
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
            
            sbv.absPos.bottomPos = [self calcSubView:sbv.bottomPos.posRelaVal.view gravity:sbv.bottomPos.posRelaVal.pos] - sbv.bottomPos.margin + sbv.topPos.margin;
            sbv.absPos.topPos = sbv.absPos.bottomPos - sbv.absPos.height;
            
            return;
        }
        else if (sbv.bottomPos.posNumVal != nil)
        {
            sbv.absPos.bottomPos = self.frame.size.height -  sbv.bottomPos.margin - self.bottomPadding + sbv.topPos.margin;
            sbv.absPos.topPos = sbv.absPos.bottomPos - sbv.absPos.height;
            return;
        }
        
        sbv.absPos.topPos = sbv.topPos.margin + self.topPadding;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        
    }

}



-(CGFloat)calcSubView:(UIView*)sbv gravity:(MarignGravity)gravity
{
    switch (gravity) {
        case MGRAVITY_HORZ_LEFT:
        {
            if (sbv == self || sbv == nil)
                return self.leftPadding;
            
            
            if (sbv.absPos.leftPos != CGFLOAT_MIN)
                return sbv.absPos.leftPos - ((sbv.isHidden && self.hideSubviewReLayout) ? sbv.leftPos.margin : 0);
            
           
            [self calcSubViewLeftRight:sbv];
            
            return sbv.absPos.leftPos - ((sbv.isHidden && self.hideSubviewReLayout) ? sbv.leftPos.margin : 0);
            
        }
            break;
        case MGRAVITY_HORZ_RIGHT:
        {
            if (sbv == self || sbv == nil)
                return self.frame.size.width - self.rightPadding;
            
            if (sbv.isHidden && self.hideSubviewReLayout)
            {
                if (sbv.absPos.leftPos != CGFLOAT_MIN)
                    return sbv.absPos.leftPos - sbv.leftPos.margin;
                
                [self calcSubViewLeftRight:sbv];
                
                return sbv.absPos.leftPos - sbv.leftPos.margin;
            }
            
            
            if (sbv.absPos.rightPos != CGFLOAT_MIN)
                return sbv.absPos.rightPos;
            
            [self calcSubViewLeftRight:sbv];
            
            return sbv.absPos.rightPos;
            
        }
            break;
        case MGRAVITY_VERT_TOP:
        {
            if (sbv == self || sbv == nil)
                return self.topPadding;
            
            
            if (sbv.absPos.topPos != CGFLOAT_MIN)
                return sbv.absPos.topPos - ((sbv.isHidden && self.hideSubviewReLayout) ? sbv.topPos.margin : 0);
            
            [self calcSubViewTopBottom:sbv];
            
            return sbv.absPos.topPos - ((sbv.isHidden && self.hideSubviewReLayout) ? sbv.topPos.margin : 0);
            
        }
            break;
        case MGRAVITY_VERT_BOTTOM:
        {
            if (sbv == self || sbv == nil)
                return self.frame.size.height - self.bottomPadding;
            
            if (sbv.isHidden && self.hideSubviewReLayout)
            {
                if (sbv.absPos.topPos != CGFLOAT_MIN)
                    return sbv.absPos.topPos - sbv.topPos.margin;
                
                [self calcSubViewTopBottom:sbv];
                
                return sbv.absPos.topPos - sbv.topPos.margin;
            }

            
            
            if (sbv.absPos.bottomPos != CGFLOAT_MIN)
                return sbv.absPos.bottomPos;
            
            [self calcSubViewTopBottom:sbv];
            
            return sbv.absPos.bottomPos;
        }
            break;
        case MGRAVITY_HORZ_FILL:
        {
            if (sbv == self || sbv == nil)
                return self.frame.size.width - self.leftPadding - self.rightPadding;
            
    
            if (sbv.absPos.width != CGFLOAT_MIN)
                return sbv.absPos.width;
            
            [self calcSubViewLeftRight:sbv];
            
            return sbv.absPos.width;
            
        }
            break;
        case MGRAVITY_VERT_FILL:
        {
            if (sbv == self || sbv == nil)
                return self.frame.size.height - self.topPadding - self.bottomPadding;
            
            
            if (sbv.absPos.height != CGFLOAT_MIN)
                return sbv.absPos.height;
            
            [self calcSubViewTopBottom:sbv];
            
            return sbv.absPos.height;
        }
            break;
        case MGRAVITY_HORZ_CENTER:
        {
            if (sbv == self || sbv == nil)
                return (self.frame.size.width - self.leftPadding - self.rightPadding) / 2 + self.leftPadding;
            
            if (sbv.isHidden && self.hideSubviewReLayout)
            {
                if (sbv.absPos.leftPos != CGFLOAT_MIN)
                    return sbv.absPos.leftPos - sbv.leftPos.margin;
                
                [self calcSubViewLeftRight:sbv];
                
                return sbv.absPos.leftPos - sbv.leftPos.margin;
            }

            
            if (sbv.absPos.leftPos != CGFLOAT_MIN && sbv.absPos.rightPos != CGFLOAT_MIN &&  sbv.absPos.width != CGFLOAT_MIN)
                return sbv.absPos.leftPos + sbv.absPos.width / 2;
            
            [self calcSubViewLeftRight:sbv];
            
            return sbv.absPos.leftPos + sbv.absPos.width / 2;
            
        }
            break;
            
        case MGRAVITY_VERT_CENTER:
        {
            if (sbv == self || sbv == nil)
                return (self.frame.size.height - self.topPadding - self.bottomPadding) / 2 + self.topPadding;
            
            if (sbv.isHidden && self.hideSubviewReLayout)
            {
                if (sbv.absPos.topPos != CGFLOAT_MIN)
                    return sbv.absPos.topPos - sbv.topPos.margin;
                
                [self calcSubViewTopBottom:sbv];
                
                return sbv.absPos.topPos - sbv.topPos.margin;
            }

            
            if (sbv.absPos.topPos != CGFLOAT_MIN && sbv.absPos.bottomPos != CGFLOAT_MIN &&  sbv.absPos.height != CGFLOAT_MIN)
                return sbv.absPos.topPos + sbv.absPos.height / 2;
            
            [self calcSubViewTopBottom:sbv];
            
            return sbv.absPos.topPos + sbv.absPos.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)calcWidth:(UIView*)sbv
{
    if (sbv.absPos.width == CGFLOAT_MIN)
    {
        if (sbv.widthDime.dimeRelaVal != nil)
        {
            
            sbv.absPos.width = [self calcSubView:sbv.widthDime.dimeRelaVal.view gravity:sbv.widthDime.dimeRelaVal.dime] * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
        }
        else if (sbv.widthDime.dimeNumVal != nil)
        {
            sbv.absPos.width = sbv.widthDime.dimeNumVal.floatValue * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
        }
        else;
        
        
        if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
        {
            if (sbv.leftPos.posRelaVal != nil)
                 sbv.absPos.leftPos = [self calcSubView:sbv.leftPos.posRelaVal.view gravity:sbv.leftPos.posRelaVal.pos] + sbv.leftPos.margin;
            else
                sbv.absPos.leftPos = sbv.leftPos.margin + self.leftPadding;
            
            if (sbv.rightPos.posRelaVal != nil)
                sbv.absPos.rightPos = [self calcSubView:sbv.rightPos.posRelaVal.view gravity:sbv.rightPos.posRelaVal.pos] - sbv.rightPos.margin;
            else
                sbv.absPos.rightPos = self.frame.size.width - sbv.rightPos.margin - self.rightPadding;
            
            sbv.absPos.width = sbv.absPos.rightPos - sbv.absPos.leftPos;
            
            return YES;

        }
        
        
        if (sbv.absPos.width == CGFLOAT_MIN)
        {
            sbv.absPos.width = sbv.frame.size.width;
        }
    }
    
    return NO;
}


-(BOOL)calcHeight:(UIView*)sbv
{
    if (sbv.absPos.height == CGFLOAT_MIN)
    {
        if (sbv.heightDime.dimeRelaVal != nil)
        {
            
            sbv.absPos.height = [self calcSubView:sbv.heightDime.dimeRelaVal.view gravity:sbv.heightDime.dimeRelaVal.dime] * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        }
        else if (sbv.heightDime.dimeNumVal != nil)
        {
            sbv.absPos.height = sbv.heightDime.dimeNumVal.floatValue * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        }
        else;
        
        if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
        {
            if (sbv.topPos.posRelaVal != nil)
                sbv.absPos.topPos = [self calcSubView:sbv.topPos.posRelaVal.view gravity:sbv.topPos.posRelaVal.pos] + sbv.topPos.margin;
            else
                sbv.absPos.topPos = sbv.topPos.margin + self.topPadding;
            
            if (sbv.bottomPos.posRelaVal != nil)
                sbv.absPos.bottomPos = [self calcSubView:sbv.bottomPos.posRelaVal.view gravity:sbv.bottomPos.posRelaVal.pos] - sbv.bottomPos.margin;
            else
                sbv.absPos.bottomPos = self.frame.size.height - sbv.bottomPos.margin - self.bottomPadding;
            
            sbv.absPos.height = sbv.absPos.bottomPos - sbv.absPos.topPos;
            
            return YES;
            
        }
        
        
        if (sbv.absPos.height == CGFLOAT_MIN)
        {
            sbv.absPos.height = sbv.frame.size.height;
        }
    }
    
    return NO;

}


-(CGSize)calcLayout:(BOOL*)pRecalc
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
            
            BOOL ok1 = sbv.isHidden && self.hideSubviewReLayout && self.flexOtherViewWidthWhenSubviewHidden;
            
            
            CGFloat totalMutil = ok1 ? 0 : sbv.widthDime.mutilVal;
            CGFloat totalAdd =  ok1 ? 0 : sbv.widthDime.addVal;
            for (MyLayoutDime *d in arr)
            {
                BOOL ok = d.view.isHidden && self.hideSubviewReLayout && self.flexOtherViewWidthWhenSubviewHidden;
                
                if (!ok)
                {
                    if (d.dimeNumVal != nil)
                        totalAdd += -1 * d.dimeNumVal.floatValue;
                    else
                        totalMutil += d.mutilVal;
                    
                    totalAdd += d.addVal;
                    
                }
                
                
            }
            
            CGFloat floatWidth = self.frame.size.width - self.leftPadding - self.rightPadding + totalAdd;
            if (floatWidth <= 0)
                floatWidth = 0;
            
            if (totalMutil != 0)
            {
                sbv.absPos.width = floatWidth * (sbv.widthDime.mutilVal / totalMutil);
                for (MyLayoutDime *d in arr) {
                    
                    if (d.dimeNumVal == nil)
                        d.view.absPos.width = floatWidth * (d.mutilVal / totalMutil);
                    else
                        d.view.absPos.width = d.dimeNumVal.floatValue;
                }
            }
        }
        
        if (sbv.heightDime.dimeArrVal != nil)
        {
            *pRecalc = YES;
            
            NSArray *arr = sbv.heightDime.dimeArrVal;
            
            BOOL ok1 = sbv.isHidden && self.hideSubviewReLayout && self.flexOtherViewHeightWhenSubviewHidden;
            
            CGFloat totalMutil = ok1 ? 0 : sbv.heightDime.mutilVal;
            CGFloat totalAdd = ok1 ? 0 : sbv.heightDime.addVal;
            for (MyLayoutDime *d in arr)
            {
                BOOL ok = d.view.isHidden && self.hideSubviewReLayout && self.flexOtherViewHeightWhenSubviewHidden;
                
                if (!ok)
                {
                    if (d.dimeNumVal != nil)
                        totalAdd += -1 * d.dimeNumVal.floatValue;
                    else
                        totalMutil += d.mutilVal;
                    
                    totalAdd += d.addVal;
                }
                
            }
            
            CGFloat floatHeight = self.frame.size.height - self.topPadding - self.bottomPadding + totalAdd;
            if (floatHeight <= 0)
                floatHeight = 0;
            
            if (totalMutil != 0)
            {
                sbv.absPos.height = floatHeight * (sbv.heightDime.mutilVal / totalMutil);
                for (MyLayoutDime *d in arr) {
                    
                    if (d.dimeNumVal == nil)
                        d.view.absPos.height = floatHeight * (d.mutilVal / totalMutil);
                    else
                        d.view.absPos.height = d.dimeNumVal.floatValue;
                }
            }
        }
        
        
        //表示视图数组水平居中
        if (sbv.centerXPos.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *arr = sbv.centerXPos.posArrVal;
            
            CGFloat totalWidth = 0;
            
            if (!(sbv.isHidden && self.hideSubviewReLayout))
            {
                [self calcWidth:sbv];
                totalWidth += sbv.absPos.width + sbv.centerXPos.margin;
            }
            
            
            for (MyLayoutPos *p in arr)
            {
                if (!(p.view.isHidden && self.hideSubviewReLayout))
                {
                    [self calcWidth:p.view];
                    totalWidth += p.view.absPos.width + p.view.centerXPos.margin;
                }
            }
            
            //所有宽度算出后，再分别设置
            CGFloat leftOffset = (self.frame.size.width - self.leftPadding - self.rightPadding - totalWidth) / 2;
            leftOffset += self.leftPadding;
            
            id prev = @(leftOffset);
            if (!(sbv.isHidden && self.hideSubviewReLayout))
            {
                sbv.leftPos.equalTo(prev);
                prev = sbv.rightPos;
            }
            
            for (MyLayoutPos *p in arr)
            {
                if (!(p.view.isHidden && self.hideSubviewReLayout))
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
            
            if (!(sbv.isHidden && self.hideSubviewReLayout))
            {
                [self calcHeight:sbv];
                totalHeight += sbv.absPos.height + sbv.centerYPos.margin;
            }
            
            
            for (MyLayoutPos *p in arr)
            {
                if (!(p.view.isHidden && self.hideSubviewReLayout))
                {
                    [self calcHeight:p.view];
                    totalHeight += p.view.absPos.height + p.view.centerYPos.margin;
                }
            }
            
            //所有宽度算出后，再分别设置
            CGFloat topOffset = (self.frame.size.height - self.topPadding - self.bottomPadding - totalHeight) / 2;
            topOffset += self.topPadding;
            
            id prev = @(topOffset);
            if (!(sbv.isHidden && self.hideSubviewReLayout))
            {
                sbv.topPos.equalTo(prev);
                prev = sbv.bottomPos;
            }
            
            for (MyLayoutPos *p in arr)
            {
                if (!(p.view.isHidden && self.hideSubviewReLayout))
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
        //左边检测。
        
        [self calcSubViewLeftRight:sbv];
        
        if (sbv.rightPos.posRelaVal != nil && sbv.rightPos.posRelaVal.view == self)
            *pRecalc = YES;
        
        
        if (sbv.isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(sbv.absPos.width, 0)];
            CGRect rectsbv = sbv.frame;
            rectsbv.size.height = sz.height;
            sbv.frame = rectsbv;
            //sbv.h = sz.height;
        }
        
        [self calcSubViewTopBottom:sbv];
        
        if (sbv.bottomPos.posRelaVal != nil && sbv.bottomPos.posRelaVal.view == self)
            *pRecalc = YES;
        
        if (sbv.isHidden && self.hideSubviewReLayout)
            continue;
        
        if (maxWidth < sbv.absPos.rightPos + sbv.rightPos.margin)
            maxWidth = sbv.absPos.rightPos + sbv.rightPos.margin;
        
        if (maxHeight < sbv.absPos.bottomPos + sbv.bottomPos.margin)
            maxHeight = sbv.absPos.bottomPos + sbv.bottomPos.margin;
    }
    
    maxWidth += self.rightPadding;
    maxHeight += self.bottomPadding;
    
    return CGSizeMake(maxWidth, maxHeight);
    
}


-(void)doLayoutSubviews
{
    [super doLayoutSubviews];
    
    //第一次布局计算。检测时序
    BOOL reCalc = NO;
    CGSize maxSize = [self calcLayout:&reCalc];
    
    if (self.wrapContentWidth || self.wrapContentHeight)
    {
        CGRect newRect = self.frame;
        if (newRect.size.height != maxSize.height || newRect.size.width != maxSize.width)
        {
            CGRect oldRect = newRect;
            
            if (self.wrapContentWidth)
            {
                newRect.size.width = maxSize.width;
            }
            
            if (self.wrapContentHeight)
            {
                newRect.size.height = maxSize.height;
            }
            
            
            self.frame = newRect;
            
            if (self.adjustScrollViewContentSize && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
            {
                UIScrollView *scrolv = (UIScrollView*)self.superview;
                
                CGSize contsize = scrolv.contentSize;
                
                if (self.wrapContentHeight && newRect.size.height != oldRect.size.height)
                {
                    contsize.height = newRect.size.height;
                    
                }
                
                if(self.wrapContentWidth && newRect.size.width != oldRect.size.width)
                {
                    contsize.width = newRect.size.width;
                    
                }
                
                scrolv.contentSize = contsize;
                
            }
            
            //如果里面有需要重新计算的就重新计算布局
            if (reCalc)
            {
                for (UIView *sbv in self.subviews)
                {
                    [sbv.absPos reset];
                }
                
                [self calcLayout:&reCalc];
            }
        }

    }
    
    for (UIView *sbv in self.subviews)
    {
            
        CGRect rect = CGRectMake(sbv.absPos.leftPos, sbv.absPos.topPos, sbv.absPos.width, sbv.absPos.height);
        sbv.frame = rect;
            
        [sbv.absPos reset];
    }
   }

@end

//
//  MyFrameLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyFrameLayout.h"
#import <objc/runtime.h>


@implementation UIView(LinearLayoutExtra)


const char * const ASSOCIATEDOBJECT_KEY_TOPMARGIN = "associatedobject_key_topmargin";
const char * const ASSOCIATEDOBJECT_KEY_LEFTMARGIN = "associatedobject_key_leftmargin";
const char * const ASSOCIATEDOBJECT_KEY_BOTTOMMARGIN = "associatedobject_key_bottommargin";
const char * const ASSOCIATEDOBJECT_KEY_RIGHTMARGIN = "associatedobject_key_rightmargin";
const char * const ASSOCIATEDOBJECT_KEY_MARGINGRAVITY = "associatedobject_key_margingravity";

-(CGFloat)topMargin
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_TOPMARGIN);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setTopMargin:(CGFloat)topMargin
{
    CGFloat oldVal = [self topMargin];
    if (oldVal != topMargin)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_TOPMARGIN, [NSNumber numberWithFloat:topMargin], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(CGFloat)leftMargin
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_LEFTMARGIN);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setLeftMargin:(CGFloat)leftMargin
{
    CGFloat oldVal = [self leftMargin];
    if (oldVal != leftMargin)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_LEFTMARGIN, [NSNumber numberWithFloat:leftMargin], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(CGFloat)bottomMargin
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_BOTTOMMARGIN);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setBottomMargin:(CGFloat)bottomMargin
{
    CGFloat oldVal = [self bottomMargin];
    if (oldVal != bottomMargin)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_BOTTOMMARGIN, [NSNumber numberWithFloat:bottomMargin], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(CGFloat)rightMargin
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RIGHTMARGIN);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setRightMargin:(CGFloat)rightMargin
{
    CGFloat oldVal = [self rightMargin];
    if (oldVal != rightMargin)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RIGHTMARGIN, [NSNumber numberWithFloat:rightMargin], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(MarignGravity)marginGravity
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MARGINGRAVITY);
    if (num == nil)
        return 0;
    return num.unsignedCharValue;
}

-(void)setMarginGravity:(MarignGravity)marginGravity
{
    MarignGravity oldVal = [self topMargin];
    if (oldVal != marginGravity)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MARGINGRAVITY, [NSNumber numberWithUnsignedChar:marginGravity], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}


@end

@implementation MyFrameLayout

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)doLayoutSubviews
{
    [super doLayoutSubviews];
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    //有限布局填充，再布局
    NSArray *sbs = self.subviews;
    for (UIView *v in sbs)
    {
        CGRect rect = v.frame;
        MarignGravity gravity = v.marginGravity;
        CGFloat topMargin = v.topMargin;
        CGFloat leftMargin = v.leftMargin;
        CGFloat rightMargin = v.rightMargin;
        CGFloat bottomMargin = v.bottomMargin;
        
        //等于none则只添加padding
        if (gravity == MGRAVITY_NONE)
        {
            rect.origin.x += self.padding.left;
            rect.origin.y += self.padding.top;
        }
        else if (gravity == MGRAVITY_FILL)
        {
            rect.origin.x = self.padding.left + leftMargin;
            rect.origin.y = self.padding.top + topMargin;
            rect.size.width = selfWidth - self.padding.right - rightMargin - rect.origin.x;
            rect.size.height = selfHeight - self.padding.bottom - topMargin - rect.origin.y;
        }
        else if (gravity == MGRAVITY_CENTER)
        {
            rect.origin.x = (selfWidth - self.padding.left - self.padding.right - leftMargin - rightMargin - rect.size.width)/2 + self.padding.left + leftMargin;
            rect.origin.y = (selfHeight - self.padding.top - self.padding.bottom - topMargin - bottomMargin - rect.size.height)/2 + self.padding.top + topMargin;
        }
        else
        {
            //分别计算出左右部分和中间不分的值。
            MarignGravity vert = gravity & 0xF0;
            MarignGravity horz = gravity & 0x0F;
            
            if (vert == MGRAVITY_VERT_FILL)
            {
                rect.origin.y = self.padding.top + topMargin;
                rect.size.height = selfHeight - self.padding.bottom - topMargin - rect.origin.y;
            }
            else if (vert == MGRAVITY_VERT_CENTER)
            {
                rect.origin.y = (selfHeight - self.padding.top - self.padding.bottom - topMargin - bottomMargin - rect.size.height)/2 + self.padding.top + topMargin;
            }
            else if (vert == MGRAVITY_VERT_BOTTOM)
            {
                rect.origin.y = selfHeight - self.padding.bottom - bottomMargin - rect.size.height;
            }
            else
            {
                rect.origin.y = self.padding.top + topMargin;
            }
            
            
            if (horz == MGRAVITY_HORZ_FILL)
            {
                rect.origin.x = self.padding.left + leftMargin;
                rect.size.width = selfWidth - self.padding.right - rightMargin - rect.origin.x;
            }
            else if (horz == MGRAVITY_HORZ_CENTER)
            {
                rect.origin.x = (selfWidth - self.padding.left - self.padding.right - leftMargin - rightMargin - rect.size.width)/2 + self.padding.left + leftMargin;
            }
            else if (horz == MGRAVITY_HORZ_RIGHT)
            {
                rect.origin.x = selfWidth - self.padding.right - rightMargin - rect.size.width;
            }
            else
            {
                rect.origin.x = self.padding.left + leftMargin;
            }
            
        }
        
        
        
        v.frame = rect;
        
    }

    
    
}

@end

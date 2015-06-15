//
//  MyLineView.m
//  MiniClient
//
//  Created by apple on 15/2/12.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyLinearLayout.h"
#import <objc/runtime.h>

@implementation UIView(LinearLayoutExtra)

const char * const ASSOCIATEDOBJECT_KEY_HEADMARGIN = "associatedobject_key_headmargin";
const char * const ASSOCIATEDOBJECT_KEY_TAILMARGIN = "associatedobject_key_tailmargin";
const char * const ASSOCIATEDOBJECT_KEY_WEIGHT = "associatedobject_key_weight";
const char * const ASSOCIATEDOBJECT_KEY_MATCHPARENT = "associatedobject_key_matchparent";

-(CGFloat)headMargin
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_HEADMARGIN);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setHeadMargin:(CGFloat)headMargin
{
    CGFloat oldVal = [self headMargin];
    if (oldVal != headMargin)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_HEADMARGIN, [NSNumber numberWithFloat:headMargin], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(CGFloat)tailMargin
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_TAILMARGIN);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setTailMargin:(CGFloat)tailMargin
{
    CGFloat oldVal = [self tailMargin];
    if (oldVal != tailMargin)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_TAILMARGIN, [NSNumber numberWithFloat:tailMargin], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(CGFloat)weight
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_WEIGHT);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setWeight:(CGFloat)weight
{
    if (weight < 0)
        return;
    
    CGFloat oldVal = [self weight];
    if (oldVal != weight)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_WEIGHT, [NSNumber numberWithFloat:weight], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}


-(CGFloat)matchParent
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MATCHPARENT);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setMatchParent:(CGFloat)matchParent
{
    if (matchParent > 1)
        return;
    
    CGFloat oldVal = [self matchParent];
    if (oldVal != matchParent)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MATCHPARENT, [NSNumber numberWithFloat:matchParent], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}



@end



@implementation MyLinearLayout


-(void)construct
{
    [super construct];
    _orientation = LVORIENTATION_VERT;
    _adjustScrollViewContentSize = NO;
    _autoAdjustSize = YES;
    _gravity = LVALIGN_DEFAULT;
    _autoAdjustDir = LVAUTOADJUSTDIR_TAIL;
    _align = LVALIGN_DEFAULT;
    _wrapContent = NO;
}


-(void)setOrientation:(LineViewOrientation)orientation
{
    if (_orientation != orientation)
    {
       
        _orientation = orientation;
         [self setNeedsLayout];
    }
}

-(void)setAutoAdjustSize:(BOOL)autoAdjustSize
{
    if (_autoAdjustSize != autoAdjustSize)
    {
        
        _autoAdjustSize = autoAdjustSize;
        [self setNeedsLayout];
    }
}

-(void)setAlign:(LineViewAlign)align
{
    if (_align != align)
    {
        _align = align;
        [self setNeedsLayout];
    }
}

-(void)setGravity:(LineViewAlign)gravity
{
 
    if (_gravity != gravity)
    {
        _gravity = gravity;
        [self setNeedsLayout];
    }
}

-(void)setAutoAdjustDir:(LineViewAutoAdjustDir)autoAdjustDir
{
    if (_autoAdjustDir != autoAdjustDir)
    {
        _autoAdjustDir = autoAdjustDir;
        [self setNeedsLayout];
    }
}

-(void)setWrapContent:(BOOL)wrapContent
{
    if (_wrapContent != wrapContent)
    {
        _wrapContent = wrapContent;
        [self setNeedsLayout];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(void)layoutSubviewsForVert
{
    

    NSArray *sbs = self.subviews;
    
    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat floatingHeight = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat maxSubViewWidth = 0;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        if (v.headMargin > 0 && v.headMargin < 1)
            totalWeight += v.headMargin;
        else
            fixedHeight += v.headMargin;
        
        if (v.tailMargin > 0 && v.tailMargin < 1)
            totalWeight += v.tailMargin;
        else
            fixedHeight += v.tailMargin;
        
        if (v.frame.size.width > maxSubViewWidth)
            maxSubViewWidth = v.frame.size.width;
        
        if (v.weight > 0.0)
        {
            totalWeight += v.weight;
        }
        else
        {
            
            fixedHeight += v.frame.size.height;
        }
    }
    
    
    //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    floatingHeight = selfHeight - fixedHeight - self.padding.top - self.padding.bottom;
    if (floatingHeight <= 0 || floatingHeight == -0.0)
        floatingHeight = 0;
    
    
    if (self.wrapContent)
    {
        selfWidth = maxSubViewWidth + self.padding.left + self.padding.right;
        CGRect rectSelf = self.frame;
        rectSelf.size.width = selfWidth;
        self.frame = rectSelf;
    }
    

    CGFloat pos = self.padding.top;
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        if (v.headMargin >0 && v.headMargin < 1)
        {
            CGFloat hh = (v.headMargin / totalWeight) * floatingHeight;
            if (hh <= 0 || hh == -0.0)
                hh = 0;
            
            pos += hh;
        }
        else
            pos += v.headMargin;
        
        
        CGRect rect = CGRectZero;
        if (v.weight > 0)
        {
            //计算浮动的高度，将剩余的总高度和 高度比重以及总高度比重减去上下的边距来计算自身的高度。
            CGFloat h = (v.weight / totalWeight) * floatingHeight;
            if (h <= 0 || h == -0.0)
                h = 0;
            
            rect = v.frame;
            rect.origin.y = pos;
            rect.size.height = h;
            
            if (v.matchParent != 0)
            {
                if (v.matchParent < 0)
                {
                    rect.size.width = selfWidth + 2 * v.matchParent - self.padding.left - self.padding.right;
                }
                else
                {
                    rect.size.width = selfWidth * v.matchParent - self.padding.left - self.padding.right;
                }
                
                rect.origin.x = (selfWidth - rect.size.width - self.padding.left - self.padding.right)/2;
            }
            
            
            if (_align == LVALIGN_CENTER)
            {
                rect.origin.x = (selfWidth - rect.size.width - self.padding.left - self.padding.right)/2.0 + self.padding.left;
            }
            else if (_align == LVALIGN_LEFT)
            {
                rect.origin.x =  self.padding.left;
            }
            else if (_align == LVALIGN_RIGHT)
            {
                rect.origin.x = selfWidth - self.padding.right - rect.size.width;
            }
            else
            {
                rect.origin.x += self.padding.left;
            }
            
            v.frame = rect;
        }
        else
        {
            rect = v.frame;
            rect.origin.y = pos;
            
            if (v.matchParent != 0)
            {
                if (v.matchParent < 0)
                {
                    rect.size.width = selfWidth + 2 * v.matchParent - self.padding.left - self.padding.right;
                }
                else
                {
                    rect.size.width = selfWidth * v.matchParent - self.padding.left - self.padding.right;
                }
                
                rect.origin.x = (selfWidth - rect.size.width - self.padding.left - self.padding.right)/2;
            }
            
            if (_align == LVALIGN_CENTER)
            {
                rect.origin.x = (selfWidth - rect.size.width - self.padding.left - self.padding.right)/2.0 + self.padding.left;
            }
            else if (_align == LVALIGN_LEFT)
            {
                rect.origin.x =  self.padding.left;
            }
            else if (_align == LVALIGN_RIGHT)
            {
                rect.origin.x = selfWidth - self.padding.right - rect.size.width;
            }
            else
            {
                rect.origin.x += self.padding.left;
            }

            
            v.frame = rect;
        }
        
     
        pos += rect.size.height;
        
        if (v.tailMargin > 0 && v.tailMargin < 1)
        {
            CGFloat th = (v.tailMargin / totalWeight) * floatingHeight;
            if (th <= 0 || th == -0.0)
                th = 0;
            
            pos += th;
            
        }
        else
            pos += v.tailMargin;
    }
    
    pos += self.padding.bottom;
    
    if (self.autoAdjustSize && totalWeight == 0)
    {
        CGRect rectSelf = self.frame;
        
        if (_autoAdjustDir == LVAUTOADJUSTDIR_TAIL)
        {
            rectSelf.size.height = pos;
        }
        else if (_autoAdjustDir == LVAUTOADJUSTDIR_HEAD)
        {
            CGFloat endpos = selfHeight + self.frame.origin.y;
            rectSelf.size.height = pos;
            rectSelf.origin.y = endpos - rectSelf.size.height;
            
        }
        else
        {
            rectSelf.size.height = pos;
            rectSelf.origin.y -= (pos - selfHeight)/2;
        }
        
        self.frame = rectSelf;
    }
    
}

-(void)layoutSubviewsForHorz
{
    NSArray *sbs = self.subviews;
    
    CGFloat fixedWidth = 0;   //计算固定部分的高度
    CGFloat floatingWidth = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat maxSubViewHeight = 0;
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        if (v.headMargin > 0 && v.headMargin < 1)
            totalWeight += v.headMargin;
        else
            fixedWidth += v.headMargin;
        
        if (v.tailMargin > 0 && v.tailMargin < 1)
            totalWeight += v.tailMargin;
        else
            fixedWidth += v.tailMargin;
        
        
        if (maxSubViewHeight < v.frame.size.height)
            maxSubViewHeight = v.frame.size.height;
        
        
        if (v.weight > 0.0)
        {
            totalWeight += v.weight;
        }
        else
        {
            fixedWidth += v.frame.size.width;
        }
    }
    
    //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    floatingWidth = selfWidth - fixedWidth - self.padding.left - self.padding.right;
    if (floatingWidth <= 0 || floatingWidth == -0.0)
        floatingWidth = 0;
    
    //调整自己的高度
    if (self.wrapContent)
    {
        selfHeight = maxSubViewHeight + self.padding.top + self.padding.bottom;
        CGRect rectSelf = self.frame;
        rectSelf.size.height = selfHeight;
        self.frame = rectSelf;
    }
    
    
    CGFloat pos = self.padding.left;
    
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
      
        if (v.headMargin >0 && v.headMargin < 1)
        {
            CGFloat hw = (v.headMargin / totalWeight) * floatingWidth;
            if (hw <= 0 || hw == -0.0)
                hw = 0;
            
            pos += hw;
        }
        else
            pos += v.headMargin;
        
        
        CGRect rect = CGRectZero;
        if (v.weight > 0)
        {
            //计算宽度
            CGFloat w = (v.weight / totalWeight) * floatingWidth;
            if (w <= 0 || w == -0.0)
                w = 0;
            
            rect = v.frame;
            rect.origin.x = pos;
            rect.size.width = w;
            
            if (v.matchParent != 0)
            {
                if (v.matchParent < 0)
                    rect.size.height = selfHeight + 2 *v.matchParent - self.padding.top - self.padding.bottom;
                else
                    rect.size.height = selfHeight * v.matchParent - self.padding.top - self.padding.bottom;
                
                rect.origin.y = (selfHeight - rect.size.height - self.padding.top - self.padding.bottom)/2;
            }
            
            
            
            if (_align == LVALIGN_CENTER)
            {
                rect.origin.y = (selfHeight - rect.size.height -self.padding.top - self.padding.bottom)/2.0 + self.padding.top;
            }
            else if (_align == LVALIGN_TOP)
            {
                rect.origin.y = self.padding.top;
            }
            else if (_align == LVALIGN_BOTTOM)
            {
                rect.origin.y = selfHeight - self.padding.bottom - rect.size.height;
            }
            else
            {
                rect.origin.y += self.padding.top;
            }

            v.frame = rect;
        }
        else
        {
            rect = v.frame;
            rect.origin.x = pos;
            
            if (v.matchParent != 0)
            {
                if (v.matchParent < 0)
                    rect.size.height = selfHeight + 2 *v.matchParent - self.padding.top - self.padding.bottom;
                else
                    rect.size.height = selfHeight * v.matchParent - self.padding.top - self.padding.bottom;
                
                rect.origin.y = (selfHeight - rect.size.height - self.padding.top - self.padding.bottom)/2;
            }
            
            
            
            if (_align == LVALIGN_CENTER)
            {
                rect.origin.y = (selfHeight - rect.size.height -self.padding.top - self.padding.bottom)/2.0 + self.padding.top;
            }
            else if (_align == LVALIGN_TOP)
            {
                rect.origin.y = self.padding.top;
            }
            else if (_align == LVALIGN_BOTTOM)
            {
                rect.origin.y = selfHeight - self.padding.bottom - rect.size.height;
            }
            else
            {
                rect.origin.y += self.padding.top;
            }

            v.frame = rect;
        }
        
      
        pos += rect.size.width;
        
        if (v.tailMargin >0 && v.tailMargin < 1)
        {
            CGFloat tw = (v.tailMargin / totalWeight) * floatingWidth;
            if (tw <= 0 || tw == -0.0)
                tw = 0;
            
            pos += tw;
        }
        else
            pos += v.tailMargin;
    }
    
    pos += self.padding.right;

    if (self.autoAdjustSize && totalWeight == 0)
    {
        CGRect rectSelf = self.frame;

        if (_autoAdjustDir == LVAUTOADJUSTDIR_TAIL)
        {
            rectSelf.size.width = pos;
        }
        else if (_autoAdjustDir == LVAUTOADJUSTDIR_HEAD)
        {
            CGFloat endpos = self.frame.size.width + self.frame.origin.x;
            rectSelf.size.width = pos;
            rectSelf.origin.x = endpos - rectSelf.size.width;
            
        }
        else
        {
            rectSelf.size.width = pos;
            rectSelf.origin.x -= (pos - selfWidth)/2;
        }
        
        self.frame = rectSelf;
    }
    
}



-(void)layoutSubviewsForVertAlign
{
    //计算子视图。
    NSArray *sbs = self.subviews;
    
    CGFloat totalHeight = 0;
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat maxSubViewWidth = 0;
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        if (v.frame.size.width > maxSubViewWidth)
            maxSubViewWidth = v.frame.size.width;
        
        
            totalHeight += v.headMargin;
            totalHeight += v.frame.size.height;
            totalHeight += v.tailMargin;
    }
    

    //调整自己的宽度。
    if (self.wrapContent)
    {
        selfWidth = maxSubViewWidth + self.padding.left + self.padding.right;
        CGRect rectSelf = self.frame;
        rectSelf.size.width = selfWidth;
        self.frame = rectSelf;
    }
    
    //根据对齐的方位来定位子视图的布局对齐
    
    CGFloat pos = 0;
    
    if (_gravity == LVALIGN_TOP)
    {
        pos = self.padding.top;
    }
    else if (_gravity == LVALIGN_CENTER)
    {
        pos = (self.bounds.size.height - totalHeight - self.padding.bottom - self.padding.top)/2.0;
        pos += self.padding.top;
    }
    else
    {
        pos = self.bounds.size.height - totalHeight - self.padding.bottom;
    }
    
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        pos += v.headMargin;
        CGRect rect = v.frame;
        rect.origin.y = pos;
        
        if (v.matchParent != 0)
        {
            if (v.matchParent < 0)
            {
                rect.size.width = selfWidth + 2 * v.matchParent - self.padding.left - self.padding.right;
            }
            else
            {
                rect.size.width = selfWidth * v.matchParent - self.padding.left - self.padding.right;
            }
            
            rect.origin.x = (selfWidth - rect.size.width - self.padding.left - self.padding.right)/2;
        }

        
        if (_align == LVALIGN_CENTER)
        {
            rect.origin.x = (selfWidth - rect.size.width - self.padding.left - self.padding.right)/2.0 + self.padding.left;
        }
        else if (_align == LVALIGN_LEFT)
        {
            rect.origin.x =  self.padding.left;
        }
        else if (_align == LVALIGN_RIGHT)
        {
            rect.origin.x = selfWidth - self.padding.right - rect.size.width;
        }
        else
        {
            rect.origin.x += self.padding.left;
        }

        v.frame = rect;
        
        pos += rect.size.height;
        pos += v.tailMargin;
    }
    
    
}

-(void)layoutSubviewsForHorzAlign
{
    //计算子视图。
    NSArray *sbs = self.subviews;
    
    CGFloat totalWidth = 0;
    CGFloat selfHeight = self.bounds.size.height;
    CGFloat maxSubViewHeight = 0;
   
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        if (maxSubViewHeight < v.frame.size.height)
            maxSubViewHeight = v.frame.size.height;
        
        totalWidth += v.headMargin;
        totalWidth += v.frame.size.width;
        totalWidth += v.tailMargin;
    }
    
    //调整自己的高度
    if (self.wrapContent)
    {
        selfHeight = maxSubViewHeight + self.padding.top + self.padding.bottom;
        CGRect rectSelf = self.frame;
        rectSelf.size.height = selfHeight;
        self.frame = rectSelf;
    }

    
    CGFloat pos = 0;
    if (_gravity == LVALIGN_LEFT)
    {
        pos = self.padding.left;
    }
    else if (_gravity == LVALIGN_CENTER)
    {
        CGFloat pos = (self.bounds.size.width - totalWidth - self.padding.left - self.padding.right)/2.0;
        pos += self.padding.left;
    }
    else
    {
        pos = self.bounds.size.width - totalWidth - self.padding.right;
    }

    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
        pos += v.headMargin;
        CGRect rect = v.frame;
        rect.origin.x = pos;
        
        if (v.matchParent != 0)
        {
            if (v.matchParent < 0)
                rect.size.height = selfHeight + 2 *v.matchParent - self.padding.top - self.padding.bottom;
            else
                rect.size.height = selfHeight * v.matchParent - self.padding.top - self.padding.bottom;
            
            rect.origin.y = (selfHeight - rect.size.height - self.padding.top - self.padding.bottom)/2;
        }
        
        
        
        if (_align == LVALIGN_CENTER)
        {
            rect.origin.y = (selfHeight - rect.size.height -self.padding.top - self.padding.bottom)/2.0 + self.padding.top;
        }
        else if (_align == LVALIGN_TOP)
        {
            rect.origin.y = self.padding.top;
        }
        else if (_align == LVALIGN_BOTTOM)
        {
            rect.origin.y = selfHeight - self.padding.bottom - rect.size.height;
        }
        else
        {
            rect.origin.y += self.padding.top;
        }
        
        v.frame = rect;
        
        pos += rect.size.width;
        pos += v.tailMargin;
    }
    
}




-(void)layoutSubviewAlign
{
    if (self.orientation == LVORIENTATION_VERT)
    {
        [self layoutSubviewsForVertAlign];
    }
    else
    {
        [self layoutSubviewsForHorzAlign];
    }

}


-(void)doLayoutSubviews
{
    
    [super doLayoutSubviews];
  
    if (_gravity != LVALIGN_DEFAULT)
    {
        [self layoutSubviewAlign];
    }
    else
    {
     
        CGRect oldRect = self.bounds;
        
        if (self.orientation == LVORIENTATION_VERT)
        {
            [self layoutSubviewsForVert];
        }
        else
        {
            [self layoutSubviewsForHorz];
        }
        
        
        if (self.autoAdjustSize && self.adjustScrollViewContentSize && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrolv = (UIScrollView*)self.superview;
            CGRect newRect = self.bounds;
            if (newRect.size.height != oldRect.size.height || newRect.size.width != oldRect.size.width)
            {
                CGSize contsize = scrolv.contentSize;
                
                if (_orientation == LVORIENTATION_VERT)
                {
                    contsize.height = self.bounds.size.height;
                }
                else
                {
                    contsize.width = self.bounds.size.width;
                }
                
                scrolv.contentSize = contsize;
                
            }
            
            
        }
    }
}


@end

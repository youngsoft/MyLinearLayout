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
{
    BOOL _isLayouting;   //防止递归调用
}

-(void)construct
{
   // self.backgroundColor = [UIColor clearColor];
    _orientation = LVORIENTATION_VERT;
    _isLayouting = NO;
    _adjustScrollViewContentSize = NO;
    _autoAdjustSize = YES;
    _gravity = LVALIGN_DEFAULT;
    _autoAdjustDir = LVAUTOADJUSTDIR_TAIL;
    _align = LVALIGN_DEFAULT;
    _padding = UIEdgeInsetsZero;
    _wrapContent = NO;
    _priorAutoresizingMask = NO;
    self.backgroundColor = [UIColor clearColor];
    _beginLayoutBlock = nil;
    _endLayoutBlock = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self construct];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self construct];
    }
    return self;
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

-(void)setPadding:(UIEdgeInsets)padding
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_padding, padding))
    {
        _padding = padding;
        [self setNeedsLayout];
    }
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
   [self setPadding:UIEdgeInsetsMake(_padding.top, leftPadding, _padding.bottom,_padding.right)];
}

-(CGFloat)leftPadding
{
    return _padding.left;
}

-(void)setTopPadding:(CGFloat)topPadding
{
    [self setPadding:UIEdgeInsetsMake(topPadding, _padding.left, _padding.bottom,_padding.right)];
}

-(CGFloat)topPadding
{
    return _padding.top;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    [self setPadding:UIEdgeInsetsMake(_padding.top, _padding.left, _padding.bottom,rightPadding)];
}

-(CGFloat)rightPadding
{
    return _padding.right;
}

-(void)setBottomPadding:(CGFloat)bottomPadding
{
    [self setPadding:UIEdgeInsetsMake(_padding.top, _padding.left, bottomPadding,_padding.right)];
}

-(CGFloat)bottomPadding
{
    return _padding.bottom;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    if (!_isLayouting && [self.subviews containsObject:object])
    {
        [self setNeedsLayout];
    }
}


- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];   //只要加入进来后就修改其默认的实现，而改用我们的实现，这里包括隐藏,调整大小，
    
    //添加hidden, frame, bounds, center的属性通知。
    [subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [subview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    [subview addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];

    
    [self setNeedsLayout];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];  //删除后恢复其原来的实现。
    
    [subview removeObserver:self forKeyPath:@"hidden"];
    [subview removeObserver:self forKeyPath:@"frame"];
    [subview removeObserver:self forKeyPath:@"bounds"];
    [subview removeObserver:self forKeyPath:@"center"];
    
    [self setNeedsLayout];
}


-(void)layoutSubviewsForVert
{
    
    //先计算高度，如果有子视图的weight > 0则以父视图的高
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
        
        fixedHeight += v.headMargin;
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
    floatingHeight = selfHeight - fixedHeight - _padding.top - _padding.bottom;
    if (floatingHeight <= 0 || floatingHeight == -0.0)
        floatingHeight = 0;
    
    
    if (self.wrapContent)
    {
        selfWidth = maxSubViewWidth + _padding.left + _padding.right;
        CGRect rectSelf = self.frame;
        rectSelf.size.width = selfWidth;
        self.frame = rectSelf;
    }
    

    CGFloat pos = _padding.top;
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
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
                    rect.size.width = selfWidth + 2 * v.matchParent - _padding.left - _padding.right;
                }
                else
                {
                    rect.size.width = selfWidth * v.matchParent - _padding.left - _padding.right;
                }
                
                rect.origin.x = (selfWidth - rect.size.width - _padding.left - _padding.right)/2;
            }
            
            
            if (_align == LVALIGN_CENTER)
            {
                rect.origin.x = (selfWidth - rect.size.width - _padding.left - _padding.right)/2.0 + _padding.left;
            }
            else if (_align == LVALIGN_LEFT)
            {
                rect.origin.x =  _padding.left;
            }
            else if (_align == LVALIGN_RIGHT)
            {
                rect.origin.x = selfWidth - _padding.right - rect.size.width;
            }
            else
            {
                rect.origin.x += _padding.left;
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
                    rect.size.width = selfWidth + 2 * v.matchParent - _padding.left - _padding.right;
                }
                else
                {
                    rect.size.width = selfWidth * v.matchParent - _padding.left - _padding.right;
                }
                
                rect.origin.x = (selfWidth - rect.size.width - _padding.left - _padding.right)/2;
            }
            
            if (_align == LVALIGN_CENTER)
            {
                rect.origin.x = (selfWidth - rect.size.width - _padding.left - _padding.right)/2.0 + _padding.left;
            }
            else if (_align == LVALIGN_LEFT)
            {
                rect.origin.x =  _padding.left;
            }
            else if (_align == LVALIGN_RIGHT)
            {
                rect.origin.x = selfWidth - _padding.right - rect.size.width;
            }
            else
            {
                rect.origin.x += _padding.left;
            }

            
            v.frame = rect;
        }
        
     
        pos += rect.size.height;
        pos += v.tailMargin;
    }
    
    pos += _padding.bottom;
    
    if (self.autoAdjustSize)
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
        
        fixedWidth += v.headMargin;
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
    floatingWidth = selfWidth - fixedWidth - _padding.left - _padding.right;
    if (floatingWidth <= 0 || floatingWidth == -0.0)
        floatingWidth = 0;
    
    //调整自己的高度
    if (self.wrapContent)
    {
        selfHeight = maxSubViewHeight + _padding.top + _padding.bottom;
        CGRect rectSelf = self.frame;
        rectSelf.size.height = selfHeight;
        self.frame = rectSelf;
    }
    
    
    CGFloat pos = _padding.left;
    
    for (int i = 0; i < sbs.count; i++) {
        
        UIView *v = [sbs objectAtIndex:i];
        if (v.isHidden)
            continue;
        
      
        pos += v.headMargin;
        
        
        CGRect rect = CGRectZero;
        if (v.weight > 0)
        {
            //计算宽度
            CGFloat h = (v.weight / totalWeight) * floatingWidth;
            if (h <= 0 || h == -0.0)
                h = 0;
            
            rect = v.frame;
            rect.origin.x = pos;
            rect.size.width = h;
            
            if (v.matchParent != 0)
            {
                if (v.matchParent < 0)
                    rect.size.height = selfHeight + 2 *v.matchParent - _padding.top - _padding.bottom;
                else
                    rect.size.height = selfHeight * v.matchParent - _padding.top - _padding.bottom;
                
                rect.origin.y = (selfHeight - rect.size.height - _padding.top - _padding.bottom)/2;
            }
            
            
            
            if (_align == LVALIGN_CENTER)
            {
                rect.origin.y = (selfHeight - rect.size.height -_padding.top - _padding.bottom)/2.0 + _padding.top;
            }
            else if (_align == LVALIGN_TOP)
            {
                rect.origin.y = _padding.top;
            }
            else if (_align == LVALIGN_BOTTOM)
            {
                rect.origin.y = selfHeight - _padding.bottom - rect.size.height;
            }
            else
            {
                rect.origin.y += _padding.top;
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
                    rect.size.height = selfHeight + 2 *v.matchParent - _padding.top - _padding.bottom;
                else
                    rect.size.height = selfHeight * v.matchParent - _padding.top - _padding.bottom;
                
                rect.origin.y = (selfHeight - rect.size.height - _padding.top - _padding.bottom)/2;
            }
            
            
            
            if (_align == LVALIGN_CENTER)
            {
                rect.origin.y = (selfHeight - rect.size.height -_padding.top - _padding.bottom)/2.0 + _padding.top;
            }
            else if (_align == LVALIGN_TOP)
            {
                rect.origin.y = _padding.top;
            }
            else if (_align == LVALIGN_BOTTOM)
            {
                rect.origin.y = selfHeight - _padding.bottom - rect.size.height;
            }
            else
            {
                rect.origin.y += _padding.top;
            }

            v.frame = rect;
        }
        
      
        pos += rect.size.width;
        pos += v.tailMargin;
    }
    
    pos += _padding.right;

    if (self.autoAdjustSize)
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
        selfWidth = maxSubViewWidth + _padding.left + _padding.right;
        CGRect rectSelf = self.frame;
        rectSelf.size.width = selfWidth;
        self.frame = rectSelf;
    }
    
    //根据对齐的方位来定位子视图的布局对齐
    
    CGFloat pos = 0;
    
    if (_gravity == LVALIGN_TOP)
    {
        pos = _padding.top;
    }
    else if (_gravity == LVALIGN_CENTER)
    {
        pos = (self.bounds.size.height - totalHeight - _padding.bottom - _padding.top)/2.0;
        pos += _padding.top;
    }
    else
    {
        pos = self.bounds.size.height - totalHeight - _padding.bottom;
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
                rect.size.width = selfWidth + 2 * v.matchParent - _padding.left - _padding.right;
            }
            else
            {
                rect.size.width = selfWidth * v.matchParent - _padding.left - _padding.right;
            }
            
            rect.origin.x = (selfWidth - rect.size.width - _padding.left - _padding.right)/2;
        }

        
        if (_align == LVALIGN_CENTER)
        {
            rect.origin.x = (selfWidth - rect.size.width - _padding.left - _padding.right)/2.0 + _padding.left;
        }
        else if (_align == LVALIGN_LEFT)
        {
            rect.origin.x =  _padding.left;
        }
        else if (_align == LVALIGN_RIGHT)
        {
            rect.origin.x = selfWidth - _padding.right - rect.size.width;
        }
        else
        {
            rect.origin.x += _padding.left;
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
        selfHeight = maxSubViewHeight + _padding.top + _padding.bottom;
        CGRect rectSelf = self.frame;
        rectSelf.size.height = selfHeight;
        self.frame = rectSelf;
    }

    
    CGFloat pos = 0;
    if (_gravity == LVALIGN_LEFT)
    {
        pos = _padding.left;
    }
    else if (_gravity == LVALIGN_CENTER)
    {
        CGFloat pos = (self.bounds.size.width - totalWidth - _padding.left - _padding.right)/2.0;
        pos += _padding.left;
    }
    else
    {
        pos = self.bounds.size.width - totalWidth - _padding.right;
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
                rect.size.height = selfHeight + 2 *v.matchParent - _padding.top - _padding.bottom;
            else
                rect.size.height = selfHeight * v.matchParent - _padding.top - _padding.bottom;
            
            rect.origin.y = (selfHeight - rect.size.height - _padding.top - _padding.bottom)/2;
        }
        
        
        
        if (_align == LVALIGN_CENTER)
        {
            rect.origin.y = (selfHeight - rect.size.height -_padding.top - _padding.bottom)/2.0 + _padding.top;
        }
        else if (_align == LVALIGN_TOP)
        {
            rect.origin.y = _padding.top;
        }
        else if (_align == LVALIGN_BOTTOM)
        {
            rect.origin.y = selfHeight - _padding.bottom - rect.size.height;
        }
        else
        {
            rect.origin.y += _padding.top;
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


-(void)layoutSubviews
{
    NSLog(@"layoutSubviews");
    
    
    if (_beginLayoutBlock != nil)
        _beginLayoutBlock();
    
    _isLayouting = YES;
    
    if (_priorAutoresizingMask)
        [super layoutSubviews];
    
    
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
                scrolv.contentSize = self.bounds.size;
                
            }
            
            
        }

        
    }
    

    _isLayouting = NO;
    
    if (_endLayoutBlock != nil)
        _endLayoutBlock();
}


@end

//
//  MyLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyLayout.h"
#import <objc/runtime.h>


@implementation UIView(LayoutExtra)


const char * const ASSOCIATEDOBJECT_KEY_TOPMARGIN = "associatedobject_key_topmargin";
const char * const ASSOCIATEDOBJECT_KEY_LEFTMARGIN = "associatedobject_key_leftmargin";
const char * const ASSOCIATEDOBJECT_KEY_BOTTOMMARGIN = "associatedobject_key_bottommargin";
const char * const ASSOCIATEDOBJECT_KEY_RIGHTMARGIN = "associatedobject_key_rightmargin";
const char * const ASSOCIATEDOBJECT_KEY_MARGINGRAVITY = "associatedobject_key_margingravity";
const char * const ASSOCIATEDOBJECT_KEY_MATCHPARENTHEIGHT = "associatedobject_key_matchparentheight";
const char * const ASSOCIATEDOBJECT_KEY_MATCHPARENTWIDTH = "associatedobject_key_matchparentwidth";
const char * const ASSOCIATEDOBJECT_KEY_FLEXEDHEIGHT = "associatedobject_key_flexedheight";


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

-(void)setMargin:(UIEdgeInsets)margin
{
    self.topMargin = margin.top;
    self.leftMargin = margin.left;
    self.bottomMargin = margin.bottom;
    self.rightMargin = margin.right;
}

-(UIEdgeInsets)margin
{
    return  UIEdgeInsetsMake(self.topMargin, self.leftMargin, self.bottomMargin, self.rightMargin);
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
    MarignGravity oldVal = [self marginGravity];
    if (oldVal != marginGravity)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MARGINGRAVITY, [NSNumber numberWithUnsignedChar:marginGravity], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}



-(CGFloat)matchParentHeight
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MATCHPARENTHEIGHT);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setMatchParentHeight:(CGFloat)matchParentHeight
{
    if (matchParentHeight > 1)
        return;
    
    CGFloat oldVal = [self matchParentHeight];
    if (oldVal != matchParentHeight)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MATCHPARENTHEIGHT, [NSNumber numberWithFloat:matchParentHeight], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}


-(CGFloat)matchParentWidth
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MATCHPARENTWIDTH);
    if (num == nil)
        return 0;
    return num.floatValue;
}

-(void)setMatchParentWidth:(CGFloat)matchParentWidth
{
    if (matchParentWidth > 1)
        return;
    
    CGFloat oldVal = [self matchParentWidth];
    if (oldVal != matchParentWidth)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MATCHPARENTWIDTH, [NSNumber numberWithFloat:matchParentWidth], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}





-(void)setFlexedHeight:(BOOL)flexedHeight
{
    BOOL oldVal = [self isFlexedHeight];
    if (oldVal != flexedHeight)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_FLEXEDHEIGHT, [NSNumber numberWithBool:flexedHeight], OBJC_ASSOCIATION_RETAIN);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)isFlexedHeight
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_FLEXEDHEIGHT);
    if (num == nil)
        return NO;
    
    return num.boolValue;
}



@end


@implementation MyLayout


-(void)construct
{
    _isLayouting = NO;
    _padding = UIEdgeInsetsZero;
    _priorAutoresizingMask = NO;
    _beginLayoutBlock = nil;
    _endLayoutBlock = nil;
    self.backgroundColor = [UIColor clearColor];
}

-(void)doLayoutSubviews
{
    
}

-(BOOL)isRelativeMargin:(CGFloat)margin
{
    return margin > 0 && margin < 1;
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


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    //将要添加到父视图时，如果不是MyLayout派生则则跟父视图保持一致并
    if (self.matchParentHeight != 0 || self.matchParentWidth != 0)
    {
        if (![newSuperview isKindOfClass:[MyLayout class]])
        {
            CGRect rectSuper = newSuperview.bounds;
            CGRect rectSelf = self.frame;
            self.autoresizingMask = UIViewAutoresizingNone;
             if (self.matchParentWidth != 0)
             {
                 [self calcMatchParentWidth:self.matchParentWidth selfWidth:rectSuper.size.width leftMargin:self.leftMargin rightMargin:self.rightMargin leftPadding:0 rightPadding:0 rect:&rectSelf];
                 self.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
             }
            if (self.matchParentHeight != 0)
            {
                [self calcMatchParentHeight:self.matchParentHeight selfHeight:rectSuper.size.height topMargin:self.topMargin bottomMargin:self.bottomMargin topPadding:0 bottomPadding:0 rect:&rectSelf];
                self.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
            }
            
            self.frame = rectSelf;
            
        }
    }
    
}


-(void)layoutSubviews
{
    
    if (self.beginLayoutBlock != nil)
        self.beginLayoutBlock();
    
    self.isLayouting = YES;
    
    if (self.priorAutoresizingMask)
        [super layoutSubviews];
    
    
    [self doLayoutSubviews];
    
    
    self.isLayouting = NO;
    
    if (self.endLayoutBlock != nil)
        self.endLayoutBlock();
}


#pragma mark -- helperMethod

-(void)vertGravity:(MarignGravity)vert
        selfHeight:(CGFloat)selfHeight
         topMargin:(CGFloat)topMargin
      bottomMargin:(CGFloat)bottomMargin
              rect:(CGRect*)pRect
{
    CGFloat fixedHeight = self.padding.top + self.padding.bottom;
    
    if ([self isRelativeMargin:topMargin])
        topMargin = (selfHeight - fixedHeight) * topMargin;
    
    if ([self isRelativeMargin:bottomMargin])
        bottomMargin = (selfHeight - fixedHeight) * bottomMargin;
    

    
    if (vert == MGRAVITY_VERT_FILL)
    {
        
        pRect->origin.y = self.padding.top + topMargin;
        pRect->size.height = selfHeight - self.padding.bottom - bottomMargin - pRect->origin.y;
    }
    else if (vert == MGRAVITY_VERT_CENTER)
    {
        
        pRect->origin.y = (selfHeight - self.padding.top - self.padding.bottom - topMargin - bottomMargin - pRect->size.height)/2 + self.padding.top + topMargin;
    }
    else if (vert == MGRAVITY_VERT_BOTTOM)
    {
        
        pRect->origin.y = selfHeight - self.padding.bottom - bottomMargin - pRect->size.height;
    }
    else if (vert == MGRAVITY_VERT_TOP)
    {
        pRect->origin.y = self.padding.top + topMargin;
    }
    else
    {
         pRect->origin.y = self.padding.top + topMargin;
    }
    

}

-(void)horzGravity:(MarignGravity)horz
         selfWidth:(CGFloat)selfWidth
        leftMargin:(CGFloat)leftMargin
       rightMargin:(CGFloat)rightMargin
              rect:(CGRect*)pRect
{
    
    CGFloat fixedWidth = self.padding.left + self.padding.right;
    if ([self isRelativeMargin:leftMargin])
        leftMargin = (selfWidth - fixedWidth) * leftMargin;
    
    if ([self isRelativeMargin:rightMargin])
        rightMargin = (selfWidth - fixedWidth) * rightMargin;
    
    
    if (horz == MGRAVITY_HORZ_FILL)
    {

        pRect->origin.x = self.padding.left + leftMargin;
        pRect->size.width = selfWidth - self.padding.right - rightMargin - pRect->origin.x;
    }
    else if (horz == MGRAVITY_HORZ_CENTER)
    {
        pRect->origin.x = (selfWidth - self.padding.left - self.padding.right - leftMargin - rightMargin - pRect->size.width)/2 + self.padding.left + leftMargin;
    }
    else if (horz == MGRAVITY_HORZ_RIGHT)
    {
        
        pRect->origin.x = selfWidth - self.padding.right - rightMargin - pRect->size.width;
    }
    else if (horz == MGRAVITY_HORZ_LEFT)
    {
        pRect->origin.x = self.padding.left + leftMargin;
    }
    else
    {
         pRect->origin.x = self.padding.left + leftMargin;
    }
}


-(void)calcMatchParentWidth:(CGFloat)matchParent selfWidth:(CGFloat)selfWidth leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding rect:(CGRect*)pRect
{
    
    if (matchParent != 0)
    {
        
        CGFloat vTotalWidth = 0;
        
        if (matchParent < 0)
            vTotalWidth = selfWidth - leftPadding - rightPadding + 2*matchParent;
        else
            vTotalWidth = (selfWidth - leftPadding - rightPadding)*matchParent;
        
        if ([self isRelativeMargin:leftMargin])
            leftMargin = vTotalWidth * leftMargin;
        
        
        if ([self isRelativeMargin:rightMargin])
            rightMargin = vTotalWidth * rightMargin;
        
        pRect->size.width = vTotalWidth - leftMargin - rightMargin;
        pRect->origin.x = (selfWidth - pRect->size.width - leftPadding - rightPadding - leftMargin - rightMargin )/2 + leftPadding + leftMargin;
    }
    
}

-(void)calcMatchParentHeight:(CGFloat)matchParent selfHeight:(CGFloat)selfHeight topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin topPadding:(CGFloat)topPadding bottomPadding:(CGFloat)bottomPadding rect:(CGRect*)pRect
{
    
    if (matchParent != 0)
    {
        
        CGFloat vTotalHeight = 0;
        
        if (matchParent < 0)
            vTotalHeight = selfHeight - topPadding - bottomPadding + 2 *matchParent;
        else
            vTotalHeight = (selfHeight - topPadding - bottomPadding)*matchParent;
        
        if ([self isRelativeMargin:topMargin])
            topMargin = vTotalHeight * topMargin;
        
        
        if ([self isRelativeMargin:bottomMargin])
            bottomMargin = vTotalHeight * bottomMargin;
        
        pRect->size.height = vTotalHeight - topMargin - bottomMargin;
        pRect->origin.y = (selfHeight - pRect->size.height - topPadding - bottomPadding - topMargin - bottomMargin )/2 + topPadding + topMargin;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

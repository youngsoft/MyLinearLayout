//
//  MyLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyLayout.h"
#import <objc/runtime.h>


@implementation MyMaker
{
    __weak UIView *_myView;
    NSMutableArray *_keys;
}

-(id)initWithView:(UIView *)v
{
    self = [self init];
    if (self != nil)
    {
        _myView = v;
        _keys = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(MyMaker*)topMargin
{
    [_keys addObject:@"topMargin"];
    return self;
}

-(MyMaker*)leftMargin
{
    [_keys addObject:@"leftMargin"];
    return self;
}

-(MyMaker*)bottomMargin
{
    [_keys addObject:@"bottomMargin"];
    return self;
}

-(MyMaker*)rightMargin
{
    [_keys addObject:@"rightMargin"];
    return self;
}

-(MyMaker*)margin
{
    [_keys addObject:@"margin"];
    return self;
}

-(MyMaker*)marginGravity
{
    [_keys addObject:@"marginGravity"];
    return self;
}

-(MyMaker*)matchParentWidth
{
    [_keys addObject:@"matchParentWidth"];
    return self;
}

-(MyMaker*)matchParentHeight
{
    [_keys addObject:@"matchParentHeight"];
    return self;
}

-(MyMaker*)flexedHeight
{
    [_keys addObject:@"flexedHeight"];
    return self;
}

-(MyMaker*)height
{
    [_keys addObject:@"height"];
    return self;
}

-(MyMaker*)width
{
    [_keys addObject:@"width"];
    return self;
}

-(MyMaker*)size
{
    [_keys addObject:@"size"];
    return self;
}

-(MyMaker*)topPadding
{
    [_keys addObject:@"topPadding"];
    return self;
}

-(MyMaker*)leftPadding
{
    [_keys addObject:@"leftPadding"];
    return self;
}

-(MyMaker*)bottomPadding
{
    [_keys addObject:@"bottomPadding"];
    return self;
}

-(MyMaker*)rightPadding
{
    [_keys addObject:@"rightPadding"];
    return self;
}


//布局独有
-(MyMaker*)orientation
{
    [_keys addObject:@"orientation"];
    return self;
}

-(MyMaker*)wrapContent
{
    [_keys addObject:@"wrapContent"];
    return self;
}

-(MyMaker*)adjustScrollViewContentSize
{
    [_keys addObject:@"adjustScrollViewContentSize"];
    return self;
}

-(MyMaker*)gravity
{
    [_keys addObject:@"gravity"];
    return self;
}

-(MyMaker*)autoAdjustSize
{
    [_keys addObject:@"autoAdjustSize"];
    return self;
}


-(MyMaker*)autoAdjustDir
{
    [_keys addObject:@"autoAdjustDir"];
    return self;
}



-(MyMaker* (^)(id val))equalTo
{
    
     return ^id(id val) {
         
         for (NSString *key in _keys)
         {
             id vv = val;
             
             if ([val isKindOfClass:[UIView class]])
             {
                 UIView *v = val;
                 vv = [v valueForKey:key];
             }
             
             [_myView setValue:vv forKey:key];
         }
         
         [_keys removeAllObjects];
         return self;
     };
}



@end



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

-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}


-(CGFloat)width
{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

-(CGSize)size
{
    return self.frame.size;
}

-(void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size.width = size.width;
    rect.size.height = size.height;
    
    self.frame = rect;
}

-(void)makeLayout:(void(^)(MyMaker *make))layoutMaker
{
    MyMaker *mymaker = [[MyMaker alloc] initWithView:self];
    layoutMaker(mymaker);
}


@end

@implementation MyBorderLineDraw

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _color = [UIColor blackColor];
        _insetColor = nil;
        _thick = 1;
        _headIndent = 0;
        _tailIndent = 0;
        _dash  = 0;
    }
    
    return self;
}

-(id)initWithColor:(UIColor *)color
{
    self = [self init];
    if (self != nil)
    {
        _color = color;
    }
    
    return self;
}

@end

@interface MyLayout()<UIGestureRecognizerDelegate>

@end

@implementation MyLayout
{
    __weak id _target;
    SEL   _action;
    UIColor *_oldBackgroundColor;
    BOOL _hasBegin;
    BOOL _canTouch;
    BOOL _canCallAction;
    CGPoint _beginPoint;
}


-(void)construct
{
    _isLayouting = NO;
    _padding = UIEdgeInsetsZero;
    _priorAutoresizingMask = NO;
    _beginLayoutBlock = nil;
    _endLayoutBlock = nil;
    self.backgroundColor = [UIColor clearColor];
    _leftBorderLine = nil;
    _rightBorderLine = nil;
    _bottomBorderLine = nil;
    _topBorderLine = nil;
    _oldBackgroundColor = nil;
    _target = nil;
    _action = nil;
    _hasBegin = NO;
    _canTouch = YES;
    _canCallAction = NO;
    _beginPoint = CGPointZero;
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

-(void)setBoundBorderLine:(MyBorderLineDraw *)boundBorderLine
{
    self.leftBorderLine = boundBorderLine;
    self.rightBorderLine = boundBorderLine;
    self.topBorderLine = boundBorderLine;
    self.bottomBorderLine = boundBorderLine;
    [self setNeedsDisplay];
}

-(MyBorderLineDraw*)boundBorderLine
{
    return self.leftBorderLine;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_target != nil && _canTouch)
    {
        _hasBegin = YES;
        _canCallAction = YES;
        _beginPoint = [((UITouch*)[touches anyObject]) locationInView:self];
        if (_highlightedBackgroundColor != nil)
        {
            _oldBackgroundColor = self.backgroundColor;
            self.backgroundColor = _highlightedBackgroundColor;
        }
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_target != nil && _hasBegin)
    {
        if (_canCallAction)
        {
            CGPoint pt = [((UITouch*)[touches anyObject]) locationInView:self];
            if (fabs(pt.x - _beginPoint.x) > 2 || fabs(pt.y - _beginPoint.y) > 2)
                _canCallAction = NO;
        }
    }

    [super touchesMoved:touches withEvent:event];
}

-(void)doTargetAction:(UITouch*)touch
{
    if (_highlightedBackgroundColor != nil)
    {
        self.backgroundColor = _oldBackgroundColor;
    }
    
    //距离太远则不会处理
    CGPoint pt = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, pt) && _action != nil && _canCallAction)
    {
        [_target performSelector:_action withObject:self];
    }
    
    _canTouch = YES;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_target != nil && _hasBegin)
    {
        //设置一个延时.
        _canTouch = NO;
        [self performSelector:@selector(doTargetAction:) withObject:[touches anyObject] afterDelay:0.12];
    }
    
    _hasBegin = NO;

    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
    
    if (_target != nil && _hasBegin)
    {
        if (_highlightedBackgroundColor != nil)
        {
            self.backgroundColor = _oldBackgroundColor;
        }
        
    }
    
    _hasBegin = NO;

    [super touchesCancelled:touches withEvent:event];
}

-(void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
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
        // pRect->origin.y = self.padding.top + topMargin;
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
        // pRect->origin.x = self.padding.left + leftMargin;
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



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.leftBorderLine)
    {
        //绘制内容。
        CGContextRef ctx =  UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        if (self.leftBorderLine.dash != 0)
        {
            CGFloat lengths[2];
            lengths[0] = self.leftBorderLine.dash;
            lengths[1] = self.leftBorderLine.dash;
            CGContextSetLineDash(ctx, self.leftBorderLine.dash/2, lengths, 2);
        }
        
        if (self.leftBorderLine.insetColor != nil)
        {
            CGContextSetStrokeColorWithColor(ctx, self.leftBorderLine.insetColor.CGColor);
            CGContextSetLineWidth(ctx, self.leftBorderLine.thick);
        
            CGContextMoveToPoint(ctx, 1, self.leftBorderLine.headIndent);
            CGContextAddLineToPoint(ctx, 1, rect.size.height - self.leftBorderLine.tailIndent - self.leftBorderLine.headIndent);
            CGContextStrokePath(ctx);
        }
        
        CGContextSetStrokeColorWithColor(ctx, self.leftBorderLine.color.CGColor);
        CGContextSetLineWidth(ctx, self.leftBorderLine.thick);
        
        CGContextMoveToPoint(ctx, 0, self.leftBorderLine.headIndent);
        CGContextAddLineToPoint(ctx, 0, rect.size.height - self.leftBorderLine.tailIndent - self.leftBorderLine.headIndent);
        CGContextStrokePath(ctx);
 
        CGContextRestoreGState(ctx);
        
    }
    
    if (self.rightBorderLine)
    {
        CGContextRef ctx =  UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(ctx);
        
        if (self.rightBorderLine.dash != 0)
        {
            CGFloat lengths[2];
            lengths[0] = self.rightBorderLine.dash;
            lengths[1] = self.rightBorderLine.dash;
            CGContextSetLineDash(ctx, self.rightBorderLine.dash/2, lengths, 2);
        }

        CGFloat inset = self.rightBorderLine.insetColor == nil ? 0 : 1;
        
        CGContextSetStrokeColorWithColor(ctx, self.rightBorderLine.color.CGColor);
        CGContextSetLineWidth(ctx, self.rightBorderLine.thick);
        
        CGContextMoveToPoint(ctx, rect.size.width - inset, self.rightBorderLine.headIndent);
        CGContextAddLineToPoint(ctx, rect.size.width - inset, rect.size.height - self.rightBorderLine.tailIndent - self.rightBorderLine.headIndent);
        CGContextStrokePath(ctx);
        
        if (self.rightBorderLine.insetColor != nil)
        {
            CGContextSetStrokeColorWithColor(ctx, self.rightBorderLine.insetColor.CGColor);
            CGContextSetLineWidth(ctx, self.rightBorderLine.thick);
        
            CGContextMoveToPoint(ctx, rect.size.width, self.rightBorderLine.headIndent);
            CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height - self.rightBorderLine.tailIndent - self.rightBorderLine.headIndent);
            CGContextStrokePath(ctx);
        }
        

        CGContextRestoreGState(ctx);
        
    }
    
    if (self.topBorderLine)
    {
        CGContextRef ctx =  UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(ctx);
        
        if (self.topBorderLine.dash != 0)
        {
            CGFloat lengths[2];
            lengths[0] = self.topBorderLine.dash;
            lengths[1] = self.topBorderLine.dash;
            CGContextSetLineDash(ctx, self.topBorderLine.dash/2, lengths, 2);
        }
        
        if (self.topBorderLine.insetColor != nil)
        {
            CGContextSetStrokeColorWithColor(ctx, self.topBorderLine.insetColor.CGColor);
            CGContextSetLineWidth(ctx, self.topBorderLine.thick);
        
            CGContextMoveToPoint(ctx, self.topBorderLine.headIndent, 1);
            CGContextAddLineToPoint(ctx,rect.size.width - self.topBorderLine.tailIndent - self.topBorderLine.tailIndent, 1);
            CGContextStrokePath(ctx);
        }

        
        CGContextSetStrokeColorWithColor(ctx, self.topBorderLine.color.CGColor);
        CGContextSetLineWidth(ctx, self.topBorderLine.thick);
        
        CGContextMoveToPoint(ctx, self.topBorderLine.headIndent, 0);
        CGContextAddLineToPoint(ctx,rect.size.width - self.topBorderLine.tailIndent - self.topBorderLine.headIndent, 0);
        CGContextStrokePath(ctx);
        
        CGContextRestoreGState(ctx);

        
    }

    if (self.bottomBorderLine)
    {
        CGContextRef ctx =  UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(ctx);
        
        if (self.bottomBorderLine.dash != 0)
        {
            CGFloat lengths[2];
            lengths[0] = self.bottomBorderLine.dash;
            lengths[1] = self.bottomBorderLine.dash;
            CGContextSetLineDash(ctx, self.bottomBorderLine.dash/2, lengths, 2);
        }
        

        
        CGContextSetStrokeColorWithColor(ctx, self.bottomBorderLine.color.CGColor);
        CGContextSetLineWidth(ctx, self.bottomBorderLine.thick);
        
        CGFloat inset = self.bottomBorderLine.insetColor == nil ? 0 : 1;
        
        CGContextMoveToPoint(ctx, self.bottomBorderLine.headIndent, rect.size.height - inset);
        CGContextAddLineToPoint(ctx,rect.size.width - self.bottomBorderLine.tailIndent - self.bottomBorderLine.tailIndent, rect.size.height - inset);
        CGContextStrokePath(ctx);
        
        
        if (self.bottomBorderLine.insetColor != nil)
        {
        CGContextSetStrokeColorWithColor(ctx, self.bottomBorderLine.insetColor.CGColor);
        CGContextSetLineWidth(ctx, self.bottomBorderLine.thick);
        
        CGContextMoveToPoint(ctx, self.bottomBorderLine.headIndent, rect.size.height);
        CGContextAddLineToPoint(ctx,rect.size.width - self.bottomBorderLine.tailIndent - self.bottomBorderLine.tailIndent, rect.size.height);
        CGContextStrokePath(ctx);
        }

        CGContextRestoreGState(ctx);        
    }
    
}


@end

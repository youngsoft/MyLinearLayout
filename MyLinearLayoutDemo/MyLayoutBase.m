//
//  MyLayoutBase.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyLayoutBase.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>

@implementation UIView(MyLayoutExt)

const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_LEFT = "associatedobject_key_relativeleft";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_TOP = "associatedobject_key_relativetop";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_RIGHT = "associatedobject_key_relativeright";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_BOTTOM = "associatedobject_key_relativebottom";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_WIDTH = "associatedobject_key_relativewidth";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_HEIGHT = "associatedobject_key_relativeheight";

const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERX = "associatedobject_key_relativecenterx";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERY = "associatedobject_key_relativecentery";

const char * const ASSOCIATEDOBJECT_KEY_FLEXEDHEIGHT = "associatedobject_key_flexedheight";



-(MyLayoutPos*)leftPos
{
    MyLayoutPos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_LEFT);
    if (pos == nil)
    {
        pos = [MyLayoutPos new];
        pos.view = self;
        pos.pos = MGRAVITY_HORZ_LEFT;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_LEFT, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}



-(MyLayoutPos*)topPos
{
    MyLayoutPos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_TOP);
    if (pos == nil)
    {
        pos = [MyLayoutPos new];
        pos.view = self;
        pos.pos = MGRAVITY_VERT_TOP;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_TOP, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}


-(MyLayoutPos*)rightPos
{
    MyLayoutPos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_RIGHT);
    if (pos == nil)
    {
        pos = [MyLayoutPos new];
        pos.view = self;
        pos.pos = MGRAVITY_HORZ_RIGHT;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_RIGHT, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}


-(MyLayoutPos*)bottomPos
{
    MyLayoutPos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_BOTTOM);
    if (pos == nil)
    {
        pos = [MyLayoutPos new];
        pos.view = self;
        pos.pos = MGRAVITY_VERT_BOTTOM;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_BOTTOM, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}


-(CGFloat)leftMargin
{
    return self.leftPos.margin;
}

-(void)setLeftMargin:(CGFloat)leftMargin
{
    self.leftPos.equalTo(@(leftMargin));

}

-(CGFloat)topMargin
{
    return self.topPos.margin;
}

-(void)setTopMargin:(CGFloat)topMargin
{
    self.topPos.equalTo(@(topMargin));
}

-(CGFloat)rightMargin
{
    return self.rightPos.margin;
}

-(void)setRightMargin:(CGFloat)rightMargin
{
    self.rightPos.equalTo(@(rightMargin));
}

-(CGFloat)bottomMargin
{
    return self.bottomPos.margin;
}

-(void)setBottomMargin:(CGFloat)bottomMargin
{
    self.bottomPos.equalTo(@(bottomMargin));
}



-(MyLayoutDime*)widthDime
{
    MyLayoutDime *dime = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_WIDTH);
    if (dime == nil)
    {
        dime = [MyLayoutDime new];
        dime.view = self;
        dime.dime = MGRAVITY_HORZ_FILL;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_WIDTH, dime, OBJC_ASSOCIATION_RETAIN);
    }
    return dime;
}


-(MyLayoutDime*)heightDime
{
    MyLayoutDime *dime = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_HEIGHT);
    if (dime == nil)
    {
        dime = [MyLayoutDime new];
        dime.view = self;
        dime.dime = MGRAVITY_VERT_FILL;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_HEIGHT, dime, OBJC_ASSOCIATION_RETAIN);
    }
    return dime;
}

-(CGFloat)width
{
    return self.widthDime.measure;
}

-(void)setWidth:(CGFloat)width
{
    self.widthDime.equalTo(@(width));
}

-(CGFloat)height
{
    return self.heightDime.measure;
}

-(void)setHeight:(CGFloat)height
{
    self.heightDime.equalTo(@(height));
}

-(CGSize)size
{
    return CGSizeMake(self.width, self.height);
}

-(void)setSize:(CGSize)size
{
    self.width = size.width;
    self.height = size.height;
}


-(MyLayoutPos*)centerXPos
{
    MyLayoutPos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERX);
    if (pos == nil)
    {
        pos = [MyLayoutPos new];
        pos.view = self;
        pos.pos = MGRAVITY_HORZ_CENTER;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERX, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}



-(MyLayoutPos*)centerYPos
{
    MyLayoutPos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERY);
    if (pos == nil)
    {
        pos = [MyLayoutPos new];
        pos.view = self;
        pos.pos = MGRAVITY_VERT_CENTER;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERY, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
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




@implementation MyLayoutPos

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _view = nil;
        _pos = MGRAVITY_NONE;
        _posVal = nil;
        _posValType = MyLayoutValueType_NULL;
        _offsetVal = 0;
    }
    
    return self;
}

-(NSNumber*)posNumVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_NSNumber)
        return _posVal;
    
    return nil;
    
}

-(MyLayoutPos*)posRelaVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Layout)
        return _posVal;
    
    return nil;
    
}

-(MyLayoutPos*)posArrVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Array)
        return _posVal;
    
    return nil;
    
}

-(CGFloat)margin
{
    if (self.posNumVal == nil)
        return _offsetVal;
    else
        return self.posNumVal.floatValue + _offsetVal;
}


-(MyLayoutPos* (^)(CGFloat val))offset
{
    return ^id(CGFloat val){
        
        _offsetVal = val;
        
        return self;
    };
}

-(MyLayoutPos* (^)(id val))equalTo
{
    return ^id(id val){
        
        _posVal = val;
       if ([val isKindOfClass:[NSNumber class]])
            _posValType = MyLayoutValueType_NSNumber;
        else if ([val isKindOfClass:[MyLayoutPos class]])
            _posValType = MyLayoutValueType_Layout;
        else if ([val isKindOfClass:[NSArray class]])
            _posValType = MyLayoutValueType_Array;
        else
            _posValType = MyLayoutValueType_NULL;
        
        return self;
    };
    
}


@end



@implementation MyLayoutDime

-(id)init
{
    self= [super init];
    if (self !=nil)
    {
        _view = nil;
        _dime = MGRAVITY_NONE;
        _addVal = 0;
        _mutilVal = 1;
        _dimeVal = nil;
        _dimeValType = MyLayoutValueType_NULL;
    }
    
    return self;
}

//乘
-(MyLayoutDime* (^)(CGFloat val))multiply
{
    return ^id(CGFloat val){
        
        _mutilVal = val;
        return self;
    };
    
}

//加
-(MyLayoutDime* (^)(CGFloat val))add
{
    return ^id(CGFloat val){
        
        _addVal = val;
        return self;
        
    };
    
}

-(MyLayoutDime* (^)(id val))equalTo
{
    return ^id(id val){
        
        _dimeVal = val;
        
        if ([val isKindOfClass:[NSNumber class]])
            _dimeValType = MyLayoutValueType_NSNumber;
        else if ([val isKindOfClass:[MyLayoutDime class]])
            _dimeValType = MyLayoutValueType_Layout;
        else if ([val isKindOfClass:[NSArray class]])
            _dimeValType = MyLayoutValueType_Array;
        else
            _dimeValType = MyLayoutValueType_NULL;

        
        return self;
    };
    
}

-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_NSNumber)
        return _dimeVal;
    return nil;
}

-(NSArray*)dimeArrVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_Array)
        return _dimeVal;
    return nil;
    
}

-(MyLayoutDime*)dimeRelaVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_Layout)
        return _dimeVal;
    return nil;
    
}

-(BOOL)isMatchParent
{
    return self.dimeRelaVal != nil && self.dimeRelaVal.view == _view.superview;
}

-(BOOL)isMatchView:(UIView*)v
{
    return self.dimeRelaVal != nil && self.dimeRelaVal.view == v;
}


-(CGFloat) measure
{
    return self.dimeNumVal.floatValue * _mutilVal + _addVal;
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

@interface MyLayoutBase()

@end

@implementation MyLayoutBase
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
    _hideSubviewReLayout = YES;
    _wrapContentHeight = NO;
    _wrapContentWidth = NO;
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

-(void)setHideSubviewReLayout:(BOOL)hideSubviewReLayout
{
    if (_hideSubviewReLayout != hideSubviewReLayout)
    {
        _hideSubviewReLayout = hideSubviewReLayout;
        [self setNeedsLayout];
    }
    
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


- (void)willMoveToSuperview:(UIView*)newSuperview
{
    //将要添加到父视图时，如果不是MyLayout派生则则跟父视图保持一致并
    if ([self.heightDime isMatchView:newSuperview] || [self.widthDime isMatchView:newSuperview])
    {
        if (![newSuperview isKindOfClass:[MyLayoutBase class]])
        {
            CGRect rectSuper = newSuperview.bounds;
            CGRect rectSelf = self.frame;
            self.autoresizingMask = UIViewAutoresizingNone;
             if ([self.widthDime isMatchView:newSuperview])
             {
                 [self calcMatchParentWidth:self.widthDime selfWidth:rectSuper.size.width leftMargin:self.leftPos.margin rightMargin:self.rightPos.margin leftPadding:0 rightPadding:0 rect:&rectSelf superView:newSuperview];
                 self.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
             }
            if ([self.heightDime isMatchView:newSuperview])
            {
                [self calcMatchParentHeight:self.heightDime selfHeight:rectSuper.size.height topMargin:self.topPos.margin bottomMargin:self.bottomPos.margin topPadding:0 bottomPadding:0 rect:&rectSelf superView:newSuperview];
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



-(void)calcMatchParentWidth:(MyLayoutDime*)match selfWidth:(CGFloat)selfWidth leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding rect:(CGRect*)pRect superView:(UIView*)newSuperview
{
    BOOL ok = NO;
    if (newSuperview == nil)
        ok = [match isMatchParent];
    else
        ok = [match isMatchView:newSuperview];
    
    if (ok)
    {
        
        CGFloat vTotalWidth = 0;
        
        vTotalWidth = (selfWidth - leftPadding - rightPadding)*match.mutilVal + match.addVal;
        
        if ([self isRelativeMargin:leftMargin])
            leftMargin = vTotalWidth * leftMargin;
        
        
        if ([self isRelativeMargin:rightMargin])
            rightMargin = vTotalWidth * rightMargin;
        
        pRect->size.width = vTotalWidth - leftMargin - rightMargin;
        pRect->origin.x = (selfWidth - pRect->size.width - leftPadding - rightPadding - leftMargin - rightMargin )/2 + leftPadding + leftMargin;
    }
    
}

-(void)calcMatchParentHeight:(MyLayoutDime*)match selfHeight:(CGFloat)selfHeight topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin topPadding:(CGFloat)topPadding bottomPadding:(CGFloat)bottomPadding rect:(CGRect*)pRect superView:(UIView*)newSuperview
{
    
    BOOL ok = NO;
    if (newSuperview == nil)
        ok = [match isMatchParent];
    else
        ok = [match isMatchView:newSuperview];
    
    if (ok)
    {
        
        CGFloat vTotalHeight = (selfHeight - topPadding - bottomPadding)*match.mutilVal + match.addVal;
        
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

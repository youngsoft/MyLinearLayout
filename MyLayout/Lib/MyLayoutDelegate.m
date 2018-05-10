//
//  MyLayoutDelegate.m
//  MyLayout
//
//  Created by oubaiquan on 2017/9/2.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutDelegate.h"
#import "MyBaseLayout.h"
#import "MyLayoutMath.h"


@implementation MyBorderlineLayerDelegate
{
    __weak CALayer *_layoutLayer;
    CGRect _layoutRect;
}

-(id)initWithLayoutLayer:(CALayer*)layoutLayer
{
    self = [self init];
    if (self != nil)
    {
        _layoutLayer = layoutLayer;
        _layoutRect = CGRectZero;
    }
    
    return self;
}

-(void)dealloc
{
    if (_topBorderlineLayer != nil)
    {
        _topBorderlineLayer.delegate = nil;
        [_topBorderlineLayer removeFromSuperlayer];
        _topBorderlineLayer = nil;
    }
    
    if (_bottomBorderlineLayer != nil)
    {
        _bottomBorderlineLayer.delegate = nil;
        [_bottomBorderlineLayer removeFromSuperlayer];
        _bottomBorderlineLayer = nil;
    }
    
    if (_leadingBorderlineLayer != nil)
    {
        _leadingBorderlineLayer.delegate = nil;
        [_leadingBorderlineLayer removeFromSuperlayer];
        _leadingBorderlineLayer = nil;
    }
    
    if (_trailingBorderlineLayer != nil)
    {
        _trailingBorderlineLayer.delegate = nil;
        [_trailingBorderlineLayer removeFromSuperlayer];
        _trailingBorderlineLayer = nil;
    }
        
    
    
}

-(void)setTopBorderline:(MyBorderline *)topBorderline
{
    if (_topBorderline != topBorderline)
    {
        _topBorderline = topBorderline;
        
        CAShapeLayer *borderLayer = _topBorderlineLayer;
        [self updateBorderLayer:&borderLayer withBorderline:_topBorderline];
        _topBorderlineLayer = borderLayer;
        
    }
}

-(void)setLeadingBorderline:(MyBorderline *)leadingBorderline
{
    if (_leadingBorderline != leadingBorderline)
    {
        _leadingBorderline = leadingBorderline;
        
        CAShapeLayer *borderLayer = _leadingBorderlineLayer;
        [self updateBorderLayer:&borderLayer withBorderline:_leadingBorderline];
        _leadingBorderlineLayer = borderLayer;
    }
}

-(void)setBottomBorderline:(MyBorderline *)bottomBorderline
{
    if (_bottomBorderline != bottomBorderline)
    {
        _bottomBorderline = bottomBorderline;
        
        CAShapeLayer *borderLayer = _bottomBorderlineLayer;
        [self updateBorderLayer:&borderLayer withBorderline:_bottomBorderline];
        _bottomBorderlineLayer = borderLayer;
    }
}


-(void)setTrailingBorderline:(MyBorderline *)trailingBorderline
{
    if (_trailingBorderline != trailingBorderline)
    {
        _trailingBorderline = trailingBorderline;
        
        CAShapeLayer *borderLayer = _trailingBorderlineLayer;
        [self updateBorderLayer:&borderLayer withBorderline:_trailingBorderline];
        _trailingBorderlineLayer = borderLayer;
    }
    
}

-(MyBorderline*)leftBorderline
{
    if ([MyBaseLayout isRTL])
        return self.trailingBorderline;
    else
        return self.leadingBorderline;
}

-(void)setLeftBorderline:(MyBorderline *)leftBorderline
{
    if ([MyBaseLayout isRTL])
        self.trailingBorderline = leftBorderline;
    else
        self.leadingBorderline = leftBorderline;
}


-(MyBorderline*)rightBorderline
{
    if ([MyBaseLayout isRTL])
        return self.leadingBorderline;
    else
        return self.trailingBorderline;
}

-(void)setRightBorderline:(MyBorderline *)rightBorderline
{
    if ([MyBaseLayout isRTL])
        self.leadingBorderline = rightBorderline;
    else
        self.trailingBorderline = rightBorderline;
}



-(void)updateBorderLayer:(CAShapeLayer**)ppLayer withBorderline:(MyBorderline*)borderline
{
    
    if (borderline == nil)
    {
        
        if (*ppLayer != nil)
        {
            [(*ppLayer) removeFromSuperlayer];
            (*ppLayer).delegate = nil;
            *ppLayer = nil;
        }
    }
    else
    {
        
        if ( *ppLayer == nil)
        {
            *ppLayer = [[CAShapeLayer alloc] init];
            (*ppLayer).zPosition = 10000;
            (*ppLayer).delegate = self;
            if (_layoutLayer != nil)
                [_layoutLayer addSublayer:*ppLayer];
        }
        
        //如果是点线则是用path，否则就用背景色
        if (borderline.dash != 0)
        {
            (*ppLayer).lineDashPhase = borderline.dash / 2;
            NSNumber *num = @(borderline.dash);
            (*ppLayer).lineDashPattern = @[num,num];
            
            (*ppLayer).strokeColor = borderline.color.CGColor;
            (*ppLayer).lineWidth = borderline.thick;
            (*ppLayer).backgroundColor = nil;
            
        }
        else
        {
            (*ppLayer).lineDashPhase = 0;
            (*ppLayer).lineDashPattern = nil;
            
            (*ppLayer).strokeColor = nil;
            (*ppLayer).lineWidth = 0;
            (*ppLayer).backgroundColor = borderline.color.CGColor;
            
        }
        
        [(*ppLayer) setNeedsLayout];
        
    }
}


-(void)layoutSublayersOfLayer:(CAShapeLayer *)layer
{
    if (_layoutLayer == nil)
        return;
    
    CGPoint layoutPoint = _layoutRect.origin;
    CGSize  layoutSize =  _layoutRect.size; //_layoutLayer.bounds.size;
    
    if (layoutSize.width == 0 || layoutSize.height == 0 || layer.isHidden)
        return;
    
    CGRect layerRect;
    CGPoint fromPoint;
    CGPoint toPoint;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (layer == self.leadingBorderlineLayer)
    {
        layerRect = CGRectMake(self.leadingBorderline.offset + layoutPoint.x,
                               self.leadingBorderline.headIndent + layoutPoint.y,
                               self.leadingBorderline.thick/scale,
                               layoutSize.height - self.leadingBorderline.headIndent - self.leadingBorderline.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);
        
    }
    else if (layer == self.trailingBorderlineLayer)
    {
        layerRect = CGRectMake(layoutSize.width - self.trailingBorderline.thick / scale - self.trailingBorderline.offset + layoutPoint.x,
                               self.trailingBorderline.headIndent + layoutPoint.y,
                               self.trailingBorderline.thick / scale,
                               layoutSize.height - self.trailingBorderline.headIndent - self.trailingBorderline.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);
        
    }
    else if (layer == self.topBorderlineLayer)
    {
        layerRect = CGRectMake(self.topBorderline.headIndent + layoutPoint.x,
                               self.topBorderline.offset + layoutPoint.y,
                               layoutSize.width - self.topBorderline.headIndent - self.topBorderline.tailIndent,
                               self.topBorderline.thick/scale);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
    }
    else if (layer == self.bottomBorderlineLayer)
    {
        layerRect = CGRectMake(self.bottomBorderline.headIndent + layoutPoint.x,
                               layoutSize.height - self.bottomBorderline.thick / scale - self.bottomBorderline.offset + layoutPoint.y,
                               layoutSize.width - self.bottomBorderline.headIndent - self.bottomBorderline.tailIndent,
                               self.bottomBorderline.thick /scale);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
        
    }
    else
    {
        layerRect = CGRectZero;
        fromPoint = CGPointZero;
        toPoint = CGPointZero;
        NSAssert(0, @"oops!");
    }
    
    if ([MyBaseLayout isRTL])
    {
        layerRect.origin.x = layoutSize.width - layerRect.origin.x - layerRect.size.width;
    }
    
    //把动画效果取消。
    
    
    if (!_myCGRectEqual(layer.frame, layerRect))
    {
        if (layer.lineDashPhase == 0)
        {
            layer.path = nil;
        }
        else
        {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, fromPoint.x, fromPoint.y);
            CGPathAddLineToPoint(path, nil, toPoint.x,toPoint.y);
            layer.path = path;
            CGPathRelease(path);
        }
        layer.frame = layerRect;
        
    }
    
}


- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    return [NSNull null];
}


-(void)setNeedsLayoutIn:(CGRect)rect withLayer:(CALayer*)layer
{
    _layoutLayer = layer;
    _layoutRect = rect;
    if (_topBorderlineLayer != nil)
    {
        if (_topBorderlineLayer.superlayer == nil)
            [layer addSublayer:_topBorderlineLayer];
        
        if (_topBorderlineLayer.isHidden)
            _topBorderlineLayer.hidden = NO;
        [_topBorderlineLayer setNeedsLayout];
    }
    
    if (_bottomBorderlineLayer != nil)
    {
        if (_bottomBorderlineLayer.superlayer == nil)
            [layer addSublayer:_bottomBorderlineLayer];
        
        if (_bottomBorderlineLayer.isHidden)
            _bottomBorderlineLayer.hidden = NO;
        [_bottomBorderlineLayer setNeedsLayout];
    }
    
    if (_leadingBorderlineLayer != nil)
    {
        if (_leadingBorderlineLayer.superlayer == nil)
            [layer addSublayer:_leadingBorderlineLayer];
        
        if (_leadingBorderlineLayer.isHidden)
            _leadingBorderlineLayer.hidden = NO;
        [_leadingBorderlineLayer setNeedsLayout];
    }
    
    if (_trailingBorderlineLayer != nil)
    {
        if (_trailingBorderlineLayer.superlayer == nil)
            [layer addSublayer:_trailingBorderlineLayer];
        
        if (_trailingBorderlineLayer.isHidden)
            _trailingBorderlineLayer.hidden = NO;
        [_trailingBorderlineLayer setNeedsLayout];
    }
    
}


@end


//布局的事件处理委托对象
@implementation MyTouchEventDelegate
{
    __weak id _touchDownTarget;
    SEL  _touchDownAction;
    
    __weak id _touchCancelTarget;
    SEL _touchCancelAction;
    BOOL _hasDoCancel;
    
    
    BOOL _forbidTouch;
    BOOL _canCallAction;
    CGPoint _beginPoint;
    
}

BOOL _hasBegin;
__weak MyBaseLayout * _currentLayout;

-(instancetype)initWithLayout:(MyBaseLayout *)layout
{
    self = [self init];
    if (self != nil)
    {
        _layout = layout;
        _currentLayout = nil;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (_layout != nil && _target != nil && !_forbidTouch && touch.tapCount == 1 && !_hasBegin)
    {
        _hasBegin = YES;
        _currentLayout = _layout;
        _canCallAction = YES;
        _beginPoint = [touch locationInView:_layout];
        
        [self mySetTouchHighlighted];
        
        _hasDoCancel = NO;
        [self myPerformTouch:_touchDownTarget withAction:_touchDownAction];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_layout != nil && _target != nil && _hasBegin && (_layout == _currentLayout || _currentLayout == nil))
    {
        if (_canCallAction)
        {
            CGPoint pt = [((UITouch*)[touches anyObject]) locationInView:_layout];
            if (fabs(pt.x - _beginPoint.x) > 2 || fabs(pt.y - _beginPoint.y) > 2)
            {
                _canCallAction = NO;
                
                if (!_hasDoCancel)
                {
                    [self myPerformTouch:_touchCancelTarget withAction:_touchCancelAction];
                    
                    _hasDoCancel = YES;
                    
                }
                
            }
        }
    }
}

-(void)doTargetAction:(UITouch*)touch
{
    
    [self myResetTouchHighlighted];
    
    //距离太远则不会处理
    CGPoint pt = [touch locationInView:_layout];
    if (CGRectContainsPoint(_layout.bounds, pt) && _action != nil && _canCallAction)
    {
        [self myPerformTouch:_target withAction:_action];
        
    }
    else
    {
        if (!_hasDoCancel)
        {
            [self myPerformTouch:_touchCancelTarget withAction:_touchCancelAction];
            _hasDoCancel = YES;
        }
        
    }
    
    _forbidTouch = NO;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_layout != nil && _target != nil && _hasBegin && (_layout == _currentLayout || _currentLayout == nil))
    {
        //设置一个延时.
        _forbidTouch = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:@selector(doTargetAction:) withObject:[touches anyObject] afterDelay:0.12];
#pragma clang diagnostic pop
        
        _hasBegin = NO;
        _currentLayout = nil;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_layout != nil && _target != nil && _hasBegin && (_layout == _currentLayout || _currentLayout == nil))
    {
        [self myResetTouchHighlighted];
        
        _hasBegin = NO;
        _currentLayout = nil;
        
        if (!_hasDoCancel)
        {
            [self myPerformTouch:_touchCancelTarget withAction:_touchCancelAction];
            
            _hasDoCancel = YES;
        }
        
    }
}


///设置触摸时的高亮
-(void)mySetTouchHighlighted
{
}

//恢复触摸时的高亮。
-(void)myResetTouchHighlighted
{
}

-(void)myResetTouchHighlighted2
{
    
}


-(id)myActionSender
{
    return _layout;
}


-(void)myPerformTouch:(id)target withAction:(SEL)action
{
    if (_layout != nil && target != nil && action != nil && self.myActionSender != nil)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:action withObject:[self myActionSender]];
#pragma clang diagnostic pop
        
    }
}

-(void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

-(void)setTouchDownTarget:(id)target action:(SEL)action
{
    _touchDownTarget = target;
    _touchDownAction = action;
}

-(void)setTouchCancelTarget:(id)target action:(SEL)action
{
    _touchCancelTarget = target;
    _touchCancelAction = action;
    
}


@end



@implementation MyLayoutTouchEventDelegate
{
    UIColor *_oldBackgroundColor;
    UIImage *_oldBackgroundImage;
    CGFloat _oldAlpha;
}

-(instancetype)initWithLayout:(MyBaseLayout *)layout
{
    self = [super initWithLayout:layout];
    if (self != nil)
    {
        _oldAlpha = 1;
    }
    
    return self;
}

///设置触摸时的高亮
-(void)mySetTouchHighlighted
{
    if (self.highlightedOpacity != 0)
    {
        _oldAlpha = self.layout.alpha;
        self.layout.alpha = 1 - self.highlightedOpacity;
    }
    
    if (self.highlightedBackgroundColor != nil)
    {
        _oldBackgroundColor = self.layout.backgroundColor;
        self.layout.backgroundColor = self.highlightedBackgroundColor;
    }
    
    if (self.highlightedBackgroundImage != nil)
    {
        _oldBackgroundImage = self.layout.backgroundImage;
        self.layout.backgroundImage = self.highlightedBackgroundImage;
    }
    
}

//恢复触摸时的高亮。
-(void)myResetTouchHighlighted
{
    if (self.highlightedOpacity != 0)
    {
        self.layout.alpha = _oldAlpha;
        _oldAlpha = 1;
    }
    
    if (self.highlightedBackgroundColor != nil)
    {
        self.layout.backgroundColor = _oldBackgroundColor;
        _oldBackgroundColor = nil;
    }
    
    
    if (self.highlightedBackgroundImage != nil)
    {
        self.layout.backgroundImage = _oldBackgroundImage;
        _oldBackgroundImage = nil;
    }
    
}

-(void)myResetTouchHighlighted2
{
    if (_oldAlpha != 1)
    {
        self.layout.alpha = _oldAlpha;
        _oldAlpha = 1;
    }
    
    if (_oldBackgroundColor != nil)
    {
        self.layout.backgroundColor = _oldBackgroundColor;
        _oldBackgroundColor = nil;
    }
    
    if (_oldBackgroundImage != nil)
    {
        self.layout.backgroundImage = _oldBackgroundImage;
        _oldBackgroundImage = nil;
    }
}

@end



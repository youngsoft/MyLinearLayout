//
//  MyBorderline.m
//  MyLayout
//
//  Created by oubaiquan on 2017/8/23.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyBorderline.h"
#import "MyBaseLayout.h"
#import "MyLayoutInner.h"


@implementation MyBorderline


-(instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _color = [UIColor blackColor];
        _thick = 1;
        _headIndent = 0;
        _tailIndent = 0;
        _dash  = 0;
        _offset = 0;
    }
    
    return self;
}

-(instancetype)initWithColor:(UIColor *)color
{
    self = [self init];
    if (self != nil)
    {
        _color = color;
    }
    
    return self;
}

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick
{
    self = [self initWithColor:color];
    if (self != nil)
    {
        self.thick = thick;
    }
    
    return self;
}

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick headIndent:(CGFloat)headIndent tailIndent:(CGFloat)tailIndent
{
    self = [self initWithColor:color thick:thick];
    if (self != nil)
    {
        _headIndent = headIndent;
        _tailIndent = tailIndent;
    }
    
    return self;

}

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick headIndent:(CGFloat)headIndent tailIndent:(CGFloat)tailIndent offset:(CGFloat)offset
{
    self = [self initWithColor:color thick:thick headIndent:headIndent tailIndent:tailIndent];
    if (self != nil)
    {
        _offset = offset;
    }
    
    return self;
}

-(void)setThick:(CGFloat)thick
{
    if (thick < 1)
        thick = 1;
    if (_thick != thick)
    {
        _thick = thick;
    }
}

@end



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


-(void)setNeedsLayoutIn:(CGRect)rect
{
    _layoutRect = rect;
    if (_topBorderlineLayer != nil)
    {
        if (_topBorderlineLayer.isHidden)
            _topBorderlineLayer.hidden = NO;
        [_topBorderlineLayer setNeedsLayout];
    }
    
    if (_bottomBorderlineLayer != nil)
    {
        if (_bottomBorderlineLayer.isHidden)
            _bottomBorderlineLayer.hidden = NO;
        [_bottomBorderlineLayer setNeedsLayout];
    }
    
    if (_leadingBorderlineLayer != nil)
    {
        if (_leadingBorderlineLayer.isHidden)
            _leadingBorderlineLayer.hidden = NO;
        [_leadingBorderlineLayer setNeedsLayout];
    }
    
    if (_trailingBorderlineLayer != nil)
    {
        if (_trailingBorderlineLayer.isHidden)
            _trailingBorderlineLayer.hidden = NO;
        [_trailingBorderlineLayer setNeedsLayout];
    }
    
}


@end




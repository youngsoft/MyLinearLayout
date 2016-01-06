//
//  YSLayoutBase.m
//  YSLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "YSLayoutBase.h"
#import "YSLayoutInner.h"
#import <objc/runtime.h>


const char * const ASSOCIATEDOBJECT_KEY_YSLAYOUT_SIZECLASS = "ASSOCIATEDOBJECT_KEY_YSLAYOUT_SIZECLASS";


@implementation YSLayoutSizeClass


-(YSLayoutPos*)leftPos
{
    if (_leftPos == nil)
    {
        _leftPos = [YSLayoutPos new];
        _leftPos.pos = YSMarignGravity_Horz_Left;
        
    }
    
    return _leftPos;
    
}

-(YSLayoutPos*)topPos
{
    if (_topPos == nil)
    {
        _topPos = [YSLayoutPos new];
        _topPos.pos = YSMarignGravity_Vert_Top;
        
    }
    
    return _topPos;
}

-(YSLayoutPos*)rightPos
{
    if (_rightPos == nil)
    {
        _rightPos = [YSLayoutPos new];
        _rightPos.pos = YSMarignGravity_Horz_Right;
        
    }
    
    return _rightPos;
}

-(YSLayoutPos*)bottomPos
{
    if (_bottomPos == nil)
    {
        _bottomPos = [YSLayoutPos new];
        _bottomPos.pos = YSMarignGravity_Vert_Bottom;
        
    }
    
    return _bottomPos;
}


-(YSLayoutPos*)centerXPos
{
    if (_centerXPos == nil)
    {
        _centerXPos = [YSLayoutPos new];
        _centerXPos.pos = YSMarignGravity_Horz_Center;
        
    }
    
    return _centerXPos;
}

-(YSLayoutPos*)centerYPos
{
    if (_centerYPos == nil)
    {
        _centerYPos = [YSLayoutPos new];
        _centerYPos.pos = YSMarignGravity_Vert_Center;
        
    }
    
    return _centerYPos;
}


-(YSLayoutDime*)widthDime
{
    if (_widthDime == nil)
    {
        _widthDime = [YSLayoutDime new];
        _widthDime.dime = YSMarignGravity_Horz_Fill;
        
    }
    
    return _widthDime;
}


-(YSLayoutDime*)heightDime
{
    if (_heightDime == nil)
    {
        _heightDime = [YSLayoutDime new];
        _heightDime.dime = YSMarignGravity_Vert_Fill;
        
    }
    
    return _heightDime;
}

-(void)setWeight:(CGFloat)weight
{
    if (weight < 0)
        weight = 0;
    
    if (_weight != weight)
        _weight = weight;
}



-(YSLayoutMeasure*)absPos
{
    if (_absPos == nil)
    {
        _absPos = [YSLayoutMeasure new];
    }
    
    return _absPos;
}


@end



@implementation UIView(YSLayoutExt)


-(YSLayoutPos*)leftPos
{
    YSLayoutPos *pos = self.ysLayoutSizeClass.leftPos;
    pos.view = self;
    return pos;
}


-(YSLayoutPos*)topPos
{
    YSLayoutPos *pos = self.ysLayoutSizeClass.topPos;
    pos.view = self;
    return pos;
}


-(YSLayoutPos*)rightPos
{

    YSLayoutPos *pos = self.ysLayoutSizeClass.rightPos;
    pos.view = self;
    return pos;
    
}


-(YSLayoutPos*)bottomPos
{
    
    YSLayoutPos *pos = self.ysLayoutSizeClass.bottomPos;
    pos.view = self;
    return pos;
    
}

#ifdef YS_USEOLDENUMDEF


-(CGFloat)leftMargin
{
    return self.ysLeftMargin;
}

-(void)setLeftMargin:(CGFloat)leftMargin
{
    self.ysLeftMargin = leftMargin;

}

-(CGFloat)topMargin
{
    return self.ysTopMargin;
}

-(void)setTopMargin:(CGFloat)topMargin
{
    self.ysTopMargin = topMargin;
 }

-(CGFloat)rightMargin
{
    return self.ysRightMargin;
}

-(void)setRightMargin:(CGFloat)rightMargin
{
    self.ysRightMargin = rightMargin;
}

-(CGFloat)bottomMargin
{
    return self.ysBottomMargin;
}

-(void)setBottomMargin:(CGFloat)bottomMargin
{
    self.ysBottomMargin = bottomMargin;
}

#endif

-(CGFloat)ysLeftMargin
{
    return self.leftPos.margin;
}

-(void)setYsLeftMargin:(CGFloat)leftMargin
{
    self.leftPos.equalTo(@(leftMargin));
    
}

-(CGFloat)ysTopMargin
{
    return self.topPos.margin;
}

-(void)setYsTopMargin:(CGFloat)topMargin
{
    self.topPos.equalTo(@(topMargin));
}

-(CGFloat)ysRightMargin
{
    return self.rightPos.margin;
}

-(void)setYsRightMargin:(CGFloat)rightMargin
{
    self.rightPos.equalTo(@(rightMargin));
}

-(CGFloat)ysBottomMargin
{
    return self.bottomPos.margin;
}

-(void)setYsBottomMargin:(CGFloat)bottomMargin
{
    self.bottomPos.equalTo(@(bottomMargin));
}



-(YSLayoutDime*)widthDime
{

    YSLayoutDime *dime = self.ysLayoutSizeClass.widthDime;
    dime.view = self;
    return dime;
    
}



-(YSLayoutDime*)heightDime
{

    YSLayoutDime *dime = self.ysLayoutSizeClass.heightDime;
    dime.view = self;
    return dime;
}


#ifdef YS_USEOLDENUMDEF

-(CGFloat)width
{
    return self.ysWidth;
}

-(void)setWidth:(CGFloat)width
{
    self.ysWidth = width;
}

-(CGFloat)height
{
    return self.ysHeight;
}

-(void)setHeight:(CGFloat)height
{
    self.ysHeight = height;
}

#endif

-(CGFloat)ysWidth
{
    return self.widthDime.measure;
}

-(void)setYsWidth:(CGFloat)width
{
    self.widthDime.equalTo(@(width));
}

-(CGFloat)ysHeight
{
    return self.heightDime.measure;
}

-(void)setYsHeight:(CGFloat)height
{
    self.heightDime.equalTo(@(height));
}



-(YSLayoutPos*)centerXPos
{
    YSLayoutPos *pos = self.ysLayoutSizeClass.centerXPos;
    pos.view = self;
    return pos;
    
}


-(YSLayoutPos*)centerYPos
{
    
    YSLayoutPos *pos = self.ysLayoutSizeClass.centerYPos;
    pos.view = self;
    return pos;
}

#ifdef YS_USEOLDENUMDEF

-(CGFloat)centerXOffset
{
    return self.ysCenterXOffset;
}

-(void)setCenterXOffset:(CGFloat)centerXOffset
{
    self.ysCenterXOffset = centerXOffset;
}

-(CGFloat)centerYOffset
{
    return self.ysCenterYOffset;
}

-(void)setCenterYOffset:(CGFloat)centerYOffset
{
    self.ysCenterYOffset = centerYOffset;
}


-(CGPoint)centerOffset
{
    return self.ysCenterOffset;
}

-(void)setCenterOffset:(CGPoint)centerOffset
{
    self.ysCenterOffset = centerOffset;
}

#endif


-(CGFloat)ysCenterXOffset
{
    return self.centerXPos.margin;
}

-(void)setYsCenterXOffset:(CGFloat)centerXOffset
{
    self.centerXPos.equalTo(@(centerXOffset));
}

-(CGFloat)ysCenterYOffset
{
    return self.centerYPos.margin;
}

-(void)setYsCenterYOffset:(CGFloat)centerYOffset
{
    self.centerYPos.equalTo(@(centerYOffset));
}


-(CGPoint)ysCenterOffset
{
    return CGPointMake(self.ysCenterXOffset, self.ysCenterYOffset);
}

-(void)setYsCenterOffset:(CGPoint)centerOffset
{
    self.ysCenterXOffset = centerOffset.x;
    self.ysCenterYOffset = centerOffset.y;
}


-(void)setFlexedHeight:(BOOL)flexedHeight
{
    self.ysLayoutSizeClass.flexedHeight = flexedHeight;
    if (self.superview != nil)
        [self.superview setNeedsLayout];
}

-(BOOL)isFlexedHeight
{
    return self.ysLayoutSizeClass.flexedHeight;
}



-(CGRect)estimatedRect
{
    CGRect rect = self.absPos.frame;
    if (rect.origin.x == CGFLOAT_MAX || rect.origin.y == CGFLOAT_MAX)
        return self.frame;
    return rect;
}


-(void)resetMyLayoutSetting
{
    [self resetYSLayoutSetting];
}

-(void)resetYSLayoutSetting
{
    objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_YSLAYOUT_SIZECLASS, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(BOOL)useFrame
{
    return self.ysLayoutSizeClass.useFrame;
}

-(void)setUseFrame:(BOOL)useFrame
{
    
    self.ysLayoutSizeClass.useFrame = useFrame;
    if (self.superview != nil)
        [ self.superview setNeedsLayout];
    
}




@end


@implementation UIView(YSLayoutExtInner)



-(YSLayoutSizeClass*)ysLayoutSizeClass
{
    YSLayoutSizeClass *ysLayoutSizeClass = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_YSLAYOUT_SIZECLASS);
    if (ysLayoutSizeClass == nil)
    {
        ysLayoutSizeClass = [YSLayoutSizeClass new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_YSLAYOUT_SIZECLASS, ysLayoutSizeClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return ysLayoutSizeClass;
}


-(YSLayoutMeasure*)absPos
{    
    return self.ysLayoutSizeClass.absPos;
}


@end



@implementation YSBorderLineDraw


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


/**绘制线条层委托实现类**/
@interface YSBorderLineLayerDelegate : NSObject

@property(nonatomic ,weak) YSLayoutBase *layout;

-(id)initWithLayout:(YSLayoutBase*)layout;


@end

@implementation YSBorderLineLayerDelegate


-(id)initWithLayout:(YSLayoutBase*)layout
{
    self = [self init];
    if (self != nil)
    {
        _layout = layout;
    }
    
    return self;
}


-(void)layoutSublayersOfLayer:(CAShapeLayer *)layer
{
    if (self.layout == nil)
        return;
    
    CGSize layoutSize = self.layout.layer.bounds.size;
    
    CGRect layerRect;
    CGPoint fromPoint;
    CGPoint toPoint;
    
    if (layer == self.layout.leftBorderLineLayer)
    {
        layerRect = CGRectMake(0, self.layout.leftBorderLine.headIndent, self.layout.leftBorderLine.thick, layoutSize.height - self.layout.leftBorderLine.headIndent - self.layout.leftBorderLine.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);
        
    }
    else if (layer == self.layout.rightBorderLineLayer)
    {
        layerRect = CGRectMake(layoutSize.width - self.layout.rightBorderLine.thick / 2, self.layout.rightBorderLine.headIndent, self.layout.rightBorderLine.thick / 2, layoutSize.height - self.layout.rightBorderLine.headIndent - self.layout.rightBorderLine.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);

    }
    else if (layer == self.layout.topBorderLineLayer)
    {
        layerRect = CGRectMake(self.layout.topBorderLine.headIndent, 0, layoutSize.width - self.layout.topBorderLine.headIndent - self.layout.topBorderLine.tailIndent, self.layout.topBorderLine.thick/2);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
    }
    else if (layer == self.layout.bottomBorderLineLayer)
    {
        layerRect = CGRectMake(self.layout.bottomBorderLine.headIndent, layoutSize.height - self.layout.bottomBorderLine.thick / 2, layoutSize.width - self.layout.bottomBorderLine.headIndent - self.layout.bottomBorderLine.tailIndent, self.layout.bottomBorderLine.thick /2);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
    }
    else
    {
        NSAssert(0, @"oops!");
    }
    
    
    //把动画效果取消。
    if (!CGRectEqualToRect(layer.frame, layerRect))
    {
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        
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
        
        [CATransaction commit];
    }

}

@end


@interface YSLayoutBase()

@end



@implementation YSLayoutBase
{
    __weak id _target;
    SEL   _action;
    
    __weak id _touchDownTarget;
    SEL  _touchDownAction;
    
    __weak id _touchCancelTarget;
    SEL _touchCancelAction;
    BOOL _hasDoCancel;

    
    UIColor *_oldBackgroundColor;
    UIImage *_oldBackgroundImage;
    BOOL _forbidTouch;
    BOOL _canCallAction;
    CGPoint _beginPoint;
    YSBorderLineLayerDelegate *_layerDelegate;

}

BOOL _hasBegin;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self layoutConstruct];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self layoutConstruct];
    }
    return self;
}

-(void)dealloc
{
}

#pragma  mark -- Public Method

#ifdef YS_USEOLDENUMDEF

-(UIEdgeInsets)padding
{
    return self.ysPadding;
}

-(void)setPadding:(UIEdgeInsets)padding
{
    self.ysPadding = padding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    self.ysLeftPadding = leftPadding;
}

-(CGFloat)leftPadding
{
    return self.ysLeftPadding;
}

-(void)setTopPadding:(CGFloat)topPadding
{
    self.ysTopPadding = topPadding;
}

-(CGFloat)topPadding
{
    return self.ysTopPadding;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    self.ysRightPadding = rightPadding;
}

-(CGFloat)rightPadding
{
    return self.ysRightPadding;
}

-(void)setBottomPadding:(CGFloat)bottomPadding
{
    self.ysBottomPadding = bottomPadding;
}

-(CGFloat)bottomPadding
{
    return self.ysBottomPadding;
}

#endif

-(void)setYsPadding:(UIEdgeInsets)padding
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_ysPadding, padding))
    {
        _ysPadding = padding;
        [self setNeedsLayout];
    }
}

-(void)setYsLeftPadding:(CGFloat)leftPadding
{
    [self setYsPadding:UIEdgeInsetsMake(_ysPadding.top, leftPadding, _ysPadding.bottom,_ysPadding.right)];
}

-(CGFloat)ysLeftPadding
{
    return _ysPadding.left;
}

-(void)setYsTopPadding:(CGFloat)topPadding
{
    [self setYsPadding:UIEdgeInsetsMake(topPadding, _ysPadding.left, _ysPadding.bottom,_ysPadding.right)];
}

-(CGFloat)ysTopPadding
{
    return _ysPadding.top;
}

-(void)setYsRightPadding:(CGFloat)rightPadding
{
    [self setYsPadding:UIEdgeInsetsMake(_ysPadding.top, _ysPadding.left, _ysPadding.bottom,rightPadding)];
}

-(CGFloat)ysRightPadding
{
    return _ysPadding.right;
}

-(void)setYsBottomPadding:(CGFloat)bottomPadding
{
    [self setYsPadding:UIEdgeInsetsMake(_ysPadding.top, _ysPadding.left, bottomPadding,_ysPadding.right)];
}

-(CGFloat)ysBottomPadding
{
    return _ysPadding.bottom;
}



-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    if (_wrapContentHeight != wrapContentHeight)
    {
        _wrapContentHeight = wrapContentHeight;
        [self setNeedsLayout];
    }
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    if (_wrapContentWidth != wrapContentWidth)
    {
        _wrapContentWidth = wrapContentWidth;
        [self setNeedsLayout];
    }
}


-(void)setHideSubviewReLayout:(BOOL)hideSubviewReLayout
{
    if (_hideSubviewReLayout != hideSubviewReLayout)
    {
        _hideSubviewReLayout = hideSubviewReLayout;
        [self setNeedsLayout];
    }
    
}


-(void)updateBorderLayer:(CAShapeLayer**)ppLayer withBorderLineDraw:(YSBorderLineDraw*)borderLineDraw
{
    if (borderLineDraw == nil)
    {
        if (*ppLayer != nil)
        {
            (*ppLayer).delegate = nil;
            [(*ppLayer) removeFromSuperlayer];
            *ppLayer = nil;
        }
    }
    else
    {
        if (_layerDelegate == nil)
            _layerDelegate = [[YSBorderLineLayerDelegate alloc] initWithLayout:self];
        
        if ( *ppLayer == nil)
        {
            *ppLayer = [[CAShapeLayer alloc] init];
            (*ppLayer).delegate = _layerDelegate;
            [self.layer addSublayer:*ppLayer];
        }
        
        //如果是点线则是用path，否则就用背景色
        if (borderLineDraw.dash != 0)
        {
            (*ppLayer).lineDashPhase = borderLineDraw.dash / 2;
            NSNumber *num = @(borderLineDraw.dash);
            (*ppLayer).lineDashPattern = @[num,num];
            
            (*ppLayer).strokeColor = borderLineDraw.color.CGColor;
            (*ppLayer).lineWidth = borderLineDraw.thick;
            (*ppLayer).backgroundColor = nil;

        }
        else
        {
            (*ppLayer).lineDashPhase = 0;
            (*ppLayer).lineDashPattern = nil;
            
            (*ppLayer).strokeColor = nil;
            (*ppLayer).lineWidth = 0;
            (*ppLayer).backgroundColor = borderLineDraw.color.CGColor;

        }
        
        [(*ppLayer) setNeedsLayout];
        
    }
}


-(void)setBottomBorderLine:(YSBorderLineDraw *)bottomBorderLine
{
    if (_bottomBorderLine != bottomBorderLine)
    {
        _bottomBorderLine = bottomBorderLine;
    
        CAShapeLayer *borderLayer = _bottomBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_bottomBorderLine];
        _bottomBorderLineLayer = borderLayer;
    }
}

-(void)setTopBorderLine:(YSBorderLineDraw *)topBorderLine
{
    if (_topBorderLine != topBorderLine)
    {
        _topBorderLine = topBorderLine;
        
        CAShapeLayer *borderLayer = _topBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_topBorderLine];
        _topBorderLineLayer = borderLayer;
        
    }
}

-(void)setLeftBorderLine:(YSBorderLineDraw *)leftBorderLine
{
    if (_leftBorderLine != leftBorderLine)
    {
        _leftBorderLine = leftBorderLine;
        
        CAShapeLayer *borderLayer = _leftBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_leftBorderLine];
        _leftBorderLineLayer = borderLayer;
    }
}

-(void)setRightBorderLine:(YSBorderLineDraw *)rightBorderLine
{
    if (_rightBorderLine != rightBorderLine)
    {
        _rightBorderLine = rightBorderLine;
        
        CAShapeLayer *borderLayer = _rightBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_rightBorderLine];
        _rightBorderLineLayer = borderLayer;
    }
    
}


-(void)setBoundBorderLine:(YSBorderLineDraw *)boundBorderLine
{
    self.leftBorderLine = boundBorderLine;
    self.rightBorderLine = boundBorderLine;
    self.topBorderLine = boundBorderLine;
    self.bottomBorderLine = boundBorderLine;
}

-(YSBorderLineDraw*)boundBorderLine
{
    return self.leftBorderLine;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage)
    {
        _backgroundImage = backgroundImage;
        self.layer.contents = (id)_backgroundImage.CGImage;
    }
}


//只获取计算得到尺寸，不进行真正的布局。
-(CGRect)estimateLayoutRect:(CGSize)size
{
    BOOL hasSubLayout = NO;
    self.absPos.frame = [self calcLayoutRect:size isEstimate:NO pHasSubLayout:&hasSubLayout];
    if (!hasSubLayout)
        return self.absPos.frame;
    else
        return [self calcLayoutRect:CGSizeZero isEstimate:YES pHasSubLayout:&hasSubLayout];
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





#pragma mark -- touches event



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (_target != nil && !_forbidTouch && touch.tapCount == 1 && !_hasBegin)
    {
        _hasBegin = YES;
        _canCallAction = YES;
        _beginPoint = [((UITouch*)[touches anyObject]) locationInView:self];
        if (_highlightedBackgroundColor != nil)
        {
            _oldBackgroundColor = self.backgroundColor;
            self.backgroundColor = _highlightedBackgroundColor;
        }
        
        if (_highlightedBackgroundImage != nil)
        {
            _oldBackgroundImage = self.backgroundImage;
            self.backgroundImage = _highlightedBackgroundImage;
        }
        
        _hasDoCancel = NO;
        if (_touchDownTarget != nil && _touchDownAction != nil)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_touchDownTarget performSelector:_touchDownAction withObject:self];
#pragma clang diagnostic pop

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
            {
                _canCallAction = NO;
                
                if (!_hasDoCancel)
                {
                    
                    if (_touchCancelTarget != nil && _touchCancelAction != nil)
                    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [_touchCancelTarget performSelector:_touchCancelAction withObject:self];
#pragma clang diagnostic pop

                    }
                    
                    _hasDoCancel = YES;

                }
                
            }
        }
    }
    
    [super touchesMoved:touches withEvent:event];
}

-(void)doTargetAction:(UITouch*)touch
{
    if (_highlightedBackgroundColor != nil)
    {
        self.backgroundColor = _oldBackgroundColor;
        _oldBackgroundColor = nil;
    }
    
    
    if (_highlightedBackgroundImage != nil)
    {
        self.backgroundImage = _oldBackgroundImage;
        _oldBackgroundImage = nil;
    }
    
    
    //距离太远则不会处理
    CGPoint pt = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, pt) && _action != nil && _canCallAction)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop

    }
    else
    {
        if (!_hasDoCancel)
        {
            if (_touchCancelTarget != nil && _touchCancelAction != nil)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_touchCancelTarget performSelector:_touchCancelAction withObject:self];
#pragma clang diagnostic pop

            }
            
            _hasDoCancel = YES;
        }

    }
    
    _forbidTouch = NO;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_target != nil && _hasBegin)
    {
        //设置一个延时.
        _forbidTouch = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:@selector(doTargetAction:) withObject:[touches anyObject] afterDelay:0.12];
#pragma clang diagnostic pop

        _hasBegin = NO;
    }
    
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_target != nil && _hasBegin)
    {
        if (_highlightedBackgroundColor != nil)
        {
            self.backgroundColor = _oldBackgroundColor;
            _oldBackgroundColor = nil;
        }
        
        if (_highlightedBackgroundImage != nil)
        {
            self.backgroundImage = _oldBackgroundImage;
            _oldBackgroundImage = nil;
        }
        
        
        _hasBegin = NO;
        
        if (!_hasDoCancel)
        {
            if (_touchCancelTarget != nil && _touchCancelAction != nil)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_touchCancelTarget performSelector:_touchCancelAction withObject:self];
#pragma clang diagnostic pop

            }
            
            _hasDoCancel = YES;

        }
        
    }
    
    
    [super touchesCancelled:touches withEvent:event];
}



#pragma mark -- KVO


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    
    //监控非布局父视图的frame的变化，而改变自身的位置和尺寸
    if (object == self.superview && [keyPath isEqualToString:@"frame"])
    {
        
        if (![object isKindOfClass:[YSLayoutBase class]])
        {
            
            //如果同时设置了左边和右边值则
            if ((self.leftPos.posNumVal != nil && self.rightPos.posNumVal != nil) ||
                [self.widthDime isMatchView:object] ||
                (self.topPos.posNumVal != nil && self.bottomPos.posNumVal != nil) ||
                [self.heightDime isMatchView:object])
            {
                CGRect rectSuper = object.bounds;
                CGRect rectSelf = self.frame;
                
                if ((self.leftPos.posNumVal != nil && self.rightPos.posNumVal != nil) || [self.widthDime isMatchView:object])
                {
                    //如果是外部视图不支持相对间距。
                    [self calcMatchParentWidth:self.widthDime selfWidth:rectSuper.size.width leftMargin:self.leftPos.margin centerMargin:0  rightMargin:self.rightPos.margin leftPadding:0 rightPadding:0 rect:&rectSelf];
                }
                
                
                if ((self.topPos.posNumVal != nil && self.bottomPos.posNumVal != nil) || [self.heightDime isMatchView:object])
                {
                    [self calcMatchParentHeight:self.heightDime selfHeight:rectSuper.size.height topMargin:self.topPos.margin centerMargin:0 bottomMargin:self.bottomPos.margin topPadding:0 bottomPadding:0 rect:&rectSelf];
                }
                
                rectSelf.size.height = [self.heightDime validMeasure:rectSelf.size.height];
                rectSelf.size.width = [self.widthDime validMeasure:rectSelf.size.width];
                self.frame = rectSelf;
                
            }
        }

        
        
     //
    }
    
    
    //监控子视图的frame的变化以便重新进行布局
    if (!_isLayouting && [self.subviews containsObject:object])
    {
        if (![object useFrame])
        {
            [self setNeedsLayout];
            
            //这里添加的原因是有可能子视图取消隐藏后不会绘制自身，所以这里要求子视图重新绘制自身
            if ([keyPath isEqualToString:@"hidden"] && ![change[NSKeyValueChangeNewKey] boolValue])
            {
                [(UIView*)object setNeedsDisplay];
            }
        }
    }
    
}


#pragma mark -- Override Method

-(CGSize)sizeThatFits:(CGSize)size
{
    return [self estimateLayoutRect:size].size;
}

-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden == NO)
    {
        if (_topBorderLineLayer != nil)
            [_topBorderLineLayer setNeedsLayout];
        
        if (_bottomBorderLineLayer != nil)
            [_bottomBorderLineLayer setNeedsLayout];
        
        
        if (_leftBorderLineLayer != nil)
            [_leftBorderLineLayer setNeedsLayout];
        
        if (_rightBorderLineLayer != nil)
            [_rightBorderLineLayer setNeedsLayout];
    }
}



- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];   //只要加入进来后就修改其默认的实现，而改用我们的实现，这里包括隐藏,调整大小，
    
    //添加hidden, frame,center的属性通知。
    [subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];  //删除后恢复其原来的实现。
    
    [subview removeObserver:self forKeyPath:@"hidden"];
    [subview removeObserver:self forKeyPath:@"frame"];
}


- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    

    
    //将要添加到父视图时，如果不是MyLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
    if (newSuperview != nil && ![newSuperview isKindOfClass:[YSLayoutBase class]])
    {

        //如果同时设置了左边和右边值则
        if ((self.leftPos.posNumVal != nil && self.rightPos.posNumVal != nil) ||
            [self.widthDime isMatchView:newSuperview] ||
            (self.topPos.posNumVal != nil && self.bottomPos.posNumVal != nil) ||
            [self.heightDime isMatchView:newSuperview])
        {
            CGRect rectSuper = newSuperview.bounds;
            CGRect rectSelf = self.frame;
            
            if ((self.leftPos.posNumVal != nil && self.rightPos.posNumVal != nil) || [self.widthDime isMatchView:newSuperview])
            {
                self.wrapContentWidth = NO;
                [self calcMatchParentWidth:self.widthDime selfWidth:rectSuper.size.width leftMargin:self.leftPos.margin centerMargin:0  rightMargin:self.rightPos.margin leftPadding:0 rightPadding:0 rect:&rectSelf];
            }
            
            
            if ((self.topPos.posNumVal != nil && self.bottomPos.posNumVal != nil) || [self.heightDime isMatchView:newSuperview])
            {
                self.wrapContentHeight = NO;
                [self calcMatchParentHeight:self.heightDime selfHeight:rectSuper.size.height topMargin:self.topPos.margin centerMargin:0 bottomMargin:self.bottomPos.margin topPadding:0 bottomPadding:0 rect:&rectSelf];
            }

            rectSelf.size.height = [self.heightDime validMeasure:rectSelf.size.height];
            rectSelf.size.width = [self.widthDime validMeasure:rectSelf.size.width];
            
            self.frame = rectSelf;
            
            //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃
            if (self.superview != nil && ![self.superview isKindOfClass:[YSLayoutBase class]])
            {
                @try {
                    [self.superview removeObserver:self forKeyPath:@"frame"];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }

            [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

        }
        else
        {
            CGRect rectSelf = self.frame;
            if (self.widthDime.dimeNumVal != nil)
                rectSelf.size.width = self.widthDime.measure;
            
            if (self.heightDime.dimeNumVal != nil)
                rectSelf.size.height = self.heightDime.measure;
            
            if (!CGRectEqualToRect(rectSelf, self.frame))
            {
                self.frame = rectSelf;
            }
            
            
        }
    }
    
    if (newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[YSLayoutBase class]])
    {
        @try {
            [self.superview removeObserver:self forKeyPath:@"frame"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    
    
}



-(void)layoutSubviews
{
    
    if (self.beginLayoutBlock != nil)
        self.beginLayoutBlock();
    
    if (!self.isLayouting)
    {
        _isLayouting = YES;
    
        if (self.priorAutoresizingMask)
            [super layoutSubviews];
        
        CGRect oldSelfRect = self.frame;
        CGRect newSelfRect = [self calcLayoutRect:CGSizeZero isEstimate:NO pHasSubLayout:nil];
        
        for (UIView *sbv in self.subviews)
        {
            if (sbv.absPos.leftPos != CGFLOAT_MAX && sbv.absPos.topPos != CGFLOAT_MAX)
                sbv.frame = sbv.absPos.frame;
            
            [sbv.absPos reset];
        }
        
        if (!CGRectEqualToRect(oldSelfRect,newSelfRect) && newSelfRect.origin.x != CGFLOAT_MAX)
        {
            self.frame = newSelfRect;
        }
        
        if (_topBorderLineLayer != nil)
            [_topBorderLineLayer setNeedsLayout];
        
        if (_bottomBorderLineLayer != nil)
            [_bottomBorderLineLayer setNeedsLayout];
        
        
        if (_leftBorderLineLayer != nil)
            [_leftBorderLineLayer setNeedsLayout];
        
        if (_rightBorderLineLayer != nil)
            [_rightBorderLineLayer setNeedsLayout];

        
        if (newSelfRect.origin.x != CGFLOAT_MAX)
            [self alterScrollViewContentSize:newSelfRect];
       
        
        
        _isLayouting = NO;
    }
    
    if (self.endLayoutBlock != nil)
    {
        self.endLayoutBlock();
        self.beginLayoutBlock = nil;
        self.endLayoutBlock = nil;
    }
}


#pragma mark -- Private Method


-(void)layoutConstruct
{
    _hideSubviewReLayout = YES;
}

-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout
{
    
    CGRect selfRect;
    if (isEstimate)
        selfRect = self.absPos.frame;
    else
    {
        selfRect = self.frame;
        if (size.width != 0)
            selfRect.size.width = size.width;
        if (size.height != 0)
            selfRect.size.height = size.height;
    }
    
    if (pHasSubLayout != nil)
        *pHasSubLayout = NO;
    
    return selfRect;
    
}


-(BOOL)isRelativeMargin:(CGFloat)margin
{
    return margin > 0 && margin < 1;
}



-(void)vertGravity:(YSMarignGravity)vert
        selfHeight:(CGFloat)selfHeight
               sbv:(UIView *)sbv
              rect:(CGRect*)pRect
{
    CGFloat  tm = sbv.topPos.posNumVal.doubleValue;
    CGFloat  cm = sbv.centerYPos.posNumVal.doubleValue;
    CGFloat  bm = sbv.bottomPos.posNumVal.doubleValue;
    
    
    CGFloat topMargin;
    CGFloat centerMargin;
    CGFloat bottomMargin;
    
    
    CGFloat fixedHeight = self.ysPadding.top + self.ysPadding.bottom;
    
    if ([self isRelativeMargin:tm])
        topMargin = (selfHeight - fixedHeight) * tm;
    else
        topMargin = tm;
    
    if ([self isRelativeMargin:cm])
        centerMargin = (selfHeight - fixedHeight) * cm;
    else
        centerMargin = cm;

    
    if ([self isRelativeMargin:bm])
        bottomMargin = (selfHeight - fixedHeight) * bm;
    else
        bottomMargin = bm;
    
    
    topMargin = [sbv.topPos validMargin:topMargin + sbv.topPos.offsetVal];
    centerMargin = [sbv.centerYPos validMargin:centerMargin + sbv.centerYPos.offsetVal];
    bottomMargin = [sbv.bottomPos validMargin:bottomMargin + sbv.bottomPos.offsetVal];

    
    if (vert == YSMarignGravity_Vert_Fill)
    {
        
        pRect->origin.y = self.ysPadding.top + topMargin;
        pRect->size.height = [sbv.heightDime validMeasure:selfHeight - self.ysPadding.bottom - bottomMargin - pRect->origin.y];
    }
    else if (vert == YSMarignGravity_Vert_Center)
    {
        
        pRect->origin.y = (selfHeight - self.ysPadding.top - self.ysPadding.bottom - topMargin - bottomMargin - pRect->size.height)/2 + self.ysPadding.top + topMargin + centerMargin;
    }
    else if (vert == YSMarignGravity_Vert_Window_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.y = (self.window.frame.size.height - topMargin - bottomMargin - pRect->size.height)/2 + topMargin + centerMargin;
            
            CGPoint pt = pRect->origin;
            pRect->origin.y =  [self.window convertPoint:pt toView:self].y;
        }

    }
    else if (vert == YSMarignGravity_Vert_Bottom)
    {
        
        pRect->origin.y = selfHeight - self.ysPadding.bottom - bottomMargin - pRect->size.height;
    }
    else if (vert == YSMarignGravity_Vert_Top)
    {
        pRect->origin.y = self.ysPadding.top + topMargin;
    }
    else
    {
        pRect->origin.y = self.ysPadding.top + topMargin;
    }
    
    
}

-(void)horzGravity:(YSMarignGravity)horz
         selfWidth:(CGFloat)selfWidth
               sbv:(UIView *)sbv
              rect:(CGRect*)pRect
{
    CGFloat  lm = sbv.leftPos.posNumVal.doubleValue;
    CGFloat  cm = sbv.centerXPos.posNumVal.doubleValue;
    CGFloat  rm = sbv.rightPos.posNumVal.doubleValue;

    
    CGFloat leftMargin;
    CGFloat centerMargin;
    CGFloat rightMargin;
    
    
    CGFloat fixedWidth = self.ysPadding.left + self.ysPadding.right;
    if ([self isRelativeMargin:lm])
        leftMargin = (selfWidth - fixedWidth) * lm;
    else
        leftMargin = lm;
    
    if ([self isRelativeMargin:cm])
        centerMargin = (selfWidth - fixedWidth) * cm;
    else
        centerMargin = cm;

    
    if ([self isRelativeMargin:rm])
        rightMargin = (selfWidth - fixedWidth) * rm;
    else
        rightMargin = rm;
    
    leftMargin = [sbv.leftPos validMargin:leftMargin + sbv.leftPos.offsetVal];
    centerMargin = [sbv.centerXPos validMargin:centerMargin + sbv.centerXPos.offsetVal];
    rightMargin = [sbv.rightPos validMargin:rightMargin + sbv.rightPos.offsetVal];

    
    
    if (horz == YSMarignGravity_Horz_Fill)
    {
        
        pRect->origin.x = self.ysPadding.left + leftMargin;
        pRect->size.width = [sbv.widthDime validMeasure:selfWidth - self.ysPadding.right - rightMargin - pRect->origin.x];
    }
    else if (horz == YSMarignGravity_Horz_Center)
    {
        pRect->origin.x = (selfWidth - self.ysPadding.left - self.ysPadding.right - leftMargin - rightMargin - pRect->size.width)/2 + self.ysPadding.left + leftMargin + centerMargin;
    }
    else if (horz == YSMarignGravity_Horz_Window_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.x = (self.window.frame.size.width - leftMargin - rightMargin - pRect->size.width)/2 + leftMargin + centerMargin;
            
            CGPoint pt = pRect->origin;
            pRect->origin.x =  [self.window convertPoint:pt toView:self].x;
        }


    }
    else if (horz == YSMarignGravity_Horz_Right)
    {
        
        pRect->origin.x = selfWidth - self.ysPadding.right - rightMargin - pRect->size.width;
    }
    else if (horz == YSMarignGravity_Horz_Left)
    {
        pRect->origin.x = self.ysPadding.left + leftMargin;
    }
    else
    {
        pRect->origin.x = self.ysPadding.left + leftMargin;
    }
}



-(void)calcMatchParentWidth:(YSLayoutDime*)match selfWidth:(CGFloat)selfWidth leftMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin rightMargin:(CGFloat)rightMargin leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding rect:(CGRect*)pRect
{
    
    CGFloat vTotalWidth = 0;
    
    vTotalWidth = (selfWidth - leftPadding - rightPadding)*match.mutilVal + match.addVal;
    
    
    pRect->size.width = [match validMeasure:vTotalWidth - leftMargin - centerMargin - rightMargin];
    pRect->origin.x = (selfWidth - pRect->size.width - leftPadding - rightPadding - leftMargin - rightMargin )/2 + leftPadding + leftMargin + centerMargin;
    
}

-(void)calcMatchParentHeight:(YSLayoutDime*)match selfHeight:(CGFloat)selfHeight topMargin:(CGFloat)topMargin centerMargin:(CGFloat)centerMargin  bottomMargin:(CGFloat)bottomMargin topPadding:(CGFloat)topPadding bottomPadding:(CGFloat)bottomPadding rect:(CGRect*)pRect
{
    
    
    CGFloat vTotalHeight = (selfHeight - topPadding - bottomPadding)*match.mutilVal + match.addVal;
    
    pRect->size.height = [match validMeasure:vTotalHeight - topMargin - centerMargin - bottomMargin];
    pRect->origin.y = (selfHeight - pRect->size.height - topPadding - bottomPadding - topMargin - bottomMargin )/2 + topPadding + topMargin + centerMargin;
    
    
}


-(void)setWrapContentWidthNoLayout:(BOOL)wrapContentWidth
{
    _wrapContentWidth = wrapContentWidth;
}

-(void)setWrapContentHeightNoLayout:(BOOL)wrapContentHeight
{
    _wrapContentHeight = wrapContentHeight;
}


- (void)alterScrollViewContentSize:(CGRect)newRect
{
    if (self.adjustScrollViewContentSize && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrolv = (UIScrollView*)self.superview;
        CGSize contsize = scrolv.contentSize;
        
        if (contsize.height != newRect.size.height)
            contsize.height = newRect.size.height;
        if (contsize.width != newRect.size.width)
            contsize.width = newRect.size.width;
        
        scrolv.contentSize = contsize;
        
    }
}

@end

//
//  MyLayoutBase.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutBase.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>


const char * const ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASS = "associatedobject_key_mylayout_sizeclass";


@implementation MyLayoutSizeClass


-(MyLayoutPos*)leftPos
{
    if (_leftPos == nil)
    {
        _leftPos = [MyLayoutPos new];
        _leftPos.pos = MGRAVITY_HORZ_LEFT;
        
    }
    
    return _leftPos;
    
}

-(MyLayoutPos*)topPos
{
    if (_topPos == nil)
    {
        _topPos = [MyLayoutPos new];
        _topPos.pos = MGRAVITY_VERT_TOP;
        
    }
    
    return _topPos;
}

-(MyLayoutPos*)rightPos
{
    if (_rightPos == nil)
    {
        _rightPos = [MyLayoutPos new];
        _rightPos.pos = MGRAVITY_HORZ_RIGHT;
        
    }
    
    return _rightPos;
}

-(MyLayoutPos*)bottomPos
{
    if (_bottomPos == nil)
    {
        _bottomPos = [MyLayoutPos new];
        _bottomPos.pos = MGRAVITY_VERT_BOTTOM;
        
    }
    
    return _bottomPos;
}


-(MyLayoutPos*)centerXPos
{
    if (_centerXPos == nil)
    {
        _centerXPos = [MyLayoutPos new];
        _centerXPos.pos = MGRAVITY_HORZ_CENTER;
        
    }
    
    return _centerXPos;
}

-(MyLayoutPos*)centerYPos
{
    if (_centerYPos == nil)
    {
        _centerYPos = [MyLayoutPos new];
        _centerYPos.pos = MGRAVITY_VERT_CENTER;
        
    }
    
    return _centerYPos;
}


-(MyLayoutDime*)widthDime
{
    if (_widthDime == nil)
    {
        _widthDime = [MyLayoutDime new];
        _widthDime.dime = MGRAVITY_HORZ_FILL;
        
    }
    
    return _widthDime;
}


-(MyLayoutDime*)heightDime
{
    if (_heightDime == nil)
    {
        _heightDime = [MyLayoutDime new];
        _heightDime.dime = MGRAVITY_VERT_FILL;
        
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



-(MyLayoutMeasure*)absPos
{
    if (_absPos == nil)
    {
        _absPos = [MyLayoutMeasure new];
    }
    
    return _absPos;
}


@end



@implementation UIView(MyLayoutExt)




-(MyLayoutPos*)leftPos
{
    MyLayoutPos *pos = self.myLayoutSizeClass.leftPos;
    pos.view = self;
    return pos;
}


-(MyLayoutPos*)topPos
{
    MyLayoutPos *pos = self.myLayoutSizeClass.topPos;
    pos.view = self;
    return pos;
}


-(MyLayoutPos*)rightPos
{

    MyLayoutPos *pos = self.myLayoutSizeClass.rightPos;
    pos.view = self;
    return pos;
    
}


-(MyLayoutPos*)bottomPos
{
    
    MyLayoutPos *pos = self.myLayoutSizeClass.bottomPos;
    pos.view = self;
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

    MyLayoutDime *dime = self.myLayoutSizeClass.widthDime;
    dime.view = self;
    return dime;
    
}



-(MyLayoutDime*)heightDime
{

    MyLayoutDime *dime = self.myLayoutSizeClass.heightDime;
    dime.view = self;
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


-(MyLayoutPos*)centerXPos
{
    MyLayoutPos *pos = self.myLayoutSizeClass.centerXPos;
    pos.view = self;
    return pos;
    
}


-(MyLayoutPos*)centerYPos
{
    
    MyLayoutPos *pos = self.myLayoutSizeClass.centerYPos;
    pos.view = self;
    return pos;
}


-(CGFloat)centerXOffset
{
    return self.centerXPos.margin;
}

-(void)setCenterXOffset:(CGFloat)centerXOffset
{
    self.centerXPos.equalTo(@(centerXOffset));
}

-(CGFloat)centerYOffset
{
    return self.centerYPos.margin;
}

-(void)setCenterYOffset:(CGFloat)centerYOffset
{
    self.centerYPos.equalTo(@(centerYOffset));
}


-(CGPoint)centerOffset
{
    return CGPointMake(self.centerXOffset, self.centerYOffset);
}

-(void)setCenterOffset:(CGPoint)centerOffset
{
    self.centerXOffset = centerOffset.x;
    self.centerYOffset = centerOffset.y;
}




-(void)setFlexedHeight:(BOOL)flexedHeight
{
    self.myLayoutSizeClass.flexedHeight = flexedHeight;
    if (self.superview != nil)
        [self.superview setNeedsLayout];
}

-(BOOL)isFlexedHeight
{
    return self.myLayoutSizeClass.flexedHeight;
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
    objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASS, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)useFrame
{
    return self.myLayoutSizeClass.useFrame;
}

-(void)setUseFrame:(BOOL)useFrame
{
    
    self.myLayoutSizeClass.useFrame = useFrame;
    if (self.superview != nil)
        [ self.superview setNeedsLayout];
    
}




@end


@implementation UIView(MyLayoutExtInner)



-(MyLayoutSizeClass*)myLayoutSizeClass
{
    MyLayoutSizeClass *myLayoutSizeClass = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASS);
    if (myLayoutSizeClass == nil)
    {
        myLayoutSizeClass = [MyLayoutSizeClass new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASS, myLayoutSizeClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return myLayoutSizeClass;
}


-(MyLayoutMeasure*)absPos
{    
    return self.myLayoutSizeClass.absPos;
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


/**绘制线条层委托实现类**/
@interface MyBorderLineLayerDelegate : NSObject

@property(nonatomic ,weak) MyLayoutBase *layout;

-(id)initWithLayout:(MyLayoutBase*)layout;


@end

@implementation MyBorderLineLayerDelegate


-(id)initWithLayout:(MyLayoutBase*)layout
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


@interface MyLayoutBase()

@end

void(*g_mylayoutdefaultsetFrame)(UIView*,SEL,CGRect) = NULL;
void(*g_mylayoutdefaultsetHidden)(UIView*,SEL,BOOL) = NULL;


void mylayoutsetFrame(UIView *self, SEL _cmd, CGRect frame)
{
    CGRect oldFrame = self.frame;
    
    g_mylayoutdefaultsetFrame(self, _cmd, frame);
    
    if (!CGRectEqualToRect(oldFrame, frame))
    {
        if (self.superview != nil && [self.superview isKindOfClass:[MyLayoutBase class]])
        {
            MyLayoutBase *layout = (MyLayoutBase*)self.superview;
            
            if (!layout.isLayouting)
            {
                if (![self useFrame])
                {
                    [layout setNeedsLayout];
                }
            }
            
        }
    }
}

void mylayoutsetHidden(UIView *self, SEL _cmd, BOOL hidden)
{
    BOOL oldHidden = self.isHidden;
    
    g_mylayoutdefaultsetHidden(self, _cmd, hidden);
    
    if (oldHidden != hidden)
    {
        if (self.superview != nil && [self.superview isKindOfClass:[MyLayoutBase class]])
        {
            MyLayoutBase *layout = (MyLayoutBase*)self.superview;
            
            if (!layout.isLayouting)
            {
                if (![self useFrame])
                {
                    [layout setNeedsLayout];
                    if (!hidden)
                    {
                        [self setNeedsDisplay];
                    }
                }
            }
            
        }
    }
}



@implementation MyLayoutBase
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
    MyBorderLineLayerDelegate *_layerDelegate;

}

BOOL _hasBegin;


//+(void)initialize
//{
//    if (self == [MyLayoutBase self])
//    {
//        
//        g_mylayoutdefaultsetFrame = (void(*)(UIView*,SEL,CGRect))class_replaceMethod([UIView class], @selector(setFrame:), (IMP)&mylayoutsetFrame, "@:{CGRect={CGPoint={ff}}{CGSize={ff}}}");
//        
//        g_mylayoutdefaultsetHidden = (void(*)(UIView*,SEL,BOOL))class_replaceMethod([UIView class], @selector(setHidden:), (IMP)&mylayoutsetHidden, "@:B");
//        
//        
//
//    }
//}
//

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


-(void)updateBorderLayer:(CAShapeLayer**)ppLayer withBorderLineDraw:(MyBorderLineDraw*)borderLineDraw
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
            _layerDelegate = [[MyBorderLineLayerDelegate alloc] initWithLayout:self];
        
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


-(void)setBottomBorderLine:(MyBorderLineDraw *)bottomBorderLine
{
    if (_bottomBorderLine != bottomBorderLine)
    {
        _bottomBorderLine = bottomBorderLine;
    
        CAShapeLayer *borderLayer = _bottomBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_bottomBorderLine];
        _bottomBorderLineLayer = borderLayer;
    }
}

-(void)setTopBorderLine:(MyBorderLineDraw *)topBorderLine
{
    if (_topBorderLine != topBorderLine)
    {
        _topBorderLine = topBorderLine;
        
        CAShapeLayer *borderLayer = _topBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_topBorderLine];
        _topBorderLineLayer = borderLayer;
        
    }
}

-(void)setLeftBorderLine:(MyBorderLineDraw *)leftBorderLine
{
    if (_leftBorderLine != leftBorderLine)
    {
        _leftBorderLine = leftBorderLine;
        
        CAShapeLayer *borderLayer = _leftBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_leftBorderLine];
        _leftBorderLineLayer = borderLayer;
    }
}

-(void)setRightBorderLine:(MyBorderLineDraw *)rightBorderLine
{
    if (_rightBorderLine != rightBorderLine)
    {
        _rightBorderLine = rightBorderLine;
        
        CAShapeLayer *borderLayer = _rightBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_rightBorderLine];
        _rightBorderLineLayer = borderLayer;
    }
    
}


-(void)setBoundBorderLine:(MyBorderLineDraw *)boundBorderLine
{
    self.leftBorderLine = boundBorderLine;
    self.rightBorderLine = boundBorderLine;
    self.topBorderLine = boundBorderLine;
    self.bottomBorderLine = boundBorderLine;
}

-(MyBorderLineDraw*)boundBorderLine
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
    if (object == self.superview && [keyPath isEqualToString:@"frame"])
    {
        //
        
        if (![object isKindOfClass:[MyLayoutBase class]])
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
    
    
    if (!_isLayouting && [self.subviews containsObject:object])
    {
        if (![object useFrame])
        {
            [self setNeedsLayout];
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
    

    
    //将要添加到父视图时，如果不是MyLayout派生则则跟父视图保持一致并
    if (newSuperview != nil && ![newSuperview isKindOfClass:[MyLayoutBase class]])
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
    
    if (newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[MyLayoutBase class]])
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



-(void)vertGravity:(MarignGravity)vert
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
    
    
    CGFloat fixedHeight = self.padding.top + self.padding.bottom;
    
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

    
    if (vert == MGRAVITY_VERT_FILL)
    {
        
        pRect->origin.y = self.padding.top + topMargin;
        pRect->size.height = [sbv.heightDime validMeasure:selfHeight - self.padding.bottom - bottomMargin - pRect->origin.y];
    }
    else if (vert == MGRAVITY_VERT_CENTER)
    {
        
        pRect->origin.y = (selfHeight - self.padding.top - self.padding.bottom - topMargin - bottomMargin - pRect->size.height)/2 + self.padding.top + topMargin + centerMargin;
    }
    else if (vert == MGRAVITY_VERT_WINDOW_CENTER)
    {
        if (self.window != nil)
        {
            pRect->origin.y = (self.window.frame.size.height - topMargin - bottomMargin - pRect->size.height)/2 + topMargin + centerMargin;
            
            CGPoint pt = pRect->origin;
            pRect->origin.y =  [self.window convertPoint:pt toView:self].y;
        }

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
               sbv:(UIView *)sbv
              rect:(CGRect*)pRect
{
    CGFloat  lm = sbv.leftPos.posNumVal.doubleValue;
    CGFloat  cm = sbv.centerXPos.posNumVal.doubleValue;
    CGFloat  rm = sbv.rightPos.posNumVal.doubleValue;

    
    CGFloat leftMargin;
    CGFloat centerMargin;
    CGFloat rightMargin;
    
    
    CGFloat fixedWidth = self.padding.left + self.padding.right;
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

    
    
    if (horz == MGRAVITY_HORZ_FILL)
    {
        
        pRect->origin.x = self.padding.left + leftMargin;
        pRect->size.width = [sbv.widthDime validMeasure:selfWidth - self.padding.right - rightMargin - pRect->origin.x];
    }
    else if (horz == MGRAVITY_HORZ_CENTER)
    {
        pRect->origin.x = (selfWidth - self.padding.left - self.padding.right - leftMargin - rightMargin - pRect->size.width)/2 + self.padding.left + leftMargin + centerMargin;
    }
    else if (horz == MGRAVITY_HORZ_WINDOW_CENTER)
    {
        if (self.window != nil)
        {
            pRect->origin.x = (self.window.frame.size.width - leftMargin - rightMargin - pRect->size.width)/2 + leftMargin + centerMargin;
            
            CGPoint pt = pRect->origin;
            pRect->origin.x =  [self.window convertPoint:pt toView:self].x;
        }


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



-(void)calcMatchParentWidth:(MyLayoutDime*)match selfWidth:(CGFloat)selfWidth leftMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin rightMargin:(CGFloat)rightMargin leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding rect:(CGRect*)pRect
{
    
    CGFloat vTotalWidth = 0;
    
    vTotalWidth = (selfWidth - leftPadding - rightPadding)*match.mutilVal + match.addVal;
    
   /* if ([self isRelativeMargin:leftMargin])
        leftMargin = vTotalWidth * leftMargin;
    
    if ([self isRelativeMargin:centerMargin])
        centerMargin = vTotalWidth * centerMargin;
    
    if ([self isRelativeMargin:rightMargin])
        rightMargin = vTotalWidth * rightMargin;
    */
    
    pRect->size.width = [match validMeasure:vTotalWidth - leftMargin - centerMargin - rightMargin];
    pRect->origin.x = (selfWidth - pRect->size.width - leftPadding - rightPadding - leftMargin - rightMargin )/2 + leftPadding + leftMargin + centerMargin;
    
}

-(void)calcMatchParentHeight:(MyLayoutDime*)match selfHeight:(CGFloat)selfHeight topMargin:(CGFloat)topMargin centerMargin:(CGFloat)centerMargin  bottomMargin:(CGFloat)bottomMargin topPadding:(CGFloat)topPadding bottomPadding:(CGFloat)bottomPadding rect:(CGRect*)pRect
{
    
    
    CGFloat vTotalHeight = (selfHeight - topPadding - bottomPadding)*match.mutilVal + match.addVal;
    
  //  if ([self isRelativeMargin:topMargin])
    //    topMargin = vTotalHeight * topMargin;
    
   // if ([self isRelativeMargin:centerMargin])
     //   centerMargin = vTotalHeight * centerMargin;

    
    //if ([self isRelativeMargin:bottomMargin])
      //  bottomMargin = vTotalHeight * bottomMargin;
    
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

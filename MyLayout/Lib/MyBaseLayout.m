//
//  MyBaseLayout.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>


const char * const ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES";
const char * const ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS";


@implementation UIView(MyLayoutExt)


-(MyLayoutPos*)leftPos
{
        
    MyLayoutPos *pos = self.myCurrentSizeClass.leftPos;
    pos.view = self;
    return pos;
}


-(MyLayoutPos*)topPos
{
    MyLayoutPos *pos = self.myCurrentSizeClass.topPos;
    pos.view = self;
    return pos;
}


-(MyLayoutPos*)rightPos
{

    MyLayoutPos *pos = self.myCurrentSizeClass.rightPos;
    pos.view = self;
    return pos;
    
}


-(MyLayoutPos*)bottomPos
{
    
    MyLayoutPos *pos = self.myCurrentSizeClass.bottomPos;
    pos.view = self;
    return pos;
    
}

-(CGFloat)myLeftMargin
{
    return self.leftPos.margin;
}

-(void)setMyLeftMargin:(CGFloat)leftMargin
{
    self.leftPos.equalTo(@(leftMargin));
    
}

-(CGFloat)myTopMargin
{
    return self.topPos.margin;
}

-(void)setMyTopMargin:(CGFloat)topMargin
{
    self.topPos.equalTo(@(topMargin));
}

-(CGFloat)myRightMargin
{
    return self.rightPos.margin;
}

-(void)setMyRightMargin:(CGFloat)rightMargin
{
    self.rightPos.equalTo(@(rightMargin));
}

-(CGFloat)myBottomMargin
{
    return self.bottomPos.margin;
}

-(void)setMyBottomMargin:(CGFloat)bottomMargin
{
    self.bottomPos.equalTo(@(bottomMargin));
}

-(CGFloat)myMargin
{
    return self.leftPos.margin;
}

-(void)setMyMargin:(CGFloat)myMargin
{
    self.topPos.equalTo(@(myMargin));
    self.leftPos.equalTo(@(myMargin));
    self.rightPos.equalTo(@(myMargin));
    self.bottomPos.equalTo(@(myMargin));
}

-(MyLayoutDime*)widthDime
{

    MyLayoutDime *dime = self.myCurrentSizeClass.widthDime;
    dime.view = self;
    return dime;
    
}



-(MyLayoutDime*)heightDime
{

    MyLayoutDime *dime = self.myCurrentSizeClass.heightDime;
    dime.view = self;
    return dime;
}


-(CGFloat)myWidth
{
    return self.widthDime.measure;
}

-(void)setMyWidth:(CGFloat)width
{
    self.widthDime.equalTo(@(width));
}

-(CGFloat)myHeight
{
    return self.heightDime.measure;
}

-(void)setMyHeight:(CGFloat)height
{
    self.heightDime.equalTo(@(height));
}

-(CGSize)mySize
{
    return CGSizeMake(self.myWidth, self.myHeight);
}

-(void)setMySize:(CGSize)mySize
{
    self.myWidth = mySize.width;
    self.myHeight = mySize.height;
}




-(MyLayoutPos*)centerXPos
{
    MyLayoutPos *pos = self.myCurrentSizeClass.centerXPos;
    pos.view = self;
    return pos;
    
}


-(MyLayoutPos*)centerYPos
{
    
    MyLayoutPos *pos = self.myCurrentSizeClass.centerYPos;
    pos.view = self;
    return pos;
}


-(CGFloat)myCenterXOffset
{
    return self.centerXPos.margin;
}

-(void)setMyCenterXOffset:(CGFloat)centerXOffset
{
    self.centerXPos.equalTo(@(centerXOffset));
}

-(CGFloat)myCenterYOffset
{
    return self.centerYPos.margin;
}

-(void)setMyCenterYOffset:(CGFloat)centerYOffset
{
    self.centerYPos.equalTo(@(centerYOffset));
}


-(CGPoint)myCenterOffset
{
    return CGPointMake(self.myCenterXOffset, self.myCenterYOffset);
}

-(void)setMyCenterOffset:(CGPoint)centerOffset
{
    self.myCenterXOffset = centerOffset.x;
    self.myCenterYOffset = centerOffset.y;
}


-(void)setFlexedHeight:(BOOL)flexedHeight
{
    UIView *lsc = self.myCurrentSizeClass;
    if (lsc.flexedHeight != flexedHeight)
    {
        lsc.flexedHeight = flexedHeight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)isFlexedHeight
{
    return self.myCurrentSizeClass.isFlexedHeight;
}


-(BOOL)useFrame
{
    return self.myCurrentSizeClass.useFrame;
}

-(void)setUseFrame:(BOOL)useFrame
{
    UIView *lsc = self.myCurrentSizeClass;
    if (lsc.useFrame != useFrame)
    {
        lsc.useFrame = useFrame;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
    
}

-(BOOL)noLayout
{
    return self.myCurrentSizeClass.noLayout;
}

-(void)setNoLayout:(BOOL)noLayout
{
    UIView *lsc = self.myCurrentSizeClass;
    if (lsc.noLayout != noLayout)
    {
        lsc.noLayout = noLayout;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
    
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
    [self resetMyLayoutSettingInSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}

-(void)resetMyLayoutSettingInSizeClass:(MySizeClass)sizeClass
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES);
    if (dict != nil)
    {
        [dict removeObjectForKey:@(sizeClass)];
    }

}






-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass
{
    return [self fetchLayoutSizeClass:sizeClass copyFrom:0xFF];
}

-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES);
    if (dict == nil)
    {
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    MyLayoutSizeClass *myLayoutSizeClass = (MyLayoutSizeClass*)[dict objectForKey:@(sizeClass)];
    if (myLayoutSizeClass == nil)
    {
        MyLayoutSizeClass *srcLayoutSizeClass = (MyLayoutSizeClass*)[dict objectForKey:@(srcSizeClass)];
        if (srcLayoutSizeClass == nil)
            myLayoutSizeClass = [self createSizeClassInstance];
        else
            myLayoutSizeClass = [srcLayoutSizeClass copy];
        
        [dict setObject:myLayoutSizeClass forKey:@(sizeClass)];
    }
    
    
    return (UIView*)myLayoutSizeClass;

}






@end


@implementation UIView(MyLayoutExtInner)


-(instancetype)myDefaultSizeClass
{
    return [self fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}


-(instancetype)myCurrentSizeClass
{
    if (self.absPos.sizeClass == nil)
        self.absPos.sizeClass = [self myDefaultSizeClass];
    
    return self.absPos.sizeClass;
}


-(instancetype)myBestSizeClass:(MySizeClass)sizeClass
{
    
    MySizeClass wsc = sizeClass & 0x03;
    MySizeClass hsc = sizeClass & 0x0C;
    MySizeClass ori = sizeClass & 0xC0;
    
    
    NSMutableDictionary *dict = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES);
    if (dict == nil)
    {
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        wsc = MySizeClass_wAny;
        hsc = MySizeClass_hAny;
    }
    
    
    //first search the most exact SizeClass
    MySizeClass searchSizeClass = wsc | hsc | ori;
    MyLayoutSizeClass *myClass = (MyLayoutSizeClass*)[dict objectForKey:@(searchSizeClass)];
    if (myClass != nil)
        return (UIView*)myClass;
    
    
    searchSizeClass = wsc | hsc;
    if (searchSizeClass != sizeClass)
    {
        MyLayoutSizeClass *myClass = (MyLayoutSizeClass*)[dict objectForKey:@(searchSizeClass)];
        if (myClass != nil)
            return (UIView*)myClass;
    }
    
    
    searchSizeClass = MySizeClass_wAny | hsc | ori;
    if (ori != 0 && searchSizeClass != sizeClass)
    {
        myClass = (MyLayoutSizeClass*)[dict objectForKey:@(searchSizeClass)];
        if (myClass != nil)
            return (UIView*)myClass;
        
    }
    
    searchSizeClass = MySizeClass_wAny | hsc;
    if (searchSizeClass != sizeClass)
    {
        myClass = (MyLayoutSizeClass*)[dict objectForKey:@(searchSizeClass)];
        if (myClass != nil)
            return (UIView*)myClass;
    }
    
    searchSizeClass = wsc | MySizeClass_hAny | ori;
    if (ori != 0 && searchSizeClass != sizeClass)
    {
        myClass = (MyLayoutSizeClass*)[dict objectForKey:@(searchSizeClass)];
        if (myClass != nil)
            return (UIView*)myClass;
    }
    
    searchSizeClass = wsc | MySizeClass_hAny;
    if (searchSizeClass != sizeClass)
    {
        myClass = (MyLayoutSizeClass*)[dict objectForKey:@(searchSizeClass)];
        if (myClass != nil)
            return (UIView*)myClass;
    }
    
    searchSizeClass = MySizeClass_wAny | MySizeClass_hAny | ori;
    if (ori != 0 && searchSizeClass != sizeClass)
    {
        myClass = (MyLayoutSizeClass*)[dict objectForKey:@(searchSizeClass)];
        if (myClass != nil)
            return (UIView*)myClass;
    }
    
    searchSizeClass = MySizeClass_wAny | MySizeClass_hAny;
    myClass = (MyLayoutSizeClass*)[dict objectForKey:@(searchSizeClass)];
    if (myClass == nil)
    {
        myClass = [self createSizeClassInstance];
        [dict setObject:myClass forKey:@(searchSizeClass)];
    }
    
    return (UIView*)myClass;
    
    
}


-(MyLayoutMeasure*)absPos
{
    
    MyLayoutMeasure *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS);
    if (obj == nil)
    {
        obj = [MyLayoutMeasure new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return obj;
}

-(id)createSizeClassInstance
{
    return [MyLayoutSizeClass new];
}



@end



@implementation MyBorderLineDraw


-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _color = [UIColor blackColor];
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

@property(nonatomic ,weak) MyBaseLayout *layout;

-(id)initWithLayout:(MyBaseLayout*)layout;


@end

@implementation MyBorderLineLayerDelegate


-(id)initWithLayout:(MyBaseLayout*)layout
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
        layerRect = CGRectMake(0, self.layout.leftBorderLine.headIndent, self.layout.leftBorderLine.thick/2, layoutSize.height - self.layout.leftBorderLine.headIndent - self.layout.leftBorderLine.tailIndent);
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


@interface MyBaseLayout()

@end


IB_DESIGNABLE
@implementation MyBaseLayout
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
    
    CGFloat _oldAlpha;
    CGFloat _highlightedOpacity;
    
    BOOL _forbidTouch;
    BOOL _canCallAction;
    CGPoint _beginPoint;
    MyBorderLineLayerDelegate *_layerDelegate;

}

BOOL _hasBegin;

-(void)dealloc
{
}

#pragma  mark -- Public Method

-(void)setPadding:(UIEdgeInsets)padding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (!UIEdgeInsetsEqualToEdgeInsets(lsc.padding, padding))
    {
        lsc.padding = padding;
        [self setNeedsLayout];
    }
}

-(UIEdgeInsets)padding
{
    return self.myCurrentSizeClass.padding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    [self setPadding:UIEdgeInsetsMake(lsc.padding.top, leftPadding, lsc.padding.bottom,lsc.padding.right)];
}

-(CGFloat)leftPadding
{
    return self.myCurrentSizeClass.padding.left;
}

-(void)setTopPadding:(CGFloat)topPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    [self setPadding:UIEdgeInsetsMake(topPadding, lsc.padding.left, lsc.padding.bottom,lsc.padding.right)];
}

-(CGFloat)topPadding
{
    return self.myCurrentSizeClass.padding.top;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    [self setPadding:UIEdgeInsetsMake(lsc.padding.top, lsc.padding.left, lsc.padding.bottom, rightPadding)];
}

-(CGFloat)rightPadding
{
    return self.myCurrentSizeClass.padding.right;
}

-(void)setBottomPadding:(CGFloat)bottomPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    [self setPadding:UIEdgeInsetsMake(lsc.padding.top, lsc.padding.left, bottomPadding, lsc.padding.right)];
}

-(CGFloat)bottomPadding
{
    return self.myCurrentSizeClass.padding.bottom;
}



-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;

    if (lsc.wrapContentHeight != wrapContentHeight)
    {
        lsc.wrapContentHeight = wrapContentHeight;
        [self setNeedsLayout];
    }
}

-(BOOL)wrapContentHeight
{
    return self.myCurrentSizeClass.wrapContentHeight;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;

    if (lsc.wrapContentWidth != wrapContentWidth)
    {
        lsc.wrapContentWidth = wrapContentWidth;
        [self setNeedsLayout];
    }
}

-(BOOL)wrapContentWidth
{
    return self.myCurrentSizeClass.wrapContentWidth;
}


-(void)setHideSubviewReLayout:(BOOL)hideSubviewReLayout
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;

    if (lsc.hideSubviewReLayout != hideSubviewReLayout)
    {
        lsc.hideSubviewReLayout = hideSubviewReLayout;
        [self setNeedsLayout];
    }
    
}

-(BOOL)hideSubviewReLayout
{
    return self.myCurrentSizeClass.hideSubviewReLayout;
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
    return [self estimateLayoutRect:size inSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}

-(CGRect)estimateLayoutRect:(CGSize)size inSizeClass:(MySizeClass)sizeClass
{
    
    self.absPos.sizeClass = [self myBestSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
    {
        sbv.absPos.sizeClass = [sbv myBestSizeClass:sizeClass];
    }
    
    BOOL hasSubLayout = NO;
    CGRect rect;
    self.absPos.frame = [self calcLayoutRect:size isEstimate:NO pHasSubLayout:&hasSubLayout sizeClass:sizeClass];
    if (!hasSubLayout)
        rect = self.absPos.frame;
    else
    {
        rect = [self calcLayoutRect:CGSizeZero isEstimate:YES pHasSubLayout:&hasSubLayout sizeClass:sizeClass];
        self.absPos.frame = rect;
    }

    
    //计算后还原为默认sizeClass
    for (UIView *sbv in self.subviews)
    {
        sbv.absPos.sizeClass = self.myDefaultSizeClass;
        
    }
    self.absPos.sizeClass = self.myDefaultSizeClass;
    
    
    return rect;
    
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





#pragma mark -- Touches Event



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (_target != nil && !_forbidTouch && touch.tapCount == 1 && !_hasBegin)
    {
        _hasBegin = YES;
        _canCallAction = YES;
        _beginPoint = [((UITouch*)[touches anyObject]) locationInView:self];
        
        if (_highlightedOpacity != 0)
        {
            _oldAlpha = self.alpha;
            self.alpha = 1 - _highlightedOpacity;
        }
        
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
    
    if (_highlightedOpacity != 0)
    {
        self.alpha = _oldAlpha;
        _oldAlpha = 1;
    }
    
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
        if (_highlightedOpacity != 0)
        {
            self.alpha = _oldAlpha;
            _oldAlpha = 1;
        }
        
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
    if (object == self.superview && ![object isKindOfClass:[MyBaseLayout class]])
    {
        
        if ([keyPath isEqualToString:@"frame"] ||
            [keyPath isEqualToString:@"bounds"] )
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
        
    }
    
    
    //监控子视图的frame的变化以便重新进行布局
    if (!_isMyLayouting && [self.subviews containsObject:object])
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

-(id)createSizeClassInstance
{
    return [MyLayoutSizeClassLayout new];
}


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
    if (newSuperview != nil && ![newSuperview isKindOfClass:[MyBaseLayout class]])
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
            
            
            if (self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]])
            {
                @try {
                    [self.superview removeObserver:self forKeyPath:@"frame"];
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                @try {
                    [self.superview removeObserver:self forKeyPath:@"bounds"];
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                
            }
            
            [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [newSuperview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];

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
    
    if (newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]])
    {
        
        @try {
            [self.superview removeObserver:self forKeyPath:@"frame"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        @try {
            [self.superview removeObserver:self forKeyPath:@"bounds"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    }
    
    
}



-(void)layoutSubviews
{
    if (!self.autoresizesSubviews)
        return;
    
    if (self.beginLayoutBlock != nil)
        self.beginLayoutBlock();
    
    if (!self.isMyLayouting)
    {        
        _isMyLayouting = YES;
    
        if (self.priorAutoresizingMask)
            [super layoutSubviews];
        
        //得到最佳的sizeClass
        MySizeClass sizeClass;
        if ([UIDevice currentDevice].systemVersion.floatValue < 8)
            sizeClass = MySizeClass_hAny | MySizeClass_wAny;
        else
            sizeClass = (MySizeClass)((self.traitCollection.verticalSizeClass << 2) | self.traitCollection.horizontalSizeClass);
        
        UIDeviceOrientation ori =   [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsPortrait(ori))
            sizeClass |= MySizeClass_Portrait;
        else if (UIDeviceOrientationIsLandscape(ori))
            sizeClass |= MySizeClass_Landscape;
        else;
        
        self.absPos.sizeClass = [self myBestSizeClass:sizeClass];
        for (UIView *sbv in self.subviews)
        {
            sbv.absPos.sizeClass = [sbv myBestSizeClass:sizeClass];
        }

        //计算布局
        CGRect oldSelfRect = self.frame;
        CGRect newSelfRect = [self calcLayoutRect:CGSizeZero isEstimate:NO pHasSubLayout:nil sizeClass:sizeClass];
        
        //设置子视图的frame并还原
        for (UIView *sbv in self.subviews)
        {
            if (sbv.absPos.leftPos != CGFLOAT_MAX && sbv.absPos.topPos != CGFLOAT_MAX && !sbv.noLayout)
                sbv.frame = sbv.absPos.frame;
            
            if (sbv.absPos.sizeClass.isHidden)
                sbv.frame = CGRectZero;
            
            sbv.absPos.sizeClass = [sbv myDefaultSizeClass];
            [sbv.absPos reset];
        }
        self.absPos.sizeClass = [self myDefaultSizeClass];
        
        //调整自身
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

        
        //这里只用origin.x判断的原因是如果newSelfRect被计算成功则rect中的所有值都不是CGFLOAT_MAX，所以这里选origin.x只是其中一个代表。
        if (newSelfRect.origin.x != CGFLOAT_MAX)
            [self alterScrollViewContentSize:newSelfRect];
       
        
        
        _isMyLayouting = NO;
    }
    
    if (self.endLayoutBlock != nil)
    {
        self.endLayoutBlock();
        self.beginLayoutBlock = nil;
        self.endLayoutBlock = nil;
    }
}





#pragma mark -- Private Method

-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
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



-(void)vertGravity:(MyMarginGravity)vert
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

    
    if (vert == MyMarginGravity_Vert_Fill)
    {
        
        pRect->origin.y = self.padding.top + topMargin;
        pRect->size.height = [sbv.heightDime validMeasure:selfHeight - self.padding.bottom - bottomMargin - pRect->origin.y];
    }
    else if (vert == MyMarginGravity_Vert_Center)
    {
        
        pRect->origin.y = (selfHeight - self.padding.top - self.padding.bottom - topMargin - bottomMargin - pRect->size.height)/2 + self.padding.top + topMargin + centerMargin;
    }
    else if (vert == MyMarginGravity_Vert_Window_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.y = (self.window.frame.size.height - topMargin - bottomMargin - pRect->size.height)/2 + topMargin + centerMargin;
            
            CGPoint pt = pRect->origin;
            pRect->origin.y =  [self.window convertPoint:pt toView:self].y;
        }

    }
    else if (vert == MyMarginGravity_Vert_Bottom)
    {
        
        pRect->origin.y = selfHeight - self.padding.bottom - bottomMargin - pRect->size.height;
    }
    else if (vert == MyMarginGravity_Vert_Top)
    {
        pRect->origin.y = self.padding.top + topMargin;
    }
    else
    {
        pRect->origin.y = self.padding.top + topMargin;
    }
    
    
}

-(void)horzGravity:(MyMarginGravity)horz
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

    
    
    if (horz == MyMarginGravity_Horz_Fill)
    {
        
        pRect->origin.x = self.padding.left + leftMargin;
        pRect->size.width = [sbv.widthDime validMeasure:selfWidth - self.padding.right - rightMargin - pRect->origin.x];
    }
    else if (horz == MyMarginGravity_Horz_Center)
    {
        pRect->origin.x = (selfWidth - self.padding.left - self.padding.right - leftMargin - rightMargin - pRect->size.width)/2 + self.padding.left + leftMargin + centerMargin;
    }
    else if (horz == MyMarginGravity_Horz_Window_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.x = (self.window.frame.size.width - leftMargin - rightMargin - pRect->size.width)/2 + leftMargin + centerMargin;
            
            CGPoint pt = pRect->origin;
            pRect->origin.x =  [self.window convertPoint:pt toView:self].x;
        }


    }
    else if (horz == MyMarginGravity_Horz_Right)
    {
        
        pRect->origin.x = selfWidth - self.padding.right - rightMargin - pRect->size.width;
    }
    else if (horz == MyMarginGravity_Horz_Left)
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
    
    
    pRect->size.width = [match validMeasure:vTotalWidth - leftMargin - centerMargin - rightMargin];
    pRect->origin.x = (selfWidth - pRect->size.width - leftPadding - rightPadding - leftMargin - rightMargin )/2 + leftPadding + leftMargin + centerMargin;
    
}

-(void)calcMatchParentHeight:(MyLayoutDime*)match selfHeight:(CGFloat)selfHeight topMargin:(CGFloat)topMargin centerMargin:(CGFloat)centerMargin  bottomMargin:(CGFloat)bottomMargin topPadding:(CGFloat)topPadding bottomPadding:(CGFloat)bottomPadding rect:(CGRect*)pRect
{
    CGFloat vTotalHeight = (selfHeight - topPadding - bottomPadding)*match.mutilVal + match.addVal;
    
    pRect->size.height = [match validMeasure:vTotalHeight - topMargin - centerMargin - bottomMargin];
    pRect->origin.y = (selfHeight - pRect->size.height - topPadding - bottomPadding - topMargin - bottomMargin )/2 + topPadding + topMargin + centerMargin;
    
    
}


-(void)setWrapContentWidthNoLayout:(BOOL)wrapContentWidth
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    lsc.wrapContentWidth = wrapContentWidth;
}

-(void)setWrapContentHeightNoLayout:(BOOL)wrapContentHeight
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    lsc.wrapContentHeight = wrapContentHeight;
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


@end

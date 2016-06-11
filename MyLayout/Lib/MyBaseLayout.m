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
    
    BOOL _isAddSuperviewKVO;

}

BOOL _hasBegin;

-(void)dealloc
{
    //如果您在使用时出现了KVO的异常崩溃，原因是您将这个视图被多次加入为子视图，请检查您的代码，是否这个视图被多次加入！！
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


-(void)layoutAnimationWithDuration:(NSTimeInterval)duration
{
    self.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
    };
    
    self.endLayoutBlock = ^{
    
        [UIView commitAnimations];
    };
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
            [self setLayoutRectInNoLayoutSuperview:object];
        }
        return;
    }
    
    
    //监控子视图的frame的变化以便重新进行布局
    if ([keyPath isEqualToString:@"frame"] ||
        [keyPath isEqualToString:@"hidden"] )
    {
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
    
#ifdef DEBUG
    
    if (self.wrapContentHeight && self.heightDime.dimeVal != nil)
    {
        //约束警告：wrapContentHeight和设置的heightDime可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentHeight and heightDime setting may be constraint.",self);
    }
    
    if (self.wrapContentWidth && self.widthDime.dimeVal != nil)
    {
        //约束警告：wrapContentWidth和设置的widthDime可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentWidth and widthDime setting may be constraint.",self);
    }
    
#endif
    
    
    
    //将要添加到父视图时，如果不是MyLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
    if (newSuperview != nil && ![newSuperview isKindOfClass:[MyBaseLayout class]])
    {

#ifdef DEBUG
        
        if (self.leftPos.posRelaVal != nil)
        {
            //约束冲突：左边距依赖的视图不是父视图
            NSCAssert(self.leftPos.posRelaVal.view == newSuperview, @"Constraint exception!! %@left margin dependent on:%@is not superview",self, self.leftPos.posRelaVal.view);
        }
        
        if (self.rightPos.posRelaVal != nil)
        {
            //约束冲突：右边距依赖的视图不是父视图
            NSCAssert(self.rightPos.posRelaVal.view == newSuperview, @"Constraint exception!! %@right margin dependent on:%@is not superview",self,self.rightPos.posRelaVal.view);
        }
        
        if (self.centerXPos.posRelaVal != nil)
        {
            //约束冲突：水平中心点依赖的视图不是父视图
            NSCAssert(self.centerXPos.posRelaVal.view == newSuperview, @"Constraint exception!! %@horizontal center margin dependent on:%@is not superview",self, self.centerXPos.posRelaVal.view);
        }
        
        if (self.topPos.posRelaVal != nil)
        {
            //约束冲突：上边距依赖的视图不是父视图
            NSCAssert(self.topPos.posRelaVal.view == newSuperview, @"Constraint exception!! %@top margin dependent on:%@is not superview",self, self.topPos.posRelaVal.view);
        }
        
        if (self.bottomPos.posRelaVal != nil)
        {
            //约束冲突：下边距依赖的视图不是父视图
            NSCAssert(self.bottomPos.posRelaVal.view == newSuperview, @"Constraint exception!! %@bottom margin dependent on:%@is not superview",self, self.bottomPos.posRelaVal.view);
            
        }
        
        if (self.centerYPos.posRelaVal != nil)
        {
            //约束冲突：垂直中心点依赖的视图不是父视图
            NSCAssert(self.centerYPos.posRelaVal.view == newSuperview, @"Constraint exception!! vertical center margin dependent on:%@is not superview",self.centerYPos.posRelaVal.view);
        }
        
        if (self.widthDime.dimeRelaVal != nil)
        {
            //约束冲突：宽度依赖的视图不是父视图
            NSCAssert(self.widthDime.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@width dependent on:%@is not superview",self, self.widthDime.dimeRelaVal.view);
        }
        
        if (self.heightDime.dimeRelaVal != nil)
        {
            //约束冲突：高度依赖的视图不是父视图
            NSCAssert(self.heightDime.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@height dependent on:%@is not superview",self,self.heightDime.dimeRelaVal.view);
        }
        
#endif

        if ([self setLayoutRectInNoLayoutSuperview:newSuperview])
        {
            //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃
            
            //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
            //然后在左边将异常断点清除即可
            
            if (_isAddSuperviewKVO && self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]])
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
            _isAddSuperviewKVO = YES;
        }
        
    }
    
    if (_isAddSuperviewKVO && newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]])
    {
        
        //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
        //然后在左边将异常断点清除即可
        
        _isAddSuperviewKVO = NO;
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
    
    
    if (newSuperview != nil)
    {
        //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
        if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
            self.adjustScrollViewContentSize = YES;
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
        selfSize:(CGSize)selfSize
               sbv:(UIView *)sbv
              rect:(CGRect*)pRect
{
    
    CGFloat fixedHeight = self.padding.top + self.padding.bottom;

    
   CGFloat  topMargin =  [self validMargin:sbv.topPos sbv:sbv calcPos:[sbv.topPos realMarginInSize:selfSize.height - fixedHeight] selfLayoutSize:selfSize];
    
   CGFloat  centerMargin = [self validMargin:sbv.centerYPos sbv:sbv calcPos:[sbv.centerYPos realMarginInSize:selfSize.height - fixedHeight] selfLayoutSize:selfSize];
    
   CGFloat  bottomMargin = [self validMargin:sbv.bottomPos sbv:sbv calcPos:[sbv.bottomPos realMarginInSize:selfSize.height - fixedHeight] selfLayoutSize:selfSize];

    
    if (vert == MyMarginGravity_Vert_Fill)
    {
        
        pRect->origin.y = self.padding.top + topMargin;
        pRect->size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:selfSize.height - self.padding.bottom - bottomMargin - pRect->origin.y sbvSize:pRect->size selfLayoutSize:selfSize];
    }
    else if (vert == MyMarginGravity_Vert_Center)
    {
        
        pRect->origin.y = (selfSize.height - self.padding.top - self.padding.bottom - topMargin - bottomMargin - pRect->size.height)/2 + self.padding.top + topMargin + centerMargin;
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
        
        pRect->origin.y = selfSize.height - self.padding.bottom - bottomMargin - pRect->size.height;
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
         selfSize:(CGSize)selfSize
               sbv:(UIView *)sbv
              rect:(CGRect*)pRect
{
    CGFloat fixedWidth = self.padding.left + self.padding.right;
    
    CGFloat leftMargin = [self validMargin:sbv.leftPos sbv:sbv calcPos:[sbv.leftPos realMarginInSize:selfSize.width - fixedWidth] selfLayoutSize:selfSize];
    
    CGFloat centerMargin = [self validMargin:sbv.centerXPos sbv:sbv calcPos:[sbv.centerXPos realMarginInSize:selfSize.width - fixedWidth] selfLayoutSize:selfSize];
    
   CGFloat  rightMargin = [self validMargin:sbv.rightPos sbv:sbv calcPos:[sbv.rightPos realMarginInSize:selfSize.width - fixedWidth] selfLayoutSize:selfSize];

    
    if (horz == MyMarginGravity_Horz_Fill)
    {
        
        pRect->origin.x = self.padding.left + leftMargin;
        pRect->size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:selfSize.width - self.padding.right - rightMargin - pRect->origin.x sbvSize:pRect->size selfLayoutSize:selfSize];

        
    }
    else if (horz == MyMarginGravity_Horz_Center)
    {
        pRect->origin.x = (selfSize.width - self.padding.left - self.padding.right - leftMargin - rightMargin - pRect->size.width)/2 + self.padding.left + leftMargin + centerMargin;
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
        
        pRect->origin.x = selfSize.width - self.padding.right - rightMargin - pRect->size.width;
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

-(void)calcSizeOfWrapContentSubview:(UIView*)sbv
{
    if (sbv.widthDime.dimeSelfVal != nil || sbv.heightDime.dimeSelfVal != nil)
    {
        CGSize fitSize = [sbv sizeThatFits:CGSizeZero];
        if (sbv.widthDime.dimeSelfVal != nil)
        {
            sbv.absPos.width = fitSize.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            
        }
        
        if (sbv.heightDime.dimeSelfVal != nil)
        {
            sbv.absPos.height = fitSize.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        }
    }    
}


-(BOOL)setLayoutRectInNoLayoutSuperview:(UIView*)newSuperview
{
    BOOL isAdjust = NO;
    
    CGRect rectSuper = newSuperview.bounds;
    CGRect rectSelf = self.frame;
    
    //确定左右边距和宽度。
    if (self.widthDime.dimeVal != nil)
    {
        [self setWrapContentWidthNoLayout:NO];
        
        if (self.widthDime.dimeRelaVal != nil)
        {
            rectSelf.size.width = rectSuper.size.width*self.widthDime.mutilVal + self.widthDime.addVal;
            isAdjust = YES;
        }
        else
            rectSelf.size.width = self.widthDime.measure;
    }
    
    rectSelf.size.width = [self validMeasure:self.widthDime sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
    
    if (self.leftPos.posVal != nil && self.rightPos.posVal != nil)
    {
        isAdjust = YES;
        [self setWrapContentWidthNoLayout:NO];
        rectSelf.size.width = rectSuper.size.width - self.leftPos.margin - self.rightPos.margin;
        rectSelf.size.width = [self validMeasure:self.widthDime sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
        
        rectSelf.origin.x = self.leftPos.margin;
    }
    else if (self.centerXPos.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x = (rectSuper.size.width - rectSelf.size.width)/2 + self.centerXPos.margin;
    }
    else if (self.leftPos.posVal != nil)
    {
        rectSelf.origin.x = self.leftPos.margin;
    }
    else if (self.rightPos.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x  = rectSuper.size.width - rectSelf.size.width - self.rightPos.margin;
    }
    else;
    
    
    if (self.heightDime.dimeVal != nil)
    {
        [self setWrapContentHeightNoLayout:NO];
        
        if (self.heightDime.dimeRelaVal != nil)
        {
            rectSelf.size.height = rectSuper.size.height*self.heightDime.mutilVal + self.heightDime.addVal;
            isAdjust = YES;
        }
        else
            rectSelf.size.height = self.heightDime.measure;
    }
    
    rectSelf.size.height = [self validMeasure:self.heightDime sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
    
    if (self.topPos.posVal != nil && self.bottomPos.posVal != nil)
    {
        isAdjust = YES;
        [self setWrapContentHeightNoLayout:NO];
        rectSelf.size.height = rectSuper.size.height - self.topPos.margin - self.bottomPos.margin;
        rectSelf.size.height = [self validMeasure:self.heightDime sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
        
        rectSelf.origin.y = self.topPos.margin;
    }
    else if (self.centerYPos.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y = (rectSuper.size.height - rectSelf.size.height)/2 + self.centerYPos.margin;
    }
    else if (self.topPos.posVal != nil)
    {
        rectSelf.origin.y = self.topPos.margin;
    }
    else if (self.bottomPos.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y  = rectSuper.size.height - rectSelf.size.height - self.bottomPos.margin;
    }
    else;
    


    if (!CGRectEqualToRect(rectSelf, self.frame))
    {
        self.frame = rectSelf;
    }
    
    return isAdjust;

}

-(CGFloat)heightFromFlexedHeightView:(UIView*)sbv inWidth:(CGFloat)width
{
    if ([sbv isKindOfClass:[UIImageView class]])
    {
        //根据图片的尺寸进行等比缩放得到合适的高度。
        UIImage *img = ((UIImageView*)sbv).image;
        if (img != nil && img.size.width != 0)
        {
            return img.size.height * (width / img.size.width);
        }
        else
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(width, 0)];
            return sz.height;
            
        }
    }
    else
    {
        CGSize sz = [sbv sizeThatFits:CGSizeMake(width, 0)];
        return sz.height;
    }
}


-(CGFloat)getBoundLimitMeasure:(MyLayoutDime*)boundDime sbv:(UIView*)sbv dimeType:(MyMarginGravity)dimeType sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound
{
    CGFloat value = isUBound ? CGFLOAT_MAX : -CGFLOAT_MAX;
    
    MyLayoutValueType lValueType = boundDime.dimeValType;
    if (lValueType == MyLayoutValueType_NSNumber)
    {
        value = boundDime.dimeNumVal.doubleValue;
    }
    else if (lValueType == MyLayoutValueType_LayoutDime)
    {
        if (boundDime.dimeRelaVal.view == self || boundDime.dimeRelaVal.view == self.superview)
        {
            if (boundDime.dimeRelaVal.dime == MyMarginGravity_Horz_Fill)
                value = selfLayoutSize.width - (boundDime.dimeRelaVal.view == self ? (self.leftPadding - self.rightPadding) : 0);
            else
                value = selfLayoutSize.height - (boundDime.dimeRelaVal.view == self ? (self.topPadding - self.bottomPadding) :0);
        }
        else if (boundDime.dimeRelaVal.view == sbv)
        {
            if (boundDime.dimeRelaVal.dime == dimeType)
            {
                //约束冲突：无效的边界设置方法
                NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
            }
            else
            {
                if (boundDime.dimeRelaVal.dime == MyMarginGravity_Horz_Fill)
                    value = sbvSize.width;
                else
                    value = sbvSize.height;
            }
        }
        else
        {
            if (boundDime.dimeRelaVal.dime == MyMarginGravity_Horz_Fill)
            {
                if (boundDime.dimeRelaVal.view.absPos.width != CGFLOAT_MAX)
                    value = boundDime.dimeRelaVal.view.absPos.width;
            }
            else
            {
                if (boundDime.dimeRelaVal.view.absPos.height != CGFLOAT_MAX)
                    value = boundDime.dimeRelaVal.view.absPos.height;
            }
        }
        
    }
    else
    {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
    }
    
    if (value == CGFLOAT_MAX || value == -CGFLOAT_MAX)
        return value;
    
    return value * boundDime.mutilVal + boundDime.addVal;

}



-(CGFloat)validMeasure:(MyLayoutDime*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize
{    
    //算出最大最小值。
    CGFloat min = [self getBoundLimitMeasure:dime.lBoundVal sbv:sbv dimeType:dime.dime sbvSize:sbvSize selfLayoutSize:selfLayoutSize isUBound:NO];
    CGFloat max = [self getBoundLimitMeasure:dime.uBoundVal sbv:sbv dimeType:dime.dime sbvSize:sbvSize selfLayoutSize:selfLayoutSize isUBound:YES];
    
    calcSize = MAX(min, calcSize);
    calcSize = MIN(max, calcSize);
    
    return calcSize;
}


-(CGFloat)getBoundLimitMargin:(MyLayoutPos*)boundPos sbv:(UIView*)sbv selfLayoutSize:(CGSize)selfLayoutSize
{
    CGFloat value = 0;
    
    MyLayoutValueType lValueType = boundPos.posValType;
    if (lValueType == MyLayoutValueType_NSNumber)
        value = boundPos.posNumVal.doubleValue;
    else if (lValueType == MyLayoutValueType_LayoutPos)
    {
        CGRect rect = boundPos.posRelaVal.view.absPos.frame;
        
        MyMarginGravity pos = boundPos.posRelaVal.pos;
        if (pos == MyMarginGravity_Horz_Left)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMinX(rect);
        }
        else if (pos == MyMarginGravity_Horz_Center)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMidX(rect);
        }
        else if (pos == MyMarginGravity_Horz_Right)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMaxX(rect);
        }
        else if (pos == MyMarginGravity_Vert_Top)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMinY(rect);
        }
        else if (pos == MyMarginGravity_Vert_Center)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMidY(rect);
        }
        else if (pos == MyMarginGravity_Vert_Bottom)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMaxY(rect);
        }
    }
    else
    {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
    }
    
    return value + boundPos.offsetVal;
}


-(CGFloat)validMargin:(MyLayoutPos*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize
{
    //算出最大最小值
    CGFloat min = [self getBoundLimitMargin:pos.lBoundVal sbv:sbv selfLayoutSize:selfLayoutSize];
    CGFloat max = [self getBoundLimitMargin:pos.uBoundVal sbv:sbv selfLayoutSize:selfLayoutSize];
    
    calcPos = MAX(min, calcPos);
    calcPos = MIN(max, calcPos);
    return calcPos;
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

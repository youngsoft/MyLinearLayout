//
//  MyBaseLayout.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"
#import "MyLayoutDelegate.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>

const char *const ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE";

void *_myObserverContextA = (void *)20175281;
void *_myObserverContextB = (void *)20175282;
void *_myObserverContextC = (void *)20175283;

@interface MyLayoutDragger ()

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger oldIndex;
@property (nonatomic, assign) BOOL hasDragging;
@property (nonatomic, weak) MyBaseLayout *layout;

@end

/**
 窗口对RTL的支持。
 */

@interface UIWindow (MyLayoutExt)

- (void)myUpdateRTL:(BOOL)isRTL;

@end

@implementation UIView (MyLayoutExt)

_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, topPos)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, leadingPos)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, bottomPos)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, trailingPos)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, centerXPos)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, centerYPos)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, leftPos)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, rightPos)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutPos *, baselinePos)

_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyTop, myTop)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyLeading, myLeading)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyBottom, myBottom)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyTrailing, myTrailing)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyCenterX, myCenterX)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyCenterY, myCenterY)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGPoint, MyCenter, myCenter)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyLeft, myLeft)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyRight, myRight)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyMargin, myMargin)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyHorzMargin, myHorzMargin)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyVertMargin, myVertMargin)

_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutSize *, widthSize)
_MYLAYOUT_PROPERTY_VIEW_GET3(MyLayoutSize *, heightSize)

_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyWidth, myWidth)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGFloat, MyHeight, myHeight)
_MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(CGSize, MySize, mySize)


_MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(BOOL, WrapContentHeight, wrapContentHeight)

_MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(BOOL, WrapContentWidth, wrapContentWidth)

_MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(BOOL, WrapContentSize, wrapContentSize)

_MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(CGFloat, Weight, weight)

_MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(BOOL, UseFrame, useFrame)

_MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(BOOL, NoLayout, noLayout)

_MYLAYOUT_PROPERTY_VIEW_GET2(MyVisibility, visibility)

- (void)setVisibility:(MyVisibility)visibility {
    MyViewTraitsImpl *viewTraits = (MyViewTraitsImpl*)self.myDefaultTraits;
    if (viewTraits.visibility != visibility) {
        viewTraits.visibility = visibility;
        self.hidden = (visibility != MyVisibility_Visible);
        if (self.superview != nil) {
            //修复布局视图在从隐藏转到不隐藏并且有尺寸自适应时，位置和尺寸不会重新计算的BUG。
            if (!self.isHidden &&
                [self isKindOfClass:MyBaseLayout.class] && (viewTraits.widthSizeInner.isWrap || viewTraits.heightSizeInner.isWrap)) {
                [self setNeedsLayout];
            }
            [self.superview setNeedsLayout];
        }
    }
}

_MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(MyGravity, Alignment, alignment)


- (void)setReverseFloat:(BOOL)reverseFloat {
    MyViewTraitsImpl *viewTraits = (MyViewTraitsImpl*)self.myDefaultTraits;
    if (viewTraits.isReverseFloat != reverseFloat) {
        viewTraits.reverseFloat = reverseFloat;
        if (self.superview != nil) {
            [self.superview setNeedsLayout];
        }
    }
}

- (BOOL)isReverseFloat {
    return self.myDefaultTraitsInner.isReverseFloat;
}


_MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(BOOL, ClearFloat, clearFloat)


- (void (^)(MyBaseLayout *, UIView *))viewLayoutCompleteBlock {
    return self.myEngineInner.viewLayoutCompleteBlock;
}

- (void)setViewLayoutCompleteBlock:(void (^)(MyBaseLayout *, UIView *))viewLayoutCompleteBlock {
    self.myEngine.viewLayoutCompleteBlock = viewLayoutCompleteBlock;
}

- (CGRect)estimatedRect {
    CGRect rect = self.myEngine.frame;
    if (rect.size.width == CGFLOAT_MAX || rect.size.height == CGFLOAT_MAX) {
        return self.frame;
    }
    return rect;
}

- (void)clearLayoutTraits {
    [self clearLayoutTraitsInSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}

- (void)clearLayoutTraitsInSizeClass:(MySizeClass)sizeClass {
    [self.myEngine.traitsDict removeObjectForKey:@(sizeClass)];
}

- (id<MyViewTraits>)fetchLayoutTraitsInSizeClass:(MySizeClass)sizeClass {
    return [self fetchLayoutTraitsInSizeClass:sizeClass copyFrom:MySizeClass_All];
}

- (id<MyViewTraits>)fetchLayoutTraitsInSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass {
    return [self.myEngine fetchView:self traitsInSizeClass:sizeClass copyFrom:srcSizeClass];
}

- (void)setLayoutTraits:(id<MyViewTraits>)value inSizeClass:(MySizeClass)sizeClass {
    [self.myEngine setView:self newTraits:(MyViewTraitsImpl*)value at:sizeClass];
}

- (void)resetMyLayoutSetting {
    [self clearLayoutTraits];
}

- (void)resetMyLayoutSettingInSizeClass:(MySizeClass)sizeClass {
    [self clearLayoutTraitsInSizeClass:sizeClass];
}

- (instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass {
    return [self fetchLayoutSizeClass:sizeClass copyFrom:MySizeClass_All];
}

- (instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass {
    return (UIView *)[self fetchLayoutTraitsInSizeClass:sizeClass copyFrom:srcSizeClass];
}

- (void)setLayoutSizeClass:(MySizeClass)sizeClass withValue:(id)value {
    [self setLayoutTraits:value inSizeClass:sizeClass];
}

@end

@implementation UIView (MyLayoutExtInner)

- (__kindof MyViewTraitsImpl *)myDefaultTraits {
    MyLayoutEngine *viewEngine = self.myEngine;
    if (viewEngine.defaultTraits == nil) {
        viewEngine.defaultTraits = [viewEngine fetchView:self traitsInSizeClass:MySizeClass_wAny | MySizeClass_hAny copyFrom:MySizeClass_All];
    }
    if (viewEngine.currentTraits == nil) {
        viewEngine.currentTraits = viewEngine.defaultTraits;
    }
    return viewEngine.defaultTraits;
}

- (__kindof MyViewTraitsImpl *)myDefaultTraitsInner {
    return self.myEngineInner.defaultTraits;
}

- (__kindof MyViewTraitsImpl *)myCurrentTraits {
    MyLayoutEngine *viewEngine = self.myEngine;
    if (viewEngine.currentTraits == nil) {
        viewEngine.currentTraits = [self myDefaultTraits];
    }
    return viewEngine.currentTraits;
}

- (__kindof MyViewTraitsImpl *)myCurrentTraitsInner {
    //如果没有则不会建立，为了优化减少不必要的建立。
    return self.myEngineInner.currentTraits;
}

- (MyLayoutEngine *)myEngine {
    MyLayoutEngine *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE);
    if (obj == nil){
        obj = [[MyLayoutEngine alloc] initWithTraitsClass:[MyViewTraitsImpl class]];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (MyLayoutEngine *)myEngineInner {
    return (MyLayoutEngine*)objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ENGINE);
}


- (CGFloat)myEstimatedWidth {
    //如果视图的父视图不是布局视图则直接返回宽度值。
    if (![self.superview isKindOfClass:[MyBaseLayout class]]) {
        return CGRectGetWidth(self.bounds);
    } else {
        MyLayoutEngine *viewEngine = self.myEngine;
        if (viewEngine.width == CGFLOAT_MAX) {
            return CGRectGetWidth(self.bounds);
        }
        return viewEngine.width;
    }
}

- (CGFloat)myEstimatedHeight {
    if (![self.superview isKindOfClass:[MyBaseLayout class]]) {
        return CGRectGetHeight(self.bounds);
    } else {
        MyLayoutEngine *viewEngine = self.myEngine;
        if (viewEngine.height == CGFLOAT_MAX) {
            return CGRectGetHeight(self.bounds);
        }
        return viewEngine.height;
    }
}

- (CGFloat)myLayoutPaddingTop {
    return 0.0;
}
- (CGFloat)myLayoutPaddingBottom {
    return 0.0;
}
- (CGFloat)myLayoutPaddingLeft {
    return 0.0;
}
- (CGFloat)myLayoutPaddingRight {
    return 0.0;
}
- (CGFloat)myLayoutPaddingLeading {
    return 0.0;
}
- (CGFloat)myLayoutPaddingTrailing {
    return 0.0;
}


@end

@implementation MyBaseLayout {
    BOOL _isAddSuperviewKVO;
    BOOL _useCacheRects;
    MyLayoutTouchEventDelegate *_touchEventDelegate;
    MyBorderlineLayerDelegate *_borderlineLayerDelegate;
    MyBaseLayoutOptionalData *_optionalData;
    MyLayoutEngine *_myEngine;
}

- (void)dealloc {
    //如果您在使用时出现了KVO的异常崩溃，原因是您将这个视图被多次加入为子视图，请检查您的代码，是否这个视图被多次加入！！
    _optionalData = nil;
}

#pragma mark-- Public Methods

+ (BOOL)isRTL {
    return [MyViewTraitsImpl isRTL];
}

+ (void)setIsRTL:(BOOL)isRTL {
    [MyViewTraitsImpl setIsRTL:isRTL];
}

+ (void)updateRTL:(BOOL)isRTL inWindow:(UIWindow *)window {
    [window myUpdateRTL:isRTL];
}

_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,topPos)
_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,leadingPos)
_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,bottomPos)
_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,trailingPos)
_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,centerXPos)
_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,centerYPos)
_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,leftPos)
_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,rightPos)
_MYLAYOUT_PROPERTY_GET1(MyLayoutPos *,baselinePos)

_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyTop,myTop)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyLeading,myLeading)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyBottom,myBottom)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyTrailing,myTrailing)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyCenterX,myCenterX)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyCenterY,myCenterY)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGPoint,MyCenter,myCenter)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyLeft,myLeft)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyRight,myRight)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyMargin,myMargin)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyHorzMargin,myHorzMargin)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyVertMargin,myVertMargin)

_MYLAYOUT_PROPERTY_GET1(MyLayoutSize *,widthSize)
_MYLAYOUT_PROPERTY_GET1(MyLayoutSize *,heightSize)


_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyWidth,myWidth)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,MyHeight,myHeight)
_MYLAYOUT_PROPERTY_OVERRIDE1(CGSize,MySize,mySize)

_MYLAYOUT_PROPERTY_GET1(BOOL,wrapContentWidth)
_MYLAYOUT_PROPERTY_GET1(BOOL,wrapContentHeight)
_MYLAYOUT_PROPERTY_GET1(BOOL,wrapContentSize)



_MYLAYOUT_PROPERTY_OVERRIDE1(CGFloat,Weight,weight)
_MYLAYOUT_PROPERTY_OVERRIDE1(BOOL,UseFrame,useFrame)
_MYLAYOUT_PROPERTY_OVERRIDE1(BOOL,NoLayout,noLayout)
_MYLAYOUT_PROPERTY_OVERRIDE1(MyVisibility,Visibility,visibility)
_MYLAYOUT_PROPERTY_OVERRIDE1(MyGravity,Alignment,alignment)
_MYLAYOUT_PROPERTY_OVERRIDE1(BOOL,ReverseFloat,isReverseFloat)
_MYLAYOUT_PROPERTY_OVERRIDE1(BOOL,ClearFloat,clearFloat)




_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, PaddingTop, paddingTop)
_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, PaddingLeading, paddingLeading)
_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, PaddingBottom, paddingBottom)
_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, PaddingTrailing, paddingTrailing)


_MYLAYOUT_PROPERTY_LAYOUTVIEW_GET1(MyLayoutTraitsImpl, UIEdgeInsets, padding)


- (void)setPadding:(UIEdgeInsets)padding {
    MyLayoutTraitsImpl *layoutTraits = (MyLayoutTraitsImpl*)self.myDefaultTraits;
    if (!UIEdgeInsetsEqualToEdgeInsets(layoutTraits.padding, padding)) {
        layoutTraits.padding = padding;
        [self setNeedsLayout];
    }
}


_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, PaddingLeft, paddingLeft)
_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, PaddingRight, paddingRight)


- (BOOL)zeroPadding {
    //这里不用myDefaultSizeClassInner的原因是这个属性默认是YES!
    return ((MyLayoutTraitsImpl*)self.myDefaultTraits).zeroPadding;
}

_MYLAYOUT_PROPERTY_LAYOUTVIEW_SET1(MyLayoutTraitsImpl, BOOL,ZeroPadding,zeroPadding)


- (UIRectEdge)insetsPaddingFromSafeArea {
    //这里不用myDefaultSizeClassInner的原因是这个属性默认是UIRectEdgeLeft | UIRectEdgeRight ！
    return ((MyLayoutTraitsImpl*)self.myDefaultTraits).insetsPaddingFromSafeArea;
}

_MYLAYOUT_PROPERTY_LAYOUTVIEW_SET1(MyLayoutTraitsImpl, UIRectEdge,InsetsPaddingFromSafeArea,insetsPaddingFromSafeArea)


_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, BOOL, InsetLandscapeFringePadding, insetLandscapeFringePadding)


_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, SubviewHSpacing, subviewHSpacing)
_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, SubviewVSpacing, subviewVSpacing)
_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, CGFloat, SubviewSpacing, subviewSpacing)


- (void)setSubviewHSpace:(CGFloat)subviewHSpace {
    self.subviewHSpacing = subviewHSpace;
}

- (CGFloat)subviewHSpace {
    return self.subviewHSpacing;
}

- (void)setSubviewVSpace:(CGFloat)subviewVSpace {
    self.subviewVSpacing = subviewVSpace;
}

- (CGFloat)subviewVSpace {
    return self.subviewVSpacing;
}

- (void)setSubviewSpace:(CGFloat)subviewSpace {
    self.subviewSpacing = subviewSpace;
}

- (CGFloat)subviewSpace {
    return self.subviewSpacing;
}

_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, MyGravity, Gravity, gravity)
_MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(MyLayoutTraitsImpl, BOOL, ReverseLayout, reverseLayout)


- (CGAffineTransform)layoutTransform {
    if (self.myDefaultTraitsInner == nil) {
        return CGAffineTransformIdentity;
    } else {
        return ((MyLayoutTraitsImpl*)self.myDefaultTraits).layoutTransform;
    }
}

- (void)setLayoutTransform:(CGAffineTransform)layoutTransform {
    MyLayoutTraitsImpl *layoutTraits = self.myDefaultTraits;
    if (!CGAffineTransformEqualToTransform(layoutTraits.layoutTransform, layoutTransform)) {
        layoutTraits.layoutTransform = layoutTransform;
        [self setNeedsLayout];
    }
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (MyBorderline *)topBorderline {
    return _borderlineLayerDelegate.topBorderline;
}

- (void)setTopBorderline:(MyBorderline *)topBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    _borderlineLayerDelegate.topBorderline = topBorderline;
}

- (MyBorderline *)leadingBorderline {
    return _borderlineLayerDelegate.leadingBorderline;
}

- (void)setLeadingBorderline:(MyBorderline *)leadingBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    _borderlineLayerDelegate.leadingBorderline = leadingBorderline;
}

- (MyBorderline *)bottomBorderline {
    return _borderlineLayerDelegate.bottomBorderline;
}

- (void)setBottomBorderline:(MyBorderline *)bottomBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    _borderlineLayerDelegate.bottomBorderline = bottomBorderline;
}

- (MyBorderline *)trailingBorderline {
    return _borderlineLayerDelegate.trailingBorderline;
}

- (void)setTrailingBorderline:(MyBorderline *)trailingBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}

- (MyBorderline *)leftBorderline {
    return _borderlineLayerDelegate.leftBorderline;
}

- (void)setLeftBorderline:(MyBorderline *)leftBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    _borderlineLayerDelegate.leftBorderline = leftBorderline;
}

- (MyBorderline *)rightBorderline {
    return _borderlineLayerDelegate.rightBorderline;
}

- (void)setRightBorderline:(MyBorderline *)rightBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    _borderlineLayerDelegate.rightBorderline = rightBorderline;
}

- (void)setBoundBorderline:(MyBorderline *)boundBorderline {
    self.leadingBorderline = boundBorderline;
    self.trailingBorderline = boundBorderline;
    self.topBorderline = boundBorderline;
    self.bottomBorderline = boundBorderline;
}

- (MyBorderline *)boundBorderline {
    return self.bottomBorderline;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        self.layer.contents = (id)_backgroundImage.CGImage;
    }
}

- (void)setCacheEstimatedRect:(BOOL)cacheEstimatedRect {
    _cacheEstimatedRect = cacheEstimatedRect;
    _useCacheRects = NO;
}

- (CGRect)subview:(UIView *)subview estimatedRectInLayoutSize:(CGSize)size {
    if (subview.superview == self) {
        return subview.frame;
    }
    NSMutableArray *subviews = [self.subviews mutableCopy];
    [subviews addObject:subview];

    [self myEstimateLayoutSize:size inSizeClass:MySizeClass_wAny | MySizeClass_hAny subviews:subviews];

    return [subview estimatedRect];
}

- (void)setHighlightedOpacity:(CGFloat)highlightedOpacity {
    if (_touchEventDelegate == nil) {
        _touchEventDelegate = [[MyLayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    _touchEventDelegate.highlightedOpacity = highlightedOpacity;
}

- (CGFloat)highlightedOpacity {
    return _touchEventDelegate.highlightedOpacity;
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    if (_touchEventDelegate == nil) {
        _touchEventDelegate = [[MyLayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    _touchEventDelegate.highlightedBackgroundColor = highlightedBackgroundColor;
}

- (UIColor *)highlightedBackgroundColor {
    return _touchEventDelegate.highlightedBackgroundColor;
}

- (void)setHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage {
    if (_touchEventDelegate == nil) {
        _touchEventDelegate = [[MyLayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    _touchEventDelegate.highlightedBackgroundImage = highlightedBackgroundImage;
}

- (UIImage *)highlightedBackgroundImage {
    return _touchEventDelegate.highlightedBackgroundImage;
}

- (void)setTarget:(id)target action:(SEL)action {
    if (_touchEventDelegate == nil) {
        _touchEventDelegate = [[MyLayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    [_touchEventDelegate setTarget:target action:action];
}

- (void)setTouchDownTarget:(id)target action:(SEL)action {
    if (_touchEventDelegate == nil) {
        _touchEventDelegate = [[MyLayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    [_touchEventDelegate setTouchDownTarget:target action:action];
}

- (void)setTouchCancelTarget:(id)target action:(SEL)action {
    if (_touchEventDelegate == nil) {
        _touchEventDelegate = [[MyLayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    [_touchEventDelegate setTouchCancelTarget:target action:action];
}

- (MyLayoutDragger *)createLayoutDragger {
    MyLayoutDragger *dragger = [MyLayoutDragger new];
    dragger.currentIndex = -1;
    dragger.oldIndex = -1;
    dragger.hasDragging = NO;
    dragger.layout = self;
    return dragger;
}

- (void)setBeginLayoutBlock:(void (^)(void))beginLayoutBlock {
    if (_optionalData == nil) {
        _optionalData = [MyBaseLayoutOptionalData new];
    }
    _optionalData.beginLayoutBlock = beginLayoutBlock;
}

- (void (^)(void))beginLayoutBlock {
    return _optionalData.beginLayoutBlock;
}

- (void)setEndLayoutBlock:(void (^)(void))endLayoutBlock {
    if (_optionalData == nil) {
        _optionalData = [MyBaseLayoutOptionalData new];
    }
    _optionalData.endLayoutBlock = endLayoutBlock;
}

- (void (^)(void))endLayoutBlock {
    return _optionalData.endLayoutBlock;
}

- (void)setRotationToDeviceOrientationBlock:(void (^)(MyBaseLayout *, BOOL, BOOL))rotationToDeviceOrientationBlock {
    if (_optionalData == nil) {
        _optionalData = [MyBaseLayoutOptionalData new];
    }
    _optionalData.rotationToDeviceOrientationBlock = rotationToDeviceOrientationBlock;
}

- (void (^)(MyBaseLayout *, BOOL, BOOL))rotationToDeviceOrientationBlock {
    return _optionalData.rotationToDeviceOrientationBlock;
}

- (void)layoutAnimationWithDuration:(NSTimeInterval)duration {
    [self layoutAnimationWithDuration:duration options:0 completion:nil];
}
- (void)layoutAnimationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^__nullable)(BOOL finished))completion {
    if (_optionalData == nil) {
        _optionalData = [MyBaseLayoutOptionalData new];
    }
    _optionalData.aniDuration = duration;
    _optionalData.aniOptions = options;
    _optionalData.aniCompletion = completion;
}

- (id<MyViewTraits>)fetchLayoutTraitsInSizeClass:(MySizeClass)sizeClass {
    return [super fetchLayoutTraitsInSizeClass:sizeClass];
}

- (id<MyViewTraits>)fetchLayoutTraitsInSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass {
    return [super fetchLayoutTraitsInSizeClass:sizeClass copyFrom:srcSizeClass];
}

- (void)setLayoutTraits:(id<MyViewTraits>)value inSizeClass:(MySizeClass)sizeClass {
    return [super setLayoutTraits:value inSizeClass:sizeClass];
    
}

#pragma mark-- Touches Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_touchEventDelegate touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [_touchEventDelegate touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_touchEventDelegate touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [_touchEventDelegate touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark-- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context {
    //监控非布局父视图的frame的变化，而改变自身的位置和尺寸
    if (context == _myObserverContextC) {
        //只监控父视图的尺寸变换
        CGRect oldRect = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect newRect = [change[NSKeyValueChangeNewKey] CGRectValue];
        if (!_myCGSizeEqual(oldRect.size, newRect.size)) {
            [self myUpdateLayoutRectInNoLayoutSuperview:object];
        }
        return;
    }

    //监控子视图的frame的变化以便重新进行布局
    if (!self.isMyLayouting) {
        if (context == _myObserverContextA) {
            if (!object.myCurrentTraitsInner.useFrame) {
                [self setNeedsLayout];
                //这里添加的原因是有可能子视图取消隐藏后不会绘制自身，所以这里要求子视图重新绘制自身
                if ([keyPath isEqualToString:@"hidden"] && ![change[NSKeyValueChangeNewKey] boolValue]) {
                    [(UIView *)object setNeedsDisplay];
                }
            }
        } else if (context == _myObserverContextB) { //针对UILabel特殊处理。。
            MyViewTraitsImpl *subviewTraits = (MyViewTraitsImpl*)object.myCurrentTraits;
            if (subviewTraits.widthSizeInner.wrapVal || subviewTraits.heightSizeInner.wrapVal) {
                [self setNeedsLayout];
            }
        }
    }
}

#pragma mark-- Override Methods

_MYLAYOUT_PROPERTY_LAYOUTVIEW_SET1(MyLayoutTraitsImpl, BOOL, WrapContentHeight, wrapContentHeight)
_MYLAYOUT_PROPERTY_LAYOUTVIEW_SET1(MyLayoutTraitsImpl, BOOL, WrapContentWidth, wrapContentWidth)

- (void)setWrapContentSize:(BOOL)wrapContentSize {
    MyLayoutTraitsImpl *layoutTraits = self.myDefaultTraits;
    layoutTraits.wrapContentSize = wrapContentSize;
    [self setNeedsLayout];
}

- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray *)subviewEngines context:(MyLayoutContext *)context {
    if (context->isEstimate) {
        context->selfSize = size;
    } else {
        context->selfSize = self.bounds.size;
        if (size.width != 0) {
            context->selfSize.width = size.width;
        }
        if (size.height != 0) {
            context->selfSize.height = size.height;
        }
    }
    
    MyLayoutTraitsImpl *layoutTraits = context->layoutViewEngine.currentTraits;
    context->paddingTop = layoutTraits.myLayoutPaddingTop;
    context->paddingBottom = layoutTraits.myLayoutPaddingBottom;
    context->paddingLeading = layoutTraits.myLayoutPaddingLeading;
    context->paddingTrailing = layoutTraits.myLayoutPaddingTrailing;
    context->vertGravity = MYVERTGRAVITY(layoutTraits.gravity);
    context->horzGravity = [MyViewTraitsImpl convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(layoutTraits.gravity)];
    context->vertSpacing = layoutTraits.subviewVSpacing;
    context->horzSpacing = layoutTraits.subviewHSpacing;
    if (context->subviewEngines == nil) {
        context->subviewEngines = [layoutTraits filterEngines:subviewEngines];
    }

    return context->selfSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self sizeThatFits:size inSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}

- (CGSize)sizeThatFits:(CGSize)size inSizeClass:(MySizeClass)sizeClass {
    return [self myEstimateLayoutSize:size inSizeClass:sizeClass subviews:nil];
}

- (void)setHidden:(BOOL)hidden {
    if (self.isHidden == hidden) {
        return;
    }
    [super setHidden:hidden];
    UIView *superview = self.superview;
    if ([superview isKindOfClass:[MyBaseLayout class]]) {
        if (!((MyBaseLayout *)superview).isMyLayouting) {
            [superview setNeedsLayout];
        }
    }
    if (hidden == NO) {
        [_borderlineLayerDelegate setNeedsLayoutIn:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) withLayer:self.layer];
    }
}

- (void)setCenter:(CGPoint)center {
    CGPoint oldCenter = self.center;
    [super setCenter:center];
    UIView *superview = self.superview;
    if (!CGPointEqualToPoint(oldCenter, center) && [superview isKindOfClass:[MyBaseLayout class]]) {
        if (!((MyBaseLayout *)superview).isMyLayouting) {
            [superview setNeedsLayout];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    CGRect oldFrame = self.frame;
    [super setFrame:frame];
    UIView *superview = self.superview;
    if (!CGRectEqualToRect(oldFrame, frame) && [superview isKindOfClass:[MyBaseLayout class]]) {
        if (!((MyBaseLayout *)superview).isMyLayouting) {
            [superview setNeedsLayout];
        }
    }
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];

    if ([subview isKindOfClass:[MyBaseLayout class]]) {
        ((MyBaseLayout *)subview).cacheEstimatedRect = self.cacheEstimatedRect;
    }

    [self myInvalidateIntrinsicContentSize];
}

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];

    [self myRemoveSubviewObserver:subview];

    [self myInvalidateIntrinsicContentSize];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow == nil) {
        //这里处理可能因为触摸事件被强行终止而导致的背景色无法恢复的问题。
        [_touchEventDelegate myResetTouchHighlighted2];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    MyLayoutTraitsImpl *layoutTraits = self.myCurrentTraits;

    //特殊处理如果视图是控制器根视图则取消高度或者宽度包裹,安全区padding的缩进, 以及adjustScrollViewContentSizeMode的设置。
    //但是有一种特殊情况是控制器是子视图控制器。因此还需要添加判断父视图是否是非布局父视图，只有是非布局父视图下才将自适应设置清除
    @try {

        if (newSuperview != nil) {
            UIRectEdge defRectEdge = UIRectEdgeLeft | UIRectEdgeRight;
            id vc = [self valueForKey:@"viewDelegate"];
            if (vc != nil) {
                if (![newSuperview isKindOfClass:[MyBaseLayout class]]) {
                    if (layoutTraits.widthSizeInner.wrapVal) {
                        [layoutTraits.widthSizeInner _myEqualTo:nil];
                    }
                    if (layoutTraits.heightSizeInner.wrapVal) {
                        [layoutTraits.heightSizeInner _myEqualTo:nil];
                    }
                }

                if (layoutTraits.insetsPaddingFromSafeArea == defRectEdge) {
                    layoutTraits.insetsPaddingFromSafeArea = ~UIRectEdgeTop;
                }
                self.adjustScrollViewContentSizeMode = MyAdjustScrollViewContentSizeModeNo;
            }

            //如果布局视图的父视图是滚动视图并且是非UITableView和UICollectionView的话。将默认叠加除顶部外的安全区域。
            if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]]) {
                if (layoutTraits.insetsPaddingFromSafeArea == defRectEdge) {
                    layoutTraits.insetsPaddingFromSafeArea = ~UIRectEdgeTop;
                }
            }
        }

    } @catch (NSException *exception) {
    }

    //将要添加到父视图时，如果不是MyLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
    if (newSuperview != nil && ![newSuperview isKindOfClass:[MyBaseLayout class]]) {

#ifdef DEBUG

        if (layoutTraits.leadingPosInner.anchorVal != nil) {
            //约束冲突：左边距依赖的视图不是父视图
            NSCAssert(layoutTraits.leadingPosInner.anchorVal.view == newSuperview, @"Constraint exception!! %@leading pos dependent on:%@is not superview", self, layoutTraits.leadingPosInner.anchorVal.view);
        }

        if (layoutTraits.trailingPosInner.anchorVal != nil) {
            //约束冲突：右边距依赖的视图不是父视图
            NSCAssert(layoutTraits.trailingPosInner.anchorVal.view == newSuperview, @"Constraint exception!! %@trailing pos dependent on:%@is not superview", self, layoutTraits.trailingPosInner.anchorVal.view);
        }

        if (layoutTraits.centerXPosInner.anchorVal != nil) {
            //约束冲突：水平中心点依赖的视图不是父视图
            NSCAssert(layoutTraits.centerXPosInner.anchorVal.view == newSuperview, @"Constraint exception!! %@horizontal center pos dependent on:%@is not superview", self, layoutTraits.centerXPosInner.anchorVal.view);
        }

        if (layoutTraits.topPosInner.anchorVal != nil) {
            //约束冲突：上边距依赖的视图不是父视图
            NSCAssert(layoutTraits.topPosInner.anchorVal.view == newSuperview, @"Constraint exception!! %@top pos dependent on:%@is not superview", self, layoutTraits.topPosInner.anchorVal.view);
        }

        if (layoutTraits.bottomPosInner.anchorVal != nil) {
            //约束冲突：下边距依赖的视图不是父视图
            NSCAssert(layoutTraits.bottomPosInner.anchorVal.view == newSuperview, @"Constraint exception!! %@bottom pos dependent on:%@is not superview", self, layoutTraits.bottomPosInner.anchorVal.view);
        }

        if (layoutTraits.centerYPosInner.anchorVal != nil) {
            //约束冲突：垂直中心点依赖的视图不是父视图
            NSCAssert(layoutTraits.centerYPosInner.anchorVal.view == newSuperview, @"Constraint exception!! vertical center pos dependent on:%@is not superview", layoutTraits.centerYPosInner.anchorVal.view);
        }

        if (layoutTraits.widthSizeInner.anchorVal != nil) {
            //约束冲突：宽度依赖的视图不是父视图
            NSCAssert(layoutTraits.widthSizeInner.anchorVal.view == newSuperview, @"Constraint exception!! %@width dependent on:%@is not superview", self, layoutTraits.widthSizeInner.anchorVal.view);
        }

        if (layoutTraits.heightSizeInner.anchorVal != nil) {
            //约束冲突：高度依赖的视图不是父视图
            NSCAssert(layoutTraits.heightSizeInner.anchorVal.view == newSuperview, @"Constraint exception!! %@height dependent on:%@is not superview", self, layoutTraits.heightSizeInner.anchorVal.view);
        }

#endif
        if ([self myUpdateLayoutRectInNoLayoutSuperview:newSuperview]) {
            //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃

            //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
            //然后在左边将异常断点清除即可

            if (_isAddSuperviewKVO && self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]]) {
                @try {
                    [self.superview removeObserver:self forKeyPath:@"frame"];
                }@catch (NSException *exception) {
                }
                
                @try {
                    [self.superview removeObserver:self forKeyPath:@"bounds"];
                }@catch (NSException *exception) {
                }
            }

            [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_myObserverContextC];
            [newSuperview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_myObserverContextC];
            _isAddSuperviewKVO = YES;
        }
    }

    if (_isAddSuperviewKVO && newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]]) {
        //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
        //然后在左边将异常断点清除即可
        _isAddSuperviewKVO = NO;
        @try {
            [self.superview removeObserver:self forKeyPath:@"frame"];
        }@catch (NSException *exception) {
        }
        
        @try {
            [self.superview removeObserver:self forKeyPath:@"bounds"];
        }@catch (NSException *exception) {
        }
    }

    if (newSuperview != nil) {
        //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
        if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]]) {
            if (self.adjustScrollViewContentSizeMode == MyAdjustScrollViewContentSizeModeAuto) {
                //这里预先设置一下contentSize主要是为了解决contentOffset在后续计算contentSize的偏移错误的问题。
                [UIView performWithoutAnimation:^{
                    UIScrollView *scrollSuperView = (UIScrollView *)newSuperview;
                    if (CGSizeEqualToSize(scrollSuperView.contentSize, CGSizeZero)) {
                        CGSize screenSize = [UIScreen mainScreen].bounds.size;
                        scrollSuperView.contentSize = CGSizeMake(0, screenSize.height + 0.1);
                    }
                }];

                self.adjustScrollViewContentSizeMode = MyAdjustScrollViewContentSizeModeYes;
            }
        }
    } else {
        _optionalData.aniDuration = 0.0;
        _optionalData.beginLayoutBlock = nil;
        _optionalData.endLayoutBlock = nil;
        if (_optionalData.rotationToDeviceOrientationBlock == nil) {
            _optionalData = nil;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    if (self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]]) {
        [self myUpdateLayoutRectInNoLayoutSuperview:self.superview];
    }
}

- (void)safeAreaInsetsDidChange {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

    [super safeAreaInsetsDidChange];
#endif
    
    MyViewTraitsImpl *viewTraits = self.myCurrentTraitsInner;

    if (self.superview != nil &&
        ![self.superview isKindOfClass:[MyBaseLayout class]] &&
        (viewTraits.leadingPosInner.isSafeAreaPos ||
         viewTraits.trailingPosInner.isSafeAreaPos ||
         viewTraits.topPosInner.isSafeAreaPos ||
         viewTraits.bottomPosInner.isSafeAreaPos)) {
        if (!self.isMyLayouting) {
            self.isMyLayouting = YES;
            [self myUpdateLayoutRectInNoLayoutSuperview:self.superview];
            self.isMyLayouting = NO;
        }
    }
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self myInvalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    MyViewTraitsImpl *viewTraits = self.myCurrentTraitsInner;
    if (self.translatesAutoresizingMaskIntoConstraints == NO && (viewTraits.widthSizeInner.wrapVal || viewTraits.heightSizeInner.wrapVal)) {
        if (viewTraits.widthSizeInner.wrapVal && viewTraits.heightSizeInner.wrapVal) {
            size = [self sizeThatFits:CGSizeZero];
        } else if (viewTraits.widthSizeInner.wrapVal) {
            //动态宽度
            NSLayoutConstraint *heightConstraint = nil;
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight) {
                    heightConstraint = constraint;
                    break;
                }
            }

            if (heightConstraint == nil) {
                for (NSLayoutConstraint *constraint in self.superview.constraints) {
                    if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight) {
                        heightConstraint = constraint;
                        break;
                    }
                }
            }

            if (heightConstraint != nil) {
                CGFloat dependHeight = UIViewNoIntrinsicMetric;
                if ([heightConstraint.secondItem isKindOfClass:[UIView class]]) {
                    UIView *dependView = (UIView *)heightConstraint.secondItem;
                    CGRect dependViewRect = dependView.bounds;
                    if (heightConstraint.secondAttribute == NSLayoutAttributeHeight) {
                        dependHeight = CGRectGetHeight(dependViewRect);
                    }

                    else if (heightConstraint.secondAttribute == NSLayoutAttributeWidth) {
                        dependHeight = CGRectGetWidth(dependViewRect);
                    }

                    else {
                        dependHeight = UIViewNoIntrinsicMetric;
                    }
                } else if (heightConstraint.secondItem == nil) {
                    dependHeight = 0;
                }
                if (dependHeight != UIViewNoIntrinsicMetric) {
                    dependHeight *= heightConstraint.multiplier;
                    dependHeight += heightConstraint.constant;
                    size.width = [self sizeThatFits:CGSizeMake(0, dependHeight)].width;
                }
            }
        } else {
            //动态高度
            NSLayoutConstraint *widthConstraint = nil;
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth) {
                    widthConstraint = constraint;
                    break;
                }
            }

            if (widthConstraint == nil) {
                for (NSLayoutConstraint *constraint in self.superview.constraints) {
                    if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth) {
                        widthConstraint = constraint;
                        break;
                    }
                }
            }

            CGFloat dependWidth = UIViewNoIntrinsicMetric;
            if (widthConstraint != nil) {
                if ([widthConstraint.secondItem isKindOfClass:[UIView class]]) {
                    UIView *dependView = (UIView *)widthConstraint.secondItem;
                    CGRect dependViewRect = dependView.bounds;
                    if (widthConstraint.secondAttribute == NSLayoutAttributeWidth) {
                        dependWidth = CGRectGetWidth(dependViewRect);
                    }

                    else if (widthConstraint.secondAttribute == NSLayoutAttributeHeight) {
                        dependWidth = CGRectGetHeight(dependViewRect);
                    } else {
                        dependWidth = UIViewNoIntrinsicMetric;
                    }
                } else if (widthConstraint.secondItem == nil) {
                    dependWidth = 0;
                }
                if (dependWidth != UIViewNoIntrinsicMetric) {
                    dependWidth *= widthConstraint.multiplier;
                    dependWidth += widthConstraint.constant;
                    size.height = [self sizeThatFits:CGSizeMake(dependWidth, 0)].height;
                }
            }
        }
    }
    return size;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    return [self sizeThatFits:targetSize];
}

- (void)doLayoutSubviews {
    int currentScreenOrientation = 0;

    if (!self.isMyLayouting) {
        self.isMyLayouting = YES;

        if (self.priorAutoresizingMask) {
            [super layoutSubviews];
        }
        //减少每次调用就计算设备方向以及sizeclass的次数。
        MySizeClass sizeClass = [self myGetGlobalSizeClass];
        if ((sizeClass & 0xF0) == MySizeClass_Portrait) {
            currentScreenOrientation = 1;
        } else if ((sizeClass & 0xF0) == MySizeClass_Landscape) {
            currentScreenOrientation = 2;
        }
        //得到当前布局视图和子视图的最佳的sizeClass
        MyLayoutEngine *layoutViewEngine = self.myEngine;
        layoutViewEngine.currentTraits = [layoutViewEngine fetchView:self bestTraitsAt:sizeClass];
        
        NSMutableArray<MyLayoutEngine *> *subviewEngines = [NSMutableArray arrayWithCapacity:self.subviews.count];
        for (UIView *subview in self.subviews) {
            MyLayoutEngine *subviewEngine = subview.myEngine;
            subviewEngine.currentTraits = [subviewEngine fetchView:subview bestTraitsAt:sizeClass];
            
            if (!subviewEngine.hasObserver && subviewEngine.currentTraits != nil && !subviewEngine.currentTraits.useFrame) {
                subviewEngine.hasObserver = YES;
                [self myAddSubviewObserver:subview];
            }
            
            [subviewEngines addObject:subviewEngine];
        }

        MyLayoutTraitsImpl *layoutTraits = layoutViewEngine.currentTraits;

        //计算布局
        CGSize oldSelfSize = self.bounds.size;
        CGSize newSelfSize;
        if (_useCacheRects && layoutViewEngine.width != CGFLOAT_MAX && layoutViewEngine.height != CGFLOAT_MAX) {
            newSelfSize = CGSizeMake(layoutViewEngine.width, layoutViewEngine.height);
        } else {
            
            MyLayoutContext context;
            context.isEstimate = NO;
            context.sizeClass = sizeClass;
            context.layoutViewEngine = layoutViewEngine;
            context.selfSize = oldSelfSize;
    
            newSelfSize = [self calcLayoutSize:[self myCalcSizeInNoLayoutSuperview:self.superview currentSize:oldSelfSize] subviewEngines:subviewEngines context:&context];
        }

        newSelfSize = _myCGSizeRound(newSelfSize);
        _useCacheRects = NO;

        static CGFloat sSizeError = 0;
        if (sSizeError == 0) {
            sSizeError = 1 / [UIScreen mainScreen].scale + 0.0001; //误差量。
        }
        //设置子视图的frame并还原
        for (UIView *subview in self.subviews) {
            CGRect sbvOldBounds = subview.bounds;
            CGPoint sbvOldCenter = subview.center;

            MyLayoutEngine *subviewEngine = subview.myEngine;
            MyViewTraitsImpl *subviewTraits = subviewEngine.currentTraits;

            if (subviewEngine.leading != CGFLOAT_MAX && subviewEngine.top != CGFLOAT_MAX && !subviewTraits.noLayout && !subviewTraits.useFrame) {
                if (subviewEngine.width < 0) {
                    subviewEngine.width = 0;
                }
                if (subviewEngine.height < 0) {
                    subviewEngine.height = 0;
                }
                //这里的位置需要进行有效像素的舍入处理，否则可能出现文本框模糊，以及视图显示可能多出一条黑线的问题。
                //原因是当frame中的值不能有效的转化为最小可绘制的物理像素时就会出现模糊，虚化，多出黑线，以及layer处理圆角不圆的情况。
                //所以这里要将frame中的点转化为有效的点。
                //这里之所以将布局子视图的转化方法和一般子视图的转化方法区分开来是因为我们要保证布局子视图不能出现细微的重叠，因为布局子视图有边界线
                //如果有边界线而又出现细微重叠的话，那么边界线将无法正常显示，因此这里做了一个特殊的处理。
                CGRect rect;
                if ([subview isKindOfClass:[MyBaseLayout class]]) {
                    rect = _myLayoutCGRectRound(subviewEngine.frame);

                    CGRect subviewTempBounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, rect.size.width, rect.size.height);

                    if (_myCGFloatErrorEqual(subviewTempBounds.size.width, sbvOldBounds.size.width, sSizeError)) {
                        subviewTempBounds.size.width = sbvOldBounds.size.width;
                    }
                    if (_myCGFloatErrorEqual(subviewTempBounds.size.height, sbvOldBounds.size.height, sSizeError)) {
                        subviewTempBounds.size.height = sbvOldBounds.size.height;
                    }
                    if (_myCGFloatErrorNotEqual(subviewTempBounds.size.width, sbvOldBounds.size.width, sSizeError) ||
                        _myCGFloatErrorNotEqual(subviewTempBounds.size.height, sbvOldBounds.size.height, sSizeError)) {
                        subview.bounds = subviewTempBounds;
                    }
                    CGPoint subviewTempCenter = CGPointMake(rect.origin.x + subview.layer.anchorPoint.x * subviewTempBounds.size.width, rect.origin.y + subview.layer.anchorPoint.y * subviewTempBounds.size.height);

                    if (_myCGFloatErrorEqual(subviewTempCenter.x, sbvOldCenter.x, sSizeError)) {
                        subviewTempCenter.x = sbvOldCenter.x;
                    }
                    if (_myCGFloatErrorEqual(subviewTempCenter.y, sbvOldCenter.y, sSizeError)) {
                        subviewTempCenter.y = sbvOldCenter.y;
                    }
                    if (_myCGFloatErrorNotEqual(subviewTempCenter.x, sbvOldCenter.x, sSizeError) ||
                        _myCGFloatErrorNotEqual(subviewTempCenter.y, sbvOldCenter.y, sSizeError)) {
                        subview.center = subviewTempCenter;
                    }
                } else {
                    rect = _myCGRectRound(subviewEngine.frame);
                    subview.center = CGPointMake(rect.origin.x + subview.layer.anchorPoint.x * rect.size.width, rect.origin.y + subview.layer.anchorPoint.y * rect.size.height);
                    subview.bounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, rect.size.width, rect.size.height);
                }
            }

            if (subviewTraits.visibility == MyVisibility_Gone && !subview.isHidden) {
                subview.bounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, 0, 0);
            }
            if (subviewEngine.viewLayoutCompleteBlock != nil) {
                subviewEngine.viewLayoutCompleteBlock(self, subview);
                subviewEngine.viewLayoutCompleteBlock = nil;
            }

            [subviewEngine reset];
        }

        if (newSelfSize.width != CGFLOAT_MAX && (layoutTraits.widthSizeInner.wrapVal || layoutTraits.heightSizeInner.wrapVal)) {
            //因为布局子视图的新老尺寸计算在上面有两种不同的方法，因此这里需要考虑两种计算的误差值，而这两种计算的误差值是不超过1/屏幕精度的。
            //因此我们认为当二者的值超过误差时我们才认为有尺寸变化。
            BOOL isWidthAlter = _myCGFloatErrorNotEqual(newSelfSize.width, oldSelfSize.width, sSizeError);
            BOOL isHeightAlter = _myCGFloatErrorNotEqual(newSelfSize.height, oldSelfSize.height, sSizeError);

            //如果父视图也是布局视图，并且自己隐藏则不调整自身的尺寸和位置。
            BOOL isAdjustSelf = YES;
            if (self.superview != nil && [self.superview isKindOfClass:[MyBaseLayout class]]) {
                if ([self.myCurrentTraits invalid]) {
                    isAdjustSelf = NO;
                }
            }
            if (isAdjustSelf && (isWidthAlter || isHeightAlter)) {
                if (newSelfSize.width < 0) {
                    newSelfSize.width = 0;
                }

                if (newSelfSize.height < 0) {
                    newSelfSize.height = 0;
                }
                if (CGAffineTransformIsIdentity(self.transform)) {
                    CGRect currentFrame = self.frame;
                    if (isWidthAlter && layoutTraits.widthSizeInner.wrapVal) {
                        currentFrame.size.width = newSelfSize.width;
                    }
                    if (isHeightAlter && layoutTraits.heightSizeInner.wrapVal) {
                        currentFrame.size.height = newSelfSize.height;
                    }
                    self.frame = currentFrame;
                } else {
                    CGRect currentBounds = self.bounds;
                    CGPoint currentCenter = self.center;

                    //针对滚动父视图做特殊处理，如果父视图是滚动视图，而且当前的缩放比例不为1时系统会调整中心点的位置，因此这里需要特殊处理。
                    CGFloat superViewZoomScale = 1.0;
                    if ([self.superview isKindOfClass:[UIScrollView class]]) {
                        superViewZoomScale = ((UIScrollView *)self.superview).zoomScale;
                    }
                    if (isWidthAlter && layoutTraits.widthSizeInner.wrapVal) {
                        currentBounds.size.width = newSelfSize.width;
                        currentCenter.x += (newSelfSize.width - oldSelfSize.width) * self.layer.anchorPoint.x * superViewZoomScale;
                    }
                    if (isHeightAlter && layoutTraits.heightSizeInner.wrapVal) {
                        currentBounds.size.height = newSelfSize.height;
                        currentCenter.y += (newSelfSize.height - oldSelfSize.height) * self.layer.anchorPoint.y * superViewZoomScale;
                    }
                    self.bounds = currentBounds;
                    self.center = currentCenter;
                }
            }
        }

        //这里只用width判断的原因是如果newSelfSize被计算成功则size中的所有值都不是CGFLOAT_MAX，所以这里选width只是其中一个代表。
        if (newSelfSize.width != CGFLOAT_MAX) {
            UIView *superview = self.superview;
            //更新边界线。
            if (_borderlineLayerDelegate != nil) {
                CGRect borderlineRect = CGRectMake(0, 0, newSelfSize.width, newSelfSize.height);
                if ([superview isKindOfClass:[MyBaseLayout class]]) {
                    //这里给父布局视图一个机会来可以改变当前布局的borderlineRect的值，也就是显示的边界线有可能会超出当前布局视图本身的区域。
                    //比如一些表格或者其他的情况。默认情况下这个函数什么也不做。
                    [((MyBaseLayout *)superview) myHookSublayout:self borderlineRect:&borderlineRect];
                }

                [_borderlineLayerDelegate setNeedsLayoutIn:borderlineRect withLayer:self.layer];
            }
            //如果自己的父视图是非UIScrollView以及非布局视图。以及自己的宽度或者高度是包裹的，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
            if (superview != nil && ![superview isKindOfClass:[MyBaseLayout class]]) {
                CGPoint centerPonintSelf = self.center;
                CGRect rectSelf = self.bounds;
                CGRect rectSuper = superview.bounds;

                //特殊处理低版本下的top和bottom的两种安全区域的场景。
                if ((layoutTraits.topPosInner.isSafeAreaPos || layoutTraits.bottomPosInner.isSafeAreaPos) && [UIDevice currentDevice].systemVersion.doubleValue < 11) {
                    if (layoutTraits.topPosInner.isSafeAreaPos) {
                        centerPonintSelf.y = [layoutTraits.topPosInner measureWith:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                    } else {
                        centerPonintSelf.y = rectSuper.size.height - rectSelf.size.height - [layoutTraits.bottomPosInner measureWith:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                    }
                }

                //如果自己的父视图是非UIScrollView以及非布局视图。以及自己的宽度或者高度是包裹的时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
                if (![superview isKindOfClass:[UIScrollView class]] && (layoutTraits.widthSizeInner.wrapVal || layoutTraits.heightSizeInner.wrapVal)) {

                    if ([MyBaseLayout isRTL]) {
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                    }
                    if (layoutTraits.widthSizeInner.wrapVal) {
                        //如果只设置了右边，或者只设置了居中则更新位置。。
                        if (layoutTraits.centerXPosInner.val != nil) {
                            centerPonintSelf.x = (rectSuper.size.width - rectSelf.size.width) / 2 + self.layer.anchorPoint.x * rectSelf.size.width;

                            centerPonintSelf.x += [layoutTraits.centerXPosInner measureWith:rectSuper.size.width];
                        } else if (layoutTraits.trailingPosInner.val != nil && layoutTraits.leadingPosInner.val == nil) {
                            centerPonintSelf.x = rectSuper.size.width - rectSelf.size.width - [layoutTraits.trailingPosInner measureWith:rectSuper.size.width] + self.layer.anchorPoint.x * rectSelf.size.width;
                        }
                    }

                    if (layoutTraits.heightSizeInner.wrapVal) {
                        if (layoutTraits.centerYPosInner.val != nil) {
                            centerPonintSelf.y = (rectSuper.size.height - rectSelf.size.height) / 2 + [layoutTraits.centerYPosInner measureWith:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        } else if (layoutTraits.bottomPosInner.val != nil && layoutTraits.topPosInner.val == nil) {
                            //这里可能有坑，在有安全区时。但是先不处理了。
                            centerPonintSelf.y = rectSuper.size.height - rectSelf.size.height - [layoutTraits.bottomPosInner measureWith:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                    }

                    if ([MyBaseLayout isRTL]) {
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                    }
                }

                //如果有变化则只调整自己的center。而不变化
                if (!_myCGPointEqual(self.center, centerPonintSelf)) {
                    self.center = centerPonintSelf;
                }
            }

            //这里处理当布局视图的父视图是非布局父视图，且父视图具有wrap属性时需要调整父视图的尺寸。
            if (superview != nil && ![superview isKindOfClass:[MyBaseLayout class]]) {
                MyViewTraitsImpl *superviewTraits = superview.myCurrentTraitsInner;
                if (superviewTraits.heightSizeInner.wrapVal || superviewTraits.widthSizeInner.wrapVal) {
                    //调整父视图的高度和宽度。frame值。
                    CGRect superBounds = superview.bounds;
                    CGPoint superCenter = superview.center;

                    if (superviewTraits.heightSizeInner.wrapVal) {
                        superBounds.size.height = [self myValidMeasure:superviewTraits.heightSizeInner subview:superview calcSize:layoutTraits.myTop + newSelfSize.height + layoutTraits.myBottom subviewSize:superBounds.size selfLayoutSize:newSelfSize];
                        superCenter.y += (superBounds.size.height - superview.bounds.size.height) * superview.layer.anchorPoint.y;
                    }

                    if (superviewTraits.widthSizeInner.wrapVal) {
                        superBounds.size.width = [self myValidMeasure:superviewTraits.widthSizeInner subview:superview calcSize:layoutTraits.myLeading + newSelfSize.width + layoutTraits.myTrailing subviewSize:superBounds.size selfLayoutSize:newSelfSize];
                        superCenter.x += (superBounds.size.width - superview.bounds.size.width) * superview.layer.anchorPoint.x;
                    }

                    if (!_myCGRectEqual(superview.bounds, superBounds)) {
                        superview.center = superCenter;
                        superview.bounds = superBounds;
                    }
                }
            }

            //处理父视图是滚动视图时动态调整滚动视图的contentSize
            [self myLayout:layoutTraits adjustScrollViewContentWithSize:newSelfSize];
        }

        self.isMyLayouting = NO;
    }

    //执行屏幕旋转的处理逻辑。
    if (currentScreenOrientation != 0 && _optionalData.rotationToDeviceOrientationBlock != nil) {
        if (_optionalData.lastScreenOrientation == 0) {
            _optionalData.lastScreenOrientation = currentScreenOrientation;
            _optionalData.rotationToDeviceOrientationBlock(self, YES, currentScreenOrientation == 1);
        } else {
            if (_optionalData.lastScreenOrientation != currentScreenOrientation) {
                _optionalData.lastScreenOrientation = currentScreenOrientation;
                _optionalData.rotationToDeviceOrientationBlock(self, NO, currentScreenOrientation == 1);
            }
        }
        _optionalData.lastScreenOrientation = currentScreenOrientation;
    }
}

- (void)layoutSubviews {
    if (!self.autoresizesSubviews) {
        return;
    }
    if (_optionalData.beginLayoutBlock != nil) {
        _optionalData.beginLayoutBlock();
        _optionalData.beginLayoutBlock = nil;
    }

    if (_optionalData == nil || _optionalData.aniDuration <= 0) {
        [self doLayoutSubviews];
    } else {
        [UIView animateWithDuration:_optionalData.aniDuration
                              delay:0
                            options:_optionalData.aniOptions
                         animations:^{
                             [self doLayoutSubviews];
                         }
                         completion:_optionalData.aniCompletion];

        _optionalData.aniDuration = 0.0;
        _optionalData.aniCompletion = nil;
    }

    if (_optionalData.endLayoutBlock != nil) {
        _optionalData.endLayoutBlock();
        _optionalData.endLayoutBlock = nil;
    }

    //因为rotationToDeviceOrientationBlock设置后不会在内部被清除，而其他的都会被清除。
    //所有只要rotationToDeviceOrientationBlock为空就可以将可选的多余数据给清除掉了。
    if (_optionalData != nil && _optionalData.rotationToDeviceOrientationBlock == nil) {
        _optionalData = nil;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    BOOL canUpdateBorderlineColor = NO;
    if (@available(iOS 13.0, *)) {
        canUpdateBorderlineColor = [self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection];
    } else if (@available(iOS 12.0, *)) {
        canUpdateBorderlineColor = (self.traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle);
    } else {
        // Fallback on earlier versions
    }
    
    if (canUpdateBorderlineColor) {
        [_borderlineLayerDelegate updateAllBorderlineColor];
    }
}

#pragma mark-- Private Methods

- (Class) myTratisClass {
    return [MyLayoutTraitsImpl class];
}

- (MyLayoutEngine *)myEngine {
    if (_myEngine == nil) {
        _myEngine = [[MyLayoutEngine alloc] initWithTraitsClass:[self myTratisClass]];
    }
    return _myEngine;
}

- (MyLayoutEngine *)myEngineInner {
    return _myEngine;
}

- (CGSize)myEstimateLayoutSize:(CGSize)size inSizeClass:(MySizeClass)sizeClass subviews:(NSMutableArray<UIView *> *)subviews {
    
    NSArray *tuple = [self myUpdateCurrentSizeClass:sizeClass subviews:subviews];
    MyLayoutEngine *layoutViewEngine = tuple.firstObject;
    NSMutableArray<MyLayoutEngine *> *subviewEngines = tuple.lastObject;
    
    
    
    MyLayoutContext context;
    context.isEstimate = YES;
    context.sizeClass = sizeClass;
    context.layoutViewEngine = layoutViewEngine;
    
    if (layoutViewEngine.currentTraits.widthSizeInner.numberVal != nil) {
        size.width = MAX(layoutViewEngine.currentTraits.widthSizeInner.measure, size.width);
    }
    
    if (layoutViewEngine.currentTraits.heightSizeInner.numberVal != nil) {
        size.height = MAX(layoutViewEngine.currentTraits.heightSizeInner.measure, size.height);
    }
    
    CGSize selfSize = [self calcLayoutSize:size subviewEngines:subviewEngines context:&context];
    
    layoutViewEngine.width = selfSize.width;
    layoutViewEngine.height = selfSize.height;
    
    if (self.cacheEstimatedRect) {
        _useCacheRects = YES;
    }
    return  _myCGSizeRound(selfSize);
}

- (CGFloat)myCalcSubview:(MyLayoutEngine *)subviewEngine
             vertGravity:(MyGravity)vertGravity
             baselinePos:(CGFloat)baselinePos
                 withContext:(MyLayoutContext *)context {
    
    MyViewTraitsImpl *subviewTraits = subviewEngine.currentTraits;
    UIView *subview = subviewTraits.view;
    CGFloat layoutViewContentHeight = context->selfSize.height - context->paddingTop - context->paddingBottom;

    CGFloat marginTop = [self myValidMargin:subviewTraits.topPosInner subview:subview calcPos:[subviewTraits.topPosInner measureWith:layoutViewContentHeight] selfLayoutSize:context->selfSize];
    CGFloat marginCenter = [self myValidMargin:subviewTraits.centerYPosInner subview:subview calcPos:[subviewTraits.centerYPosInner measureWith:layoutViewContentHeight] selfLayoutSize:context->selfSize];
    CGFloat marginBottom = [self myValidMargin:subviewTraits.bottomPosInner subview:subview calcPos:[subviewTraits.bottomPosInner measureWith:layoutViewContentHeight] selfLayoutSize:context->selfSize];

    //垂直压缩。
    CGFloat fixedHeight = marginTop + marginCenter + marginBottom + subviewEngine.height;
    if (fixedHeight > context->selfSize.height) {
        CGFloat spareHeight = context->selfSize.height - fixedHeight;
        CGFloat totalShrink = subviewTraits.topPosInner.shrink + subviewTraits.centerYPosInner.shrink + subviewTraits.bottomPosInner.shrink + subviewTraits.heightSizeInner.shrink;
        if (totalShrink != 0.0) {
            marginTop += (subviewTraits.topPosInner.shrink / totalShrink) * spareHeight;
            marginCenter += (subviewTraits.centerYPosInner.shrink / totalShrink) * spareHeight;
            marginBottom += (subviewTraits.bottomPosInner.shrink / totalShrink) * spareHeight;
            subviewEngine.height += (subviewTraits.heightSizeInner.shrink / totalShrink) * spareHeight;
        }
    }

    //如果是设置垂直拉伸则，如果子视图有约束则不受影响，否则就变为和填充一个意思。
    if (vertGravity == MyGravity_Vert_Stretch) {
        if (subviewTraits.heightSizeInner.val != nil && subviewTraits.heightSizeInner.priority != MyPriority_Low) {
            vertGravity = MyGravity_Vert_Top;
        } else {
            vertGravity = MyGravity_Vert_Fill;
        }
    }

    //确保设置基线对齐的视图都是UILabel,UITextField,UITextView
    if (baselinePos == CGFLOAT_MAX && vertGravity == MyGravity_Vert_Baseline) {
        vertGravity = MyGravity_Vert_Top;
    }
    UIFont *subviewFont = nil;
    if (vertGravity == MyGravity_Vert_Baseline) {
        subviewFont = [self myGetSubviewFont:subview];
    }
    if (subviewFont == nil && vertGravity == MyGravity_Vert_Baseline) {
        vertGravity = MyGravity_Vert_Top;
    }

    if (vertGravity == MyGravity_Vert_Top) {
        subviewEngine.top = context->paddingTop + marginTop;
    } else if (vertGravity == MyGravity_Vert_Bottom) {
        subviewEngine.top = context->selfSize.height - context->paddingBottom - marginBottom - subviewEngine.height;
    } else if (vertGravity == MyGravity_Vert_Baseline) {
        //得到基线位置。
        subviewEngine.top = baselinePos - subviewFont.ascender - (subviewEngine.height - subviewFont.lineHeight) / 2;
    } else if (vertGravity == MyGravity_Vert_Fill) {
        subviewEngine.top = context->paddingTop + marginTop;
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subview calcSize:layoutViewContentHeight - marginTop - marginBottom subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
    } else if (vertGravity == MyGravity_Vert_Center) {
        subviewEngine.top = (layoutViewContentHeight - marginTop - marginBottom - subviewEngine.height) / 2 + context->paddingTop + marginTop + marginCenter;
    } else if (vertGravity == MyGravity_Vert_Window_Center) {
        if (self.window != nil) {
            subviewEngine.top = (CGRectGetHeight(self.window.bounds) - marginTop - marginBottom - subviewEngine.height) / 2 + marginTop + marginCenter;
            subviewEngine.top = [self.window convertPoint:subviewEngine.origin toView:self].y;
        }
    }
    return marginTop + marginCenter + marginBottom + subviewEngine.height;
}

- (CGFloat)myCalcSubview:(MyLayoutEngine *)subviewEngine
             horzGravity:(MyGravity)horzGravity
                 withContext:(MyLayoutContext *)context {
    
    MyViewTraitsImpl *subviewTraits = subviewEngine.currentTraits;
    UIView *subview = subviewTraits.view;
    CGFloat layoutViewContentWidth = context->selfSize.width - context->paddingLeading - context->paddingTrailing;
    CGFloat marginLeading = [self myValidMargin:subviewTraits.leadingPosInner subview:subview calcPos:[subviewTraits.leadingPosInner measureWith:layoutViewContentWidth] selfLayoutSize:context->selfSize];
    CGFloat marginCenter = [self myValidMargin:subviewTraits.centerXPosInner subview:subview calcPos:[subviewTraits.centerXPosInner measureWith:layoutViewContentWidth] selfLayoutSize:context->selfSize];
    CGFloat marginTrailing = [self myValidMargin:subviewTraits.trailingPosInner subview:subview calcPos:[subviewTraits.trailingPosInner measureWith:layoutViewContentWidth] selfLayoutSize:context->selfSize];

    //水平压缩。
    CGFloat fixedWidth = marginLeading + marginCenter + marginTrailing + subviewEngine.width;
    if (fixedWidth > context->selfSize.width) {
        CGFloat spareWidth = context->selfSize.width - fixedWidth;
        CGFloat totalShrink = subviewTraits.leadingPosInner.shrink + subviewTraits.centerXPosInner.shrink + subviewTraits.trailingPosInner.shrink + subviewTraits.widthSizeInner.shrink;
        if (totalShrink != 0.0) {
            marginLeading += (subviewTraits.leadingPosInner.shrink / totalShrink) * spareWidth;
            marginCenter += (subviewTraits.centerXPosInner.shrink / totalShrink) * spareWidth;
            marginTrailing += (subviewTraits.trailingPosInner.shrink / totalShrink) * spareWidth;
            subviewEngine.width += (subviewTraits.widthSizeInner.shrink / totalShrink) * spareWidth;
        }
    }

    //如果是设置水平拉伸则，如果子视图有约束则不受影响，否则就变为和填充一个意思。
    if (horzGravity == MyGravity_Horz_Stretch) {
        if (subviewTraits.widthSizeInner.val != nil && subviewTraits.widthSizeInner.priority != MyPriority_Low) {
            horzGravity = MyGravity_Horz_Leading;
        } else {
            horzGravity = MyGravity_Horz_Fill;
        }
    }

    if (horzGravity == MyGravity_Horz_Leading) {
        subviewEngine.leading = context->paddingLeading + marginLeading;
    } else if (horzGravity == MyGravity_Horz_Trailing) {
        subviewEngine.leading = context->selfSize.width - context->paddingTrailing - marginTrailing - subviewEngine.width;
    }
    if (horzGravity == MyGravity_Horz_Fill) {
        subviewEngine.leading = context->paddingLeading + marginLeading;
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subview calcSize:layoutViewContentWidth - marginLeading - marginTrailing subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
    } else if (horzGravity == MyGravity_Horz_Center) {
        subviewEngine.leading = (layoutViewContentWidth - marginLeading - marginTrailing - subviewEngine.width) / 2 + context->paddingLeading + marginLeading + marginCenter;
    } else if (horzGravity == MyGravity_Horz_Window_Center) {
        if (self.window != nil) {
            subviewEngine.leading = (CGRectGetWidth(self.window.bounds) - marginLeading - marginTrailing - subviewEngine.width) / 2 + marginLeading + marginCenter;
            subviewEngine.leading = [self.window convertPoint:subviewEngine.origin toView:self].x;

            //因为从右到左布局最后统一进行了转换，但是窗口居中是不按布局来控制的，所以这里为了保持不变需要进行特殊处理。
            if ([MyBaseLayout isRTL]) {
                subviewEngine.leading = context->selfSize.width - subviewEngine.leading - subviewEngine.width;
            }
        }
    }
    return marginLeading + marginCenter + marginTrailing + subviewEngine.width;
}

- (CGSize)myCalcSizeInNoLayoutSuperview:(UIView *)newSuperview currentSize:(CGSize)size {
    if (newSuperview == nil || [newSuperview isKindOfClass:[MyBaseLayout class]]) {
        return size;
    }
    CGRect rectSuper = newSuperview.bounds;
    MyViewTraitsImpl *superviewTraits = newSuperview.myCurrentTraitsInner;
    MyLayoutTraitsImpl *layoutTraits = self.myCurrentTraits;

    if (!superviewTraits.widthSizeInner.wrapVal) {
        if (layoutTraits.widthSizeInner.anchorVal.view == newSuperview) {
            if (layoutTraits.widthSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.width];
            } else {
                size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.height];
            }
            size.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:size.width subviewSize:size selfLayoutSize:rectSuper.size];
        } else if (layoutTraits.widthSizeInner.fillVal) {
            size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.width];
        }

        if (layoutTraits.leadingPosInner.val != nil && layoutTraits.trailingPosInner.val != nil) {
            if (layoutTraits.widthSizeInner.val == nil || layoutTraits.widthSizeInner.priority == MyPriority_Low) {
                CGFloat marginLeading = [layoutTraits.leadingPosInner measureWith:rectSuper.size.width];
                CGFloat marginTrailing = [layoutTraits.trailingPosInner measureWith:rectSuper.size.width];
                size.width = rectSuper.size.width - marginLeading - marginTrailing;
                size.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:size.width subviewSize:size selfLayoutSize:rectSuper.size];
            }
        }
        if (size.width < 0) {
            size.width = 0;
        }
    }

    if (!superviewTraits.heightSizeInner.wrapVal) {
        if (layoutTraits.heightSizeInner.anchorVal.view == newSuperview) {
            if (layoutTraits.heightSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Height) {
                size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.height];
            } else {
                size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.width];
            }
            size.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:size.height subviewSize:size selfLayoutSize:rectSuper.size];
        } else if (layoutTraits.heightSizeInner.fillVal) {
            size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.height];
        }

        if (layoutTraits.topPosInner.val != nil && layoutTraits.bottomPosInner.val != nil) {
            if (layoutTraits.heightSizeInner.val == nil || layoutTraits.heightSizeInner.priority == MyPriority_Low) {
                CGFloat marginTop = [layoutTraits.topPosInner measureWith:rectSuper.size.height];
                CGFloat marginBottom = [layoutTraits.bottomPosInner measureWith:rectSuper.size.height];
                size.height = rectSuper.size.height - marginTop - marginBottom;
                size.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:size.height subviewSize:size selfLayoutSize:rectSuper.size];
            }
        }
        if (size.height < 0) {
            size.height = 0;
        }
    }
    return size;
}

- (BOOL)myUpdateLayoutRectInNoLayoutSuperview:(UIView *)newSuperview {
    BOOL isAdjust = NO; //这个变量表明是否后续父视图尺寸变化后需要调整更新布局视图的尺寸。

    CGRect rectSuper = newSuperview.bounds;
    MyLayoutTraitsImpl *layoutTraits = self.myCurrentTraits;

    CGFloat marginLeading = [layoutTraits.leadingPosInner measureWith:rectSuper.size.width];
    CGFloat marginTrailing = [layoutTraits.trailingPosInner measureWith:rectSuper.size.width];
    CGFloat marginTop = [layoutTraits.topPosInner measureWith:rectSuper.size.height];
    CGFloat marginBottom = [layoutTraits.bottomPosInner measureWith:rectSuper.size.height];
    CGRect rectSelf = self.bounds;

    //针对滚动父视图做特殊处理，如果父视图是滚动视图，而且当前的缩放比例不为1时系统会调整中心点的位置，因此这里需要特殊处理。
    CGFloat superViewZoomScale = 1.0;
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        superViewZoomScale = ((UIScrollView *)newSuperview).zoomScale;
    }
    //得到在设置center后的原始值。
    rectSelf.origin.x = self.center.x - rectSelf.size.width * self.layer.anchorPoint.x * superViewZoomScale;
    rectSelf.origin.y = self.center.y - rectSelf.size.height * self.layer.anchorPoint.y * superViewZoomScale;
    CGRect oldRectSelf = rectSelf;

    //确定左右边距和宽度。
    if (layoutTraits.widthSizeInner.val != nil) {
        if (layoutTraits.widthSizeInner.anchorVal != nil) {
            if (layoutTraits.widthSizeInner.anchorVal.view == newSuperview) {
                isAdjust = YES;

                if (layoutTraits.widthSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                    rectSelf.size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.width];
                } else {
                    rectSelf.size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.height];
                }
            } else {
                rectSelf.size.width = [layoutTraits.widthSizeInner measureWith:layoutTraits.widthSizeInner.anchorVal.view.myEstimatedWidth];
            }
        } else if (layoutTraits.widthSizeInner.numberVal != nil) {
            rectSelf.size.width = layoutTraits.widthSizeInner.measure;
        } else if (layoutTraits.widthSizeInner.fillVal) {
            isAdjust = YES;
            rectSelf.size.width = [layoutTraits.widthSizeInner measureWith:rectSuper.size.width];
        }
    }

    //这里要判断自己的宽度设置了最小和最大宽度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
    if (layoutTraits.widthSizeInner.lBoundValInner.anchorVal.view == newSuperview || layoutTraits.widthSizeInner.uBoundValInner.anchorVal.view == newSuperview) {
        isAdjust = YES;
    }

    rectSelf.size.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:rectSelf.size.width subviewSize:rectSelf.size selfLayoutSize:rectSuper.size];

    if ([MyBaseLayout isRTL]) {
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;
    }
    if (layoutTraits.leadingPosInner.val != nil && layoutTraits.trailingPosInner.val != nil) {
        isAdjust = YES;
        //如果宽度约束的优先级很低都按左右边距来决定布局视图的宽度。
        if (layoutTraits.widthSizeInner.priority == MyPriority_Low) {
            [layoutTraits.widthSizeInner _myEqualTo:nil];
        }
        if (layoutTraits.widthSizeInner.val == nil) {
            rectSelf.size.width = rectSuper.size.width - marginLeading - marginTrailing;
            rectSelf.size.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:rectSelf.size.width subviewSize:rectSelf.size selfLayoutSize:rectSuper.size];
        }

        //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
        //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
        UIScrollView *scrollSuperView = nil;
        if ([newSuperview isKindOfClass:[UIScrollView class]])
            scrollSuperView = (UIScrollView *)newSuperview;
        if (scrollSuperView != nil && layoutTraits.leadingPosInner.isSafeAreaPos) {
            marginLeading = layoutTraits.leadingPosInner.offsetVal + ([MyBaseLayout isRTL] ? scrollSuperView.safeAreaInsets.right : scrollSuperView.safeAreaInsets.left) - ([MyBaseLayout isRTL] ? scrollSuperView.adjustedContentInset.right : scrollSuperView.adjustedContentInset.left);
        }
        rectSelf.origin.x = marginLeading;
    } else if (layoutTraits.centerXPosInner.val != nil) {
        isAdjust = YES;
        rectSelf.origin.x = (rectSuper.size.width - rectSelf.size.width) / 2;
        rectSelf.origin.x += [layoutTraits.centerXPosInner measureWith:rectSuper.size.width];
    } else if (layoutTraits.leadingPosInner.val != nil) {
        //iOS11中的滚动条的安全区会叠加到contentInset里面。因此这里要特殊处理，让x轴的开始位置不应该算偏移。
        UIScrollView *scrollSuperView = nil;
        if ([newSuperview isKindOfClass:[UIScrollView class]]) {
            scrollSuperView = (UIScrollView *)newSuperview;
        }
        if (scrollSuperView != nil && layoutTraits.leadingPosInner.isSafeAreaPos) {
            marginLeading = layoutTraits.leadingPosInner.offsetVal + ([MyBaseLayout isRTL] ? scrollSuperView.safeAreaInsets.right : scrollSuperView.safeAreaInsets.left) - ([MyBaseLayout isRTL] ? scrollSuperView.adjustedContentInset.right : scrollSuperView.adjustedContentInset.left);
        }
        rectSelf.origin.x = marginLeading;
    } else if (layoutTraits.trailingPosInner.val != nil) {
        isAdjust = YES;
        rectSelf.origin.x = rectSuper.size.width - rectSelf.size.width - marginTrailing;
    }

    if (layoutTraits.heightSizeInner.val != nil) {
        if (layoutTraits.heightSizeInner.anchorVal != nil) {
            if (layoutTraits.heightSizeInner.anchorVal.view == newSuperview) {
                isAdjust = YES;
                if (layoutTraits.heightSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Height) {
                    rectSelf.size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.height];
                } else {
                    rectSelf.size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.width];
                }
            } else {
                rectSelf.size.height = [layoutTraits.heightSizeInner measureWith:layoutTraits.heightSizeInner.anchorVal.view.myEstimatedHeight];
            }
        } else if (layoutTraits.heightSizeInner.numberVal != nil) {
            rectSelf.size.height = layoutTraits.heightSizeInner.measure;
        } else if (layoutTraits.heightSizeInner.fillVal) {
            isAdjust = YES;
            rectSelf.size.height = [layoutTraits.heightSizeInner measureWith:rectSuper.size.height];
        }
    }

    //这里要判断自己的高度设置了最小和最大高度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
    if (layoutTraits.heightSizeInner.lBoundValInner.anchorVal.view == newSuperview || layoutTraits.heightSizeInner.uBoundValInner.anchorVal.view == newSuperview) {
        isAdjust = YES;
    }

    rectSelf.size.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:rectSelf.size.height subviewSize:rectSelf.size selfLayoutSize:rectSuper.size];

    if (layoutTraits.topPosInner.val != nil && layoutTraits.bottomPosInner.val != nil) {
        isAdjust = YES;
        //如果高度约束优先级很低则按上下边距来决定布局视图高度。
        if (layoutTraits.heightSizeInner.priority == MyPriority_Low) {
            [layoutTraits.heightSizeInner _myEqualTo:nil];
        }

        if (layoutTraits.heightSizeInner.val == nil) {
            rectSelf.size.height = rectSuper.size.height - marginTop - marginBottom;
            rectSelf.size.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:rectSelf.size.height subviewSize:rectSelf.size selfLayoutSize:rectSuper.size];
        }

        //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
        //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
        UIScrollView *scrollSuperView = nil;
        if ([newSuperview isKindOfClass:[UIScrollView class]])
            scrollSuperView = (UIScrollView *)newSuperview;
        if (scrollSuperView != nil && layoutTraits.topPosInner.isSafeAreaPos) {
            marginTop = layoutTraits.topPosInner.offsetVal + scrollSuperView.safeAreaInsets.top - scrollSuperView.adjustedContentInset.top;
        }
        
        rectSelf.origin.y = marginTop;
    } else if (layoutTraits.centerYPosInner.val != nil) {
        isAdjust = YES;
        rectSelf.origin.y = (rectSuper.size.height - rectSelf.size.height) / 2 + [layoutTraits.centerYPosInner measureWith:rectSuper.size.height];
    } else if (layoutTraits.topPosInner.val != nil) {
        //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
        //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
        UIScrollView *scrollSuperView = nil;
        if ([newSuperview isKindOfClass:[UIScrollView class]]) {
            scrollSuperView = (UIScrollView *)newSuperview;
        }
        if (scrollSuperView != nil && layoutTraits.topPosInner.isSafeAreaPos) {
            marginTop = layoutTraits.topPosInner.offsetVal + scrollSuperView.safeAreaInsets.top - scrollSuperView.adjustedContentInset.top;
        }
        rectSelf.origin.y = marginTop;
    } else if (layoutTraits.bottomPosInner.val != nil) {
        isAdjust = YES;
        rectSelf.origin.y = rectSuper.size.height - rectSelf.size.height - marginBottom;
    }

    if ([MyBaseLayout isRTL]) {
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;
    }
    rectSelf = _myCGRectRound(rectSelf);
    if (!_myCGRectEqual(rectSelf, oldRectSelf)) {
        if (rectSelf.size.width < 0) {
            rectSelf.size.width = 0;
        }
        if (rectSelf.size.height < 0) {
            rectSelf.size.height = 0;
        }
        if (CGAffineTransformIsIdentity(self.transform)) {
            self.frame = rectSelf;
        } else {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, rectSelf.size.width, rectSelf.size.height);
            self.center = CGPointMake(rectSelf.origin.x + self.layer.anchorPoint.x * rectSelf.size.width * superViewZoomScale, rectSelf.origin.y + self.layer.anchorPoint.y * rectSelf.size.height * superViewZoomScale);
        }
    } else if (layoutTraits.widthSizeInner.wrapVal || layoutTraits.heightSizeInner.wrapVal) {
        [self setNeedsLayout];
    }
    return isAdjust;
}

- (CGFloat)mySubview:(MyViewTraitsImpl *)subviewTraits wrapHeightSizeFits:(CGSize)size withContext:(MyLayoutContext *)context {
    UIView *subview = subviewTraits.view;
    
    CGFloat height = 0.0;
    
    if (![subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
        
        height = [subview sizeThatFits:CGSizeMake(size.width, 0)].height;
        if ([subview isKindOfClass:[UIImageView class]]) {
            //根据图片的尺寸进行等比缩放得到合适的高度。
            if (!subviewTraits.widthSizeInner.wrapVal) {
                UIImage *img = ((UIImageView *)subview).image;
                if (img != nil && img.size.width != 0) {
                    height = img.size.height * (size.width / img.size.width);
                }
            }
        } else if ([subview isKindOfClass:[UIButton class]]) {
            //按钮特殊处理多行的。。
            UIButton *button = (UIButton *)subview;
            if (button.titleLabel != nil) {
                //得到按钮本身的高度，以及单行文本的高度，这样就能算出按钮和文本的间距
                CGSize buttonSize = [button sizeThatFits:CGSizeMake(0, 0)];
                CGSize buttonTitleSize = [button.titleLabel sizeThatFits:CGSizeMake(0, 0)];
                CGSize sz = [button.titleLabel sizeThatFits:CGSizeMake(size.width, 0)];
                height = sz.height + buttonSize.height - buttonTitleSize.height; //这个sz只是纯文本的高度，所以要加上原先按钮和文本的高度差。。
            }
        }
        
    } else if (context->isEstimate) {
        //只有在评估时才这么处理。
        MyBaseLayout *sublayout = (MyBaseLayout*)subviewTraits.view;
        height = [sublayout sizeThatFits:CGSizeMake(size.width, 0) inSizeClass:context->sizeClass].height;
    } else {
        height = size.height;
    }
    return [subviewTraits.heightSizeInner measureWith:height];
}

- (CGFloat)myGetBoundLimitMeasure:(MyLayoutSize *)anchor subview:(UIView *)subview anchorType:(MyLayoutAnchorType)anchorType subviewSize:(CGSize)subviewSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound {
    CGFloat value = isUBound ? CGFLOAT_MAX : -CGFLOAT_MAX;
    if (anchor == nil || !anchor.isActive || anchor.valType == MyLayoutValType_Nil) {
        return value;
    }
    MyLayoutValType valType = anchor.valType;
    if (valType == MyLayoutValType_Number || valType == MyLayoutValType_Most) {
        value = anchor.numberVal.doubleValue;
    } else if (valType == MyLayoutValType_LayoutSize) {
        if (anchor.anchorVal.view == self) {
            if (anchor.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                value = selfLayoutSize.width - (self.myLayoutPaddingLeading + self.myLayoutPaddingTrailing);
            } else {
                value = selfLayoutSize.height - (self.myLayoutPaddingTop + self.myLayoutPaddingBottom);
            }
        } else if (anchor.anchorVal.view == subview) {
            if (anchor.anchorVal.anchorType == anchorType) {
                //约束冲突：无效的边界设置方法
                NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting", subview);
            } else {
                if (anchor.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                    value = subviewSize.width;
                } else {
                    value = subviewSize.height;
                }
            }
        } else {
            if (anchor.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                value = anchor.anchorVal.view.myEstimatedWidth;
                if (anchor.anchorVal.view == self.superview) {
                    value -= (self.superview.myLayoutPaddingLeading + self.superview.myLayoutPaddingTrailing);
                }
            } else {
                value = anchor.anchorVal.view.myEstimatedHeight;
                if (anchor.anchorVal.view == self.superview) {
                    value -= (self.superview.myLayoutPaddingTop + self.superview.myLayoutPaddingBottom);
                }
            }
        }

    } else if (valType == MyLayoutValType_Wrap) {
        if (anchorType == MyLayoutAnchorType_Width) {
            value = subviewSize.width;
        } else {
            value = subviewSize.height;
        }
    } else {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting", subview);
    }

    if (value == CGFLOAT_MAX || value == -CGFLOAT_MAX) {
        return value;
    }
    return [anchor measureWith:value];
}

- (CGFloat)myValidMeasure:(MyLayoutSize *)anchor subview:(UIView *)subview calcSize:(CGFloat)calcSize subviewSize:(CGSize)subviewSize selfLayoutSize:(CGSize)selfLayoutSize {
    if (calcSize < 0.0) {
        calcSize = 0.0;
    }
    if (anchor == nil) {
        return calcSize;
    }
    //算出最大最小值。
    if (anchor.isActive) {
        if (anchor.lBoundValInner != nil || anchor.uBoundValInner != nil) {
            CGFloat min = [self myGetBoundLimitMeasure:anchor.lBoundValInner subview:subview anchorType:anchor.anchorType subviewSize:subviewSize selfLayoutSize:selfLayoutSize isUBound:NO];
            CGFloat max = [self myGetBoundLimitMeasure:anchor.uBoundValInner subview:subview anchorType:anchor.anchorType subviewSize:subviewSize selfLayoutSize:selfLayoutSize isUBound:YES];
            
            calcSize = _myCGFloatMax(min, calcSize);
            calcSize = _myCGFloatMin(max, calcSize);
        }
    }
    return calcSize;
}

- (CGFloat)myGetBound:(MyLayoutPos *)anchor limitMarginOfSubview:(UIView *)subview {
    CGFloat value = 0;
    if (anchor == nil) {
        return value;
    }
    MyLayoutValType valType = anchor.valType;
    if (valType == MyLayoutValType_Number) {
        value = anchor.numberVal.doubleValue;
    } else if (valType == MyLayoutValType_LayoutPos) {
        CGRect rect = anchor.anchorVal.view.myEngine.frame;
        MyLayoutAnchorType anchorType = anchor.anchorVal.anchorType;
        if (anchorType == MyLayoutAnchorType_Leading) {
            if (rect.origin.x != CGFLOAT_MAX) {
                value = CGRectGetMinX(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_CenterX) {
            if (rect.origin.x != CGFLOAT_MAX) {
                value = CGRectGetMidX(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_Trailing) {
            if (rect.origin.x != CGFLOAT_MAX) {
                value = CGRectGetMaxX(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_Top) {
            if (rect.origin.y != CGFLOAT_MAX) {
                value = CGRectGetMinY(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_CenterY) {
            if (rect.origin.y != CGFLOAT_MAX) {
                value = CGRectGetMidY(rect);
            }
        } else if (anchorType == MyLayoutAnchorType_Bottom) {
            if (rect.origin.y != CGFLOAT_MAX) {
                value = CGRectGetMaxY(rect);
            }
        }
    } else {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting", subview);
    }
    return value + anchor.offsetVal;
}

- (CGFloat)myValidMargin:(MyLayoutPos *)anchor subview:(UIView *)subview calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize {
    if (anchor == nil) {
        return calcPos;
    }
    //算出最大最小值
    if (anchor.isActive) {
        if (anchor.lBoundValInner != nil || anchor.uBoundValInner != nil) {
            CGFloat min = (anchor.lBoundValInner != nil) ? [self myGetBound:anchor.lBoundValInner limitMarginOfSubview:subview] : -CGFLOAT_MAX;
            CGFloat max = (anchor.uBoundValInner != nil) ? [self myGetBound:anchor.uBoundValInner limitMarginOfSubview:subview] : CGFLOAT_MAX;
            
            calcPos = _myCGFloatMax(min, calcPos);
            calcPos = _myCGFloatMin(max, calcPos);
        }
    }
    return calcPos;
}

- (NSArray *)myUpdateCurrentSizeClass:(MySizeClass)sizeClass subviews:(NSArray<UIView *> *)subviews {
    
    MyLayoutEngine *layoutViewEngine = self.myEngine;
    layoutViewEngine.currentTraits = (MyViewTraitsImpl*)[self fetchLayoutTraitsInSizeClass:sizeClass];
    
    if (subviews == nil) {
        subviews = self.subviews;
    }
    NSMutableArray<MyLayoutEngine *> *subviewEngines = [NSMutableArray arrayWithCapacity:subviews.count];
    for (UIView *subview in subviews) {
        MyLayoutEngine *subviewEngine = subview.myEngine;
        subviewEngine.currentTraits = (MyViewTraitsImpl*)[subview fetchLayoutTraitsInSizeClass:sizeClass];
        if ([subviewEngine.currentTraits invalid]) {
            [subviewEngine reset];
        }
        [subviewEngines addObject:subviewEngine];
    }
    
    return @[layoutViewEngine, subviewEngines];
}

- (CGSize)myAdjustLayoutViewSizeWithContext:(MyLayoutContext *)context {
    
    MyLayoutTraitsImpl *layoutTraits = context->layoutViewEngine.currentTraits;
    
    //调整布局视图自己的尺寸。
    context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:context->selfSize.height subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];

    context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:context->selfSize.width subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];

    //对所有子视图进行布局变换
    CGAffineTransform layoutTransform = layoutTraits.layoutTransform;
    if (!CGAffineTransformIsIdentity(layoutTransform)) {
        for (MyLayoutEngine *subviewEngine in context->subviewEngines) {

            //取子视图中心点坐标。因为这个坐标系的原点是布局视图的左上角，所以要转化为数学坐标系的原点坐标, 才能应用坐标变换。
            CGPoint centerPoint = CGPointMake(subviewEngine.leading + subviewEngine.width / 2 - context->selfSize.width / 2,
                                              subviewEngine.top + subviewEngine.height / 2 - context->selfSize.height / 2);

            //应用坐标变换
            centerPoint = CGPointApplyAffineTransform(centerPoint, layoutTransform);

            //还原为左上角坐标系。
            centerPoint.x += context->selfSize.width / 2;
            centerPoint.y += context->selfSize.height / 2;

            //根据中心点的变化调整开始和结束位置。
            subviewEngine.leading = centerPoint.x - subviewEngine.width / 2;
            subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
            subviewEngine.top = centerPoint.y - subviewEngine.height / 2;
            subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
        }
    }

    //对所有子视图进行RTL设置
    if ([MyBaseLayout isRTL]) {
        for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
            subviewEngine.leading = context->selfSize.width - subviewEngine.leading - subviewEngine.width;
            subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
        }
    }

    //如果没有子视图，并且padding不参与空子视图尺寸计算则尺寸应该扣除padding的值。
    if (context->subviewEngines.count == 0 && !layoutTraits.zeroPadding) {
        if (layoutTraits.widthSizeInner.wrapVal) {
            context->selfSize.width -= (context->paddingLeading + context->paddingTrailing);
        }
        if (layoutTraits.heightSizeInner.wrapVal) {
            context->selfSize.height -= (context->paddingTop + context->paddingBottom);
        }
    }
    return context->selfSize;
}

- (UIFont *)myGetSubviewFont:(UIView *)subview {
    UIFont *subviewFont = nil;
    if ([subview isKindOfClass:[UILabel class]] ||
        [subview isKindOfClass:[UITextField class]] ||
        [subview isKindOfClass:[UITextView class]] ||
        [subview isKindOfClass:[UIButton class]]) {
        subviewFont = [subview valueForKey:@"font"];
    }
    return subviewFont;
}

- (CGFloat)myLayoutPaddingTop {
    return ((MyLayoutTraitsImpl*)self.myCurrentTraits).myLayoutPaddingTop;
}
- (CGFloat)myLayoutPaddingBottom {
    return ((MyLayoutTraitsImpl*)self.myCurrentTraits).myLayoutPaddingBottom;
}
- (CGFloat)myLayoutPaddingLeft {
    return ((MyLayoutTraitsImpl*)self.myCurrentTraits).myLayoutPaddingLeft;
}
- (CGFloat)myLayoutPaddingRight {
    return ((MyLayoutTraitsImpl*)self.myCurrentTraits).myLayoutPaddingRight;
}
- (CGFloat)myLayoutPaddingLeading {
    return ((MyLayoutTraitsImpl*)self.myCurrentTraits).myLayoutPaddingLeading;
}
- (CGFloat)myLayoutPaddingTrailing {
    return ((MyLayoutTraitsImpl*)self.myCurrentTraits).myLayoutPaddingTrailing;
}

- (void)myLayout:(MyLayoutTraitsImpl *)layoutTraits adjustScrollViewContentWithSize:(CGSize)newSize {
    if (self.adjustScrollViewContentSizeMode == MyAdjustScrollViewContentSizeModeYes && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        CGSize contsize = scrollView.contentSize;
        CGRect rectSuper = scrollView.bounds;

        //这里把自己在父视图中的上下左右边距也算在contentSize的包容范围内。
        CGFloat marginLeading = [layoutTraits.leadingPosInner measureWith:rectSuper.size.width];
        CGFloat marginTrailing = [layoutTraits.trailingPosInner measureWith:rectSuper.size.width];
        CGFloat marginTop = [layoutTraits.topPosInner measureWith:rectSuper.size.height];
        CGFloat marginBottom = [layoutTraits.bottomPosInner measureWith:rectSuper.size.height];
        if (layoutTraits.leadingPosInner.isSafeAreaPos) {
            marginLeading = layoutTraits.leadingPosInner.offsetVal;
        }
        if (layoutTraits.trailingPosInner.isSafeAreaPos) {
            marginTrailing = layoutTraits.trailingPosInner.offsetVal;
        }
        if (layoutTraits.topPosInner.isSafeAreaPos) {
            marginTop = layoutTraits.topPosInner.offsetVal;
        }
        if (layoutTraits.bottomPosInner.isSafeAreaPos) {
            marginBottom = layoutTraits.bottomPosInner.offsetVal;
        }
        
        if (contsize.height != newSize.height + marginTop + marginBottom) {
            contsize.height = newSize.height + marginTop + marginBottom;
        }
        if (contsize.width != newSize.width + marginLeading + marginTrailing) {
            contsize.width = newSize.width + marginLeading + marginTrailing;
        }

        contsize.width *= scrollView.zoomScale;
        contsize.height *= scrollView.zoomScale;
        if (!CGSizeEqualToSize(scrollView.contentSize, contsize)) {
            scrollView.contentSize = contsize;
        }
    }
}

MySizeClass _myGlobalSizeClass = 0xFF;

#if TARGET_OS_IOS
- (UIDeviceOrientation)myGetDeviceOrientation {
    UIDeviceOrientation devOri = UIDeviceOrientationPortrait;
    UIInterfaceOrientation intOri = UIInterfaceOrientationUnknown;
    
    //先用界面方向，再用设备方向。这样可以处理一些强制屏幕旋转的问题。
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 130000)
    if (@available(iOS 13.0, *)) {
        intOri = self.window.windowScene.interfaceOrientation;
    } else
#endif
    {   //因为App Extension 中不支持 sharedApplication 所以这里要特殊处理。
        BOOL isApp = [UIApplication respondsToSelector:@selector(sharedApplication)];
        if (isApp) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
#pragma clang diagnostic pop
            intOri = application.statusBarOrientation;
        }
    }
    
    if (intOri != UIInterfaceOrientationUnknown) {
        devOri = (UIDeviceOrientation)intOri;
    } else {
        devOri = [UIDevice currentDevice].orientation;
    }
    
    return devOri;
}
#endif

//获取全局的当前的SizeClass,减少获取次数的调用。
- (MySizeClass)myGetGlobalSizeClass {
    //找到最根部的父视图。
    if (_myGlobalSizeClass == 0xFF || ![self.superview isKindOfClass:[MyBaseLayout class]]) {
        MySizeClass sizeClass = (MySizeClass)((self.traitCollection.verticalSizeClass << 2) | self.traitCollection.horizontalSizeClass);
#if TARGET_OS_IOS
        UIDeviceOrientation ori = [self myGetDeviceOrientation];
        if (UIDeviceOrientationIsPortrait(ori)) {
            sizeClass |= MySizeClass_Portrait;
        } else if (UIDeviceOrientationIsLandscape(ori)) {
            sizeClass |= MySizeClass_Landscape;
        } else { //如果 ori == UIDeviceOrientationUnknown 的话, 默认给竖屏设置
            //当方向为未知时，尝试得到VC的方向，而不是设置默认方向。
            sizeClass |= MySizeClass_Portrait;
        }
#endif
        _myGlobalSizeClass = sizeClass;
    }
    return _myGlobalSizeClass;
}

- (void)myRemoveSubviewObserver:(UIView *)subview {
    MyLayoutEngine *subviewEngine = subview.myEngineInner;
    if (subviewEngine != nil) {
        subviewEngine.viewLayoutCompleteBlock = nil;
        if (subviewEngine.hasObserver) {
            subviewEngine.hasObserver = NO;
            if (![subview isKindOfClass:[MyBaseLayout class]]) {
                [subview removeObserver:self forKeyPath:@"hidden"];
                [subview removeObserver:self forKeyPath:@"frame"];

                if ([subview isKindOfClass:[UIScrollView class]]) {
                    [subview removeObserver:self forKeyPath:@"center"];
                } else if ([subview isKindOfClass:[UILabel class]]) {
                    [subview removeObserver:self forKeyPath:@"text"];
                    [subview removeObserver:self forKeyPath:@"attributedText"];
                }
            }
        }
    }
}

- (void)myAddSubviewObserver:(UIView *)subview {
    //非布局子视图添加hidden, frame的属性变化通知。
    if (![subview isKindOfClass:[MyBaseLayout class]]) {
        [subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        if ([subview isKindOfClass:[UIScrollView class]]) { //如果是UIScrollView则需要特殊监听center属性
            //有时候我们可能会把滚动视图加入到布局视图中去，滚动视图的尺寸有可能设置为高度自适应,这样就会调整center。从而需要重新激发滚动视图的布局
            //这也就是为什么只监听center的原因了。
            [subview addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        } else if ([subview isKindOfClass:[UILabel class]]) { //如果是UILabel则监听text和attributedText属性
            [subview addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:_myObserverContextB];
            [subview addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:_myObserverContextB];
        }
    }
}

- (void)myAdjustSizeSettingOfSubviewEngine:(MyLayoutEngine *)subviewEngine withContext:(MyLayoutContext *)context {
    
    MyLayoutTraitsImpl *layoutTraits = context->layoutViewEngine.currentTraits;
    MyViewTraitsImpl *subviewTraits = subviewEngine.currentTraits;
    UIView *subview = subviewTraits.view;

    if (!context->isEstimate) {
        subviewEngine.frame = CGRectMake(0, 0, CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
    }
    //只要子视图是包裹并且布局视图是fill填充，都应该清除子视图的包裹设置。
    if (subviewTraits.widthSizeInner.wrapVal && context->horzGravity == MyGravity_Horz_Fill) {
        [subviewTraits.widthSizeInner _myEqualTo:nil];
    }
    if (subviewTraits.heightSizeInner.wrapVal && context->vertGravity == MyGravity_Vert_Fill) {
        [subviewTraits.heightSizeInner _myEqualTo:nil];
    }
    if (subviewTraits.leadingPosInner.val != nil &&
        subviewTraits.trailingPosInner.val != nil &&
        (subviewTraits.widthSizeInner.priority == MyPriority_Low || !layoutTraits.widthSizeInner.wrapVal)) {
        [subviewTraits.widthSizeInner _myEqualTo:nil];
    }
    if (subviewTraits.topPosInner.val != nil &&
        subviewTraits.bottomPosInner.val != nil &&
        (subviewTraits.heightSizeInner.priority == MyPriority_Low || !layoutTraits.heightSizeInner.wrapVal)) {
        [subviewTraits.heightSizeInner _myEqualTo:nil];
    }
    if ([subview isKindOfClass:[MyBaseLayout class]]) {
        
        if (context->isEstimate && (subviewTraits.heightSizeInner.wrapVal || subviewTraits.widthSizeInner.wrapVal)) {
            [(MyBaseLayout *)subview sizeThatFits:subviewEngine.size inSizeClass:context->sizeClass];
        }
    }
}

- (CGFloat)myWidthSizeValueOfSubviewEngine:(MyLayoutEngine *)subviewEngine
                               withContext:(MyLayoutContext *)context {
    
    MyLayoutTraitsImpl *layoutTraits = context->layoutViewEngine.currentTraits;
    MyViewTraitsImpl *subviewTraits = subviewEngine.currentTraits;
    CGFloat retVal = subviewEngine.width;
    MyLayoutSize *sbvWidthSizeInner = subviewTraits.widthSizeInner;
    if (sbvWidthSizeInner.numberVal != nil) { //宽度等于固定的值。
        retVal = sbvWidthSizeInner.measure;
    } else if (sbvWidthSizeInner.anchorVal != nil && sbvWidthSizeInner.anchorVal.view != subviewTraits.view) { //宽度等于其他的依赖的视图。
        if (sbvWidthSizeInner.anchorVal == layoutTraits.widthSizeInner) {
            retVal = [sbvWidthSizeInner measureWith:context->selfSize.width - context->paddingLeading - context->paddingTrailing];
        } else if (sbvWidthSizeInner.anchorVal == layoutTraits.heightSizeInner) {
            retVal = [sbvWidthSizeInner measureWith:context->selfSize.height - context->paddingTop - context->paddingBottom];
        } else {
            if (sbvWidthSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                retVal = [sbvWidthSizeInner measureWith:sbvWidthSizeInner.anchorVal.view.myEstimatedWidth];
            } else {
                retVal = [sbvWidthSizeInner measureWith:sbvWidthSizeInner.anchorVal.view.myEstimatedHeight];
            }
        }
    } else if (sbvWidthSizeInner.fillVal) {
        retVal = [sbvWidthSizeInner measureWith:context->selfSize.width - context->paddingLeading - context->paddingTrailing];
    } else if (sbvWidthSizeInner.wrapVal) {
        if (![subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
            retVal = [sbvWidthSizeInner measureWith:[subviewTraits.view sizeThatFits:CGSizeMake(0, subviewEngine.height)].width];
        } else if (context->isEstimate) {
            MyBaseLayout *sublayout = (MyBaseLayout*)subviewTraits.view;
            retVal = [sublayout sizeThatFits:subviewEngine.size inSizeClass:context->sizeClass].width;
            retVal = [sbvWidthSizeInner measureWith:retVal];
        }
    }
    return retVal;
}

- (CGFloat)myHeightSizeValueOfSubviewEngine:(MyLayoutEngine *)subviewEngine
                                withContext:(MyLayoutContext *)context {
    
    MyLayoutTraitsImpl *layoutTraits = context->layoutViewEngine.currentTraits;
    MyViewTraitsImpl *subviewTraits = subviewEngine.currentTraits;
    MyLayoutSize *subviewHeightSizeInner = subviewTraits.heightSizeInner;

    CGFloat contentWidth = context->selfSize.width - context->paddingLeading - context->paddingTrailing;
    CGFloat contentHeight = context->selfSize.height - context->paddingTop - context->paddingBottom;
    
    CGFloat retVal = subviewEngine.height;
    if (subviewHeightSizeInner.numberVal != nil) { //高度等于固定的值。
        retVal = subviewHeightSizeInner.measure;
    } else if (subviewHeightSizeInner.anchorVal != nil && subviewHeightSizeInner.anchorVal.view != subviewTraits.view) { //高度等于其他依赖的视图
        if (subviewHeightSizeInner.anchorVal == layoutTraits.heightSizeInner) {
            retVal = [subviewHeightSizeInner measureWith:contentHeight];
        } else if (subviewHeightSizeInner.anchorVal == layoutTraits.widthSizeInner) {
            retVal = [subviewHeightSizeInner measureWith:contentWidth];
        } else {
            if (subviewHeightSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
                retVal = [subviewHeightSizeInner measureWith:subviewHeightSizeInner.anchorVal.view.myEstimatedWidth];
            } else {
                retVal = [subviewHeightSizeInner measureWith:subviewHeightSizeInner.anchorVal.view.myEstimatedHeight];
            }
        }
    } else if (subviewHeightSizeInner.fillVal) {
        retVal = [subviewHeightSizeInner measureWith:contentHeight];
    } else if (subviewHeightSizeInner.wrapVal) {
        retVal = [self mySubview:subviewTraits wrapHeightSizeFits:subviewEngine.size withContext:context];
    }
    return retVal;
}

- (void)myCalcRectOfSubviewEngine:(MyLayoutEngine *)subviewEngine
                     pMaxWrapSize:(CGSize *)pMaxWrapSize
                      withContext:(MyLayoutContext *)context {
    
    MyLayoutTraitsImpl *layoutTraits = context->layoutViewEngine.currentTraits;
    MyViewTraitsImpl *subviewTraits = subviewEngine.currentTraits;
    
    subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
    subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
    [self myCalcSubview:subviewEngine horzGravity:[subviewTraits finalHorzGravityFrom:context->horzGravity] withContext:context];

    subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];

    subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
    [self myCalcSubview:subviewEngine vertGravity:[subviewTraits finalVertGravityFrom:context->vertGravity] baselinePos:CGFLOAT_MAX withContext:context];

    //特殊处理宽度等于高度
    if (subviewTraits.widthSizeInner.anchorVal.view == subviewTraits.view && subviewTraits.widthSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Height) {
        subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

        [self myCalcSubview:subviewEngine horzGravity:[subviewTraits finalHorzGravityFrom:context->horzGravity] withContext:context];
    }

    //特殊处理高度等于宽度。
    if (subviewTraits.heightSizeInner.anchorVal.view == subviewTraits.view && subviewTraits.heightSizeInner.anchorVal.anchorType == MyLayoutAnchorType_Width) {
        subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];

        if (subviewTraits.heightSizeInner.wrapVal) {
            subviewEngine.height = [self mySubview:subviewTraits wrapHeightSizeFits:subviewEngine.size withContext:context];
        }
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        [self myCalcSubview:subviewEngine vertGravity:[subviewTraits finalVertGravityFrom:context->vertGravity] baselinePos:CGFLOAT_MAX withContext:context];
    }
    
    subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;

    if (pMaxWrapSize != NULL) {
        if (layoutTraits.widthSizeInner.wrapVal) {
            //如果同时设置左右边界则左右边界为最小的宽度
            if (subviewTraits.leadingPosInner.val != nil && subviewTraits.trailingPosInner.val != nil) {
                if (_myCGFloatLess(pMaxWrapSize->width, subviewTraits.leadingPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing)) {
                    pMaxWrapSize->width = subviewTraits.leadingPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing;
                }
            }

            //宽度不依赖布局则参与最大宽度计算。
            if ((subviewTraits.widthSizeInner.anchorVal == nil || subviewTraits.widthSizeInner.anchorVal != layoutTraits.widthSizeInner) && !subviewTraits.widthSizeInner.fillVal) {
                if (_myCGFloatLess(pMaxWrapSize->width, subviewEngine.width + subviewTraits.leadingPosInner.measure + subviewTraits.centerXPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing)) {
                    pMaxWrapSize->width = subviewEngine.width + subviewTraits.leadingPosInner.measure + subviewTraits.centerXPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing;
                }
                //只有不居中和底部对齐才比较底部。
                if (subviewTraits.centerXPosInner.val == nil &&
                    subviewTraits.trailingPosInner.val == nil &&
                    _myCGFloatLess(pMaxWrapSize->width, subviewEngine.trailing + subviewTraits.trailingPosInner.measure + context->paddingTrailing)) {
                    pMaxWrapSize->width = subviewEngine.trailing + subviewTraits.trailingPosInner.measure + context->paddingTrailing;
                }
            }
        }

        if (layoutTraits.heightSizeInner.wrapVal) {
            //如果同时设置上下边界则上下边界为最小的高度
            if (subviewTraits.topPosInner.val != nil && subviewTraits.bottomPosInner.val != nil) {
                if (_myCGFloatLess(pMaxWrapSize->height, subviewTraits.topPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom)) {
                    pMaxWrapSize->height = subviewTraits.topPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom;
                }
            }

            //高度不依赖布局则参与最大高度计算。
            if ((subviewTraits.heightSizeInner.anchorVal == nil || subviewTraits.heightSizeInner.anchorVal != layoutTraits.heightSizeInner) && !subviewTraits.heightSizeInner.fillVal) {
                if (_myCGFloatLess(pMaxWrapSize->height, subviewEngine.height + subviewTraits.topPosInner.measure + subviewTraits.centerYPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom)) {
                    pMaxWrapSize->height = subviewEngine.height + subviewTraits.topPosInner.measure + subviewTraits.centerYPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom;
                }

                //只有在不居中对齐和底部对齐时才比较底部。
                if (subviewTraits.centerYPosInner.val == nil &&
                    subviewTraits.bottomPosInner.val == nil &&
                    _myCGFloatLess(pMaxWrapSize->height, subviewEngine.bottom + subviewTraits.bottomPosInner.measure + context->paddingBottom)) {
                    pMaxWrapSize->height = subviewEngine.bottom + subviewTraits.bottomPosInner.measure + context->paddingBottom;
                }
            }
        }
    }
}

- (void)myHookSublayout:(MyBaseLayout *)sublayout borderlineRect:(CGRect *)pRect {
    //do nothing...
}

- (void)myInvalidateIntrinsicContentSize {
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        MyViewTraitsImpl *viewTraits = (MyViewTraitsImpl*)self.myCurrentTraitsInner;
        if (viewTraits.widthSizeInner.wrapVal || viewTraits.heightSizeInner.wrapVal) {
            [self invalidateIntrinsicContentSize];
        }
    }
}

- (void)myCalcSubviewsWrapContentSize:(MyLayoutContext *)context withCustomSetting:(void (^)(MyViewTraitsImpl *subviewTraits))customSetting {
    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        MyViewTraitsImpl *subviewTraits = subviewEngine.currentTraits;
        UIView *subview = subviewTraits.view;

        if (customSetting != nil) {
            customSetting(subviewTraits);
        }
        CGSize size = subview.bounds.size;
        subviewEngine.width = size.width;
        subviewEngine.height = size.height;
    }
}

#pragma mark -- Deprecated methods


@end

@implementation MyBaseLayoutOptionalData

@end

@implementation UIWindow (MyLayoutExt)

- (void)myUpdateRTL:(BOOL)isRTL {
    BOOL oldRTL = [MyBaseLayout isRTL];
    if (oldRTL != isRTL) {
        [MyBaseLayout setIsRTL:isRTL];
        [self mySetNeedLayoutAllSubviews:self];
    }
}

- (void)mySetNeedLayoutAllSubviews:(UIView *)view {
    NSArray *subviews = view.subviews;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[MyBaseLayout class]]) {
            [subview setNeedsLayout];
        }
        [self mySetNeedLayoutAllSubviews:subview];
    }
}
@end

#pragma mark-- MyLayoutDragger

@interface MyLayoutDragger()

@property(nonatomic, assign) CGPoint centerPointOffset;

@end

@implementation MyLayoutDragger

//开始拖动
- (void)dragView:(UIView *)view withEvent:(UIEvent *)event {
    if (self.layout == nil) {
        return;
    }
    self.oldIndex = [self.layout.subviews indexOfObject:view];
    self.currentIndex = self.oldIndex;
    self.hasDragging = NO;
    
    CGPoint point = [[event touchesForView:view].anyObject locationInView:self.layout];
    CGPoint center = view.center;
    self.centerPointOffset = CGPointMake(center.x - point.x, center.y - point.y);
}

//拖动中,在拖动时要排除移动的子视图序列，动画的时长。返回是否拖动成功。
- (void)dragginView:(UIView *)view withEvent:(UIEvent *)event {
    if (self.layout == nil) {
        return;
    }
    self.hasDragging = YES;

    //取出拖动时当前的位置点。
    CGPoint point = [[event touchesForView:view].anyObject locationInView:self.layout];

    UIView *hoverView = nil; //保存拖动时手指所在的视图。
    //判断当前手指在具体视图的位置。这里要排除exclusiveViews中指定的所有视图的位置，因为这些视图固定不会调整。
    for (UIView *subview in self.layout.subviews) {
        if (subview != view && view.useFrame && ![self.exclusiveViews containsObject:subview]) {
            if (CGRectContainsPoint(subview.frame, point)) {
                hoverView = subview;
                break;
            }
        }
    }

    //如果拖动的view和手指下当前其他的兄弟视图有重合时则意味着需要将当前视图view插入到手指下其他视图所在的位置，并且调整其他视图的位置。
    if (hoverView != nil) {
        if (self.animateDuration > 0) {
            [self.layout layoutAnimationWithDuration:self.animateDuration];
        }
        //得到要移动的视图的位置索引。
        self.currentIndex = [self.layout.subviews indexOfObjectIdenticalTo:hoverView];
        if (self.oldIndex != self.currentIndex) {
            self.oldIndex = self.currentIndex;
        } else {
            if (!self.canHover) {
                if (hoverView.center.x > view.center.x) {
                    self.currentIndex = self.oldIndex + 1;
                }
            }
        }

        for (NSInteger i = self.layout.subviews.count - 1; i > self.currentIndex; i--) {
            [self.layout exchangeSubviewAtIndex:i withSubviewAtIndex:i - 1];
        }

        //因为view在bringSubviewToFront后变为了最后一个子视图，因此要调整正确的位置。
        //经过上面的view的位置调整完成后，需要重新激发布局视图的布局，因此这里要设置autoresizesSubviews为YES。
        self.layout.autoresizesSubviews = YES;
        view.useFrame = NO;
        view.noLayout = YES;
        //这里设置为YES表示布局时不会改变view的真实位置而只是在布局视图中占用一个位置和尺寸，正是因为只是占用位置，因此会调整其他视图的位置。
        [self.layout layoutIfNeeded];
    }
    //在进行view的位置调整时，要把view移动到最顶端，也就子视图数组的的最后。同时布局视图不能激发子视图布局，因此要把autoresizesSubviews设置为NO，同时因为要自定义view的位置，因此要把useFrame设置为YES，并且恢复noLayout为NO。
    [self.layout bringSubviewToFront:view]; //把拖动的子视图放在最后，这样这个子视图在移动时就会在所有兄弟视图的上面。
    self.layout.autoresizesSubviews = NO;   //在拖动时不要让布局视图激发布局
    view.useFrame = YES;                    //因为拖动时，拖动的控件需要自己确定位置，不能被布局约束，因此必须要将useFrame设置为YES下面的center设置才会有效。
    view.center = CGPointMake(point.x + self.centerPointOffset.x, point.y + self.centerPointOffset.y);                       //因为useFrame设置为了YES所有这里可以直接调整center，从而实现了位置的自定义设置。
    view.noLayout = NO;                     //恢复noLayout为NO。
}

//结束拖动
- (void)dropView:(UIView *)view withEvent:(UIEvent *)event {
    if (self.layout == nil) {
        return;
    }
    if (!self.hasDragging) {
        return;
    }
    self.hasDragging = NO;

    //当抬起时，需要让拖动的子视图调整到正确的顺序，并重新参与布局，因此这里要把拖动的子视图的useFrame设置为NO，同时把布局视图的autoresizesSubviews还原为YES。
    for (NSInteger i = self.layout.subviews.count - 1; i > self.currentIndex; i--) {
        [self.layout exchangeSubviewAtIndex:i withSubviewAtIndex:i - 1];
    }

    view.useFrame = NO;                    //让拖动的子视图重新参与布局，将useFrame设置为NO
    self.layout.autoresizesSubviews = YES; //让布局视图可以重新激发布局，这里还原为YES。
}

- (BOOL)isHovering {
    return self.hasDragging && self.canHover && self.oldIndex == self.currentIndex;
}

@end

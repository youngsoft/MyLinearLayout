//
//  MyLayoutSizeClass.m
//  MyLayout
//
//  Created by fzy on 16/1/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyLayoutSizeClass.h"
#import "MyGridNode.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutSizeInner.h"


@implementation MyLayoutEngine

- (id)init {
    self = [super init];
    if (self != nil) {
        _leading = CGFLOAT_MAX;
        _trailing = CGFLOAT_MAX;
        _top = CGFLOAT_MAX;
        _bottom = CGFLOAT_MAX;
        _width = CGFLOAT_MAX;
        _height = CGFLOAT_MAX;
    }

    return self;
}

- (void)reset {
    _leading = CGFLOAT_MAX;
    _trailing = CGFLOAT_MAX;
    _top = CGFLOAT_MAX;
    _bottom = CGFLOAT_MAX;
    _width = CGFLOAT_MAX;
    _height = CGFLOAT_MAX;
}

- (CGRect)frame {
    return CGRectMake(_leading, _top, _width, _height);
}

- (void)setFrame:(CGRect)frame {
    _leading = frame.origin.x;
    _top = frame.origin.y;
    _width = frame.size.width;
    _height = frame.size.height;
    _trailing = _leading + _width;
    _bottom = _top + _height;
}

- (CGSize)size {
    return CGSizeMake(_width, _height);
}

- (void)setSize:(CGSize)size {
    _width = size.width;
    _height = size.height;
}

- (CGPoint)origin {
    return CGPointMake(_leading, _top);
}

- (void)setOrigin:(CGPoint)origin {
    _leading = origin.x;
    _top = origin.y;
}

- (BOOL)multiple {
    return self.sizeClasses.count > 1;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"leading:%g, top:%g, width:%g, height:%g, trailing:%g, bottom:%g", _leading, _top, _width, _height, _trailing, _bottom];
}

- (MyViewTraits *)fetchView:(UIView *)view layoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass {
    MyViewTraits *viewTraits = nil;
    if (self.sizeClasses == nil) {
        self.sizeClasses = [NSMutableDictionary new];
    } else {
      viewTraits = (MyViewTraits *)[self.sizeClasses objectForKey:@(sizeClass)];
    }
     
    if (viewTraits == nil) {
        MyViewTraits *srcTraits = (MyViewTraits *)[self.sizeClasses objectForKey:@(srcSizeClass)];
        if (srcTraits == nil) {
            viewTraits = [view createSizeClassInstance];
        } else {
            viewTraits = [srcTraits copy];
        }
        viewTraits.view = view;
        [self.sizeClasses setObject:viewTraits forKey:@(sizeClass)];
    }
    return viewTraits;
}

- (MyViewTraits *)fetchView:(UIView *)view bestLayoutSizeClass:(MySizeClass)sizeClass {

    MySizeClass wscType = sizeClass & 0x03;
    MySizeClass hscType = sizeClass & 0x0C;
    MySizeClass oriType = sizeClass & 0xC0;

    if (self.sizeClasses == nil) {
        self.sizeClasses = [NSMutableDictionary new];
    }
    MySizeClass searchType;
    MyViewTraits *viewTraits = nil;
    if (self.sizeClasses.count > 1) {
        //first search the most exact SizeClass
        searchType = wscType | hscType | oriType;
        viewTraits = [self.sizeClasses objectForKey:@(searchType)];
        if (viewTraits != nil) {
            return viewTraits;
        }
        searchType = wscType | hscType;
        if (searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = MySizeClass_wAny | hscType | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = MySizeClass_wAny | hscType;
        if (searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = wscType | MySizeClass_hAny | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = wscType | MySizeClass_hAny;
        if (searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = MySizeClass_wAny | MySizeClass_hAny | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.sizeClasses objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }
    }

    searchType = MySizeClass_wAny | MySizeClass_hAny;
    viewTraits = [self.sizeClasses objectForKey:@(searchType)];
    if (viewTraits == nil) {
        viewTraits = [view createSizeClassInstance];
        viewTraits.view = view;
        [self.sizeClasses setObject:viewTraits forKey:@(searchType)];
    }
    return viewTraits;
}

- (void)setView:(UIView *)view layoutSizeClass:(MySizeClass)sizeClass withTraits:(MyViewTraits *)traits {
    if (self.sizeClasses == nil) {
        self.sizeClasses = [NSMutableDictionary new];
    }
    traits.view = view;
    traits.topPosInner.view = view;
    traits.bottomPosInner.view = view;
    traits.leadingPosInner.view = view;
    traits.trailingPosInner.view = view;
    traits.centerXPosInner.view = view;
    traits.centerYPosInner.view = view;
    traits.baselinePosInner.view = view;
    traits.widthSizeInner.view = view;
    traits.heightSizeInner.view = view;
    
    [self.sizeClasses setObject:traits forKey:@(sizeClass)];
}


@end


@implementation MyViewTraits

BOOL _myisRTL = NO;

+ (BOOL)isRTL {
    return _myisRTL;
}

+ (void)setIsRTL:(BOOL)isRTL {
    _myisRTL = isRTL;
}

- (id)init {
    return [super init];
}

- (MyLayoutPos *)topPosInner {
    return _topPos;
}

- (MyLayoutPos *)leadingPosInner {
    return _leadingPos;
}

- (MyLayoutPos *)bottomPosInner {
    return _bottomPos;
}

- (MyLayoutPos *)trailingPosInner {
    return _trailingPos;
}

- (MyLayoutPos *)centerXPosInner {
    return _centerXPos;
}

- (MyLayoutPos *)centerYPosInner {
    return _centerYPos;
}

- (MyLayoutPos *)leftPosInner {
    return [MyViewTraits isRTL] ? self.trailingPosInner : self.leadingPosInner;
}

- (MyLayoutPos *)rightPosInner {
    return [MyViewTraits isRTL] ? self.leadingPosInner : self.trailingPosInner;
}

- (MyLayoutPos *)baselinePosInner {
    return _baselinePos;
}

- (MyLayoutSize *)widthSizeInner {
    return _widthSize;
}

- (MyLayoutSize *)heightSizeInner {
    return _heightSize;
}

//..

- (MyLayoutPos *)topPos {
    if (_topPos == nil) {
        _topPos = [MyLayoutPos new];
        _topPos.view = self.view;
        _topPos.anchorType = MyLayoutAnchorType_Top;
    }
    return _topPos;
}

- (MyLayoutPos *)leadingPos {
    if (_leadingPos == nil) {
        _leadingPos = [MyLayoutPos new];
        _leadingPos.view = self.view;
        _leadingPos.anchorType = MyLayoutAnchorType_Leading;
    }

    return _leadingPos;
}

- (MyLayoutPos *)bottomPos {
    if (_bottomPos == nil) {
        _bottomPos = [MyLayoutPos new];
        _bottomPos.view = self.view;
        _bottomPos.anchorType = MyLayoutAnchorType_Bottom;
    }
    return _bottomPos;
}

- (MyLayoutPos *)trailingPos {
    if (_trailingPos == nil) {
        _trailingPos = [MyLayoutPos new];
        _trailingPos.view = self.view;
        _trailingPos.anchorType = MyLayoutAnchorType_Trailing;
    }
    return _trailingPos;
}

- (MyLayoutPos *)centerXPos {
    if (_centerXPos == nil) {
        _centerXPos = [MyLayoutPos new];
        _centerXPos.view = self.view;
        _centerXPos.anchorType = MyLayoutAnchorType_CenterX;
    }
    return _centerXPos;
}

- (MyLayoutPos *)centerYPos {
    if (_centerYPos == nil) {
        _centerYPos = [MyLayoutPos new];
        _centerYPos.view = self.view;
        _centerYPos.anchorType = MyLayoutAnchorType_CenterY;
    }
    return _centerYPos;
}

- (MyLayoutPos *)leftPos {
    return [MyViewTraits isRTL] ? self.trailingPos : self.leadingPos;
}

- (MyLayoutPos *)rightPos {
    return [MyViewTraits isRTL] ? self.leadingPos : self.trailingPos;
}

- (MyLayoutPos *)baselinePos {
    if (_baselinePos == nil) {
        _baselinePos = [MyLayoutPos new];
        _baselinePos.view = self.view;
        _baselinePos.anchorType = MyLayoutAnchorType_Baseline;
    }
    return _baselinePos;
}

- (CGFloat)myTop {
    return self.topPosInner.measure;
}

- (void)setMyTop:(CGFloat)myTop {
    self.topPos.myEqualTo(@(myTop));
}

- (CGFloat)myLeading {
    return self.leadingPosInner.measure;
}

- (void)setMyLeading:(CGFloat)myLeading {
    self.leadingPos.myEqualTo(@(myLeading));
}

- (CGFloat)myBottom {
    return self.bottomPosInner.measure;
}

- (void)setMyBottom:(CGFloat)myBottom {
    self.bottomPos.myEqualTo(@(myBottom));
}

- (CGFloat)myTrailing {
    return self.trailingPosInner.measure;
}

- (void)setMyTrailing:(CGFloat)myTrailing {
    self.trailingPos.myEqualTo(@(myTrailing));
}

- (CGFloat)myCenterX {
    return self.centerXPosInner.measure;
}

- (void)setMyCenterX:(CGFloat)myCenterX {
    self.centerXPos.myEqualTo(@(myCenterX));
}

- (CGFloat)myCenterY {
    return self.centerYPosInner.measure;
}

- (void)setMyCenterY:(CGFloat)myCenterY {
    self.centerYPos.myEqualTo(@(myCenterY));
}

- (CGPoint)myCenter {
    return CGPointMake(self.myCenterX, self.myCenterY);
}

- (void)setMyCenter:(CGPoint)myCenter {
    self.myCenterX = myCenter.x;
    self.myCenterY = myCenter.y;
}

- (CGFloat)myLeft {
    return self.leftPosInner.measure;
}

- (void)setMyLeft:(CGFloat)myLeft {
    self.leftPos.myEqualTo(@(myLeft));
}

- (CGFloat)myRight {
    return self.rightPosInner.measure;
}

- (void)setMyRight:(CGFloat)myRight {
    self.rightPos.myEqualTo(@(myRight));
}

- (CGFloat)myMargin {
    return self.leftPosInner.measure;
}

- (void)setMyMargin:(CGFloat)myMargin {
    self.topPos.myEqualTo(@(myMargin));
    self.leftPos.myEqualTo(@(myMargin));
    self.rightPos.myEqualTo(@(myMargin));
    self.bottomPos.myEqualTo(@(myMargin));
}

- (CGFloat)myHorzMargin {
    return self.leftPosInner.measure;
}

- (void)setMyHorzMargin:(CGFloat)myHorzMargin {
    self.leftPos.myEqualTo(@(myHorzMargin));
    self.rightPos.myEqualTo(@(myHorzMargin));
}

- (CGFloat)myVertMargin {
    return self.topPosInner.measure;
}

- (void)setMyVertMargin:(CGFloat)myVertMargin {
    self.topPos.myEqualTo(@(myVertMargin));
    self.bottomPos.myEqualTo(@(myVertMargin));
}

- (MyLayoutSize *)widthSize {
    if (_widthSize == nil) {
        _widthSize = [MyLayoutSize new];
        _widthSize.view = self.view;
        _widthSize.anchorType = MyLayoutAnchorType_Width;
    }
    return _widthSize;
}

- (MyLayoutSize *)heightSize {
    if (_heightSize == nil) {
        _heightSize = [MyLayoutSize new];
        _heightSize.view = self.view;
        _heightSize.anchorType = MyLayoutAnchorType_Height;
    }
    return _heightSize;
}

- (CGFloat)myWidth {
    //特殊处理设置为MyLayoutSize.wrap和MyLayoutSize.fill的返回。
    if (self.widthSizeInner.valType == MyLayoutValType_Wrap) {
        return MyLayoutSize.wrap;
    } else if (self.widthSizeInner.valType == MyLayoutValType_Fill) {
        return MyLayoutSize.fill;
    } else {
        return self.widthSizeInner.measure;
    }
}

- (void)setMyWidth:(CGFloat)width {
    self.widthSize.myEqualTo(@(width));
}

- (CGFloat)myHeight {
    if (self.heightSizeInner.valType == MyLayoutValType_Wrap) {
        return MyLayoutSize.wrap;
    } else if (self.heightSizeInner.valType == MyLayoutValType_Fill) {
        return MyLayoutSize.fill;
    } else {
        return self.heightSizeInner.measure;
    }
}

- (void)setMyHeight:(CGFloat)height {
    self.heightSize.myEqualTo(@(height));
}

- (CGSize)mySize {
    return CGSizeMake(self.myWidth, self.myHeight);
}

- (void)setMySize:(CGSize)mySize {
    self.myWidth = mySize.width;
    self.myHeight = mySize.height;
}

- (void)setWeight:(CGFloat)weight {
    if (weight < 0) {
        weight = 0;
    }
    if (_weight != weight) {
        _weight = weight;
    }
}

- (BOOL)wrapContentWidth {
    return self.widthSizeInner.wrapVal;
}

- (BOOL)wrapContentHeight {
    return self.heightSizeInner.wrapVal;
}

- (void)setWrapContentWidth:(BOOL)wrapContentWidth {
    if (wrapContentWidth) {
        self.widthSize.myEqualTo(@(MyLayoutSize.wrap));
    } else {
        //只有是以前设置了宽度自适应，这里取消自适应后才会将尺寸清除！目的是为了兼容老版本。
        if (_widthSize.isWrap) {
            _widthSize = nil;
        }
    }
}

- (void)setWrapContentHeight:(BOOL)wrapContentHeight {
    if (wrapContentHeight) {
        self.heightSize.myEqualTo(@(MyLayoutSize.wrap));
    } else {
        //只有是以前设置了高度自适应，这里取消自适应后才会将尺寸清除！目的是为了兼容老版本。
        if (_heightSize.isWrap) {
            _heightSize = nil;
        }
    }
}

- (BOOL)wrapContentSize {
    return self.wrapContentWidth && self.wrapContentHeight;
}

- (void)setWrapContentSize:(BOOL)wrapContentSize {
    self.wrapContentWidth = self.wrapContentHeight = wrapContentSize;
}

- (NSString *)debugDescription {
    NSString *dbgDesc = [NSString stringWithFormat:@"\nView:\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\nweight=%f\nuseFrame=%@\nnoLayout=%@\nvisibility=%c\nalignment=%hu\nreverseFloat=%@\nclearFloat=%@",
                                                   self.topPosInner,
                                                   self.leadingPosInner,
                                                   self.bottomPosInner,
                                                   self.trailingPosInner,
                                                   self.centerXPosInner,
                                                   self.centerYPosInner,
                                                   self.widthSizeInner,
                                                   self.heightSizeInner,
                                                   self.weight,
                                                   self.useFrame ? @"YES" : @"NO",
                                                   self.noLayout ? @"YES" : @"NO",
                                                   self.visibility,
                                                   self.alignment,
                                                   self.reverseFloat ? @"YES" : @"NO",
                                                   self.clearFloat ? @"YES" : @"NO"];

    return dbgDesc;
}

#pragma mark-- NSCopying

- (id)copyWithZone:(NSZone *)zone {
    MyViewTraits *layoutTraits = [[[self class] allocWithZone:zone] init];

    //这里不会复制hidden属性
    layoutTraits->_view = _view;
    layoutTraits->_topPos = [self.topPosInner copy];
    layoutTraits->_leadingPos = [self.leadingPosInner copy];
    layoutTraits->_bottomPos = [self.bottomPosInner copy];
    layoutTraits->_trailingPos = [self.trailingPosInner copy];
    layoutTraits->_centerXPos = [self.centerXPosInner copy];
    layoutTraits->_centerYPos = [self.centerYPosInner copy];
    layoutTraits->_baselinePos = [self.baselinePos copy];
    layoutTraits->_widthSize = [self.widthSizeInner copy];
    layoutTraits->_heightSize = [self.heightSizeInner copy];
    layoutTraits.useFrame = self.useFrame;
    layoutTraits.noLayout = self.noLayout;
    layoutTraits.visibility = self.visibility;
    layoutTraits.alignment = self.alignment;
    layoutTraits.weight = self.weight;
    layoutTraits.reverseFloat = self.isReverseFloat;
    layoutTraits.clearFloat = self.clearFloat;

    return layoutTraits;
}

#pragma mark -- Helper

+ (MyGravity)convertLeadingTrailingGravityFromLeftRightGravity:(MyGravity)leftRightGravity{
    if (leftRightGravity == MyGravity_Horz_Left) {
        if ([self isRTL]) {
            return MyGravity_Horz_Trailing;
        } else {
            return MyGravity_Horz_Leading;
        }
    } else if (leftRightGravity == MyGravity_Horz_Right) {
        if ([self isRTL]) {
            return MyGravity_Horz_Leading;
        } else {
            return MyGravity_Horz_Trailing;
        }
    } else {
        return leftRightGravity;
    }
}


- (BOOL)invalid {
    if (self.useFrame) {
        return YES;
    }
    
    if (self.view.isHidden) {
        return self.visibility != MyVisibility_Invisible;
    } else {
        return self.visibility == MyVisibility_Gone;
    }
}

- (MyGravity)finalVertGravityFrom:(MyGravity)layoutVertGravity {
    MyGravity finalVertGravity = MyGravity_Vert_Top; //
    MyGravity vertAlignment = MYVERTGRAVITY(self.alignment);
    if (layoutVertGravity != MyGravity_None) {
        finalVertGravity = layoutVertGravity;
        if (vertAlignment != MyGravity_None) {
            finalVertGravity = vertAlignment;
        }
    } else {
        if (vertAlignment != MyGravity_None) {
            finalVertGravity = vertAlignment;
        }
        if (self.topPosInner.val != nil && self.bottomPosInner.val != nil) {
            //只有在没有设置高度约束，或者高度约束优先级很低的情况下同时设置上下才转化为填充。
            if (self.heightSizeInner.val == nil || self.heightSizeInner.priority == MyPriority_Low) {
                finalVertGravity = MyGravity_Vert_Fill;
            }
        } else if (self.centerYPosInner.val != nil) {
            finalVertGravity = MyGravity_Vert_Center;
        } else if (self.topPosInner.val != nil) {
            finalVertGravity = MyGravity_Vert_Top;
        } else if (self.bottomPosInner.val != nil) {
            finalVertGravity = MyGravity_Vert_Bottom;
        }
    }
    return finalVertGravity;
}

- (MyGravity)finalHorzGravityFrom:(MyGravity)layoutHorzGravity {
    MyGravity finalHorzGravity = MyGravity_Horz_Leading;
    MyGravity horzAlignment = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(self.alignment)];
    if (layoutHorzGravity != MyGravity_None) {
        finalHorzGravity = layoutHorzGravity;
        if (horzAlignment != MyGravity_None) {
            finalHorzGravity = horzAlignment;
        }
    } else {
        if (horzAlignment != MyGravity_None) {
            finalHorzGravity = horzAlignment;
        }
        if (self.leadingPosInner.val != nil && self.trailingPosInner.val != nil) {
            //只有在没有设置宽度约束，或者宽度约束优先级很低的情况下同时设置左右才转化为填充。
            if (self.widthSizeInner.val == nil || self.widthSizeInner.priority == MyPriority_Low) {
                finalHorzGravity = MyGravity_Horz_Fill;
            }
        } else if (self.centerXPosInner.val != nil) {
            finalHorzGravity = MyGravity_Horz_Center;
        } else if (self.leadingPosInner.val != nil) {
            finalHorzGravity = MyGravity_Horz_Leading;
        } else if (self.trailingPosInner.val != nil) {
            finalHorzGravity = MyGravity_Horz_Trailing;
        }
    }
    return finalHorzGravity;
}


@end

@implementation MyLayoutTraits

- (id)init {
    self = [super init];
    if (self != nil) {
        _zeroPadding = YES;
        _insetsPaddingFromSafeArea = UIRectEdgeLeft | UIRectEdgeRight;
        _insetLandscapeFringePadding = NO;
        _layoutTransform = CGAffineTransformIdentity;
    }
    return self;
}

- (UIEdgeInsets)padding {
    return UIEdgeInsetsMake(self.paddingTop, self.paddingLeft, self.paddingBottom, self.paddingRight);
}

- (void)setPadding:(UIEdgeInsets)padding {
    self.paddingTop = padding.top;
    self.paddingLeft = padding.left;
    self.paddingBottom = padding.bottom;
    self.paddingRight = padding.right;
}

- (CGFloat)paddingLeft {
    return [MyViewTraits isRTL] ? self.paddingTrailing : self.paddingLeading;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    if ([MyViewTraits isRTL]) {
        self.paddingTrailing = paddingLeft;
    } else {
        self.paddingLeading = paddingLeft;
    }
}

- (CGFloat)paddingRight {
    return [MyViewTraits isRTL] ? self.paddingLeading : self.paddingTrailing;
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    if ([MyViewTraits isRTL]) {
        self.paddingLeading = paddingRight;
    } else {
        self.paddingTrailing = paddingRight;
    }
}

- (CGFloat)myLayoutPaddingTop {
    //如果padding值是特殊的值。
    if (self.paddingTop >= MyLayoutPos.safeAreaMargin - 2000 && self.paddingTop <= MyLayoutPos.safeAreaMargin + 2000) {
        CGFloat paddingTopAdd = 20.0; //默认高度是状态栏的高度。
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        if (@available(iOS 11.0, *)) {
            paddingTopAdd = self.view.safeAreaInsets.top;
        }
#endif
        return self.paddingTop - MyLayoutPos.safeAreaMargin + paddingTopAdd;
    }

    if ((self.insetsPaddingFromSafeArea & UIRectEdgeTop) == UIRectEdgeTop) {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        if (@available(iOS 11.0, *)) {
            return self.paddingTop + self.view.safeAreaInsets.top;
        }
#endif
    }
    return self.paddingTop;
}

- (CGFloat)myLayoutPaddingBottom {
    //如果padding值是特殊的值。
    if (self.paddingBottom >= MyLayoutPos.safeAreaMargin - 2000 && self.paddingBottom <= MyLayoutPos.safeAreaMargin + 2000) {
        CGFloat paddingBottomAdd = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        if (@available(iOS 11.0, *)) {
            paddingBottomAdd = self.view.safeAreaInsets.bottom;
        }
#endif
        return self.paddingBottom - MyLayoutPos.safeAreaMargin + paddingBottomAdd;
    }

    if ((self.insetsPaddingFromSafeArea & UIRectEdgeBottom) == UIRectEdgeBottom) {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        if (@available(iOS 11.0, *)) {
            return self.paddingBottom + self.view.safeAreaInsets.bottom;
        }
#endif
    }
    return self.paddingBottom;
}

- (CGFloat)myLayoutPaddingLeading {
    if (self.paddingLeading >= MyLayoutPos.safeAreaMargin - 2000 && self.paddingLeading <= MyLayoutPos.safeAreaMargin + 2000) {
        CGFloat paddingLeadingAdd = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        if (@available(iOS 11.0, *)) {
            paddingLeadingAdd = self.view.safeAreaInsets.left; //因为这里左右的缩进都是一样的，因此不需要考虑RTL的情况。
        }
#endif
        return self.paddingLeading - MyLayoutPos.safeAreaMargin + paddingLeadingAdd;
    }

    CGFloat inset = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        UIRectEdge edge = [MyViewTraits isRTL] ? UIRectEdgeRight : UIRectEdgeLeft;
#if TARGET_OS_IOS
        UIDeviceOrientation devori = [MyViewTraits isRTL] ? UIDeviceOrientationLandscapeLeft : UIDeviceOrientationLandscapeRight;
#endif
        if ((self.insetsPaddingFromSafeArea & edge) == edge) {
#if TARGET_OS_IOS
            //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是尾部那么就不缩进了。
            if (self.insetLandscapeFringePadding &&
                (self.insetsPaddingFromSafeArea & (UIRectEdgeLeft | UIRectEdgeRight)) == (UIRectEdgeLeft | UIRectEdgeRight) &&
                [UIDevice currentDevice].orientation == devori) {
                inset = 0;
            } else
#endif
                inset = [MyViewTraits isRTL] ? self.view.safeAreaInsets.right : self.view.safeAreaInsets.left;
        }
    }
#endif
    return self.paddingLeading + inset;
}

- (CGFloat)myLayoutPaddingTrailing {
    if (self.paddingTrailing >= MyLayoutPos.safeAreaMargin - 2000 && self.paddingTrailing <= MyLayoutPos.safeAreaMargin + 2000) {
        CGFloat paddingTrailingAdd = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        if (@available(iOS 11.0, *)) {
            paddingTrailingAdd = self.view.safeAreaInsets.right;
        }
#endif
        return self.paddingTrailing - MyLayoutPos.safeAreaMargin + paddingTrailingAdd;
    }

    CGFloat inset = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
    if (@available(iOS 11.0, *)) {
        UIRectEdge edge = [MyViewTraits isRTL] ? UIRectEdgeLeft : UIRectEdgeRight;
#if TARGET_OS_IOS
        UIDeviceOrientation devori = [MyViewTraits isRTL] ? UIDeviceOrientationLandscapeRight : UIDeviceOrientationLandscapeLeft;
#endif
        if ((self.insetsPaddingFromSafeArea & edge) == edge) {
#if TARGET_OS_IOS
            //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是头部那么就不缩进了。
            if (self.insetLandscapeFringePadding &&
                (self.insetsPaddingFromSafeArea & (UIRectEdgeLeft | UIRectEdgeRight)) == (UIRectEdgeLeft | UIRectEdgeRight) &&
                [UIDevice currentDevice].orientation == devori) {
                inset = 0;
            } else
#endif
                inset = [MyViewTraits isRTL] ? self.view.safeAreaInsets.left : self.view.safeAreaInsets.right;
        }
    }
#endif
    return self.paddingTrailing + inset;
}

- (CGFloat)myLayoutPaddingLeft {
    return [MyViewTraits isRTL] ? [self myLayoutPaddingTrailing] : [self myLayoutPaddingLeading];
}
- (CGFloat)myLayoutPaddingRight {
    return [MyViewTraits isRTL] ? [self myLayoutPaddingLeading] : [self myLayoutPaddingTrailing];
}

- (CGFloat)subviewSpace {
    return self.subviewVSpace;
}

- (void)setSubviewSpace:(CGFloat)subviewSpace {
    self.subviewVSpace = subviewSpace;
    self.subviewHSpace = subviewSpace;
}

- (id)copyWithZone:(NSZone *)zone {
    MyLayoutTraits *layoutTraits = [super copyWithZone:zone];
    layoutTraits.paddingTop = self.paddingTop;
    layoutTraits.paddingLeading = self.paddingLeading;
    layoutTraits.paddingBottom = self.paddingBottom;
    layoutTraits.paddingTrailing = self.paddingTrailing;
    layoutTraits.zeroPadding = self.zeroPadding;
    layoutTraits.insetsPaddingFromSafeArea = self.insetsPaddingFromSafeArea;
    layoutTraits.insetLandscapeFringePadding = self.insetLandscapeFringePadding;
    layoutTraits.gravity = self.gravity;
    layoutTraits.reverseLayout = self.reverseLayout;
    layoutTraits.layoutTransform = self.layoutTransform;
    layoutTraits.subviewVSpace = self.subviewVSpace;
    layoutTraits.subviewHSpace = self.subviewHSpace;

    return layoutTraits;
}

- (NSString *)debugDescription {
    NSString *dbgDesc = [super debugDescription];
    dbgDesc = [NSString stringWithFormat:@"%@\nLayout:\npadding=%@\nzeroPadding=%@\ngravity=%hu\nreverseLayout=%@\nsubviewVertSpace=%f\nsubviewHorzSpace=%f",
                                         dbgDesc,
                                         NSStringFromUIEdgeInsets(self.padding),
                                         self.zeroPadding ? @"YES" : @"NO",
                                         self.gravity,
                                         self.reverseLayout ? @"YES" : @"NO",
                                         self.subviewVSpace,
                                         self.subviewHSpace];

    return dbgDesc;
}

#pragma mark -- Helper

- (NSMutableArray<MyLayoutEngine *> *)filterEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines {
    
    if (subviewEngines == nil) {
        subviewEngines = [NSMutableArray arrayWithCapacity:self.view.subviews.count];
        for (UIView *subview in self.view.subviews) {
            [subviewEngines addObject:subview.myEngine];
        }
    }
    
    NSInteger count = subviewEngines.count;
    if (self.reverseLayout) {
        //翻转一个数组。
        for (NSInteger i = 0; i < count / 2; i++) {
            [subviewEngines exchangeObjectAtIndex:i withObjectAtIndex:count - 1 - i];
        }
    }
    
    for (NSInteger i = count - 1; i >= 0; i--) {
        MyViewTraits *subviewTraits = subviewEngines[i].currentSizeClass;
        if ([subviewTraits invalid]) {
            [subviewEngines removeObjectAtIndex:i];
        }
    }
    
    return subviewEngines;
}


@end

@implementation MySequentLayoutFlexSpacing

- (CGFloat)calcMaxMinSubviewSizeForContent:(CGFloat)selfSize paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding space:(CGFloat *)pSpace {
    CGFloat subviewSize = self.subviewSize;

    CGFloat extralSpace = self.minSpace;
    if (self.centered) {
        extralSpace *= -1;
    }
    NSInteger rowCount = MAX(floor((selfSize - (*pStarPadding) - (*pEndPadding) + extralSpace) / (subviewSize + self.minSpace)), 1);
    NSInteger spaceCount = rowCount - 1;
    if (self.centered) {
        spaceCount += 2;
    }
    if (spaceCount > 0) {
        *pSpace = (selfSize - (*pStarPadding) - (*pEndPadding) - subviewSize * rowCount) / spaceCount;
        if (_myCGFloatGreat(*pSpace, self.maxSpace)) {
            *pSpace = self.maxSpace;
            subviewSize = (selfSize - (*pStarPadding) - (*pEndPadding) - (*pSpace) * spaceCount) / rowCount;
        }
        if (self.centered) {
            *pStarPadding = (*pStarPadding + *pSpace);
            *pEndPadding = (*pEndPadding + *pSpace);
        }
    }
    return subviewSize;
}

- (CGFloat)calcMaxMinSubviewSize:(CGFloat)selfSize arrangedCount:(NSInteger)arrangedCount paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding space:(CGFloat *)pSpace {
    CGFloat subviewSize = self.subviewSize;

    NSInteger spaceCount = arrangedCount - 1;
    if (self.centered) {
        spaceCount += 2;
    }
    if (spaceCount > 0) {
        *pSpace = (selfSize - *pStarPadding - *pEndPadding - subviewSize * arrangedCount) / spaceCount;

        if (_myCGFloatGreat(*pSpace, self.maxSpace) || _myCGFloatLess(*pSpace, self.minSpace)) {
            if (_myCGFloatGreat(*pSpace, self.maxSpace)) {
                *pSpace = self.maxSpace;
            }
            if (_myCGFloatLess(*pSpace, self.minSpace)) {
                *pSpace = self.minSpace;
            }
            subviewSize = (selfSize - *pStarPadding - *pEndPadding - (*pSpace) * spaceCount) / arrangedCount;
        }
        if (self.centered) {
            *pStarPadding = (*pStarPadding + *pSpace);
            *pEndPadding = (*pEndPadding + *pSpace);
        }
    }
    return subviewSize;
}

@end

@implementation MySequentLayoutTraits

- (id)copyWithZone:(NSZone *)zone {
    MySequentLayoutTraits *layoutTraits = [super copyWithZone:zone];
    layoutTraits.orientation = self.orientation;
    if (self.flexSpace != nil) {
        layoutTraits.flexSpace = [MySequentLayoutFlexSpacing new];
        layoutTraits.flexSpace.subviewSize = self.flexSpace.subviewSize;
        layoutTraits.flexSpace.minSpace = self.flexSpace.minSpace;
        layoutTraits.flexSpace.maxSpace = self.flexSpace.maxSpace;
        layoutTraits.flexSpace.centered = self.flexSpace.centered;
    }

    return layoutTraits;
}

- (NSString *)debugDescription {
    NSString *dbgDesc = [super debugDescription];
    dbgDesc = [NSString stringWithFormat:@"%@\nSequentLayout: \norientation=%lu",
                                         dbgDesc,
                                         (unsigned long)self.orientation];

    return dbgDesc;
}

@end

@implementation MyLinearLayoutTraits

- (id)copyWithZone:(NSZone *)zone {
    MyLinearLayoutTraits *layoutTraits = [super copyWithZone:zone];
    layoutTraits.shrinkType = self.shrinkType;
    return layoutTraits;
}

- (NSString *)debugDescription {
    NSString *dbgDesc = [super debugDescription];
    dbgDesc = [NSString stringWithFormat:@"%@\nLinearLayout: \nshrinkType=%lu",
                                         dbgDesc,
                                         (unsigned long)self.shrinkType];
    return dbgDesc;
}

@end

@implementation MyTableLayoutTraits

@end

@implementation MyFloatLayoutTraits

- (id)copyWithZone:(NSZone *)zone {
    MyFloatLayoutTraits *layoutTraits = [super copyWithZone:zone];
    return layoutTraits;
}

@end

@implementation MyFlowLayoutTraits

- (id)copyWithZone:(NSZone *)zone {
    MyFlowLayoutTraits *layoutTraits = [super copyWithZone:zone];
    layoutTraits.arrangedCount = self.arrangedCount;
    layoutTraits.autoArrange = self.autoArrange;
    layoutTraits.isFlex = self.isFlex;
    layoutTraits.lastlineGravityPolicy = self.lastlineGravityPolicy;
    layoutTraits.arrangedGravity = self.arrangedGravity;
    layoutTraits.pagedCount = self.pagedCount;
    return layoutTraits;
}

- (NSString *)debugDescription {
    NSString *dbgDesc = [super debugDescription];
    dbgDesc = [NSString stringWithFormat:@"%@\nFlowLayout: \narrangedCount=%ld\nautoArrange=%@\nisFlex=%@\narrangedGravity=%hu\npagedCount=%ld",
                                         dbgDesc,
                                         (long)self.arrangedCount,
                                         self.autoArrange ? @"YES" : @"NO",
                                         self.isFlex ? @"YES" : @"NO",
                                         self.arrangedGravity,
                                         (long)self.pagedCount];

    return dbgDesc;
}

@end

@implementation MyRelativeLayoutTraits

@end

@implementation MyFrameLayoutTraits
@end

@implementation MyPathLayoutTraits
@end

@interface MyGridLayoutTraits () <MyGridNode>

@property (nonatomic, strong) MyGridNode *rootGrid;

@end

@implementation MyGridLayoutTraits

- (MyGridNode *)rootGrid {
    if (_rootGrid == nil) {
        _rootGrid = [[MyGridNode alloc] initWithMeasure:0 superGrid:nil];
    }
    return _rootGrid;
}

//添加行栅格，返回新的栅格。
- (id<MyGrid>)addRow:(CGFloat)measure {
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列栅格，返回新的栅格。
- (id<MyGrid>)addCol:(CGFloat)measure {
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addCol:measure];
    node.superGrid = self;
    return node;
}

//添加栅格，返回被添加的栅格。这个方法和下面的cloneGrid配合使用可以用来构建那些需要重复添加栅格的场景。
- (id<MyGrid>)addRowGrid:(id<MyGrid>)grid {
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addRowGrid:grid];
    node.superGrid = self;
    return node;
}

- (id<MyGrid>)addColGrid:(id<MyGrid>)grid {
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addColGrid:grid];
    node.superGrid = self;
    return node;
}

- (id<MyGrid>)addRowGrid:(id<MyGrid>)grid measure:(CGFloat)measure {
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addRowGrid:grid measure:measure];
    node.superGrid = self;
    return node;
}

- (id<MyGrid>)addColGrid:(id<MyGrid>)grid measure:(CGFloat)measure {
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addColGrid:grid measure:measure];
    node.superGrid = self;
    return node;
}

//克隆出一个新栅格以及其下的所有子栅格。
- (id<MyGrid>)cloneGrid {
    return nil;
}

//从父栅格中删除。
- (void)removeFromSuperGrid {
}

//得到父栅格。
- (id<MyGrid>)superGrid {
    return nil;
}

- (void)setSuperGrid:(id<MyGridNode>)superGrid {
}

- (BOOL)placeholder {
    return NO;
}

- (void)setPlaceholder:(BOOL)placeholder {
}

- (BOOL)anchor {
    return NO;
}

- (void)setAnchor:(BOOL)anchor {
    //do nothing
}

- (MyGravity)overlap {
    return self.gravity;
}

- (void)setOverlap:(MyGravity)overlap {
    self.gravity = overlap;
}

- (NSInteger)tag {
    return self.view.tag;
}

- (void)setTag:(NSInteger)tag {
    self.view.tag = tag;
}

- (id)actionData {
    return self.rootGrid.actionData;
}

- (void)setActionData:(id)actionData {
    self.rootGrid.actionData = actionData;
}

- (void)setTarget:(id)target action:(SEL)action {
    //do nothing.
}

//得到所有子栅格
- (NSArray<id<MyGrid>> *)subGrids {
    return self.rootGrid.subGrids;
}

- (void)setSubGrids:(NSMutableArray *)subGrids {
    self.rootGrid.subGrids = subGrids;
}

- (MySubGridsType)subGridsType {
    return self.rootGrid.subGridsType;
}

- (void)setSubGridsType:(MySubGridsType)subGridsType {
    self.rootGrid.subGridsType = subGridsType;
}

- (MyBorderline *)topBorderline {
    return nil;
}

- (void)setTopBorderline:(MyBorderline *)topBorderline {
}

- (MyBorderline *)bottomBorderline {
    return nil;
}

- (void)setBottomBorderline:(MyBorderline *)bottomBorderline {
}

- (MyBorderline *)leftBorderline {
    return nil;
}

- (void)setLeftBorderline:(MyBorderline *)leftBorderline {
}

- (MyBorderline *)rightBorderline {
    return nil;
}

- (void)setRightBorderline:(MyBorderline *)rightBorderline {
}

- (MyBorderline *)leadingBorderline {
    return nil;
}

- (void)setLeadingBorderline:(MyBorderline *)leadingBorderline {
}

- (MyBorderline *)trailingBorderline {
    return nil;
}

- (void)setTrailingBorderline:(MyBorderline *)trailingBorderline {
}

- (NSDictionary *)gridDictionary {
    return [MyGridNode translateGridNode:self toGridDictionary:[NSMutableDictionary new]];
}

- (void)setGridDictionary:(NSDictionary *)gridDictionary {
    MyGridNode *rootNode = self.rootGrid;
    [rootNode.subGrids removeAllObjects];
    rootNode.subGridsType = MySubGridsType_Unknown;

    [self.view setNeedsLayout];

    if (gridDictionary == nil) {
        return;
    }
    [MyGridNode translateGridDicionary:gridDictionary toGridNode:self];
}

- (CGFloat)measure {
    return MyLayoutSize.fill;
    //return self.rootGrid.measure;
}

- (void)setMeasure:(CGFloat)measure {
    //self.rootGrid.measure = measure;
}

- (CGRect)gridRect {
    return self.rootGrid.gridRect;
}

- (void)setGridRect:(CGRect)gridRect {
    self.rootGrid.gridRect = gridRect;
}

//更新格子尺寸。
- (CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure {
    return [self.rootGrid updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}
- (CGFloat)updateWrapGridSizeInSuperGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure {
    return [self.rootGrid updateWrapGridSizeInSuperGrid:superGrid withMeasure:measure];
}


- (CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<MyGridNode>)superGrid withOffset:(CGFloat)offset {
    return [self.rootGrid updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}

- (UIView *)gridLayoutView {
    return self.view;
}

- (SEL)gridAction {
    return nil;
}

- (void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer {
    [self.rootGrid setBorderlineNeedLayoutIn:rect withLayer:layer];
}

- (void)showBorderline:(BOOL)show {
    [self.rootGrid showBorderline:show];
}

- (id<MyGridNode>)gridHitTest:(CGPoint)point {
    return [self.rootGrid gridHitTest:point];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //do nothing;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //do nothing;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //do nothing;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //do nothing;
}

- (id)copyWithZone:(NSZone *)zone {
    MyGridLayoutTraits *lsc = [super copyWithZone:zone];
    lsc->_rootGrid = (MyGridNode *)[self.rootGrid cloneGrid];
    return lsc;
}

@end

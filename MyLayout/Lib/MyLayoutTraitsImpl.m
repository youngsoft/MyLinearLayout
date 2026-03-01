//
//  MyLayoutSizeClass.m
//  MyLayout
//
//  Created by fzy on 16/1/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyLayoutTraitsImpl.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutSizeInner.h"


@interface MyLayoutEngine()

@property (nonatomic, readonly, strong) Class traitsClass;

@end

@implementation MyLayoutEngine


-(instancetype)initWithTraitsClass:(Class)traitsClass {
    self = [self init];
    if (self != nil) {
        _traitsClass = traitsClass;
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
    return self.traitsDict.count > 1;
}



- (NSString *)description {
    return [NSString stringWithFormat:@"leading:%g, top:%g, width:%g, height:%g, trailing:%g, bottom:%g", _leading, _top, _width, _height, _trailing, _bottom];
}

- (MyViewTraitsImpl *)fetchView:(UIView *)view traitsInSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass {
    MyViewTraitsImpl *viewTraits = nil;
    if (self.traitsDict == nil) {
        self.traitsDict = [NSMutableDictionary new];
    } else {
      viewTraits = (MyViewTraitsImpl *)[self.traitsDict objectForKey:@(sizeClass)];
    }
     
    if (viewTraits == nil) {
        MyViewTraitsImpl *srcTraits = (MyViewTraitsImpl *)[self.traitsDict objectForKey:@(srcSizeClass)];
        if (srcTraits == nil) {
            viewTraits =   [self.traitsClass new];
        } else {
            viewTraits = [srcTraits copy];
        }
        viewTraits.view = view;
        [self.traitsDict setObject:viewTraits forKey:@(sizeClass)];
    }
    return viewTraits;
}

- (MyViewTraitsImpl *)fetchView:(UIView *)view bestTraitsAt:(MySizeClass)sizeClass {

    MySizeClass wscType = sizeClass & 0x03;
    MySizeClass hscType = sizeClass & 0x0C;
    MySizeClass oriType = sizeClass & 0xC0;

    if (self.traitsDict == nil) {
        self.traitsDict = [NSMutableDictionary new];
    }
    MySizeClass searchType;
    MyViewTraitsImpl *viewTraits = nil;
    if (self.traitsDict.count > 1) {
        //first search the most exact SizeClass
        searchType = wscType | hscType | oriType;
        viewTraits = [self.traitsDict objectForKey:@(searchType)];
        if (viewTraits != nil) {
            return viewTraits;
        }
        searchType = wscType | hscType;
        if (searchType != sizeClass) {
            viewTraits = [self.traitsDict objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = MySizeClass_wAny | hscType | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.traitsDict objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = MySizeClass_wAny | hscType;
        if (searchType != sizeClass) {
            viewTraits = [self.traitsDict objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = wscType | MySizeClass_hAny | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.traitsDict objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = wscType | MySizeClass_hAny;
        if (searchType != sizeClass) {
            viewTraits = [self.traitsDict objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }

        searchType = MySizeClass_wAny | MySizeClass_hAny | oriType;
        if (oriType != 0 && searchType != sizeClass) {
            viewTraits = [self.traitsDict objectForKey:@(searchType)];
            if (viewTraits != nil) {
                return viewTraits;
            }
        }
    }

    searchType = MySizeClass_wAny | MySizeClass_hAny;
    viewTraits = [self.traitsDict objectForKey:@(searchType)];
    if (viewTraits == nil) {
        viewTraits = [self.traitsClass new];
        viewTraits.view = view;
        [self.traitsDict setObject:viewTraits forKey:@(searchType)];
    }
    return viewTraits;
}

- (void)setView:(UIView *)view newTraits:(__kindof MyViewTraitsImpl* )traits at:(MySizeClass)sizeClass {
    if (self.traitsDict == nil) {
        self.traitsDict = [NSMutableDictionary new];
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
    
    [self.traitsDict setObject:traits forKey:@(sizeClass)];
}


@end


@implementation MyViewTraitsImpl

@synthesize topPos = _topPos;
@synthesize leadingPos = _leadingPos;
@synthesize bottomPos = _bottomPos;
@synthesize trailingPos = _trailingPos;
@synthesize centerXPos = _centerXPos;
@synthesize centerYPos = _centerYPos;
@synthesize baselinePos = _baselinePos;
@synthesize widthSize = _widthSize;
@synthesize heightSize = _heightSize;
@synthesize useFrame;
@synthesize noLayout;
@synthesize visibility;
@synthesize alignment;
@synthesize weight = _weight;
@synthesize reverseFloat;
@synthesize clearFloat;

BOOL _myisRTL = NO;


+ (BOOL)isRTL {
    return _myisRTL;
}

+ (void)setIsRTL:(BOOL)isRTL {
    _myisRTL = isRTL;
}


//接口实现

- (MyLayoutPos *)topPos {
    if (_topPos == nil) {
        _topPos = [[MyLayoutPos alloc] initWithView:self.view anchorType:MyLayoutAnchorType_Top];
    }
    return _topPos;
}

- (MyLayoutPos *)leadingPos {
    if (_leadingPos == nil) {
        _leadingPos = [[MyLayoutPos alloc] initWithView:self.view anchorType:MyLayoutAnchorType_Leading];
    }
    return _leadingPos;
}

- (MyLayoutPos *)bottomPos {
    if (_bottomPos == nil) {
        _bottomPos = [[MyLayoutPos alloc] initWithView:self.view anchorType:MyLayoutAnchorType_Bottom];
    }
    return _bottomPos;
}

- (MyLayoutPos *)trailingPos {
    if (_trailingPos == nil) {
        _trailingPos = [[MyLayoutPos alloc] initWithView:self.view anchorType:MyLayoutAnchorType_Trailing];
    }
    return _trailingPos;
}

- (MyLayoutPos *)centerXPos {
    if (_centerXPos == nil) {
        _centerXPos = [[MyLayoutPos alloc] initWithView:self.view anchorType:MyLayoutAnchorType_CenterX];
    }
    return _centerXPos;
}

- (MyLayoutPos *)centerYPos {
    if (_centerYPos == nil) {
        _centerYPos = [[MyLayoutPos alloc] initWithView:self.view anchorType:MyLayoutAnchorType_CenterY];
    }
    return _centerYPos;
}

- (MyLayoutPos *)leftPos {
    return [MyViewTraitsImpl isRTL] ? self.trailingPos : self.leadingPos;
}

- (MyLayoutPos *)rightPos {
    return [MyViewTraitsImpl isRTL] ? self.leadingPos : self.trailingPos;
}

- (MyLayoutPos *)baselinePos {
    if (_baselinePos == nil) {
        _baselinePos = [[MyLayoutPos alloc] initWithView:self.view anchorType:MyLayoutAnchorType_Baseline];
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
        _widthSize = [[MyLayoutSize alloc] initWithView:self.view anchorType:MyLayoutAnchorType_Width];
    }
    return _widthSize;
}

- (MyLayoutSize *)heightSize {
    if (_heightSize == nil) {
        _heightSize = [[MyLayoutSize alloc] initWithView:self.view anchorType:MyLayoutAnchorType_Height];
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
    return [MyViewTraitsImpl isRTL] ? self.trailingPosInner : self.leadingPosInner;
}

- (MyLayoutPos *)rightPosInner {
    return [MyViewTraitsImpl isRTL] ? self.leadingPosInner : self.trailingPosInner;
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
    MyViewTraitsImpl *layoutTraits = [[[self class] allocWithZone:zone] init];

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
    MyGravity horzAlignment = [MyViewTraitsImpl convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(self.alignment)];
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

@implementation MyLayoutTraitsImpl

@synthesize zeroPadding = _zeroPadding;
@synthesize reverseLayout;
@synthesize layoutTransform = _layoutTransform;
@synthesize gravity;
@synthesize insetLandscapeFringePadding;
@synthesize paddingTop;
@synthesize paddingLeading;
@synthesize paddingBottom;
@synthesize paddingTrailing;
@synthesize insetsPaddingFromSafeArea = _insetsPaddingFromSafeArea;
@synthesize subviewVSpacing;
@synthesize subviewHSpacing;


- (id)init {
    self = [super init];
    if (self != nil) {
        _zeroPadding = YES;
        _insetsPaddingFromSafeArea = UIRectEdgeLeft | UIRectEdgeRight;
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
    return [MyViewTraitsImpl isRTL] ? self.paddingTrailing : self.paddingLeading;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    if ([MyViewTraitsImpl isRTL]) {
        self.paddingTrailing = paddingLeft;
    } else {
        self.paddingLeading = paddingLeft;
    }
}

- (CGFloat)paddingRight {
    return [MyViewTraitsImpl isRTL] ? self.paddingLeading : self.paddingTrailing;
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    if ([MyViewTraitsImpl isRTL]) {
        self.paddingLeading = paddingRight;
    } else {
        self.paddingTrailing = paddingRight;
    }
}

- (CGFloat)myLayoutPaddingTop {
    //如果padding值是特殊的值。
    if (self.paddingTop >= MyLayoutPos.safeAreaMargin - 2000 && self.paddingTop <= MyLayoutPos.safeAreaMargin + 2000) {
        return self.paddingTop - MyLayoutPos.safeAreaMargin + self.view.safeAreaInsets.top;
    }

    if ((self.insetsPaddingFromSafeArea & UIRectEdgeTop) == UIRectEdgeTop) {
        return self.paddingTop + self.view.safeAreaInsets.top;
    }
    return self.paddingTop;
}

- (CGFloat)myLayoutPaddingBottom {
    //如果padding值是特殊的值。
    if (self.paddingBottom >= MyLayoutPos.safeAreaMargin - 2000 && self.paddingBottom <= MyLayoutPos.safeAreaMargin + 2000) {
        return self.paddingBottom - MyLayoutPos.safeAreaMargin + self.view.safeAreaInsets.bottom;
    }

    if ((self.insetsPaddingFromSafeArea & UIRectEdgeBottom) == UIRectEdgeBottom) {
        return self.paddingBottom + self.view.safeAreaInsets.bottom;
    }
    return self.paddingBottom;
}

- (CGFloat)myLayoutPaddingLeading {
    if (self.paddingLeading >= MyLayoutPos.safeAreaMargin - 2000 && self.paddingLeading <= MyLayoutPos.safeAreaMargin + 2000) {
        return self.paddingLeading - MyLayoutPos.safeAreaMargin + self.view.safeAreaInsets.left;
    }

    CGFloat inset = 0;
    UIRectEdge edge = [MyViewTraitsImpl isRTL] ? UIRectEdgeRight : UIRectEdgeLeft;
#if TARGET_OS_IOS
    UIDeviceOrientation devori = [MyViewTraitsImpl isRTL] ? UIDeviceOrientationLandscapeLeft : UIDeviceOrientationLandscapeRight;
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
            inset = [MyViewTraitsImpl isRTL] ? self.view.safeAreaInsets.right : self.view.safeAreaInsets.left;
    }
    return self.paddingLeading + inset;
}

- (CGFloat)myLayoutPaddingTrailing {
    if (self.paddingTrailing >= MyLayoutPos.safeAreaMargin - 2000 && self.paddingTrailing <= MyLayoutPos.safeAreaMargin + 2000) {
        return self.paddingTrailing - MyLayoutPos.safeAreaMargin + self.view.safeAreaInsets.right;
    }

    CGFloat inset = 0;
    UIRectEdge edge = [MyViewTraitsImpl isRTL] ? UIRectEdgeLeft : UIRectEdgeRight;
#if TARGET_OS_IOS
    UIDeviceOrientation devori = [MyViewTraitsImpl isRTL] ? UIDeviceOrientationLandscapeRight : UIDeviceOrientationLandscapeLeft;
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
            inset = [MyViewTraitsImpl isRTL] ? self.view.safeAreaInsets.left : self.view.safeAreaInsets.right;
    }
    return self.paddingTrailing + inset;
}

- (CGFloat)myLayoutPaddingLeft {
    return [MyViewTraitsImpl isRTL] ? [self myLayoutPaddingTrailing] : [self myLayoutPaddingLeading];
}
- (CGFloat)myLayoutPaddingRight {
    return [MyViewTraitsImpl isRTL] ? [self myLayoutPaddingLeading] : [self myLayoutPaddingTrailing];
}

- (CGFloat)subviewSpacing {
    return self.subviewVSpacing;
}

- (void)setSubviewSpacing:(CGFloat)subviewSpacing {
    self.subviewVSpacing = subviewSpacing;
    self.subviewHSpacing = subviewSpacing;
}

- (id)copyWithZone:(NSZone *)zone {
    MyLayoutTraitsImpl *layoutTraits = [super copyWithZone:zone];
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
    layoutTraits.subviewVSpacing = self.subviewVSpacing;
    layoutTraits.subviewHSpacing = self.subviewHSpacing;

    return layoutTraits;
}

- (NSString *)debugDescription {
    NSString *dbgDesc = [super debugDescription];
    dbgDesc = [NSString stringWithFormat:@"%@\nLayout:\npadding=%@\nzeroPadding=%@\ngravity=%hu\nreverseLayout=%@\nsubviewVertSpacing=%f\nsubviewHorzSpacing=%f",
                                         dbgDesc,
                                         NSStringFromUIEdgeInsets(self.padding),
                                         self.zeroPadding ? @"YES" : @"NO",
                                         self.gravity,
                                         self.reverseLayout ? @"YES" : @"NO",
                                         self.subviewVSpacing,
                                         self.subviewHSpacing];

    return dbgDesc;
}

#pragma mark -- Helper

- (NSMutableArray<MyLayoutEngine *> *)filterEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines {
    
    if (subviewEngines == nil) {
        NSAssert(NO, @"oops!");
//        subviewEngines = [NSMutableArray arrayWithCapacity:self.view.subviews.count];
//        for (UIView *subview in self.view.subviews) {
//            [subviewEngines addObject:subview.myEngine];
//        }
    }
    
    NSInteger count = subviewEngines.count;
    if (self.reverseLayout) {
        //翻转一个数组。
        for (NSInteger i = 0; i < count / 2; i++) {
            [subviewEngines exchangeObjectAtIndex:i withObjectAtIndex:count - 1 - i];
        }
    }
    
    for (NSInteger i = count - 1; i >= 0; i--) {
        MyViewTraitsImpl *subviewTraits = subviewEngines[i].currentTraits;
        if ([subviewTraits invalid]) {
            [subviewEngines removeObjectAtIndex:i];
        }
    }
    
    return subviewEngines;
}


@end

@implementation MySequentLayoutFlexSpacing

- (CGFloat)calcMaxMinSubviewsSizeForContent:(CGFloat)selfSize paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding spacing:(CGFloat *)pSpacing {
    CGFloat subviewsSize = self.subviewsSize;

    CGFloat extralSpacing = self.minSpacing;
    if (self.centered) {
        extralSpacing *= -1;
    }
    NSInteger rowCount = MAX(floor((selfSize - (*pStarPadding) - (*pEndPadding) + extralSpacing) / (subviewsSize + self.minSpacing)), 1);
    NSInteger spacingCount = rowCount - 1;
    if (self.centered) {
        spacingCount += 2;
    }
    if (spacingCount > 0) {
        *pSpacing = (selfSize - (*pStarPadding) - (*pEndPadding) - subviewsSize * rowCount) / spacingCount;
        if (_myCGFloatGreat(*pSpacing, self.maxSpacing)) {
            *pSpacing = self.maxSpacing;
            subviewsSize = (selfSize - (*pStarPadding) - (*pEndPadding) - (*pSpacing) * spacingCount) / rowCount;
        }
        if (self.centered) {
            *pStarPadding = (*pStarPadding + *pSpacing);
            *pEndPadding = (*pEndPadding + *pSpacing);
        }
    }
    return subviewsSize;
}

- (CGFloat)calcMaxMinSubviewsSize:(CGFloat)selfSize arrangedCount:(NSInteger)arrangedCount paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding spacing:(CGFloat *)pSpacing {
    CGFloat subviewsSize = self.subviewsSize;

    NSInteger spacingCount = arrangedCount - 1;
    if (self.centered) {
        spacingCount += 2;
    }
    if (spacingCount > 0) {
        *pSpacing = (selfSize - *pStarPadding - *pEndPadding - subviewsSize * arrangedCount) / spacingCount;

        if (_myCGFloatGreat(*pSpacing, self.maxSpacing) || _myCGFloatLess(*pSpacing, self.minSpacing)) {
            if (_myCGFloatGreat(*pSpacing, self.maxSpacing)) {
                *pSpacing = self.maxSpacing;
            }
            if (_myCGFloatLess(*pSpacing, self.minSpacing)) {
                *pSpacing = self.minSpacing;
            }
            subviewsSize = (selfSize - *pStarPadding - *pEndPadding - (*pSpacing) * spacingCount) / arrangedCount;
        }
        if (self.centered) {
            *pStarPadding = (*pStarPadding + *pSpacing);
            *pEndPadding = (*pEndPadding + *pSpacing);
        }
    }
    return subviewsSize;
}

@end

@implementation MySequentLayoutTraitsImpl

@synthesize orientation;

- (id)copyWithZone:(NSZone *)zone {
    MySequentLayoutTraitsImpl *layoutTraits = [super copyWithZone:zone];
    layoutTraits.orientation = self.orientation;
    if (self.flexSpacing != nil) {
        layoutTraits.flexSpacing = [MySequentLayoutFlexSpacing new];
        layoutTraits.flexSpacing.subviewsSize = self.flexSpacing.subviewsSize;
        layoutTraits.flexSpacing.minSpacing = self.flexSpacing.minSpacing;
        layoutTraits.flexSpacing.maxSpacing = self.flexSpacing.maxSpacing;
        layoutTraits.flexSpacing.centered = self.flexSpacing.centered;
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

@implementation MyLinearLayoutTraitsImpl

@synthesize shrinkType;


- (id)copyWithZone:(NSZone *)zone {
    MyLinearLayoutTraitsImpl *layoutTraits = [super copyWithZone:zone];
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

@implementation MyTableLayoutTraitsImpl

@end

@implementation MyFloatLayoutTraitsImpl

- (id)copyWithZone:(NSZone *)zone {
    MyFloatLayoutTraitsImpl *layoutTraits = [super copyWithZone:zone];
    return layoutTraits;
}

@end

@implementation MyFlowLayoutTraitsImpl

@synthesize arrangedGravity;
@synthesize autoArrange;
@synthesize isFlex;
@synthesize lastlineGravityPolicy;
@synthesize maxLines = _maxLines;
@synthesize arrangedCount;
@synthesize pagedCount;


- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _maxLines = NSIntegerMax;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    MyFlowLayoutTraitsImpl *layoutTraits = [super copyWithZone:zone];
    layoutTraits.arrangedCount = self.arrangedCount;
    layoutTraits.autoArrange = self.autoArrange;
    layoutTraits.isFlex = self.isFlex;
    layoutTraits.lastlineGravityPolicy = self.lastlineGravityPolicy;
    layoutTraits.maxLines = self.maxLines;
    layoutTraits.arrangedGravity = self.arrangedGravity;
    layoutTraits.pagedCount = self.pagedCount;
    return layoutTraits;
}

- (NSString *)debugDescription {
    NSString *dbgDesc = [super debugDescription];
    dbgDesc = [NSString stringWithFormat:@"%@\nFlowLayout: \narrangedCount=%ld\nautoArrange=%@\nisFlex=%@\narrangedGravity=%hu\npagedCount=%ld\nmaxLines=%ld",
                                         dbgDesc,
                                         (long)self.arrangedCount,
                                         self.autoArrange ? @"YES" : @"NO",
                                         self.isFlex ? @"YES" : @"NO",
                                         self.arrangedGravity,
                                         (long)self.pagedCount,
                                         (long)self.maxLines];

    return dbgDesc;
}

@end

@implementation MyRelativeLayoutTraitsImpl

@end

@implementation MyFrameLayoutTraitsImpl
@end

@implementation MyPathLayoutTraitsImpl
@end

@interface MyGridLayoutTraitsImpl () <MyGridNode>

@property (nonatomic, strong) MyGridNode *rootGrid;

@end

@implementation MyGridLayoutTraitsImpl

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
    MyGridLayoutTraitsImpl *lsc = [super copyWithZone:zone];
    lsc->_rootGrid = (MyGridNode *)[self.rootGrid cloneGrid];
    return lsc;
}

@end

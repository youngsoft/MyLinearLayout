//
//  MyLayoutPos.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutPos.h"
#import "MyBaseLayout.h"
#import "MyLayoutInner.h"
#import "MyLayoutPosInner.h"


@implementation MyLayoutPos 

+ (CGFloat)safeAreaMargin {
    //在2017年10月3号定义的一个数字，没有其他特殊意义。
    return -20171003.0;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _active = YES;
        _view = nil;
        _val = nil;
        _valType = MyLayoutValType_Nil;
        _offsetVal = 0;
        _lBoundVal = nil;
        _uBoundVal = nil;
        _shrink = 0.0;
    }

    return self;
}

- (MyLayoutPos * (^)(id val))myEqualTo {
    return ^id(id val) {
        [self _myEqualTo:val];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutPos * (^)(CGFloat val))myOffset {
    return ^id(CGFloat val) {
        [self _myOffset:val];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutPos * (^)(CGFloat val))myMin {
    return ^id(CGFloat val) {
        [self _myMin:val];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutPos * (^)(CGFloat val))myMax {
    return ^id(CGFloat val) {
        [self _myMax:val];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutPos * (^)(id posVal, CGFloat offset))myLBound {
    return ^id(id posVal, CGFloat offset) {
        [self _myLBound:posVal offsetVal:offset];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutPos * (^)(id posVal, CGFloat offset))myUBound {
    return ^id(id posVal, CGFloat offset) {
        [self _myUBound:posVal offsetVal:offset];
        [self setNeedsLayout];
        return self;
    };
}

- (void)myClear {
    [self _myClear];
    [self setNeedsLayout];
}

- (MyLayoutPos * (^)(id val))equalTo {
    return self.myEqualTo;
}

- (MyLayoutPos * (^)(CGFloat val))offset {
    return self.myOffset;
}

- (MyLayoutPos * (^)(CGFloat val))min {
    return self.myMin;
}

- (MyLayoutPos * (^)(id posVal, CGFloat offsetVal))lBound {
    return self.myLBound;
}

- (MyLayoutPos * (^)(CGFloat val))max {
    return self.myMax;
}

- (MyLayoutPos * (^)(id posVal, CGFloat offsetVal))uBound {
    return self.myUBound;
}

- (void)clear {
    [self myClear];
}

- (void)setActive:(BOOL)active {
    if (_active != active) {
        [self _mySetActive:active];
        [self setNeedsLayout];
    }
}

- (CGFloat)shrink {
    return self.isActive ? _shrink : 0;
}

- (id)val {
    return self.isActive ? _val : nil;
}

- (CGFloat)offsetVal {
    return self.isActive ? _offsetVal : 0;
}

- (CGFloat)minVal {
    return self.isActive && _lBoundVal != nil ? _lBoundVal.numberVal.doubleValue : -CGFLOAT_MAX;
}

- (CGFloat)maxVal {
    return self.isActive && _uBoundVal != nil ?  _uBoundVal.numberVal.doubleValue : CGFLOAT_MAX;
}

#pragma mark-- NSCopying

- (id)copyWithZone:(NSZone *)zone {
    MyLayoutPos *layoutPos = [[[self class] allocWithZone:zone] init];
    layoutPos.view = self.view;
    layoutPos->_active = _active;
    layoutPos->_shrink = _shrink;
    layoutPos->_anchorType = _anchorType;
    layoutPos->_valType = _valType;
    layoutPos->_val = _val;
    layoutPos->_offsetVal = _offsetVal;
    if (_lBoundVal != nil) {
        layoutPos->_lBoundVal = [[[self class] allocWithZone:zone] init];
        layoutPos->_lBoundVal->_active = _active;
        [[layoutPos->_lBoundVal _myEqualTo:_lBoundVal.val] _myOffset:_lBoundVal.offsetVal];
    }
    if (_uBoundVal != nil) {
        layoutPos->_uBoundVal = [[[self class] allocWithZone:zone] init];
        layoutPos->_uBoundVal->_active = _active;
        [[layoutPos->_uBoundVal _myEqualTo:_uBoundVal.val] _myOffset:_uBoundVal.offsetVal];
    }

    return layoutPos;
}

#pragma mark-- Private Methods

- (NSNumber *)numberVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_Number) {
        return _val;
    } else if (_valType == MyLayoutValType_UILayoutSupport) {
        //只有在11以后并且是设置了safearea缩进才忽略UILayoutSupport。
        UIView *superview = self.view.superview;
        if (@available(iOS 11.0, *)) {
            if (superview != nil && [superview isKindOfClass:[MyBaseLayout class]]) {
                UIRectEdge edge = ((MyBaseLayout *)superview).insetsPaddingFromSafeArea;
                if ((_anchorType == MyLayoutAnchorType_Top && (edge & UIRectEdgeTop) == UIRectEdgeTop) ||
                    (_anchorType == MyLayoutAnchorType_Bottom && (edge & UIRectEdgeBottom) == UIRectEdgeBottom)) {
                    return @(0);
                }
            }
        }

        return @([((id<UILayoutSupport>)_val) length]);
    } else if (_valType == MyLayoutValType_SafeArea) {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {
            UIView *superView = self.view.superview;
            switch (_anchorType) {
                case MyLayoutAnchorType_Leading:
                    return [MyBaseLayout isRTL] ? @(superView.safeAreaInsets.right) : @(superView.safeAreaInsets.left);
                    break;
                case MyLayoutAnchorType_Trailing:
                    return [MyBaseLayout isRTL] ? @(superView.safeAreaInsets.left) : @(superView.safeAreaInsets.right);
                    break;
                case MyLayoutAnchorType_Top:
                    return @(superView.safeAreaInsets.top);
                    break;
                case MyLayoutAnchorType_Bottom:
                    return @(superView.safeAreaInsets.bottom);
                    break;
                default:
                    return @(0);
                    break;
            }
        }
#endif
        if (_anchorType == MyLayoutAnchorType_Top) {
            return @([self findContainerVC].topLayoutGuide.length);
        } else if (_anchorType == MyLayoutAnchorType_Bottom) {
            return @([self findContainerVC].bottomLayoutGuide.length);
        }
        return @(0);
    }
    return nil;
}

- (UIViewController *)findContainerVC {
    UIViewController *vc = nil;
    @try {
        UIView *v = self.view;
        while (v != nil) {
            vc = [v valueForKey:@"viewDelegate"];
            if (vc != nil) {
                break;
            }
            v = [v superview];
        }
    } @catch (NSException *exception) {
    }

    return vc;
}

- (MyLayoutPos *)anchorVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_LayoutPos) {
        return _val;
    }
    return nil;
}

- (NSArray *)arrayVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_Array) {
        return _val;
    }
    return nil;
}

- (NSNumber *)mostVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_Most) {
        return @([((MyLayoutMostPos *)_val) getMostAxisValFrom:self]);
    }
    return nil;
}

- (MyLayoutPos *)lBoundVal {
    if (_lBoundVal == nil) {
        _lBoundVal = [[MyLayoutPos alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal _myEqualTo:@(-CGFLOAT_MAX)];
    }
    return _lBoundVal;
}

- (MyLayoutPos *)uBoundVal {
    if (_uBoundVal == nil) {
        _uBoundVal = [[MyLayoutPos alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal _myEqualTo:@(CGFLOAT_MAX)];
    }
    return _uBoundVal;
}

- (MyLayoutPos *)lBoundValInner {
    return _lBoundVal;
}

- (MyLayoutPos *)uBoundValInner {
    return _uBoundVal;
}

- (MyLayoutPos *)_myEqualTo:(id)val {
    if (![_val isEqual:val]) {
        if ([val isKindOfClass:[NSNumber class]]) {
            //特殊处理设置为safeAreaMargin边距的值。
            if ([val doubleValue] == [MyLayoutPos safeAreaMargin]) {
                _valType = MyLayoutValType_SafeArea;
            } else {
                _valType = MyLayoutValType_Number;
            }
        } else if ([val isKindOfClass:[MyLayoutPos class]]) {
            _valType = MyLayoutValType_LayoutPos;
        } else if ([val isKindOfClass:[NSArray class]]) {
            _valType = MyLayoutValType_Array;
        } else if ([val conformsToProtocol:@protocol(UILayoutSupport)]) {
            //这里只有上边和下边支持，其他不支持。。
            if (_anchorType != MyLayoutAnchorType_Top && _anchorType != MyLayoutAnchorType_Bottom) {
                NSAssert(0, @"oops! only topPos or bottomPos can set to id<UILayoutSupport>");
            }
            _valType = MyLayoutValType_UILayoutSupport;
        } else if ([val isKindOfClass:[MyLayoutMostPos class]]) {
            _valType = MyLayoutValType_Most;
        } else if ([val isKindOfClass:[UIView class]]) {
            UIView *rview = (UIView *)val;
            _valType = MyLayoutValType_LayoutPos;

            switch (_anchorType) {
                case MyLayoutAnchorType_Leading:
                    val = rview.leadingPos;
                    break;
                case MyLayoutAnchorType_CenterX:
                    val = rview.centerXPos;
                    break;
                case MyLayoutAnchorType_Trailing:
                    val = rview.trailingPos;
                    break;
                case MyLayoutAnchorType_Top:
                    val = rview.topPos;
                    break;
                case MyLayoutAnchorType_CenterY:
                    val = rview.centerYPos;
                    break;
                case MyLayoutAnchorType_Bottom:
                    val = rview.bottomPos;
                    break;
                case MyLayoutAnchorType_Baseline:
                    val = rview.baselinePos;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }
        } else {
            _valType = MyLayoutValType_Nil;
        }
        _val = val;
    }

    return self;
}

- (MyLayoutPos *)_myOffset:(CGFloat)val {
    if (_offsetVal != val) {
        _offsetVal = val;
    }
    return self;
}

- (MyLayoutPos *)_myMin:(CGFloat)val {
    if (self.lBoundVal.numberVal.doubleValue != val) {
        [self.lBoundVal _myEqualTo:@(val)];
    }
    return self;
}

- (MyLayoutPos *)_myLBound:(id)posVal offsetVal:(CGFloat)offsetVal {
    [[self.lBoundVal _myEqualTo:posVal] _myOffset:offsetVal];
    return self;
}

- (MyLayoutPos *)_myMax:(CGFloat)val {
    if (self.uBoundVal.numberVal.doubleValue != val) {
        [self.uBoundVal _myEqualTo:@(val)];
    }
    return self;
}

- (MyLayoutPos *)_myUBound:(id)posVal offsetVal:(CGFloat)offsetVal {
    [[self.uBoundVal _myEqualTo:posVal] _myOffset:offsetVal];
    return self;
}

- (void)_myClear {
    _active = YES;
    _val = nil;
    _valType = MyLayoutValType_Nil;
    _offsetVal = 0;
    _lBoundVal = nil;
    _uBoundVal = nil;
    _shrink = 0;
}

- (void)_mySetActive:(BOOL)active {
    _active = active;
    [_lBoundVal _mySetActive:active];
    [_uBoundVal _mySetActive:active];
}

- (CGFloat)measure {
    if (self.isActive) {
        CGFloat retVal = _offsetVal;
        if (self.numberVal != nil) {
            retVal += self.numberVal.doubleValue;
        }
        if (_uBoundVal != nil) {
            retVal = _myCGFloatMin(_uBoundVal.numberVal.doubleValue, retVal);
        }
        if (_lBoundVal != nil) {
            retVal = _myCGFloatMax(_lBoundVal.numberVal.doubleValue, retVal);
        }
        return retVal;
    } else {
        return 0;
    }
}

- (BOOL)isRelativePos {
    if (self.isActive) {
        CGFloat realPos = self.numberVal.doubleValue;
        return realPos > 0 && realPos < 1;
    } else {
        return NO;
    }
}

- (BOOL)isSafeAreaPos {
    return self.isActive && (_valType == MyLayoutValType_SafeArea || _valType == MyLayoutValType_UILayoutSupport);
}

- (CGFloat)measureWith:(CGFloat)refVal {
    if (self.isActive) {
        CGFloat retVal = self.numberVal.doubleValue;
        if (retVal > 0 && retVal < 1) {
            retVal *= refVal;
        }
        retVal += _offsetVal;

        if (_uBoundVal != nil) {
            retVal = _myCGFloatMin(_uBoundVal.numberVal.doubleValue, retVal);
        }
        if (_lBoundVal != nil) {
            retVal = _myCGFloatMax(_lBoundVal.numberVal.doubleValue, retVal);
        }
        return retVal;
    } else {
        return 0;
    }
}

- (void)setNeedsLayout {
    if (_view != nil && _view.superview != nil && [_view.superview isKindOfClass:[MyBaseLayout class]]) {
        MyBaseLayout *lb = (MyBaseLayout *)_view.superview;
        if (!lb.isMyLayouting) {
            [_view.superview setNeedsLayout];
        }
    }
}

+ (NSString *)axisstrFromAnchor:(MyLayoutPos *)anchor showView:(BOOL)showView {
    NSString *viewstr = @"";
    if (showView) {
        viewstr = [NSString stringWithFormat:@"view:%p.", anchor.view];
    }
    NSString *axisstr = @"";

    switch (anchor.anchorType) {
        case MyLayoutAnchorType_Leading:
            axisstr = @"leadingPos";
            break;
        case MyLayoutAnchorType_CenterX:
            axisstr = @"centerXPos";
            break;
        case MyLayoutAnchorType_Trailing:
            axisstr = @"trailingPos";
            break;
        case MyLayoutAnchorType_Top:
            axisstr = @"topPos";
            break;
        case MyLayoutAnchorType_CenterY:
            axisstr = @"centerYPos";
            break;
        case MyLayoutAnchorType_Bottom:
            axisstr = @"bottomPos";
            break;
        case MyLayoutAnchorType_Baseline:
            axisstr = @"baselinePos";
            break;
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@%@", viewstr, axisstr];
}

#pragma mark-- Override Method

- (NSString *)description {
    NSString *axisStr = @"";
    switch (_valType) {
        case MyLayoutValType_Nil:
            axisStr = @"nil";
            break;
        case MyLayoutValType_Number:
            axisStr = [_val description];
            break;
        case MyLayoutValType_LayoutPos:
            axisStr = [MyLayoutPos axisstrFromAnchor:_val showView:YES];
            break;
        case MyLayoutValType_Array: {
            axisStr = @"[";
            for (NSObject *item in _val) {
                if ([item isKindOfClass:[MyLayoutPos class]]) {
                    axisStr = [axisStr stringByAppendingString:[MyLayoutPos axisstrFromAnchor:(MyLayoutPos *)item showView:YES]];
                } else {
                    axisStr = [axisStr stringByAppendingString:[item description]];
                }
                if (item != [_val lastObject]) {
                    axisStr = [axisStr stringByAppendingString:@", "];
                }
            }

            axisStr = [axisStr stringByAppendingString:@"]"];
        }
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@=%@, offset=%g, max=%g, min=%g", [MyLayoutPos axisstrFromAnchor:self showView:NO], axisStr, _offsetVal, _uBoundVal.numberVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.numberVal.doubleValue, _uBoundVal.numberVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.numberVal.doubleValue];
}

@end

@implementation MyLayoutPos (Clone)

- (MyLayoutPos * (^)(CGFloat offsetVal))clone {
    return ^id(CGFloat offsetVal) {
        MyLayoutPos *clonedAnchor = [[[self class] allocWithZone:nil] init];
        clonedAnchor->_offsetVal = offsetVal;
        clonedAnchor->_val = self;
        clonedAnchor->_valType = MyLayoutValType_LayoutAnchorClone;
        return clonedAnchor;
    };
}

@end

#pragma mark-- MyLayoutMostPos

@implementation MyLayoutMostPos {
    NSArray *_axes;
    BOOL _isMax;
}

- (instancetype)initWith:(NSArray *)axes isMax:(BOOL)isMax {
    self = [self init];
    if (self != nil) {
        _axes = axes;
        _isMax = isMax;
    }
    return self;
}

- (CGFloat)getMostAxisValFrom:(MyLayoutPos *)srcAnchor {
    CGFloat mostAxisVal = _isMax ? -CGFLOAT_MAX : CGFLOAT_MAX;
    for (id axis in _axes) {
        CGFloat axisVal = 0;
        if ([axis isKindOfClass:[NSNumber class]]) {
            axisVal = [(NSNumber *)axis doubleValue];
        } else if ([axis isKindOfClass:[MyLayoutPos class]]) {
            MyLayoutPos *anchor = (MyLayoutPos *)axis;
            CGFloat offset = 0.0;
            if (anchor.valType == MyLayoutValType_LayoutAnchorClone) {
                offset = anchor.offsetVal;
                anchor = (MyLayoutPos *)anchor.val;
            }

            MyLayoutEngine *viewEngine = anchor.view.myEngine;

            if (srcAnchor.anchorType & MyLayoutAnchorType_VertMask) { //水平
                if (anchor.anchorType == MyLayoutAnchorType_Leading) {
                    axisVal = viewEngine.leading + offset;
                } else if (anchor.anchorType == MyLayoutAnchorType_CenterX) {
                    axisVal = viewEngine.leading + viewEngine.width / 2.0 + offset;
                } else {
                    axisVal = viewEngine.trailing - offset;
                }
            } else { //垂直
                if (anchor.anchorType == MyLayoutAnchorType_Top) {
                    axisVal = viewEngine.top + offset;
                } else if (anchor.anchorType == MyLayoutAnchorType_CenterY) {
                    axisVal = viewEngine.top + viewEngine.height / 2.0 + offset;
                } else {
                    axisVal = viewEngine.bottom - offset;
                }
            }
        } else {
            NSAssert(NO, @"oops!, invalid type, only support NSNumber or MyLayoutPos");
        }
        mostAxisVal = _isMax ? _myCGFloatMax(axisVal, mostAxisVal) : _myCGFloatMin(axisVal, mostAxisVal);
    }
    return mostAxisVal;
}

@end

@implementation NSArray (MyLayoutMostPos)

- (MyLayoutMostPos *)myMinPos {
    return [[MyLayoutMostPos alloc] initWith:self isMax:NO];
}

- (MyLayoutMostPos *)myMaxPos {
    return [[MyLayoutMostPos alloc] initWith:self isMax:YES];
}

@end

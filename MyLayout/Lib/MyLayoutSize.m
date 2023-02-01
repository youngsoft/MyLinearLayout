//
//  MyLayoutSize.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutSize.h"
#import "MyBaseLayout.h"
#import "MyLayoutInner.h"
#import "MyLayoutSizeInner.h"

@implementation MyLayoutSize 

+ (NSInteger)empty {
    return -100000; //这么定义存粹是一个数字没有其他意义
}

+ (NSInteger)wrap {
    return -99999; //这么定义纯粹是一个数字没有其他意义
}

+ (NSInteger)fill {
    return -99998; //这么定义纯粹是一个数字没有其他意义
}

+ (NSInteger)average {
    return -99997; //这么定义纯粹是一个数字没有其他意义
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _active = YES;
        _view = nil;
        _val = nil;
        _valType = MyLayoutValType_Nil;
        _addVal = 0;
        _multiVal = 1;
        _lBoundVal = nil;
        _uBoundVal = nil;
        _shrink = 0.0;
        _priority = MyPriority_Normal;
    }
    return self;
}

- (MyLayoutSize * (^)(id val))myEqualTo {
    return ^id(id val) {
        [self _myEqualTo:val];
        //如果尺寸是自适应，并且当前视图是布局视图则直接布局视图自身刷新布局，否则由视图的父视图来刷新布局，这里特殊处理。
        if ([val isKindOfClass:[NSNumber class]]) {
            if ([val integerValue] == MyLayoutSize.wrap && [self.view isKindOfClass:[MyBaseLayout class]]) {
                [self.view setNeedsLayout];
                return self;
            }
        }
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutSize * (^)(CGFloat val))myAdd {
    return ^id(CGFloat val) {
        [self _myAdd:val];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutSize * (^)(CGFloat val))myMultiply {
    return ^id(CGFloat val) {
        [self _myMultiply:val];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutSize * (^)(CGFloat val))myMin {
    return ^id(CGFloat val) {
        [self _myMin:val];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myLBound {
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal) {
        [self _myLBound:sizeVal addVal:addVal multiVal:multiVal];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutSize * (^)(CGFloat val))myMax {
    return ^id(CGFloat val) {
        [self _myMax:val];
        [self setNeedsLayout];
        return self;
    };
}

- (MyLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myUBound {
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal) {
        [self _myUBound:sizeVal addVal:addVal multiVal:multiVal];
        [self setNeedsLayout];
        return self;
    };
}

- (void)myClear {
    [self _myClear];
    [self setNeedsLayout];
}

- (MyLayoutSize * (^)(id val))equalTo {
    return self.myEqualTo;
}

- (MyLayoutSize * (^)(CGFloat val))add {
    return self.myAdd;
}

- (MyLayoutSize * (^)(CGFloat val))multiply {
    return self.myMultiply;
}

- (MyLayoutSize * (^)(CGFloat val))min {
    return self.myMin;
}

- (MyLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))lBound {
    return self.myLBound;
}

- (MyLayoutSize * (^)(CGFloat val))max {
    return self.myMax;
}

- (MyLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))uBound {
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
    return _active ? _shrink : 0.0;
}

- (id)val {
    return self.isActive ? _val : nil;
}

- (BOOL)isWrap {
    return _valType == MyLayoutValType_Wrap;
}

- (BOOL)isFill {
    return _valType == MyLayoutValType_Fill;
}

#pragma mark-- NSCopying

- (id)copyWithZone:(NSZone *)zone {
    MyLayoutSize *layoutSize = [[[self class] allocWithZone:zone] init];
    layoutSize->_view = _view;
    layoutSize->_active = _active;
    layoutSize->_shrink = _shrink;
    layoutSize->_anchorType = _anchorType;
    layoutSize->_addVal = _addVal;
    layoutSize->_multiVal = _multiVal;
    layoutSize->_val = _val;
    layoutSize->_valType = _valType;
    layoutSize->_priority = _priority;
    if (_lBoundVal != nil) {
        layoutSize->_lBoundVal = [[[self class] allocWithZone:zone] init];
        layoutSize->_lBoundVal->_active = _active;
        [[[layoutSize->_lBoundVal _myEqualTo:_lBoundVal.val] _myAdd:_lBoundVal.addVal] _myMultiply:_lBoundVal.multiVal];
    }
    if (_uBoundVal != nil) {
        layoutSize->_uBoundVal = [[[self class] allocWithZone:zone] init];
        layoutSize->_uBoundVal->_active = _active;
        [[[layoutSize->_uBoundVal _myEqualTo:_uBoundVal.val] _myAdd:_uBoundVal.addVal] _myMultiply:_uBoundVal.multiVal];
    }
    return layoutSize;
}

#pragma mark-- Private Methods

- (NSNumber *)numberVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_Number) {
        return _val;
    }
    if (_valType == MyLayoutValType_Most) {
        return @([((MyLayoutMostSize *)_val) getMostDimenValFrom:self]);
    }
    return nil;
}

- (MyLayoutSize *)anchorVal {
    if (_val == nil || !self.isActive) {
        return nil;
    }
    if (_valType == MyLayoutValType_LayoutSize) {
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

- (BOOL)wrapVal {
    return self.isActive && _valType == MyLayoutValType_Wrap;
}

- (BOOL)fillVal {
    return self.isActive && _valType == MyLayoutValType_Fill;
}

- (MyLayoutSize *)lBoundVal {
    if (_lBoundVal == nil) {
        _lBoundVal = [[MyLayoutSize alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal _myEqualTo:@(-CGFLOAT_MAX)];
    }
    return _lBoundVal;
}

- (MyLayoutSize *)uBoundVal {
    if (_uBoundVal == nil) {
        _uBoundVal = [[MyLayoutSize alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal _myEqualTo:@(CGFLOAT_MAX)];
    }
    return _uBoundVal;
}

- (MyLayoutSize *)lBoundValInner {
    return _lBoundVal;
}

- (MyLayoutSize *)uBoundValInner {
    return _uBoundVal;
}

- (CGFloat)minVal {
    return (self.isActive && _lBoundVal != nil) ?  _lBoundVal.numberVal.doubleValue : -CGFLOAT_MAX;
}

- (CGFloat)maxVal {
    return (self.isActive && _uBoundVal != nil) ?  _uBoundVal.numberVal.doubleValue : CGFLOAT_MAX;
}

- (MyLayoutSize *)_myEqualTo:(id)val {
    return [self _myEqualTo:val priority:MyPriority_Normal];
}

- (MyLayoutSize *)_myEqualTo:(id)val priority:(NSInteger)priority {
    _priority = priority;
    if (![_val isEqual:val]) {
        if ([val isKindOfClass:[NSNumber class]]) {
            //特殊处理。
            if ([val integerValue] == MyLayoutSize.wrap) {
                _valType = MyLayoutValType_Wrap;
            } else if ([val integerValue] == MyLayoutSize.fill) {
                _valType = MyLayoutValType_Fill;
            } else if ([val integerValue] == MyLayoutSize.empty) {
                _valType = MyLayoutValType_Nil;
                val = nil;
            } else {
                _valType = MyLayoutValType_Number;
            }
        } else if ([val isMemberOfClass:[MyLayoutSize class]]) {
            //我们支持尺寸等于自己的情况，用来支持那些尺寸包裹内容但又想扩展尺寸的场景，为了不造成循环引用这里做特殊处理
            //当尺寸等于自己时，我们只记录_dimeValType，而把值设置为nil
            if (val == self) {
#if DEBUG
                NSLog(@"不建议这样设置，请使用MyLayoutSize.wrap代替！");
#endif
                _valType = MyLayoutValType_Wrap;
                val = @(MyLayoutSize.wrap);
            } else {
                _valType = MyLayoutValType_LayoutSize;
            }
        } else if ([val isKindOfClass:[UIView class]]) {
            UIView *viewVal = (UIView *)val;
            _valType = MyLayoutValType_LayoutSize;
            switch (_anchorType) {
                case MyLayoutAnchorType_Width:
                    val = viewVal.widthSize;
                    break;
                case MyLayoutAnchorType_Height:
                    val = viewVal.heightSize;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }
        } else if ([val isKindOfClass:[NSArray class]]) {
            _valType = MyLayoutValType_Array;
        } else if ([val isKindOfClass:[MyLayoutMostSize class]]) {
            _valType = MyLayoutValType_Most;
        } else {
            _valType = MyLayoutValType_Nil;
        }
        //特殊处理UILabel的高度是wrap的情况。
        if (_valType == MyLayoutValType_Wrap && _view != nil && _anchorType == MyLayoutAnchorType_Height) {
            if ([_view isKindOfClass:[UILabel class]]) {
                if (((UILabel *)_view).numberOfLines == 1) {
                    ((UILabel *)_view).numberOfLines = 0;
                }
            }
        }
        _val = val;
    }
    return self;
}

//加
- (MyLayoutSize *)_myAdd:(CGFloat)val {
    if (_addVal != val) {
        _addVal = val;
    }
    return self;
}

//乘
- (MyLayoutSize *)_myMultiply:(CGFloat)val {
    if (_multiVal != val) {
        _multiVal = val;
    }
    return self;
}

- (MyLayoutSize *)_myMin:(CGFloat)val {
    if (self.lBoundVal.numberVal.doubleValue != val) {
        [self.lBoundVal _myEqualTo:@(val)];
    }
    return self;
}

- (MyLayoutSize *)_myLBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal {
    if (sizeVal == self) {
#if DEBUG
        NSLog(@"不建议这样设置，请使用MyLayoutSize.wrap代替！");
#endif
        sizeVal = @(MyLayoutSize.wrap);
    }

    [[[self.lBoundVal _myEqualTo:sizeVal] _myAdd:addVal] _myMultiply:multiVal];
    return self;
}

- (MyLayoutSize *)_myMax:(CGFloat)val {
    if (self.uBoundVal.numberVal.doubleValue != val) {
        [self.uBoundVal _myEqualTo:@(val)];
    }
    return self;
}

- (MyLayoutSize *)_myUBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal {
    if (sizeVal == self) {
#if DEBUG
        NSLog(@"不建议这样设置，请使用MyLayoutSize.wrap代替！");
#endif
        sizeVal = @(MyLayoutSize.wrap);
    }
    [[[self.uBoundVal _myEqualTo:sizeVal] _myAdd:addVal] _myMultiply:multiVal];
    return self;
}

- (void)_myClear {
    _active = YES;
    _addVal = 0;
    _multiVal = 1;
    _lBoundVal = nil;
    _uBoundVal = nil;
    _val = nil;
    _shrink = 0;
    _priority = MyPriority_Normal;
    _valType = MyLayoutValType_Nil;
}

- (void)_mySetActive:(BOOL)active {
    _active = active;
    [_lBoundVal _mySetActive:active];
    [_uBoundVal _mySetActive:active];
}

- (CGFloat)measure {
    return self.isActive ? _myCGFloatFma(self.numberVal.doubleValue, _multiVal, _addVal) : 0;
}

- (CGFloat)measureWith:(CGFloat)size {
    return self.isActive ? _myCGFloatFma(size, _multiVal, _addVal) : size;
}

- (void)setNeedsLayout {
    if (_view != nil && _view.superview != nil && [_view.superview isKindOfClass:[MyBaseLayout class]]) {
        MyBaseLayout *layoutView = (MyBaseLayout *)_view.superview;
        if (!layoutView.isMyLayouting) {
            [_view.superview setNeedsLayout];
        }
    }
}

+ (NSString *)dimenstrFromAnchor:(MyLayoutSize *)anchor showView:(BOOL)showView {
    NSString *viewstr = @"";
    if (showView) {
        viewstr = [NSString stringWithFormat:@"view:%p.", anchor.view];
    }
    NSString *dimenstr = @"";

    switch (anchor.anchorType) {
        case MyLayoutAnchorType_Width:
            dimenstr = @"widthSize";
            break;
        case MyLayoutAnchorType_Height:
            dimenstr = @"heightSize";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@%@", viewstr, dimenstr];
}

#pragma mark-- Override Methods

- (NSString *)description {
    NSString *dimenStr = @"";
    switch (_valType) {
        case MyLayoutValType_Nil:
            dimenStr = @"nil";
            break;
        case MyLayoutValType_Number:
            dimenStr = [_val description];
            break;
        case MyLayoutValType_Wrap:
            dimenStr = @"wrap";
            break;
        case MyLayoutValType_Fill:
            dimenStr = @"fill";
            break;
        case MyLayoutValType_LayoutSize:
            dimenStr = [MyLayoutSize dimenstrFromAnchor:_val showView:YES];
            break;
        case MyLayoutValType_Array: {
            dimenStr = @"[";
            for (NSObject *item in _val) {
                if ([item isKindOfClass:[MyLayoutSize class]]) {
                    dimenStr = [dimenStr stringByAppendingString:[MyLayoutSize dimenstrFromAnchor:(MyLayoutSize *)item showView:YES]];
                } else {
                    dimenStr = [dimenStr stringByAppendingString:[item description]];
                }
                if (item != [_val lastObject]) {
                    dimenStr = [dimenStr stringByAppendingString:@", "];
                }
            }
            dimenStr = [dimenStr stringByAppendingString:@"]"];
        }
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@=%@, multiple=%g, increment=%g, max=%g, min=%g", [MyLayoutSize dimenstrFromAnchor:self showView:NO], dimenStr, _multiVal, _addVal, _uBoundVal.numberVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.numberVal.doubleValue, _lBoundVal.numberVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.numberVal.doubleValue];
}

@end

@implementation MyLayoutSize (Clone)

- (MyLayoutSize * (^)(CGFloat addVal, CGFloat multiVal))clone {
    return ^id(CGFloat addVal, CGFloat multiVal) {
        MyLayoutSize *clonedAnchor = [[[self class] allocWithZone:nil] init];
        clonedAnchor->_addVal = addVal;
        clonedAnchor->_multiVal = multiVal;
        clonedAnchor->_val = self;
        clonedAnchor->_valType = MyLayoutValType_LayoutAnchorClone;
        return clonedAnchor;
    };
}

@end

#pragma mark-- MyLayoutMostSize

@implementation MyLayoutMostSize {
    NSArray *_dimens;
    BOOL _isMax;
}

- (instancetype)initWith:(NSArray *)dimens isMax:(BOOL)isMax {
    self = [self init];
    if (self != nil) {
        _dimens = dimens;
        _isMax = isMax;
    }
    return self;
}

- (CGFloat)getMostDimenValFrom:(MyLayoutSize *)srcAnchor {
    CGFloat mostDimenVal = _isMax ? -CGFLOAT_MAX : CGFLOAT_MAX;
    for (id dimen in _dimens) {
        CGFloat dimenVal = 0;
        if ([dimen isKindOfClass:[NSNumber class]]) {
            dimenVal = [(NSNumber *)dimen doubleValue];
            if (dimenVal == MyLayoutSize.wrap) { //特殊的自适应值。
                CGSize size = [srcAnchor.view sizeThatFits:CGSizeZero];
                if (srcAnchor.anchorType == MyLayoutAnchorType_Width) {
                    dimenVal = size.width;
                } else {
                    dimenVal = size.height;
                }
            }
        } else if ([dimen isKindOfClass:[MyLayoutSize class]]) {
            MyLayoutSize *anchor = (MyLayoutSize *)dimen;
            CGFloat increment = 0.0;
            CGFloat multiple = 1.0;
            if (anchor.valType == MyLayoutValType_LayoutAnchorClone) {
                increment = anchor.addVal;
                multiple = anchor.multiVal;
                anchor = (MyLayoutSize *)anchor.val;
            }
            dimenVal = (anchor.anchorType == MyLayoutAnchorType_Width) ? anchor.view.myEstimatedWidth : anchor.view.myEstimatedHeight;
            dimenVal *= multiple;
            dimenVal += increment;
        } else {
            NSAssert(NO, @"oops!, invalid type, only support NSNumber or MyLayoutSize");
        }
        mostDimenVal = _isMax ? _myCGFloatMax(dimenVal, mostDimenVal) : _myCGFloatMin(dimenVal, mostDimenVal);
    }

    return mostDimenVal;
}

@end

@implementation NSArray (MyLayoutMostSize)

- (MyLayoutMostSize *)myMinSize {
    return [[MyLayoutMostSize alloc] initWith:self isMax:NO];
}

- (MyLayoutMostSize *)myMaxSize {
    return [[MyLayoutMostSize alloc] initWith:self isMax:YES];
}

@end

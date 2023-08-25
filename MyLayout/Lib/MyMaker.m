//
//  MyMaker.m
//  MyLayout
//
//  Created by oybq on 15/7/5.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyMaker.h"

#if TARGET_OS_IPHONE

#import "MyLayoutPos.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutSize.h"
#import "MyLayoutSizeInner.h"

@implementation MyMaker {
    NSArray *_myViews;
    NSMutableArray *_keys;
    BOOL _clear;
}

- (id)initWithView:(NSArray *)v {
    self = [self init];
    if (self != nil) {
        _myViews = v;
        _keys = [[NSMutableArray alloc] init];
        _clear = NO;
    }
    return self;
}

- (MyMaker *)addMethod:(NSString *)method {
    if (_clear) {
        [_keys removeAllObjects];
    }
    _clear = NO;

    [_keys addObject:method];
    return self;
}

- (MyMaker *)top {
    return [self addMethod:@"topPos"];
}

- (MyMaker *)left {
    return [self addMethod:@"leftPos"];
}

- (MyMaker *)bottom {
    return [self addMethod:@"bottomPos"];
}

- (MyMaker *)right {
    return [self addMethod:@"rightPos"];
}

- (MyMaker *)margin {
    [self top];
    [self left];
    [self right];
    return [self bottom];
}

- (MyMaker *)leading {
    return [self addMethod:@"leadingPos"];
}

- (MyMaker *)trailing {
    return [self addMethod:@"trailingPos"];
}

- (MyMaker *)height {
    return [self addMethod:@"heightSize"];
}

- (MyMaker *)width {
    return [self addMethod:@"widthSize"];
}

- (MyMaker *)useFrame {
    return [self addMethod:@"useFrame"];
}

- (MyMaker *)noLayout {
    return [self addMethod:@"noLayout"];
}

- (MyMaker *)wrapContentHeight {
    return [self addMethod:@"wrapContentHeight"];
}

- (MyMaker *)wrapContentWidth {
    return [self addMethod:@"wrapContentWidth"];
}

- (MyMaker *)reverseLayout {
    return [self addMethod:@"reverseLayout"];
}

- (MyMaker *)weight {
    return [self addMethod:@"weight"];
}

- (MyMaker *)reverseFloat {
    return [self addMethod:@"reverseFloat"];
}

- (MyMaker *)clearFloat {
    return [self addMethod:@"clearFloat"];
}

- (MyMaker *)paddingTop {
    return [self addMethod:@"paddingTop"];
}

- (MyMaker *)paddingLeft {
    return [self addMethod:@"paddingLeft"];
}

- (MyMaker *)paddingBottom {
    return [self addMethod:@"paddingBottom"];
}

- (MyMaker *)paddingRight {
    return [self addMethod:@"paddingRight"];
}

- (MyMaker *)paddingLeading {
    return [self addMethod:@"paddingLeading"];
}

- (MyMaker *)paddingTrailing {
    return [self addMethod:@"paddingTrailing"];
}

- (MyMaker *)padding {
    [self addMethod:@"paddingTop"];
    [self addMethod:@"paddingLeft"];
    [self addMethod:@"paddingBottom"];
    return [self addMethod:@"paddingRight"];
}

- (MyMaker *)zeroPadding {
    return [self addMethod:@"zeroPadding"];
}

- (MyMaker *)orientation {
    return [self addMethod:@"orientation"];
}

- (MyMaker *)gravity {
    return [self addMethod:@"gravity"];
}

- (MyMaker *)centerX {
    return [self addMethod:@"centerXPos"];
}

- (MyMaker *)centerY {
    return [self addMethod:@"centerYPos"];
}

- (MyMaker *)center {
    [self addMethod:@"centerXPos"];
    return [self addMethod:@"centerYPos"];
}
- (MyMaker *)baseline {
    return [self addMethod:@"baselinePos"];
}

- (MyMaker *)visibility {
    return [self addMethod:@"visibility"];
}

- (MyMaker *)alignment {
    return [self addMethod:@"alignment"];
}

- (MyMaker *)sizeToFit {
    for (UIView *myView in _myViews) {
        [myView sizeToFit];
    }

    return self;
}

- (MyMaker *)space {
    return [self addMethod:@"subviewSpace"];
}

- (MyMaker *)shrinkType {
    return [self addMethod:@"shrinkType"];
}

- (MyMaker *)arrangedCount {
    return [self addMethod:@"arrangedCount"];
}

- (MyMaker *)autoArrange {
    return [self addMethod:@"autoArrange"];
}

- (MyMaker *)arrangedGravity {
    return [self addMethod:@"arrangedGravity"];
}

- (MyMaker *)vertSpace {
    return [self addMethod:@"subviewVSpace"];
}

- (MyMaker *)horzSpace {
    return [self addMethod:@"subviewHSpace"];
}

- (MyMaker *)pagedCount {
    return [self addMethod:@"pagedCount"];
}

- (MyMaker * (^)(id val))equalTo {
    _clear = YES;
    return ^id(id val) {
        for (NSString *key in self->_keys) {
            for (UIView *myView in self->_myViews) {
                if ([val isKindOfClass:[NSNumber class]]) {
                    id oldVal = [myView valueForKey:key];
                    if ([oldVal isKindOfClass:[MyLayoutPos class]]) {
                        ((MyLayoutPos *)oldVal).myEqualTo(val);
                    } else if ([oldVal isKindOfClass:[MyLayoutSize class]]) {
                        ((MyLayoutSize *)oldVal).myEqualTo(val);
                    } else {
                        [myView setValue:val forKey:key];
                    }
                } else if ([val isKindOfClass:[MyLayoutPos class]]) {
                    ((MyLayoutPos *)[myView valueForKey:key]).myEqualTo(val);
                } else if ([val isKindOfClass:[MyLayoutSize class]]) {
                    ((MyLayoutSize *)[myView valueForKey:key]).myEqualTo(val);
                } else if ([val isKindOfClass:[NSArray class]]) {
                    ((MyLayoutSize *)[myView valueForKey:key]).myEqualTo(val);
                } else if ([val isKindOfClass:[UIView class]]) {
                    id oldVal = [val valueForKey:key];
                    if ([oldVal isKindOfClass:[MyLayoutPos class]]) {
                        ((MyLayoutPos *)[myView valueForKey:key]).myEqualTo(oldVal);
                    } else if ([oldVal isKindOfClass:[MyLayoutSize class]]) {
                        ((MyLayoutSize *)[myView valueForKey:key]).myEqualTo(oldVal);
                    } else {
                        [myView setValue:oldVal forKey:key];
                    }
                }
            }
        }
        return self;
    };
}

- (MyMaker * (^)(CGFloat val))offset {
    _clear = YES;
    return ^id(CGFloat val) {
        for (NSString *key in self->_keys) {
            for (UIView *myView in self->_myViews) {
                [((MyLayoutPos *)[myView valueForKey:key]) _myOffset:val];
            }
        }
        return self;
    };
}

- (MyMaker * (^)(CGFloat val))multiply {
    _clear = YES;
    return ^id(CGFloat val) {
        for (NSString *key in self->_keys) {
            for (UIView *myView in self->_myViews) {
                [((MyLayoutSize *)[myView valueForKey:key]) _myMultiply:val];
            }
        }
        return self;
    };
}

- (MyMaker * (^)(CGFloat val))add {
    _clear = YES;
    return ^id(CGFloat val) {
        for (NSString *key in self->_keys) {
            for (UIView *myView in self->_myViews) {
                [((MyLayoutSize *)[myView valueForKey:key]) _myAdd:val];
            }
        }
        return self;
    };
}

- (MyMaker * (^)(id val))min {
    _clear = YES;
    return ^id(id val) {
        for (NSString *key in self->_keys) {
            for (UIView *myView in self->_myViews) {
                id val2 = val;
                if ([val isKindOfClass:[UIView class]]) {
                    val2 = [val valueForKey:key];
                }
                id oldVal = [myView valueForKey:key];
                if ([oldVal isKindOfClass:[MyLayoutPos class]]) {
                    [((MyLayoutPos *)oldVal) _myLBound:val2 offsetVal:0];
                } else if ([oldVal isKindOfClass:[MyLayoutSize class]]) {
                    [((MyLayoutSize *)oldVal) _myLBound:val2 addVal:0 multiVal:1];
                }
            }
        }
        return self;
    };
}

- (MyMaker * (^)(id val))max {
    _clear = YES;
    return ^id(id val) {
        for (NSString *key in self->_keys) {
            for (UIView *myView in self->_myViews) {
                id val2 = val;
                if ([val isKindOfClass:[UIView class]]) {
                    val2 = [val valueForKey:key];
                }
                id oldVal = [myView valueForKey:key];
                if ([oldVal isKindOfClass:[MyLayoutPos class]]) {
                    [((MyLayoutPos *)oldVal) _myUBound:val2 offsetVal:0];
                } else if ([oldVal isKindOfClass:[MyLayoutSize class]]) {
                    [((MyLayoutSize *)oldVal) _myUBound:val2 addVal:0 multiVal:1];
                }
            }
        }
        return self;
    };
}

#pragma mark -- Dreprecated methods
//
//- (MyMaker *)topPadding {
//    return self.paddingTop;
//}
//- (MyMaker *)leftPadding {
//    return self.paddingLeft;
//}
//- (MyMaker *)bottomPadding {
//    return self.paddingBottom;
//}
//- (MyMaker *)rightPadding {
//    return self.paddingRight;
//}
//- (MyMaker *)leadingPadding {
//    return self.paddingLeading;
//}
//- (MyMaker *)trailingPadding {
//    return self.paddingTrailing;
//}

@end

@implementation UIView (MyMakerExt)

- (void)makeLayout:(void (^)(MyMaker *make))layoutMaker {
    MyMaker *myMaker = [[MyMaker alloc] initWithView:@[self]];
    layoutMaker(myMaker);
}

- (void)allSubviewMakeLayout:(void (^)(MyMaker *make))layoutMaker {
    MyMaker *myMaker = [[MyMaker alloc] initWithView:self.subviews];
    layoutMaker(myMaker);
}

@end

#endif

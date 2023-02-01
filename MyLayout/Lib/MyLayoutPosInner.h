//
//  MyLayoutPosInner.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutMath.h"
#import "MyLayoutPos.h"

//布局位置内部定义
@interface MyLayoutPos ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) MyLayoutAnchorType anchorType;
@property (nonatomic, assign) MyLayoutValType valType;
@property (nonatomic, strong) id val;
@property (nonatomic, readonly, strong) NSNumber *numberVal;
@property (nonatomic, readonly, strong) MyLayoutPos *anchorVal;
@property (nonatomic, readonly, strong) NSArray *arrayVal;
@property (nonatomic, readonly, strong) NSNumber *mostVal;

@property (nonatomic, strong) MyLayoutPos *lBoundVal;
@property (nonatomic, strong) MyLayoutPos *uBoundVal;

@property (nonatomic, readonly, strong) MyLayoutPos *lBoundValInner;
@property (nonatomic, readonly, strong) MyLayoutPos *uBoundValInner;

@property (nonatomic, assign) CGFloat offsetVal;

- (MyLayoutPos * (^)(id val))myEqualTo;
- (MyLayoutPos * (^)(CGFloat val))myOffset;
- (MyLayoutPos * (^)(CGFloat val))myMin;
- (MyLayoutPos * (^)(id posVal, CGFloat offset))myLBound;
- (MyLayoutPos * (^)(CGFloat val))myMax;
- (MyLayoutPos * (^)(id posVal, CGFloat offset))myUBound;
- (void)myClear;

- (MyLayoutPos *)_myEqualTo:(id)val;
- (MyLayoutPos *)_myOffset:(CGFloat)val;
- (MyLayoutPos *)_myMin:(CGFloat)val;
- (MyLayoutPos *)_myLBound:(id)posVal offsetVal:(CGFloat)offsetVal;
- (MyLayoutPos *)_myMax:(CGFloat)val;
- (MyLayoutPos *)_myUBound:(id)posVal offsetVal:(CGFloat)offsetVal;
- (void)_myClear;
- (void)_mySetActive:(BOOL)active;

// minVal <= posNumVal + offsetVal <=maxVal . 注意这个只试用于相对布局。对于线性布局和框架布局来说，因为可以支持相对边距。
// 所以线性布局和框架布局不能使用这个属性。
@property (nonatomic, readonly, assign) CGFloat measure;

//获取真实的位置值
- (CGFloat)measureWith:(CGFloat)size;

- (BOOL)isRelativePos;

- (BOOL)isSafeAreaPos;

@end

@interface MyLayoutMostPos : NSObject

- (instancetype)initWith:(NSArray *)poss isMax:(BOOL)isMax;

//获取极限值
- (CGFloat)getMostAxisValFrom:(MyLayoutPos *)layoutPos;

@end

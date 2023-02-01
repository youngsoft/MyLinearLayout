//
//  MyLayoutDimeInner.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutMath.h"
#import "MyLayoutSize.h"

//尺寸对象内部定义
@interface MyLayoutSize ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) MyLayoutAnchorType anchorType;

@property (nonatomic, assign) MyLayoutValType valType;
@property (nonatomic, strong) id val;
@property (nonatomic, readonly, strong) NSNumber *numberVal;
@property (nonatomic, readonly, strong) MyLayoutSize *anchorVal;
@property (nonatomic, readonly, strong) NSArray *arrayVal;

@property (nonatomic, readonly, assign) BOOL wrapVal;
@property (nonatomic, readonly, assign) BOOL fillVal;

@property (nonatomic, strong) MyLayoutSize *lBoundVal;
@property (nonatomic, strong) MyLayoutSize *uBoundVal;

@property (nonatomic, readonly, strong) MyLayoutSize *lBoundValInner;
@property (nonatomic, readonly, strong) MyLayoutSize *uBoundValInner;

@property (nonatomic, assign) CGFloat addVal;
@property (nonatomic, assign) CGFloat multiVal;

//优先级，内部使用，值是0，500， 1000 分别代表低、中、高，默认是500，这个属性先内部生效。
@property (nonatomic, assign) MyPriority priority;

- (MyLayoutSize * (^)(id val))myEqualTo;
- (MyLayoutSize * (^)(CGFloat val))myAdd;
- (MyLayoutSize * (^)(CGFloat val))myMultiply;
- (MyLayoutSize * (^)(CGFloat val))myMin;
- (MyLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myLBound;
- (MyLayoutSize * (^)(CGFloat val))myMax;
- (MyLayoutSize * (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myUBound;
- (void)myClear;

- (MyLayoutSize *)_myEqualTo:(id)val;
- (MyLayoutSize *)_myEqualTo:(id)val priority:(NSInteger)priority;
- (MyLayoutSize *)_myAdd:(CGFloat)val;
- (MyLayoutSize *)_myMultiply:(CGFloat)val;
- (MyLayoutSize *)_myMin:(CGFloat)val;
- (MyLayoutSize *)_myLBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
- (MyLayoutSize *)_myMax:(CGFloat)val;
- (MyLayoutSize *)_myUBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
- (void)_myClear;
- (void)_mySetActive:(BOOL)active;

//只有为数值时才有意义。
@property (nonatomic, readonly, assign) CGFloat measure;

- (CGFloat)measureWith:(CGFloat)size;

@end

@interface MyLayoutMostSize : NSObject

- (instancetype)initWith:(NSArray *)sizes isMax:(BOOL)isMax;

//获取极限值
- (CGFloat)getMostDimenValFrom:(MyLayoutSize *)layoutSize;

@end

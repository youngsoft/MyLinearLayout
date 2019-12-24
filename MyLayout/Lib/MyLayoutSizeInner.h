//
//  MyLayoutDimeInner.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutSize.h"
#import "MyLayoutMath.h"



//尺寸对象内部定义
@interface MyLayoutSize()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MyGravity dime;
@property(nonatomic, assign) MyLayoutValueType dimeValType;

@property(nonatomic, strong, readonly) id dimeVal;
@property(nonatomic, readonly, strong) NSNumber *dimeNumVal;
@property(nonatomic, readonly, strong) MyLayoutSize *dimeRelaVal;
@property(nonatomic, readonly, strong) NSArray *dimeArrVal;

@property(nonatomic, readonly, assign) BOOL dimeWrapVal;
@property(nonatomic, readonly, assign) BOOL dimeFillVal;

@property(nonatomic, readonly, strong) MyLayoutSize *lBoundVal;
@property(nonatomic, readonly, strong) MyLayoutSize *uBoundVal;

@property(nonatomic, readonly, strong) MyLayoutSize *lBoundValInner;
@property(nonatomic, readonly, strong) MyLayoutSize *uBoundValInner;

//优先级，内部使用，值是0，500， 1000 分别代表低、中、高，默认是500，这个属性先内部生效。
@property(nonatomic, assign) MyPriority priority;


-(MyLayoutSize* (^)(id val))myEqualTo;
-(MyLayoutSize* (^)(CGFloat val))myAdd;
-(MyLayoutSize* (^)(CGFloat val))myMultiply;
-(MyLayoutSize* (^)(CGFloat val))myMin;
-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myLBound;
-(MyLayoutSize* (^)(CGFloat val))myMax;
-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myUBound;
-(void)myClear;


-(MyLayoutSize*)__equalTo:(id)val;
-(MyLayoutSize*)__equalTo:(id)val priority:(NSInteger)priority;
-(MyLayoutSize*)__add:(CGFloat)val;
-(MyLayoutSize*)__multiply:(CGFloat)val;
-(MyLayoutSize*)__min:(CGFloat)val;
-(MyLayoutSize*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
-(MyLayoutSize*)__max:(CGFloat)val;
-(MyLayoutSize*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
-(void)__clear;
-(void)__setActive:(BOOL)active;



//只有为数值时才有意义。
@property(nonatomic, readonly, assign) CGFloat measure;


-(CGFloat)measureWith:(CGFloat)size;

@end

@interface MyLayoutMostSize:NSObject

-(instancetype)initWith:(NSArray *)sizes isMax:(BOOL)isMax;

//获取极限值
-(CGFloat)getMostSizeFrom:(MyLayoutSize *)layoutSize;

@end


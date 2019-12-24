//
//  MyLayoutPosInner.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutPos.h"
#import "MyLayoutMath.h"


//布局位置内部定义
@interface MyLayoutPos()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MyGravity pos;
@property(nonatomic, assign) MyLayoutValueType posValType;
@property(nonatomic, strong, readonly) id posVal;
@property(nonatomic, readonly, strong) NSNumber *posNumVal;
@property(nonatomic, readonly, strong) MyLayoutPos *posRelaVal;
@property(nonatomic, readonly, strong) NSArray *posArrVal;
@property(nonatomic, readonly, strong) NSNumber *posMostVal;

@property(nonatomic, readonly, strong) MyLayoutPos *lBoundVal;
@property(nonatomic, readonly, strong) MyLayoutPos *uBoundVal;

@property(nonatomic, readonly, strong) MyLayoutPos *lBoundValInner;
@property(nonatomic, readonly, strong) MyLayoutPos *uBoundValInner;


-(MyLayoutPos* (^)(id val))myEqualTo;
-(MyLayoutPos* (^)(CGFloat val))myOffset;
-(MyLayoutPos* (^)(CGFloat val))myMin;
-(MyLayoutPos* (^)(id posVal, CGFloat offset))myLBound;
-(MyLayoutPos* (^)(CGFloat val))myMax;
-(MyLayoutPos* (^)(id posVal, CGFloat offset))myUBound;
-(void)myClear;

-(MyLayoutPos*)__equalTo:(id)val;
-(MyLayoutPos*)__offset:(CGFloat)val;
-(MyLayoutPos*)__min:(CGFloat)val;
-(MyLayoutPos*)__lBound:(id)posVal offsetVal:(CGFloat)offsetVal;
-(MyLayoutPos*)__max:(CGFloat)val;
-(MyLayoutPos*)__uBound:(id)posVal offsetVal:(CGFloat)offsetVal;
-(void)__clear;
-(void)__setActive:(BOOL)active;


// minVal <= posNumVal + offsetVal <=maxVal . 注意这个只试用于相对布局。对于线性布局和框架布局来说，因为可以支持相对边距。
// 所以线性布局和框架布局不能使用这个属性。
@property(nonatomic,readonly, assign) CGFloat absVal;

//获取真实的位置值
-(CGFloat)realPosIn:(CGFloat)size;

-(BOOL)isRelativePos;

-(BOOL)isSafeAreaPos;

@end

@interface MyLayoutMostPos:NSObject

-(instancetype)initWith:(NSArray *)poss isMax:(BOOL)isMax;

//获取极限值
-(CGFloat)getMostPosFrom:(MyLayoutPos *)layoutPos;

@end

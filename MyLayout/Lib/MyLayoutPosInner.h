//
//  MyLayoutPosInner.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutPos.h"


//布局位置内部定义
@interface MyLayoutPos()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MyMarginGravity pos;
@property(nonatomic, assign) MyLayoutValueType posValType;

@property(nonatomic, readonly, strong) NSNumber *posNumVal;
@property(nonatomic, readonly, strong) MyLayoutPos *posRelaVal;
@property(nonatomic, readonly, strong) NSArray *posArrVal;

@property(nonatomic, readonly, strong) MyLayoutPos *lBoundVal;
@property(nonatomic, readonly, strong) MyLayoutPos *uBoundVal;


-(MyLayoutPos*)__equalTo:(id)val;
-(MyLayoutPos*)__offset:(CGFloat)val;
-(MyLayoutPos*)__min:(CGFloat)val;
-(MyLayoutPos*)__lBound:(id)posVal offsetVal:(CGFloat)offsetVal;
-(MyLayoutPos*)__max:(CGFloat)val;
-(MyLayoutPos*)__uBound:(id)posVal offsetVal:(CGFloat)offsetVal;
-(void)__clear;



// minVal <= posNumVal + offsetVal <=maxVal . 注意这个只试用于相对布局。对于线性布局和框架布局来说，因为可以支持相对边距。
// 所以线性布局和框架布局不能使用这个属性。
@property(nonatomic,readonly, assign) CGFloat margin;

//获取真实的位置值
-(CGFloat)realMarginInSize:(CGFloat)size;


@end

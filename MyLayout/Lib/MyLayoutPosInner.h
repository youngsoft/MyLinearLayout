//
//  MyLayoutPosInner.h
//  MyLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutDef.h"


//布局位置内部定义
@interface MyLayoutPos()

@property(nonatomic, weak) UIView *view;

@property(nonatomic, assign) MyMarginGravity pos;

@property(nonatomic, assign) MyLayoutValueType posValType;

@property(nonatomic, readonly) NSNumber *posNumVal;
@property(nonatomic, readonly) MyLayoutPos *posRelaVal;
@property(nonatomic, readonly) NSArray *posArrVal;

// minVal <= posNumVal + offsetVal <=maxVal . 注意这个只试用于相对布局。对于线性布局和框架布局来说，因为可以支持相对边距。
// 所以线性布局和框架布局不能使用这个属性。
@property(nonatomic,readonly) CGFloat margin;

//计算有效的margin值，有效的margin  minVal <= margin <=maxVal
-(CGFloat)validMargin:(CGFloat)margin;


@end

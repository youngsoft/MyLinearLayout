//
//  MyLayoutPosInner.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutDef.h"


//布局位置内部定义
@interface MyLayoutPos()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MarignGravity pos;
@property(nonatomic, assign) CGFloat offsetVal;
@property(nonatomic, assign) CGFloat minVal;
@property(nonatomic, assign) CGFloat maxVal;
@property(nonatomic, strong) id posVal;

@property(nonatomic, assign) MyLayoutValueType posValType;

@property(nonatomic, readonly) NSNumber *posNumVal;
@property(nonatomic, readonly) MyLayoutPos *posRelaVal;
@property(nonatomic, readonly) NSArray *posArrVal;

//posNumVal + offsetVal
@property(nonatomic,readonly) CGFloat margin;

//计算有效的margin值，有效的margin  minVal <= margin <=maxVal
-(CGFloat)validMargin:(CGFloat)margin;

@end

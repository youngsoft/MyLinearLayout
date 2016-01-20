//
//  MyLayoutDimeInner.h
//  MyLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutDef.h"


//尺寸对象内部定义
@interface MyLayoutDime()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MyMarginGravity dime;

@property(nonatomic, assign) MyLayoutValueType dimeValType;

@property(nonatomic, readonly) NSNumber *dimeNumVal;
@property(nonatomic, readonly) NSArray *dimeArrVal;
@property(nonatomic, readonly) MyLayoutDime *dimeRelaVal;


//是否跟父视图相关
@property(nonatomic, readonly) BOOL isMatchParent;

-(BOOL)isMatchView:(UIView*)v;

//只有为数值时才有意义。
@property(nonatomic, readonly) CGFloat measure;

//有效的尺寸， 有效的尺寸取值 minVal <= measure <= maxVal
-(CGFloat)validMeasure:(CGFloat)measure;


@end

//
//  MyLayoutDimeInner.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDime.h"


//尺寸对象内部定义
@interface MyLayoutDime()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MyMarginGravity dime;
@property(nonatomic, assign) MyLayoutValueType dimeValType;

@property(nonatomic, readonly, strong) NSNumber *dimeNumVal;
@property(nonatomic, readonly, strong) MyLayoutDime *dimeRelaVal;
@property(nonatomic, readonly, strong) NSArray *dimeArrVal;
@property(nonatomic, readonly, strong) MyLayoutDime *dimeSelfVal;

@property(nonatomic, readonly, strong) MyLayoutDime *lBoundVal;
@property(nonatomic, readonly, strong) MyLayoutDime *uBoundVal;


//是否跟父视图相关
@property(nonatomic, readonly,assign) BOOL isMatchParent;

-(BOOL)isMatchView:(UIView*)v;

//只有为数值时才有意义。
@property(nonatomic, readonly, assign) CGFloat measure;


@end

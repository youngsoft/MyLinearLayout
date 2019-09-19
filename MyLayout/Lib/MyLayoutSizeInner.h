//
//  MyLayoutDimeInner.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutSize.h"


//尺寸对象内部定义
@interface MyLayoutSize()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MyGravity dime;
@property(nonatomic, assign) MyLayoutValueType dimeValType;

@property(nonatomic, readonly, strong) NSNumber *dimeNumVal;
@property(nonatomic, readonly, strong) MyLayoutSize *dimeRelaVal;
@property(nonatomic, readonly, strong) NSArray *dimeArrVal;

@property(nonatomic, readonly, assign) BOOL dimeWrapVal;

@property(nonatomic, readonly, strong) MyLayoutSize *lBoundVal;
@property(nonatomic, readonly, strong) MyLayoutSize *uBoundVal;

@property(nonatomic, readonly, strong) MyLayoutSize *lBoundValInner;
@property(nonatomic, readonly, strong) MyLayoutSize *uBoundValInner;

//优先级，内部使用，值是0，500， 1000 分别代表低、中、高，默认是500，这个属性先内部生效。
@property(nonatomic, assign) NSInteger priority;


-(MyLayoutSize*)__equalTo:(id)val;
-(MyLayoutSize*)__equalTo:(id)val priority:(NSInteger)priority;
-(MyLayoutSize*)__add:(CGFloat)val;
-(MyLayoutSize*)__multiply:(CGFloat)val;
-(MyLayoutSize*)__min:(CGFloat)val;
-(MyLayoutSize*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
-(MyLayoutSize*)__max:(CGFloat)val;
-(MyLayoutSize*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
-(void)__clear;



//只有为数值时才有意义。
@property(nonatomic, readonly, assign) CGFloat measure;


-(CGFloat)measureWith:(CGFloat)size;

@end

@interface MyLayoutExtremeSize:NSObject

-(instancetype)initWith:(NSArray *)sizes isMax:(BOOL)isMax;

//获取极限值
-(CGFloat)getExtremeSizeFrom:(MyLayoutSize *)layoutSize;

@end


//
//  MyLayoutInner.h
//  MyLayout
//
//  Created by oybq on 15/7/10.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutDimeInner.h"
#import "MyLayoutMeasure.h"
#import "MyLayoutSizeClass.h"


@interface MyBaseLayout()


@property(nonatomic ,strong) CAShapeLayer *leftBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *rightBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *topBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderLineLayer;


//派生类重载这个函数进行布局
-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass;


//判断margin是否是相对margin
-(BOOL)isRelativeMargin:(CGFloat)margin;


-(void)vertGravity:(MyMarginGravity)vert
        selfSize:(CGSize)selfSize
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)horzGravity:(MyMarginGravity)horz
         selfSize:(CGSize)selfSize
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)setWrapContentWidthNoLayout:(BOOL)wrapContentWidth;

-(void)setWrapContentHeightNoLayout:(BOOL)wrapContentHeight;

-(void)calcSizeOfWrapContentSubview:(UIView*)sbv;


-(CGFloat)heightFromFlexedHeightView:(UIView*)sbv inWidth:(CGFloat)width;

-(CGFloat)validMeasure:(MyLayoutDime*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize;

-(CGFloat)validMargin:(MyLayoutPos*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

-(BOOL)isNoLayoutSubview:(UIView*)sbv;

-(NSMutableArray*)getLayoutSubviews;
-(NSMutableArray*)getLayoutSubviewsFrom:(NSArray*)sbsFrom;

@end







@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong, readonly) MyLayoutMeasure *absPos;


-(instancetype)myDefaultSizeClass;

-(instancetype)myBestSizeClass:(MySizeClass)sizeClass;

-(instancetype)myCurrentSizeClass;

-(id)createSizeClassInstance;

@end


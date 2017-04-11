//
//  MyLayoutInner.h
//  MyLayout
//
//  Created by oybq on 15/7/10.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutSizeInner.h"
#import "MyLayoutSizeClass.h"


//视图在布局中的评估测量值
@interface MyFrame : NSObject

@property(nonatomic, assign) CGFloat leftPos;
@property(nonatomic, assign) CGFloat rightPos;
@property(nonatomic, assign) CGFloat topPos;
@property(nonatomic, assign) CGFloat bottomPos;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, weak) UIView *sizeClass;


-(void)reset;

@property(nonatomic,assign) CGRect frame;

@end



@interface MyBaseLayout()


@property(nonatomic ,strong) CAShapeLayer *leftBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *rightBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *topBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderlineLayer;


//派生类重载这个函数进行布局
-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs;

-(id)createSizeClassInstance;


//判断margin是否是相对margin
-(BOOL)myIsRelativeMargin:(CGFloat)margin;


-(void)myVertGravity:(MyGravity)vert
        selfSize:(CGSize)selfSize
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)myHorzGravity:(MyGravity)horz
         selfSize:(CGSize)selfSize
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)mySetWrapContentWidthNoLayout:(BOOL)wrapContentWidth;

-(void)mySetWrapContentHeightNoLayout:(BOOL)wrapContentHeight;

-(void)myCalcSizeOfWrapContentSubview:(UIView*)sbv selfLayoutSize:(CGSize)selfLayoutSize;


-(CGFloat)myHeightFromFlexedHeightView:(UIView*)sbv inWidth:(CGFloat)width;

-(CGFloat)myValidMeasure:(MyLayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize;

-(CGFloat)myValidMargin:(MyLayoutPos*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

-(BOOL)myIsNoLayoutSubview:(UIView*)sbv;

-(NSMutableArray*)myGetLayoutSubviews;
-(NSMutableArray*)myGetLayoutSubviewsFrom:(NSArray*)sbsFrom;

//设置子视图的相对依赖的尺寸
-(void)mySetSubviewRelativeDimeSize:(MyLayoutSize*)dime selfSize:(CGSize)selfSize pRect:(CGRect*)pRect;

-(CGSize)myAdjustSizeWhenNoSubviews:(CGSize)size sbs:(NSArray*)sbs;

@end



@interface MyViewSizeClass()

@property(nonatomic, strong,readonly)  MyLayoutPos *leftPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *topPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *rightPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *bottomPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *centerXPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *centerYPosInner;
@property(nonatomic, strong,readonly)  MyLayoutSize *widthSizeInner;
@property(nonatomic, strong,readonly)  MyLayoutSize *heightSizeInner;

@end


@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong, readonly) MyFrame *myFrame;


-(instancetype)myDefaultSizeClass;

-(instancetype)myBestSizeClass:(MySizeClass)sizeClass;

-(instancetype)myCurrentSizeClass;

-(instancetype)myCurrentSizeClassInner;


-(id)createSizeClassInstance;


@property(nonatomic, readonly)  MyLayoutPos *leftPosInner;
@property(nonatomic, readonly)  MyLayoutPos *topPosInner;
@property(nonatomic, readonly)  MyLayoutPos *rightPosInner;
@property(nonatomic, readonly)  MyLayoutPos *bottomPosInner;
@property(nonatomic, readonly)  MyLayoutPos *centerXPosInner;
@property(nonatomic, readonly)  MyLayoutPos *centerYPosInner;
@property(nonatomic, readonly)  MyLayoutSize *widthSizeInner;
@property(nonatomic, readonly)  MyLayoutSize *heightSizeInner;




@end


extern BOOL _myCGFloatEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatNotEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatLessOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatGreatOrEqual(CGFloat f1, CGFloat f2);


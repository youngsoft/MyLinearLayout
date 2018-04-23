//
//  MyLayoutInner.h
//  MyLayout
//
//  Created by oybq on 15/7/10.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutMath.h"
#import "MyLayoutDef.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutSizeInner.h"
#import "MyLayoutSizeClass.h"


//视图在布局中的评估测量值
@interface MyFrame : NSObject

@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat leading;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat trailing;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, weak) UIView *sizeClass;

@property(nonatomic, assign, readonly) BOOL multiple; //是否设置了多个sizeclass

@property(nonatomic, strong) NSMutableDictionary *sizeClasses;

@property(nonatomic, assign) BOOL hasObserver;

-(void)reset;

@property(nonatomic,assign) CGRect frame;

@end



@interface MyBaseLayout()


//派生类重载这个函数进行布局
-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs;

-(id)createSizeClassInstance;


//判断margin是否是相对margin
-(BOOL)myIsRelativePos:(CGFloat)margin;

-(MyGravity)myGetSubviewVertGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc vertGravity:(MyGravity)vertGravity;


-(void)myCalcVertGravity:(MyGravity)vert
                     sbv:(UIView *)sbv
                   sbvsc:(UIView*)sbvsc
              paddingTop:(CGFloat)paddingTop
           paddingBottom:(CGFloat)paddingBottom
             baselinePos:(CGFloat)baselinePos
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect;

-(MyGravity)myGetSubviewHorzGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc horzGravity:(MyGravity)horzGravity;


-(void)myCalcHorzGravity:(MyGravity)horz
                     sbv:(UIView *)sbv
                   sbvsc:(UIView*)sbvsc
          paddingLeading:(CGFloat)paddingLeading
         paddingTrailing:(CGFloat)paddingTrailing
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect;

-(void)myCalcSizeOfWrapContentSubview:(UIView*)sbv sbvsc:(UIView*)sbvsc sbvmyFrame:(MyFrame*)sbvmyFrame;

-(CGFloat)myHeightFromFlexedHeightView:(UIView*)sbv sbvsc:(UIView*)sbvsc inWidth:(CGFloat)width;

-(CGFloat)myValidMeasure:(MyLayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize;

-(CGFloat)myValidMargin:(MyLayoutPos*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

-(BOOL)myIsNoLayoutSubview:(UIView*)sbv;

-(NSMutableArray*)myGetLayoutSubviews;
-(NSMutableArray*)myGetLayoutSubviewsFrom:(NSArray*)sbsFrom;

//设置子视图的相对依赖的尺寸
-(void)mySetSubviewRelativeDimeSize:(MyLayoutSize*)dime selfSize:(CGSize)selfSize lsc:(MyBaseLayout*)lsc pRect:(CGRect*)pRect;

-(CGSize)myAdjustSizeWhenNoSubviews:(CGSize)size sbs:(NSArray*)sbs lsc:(MyBaseLayout*)lsc;

- (void)myAdjustLayoutSelfSize:(CGSize *)pSelfSize lsc:(MyBaseLayout*)lsc;

-(void)myAdjustSubviewsRTLPos:(NSArray*)sbs selfWidth:(CGFloat)selfWidth;

-(MyGravity)myConvertLeftRightGravityToLeadingTrailing:(MyGravity)horzGravity;

//为支持iOS11的safeArea而进行的padding的转化
-(CGFloat)myLayoutTopPadding;
-(CGFloat)myLayoutBottomPadding;
-(CGFloat)myLayoutLeftPadding;
-(CGFloat)myLayoutRightPadding;
-(CGFloat)myLayoutLeadingPadding;
-(CGFloat)myLayoutTrailingPadding;

-(void)myAdjustSubviewWrapContentSet:(UIView*)sbv isEstimate:(BOOL)isEstimate sbvmyFrame:(MyFrame*)sbvmyFrame sbvsc:(UIView*)sbvsc selfSize:(CGSize)selfSize sizeClass:(MySizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout;


-(void)myCalcSubViewRect:(UIView*)sbv
                   sbvsc:(UIView*)sbvsc
              sbvmyFrame:(MyFrame*)sbvmyFrame
                     lsc:(MyBaseLayout*)lsc
             vertGravity:(MyGravity)vertGravity
             horzGravity:(MyGravity)horzGravity
              inSelfSize:(CGSize)selfSize
              paddingTop:(CGFloat)paddingTop
          paddingLeading:(CGFloat)paddingLeading
           paddingBottom:(CGFloat)paddingBottom
         paddingTrailing:(CGFloat)paddingTrailing
            pMaxWrapSize:(CGSize*)pMaxWrapSize;

-(UIFont*)myGetSubviewFont:(UIView*)sbv;

-(MySizeClass)myGetGlobalSizeClass;


@end



@interface MyViewSizeClass()

@property(nonatomic, strong,readonly)  MyLayoutPos *topPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *leadingPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *bottomPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *trailingPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *centerXPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *centerYPosInner;
@property(nonatomic, strong,readonly)  MyLayoutSize *widthSizeInner;
@property(nonatomic, strong,readonly)  MyLayoutSize *heightSizeInner;

@property(nonatomic, strong,readonly)  MyLayoutPos *leftPosInner;
@property(nonatomic, strong,readonly)  MyLayoutPos *rightPosInner;

@property(nonatomic, strong,readonly)  MyLayoutPos *baselinePosInner;


@property(class, nonatomic, assign) BOOL isRTL;


@end


@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong, readonly) MyFrame *myFrame;


-(instancetype)myDefaultSizeClass;

-(instancetype)myBestSizeClass:(MySizeClass)sizeClass;

-(instancetype)myCurrentSizeClass;

-(instancetype)myCurrentSizeClassInner;


-(instancetype)myCurrentSizeClassFrom:(MyFrame*)myFrame;

-(id)createSizeClassInstance;


@property(nonatomic, readonly)  MyLayoutPos *topPosInner;
@property(nonatomic, readonly)  MyLayoutPos *leadingPosInner;
@property(nonatomic, readonly)  MyLayoutPos *bottomPosInner;
@property(nonatomic, readonly)  MyLayoutPos *trailingPosInner;
@property(nonatomic, readonly)  MyLayoutPos *centerXPosInner;
@property(nonatomic, readonly)  MyLayoutPos *centerYPosInner;
@property(nonatomic, readonly)  MyLayoutSize *widthSizeInner;
@property(nonatomic, readonly)  MyLayoutSize *heightSizeInner;

@property(nonatomic, readonly)  MyLayoutPos *leftPosInner;
@property(nonatomic, readonly)  MyLayoutPos *rightPosInner;

@property(nonatomic, readonly)  MyLayoutPos *baselinePosInner;


@end

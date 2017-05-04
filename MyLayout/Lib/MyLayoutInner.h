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

@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat leading;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat trailing;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, weak) UIView *sizeClass;

@property(nonatomic, assign, readonly) BOOL multiple; //是否设置了多个sizeclass

@property(nonatomic, strong) NSMutableDictionary *sizeClasses;

-(void)reset;

@property(nonatomic,assign) CGRect frame;

@end



@interface MyBaseLayout()

@property(nonatomic ,strong) CAShapeLayer *topBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *leadingBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *trailingBorderlineLayer;


//派生类重载这个函数进行布局
-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs;

-(id)createSizeClassInstance;


//判断margin是否是相对margin
-(BOOL)myIsRelativePos:(CGFloat)margin;


-(void)myVertGravity:(MyGravity)vert
                 sbv:(UIView *)sbv
               sbvsc:(UIView*)sbvsc
          paddingTop:(CGFloat)paddingTop
       paddingBottom:(CGFloat)paddingBottom
            selfSize:(CGSize)selfSize
               pRect:(CGRect*)pRect;


-(void)myHorzGravity:(MyGravity)horz
                 sbv:(UIView *)sbv
               sbvsc:(UIView*)sbvsc
      paddingLeading:(CGFloat)paddingLeading
     paddingTrailing:(CGFloat)paddingTrailing
            selfSize:(CGSize)selfSize
               pRect:(CGRect*)pRect;

-(void)myCalcSizeOfWrapContentSubview:(UIView*)sbv sbvsc:(UIView*)sbvsc sbvMyFrame:(MyFrame*)sbvMyFrame selfLayoutSize:(CGSize)selfLayoutSize;

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


#if UIKIT_DEFINE_AS_PROPERTIES
@property(class, nonatomic, assign) BOOL isRTL;
#else
+(BOOL)isRTL;
+(void)setIsRTL:(BOOL)isRTL;
#endif

@end


@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong, readonly) MyFrame *myFrame;


-(instancetype)myDefaultSizeClass;

-(instancetype)myBestSizeClass:(MySizeClass)sizeClass;

-(instancetype)myCurrentSizeClass;

-(instancetype)myCurrentSizeClassInner;


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



@end


extern BOOL _myCGFloatEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatNotEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatLessOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatGreatOrEqual(CGFloat f1, CGFloat f2);


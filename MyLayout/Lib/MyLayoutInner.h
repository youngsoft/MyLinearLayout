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


@property(nonatomic,assign) BOOL isMyLayouting;


//派生类重载这个函数进行布局
-(CGSize)calcLayoutSize:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs;

-(id)createSizeClassInstance;


//判断margin是否是相对margin
-(BOOL)myIsRelativePos:(CGFloat)margin;

-(MyGravity)myGetSubview:(MyViewSizeClass*)sbvsc vertGravity:(MyGravity)vertGravity;


-(CGFloat)myCalcSubview:(MyViewSizeClass*)sbvsc
            vertGravity:(MyGravity)vert
             paddingTop:(CGFloat)paddingTop
          paddingBottom:(CGFloat)paddingBottom
            baselinePos:(CGFloat)baselinePos
               selfSize:(CGSize)selfSize
                  pRect:(CGRect*)pRect;

-(MyGravity)myGetSubview:(MyViewSizeClass*)sbvsc horzGravity:(MyGravity)horzGravity;


-(CGFloat)myCalcSubview:(MyViewSizeClass*)sbvsc
            horzGravity:(MyGravity)horz
          paddingLeading:(CGFloat)paddingLeading
         paddingTrailing:(CGFloat)paddingTrailing
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect;

-(CGFloat)mySubview:(MyViewSizeClass*)sbvsc wrapHeightSizeFits:(CGFloat)width;

-(CGFloat)myGetBoundLimitMeasure:(MyLayoutSize*)boundDime sbv:(UIView*)sbv dimeType:(MyGravity)dimeType sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound;

-(CGFloat)myValidMeasure:(MyLayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize;

-(CGFloat)myValidMargin:(MyLayoutPos*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

-(BOOL)myIsNoLayoutSubview:(UIView*)sbv;

-(NSMutableArray*)myGetLayoutSubviews;
-(NSMutableArray*)myGetLayoutSubviewsFrom:(NSArray*)sbsFrom;

-(CGSize)myLayout:(MyLayoutViewSizeClass*)lsc adjustSelfSize:(CGSize)selfSize withSubviews:(NSArray*)sbs;

-(MyGravity)myConvertLeftRightGravityToLeadingTrailing:(MyGravity)horzGravity;

//为支持iOS11的safeArea而进行的padding的转化
-(CGFloat)myLayoutTopPadding;
-(CGFloat)myLayoutBottomPadding;
-(CGFloat)myLayoutLeftPadding;
-(CGFloat)myLayoutRightPadding;
-(CGFloat)myLayoutLeadingPadding;
-(CGFloat)myLayoutTrailingPadding;

-(void)myLayout:(MyLayoutViewSizeClass*)lsc adjustSizeSettingOfSubview:(MyViewSizeClass*)sbvsc isEstimate:(BOOL)isEstimate sbvmyFrame:(MyFrame*)sbvmyFrame selfSize:(CGSize)selfSize vertGravity:(MyGravity)vertGravity horzGravity:(MyGravity)horzGravity sizeClass:(MySizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout;


//根据子视图的宽度约束得到宽度值
-(CGFloat)myLayout:(MyLayoutViewSizeClass*)lsc
widthSizeValueOfSubview:(MyViewSizeClass *)sbvsc
          selfSize:(CGSize)selfSize
           sbvSize:(CGSize)sbvSize
        paddingTop:(CGFloat)paddingTop
    paddingLeading:(CGFloat)paddingLeading
     paddingBottom:(CGFloat)paddingBottom
   paddingTrailing:(CGFloat)paddingTrailing;


//根据子视图的高度约束得到高度值
-(CGFloat)myLayout:(MyLayoutViewSizeClass*)lsc
heightSizeValueOfSubview:(MyViewSizeClass *)sbvsc
          selfSize:(CGSize)selfSize
           sbvSize:(CGSize)sbvSize
        paddingTop:(CGFloat)paddingTop
    paddingLeading:(CGFloat)paddingLeading
     paddingBottom:(CGFloat)paddingBottom
   paddingTrailing:(CGFloat)paddingTrailing;


-(void)myLayout:(MyLayoutViewSizeClass*)lsc
calcRectOfSubview:(MyViewSizeClass*)sbvsc
     sbvmyFrame:(MyFrame*)sbvmyFrame
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

//给父布局视图机会来更改子布局视图的边界线的显示的rect
-(void)myHookSublayout:(MyBaseLayout*)sublayout borderlineRect:(CGRect*)pRect;

-(void)myCalcSubviewsWrapContentSize:(NSArray<UIView *>*)sbs isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass withCustomSetting:(void (^)(MyViewSizeClass *sbvsc))customSetting;

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

-(instancetype)myBestSizeClass:(MySizeClass)sizeClass myFrame:(MyFrame*)myFrame;

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

@property(nonatomic, readonly) CGFloat myEstimatedWidth;
@property(nonatomic, readonly) CGFloat myEstimatedHeight;

@end

//为了减少布局视图不必要的内存占用，这里将一些可选数据保存到这个类中来
@interface MyBaseLayoutOptionalData:NSObject

//特定场景处理的回调block
@property(nonatomic,copy) void (^beginLayoutBlock)(void);
@property(nonatomic,copy) void (^endLayoutBlock)(void);
@property(nonatomic,copy) void (^rotationToDeviceOrientationBlock)(MyBaseLayout *layout, BOOL isFirst, BOOL isPortrait);
@property(nonatomic, assign) int lastScreenOrientation; //为0为初始状态，为1为竖屏，为2为横屏。内部使用。

//动画扩展
@property(nonatomic, assign) NSTimeInterval aniDuration;
@property(nonatomic, assign) UIViewAnimationOptions aniOptions;
@property(nonatomic, copy) void (^aniCompletion)(BOOL finished);

@end

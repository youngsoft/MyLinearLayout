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

-(void)calcSizeOfWrapContentSubview:(UIView*)sbv selfLayoutSize:(CGSize)selfLayoutSize;


-(CGFloat)heightFromFlexedHeightView:(UIView*)sbv inWidth:(CGFloat)width;

-(CGFloat)validMeasure:(MyLayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize;

-(CGFloat)validMargin:(MyLayoutPos*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

-(BOOL)isNoLayoutSubview:(UIView*)sbv;

-(NSMutableArray*)getLayoutSubviews;
-(NSMutableArray*)getLayoutSubviewsFrom:(NSArray*)sbsFrom;

@end







@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong, readonly) MyFrame *myFrame;


-(instancetype)myDefaultSizeClass;

-(instancetype)myBestSizeClass:(MySizeClass)sizeClass;

-(instancetype)myCurrentSizeClass;

-(id)createSizeClassInstance;

@end


extern BOOL _myCGFloatEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatNotEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatLessOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatGreatOrEqual(CGFloat f1, CGFloat f2);


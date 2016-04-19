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
-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass;


//判断margin是否是相对margin
-(BOOL)isRelativeMargin:(CGFloat)margin;


-(void)calcMatchParentWidth:(MyLayoutDime*)match
                  selfWidth:(CGFloat)selfWidth
                 leftMargin:(CGFloat)leftMargin
               centerMargin:(CGFloat)centerMargin
                rightMargin:(CGFloat)rightMargin
                leftPadding:(CGFloat)leftPadding
               rightPadding:(CGFloat)rightPadding
                       rect:(CGRect*)pRect;

-(void)calcMatchParentHeight:(MyLayoutDime*)match
                  selfHeight:(CGFloat)selfHeight
                   topMargin:(CGFloat)topMargin
                centerMargin:(CGFloat)centerMargin
                bottomMargin:(CGFloat)bottomMargin
                  topPadding:(CGFloat)topPadding
               bottomPadding:(CGFloat)bottomPadding
                        rect:(CGRect*)pRect;



-(void)vertGravity:(MyMarginGravity)vert
        selfHeight:(CGFloat)selfHeight
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)horzGravity:(MyMarginGravity)horz
         selfWidth:(CGFloat)selfWidth
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)setWrapContentWidthNoLayout:(BOOL)wrapContentWidth;

-(void)setWrapContentHeightNoLayout:(BOOL)wrapContentHeight;



@end







@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong, readonly) MyLayoutMeasure *absPos;


-(instancetype)myDefaultSizeClass;

-(instancetype)myBestSizeClass:(MySizeClass)sizeClass;

-(instancetype)myCurrentSizeClass;

-(id)createSizeClassInstance;

@end


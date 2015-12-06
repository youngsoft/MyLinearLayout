//
//  MyLayoutInner.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutDef.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutDimeInner.h"
#import "MyLayoutMeasure.h"


@interface MyLayoutBase()


@property(nonatomic ,strong) CAShapeLayer *leftBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *rightBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *topBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderLineLayer;


//派生类重载这个函数进行布局
-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout;

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



-(void)vertGravity:(MarignGravity)vert
        selfHeight:(CGFloat)selfHeight
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)horzGravity:(MarignGravity)horz
         selfWidth:(CGFloat)selfWidth
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)setWrapContentWidthNoLayout:(BOOL)wrapContentWidth;

-(void)setWrapContentHeightNoLayout:(BOOL)wrapContentHeight;



@end


/**内部的布局子视图的扩展**/
@interface MyLayoutSizeClass : NSObject

@property(nonatomic, strong)  MyLayoutPos *leftPos;
@property(nonatomic, strong)  MyLayoutPos *topPos;
@property(nonatomic, strong)  MyLayoutPos *rightPos;
@property(nonatomic, strong)  MyLayoutPos *bottomPos;
@property(nonatomic, strong)  MyLayoutPos *centerXPos;
@property(nonatomic, strong)  MyLayoutPos *centerYPos;

@property(nonatomic, strong)  MyLayoutDime *widthDime;
@property(nonatomic, strong)  MyLayoutDime *heightDime;

@property(nonatomic, assign)  BOOL flexedHeight;


@property(nonatomic, assign) BOOL useFrame;

@property(nonatomic, assign) CGFloat weight;


@property(nonatomic, assign) MarignGravity marginGravity;

@property(nonatomic, strong) MyLayoutMeasure *absPos;


@end






@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong, readonly) MyLayoutMeasure *absPos;


@property(nonatomic, strong, readonly) MyLayoutSizeClass *myLayoutSizeClass;

@end


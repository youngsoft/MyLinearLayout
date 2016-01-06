//
//  YSLayoutInner.h
//  YSLayout
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "YSLayoutDef.h"
#import "YSLayoutPosInner.h"
#import "YSLayoutDimeInner.h"
#import "YSLayoutMeasure.h"


@interface YSLayoutBase()


@property(nonatomic ,strong) CAShapeLayer *leftBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *rightBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *topBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderLineLayer;


//派生类重载这个函数进行布局
-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout;

//判断margin是否是相对margin
-(BOOL)isRelativeMargin:(CGFloat)margin;


-(void)calcMatchParentWidth:(YSLayoutDime*)match
                  selfWidth:(CGFloat)selfWidth
                 leftMargin:(CGFloat)leftMargin
               centerMargin:(CGFloat)centerMargin
                rightMargin:(CGFloat)rightMargin
                leftPadding:(CGFloat)leftPadding
               rightPadding:(CGFloat)rightPadding
                       rect:(CGRect*)pRect;

-(void)calcMatchParentHeight:(YSLayoutDime*)match
                  selfHeight:(CGFloat)selfHeight
                   topMargin:(CGFloat)topMargin
                centerMargin:(CGFloat)centerMargin
                bottomMargin:(CGFloat)bottomMargin
                  topPadding:(CGFloat)topPadding
               bottomPadding:(CGFloat)bottomPadding
                        rect:(CGRect*)pRect;



-(void)vertGravity:(YSMarignGravity)vert
        selfHeight:(CGFloat)selfHeight
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)horzGravity:(YSMarignGravity)horz
         selfWidth:(CGFloat)selfWidth
               sbv:(UIView*)sbv
              rect:(CGRect*)pRect;


-(void)setWrapContentWidthNoLayout:(BOOL)wrapContentWidth;

-(void)setWrapContentHeightNoLayout:(BOOL)wrapContentHeight;



@end


/**内部的布局子视图的扩展**/
@interface YSLayoutSizeClass : NSObject

@property(nonatomic, strong)  YSLayoutPos *leftPos;
@property(nonatomic, strong)  YSLayoutPos *topPos;
@property(nonatomic, strong)  YSLayoutPos *rightPos;
@property(nonatomic, strong)  YSLayoutPos *bottomPos;
@property(nonatomic, strong)  YSLayoutPos *centerXPos;
@property(nonatomic, strong)  YSLayoutPos *centerYPos;

@property(nonatomic, strong)  YSLayoutDime *widthDime;
@property(nonatomic, strong)  YSLayoutDime *heightDime;

@property(nonatomic, assign)  BOOL flexedHeight;


@property(nonatomic, assign) BOOL useFrame;

@property(nonatomic, assign) CGFloat weight;


@property(nonatomic, assign) YSMarignGravity marginGravity;

@property(nonatomic, strong) YSLayoutMeasure *absPos;


@end






@interface UIView(YSLayoutExtInner)

@property(nonatomic, strong, readonly) YSLayoutMeasure *absPos;


@property(nonatomic, strong, readonly) YSLayoutSizeClass *ysLayoutSizeClass;

@end


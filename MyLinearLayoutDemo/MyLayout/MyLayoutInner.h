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
#import "MyLayoutMeasurement.h"


@interface MyLayoutBase()


//派生类重载这个函数进行布局
-(CGRect)doLayoutSubviews;

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
         topMargin:(CGFloat)topMargin
      centerMargin:(CGFloat)centerMargin
      bottomMargin:(CGFloat)bottomMargin
              rect:(CGRect*)pRect;


-(void)horzGravity:(MarignGravity)horz
         selfWidth:(CGFloat)selfWidth
        leftMargin:(CGFloat)leftMargin
      centerMargin:(CGFloat)centerMargin
       rightMargin:(CGFloat)rightMargin
              rect:(CGRect*)pRect;


-(void)setWrapContentWidthNoLayout:(BOOL)wrapContentWidth;

-(void)setWrapContentHeightNoLayout:(BOOL)wrapContentHeight;



@end





@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong) MyLayoutMeasurement *absPos;

@end


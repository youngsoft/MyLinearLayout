//
//  MyLayoutSizeClass.h
//  MyLayout
//
//  Created by fzy on 16/1/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyLayoutDef.h"
#import "MyLayoutPos.h"
#import "MyLayoutDime.h"


@interface MyLayoutSizeClass : NSObject

//所有视图通用
@property(nonatomic, strong)  MyLayoutPos *leftPos;
@property(nonatomic, strong)  MyLayoutPos *topPos;
@property(nonatomic, strong)  MyLayoutPos *rightPos;
@property(nonatomic, strong)  MyLayoutPos *bottomPos;
@property(nonatomic, strong)  MyLayoutPos *centerXPos;
@property(nonatomic, strong)  MyLayoutPos *centerYPos;

@property(nonatomic, strong)  MyLayoutDime *widthDime;
@property(nonatomic, strong)  MyLayoutDime *heightDime;

@property(nonatomic, assign,getter=isFlexedHeight)  BOOL flexedHeight;

@property(nonatomic, assign) BOOL useFrame;

/*
 隐藏不参与布局，这个属性是默认sizeClass外可以用来设置某个视图是否参与布局的标志，如果设置为YES则表示不参与布局。默认是NO。
 对于默认的sizeClass来说，就可以直接使用子视图本身的hidden属性来设置。
 不参与布局的意思是在这种sizeClass下的frame会被设置为CGRectZero。而不是不加入到视图体系中去。
 如果视图真设置了隐藏属性则这个属性设置无效。
 */
@property(nonatomic, assign, getter=isHidden) BOOL hidden;


//线性布局子视图专用
@property(nonatomic, assign) CGFloat weight;

//框架布局子视图专用
@property(nonatomic, assign) MyMarginGravity marginGravity;


@end




@interface MyLayoutSizeClass()

//布局专用
@property(nonatomic,assign) UIEdgeInsets padding;
@property(nonatomic, assign) CGFloat topPadding;
@property(nonatomic, assign) CGFloat leftPadding;
@property(nonatomic, assign) CGFloat bottomPadding;
@property(nonatomic, assign) CGFloat rightPadding;

@property(nonatomic,assign) BOOL wrapContentWidth;
@property(nonatomic,assign) BOOL wrapContentHeight;

@property(nonatomic, assign) BOOL hideSubviewReLayout;


//线性布局和流式布局专用
@property(nonatomic,assign) MyLayoutViewOrientation orientation;
@property(nonatomic, assign) MyMarginGravity gravity;


//相对布局专用
@property(nonatomic, assign) BOOL flexOtherViewWidthWhenSubviewHidden;
@property(nonatomic, assign) BOOL flexOtherViewHeightWhenSubviewHidden;


//流式布局专用
@property(nonatomic, assign) NSInteger arrangedCount;
@property(nonatomic,assign) BOOL averageArrange;
@property(nonatomic,assign) MyMarginGravity arrangedGravity;

//线性布局专用
@property(nonatomic, assign) CGFloat subviewMargin;

//流式布局专用
@property(nonatomic ,assign) CGFloat subviewVertMargin;
@property(nonatomic, assign) CGFloat subviewHorzMargin;



@end


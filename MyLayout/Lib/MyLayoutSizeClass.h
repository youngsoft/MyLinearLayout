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


@interface MyLayoutSizeClass : NSObject<NSCopying>

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


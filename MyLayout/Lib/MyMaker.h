//
//  MyMaker.h
//  MyLayout
//
//  Created by oybq on 15/7/5.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"


/**
 *专门为布局设置的简化操作类，以便在统一的地方进行布局设置
 */
@interface MyMaker : NSObject

-(MyMaker*)top;
-(MyMaker*)left;
-(MyMaker*)bottom;
-(MyMaker*)right;
-(MyMaker*)margin;

-(MyMaker*)height;
-(MyMaker*)width;
-(MyMaker*)flexedHeight;
-(MyMaker*)useFrame;
-(MyMaker*)noLayout;

-(MyMaker*)centerX;
-(MyMaker*)centerY;

-(MyMaker*)sizeToFit;


//布局独有
-(MyMaker*)topPadding;
-(MyMaker*)leftPadding;
-(MyMaker*)bottomPadding;
-(MyMaker*)rightPadding;
-(MyMaker*)wrapContentHeight;
-(MyMaker*)wrapContentWidth;
-(MyMaker*)reverseLayout;



//框架布局子视图独有
-(MyMaker*)marginGravity;

//线性布局和流式布局独有
-(MyMaker*)orientation;
-(MyMaker*)gravity;
-(MyMaker*)subviewMargin;


//流式布局独有
-(MyMaker*)arrangedCount;
-(MyMaker*)averageArrange;
-(MyMaker*)autoArrange;
-(MyMaker*)arrangedGravity;
-(MyMaker*)subviewVertMargin;
-(MyMaker*)subviewHorzMargin;



//线性布局和浮动布局和流式布局子视图独有
-(MyMaker*)weight;

//浮动布局子视图独有
-(MyMaker*)reverseFloat;
-(MyMaker*)clearFloat;


//浮动布局独有。
-(MyMaker*)noBoundaryLimit;

//赋值操支持NSNumber,UIView,MyLayoutPos,MyLayoutDime, NSArray[MyLayoutDime]
-(MyMaker* (^)(id val))equalTo;

-(MyMaker* (^)(CGFloat val))offset;
-(MyMaker* (^)(CGFloat val))multiply;
-(MyMaker* (^)(CGFloat val))add;
-(MyMaker* (^)(CGFloat val))min;
-(MyMaker* (^)(CGFloat val))max;



@end


@interface UIView(MyMakerExt)

//对视图进行统一的布局，方便操作，请参考DEMO1中的使用方法。
-(void)makeLayout:(void(^)(MyMaker *make))layoutMaker;

//布局内所有子视图的布局构造，会影响到有所的子视图。
-(void)allSubviewMakeLayout:(void(^)(MyMaker *make))layoutMaker;


@end




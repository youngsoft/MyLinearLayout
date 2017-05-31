//
//  MyMaker.h
//  MyLayout
//
//  Created by oybq on 15/7/5.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"

#if TARGET_OS_IPHONE

/**
 *专门为布局设置的简化操作类，以便在统一的地方进行布局设置,MyLayout提供了类似masonry的布局设置语法。
 */
@interface MyMaker : NSObject

-(MyMaker*)top;
-(MyMaker*)left;
-(MyMaker*)bottom;
-(MyMaker*)right;
-(MyMaker*)margin;

-(MyMaker*)leading;
-(MyMaker*)trailing;


-(MyMaker*)wrapContentHeight;
-(MyMaker*)wrapContentWidth;

-(MyMaker*)height;
-(MyMaker*)width;
-(MyMaker*)useFrame;
-(MyMaker*)noLayout;

-(MyMaker*)centerX;
-(MyMaker*)centerY;
-(MyMaker*)center;

-(MyMaker*)visibility;
-(MyMaker*)alignment;

-(MyMaker*)sizeToFit;


//布局独有
-(MyMaker*)topPadding;
-(MyMaker*)leftPadding;
-(MyMaker*)bottomPadding;
-(MyMaker*)rightPadding;
-(MyMaker*)leadingPadding;
-(MyMaker*)trailingPadding;
-(MyMaker*)padding;
-(MyMaker*)zeroPadding;
-(MyMaker*)reverseLayout;
-(MyMaker*)vertSpace;
-(MyMaker*)horzSpace;
-(MyMaker*)space;



//线性布局和流式布局独有
-(MyMaker*)orientation;
-(MyMaker*)gravity;

//线性布局独有
-(MyMaker*)shrinkType;

//流式布局独有
-(MyMaker*)arrangedCount;
-(MyMaker*)autoArrange;
-(MyMaker*)arrangedGravity;
-(MyMaker*)pagedCount;


//线性布局和浮动布局和流式布局子视图独有
-(MyMaker*)weight;

//浮动布局子视图独有
-(MyMaker*)reverseFloat;
-(MyMaker*)clearFloat;


//浮动布局独有。
-(MyMaker*)noBoundaryLimit;

//赋值操支持NSNumber,UIView,MyLayoutPos,MyLayoutSize, NSArray[MyLayoutSize]
-(MyMaker* (^)(id val))equalTo;
-(MyMaker* (^)(id val))min;
-(MyMaker* (^)(id val))max;

-(MyMaker* (^)(CGFloat val))offset;
-(MyMaker* (^)(CGFloat val))multiply;
-(MyMaker* (^)(CGFloat val))add;




@end


@interface UIView(MyMakerExt)

//对视图进行统一的布局，方便操作，请参考DEMO1中的使用方法。
-(void)makeLayout:(void(^)(MyMaker *make))layoutMaker;

//布局内所有子视图的布局构造，会影响到有所的子视图。
-(void)allSubviewMakeLayout:(void(^)(MyMaker *make))layoutMaker;


@end

#endif



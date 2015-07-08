//
//  MyMaker.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*专门为布局设置的简化操作类，以便在统一的地方进行布局设置*/
@interface MyMaker : NSObject

-(MyMaker*)topMargin;
-(MyMaker*)leftMargin;
-(MyMaker*)bottomMargin;
-(MyMaker*)rightMargin;
-(MyMaker*)margin;
-(MyMaker*)marginGravity;
-(MyMaker*)matchParentWidth;
-(MyMaker*)matchParentHeight;
-(MyMaker*)flexedHeight;
-(MyMaker*)weight;
-(MyMaker*)height;
-(MyMaker*)width;
-(MyMaker*)size;
-(MyMaker*)centerX;
-(MyMaker*)centerY;
-(MyMaker*)center;

//布局独有
-(MyMaker*)topPadding;
-(MyMaker*)leftPadding;
-(MyMaker*)bottomPadding;
-(MyMaker*)rightPadding;

-(MyMaker*)orientation;
-(MyMaker*)wrapContent;
-(MyMaker*)adjustScrollViewContentSize;
-(MyMaker*)gravity;
-(MyMaker*)autoAdjustSize;
-(MyMaker*)autoAdjustDir;

//相对布局子视图独有
-(MyMaker*)top;
-(MyMaker*)left;
-(MyMaker*)bottom;
-(MyMaker*)right;



//赋值操支持NSNumber,UIView,MyRelativePos,MyRelativeDime, NSArray[MyRelativeDime]
-(MyMaker* (^)(id val))equalTo;

//相对布局下子视图独有
-(MyMaker* (^)(CGFloat val))offset;
-(MyMaker* (^)(CGFloat val))multiply;
-(MyMaker* (^)(CGFloat val))add;


@end


@interface UIView(MyMakerEx)

//对视图进行统一的布局，方便操作，跟masonry库的设置一致，请参考DEMO1中的设置。
-(void)makeLayout:(void(^)(MyMaker *make))layoutMaker;

//布局内所有子视图的布局构造，会影响到有所的子视图。
-(void)allSubviewMakeLayout:(void(^)(MyMaker *make))layoutMaker;


@end





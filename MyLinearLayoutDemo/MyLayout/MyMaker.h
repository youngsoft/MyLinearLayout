//
//  MyMaker.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*专门为布局设置的简化操作类，以便在统一的地方进行布局设置*/
@interface MyMaker : NSObject

-(MyMaker*)top;
-(MyMaker*)left;
-(MyMaker*)bottom;
-(MyMaker*)right;
-(MyMaker*)margin;

-(MyMaker*)height;
-(MyMaker*)width;
-(MyMaker*)flexedHeight;

-(MyMaker*)centerX;
-(MyMaker*)centerY;


//布局独有
-(MyMaker*)topPadding;
-(MyMaker*)leftPadding;
-(MyMaker*)bottomPadding;
-(MyMaker*)rightPadding;
-(MyMaker*)wrapContentHeight;
-(MyMaker*)wrapContentWidth;



//框架布局子视图独有
-(MyMaker*)marginGravity;

//线性布局独有
-(MyMaker*)orientation;
-(MyMaker*)gravity;

//线性布局子视图独有
-(MyMaker*)weight;




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





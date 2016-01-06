//
//  YSMaker.h
//  YSLayout
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YSLayoutDef.h"


/*专门为布局设置的简化操作类，以便在统一的地方进行布局设置*/
@interface YSMaker : NSObject

-(YSMaker*)top;
-(YSMaker*)left;
-(YSMaker*)bottom;
-(YSMaker*)right;
-(YSMaker*)margin;

-(YSMaker*)height;
-(YSMaker*)width;
-(YSMaker*)flexedHeight;
-(YSMaker*)useFrame;

-(YSMaker*)centerX;
-(YSMaker*)centerY;

-(YSMaker*)sizeToFit;


//布局独有
-(YSMaker*)topPadding;
-(YSMaker*)leftPadding;
-(YSMaker*)bottomPadding;
-(YSMaker*)rightPadding;
-(YSMaker*)wrapContentHeight;
-(YSMaker*)wrapContentWidth;



//框架布局子视图独有
-(YSMaker*)marginGravity;

//线性布局独有
-(YSMaker*)orientation;
-(YSMaker*)gravity;

//线性布局子视图独有
-(YSMaker*)weight;




//赋值操支持NSNumber,UIView,YSLayoutPos,YSLayoutDime, NSArray[YSLayoutDime]
-(YSMaker* (^)(id val))equalTo;

-(YSMaker* (^)(CGFloat val))offset;
-(YSMaker* (^)(CGFloat val))multiply;
-(YSMaker* (^)(CGFloat val))add;
-(YSMaker* (^)(CGFloat val))min;
-(YSMaker* (^)(CGFloat val))max;



@end


@interface UIView(YSMakerExt)

//对视图进行统一的布局，方便操作，跟masonry库的设置一致，请参考DEMO1中的设置。
-(void)makeLayout:(void(^)(YSMaker *make))layoutMaker;

//布局内所有子视图的布局构造，会影响到有所的子视图。
-(void)allSubviewMakeLayout:(void(^)(YSMaker *make))layoutMaker;


@end


//兼容老版本定义
typedef YSMaker MyMaker YSDEPRECATED("use YSMaker!");






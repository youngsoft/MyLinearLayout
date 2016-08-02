//
//  MyLayoutDef.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifndef MYDEPRECATED
    #define MYDEPRECATED(desc)  __attribute__((deprecated(desc)))
#endif



//如果想使用老的枚举类型的定义而不报警请定义MY_USEOLDENUMNOWARNING这个宏
#ifdef MY_USEOLDENUMNOWARNING

    #define MYENUMDEPRECATED(desc)

#else

    #define MYENUMDEPRECATED(desc) MYDEPRECATED(desc)

#endif


//如果定义了这个宏则使用老的方法不告警
#ifdef MY_USEOLDMETHODNOWARNING

    #define MYMETHODDEPRECATED(desc)

#else

   #define MYMETHODDEPRECATED(desc)  MYDEPRECATED(desc)

#endif



/**
 *视图在布局视图中的停靠和填充属性。所谓停靠就是指子视图定位在布局视图中的水平左、中、右和垂直上、中、下的某个方位上的位置。而所谓填充则让布局视图里面的子视图的宽度和高度和自己相等。
 */
typedef enum : unsigned short {
    
    //不停靠
    MyMarginGravity_None = 0,

    //水平
    MyMarginGravity_Horz_Left = 1,
    MyMarginGravity_Horz_Center = 2,
    MyMarginGravity_Horz_Right = 4,
    MyMarginGravity_Horz_Window_Center = 8,   //屏幕水平居中
    MyMarginGravity_Horz_Fill = MyMarginGravity_Horz_Left | MyMarginGravity_Horz_Center | MyMarginGravity_Horz_Right,
    MyMarginGravity_Horz_Mask = 0xFF00,

    //垂直
    MyMarginGravity_Vert_Top = 1 << 8,
    MyMarginGravity_Vert_Center = 2 << 8,
    MyMarginGravity_Vert_Bottom = 4 << 8,
    MyMarginGravity_Vert_Window_Center = 8 << 8,  //屏幕垂直居中
    MyMarginGravity_Vert_Fill = MyMarginGravity_Vert_Top | MyMarginGravity_Vert_Center | MyMarginGravity_Vert_Bottom,
    MyMarginGravity_Vert_Mask = 0x00FF,

    //居中
    MyMarginGravity_Center = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Center,

    //填充
    MyMarginGravity_Fill = MyMarginGravity_Horz_Fill | MyMarginGravity_Vert_Fill,
    
    
    
} MyMarginGravity;


//布局视图排列的方向定义
typedef enum : NSUInteger {
     MyLayoutViewOrientation_Vert = 0,  //整体从上到下
     MyLayoutViewOrientation_Horz = 1,  //整体从左到右
} MyLayoutViewOrientation;



//设置当布局视图嵌入到UIScrollView以及其派生类时对UIScrollView的contentSize的调整模式。
typedef enum :NSUInteger
{
    MyLayoutAdjustScrollViewContentSizeModeAuto = 0,   //自动调整，在添加到UIScrollView之前(UITableView, UICollectionView除外)。如果值被设置Auto则自动会变化YES。如果值被设置为NO则不进行任何调整。
    MyLayoutAdjustScrollViewContentSizeModeNo = 1,     //不调整，任何加入到UIScrollView中的布局视图在尺寸变化时都不会调整contentSize的值。
    MyLayoutAdjustScrollViewContentSizeModeYes = 2     //会调整，任何加入到UIScrollView中的布局视图在尺寸变化时都会调整contentSize的值。
}MyLayoutAdjustScrollViewContentSizeMode;


//内部使用
typedef enum : unsigned char
{
    MyLayoutValueType_Nil,
    MyLayoutValueType_NSNumber,
    MyLayoutValueType_LayoutDime,
    MyLayoutValueType_LayoutPos,
    MyLayoutValueType_Array
}MyLayoutValueType;

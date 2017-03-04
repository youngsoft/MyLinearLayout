//
//  MyLayoutDef.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
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
 *布局视图方向的枚举类型定义。用来指定布局内子视图的整体排列布局方向。
 */
typedef enum : NSUInteger {
    MyLayoutViewOrientation_Vert = 0,  //垂直方向，布局视图内所有子视图整体从上到下排列布局
    MyLayoutViewOrientation_Horz = 1,  //水平方向，布局视图内所有子视图整体从左到右排列布局
} MyLayoutViewOrientation;



/**
 *布局视图内所有子视图的停靠方向和填充拉伸属性以及对齐方式的枚举类型定义。
 所谓停靠方向就是指子视图停靠在布局视图中水平方向和垂直方向的位置。水平方向一共有左、水平中心、右、窗口水平中心四个位置，垂直方向一共有上、垂直中心、下、窗口垂直中心四个位置。
 所谓填充拉伸属性就是指子视图的尺寸填充或者子视图的间距拉伸满整个布局视图。一共有水平宽度、垂直高度两种尺寸填充，水平间距、垂直间距两种间距拉伸。
 所谓对齐方式就是指多个子视图之间的对齐位置。水平方向一共有左、水平居中、右、左右两端对齐四种对齐方式，垂直方向一共有上、垂直居中、下、向下两端对齐四种方式。
 在线性布局、流式布局、浮动布局中有一个gravity属性用来表示布局内所有子视图的停靠方向和填充拉伸属性；在流式布局中有一个arrangedGravity属性用来表示布局内每排子视图的对齐方式。
 */
typedef enum : unsigned short {
    
    //默认值，不停靠、不填充、不对齐。
    MyMarginGravity_None = 0,

    //水平方向
    MyMarginGravity_Horz_Left = 1,             //左边停靠或者左对齐
    MyMarginGravity_Horz_Center = 2,           //水平中心停靠或者水平居中对齐
    MyMarginGravity_Horz_Right = 4,            //右边停靠或者右对齐
    MyMarginGravity_Horz_Window_Center = 8,    //窗口水平中心停靠，表示在屏幕窗口的水平中心停靠
    MyMarginGravity_Horz_Between = 16,         //水平间距拉伸
    MyMarginGravity_Horz_Fill = MyMarginGravity_Horz_Left | MyMarginGravity_Horz_Center | MyMarginGravity_Horz_Right, //水平宽度填充
    MyMarginGravity_Horz_Mask = 0xFF00,        //水平掩码，用来获取水平方向的枚举值

    //垂直方向
    MyMarginGravity_Vert_Top = 1 << 8,             //上边停靠或者上对齐
    MyMarginGravity_Vert_Center = 2 << 8,          //垂直中心停靠或者垂直居中对齐
    MyMarginGravity_Vert_Bottom = 4 << 8,          //下边停靠或者下边对齐
    MyMarginGravity_Vert_Window_Center = 8 << 8,   //窗口垂直中心停靠，表示在屏幕窗口的垂直中心停靠
    MyMarginGravity_Vert_Between = 16 << 8,        //垂直间距拉伸
    MyMarginGravity_Vert_Fill = MyMarginGravity_Vert_Top | MyMarginGravity_Vert_Center | MyMarginGravity_Vert_Bottom,  //垂直高度填充
    MyMarginGravity_Vert_Mask = 0x00FF,            //垂直掩码，用来获取垂直方向的枚举值

    //整体居中
    MyMarginGravity_Center = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Center,

    //全部填充
    MyMarginGravity_Fill = MyMarginGravity_Horz_Fill | MyMarginGravity_Vert_Fill,
    
    //全部拉伸
    MyMarginGravity_Between = MyMarginGravity_Horz_Between | MyMarginGravity_Vert_Between
    
    
    
} MyMarginGravity;


/**
 *设置当将布局视图嵌入到UIScrollView以及其派生类时对UIScrollView的contentSize的调整设置模式的枚举类型定义。
 *当将一个布局视图作为子视图添加到UIScrollView或者其派生类时(UITableView,UICollectionView除外)系统会自动调整和计算并设置其中的contentSize值。您可以使用布局视图的属性adjustScrollViewContentSizeMode来进行设置定义的枚举值。
 */
typedef enum :NSUInteger
{
    MyLayoutAdjustScrollViewContentSizeModeAuto = 0,   //自动调整，在添加到UIScrollView之前(UITableView, UICollectionView除外)。如果值被设置Auto则在添加到父视图后自动会变为YES。
    MyLayoutAdjustScrollViewContentSizeModeNo = 1,     //不调整，任何加入到UIScrollView中的布局视图在尺寸变化时都不会调整和设置contentSize的值。
    MyLayoutAdjustScrollViewContentSizeModeYes = 2     //会调整，任何加入到UIScrollView中的布局视图在尺寸变化时都会调整和设置contentSize的值。
}MyLayoutAdjustScrollViewContentSizeMode;


/**
 *用来设置当线性布局中的子视图的尺寸大于线性布局的尺寸时的子视图的压缩策略枚举类型定义。请参考线性布局的shrinkType属性的定义。
 */
typedef enum : NSUInteger {
    MySubviewsShrink_None = 0,     //不压缩。
    MySubviewsShrink_Average = 1,  //平均压缩。
    MySubviewsShrink_Weight = 2,   //比例压缩。
    MySubviewsShrink_Auto = 4,     //自动压缩。这个属性只有在水平线性布局里面并且只有2个子视图的宽度等于自身时才有用。这个属性主要用来实现左右两个子视图根据自身内容来进行缩放，以便实现最佳的宽度空间利用。
    
} MySubviewsShrinkType;



//内部使用
typedef enum : unsigned char
{
    MyLayoutValueType_Nil,
    MyLayoutValueType_NSNumber,
    MyLayoutValueType_LayoutDime,
    MyLayoutValueType_LayoutPos,
    MyLayoutValueType_Array
}MyLayoutValueType;

//
//  YSLayoutDef.h
//  YSLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//


//如果想使用老的库的所有的定义则请定义YS_USEOLDLIBDEF这个宏，这个的目的是为了兼容老的版本
#ifdef YS_USEOLDLIBDEF

    #ifndef YS_USEOLDENUMDEF
        #define YS_USEOLDENUMDEF 1
    #endif

    #ifndef YS_USEOLDMETHODDEF
        #define YS_USEOLDMETHODDEF 1
    #endif

    #define YSDEPRECATED(desc)

#else

    #define YSDEPRECATED(desc)  __attribute__((deprecated(desc)))

#endif


//如果想使用老的枚举类型的定义则请定义YS_USEOLDENUMDEF这个宏，这个目的是为了兼容老的版本
#ifdef YS_USEOLDENUMDEF

    #define YSENUMDEPRECATED(desc)

#else

    #define YSENUMDEPRECATED(desc) YSDEPRECATED(desc)

#endif

//如果想使用老的方法的定义则请定义YS_USEOLDMETHODDEF这个宏，这个的目的是为了兼容老的版本
#ifdef YS_USEOLDMETHODDEF

    #define YSMETHODDEPRECATED(desc)

#else

    #define YSMETHODDEPRECATED(desc) YSDEPRECATED(desc)

#endif



/**
 视图在布局视图中的停靠属性。
 可用于视图的扩展属性marginGravity，用于指定视图在YSFrameLayout布局中的停靠位置。
 可用于YSLinearLayout布局的gravity属性，用于指定布局中的所有视图的停靠位置。
 可用于YSFlowLayout布局的gravity,arrangedGravity属性设置
 */
typedef enum : unsigned short {
    
    /**过期的枚举定义**/
    MGRAVITY_NONE YSENUMDEPRECATED("use YSMarginGravity_None") = 0,
    
    //水平
    MGRAVITY_HORZ_LEFT YSENUMDEPRECATED("use YSMarignGravity_Horz_Left") = 1,
    MGRAVITY_HORZ_CENTER YSENUMDEPRECATED("use YSMarignGravity_Horz_Center") = 2,
    MGRAVITY_HORZ_RIGHT YSENUMDEPRECATED("use YSMarignGravity_Horz_Right")= 4,
    MGRAVITY_HORZ_WINDOW_CENTER YSENUMDEPRECATED("use YSMarignGravity_Horz_Window_Center") = 8,  //在窗口中水平居中。
    MGRAVITY_HORZ_FILL YSENUMDEPRECATED("use YSMarignGravity_Horz_Fill") = MGRAVITY_HORZ_LEFT | MGRAVITY_HORZ_CENTER | MGRAVITY_HORZ_RIGHT,
    MGRAVITY_HORZ_MASK YSENUMDEPRECATED("use YSMarignGravity_Horz_Mask") = 0xFF00,     //设置水平前请跟这个值进行&操作再跟具体的水平|
    
    //垂直
    MGRAVITY_VERT_TOP YSENUMDEPRECATED("use YSMarignGravity_Vert_Top") = 1 << 8,
    MGRAVITY_VERT_CENTER YSENUMDEPRECATED("use YSMarignGravity_Vert_Center") = 2 << 8,
    MGRAVITY_VERT_BOTTOM YSENUMDEPRECATED("use YSMarignGravity_Vert_Bottom") = 4 << 8,
    MGRAVITY_VERT_WINDOW_CENTER YSENUMDEPRECATED("use YSMarignGravity_Vert_Window_Center") = 8 << 8, //窗口中垂直居中
    MGRAVITY_VERT_FILL YSENUMDEPRECATED("use YSMarignGravity_Vert_Fill") = MGRAVITY_VERT_TOP | MGRAVITY_VERT_CENTER | MGRAVITY_VERT_BOTTOM,
    MGRAVITY_VERT_MASK YSENUMDEPRECATED("use YSMarignGravity_Vert_Mask") = 0x00FF,   //设置垂直前请跟这个值进行&操作再跟具体的垂直|
    
    //居中
    MGRAVITY_CENTER YSENUMDEPRECATED("use YSMarignGravity_Center") = MGRAVITY_HORZ_CENTER | MGRAVITY_VERT_CENTER,
    
    //填充
    MGRAVITY_FILL YSENUMDEPRECATED("use YSMarignGravity_Fill") = MGRAVITY_HORZ_FILL | MGRAVITY_VERT_FILL,
    
    
    
    /**新的枚举值的定义**/
    YSMarginGravity_None = 0,

    //水平
    YSMarignGravity_Horz_Left = 1,
    YSMarignGravity_Horz_Center = 2,
    YSMarignGravity_Horz_Right = 4,
    YSMarignGravity_Horz_Window_Center = 8,
    YSMarignGravity_Horz_Fill = YSMarignGravity_Horz_Left | YSMarignGravity_Horz_Center | YSMarignGravity_Horz_Right,
    YSMarignGravity_Horz_Mask = 0xFF00,

    //垂直
    YSMarignGravity_Vert_Top = 1 << 8,
    YSMarignGravity_Vert_Center = 2 << 8,
    YSMarignGravity_Vert_Bottom = 4 << 8,
    YSMarignGravity_Vert_Window_Center = 8 << 8,
    YSMarignGravity_Vert_Fill = YSMarignGravity_Vert_Top | YSMarignGravity_Vert_Center | YSMarignGravity_Vert_Bottom,
    YSMarignGravity_Vert_Mask = 0x00FF,

    //居中
    YSMarignGravity_Center = YSMarignGravity_Horz_Center | YSMarignGravity_Vert_Center,

    //填充
    YSMarignGravity_Fill = YSMarignGravity_Horz_Fill | YSMarignGravity_Vert_Fill,
    
    
    
} YSMarignGravity;

//兼容老版本定义
typedef YSMarignGravity MarginGravity YSDEPRECATED("use YSMarginGravity");

 

//布局视图排列的方向定义
typedef enum : NSUInteger {
    /**过期的枚举值定义**/
    LVORIENTATION_VERT YSENUMDEPRECATED("use YSLayoutViewOrientation_Vert!") = 0,
    LVORIENTATION_HORZ YSENUMDEPRECATED("use YSLayoutViewOrientation_Horz!") = 1,
    
    /**新的枚举值的定义**/
    YSLayoutViewOrientation_Vert = 0,
    YSLayoutViewOrientation_Horz = 1,
} YSLayoutViewOrientation;

//兼容老版本定义
typedef YSLayoutViewOrientation LineViewOrientation YSDEPRECATED("use YSLayoutViewOrientation!");



typedef enum : unsigned char
{
    YSLayoutValueType_Nil,
    YSLayoutValueType_NSNumber,
    YSLayoutValueType_Layout,
    YSLayoutValueType_Array
}YSLayoutValueType;
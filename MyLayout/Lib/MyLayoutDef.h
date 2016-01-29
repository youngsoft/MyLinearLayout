//
//  MyLayoutDef.h
//  MyLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

//您可以解开下面的注释，兼容一些老的方法和老的枚举值告警
/*
#define MY_USEOLDMETHODDEF 1
#define MY_USEOLDMETHODNOWARNING 1
#define MY_USEOLDENUMDEF 1
#define MY_USEOLDENUMNOWARNING 1
*/

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
 视图在布局视图中的停靠属性。
 可用于视图的扩展属性marginGravity，用于指定视图在MyFrameLayout布局中的停靠位置。
 可用于MyLinearLayout布局的gravity属性，用于指定布局中的所有视图的停靠位置。
 可用于MyFlowLayout布局的gravity,arrangedGravity属性设置
 */
typedef enum : unsigned short {
    

//如果想使用老的枚举值定义则请定义这个宏MY_USEOLDENUMDEF, 如果使用老的宏定义而不出现警告则请定义MY_USEOLDENUMNOWARNING
#ifdef MY_USEOLDENUMDEF
    
    /**过期的枚举定义**/
    MGRAVITY_NONE MYENUMDEPRECATED("use MyMarginGravity_None") = 0,
    
    //水平
    MGRAVITY_HORZ_LEFT MYENUMDEPRECATED("use MyMarginGravity_Horz_Left") = 1,
    MGRAVITY_HORZ_CENTER MYENUMDEPRECATED("use MyMarginGravity_Horz_Center") = 2,
    MGRAVITY_HORZ_RIGHT MYENUMDEPRECATED("use MyMarginGravity_Horz_Right")= 4,
    MGRAVITY_HORZ_WINDOW_CENTER MYENUMDEPRECATED("use MyMarginGravity_Horz_Window_Center") = 8,  //在窗口中水平居中。
    MGRAVITY_HORZ_FILL MYENUMDEPRECATED("use MyMarginGravity_Horz_Fill") = MGRAVITY_HORZ_LEFT | MGRAVITY_HORZ_CENTER | MGRAVITY_HORZ_RIGHT,
    MGRAVITY_HORZ_MASK MYENUMDEPRECATED("use MyMarginGravity_Horz_Mask") = 0xFF00,     //设置水平前请跟这个值进行&操作再跟具体的水平|
    
    //垂直
    MGRAVITY_VERT_TOP MYENUMDEPRECATED("use MyMarginGravity_Vert_Top") = 1 << 8,
    MGRAVITY_VERT_CENTER MYENUMDEPRECATED("use MyMarginGravity_Vert_Center") = 2 << 8,
    MGRAVITY_VERT_BOTTOM MYENUMDEPRECATED("use MyMarginGravity_Vert_Bottom") = 4 << 8,
    MGRAVITY_VERT_WINDOW_CENTER MYENUMDEPRECATED("use MyMarginGravity_Vert_Window_Center") = 8 << 8, //窗口中垂直居中
    MGRAVITY_VERT_FILL MYENUMDEPRECATED("use MyMarginGravity_Vert_Fill") = MGRAVITY_VERT_TOP | MGRAVITY_VERT_CENTER | MGRAVITY_VERT_BOTTOM,
    MGRAVITY_VERT_MASK MYENUMDEPRECATED("use MyMarginGravity_Vert_Mask") = 0x00FF,   //设置垂直前请跟这个值进行&操作再跟具体的垂直|
    
    //居中
    MGRAVITY_CENTER MYENUMDEPRECATED("use MyMarginGravity_Center") = MGRAVITY_HORZ_CENTER | MGRAVITY_VERT_CENTER,
    
    //填充
    MGRAVITY_FILL MYENUMDEPRECATED("use MyMarginGravity_Fill") = MGRAVITY_HORZ_FILL | MGRAVITY_VERT_FILL,
    
#endif
    
    /**新的枚举值的定义**/
    MyMarginGravity_None = 0,

    //水平
    MyMarginGravity_Horz_Left = 1,
    MyMarginGravity_Horz_Center = 2,
    MyMarginGravity_Horz_Right = 4,
    MyMarginGravity_Horz_Window_Center = 8,
    MyMarginGravity_Horz_Fill = MyMarginGravity_Horz_Left | MyMarginGravity_Horz_Center | MyMarginGravity_Horz_Right,
    MyMarginGravity_Horz_Mask = 0xFF00,

    //垂直
    MyMarginGravity_Vert_Top = 1 << 8,
    MyMarginGravity_Vert_Center = 2 << 8,
    MyMarginGravity_Vert_Bottom = 4 << 8,
    MyMarginGravity_Vert_Window_Center = 8 << 8,
    MyMarginGravity_Vert_Fill = MyMarginGravity_Vert_Top | MyMarginGravity_Vert_Center | MyMarginGravity_Vert_Bottom,
    MyMarginGravity_Vert_Mask = 0x00FF,

    //居中
    MyMarginGravity_Center = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Center,

    //填充
    MyMarginGravity_Fill = MyMarginGravity_Horz_Fill | MyMarginGravity_Vert_Fill,
    
    
    
} MyMarginGravity;


//如果想使用老的枚举值定义则请定义这个宏MY_USEOLDENUMDEF, 如果使用老的宏定义而不出现警告则请定义MY_USEOLDENUMNOWARNING
#ifdef MY_USEOLDENUMDEF

//兼容老版本定义
typedef MyMarginGravity MarginGravity MYENUMDEPRECATED("use MyMarginGravity");

#endif


//布局视图排列的方向定义
typedef enum : NSUInteger {

//如果想使用老的枚举值定义则请定义这个宏MY_USEOLDENUMDEF, 如果使用老的宏定义而不出现警告则请定义MY_USEOLDENUMNOWARNING
#ifdef MY_USEOLDENUMDEF
    /**过期的枚举值定义**/
    LVORIENTATION_VERT MYENUMDEPRECATED("use MyLayoutViewOrientation_Vert!") = 0,
    LVORIENTATION_HORZ MYENUMDEPRECATED("use MyLayoutViewOrientation_Horz!") = 1,
#endif
    
    /**新的枚举值的定义**/
    MyLayoutViewOrientation_Vert = 0,
    MyLayoutViewOrientation_Horz = 1,
} MyLayoutViewOrientation;


//如果想使用老的枚举值定义则请定义这个宏MY_USEOLDENUMDEF, 如果使用老的宏定义而不出现警告则请定义MY_USEOLDENUMNOWARNING
#ifdef MY_USEOLDENUMDEF

//兼容老版本定义
typedef MyLayoutViewOrientation LineViewOrientation MYENUMDEPRECATED("use MyLayoutViewOrientation!");

#endif


//SizeClass的尺寸定义,下面是sizeClass的继承关系。
//也就是说设备当前是：w:Compact h:Compact 则会找出某个视图是否定义了这个尺寸，如果没有则找w:Any h:Compact。如果找到了
//则使用，否则继续往上找，指导w:Any h:Any这种尺寸，因为默认所有视图定义的属性都是w:Any h:Any的。所以总是会找到对应的视图定义的
//尺寸的。
/*
 w:Compact h:Compact 继承 (w:Any h:Compact , w:Compact h:Any , w:Any h:Any)
 w:Regular h:Compact 继承 (w:Any h:Compact , w:Regular h:Any , w:Any h:Any)
 w:Compact h:Regular 继承 (w:Any h:Regular , w:Compact h:Any , w:Any h:Any)
 w:Regular h:Regular 继承 (w:Any h:Regular , w:Regular h:Any , w:Any h:Any)
 */
typedef enum : NSInteger{
    MySizeClass_wAny = 0,       //任意尺寸
    MySizeClass_wCompact = 1,   //压缩尺寸
    MySizeClass_wRegular = 2,   //常规尺寸
    
    MySizeClass_hAny = 0,       //任意尺寸
    MySizeClass_hCompact = 1 << 4,   //压缩尺寸
    MySizeClass_hRegular = 2 << 4,   //常规尺寸
}MySizeClass;





//内部使用
typedef enum : unsigned char
{
    MyLayoutValueType_Nil,
    MyLayoutValueType_NSNumber,
    MyLayoutValueType_Layout,
    MyLayoutValueType_Array
}MyLayoutValueType;

//
//  MyLayoutDef.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//


/**
 视图在布局视图中的停靠属性。
    可用于视图的扩展属性marginGravity，用于指定视图在MyFrameLayout布局中的停靠位置。
    可用于MyLinearLayout布局的gravity属性，用于指定布局中的所有视图的停靠位置。
 */
typedef enum : unsigned short {
    MGRAVITY_NONE = 0,
    
    //水平
    MGRAVITY_HORZ_LEFT = 1,
    MGRAVITY_HORZ_CENTER = 2,
    MGRAVITY_HORZ_RIGHT = 4,
    MGRAVITY_HORZ_WINDOW_CENTER = 8,  //在窗口中水平居中。
    
    //水平填满
    MGRAVITY_HORZ_FILL = MGRAVITY_HORZ_LEFT | MGRAVITY_HORZ_CENTER | MGRAVITY_HORZ_RIGHT,
    
    MGRAVITY_HORZ_MASK = 0xFF00,     //设置水平前请跟这个值进行&操作再跟具体的水平|
    
    //垂直
    MGRAVITY_VERT_TOP = 1 << 8,
    MGRAVITY_VERT_CENTER = 2 << 8,
    MGRAVITY_VERT_BOTTOM = 4 << 8,
    MGRAVITY_VERT_WINDOW_CENTER = 8 << 8, //窗口中垂直居中
    
    //垂直填满
    MGRAVITY_VERT_FILL = MGRAVITY_VERT_TOP | MGRAVITY_VERT_CENTER | MGRAVITY_VERT_BOTTOM,
    
    MGRAVITY_VERT_MASK = 0x00FF,   //设置垂直前请跟这个值进行&操作再跟具体的垂直|
    
    //居中
    MGRAVITY_CENTER = MGRAVITY_HORZ_CENTER | MGRAVITY_VERT_CENTER,
    
    //填满
    MGRAVITY_FILL = MGRAVITY_HORZ_FILL | MGRAVITY_VERT_FILL
    
} MarignGravity;


//布局排列的方向
typedef enum : NSUInteger {
    LVORIENTATION_VERT,
    LVORIENTATION_HORZ,
} LineViewOrientation;





typedef enum : unsigned char
{
    MyLayoutValueType_NULL,
    MyLayoutValueType_NSNumber,
    MyLayoutValueType_Layout,
    MyLayoutValueType_Array
}MyLayoutValueType;
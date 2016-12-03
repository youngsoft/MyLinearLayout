//
//  MyLayoutDef.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

//#if TARGET_OS_IPHONE

    #import <UIKit/UIKit.h>

//#elif TARGET_OS_MAC

//#import <AppKit/AppKit.h>


//   #define UIView NSView
//   #define UIEdgeInsets NSEdgeInsets
//   #define UIColor NSColor
//   #define UIImage NSImage

//#endif



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
    MyMarginGravity_Horz_Between = 16,   //水平间距拉伸，用于线性布局和流式布局
    MyMarginGravity_Horz_Fill = MyMarginGravity_Horz_Left | MyMarginGravity_Horz_Center | MyMarginGravity_Horz_Right,
    MyMarginGravity_Horz_Mask = 0xFF00,

    //垂直
    MyMarginGravity_Vert_Top = 1 << 8,
    MyMarginGravity_Vert_Center = 2 << 8,
    MyMarginGravity_Vert_Bottom = 4 << 8,
    MyMarginGravity_Vert_Window_Center = 8 << 8,  //屏幕垂直居中
    MyMarginGravity_Vert_Between = 16 << 8,       //垂直间距拉伸，用于线性布局和流式布局
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


/**
 * 这个枚举定义在线性布局里面当某个子视图的尺寸为weight或者尺寸为相对尺寸时，而当剩余的有固定尺寸和间距的子视图的尺寸总和要大于
 * 视图本身的尺寸时，对那些具有固定尺寸或者固定间距的子视图的处理方式。需要注意的是只有当子视图的尺寸和间距总和大于布局视图的尺寸时才有意义，否则无意义。
 * 比如某个垂直线性布局的高度是100。 里面分别有A,B,C,D四个子视图。其中:
 A.topPos = 10
 A.height = 50
 B.topPos = 0.1
 B.weight = 0.2
 C.height = 60
 D.topPos = 20
 D.weight = 0.7
 
 那么这时候总的固定高度 = A.topPos + A.height + C.height +D.topPos = 140 > 100。
 也就是多出了40的尺寸值，那么这时候我们可以用如下压缩类型的组合进行特殊的处理：
 
 1. MySubviewsShrink_Average | MySubviewsShrink_Size: (布局的默认设置。)
 这种情况下，我们只会压缩那些具有固定尺寸的视图的高度A,C的尺寸，每个子视图的压缩的值是：剩余的尺寸40 / 固定尺寸的视图数量2 = 20。 这样:
 A的最终高度 = 50 - 20 = 30
 C的最终高度 = 60 - 20 = 40
 2. MySubviewsShrink_Average | MySubviewsShrink_Space: (暂时不支持！)
 这种情况下，我们只会压缩那些具有固定间距的视图:A,D的间距，每个子视图的压缩的值是：剩余的尺寸40 / 固定间距的视图的数量2 = 20。 这样：
 A的最终topPos = 10 - 20 = -10
 D的最终topPos = 20 - 20 = 0
 3. MySubviewsShrink_Average | MySubviewsShrink_SizeAndSpace:  (暂时不支持！)
 这种情况下，我们会压缩那些具有固定高度和固定间距的视图：A,C,D. 每个子视图的压缩值是： 剩余的尺寸40 /固定值的数量4 = 10。 这样：
 A的最终topPos = 10 - 10 = 0
 A的最终高度 = 50 - 10 = 40
 C的最终高度 = 60 - 10 = 50
 D的最终topPos = 20 - 10 = 10
 
 4.MySubviewsShrink_Weight | MySubviewsShrink_Size:
 这种情况下，我们只会压缩那些具有固定尺寸的视图的高度A,C的尺寸，这些总的高度为50 + 60 = 110. 这样：
 A的最终高度 = 50 - 40 *(50/110) = 32
 C的最终高度 = 60 - 40 *（60/110) = 38
 
 5. MySubviewsShrink_Weight | MySubviewsShrink_Space: (暂时不支持！)
 这种情况下，我们只会压缩那些具有固定间距的视图:A,D的间距，这些总的间距为10+20 = 30. 这样：
 A的最终topPos = 10 - 40 *(10/30) = -3
 D的最终topPos = 20 - 40 *(20/30) = -7
 
 6. MySubviewsShrink_Weight | MySubviewsShrink_SizeAndSpace: (暂时不支持！)
 这种情况下，我们会压缩那些具有固定高度和固定间距的视图：A,C,D. 这些总的高度为10+50+60+20 = 140。这样：
 A的最终topPos = 10 - 40 *(10/140) = 7
 A的最终高度 = 50 - 40 *(50/140) = 36
 C的最终高度 = 60 - 40*(60/140) = 43
 D的最终topPos = 20 - 40 *(20/140) = 14
 
 7. MySubviewsShrink_None:
 这种情况下即使是固定的视图的尺寸超出也不会进行任何压缩！！！！这个属性设置后，MySubviewsShrink_Size，MySubviewsShrink_Space，MySubviewsShrink_SizeAndSpace的设置无意义。
 
 */
typedef enum : NSUInteger {
    MySubviewsShrink_Average = 0,  //平均压缩。
    MySubviewsShrink_Weight = 1,   //比例压缩。
    MySubviewsShrink_None = 8,     //不压缩。
    
    MySubviewsShrink_Size =   0 << 4,    //只压缩尺寸，因为这里是0所以这部分可以不设置。
    MySubviewsShrink_Space =  1 << 4,    //只压缩间距，暂时不支持！！
    MySubviewsShrink_SizeAndSpace = 2 << 4  //压缩尺寸和间距。暂时不支持！！！
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

//
//  MyLinearLayout.h
//  MyLinearLayoutDEMO
//
//  Created by oybq on 15/2/12.
//  Copyright (c) 2015年. All rights reserved.
//  Email:obq0387_cn@sina.com
//  qq:156355113
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"



//用于线性布局的子视图的属性，描述离兄弟视图的间隔距离，以及在父视图中的比重。
@interface UIView(LinearLayoutExtra)

//距离前面兄弟视图的距离，如果前面没有兄弟视图则是距离MyLinearLayout头部的距离,如果为0则表示没有头部距离，如果设置为0> <1之间则
//表示为相对头部距离也就是头部距离是浮动的跟weight的意义相似了
@property(nonatomic, assign) CGFloat headMargin;

//距离后面兄弟视图的距离，如果后面没有兄弟视图则是距离MyLinearLayout尾部的距离,如果为0则表示没有头部距离，如果设置为0> <1之间则
//表示为相对头部距离也就是头部距离是浮动的跟weight的意义相似了。可以实现不同屏幕之间的布局
@property(nonatomic, assign) CGFloat tailMargin;

//比重，指定自定的高度或者宽度在父视图的比重。取值为>=0 <=1,这个特性用于平均分配高宽度或者按比例分配高宽度
@property(nonatomic, assign) CGFloat weight;

//相对尺寸如果为0则视图使用绝对的高度或宽度；值的范围是0-1表示自身的高度或者宽度是linearlayout的高度和宽度的百分比，如果是垂直布局则是宽度，如果是水平布局则是高度,如果是1则表示和linearlayout是一样的高度和宽度；如果为负数则表示本视图离linearlayout的两边的边距是多少。
@property(nonatomic,assign) CGFloat matchParent;

@end


//布局排列的方向
typedef enum : NSUInteger {
    LVORIENTATION_VERT,
    LVORIENTATION_HORZ,
} LineViewOrientation;

//里面子视图的对齐方式
typedef enum : NSUInteger{

  LVALIGN_DEFAULT = 0,   //默认，不改变对齐方式
  LVALIGN_LEFT = 1,     //用于垂直布局，左对齐
  LVALIGN_RIGHT = 2,     //用于垂直布局，右对齐
  LVALIGN_TOP = 1,      //用于水平布局，顶对齐
  LVALIGN_BOTTOM = 2,   //用于水平布局，底部对齐
  LVALIGN_CENTER = 3,    //居中对齐
}LineViewAlign;


//调整大小时伸缩的方向
typedef enum : NSUInteger {
    LVAUTOADJUSTDIR_TAIL,   //头部固定尾部伸缩,默认值
    LVAUTOADJUSTDIR_CENTER, //中间固定头尾伸缩
    LVAUTOADJUSTDIR_HEAD,   //尾部固定头部伸缩
}LineViewAutoAdjustDir;




/*
   线性视图，类似android的LinearLayout布局。支持2个方向。现在的版本要求子视图的位置或者是否隐藏改变后需要调用
   使用线性布局时里面的子视图的frame.origin.y是无效的，而是通过子视图的headMargin,tailMargin分别指出其距离他
   兄弟的距离以及weight用来表明他在父视图之中的比重。因此在xib上如果用MyLineView来进行布局则可能实际上显示的内容
   和真实的内容是不一致的。而且线性布局会因为子视图的大小和边距而调整自己的尺寸。因此线性布局比较适合通过代码的方式来
   构造视图。同时适合于将线性布局作为scrollview的子视图来布局。因为线性布局在位置调整后会
   如果是使用自动布局则这个类将无效。
 
 注意：如果使用这个类请关闭XIB中的自动布局功能。或者父视图的自动布局功能。
 */
@interface MyLinearLayout : MyLayout

//方向，默认是纵向的
@property(nonatomic,assign) LineViewOrientation orientation;

//所谓对齐方式就是布局方向的另外一边的对齐形式，如果是垂直布局则是默认和左中右对齐，如果是水平布局则是默认和上中下对齐，这里的默认是指不调整子视图的原来的非布局方向的位置。
@property(nonatomic,assign) LineViewAlign align;  //布局时的对齐方式默认是不处理:LVALIGN_DEFAULT


//本视图的非布局方向的尺寸是否跟子视图里面最大尺寸保持一致。默认是NO,假如是垂直布局则表示宽度是否和子视图里面最宽的子视图的宽度保持一致。
//假如是水平布局则表示高度是否和子视图里面最高的子视图的高度保持一致。
@property(nonatomic,assign) BOOL wrapContent;


//如果线性布局的父视图是UIScrollView或者子类则在线性布局的位置调整后是否调整滚动视图的contentsize,默认是NO
//这个属性适合与整个线性布局作为滚动视图的唯一子视图来使用。
@property(nonatomic, assign, getter = isAdjustScrollViewContentSize) BOOL adjustScrollViewContentSize;


//align的值是非布局方向的对齐方式，而gravity是方向上的布局，默认是LVALIGN_DEFAULT，如果如果这个属性的值不是LVALIGN_DEFAULT
//则autoAdjustSize不起作用了。而且如果子视图里面有weight了也不起作用了，里面的子视图将在方向按上中下或者左中右依次排列
//
@property(nonatomic, assign) LineViewAlign gravity;


//是否调整自己的大小，默认是YES的.如果设置为NO的话则adjustScrollViewContentSize就没有实际的意思了。
//注意这里是调整自己布局方向的大小,不会影响maxSubViewMeasure
@property(nonatomic, assign, getter =isAutoAdjustSize) BOOL autoAdjustSize;

//当调整自己大小时是的伸缩方向，默认是LVAUTOADJUST_TAIL，这个属性只有在autoAdjustSize为YES时才有效。
@property(nonatomic,assign) LineViewAutoAdjustDir autoAdjustDir;






@end

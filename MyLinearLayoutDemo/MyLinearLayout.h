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



@interface UIView(LinearLayoutExtra)

//比重，指定自定的高度或者宽度在父视图的比重。取值为>=0 <=1,这个特性用于平均分配高宽度或者按比例分配高宽度
@property(nonatomic, assign) CGFloat weight;

@end


//布局排列的方向
typedef enum : NSUInteger {
    LVORIENTATION_VERT,
    LVORIENTATION_HORZ,
} LineViewOrientation;


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


//本视图的非布局方向的尺寸是否跟子视图里面最大尺寸保持一致。默认是NO,假如是垂直布局则表示宽度是否和子视图里面最宽的子视图的宽度保持一致。
//假如是水平布局则表示高度是否和子视图里面最高的子视图的高度保持一致。
@property(nonatomic,assign) BOOL wrapContent;


//如果线性布局的父视图是UIScrollView或者子类则在线性布局的位置调整后是否调整滚动视图的contentsize,默认是NO
//这个属性适合与整个线性布局作为滚动视图的唯一子视图来使用。
@property(nonatomic, assign, getter = isAdjustScrollViewContentSize) BOOL adjustScrollViewContentSize;


//里面的所有子视图的停靠位置，默认是MGRAVITY_NONE，如果如果这个属性的值不是MGRAVITY_NONE
//则autoAdjustSize不起作用了。而且如果子视图里面有weight了也不起作用了，里面的子视图将在方向按上中下或者左中右依次排列
//
@property(nonatomic, assign) MarignGravity gravity;


//是否调整自己的大小，默认是YES的.如果设置为NO的话则adjustScrollViewContentSize就没有实际的意思了。
//注意这里是调整自己布局方向的大小,不会影响wrapContent
@property(nonatomic, assign, getter =isAutoAdjustSize) BOOL autoAdjustSize;

//当调整自己大小时是的伸缩方向，默认是LVAUTOADJUST_TAIL，这个属性只有在autoAdjustSize为YES时才有效。
@property(nonatomic,assign) LineViewAutoAdjustDir autoAdjustDir;


//均分子视图和间距,布局会根据里面的子视图的数量来平均分配子视图的高度或者宽度以及间距。
//这个函数只对已经加入布局的视图有效，函数调用后加入的子视图无效。
//centered属性描述是否所有子视图居中，当居中时顶部和底部会保留出间距，而不居中时则顶部和底部不保持间距
-(void)averageSubviews:(BOOL)centered;

//均分子视图的间距，上面函数会使子视图和间距的尺寸保持一致，而这个函数则是子视图的尺寸保持不变而间距自动平均分配。
//centered的意义同上。
-(void)averageMargin:(BOOL)centered;



@end

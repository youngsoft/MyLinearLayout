//
//  MyLayoutSizeClass.h
//  MyLayout
//
//  Created by oybq on 16/1/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//


#import "MyLayoutDef.h"
#import "MyLayoutPos.h"
#import "MyLayoutSize.h"

@class MyBaseLayout;

/*
 SizeClass的尺寸定义,用于定义苹果设备的各种屏幕的尺寸，对于任意一种设备来说某个纬度的尺寸都可以描述为：Any任意，Compact压缩，Regular常规
 三种形式，比如下面就列出了苹果各种设备的SizeClass定义：
 
 iPhone4S,iPhone5/5s,iPhone6
 竖屏：(w:Compact h:Regular)
 横屏：(w:Compact h:Compact)
 iPhone6 Plus
 竖屏：(w:Compact h:Regular)
 横屏：(w:Regular h:Compact)
 iPad
 竖屏：(w:Regular h:Regular)
 横屏：(w:Regular h:Regular)
 Apple Watch
 竖屏：(w:Compact h:Compact)
 横屏：(w:Compact h:Compact)

 我们可以专门为某种设备的SizeClass来设置具体的各种子视图和布局的约束，但是为了兼容多种设备，我们提出了SizeClass的继承关系,其中的继承关系如下：
 
 w:Compact h:Compact 继承 (w:Any h:Compact , w:Compact h:Any , w:Any h:Any)
 w:Regular h:Compact 继承 (w:Any h:Compact , w:Regular h:Any , w:Any h:Any)
 w:Compact h:Regular 继承 (w:Any h:Regular , w:Compact h:Any , w:Any h:Any)
 w:Regular h:Regular 继承 (w:Any h:Regular , w:Regular h:Any , w:Any h:Any)
 
 
  也就是说设备当前是：w:Compact h:Compact 则会找出某个视图是否定义了这个SizeClass的界面约束布局，如果没有则找w:Any h:Compact。如果找到了
 则使用，否则继续往上找，直到w:Any h:Any这种尺寸，因为默认所有视图和布局视图的约束设置都是基于w:Any h:Any的。所以总是会找到对应的视图定义的约束的。
 
 在上述的定义中我们发现了2个问题，一个就是没有一个明确来指定横屏和竖屏这种屏幕的情况；另外一个是iPad设备的宽度和高度都是regular，而无法区分横屏和竖屏。因此这里对
 MySizeClass新增加了两个定义：竖屏MySizeClass_Portrait和横屏MySizeClass_Landscape。我们可以用这两个SizeClass来定义全局横屏以及某类设备的横屏和竖屏
 
 在默认情况下现有的布局以及子视图的约束设置都是基于w:Any h:Any的,如果我们要为某种SizeClass设置约束则可以调用视图的扩展方法：
 
 -(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass;
 -(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass;


 这两个方法需要传递一个宽度的MySizeClass定义和高度的MySizeClass定义，并通过 | 运算符来组合。 比如：
 
 1.想设置所有iPhone设备的横屏的约束
     UIView *lsc = [某视图 fetchLayoutSizeClass:MySizeClass_wAny|MySizeClass_hCompact];
 
 2.想设置所有iPad设备的横屏的约束
    UIView *lsc = [某视图 fetchLayoutSizeClass: MySizeClass_wRegular | MySizeClass_hRegular | MySizeClass_Landscape];
 
 3.想设置iphone6plus下的横屏的约束
     UIView *lsc = [某视图 fetchLayoutSizeClass:MySizeClass_wRegular|MySizeClass_hCompact];
 
 4.想设置ipad下的约束
    UIView *lsc = [某视图 fetchLayoutSizeClass:MySizeClass_wRegular | MySizeClass_hRegular];

 5.想设置所有设备下的约束，也是默认的视图的约束
    UIView *lsc = [某视图 fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hAny];
 
 6.所有设备的竖屏约束：
   UIView *lsc = [某视图 fetchLayoutSizeClass:MySizeClass_Portrait];
 
 7.所有设备的横屏约束：
   UIView *lsc = [某视图 fetchLayoutSizeClass:MySizeClass_Landscape];
 
 
 
 fetchLayoutSizeClass虽然返回的是一个instancetype,但实际得到了一个MyLayoutSizeClass对象或者其派生类，而MyLayoutSizeClass类中又定义了跟UIView一样相同的布局方法，因此虽然是返回视图对象，并设置各种约束，但实际上是设置MyLayoutSizeClass对象的各种约束。
 
 */
typedef enum : unsigned char{
    MySizeClass_wAny = 0,       //宽度任意尺寸
    MySizeClass_wCompact = 1,   //宽度压缩尺寸,这个属性在iOS8以下不支持
    MySizeClass_wRegular = 2,   //宽度常规尺寸,这个属性在iOS8以下不支持
    
    MySizeClass_hAny = 0,            //高度任意尺寸
    MySizeClass_hCompact = 1 << 2,   //高度压缩尺寸,这个属性在iOS8以下不支持
    MySizeClass_hRegular = 2 << 2,   //高度常规尺寸,这个属性在iOS8以下不支持

    MySizeClass_Portrait = 0x40,  //竖屏
    MySizeClass_Landscape = 0x80,  //横屏,注意横屏和竖屏不支持 | 运算操作，只能指定一个。
}MySizeClass;



/*
 布局的尺寸类型类，这个类的功能用来支持类似于iOS的Size Class机制用来实现各种屏幕下的视图的约束。
 MyLayoutSizeClass类中定义的各种属性跟视图和布局的各种扩展属性是一致的。
 
 我们所有的视图的默认的约束设置都是基于MySizeClass_wAny|MySizeClass_hAny这种SizeClass的。
 
 需要注意的是因为MyLayoutSizeClass是基于苹果SizeClass实现的，因此如果是iOS7的系统则只能支持MySizeClass_wAny|MySizeClass_hAny这种
 SizeClass，以及MySizeClass_Portrait或者MySizeClass_Landscape 也就是设置布局默认的约束。而iOS8以上的系统则能支持所有的SizeClass.
  
 */
@interface MyViewSizeClass:NSObject<NSCopying>

@property(nonatomic, weak) UIView *view;

//所有视图通用
@property(nonatomic, strong)  MyLayoutPos *topPos;
@property(nonatomic, strong)  MyLayoutPos *leadingPos;
@property(nonatomic, strong)  MyLayoutPos *bottomPos;
@property(nonatomic, strong)  MyLayoutPos *trailingPos;
@property(nonatomic, strong)  MyLayoutPos *centerXPos;
@property(nonatomic, strong)  MyLayoutPos *centerYPos;


@property(nonatomic, strong,readonly)  MyLayoutPos *leftPos;
@property(nonatomic, strong,readonly)  MyLayoutPos *rightPos;



@property(nonatomic, assign) CGFloat myTop;
@property(nonatomic, assign) CGFloat myLeading;
@property(nonatomic, assign) CGFloat myBottom;
@property(nonatomic, assign) CGFloat myTrailing;
@property(nonatomic, assign) CGFloat myCenterX;
@property(nonatomic, assign) CGFloat myCenterY;
@property(nonatomic, assign) CGPoint myCenter;


@property(nonatomic, assign) CGFloat myLeft;
@property(nonatomic, assign) CGFloat myRight;



@property(nonatomic, assign) CGFloat myMargin;
@property(nonatomic, assign) CGFloat myHorzMargin;
@property(nonatomic, assign) CGFloat myVertMargin;


@property(nonatomic, strong)  MyLayoutSize *widthSize;
@property(nonatomic, strong)  MyLayoutSize *heightSize;

@property(nonatomic, assign) CGFloat myWidth;
@property(nonatomic, assign) CGFloat myHeight;
@property(nonatomic, assign) CGSize  mySize;


@property(nonatomic, assign) BOOL wrapContentWidth;
@property(nonatomic, assign) BOOL wrapContentHeight;

@property(nonatomic, assign) BOOL wrapContentSize;

@property(nonatomic, assign) BOOL useFrame;
@property(nonatomic, assign) BOOL noLayout;

@property(nonatomic, assign) MyVisibility myVisibility;
@property(nonatomic, assign) MyGravity myAlignment;

@property(nonatomic, copy) void (^viewLayoutCompleteBlock)(MyBaseLayout* layout, UIView *v);

//线性布局和浮动布局子视图专用
@property(nonatomic, assign) CGFloat weight;

//浮动布局子视图专用
@property(nonatomic,assign,getter=isReverseFloat) BOOL reverseFloat;
@property(nonatomic,assign) BOOL clearFloat;

@end


@interface MyLayoutViewSizeClass : MyViewSizeClass

@property(nonatomic, assign) CGFloat topPadding;
@property(nonatomic, assign) CGFloat leadingPadding;
@property(nonatomic, assign) CGFloat bottomPadding;
@property(nonatomic, assign) CGFloat trailingPadding;
@property(nonatomic, assign) UIEdgeInsets padding;


@property(nonatomic, assign) CGFloat leftPadding;
@property(nonatomic, assign) CGFloat rightPadding;


@property(nonatomic, assign) BOOL zeroPadding;

@property(nonatomic ,assign) CGFloat subviewVSpace;
@property(nonatomic, assign) CGFloat subviewHSpace;
@property(nonatomic, assign) CGFloat subviewSpace;

@property(nonatomic, assign) MyGravity gravity;

@property(nonatomic, assign) BOOL reverseLayout;   //逆序布局，子视图从后往前。



@end


@interface MySequentLayoutViewSizeClass : MyLayoutViewSizeClass

@property(nonatomic,assign) MyOrientation orientation;



@end




@interface MyLinearLayoutViewSizeClass : MySequentLayoutViewSizeClass

@property(nonatomic, assign) MySubviewsShrinkType shrinkType;

@end



@interface MyTableLayoutViewSizeClass : MyLinearLayoutViewSizeClass

@end


@interface MyFlowLayoutViewSizeClass : MySequentLayoutViewSizeClass

@property(nonatomic,assign) NSInteger arrangedCount;
@property(nonatomic, assign) NSInteger pagedCount;
@property(nonatomic,assign) BOOL autoArrange;
@property(nonatomic,assign) MyGravity arrangedGravity;

@property(nonatomic, assign) CGFloat subviewSize;
@property(nonatomic, assign) CGFloat minSpace;
@property(nonatomic, assign) CGFloat maxSpace;



@end


@interface MyFloatLayoutViewSizeClass : MySequentLayoutViewSizeClass

@property(nonatomic, assign) CGFloat subviewSize;
@property(nonatomic, assign) CGFloat minSpace;
@property(nonatomic, assign) CGFloat maxSpace;
@property(nonatomic,assign) BOOL noBoundaryLimit;

@end


@interface MyRelativeLayoutViewSizeClass : MyLayoutViewSizeClass


@end


@interface MyFrameLayoutViewSizeClass : MyLayoutViewSizeClass


@end

@interface MyPathLayoutViewSizeClass  : MyLayoutViewSizeClass


@end




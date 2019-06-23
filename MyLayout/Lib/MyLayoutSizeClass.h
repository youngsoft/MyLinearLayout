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
#import "MyGrid.h"

@class MyBaseLayout;


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

@property(nonatomic, strong)  MyLayoutPos *baselinePos;


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

@property(nonatomic, assign) MyVisibility visibility;
@property(nonatomic, assign) MyGravity alignment;

@property(nonatomic, copy) void (^viewLayoutCompleteBlock)(MyBaseLayout* layout, UIView *v);

//线性布局和浮动布局子视图专用
@property(nonatomic, assign) CGFloat weight;

//浮动布局子视图专用
@property(nonatomic,assign,getter=isReverseFloat) BOOL reverseFloat;
@property(nonatomic,assign) BOOL clearFloat;

@end


@interface MyLayoutViewSizeClass : MyViewSizeClass

@property(nonatomic, assign) BOOL zeroPadding;

@property(nonatomic, assign) BOOL reverseLayout;
@property(nonatomic, assign) CGAffineTransform layoutTransform;  //布局变换。

@property(nonatomic, assign) MyGravity gravity;

@property(nonatomic, assign) BOOL insetLandscapeFringePadding;

@property(nonatomic, assign) CGFloat topPadding;
@property(nonatomic, assign) CGFloat leadingPadding;
@property(nonatomic, assign) CGFloat bottomPadding;
@property(nonatomic, assign) CGFloat trailingPadding;
@property(nonatomic, assign) UIEdgeInsets padding;


@property(nonatomic, assign) CGFloat leftPadding;
@property(nonatomic, assign) CGFloat rightPadding;



@property(nonatomic, assign) UIRectEdge insetsPaddingFromSafeArea;



@property(nonatomic ,assign) CGFloat subviewVSpace;
@property(nonatomic, assign) CGFloat subviewHSpace;
@property(nonatomic, assign) CGFloat subviewSpace;






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

@property(nonatomic,assign) MyGravity arrangedGravity;
@property(nonatomic,assign) BOOL autoArrange;

@property(nonatomic,assign) NSInteger arrangedCount;
@property(nonatomic, assign) NSInteger pagedCount;

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


@interface MyGridLayoutViewSizeClass : MyLayoutViewSizeClass<MyGrid>

@end




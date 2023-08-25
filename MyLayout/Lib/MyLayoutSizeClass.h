//
//  MyLayoutSizeClass.h
//  MyLayout
//
//  Created by oybq on 16/1/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyGrid.h"
#import "MyLayoutDef.h"
#import "MyLayoutPos.h"
#import "MyLayoutSize.h"

@class MyBaseLayout;

@class MyViewTraits;

//视图的布局引擎。
@interface MyLayoutEngine : NSObject

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat trailing;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGRect frame;

//默认的布局分类，所有视图的布局相关的属性，都是设置到这个分类上。
@property (nonatomic, weak) MyViewTraits *defaultSizeClass;

//当前的布局分类，当前正在执行布局时所用的布局分类。
@property (nonatomic, weak) MyViewTraits *currentSizeClass;

@property (nonatomic, assign, readonly) BOOL multiple; //是否设置了多个sizeclass

@property (nonatomic, strong) NSMutableDictionary<NSNumber*, MyViewTraits*> *sizeClasses;

@property (nonatomic, assign) BOOL hasObserver;

- (void)reset;

- (MyViewTraits *)fetchView:(UIView *)view layoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass;

- (MyViewTraits *)fetchView:(UIView *)view bestLayoutSizeClass:(MySizeClass)sizeClass;

- (void)setView:(UIView *)view layoutSizeClass:(MySizeClass)sizeClass withTraits:(MyViewTraits *)traits;

@end


@interface UIView (MyLayoutExtInner)

@property (nonatomic, strong, readonly) MyLayoutEngine *myEngine;
@property (nonatomic, strong, readonly) MyLayoutEngine *myEngineInner;


- (id)createSizeClassInstance;

- (instancetype)myDefaultSizeClass;
- (instancetype)myDefaultSizeClassInner;

- (instancetype)myCurrentSizeClass;
- (instancetype)myCurrentSizeClassInner;

@property (nonatomic, readonly) MyLayoutPos *topPosInner;
@property (nonatomic, readonly) MyLayoutPos *leadingPosInner;
@property (nonatomic, readonly) MyLayoutPos *bottomPosInner;
@property (nonatomic, readonly) MyLayoutPos *trailingPosInner;
@property (nonatomic, readonly) MyLayoutPos *centerXPosInner;
@property (nonatomic, readonly) MyLayoutPos *centerYPosInner;
@property (nonatomic, readonly) MyLayoutSize *widthSizeInner;
@property (nonatomic, readonly) MyLayoutSize *heightSizeInner;

@property (nonatomic, readonly) MyLayoutPos *leftPosInner;
@property (nonatomic, readonly) MyLayoutPos *rightPosInner;

@property (nonatomic, readonly) MyLayoutPos *baselinePosInner;

@property (nonatomic, readonly) CGFloat myEstimatedWidth;
@property (nonatomic, readonly) CGFloat myEstimatedHeight;

@end



/*
 布局的属性特征集合类，这个类的功能用来存储涉及到布局的各种属性。MyViewTraits类中定义的各种属性跟视图和布局的各种扩展属性是一致的。
 */
@interface MyViewTraits : NSObject <NSCopying>

@property (nonatomic, weak) UIView *view;

//所有视图通用
@property (nonatomic, strong) MyLayoutPos *topPos;
@property (nonatomic, strong) MyLayoutPos *leadingPos;
@property (nonatomic, strong) MyLayoutPos *bottomPos;
@property (nonatomic, strong) MyLayoutPos *trailingPos;
@property (nonatomic, strong) MyLayoutPos *centerXPos;
@property (nonatomic, strong) MyLayoutPos *centerYPos;

@property (nonatomic, strong, readonly) MyLayoutPos *leftPos;
@property (nonatomic, strong, readonly) MyLayoutPos *rightPos;

@property (nonatomic, strong) MyLayoutPos *baselinePos;

@property (nonatomic, assign) CGFloat myTop;
@property (nonatomic, assign) CGFloat myLeading;
@property (nonatomic, assign) CGFloat myBottom;
@property (nonatomic, assign) CGFloat myTrailing;
@property (nonatomic, assign) CGFloat myCenterX;
@property (nonatomic, assign) CGFloat myCenterY;
@property (nonatomic, assign) CGPoint myCenter;

@property (nonatomic, assign) CGFloat myLeft;
@property (nonatomic, assign) CGFloat myRight;

@property (nonatomic, assign) CGFloat myMargin;
@property (nonatomic, assign) CGFloat myHorzMargin;
@property (nonatomic, assign) CGFloat myVertMargin;

@property (nonatomic, strong) MyLayoutSize *widthSize;
@property (nonatomic, strong) MyLayoutSize *heightSize;

@property (nonatomic, assign) CGFloat myWidth;
@property (nonatomic, assign) CGFloat myHeight;
@property (nonatomic, assign) CGSize mySize;

@property (nonatomic, assign) BOOL wrapContentWidth;
@property (nonatomic, assign) BOOL wrapContentHeight;

@property (nonatomic, assign) BOOL wrapContentSize;

@property (nonatomic, assign) BOOL useFrame;
@property (nonatomic, assign) BOOL noLayout;

@property (nonatomic, assign) MyVisibility visibility;
@property (nonatomic, assign) MyGravity alignment;

@property (nonatomic, copy) void (^viewLayoutCompleteBlock)(MyBaseLayout *layout, UIView *v);

//线性布局和浮动布局和流式布局子视图专用
@property (nonatomic, assign) CGFloat weight;

//浮动布局子视图专用
@property (nonatomic, assign, getter=isReverseFloat) BOOL reverseFloat;
@property (nonatomic, assign) BOOL clearFloat;

//内部属性
@property (nonatomic, strong, readonly) MyLayoutPos *topPosInner;
@property (nonatomic, strong, readonly) MyLayoutPos *leadingPosInner;
@property (nonatomic, strong, readonly) MyLayoutPos *bottomPosInner;
@property (nonatomic, strong, readonly) MyLayoutPos *trailingPosInner;
@property (nonatomic, strong, readonly) MyLayoutPos *centerXPosInner;
@property (nonatomic, strong, readonly) MyLayoutPos *centerYPosInner;
@property (nonatomic, strong, readonly) MyLayoutSize *widthSizeInner;
@property (nonatomic, strong, readonly) MyLayoutSize *heightSizeInner;

@property (nonatomic, strong, readonly) MyLayoutPos *leftPosInner;
@property (nonatomic, strong, readonly) MyLayoutPos *rightPosInner;

@property (nonatomic, strong, readonly) MyLayoutPos *baselinePosInner;

@property (class, nonatomic, assign) BOOL isRTL;

//内部方法
- (BOOL)invalid;

+ (MyGravity)convertLeadingTrailingGravityFromLeftRightGravity:(MyGravity)horzGravity;
- (MyGravity)finalVertGravityFrom:(MyGravity)layoutVertGravity;
- (MyGravity)finalHorzGravityFrom:(MyGravity)layoutHorzGravity;

@end

@interface MyLayoutTraits : MyViewTraits

@property (nonatomic, assign) BOOL zeroPadding;

@property (nonatomic, assign) BOOL reverseLayout;
@property (nonatomic, assign) CGAffineTransform layoutTransform; //布局变换。

@property (nonatomic, assign) MyGravity gravity;

@property (nonatomic, assign) BOOL insetLandscapeFringePadding;

@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingLeading;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat paddingTrailing;
@property (nonatomic, assign) UIEdgeInsets padding;

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;

//兼容1.9.2以及以前的老版本，因为老版本的命名不符合规范，所以这里重新命名。
//@property (nonatomic, assign, getter=paddingTop, setter=setPaddingTop:) CGFloat topPadding;
//@property (nonatomic, assign, getter=paddingLeading, setter=setPaddingLeading:) CGFloat leadingPadding;
//@property (nonatomic, assign, getter=paddingBottom, setter=setPaddingBottom:) CGFloat bottomPadding;
//@property (nonatomic, assign, getter=paddingTrailing, setter=setPaddingTrailing:) CGFloat trailingPadding;
//@property (nonatomic, assign, getter=paddingLeft, setter=setPaddingLeft:) CGFloat leftPadding;
//@property (nonatomic, assign, getter=paddingRight, setter=setPaddingRight:) CGFloat rightPadding;

//为支持iOS11的safeArea而进行的padding的转化
- (CGFloat)myLayoutPaddingTop;
- (CGFloat)myLayoutPaddingBottom;
- (CGFloat)myLayoutPaddingLeft;
- (CGFloat)myLayoutPaddingRight;
- (CGFloat)myLayoutPaddingLeading;
- (CGFloat)myLayoutPaddingTrailing;

@property (nonatomic, assign) UIRectEdge insetsPaddingFromSafeArea;

@property (nonatomic, assign) CGFloat subviewVSpace;
@property (nonatomic, assign) CGFloat subviewHSpace;
@property (nonatomic, assign) CGFloat subviewSpace;

//从全部子视图引擎数组中过滤出需要进行布局的子视图布局引擎数组子集。
- (NSMutableArray<MyLayoutEngine *> *)filterEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines;

@end

@interface MySequentLayoutFlexSpacing : NSObject
@property (nonatomic, assign) CGFloat subviewSize;
@property (nonatomic, assign) CGFloat minSpace;
@property (nonatomic, assign) CGFloat maxSpace;
@property (nonatomic, assign) BOOL centered;

- (CGFloat)calcMaxMinSubviewSizeForContent:(CGFloat)selfSize paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding space:(CGFloat *)pSpace;
- (CGFloat)calcMaxMinSubviewSize:(CGFloat)selfSize arrangedCount:(NSInteger)arrangedCount paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding space:(CGFloat *)pSpace;

@end

@interface MySequentLayoutTraits : MyLayoutTraits

@property (nonatomic, assign) MyOrientation orientation;
@property (nonatomic, strong) MySequentLayoutFlexSpacing *flexSpace;

@end

@interface MyLinearLayoutTraits : MySequentLayoutTraits

@property (nonatomic, assign) MySubviewsShrinkType shrinkType;

@end

@interface MyTableLayoutTraits : MyLinearLayoutTraits

@end

@interface MyFlowLayoutTraits : MySequentLayoutTraits

@property (nonatomic, assign) MyGravity arrangedGravity;
@property (nonatomic, assign) BOOL autoArrange;
@property (nonatomic, assign) BOOL isFlex;
@property (nonatomic, assign) MyGravityPolicy lastlineGravityPolicy;

@property (nonatomic, assign) NSInteger arrangedCount;
@property (nonatomic, assign) NSInteger pagedCount;

@end

@interface MyFloatLayoutTraits : MySequentLayoutTraits

@end

@interface MyRelativeLayoutTraits : MyLayoutTraits

@end

@interface MyFrameLayoutTraits : MyLayoutTraits

@end

@interface MyPathLayoutTraits : MyLayoutTraits

@end

@interface MyGridLayoutTraits : MyLayoutTraits <MyGrid>

@end

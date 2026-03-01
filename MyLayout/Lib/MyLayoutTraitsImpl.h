//
//  MyLayoutTraitsImpl.h
//  MyLayout
//
//  Created by oybq on 16/1/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyLayoutTraits.h"
#import "MyGridNode.h"

@class MyViewTraitsImpl;

//视图的布局引擎。
@interface MyLayoutEngine : NSObject

-(instancetype)initWithTraitsClass:(Class)traitsClass;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat trailing;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGRect frame;



@property (nonatomic, copy) void (^viewLayoutCompleteBlock)(MyBaseLayout *, UIView *);

//默认的布局特性，所有视图对象属性中所指定的布局特性。
@property (nonatomic, weak)  __kindof MyViewTraitsImpl *defaultTraits;

//当前的布局特性，也就是视图所处当前sizeclass下的布局特性。
@property (nonatomic, weak) __kindof MyViewTraitsImpl *currentTraits;

@property (nonatomic, assign, readonly) BOOL multiple; //是否设置了多个布局特性集

@property (nonatomic, strong) NSMutableDictionary<NSNumber*, __kindof MyViewTraitsImpl* > *traitsDict;

@property (nonatomic, assign) BOOL hasObserver;

- (void)reset;

- (__kindof MyViewTraitsImpl* )fetchView:(UIView *)view traitsInSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass;

- (__kindof MyViewTraitsImpl* )fetchView:(UIView *)view bestTraitsAt:(MySizeClass)sizeClass;

- (void)setView:(UIView *)view newTraits:(__kindof MyViewTraitsImpl* )traits at:(MySizeClass)sizeClass;

@end

/*
 布局的属性特征集合类，这个类的功能用来存储涉及到布局的各种属性。MyViewTraits类中定义的各种属性跟视图和布局的各种扩展属性是一致的。
 */
@interface MyViewTraitsImpl : NSObject <NSCopying, MyViewTraits>

@property (nonatomic, weak) UIView *view;


@property (class, nonatomic, assign) BOOL isRTL;


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


//内部方法
- (BOOL)invalid;

+ (MyGravity)convertLeadingTrailingGravityFromLeftRightGravity:(MyGravity)horzGravity;
- (MyGravity)finalVertGravityFrom:(MyGravity)layoutVertGravity;
- (MyGravity)finalHorzGravityFrom:(MyGravity)layoutHorzGravity;

@end

@interface MyLayoutTraitsImpl : MyViewTraitsImpl<MyLayoutTraits>

//为支持iOS11的safeArea而进行的padding的转化
- (CGFloat)myLayoutPaddingTop;
- (CGFloat)myLayoutPaddingBottom;
- (CGFloat)myLayoutPaddingLeft;
- (CGFloat)myLayoutPaddingRight;
- (CGFloat)myLayoutPaddingLeading;
- (CGFloat)myLayoutPaddingTrailing;


//从全部子视图引擎数组中过滤出需要进行布局的子视图布局引擎数组子集。
- (NSMutableArray<MyLayoutEngine *> *)filterEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines;

@end

@interface MySequentLayoutFlexSpacing : NSObject
@property (nonatomic, assign) CGFloat subviewsSize;
@property (nonatomic, assign) CGFloat minSpacing;
@property (nonatomic, assign) CGFloat maxSpacing;
@property (nonatomic, assign) BOOL centered;

- (CGFloat)calcMaxMinSubviewsSizeForContent:(CGFloat)selfSize paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding spacing:(CGFloat *)pSpacing;
- (CGFloat)calcMaxMinSubviewsSize:(CGFloat)selfSize arrangedCount:(NSInteger)arrangedCount paddingStart:(CGFloat *)pStarPadding paddingEnd:(CGFloat *)pEndPadding spacing:(CGFloat *)pSpacing;

@end

@interface MySequentLayoutTraitsImpl : MyLayoutTraitsImpl<MySequentLayoutTraits>

@property (nonatomic, strong) MySequentLayoutFlexSpacing *flexSpacing;

@end

@interface MyLinearLayoutTraitsImpl : MySequentLayoutTraitsImpl<MyLinearLayoutTraits>

@end

@interface MyTableLayoutTraitsImpl : MyLinearLayoutTraitsImpl<MyTableLayoutTraits>

@end

@interface MyFlowLayoutTraitsImpl : MySequentLayoutTraitsImpl<MyFlowLayoutTraits>

@end

@interface MyFloatLayoutTraitsImpl : MySequentLayoutTraitsImpl<MyFloatLayoutTraits>

@end

@interface MyRelativeLayoutTraitsImpl : MyLayoutTraitsImpl<MyRelativeLayoutTraits>

@end

@interface MyFrameLayoutTraitsImpl : MyLayoutTraitsImpl<MyFrameLayoutTraits>

@end

@interface MyPathLayoutTraitsImpl : MyLayoutTraitsImpl<MyPathLayoutTraits>

@end

@interface MyGridLayoutTraitsImpl : MyLayoutTraitsImpl <MyGridLayoutTraits, MyGridNode>

@end

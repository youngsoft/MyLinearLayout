//
//  MyLayoutInner.h
//  MyLayout
//
//  Created by oybq on 15/7/10.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"
#import "MyLayoutMath.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutTraitsImpl.h"
#import "MyLayoutSizeInner.h"


typedef struct _MyLayoutContext {

    BOOL isEstimate;
    
    MySizeClass sizeClass;
    
    MyGravity vertGravity;
    MyGravity horzGravity;

    MyLayoutEngine *layoutViewEngine;
    NSMutableArray<MyLayoutEngine *> *subviewEngines;
    
    //布局视图相关属性。
    CGSize selfSize;
    CGFloat paddingLeading;
    CGFloat paddingTrailing;
    CGFloat paddingTop;
    CGFloat paddingBottom;

    
    CGFloat horzSpacing;
    CGFloat vertSpacing;
    
} MyLayoutContext;

@interface UIView (MyLayoutExtInner)

@property (nonatomic, strong, readonly) MyLayoutEngine *myEngine;
@property (nonatomic, strong, readonly) MyLayoutEngine *myEngineInner;


- (__kindof MyViewTraitsImpl *)myDefaultTraits;
- (__kindof MyViewTraitsImpl *)myDefaultTraitsInner;

- (__kindof MyViewTraitsImpl *)myCurrentTraits;
- (__kindof MyViewTraitsImpl *)myCurrentTraitsInner;

@property (nonatomic, readonly) CGFloat myEstimatedWidth;
@property (nonatomic, readonly) CGFloat myEstimatedHeight;

//为支持iOS11的safeArea而进行的padding的转化
- (CGFloat)myLayoutPaddingTop;
- (CGFloat)myLayoutPaddingBottom;
- (CGFloat)myLayoutPaddingLeft;
- (CGFloat)myLayoutPaddingRight;
- (CGFloat)myLayoutPaddingLeading;
- (CGFloat)myLayoutPaddingTrailing;

@end


@interface MyBaseLayout ()

@property (nonatomic, assign) BOOL isMyLayouting;

//派生类重载这个函数进行布局
- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray *)subviewEngines context:(MyLayoutContext *)context;


- (CGFloat)myCalcSubview:(MyLayoutEngine *)subviewEngine
             vertGravity:(MyGravity)vertGravity
             baselinePos:(CGFloat)baselinePos
                 withContext:(MyLayoutContext *)context;

- (CGFloat)myCalcSubview:(MyLayoutEngine *)subviewEngine
             horzGravity:(MyGravity)horz
                 withContext:(MyLayoutContext *)context;

- (CGFloat)mySubview:(id<MyViewTraits>)subviewTraits wrapHeightSizeFits:(CGSize)size withContext:(MyLayoutContext *)context;

- (CGFloat)myGetBoundLimitMeasure:(MyLayoutSize *)anchor subview:(UIView *)subview anchorType:(MyLayoutAnchorType)anchorType subviewSize:(CGSize)subviewSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound;

- (CGFloat)myValidMeasure:(MyLayoutSize *)anchor subview:(UIView *)subview calcSize:(CGFloat)calcSize subviewSize:(CGSize)subviewSize selfLayoutSize:(CGSize)selfLayoutSize;

- (CGFloat)myValidMargin:(MyLayoutPos *)anchor subview:(UIView *)subview calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

- (NSArray *)myUpdateCurrentSizeClass:(MySizeClass)sizeClass subviews:(NSArray<UIView *> *)subviews;


- (CGSize)myAdjustLayoutViewSizeWithContext:(MyLayoutContext *)context;


- (void)myAdjustSizeSettingOfSubviewEngine:(MyLayoutEngine *)subviewEngine withContext:(MyLayoutContext *)context;

//根据子视图的宽度约束得到宽度值
- (CGFloat)myWidthSizeValueOfSubviewEngine:(MyLayoutEngine *)subviewEngine
                               withContext:(MyLayoutContext *)context;

//根据子视图的高度约束得到高度值
- (CGFloat)myHeightSizeValueOfSubviewEngine:(MyLayoutEngine *)subviewEngine
                                withContext:(MyLayoutContext *)context;

- (void)myCalcRectOfSubviewEngine:(MyLayoutEngine *)subviewEngine
                pMaxWrapSize:(CGSize *)pMaxWrapSize
                 withContext:(MyLayoutContext *)context;

- (UIFont *)myGetSubviewFont:(UIView *)subview;

- (MySizeClass)myGetGlobalSizeClass;

//给父布局视图机会来更改子布局视图的边界线的显示的rect
- (void)myHookSublayout:(MyBaseLayout *)sublayout borderlineRect:(CGRect *)pRect;

- (void)myCalcSubviewsWrapContentSize:(MyLayoutContext *)context withCustomSetting:(void (^)(MyViewTraitsImpl *subviewTraits))customSetting;

@end

//为了减少布局视图不必要的内存占用，这里将一些可选数据保存到这个类中来
@interface MyBaseLayoutOptionalData : NSObject

//特定场景处理的回调block
@property (nonatomic, copy) void (^beginLayoutBlock)(void);
@property (nonatomic, copy) void (^endLayoutBlock)(void);
@property (nonatomic, copy) void (^rotationToDeviceOrientationBlock)(MyBaseLayout *layout, BOOL isFirst, BOOL isPortrait);
@property (nonatomic, assign) int lastScreenOrientation; //为0为初始状态，为1为竖屏，为2为横屏。内部使用。

//动画扩展
@property (nonatomic, assign) NSTimeInterval aniDuration;
@property (nonatomic, assign) UIViewAnimationOptions aniOptions;
@property (nonatomic, copy) void (^aniCompletion)(BOOL finished);

@end



#define _MYLAYOUT_PROPERTY_GET1(type, name)\
-(type)name {\
return [super name];\
}\

#define _MYLAYOUT_PROPERTY_SET1(type, setName, name)\
-(void)set##setName:(type)name{\
[super set##setName:name];\
}\

#define _MYLAYOUT_PROPERTY_OVERRIDE1(type, setName, name)\
_MYLAYOUT_PROPERTY_GET1(type, name)\
_MYLAYOUT_PROPERTY_SET1(type, setName, name)\


#define _MYLAYOUT_PROPERTY_VIEW_GET1(type, name)\
-(type)name {\
return self.myDefaultTraitsInner.name;\
}\

#define _MYLAYOUT_PROPERTY_VIEW_SET1(type, setName, name)\
- (void)set##setName:(type)name {\
self.myDefaultTraits.name = name;\
}\

#define _MYLAYOUT_PROPERTY_VIEW_OVERRIDE1(type, setName, name)\
_MYLAYOUT_PROPERTY_VIEW_GET1(type, name)\
_MYLAYOUT_PROPERTY_VIEW_SET1(type, setName, name)\


#define _MYLAYOUT_PROPERTY_VIEW_GET2 _MYLAYOUT_PROPERTY_VIEW_GET1

#define _MYLAYOUT_PROPERTY_VIEW_SET2(type, setName, name)\
- (void)set##setName:(type)name {\
    MyViewTraitsImpl *viewTraits = (MyViewTraitsImpl*)self.myDefaultTraits;\
    if (viewTraits.name != name) {\
        viewTraits.name = name;\
        if (self.superview != nil) {\
            [self.superview setNeedsLayout];\
        }\
    }\
}\

#define _MYLAYOUT_PROPERTY_VIEW_OVERRIDE2(type, setName, name)\
_MYLAYOUT_PROPERTY_VIEW_GET2(type,name)\
_MYLAYOUT_PROPERTY_VIEW_SET2(type,setName,name)\


#define _MYLAYOUT_PROPERTY_VIEW_GET3(type, name)\
-(type)name {\
return ((MyViewTraitsImpl *)self.myDefaultTraits).name;\
}\


#define _MYLAYOUT_PROPERTY_LAYOUTVIEW_GET1(traits,type, name)\
-(type)name {\
return ((traits *)self.myDefaultTraitsInner).name;\
}\

#define _MYLAYOUT_PROPERTY_LAYOUTVIEW_SET1(traits, type, setName, name)\
- (void)set##setName:(type)name {\
    traits *layoutTraits = (traits *)self.myDefaultTraits;\
    if (layoutTraits.name != name) {\
        layoutTraits.name = name;\
        [self setNeedsLayout];\
    }\
}\


#define _MYLAYOUT_PROPERTY_LAYOUTVIEW_OVERRIDE1(traits, type, setName, name)\
_MYLAYOUT_PROPERTY_LAYOUTVIEW_GET1(traits,type,name)\
_MYLAYOUT_PROPERTY_LAYOUTVIEW_SET1(traits,type,setName,name)\




#define _MYLAYOUT_PROPERTY_GRIDLAYOUT_GET(type, name)\
-(type)name {\
return ((MyGridLayoutTraitsImpl*)self.myDefaultTraits).name;\
}\

#define _MYLAYOUT_PROPERTY_GRIDLAYOUT_SET(type, setName, name)\
- (void)set##setName:(type)name {\
MyGridLayoutTraitsImpl *layoutTraits = self.myDefaultTraits;\
layoutTraits.name = name;\
}\

#define _MYLAYOUT_PROPERTY_GRIDLAYOUT_OVERRIDE(type, setName, name)\
_MYLAYOUT_PROPERTY_GRIDLAYOUT_GET(type,name)\
_MYLAYOUT_PROPERTY_GRIDLAYOUT_SET(type,setName,name)\


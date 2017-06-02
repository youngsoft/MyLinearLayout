//
//  MyBaseLayout.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>


const char * const ASSOCIATEDOBJECT_KEY_MYLAYOUT_FRAME = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_FRAME";

void* _myObserverContextA = (void*)20175281;
void* _myObserverContextB = (void*)20175282;
void* _myObserverContextC = (void*)20175283;


@implementation UIView(MyLayoutExt)


-(MyLayoutPos*)topPos
{
    return self.myCurrentSizeClass.topPos;
}

-(MyLayoutPos*)leadingPos
{
    return self.myCurrentSizeClass.leadingPos;
}



-(MyLayoutPos*)bottomPos
{
    return self.myCurrentSizeClass.bottomPos;
}


-(MyLayoutPos*)trailingPos
{
    return self.myCurrentSizeClass.trailingPos;
}



-(MyLayoutPos*)centerXPos
{
    return self.myCurrentSizeClass.centerXPos;
}


-(MyLayoutPos*)centerYPos
{
   return  self.myCurrentSizeClass.centerYPos;
}


-(MyLayoutPos*)leftPos
{
    return self.myCurrentSizeClass.leftPos;
}

-(MyLayoutPos*)rightPos
{
    return self.myCurrentSizeClass.rightPos;
}




-(CGFloat)myTop
{
    return self.myCurrentSizeClass.myTop;
}

-(void)setMyTop:(CGFloat)myTop
{
    self.myCurrentSizeClass.myTop = myTop;
}

-(CGFloat)myLeading
{
    return self.myCurrentSizeClass.myLeading;
}

-(void)setMyLeading:(CGFloat)myLeading
{
    self.myCurrentSizeClass.myLeading = myLeading;
}


-(CGFloat)myBottom
{
    return self.myCurrentSizeClass.myBottom;
}

-(void)setMyBottom:(CGFloat)myBottom
{
    self.myCurrentSizeClass.myBottom = myBottom;
}



-(CGFloat)myTrailing
{
    return self.myCurrentSizeClass.myTrailing;
}

-(void)setMyTrailing:(CGFloat)myTrailing
{
    self.myCurrentSizeClass.myTrailing = myTrailing;
}


-(CGFloat)myCenterX
{
    return self.myCurrentSizeClass.myCenterX;
}

-(void)setMyCenterX:(CGFloat)myCenterX
{
    self.myCurrentSizeClass.myCenterX = myCenterX;
}

-(CGFloat)myCenterY
{
    return self.myCurrentSizeClass.myCenterY;
}

-(void)setMyCenterY:(CGFloat)myCenterY
{
    self.myCurrentSizeClass.myCenterY = myCenterY;
}


-(CGPoint)myCenter
{
    return self.myCurrentSizeClass.myCenter;
}

-(void)setMyCenter:(CGPoint)myCenter
{
    self.myCurrentSizeClass.myCenter = myCenter;
}


-(CGFloat)myLeft
{
    return self.myCurrentSizeClass.myLeft;
}

-(void)setMyLeft:(CGFloat)myLeft
{
    self.myCurrentSizeClass.myLeft = myLeft;
}

-(CGFloat)myRight
{
    return self.myCurrentSizeClass.myRight;
}

-(void)setMyRight:(CGFloat)myRight
{
    self.myCurrentSizeClass.myRight = myRight;
}



-(CGFloat)myMargin
{
    return self.myCurrentSizeClass.myMargin;
}

-(void)setMyMargin:(CGFloat)myMargin
{
    self.myCurrentSizeClass.myMargin = myMargin;
}

-(CGFloat)myHorzMargin
{
    return self.myCurrentSizeClass.myHorzMargin;
}

-(void)setMyHorzMargin:(CGFloat)myHorzMargin
{
    self.myCurrentSizeClass.myHorzMargin = myHorzMargin;
}


-(CGFloat)myVertMargin
{
    return self.myCurrentSizeClass.myVertMargin;
}

-(void)setMyVertMargin:(CGFloat)myVertMargin
{
    self.myCurrentSizeClass.myVertMargin = myVertMargin;
}


-(MyLayoutSize*)widthSize
{
    return self.myCurrentSizeClass.widthSize;
}



-(MyLayoutSize*)heightSize
{
    return self.myCurrentSizeClass.heightSize;
}


-(CGFloat)myWidth
{
    return self.myCurrentSizeClass.myWidth;
}


-(void)setMyWidth:(CGFloat)myWidth
{
    self.myCurrentSizeClass.myWidth = myWidth;
}

-(CGFloat)myHeight
{
    return self.myCurrentSizeClass.myHeight;
}

-(void)setMyHeight:(CGFloat)myHeight
{
    self.myCurrentSizeClass.myHeight = myHeight;
}

-(CGSize)mySize
{
    return self.myCurrentSizeClass.mySize;
}

-(void)setMySize:(CGSize)mySize
{
    self.myCurrentSizeClass.mySize = mySize;
}


-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.wrapContentHeight != wrapContentHeight)
    {
        sc.wrapContentHeight = wrapContentHeight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)wrapContentHeight
{
    //特殊处理，减少不必要的对象创建
    return self.myCurrentSizeClassInner.wrapContentHeight;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.wrapContentWidth != wrapContentWidth)
    {
        sc.wrapContentWidth = wrapContentWidth;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
    
}

-(BOOL)wrapContentWidth
{
    //特殊处理，减少不必要的对象创建
    return self.myCurrentSizeClassInner.wrapContentWidth;
}


-(BOOL)wrapContentSize
{
    return self.myCurrentSizeClassInner.wrapContentSize;
}

-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.wrapContentSize != wrapContentSize)
    {
        sc.wrapContentSize = wrapContentSize;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(CGFloat)weight
{
    return self.myCurrentSizeClass.weight;
}

-(void)setWeight:(CGFloat)weight
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.weight != weight)
    {
        sc.weight = weight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}



-(BOOL)useFrame
{
    return self.myCurrentSizeClass.useFrame;
}

-(void)setUseFrame:(BOOL)useFrame
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.useFrame != useFrame)
    {
        sc.useFrame = useFrame;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
    
}

-(BOOL)noLayout
{
    return self.myCurrentSizeClass.noLayout;
}

-(void)setNoLayout:(BOOL)noLayout
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.noLayout != noLayout)
    {
        sc.noLayout = noLayout;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
    
}

-(MyVisibility)myVisibility
{
    return self.myCurrentSizeClass.myVisibility;
}

-(void)setMyVisibility:(MyVisibility)myVisibility
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.myVisibility != myVisibility)
    {
        sc.myVisibility = myVisibility;
        if (myVisibility == MyVisibility_Visible)
            self.hidden = NO;
        else
            self.hidden = YES;
        
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }

}

-(MyGravity)myAlignment
{
    return self.myCurrentSizeClass.myAlignment;
}

-(void)setMyAlignment:(MyGravity)myAlignment
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.myAlignment != myAlignment)
    {
        sc.myAlignment = myAlignment;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }

}


-(void (^)(MyBaseLayout*, UIView*))viewLayoutCompleteBlock
{
    return self.myCurrentSizeClass.viewLayoutCompleteBlock;
}

-(void)setViewLayoutCompleteBlock:(void (^)(MyBaseLayout *, UIView *))viewLayoutCompleteBlock
{
    self.myCurrentSizeClass.viewLayoutCompleteBlock = viewLayoutCompleteBlock;
}





-(CGRect)estimatedRect
{
    CGRect rect = self.myFrame.frame;
    if (rect.size.width == CGFLOAT_MAX || rect.size.width == CGFLOAT_MAX)
        return self.frame;
    return rect;
}



-(void)resetMyLayoutSetting
{
    [self resetMyLayoutSettingInSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}

-(void)resetMyLayoutSettingInSizeClass:(MySizeClass)sizeClass
{
    [self.myFrame.sizeClasses removeObjectForKey:@(sizeClass)];
}






-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass
{
    return [self fetchLayoutSizeClass:sizeClass copyFrom:0xFF];
}

-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass
{
    MyFrame *myFrame = self.myFrame;
    if (myFrame.sizeClasses == nil)
        myFrame.sizeClasses = [NSMutableDictionary new];
    
    MyViewSizeClass *myLayoutSizeClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(sizeClass)];
    if (myLayoutSizeClass == nil)
    {
        MyViewSizeClass *srcLayoutSizeClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(srcSizeClass)];
        if (srcLayoutSizeClass == nil)
            myLayoutSizeClass = [self createSizeClassInstance];
        else
            myLayoutSizeClass = [srcLayoutSizeClass copy];
        myLayoutSizeClass.view = self;
        [myFrame.sizeClasses setObject:myLayoutSizeClass forKey:@(sizeClass)];
    }
    
    return (UIView*)myLayoutSizeClass;

}



@end

@implementation UIView(MyLayoutExtDeprecated)




-(CGFloat)myLeftMargin
{
    return self.myLeft;
}

-(void)setMyLeftMargin:(CGFloat)myLeftMargin
{
    self.myLeft = myLeftMargin;
}

-(CGFloat)myTopMargin
{
    return self.myTop;
}

-(void)setMyTopMargin:(CGFloat)myTopMargin
{
    self.myTop = myTopMargin;
}

-(CGFloat)myRightMargin
{
    return self.myRight;
}

-(void)setMyRightMargin:(CGFloat)myRightMargin
{
    self.myRight = myRightMargin;
}

-(CGFloat)myBottomMargin
{
    return self.myBottom;
}

-(void)setMyBottomMargin:(CGFloat)myBottomMargin
{
    self.myBottom = myBottomMargin;
}

-(MyLayoutSize*)widthDime
{
    return self.widthSize;
}



-(MyLayoutSize*)heightDime
{
    return self.heightSize;
}


-(CGFloat)myCenterXOffset
{
    return self.myCenterX;
}

-(void)setMyCenterXOffset:(CGFloat)myCenterXOffset
{
    self.myCenterX = myCenterXOffset;
}

-(CGFloat)myCenterYOffset
{
    return self.myCenterY;
}

-(void)setMyCenterYOffset:(CGFloat)myCenterYOffset
{
    self.myCenterY = myCenterYOffset;
}


-(CGPoint)myCenterOffset
{
    return self.myCenter;
}

-(void)setMyCenterOffset:(CGPoint)myCenterOffset
{
    self.myCenter = myCenterOffset;
}



-(void)setFlexedHeight:(BOOL)flexedHeight
{
    self.wrapContentHeight = flexedHeight;
}

-(BOOL)isFlexedHeight
{
    return self.wrapContentHeight;
}



@end


@implementation UIView(MyLayoutExtInner)


-(instancetype)myDefaultSizeClass
{
    return [self fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}


-(instancetype)myCurrentSizeClass
{
    MyFrame *myFrame = self.myFrame;  //减少多次访问，增加性能。
    if (myFrame.sizeClass == nil)
        myFrame.sizeClass = [self myDefaultSizeClass];
    
    return myFrame.sizeClass;
}

-(instancetype)myCurrentSizeClassInner
{
    //如果没有则不会建立，为了优化减少不必要的建立。
    MyFrame *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_FRAME);
    return obj.sizeClass;
}

-(instancetype)myCurrentSizeClassFrom:(MyFrame*)myFrame
{
    if (myFrame.sizeClass == nil)
        myFrame.sizeClass = [self myDefaultSizeClass];
    
    return myFrame.sizeClass;
}




-(instancetype)myBestSizeClass:(MySizeClass)sizeClass
{
    
    MySizeClass wsc = sizeClass & 0x03;
    MySizeClass hsc = sizeClass & 0x0C;
    MySizeClass ori = sizeClass & 0xC0;
    
    MyFrame *myFrame = self.myFrame;
    
    if (myFrame.sizeClasses == nil)
        myFrame.sizeClasses = [NSMutableDictionary new];
    
    
    MySizeClass searchSizeClass;
    MyViewSizeClass *myClass = nil;
    if (myFrame.multiple)
    {
        //first search the most exact SizeClass
        searchSizeClass = wsc | hsc | ori;
        myClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(searchSizeClass)];
        if (myClass != nil)
            return (UIView*)myClass;
        
        
        searchSizeClass = wsc | hsc;
        if (searchSizeClass != sizeClass)
        {
            MyViewSizeClass *myClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
        
        searchSizeClass = MySizeClass_wAny | hsc | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
            
        }
        
        searchSizeClass = MySizeClass_wAny | hsc;
        if (searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
        searchSizeClass = wsc | MySizeClass_hAny | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
        searchSizeClass = wsc | MySizeClass_hAny;
        if (searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
        searchSizeClass = MySizeClass_wAny | MySizeClass_hAny | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
    }
    
    searchSizeClass = MySizeClass_wAny | MySizeClass_hAny;
    myClass = (MyViewSizeClass*)[myFrame.sizeClasses objectForKey:@(searchSizeClass)];
    if (myClass == nil)
    {
        myClass = [self createSizeClassInstance];
        myClass.view = self;
        [myFrame.sizeClasses setObject:myClass forKey:@(searchSizeClass)];
    }
    
    return (UIView*)myClass;
    
    
}


-(MyFrame*)myFrame
{
    
    MyFrame *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_FRAME);
    if (obj == nil)
    {
        obj = [MyFrame new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_FRAME, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return obj;
}

-(id)createSizeClassInstance
{
    return [MyViewSizeClass new];
}


-(MyLayoutPos*)topPosInner
{
    return self.myCurrentSizeClass.topPosInner;
}

-(MyLayoutPos*)leadingPosInner
{
    return self.myCurrentSizeClass.leadingPosInner;
}

-(MyLayoutPos*)bottomPosInner
{
    return self.myCurrentSizeClass.bottomPosInner;
}

-(MyLayoutPos*)trailingPosInner
{
    return self.myCurrentSizeClass.trailingPosInner;
}



-(MyLayoutPos*)centerXPosInner
{
    return self.myCurrentSizeClass.centerXPosInner;
}


-(MyLayoutPos*)centerYPosInner
{
    return self.myCurrentSizeClass.centerYPosInner;
}


-(MyLayoutPos*)leftPosInner
{
   return self.myCurrentSizeClass.leftPosInner;
}

-(MyLayoutPos*)rightPosInner
{
   return self.myCurrentSizeClass.rightPosInner;
}



-(MyLayoutSize*)widthSizeInner
{
    return self.myCurrentSizeClass.widthSizeInner;
}


-(MyLayoutSize*)heightSizeInner
{
   return self.myCurrentSizeClass.heightSizeInner;
}








@end



@implementation MyBorderline


-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _color = [UIColor blackColor];
        _thick = 1;
        _headIndent = 0;
        _tailIndent = 0;
        _dash  = 0;
    }
    
    return self;
}

-(id)initWithColor:(UIColor *)color
{
    self = [self init];
    if (self != nil)
    {
        _color = color;
    }
    
    return self;
}

-(void)setThick:(CGFloat)thick
{
    if (thick < 1)
        thick = 1;
    if (_thick != thick)
    {
        _thick = thick;
    }
}

@end


@implementation MyBaseLayout
{
    MyTouchEventDelegate *_touchEventDelegate;
    
    MyBorderlineLayerDelegate *_borderlineLayerDelegate;
    
    BOOL _isAddSuperviewKVO;

    int _lastScreenOrientation; //为0为初始状态，为1为竖屏，为2为横屏。内部使用。
    
    BOOL _useCacheRects;
}


-(void)dealloc
{
    //如果您在使用时出现了KVO的异常崩溃，原因是您将这个视图被多次加入为子视图，请检查您的代码，是否这个视图被多次加入！！
    _endLayoutBlock = nil;
    _beginLayoutBlock = nil;
    _rotationToDeviceOrientationBlock = nil;
}

+(BOOL)isRTL
{
    return [MyViewSizeClass isRTL];
}

+(void)setIsRTL:(BOOL)isRTL
{
    [MyViewSizeClass setIsRTL:isRTL];
}

#pragma  mark -- Public Method


-(CGFloat)topPadding
{
    return self.myCurrentSizeClass.topPadding;
}

-(void)setTopPadding:(CGFloat)topPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.topPadding != topPadding)
    {
        lsc.topPadding = topPadding;
        [self setNeedsLayout];
    }
}

-(CGFloat)leadingPadding
{
    return self.myCurrentSizeClass.leadingPadding;
}

-(void)setLeadingPadding:(CGFloat)leadingPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.leadingPadding != leadingPadding)
    {
        lsc.leadingPadding = leadingPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)bottomPadding
{
    return self.myCurrentSizeClass.bottomPadding;
}

-(void)setBottomPadding:(CGFloat)bottomPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.bottomPadding != bottomPadding)
    {
        lsc.bottomPadding = bottomPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)trailingPadding
{
    return self.myCurrentSizeClass.trailingPadding;
}

-(void)setTrailingPadding:(CGFloat)trailingPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.trailingPadding != trailingPadding)
    {
        lsc.trailingPadding = trailingPadding;
        [self setNeedsLayout];
    }
}


-(UIEdgeInsets)padding
{
    return self.myCurrentSizeClass.padding;
}

-(void)setPadding:(UIEdgeInsets)padding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (!UIEdgeInsetsEqualToEdgeInsets(lsc.padding, padding))
    {
        lsc.padding = padding;
        [self setNeedsLayout];
    }
}


-(CGFloat)leftPadding
{
    return self.myCurrentSizeClass.leftPadding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.leftPadding != leftPadding)
    {
        lsc.leftPadding = leftPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)rightPadding
{
    return self.myCurrentSizeClass.rightPadding;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.rightPadding != rightPadding)
    {
        lsc.rightPadding = rightPadding;
        [self setNeedsLayout];
    }
}

-(BOOL)zeroPadding
{
    return self.myCurrentSizeClass.zeroPadding;
}

-(void)setZeroPadding:(BOOL)zeroPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.zeroPadding != zeroPadding)
    {
        lsc.zeroPadding = zeroPadding;
        [self setNeedsLayout];
    }
}



-(void)setSubviewHSpace:(CGFloat)subviewHSpace
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.subviewHSpace != subviewHSpace)
    {
        lsc.subviewHSpace = subviewHSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewHSpace
{
    return self.myCurrentSizeClass.subviewHSpace;
}

-(void)setSubviewVSpace:(CGFloat)subviewVSpace
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.subviewVSpace != subviewVSpace)
    {
        lsc.subviewVSpace = subviewVSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewVSpace
{
    return self.myCurrentSizeClass.subviewVSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.subviewSpace != subviewSpace)
    {
        lsc.subviewSpace = subviewSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewSpace
{
    return self.myCurrentSizeClass.subviewSpace;
}

-(void)setGravity:(MyGravity)gravity
{
    
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.gravity != gravity)
    {
        lsc.gravity = gravity;
        [self setNeedsLayout];
    }
}

-(MyGravity)gravity
{
    return self.myCurrentSizeClass.gravity;
}



-(void)setReverseLayout:(BOOL)reverseLayout
{
    
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.reverseLayout != reverseLayout)
    {
        lsc.reverseLayout = reverseLayout;
        [self setNeedsLayout];
    }
}

-(BOOL)reverseLayout
{
    return self.myCurrentSizeClass.reverseLayout;
}



-(void)setHideSubviewReLayout:(BOOL)hideSubviewReLayout
{
    //这个属性已经无效了，请单独设置子视图的myVisibility属性来控制视图的显示与否。
    NSAssert(0, @"oops!, hideSubviewReLayout is invalid please use subview's myVisibility to instead!!!");
}

-(BOOL)hideSubviewReLayout
{
    return NO;
}


-(void)layoutAnimationWithDuration:(NSTimeInterval)duration
{
    self.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
    };
    
    self.endLayoutBlock = ^{
    
        [UIView commitAnimations];
    };
}

-(MyBorderline*)topBorderline
{
    return _borderlineLayerDelegate.topBorderline;
}

-(void)setTopBorderline:(MyBorderline *)topBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayout:self];
    }
    
    _borderlineLayerDelegate.topBorderline = topBorderline;
}

-(MyBorderline*)leadingBorderline
{
    return _borderlineLayerDelegate.leadingBorderline;
}

-(void)setLeadingBorderline:(MyBorderline *)leadingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayout:self];
    }
    
    _borderlineLayerDelegate.leadingBorderline = leadingBorderline;
}

-(MyBorderline*)bottomBorderline
{
    return _borderlineLayerDelegate.bottomBorderline;
}

-(void)setBottomBorderline:(MyBorderline *)bottomBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayout:self];
    }
    
    _borderlineLayerDelegate.bottomBorderline = bottomBorderline;
}


-(MyBorderline*)trailingBorderline
{
    return _borderlineLayerDelegate.trailingBorderline;
}

-(void)setTrailingBorderline:(MyBorderline *)trailingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayout:self];
    }
    
    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}



-(MyBorderline*)leftBorderline
{
    return _borderlineLayerDelegate.leftBorderline;
}

-(void)setLeftBorderline:(MyBorderline *)leftBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayout:self];
    }
    
    _borderlineLayerDelegate.leftBorderline = leftBorderline;
}


-(MyBorderline*)rightBorderline
{
    return _borderlineLayerDelegate.rightBorderline;
}

-(void)setRightBorderline:(MyBorderline *)rightBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayout:self];
    }
    
    _borderlineLayerDelegate.rightBorderline = rightBorderline;
}


-(void)setBoundBorderline:(MyBorderline *)boundBorderline
{
    self.leadingBorderline = boundBorderline;
    self.trailingBorderline = boundBorderline;
    self.topBorderline = boundBorderline;
    self.bottomBorderline = boundBorderline;
}

-(MyBorderline*)boundBorderline
{
    return self.bottomBorderline;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage)
    {
        _backgroundImage = backgroundImage;
        self.layer.contents = (id)_backgroundImage.CGImage;
    }
}



-(CGRect)estimateLayoutRect:(CGSize)size inSizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    MyFrame *selfMyFrame = self.myFrame;
    
    if (selfMyFrame.multiple)
         selfMyFrame.sizeClass = [self myBestSizeClass:sizeClass];
    
    for (UIView *sbv in self.subviews)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        if (sbvmyFrame.multiple)
            sbvmyFrame.sizeClass = [sbv myBestSizeClass:sizeClass];
    }
    
    BOOL hasSubLayout = NO;
    CGSize selfSize= [self calcLayoutRect:size isEstimate:NO pHasSubLayout:&hasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (hasSubLayout)
    {
        selfMyFrame.width = selfSize.width;
        selfMyFrame.height = selfSize.height;
        
        selfSize = [self calcLayoutRect:CGSizeZero isEstimate:YES pHasSubLayout:&hasSubLayout sizeClass:sizeClass sbs:sbs];
    }
    
    selfMyFrame.width = selfSize.width;
    selfMyFrame.height = selfSize.height;
    
    
    
    //计算后还原为默认sizeClass
    for (UIView *sbv in self.subviews)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        if (sbvmyFrame.multiple)
            sbvmyFrame.sizeClass = self.myDefaultSizeClass;
    }
    
    if (selfMyFrame.multiple)
        selfMyFrame.sizeClass = self.myDefaultSizeClass;
    
    if (self.cacheEstimatedRect)
        _useCacheRects = YES;
    
    return CGRectMake(0, 0, selfSize.width, selfSize.height);
}

//只获取计算得到尺寸，不进行真正的布局。
-(CGRect)estimateLayoutRect:(CGSize)size
{
    return [self estimateLayoutRect:size inSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}

-(CGRect)estimateLayoutRect:(CGSize)size inSizeClass:(MySizeClass)sizeClass
{
    return [self estimateLayoutRect:size inSizeClass:sizeClass sbs:nil];
}

-(void)setCacheEstimatedRect:(BOOL)cacheEstimatedRect
{
    _cacheEstimatedRect = cacheEstimatedRect;
    _useCacheRects = NO;
}


-(CGRect)subview:(UIView*)subview estimatedRectInLayoutSize:(CGSize)size
{
    if (subview.superview == self)
        return subview.frame;
    
    NSMutableArray *sbs = [self myGetLayoutSubviews];
    [sbs addObject:subview];
    
    [self estimateLayoutRect:size inSizeClass:MySizeClass_wAny | MySizeClass_hAny sbs:sbs];
    
    return [subview estimatedRect];
}




-(void)setTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[MyTouchEventDelegate alloc] initWithLayout:self];
    }
    
    [_touchEventDelegate setTarget:target action:action];
}


-(void)setTouchDownTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[MyTouchEventDelegate alloc] initWithLayout:self];
    }

    [_touchEventDelegate setTouchDownTarget:target action:action];
}

-(void)setTouchCancelTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[MyTouchEventDelegate alloc] initWithLayout:self];
    }
    
    [_touchEventDelegate setTouchCancelTarget:target action:action];
    
}





#pragma mark -- Touches Event


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
    [_touchEventDelegate touchesBegan:touches withEvent:event];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}



#pragma mark -- KVO


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    
    //监控非布局父视图的frame的变化，而改变自身的位置和尺寸
    if (context == _myObserverContextC)
    {
        //只监控父视图的尺寸变换
        CGRect rcOld = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect rcNew = [change[NSKeyValueChangeNewKey] CGRectValue];
        if (!CGSizeEqualToSize(rcOld.size, rcNew.size))
        {
            [self myUpdateLayoutRectInNoLayoutSuperview:object];
        }
        return;
    }
    

    //监控子视图的frame的变化以便重新进行布局
    if (!_isMyLayouting)
    {
        
        if (context == _myObserverContextA)
        {
            [self setNeedsLayout];
            //这里添加的原因是有可能子视图取消隐藏后不会绘制自身，所以这里要求子视图重新绘制自身
            if ([keyPath isEqualToString:@"hidden"] && ![change[NSKeyValueChangeNewKey] boolValue])
            {
                [(UIView*)object setNeedsDisplay];
            }
            
        }
        else if (context == _myObserverContextB)
        {//针对UILabel特殊处理。。
            
            UIView *sbvsc = object.myCurrentSizeClass;
            
            if (sbvsc.widthSizeInner.dimeSelfVal != nil && sbvsc.heightSizeInner.dimeSelfVal != nil)
            {
                [self setNeedsLayout];
            }
            else if (sbvsc.wrapContentWidth ||
                     sbvsc.wrapContentHeight ||
                     sbvsc.widthSizeInner.dimeSelfVal != nil ||
                     sbvsc.heightSizeInner.dimeSelfVal != nil)
            {
                [object sizeToFit];
            }
        }
    }
}


#pragma mark -- Override Method



-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.wrapContentHeight != wrapContentHeight)
    {
        lsc.wrapContentHeight = wrapContentHeight;
        [self setNeedsLayout];
    }
}


-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.wrapContentWidth != wrapContentWidth)
    {
        lsc.wrapContentWidth = wrapContentWidth;
        [self setNeedsLayout];
    }
    
}

-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (lsc.wrapContentSize != wrapContentSize)
    {
        lsc.wrapContentSize = wrapContentSize;
        [self setNeedsLayout];
    }
}



-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize;
    if (isEstimate)
        selfSize = self.myFrame.frame.size;
    else
    {
        selfSize = self.bounds.size;
        if (size.width != 0)
            selfSize.width = size.width;
        if (size.height != 0)
            selfSize.height = size.height;
    }
    
    if (pHasSubLayout != nil)
        *pHasSubLayout = NO;
    
    return selfSize;
    
}


-(id)createSizeClassInstance
{
    return [MyLayoutViewSizeClass new];
}


-(CGSize)sizeThatFits:(CGSize)size
{
    return [self estimateLayoutRect:size].size;
}

-(void)setHidden:(BOOL)hidden
{
    if (self.isHidden == hidden)
        return;
    
    [super setHidden:hidden];
    if (hidden == NO)
    {
       
        [_borderlineLayerDelegate setNeedsLayout];
        
        if ([self.superview isKindOfClass:[MyBaseLayout class]])
        {
            [self setNeedsLayout];
        }
        
    }
   
}



- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];   //只要加入进来后就修改其默认的实现，而改用我们的实现，这里包括隐藏,调整大小，
    
    if ([subview isKindOfClass:[MyBaseLayout class]])
    {
        ((MyBaseLayout*)subview).cacheEstimatedRect = self.cacheEstimatedRect;
    }
    
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];  //删除后恢复其原来的实现。

    [self myRemoveSubviewObserver:subview];
}

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    
    //特殊处理如果视图是控制器根视图则取消wrapContentWidth, wrapContentHeight,以及adjustScrollViewContentSizeMode的设置。
    @try {
        
        if (newSuperview != nil)
        {
            id vc = [self valueForKey:@"viewDelegate"];
            if (vc != nil)
            {
                lsc.wrapContentWidth = NO;
                lsc.wrapContentHeight = NO;
                self.adjustScrollViewContentSizeMode = MyAdjustScrollViewContentSizeModeNo;
            }
        }
        
    } @catch (NSException *exception) {
        
    }
    
    
#ifdef DEBUG
    
    if (lsc.wrapContentHeight && lsc.heightSizeInner.dimeVal != nil)
    {
        //约束警告：wrapContentHeight和设置的heightSize可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentHeight and heightSize setting may be constraint.",self);
    }
    
    if (lsc.wrapContentWidth && lsc.widthSizeInner.dimeVal != nil)
    {
        //约束警告：wrapContentWidth和设置的widthSize可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentWidth and widthSize setting may be constraint.",self);
    }
    
#endif
    
    
    
    
    //将要添加到父视图时，如果不是MyLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
    if (newSuperview != nil && ![newSuperview isKindOfClass:[MyBaseLayout class]])
    {

#ifdef DEBUG
        
        if (lsc.leadingPosInner.posRelaVal != nil)
        {
            //约束冲突：左边距依赖的视图不是父视图
            NSCAssert(lsc.leadingPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@leading pos dependent on:%@is not superview",self, lsc.leadingPosInner.posRelaVal.view);
        }
        
        if (lsc.trailingPosInner.posRelaVal != nil)
        {
            //约束冲突：右边距依赖的视图不是父视图
            NSCAssert(lsc.trailingPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@trailing pos dependent on:%@is not superview",self,lsc.trailingPosInner.posRelaVal.view);
        }
        
        if (lsc.centerXPosInner.posRelaVal != nil)
        {
            //约束冲突：水平中心点依赖的视图不是父视图
            NSCAssert(lsc.centerXPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@horizontal center pos dependent on:%@is not superview",self, lsc.centerXPosInner.posRelaVal.view);
        }
        
        if (lsc.topPosInner.posRelaVal != nil)
        {
            //约束冲突：上边距依赖的视图不是父视图
            NSCAssert(lsc.topPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@top pos dependent on:%@is not superview",self, lsc.topPosInner.posRelaVal.view);
        }
        
        if (lsc.bottomPosInner.posRelaVal != nil)
        {
            //约束冲突：下边距依赖的视图不是父视图
            NSCAssert(lsc.bottomPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@bottom pos dependent on:%@is not superview",self, lsc.bottomPosInner.posRelaVal.view);
            
        }
        
        if (lsc.centerYPosInner.posRelaVal != nil)
        {
            //约束冲突：垂直中心点依赖的视图不是父视图
            NSCAssert(lsc.centerYPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! vertical center pos dependent on:%@is not superview",lsc.centerYPosInner.posRelaVal.view);
        }
        
        if (lsc.widthSizeInner.dimeRelaVal != nil)
        {
            //约束冲突：宽度依赖的视图不是父视图
            NSCAssert(lsc.widthSizeInner.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@width dependent on:%@is not superview",self, lsc.widthSizeInner.dimeRelaVal.view);
        }
        
        if (lsc.heightSizeInner.dimeRelaVal != nil)
        {
            //约束冲突：高度依赖的视图不是父视图
            NSCAssert(lsc.heightSizeInner.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@height dependent on:%@is not superview",self,lsc.heightSizeInner.dimeRelaVal.view);
        }
        
#endif

        if ([self myUpdateLayoutRectInNoLayoutSuperview:newSuperview])
        {
            //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃
            
            //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
            //然后在左边将异常断点清除即可
            
            if (_isAddSuperviewKVO && self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]])
            {
                @try {
                    [self.superview removeObserver:self forKeyPath:@"frame"];
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                @try {
                    [self.superview removeObserver:self forKeyPath:@"bounds"];
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                
            }
            
            [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_myObserverContextC];
            [newSuperview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_myObserverContextC];
            _isAddSuperviewKVO = YES;
        }
        
    }
    
    if (_isAddSuperviewKVO && newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]])
    {
        
        //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
        //然后在左边将异常断点清除即可
        
        _isAddSuperviewKVO = NO;
        @try {
            [self.superview removeObserver:self forKeyPath:@"frame"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        @try {
            [self.superview removeObserver:self forKeyPath:@"bounds"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    }
    
    
    if (newSuperview != nil)
    {
        //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
        if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
        {
            if (self.adjustScrollViewContentSizeMode == MyAdjustScrollViewContentSizeModeAuto)
            {
                self.adjustScrollViewContentSizeMode = MyAdjustScrollViewContentSizeModeYes;
            }
        }
    }
    else
    {
        self.beginLayoutBlock = nil;
        self.endLayoutBlock = nil;
    }
    
    
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.superview != nil && ![self.superview isKindOfClass:[MyBaseLayout class]])
        [self myUpdateLayoutRectInNoLayoutSuperview:self.superview];
}

-(void)layoutSubviews
{
    
    if (!self.autoresizesSubviews)
        return;
    
    if (self.beginLayoutBlock != nil)
        self.beginLayoutBlock();
    self.beginLayoutBlock = nil;

    int  currentScreenOrientation = 0;
    
    
    if (!self.isMyLayouting)
    {

        _isMyLayouting = YES;

        if (self.priorAutoresizingMask)
            [super layoutSubviews];
        
        //减少每次调用就计算设备方向以及sizeclass的次数。
        MySizeClass sizeClass = [self myGetGlobalSizeClass];
        if ((sizeClass & 0xF0) == MySizeClass_Portrait)
            currentScreenOrientation = 1;
        else if ((sizeClass & 0xF0) == MySizeClass_Landscape)
            currentScreenOrientation = 2;
        
        MyFrame *selfMyFrame = self.myFrame;
        if (selfMyFrame.multiple)
            selfMyFrame.sizeClass = [self myBestSizeClass:sizeClass];
        for (UIView *sbv in self.subviews)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            if (sbvmyFrame.multiple)
                sbv.myFrame.sizeClass = [sbv myBestSizeClass:sizeClass];
            
            if (!sbvmyFrame.hasObserver && sbvmyFrame.sizeClass != nil && !sbvmyFrame.sizeClass.useFrame)
            {
                [self myAddSubviewObserver:sbv sbvmyFrame:sbvmyFrame];
            }
        }
     
        MyBaseLayout *lsc = (MyBaseLayout*)selfMyFrame.sizeClass;


        //计算布局
        CGSize oldSelfSize = self.bounds.size;
        CGSize newSelfSize;
        if (_useCacheRects && selfMyFrame.width != CGFLOAT_MAX && selfMyFrame.height != CGFLOAT_MAX)
        {
            newSelfSize = CGSizeMake(selfMyFrame.width, selfMyFrame.height);
        }
        else
        {
            newSelfSize = [self calcLayoutRect:[self myCalcSizeInNoLayoutSuperview:self.superview currentSize:oldSelfSize] isEstimate:NO pHasSubLayout:nil sizeClass:sizeClass sbs:nil];
        }
        _useCacheRects = NO;

        //设置子视图的frame并还原
        for (UIView *sbv in self.subviews)
        {
            CGPoint ptorigin = sbv.bounds.origin;

            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
            
            if (sbvmyFrame.leading != CGFLOAT_MAX && sbvmyFrame.top != CGFLOAT_MAX && !sbvsc.noLayout && !sbvsc.useFrame)
            {
                if (sbvmyFrame.width < 0)
                {
                    sbvmyFrame.width = 0;
                }
                if (sbvmyFrame.height < 0)
                {
                    sbvmyFrame.height = 0;
                }
                
                //这里的位置需要进行有效像素的舍入处理，否则可能出现文本框模糊，以及视图显示可能多出一条黑线的问题。
                CGRect rc = sbvmyFrame.frame;
                if (![sbv isKindOfClass:[MyBaseLayout class]])
                {
                    rc = _myRoundRect(rc);
                }
                
                if (CGAffineTransformIsIdentity(sbv.transform))
                {
                    sbv.frame = rc;
                }
                else
                {
                    sbv.center = CGPointMake(rc.origin.x + sbv.layer.anchorPoint.x * rc.size.width, rc.origin.y + sbv.layer.anchorPoint.y * rc.size.height);
                    sbv.bounds = CGRectMake(ptorigin.x, ptorigin.y, rc.size.width, rc.size.height);
                }

            }
            
            if (sbvsc.myVisibility == MyVisibility_Gone && !sbv.isHidden)
            {
                sbv.bounds = CGRectMake(ptorigin.x, ptorigin.y, 0, 0);
            }
            
            if (sbvmyFrame.sizeClass.viewLayoutCompleteBlock != nil)
            {
                sbvmyFrame.sizeClass.viewLayoutCompleteBlock(self, sbv);
                sbvmyFrame.sizeClass.viewLayoutCompleteBlock = nil;
            }
            
            
            if (sbvmyFrame.multiple)
                sbvmyFrame.sizeClass = [sbv myDefaultSizeClass];
            [sbvmyFrame reset];
        }
        
        //调整自身
        if (!CGSizeEqualToSize(oldSelfSize,newSelfSize) && newSelfSize.width != CGFLOAT_MAX)
        {
            //如果父视图也是布局视图，并且自己隐藏则不调整自身的尺寸和位置。
            BOOL isAdjustSelf = YES;
            if (self.superview != nil && [self.superview isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *supl = (MyBaseLayout*)self.superview;
                if ([supl myIsNoLayoutSubview:self])
                    isAdjustSelf = NO;
            }
            if (isAdjustSelf)
            {
                
                if (newSelfSize.width < 0)
                {
                    newSelfSize.width = 0;
                }
                
                if (newSelfSize.height < 0)
                {
                    newSelfSize.height = 0;
                }
                
                if (CGAffineTransformIsIdentity(self.transform))
                {
                    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSelfSize.width, newSelfSize.height);
                }
                else
                {
                    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, newSelfSize.width, newSelfSize.height);
                    self.center = CGPointMake(self.center.x + (newSelfSize.width - oldSelfSize.width) * self.layer.anchorPoint.x, self.center.y + (newSelfSize.height - oldSelfSize.height) * self.layer.anchorPoint.y);
                }
            }
        }
        
        [_borderlineLayerDelegate setNeedsLayout];
                
        //这里只用width判断的原因是如果newSelfSize被计算成功则size中的所有值都不是CGFLOAT_MAX，所以这里选width只是其中一个代表。
        if (newSelfSize.width != CGFLOAT_MAX)
        {
            UIView *supv = self.superview;

            //如果自己的父视图是非UIScrollView以及非布局视图。以及自己是wrapContentWidth或者wrapContentHeight时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
            if (supv != nil && ![supv isKindOfClass:[MyBaseLayout class]] && ![supv isKindOfClass:[UIScrollView class]])
            {
                if (lsc.wrapContentWidth || lsc.wrapContentHeight)
                {
                    CGRect rectSuper = supv.bounds;
                    CGRect rectSelf = self.bounds;
                    CGPoint centerPonintSelf = self.center;
                    
                    if ([MyBaseLayout isRTL])
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                    
                    if (lsc.wrapContentWidth)
                    {
                        //如果只设置了右边，或者只设置了居中则更新位置。。
                        if (lsc.centerXPosInner.posVal != nil)
                        {
                            centerPonintSelf.x = (rectSuper.size.width - rectSelf.size.width)/2 + self.layer.anchorPoint.x * rectSelf.size.width;
                            
                            centerPonintSelf.x += [lsc.centerXPosInner realPosIn:rectSuper.size.width];
                        }
                        else if (lsc.trailingPosInner.posVal != nil && lsc.leadingPosInner.posVal == nil)
                        {
                            centerPonintSelf.x  = rectSuper.size.width - rectSelf.size.width - [lsc.trailingPosInner realPosIn:rectSuper.size.width] + self.layer.anchorPoint.x * rectSelf.size.width;
                        }
                        
                    }
                    
                    if (lsc.wrapContentHeight)
                    {
                        if (lsc.centerYPosInner.posVal != nil)
                        {
                            centerPonintSelf.y = (rectSuper.size.height - rectSelf.size.height)/2 + [lsc.centerYPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                        else if (lsc.bottomPosInner.posVal != nil && lsc.topPosInner.posVal == nil)
                        {
                            centerPonintSelf.y  = rectSuper.size.height - rectSelf.size.height - [lsc.bottomPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                    }
                    
                    if ([MyBaseLayout isRTL])
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                    
                    //如果有变化则只调整自己的center。而不变化
                    if (!CGPointEqualToPoint(self.center, centerPonintSelf))
                    {
                        self.center = centerPonintSelf;
                    }
                }
                
            }
            
            
            //这里处理当布局视图的父视图是非布局父视图，且父视图具有wrap属性时需要调整父视图的尺寸。
            if (supv != nil && ![supv isKindOfClass:[MyBaseLayout class]])
            {
                if (supv.wrapContentHeight || supv.wrapContentWidth)
                {
                    //调整父视图的高度和宽度。frame值。
                    CGRect superBounds = supv.bounds;
                    CGPoint superCenter = supv.center;
                    
                    if (supv.wrapContentHeight)
                    {
                        superBounds.size.height = lsc.myTop + newSelfSize.height + lsc.myBottom;
                        superCenter.y += (superBounds.size.height - supv.bounds.size.height) * supv.layer.anchorPoint.y;
                    }
                    
                    if (supv.wrapContentWidth)
                    {
                        superBounds.size.width = lsc.myLeading + newSelfSize.width + lsc.myTrailing;
                        superCenter.x += (superBounds.size.width - supv.bounds.size.width) * supv.layer.anchorPoint.x;
                    }
                    
                    if (!CGRectEqualToRect(supv.bounds, superBounds))
                    {
                        supv.center = superCenter;
                        supv.bounds = superBounds;
                    }
                    
                }
            }
            
            //处理父视图是滚动视图时动态调整滚动视图的contentSize
            [self myAlterScrollViewContentSize:newSelfSize lsc:lsc];
        }
       

        if (selfMyFrame.multiple)
            selfMyFrame.sizeClass = [self myDefaultSizeClass];
        _isMyLayouting = NO;
        
    }
    
    if (self.endLayoutBlock != nil)
        self.endLayoutBlock();
    self.endLayoutBlock = nil;

    //执行屏幕旋转的处理逻辑。
    if (currentScreenOrientation != 0 && self.rotationToDeviceOrientationBlock != nil)
    {
        if (_lastScreenOrientation == 0)
        {
            _lastScreenOrientation = currentScreenOrientation;
            self.rotationToDeviceOrientationBlock(self,YES, currentScreenOrientation == 1);
        }
        else
        {
            if (_lastScreenOrientation != currentScreenOrientation)
            {
                _lastScreenOrientation = currentScreenOrientation;
                self.rotationToDeviceOrientationBlock(self, NO, currentScreenOrientation == 1);
            }
        }
        
        _lastScreenOrientation = currentScreenOrientation;
    }
    

}


#pragma mark -- Deprecated Method


#pragma mark -- Private Method



-(BOOL)myIsRelativePos:(CGFloat)margin
{
    return margin > 0 && margin < 1;
}


-(MyGravity)myGetSubviewVertGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc vertGravity:(MyGravity)vertGravity
{
    MyGravity sbvVertAligement = sbvsc.myAlignment & MyGravity_Horz_Mask;
    MyGravity sbvVertGravity = MyGravity_Vert_Top;
    
    if (vertGravity != MyGravity_None)
    {
        sbvVertGravity = vertGravity;
        if (sbvVertAligement != MyGravity_None)
        {
            sbvVertGravity = sbvVertAligement;
        }
    }
    else
    {
        
        if (sbvVertAligement != MyGravity_None)
        {
            sbvVertGravity = sbvVertAligement;
        }
        
        if (sbvsc.centerYPosInner.posVal != nil)
        {
            sbvVertGravity = MyGravity_Vert_Center;
        }
        else if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        {
            sbvVertGravity = MyGravity_Vert_Fill;
        }
        else if (sbvsc.topPosInner.posVal != nil)
        {
            sbvVertGravity = MyGravity_Vert_Top;
        }
        else if (sbvsc.bottomPosInner.posVal != nil)
        {
            sbvVertGravity = MyGravity_Vert_Bottom;
        }
    }
    
    return sbvVertGravity;
}


-(void)myCalcVertGravity:(MyGravity)vertGravity
               sbv:(UIView *)sbv
               sbvsc:(UIView*)sbvsc
      paddingTop:(CGFloat)paddingTop
     paddingBottom:(CGFloat)paddingBottom
            selfSize:(CGSize)selfSize
               pRect:(CGRect*)pRect
{
    
    
   CGFloat  topMargin =  [self myValidMargin:sbvsc.topPosInner sbv:sbv calcPos:[sbvsc.topPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];
    
   CGFloat  centerMargin = [self myValidMargin:sbvsc.centerYPosInner sbv:sbv calcPos:[sbvsc.centerYPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];
    
   CGFloat  bottomMargin = [self myValidMargin:sbvsc.bottomPosInner sbv:sbv calcPos:[sbvsc.bottomPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];

    
    if (vertGravity == MyGravity_Vert_Top)
    {
        pRect->origin.y = paddingTop + topMargin;
    }
    else if (vertGravity == MyGravity_Vert_Bottom)
    {
        pRect->origin.y = selfSize.height - paddingBottom - bottomMargin - pRect->size.height;
    }
    if (vertGravity == MyGravity_Vert_Fill)
    {
        pRect->origin.y = paddingTop + topMargin;
        pRect->size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:selfSize.height - paddingTop - paddingBottom - topMargin - bottomMargin  sbvSize:pRect->size selfLayoutSize:selfSize];
    }
    else if (vertGravity == MyGravity_Vert_Center)
    {
        pRect->origin.y = (selfSize.height - paddingTop - paddingBottom - topMargin - bottomMargin - pRect->size.height)/2 + paddingTop + topMargin + centerMargin;
    }
    else if (vertGravity == MyGravity_Vert_Window_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.y = (CGRectGetHeight(self.window.bounds) - topMargin - bottomMargin - pRect->size.height)/2 + topMargin + centerMargin;
            pRect->origin.y =  [self.window convertPoint:pRect->origin toView:self].y;
        }
    }
    else
    {
        ;
    }
    
    
}


-(MyGravity)myGetSubviewHorzGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc horzGravity:(MyGravity)horzGravity
{
    MyGravity sbvHorzAligement = [self myConvertLeftRightGravityToLeadingTrailing:sbvsc.myAlignment & MyGravity_Vert_Mask];
    MyGravity sbvHorzGravity = MyGravity_Horz_Leading;
    
    if (horzGravity != MyGravity_None)
    {
        sbvHorzGravity = horzGravity;
        if (sbvHorzAligement != MyGravity_None)
        {
            sbvHorzGravity = sbvHorzAligement;
        }
    }
    else
    {
        
        if (sbvHorzAligement != MyGravity_None)
        {
            sbvHorzGravity = sbvHorzAligement;
        }
        
        if (sbvsc.centerXPosInner.posVal != nil)
        {
            sbvHorzGravity = MyGravity_Horz_Center;
        }
        else if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        {
            sbvHorzGravity = MyGravity_Horz_Fill;
        }
        else if (sbvsc.leadingPosInner.posVal != nil)
        {
            sbvHorzGravity = MyGravity_Horz_Leading;
        }
        else if (sbvsc.trailingPosInner.posVal != nil)
        {
            sbvHorzGravity = MyGravity_Horz_Trailing;
        }
    }
    
    return sbvHorzGravity;
}


-(void)myCalcHorzGravity:(MyGravity)horzGravity
               sbv:(UIView *)sbv
               sbvsc:(UIView*)sbvsc
      paddingLeading:(CGFloat)paddingLeading
     paddingTrailing:(CGFloat)paddingTrailing
            selfSize:(CGSize)selfSize
               pRect:(CGRect*)pRect
{
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    
    CGFloat leadingMargin = [self myValidMargin:sbvsc.leadingPosInner sbv:sbv calcPos:[sbvsc.leadingPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];
    
    CGFloat centerMargin = [self myValidMargin:sbvsc.centerXPosInner sbv:sbv calcPos:[sbvsc.centerXPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];
    
   CGFloat  trailingMargin = [self myValidMargin:sbvsc.trailingPosInner sbv:sbv calcPos:[sbvsc.trailingPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];

    
    if (horzGravity == MyGravity_Horz_Leading)
    {
        pRect->origin.x = paddingLeading + leadingMargin;
    }
    else if (horzGravity == MyGravity_Horz_Trailing)
    {
        pRect->origin.x = selfSize.width - paddingTrailing - trailingMargin - pRect->size.width;
    }
    if (horzGravity == MyGravity_Horz_Fill)
    {
        
        pRect->origin.x = paddingLeading + leadingMargin;
        pRect->size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:selfSize.width - paddingHorz - leadingMargin -  trailingMargin sbvSize:pRect->size selfLayoutSize:selfSize];

    }
    else if (horzGravity == MyGravity_Horz_Center)
    {
        pRect->origin.x = (selfSize.width - paddingHorz - leadingMargin -  trailingMargin - pRect->size.width)/2 + paddingLeading + leadingMargin + centerMargin;
    }
    else if (horzGravity == MyGravity_Horz_Window_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.x = (CGRectGetWidth(self.window.bounds) - leadingMargin - trailingMargin - pRect->size.width)/2 + leadingMargin +  centerMargin;
            pRect->origin.x =  [self.window convertPoint:pRect->origin toView:self].x;
            
            //因为从右到左布局最后统一进行了转换，但是窗口居中是不按布局来控制的，所以这里为了保持不变需要进行特殊处理。
            if ([MyBaseLayout isRTL])
            {
                pRect->origin.x = selfSize.width - pRect->origin.x - pRect->size.width;
            }
        }

    }
    else
    {
        ;
    }
}


-(void)myCalcSizeOfWrapContentSubview:(UIView*)sbv sbvsc:(UIView*)sbvsc sbvmyFrame:(MyFrame*)sbvmyFrame selfLayoutSize:(CGSize)selfLayoutSize
{
    BOOL isLayoutView = [sbv isKindOfClass:[MyBaseLayout class]];
    BOOL isWrapWidth = (sbvsc.widthSizeInner.dimeSelfVal != nil) || (!isLayoutView && sbvsc.wrapContentWidth); //宽度包裹特殊处理
    BOOL isWrapHeight = (sbvsc.heightSizeInner.dimeSelfVal != nil) || (!isLayoutView && sbvsc.wrapContentSize);//高度包裹也特殊处理
    
    
    if (isWrapWidth || isWrapHeight)
    {
        CGSize fitSize = [sbv sizeThatFits:CGSizeZero];
        if (isWrapWidth)
        {
            if (sbvsc.wrapContentWidth)
                sbvmyFrame.width = fitSize.width;
            else
                sbvmyFrame.width = [sbvsc.widthSizeInner measureWith:fitSize.width];
        }
        
        if (isWrapHeight)
        {
            if (sbvsc.wrapContentHeight)
                sbvmyFrame.height = fitSize.height;
            else
                sbvmyFrame.height = [sbvsc.heightSizeInner measureWith:fitSize.height];
        }
    }
}


-(CGSize)myCalcSizeInNoLayoutSuperview:(UIView*)newSuperview currentSize:(CGSize)size
{
    if (newSuperview == nil || [newSuperview isKindOfClass:[MyBaseLayout class]])
        return size;
    
    CGRect rectSuper = newSuperview.bounds;
    UIView *ssc = newSuperview.myCurrentSizeClass;
    UIView *lsc = self.myCurrentSizeClass;
    
    if (!ssc.wrapContentWidth)
    {
        if (lsc.widthSizeInner.dimeRelaVal.view == newSuperview)
        {
            size.width = [lsc.widthSizeInner measureWith:rectSuper.size.width];
            size.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:size.width sbvSize:size selfLayoutSize:rectSuper.size];
        }
        
        if (lsc.leadingPosInner.posVal != nil && lsc.trailingPosInner.posVal != nil)
        {
            CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
            CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
            size.width = rectSuper.size.width - leadingMargin - trailingMargin;
            size.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:size.width sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (size.width < 0)
        {
            size.width = 0;
        }
    }

    if (!ssc.wrapContentHeight)
    {
        if (lsc.heightSizeInner.dimeRelaVal.view == newSuperview)
        {
            
            size.height = [lsc.heightSizeInner measureWith:rectSuper.size.height];
            size.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:size.height sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (lsc.topPosInner.posVal != nil && lsc.bottomPosInner.posVal != nil)
        {
            CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
            CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];
            size.height = rectSuper.size.height - topMargin - bottomMargin;
            size.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:size.height sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (size.height < 0)
        {
            size.height = 0;
        }

    }
    
    
    return size;
}

-(BOOL)myUpdateLayoutRectInNoLayoutSuperview:(UIView*)newSuperview
{
    BOOL isAdjust = NO;
    
    CGRect rectSuper = newSuperview.bounds;
    
    UIView *lsc = self.myCurrentSizeClass;
    
    CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
    CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
    CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
    CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];
    CGRect rectSelf = self.bounds;
    
    //得到在设置center后的原始值。
    rectSelf.origin.y = self.center.y - rectSelf.size.height * self.layer.anchorPoint.y;
    rectSelf.origin.x = self.center.x - rectSelf.size.width * self.layer.anchorPoint.x;
    CGRect oldRectSelf = rectSelf;
    
    //确定左右边距和宽度。
    if (lsc.widthSizeInner.dimeVal != nil)
    {
        lsc.wrapContentWidth = NO;
        
        if (lsc.widthSizeInner.dimeRelaVal != nil)
        {
            if (lsc.widthSizeInner.dimeRelaVal.view == newSuperview)
            {
                rectSelf.size.width = [lsc.widthSizeInner measureWith:rectSuper.size.width];
            }
            else
            {
                rectSelf.size.width = [lsc.widthSizeInner measureWith:lsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
            }
            isAdjust = YES;
        }
        else
            rectSelf.size.width = lsc.widthSizeInner.measure;
        
     }
    
    rectSelf.size.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
    
    if ([MyBaseLayout isRTL])
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;

    
    if (lsc.leadingPosInner.posVal != nil && lsc.trailingPosInner.posVal != nil)
    {
        isAdjust = YES;
        lsc.wrapContentWidth = NO;
        rectSelf.size.width = rectSuper.size.width - leadingMargin - trailingMargin;
        rectSelf.size.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
        
        rectSelf.origin.x = leadingMargin;
    }
    else if (lsc.centerXPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x = (rectSuper.size.width - rectSelf.size.width)/2;
        rectSelf.origin.x += [lsc.centerXPosInner realPosIn:rectSuper.size.width];
    }
    else if (lsc.leadingPosInner.posVal != nil)
    {
        rectSelf.origin.x = leadingMargin;
    }
    else if (lsc.trailingPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x  = rectSuper.size.width - rectSelf.size.width - trailingMargin;
    }
    else;
    
    
    if (lsc.heightSizeInner.dimeVal != nil)
    {
        lsc.wrapContentHeight = NO;
        
        if (lsc.heightSizeInner.dimeRelaVal != nil)
        {
            if (lsc.heightSizeInner.dimeRelaVal.view == newSuperview)
            {
                rectSelf.size.height = [lsc.heightSizeInner measureWith:rectSuper.size.height];
            }
            else
            {
                rectSelf.size.height = [lsc.heightSizeInner measureWith:lsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
            }
            isAdjust = YES;
        }
        else
            rectSelf.size.height = lsc.heightSizeInner.measure;
    }
    
    rectSelf.size.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
    
    if (lsc.topPosInner.posVal != nil && lsc.bottomPosInner.posVal != nil)
    {
        isAdjust = YES;
        lsc.wrapContentHeight = NO;
        rectSelf.size.height = rectSuper.size.height - topMargin - bottomMargin;
        rectSelf.size.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
        
        rectSelf.origin.y = topMargin;
    }
    else if (lsc.centerYPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y = (rectSuper.size.height - rectSelf.size.height)/2 + [lsc.centerYPosInner realPosIn:rectSuper.size.height];
    }
    else if (lsc.topPosInner.posVal != nil)
    {
        rectSelf.origin.y = topMargin;
    }
    else if (lsc.bottomPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y  = rectSuper.size.height - rectSelf.size.height - bottomMargin;
    }
    else;
    
    if ([MyBaseLayout isRTL])
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;
    
    if (!CGRectEqualToRect(rectSelf, oldRectSelf))
    {
        if (rectSelf.size.width < 0)
        {
            rectSelf.size.width = 0;
        }
        if (rectSelf.size.height < 0)
        {
            rectSelf.size.height = 0;
        }
        
        if (CGAffineTransformIsIdentity(self.transform))
        {
            self.frame = rectSelf;
        }
        else
        {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,rectSelf.size.width, rectSelf.size.height);
            self.center = CGPointMake(rectSelf.origin.x + self.layer.anchorPoint.x * rectSelf.size.width, rectSelf.origin.y + self.layer.anchorPoint.y * rectSelf.size.height);
        }
    }
    else if (lsc.wrapContentWidth || lsc.wrapContentHeight)
    {
        [self setNeedsLayout];
    }
    
    
    
    return isAdjust;

}

-(CGFloat)myHeightFromFlexedHeightView:(UIView*)sbv sbvsc:(UIView*)sbvsc inWidth:(CGFloat)width
{
    CGFloat h = [sbv sizeThatFits:CGSizeMake(width, 0)].height;
    if ([sbv isKindOfClass:[UIImageView class]])
    {
        //根据图片的尺寸进行等比缩放得到合适的高度。
        UIImage *img = ((UIImageView*)sbv).image;
        if (img != nil && img.size.width != 0)
        {
            h = img.size.height * (width / img.size.width);
        }
    }
    else if ([sbv isKindOfClass:[UIButton class]])
    {
        //按钮特殊处理多行的。。
        UIButton *button = (UIButton*)sbv;
        
        if (button.titleLabel != nil)
        {
            //得到按钮本身的高度，以及单行文本的高度，这样就能算出按钮和文本的间距
            CGSize buttonSize = [button sizeThatFits:CGSizeMake(0, 0)];
            CGSize buttonTitleSize = [button.titleLabel sizeThatFits:CGSizeMake(0, 0)];
            CGSize sz = [button.titleLabel sizeThatFits:CGSizeMake(width, 0)];
            h = sz.height + buttonSize.height - buttonTitleSize.height; //这个sz只是纯文本的高度，所以要加上原先按钮和文本的高度差。。
        }
    }
    else
        ;
    
    if (sbvsc.heightSizeInner == nil)
        return h;
    else
        return [sbvsc.heightSizeInner measureWith:h];
}


-(CGFloat)myGetBoundLimitMeasure:(MyLayoutSize*)boundDime sbv:(UIView*)sbv dimeType:(MyGravity)dimeType sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound
{
    CGFloat value = isUBound ? CGFLOAT_MAX : -CGFLOAT_MAX;
    if (boundDime == nil)
        return value;
    
    MyLayoutValueType lValueType = boundDime.dimeValType;
    if (lValueType == MyLayoutValueType_NSNumber)
    {
        value = boundDime.dimeNumVal.doubleValue;
    }
    else if (lValueType == MyLayoutValueType_LayoutDime)
    {
        if (boundDime.dimeRelaVal.view == self)
        {
            if (boundDime.dimeRelaVal.dime == MyGravity_Horz_Fill)
                value = selfLayoutSize.width - (boundDime.dimeRelaVal.view == self ? (self.leadingPadding + self.trailingPadding) : 0);
            else
                value = selfLayoutSize.height - (boundDime.dimeRelaVal.view == self ? (self.topPadding + self.bottomPadding) :0);
        }
        else if (boundDime.dimeRelaVal.view == sbv)
        {
            if (boundDime.dimeRelaVal.dime == dimeType)
            {
                //约束冲突：无效的边界设置方法
                NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
            }
            else
            {
                if (boundDime.dimeRelaVal.dime == MyGravity_Horz_Fill)
                    value = sbvSize.width;
                else
                    value = sbvSize.height;
            }
        }
        else if (boundDime.dimeSelfVal != nil)
        {
            if (dimeType == MyGravity_Horz_Fill)
                value = sbvSize.width;
            else
                value = sbvSize.height;
        }
        else
        {
            if (boundDime.dimeRelaVal.dime == MyGravity_Horz_Fill)
            {
                value = boundDime.dimeRelaVal.view.estimatedRect.size.width;
            }
            else
            {
                value = boundDime.dimeRelaVal.view.estimatedRect.size.height;
            }
        }
        
    }
    else
    {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
    }
    
    if (value == CGFLOAT_MAX || value == -CGFLOAT_MAX)
        return value;
    
    return  [boundDime measureWith:value];

}



-(CGFloat)myValidMeasure:(MyLayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize
{
    if (dime == nil)
        return calcSize;
    
    //算出最大最小值。
    CGFloat min = dime.isActive? [self myGetBoundLimitMeasure:dime.lBoundValInner sbv:sbv dimeType:dime.dime sbvSize:sbvSize selfLayoutSize:selfLayoutSize isUBound:NO] : -CGFLOAT_MAX;
    CGFloat max = dime.isActive ?  [self myGetBoundLimitMeasure:dime.uBoundValInner sbv:sbv dimeType:dime.dime sbvSize:sbvSize selfLayoutSize:selfLayoutSize isUBound:YES] : CGFLOAT_MAX;
    
    calcSize = MAX(min, calcSize);
    calcSize = MIN(max, calcSize);
    
    return calcSize;
}


-(CGFloat)myGetBoundLimitMargin:(MyLayoutPos*)boundPos sbv:(UIView*)sbv selfLayoutSize:(CGSize)selfLayoutSize
{
    CGFloat value = 0;
    if (boundPos == nil)
        return value;
    
    MyLayoutValueType lValueType = boundPos.posValType;
    if (lValueType == MyLayoutValueType_NSNumber)
        value = boundPos.posNumVal.doubleValue;
    else if (lValueType == MyLayoutValueType_LayoutPos)
    {
        CGRect rect = boundPos.posRelaVal.view.myFrame.frame;
        
        MyGravity pos = boundPos.posRelaVal.pos;
        if (pos == MyGravity_Horz_Leading)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMinX(rect);
        }
        else if (pos == MyGravity_Horz_Center)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMidX(rect);
        }
        else if (pos == MyGravity_Horz_Trailing)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMaxX(rect);
        }
        else if (pos == MyGravity_Vert_Top)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMinY(rect);
        }
        else if (pos == MyGravity_Vert_Center)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMidY(rect);
        }
        else if (pos == MyGravity_Vert_Bottom)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMaxY(rect);
        }
    }
    else
    {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
    }
    
    return value + boundPos.offsetVal;
}


-(CGFloat)myValidMargin:(MyLayoutPos*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize
{
    if (pos == nil)
        return calcPos;
    
    //算出最大最小值
    CGFloat min = (pos.isActive && pos.lBoundValInner != nil) ? [self myGetBoundLimitMargin:pos.lBoundValInner sbv:sbv selfLayoutSize:selfLayoutSize] : -CGFLOAT_MAX;
    CGFloat max = (pos.isActive && pos.uBoundValInner != nil) ? [self myGetBoundLimitMargin:pos.uBoundValInner sbv:sbv selfLayoutSize:selfLayoutSize] : CGFLOAT_MAX;
    
    calcPos = MAX(min, calcPos);
    calcPos = MIN(max, calcPos);
    return calcPos;
}

-(BOOL)myIsNoLayoutSubview:(UIView*)sbv
{
    UIView *sbvsc = sbv.myCurrentSizeClass;
    
    if (sbvsc.useFrame)
        return YES;
    
    if (sbv.isHidden)
    {
        return sbvsc.myVisibility != MyVisibility_Invisible;
    }
    else
    {
        return sbvsc.myVisibility == MyVisibility_Gone;
    }
    
}

-(NSMutableArray*)myGetLayoutSubviews
{
    return [self myGetLayoutSubviewsFrom:self.subviews];
}

-(NSMutableArray*)myGetLayoutSubviewsFrom:(NSArray*)sbsFrom
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:sbsFrom.count];
    BOOL isReverseLayout = self.reverseLayout;
    
    if (isReverseLayout)
    {
        [sbs addObjectsFromArray:[sbsFrom reverseObjectEnumerator].allObjects];
    }
    else
    {
        [sbs addObjectsFromArray:sbsFrom];
        
    }
    
    for (NSInteger i = sbs.count - 1; i >=0; i--)
    {
        UIView *sbv = sbs[i];
        if ([self myIsNoLayoutSubview:sbv])
        {
            [sbs removeObjectAtIndex:i];
        }
    }
    
    return sbs;

}

-(void)mySetSubviewRelativeDimeSize:(MyLayoutSize*)dime selfSize:(CGSize)selfSize lsc:(MyBaseLayout*)lsc pRect:(CGRect*)pRect
{
    if (dime.dimeRelaVal == nil)
        return;
    
    if (dime.dime == MyGravity_Horz_Fill)
    {
        
        if (dime.dimeRelaVal == lsc.widthSizeInner && !lsc.wrapContentWidth)
            pRect->size.width = [dime measureWith:(selfSize.width - lsc.leadingPadding - lsc.trailingPadding)];
        else if (dime.dimeRelaVal == lsc.heightSizeInner)
            pRect->size.width = [dime measureWith:(selfSize.height - lsc.topPadding - lsc.bottomPadding)];
        else if (dime.dimeRelaVal == dime.view.heightSizeInner)
            pRect->size.width = [dime measureWith:pRect->size.height];
        else if (dime.dimeRelaVal.dime == MyGravity_Horz_Fill)
            pRect->size.width = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.width];
        else
            pRect->size.width = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.height];
    }
    else
    {
        if (dime.dimeRelaVal == lsc.heightSizeInner && !lsc.wrapContentHeight)
            pRect->size.height = [dime measureWith:(selfSize.height - lsc.topPadding - lsc.bottomPadding)];
        else if (dime.dimeRelaVal == lsc.widthSizeInner)
            pRect->size.height = [dime measureWith:(selfSize.width - lsc.leadingPadding - lsc.trailingPadding)];
        else if (dime.dimeRelaVal == dime.view.widthSizeInner)
            pRect->size.height = [dime measureWith:pRect->size.width];
        else if (dime.dimeRelaVal.dime == MyGravity_Horz_Fill)
            pRect->size.height = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.width];
        else
            pRect->size.height = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.height];
    }
}

-(CGSize)myAdjustSizeWhenNoSubviews:(CGSize)size sbs:(NSArray *)sbs lsc:(MyBaseLayout*)lsc
{
    //如果没有子视图，并且padding不参与空子视图尺寸计算则尺寸应该扣除padding的值。
    if (sbs.count == 0 && !lsc.zeroPadding)
    {
        if (lsc.wrapContentWidth)
            size.width -= (lsc.leadingPadding + lsc.trailingPadding);
        if (lsc.wrapContentHeight)
            size.height -= (lsc.topPadding + lsc.bottomPadding);
    }
    
    return size;
}

- (void)myAdjustLayoutSelfSize:(CGSize *)pSelfSize lsc:(MyBaseLayout*)lsc
{
    //调整自己的尺寸。
    pSelfSize->height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:pSelfSize->height sbvSize:*pSelfSize selfLayoutSize:self.superview.bounds.size];
    
    pSelfSize->width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:pSelfSize->width sbvSize:*pSelfSize selfLayoutSize:self.superview.bounds.size];
}

-(void)myAdjustSubviewsRTLPos:(NSArray*)sbs selfWidth:(CGFloat)selfWidth
{
    if ([MyBaseLayout isRTL])
    {
        for (UIView *sbv in sbs)
        {
            MyFrame *myFrame = sbv.myFrame;
            
            myFrame.leading = selfWidth - myFrame.leading - myFrame.width;
            myFrame.trailing = myFrame.leading + myFrame.width;
        }
    }
}

-(MyGravity)myConvertLeftRightGravityToLeadingTrailing:(MyGravity)horzGravity
{
    if (horzGravity == MyGravity_Horz_Left)
    {
        if ([MyBaseLayout isRTL])
            return MyGravity_Horz_Trailing;
        else
            return MyGravity_Horz_Leading;
    }
    else if (horzGravity == MyGravity_Horz_Right)
    {
        if ([MyBaseLayout isRTL])
            return MyGravity_Horz_Leading;
        else
            return MyGravity_Horz_Trailing;
    }
    else
        return horzGravity;
    
}



- (void)myAlterScrollViewContentSize:(CGSize)newSize lsc:(MyBaseLayout*)lsc
{
    if (self.adjustScrollViewContentSizeMode == MyAdjustScrollViewContentSizeModeYes && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrolv = (UIScrollView*)self.superview;
        CGSize contsize = scrolv.contentSize;
        CGRect rectSuper = scrolv.bounds;
        
        //这里把自己在父视图中的上下左右边距也算在contentSize的包容范围内。
        CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
        CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
        CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
        CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];
        
        if (contsize.height != newSize.height + topMargin + bottomMargin)
            contsize.height = newSize.height + topMargin + bottomMargin;
        if (contsize.width != newSize.width + leadingMargin + trailingMargin)
            contsize.width = newSize.width + leadingMargin + trailingMargin;
        
        scrolv.contentSize =  contsize;
        
    }
}

MySizeClass _myGlobalSizeClass = 0xFF;

//获取全局的当前的SizeClass,减少获取次数的调用。
-(MySizeClass)myGetGlobalSizeClass
{
    //找到最根部的父视图。
    if (_myGlobalSizeClass == 0xFF || ![self.superview isKindOfClass:[MyBaseLayout class]])
    {
        MySizeClass sizeClass;
        if ([UIDevice currentDevice].systemVersion.floatValue < 8)
            sizeClass = MySizeClass_hAny | MySizeClass_wAny;
        else
            sizeClass = (MySizeClass)((self.traitCollection.verticalSizeClass << 2) | self.traitCollection.horizontalSizeClass);
        
        UIDeviceOrientation ori =   [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsPortrait(ori))
        {
            sizeClass |= MySizeClass_Portrait;
        }
        else if (UIDeviceOrientationIsLandscape(ori))
        {
            sizeClass |= MySizeClass_Landscape;
        }
        else;
        
        _myGlobalSizeClass = sizeClass;
    }
    else
    {
        ;
    }
    
    return _myGlobalSizeClass;
}

-(void)myRemoveSubviewObserver:(UIView*)subview
{
    
    MyFrame *sbvmyFrame = objc_getAssociatedObject(subview, ASSOCIATEDOBJECT_KEY_MYLAYOUT_FRAME);
    if (sbvmyFrame != nil)
    {
        sbvmyFrame.sizeClass.viewLayoutCompleteBlock = nil;
        if (sbvmyFrame.hasObserver)
        {
            [subview removeObserver:self forKeyPath:@"hidden"];
            [subview removeObserver:self forKeyPath:@"frame"];
            
            if ([subview isKindOfClass:[MyBaseLayout class]])
            {
                [subview removeObserver:self forKeyPath:@"center"];
            }
            else if ([subview isKindOfClass:[UILabel class]])
            {
                [subview removeObserver:self forKeyPath:@"text"];
                [subview removeObserver:self forKeyPath:@"attributedText"];
            }
            else;

            sbvmyFrame.hasObserver = NO;
        }
    }
}

-(void)myAddSubviewObserver:(UIView*)subview sbvmyFrame:(MyFrame*)sbvmyFrame
{
    
    if (!sbvmyFrame.hasObserver)
    {
        //添加hidden, frame,center的属性通知。
        [subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        if ([subview isKindOfClass:[MyBaseLayout class]])
        {
            [subview addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:_myObserverContextA];
        }
        else if ([subview isKindOfClass:[UILabel class]])
        {//如果是UILabel则一旦设置了text和attributedText则
            
            [subview addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:_myObserverContextB];
            [subview addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:_myObserverContextB];
        }
        else;

        sbvmyFrame.hasObserver = YES;
        
    }
}



@end

//布局的事件处理委托对象
@implementation MyTouchEventDelegate
{
    __weak MyBaseLayout *_layout;
    __weak id _target;
    SEL   _action;
    
    __weak id _touchDownTarget;
    SEL  _touchDownAction;
    
    __weak id _touchCancelTarget;
    SEL _touchCancelAction;
    BOOL _hasDoCancel;
    
    
    UIColor *_oldBackgroundColor;
    UIImage *_oldBackgroundImage;
    
    CGFloat _oldAlpha;
    
    BOOL _forbidTouch;
    BOOL _canCallAction;
    CGPoint _beginPoint;
    
}

BOOL _hasBegin;

-(instancetype)initWithLayout:(MyBaseLayout *)layout
{
    self = [self init];
    if (self != nil)
    {
        _layout = layout;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    if (_layout != nil && _target != nil && !_forbidTouch && touch.tapCount == 1 && !_hasBegin)
    {
        _hasBegin = YES;
        _canCallAction = YES;
        _beginPoint = [touch locationInView:_layout];
        
        [self mySetTouchHighlighted];
        
        _hasDoCancel = NO;
        [self myPerformTouch:_touchDownTarget withAction:_touchDownAction];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_layout != nil && _target != nil && _hasBegin)
    {
        if (_canCallAction)
        {
            CGPoint pt = [((UITouch*)[touches anyObject]) locationInView:_layout];
            if (fabs(pt.x - _beginPoint.x) > 2 || fabs(pt.y - _beginPoint.y) > 2)
            {
                _canCallAction = NO;
                
                if (!_hasDoCancel)
                {
                    [self myPerformTouch:_touchCancelTarget withAction:_touchCancelAction];
                    
                    _hasDoCancel = YES;
                    
                }
                
            }
        }
    }
}

-(void)doTargetAction:(UITouch*)touch
{
    
    [self myResetTouchHighlighted];
    
    //距离太远则不会处理
    CGPoint pt = [touch locationInView:_layout];
    if (CGRectContainsPoint(_layout.bounds, pt) && _action != nil && _canCallAction)
    {
        [self myPerformTouch:_target withAction:_action];
        
    }
    else
    {
        if (!_hasDoCancel)
        {
            [self myPerformTouch:_touchCancelTarget withAction:_touchCancelAction];
            _hasDoCancel = YES;
        }
        
    }
    
    _forbidTouch = NO;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_layout != nil && _target != nil && _hasBegin)
    {
        //设置一个延时.
        _forbidTouch = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:@selector(doTargetAction:) withObject:[touches anyObject] afterDelay:0.12];
#pragma clang diagnostic pop
        
        _hasBegin = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_layout != nil && _target != nil && _hasBegin)
    {
        [self myResetTouchHighlighted];
        
        _hasBegin = NO;
        
        if (!_hasDoCancel)
        {
            [self myPerformTouch:_touchCancelTarget withAction:_touchCancelAction];
            
            _hasDoCancel = YES;
        }
        
    }
}


///设置触摸时的高亮
-(void)mySetTouchHighlighted
{
    if (_layout.highlightedOpacity != 0)
    {
        _oldAlpha = _layout.alpha;
        _layout.alpha = 1 - _layout.highlightedOpacity;
    }
    
    if (_layout.highlightedBackgroundColor != nil)
    {
        _oldBackgroundColor = _layout.backgroundColor;
        _layout.backgroundColor = _layout.highlightedBackgroundColor;
    }
    
    if (_layout.highlightedBackgroundImage != nil)
    {
        _oldBackgroundImage = _layout.backgroundImage;
        _layout.backgroundImage = _layout.highlightedBackgroundImage;
    }
    
}

//恢复触摸时的高亮。
-(void)myResetTouchHighlighted
{
    if (_layout.highlightedOpacity != 0)
    {
        _layout.alpha = _oldAlpha;
        _oldAlpha = 1;
    }
    
    if (_layout.highlightedBackgroundColor != nil)
    {
        _layout.backgroundColor = _oldBackgroundColor;
        _oldBackgroundColor = nil;
    }
    
    
    if (_layout.highlightedBackgroundImage != nil)
    {
        _layout.backgroundImage = _oldBackgroundImage;
        _oldBackgroundImage = nil;
    }
    
}

-(void)myPerformTouch:(id)target withAction:(SEL)action
{
    if (_layout != nil && target != nil && action != nil)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:action withObject:_layout];
#pragma clang diagnostic pop
        
    }
}

-(void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}


-(void)setTouchDownTarget:(id)target action:(SEL)action
{
    _touchDownTarget = target;
    _touchDownAction = action;
}

-(void)setTouchCancelTarget:(id)target action:(SEL)action
{
    _touchCancelTarget = target;
    _touchCancelAction = action;
    
}


@end



@implementation MyBorderlineLayerDelegate
{
    __weak MyBaseLayout *_layout;
}

-(id)initWithLayout:(MyBaseLayout*)layout
{
    self = [self init];
    if (self != nil)
    {
        _layout = layout;
    }
    
    return self;
}


-(void)setTopBorderline:(MyBorderline *)topBorderline
{
    if (_topBorderline != topBorderline)
    {
        _topBorderline = topBorderline;
        
        CAShapeLayer *borderLayer = _topBorderlineLayer;
        [self myUpdateBorderLayer:&borderLayer withBorderline:_topBorderline];
        _topBorderlineLayer = borderLayer;
        
    }
}

-(void)setLeadingBorderline:(MyBorderline *)leadingBorderline
{
    if (_leadingBorderline != leadingBorderline)
    {
        _leadingBorderline = leadingBorderline;
        
        CAShapeLayer *borderLayer = _leadingBorderlineLayer;
        [self myUpdateBorderLayer:&borderLayer withBorderline:_leadingBorderline];
        _leadingBorderlineLayer = borderLayer;
    }
}

-(void)setBottomBorderline:(MyBorderline *)bottomBorderline
{
    if (_bottomBorderline != bottomBorderline)
    {
        _bottomBorderline = bottomBorderline;
        
        CAShapeLayer *borderLayer = _bottomBorderlineLayer;
        [self myUpdateBorderLayer:&borderLayer withBorderline:_bottomBorderline];
        _bottomBorderlineLayer = borderLayer;
    }
}


-(void)setTrailingBorderline:(MyBorderline *)trailingBorderline
{
    if (_trailingBorderline != trailingBorderline)
    {
        _trailingBorderline = trailingBorderline;
        
        CAShapeLayer *borderLayer = _trailingBorderlineLayer;
        [self myUpdateBorderLayer:&borderLayer withBorderline:_trailingBorderline];
        _trailingBorderlineLayer = borderLayer;
    }
    
}

-(MyBorderline*)leftBorderline
{
    if ([MyBaseLayout isRTL])
        return self.trailingBorderline;
    else
        return self.leadingBorderline;
}

-(void)setLeftBorderline:(MyBorderline *)leftBorderline
{
    if ([MyBaseLayout isRTL])
        self.trailingBorderline = leftBorderline;
    else
        self.leadingBorderline = leftBorderline;
}


-(MyBorderline*)rightBorderline
{
    if ([MyBaseLayout isRTL])
        return self.leadingBorderline;
    else
        return self.trailingBorderline;
}

-(void)setRightBorderline:(MyBorderline *)rightBorderline
{
    if ([MyBaseLayout isRTL])
        self.leadingBorderline = rightBorderline;
    else
        self.trailingBorderline = rightBorderline;
}



-(void)myUpdateBorderLayer:(CAShapeLayer**)ppLayer withBorderline:(MyBorderline*)borderline
{
    
    if (borderline == nil)
    {
        
        if (*ppLayer != nil)
        {
            [(*ppLayer) removeFromSuperlayer];
            (*ppLayer).delegate = nil;
            *ppLayer = nil;
        }
    }
    else
    {
        
        if ( *ppLayer == nil)
        {
            *ppLayer = [[CAShapeLayer alloc] init];
            (*ppLayer).delegate = self;
            [_layout.layer addSublayer:*ppLayer];
        }
        
        //如果是点线则是用path，否则就用背景色
        if (borderline.dash != 0)
        {
            (*ppLayer).lineDashPhase = borderline.dash / 2;
            NSNumber *num = @(borderline.dash);
            (*ppLayer).lineDashPattern = @[num,num];
            
            (*ppLayer).strokeColor = borderline.color.CGColor;
            (*ppLayer).lineWidth = borderline.thick;
            (*ppLayer).backgroundColor = nil;
            
        }
        else
        {
            (*ppLayer).lineDashPhase = 0;
            (*ppLayer).lineDashPattern = nil;
            
            (*ppLayer).strokeColor = nil;
            (*ppLayer).lineWidth = 0;
            (*ppLayer).backgroundColor = borderline.color.CGColor;
            
        }
        
        [(*ppLayer) setNeedsLayout];
        
    }
}


-(void)layoutSublayersOfLayer:(CAShapeLayer *)layer
{
    if (_layout == nil)
        return;
    
    CGSize layoutSize = _layout.layer.bounds.size;
    
    if (layoutSize.width == 0 || layoutSize.height == 0)
        return;
    
    CGRect layerRect;
    CGPoint fromPoint;
    CGPoint toPoint;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (layer == self.leadingBorderlineLayer)
    {
        layerRect = CGRectMake(self.leadingBorderline.offset, self.leadingBorderline.headIndent, self.leadingBorderline.thick/scale, layoutSize.height - self.leadingBorderline.headIndent - self.leadingBorderline.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);
        
    }
    else if (layer == self.trailingBorderlineLayer)
    {
        layerRect = CGRectMake(layoutSize.width - self.trailingBorderline.thick / scale - self.trailingBorderline.offset, self.trailingBorderline.headIndent, self.trailingBorderline.thick / scale, layoutSize.height - self.trailingBorderline.headIndent - self.trailingBorderline.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);
        
    }
    else if (layer == self.topBorderlineLayer)
    {
        layerRect = CGRectMake(self.topBorderline.headIndent, self.topBorderline.offset, layoutSize.width - self.topBorderline.headIndent - self.topBorderline.tailIndent, self.topBorderline.thick/scale);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
    }
    else if (layer == self.bottomBorderlineLayer)
    {
        layerRect = CGRectMake(self.bottomBorderline.headIndent, layoutSize.height - self.bottomBorderline.thick / scale - self.bottomBorderline.offset, layoutSize.width - self.bottomBorderline.headIndent - self.bottomBorderline.tailIndent, self.bottomBorderline.thick /scale);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
    }
    else
    {
        layerRect = CGRectZero;
        fromPoint = CGPointZero;
        toPoint = CGPointZero;
        NSAssert(0, @"oops!");
    }
    
    if ([MyBaseLayout isRTL])
    {
        layerRect.origin.x = layoutSize.width - layerRect.origin.x - layerRect.size.width;
    }
    
    //把动画效果取消。
    if (!CGRectEqualToRect(layer.frame, layerRect))
    {
        if (layer.lineDashPhase == 0)
        {
            layer.path = nil;
        }
        else
        {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, fromPoint.x, fromPoint.y);
            CGPathAddLineToPoint(path, nil, toPoint.x,toPoint.y);
            layer.path = path;
            CGPathRelease(path);
        }
        layer.frame = layerRect;
        
    }
    
}


- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    return [NSNull null];
}


-(void)setNeedsLayout
{
    if (_topBorderlineLayer != nil)
        [_topBorderlineLayer setNeedsLayout];
    
    if (_bottomBorderlineLayer != nil)
        [_bottomBorderlineLayer setNeedsLayout];
    
    
    if (_leadingBorderlineLayer != nil)
        [_leadingBorderlineLayer setNeedsLayout];
    
    if (_trailingBorderlineLayer != nil)
        [_trailingBorderlineLayer setNeedsLayout];

}


@end




@implementation MyFrame

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _leading = CGFLOAT_MAX;
        _trailing = CGFLOAT_MAX;
        _top = CGFLOAT_MAX;
        _bottom = CGFLOAT_MAX;
        _width = CGFLOAT_MAX;
        _height = CGFLOAT_MAX;
    }
    
    return self;
}

-(void)reset
{
    _leading = CGFLOAT_MAX;
    _trailing = CGFLOAT_MAX;
    _top = CGFLOAT_MAX;
    _bottom = CGFLOAT_MAX;
    _width = CGFLOAT_MAX;
    _height = CGFLOAT_MAX;
}


-(CGRect)frame
{
    return CGRectMake(_leading, _top,_width, _height);
}

-(void)setFrame:(CGRect)frame
{
    _leading = frame.origin.x;
    _top = frame.origin.y;
    _width  = frame.size.width;
    _height = frame.size.height;
    _trailing = _leading + _width;
    _bottom = _top + _height;
}

-(BOOL)multiple
{
    return self.sizeClasses.count > 1;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"leading:%g, top:%g, width:%g, height:%g, trailing:%g, bottom:%g",_leading,_top,_width,_height,_trailing,_bottom];
}


@end


BOOL _myCGFloatEqual(CGFloat f1, CGFloat f2)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fabs(f1 - f2) < 1e-7;
#else
    return fabsf(f1 - f2) < 1e-4;
#endif
}

BOOL _myCGFloatNotEqual(CGFloat f1, CGFloat f2)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fabs(f1 - f2) > 1e-7;
#else
    return fabsf(f1 - f2) > 1e-4;
#endif
}


BOOL _myCGFloatLessOrEqual(CGFloat f1, CGFloat f2)
{
    
#if CGFLOAT_IS_DOUBLE == 1
    return f1 < f2 || fabs(f1 - f2) < 1e-7;
#else
    return f1 < f2 || fabsf(f1 - f2) < 1e-4;
#endif
}

BOOL _myCGFloatGreatOrEqual(CGFloat f1, CGFloat f2)
{
#if CGFLOAT_IS_DOUBLE == 1
    return f1 > f2 || fabs(f1 - f2) < 1e-7;
#else
    return f1 > f2 || fabsf(f1 - f2) < 1e-4;
#endif
}

CGFloat _myRoundNumber(CGFloat f)
{
    if (f == CGFLOAT_MAX)
        return f;
    
    static CGFloat scale;
    scale = [UIScreen mainScreen].scale;
    static CGFloat inc;
    inc = 0.5/scale;
    
    f += inc;
    f *= scale;
    return floor(f) / scale;
}

CGRect _myRoundRect(CGRect rect)
{
    rect.origin.x = _myRoundNumber(rect.origin.x);
    rect.origin.y = _myRoundNumber(rect.origin.y);
    rect.size.width = _myRoundNumber(rect.size.width);
    rect.size.height = _myRoundNumber(rect.size.height);
    return rect;
}

CGSize _myRoundSize(CGSize size)
{
    size.width = _myRoundNumber(size.width);
    size.height = _myRoundNumber(size.height);
    return size;
}

CGPoint _myRoundPoint(CGPoint point)
{
    point.x = _myRoundNumber(point.x);
    point.y = _myRoundNumber(point.y);
    return point;
}


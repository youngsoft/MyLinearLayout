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


const char * const ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES";
const char * const ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS";


@implementation UIView(MyLayoutExt)


-(MyLayoutPos*)leftPos
{
        
    MyLayoutPos *pos = self.myCurrentSizeClass.leftPos;
    pos.view = self;
    return pos;
}


-(MyLayoutPos*)topPos
{
    MyLayoutPos *pos = self.myCurrentSizeClass.topPos;
    pos.view = self;
    return pos;
}


-(MyLayoutPos*)rightPos
{

    MyLayoutPos *pos = self.myCurrentSizeClass.rightPos;
    pos.view = self;
    return pos;
    
}


-(MyLayoutPos*)bottomPos
{
    
    MyLayoutPos *pos = self.myCurrentSizeClass.bottomPos;
    pos.view = self;
    return pos;
    
}

-(CGFloat)myLeft
{
    return self.leftPosInner.margin;
}

-(void)setMyLeft:(CGFloat)myLeft
{
    [self.leftPos __equalTo:@(myLeft)];
    
}

-(CGFloat)myTop
{
    return self.topPosInner.margin;
}

-(void)setMyTop:(CGFloat)myTop
{
    [self.topPos __equalTo:@(myTop)];
}

-(CGFloat)myRight
{
    return self.rightPosInner.margin;
}

-(void)setMyRight:(CGFloat)myRight
{
    [self.rightPos __equalTo:@(myRight)];
}

-(CGFloat)myBottom
{
    return self.bottomPosInner.margin;
}

-(void)setMyBottom:(CGFloat)myBottom
{
    [self.bottomPos __equalTo:@(myBottom)];
}

-(CGFloat)myMargin
{
    return self.leftPosInner.margin;
}

-(void)setMyMargin:(CGFloat)myMargin
{
    [self.topPos __equalTo:@(myMargin)];
    [self.leftPos __equalTo:@(myMargin)];
    [self.rightPos __equalTo:@(myMargin)];
     [self.bottomPos __equalTo:@(myMargin)];
}

-(CGFloat)myHorzMargin
{
    return self.leftPosInner.margin;
}

-(void)setMyHorzMargin:(CGFloat)myHorzMargin
{
    [self.leftPos __equalTo:@(myHorzMargin)];
    [self.rightPos __equalTo:@(myHorzMargin)];
}


-(CGFloat)myVertMargin
{
    return self.topPosInner.margin;
}

-(void)setMyVertMargin:(CGFloat)myVertMargin
{
    [self.topPos __equalTo:@(myVertMargin)];
    [self.bottomPos __equalTo:@(myVertMargin)];
}


-(MyLayoutSize*)widthSize
{

    MyLayoutSize *layoutSize = self.myCurrentSizeClass.widthSize;
    layoutSize.view = self;
    return layoutSize;
    
}



-(MyLayoutSize*)heightSize
{

    MyLayoutSize *layoutSize = self.myCurrentSizeClass.heightSize;
    layoutSize.view = self;
    return layoutSize;
}


-(CGFloat)myWidth
{
    return self.widthSizeInner.measure;
}


-(void)setMyWidth:(CGFloat)myWidth
{
    [self.widthSize __equalTo:@(myWidth)];
}

-(CGFloat)myHeight
{
    return self.heightSizeInner.measure;
}

-(void)setMyHeight:(CGFloat)myHeight
{
    [self.heightSize __equalTo:@(myHeight)];
}

-(CGSize)mySize
{
    return CGSizeMake(self.myWidth, self.myHeight);
}

-(void)setMySize:(CGSize)mySize
{
    self.myWidth = mySize.width;
    self.myHeight = mySize.height;
}




-(MyLayoutPos*)centerXPos
{
    MyLayoutPos *pos = self.myCurrentSizeClass.centerXPos;
    pos.view = self;
    return pos;
    
}


-(MyLayoutPos*)centerYPos
{
    
    MyLayoutPos *pos = self.myCurrentSizeClass.centerYPos;
    pos.view = self;
    return pos;
}


-(CGFloat)myCenterX
{
    return self.centerXPosInner.margin;
}

-(void)setMyCenterX:(CGFloat)myCenterX
{
    [self.centerXPos __equalTo:@(myCenterX)];
}

-(CGFloat)myCenterY
{
    return self.centerYPosInner.margin;
}

-(void)setMyCenterY:(CGFloat)myCenterY
{
    [self.centerYPos __equalTo:@(myCenterY)];
}


-(CGPoint)myCenter
{
    return CGPointMake(self.myCenterX, self.myCenterY);
}

-(void)setMyCenter:(CGPoint)myCenter
{
    self.myCenterX = myCenter.x;
    self.myCenterY = myCenter.y;
}


-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    UIView *lsc = self.myCurrentSizeClass;
    
    if (lsc.wrapContentHeight != wrapContentHeight)
    {
        lsc.wrapContentHeight = wrapContentHeight;
        
        if (wrapContentHeight && [self isKindOfClass:[UILabel class]])
        {
            ((UILabel*)self).numberOfLines = 0;
        }
        
        if ([self isKindOfClass:[MyBaseLayout class]])
        {
            [self setNeedsLayout];
        }
        else
        {
            if (self.superview != nil)
                [self.superview setNeedsLayout];
        }

    }
}

-(BOOL)wrapContentHeight
{
    //特殊处理，减少不必要的对象创建
    return self.myCurrentSizeClassInner.wrapContentHeight;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    UIView *lsc = self.myCurrentSizeClass;
    
    if (lsc.wrapContentWidth != wrapContentWidth)
    {
        lsc.wrapContentWidth = wrapContentWidth;
        
        if ([self isKindOfClass:[MyBaseLayout class]])
        {
            [self setNeedsLayout];
        }
        else
        {
            if (self.superview != nil)
                [self.superview setNeedsLayout];
        }
    }
    
}

-(BOOL)wrapContentWidth
{
    //特殊处理，减少不必要的对象创建
    return self.myCurrentSizeClassInner.wrapContentWidth;
}

-(BOOL)useFrame
{
    return self.myCurrentSizeClass.useFrame;
}

-(void)setUseFrame:(BOOL)useFrame
{
    UIView *lsc = self.myCurrentSizeClass;
    if (lsc.useFrame != useFrame)
    {
        lsc.useFrame = useFrame;
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
    UIView *lsc = self.myCurrentSizeClass;
    if (lsc.noLayout != noLayout)
    {
        lsc.noLayout = noLayout;
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
    UIView *lsc = self.myCurrentSizeClass;
    lsc.viewLayoutCompleteBlock = viewLayoutCompleteBlock;
}





-(CGRect)estimatedRect
{
    CGRect rect = self.myFrame.frame;
    if (rect.origin.x == CGFLOAT_MAX || rect.origin.y == CGFLOAT_MAX)
        return self.frame;
    return rect;
}



-(void)resetMyLayoutSetting
{
    [self resetMyLayoutSettingInSizeClass:MySizeClass_wAny | MySizeClass_hAny];
}

-(void)resetMyLayoutSettingInSizeClass:(MySizeClass)sizeClass
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES);
    if (dict != nil)
    {
        [dict removeObjectForKey:@(sizeClass)];
    }

}






-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass
{
    return [self fetchLayoutSizeClass:sizeClass copyFrom:0xFF];
}

-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES);
    if (dict == nil)
    {
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    MyViewSizeClass *myLayoutSizeClass = (MyViewSizeClass*)[dict objectForKey:@(sizeClass)];
    if (myLayoutSizeClass == nil)
    {
        MyViewSizeClass *srcLayoutSizeClass = (MyViewSizeClass*)[dict objectForKey:@(srcSizeClass)];
        if (srcLayoutSizeClass == nil)
            myLayoutSizeClass = [self createSizeClassInstance];
        else
            myLayoutSizeClass = [srcLayoutSizeClass copy];
        
        [dict setObject:myLayoutSizeClass forKey:@(sizeClass)];
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
    MyFrame *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS);
    if (obj != nil)
    {
        return obj.sizeClass;
    }
    
    return nil;

}



-(instancetype)myBestSizeClass:(MySizeClass)sizeClass
{
    
    MySizeClass wsc = sizeClass & 0x03;
    MySizeClass hsc = sizeClass & 0x0C;
    MySizeClass ori = sizeClass & 0xC0;
    
    
    NSMutableDictionary *dict = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES);
    if (dict == nil)
    {
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        wsc = MySizeClass_wAny;
        hsc = MySizeClass_hAny;
    }
    
    
    MySizeClass searchSizeClass;
    MyViewSizeClass *myClass = nil;
    if (dict.count > 1)
    {
        
        //first search the most exact SizeClass
        searchSizeClass = wsc | hsc | ori;
        myClass = (MyViewSizeClass*)[dict objectForKey:@(searchSizeClass)];
        if (myClass != nil)
            return (UIView*)myClass;
        
        
        searchSizeClass = wsc | hsc;
        if (searchSizeClass != sizeClass)
        {
            MyViewSizeClass *myClass = (MyViewSizeClass*)[dict objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
        
        searchSizeClass = MySizeClass_wAny | hsc | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[dict objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
            
        }
        
        searchSizeClass = MySizeClass_wAny | hsc;
        if (searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[dict objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
        searchSizeClass = wsc | MySizeClass_hAny | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[dict objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
        searchSizeClass = wsc | MySizeClass_hAny;
        if (searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[dict objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
        searchSizeClass = MySizeClass_wAny | MySizeClass_hAny | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            myClass = (MyViewSizeClass*)[dict objectForKey:@(searchSizeClass)];
            if (myClass != nil)
                return (UIView*)myClass;
        }
        
    }
    
    searchSizeClass = MySizeClass_wAny | MySizeClass_hAny;
    myClass = (MyViewSizeClass*)[dict objectForKey:@(searchSizeClass)];
    if (myClass == nil)
    {
        myClass = [self createSizeClassInstance];
        [dict setObject:myClass forKey:@(searchSizeClass)];
    }
    
    return (UIView*)myClass;
    
    
}


-(MyFrame*)myFrame
{
    
    MyFrame *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS);
    if (obj == nil)
    {
        obj = [MyFrame new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return obj;
}

-(id)createSizeClassInstance
{
    return [MyViewSizeClass new];
}


-(MyLayoutPos*)leftPosInner
{
    MyLayoutPos *p = self.myCurrentSizeClass.leftPosInner;
    p.view = self;
    return p;
}


-(MyLayoutPos*)topPosInner
{
    MyLayoutPos *p = self.myCurrentSizeClass.topPosInner;
    p.view = self;
    return p;
}


-(MyLayoutPos*)rightPosInner
{
    
    MyLayoutPos *p = self.myCurrentSizeClass.rightPosInner;
    p.view = self;
    return p;
}

-(MyLayoutPos*)centerXPosInner
{
    MyLayoutPos *p =self.myCurrentSizeClass.centerXPosInner;
    p.view = self;
    return p;
}


-(MyLayoutPos*)centerYPosInner
{
    
    MyLayoutPos * p= self.myCurrentSizeClass.centerYPosInner;
    p.view = self;
    return p;
    
}



-(MyLayoutPos*)bottomPosInner
{
    MyLayoutPos * p =  self.myCurrentSizeClass.bottomPosInner;
    p.view = self;
    return p;
}

-(MyLayoutSize*)widthSizeInner
{
    MyLayoutSize *p =  self.myCurrentSizeClass.widthSizeInner;
    p.view = self;
    return p;
}


-(MyLayoutSize*)heightSizeInner
{
    MyLayoutSize *p = self.myCurrentSizeClass.heightSizeInner;
    p.view = self;
    return p;
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

@end


/**绘制线条层委托实现类**/
#ifdef MAC_OS_X_VERSION_10_12
@interface MyBorderlineLayerDelegate : NSObject<CALayerDelegate>
#else
@interface MyBorderlineLayerDelegate : NSObject
#endif

@property(nonatomic ,weak) MyBaseLayout *layout;

-(id)initWithLayout:(MyBaseLayout*)layout;


@end

@implementation MyBorderlineLayerDelegate


-(id)initWithLayout:(MyBaseLayout*)layout
{
    self = [self init];
    if (self != nil)
    {
        _layout = layout;
    }
    
    return self;
}


-(void)layoutSublayersOfLayer:(CAShapeLayer *)layer
{
    if (self.layout == nil)
        return;
    
    CGSize layoutSize = self.layout.layer.bounds.size;
    
    CGRect layerRect;
    CGPoint fromPoint;
    CGPoint toPoint;
    
    if (layer == self.layout.leftBorderlineLayer)
    {
        layerRect = CGRectMake(0, self.layout.leftBorderline.headIndent, self.layout.leftBorderline.thick/2, layoutSize.height - self.layout.leftBorderline.headIndent - self.layout.leftBorderline.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);
        
    }
    else if (layer == self.layout.rightBorderlineLayer)
    {
        layerRect = CGRectMake(layoutSize.width - self.layout.rightBorderline.thick / 2, self.layout.rightBorderline.headIndent, self.layout.rightBorderline.thick / 2, layoutSize.height - self.layout.rightBorderline.headIndent - self.layout.rightBorderline.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);

    }
    else if (layer == self.layout.topBorderlineLayer)
    {
        layerRect = CGRectMake(self.layout.topBorderline.headIndent, 0, layoutSize.width - self.layout.topBorderline.headIndent - self.layout.topBorderline.tailIndent, self.layout.topBorderline.thick/2);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
    }
    else if (layer == self.layout.bottomBorderlineLayer)
    {
        layerRect = CGRectMake(self.layout.bottomBorderline.headIndent, layoutSize.height - self.layout.bottomBorderline.thick / 2, layoutSize.width - self.layout.bottomBorderline.headIndent - self.layout.bottomBorderline.tailIndent, self.layout.bottomBorderline.thick /2);
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
    
    
    //把动画效果取消。
    if (!CGRectEqualToRect(layer.frame, layerRect))
    {
        
        [CATransaction begin];
        
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        
        
        
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
        
        
        [CATransaction commit];
    }

}

@end


@interface MyBaseLayout()

@end



@implementation MyBaseLayout
{
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
    CGFloat _highlightedOpacity;
    
    BOOL _forbidTouch;
    BOOL _canCallAction;
    CGPoint _beginPoint;
    MyBorderlineLayerDelegate *_borderlineLayerDelegate;
    
    BOOL _isAddSuperviewKVO;

    int _lastScreenOrientation; //为0为初始状态，为1为竖屏，为2为横屏。内部使用。
}

BOOL _hasBegin;

-(void)dealloc
{
    //如果您在使用时出现了KVO的异常崩溃，原因是您将这个视图被多次加入为子视图，请检查您的代码，是否这个视图被多次加入！！
    _endLayoutBlock = nil;
    _beginLayoutBlock = nil;
    _rotationToDeviceOrientationBlock = nil;
}

#pragma  mark -- Public Method

-(void)setPadding:(UIEdgeInsets)padding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    if (!UIEdgeInsetsEqualToEdgeInsets(lsc.padding, padding))
    {
        lsc.padding = padding;
        [self setNeedsLayout];
    }
}

-(UIEdgeInsets)padding
{
    return self.myCurrentSizeClass.padding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    [self setPadding:UIEdgeInsetsMake(lsc.padding.top, leftPadding, lsc.padding.bottom,lsc.padding.right)];
}

-(CGFloat)leftPadding
{
    return self.myCurrentSizeClass.padding.left;
}

-(void)setTopPadding:(CGFloat)topPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    [self setPadding:UIEdgeInsetsMake(topPadding, lsc.padding.left, lsc.padding.bottom,lsc.padding.right)];
}

-(CGFloat)topPadding
{
    return self.myCurrentSizeClass.padding.top;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    [self setPadding:UIEdgeInsetsMake(lsc.padding.top, lsc.padding.left, lsc.padding.bottom, rightPadding)];
}

-(CGFloat)rightPadding
{
    return self.myCurrentSizeClass.padding.right;
}

-(void)setBottomPadding:(CGFloat)bottomPadding
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    [self setPadding:UIEdgeInsetsMake(lsc.padding.top, lsc.padding.left, bottomPadding, lsc.padding.right)];
}

-(CGFloat)bottomPadding
{
    return self.myCurrentSizeClass.padding.bottom;
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
    MyBaseLayout *lsc = self.myCurrentSizeClass;

    if (lsc.hideSubviewReLayout != hideSubviewReLayout)
    {
        lsc.hideSubviewReLayout = hideSubviewReLayout;
        [self setNeedsLayout];
    }
    
}

-(BOOL)hideSubviewReLayout
{
    return self.myCurrentSizeClass.hideSubviewReLayout;
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

-(void)setLeftBorderline:(MyBorderline *)leftBorderline
{
    if (_leftBorderline != leftBorderline)
    {
        _leftBorderline = leftBorderline;
        
        CAShapeLayer *borderLayer = _leftBorderlineLayer;
        [self myUpdateBorderLayer:&borderLayer withBorderline:_leftBorderline];
        _leftBorderlineLayer = borderLayer;
    }
}

-(void)setRightBorderline:(MyBorderline *)rightBorderline
{
    if (_rightBorderline != rightBorderline)
    {
        _rightBorderline = rightBorderline;
        
        CAShapeLayer *borderLayer = _rightBorderlineLayer;
        [self myUpdateBorderLayer:&borderLayer withBorderline:_rightBorderline];
        _rightBorderlineLayer = borderLayer;
    }
    
}


-(void)setBoundBorderline:(MyBorderline *)boundBorderline
{
    self.leftBorderline = boundBorderline;
    self.rightBorderline = boundBorderline;
    self.topBorderline = boundBorderline;
    self.bottomBorderline = boundBorderline;
}

-(MyBorderline*)boundBorderline
{
    return self.leftBorderline;
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
    self.myFrame.sizeClass = [self myBestSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
    {
        sbv.myFrame.sizeClass = [sbv myBestSizeClass:sizeClass];
    }
    
    BOOL hasSubLayout = NO;
    CGSize selfSize= [self calcLayoutRect:size isEstimate:NO pHasSubLayout:&hasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (hasSubLayout)
    {
        self.myFrame.width = selfSize.width;
        self.myFrame.height = selfSize.height;
        
        selfSize = [self calcLayoutRect:CGSizeZero isEstimate:YES pHasSubLayout:&hasSubLayout sizeClass:sizeClass sbs:sbs];
    }
    
    self.myFrame.width = selfSize.width;
    self.myFrame.height = selfSize.height;
    
    
    
    //计算后还原为默认sizeClass
    for (UIView *sbv in self.subviews)
    {
        sbv.myFrame.sizeClass = self.myDefaultSizeClass;
        
    }
    self.myFrame.sizeClass = self.myDefaultSizeClass;
    
    
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





#pragma mark -- Touches Event



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (_target != nil && !_forbidTouch && touch.tapCount == 1 && !_hasBegin)
    {
        _hasBegin = YES;
        _canCallAction = YES;
        _beginPoint = [((UITouch*)[touches anyObject]) locationInView:self];
        
        if (_highlightedOpacity != 0)
        {
            _oldAlpha = self.alpha;
            self.alpha = 1 - _highlightedOpacity;
        }
        
        if (_highlightedBackgroundColor != nil)
        {
            _oldBackgroundColor = self.backgroundColor;
            self.backgroundColor = _highlightedBackgroundColor;
        }
        
        if (_highlightedBackgroundImage != nil)
        {
            _oldBackgroundImage = self.backgroundImage;
            self.backgroundImage = _highlightedBackgroundImage;
        }
        
        _hasDoCancel = NO;
        if (_touchDownTarget != nil && _touchDownAction != nil)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_touchDownTarget performSelector:_touchDownAction withObject:self];
#pragma clang diagnostic pop

        }
        
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_target != nil && _hasBegin)
    {
        if (_canCallAction)
        {
            CGPoint pt = [((UITouch*)[touches anyObject]) locationInView:self];
            if (fabs(pt.x - _beginPoint.x) > 2 || fabs(pt.y - _beginPoint.y) > 2)
            {
                _canCallAction = NO;
                
                if (!_hasDoCancel)
                {
                    
                    if (_touchCancelTarget != nil && _touchCancelAction != nil)
                    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [_touchCancelTarget performSelector:_touchCancelAction withObject:self];
#pragma clang diagnostic pop

                    }
                    
                    _hasDoCancel = YES;

                }
                
            }
        }
    }
    
    [super touchesMoved:touches withEvent:event];
}

-(void)doTargetAction:(UITouch*)touch
{
    
    if (_highlightedOpacity != 0)
    {
        self.alpha = _oldAlpha;
        _oldAlpha = 1;
    }
    
    if (_highlightedBackgroundColor != nil)
    {
        self.backgroundColor = _oldBackgroundColor;
        _oldBackgroundColor = nil;
    }
    
    
    if (_highlightedBackgroundImage != nil)
    {
        self.backgroundImage = _oldBackgroundImage;
        _oldBackgroundImage = nil;
    }
    
    
    //距离太远则不会处理
    CGPoint pt = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, pt) && _action != nil && _canCallAction)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop

    }
    else
    {
        if (!_hasDoCancel)
        {
            if (_touchCancelTarget != nil && _touchCancelAction != nil)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_touchCancelTarget performSelector:_touchCancelAction withObject:self];
#pragma clang diagnostic pop

            }
            
            _hasDoCancel = YES;
        }

    }
    
    _forbidTouch = NO;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_target != nil && _hasBegin)
    {
        //设置一个延时.
        _forbidTouch = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:@selector(doTargetAction:) withObject:[touches anyObject] afterDelay:0.12];
#pragma clang diagnostic pop

        _hasBegin = NO;
    }
    
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_target != nil && _hasBegin)
    {
        if (_highlightedOpacity != 0)
        {
            self.alpha = _oldAlpha;
            _oldAlpha = 1;
        }
        
        if (_highlightedBackgroundColor != nil)
        {
            self.backgroundColor = _oldBackgroundColor;
            _oldBackgroundColor = nil;
        }
        
        if (_highlightedBackgroundImage != nil)
        {
            self.backgroundImage = _oldBackgroundImage;
            _oldBackgroundImage = nil;
        }
        
        
        _hasBegin = NO;
        
        if (!_hasDoCancel)
        {
            if (_touchCancelTarget != nil && _touchCancelAction != nil)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_touchCancelTarget performSelector:_touchCancelAction withObject:self];
#pragma clang diagnostic pop

            }
            
            _hasDoCancel = YES;

        }
        
    }
    
    
    [super touchesCancelled:touches withEvent:event];
}



#pragma mark -- KVO


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    
    //监控非布局父视图的frame的变化，而改变自身的位置和尺寸
    if (object == self.superview && ![object isKindOfClass:[MyBaseLayout class]] && !self.useFrame)
    {
        
        if ([keyPath isEqualToString:@"frame"] ||
            [keyPath isEqualToString:@"bounds"] )
        {
         
            //只监控父视图的尺寸变换
            CGRect rcOld = [change[NSKeyValueChangeOldKey] CGRectValue];
            CGRect rcNew = [change[NSKeyValueChangeNewKey] CGRectValue];
            if (!CGSizeEqualToSize(rcOld.size, rcNew.size))
            {
                [self mySetLayoutRectInNoLayoutSuperview:object];
            }
        }
        return;
    }
    
    
    //监控子视图的frame的变化以便重新进行布局
    if (!_isMyLayouting)
    {
        if ([keyPath isEqualToString:@"frame"] ||
            [keyPath isEqualToString:@"hidden"] ||
            [keyPath isEqualToString:@"center"])
        {
            
            if (![object useFrame])
            {
                [self setNeedsLayout];
                //这里添加的原因是有可能子视图取消隐藏后不会绘制自身，所以这里要求子视图重新绘制自身
                if ([keyPath isEqualToString:@"hidden"] && ![change[NSKeyValueChangeNewKey] boolValue])
                {
                    [(UIView*)object setNeedsDisplay];
                }
            }
        }
    }
    
}


#pragma mark -- Override Method


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
        if (_topBorderlineLayer != nil)
            [_topBorderlineLayer setNeedsLayout];
        
        if (_bottomBorderlineLayer != nil)
            [_bottomBorderlineLayer setNeedsLayout];
        
        
        if (_leftBorderlineLayer != nil)
            [_leftBorderlineLayer setNeedsLayout];
        
        if (_rightBorderlineLayer != nil)
            [_rightBorderlineLayer setNeedsLayout];
        
        if ([self.superview isKindOfClass:[MyBaseLayout class]])
        {
            MyBaseLayout *supl = (MyBaseLayout*)self.superview;
            
            if (supl.hideSubviewReLayout && !self.useFrame)
            {
                [self setNeedsLayout];
            }
        }
        
    }
   
}



- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];   //只要加入进来后就修改其默认的实现，而改用我们的实现，这里包括隐藏,调整大小，
    
    //添加hidden, frame,center的属性通知。
    [subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [subview addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];  //删除后恢复其原来的实现。
    
    subview.viewLayoutCompleteBlock = nil;
    [subview removeObserver:self forKeyPath:@"hidden"];
    [subview removeObserver:self forKeyPath:@"frame"];
    [subview removeObserver:self forKeyPath:@"center"];

}

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    
    //特殊处理如果视图是控制器根视图则取消wrapContentWidth, wrapContentHeight,以及adjustScrollViewContentSizeMode的设置。
    @try {
        
        if (newSuperview != nil)
        {
            id vc = [self valueForKey:@"viewDelegate"];
            if (vc != nil)
            {
                [self mySetWrapContentWidthNoLayout:NO];
                [self mySetWrapContentHeightNoLayout:NO];
                self.adjustScrollViewContentSizeMode = MyLayoutAdjustScrollViewContentSizeModeNo;
            }
        }
        
    } @catch (NSException *exception) {
        
    }
    
    
#ifdef DEBUG
    
    if (self.wrapContentHeight && self.heightSizeInner.dimeVal != nil)
    {
        //约束警告：wrapContentHeight和设置的heightSize可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentHeight and heightSize setting may be constraint.",self);
    }
    
    if (self.wrapContentWidth && self.widthSizeInner.dimeVal != nil)
    {
        //约束警告：wrapContentWidth和设置的widthSize可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentWidth and widthSize setting may be constraint.",self);
    }
    
#endif
    
    
    
    
    //将要添加到父视图时，如果不是MyLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
    if (newSuperview != nil && ![newSuperview isKindOfClass:[MyBaseLayout class]])
    {

#ifdef DEBUG
        
        if (self.leftPosInner.posRelaVal != nil)
        {
            //约束冲突：左边距依赖的视图不是父视图
            NSCAssert(self.leftPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@left margin dependent on:%@is not superview",self, self.leftPosInner.posRelaVal.view);
        }
        
        if (self.rightPosInner.posRelaVal != nil)
        {
            //约束冲突：右边距依赖的视图不是父视图
            NSCAssert(self.rightPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@right margin dependent on:%@is not superview",self,self.rightPosInner.posRelaVal.view);
        }
        
        if (self.centerXPosInner.posRelaVal != nil)
        {
            //约束冲突：水平中心点依赖的视图不是父视图
            NSCAssert(self.centerXPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@horizontal center margin dependent on:%@is not superview",self, self.centerXPosInner.posRelaVal.view);
        }
        
        if (self.topPosInner.posRelaVal != nil)
        {
            //约束冲突：上边距依赖的视图不是父视图
            NSCAssert(self.topPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@top margin dependent on:%@is not superview",self, self.topPosInner.posRelaVal.view);
        }
        
        if (self.bottomPosInner.posRelaVal != nil)
        {
            //约束冲突：下边距依赖的视图不是父视图
            NSCAssert(self.bottomPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@bottom margin dependent on:%@is not superview",self, self.bottomPosInner.posRelaVal.view);
            
        }
        
        if (self.centerYPosInner.posRelaVal != nil)
        {
            //约束冲突：垂直中心点依赖的视图不是父视图
            NSCAssert(self.centerYPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! vertical center margin dependent on:%@is not superview",self.centerYPosInner.posRelaVal.view);
        }
        
        if (self.widthSizeInner.dimeRelaVal != nil)
        {
            //约束冲突：宽度依赖的视图不是父视图
            NSCAssert(self.widthSizeInner.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@width dependent on:%@is not superview",self, self.widthSizeInner.dimeRelaVal.view);
        }
        
        if (self.heightSizeInner.dimeRelaVal != nil)
        {
            //约束冲突：高度依赖的视图不是父视图
            NSCAssert(self.heightSizeInner.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@height dependent on:%@is not superview",self,self.heightSizeInner.dimeRelaVal.view);
        }
        
#endif

        if ([self mySetLayoutRectInNoLayoutSuperview:newSuperview])
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
            
            [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
            [newSuperview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
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
            if (self.adjustScrollViewContentSizeMode == MyLayoutAdjustScrollViewContentSizeModeAuto)
            {
                self.adjustScrollViewContentSizeMode = MyLayoutAdjustScrollViewContentSizeModeYes;
            }
        }
    }
    else
    {
        self.beginLayoutBlock = nil;
        self.endLayoutBlock = nil;
    }
    
    
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
        
        //得到最佳的sizeClass
     /*   MySizeClass sizeClass;
        if ([UIDevice currentDevice].systemVersion.floatValue < 8)
            sizeClass = MySizeClass_hAny | MySizeClass_wAny;
        else
            sizeClass = (MySizeClass)((self.traitCollection.verticalSizeClass << 2) | self.traitCollection.horizontalSizeClass);
        
        UIDeviceOrientation ori =   [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsPortrait(ori))
        {
            sizeClass |= MySizeClass_Portrait;
            currentScreenOrientation  = 1;
        }
        else if (UIDeviceOrientationIsLandscape(ori))
        {
            sizeClass |= MySizeClass_Landscape;
            currentScreenOrientation = 2;
        }
        else;
       */
        
        //减少每次调用就计算设备方向以及sizeclass的次数。
        MySizeClass sizeClass = [self myGetGlobalSizeClass];
        if ((sizeClass & 0xF0) == MySizeClass_Portrait)
            currentScreenOrientation = 1;
        else if ((sizeClass & 0xF0) == MySizeClass_Landscape)
            currentScreenOrientation = 2;
        
        self.myFrame.sizeClass = [self myBestSizeClass:sizeClass];
        for (UIView *sbv in self.subviews)
        {
            sbv.myFrame.sizeClass = [sbv myBestSizeClass:sizeClass];
        }

        //计算布局
        CGSize oldSelfSize = self.bounds.size;
        CGSize newSelfSize = [self calcLayoutRect:[self myCalcSizeInNoLayoutSuperview:self.superview currentSize:oldSelfSize] isEstimate:NO pHasSubLayout:nil sizeClass:sizeClass sbs:nil];
        
        //设置子视图的frame并还原
        for (UIView *sbv in self.subviews)
        {
            CGPoint ptorigin = sbv.bounds.origin;
            
            MyFrame *myFrame = sbv.myFrame;
            if (myFrame.leftPos != CGFLOAT_MAX && myFrame.topPos != CGFLOAT_MAX && !sbv.noLayout && !sbv.useFrame)
            {
                if (myFrame.width < 0)
                {
                    myFrame.width = 0;
                }
                if (myFrame.height < 0)
                {
                    myFrame.height = 0;
                }
                
            
                sbv.center = CGPointMake(myFrame.leftPos + sbv.layer.anchorPoint.x * myFrame.width, myFrame.topPos + sbv.layer.anchorPoint.y * myFrame.height);
                
                sbv.bounds = CGRectMake(ptorigin.x, ptorigin.y, myFrame.width, myFrame.height);
            

            }
            
            if (myFrame.sizeClass.isHidden)
            {
                sbv.bounds = CGRectMake(ptorigin.x, ptorigin.y, 0, 0);
            }
            
            if (sbv.viewLayoutCompleteBlock != nil)
            {
                sbv.viewLayoutCompleteBlock(self, sbv);
                sbv.viewLayoutCompleteBlock = nil;
            }
            
            myFrame.sizeClass = [sbv myDefaultSizeClass];
            [myFrame reset];
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
                
                self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, newSelfSize.width, newSelfSize.height);
                self.center = CGPointMake(self.center.x + (newSelfSize.width - oldSelfSize.width) * self.layer.anchorPoint.x, self.center.y + (newSelfSize.height - oldSelfSize.height) * self.layer.anchorPoint.y);
            }
        }
        
        if (_topBorderlineLayer != nil)
            [_topBorderlineLayer setNeedsLayout];
        
        if (_bottomBorderlineLayer != nil)
            [_bottomBorderlineLayer setNeedsLayout];
        
        
        if (_leftBorderlineLayer != nil)
            [_leftBorderlineLayer setNeedsLayout];
        
        if (_rightBorderlineLayer != nil)
            [_rightBorderlineLayer setNeedsLayout];

        
        //这里只用width判断的原因是如果newSelfSize被计算成功则size中的所有值都不是CGFLOAT_MAX，所以这里选width只是其中一个代表。
        if (newSelfSize.width != CGFLOAT_MAX)
        {
            UIView *supv = self.superview;

            //如果自己的父视图是非UIScrollView以及非布局视图。以及自己是wrapContentWidth或者wrapContentHeight时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
            if (supv != nil && ![supv isKindOfClass:[MyBaseLayout class]] && ![supv isKindOfClass:[UIScrollView class]])
            {
                if (self.wrapContentWidth || self.wrapContentHeight)
                {
                    CGRect rectSuper = supv.bounds;
                    CGRect rectSelf = self.bounds;
                    CGPoint centerPonintSelf = self.center;
                    
                    if (self.wrapContentWidth)
                    {
                        //如果只设置了右边，或者只设置了居中则更新位置。。
                        if (self.centerXPosInner.posVal != nil)
                        {
                            centerPonintSelf.x = (rectSuper.size.width - rectSelf.size.width)/2 + [self.centerXPosInner realMarginInSize:rectSuper.size.width] + self.layer.anchorPoint.x * rectSelf.size.width;
                        }
                        else if (self.rightPosInner.posVal != nil && self.leftPosInner.posVal == nil)
                        {
                            centerPonintSelf.x  = rectSuper.size.width - rectSelf.size.width - [self.rightPosInner realMarginInSize:rectSuper.size.width] + self.layer.anchorPoint.x * rectSelf.size.width;
                        }
                        
                    }
                    
                    if (self.wrapContentHeight)
                    {
                        if (self.centerYPosInner.posVal != nil)
                        {
                            centerPonintSelf.y = (rectSuper.size.height - rectSelf.size.height)/2 + [self.centerYPosInner realMarginInSize:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                        else if (self.bottomPosInner.posVal != nil && self.topPosInner.posVal == nil)
                        {
                            centerPonintSelf.y  = rectSuper.size.height - rectSelf.size.height - [self.bottomPosInner realMarginInSize:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                    }
                    
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
                        superBounds.size.height = self.myTop + newSelfSize.height + self.myBottom;
                        superCenter.y += (superBounds.size.height - supv.bounds.size.height) * supv.layer.anchorPoint.y;
                    }
                    
                    if (supv.wrapContentWidth)
                    {
                        superBounds.size.width = self.myLeft + newSelfSize.width + self.myRight;
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
            [self myAlterScrollViewContentSize:newSelfSize];
        }
       
        self.myFrame.sizeClass = [self myDefaultSizeClass];
        _isMyLayouting = NO;
        
    }
    
    if (self.endLayoutBlock != nil)
        self.endLayoutBlock();
    self.endLayoutBlock = nil;

    //执行屏幕旋转的处理逻辑。
    if (self.rotationToDeviceOrientationBlock != nil && currentScreenOrientation != 0)
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

/*
-(void)setSubviewHorzMargin:(CGFloat)subviewHorzMargin
{
    self.subviewHSpace = subviewHorzMargin;
}

-(CGFloat)subviewHorzMargin
{
    return self.subviewHSpace;
}

-(void)setSubviewVertMargin:(CGFloat)subviewVertMargin
{
    self.subviewVSpace = subviewVertMargin;
}

-(CGFloat)subviewVertMargin
{
    return self.subviewVSpace;
}

-(CGFloat)subviewMargin
{
    return self.subviewSpace;
}

-(void)setSubviewMargin:(CGFloat)subviewMargin
{
    self.subviewSpace = subviewMargin;
}
*/


#pragma mark -- Private Method



-(BOOL)myIsRelativeMargin:(CGFloat)margin
{
    return margin > 0 && margin < 1;
}



-(void)myVertGravity:(MyGravity)vert
        selfSize:(CGSize)selfSize
               sbv:(UIView *)sbv
              rect:(CGRect*)pRect
{
    
    CGFloat fixedHeight = self.padding.top + self.padding.bottom;

    
   CGFloat  topMargin =  [self myValidMargin:sbv.topPosInner sbv:sbv calcPos:[sbv.topPosInner realMarginInSize:selfSize.height - fixedHeight] selfLayoutSize:selfSize];
    
   CGFloat  centerMargin = [self myValidMargin:sbv.centerYPosInner sbv:sbv calcPos:[sbv.centerYPosInner realMarginInSize:selfSize.height - fixedHeight] selfLayoutSize:selfSize];
    
   CGFloat  bottomMargin = [self myValidMargin:sbv.bottomPosInner sbv:sbv calcPos:[sbv.bottomPosInner realMarginInSize:selfSize.height - fixedHeight] selfLayoutSize:selfSize];

    
    if (vert == MyGravity_Vert_Fill)
    {
        
        pRect->origin.y = self.padding.top + topMargin;
        pRect->size.height = [self myValidMeasure:sbv.heightSizeInner sbv:sbv calcSize:selfSize.height - fixedHeight - bottomMargin - topMargin sbvSize:pRect->size selfLayoutSize:selfSize];
    }
    else if (vert == MyGravity_Vert_Center)
    {
        
        pRect->origin.y = (selfSize.height - self.padding.top - self.padding.bottom - topMargin - bottomMargin - pRect->size.height)/2 + self.padding.top + topMargin + centerMargin;
    }
    else if (vert == MyGravity_Vert_Window_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.y = (CGRectGetHeight(self.window.bounds) - topMargin - bottomMargin - pRect->size.height)/2 + topMargin + centerMargin;
            pRect->origin.y =  [self.window convertPoint:pRect->origin toView:self].y;
        }

    }
    else if (vert == MyGravity_Vert_Bottom)
    {
        
        pRect->origin.y = selfSize.height - self.padding.bottom - bottomMargin - pRect->size.height;
    }
    else
    {
        pRect->origin.y = self.padding.top + topMargin;
    }
    
    
}

-(void)myHorzGravity:(MyGravity)horz
         selfSize:(CGSize)selfSize
               sbv:(UIView *)sbv
              rect:(CGRect*)pRect
{
    CGFloat fixedWidth = self.padding.left + self.padding.right;
    
    CGFloat leftMargin = [self myValidMargin:sbv.leftPosInner sbv:sbv calcPos:[sbv.leftPosInner realMarginInSize:selfSize.width - fixedWidth] selfLayoutSize:selfSize];
    
    CGFloat centerMargin = [self myValidMargin:sbv.centerXPosInner sbv:sbv calcPos:[sbv.centerXPosInner realMarginInSize:selfSize.width - fixedWidth] selfLayoutSize:selfSize];
    
   CGFloat  rightMargin = [self myValidMargin:sbv.rightPosInner sbv:sbv calcPos:[sbv.rightPosInner realMarginInSize:selfSize.width - fixedWidth] selfLayoutSize:selfSize];

    
    if (horz == MyGravity_Horz_Fill)
    {
        
        pRect->origin.x = self.padding.left + leftMargin;
        pRect->size.width = [self myValidMeasure:sbv.widthSizeInner sbv:sbv calcSize:selfSize.width - self.padding.right - rightMargin - pRect->origin.x sbvSize:pRect->size selfLayoutSize:selfSize];

        
    }
    else if (horz == MyGravity_Horz_Center)
    {
        pRect->origin.x = (selfSize.width - self.padding.left - self.padding.right - leftMargin - rightMargin - pRect->size.width)/2 + self.padding.left + leftMargin + centerMargin;
    }
    else if (horz == MyGravity_Horz_Window_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.x = (CGRectGetWidth(self.window.bounds) - leftMargin - rightMargin - pRect->size.width)/2 + leftMargin + centerMargin;
            pRect->origin.x =  [self.window convertPoint:pRect->origin toView:self].x;
        }


    }
    else if (horz == MyGravity_Horz_Right)
    {
        
        pRect->origin.x = selfSize.width - self.padding.right - rightMargin - pRect->size.width;
    }
    else
    {
        pRect->origin.x = self.padding.left + leftMargin;
    }
}


-(void)mySetWrapContentWidthNoLayout:(BOOL)wrapContentWidth
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    lsc.wrapContentWidth = wrapContentWidth;
}

-(void)mySetWrapContentHeightNoLayout:(BOOL)wrapContentHeight
{
    MyBaseLayout *lsc = self.myCurrentSizeClass;
    lsc.wrapContentHeight = wrapContentHeight;
}

-(void)myCalcSizeOfWrapContentSubview:(UIView*)sbv selfLayoutSize:(CGSize)selfLayoutSize
{
    if (sbv.widthSizeInner.dimeSelfVal != nil || sbv.heightSizeInner.dimeSelfVal != nil)
    {
        CGSize fitSize = [sbv sizeThatFits:CGSizeZero];
        if (sbv.widthSizeInner.dimeSelfVal != nil)
        {
            sbv.myFrame.width =  [sbv.widthSizeInner measureWith:fitSize.width];
            
        }
        
        if (sbv.heightSizeInner.dimeSelfVal != nil)
        {
            sbv.myFrame.height = [sbv.heightSizeInner measureWith:fitSize.height];
        }
    }    
}


-(CGSize)myCalcSizeInNoLayoutSuperview:(UIView*)newSuperview currentSize:(CGSize)size
{
    if (newSuperview == nil || [newSuperview isKindOfClass:[MyBaseLayout class]])
        return size;
    
    CGRect rectSuper = newSuperview.bounds;
    
    if (!newSuperview.wrapContentWidth)
    {
        if (self.widthSizeInner.dimeRelaVal.view == newSuperview)
        {
            size.width = [self.widthSizeInner measureWith:rectSuper.size.width];
            size.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:size.width sbvSize:size selfLayoutSize:rectSuper.size];
        }
        
        if (self.leftPosInner.posVal != nil && self.rightPosInner.posVal != nil)
        {
            CGFloat leftMargin = [self.leftPosInner realMarginInSize:rectSuper.size.width];
            CGFloat rightMargin = [self.rightPosInner realMarginInSize:rectSuper.size.width];
            size.width = rectSuper.size.width - leftMargin - rightMargin;
            size.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:size.width sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (size.width < 0)
        {
            size.width = 0;
        }
    }

    if (!newSuperview.wrapContentHeight)
    {
        if (self.heightSizeInner.dimeRelaVal.view == newSuperview)
        {
            size.height = [self.heightSizeInner measureWith:rectSuper.size.height];
            size.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:size.height sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (self.topPosInner.posVal != nil && self.bottomPosInner.posVal != nil)
        {
            CGFloat topMargin = [self.topPosInner realMarginInSize:rectSuper.size.height];
            CGFloat bottomMargin = [self.bottomPosInner realMarginInSize:rectSuper.size.height];
            size.height = rectSuper.size.height - topMargin - bottomMargin;
            size.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:size.height sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (size.height < 0)
        {
            size.height = 0;
        }

    }
    
    
    return size;
}

-(BOOL)mySetLayoutRectInNoLayoutSuperview:(UIView*)newSuperview
{
    BOOL isAdjust = NO;
    
    CGRect rectSuper = newSuperview.bounds;
    CGFloat leftMargin = [self.leftPosInner realMarginInSize:rectSuper.size.width];
    CGFloat rightMargin = [self.rightPosInner realMarginInSize:rectSuper.size.width];
    CGFloat topMargin = [self.topPosInner realMarginInSize:rectSuper.size.height];
    CGFloat bottomMargin = [self.bottomPosInner realMarginInSize:rectSuper.size.height];
    CGRect rectSelf = self.bounds;
    
    //得到在设置center后的原始值。
    rectSelf.origin.x = self.center.x - rectSelf.size.width * self.layer.anchorPoint.x;
    rectSelf.origin.y = self.center.y - rectSelf.size.height * self.layer.anchorPoint.y;
    
    CGRect oldRectSelf = rectSelf;
    
    //确定左右边距和宽度。
    if (self.widthSizeInner.dimeVal != nil)
    {
        [self mySetWrapContentWidthNoLayout:NO];
        
        if (self.widthSizeInner.dimeRelaVal != nil)
        {
            if (self.widthSizeInner.dimeRelaVal.view == newSuperview)
            {
                rectSelf.size.width = [self.widthSizeInner measureWith:rectSuper.size.width];
            }
            else
            {
                rectSelf.size.width = [self.widthSizeInner measureWith:self.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
            }
            isAdjust = YES;
        }
        else
            rectSelf.size.width = self.widthSizeInner.measure;
    }
    
    rectSelf.size.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
    
    if (self.leftPosInner.posVal != nil && self.rightPosInner.posVal != nil)
    {
        isAdjust = YES;
        [self mySetWrapContentWidthNoLayout:NO];
        rectSelf.size.width = rectSuper.size.width - leftMargin - rightMargin;
        rectSelf.size.width = [self myValidMeasure:self.widthSizeInner sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
        
        rectSelf.origin.x = leftMargin;
    }
    else if (self.centerXPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x = (rectSuper.size.width - rectSelf.size.width)/2 + [self.centerXPosInner realMarginInSize:rectSuper.size.width];
    }
    else if (self.leftPosInner.posVal != nil)
    {
        rectSelf.origin.x = leftMargin;
    }
    else if (self.rightPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x  = rectSuper.size.width - rectSelf.size.width - rightMargin;
    }
    else;
    
    
    if (self.heightSizeInner.dimeVal != nil)
    {
        [self mySetWrapContentHeightNoLayout:NO];
        
        if (self.heightSizeInner.dimeRelaVal != nil)
        {
            if (self.heightSizeInner.dimeRelaVal.view == newSuperview)
            {
                rectSelf.size.height = [self.heightSizeInner measureWith:rectSuper.size.height];
            }
            else
            {
                rectSelf.size.height = [self.heightSizeInner measureWith:self.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
            }
            isAdjust = YES;
        }
        else
            rectSelf.size.height = self.heightSizeInner.measure;
    }
    
    rectSelf.size.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
    
    if (self.topPosInner.posVal != nil && self.bottomPosInner.posVal != nil)
    {
        isAdjust = YES;
        [self mySetWrapContentHeightNoLayout:NO];
        rectSelf.size.height = rectSuper.size.height - topMargin - bottomMargin;
        rectSelf.size.height = [self myValidMeasure:self.heightSizeInner sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
        
        rectSelf.origin.y = topMargin;
    }
    else if (self.centerYPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y = (rectSuper.size.height - rectSelf.size.height)/2 + [self.centerYPosInner realMarginInSize:rectSuper.size.height];
    }
    else if (self.topPosInner.posVal != nil)
    {
        rectSelf.origin.y = topMargin;
    }
    else if (self.bottomPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y  = rectSuper.size.height - rectSelf.size.height - bottomMargin;
    }
    else;
    
    
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
        
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,rectSelf.size.width, rectSelf.size.height);
        self.center = CGPointMake(rectSelf.origin.x + self.layer.anchorPoint.x * rectSelf.size.width, rectSelf.origin.y + self.layer.anchorPoint.y * rectSelf.size.height);
        
    }
    else if (self.wrapContentWidth || self.wrapContentHeight)
    {
        [self setNeedsLayout];
    }
    
    
    
    return isAdjust;

}

-(CGFloat)myHeightFromFlexedHeightView:(UIView*)sbv inWidth:(CGFloat)width
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
    
    if (sbv.heightSizeInner == nil)
        return h;
    else
        return [sbv.heightSizeInner measureWith:h];
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
                value = selfLayoutSize.width - (boundDime.dimeRelaVal.view == self ? (self.leftPadding + self.rightPadding) : 0);
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
        if (pos == MyGravity_Horz_Left)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMinX(rect);
        }
        else if (pos == MyGravity_Horz_Center)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMidX(rect);
        }
        else if (pos == MyGravity_Horz_Right)
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
    return ((sbv.isHidden || sbv.myFrame.sizeClass.isHidden) && self.hideSubviewReLayout) || sbv.useFrame;
}

-(NSMutableArray*)myGetLayoutSubviews
{
    return [self myGetLayoutSubviewsFrom:self.subviews];
}

-(NSMutableArray*)myGetLayoutSubviewsFrom:(NSArray*)sbsFrom
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:sbsFrom.count];
    BOOL isReverseLayout = self.reverseLayout;
    for (UIView *sbv in sbsFrom)
    {
        if ([self myIsNoLayoutSubview:sbv])
            continue;
        
        if (isReverseLayout)
            [sbs insertObject:sbv atIndex:0];
        else
            [sbs addObject:sbv];
    }
    
    
    return sbs;

}

-(void)mySetSubviewRelativeDimeSize:(MyLayoutSize*)dime selfSize:(CGSize)selfSize pRect:(CGRect*)pRect
{
    if (dime.dimeRelaVal == nil)
        return;
    
    if (dime.dime == MyGravity_Horz_Fill)
    {
        
        if (dime.dimeRelaVal == self.widthSizeInner && !self.wrapContentWidth)
            pRect->size.width = [dime measureWith:(selfSize.width - self.leftPadding - self.rightPadding)];
        else if (dime.dimeRelaVal == self.heightSizeInner)
            pRect->size.width = [dime measureWith:(selfSize.height - self.topPadding - self.bottomPadding)];
        else if (dime.dimeRelaVal == dime.view.heightSizeInner)
            pRect->size.width = [dime measureWith:pRect->size.height];
        else if (dime.dimeRelaVal.dime == MyGravity_Horz_Fill)
            pRect->size.width = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.width];
        else
            pRect->size.width = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.height];
    }
    else
    {
        if (dime.dimeRelaVal == self.heightSizeInner && !self.wrapContentHeight)
            pRect->size.height = [dime measureWith:(selfSize.height - self.topPadding - self.bottomPadding)];
        else if (dime.dimeRelaVal == self.widthSizeInner)
            pRect->size.height = [dime measureWith:(selfSize.width - self.leftPadding - self.rightPadding)];
        else if (dime.dimeRelaVal == dime.view.widthSizeInner)
            pRect->size.height = [dime measureWith:pRect->size.width];
        else if (dime.dimeRelaVal.dime == MyGravity_Horz_Fill)
            pRect->size.height = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.width];
        else
            pRect->size.height = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.height];
    }
}

-(CGSize)myAdjustSizeWhenNoSubviews:(CGSize)size sbs:(NSArray *)sbs
{
    //如果没有子视图，并且padding不参与空子视图尺寸计算则尺寸应该扣除padding的值。
    if (sbs.count == 0 && !self.zeroPadding)
    {
        if (self.wrapContentWidth)
            size.width -= (self.leftPadding + self.rightPadding);
        if (self.wrapContentHeight)
            size.height -= (self.topPadding + self.bottomPadding);
    }
    
    return size;
}

- (void)myAlterScrollViewContentSize:(CGSize)newSize
{
    if (self.adjustScrollViewContentSizeMode == MyLayoutAdjustScrollViewContentSizeModeYes && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrolv = (UIScrollView*)self.superview;
        CGSize contsize = scrolv.contentSize;
        CGRect rectSuper = scrolv.bounds;
        
        //这里把自己在父视图中的上下左右边距也算在contentSize的包容范围内。
        CGFloat leftMargin = [self.leftPosInner realMarginInSize:rectSuper.size.width];
        CGFloat rightMargin = [self.rightPosInner realMarginInSize:rectSuper.size.width];
        CGFloat topMargin = [self.topPosInner realMarginInSize:rectSuper.size.height];
        CGFloat bottomMargin = [self.bottomPosInner realMarginInSize:rectSuper.size.height];
        
        if (contsize.height != newSize.height + topMargin + bottomMargin)
            contsize.height = newSize.height + topMargin + bottomMargin;
        if (contsize.width != newSize.width + leftMargin + rightMargin)
            contsize.width = newSize.width + leftMargin + rightMargin;
        
        scrolv.contentSize = contsize;
        
    }
}

-(void)myUpdateBorderLayer:(CAShapeLayer**)ppLayer withBorderline:(MyBorderline*)borderline
{
    
    if (borderline == nil)
    {
        
        if (*ppLayer != nil)
        {
          (*ppLayer).delegate = nil;
           [(*ppLayer) removeFromSuperlayer];
            *ppLayer = nil;
        }
    }
    else
    {
        if (_borderlineLayerDelegate == nil)
            _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayout:self];
        
        if ( *ppLayer == nil)
        {
            *ppLayer = [[CAShapeLayer alloc] init];
            (*ppLayer).delegate = _borderlineLayerDelegate;
            [self.layer addSublayer:*ppLayer];
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



@end


@implementation MyFrame

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _leftPos = CGFLOAT_MAX;
        _rightPos = CGFLOAT_MAX;
        _topPos = CGFLOAT_MAX;
        _bottomPos = CGFLOAT_MAX;
        _width = CGFLOAT_MAX;
        _height = CGFLOAT_MAX;
        
    }
    
    return self;
}

-(void)reset
{
    _leftPos = CGFLOAT_MAX;
    _rightPos = CGFLOAT_MAX;
    _topPos = CGFLOAT_MAX;
    _bottomPos = CGFLOAT_MAX;
    _width = CGFLOAT_MAX;
    _height = CGFLOAT_MAX;
}


-(CGRect)frame
{
    return CGRectMake(_leftPos, _topPos,_width, _height);
}

-(void)setFrame:(CGRect)frame
{
    _leftPos = frame.origin.x;
    _topPos = frame.origin.y;
    _width  = frame.size.width;
    _height = frame.size.height;
    _rightPos = _leftPos + _width;
    _bottomPos = _topPos + _height;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"LeftPos:%g, TopPos:%g, Width:%g, Height:%g, RightPos:%g, BottomPos:%g",_leftPos,_topPos,_width,_height,_rightPos,_bottomPos];
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

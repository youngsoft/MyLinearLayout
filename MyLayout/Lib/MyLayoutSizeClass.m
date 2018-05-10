//
//  MyLayoutSizeClass.m
//  MyLayout
//
//  Created by fzy on 16/1/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyLayoutSizeClass.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutSizeInner.h"
#import "MyGridNode.h"
#import "MyBaseLayout.h"

@interface MyViewSizeClass()

@property(nonatomic, assign) BOOL wrapWidth;
@property(nonatomic, assign) BOOL wrapHeight;

@end

@implementation MyViewSizeClass

BOOL _myisRTL = NO;

+(BOOL)isRTL
{
    return _myisRTL;
}

+(void)setIsRTL:(BOOL)isRTL
{
    _myisRTL = isRTL;
}

-(id)init
{
    return [super init];
}

-(MyLayoutPos*)topPosInner
{
    return _topPos;
}

-(MyLayoutPos*)leadingPosInner
{
    return _leadingPos;
}


-(MyLayoutPos*)bottomPosInner
{
    return _bottomPos;
}

-(MyLayoutPos*)trailingPosInner
{
    return _trailingPos;
}

-(MyLayoutPos*)centerXPosInner
{
    return _centerXPos;
}

-(MyLayoutPos*)centerYPosInner
{
    return _centerYPos;
}

-(MyLayoutPos*)leftPosInner
{
    return [MyViewSizeClass isRTL] ? self.trailingPosInner : self.leadingPosInner;
}

-(MyLayoutPos*)rightPosInner
{
    return [MyViewSizeClass isRTL] ? self.leadingPosInner : self.trailingPosInner;
}

-(MyLayoutPos*)baselinePosInner
{
    return _baselinePos;
}

-(MyLayoutSize*)widthSizeInner
{
    return _widthSize;
}


-(MyLayoutSize*)heightSizeInner
{
    return _heightSize;
}



//..

-(MyLayoutPos*)topPos
{
    if (_topPos == nil)
    {
        _topPos = [MyLayoutPos new];
        _topPos.view = self.view;
        _topPos.pos = MyGravity_Vert_Top;
        
    }
    
    return _topPos;
}

-(MyLayoutPos*)leadingPos
{
    if (_leadingPos == nil)
    {
        _leadingPos = [MyLayoutPos new];
        _leadingPos.view = self.view;
        _leadingPos.pos = MyGravity_Horz_Leading;
    }
    
    return _leadingPos;
}


-(MyLayoutPos*)bottomPos
{
    if (_bottomPos == nil)
    {
        _bottomPos = [MyLayoutPos new];
        _bottomPos.view = self.view;
        _bottomPos.pos = MyGravity_Vert_Bottom;
        
    }
    
    return _bottomPos;
}


-(MyLayoutPos*)trailingPos
{
    if (_trailingPos == nil)
    {
        _trailingPos = [MyLayoutPos new];
        _trailingPos.view = self.view;
        _trailingPos.pos = MyGravity_Horz_Trailing;
    }
    
    return _trailingPos;
    
}


-(MyLayoutPos*)centerXPos
{
    if (_centerXPos == nil)
    {
        _centerXPos = [MyLayoutPos new];
        _centerXPos.view = self.view;
        _centerXPos.pos = MyGravity_Horz_Center;
        
    }
    
    return _centerXPos;
}

-(MyLayoutPos*)centerYPos
{
    if (_centerYPos == nil)
    {
        _centerYPos = [MyLayoutPos new];
        _centerYPos.view = self.view;
        _centerYPos.pos = MyGravity_Vert_Center;
        
    }
    
    return _centerYPos;
}



-(MyLayoutPos*)leftPos
{
    return [MyViewSizeClass isRTL] ? self.trailingPos : self.leadingPos;
}

-(MyLayoutPos*)rightPos
{
    return [MyViewSizeClass isRTL] ? self.leadingPos : self.trailingPos;
}

-(MyLayoutPos*)baselinePos
{
    if (_baselinePos == nil)
    {
        _baselinePos = [MyLayoutPos new];
        _baselinePos.view = self.view;
        _baselinePos.pos = MyGravity_Vert_Baseline;
    }
    
    return _baselinePos;
}



-(CGFloat)myTop
{
    return self.topPosInner.absVal;
}

-(void)setMyTop:(CGFloat)myTop
{
    [self.topPos __equalTo:@(myTop)];
}


-(CGFloat)myLeading
{
    return self.leadingPosInner.absVal;
}

-(void)setMyLeading:(CGFloat)myLeading
{
    [self.leadingPos __equalTo:@(myLeading)];
}


-(CGFloat)myBottom
{
    return self.bottomPosInner.absVal;
}

-(void)setMyBottom:(CGFloat)myBottom
{
    [self.bottomPos __equalTo:@(myBottom)];
}


-(CGFloat)myTrailing
{
    return self.trailingPosInner.absVal;
}

-(void)setMyTrailing:(CGFloat)myTrailing
{
    [self.trailingPos __equalTo:@(myTrailing)];
}


-(CGFloat)myCenterX
{
    return self.centerXPosInner.absVal;
}

-(void)setMyCenterX:(CGFloat)myCenterX
{
    [self.centerXPos __equalTo:@(myCenterX)];
}

-(CGFloat)myCenterY
{
    return self.centerYPosInner.absVal;
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



-(CGFloat)myLeft
{
    return self.leftPosInner.absVal;
}

-(void)setMyLeft:(CGFloat)myLeft
{
    [self.leftPos __equalTo:@(myLeft)];
    
}

-(CGFloat)myRight
{
    return self.rightPosInner.absVal;
}

-(void)setMyRight:(CGFloat)myRight
{
    [self.rightPos __equalTo:@(myRight)];
}




-(CGFloat)myMargin
{
    return self.leftPosInner.absVal;
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
    return self.leftPosInner.absVal;
}

-(void)setMyHorzMargin:(CGFloat)myHorzMargin
{
    [self.leftPos __equalTo:@(myHorzMargin)];
    [self.rightPos __equalTo:@(myHorzMargin)];
}

-(CGFloat)myVertMargin
{
    return self.topPosInner.absVal;
}

-(void)setMyVertMargin:(CGFloat)myVertMargin
{
    [self.topPos __equalTo:@(myVertMargin)];
    [self.bottomPos __equalTo:@(myVertMargin)];
}




-(MyLayoutSize*)widthSize
{
    if (_widthSize == nil)
    {
        _widthSize = [MyLayoutSize new];
        _widthSize.view = self.view;
        _widthSize.dime = MyGravity_Horz_Fill;
        
    }
    
    return _widthSize;
}


-(MyLayoutSize*)heightSize
{
    if (_heightSize == nil)
    {
        _heightSize = [MyLayoutSize new];
        _heightSize.view = self.view;
        _heightSize.dime = MyGravity_Vert_Fill;
        
    }
    
    return _heightSize;
}


-(CGFloat)myWidth
{
    return self.widthSizeInner.measure;
}

-(void)setMyWidth:(CGFloat)width
{
    [self.widthSize __equalTo:@(width)];
}

-(CGFloat)myHeight
{
    return self.heightSizeInner.measure;
}

-(void)setMyHeight:(CGFloat)height
{
    [self.heightSize __equalTo:@(height)];
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



-(void)setWeight:(CGFloat)weight
{
    if (weight < 0)
        weight = 0;
    
    if (_weight != weight)
        _weight = weight;
}

-(BOOL)wrapContentWidth
{
    return self.wrapWidth;
}

-(BOOL)wrapContentHeight
{
    return self.wrapHeight;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    if (self.wrapWidth != wrapContentWidth)
    {
        self.wrapWidth = wrapContentWidth;
        
        if (wrapContentWidth)
        {
#ifdef MY_USEPREFIXMETHOD
            self.widthSize.myEqualTo(self.widthSize);
#else
            self.widthSize.equalTo(self.widthSize);
#endif
        }
        else
        {
            if (self.widthSizeInner.dimeSelfVal != nil)
            {
#ifdef MY_USEPREFIXMETHOD
                self.widthSizeInner.myEqualTo(nil);
#else
                self.widthSizeInner.equalTo(nil);
#endif
            }
        }
    }
}


-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    if (self.wrapHeight != wrapContentHeight)
    {
        self.wrapHeight = wrapContentHeight;
        
        if (wrapContentHeight)
        {
            if([_view isKindOfClass:[UILabel class]])
            {
                if (((UILabel*)_view).numberOfLines == 1)
                    ((UILabel*)_view).numberOfLines = 0;
            }
        }
    }
}

-(BOOL)wrapContentSize
{
    return self.wrapContentWidth && self.wrapContentHeight;
}


-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    self.wrapContentWidth = self.wrapContentHeight = wrapContentSize;
}




-(NSString*)debugDescription
{
    
    NSString*dbgDesc = [NSString stringWithFormat:@"\nView:\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\nweight=%f\nuseFrame=%@\nnoLayout=%@\nmyVisibility=%c\nmyAlignment=%hu\nwrapContentWidth=%@\nwrapContentHeight=%@\nreverseFloat=%@\nclearFloat=%@",
                    self.topPosInner,
                    self.leadingPosInner,
                    self.bottomPosInner,
                    self.trailingPosInner,
                    self.centerXPosInner,
                    self.centerYPosInner,
                    self.widthSizeInner,
                    self.heightSizeInner,
                    self.weight,
                    self.useFrame ? @"YES":@"NO",
                    self.noLayout? @"YES":@"NO",
                    self.myVisibility,
                    self.myAlignment,
                    self.wrapContentWidth ? @"YES":@"NO",
                    self.wrapContentHeight ? @"YES":@"NO",
                    self.reverseFloat ? @"YES":@"NO",
                    self.clearFloat ? @"YES":@"NO"];
    
    
    return dbgDesc;
}


#pragma mark -- NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    MyViewSizeClass *lsc = [[[self class] allocWithZone:zone] init];
    
  
    //这里不会复制hidden属性
    lsc->_view = _view;
    lsc->_topPos = [self.topPosInner copy];
    lsc->_leadingPos = [self.leadingPosInner copy];
    lsc->_bottomPos = [self.bottomPosInner copy];
    lsc->_trailingPos = [self.trailingPosInner copy];
    lsc->_centerXPos = [self.centerXPosInner copy];
    lsc->_centerYPos = [self.centerYPosInner copy];
    lsc->_baselinePos = [self.baselinePos copy];
    lsc->_widthSize = [self.widthSizeInner copy];
    lsc->_heightSize = [self.heightSizeInner copy];
    lsc->_wrapWidth = self.wrapWidth;
    lsc->_wrapHeight = self.wrapHeight;
    lsc.useFrame = self.useFrame;
    lsc.noLayout = self.noLayout;
    lsc.myVisibility = self.myVisibility;
    lsc.myAlignment = self.myAlignment;
    lsc.weight = self.weight;
    lsc.reverseFloat = self.isReverseFloat;
    lsc.clearFloat = self.clearFloat;

    
    return lsc;
}


@end

@implementation MyLayoutViewSizeClass

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _zeroPadding = YES;
        _insetsPaddingFromSafeArea = UIRectEdgeLeft | UIRectEdgeRight;
        _insetLandscapeFringePadding = NO;
        
    }
    
    return self;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    if (self.wrapWidth != wrapContentWidth)
    {
        self.wrapWidth = wrapContentWidth;
    }
    
}

-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    if (self.wrapHeight != wrapContentHeight)
    {
        self.wrapHeight = wrapContentHeight;
    }
    
}



-(UIEdgeInsets)padding
{
    return UIEdgeInsetsMake(self.topPadding, self.leftPadding, self.bottomPadding, self.rightPadding);
}

-(void)setPadding:(UIEdgeInsets)padding
{
    self.topPadding = padding.top;
    self.leftPadding = padding.left;
    self.bottomPadding = padding.bottom;
    self.rightPadding = padding.right;
}

-(CGFloat)leftPadding
{
    return [MyViewSizeClass isRTL] ? self.trailingPadding : self.leadingPadding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
     if ([MyViewSizeClass isRTL])
     {
     self.trailingPadding = leftPadding;
     }
     else
     {
     self.leadingPadding = leftPadding;
     }
}

-(CGFloat)rightPadding
{
    return [MyViewSizeClass isRTL] ? self.leadingPadding : self.trailingPadding;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    if ([MyViewSizeClass isRTL])
    {
        self.leadingPadding = rightPadding;
    }
    else
    {
        self.trailingPadding = rightPadding;
    }
}


-(CGFloat)myLayoutTopPadding
{
    //如果padding值是特殊的值。
    if (self.topPadding >= MyLayoutPos.safeAreaMargin - 2000 && self.topPadding <= MyLayoutPos.safeAreaMargin + 2000)
    {
        return  self.topPadding - MyLayoutPos.safeAreaMargin + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    }
    
    if ((self.insetsPaddingFromSafeArea & UIRectEdgeTop) == UIRectEdgeTop)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
       
        if (@available(iOS 11.0, *)) {
             return self.topPadding + self.view.safeAreaInsets.top;
        }
#endif
    }
    
    return self.topPadding;
}

-(CGFloat)myLayoutBottomPadding
{
    //如果padding值是特殊的值。
    if (self.bottomPadding >= MyLayoutPos.safeAreaMargin - 2000 && self.bottomPadding <= MyLayoutPos.safeAreaMargin + 2000)
    {
        CGFloat bottomPaddingAdd = 0;
#if TARGET_OS_IOS
            //如果设备是iPhoneX就特殊处理。竖屏是34，横屏是21
            if ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
            {
               if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                   bottomPaddingAdd = 21;
                else
                    bottomPaddingAdd = 34;
            }
#endif
        return self.bottomPadding - MyLayoutPos.safeAreaMargin + bottomPaddingAdd;
    }
    
    if ((self.insetsPaddingFromSafeArea & UIRectEdgeBottom) == UIRectEdgeBottom )
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

        if (@available(iOS 11.0, *)) {

                return self.bottomPadding + self.view.safeAreaInsets.bottom;
        }
#endif
    }
    
    return self.bottomPadding;
}

-(CGFloat)myLayoutLeadingPadding
{
    if (self.leadingPadding >= MyLayoutPos.safeAreaMargin - 2000 && self.leadingPadding <= MyLayoutPos.safeAreaMargin + 2000)
    {
        CGFloat leadingPaddingAdd = 0;
#if TARGET_OS_IOS
        //如果设备是iPhoneX就特殊处理。竖屏是34，横屏是21
        if ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
        {
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                leadingPaddingAdd = 44;
            else
                leadingPaddingAdd = 0;
        }
#endif
        return self.leadingPadding - MyLayoutPos.safeAreaMargin + leadingPaddingAdd;
    }

    
    CGFloat inset = 0;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

    if (@available(iOS 11.0, *)) {
        
        UIRectEdge edge = [MyViewSizeClass isRTL]? UIRectEdgeRight:UIRectEdgeLeft;
#if TARGET_OS_IOS
        UIDeviceOrientation devori = [MyViewSizeClass isRTL]? UIDeviceOrientationLandscapeLeft: UIDeviceOrientationLandscapeRight;
#endif
        if ((self.insetsPaddingFromSafeArea & edge) == edge)
        {
#if TARGET_OS_IOS

            //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是尾部那么就不缩进了。
            if (self.insetLandscapeFringePadding &&
                (self.insetsPaddingFromSafeArea & (UIRectEdgeLeft | UIRectEdgeRight)) == (UIRectEdgeLeft | UIRectEdgeRight) &&
                [UIDevice currentDevice].orientation == devori)
            {
                inset = 0;
            }
            else
#endif
                inset = [MyViewSizeClass isRTL]? self.view.safeAreaInsets.right : self.view.safeAreaInsets.left;
        }
    }
#endif
    
    return self.leadingPadding + inset;
}

-(CGFloat)myLayoutTrailingPadding
{
    if (self.trailingPadding >= MyLayoutPos.safeAreaMargin - 2000 && self.trailingPadding <= MyLayoutPos.safeAreaMargin + 2000)
    {
        CGFloat trailingPaddingAdd = 0;
#if TARGET_OS_IOS
        //如果设备是iPhoneX就特殊处理。竖屏是34，横屏是21
        if ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
        {
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                trailingPaddingAdd = 44;
            else
                trailingPaddingAdd = 0;
        }
#endif
        return self.trailingPadding - MyLayoutPos.safeAreaMargin + trailingPaddingAdd;
    }

    
    CGFloat inset = 0;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

    if (@available(iOS 11.0, *)) {
        UIRectEdge edge = [MyViewSizeClass isRTL]? UIRectEdgeLeft:UIRectEdgeRight;
#if TARGET_OS_IOS
        UIDeviceOrientation devori = [MyViewSizeClass isRTL]? UIDeviceOrientationLandscapeRight: UIDeviceOrientationLandscapeLeft;
#endif
        if ((self.insetsPaddingFromSafeArea & edge) == edge)
        {
#if TARGET_OS_IOS
            //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是头部那么就不缩进了。
            if (self.insetLandscapeFringePadding &&
                (self.insetsPaddingFromSafeArea & (UIRectEdgeLeft | UIRectEdgeRight)) == (UIRectEdgeLeft | UIRectEdgeRight) &&
                [UIDevice currentDevice].orientation == devori)
            {
                inset = 0;
            }
            else
#endif
                inset = [MyViewSizeClass isRTL]? self.view.safeAreaInsets.left : self.view.safeAreaInsets.right;
        }
    }
#endif
    
    return self.trailingPadding + inset;
}

-(CGFloat)myLayoutLeftPadding
{
    return [MyViewSizeClass isRTL] ? [self myLayoutTrailingPadding] : [self myLayoutLeadingPadding];
}
-(CGFloat)myLayoutRightPadding
{
    return [MyViewSizeClass isRTL] ? [self myLayoutLeadingPadding] : [self myLayoutTrailingPadding];
}


-(CGFloat)subviewSpace
{
    return self.subviewVSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    self.subviewVSpace = subviewSpace;
    self.subviewHSpace = subviewSpace;
}


- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc.topPadding = self.topPadding;
    lsc.leadingPadding = self.leadingPadding;
    lsc.bottomPadding = self.bottomPadding;
    lsc.trailingPadding = self.trailingPadding;
    lsc.zeroPadding = self.zeroPadding;
    lsc.insetsPaddingFromSafeArea = self.insetsPaddingFromSafeArea;
    lsc.insetLandscapeFringePadding = self.insetLandscapeFringePadding;
    lsc.gravity = self.gravity;
    lsc.reverseLayout = self.reverseLayout;
    lsc.subviewVSpace = self.subviewVSpace;
    lsc.subviewHSpace = self.subviewHSpace;
    
    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nLayout:\npadding=%@\nzeroPadding=%@\ngravity=%hu\nreverseLayout=%@\nsubviewVertSpace=%f\nsubviewHorzSpace=%f",
               dbgDesc,
               NSStringFromUIEdgeInsets(self.padding),
               self.zeroPadding?@"YES":@"NO",
               self.gravity,
               self.reverseLayout ? @"YES":@"NO",
               self.subviewVSpace,
               self.subviewHSpace
               ];
    
    
    return dbgDesc;
}


@end


@implementation MySequentLayoutViewSizeClass



- (id)copyWithZone:(NSZone *)zone
{
    MySequentLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc.orientation = self.orientation;
   
    
     return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nSequentLayout: \norientation=%lu",
               dbgDesc,
              (unsigned long)self.orientation
               ];
    
    
    return dbgDesc;
}



@end


@implementation MyLinearLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    MyLinearLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    
    lsc.shrinkType = self.shrinkType;
    
    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nLinearLayout: \nshrinkType=%lu",
               dbgDesc,
               (unsigned long)self.shrinkType
               ];
    
    
    return dbgDesc;
}



@end


@implementation MyTableLayoutViewSizeClass

@end

@implementation MyFloatLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    MyFloatLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    
    lsc.subviewSize = self.subviewSize;
    lsc.minSpace = self.minSpace;
    lsc.maxSpace = self.maxSpace;
    lsc.noBoundaryLimit = self.noBoundaryLimit;
    
    return lsc;
}


-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nFloatLayout: \nnoBoundaryLimit=%@",
               dbgDesc,
               self.noBoundaryLimit ? @"YES":@"NO"];
    
    return dbgDesc;
}



@end


@implementation MyFlowLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    MyFlowLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    
    lsc.arrangedCount = self.arrangedCount;
    lsc.autoArrange = self.autoArrange;
    lsc.arrangedGravity = self.arrangedGravity;
    lsc.subviewSize = self.subviewSize;
    lsc.minSpace = self.minSpace;
    lsc.maxSpace = self.maxSpace;
    lsc.pagedCount = self.pagedCount;
    
    return lsc;
}


-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nFlowLayout: \narrangedCount=%ld\nautoArrange=%@\narrangedGravity=%hu\npagedCount=%ld",
                                          dbgDesc,
                                          (long)self.arrangedCount,
                                          self.autoArrange ? @"YES":@"NO",
                                          self.arrangedGravity,
                                          (long)self.pagedCount
                                          ];
    
    return dbgDesc;
}


@end


@implementation MyRelativeLayoutViewSizeClass

@end

@implementation MyFrameLayoutViewSizeClass



@end

@implementation MyPathLayoutViewSizeClass

@end


@interface MyGridLayoutViewSizeClass()<MyGridNode>

@property(nonatomic, strong) MyGridNode *rootGrid;

@end


@implementation MyGridLayoutViewSizeClass


-(MyGridNode*)rootGrid
{
    if (_rootGrid == nil)
    {
        _rootGrid = [[MyGridNode alloc] initWithMeasure:0 superGrid:nil];
    }
    return _rootGrid;
}

//添加行栅格，返回新的栅格。
-(id<MyGrid>)addRow:(CGFloat)measure
{
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列栅格，返回新的栅格。
-(id<MyGrid>)addCol:(CGFloat)measure
{
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addCol:measure];
    node.superGrid = self;
    return node;
}

//添加栅格，返回被添加的栅格。这个方法和下面的cloneGrid配合使用可以用来构建那些需要重复添加栅格的场景。
-(id<MyGrid>)addRowGrid:(id<MyGrid>)grid
{
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addRowGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<MyGrid>)addColGrid:(id<MyGrid>)grid
{
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addColGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<MyGrid>)addRowGrid:(id<MyGrid>)grid measure:(CGFloat)measure
{
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addRowGrid:grid measure:measure];
    node.superGrid = self;
    return node;
    
}

-(id<MyGrid>)addColGrid:(id<MyGrid>)grid measure:(CGFloat)measure
{
    id<MyGridNode> node = (id<MyGridNode>)[self.rootGrid addColGrid:grid measure:measure];
    node.superGrid = self;
    return node;
    
}


//克隆出一个新栅格以及其下的所有子栅格。
-(id<MyGrid>)cloneGrid
{
    return nil;
}

//从父栅格中删除。
-(void)removeFromSuperGrid
{
}

//得到父栅格。
-(id<MyGrid>)superGrid
{
    return nil;
}

-(void)setSuperGrid:(id<MyGridNode>)superGrid
{
    
}

-(BOOL)placeholder
{
    return NO;
}

-(void)setPlaceholder:(BOOL)placeholder
{
}

-(BOOL)anchor
{
    return NO;
}

-(void)setAnchor:(BOOL)anchor
{
    //do nothing
}

-(MyGravity)overlap
{
    return self.gravity;
}

-(void)setOverlap:(MyGravity)overlap
{
    self.gravity = overlap;
}


-(NSInteger)tag
{
    return self.view.tag;
}

-(void)setTag:(NSInteger)tag
{
    self.view.tag = tag;
}

-(id)actionData
{
    return self.rootGrid.actionData;
}

-(void)setActionData:(id)actionData
{
    self.rootGrid.actionData = actionData;
}

-(void)setTarget:(id)target action:(SEL)action
{
    //do nothing.
}

//得到所有子栅格
-(NSArray<id<MyGrid>> *)subGrids
{
    return self.rootGrid.subGrids;
}


-(void)setSubGrids:(NSMutableArray *)subGrids
{
    self.rootGrid.subGrids = subGrids;
}

-(MySubGridsType)subGridsType
{
    return self.rootGrid.subGridsType;
}

-(void)setSubGridsType:(MySubGridsType)subGridsType
{
    self.rootGrid.subGridsType = subGridsType;
}


-(MyBorderline*)topBorderline
{
    return nil;
}

-(void)setTopBorderline:(MyBorderline *)topBorderline
{
}


-(MyBorderline*)bottomBorderline
{
    return nil;
}

-(void)setBottomBorderline:(MyBorderline *)bottomBorderline
{
}


-(MyBorderline*)leftBorderline
{
    return nil;
}

-(void)setLeftBorderline:(MyBorderline *)leftBorderline
{
}


-(MyBorderline*)rightBorderline
{
    return nil;
}

-(void)setRightBorderline:(MyBorderline *)rightBorderline
{
}

-(MyBorderline*)leadingBorderline
{
    return nil;
}

-(void)setLeadingBorderline:(MyBorderline *)leadingBorderline
{
    
}

-(MyBorderline*)trailingBorderline
{
    return nil;
}

-(void)setTrailingBorderline:(MyBorderline *)trailingBorderline
{
    
}


-(NSDictionary*)gridDictionary
{
    return [MyGridNode translateGridNode:self toGridDictionary:[NSMutableDictionary new]];
}

-(void)setGridDictionary:(NSDictionary *)gridDictionary
{
    MyGridNode *rootNode = self.rootGrid;
    [rootNode.subGrids removeAllObjects];
    rootNode.subGridsType = MySubGridsType_Unknown;
    
    [self.view setNeedsLayout];
    
    if (gridDictionary == nil)
        return;
    
    [MyGridNode translateGridDicionary:gridDictionary toGridNode:self];
}

-(CGFloat)measure
{
    return MyLayoutSize.fill;
    //return self.rootGrid.measure;
}

-(void)setMeasure:(CGFloat)measure
{
    //self.rootGrid.measure = measure;
}

-(CGRect)gridRect
{
    return self.rootGrid.gridRect;
}

-(void)setGridRect:(CGRect)gridRect
{
    self.rootGrid.gridRect = gridRect;
}

//更新格子尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure
{
    return [self.rootGrid updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<MyGridNode>)superGrid withOffset:(CGFloat)offset
{
    return [self.rootGrid updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}


-(UIView*)gridLayoutView
{
    return self.view;
}

-(SEL)gridAction
{
    return nil;
}

-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer
{
    [self.rootGrid setBorderlineNeedLayoutIn:rect withLayer:layer];
}

-(void)showBorderline:(BOOL)show
{
    [self.rootGrid showBorderline:show];
}

-(id<MyGridNode>)gridHitTest:(CGPoint)point
{
    return [self.rootGrid gridHitTest:point];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}




- (id)copyWithZone:(NSZone *)zone
{
    MyGridLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc->_rootGrid = (MyGridNode*)[self.rootGrid cloneGrid];
    
    
    return lsc;
}


@end

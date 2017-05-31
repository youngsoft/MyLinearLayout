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
            self.widthSize.equalTo(self.widthSize);
        }
        else
        {
            if (self.widthSizeInner.dimeSelfVal != nil)
                self.widthSizeInner.equalTo(nil);
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

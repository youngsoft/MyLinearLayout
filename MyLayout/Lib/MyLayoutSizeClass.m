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

@implementation MyViewSizeClass

-(id)init
{
    return [super init];
}


-(MyLayoutPos*)leftPosInner
{
    return _leftPos;
}

-(MyLayoutPos*)topPosInner
{
    return _topPos;
}

-(MyLayoutPos*)rightPosInner
{
    return _rightPos;
}

-(MyLayoutPos*)bottomPosInner
{
    return _bottomPos;
}


-(MyLayoutPos*)centerXPosInner
{
    return _centerXPos;
}

-(MyLayoutPos*)centerYPosInner
{
    return _centerYPos;
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

-(MyLayoutPos*)leftPos
{
    if (_leftPos == nil)
    {
        _leftPos = [MyLayoutPos new];
        _leftPos.pos = MyGravity_Horz_Left;
        
    }
    
    return _leftPos;
    
}

-(MyLayoutPos*)topPos
{
    if (_topPos == nil)
    {
        _topPos = [MyLayoutPos new];
        _topPos.pos = MyGravity_Vert_Top;
        
    }
    
    return _topPos;
}

-(MyLayoutPos*)rightPos
{
    if (_rightPos == nil)
    {
        _rightPos = [MyLayoutPos new];
        _rightPos.pos = MyGravity_Horz_Right;
        
    }
    
    return _rightPos;
}

-(MyLayoutPos*)bottomPos
{
    if (_bottomPos == nil)
    {
        _bottomPos = [MyLayoutPos new];
        _bottomPos.pos = MyGravity_Vert_Bottom;
        
    }
    
    return _bottomPos;
}


-(MyLayoutPos*)centerXPos
{
    if (_centerXPos == nil)
    {
        _centerXPos = [MyLayoutPos new];
        _centerXPos.pos = MyGravity_Horz_Center;
        
    }
    
    return _centerXPos;
}

-(MyLayoutPos*)centerYPos
{
    if (_centerYPos == nil)
    {
        _centerYPos = [MyLayoutPos new];
        _centerYPos.pos = MyGravity_Vert_Center;
        
    }
    
    return _centerYPos;
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


-(MyLayoutSize*)widthSize
{
    if (_widthSize == nil)
    {
        _widthSize = [MyLayoutSize new];
        _widthSize.dime = MyGravity_Horz_Fill;
        
    }
    
    return _widthSize;
}


-(MyLayoutSize*)heightSize
{
    if (_heightSize == nil)
    {
        _heightSize = [MyLayoutSize new];
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


-(NSString*)debugDescription
{
    
    NSString*dbgDesc = [NSString stringWithFormat:@"\nView:\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\nweight=%f\nuseFrame=%@\nnoLayout=%@\nwrapContentWidth=%@\nwrapContentHeight=%@\nreverseFloat=%@\nclearFloat=%@",
                    self.leftPosInner,
                    self.topPosInner,
                    self.bottomPosInner,
                    self.rightPosInner,
                    self.centerXPosInner,
                    self.centerYPosInner,
                    self.widthSizeInner,
                    self.heightSizeInner,
                    self.weight,
                    self.useFrame ? @"YES":@"NO",
                    self.noLayout? @"YES":@"NO",
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
    lsc->_leftPos = [self.leftPosInner copy];
    lsc->_topPos = [self.topPosInner copy];
    lsc->_rightPos = [self.rightPosInner copy];
    lsc->_bottomPos = [self.bottomPosInner copy];
    lsc->_centerXPos = [self.centerXPosInner copy];
    lsc->_centerYPos = [self.centerYPosInner copy];
    lsc->_widthSize = [self.widthSizeInner copy];
    lsc->_heightSize = [self.heightSizeInner copy];
    lsc->_wrapContentWidth = self.wrapContentWidth;
    lsc->_wrapContentHeight = self.wrapContentHeight;
    lsc.useFrame = self.useFrame;
    lsc.noLayout = self.noLayout;
    lsc.hidden = self.hidden;
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
        _hideSubviewReLayout = YES;
        _zeroPadding = YES;
        
    }
    
    return self;
}

-(CGFloat)topPadding
{
    return self.padding.top;
}

-(void)setTopPadding:(CGFloat)topPadding
{
    self->_padding.top = topPadding;
}

-(CGFloat)leftPadding
{
    return self.padding.left;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    self->_padding.left = leftPadding;
}

-(CGFloat)bottomPadding
{
    return self.padding.bottom;
}

-(void)setBottomPadding:(CGFloat)bottomPadding
{
    self->_padding.bottom = bottomPadding;
}

-(CGFloat)rightPadding
{
    return self.padding.right;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    self->_padding.right = rightPadding;
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
    lsc.padding = self.padding;
    lsc.zeroPadding = self.zeroPadding;
    lsc.hideSubviewReLayout = self.hideSubviewReLayout;
    lsc.reverseLayout = self.reverseLayout;
    lsc.subviewVSpace = self.subviewVSpace;
    lsc.subviewHSpace = self.subviewHSpace;
    
    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nLayout:\npadding=%@\nzeroPadding=%@\nhideSubviewRelayout=%@\nreverseLayout=%@\nsubviewVertSpace=%f\nsubviewHorzSpace=%f",
               dbgDesc,
               NSStringFromUIEdgeInsets(self.padding),
               self.zeroPadding?@"YES":@"NO",
               self.hideSubviewReLayout?@"YES":@"NO",
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
    lsc.gravity = self.gravity;
   
    
     return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nSequentLayout: \norientation=%lu\ngravity=%hu",
               dbgDesc,
              (unsigned long)self.orientation,
               self.gravity
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

- (id)copyWithZone:(NSZone *)zone
{
    MyRelativeLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc.flexOtherViewWidthWhenSubviewHidden = self.flexOtherViewWidthWhenSubviewHidden;
    lsc.flexOtherViewHeightWhenSubviewHidden = self.flexOtherViewHeightWhenSubviewHidden;
    
    return lsc;
}


-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nRelativeLayout: \nflexOtherViewWidthWhenSubviewHidden=%@\nflexOtherViewHeightWhenSubviewHidden=%@",
               dbgDesc,
               self.flexOtherViewWidthWhenSubviewHidden ? @"YES":@"NO",
               self.flexOtherViewHeightWhenSubviewHidden ? @"YES":@"NO"
               ];
    
    return dbgDesc;
}



@end

@implementation MyFrameLayoutViewSizeClass



@end

@implementation MyPathLayoutViewSizeClass

@end

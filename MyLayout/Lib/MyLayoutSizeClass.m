//
//  MyLayoutSizeClass.m
//  MyLayout
//
//  Created by fzy on 16/1/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyLayoutSizeClass.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutDimeInner.h"

@implementation MyLayoutSizeClass


-(MyLayoutPos*)leftPos
{
    if (_leftPos == nil)
    {
        _leftPos = [MyLayoutPos new];
        _leftPos.pos = MyMarginGravity_Horz_Left;
        
    }
    
    return _leftPos;
    
}

-(MyLayoutPos*)topPos
{
    if (_topPos == nil)
    {
        _topPos = [MyLayoutPos new];
        _topPos.pos = MyMarginGravity_Vert_Top;
        
    }
    
    return _topPos;
}

-(MyLayoutPos*)rightPos
{
    if (_rightPos == nil)
    {
        _rightPos = [MyLayoutPos new];
        _rightPos.pos = MyMarginGravity_Horz_Right;
        
    }
    
    return _rightPos;
}

-(MyLayoutPos*)bottomPos
{
    if (_bottomPos == nil)
    {
        _bottomPos = [MyLayoutPos new];
        _bottomPos.pos = MyMarginGravity_Vert_Bottom;
        
    }
    
    return _bottomPos;
}


-(MyLayoutPos*)centerXPos
{
    if (_centerXPos == nil)
    {
        _centerXPos = [MyLayoutPos new];
        _centerXPos.pos = MyMarginGravity_Horz_Center;
        
    }
    
    return _centerXPos;
}

-(MyLayoutPos*)centerYPos
{
    if (_centerYPos == nil)
    {
        _centerYPos = [MyLayoutPos new];
        _centerYPos.pos = MyMarginGravity_Vert_Center;
        
    }
    
    return _centerYPos;
}


-(CGFloat)myLeftMargin
{
    return self.leftPos.margin;
}

-(void)setMyLeftMargin:(CGFloat)leftMargin
{
    self.leftPos.equalTo(@(leftMargin));
    
}

-(CGFloat)myTopMargin
{
    return self.topPos.margin;
}

-(void)setMyTopMargin:(CGFloat)topMargin
{
    self.topPos.equalTo(@(topMargin));
}

-(CGFloat)myRightMargin
{
    return self.rightPos.margin;
}

-(void)setMyRightMargin:(CGFloat)rightMargin
{
    self.rightPos.equalTo(@(rightMargin));
}

-(CGFloat)myBottomMargin
{
    return self.bottomPos.margin;
}

-(void)setMyBottomMargin:(CGFloat)bottomMargin
{
    self.bottomPos.equalTo(@(bottomMargin));
}

-(CGFloat)myMargin
{
    return self.leftPos.margin;
}

-(void)setMyMargin:(CGFloat)myMargin
{
    self.topPos.equalTo(@(myMargin));
    self.leftPos.equalTo(@(myMargin));
    self.rightPos.equalTo(@(myMargin));
    self.bottomPos.equalTo(@(myMargin));
}


-(CGFloat)myCenterXOffset
{
    return self.centerXPos.margin;
}

-(void)setMyCenterXOffset:(CGFloat)centerXOffset
{
    self.centerXPos.equalTo(@(centerXOffset));
}

-(CGFloat)myCenterYOffset
{
    return self.centerYPos.margin;
}

-(void)setMyCenterYOffset:(CGFloat)centerYOffset
{
    self.centerYPos.equalTo(@(centerYOffset));
}


-(CGPoint)myCenterOffset
{
    return CGPointMake(self.myCenterXOffset, self.myCenterYOffset);
}

-(void)setMyCenterOffset:(CGPoint)centerOffset
{
    self.myCenterXOffset = centerOffset.x;
    self.myCenterYOffset = centerOffset.y;
}


-(MyLayoutDime*)widthDime
{
    if (_widthDime == nil)
    {
        _widthDime = [MyLayoutDime new];
        _widthDime.dime = MyMarginGravity_Horz_Fill;
        
    }
    
    return _widthDime;
}


-(MyLayoutDime*)heightDime
{
    if (_heightDime == nil)
    {
        _heightDime = [MyLayoutDime new];
        _heightDime.dime = MyMarginGravity_Vert_Fill;
        
    }
    
    return _heightDime;
}


-(CGFloat)myWidth
{
    return self.widthDime.measure;
}

-(void)setMyWidth:(CGFloat)width
{
    self.widthDime.equalTo(@(width));
}

-(CGFloat)myHeight
{
    return self.heightDime.measure;
}

-(void)setMyHeight:(CGFloat)height
{
    self.heightDime.equalTo(@(height));
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



#pragma mark -- NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutSizeClass *lsc = [[[self class] allocWithZone:zone] init];
    
  
    //这里不会复制hidden属性
    lsc->_leftPos = [self.leftPos copy];
    lsc->_topPos = [self.topPos copy];
    lsc->_rightPos = [self.rightPos copy];
    lsc->_bottomPos = [self.bottomPos copy];
    lsc->_centerXPos = [self.centerXPos copy];
    lsc->_centerYPos = [self.centerYPos copy];
    lsc->_widthDime = [self.widthDime copy];
    lsc->_heightDime = [self.heightDime copy];
    lsc.flexedHeight = self.isFlexedHeight;
    lsc.useFrame = self.useFrame;
    lsc.noLayout = self.noLayout;
    lsc.hidden = self.hidden;
    lsc.weight = self.weight;
    lsc.marginGravity = self.marginGravity;
    lsc.reverseFloat = self.isReverseFloat;
    lsc.clearFloat = self.clearFloat;

    
    return lsc;
}


@end

@implementation MyLayoutSizeClassLayout

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.hideSubviewReLayout = YES;
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

- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutSizeClassLayout *lsc = [super copyWithZone:zone];
    lsc.padding = self.padding;
    lsc.wrapContentWidth = self.wrapContentWidth;
    lsc.wrapContentHeight = self.wrapContentHeight;
    lsc.hideSubviewReLayout = self.hideSubviewReLayout;
    
    return lsc;
}


@end


@implementation MyLayoutSizeClassLinearLayout

-(CGFloat)subviewMargin
{
    return self.subviewVertMargin;
}

-(void)setSubviewMargin:(CGFloat)subviewMargin
{
    self.subviewVertMargin = subviewMargin;
    self.subviewHorzMargin = subviewMargin;
}


- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutSizeClassLinearLayout *lsc = [super copyWithZone:zone];
    
    lsc.orientation = self.orientation;
    lsc.gravity = self.gravity;
    lsc.subviewVertMargin = self.subviewVertMargin;
    lsc.subviewHorzMargin = self.subviewHorzMargin;
    
     return lsc;
}



@end

@implementation MyLayoutSizeClassTableLayout


-(CGFloat)rowSpacing
{
    return self.subviewMargin;
}

-(void)setRowSpacing:(CGFloat)rowSpacing
{
    self.subviewMargin = rowSpacing;
}


- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutSizeClassTableLayout *lsc = [super copyWithZone:zone];
    
    lsc.rowSpacing = self.rowSpacing;
    lsc.colSpacing = self.colSpacing;
    
    return lsc;
}



@end

@implementation MyLayoutSizeClassFloatLayout

- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutSizeClassFloatLayout *lsc = [super copyWithZone:zone];
    
    lsc.subviewSize = self.subviewSize;
    lsc.minMargin = self.minMargin;
    
    return lsc;
}


@end


@implementation MyLayoutSizeClassFlowLayout

- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutSizeClassFlowLayout *lsc = [super copyWithZone:zone];
    
    lsc.arrangedCount = self.arrangedCount;
    lsc.averageArrange = self.averageArrange;
    lsc.autoArrange = self.autoArrange;
    lsc.arrangedGravity = self.arrangedGravity;
    
    return lsc;
}


@end


@implementation MyLayoutSizeClassRelativeLayout

- (id)copyWithZone:(NSZone *)zone
{
    MyLayoutSizeClassRelativeLayout *lsc = [super copyWithZone:zone];
    lsc.flexOtherViewWidthWhenSubviewHidden = self.flexOtherViewWidthWhenSubviewHidden;
    lsc.flexOtherViewHeightWhenSubviewHidden = self.flexOtherViewHeightWhenSubviewHidden;
    
    return lsc;
}


@end

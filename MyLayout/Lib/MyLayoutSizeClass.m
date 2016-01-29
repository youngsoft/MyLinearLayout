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


-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.hideSubviewReLayout = YES;
    }
    
    return self;
}



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

-(void)setWeight:(CGFloat)weight
{
    if (weight < 0)
        weight = 0;
    
    if (_weight != weight)
        _weight = weight;
}



@end

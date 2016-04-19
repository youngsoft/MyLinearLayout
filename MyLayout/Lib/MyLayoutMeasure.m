//
//  MyLayoutMeasure.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutMeasure.h"

@implementation MyLayoutMeasure

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


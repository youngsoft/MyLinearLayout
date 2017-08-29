//
//  MyDimeScale.m
//  MyLayout
//
//  Created by oybq on 16/2/23.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyDimeScale.h"

#if TARGET_OS_IPHONE

extern CGFloat _myCGFloatRound(CGFloat);
extern CGPoint _myCGPointRound(CGPoint);
extern CGSize _myCGSizeRound(CGSize);
extern CGRect _myCGRectRound(CGRect);


@implementation MyDimeScale

CGFloat _rate = 1;
CGFloat _wrate = 1;
CGFloat _hrate = 1;


+(void)setUITemplateSize:(CGSize)size
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _wrate = screenSize.width / size.width;
    _hrate = screenSize.height / size.height;
    _rate = sqrt((screenSize.width * screenSize.width + screenSize.height * screenSize.height) / (size.width * size.width + size.height * size.height));
}

+(CGFloat)scale:(CGFloat)val
{
    return _myCGFloatRound(val * _rate);
}

+(CGFloat)scaleW:(CGFloat)val
{
    return _myCGFloatRound(val * _wrate);
}

+(CGFloat)scaleH:(CGFloat)val
{
    return _myCGFloatRound(val * _hrate);
}

+(CGFloat)roundNumber:(CGFloat)number
{
    return _myCGFloatRound(number);
}

+(CGPoint)roundPoint:(CGPoint)point
{
    return _myCGPointRound(point);
}

+(CGSize)roundSize:(CGSize)size
{
    return _myCGSizeRound(size);
}

+(CGRect)roundRect:(CGRect)rect
{
    return _myCGRectRound(rect);
}




@end

#endif

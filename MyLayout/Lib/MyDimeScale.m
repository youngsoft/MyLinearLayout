//
//  MyDimeScale.m
//  MyLayout
//
//  Created by oybq on 16/2/23.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyDimeScale.h"

#if TARGET_OS_IPHONE

extern CGFloat _myRoundNumber(CGFloat);
extern CGPoint _myRoundPoint(CGPoint);
extern CGSize _myRoundSize(CGSize);
extern CGRect _myRoundRect(CGRect);


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
    return _myRoundNumber(val * _rate);
}

+(CGFloat)scaleW:(CGFloat)val
{
    return _myRoundNumber(val * _wrate);
}

+(CGFloat)scaleH:(CGFloat)val
{
    return _myRoundNumber(val * _hrate);
}

+(CGFloat)roundNumber:(CGFloat)number
{
    return _myRoundNumber(number);
}

+(CGPoint)roundPoint:(CGPoint)point
{
    return _myRoundPoint(point);
}

+(CGSize)roundSize:(CGSize)size
{
    return _myRoundSize(size);
}

+(CGRect)roundRect:(CGRect)rect
{
    return _myRoundRect(rect);
}




@end

#endif

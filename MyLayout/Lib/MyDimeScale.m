//
//  MyDimeScale.m
//  MyLayout
//
//  Created by oybq on 16/2/23.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyDimeScale.h"

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

//保持缩放值精确到0.5
+(CGFloat)roundNumber:(CGFloat)num
{
    num += 0.49999;
    num *= 2;
    return floor(num) / 2.0;
}


+(CGFloat)scale:(CGFloat)val
{
    return [self roundNumber:val * _rate];
}

+(CGFloat)scaleW:(CGFloat)val
{
    return [self roundNumber:val * _wrate];
}

+(CGFloat)scaleH:(CGFloat)val
{
    return  [self roundNumber:val * _hrate];
}



@end

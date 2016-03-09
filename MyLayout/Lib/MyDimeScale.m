//
//  MyDimeScale.m
//  MyLayout
//
//  Created by apple on 16/2/23.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
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

+(CGFloat)scale:(CGFloat)val
{
    return val * _rate;
}

+(CGFloat)scaleW:(CGFloat)val
{
    return val * _wrate;
}

+(CGFloat)scaleH:(CGFloat)val
{
    return  val * _hrate;
}



@end

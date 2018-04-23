//
//  MyBorderline.h
//  MyLayout
//
//  Created by oubaiquan on 2017/8/23.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MyLayoutDef.h"


/**
 *布局的边界画线类，用于实现绘制布局的四周的边界线的功能。一个布局视图中提供了上下左右4个方向的边界画线类对象。
 */
@interface MyBorderline : NSObject


/**
 *边界线的颜色
 */
@property(nonatomic,strong) UIColor *color;

/**
 *边界线的厚度，默认是1,设置的值不能小于1. 单位是像素。
 */
@property(nonatomic,assign) CGFloat thick;

/**
 *边界线的头部缩进单位。比如某个布局视图宽度是100，头部缩进单位是20，那么边界线将从20的位置开始绘制。
 */
@property(nonatomic,assign) CGFloat headIndent;

/**
 *边界线的尾部缩进单位。比如某个布局视图宽度是100，尾部缩进单位是20，那么边界线将绘制到80的位置结束。
 */
@property(nonatomic, assign) CGFloat tailIndent;

/**
 *设置边界线为点划线,如果是0则边界线是实线
 */
@property(nonatomic, assign) CGFloat dash;

/**
 *边界线绘制时的偏移量
 */
@property(nonatomic, assign) CGFloat offset;



-(instancetype)initWithColor:(UIColor*)color;

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick;

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick headIndent:(CGFloat)headIndent tailIndent:(CGFloat)tailIndent;

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick headIndent:(CGFloat)headIndent tailIndent:(CGFloat)tailIndent offset:(CGFloat)offset;


@end




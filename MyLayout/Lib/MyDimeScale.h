//
//  MyDimeScale.h
//  MyLayout
//
//  Created by oybq on 16/2/23.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *一个用于计算位置和尺寸在不同设备屏幕下缩放比例的辅助类，用于实现不同大小设备屏幕之间的位置和尺寸的适配。
 *比如某个视图的宽度在iPhone6下是100，那么在iPhone6+上大概应该是110，而在iPhone5下则大概应该是85。
 */
@interface MyDimeScale : NSObject

/**
 *指定UI设计原型图所用的设备尺寸。请在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法的开始处调用这个方法，比如当UI设计人员用iPhone6作为界面的原型尺寸则将size设置为375,667。
 */
+(void)setUITemplateSize:(CGSize)size;

/**
 *返回屏幕尺寸缩放的比例
 */
+(CGFloat)scale:(CGFloat)val;

/**
 *返回屏幕宽度缩放的比例
 */
+(CGFloat)scaleW:(CGFloat)val;

/**
 *返回屏幕高度缩放的比例
 */
+(CGFloat)scaleH:(CGFloat)val;

@end

#define MYDIMESCALE(val)   ([MyDimeScale scale:val])
#define MYDIMESCALEW(val)  ([MyDimeScale scaleW:val])
#define MYDIMESCALEH(val)  ([MyDimeScale scaleH:val])

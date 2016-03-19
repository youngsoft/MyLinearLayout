//
//  MyDimeScale.h
//  MyLayout
//
//  Created by apple on 16/2/23.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**一个简单的用于计算不同屏幕的伸缩尺寸的辅助类，用于实现不同大小屏幕之间的位置和尺寸的适配**/
@interface MyDimeScale : NSObject

//请在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions函数中
//设置你的UI设计人员设计的图片的尺寸的点数，如果用iPhone6的设备制作的UI图则size设置为375,667
+(void)setUITemplateSize:(CGSize)size;


+(CGFloat)scale:(CGFloat)val;  //返回对角线缩放的比例

+(CGFloat)scaleW:(CGFloat)val;  //返回宽度缩放的比例

+(CGFloat)scaleH:(CGFloat)val;  //返回高度缩放的比例

@end


#define MYDIMESCALE(val)   ([MyDimeScale scale:val])
#define MYDIMESCALEW(val)  ([MyDimeScale scaleW:val])
#define MYDIMESCALEH(val)  ([MyDimeScale scaleH:val])

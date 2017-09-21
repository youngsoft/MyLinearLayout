//
//  UIColor+MyLayout.h
//  MyLayout
//
//  Created by 吴斌 on 2017/9/9.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (MyLayout)

/**
 从十六进制或者系统自带字符串创建并返回一个颜色对象
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA red blue .....

 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88" , @"red" , @"blue"
 
 @param hexStr  颜色值
 
 @return        来自字符串的UIColor对象，如果发生错误，则为nil
 */
+ (nullable UIColor *)myColorWithHexString:(NSString *_Nonnull)hexStr;


/**
 不透明
 RGB 颜色值
 @return 十六进制
 */
- (nullable NSString *)hexString;

/**
 透明
 RGB 颜色值
 @return 十六进制
 */
- (nullable NSString *)hexStringWithAlpha;

@end

@interface NSString (MyLayout)


/**
 判断是否是非空

 @return YES 非空 NO 为空
 */
- (BOOL)myIsNotBlank;



/**
 去除两边空格

 @return 过滤后的字符串
 */
- (NSString *)myRemoveStringByTrimSpace;

@end

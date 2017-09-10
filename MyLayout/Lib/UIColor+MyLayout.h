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
+ (nullable UIColor *)layoutColorWithHexString:(NSString *_Nullable)hexStr;



@end

@interface NSString (MyLayout)

- (BOOL)isNotBlank;

@end

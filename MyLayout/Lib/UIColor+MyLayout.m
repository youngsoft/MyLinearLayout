//
//  UIColor+MyLayout.m
//  MyLayout
//
//  Created by 吴斌 on 2017/9/9.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "UIColor+MyLayout.h"

@implementation UIColor (MyLayout)

static inline NSUInteger myHexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL myHexStrToRGBA(NSString *str,
                           CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [str uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = myHexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = myHexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = myHexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = myHexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = myHexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = myHexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = myHexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = myHexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

static NSDictionary*  createColors()
{
    NSDictionary *colors = @{
                             @"black":UIColor.blackColor,
                             @"darkgray":UIColor.darkGrayColor,
                             @"lightgray":UIColor.lightGrayColor,
                             @"white":UIColor.whiteColor,
                             @"gray":UIColor.grayColor,
                             @"red":UIColor.redColor,
                             @"green":UIColor.greenColor,
                             @"cyan":UIColor.cyanColor,
                             @"yellow":UIColor.yellowColor,
                             @"magenta":UIColor.magentaColor,
                             @"orange":UIColor.orangeColor,
                             @"purple":UIColor.purpleColor,
                             @"brown":UIColor.brownColor,
                             @"clear":UIColor.clearColor
                             };
    
    return colors;
}



+ (nullable UIColor *)myColorWithHexString:(NSString *_Nonnull)hexStr
{
    
    NSString *temp = hexStr.lowercaseString;
    UIColor *color = [createColors() objectForKey:temp];
    if (color != nil) {
        return  color;
    }
    CGFloat r, g, b, a;
    if (myHexStrToRGBA(temp, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

@end



@implementation NSString (MyLayout)

- (BOOL)myIsNotBlank
{
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) return NO;
    
    return YES;
}

@end

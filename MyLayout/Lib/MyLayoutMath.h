//
//  MyLayoutMath.h
//  MyLayout
//
//  Created by oubaiquan on 2017/8/29.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

extern BOOL _myCGFloatErrorEqual(CGFloat f1, CGFloat f2, CGFloat error);
extern BOOL _myCGFloatErrorNotEqual(CGFloat f1, CGFloat f2, CGFloat error);

extern BOOL _myCGFloatLess(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatGreat(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatNotEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatLessOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGFloatGreatOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _myCGSizeEqual(CGSize sz1, CGSize sz2);
extern BOOL _myCGPointEqual(CGPoint pt1, CGPoint pt2);
extern BOOL _myCGRectEqual(CGRect rect1, CGRect rect2);

extern CGFloat _myCGFloatRound(CGFloat f);
extern CGRect _myCGRectRound(CGRect rect);
extern CGSize _myCGSizeRound(CGSize size);
extern CGPoint _myCGPointRound(CGPoint point);
extern CGRect _myLayoutCGRectRound(CGRect rect);

extern CGFloat _myCGFloatMax(CGFloat a, CGFloat b);
extern CGFloat _myCGFloatMin(CGFloat a, CGFloat b);

//a*b + c
extern CGFloat _myCGFloatFma(CGFloat a, CGFloat b, CGFloat c);

/**
 * 定义优先级
 */
typedef enum : short {
    MyPriority_Low = 0,
    MyPriority_Normal = 500, //默认值。
    MyPriority_High = 1000,
} MyPriority;

//内部使用先放在这里。后续再移到合适位置。
typedef enum : unsigned char {
    MyLayoutValType_Nil,
    MyLayoutValType_Number,
    MyLayoutValType_LayoutSize,
    MyLayoutValType_LayoutPos,
    MyLayoutValType_Array,
    MyLayoutValType_UILayoutSupport,
    MyLayoutValType_SafeArea,
    MyLayoutValType_Most,
    MyLayoutValType_LayoutAnchorClone,
    MyLayoutValType_Fill,
    MyLayoutValType_Wrap,
} MyLayoutValType;


//位置尺寸类型
typedef enum : unsigned short {
    MyLayoutAnchorType_Width = 1|2|4,
    MyLayoutAnchorType_Height = (1|2|4)<<8,
    MyLayoutAnchorType_Leading = 32,
    MyLayoutAnchorType_Trailing = 64,
    MyLayoutAnchorType_Top = 1<<8,
    MyLayoutAnchorType_Bottom = 4<<8,
    MyLayoutAnchorType_CenterX = 2,
    MyLayoutAnchorType_CenterY = 2<<8,
    MyLayoutAnchorType_Baseline = 32<<8,
    MyLayoutAnchorType_HorzMask = 0xFF00,
    MyLayoutAnchorType_VertMask = 0x00FF
} MyLayoutAnchorType;

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

//
//  MyLayoutMeasure.h
//  MyLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyLayoutSizeClass.h"


//视图在布局中的评估测量值
@interface MyLayoutMeasure : NSObject

@property(nonatomic, assign) CGFloat leftPos;
@property(nonatomic, assign) CGFloat rightPos;
@property(nonatomic, assign) CGFloat topPos;
@property(nonatomic, assign) CGFloat bottomPos;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, weak) UIView *sizeClass;


-(void)reset;

@property(nonatomic,assign) CGRect frame;

@end

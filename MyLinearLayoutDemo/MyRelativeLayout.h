//
//  MyRelativeLayout.h
//  MyLinearLayoutDemo
//
//  Created by fzy on 15/7/1.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyLayoutBase.h"

/*相对位置对象*/
@interface MyRelativePos : NSObject

//偏移
-(MyRelativePos* (^)(CGFloat val))offset;

//NSNumber, MyRelativePos对象,如果是centerXPos或者centerYPos则可以传NSArray，数组里面里面也必须是centerXPos，表示指定的视图数组
//在父视图中居中，比如： A.centerXPos.equalTo(@[B.centerXPos.offset(20)].offset(20)
//表示A和B在父视图中居中往下偏移20，B在A的右边，间隔20。
-(MyRelativePos* (^)(id val))equalTo;

@end

/*相对尺寸对象*/
@interface MyRelativeDime : NSObject

//乘
-(MyRelativeDime* (^)(CGFloat val))multiply;
//加,用这个和equalTo的数组功能可以实现均分子视图宽度以及间隔的设定。
-(MyRelativeDime* (^)(CGFloat val))add;


//NSNumber, MyRelativeDime以及MyRelativeDime数组，数组的概念就是所有数组里面的子视图的尺寸平分父视图的尺寸。
-(MyRelativeDime* (^)(id val))equalTo;


@end


@interface UIView(MyRelativeLayoutEx)

//位置
@property(nonatomic, readonly)  MyRelativePos *leftPos;
@property(nonatomic, readonly)  MyRelativePos *topPos;
@property(nonatomic, readonly)  MyRelativePos *rightPos;
@property(nonatomic, readonly)  MyRelativePos *bottomPos;
@property(nonatomic, readonly)  MyRelativePos *centerXPos;
@property(nonatomic, readonly)  MyRelativePos *centerYPos;


//尺寸
@property(nonatomic, readonly)  MyRelativeDime *widthDime;
@property(nonatomic, readonly)  MyRelativeDime *heightDime;



@end

//如何让某几个视图成组。形成一个虚拟视图。先查找


/*相对布局视图，里面的所有子视图都需要指定位置和尺寸的依赖关系*/
@interface MyRelativeLayout : MyLayoutBase


//高度由子视图决定,默认都是NO,如果设置了这个属性为YES则要求里面的子视图不能依赖于布局的尺寸和右边和下边位置
@property(nonatomic, assign) BOOL wrapContentWidth;
@property(nonatomic, assign) BOOL wrapContentHeight;
@property(nonatomic, assign) BOOL wrapContent;  //上面两个的整体设置


//如果布局的父视图是UIScrollView或者子类则在布局的位置调整后是否调整滚动视图的contentsize,默认是NO
//这个属性适合与整个布局作为滚动视图的唯一子视图来使用。
@property(nonatomic, assign, getter = isAdjustScrollViewContentSize) BOOL adjustScrollViewContentSize;



//均分宽度时当有隐藏子视图，是否参与宽度计算,这个属性只有在参与均分视图的子视图隐藏时才有效,默认是NO
@property(nonatomic, assign) BOOL flexOtherViewWidthWhenSubviewHidden;

//均分高度时当有隐藏子视图，是否参与高度计算,这个属性只有在参与均分视图的子视图隐藏时才有效，默认是NO
@property(nonatomic, assign) BOOL flexOtherViewHeightWhenSubviewHidden;





@end

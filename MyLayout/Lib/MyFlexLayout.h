//
//  MyFlexLayout.h
//  MyLayout
//
//  Created by oubaiquan on 2019/8/30.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import "MyFlowLayout.h"

//定义flex的方向类型。
typedef int MyFlexDirection;
//定义flex的换行类型。
typedef int MyFlexWrap;
//定义flex的停靠对齐类型。
typedef int MyFlexGravity;


@interface MyFlexItem:NSObject

//因为auto是C语言关键字不能直接使用，所以这里加一个_前缀。
@property(class, readonly, assign) CGFloat _auto;


//条目的顺序设置
-(MyFlexItem* (^)(NSInteger))order;
//条目的尺寸比重设置，默认为0表示不按比重
-(MyFlexItem* (^)(CGFloat))flex_grow;
//条目的压缩比重设置，默认为1，表示当会进行压缩
-(MyFlexItem* (^)(CGFloat))flex_shrink;
//条目的尺寸设置，可以设置为_auto,固定值,相对值。你可以使用这个属性也可以通过width/height来设置。
-(MyFlexItem* (^)(CGFloat))flex_basis;
//行内条目自身的对齐方式。
-(MyFlexItem* (^)(MyFlexGravity))align_self;

//设置具体的宽度值，当宽度值大于0小于1是表明的是相对宽度，你也可以设置MyLayoutSize.wrap和MyLayoutSize.fill来设置特殊宽度。
-(MyFlexItem* (^)(CGFloat))width;
-(MyFlexItem* (^)(CGFloat))height;
//条目的外间距设置。
-(MyFlexItem* (^)(CGFloat))margin_top;
-(MyFlexItem* (^)(CGFloat))margin_bottom;
-(MyFlexItem* (^)(CGFloat))margin_left;
-(MyFlexItem* (^)(CGFloat))margin_right;
-(MyFlexItem* (^)(CGFloat))margin;


-(__kindof UIView* (^)(UIView*))addTo;

@property(nonatomic, weak, readonly) __kindof UIView *view;

@end

@class MyFlexLayout;

@interface MyFlex:MyFlexItem

//方向枚举
@property(class, readonly, assign) MyFlexDirection row;
@property(class, readonly, assign) MyFlexDirection row_reverse;
@property(class, readonly, assign) MyFlexDirection column;
@property(class, readonly, assign) MyFlexDirection column_reverse;

//换行枚举
@property(class, readonly, assign) MyFlexWrap nowrap;
@property(class, readonly, assign) MyFlexWrap wrap;
@property(class, readonly, assign) MyFlexWrap wrap_reverse;

//停靠对齐枚举
@property(class, readonly, assign) MyFlexGravity flex_start;
@property(class, readonly, assign) MyFlexGravity flex_end;
@property(class, readonly, assign) MyFlexGravity center;
@property(class, readonly, assign) MyFlexGravity space_between;
@property(class, readonly, assign) MyFlexGravity sapce_around;
@property(class, readonly, assign) MyFlexGravity baseline;
@property(class, readonly, assign) MyFlexGravity stretch;



//方向设置
-(MyFlex* (^)(MyFlexDirection))flex_direction;

//换行设置
-(MyFlex* (^)(MyFlexWrap))flex_wrap;

//通过 | 运算来结合 wrap 和direction
-(MyFlex* (^)(int))flex_flow;

//行的停靠设置
-(MyFlex* (^)(MyFlexGravity))justify_content;

//行内条目的对齐设置
-(MyFlex* (^)(MyFlexGravity))align_items;

//整体的停靠设置
-(MyFlex* (^)(MyFlexGravity))align_content;

//内边距设置
-(MyFlex* (^)(UIEdgeInsets))padding;
//条目之间的垂直和水平间距设置
-(MyFlex* (^)(CGFloat))vert_space;
-(MyFlex* (^)(CGFloat))horz_space;


@property(nonatomic, weak, readonly) MyFlexLayout *layout;

@end


@interface UIView(MyFlexLayout)

//我们可以借助视图的flexItem来设置当视图在flexbox中的一些属性。
@property(nonatomic, readonly, strong) MyFlexItem *flexItem;

@end


/*
 * FlexLayout布局是为了兼容flexbox语法而建立了一个布局，它是从MyFlowLayout派生。在MyFlowLayout中也是支持类似flexbox的一些特性的
 * 但是它的属性和flexbox不兼容和一致，因此提供一个新的类MyFlexLayout来完全支持flexbox.
 */
@interface MyFlexLayout:MyFlowLayout

@property(nonatomic, readonly, strong, readonly) MyFlex *flex;

@end

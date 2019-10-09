//
//  MyFlexLayout.h
//  MyLayout
//
//  Created by oubaiquan on 2019/8/30.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import "MyFlowLayout.h"


@interface MyFlexItem:NSObject

+(CGFloat)auto;

-(MyFlexItem* (^)(NSInteger))order;
-(MyFlexItem* (^)(CGFloat))flex_grow;
-(MyFlexItem* (^)(CGFloat))flex_shrink;
-(MyFlexItem* (^)(CGFloat))flex_basis;
-(MyFlexItem* (^)(int))align_self;

//设置具体的宽度值，当宽度值大于0小于1是表明的是相对宽度，你也可以设置MyLayoutSize.wrap和MyLayoutSize.fill来设置特殊宽度。
-(MyFlexItem* (^)(CGFloat))width;
-(MyFlexItem* (^)(CGFloat))height;
-(MyFlexItem* (^)(CGFloat))margin_top;
-(MyFlexItem* (^)(CGFloat))margin_bottom;
-(MyFlexItem* (^)(CGFloat))margin_left;
-(MyFlexItem* (^)(CGFloat))margin_right;


-(__kindof UIView* (^)(UIView*))addTo;

@property(nonatomic, weak, readonly) __kindof UIView *view;

@end

@class MyFlexLayout;

@interface MyFlex:MyFlexItem

+(int)row;
+(int)row_reverse;
+(int)column;
+(int)column_reverse;

+(int)nowrap;
+(int)wrap;
+(int)wrap_reverse;

+(int)flex_start;
+(int)flex_end;
+(int)center;
+(int)space_between;
+(int)sapce_around;
+(int)baseline;
+(int)stretch;


-(MyFlex* (^)(int))flex_direction;

-(MyFlex* (^)(int))flex_wrap;

-(MyFlex* (^)(int))flex_flow;

-(MyFlex* (^)(int))justify_content;

-(MyFlex* (^)(int))align_items;

-(MyFlex* (^)(int))align_content;

-(MyFlex* (^)(UIEdgeInsets))padding;
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

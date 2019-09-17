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

@property(nonatomic, readonly, strong) MyFlexItem *flexItem;

@end

//row必须指定宽度如果没有则是和父视图等宽，如果没有指定高度则高度自适应。column则反之。
@interface MyFlexLayout:MyFlowLayout

@property(nonatomic, readonly, strong, readonly) MyFlex *flex;

@end

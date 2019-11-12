//
//  MyFlexLayout.h
//  MyLayout
//
//  Created by oubaiquan on 2019/8/30.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import "MyFlowLayout.h"


//定义flex的方向类型。
typedef enum : int {
    MyFlexDirection_Row,
    MyFlexDirection_Column,
    MyFlexDirection_Row_Reverse,
    MyFlexDirection_Column_Reverse
} MyFlexDirection;

//定义flex的换行类型
typedef enum : int {
    MyFlexWrap_NoWrap = 0,
    MyFlexWrap_Wrap = 4,
    MyFlexWrap_Wrap_Reverse = 12
}MyFlexWrap;

//定义flex的停靠对齐
typedef enum : int {
    MyFlexGravity_Flex_Start,
    MyFlexGravity_Flex_End,
    MyFlexGravity_Center,
    MyFlexGravity_Space_Between,
    MyFlexGravity_Space_Around,
    MyFlexGravity_Baseline,
    MyFlexGravity_Stretch
}MyFlexGravity;

extern const int MyFlex_Auto;


//条目的属性，用于条目视图的属性设置和获取。
@interface MyFlexItemAttrs:NSObject

@property(nonatomic, assign) NSInteger order;
@property(nonatomic, assign) CGFloat flex_grow;
@property(nonatomic, assign) CGFloat flex_shrink;
@property(nonatomic, assign) CGFloat flex_basis;
@property(nonatomic, assign) MyFlexGravity align_self;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat margin_top;
@property(nonatomic, assign) CGFloat margin_bottom;
@property(nonatomic, assign) CGFloat margin_left;
@property(nonatomic, assign) CGFloat margin_right;
@property(nonatomic, assign) MyVisibility visibility;

@end

@protocol MyFlexItemAttrsContainer

@property(nonatomic, strong, readonly) MyFlexItemAttrs *attrs;

@end




/*
  flexbox中项目的设置类。
 */
@interface MyFlexItem:NSObject<MyFlexItemAttrsContainer>

//您可以用链式语法进行属性设置，也可以直接通过属性赋值进行设置和获取。
@property(nonatomic, weak, readonly) __kindof UIView *view;

//条目的顺序设置
-(MyFlexItem* (^)(NSInteger))order;
//条目的尺寸比重设置，默认为0表示不按比重
-(MyFlexItem* (^)(CGFloat))flex_grow;
//条目的压缩比重设置，默认为1，表示当会进行压缩
-(MyFlexItem* (^)(CGFloat))flex_shrink;
//条目的尺寸设置，可以设置为MyFlex_Auto,固定值,相对值。你可以使用这个属性也可以通过width/height来设置。
-(MyFlexItem* (^)(CGFloat))flex_basis;
//行内条目自身的对齐方式。
-(MyFlexItem* (^)(MyFlexGravity))align_self;
//设置具体的宽度或高度值，当宽度值大于0小于1是表明的是相对宽度或高度，你也可以设置MyLayoutSize.wrap和MyLayoutSize.fill来设置特殊宽度或高度。
-(MyFlexItem* (^)(CGFloat))width;
-(MyFlexItem* (^)(CGFloat))min_width;
-(MyFlexItem* (^)(CGFloat))max_width;
-(MyFlexItem* (^)(CGFloat))height;
-(MyFlexItem* (^)(CGFloat))min_height;
-(MyFlexItem* (^)(CGFloat))max_height;

//条目的外间距设置。
-(MyFlexItem* (^)(CGFloat))margin_top;
-(MyFlexItem* (^)(CGFloat))margin_bottom;
-(MyFlexItem* (^)(CGFloat))margin_left;
-(MyFlexItem* (^)(CGFloat))margin_right;
-(MyFlexItem* (^)(CGFloat))margin;

//是否可见
-(MyFlexItem* (^)(MyVisibility))visibility;

//添加到父视图中
-(__kindof UIView* (^)(UIView*))addTo;

@end




//布局的属性，用于布局视图的属性设置和获取。
@interface MyFlexAttrs:MyFlexItemAttrs

@property(nonatomic, assign) MyFlexDirection flex_direction;
@property(nonatomic, assign) MyFlexWrap flex_wrap;
@property(nonatomic, assign) MyFlexGravity justify_content;
@property(nonatomic, assign) MyFlexGravity align_items;
@property(nonatomic, assign) MyFlexGravity align_content;
@property(nonatomic, assign) UIEdgeInsets padding;
@property(nonatomic, assign) CGFloat vert_space;
@property(nonatomic, assign) CGFloat horz_space;

@end

@protocol MyFlexAttrsContainer

@property(nonatomic, strong, readonly) MyFlexAttrs *attrs;

@end


/*
  flexbox的设置类。
 */
@interface MyFlex:MyFlexItem<MyFlexAttrsContainer>

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

@end






//条目视图在应用flexbox时的分类扩展，只有MyFlexLayout中的子视图才有用。
@interface UIView(MyFlexLayout)

//我们可以借助视图的flexItem来设置条目视图在弹性布局视图中的一些属性。
@property(nonatomic, readonly, strong) MyFlexItem *flexItem;

@end


/*
 * 弹性布局是为了兼容flexbox语法而建立了一个布局，它是从MyFlowLayout派生。在MyFlowLayout中也是支持类似flexbox的一些特性的
 * 因为它的属性和flexbox不兼容，所以提供一个新的类MyFlexLayout来完全支持flexbox.
 */
@interface MyFlexLayout:MyFlowLayout

//用于flexbox约束的设置。
@property(nonatomic, readonly, strong, readonly) MyFlex *flex;

@end

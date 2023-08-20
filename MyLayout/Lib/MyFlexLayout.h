//
//  MyFlexLayout.h
//  MyLayout
//
//  Created by oubaiquan on 2019/8/30.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import "MyFlowLayout.h"

/**定义flex的方向类型*/
typedef enum : int {
    /**横向从左到右排列（左对齐），默认的排列方式*/
    MyFlexDirection_Row,
    /**纵向排列*/
    MyFlexDirection_Column,
    /**反转横向排列（右对齐，从后往前排，最后一项排在最前面*/
    MyFlexDirection_Row_Reverse,
    /**反转纵向排列，从后往前排，最后一项排在最上面*/
    MyFlexDirection_Column_Reverse
} MyFlexDirection;

/**定义flex的换行类型*/
typedef enum : int {
    /**当子元素溢出父容器时不换行*/
    MyFlexWrap_NoWrap = 0,
    /**当子元素溢出父容器时自动换行*/
    MyFlexWrap_Wrap = 4,
    /**反转 wrap 排列*/
    MyFlexWrap_Wrap_Reverse = 12
} MyFlexWrap;

/**定义弹性盒以及条目的停靠对齐类型*/
typedef enum : int {
    /**开始位置对齐或停靠*/
    MyFlexGravity_Flex_Start,
    /**结束位置对齐或停靠*/
    MyFlexGravity_Flex_End,
    /**居中位置对齐或停靠*/
    MyFlexGravity_Center,
    /**拉伸行或者列之间的间距*/
    MyFlexGravity_Space_Between,
    /**拉伸行或者列之间的间距，头尾间距是其他间距的一半*/
    MyFlexGravity_Space_Around,
    /**基线对齐*/
    MyFlexGravity_Baseline,
    /**拉伸条目尺寸*/
    MyFlexGravity_Stretch
} MyFlexGravity;

/**默认自动值*/
extern const int MyFlex_Auto;

/**
 条目视图属性
 */
@protocol MyFlexItemAttrs

@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) CGFloat flex_grow;
@property (nonatomic, assign) CGFloat flex_shrink;
@property (nonatomic, assign) CGFloat flex_basis;
@property (nonatomic, assign) MyFlexGravity align_self;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

/**
 布局视图属性
 */
@protocol MyFlexBoxAttrs <MyFlexItemAttrs>

@property (nonatomic, assign) MyFlexDirection flex_direction;
@property (nonatomic, assign) MyFlexWrap flex_wrap;
@property (nonatomic, assign) MyFlexGravity justify_content;
@property (nonatomic, assign) MyFlexGravity align_items;
@property (nonatomic, assign) MyFlexGravity align_content;
@property (nonatomic, assign) NSInteger item_size;
@property (nonatomic, assign) UIEdgeInsets padding;
@property (nonatomic, assign) CGFloat vert_space;
@property (nonatomic, assign) CGFloat horz_space;

@end

#define MyFlexNew(cls, var) (var = cls.new).myFlex

@protocol MyFlexItem

@property (nonatomic, strong, readonly) id<MyFlexItemAttrs> attrs;
@property (nonatomic, weak, readonly) __kindof UIView *view;

/**
 视图的宽度设置，如果宽度设置为大于0小于1则表明是相对于父视图宽度的比重值，如果是MyLayoutSize.wrap则表明宽度自适应，如果是MyLayoutSize.fill则表明宽度和父视图相等，如果是MyLayoutSize.empty则表明不设置宽度值。 其他的值就是一个固定宽度值。
 */
- (id<MyFlexItem> (^)(CGFloat))width;

/**
 视图的宽度设置，percent表明占用父视图宽度的百分比值，inc表明在百分比值的基础上的增量值。
 */
- (id<MyFlexItem> (^)(CGFloat percent, CGFloat inc))width_percent;

/**
 最小宽度限制设置
 */
- (id<MyFlexItem> (^)(CGFloat))min_width;

/**
 最大宽度限制设置
 */
- (id<MyFlexItem> (^)(CGFloat))max_width;
/**
 视图的高度设置，如果高度设置为大于0小于1则表明是相对于父视图高度的比重值，如果是MyLayoutSize.wrap则表明高度自适应，如果是MyLayoutSize.fill则表明高度和父视图相等，如果是MyLayoutSize.empty则表明不设置高度值，其他的值就是一个固定高度值。
 */
- (id<MyFlexItem> (^)(CGFloat))height;

/**
 视图的高度设置，percent表明占用父视图高度的百分比值，inc表明在百分比值的基础上的增量值。
 */
- (id<MyFlexItem> (^)(CGFloat percent, CGFloat inc))height_percent;

/**
 最小高度限制设置
 */
- (id<MyFlexItem> (^)(CGFloat))min_height;

/**
 最大高度限制设置
 */
- (id<MyFlexItem> (^)(CGFloat))max_height;

//视图的外间距设置。
/**
 视图的顶部外间距设置
 */
- (id<MyFlexItem> (^)(CGFloat))margin_top;
/**
 视图的底部外间距设置
 */
- (id<MyFlexItem> (^)(CGFloat))margin_bottom;
/**
 视图的左边外间距设置
 */
- (id<MyFlexItem> (^)(CGFloat))margin_left;
/**
 视图的右边外间距设置
 */
- (id<MyFlexItem> (^)(CGFloat))margin_right;
/**
 视图的四周外间距设置
 */
- (id<MyFlexItem> (^)(CGFloat))margin;
/**
 视图的可视设置
 */
- (id<MyFlexItem> (^)(MyVisibility))visibility;

//添加到父视图中
- (__kindof UIView * (^)(UIView *))addTo;

//添加子视图
- (id<MyFlexItem> (^)(UIView *))add;

//添加条目
- (id<MyFlexItem> (^)(id<MyFlexItem>))addItem;

/**
 条目在弹盒中的排列顺序，值越大越往后排。
 */
- (id<MyFlexItem> (^)(NSInteger))order;
/**
 设置或检索弹性盒的扩展比率。默认值为0表示不扩展
 */
- (id<MyFlexItem> (^)(CGFloat))flex_grow;
/**
 设置或检索弹性盒的收缩比率。默认值为1表示当条目尺寸超过弹性盒尺寸后会进行压缩。值越大压缩比越大
 */
- (id<MyFlexItem> (^)(CGFloat))flex_shrink;
/**
 设置或检索弹性盒伸缩基准值。默认值为MyFlex_Auto表示由其他属性决定，如果值为大于0小于1则表示相对值，其他为一个固定的尺寸值。
 */
- (id<MyFlexItem> (^)(CGFloat))flex_basis;
/**
 设置或检索弹性盒子元素自身在侧轴（纵轴）方向上的对齐方式。可选值为：MyFlexGravity_Flex_Start | MyFlexGravity_Flex_End | MyFlexGravity_Center | MyFlexGravity_Baseline | MyFlexGravity_Stretch中的一个，默认值为MyFlex_Auto
 */
- (id<MyFlexItem> (^)(MyFlexGravity))align_self;

@end

@protocol MyFlexBox <MyFlexItem>

@property (nonatomic, strong) id<MyFlexBoxAttrs> attrs;

/**
 设置或检索伸缩盒对象的子元素在父容器中的位置。默认值：MyFlexDirection_Row
 */
- (id<MyFlexBox> (^)(MyFlexDirection))flex_direction;
/**
 设置或检索伸缩盒对象的子元素超出父容器时是否换行。默认值：MyFlexWrap_NoWrap
 */
- (id<MyFlexBox> (^)(MyFlexWrap))flex_wrap;
/**
 同时设置检索伸缩盒对象的子元素在父容器中的位置和伸缩盒对象的子元素超出父容器时是否换行。二者通过 | 运算进行组合
 */
- (id<MyFlexBox> (^)(int))flex_flow;
/**
 设置或检索弹性盒子元素在主轴（横轴）方向上的对齐方式。可选值为：MyFlexGravity_Flex_Start | MyFlexGravity_Flex_End | MyFlexGravity_Center | MyFlexGravity_Space_Between | MyFlexGravity_Space_Around 中的一个，默认值为MyFlexGravity_Flex_Start
 */
- (id<MyFlexBox> (^)(MyFlexGravity))justify_content;
/**
 设置或检索弹性盒子元素在侧轴（纵轴）方向上的对齐方式。可选值为：MyFlexGravity_Flex_Start | MyFlexGravity_Flex_End | MyFlexGravity_Center | MyFlexGravity_Baseline | MyFlexGravity_Stretch中的一个，默认值为MyFlexGravity_Flex_Start
 */
- (id<MyFlexBox> (^)(MyFlexGravity))align_items;
/**
 设置或检索弹性盒堆叠伸缩行的对齐方式。可选值为：MyFlexGravity_Flex_Start | MyFlexGravity_Flex_End | MyFlexGravity_Center | MyFlexGravity_Between | MyFlexGravity_Around | MyFlexGravity_Stretch中的一个，默认值为MyFlexGravity_Stretch
 */
- (id<MyFlexBox> (^)(MyFlexGravity))align_content;

/**
 指定主轴的子条目的数量。只有在flex_wrap设置为wrap时才有效。默认值是0表示会根据条目的尺寸自动进行换行。
 */
- (id<MyFlexBox> (^)(NSInteger))item_size;
/**
 指定布局视图中每页的条目数量。这个值必须是item_size的倍数。
 */
- (id<MyFlexBox> (^)(NSInteger))page_size;
/**
 指定布局会根据条目的尺寸自动排列，默认值是NO。
 */
- (id<MyFlexBox> (^)(BOOL))auto_arrange;

/**
 设置弹性盒的内边距
 */
- (id<MyFlexBox> (^)(UIEdgeInsets))padding;
/**
 设置弹性盒内所有条目视图之间的垂直间距
 */
- (id<MyFlexBox> (^)(CGFloat))vert_space;
/**
 设置弹性盒内所有条目视图之间的水平间距
 */
- (id<MyFlexBox> (^)(CGFloat))horz_space;

@end

@interface UIView (MyFlexLayout)

/**
 用于弹盒视图中的子视图的布局设置。
 */
@property (nonatomic, strong, readonly) id<MyFlexItem> myFlex;

@end

/*
 * 弹性布局是为了兼容flexbox语法而建立了一个布局，它是从MyFlowLayout派生。在MyFlowLayout中也是支持类似flexbox的一些特性的
 * 因为它的属性和flexbox不兼容，所以提供一个新的类MyFlexLayout来完全支持flexbox.
 */
@interface MyFlexLayout : MyFlowLayout

/**
 用于弹盒布局视图自身的布局设置
 */
@property (nonatomic, strong, readonly) id<MyFlexBox> myFlex;

@end

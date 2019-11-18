//
//  MyFlexItem.h
//  MyLayout
//
//  Created by oubaiquan on 2019/11/15.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyLayoutDef.h"


@protocol MyUIViewUI
@optional

//您可以用链式语法进行属性设置，也可以直接通过属性赋值进行设置和获取。
@property(nonatomic, weak, readonly) __kindof UIView *view;


/**
 视图的宽度设置，如果宽度设置为大于0小于1则表明是相对于父视图宽度的比重值，如果是MyLayoutSize.wrap则表明宽度自适应，如果是MyLayoutSize.fill则表明宽度和父视图相等，其他的值就是一个固定宽度值。
 */
-(id<MyUIViewUI> (^)(CGFloat))width;

/**
 最小宽度限制设置
 */
-(id<MyUIViewUI> (^)(CGFloat))min_width;

/**
 最大宽度限制设置
 */
-(id<MyUIViewUI> (^)(CGFloat))max_width;
/**
 视图的高度设置，如果高度设置为大于0小于1则表明是相对于父视图高度的比重值，如果是MyLayoutSize.wrap则表明高度自适应，如果是MyLayoutSize.fill则表明高度和父视图相等，其他的值就是一个固定高度值。
 */
-(id<MyUIViewUI> (^)(CGFloat))height;

/**
 最小高度限制设置
 */
-(id<MyUIViewUI> (^)(CGFloat))min_height;

/**
 最大高度限制设置
 */
-(id<MyUIViewUI> (^)(CGFloat))max_height;

//视图的外间距设置。
/**
 视图的顶部外间距设置
 */
-(id<MyUIViewUI> (^)(CGFloat))margin_top;
/**
 视图的底部外间距设置
 */
-(id<MyUIViewUI> (^)(CGFloat))margin_bottom;
/**
 视图的左边外间距设置
 */
-(id<MyUIViewUI> (^)(CGFloat))margin_left;
/**
 视图的右边外间距设置
 */
-(id<MyUIViewUI> (^)(CGFloat))margin_right;
/**
 视图的四周外间距设置
 */
-(id<MyUIViewUI> (^)(CGFloat))margin;
/**
 视图的可视设置
 */
-(id<MyUIViewUI> (^)(MyVisibility))visibility;

//视图特有的属性。
-(id<MyUIViewUI> (^)(CGAffineTransform))transform;
-(id<MyUIViewUI> (^)(BOOL))clipsToBounds;
-(id<MyUIViewUI> (^)(UIColor*))backgroundColor;
-(id<MyUIViewUI> (^)(CGFloat))alpha;
-(id<MyUIViewUI> (^)(NSInteger))tag;
-(id<MyUIViewUI> (^)(BOOL))userInteractionEnabled;
-(id<MyUIViewUI> (^)( UIColor *color,CGFloat width))border;
-(id<MyUIViewUI> (^)(CGFloat))cornerRadius;
-(id<MyUIViewUI> (^)(UIColor* color, CGSize offset, CGFloat radius))shadow;

//添加到父视图中
-(__kindof UIView* (^)(UIView*))addTo;

//添加子视图
-(id<MyUIViewUI> (^)(UIView*))add;

@end


@protocol MyUIViewUICategory

@property(nonatomic, strong, readonly) id<MyUIViewUI> myUI;

@end


@interface UIView(MyLayoutUI)<MyUIViewUICategory>
@end


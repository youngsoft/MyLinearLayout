//
//  MyGridLayout.h
//  MyLayout
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"
#import "MyGrid.h"



/**
 栅格布局，布局默认情况下就是一个行栅格。
 */
@interface MyGridLayout : MyBaseLayout<MyGrid>


+(id<MyGrid>)createTemplateGrid:(NSInteger)gridTag;

//删除布局下所有的子栅格
-(void)removeGrids;
-(void)removeGridsIn:(MySizeClass)sizeClass;


/**
 返回布局视图某个点所在的栅格

 @param point 点坐标
 @return 返回点所在的栅格。
 */
-(id<MyGrid>) gridHitTest:(CGPoint)point;


/**
 得到子视图所在的栅格

 @param subview 子视图
 @return 返回包含子视图的最顶部栅格。
 */
-(id<MyGrid>) gridContainsSubview:(UIView*)subview;


/**
 返回某个栅格包含的所有子视图

 @param grid 栅格
 @return 返回包含的子视图，如果没有则返回空数组
 */
-(NSArray<UIView*>*) subviewsContainedInGrid:(id<MyGrid>)grid;


/******************
 *下面一系列方法用于处理数据和栅格都从远端下发并且用来进行动态构建的机制
 *
 */

//将某个视图组绑定添加到某类栅格中去。并将这部分子视图对应到栅格的actionData上去。
-(void)addViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData to:(NSInteger)gridTag;


-(void)insertViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag;


/**
 替换指定标签下指定位置的视图组。如果没有指定的标签或者索引位置则会实现和addViewGroup相同的功能，

 @param viewGroup 要替换的视图组
 @param actionData 动作数据
 @param index 要替换的索引位置
 @param gridTag 标签
 */
-(void)replaceViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag;


/**
 移动视图组从一个标签到另外一个标签中

 @param index 视图组所在的标签的索引
 @param origGridTag 视图组索引所在的标签
 @param destGridTag 新视图组所在的标签
 */
-(void)moveViewGroupAtIndex:(NSUInteger)index from:(NSInteger)origGridTag to:(NSInteger)destGridTag;

-(void)moveViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)origGridTag  toIndex:(NSUInteger)index2 to:(NSInteger)destGridTag;


/**
 删除某个gridTag标签下指定索引位置的视图组

 @param index 视图组在gridTag标签下的位置索引
 @param gridTag 视图组所在的gridTag
 */
-(void)removeViewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag;



/**
 删除某个gridTag标签下的所有视图组

 @param gridTag gridTag标签
 */
-(void)removeViewGroupFrom:(NSInteger)gridTag;




/**
 交换两个tag之间两个位置索引下的视图组

 @param index1 tag标签1下的位置索引
 @param gridTag1 tag标签1
 @param index2 tag标签2下的位置索引
 @param gridTag2 tag标签2
 */
-(void)exchangeViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)gridTag1  withViewGroupAtIndex:(NSUInteger)index2 from:(NSInteger)gridTag2;





/**
 返回某个tag标签下的视图组的数量

 @param gridTag tag标签
 @return 返回某个tag标签下的视图组的数量
 */
-(NSUInteger)viewGroupCountOf:(NSInteger)gridTag;


/**
 返回某个tag标签中的某个索引位置下的视图组

 @param index 视图组位置索引
 @param gridTag tag标签
 @return 返回对应索引下的视图组，如果没有则返回nil
 */
-(NSArray<UIView*> *)viewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag;






/*
 栅格的描述。你可以用格子描述语言来建立格子
 
 @code
 
    {rows:[
 
 {size:100, size:"100%", size:"-20%",size:"wrap", size:"fill", padding:"{10,10,10,10}", space:10.0, gravity:@"top|bottom|left|right|centerX|centerY|width|height","top-borderline":{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1} },
 {},
 ]
 }
 
 @endcode
 
 */
@property(nonatomic, strong) NSDictionary *gridDictionary;

//主要为那些动态下发事件来服务。。通过给栅格布局设置总的处理target，而动态下发的只有action
@property(nonatomic, weak) id gridTarget;

@end

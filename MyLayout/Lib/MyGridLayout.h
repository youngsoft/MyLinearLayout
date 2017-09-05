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


//将某个视图组绑定添加到某类栅格中去。并将这部分子视图对应到栅格的actionData上去。
-(void)addViewGroup:(NSArray<UIView*> *)viewGroup toTag:(NSInteger)tag withActionData:(id)actionData;


-(NSArray<NSArray<UIView*> *> *)viewGroupArrayFromTag:(NSInteger)tag;


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

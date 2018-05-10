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
 栅格布局。栅格布局是一种将一个矩形的视图区域按行或者按列的方式划分为多个子区域，子区域根据布局的要求可以继续递归划分。栅格布局里面的子视图将按照添加的顺序依次填充到对应的叶子区域中去的布局方式。
 栅格布局通过一套自定义的布局体系来划分位置和尺寸，添加到栅格布局里面的子视图将不再需要指定位置和尺寸而是由栅格布局中的子栅格来完成，因此可以很很方便的调整布局结构，从而实现动态布局的能力。
 
 所谓栅格其实就是一个矩形区域，我们知道一个视图其实就是一个矩形区域，而子视图的frame属性其实就是父视图中的某个特定的子区域部分。既然子视图最终占据的是父视图的某个子矩形区域。那么我们也可以先将一个矩形区域按照某种规则分解为多个子矩形区域，然后再将子视图填充到对应的子矩形区域中去，这就是栅格布局的实现思想。
 
 */
@interface MyGridLayout : MyBaseLayout<MyGrid>


/**
 建立一个栅格模板，注意栅格模板不能添加到栅格布局中去，而应该采用clone的方法来将克隆的栅格添加到栅格布局中去

 @param gridTag 栅格模板的标签
 @return 返回一个模板栅格。
 */
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


/****************************************************************************************************************************
 *下面一系列方法用于处理数据和栅格都从远端下发并且用来进行动态构建的机制，我们称为视图组。一旦您开启了视图组的模式，那么用addSubview方法来构建的视图的顺序将无法得到保证。
 * 所谓视图组就是一组子视图的集合，如果给某个栅格设置了tag标签。然后通过下面的一系列方法，就可以将视图组里面的子视图依次填充到对应栅格标签下的子栅格里面。也就是将一个线性数组和树形结构的栅格进行了绑定处理，所谓绑定处理就是将线性的视图映射到树形的栅格中去。
 * 视图组和栅格布局标签的绑定是可以复用的，这种复用机制有点类似于UITableview的视图复用一样，只不过在这里是通过replaceViewGroup方法来实现的。
 ****************************************************************************************************************************/


/**
 将某个视图组绑定添加到某类栅格中去。并将这部分子视图对应到栅格的actionData上去。

 @param viewGroup 视图组，数组中的元素除了为视图外还可以为NSNull对象表示对应的位置并没有视图，这种场景主要用于某些栅格上的视图是可选的。
 @param actionData 如果视图组对应的栅格支持点击事件时可以获取到的动作数据，这个参数可以为nil
 @param gridTag 视图组对应的栅格的标签，也就是这个视图组会放入具有对应栅格标签的栅格里面。
 */
-(void)addViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData to:(NSInteger)gridTag;


/**
 将某个视图组绑定添加到某类栅格中去。并将这部分子视图对应到栅格的actionData上去。

 @param viewGroup 数组中的元素除了为视图外还可以为NSNull对象表示对应的位置并没有视图
 @param actionData 如果视图组对应的栅格支持点击事件时可以获取到的动作数据，这个参数可以为nil
 @param index 栅格标签内的视图组索引位置。
 @param gridTag 视图组对应的栅格的标签，也就是这个视图组会放入具有对应栅格标签的栅格里面
 */
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


/**
 移动视图组从一个标签到另外一个标签中

 @param index1 视图组所在的标签的索引
 @param origGridTag 视图组索引所在的标签
 @param index2 要移动到的目标标签内的索引
 @param destGridTag 要移动的目标标签
 */
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






/**
 栅格的字典描述。我们可以用addRow, addCol的方式来建立子栅格系统从而完成栅格的建立。我们也可以采用字典的方式来描述树形的栅格结构，并赋值给gridDictionary来实现栅格的建立和更新。因此您可以用这个属性来实现格式化语言描述的栅格的建立方法。下面是我们可以通过字典的方式来构造一个栅格系统的语法：

 @code
 
 {"rows | cols":[
     {"size":100 | "100%" | "-20%" | "wrap" | size:"fill",
      "padding":"{10,10,10,10}",
      "space":10.0,
      "gravity":@"top|bottom|left|right|centerX|centerY|width|height",
      "top-borderline":{"color":"#AAAAAA","thick":1.0, "head":1.0, "tail":1.0, "offset":1},
      "bottom-borderline":{},
      "left-borderline":{},
      "right-borderline":{},
      "tag":1000,
      "action":"handleClick:",
      "action-data":"any object",
      "placeholder":false,
      "anchor":false
     },
     {},
     ]
 }
 @endcode
 
 具体可以设置的key和value可以参考MyGrid.h头部定义的key和value的关键字。
 */
@property(nonatomic, strong) NSDictionary *gridDictionary;



/**
 主要为那些动态下发事件来服务。我们知道从服务器下发的JSON或者字典是不可能包含要执行事件的target的。因此我们可以通过给布局视图设置一个预先设置好的target来作为事件的执行者，这样就可以实现当某个栅格里面设置了action时可以用这个属性来指定这个action消息的接收者。
 */
@property(nonatomic, weak) id<NSObject> gridActionTarget;


@end

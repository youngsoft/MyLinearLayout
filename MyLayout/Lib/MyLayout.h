//
//  MyLayout.h
//  MyLayout
//
//  Created by oybq on 15/7/5.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//  Email:    obq0387_cn@sina.com
//  QQ:       156355113
//  QQ群:     178573773
//  Github:   https://github.com/youngsoft/MyLinearLayout
//  个人主页:  http://www.jianshu.com/users/3c9287519f58/latest_articles  http://blog.csdn.net/yangtiang
//
/*
 The MIT License (MIT)
 
 Copyright (c) 2015 YoungSoft
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

/*
 version1.2.3
 1.添加了新的布局：路径布局MyPathLayout。通过路径布局您只需要提供一个生成路径曲线的方程、以及指定子视图在路径曲线之中的距离等信息就可以让子视图按照指定的路径曲线进行布局，因此路径布局可以实现一些非常酷炫的效果。具体例子见：PLTest1,2,3,4ViewController
 2.添加了子视图的新方法:@property(nonatomic,copy) void (^viewLayoutCompleteBlock)(MyBaseLayout* layout, UIView *v); 这个方法是在每个子视图布局完成后会调用一次，然后自动销毁。您可以实现这个block来进行一些子视图布局完成后的设置，一般实现这个块用来完成一些特定的动画效果，以及取值操作。具体例子见RLTest1ViewController,PLTest1ViewController
 3.添加了对布局视图里面的子视图通过transform进行坐标变换的支持功能，在您对子视图进行坐标变换操作时，您可以可以通过设置扩展属性来确定子视图的尺寸和位置。具体能力见PLTest系列DEMO。
 4.完善了智能边界线的能力，如果您在布局视图中设置了subviewMargin属性的话，布局系统将会自动的将智能边界线一分为2.具体例子见TLTest3ViewController
 5.布局基类的属性：adjustScrollViewContentSize被设置为过期，改为通过adjustScrollViewContentSizeMode属性来设置当布局视图加入到UIScrollView时调整其contentSize的方式。
 6.修正了一个线性布局中当布局视图的尺寸没有子视图尺寸大，而子视图又设置了weight属性时可能导致的计算不正确的问题。
 
 */

/*
 version1.2.2
 1.流式布局MyFlowLayout中的子视图添加了对weight属性的支持，流式布局中的weight属性表示的是剩余空间的占比。通过weight属性的使用，我们可以在很多用线性布局实现的布局，改用流式布局来完成，从而减少布局的嵌套。流式布局具有HTML中的Flex的特性。具体例子见FLLTest4ViewController
 2.布局视图增加了子视图反序排列的功能属性：@property(nonatomic, assign) BOOL reverseLayout; 这个属性可以按子视图添加的逆顺序进行界面布局。具体例子见：AllTest4ViewController
 3.修正了浮动布局MyFloatLayout中weight计算的问题，由原先的减间距再乘比例改为先乘比例再减间距
 

 */


/*
  version1.2.1
    1. 修正了相对布局中子视图隐藏时，相关子视图重新排列布局可能导致不正确的问题。相对布局中子视图隐藏时其他视图重新排列布局的算法是：隐藏的子视图的尺寸设置为0，所以依赖隐藏的子视图的边距依赖无效，变为依赖隐藏子视图所依赖的边距。
    2. 垂直线性布局里面添加了A.heightDime.equalTo(A.widthDime)的支持。水平线性布局不支持。
    3.优化了代码结构，增加了代码的可读性。
 */
 
/*
   version1.2.0
    1. 修复了垂直线性布局中同时设置myLeftMargin,myRightMargin并且设置了gravity=MyMarginGravity_Horz_Center时前者设置失效的问题。水平线性布局亦然。
 */

/*
   version1.1.9
    1.增加了对国际化的支持。
 */

/*
   version1.1.8
 
 New:
   1.优化了表格布局MyTableLayout和智能边界线的结合的问题。(具体见：TLTest3ViewController)
   2. 增加了浮动布局MyFloatLayout设置浮动间距的方法setSubviewFloatMargin (具体见：FOLTest4ViewController）

 
 */

/*
  version1.1.7
 
 New:
 
  1.修改表格布局的addRow:colSize:以及insertRow:colSize:atIndex的方法名，将原来的colWidth改为了colSize。 (具体见：TLTest2ViewController)
  2.修改了表格布局的特殊尺寸的宏定义：MTLSIZE_XXXX  (具体见：TLTest1ViewController，TLTest2ViewController)
  3.为表格布局添加行间距:rowSpacing和列间距:colSpacing两个属性，用来设置表格的行和列之间的间距。 (具体见：TLTest2ViewController)
  4.为布局添加方法：layoutAnimationWithDuration用来实现布局时的动画效果。  (具体见：各个DEMO)
  5.扩展flexedHeight属性对于UIImageView的支持。当对一个UIImageView设置flexedHeight为YES时则其在布局时会自动根据UIImageView设置的宽度等比例缩放其高度。这个特性在瀑布流实现中非常实用。   (具体见：TLTest2ViewController)
  6.为浮动布局MyFloat提供subviewMargin、subviewVertMargin、subviewHorzMargin三个新属性，用来设置浮动布局中各视图的水平和垂直间距。 (具体见：FOLTest4ViewController，FOLTest5ViewController)
  7.为布局视图下的子视图的尺寸提供了设置最大尺寸以及最小尺寸的新功能，原先的MyLayoutDime中的min,max两个方法只能用来设置最小最大的常数值。MyLayoutDime新增加的方法lBound,uBound则功能更加强大。除了可以设置常数限制尺寸外，还可以设置对象限制尺寸。(具体见：AllTest2ViewController，AllTest3ViewController)
  8.对线性布局中的浮动间距进行优化，支持宽度自动调整的能力.(具体见：AllTest3ViewController)
  9.完善了将布局视图加入到非布局父视图时的位置和尺寸设置。您可以用myXXXMargin方法以及myHeight,myWidth方法设置其在非布局父视图上的位置和尺寸。
  10.系统自动处理了大部分可能出现布局约束冲突的地方，减少了约束冲突出现的可能性。以及出现了约束冲突时告警以及crash的提示。
  11.所有代码部分的注释重新编写，更加有利于大家的理解。
  12.重新编写了大部分的DEMO例子。
 
 Bug:
 1.修复了浮动布局加入到UIScrollview中不能自动固定的问题。
 2.修正了相对布局嵌套其他布局时，高度评估方法可能不正确的问题。
 3.修正了线性布局在计算高度和宽度时的一个问题。
 
 QA:
   1.在布局中，最容易出现约束冲突的情况是某个布局视图设置了wrapContentWidth或者wrapContentHeight，但是在加入到其他布局视图时又被动或者主动设置了明确的高度或者宽度这样导致的约束冲突最多。
 
 */



#ifndef MyLayout_MyLayout_h
#define MyLayout_MyLayout_h

#import "MyLayoutDef.h"
#import "MyDimeScale.h"
#import "MyLayoutPos.h"
#import "MyLayoutDime.h"
#import "MyLinearLayout.h"
#import "MyFrameLayout.h"
#import "MyRelativeLayout.h"
#import "MyTableLayout.h"
#import "MyFlowLayout.h"
#import "MyFloatLayout.h"
#import "MyPathLayout.h"
#import "MyMaker.h"

#endif

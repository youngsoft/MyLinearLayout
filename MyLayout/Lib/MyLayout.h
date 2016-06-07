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
#import "MyMaker.h"

#endif

[![Version](https://img.shields.io/cocoapods/v/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![License](https://img.shields.io/cocoapods/l/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Platform](https://img.shields.io/cocoapods/p/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Support](https://img.shields.io/badge/support-iOS%205%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Weibo](https://img.shields.io/badge/Sina微博-@欧阳大哥2013-yellow.svg?style=flat)](http://weibo.com/1411091507)
[![QQ](https://img.shields.io/badge/QQ-156355113-yellow.svg?style=flat)]()
[![GitHub stars](https://img.shields.io/github/stars/youngsoft/MyLinearLayout.svg)](https://github.com/youngsoft/MyLinearLayout/stargazers)

#MyLayout(2016.10.27)

#### MyLayout的Swift版本叫：[TangramKit](https://github.com/youngsoft/TangramKit)

#### English : [Introduction](README.md)

##功能介绍
---
   一套功能强大的iOS界面布局库，他不是在AutoLayout的基础上进行的封装，而是一套基于对frame属性的设置，并通过重载layoutSubview函数来实现对子视图进行布局的布局框架。因此可以无限制的运行在任何版本的iOS系统中。其设计思想以及原理则参考了Android的布局体系和iOS自动布局以及SizeClass的功能，通过提供的：**线性布局MyLinearLayout**、**相对布局MyRelativeLayout**、**框架布局MyFrameLayout**、**表格布局MyTableLayout**、**流式布局MyFlowLayout**、**浮动布局MyFloatLayout**、**路径布局MyPathLayout**七个布局类，以及对**SizeClass**的支持，来完成对界面的布局。MyLayout具有功能强大、简单易用、几乎不用设置任何约束、可以完美适配各种尺寸的屏幕等优势。具体的使用方法请看Demo中的演示代码以及到我的CSDN主页中了解：
   
[http://blog.csdn.net/yangtiang/article/details/46483999](http://blog.csdn.net/yangtiang/article/details/46483999)   线性布局  
[http://blog.csdn.net/yangtiang/article/details/46795231](http://blog.csdn.net/yangtiang/article/details/46795231)   相对布局  
[http://blog.csdn.net/yangtiang/article/details/46492083](http://blog.csdn.net/yangtiang/article/details/46492083)   框架布局  
[http://blog.csdn.net/yangtiang/article/details/48011431](http://blog.csdn.net/yangtiang/article/details/48011431) 表格布局  
[http://blog.csdn.net/yangtiang/article/details/50652946](http://blog.csdn.net/yangtiang/article/details/50652946) 流式布局  
[http://www.jianshu.com/p/0c075f2fdab2](http://www.jianshu.com/p/0c075f2fdab2) 浮动布局

###你也可以加入到QQ群：*178573773* 或者添加个人QQ：*156355113* 或者邮件：*obq0387_cn@sina.com* 联系我。###



## 演示效果图
---

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo1.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo2.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo3.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo4.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo5.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo6.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo7.gif)



### 线性布局MyLinearLayout
---
线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单列(单行)布局视图，因此里面的子视图是通过添加的顺序建立约束和依赖关系的。 子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而子视图从左到右依次排列的线性布局视图则称为水平线性布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/ll.png)

示例代码:

```objective-c
MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
rootLayout.wrapContentWidth = YES;
rootLayout.subviewMargin = 10;

UIView *A = [UIView new];
A.myLeftMargin = A.myRightMargin = 5;
A.myHeight = 40;
[rootLayout addSubview:A];

UIView *B = [UIView new];
B.myLeftMargin = 20;
B.myWidth = B.myHeight = 40;
[rootLayout addSubview:B];

UIView *C = [UIView new];
C.myRightMargin = 40;
C.myWidth = 50;
C.myHeight = 40;
[rootLayout addSubview:C];

UIView *D = [UIView new];
D.myLeftMargin = D.myRightMargin = 10;
D.myHeight = 40;
[rootLayout addSubview:D];

```

**MyLinearLayout的功能等价于Android的LinearLayout和iOS的UIStackView**


### 相对布局MyRelativeLayout
---
相对布局是一种里面的子视图通过相互之间的约束和依赖来进行布局和定位的布局视图。相对布局里面的子视图的布局位置和添加的顺序无关，而是通过设置子视图的相对依赖关系来进行定位和布局的。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/rl.png)

示例代码:

```objective-c
MyRelativeLayout *rootLayout = [MyRelativeLayout new];
rootLayout.wrapContentWidth = YES;
rootLayout.wrapContentHeight = YES;

UIView *A = [UIView new];
A.leftPos.equalTo(@20)
A.topPos.equalTo(@20);
A.widthDime.equalTo(@40);
A.heightDime.equalTo(A.widthDime);
[rootLayout addSubview:A];

UIView *B = [UIView new];
B.leftPos.equalTo(A.centerXPos);
B.topPos.equalTo(A.bottomPos);
B.widthDime.equalTo(@60);
B.heightDime.equalTo(A.heightDime);
[rootLayout addSubview:B];

UIView *C = [UIView new];
C.leftPos.equalTo(B.rightPos);
C.widthDime.equalTo(@40);
C.heightDime.equalTo(B.heightDime).multiply(0.5);
[rootLayout addSubview:C];

UIView *D = [UIView new];
D.bottomPos.equalTo(C.topPos);
D.rightPos.equalTo(@20);
D.heightDime.equalTo(A.heightDime);
D.widthDime.equalTo(D.heightDime);
[rootLayout addSubview:D];

UIView *E = [UIView new];
E.centerYPos.equalTo(@0);
E.heightDime.equalTo(@40);
E.widthDime.equalTo(rootLayout.widthDime);
[rootLayout addSubview:E];
//...F,G

```
**MyRelativeLayout的功能等价于Android的RelativeLayout和iOS的AutoLayout**


### 框架布局MyFrameLayout
---
框架布局是一种里面的子视图停靠在父视图特定方位并且可以重叠的布局视图。框架布局里面的子视图的布局位置和添加的顺序无关，只跟父视图建立布局约束依赖关系。框架布局将垂直方向上分为上、中、下三个方位，而水平方向上则分为左、中、右三个方位，任何一个子视图都只能定位在垂直方向和水平方向上的一个方位上。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fl.png)

示例代码:

```objective-c
  MyFrameLayout *rootLayout = [MyFrameLayout new];
  rootLayout.mySize = CGSizeMake(500,500);
  
  UIView *A = [UIView new];
  A.mySize = CGSizeMake(40,40);
  A.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Top;
  [rootLayout addSubview:A];
  
  UIView *B = [UIView new];
  B.mySize = CGSizeMake(40,40);
  B.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Top;
  [rootLayout addSubview:B];
  
  UIView *C = [UIView new];
  C.mySize = CGSizeMake(40,40);
  C.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Center;
  [rootLayout addSubview:C];

  UIView *D = [UIView new];
  D.mySize = CGSizeMake(40,40);
  D.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Center;
  [rootLayout addSubview:D];
  
  //..E，F,G
  
```

**MyFrameLayout的功能等价于Android的FrameLayout**



### 表格布局MyTableLayout
---
表格布局是一种里面的子视图可以像表格一样多行多列排列的布局视图。子视图添加到表格布局视图前必须先要建立并添加行视图，然后再将子视图添加到行视图里面。如果行视图在表格布局里面是从上到下排列的则表格布局为垂直表格布局，垂直表格布局里面的子视图在行视图里面是从左到右排列的；如果行视图在表格布局里面是从左到右排列的则表格布局为水平表格布局，水平表格布局里面的子视图在行视图里面是从上到下排列的。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/tl.png)

示例代码:

```objective-c
  MyTableLayout *rootLayout = [MyTableLayout tableLayoutWithOrientation:MyLayoutViewOrientation_Vert];
  rootLayout.myWidth = 500;
  
  [rootLayout addRow:MTLSIZE_WRAPCONTENT colSize:MTLSIZE_MATCHPARENT];
  
  UIView *A = [UIView new];
  A.mySize = CGSizeMake(50,40);
  [rootLayout addSubview:A];
  
  UIView *B = [UIView new];
  B.mySize = CGSizeMake(100,40);
  [rootLayout addSubview:B];
  
  UIView *C = [UIView new];
  C.mySize = CGSizeMake(30,40);
  [rootLayout addSubview:C];
  
  [rootLayout addRow:MTLSIZE_WRAPCONTENT colSize:MTLSIZE_MATCHPARENT];
  
   UIView *D = [UIView new];
  D.mySize = CGSizeMake(180,40);
  [rootLayout addSubview:D];
  
  //...E,F  
  
  
```

**MyTableLayout的功能等价于Android的TableLayout和HTML中的table元素**


### 流式布局MyFlowLayout
---
流式布局是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一行再重新排列的多行展示的布局视图。这里的约束限制主要有数量约束限制和内容尺寸约束限制两种，而换行的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些子视图有规律排列的场景，在某种程度上可以作为UICollectionView的替代品。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fll.png)

示例代码:

```objective-c
   MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
   rootLayout.wrapContentHeight = YES;
   rootLayout.myWidth = 300;
   rootLayout.averageArrange = YES;
   rootLayout.subviewMargin = 10;
   
   for (int i = 0; i < 10; i++)
   {
       UIView *A = [UIView new];
       A.heightDime.equalTo(A.widhtDime);
       [rootLayout addSubview:A];
   }
   
   

```

**MyFlowLayout的功能等价于CSS3中的flexbox**

	
### 浮动布局MyFloatLayout
---
浮动布局是一种里面的子视图按照约定的方向浮动停靠，当尺寸不足以被容纳时会自动寻找最佳的位置进行浮动停靠的布局视图。浮动布局的理念源于HTML/CSS中的浮动定位技术,因此浮动布局可以专门用来实现那些不规则布局或者图文环绕的布局。根据浮动的方向不同，浮动布局可以分为左右浮动布局和上下浮动布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/flo.png)

示例代码:

```objective-c
     MyFloatLayout *rootLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
     rootLayout.wrapContentHeight = YES;
     rootLayout.myWidth = 300;
     
     UIView *A = [UIView new];
     A.mySize = CGSizeMake(80,70);
     [rootLayout addSubview:A];
     
     UIView *B = [UIView new];
     B.mySize = CGSizeMake(150,40);
     [rootLayout addSubview:B];
     
     UIView *C = [UIView new];
     C.mySize = CGSizeMake(70,40);
     [rootLayout addSubview:C];
     
     UIView *D = [UIView new];
     D.mySize = CGSizeMake(140,140);
     [rootLayout addSubview:D];
     
     UIView *E = [UIView new];
     E.mySize = CGSizeMake(150,40);
     E.reverseFloat = YES;
     [rootLayout addSubview:E];

     UIView *F = [UIView new];
     F.mySize = CGSizeMake(140,60);
     [rootLayout addSubview:F];
     

```

**MyFloatLayout的功能等价于CSS中的float浮动定位**


### 路径布局MyPathLayout
---
路径布局是一种里面的子视图根据您提供的一条特定的曲线函数形成的路径来进行布局的布局视图。您需要提供一个实现曲线路径的函数、一个特定的坐标体系、一种特定的子视图在曲线上的距离设置这三个要素来实现界面布局。当曲线路径形成后，子视图将按相等的距离依次环绕着曲线进行布局。路径布局主要应用于那些具有特定规律的不规则排列，而且效果很酷炫的的界面布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/pl.png)

示例代码:
 
 ```objective-c
    MyPathLayout *rootLayout = [MyPathLayout new];
    rootLayout.mySize = CGSizeMake(400,400);
    rootLayout.coordinateSetting.origin = CGPointMake(0.5, 0.5);
        
    rootLayout.polarEquation = ^(CGFloat angle)
    {
       return 120 * (1 + cos(angle));
    };
    
    for (int i = 0; i < 4; i++)
   {
       UIView *A = [UIView new];
       A.mySize = CGSizeMake(40,40);
       [rootLayout addSubview:A];
   }
 
 ```
  
  **MyPathLayout的功能在iOS中独有**
  


###  SizeClass的支持
---
MyLayout布局体系为了实现对不同屏幕尺寸的设备进行适配，提供了对SIZECLASS的支持。您可以将SIZECLASS和上述的6种布局搭配使用，以便实现各种设备界面的完美适配。
	


## 使用方法
---

### 直接拷贝
1.  将github工程中的Lib文件夹下的所有文件复制到您的工程中。
2.  将`#import "MyLayout.h"` 头文件放入到您的pch文件中，或者在需要使用界面布局的源代码位置。

### CocoaPods安装

如果您还没有安装cocoapods则请先执行如下命令：
```
$ gem install cocoapods
```

为了用CocoaPods整合MyLayout到您的Xcode工程, 请建立如下的Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

pod 'MyLayout', '~> 1.2.6'
```
   
然后运行如下命令:

```
$ pod install
```



##版本历史
---
### V1.2.6版本新功能
 1. 优化代码，修复一个设置尺寸的uBound,lBound方法时可以指定其他任意视图的问题。
 2. 为了解决和Masonry两个库共存时，打开了Masonry的宏MAS_SHORTHAND_GLOBALS时造成offset, equalTo方法无法使用的问题，解决的方法是您可以在PCH或者在使用MyLayout.h之前定义：#define MY_USEPREFIXMETHOD 这个宏，这样所有MyLayoutPos, MyLayoutDime中的方法都增加了前缀my。 比如原来的A.leftPos.equalTo(@10) ==> A.leftPos.myEqualTo(@10)

### V1.2.5版本新功能
1. 优化了beginLayoutBlock和endLayoutBlock的调用时机，以及解决了可能这两个block块会出现循环引用的问题，同时优化了viewLayoutCompleteBlock可能会出现循环引用的问题
    2. 修复了布局视图隐藏属性hidden设置时可能会出现的布局的问题，尤其是当布局视图作为相对布局视图里面的子视图时。

### V1.2.4版本新功能
 1. 浮动布局MyFloatLayout增加了新属性noBoundaryLimit，用来实现那些只要单向浮动且没有边界限制的场景。具体例子见FOLTest6ViewController。
   2. 优化了布局方法estimateLayoutRect，优化了那些布局套布局的尺寸的评估的计算方法，加快了对动态高度评估计算的速度。
   3. 添加了2个DEMO，一个是RLTest4ViewController用来介绍布局在滚动条上滚动式停靠的实现。一个是FOLTest6ViewController用来介绍用浮动布局实现一些用户配置方面的DEMO。

###  V1.2.3版本新功能

1. 添加了新的布局：路径布局MyPathLayout。通过路径布局您只需要提供一个生成路径曲线的方程、以及指定子视图在路径曲线之中的距离等信息就可以让子视图按照指定的路径曲线进行布局，因此路径布局可以实现一些非常酷炫的效果。具体例子见：PLTest1,2,3,4ViewController
 2. 添加了子视图的新方法:@property(nonatomic,copy) void (^viewLayoutCompleteBlock)(MyBaseLayout* layout, UIView *v); 这个方法是在每个子视图布局完成后会调用一次，然后自动销毁。您可以实现这个block来进行一些子视图布局完成后的设置，一般实现这个块用来完成一些特定的动画效果，以及取值操作。具体例子见RLTest1ViewController,PLTest1ViewController
 3. 添加了对布局视图里面的子视图通过transform进行坐标变换的支持功能，在您对子视图进行坐标变换操作时，您可以可以通过设置扩展属性来确定子视图的尺寸和位置。具体能力见PLTest系列DEMO。
 4. 完善了智能边界线的能力，如果您在布局视图中设置了subviewMargin属性的话，布局系统将会自动的将智能边界线一分为2.具体例子见TLTest3ViewController
 5. 布局基类的属性：adjustScrollViewContentSize被设置为过期，改为通过adjustScrollViewContentSizeMode属性来设置当布局视图加入到UIScrollView时调整其contentSize的方式。
 6. 修正了一个线性布局中当布局视图的尺寸没有子视图尺寸大，而子视图又设置了weight属性时可能导致的计算不正确的问题。
 
### V1.2.2版本新功能
 1. 流式布局MyFlowLayout中的子视图添加了对weight属性的支持，流式布局中的weight属性表示的是剩余空间的占比。通过weight属性的使用，我们可以在很多用线性布局实现的布局，改用流式布局来完成，从而减少布局的嵌套。流式布局具有HTML中的Flex的特性。具体例子见FLLTest4ViewController
 2. 布局视图增加了子视图反序排列的功能属性：@property(nonatomic, assign) BOOL reverseLayout; 这个属性可以按子视图添加的逆顺序进行界面布局。具体例子见：AllTest4ViewController
 3. 修正了浮动布局MyFloatLayout中weight计算的问题，由原先的减间距再乘比例改为先乘比例再减间距

### V1.2.1版本新功能
1. 修正了相对布局中子视图隐藏时，相关子视图重新排列布局可能导致不正确的问题。相对布局中子视图隐藏时其他视图重新排列布局的算法是：隐藏的子视图的尺寸设置为0，所以依赖隐藏的子视图的边距依赖无效，变为依赖隐藏子视图所依赖的边距。
2. 垂直线性布局里面添加了A.heightDime.equalTo(A.widthDime)的支持。水平线性布局不支持。
3. 优化了代码结构，增加了代码的可读性。



### V1.2.0版本新功能
1. 修复了垂直线性布局中同时设置myLeftMargin,myRightMargin并且设置了gravity=MyMarginGravity_Horz_Center时前者设置失效的问题。水平线性布局亦然。


### V1.1.9版本新功能
1. 添加对国际化的支持。


### V1.1.8版本新功能
1. 优化了表格布局MyTableLayout和智能边界线的结合的问题。(具体见：TLTest3ViewController)
2. 增加了浮动布局MyFloatLayout设置浮动间距的方法setSubviewFloatMargin (具体见：FOLTest4ViewController）

### V1.1.7版本新功能
 1. 修改表格布局的addRow:colSize:以及insertRow:colSize:atIndex的方法名，将原来的colWidth改为了colSize。 (具体见：TLTest2ViewController)
 2. 修改了表格布局的特殊尺寸的宏定义：MTLSIZE_XXXX  (具体见：TLTest1ViewController，TLTest2ViewController)
 3. 为表格布局添加行间距:rowSpacing和列间距:colSpacing两个属性，用来设置表格的行和列之间的间距。 (具体见：TLTest2ViewController)
 4. 为布局添加方法：layoutAnimationWithDuration用来实现布局时的动画效果。  (具体见：各个DEMO)
 5. 扩展flexedHeight属性对于UIImageView的支持。当对一个UIImageView设置flexedHeight为YES时则其在布局时会自动根据UIImageView设置的宽度等比例缩放其高度。这个特性在瀑布流实现中非常实用。   (具体见：TLTest2ViewController)
 6. 为浮动布局MyFloat提供subviewMargin、subviewVertMargin、subviewHorzMargin三个新属性，用来设置浮动布局中各视图的水平和垂直间距。 (具体见：FOLTest4ViewController，FOLTest5ViewController)
 7. 为布局视图下的子视图的尺寸提供了设置最大尺寸以及最小尺寸的新功能，原先的MyLayoutDime中的min,max两个方法只能用来设置最小最大的常数值。MyLayoutDime新增加的方法lBound,uBound则功能更加强大。除了可以设置常数限制尺寸外，还可以设置对象限制尺寸。(具体见：AllTest2ViewController，AllTest3ViewController)
 8. 对线性布局中的浮动间距进行优化，支持宽度自动调整的能力.(具体见：AllTest3ViewController)
 9. 完善了将布局视图加入到非布局父视图时的位置和尺寸设置。您可以用myXXXMargin方法以及myHeight,myWidth方法设置其在非布局父视图上的位置和尺寸。
 10. 系统自动处理了大部分可能出现布局约束冲突的地方，减少了约束冲突出现的可能性。以及出现了约束冲突时告警以及crash的提示。
 11. 所有代码部分的注释重新编写，更加有利于大家的理解。
 12. 重新编写了大部分的DEMO例子。
 13. 修复了浮动布局加入到UIScrollview中不能自动固定的问题。
 14. 修正了相对布局嵌套其他布局时，高度评估方法可能不正确的问题。
 15. 修正了线性布局在计算高度和宽度时的一个问题。

### V1.1.6版本新功能
1.  MyLayoutDime类的equalTo方法添加可以等于自身的功能。比如`a.widthDime.equalTo(a.widthDime).add(10);` 表示视图a的最终宽度等于其本身内容的宽度再加上10. 这种设置方法不会造成循环引用，主要用于那些需要在自身内容尺寸基础上再扩展尺寸的场景，具体例子见： *FLLTest2ViewController*。
2.  流式布局MyFlowLayout中的内容填充布局为了解决每行内容的填充空隙问题，增加了拉伸间距，拉伸尺寸，以及自动排列三种功能。拉伸间距需要设置属性*gravity*的值为*MyMarginGravity_Horz_Fill*或者*MyMarginGravity_Vert_Fill*；拉伸尺寸需要设置属性*averageArrange*的值为YES；自动排列则需要设置属性autoArrange的值为YES。具体例子见*FLLTest2ViewController*。
3.  添加了新的视图扩展属性*noLayout*。这个属性设置为YES时表示子视图会参与布局，但是并不会真实的调整其在布局视图中的位置和尺寸，而布局视图则会保留出这个子视图的布局位置和尺寸的空间。这个属性和*useFrame*混合使用用来实现一些动画效果。具体例子见：*FLLTest3ViewController*。
4.  框架布局MyFrameLayout支持了wrapContentHeight和wrapContentWidth设置为YES的功能。
5.  布局视图添加新的属性*highlightedOpacity*，用来指定当布局Touch事件的高亮不透明度值。具体例子见：AllTest1ViewController。
6.  修正了MyTableLayout中的一个BUG。
7.  将布局库中的所有注释部分重新进行了格式化和调整。
8.  优化了布局中的一些性能问题。
9.  去掉了对过期代码的兼容性。

### V1.1.5版本新功能
1. 添加了新的布局 **浮动布局**，浮动布局实现不规则的子视图的排列，卡片布局。设计思想是从HTML中的CSS样式的float属性得到了。
2. 新增智能边界线的功能，通过智能边界线的设定，可以让布局中的子布局根据排版而自动生成边界线，而不需要手动去设置。
3. 修正了各布局的wrapContentHeight和 wrapContentWidth 可能计算不正确的问题。
4. 修正了布局视图的leftBorderLineLayer的宽度不正确的问题。
5. 增加了MyLayoutDime和MyLayoutPos这两个类中的方法clear，以便能快速的清除掉所有的设置。
6. 优化了速度和性能的问题。



### V1.1.4版本新功能
1.	 修正了尺寸评估函数`estimateLayoutRect`的一个多层嵌套是无法正确评估尺寸的BUG。
2.	 添加了属性`myMargin`用来简单快速的设置myLeftMarign,myTopMargin,myRightMargin,myBottomMargin都是相等的值。
3.	 增加了`MyDimeScale`这个工具类，用来实现不同屏幕的尺寸和位置的缩放的功能，加入我们的UI给我们的是iPhone6的设计图，并指定了某个视图的高度为100但又同时希望在iPhone5上高度缩小，而在iPhone6Plus上高度增加，则可以通过`[MyDimeScale scale:100]`得到各种屏幕的缩放后的值了。


### V1.1.3版本新功能
1.  对SizeClass支持和竖屏MySizeClass_Portrait和横屏MySizeClass_Landscape。以便支持单独的横屏和竖屏的界面适配，尤其是对iPad设备的横竖屏进行区分适配。

### V1.1.2版本新功能
1.  全面升级，新增加了对SizeClass的支持，通过SizeClass的功能可以为苹果的不同尺寸的设备提供完美的适配功能，对SizeClass的支持，是在苹果的SizeClass能力上支持的，因此只有iOS8以上的版本才支持SizeClass.
2.  流式布局MyFlowLayout增加了按内容填充约束的方式的布局，当arrangedCount设置为0时则表示按内容约束方式进行布局。
2.  添加了一个新的视图扩展属性mySize，以便为了简化同时设置myWidth,myHeight的能力。
3.  将原先的布局基类名字MyLayoutBase更名为MyBaseLayout.
4.  修正了直接从MyLinearLayout或者MyFlowLayout建立派生类并初始化可能会出现的死循环的问题。
5.  增加了对布局视图的autoresizesSubviews属性的支持，这个属性默认是设置为YES，如果设置为NO则布局视图不会产生任何的布局动作，也就是所有的子视图的frame的设置是最终的布局的结果，设置这个属性的作用主要用来实现一些子视图的动画。
6.  修正了其他的BUG。

### V1.1.1版本新功能
1.	新增加了一个mySize属性可以设置布局的宽度和高度，相当于同时设置myWidth,myHeight
2.	修正了和iOS的AutoLayout结合使用时可能出现的布局定位不正确的问题，这个版本可以同时和frame,AutoLayout布局进行混合使用。
3.	修正了其他的小问题，以及注释进行了优化和完整。
4.	将原来的leftMargin,rightMargin,topMargin,bottomMargin,width,height,centerXOffset,centerYOffset,centerOffset这几个方法进行了命名冲突兼容，新版本都在前面增加了my前缀，如果要保持老版本请定义宏：`  #define MY_USEOLDMETHODDEF 1 ` 和`  #define MY_USEOLDMETHODNOWARNING 1 `。
5.	将原来的的MarginGravity枚举类型和LineViewOrientation枚举类型重新定义为：MyMarginGravity和MyLayoutViewOrientation。里面的枚举值也进行重新定义，但可以定义宏：`  #define MY_USEOLDENUMDEF 1 `和`  #define MY_USEOLDENUMNOWARNING 1 `来兼容老版本。


### V1.1.0版本新功能

1. 增加了新布局流式布局MyFlowLayout。	 
2. 线性布局添加了gravity停靠设置的屏幕水平居中和屏幕垂直居中的功能。  
3. 添加了设置布局视图背景图片backgroundImage和高亮背景图片highlightedBackgroundImage的功能。
4. 添加了视图偏移约束的最大max最小值min限制，以及尺寸约束时的最大max最小值min限制。
5. 添加了布局尺寸评估方法estimateLayoutRect以及视图的评估rect值的功能。
6. 添加了框架布局中的子视图的高度和宽度设置功能，可以让高度或者宽度设置为父视图的高度或者宽度的缩放比例，可以设置高度和宽度相等等功能。
7. 添加了线性布局均分视图设置边距subviewMargin的功能。
8. 添加了在布局中让某个子视图不参与布局的功能,只要将useFrame设置为YES即可。
9. 添加了布局视图设置按下事件setTouchDownTarget，按下被取消setTouchCancelTarget的事件功能。
10. 添加了线性布局均分时的间距值设置功能averageSubviews。
11. 添加了清除视图布局设定的方法resetMyLayoutSetting。
12. 修复了布局占用大量内存的问题。   
13. 修改了布局内添加UIScrollView时橡皮筋效果无效的问题。  
14. 优化了一些约束冲突的解决。
15. 优化了布局视图添加到非布局视图时的位置和尺寸调整功能。
16. 修正了子视图恢复隐藏时的界面不重绘的问题。
17. 修正了布局边界线的缩进显示的问题。
18. 修正UITableView，UICollectionView下添加布局可能会造成的问题。
 

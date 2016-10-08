[![Version](https://img.shields.io/cocoapods/v/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![License](https://img.shields.io/cocoapods/l/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Platform](https://img.shields.io/cocoapods/p/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Support](https://img.shields.io/badge/support-iOS%205%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Weibo](https://img.shields.io/badge/Sina微博-@欧阳大哥2013-yellow.svg?style=flat)](http://weibo.com/1411091507)
[![QQ](https://img.shields.io/badge/QQ-156355113-yellow.svg?style=flat)]()
[![GitHub stars](https://img.shields.io/github/stars/youngsoft/MyLinearLayout.svg)](https://github.com/youngsoft/MyLinearLayout/stargazers)

#MyLayout(2016.10.8)


## Introduction
---
**MyLayout is a powerful iOS UI layout framework which is not an encapsulation based on the AutoLayout but is based on primary *frame* property and by overwriting the *layoutSubview* method to realize the subview's layout. So It is unlimited to run in any version of iOS system. Its idea and principle is referenced from the layout of the Android system, HTML/CSS float&flexbox, iOS AutoLayout and SizeClass. You can implement the UI layout through the seven kinds of layout class below: MyLinearLayout, MyRelativeLayout, MyFrameLayout MyTableLayout, MyFlowLayout,MyFloatLayout ,MyPathLayout and the support for SizeClass.**

**Powerful function, easy to use, barely constraint 
setting and fit various screen size perfectly are MyLayout's main advantages.**

**I hope you use MyLayout right now or in your next project will be happy!**

#### ![cn](https://raw.githubusercontent.com/gosquared/flags/master/flags/flags/shiny/24/China.png) **Chinese (Simplified)**: [中文说明](README.zh.md)

---
### MyLinearLayout
Linear layout is a single line layout view that the subviews are arranged in sequence according to the added order（from top to bottom or from left to right). So the subviews' origin&size constraints are established by the added order. Subviews arranged in top-to-bottom order is called vertical linear layout view, and 
the subviews arranged in left-to-right order is called horizontal linear layout.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/ll.png)

Sample code:

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

**MyLinearLayout be equivalent to LinearLayout of Android and UIStackView**

---
### MyRelativeLayout
Relative layout is a layout view that the subviews layout and position through mutual constraints.The subviews in the relative layout are not depended to the adding order but layout and position by setting the subviews' constraints.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/rl.png)

Sample code:

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
**MyRelativeLayout be equivalent to RelativeLayout of Android and AutoLayout**

---
### MyFrameLayout
Frame layout is a layout view that the subviews can be overlapped and gravity in a special location of the superview.The subviews' layout position&size is not depended to the adding order and establish dependency constraint with the superview. Frame layout devided the vertical orientation to top,vertical center and bottom, while horizontal orientation is devided to left,horizontal center and right. Any of the subviews is just gravity in either vertical orientation or horizontal orientation.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fl.png)

Sample code:

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

**MyFrameLayout be equivalent to FrameLayout of Android**

---
### MyTableLayout
Table layout is a layout view that the subviews are multi-row&col arranged like a table. First you must create a rowview and add it to the table layout, then add the subview to the rowview. If the rowviews arranged in top-to-bottom order,the tableview is caled vertical table layout,in which the subviews are arranged from left to right; If the rowviews arranged in in left-to-right order,the tableview is caled horizontal table layout,in which the subviews are arranged from top to bottom.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/tl.png)

Sample code:

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

**MyTableLayout be equivalent to TableLayout of Android and table element of HTML**

---

### MyFlowLayout
Flow layout is a layout view presents in multi-line that the subviews are arranged in sequence according to the added order, and when meeting with a arranging constraint it will start a new line and rearrange. The constrains mentioned here includes count constraints and size constraints. The orientation of the new line would be vertical and horizontal, so the flow layout is divided into: count constraints vertical flow layout, size constraints vertical flow layout, count constraints horizontal flow layout,  size constraints horizontal flow layout. Flow layout often used in the scenes that the subviews is  arranged regularly, it can be substitutive of UICollectionView to some extent. the MyFlowLayout is almost implement the flex-box function of the HTML/CSS.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fll.png)

Sample code:

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

**MyFlowLayout be equivalent to flexbox of CSS3**

---	
### MyFloatLayout
Float layout is a layout view that the subviews are floating gravity in the given orientations, when the size is not enough to be hold, it will automatically find the best location to gravity. float layout's conception is reference from the HTML/CSS's floating positioning technology, so the float layout can be designed in implementing irregular layout. According to the different orientation of the floating, float layout can be divided into left-right float layout and up-down float layout.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/flo.png)

Sample code:

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

**MyFloatLayout be equivalent to float of CSS**

---
### MyPathLayout
 Path layout is a layout view that the subviews are according to a specified path curve to layout. You must provide a type of Functional equation，a coordinate and a type of distance setting to create a Path Curve than all subview are equidistance layout in the Path layout. path layout usually used to create some irregular and gorgeous UI layout.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/pl.png)

Sample code:
 
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
  
  **MyPathLayout is only implement in MyLayout**
  
---
###  MySizeClass
MyLayout provided support to SizeClass in order to fit the different screen sizes of devices. You can combinate the SizeClass with any of the 6 kinds of layout views mentioned above to perfect fit the UI of all equipments.

**MySizeClass be equivalent to SizeClass of iOS**


## Demo sample
---

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo1.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo2.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo3.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo4.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo5.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo6.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo7.gif)


##How To Get Started
---
 [Download MyLayout](https://github.com/youngsoft/MyLinearLayout/archive/master.zip) and try out the included iPad and iPhone example apps
Read FAQ, or articles below:
   
[http://blog.csdn.net/yangtiang/article/details/46483999](http://blog.csdn.net/yangtiang/article/details/46483999)   线性布局  
[http://blog.csdn.net/yangtiang/article/details/46795231](http://blog.csdn.net/yangtiang/article/details/46795231)   相对布局  
[http://blog.csdn.net/yangtiang/article/details/46492083](http://blog.csdn.net/yangtiang/article/details/46492083)   框架布局  
[http://blog.csdn.net/yangtiang/article/details/48011431](http://blog.csdn.net/yangtiang/article/details/48011431) 表格布局  
[http://blog.csdn.net/yangtiang/article/details/50652946](http://blog.csdn.net/yangtiang/article/details/50652946) 流式布局  
[http://www.jianshu.com/p/0c075f2fdab2](http://www.jianshu.com/p/0c075f2fdab2) 浮动布局


Because my english is poor so I just only can support chinese articles，and I wish somebody can help me translate to english.


##Communication
---

- If you need help, use Stack Overflow or Baidu. (Tag 'mylayout')
- If you'd like to contact me, use *qq:156355113 or weibo:欧阳大哥 or email:obq0387_cn@sina.com*
- If you found a bug, and can provide steps to reliably reproduce it, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.

## Installation
---
MyLayout supports multiple methods for installing the library in a project.
### Copy to your project
1.  Copy `Lib` folder from the demo project to your project
2.  Add`#import "MyLayout.h"` to your project's PCH file or the referenced header file。

### Installation with CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like MyLayout in your projects. You can install it with the following command:

`$ gem install cocoapods`

To integrate MyLayout into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

pod 'MyLayout', '~> 1.2.5'
```
   
Then, run the following command:

`$ pod install`





##FAQ
---
* If you use MyLayout runtime cause 100% CPU usage said appeared constraint conflict, please check the subview's constraint set.
* If you use MyLayout exception crashed in MyBaseLayout *willMoveToSuperview* method. it does not matter, just remove the exception break setting in CMD+7.
* If you set wrapConentWidth or wrapContentHeight while set widthDime or heightDime in layout view may be constraint conflict。
* If you set the layout view as a UIControllView's root view. please set wrapContentWidth and wrapContentHeight to NO.
- Just only MyLinearLayout and MyFrameLayout's subview support relative margin.
- If subview added in layout view, the setFrame method can't setting the origin but the size.


## License
---

MyLayout is released under the MIT license. See LICENSE for details.




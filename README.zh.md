[![Version](https://img.shields.io/cocoapods/v/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![License](https://img.shields.io/cocoapods/l/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Platform](https://img.shields.io/cocoapods/p/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Support](https://img.shields.io/badge/support-iOS%205%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Weibo](https://img.shields.io/badge/Sina微博-@欧阳大哥2013-yellow.svg?style=flat)](http://weibo.com/1411091507)
[![QQ](https://img.shields.io/badge/QQ-156355113-yellow.svg?style=flat)]()
[![GitHub stars](https://img.shields.io/github/stars/youngsoft/MyLinearLayout.svg)](https://github.com/youngsoft/MyLinearLayout/stargazers)

##MyLayout(2017.1.21)

MyLayout是一套iOS界面视图布局框架。MyLayout的内核是基于对UIView的layoutSubviews方法的重载以及对子视图的bounds和center属性的设置而实现的。MyLayout功能强大而且简单易用，它集成了:iOS Autolayout和SizeClass、android的5大布局体系、HTML/CSS的浮动定位技术以及flex-box和bootstrap框架等市面上主流的平台的界面布局功能，同时提供了一套非常简单和完备的多屏幕尺寸适配的解决方案。MyLayout的Swift版本的名字叫做：**[TangramKit](https://github.com/youngsoft/TangramKit)**   

##### English (Simplified): [英文说明](README.md)   
   
> 您可以加入到QQ群：*178573773* 或者添加个人QQ：*156355113* 来跟我讨论或者邮件：*obq0387_cn@sina.com* 联系我。

您也可以到我的主页中了解各布局的详细介绍：
   
[http://blog.csdn.net/yangtiang/article/details/46483999](http://blog.csdn.net/yangtiang/article/details/46483999)   线性布局  
[http://blog.csdn.net/yangtiang/article/details/46795231](http://blog.csdn.net/yangtiang/article/details/46795231)   相对布局  
[http://blog.csdn.net/yangtiang/article/details/46492083](http://blog.csdn.net/yangtiang/article/details/46492083)   框架布局  
[http://blog.csdn.net/yangtiang/article/details/48011431](http://blog.csdn.net/yangtiang/article/details/48011431) 表格布局  
[http://blog.csdn.net/yangtiang/article/details/50652946](http://blog.csdn.net/yangtiang/article/details/50652946) 流式布局  
[http://www.jianshu.com/p/0c075f2fdab2](http://www.jianshu.com/p/0c075f2fdab2) 浮动布局


## 演示效果图

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo1.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo2.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo3.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo4.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo5.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo6.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo7.gif)


## 应用场景
举例下面一个应用场景:
*  有一个容器视图S的宽度是100而高度则是由四个从上到下依次排列的子视图A,B,C,D的高度总和。
*  视图A的左边距占用父视图宽度的20%，而右边距则占用父视图宽度的30%，高度则等于自身的宽度。
*  视图B的左边距是40，宽度则占用父视图的剩余宽度，高度是40。
*  视图C的宽度占用父视图的所有宽度，高度是40。
*  视图D的右边距是20，宽度是父视图宽度的50%，高度是40。

最终的效果图如下：

![demo](https://raw.githubusercontent.com/youngsoft/TangramKit/master/TangramKitDemo/Support Files/usagedemo.png)


```objective-c

    MyLinearLayout *S = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    S.subviewMargin = 10;
    S.myWidth = 100;
    
    UIView *A = UIView.new;
    A.myLeftMargin = 0.2;
    A.myRightMargin = 0.3;
    A.heightDime.equalTo(A.widthDime);
    [S addSubview:A];
    
    UIView *B = UIView.new;
    B.myLeftMargin = 40;
    B.myWidth = 60;
    B.myHeight = 40;
    [S addSubview:B];
    
    UIView *C = UIView.new;
    C.myLeftMargin = C.myRightMargin = 0;
    C.myHeight = 40;
    [S addSubview:C];
    
    UIView *D = UIView.new;
    D.myRightMargin = 20;
    D.widthDime.equalTo(S.widthDime).multiply(0.5);
    D.myHeight = 40;
    [S addSubview:D];
    

```


## 系统结构
 
 ![demo](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/MyLayoutClass.png)
 

### 布局位置类MyLayoutPos
MyLayoutPos类是用来描述一个视图所在的位置的类。UIView中扩展出了leftPos,topPos,bottomPos,rightPos,centerXPos,centerYPos这六个变量来实现视图的定位操作。您可以用这些变量的`equalTo`方法来设置视图之间的边距和间距。 `equalTo` 方法可以设置NSNumber, MyLayoutPos, NSArray<MyLayoutPos*>这几种值，分别用于不同的场景。同时系统提供了6个简单的变量myLeftMargin, myTopMargin, myBottomMargin, myRightMargin, myCenterXOffset, mYCenterYOffset来设置NSNumber类型的值，比如 `A.leftPos.equalTo(@10); 等价于 A.myLeftMargin = 10;`.


### 布局尺寸类MyLayoutSize
MyLayoutSize类是用来描述一个视图的尺寸的类。UIView中扩展出了widthDime,heightDime这两个变量来实现视图的宽度和高度尺寸的设置。您可以用其中的`equalTo`方法来设置视图的宽度和高度。`equalTo`方法可以设置NSNumber, MyLayoutSize, NSArray<MyLayoutSize*>这几种值，分别用于不同的场景。同时系统提供了2个简单的变量myWidth,myHeight来设置NSNumber类型的值，比如`A.widthDime.equalTo(@10); 等价于A.myWidth = 10;`.


### 线性布局MyLinearLayout
> 等价于iOS的UIStackView和android的LinearLayout布局。

线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单列(单行)布局视图，因此里面的子视图是通过添加的顺序建立约束和依赖关系的。 子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而子视图从左到右依次排列的线性布局视图则称为水平线性布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/ll.png)

示例代码:

```objective-c
-(void)loadView
{
    [super loadView];
    
    MyLinearLayout *S = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    S.myWidth = 120;
    S.subviewMargin = 10;
    
    UIView *A = [UIView new];
    A.myLeftMargin = A.myRightMargin = 5;
    A.myHeight = 40;
    [S addSubview:A];
    
    UIView *B = [UIView new];
    B.myLeftMargin = 20;
    B.myWidth = B.myHeight = 40;
    [S addSubview:B];
    
    UIView *C = [UIView new];
    C.myRightMargin = 40;
    C.myWidth = 50;
    C.myHeight = 40;
    [S addSubview:C];
    
    UIView *D = [UIView new];
    D.myLeftMargin = D.myRightMargin = 10;
    D.myHeight = 40;
    [S addSubview:D];
    
    [self.view addSubview:S];
    S.backgroundColor = [UIColor redColor];
    A.backgroundColor = [UIColor greenColor];
    B.backgroundColor = [UIColor blueColor];
    C.backgroundColor = [UIColor orangeColor];
    D.backgroundColor = [UIColor cyanColor];
 }

```


### 相对布局MyRelativeLayout
> 等价于iOS的AutoLayout 和 Android的RelativeLayout布局。

相对布局是一种里面的子视图通过相互之间的约束和依赖来进行布局和定位的布局视图。相对布局里面的子视图的布局位置和添加的顺序无关，而是通过设置子视图的相对依赖关系来进行定位和布局的。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/rl.png)

示例代码:

```objective-c
-(void)loadView
{
    [super loadView];
    
    MyRelativeLayout *S = [MyRelativeLayout new];
    S.widthDime.equalTo(@170);
    S.heightDime.equalTo(@280);
    
    UIView *A = [UIView new];
    A.leftPos.equalTo(@20);
    A.topPos.equalTo(@20);
    A.widthDime.equalTo(@40);
    A.heightDime.equalTo(A.widthDime);
    [S addSubview:A];
    
    UIView *B = [UIView new];
    B.leftPos.equalTo(A.centerXPos);
    B.topPos.equalTo(A.bottomPos).offset(10);
    B.widthDime.equalTo(@60);
    B.heightDime.equalTo(A.heightDime);
    [S addSubview:B];
    
    UIView *C = [UIView new];
    C.leftPos.equalTo(B.rightPos).offset(10);
    C.bottomPos.equalTo(B.bottomPos);
    C.widthDime.equalTo(@40);
    C.heightDime.equalTo(B.heightDime).multiply(0.5);
    [S addSubview:C];
    
    UIView *D = [UIView new];
    D.bottomPos.equalTo(C.topPos).offset(10);
    D.rightPos.equalTo(@15);
    D.heightDime.equalTo(A.heightDime);
    D.widthDime.equalTo(D.heightDime);
    [S addSubview:D];
    
    UIView *E = [UIView new];
    E.centerYPos.equalTo(@0);
    E.centerXPos.equalTo(@0);
    E.heightDime.equalTo(@40);
    E.widthDime.equalTo(S.widthDime).add(-20);
    [S addSubview:E];
    //.. F, G
    
    [self.view addSubview:S];
    S.backgroundColor = [UIColor redColor];
    A.backgroundColor = [UIColor greenColor];
    B.backgroundColor = [UIColor blueColor];
    C.backgroundColor = [UIColor orangeColor];
    D.backgroundColor = [UIColor cyanColor];
    E.backgroundColor = [UIColor magentaColor];
}

```


### 框架布局MyFrameLayout
> 等价于Android的FrameLayout布局。


框架布局是一种里面的子视图停靠在父视图特定方位并且可以重叠的布局视图。框架布局里面的子视图的布局位置和添加的顺序无关，只跟父视图建立布局约束依赖关系。框架布局将垂直方向上分为上、中、下三个方位，而水平方向上则分为左、中、右三个方位，任何一个子视图都只能定位在垂直方向和水平方向上的一个方位上。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fl.png)

示例代码:

```objective-c
 -(void)loadView
{
    [super loadView];
    
    MyFrameLayout *S = [MyFrameLayout new];
    S.mySize = CGSizeMake(320,500);
    
    UIView *A = [UIView new];
    A.mySize = CGSizeMake(40,40);
    A.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Top;
    [S addSubview:A];
    
    UIView *B = [UIView new];
    B.mySize = CGSizeMake(40,40);
    B.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Top;
    [S addSubview:B];
    
    UIView *C = [UIView new];
    C.mySize = CGSizeMake(40,40);
    C.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Center;
    [S addSubview:C];
    
    UIView *D = [UIView new];
    D.mySize = CGSizeMake(40,40);
    D.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Center;
    [S addSubview:D];
    
    //..E，F,G
    
    [self.view addSubview:S];
    S.backgroundColor = [UIColor redColor];
    A.backgroundColor = [UIColor greenColor];
    B.backgroundColor = [UIColor blueColor];
    C.backgroundColor = [UIColor orangeColor];
    D.backgroundColor = [UIColor cyanColor];  
  }
  
```


### 表格布局MyTableLayout
> 等价于Android的TableLayout布局和HTML的table元素。


表格布局是一种里面的子视图可以像表格一样多行多列排列的布局视图。子视图添加到表格布局视图前必须先要建立并添加行视图，然后再将子视图添加到行视图里面。如果行视图在表格布局里面是从上到下排列的则表格布局为垂直表格布局，垂直表格布局里面的子视图在行视图里面是从左到右排列的；如果行视图在表格布局里面是从左到右排列的则表格布局为水平表格布局，水平表格布局里面的子视图在行视图里面是从上到下排列的。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/tl.png)

示例代码:

```objective-c
  -(void)loadView
{
    [super loadView];
    
    MyTableLayout *S = [MyTableLayout tableLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    S.wrapContentWidth = YES;
    S.rowSpacing = 10;
    S.colSpacing = 10;
    
    [S addRow:MTLSIZE_WRAPCONTENT colSize:MTLSIZE_WRAPCONTENT];
    
    UIView *A = [UIView new];
    A.mySize = CGSizeMake(50,40);
    [S addSubview:A];
    
    UIView *B = [UIView new];
    B.mySize = CGSizeMake(100,40);
    [S addSubview:B];
    
    UIView *C = [UIView new];
    C.mySize = CGSizeMake(30,40);
    [S addSubview:C];
    
    [S addRow:MTLSIZE_WRAPCONTENT colSize:MTLSIZE_WRAPCONTENT];
    
    UIView *D = [UIView new];
    D.mySize = CGSizeMake(200,40);
    [S addSubview:D];
    
    //...E,F  
    
    
    [self.view addSubview:S];
    S.backgroundColor = [UIColor redColor];
    A.backgroundColor = [UIColor greenColor];
    B.backgroundColor = [UIColor blueColor];
    C.backgroundColor = [UIColor orangeColor];
    D.backgroundColor = [UIColor cyanColor];
}  
  
  
```


### 流式布局MyFlowLayout
> 等价于CSS3的flex-box。


流式布局是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一行再重新排列的多行展示的布局视图。这里的约束限制主要有数量约束限制和内容尺寸约束限制两种，而换行的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些子视图有规律排列的场景，在某种程度上可以作为UICollectionView的替代品。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fll.png)

示例代码:

```objective-c
   
  -(void)loadView
{
    [super loadView];
    
    MyFlowLayout *S = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:4];
    S.wrapContentHeight = YES;
    S.myWidth = 300;
    S.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    S.gravity = MyMarginGravity_Horz_Fill;
    S.subviewMargin = 10;
    
    for (int i = 0; i < 10; i++)
    {
        UIView *A = [UIView new];
        A.heightDime.equalTo(A.widthDime);
        [S addSubview:A];
        
        A.backgroundColor = [UIColor greenColor];

    }
    
    
    [self.view addSubview:S];
    S.backgroundColor = [UIColor redColor];
}

   
   

```


	
### 浮动布局MyFloatLayout
> 等价于css中的float定位。

浮动布局是一种里面的子视图按照约定的方向浮动停靠，当尺寸不足以被容纳时会自动寻找最佳的位置进行浮动停靠的布局视图。浮动布局的理念源于HTML/CSS中的浮动定位技术,因此浮动布局可以专门用来实现那些不规则布局或者图文环绕的布局。根据浮动的方向不同，浮动布局可以分为左右浮动布局和上下浮动布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/flo.png)

示例代码:

```objective-c
      -(void)loadView
{
    [super loadView];
    
    MyFloatLayout *S  = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    S.wrapContentHeight = YES;
    S.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    S.subviewMargin = 10;
    S.myWidth = 300;
    
    UIView *A = [UIView new];
    A.mySize = CGSizeMake(80,70);
    [S addSubview:A];
    
    UIView *B = [UIView new];
    B.mySize = CGSizeMake(150,40);
    [S addSubview:B];
    
    UIView *C = [UIView new];
    C.mySize = CGSizeMake(70,40);
    [S addSubview:C];
    
    UIView *D = [UIView new];
    D.mySize = CGSizeMake(100,140);
    [S addSubview:D];
    
    UIView *E = [UIView new];
    E.mySize = CGSizeMake(150,40);
    E.reverseFloat = YES;
    [S addSubview:E];
    
    UIView *F = [UIView new];
    F.mySize = CGSizeMake(120,60);
    [S addSubview:F];
    
    
    [self.view addSubview:S];
    S.backgroundColor = [UIColor redColor];
    A.backgroundColor = [UIColor greenColor];
    B.backgroundColor = [UIColor blueColor];
    C.backgroundColor = [UIColor orangeColor];
    D.backgroundColor = [UIColor cyanColor];
    E.backgroundColor = [UIColor blackColor];
    F.backgroundColor = [UIColor whiteColor];
}     
     

```



### 路径布局MyPathLayout
> 布局库独有


路径布局是一种里面的子视图根据您提供的一条特定的曲线函数形成的路径来进行布局的布局视图。您需要提供一个实现曲线路径的函数、一个特定的坐标体系、一种特定的子视图在曲线上的距离设置这三个要素来实现界面布局。当曲线路径形成后，子视图将按相等的距离依次环绕着曲线进行布局。路径布局主要应用于那些具有特定规律的不规则排列，而且效果很酷炫的的界面布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/pl.png)

示例代码:
 
 ```objective-c
   -(void)loadView
{
    [super loadView];
    
    MyPathLayout *S = [MyPathLayout new];
    S.mySize = CGSizeMake(320,320);
    S.coordinateSetting.isReverse = YES;
    S.coordinateSetting.origin = CGPointMake(0.5, 0.2);
    
    S.polarEquation = ^(CGFloat angle)
    {
        return 80 * (1 + cos(angle));
    };
    
    for (int i = 0; i < 4; i++)
    {
        UIView *A = [UIView new];
        A.mySize = CGSizeMake(40,40);
        [S addSubview:A];
        
        A.backgroundColor = [UIColor greenColor];
    }

    [self.view  addSubview:S];
    S.backgroundColor = [UIColor redColor];
 }
 
 ```
   

###  SizeClass的支持
> 等价于iOS的Size Classes

MyLayout布局体系为了实现对不同屏幕尺寸的设备进行适配，提供了对SIZECLASS的支持。您可以将SIZECLASS和上述的6种布局搭配使用，以便实现各种设备界面的完美适配。系统提供2个UIView的扩展方法：

```objective-c

-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass;
-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass;

````
来实现对Size Classes的支持。比如下面的例子：

```objective-c

//默认所有设备的设置。
 MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.wrapContentHeight = NO;
    rootLayout.gravity = MyMarginGravity_Horz_Fill;

//MySizeClass_wAny | MySizeClass_hCompact 表明的是iPhone设备的横屏.
 MyLinearLayout *lsc = [rootLayout fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact copyFrom:MySizeClass_wAny | MySizeClass_hAny];
 
    lsc.orientation = MyLayoutViewOrientation_Horz;
    lsc.wrapContentWidth = NO;
    lsc.gravity = MyMarginGravity_Vert_Fill;


```



## 使用方法

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

pod 'MyLayout', '~> 1.3.2'
```
   
然后运行如下命令:

```
$ pod install
```



##版本历史
具体请查看 **[CHANGELOG.md](CHANGELOG.md)**

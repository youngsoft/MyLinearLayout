[![Version](https://img.shields.io/cocoapods/v/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Platform](https://img.shields.io/cocoapods/p/MyLayout.svg?style=flat)](http://cocoapods.org/pods/MyLayout)
[![Support](https://img.shields.io/badge/support-iOS%205%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Weibo](https://img.shields.io/badge/Sina微博-@欧阳大哥2013-yellow.svg?style=flat)](http://weibo.com/1411091507)
[![QQ](https://img.shields.io/badge/QQ-156355113-yellow.svg?style=flat)]()
[![GitHub stars](https://img.shields.io/github/stars/youngsoft/MyLinearLayout.svg)](https://github.com/youngsoft/MyLinearLayout/stargazers)


![Logo](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/MyLayout.png)

## MyLayout

MyLayout是一套iOS界面视图布局框架。MyLayout的内核是基于对UIView的layoutSubviews方法的重载以及对子视图的bounds和center属性的设置而实现的。MyLayout功能强大而且简单易用，它集成了:iOS Autolayout和SizeClass、android的5大布局体系、HTML/CSS的浮动定位技术以及flex-box和bootstrap框架等市面上主流的平台的界面布局功能，同时提供了一套非常简单和完备的多屏幕尺寸适配的解决方案。MyLayout的Swift版本的名字叫做：**[TangramKit](https://github.com/youngsoft/TangramKit)**   

##### English (Simplified): [英文说明](README.md)   
   
> 您可以加入到QQ群：*178573773* 或者添加个人QQ：*156355113* 来跟我讨论或者邮件：*obq0387_cn@sina.com* 联系我。

您也可以到我的主页中了解各布局的详细介绍：
 
 [http://www.jianshu.com/p/4c1eb0dd676f](http://www.jianshu.com/p/4c1eb0dd676f)   布局框架和原理介绍    
[http://blog.csdn.net/yangtiang/article/details/46483999](http://blog.csdn.net/yangtiang/article/details/46483999)   线性布局  
[http://blog.csdn.net/yangtiang/article/details/46795231](http://blog.csdn.net/yangtiang/article/details/46795231)   相对布局  
[http://blog.csdn.net/yangtiang/article/details/46492083](http://blog.csdn.net/yangtiang/article/details/46492083)   框架布局  
[http://blog.csdn.net/yangtiang/article/details/48011431](http://blog.csdn.net/yangtiang/article/details/48011431) 表格布局  
[http://www.jianshu.com/p/fbeb376584ed](http://www.jianshu.com/p/fbeb376584ed) 流式布局  
[http://www.jianshu.com/p/0c075f2fdab2](http://www.jianshu.com/p/0c075f2fdab2) 浮动布局


### MyLayout的优势
* MyLayout的实现内核是基于frame的设置，而不是对AutoLayout的封装。因此在使用上不会受到任何操作系统版本的限制。
* 有文章表明用frame进行布局的性能要高于用AutoLayout进行布局的性能，尤其是当界面内视图数量增加时效果更加明显。
* AutoLayout的思想是通过视图之间的约束依赖来完成布局，但是约束依赖的结果是造成视图之间的耦合性高而增大了界面更新的成本。而MyLayout则除了提供约束依赖外，还提供了根据视图添加顺序自动建立约束的功能，从而减少了这种显示依赖关系建立的问题，最终的结果是简化了布局的代码量，以及减少了布局更新时的代码修改量。
* AutoLayout只是一种相对约束的布局，而MyLayout除了同时提供具有和AutoLayout相同能力的相对布局外、还提供了线性布局、框架布局、表格布局、流式布局、浮动布局、路径布局7大布局体系，你完全可以根据你的界面需求来选择一种最简易的布局容器来实现你的功能，同时MyLayout还支持Size classes的机制，以及提供了一些实现屏幕尺寸完美适配的方法。
* MyLayout主要是一种通过代码进行布局的解决方案，但是框架一样可以支持和XIB以及SB结合布局的方式。并提供了视图隐藏和显示时会自动激发布局、布局视图的高度自适应(UITableviewCell动态高度)、标签云实现、左右内容宽度自适应、按比例分配尺寸和间距、整体停靠控制等等各种强大的功能。


### MyLayout和各种布局方式的性能比较
![demo](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/MyLayoutP.png)

下面两张表格分别列表每个子视图的建立消耗的时间和布局消耗时间，单位为：毫秒

create time(ms)/per subview|Frame|MyLayout|AutoLayout|Masonry|UIStackView	
-------|-----|-------|--------|--------|-------
MyLinearLayout|0.08|0.164|0.219|0.304|0.131
MyFrameLayout|0.05|0.149|0.209|0.273|0.131
MyRelativeLayout|0.079|0.182|0.116|0.359|0.131
MyFlowLayout|0.08|0.107|0.198|0.258|0.131
MyFloatLayout|0.044|0.148|0.203|0.250|0.131



layout time(ms)/per subview |Frame|MyLayout|AutoLayout|Masonry|UIStackView	
-----|-------|--------|-------|---------|------
MyLinearLayout|0|0.049|0.269|0.269|0.272
MyFrameLayout|0|0.042|0.243|0.243|0.272
MyRelativeLayout|0|0.068|0.274|0.274|0.272
MyFlowLayout|0|0.036|0.279|0.279|0.272
MyFloatLayout|0|0.055|0.208|0.208|0.272



从上面的表格可以总结如下：

 1. 用frame构建视图用时最少，平均每个视图花费0.068ms。当视图的frame指定后就不再需要布局视图了，所以布局时间几乎是0。
  2. 当用AutoLayout进行布局时每个子视图的平均构建时长约为0.189ms，而Masonry因为是对AutoLayout的封装所以平均构建时长约为0.289ms。在布局时则因为都是使用了AutoLayout所以是相等的，大概花费0.255ms左右。
  3. MyLayout的实现因为是对frame的封装，所以无论是构建时长和布局时长都要优于AutoLayout，但低于原始的frame方法。MyLayout的平均构建时长约0.150ms，比frame构建要多花费2.2倍的时间；而AutoLayout的平均构建时长是MyLayout的1.26倍；Masonry的平均构建时长则是MyLayout的1.9倍。
  4. MyLayout的平均布局时长是0.05ms, 而AutoLayout的布局时长则是MyLayout的5倍。
  5. UIStackView的构建时长要稍微优于MyLayout的线性布局MyLinearLayout.但是布局时长则是MyLinearLayout的5.5倍。
  6. MyLayout中流式布局MyFlowLayout的构建时长和布局时长最小，而相对布局的构建和布局时长最长。




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

![demo](https://raw.githubusercontent.com/youngsoft/TangramKit/master/TangramKitDemo/Support%20Files/usagedemo.png)


```objective-c

     MyLinearLayout *S = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    S.subviewSpace = 10;
    S.widthSize.equalTo(@100);
    
    UIView *A = UIView.new;
    A.leftPos.equalTo(@0.2);
    A.rightPos.equalTo(@0.3);
    A.heightSize.equalTo(A.widthSize);
    [S addSubview:A];
    
    UIView *B = UIView.new;
    B.leftPos.equalTo(@40);
    B.widthSize.equalTo(@60);
    B.heightSize.equalTo(@40);
    [S addSubview:B];
    
    UIView *C = UIView.new;
    C.leftPos.equalTo(@0);
    C.rightPos.equalTo(@0);
    C.heightSize.equalTo(@40);
    [S addSubview:C];
    
    UIView *D = UIView.new;
    D.rightPos.equalTo(@20);
    D.widthSize.equalTo(S.widthSize).multiply(0.5);
    D.heightSize.equalTo(@40);
    [S addSubview:D];
    
    

```


## 系统结构
 
 ![demo](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/MyLayoutClass.png)
 

### 布局位置类MyLayoutPos
MyLayoutPos类是用来描述一个视图所在的位置的类。UIView中扩展出了leftPos,topPos,bottomPos,rightPos,centerXPos,centerYPos这六个变量来实现视图的定位操作。您可以用这些变量的`equalTo`方法来设置视图之间的边距和间距。 `equalTo` 方法可以设置NSNumber, MyLayoutPos, NSArray<MyLayoutPos*>这几种值，分别用于不同的场景。同时系统提供了6个简单的变量myLeft, myTop, myBottom, myRight, myCenterX, mYCenterY来设置NSNumber类型的值，比如 `A.leftPos.equalTo(@10); 等价于 A.myLeft = 10;`.


### 布局尺寸类MyLayoutSize
MyLayoutSize类是用来描述一个视图的尺寸的类。UIView中扩展出了widthSize,heightSize这两个变量来实现视图的宽度和高度尺寸的设置。您可以用其中的`equalTo`方法来设置视图的宽度和高度。`equalTo`方法可以设置NSNumber, MyLayoutSize, NSArray<MyLayoutSize*>这几种值，分别用于不同的场景。同时系统提供了2个简单的变量myWidth,myHeight来设置NSNumber类型的值，比如`A.widthSize.equalTo(@10); 等价于A.myWidth = 10;`.


### 线性布局MyLinearLayout
> 等价于iOS的UIStackView和android的LinearLayout布局。

线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单列(单行)布局视图，因此里面的子视图是通过添加的顺序建立约束和依赖关系的。 子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而子视图从左到右依次排列的线性布局视图则称为水平线性布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/ll.png)

示例代码:

```objective-c
-(void)loadView
{
    [super loadView];
    
    MyLinearLayout *S = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    S.myWidth = 120;
    S.subviewSpace = 10;
    
    UIView *A = [UIView new];
    A.myLeft = A.myRight = 5;
    A.myHeight = 40;
    [S addSubview:A];
    
    UIView *B = [UIView new];
    B.myLeft = 20;
    B.myWidth = B.myHeight = 40;
    [S addSubview:B];
    
    UIView *C = [UIView new];
    C.myRight = 40;
    C.myWidth = 50;
    C.myHeight = 40;
    [S addSubview:C];
    
    UIView *D = [UIView new];
    D.myLeft = D.myRight = 10;
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
    S.widthSize.equalTo(@170);
    S.heightSize.equalTo(@280);
    
    UIView *A = [UIView new];
    A.leftPos.equalTo(@20);
    A.topPos.equalTo(@20);
    A.widthSize.equalTo(@40);
    A.heightSize.equalTo(A.widthSize);
    [S addSubview:A];
    
    UIView *B = [UIView new];
    B.leftPos.equalTo(A.centerXPos);
    B.topPos.equalTo(A.bottomPos).offset(10);
    B.widthSize.equalTo(@60);
    B.heightSize.equalTo(A.heightSize);
    [S addSubview:B];
    
    UIView *C = [UIView new];
    C.leftPos.equalTo(B.rightPos).offset(10);
    C.bottomPos.equalTo(B.bottomPos);
    C.widthSize.equalTo(@40);
    C.heightSize.equalTo(B.heightSize).multiply(0.5);
    [S addSubview:C];
    
    UIView *D = [UIView new];
    D.bottomPos.equalTo(C.topPos).offset(10);
    D.rightPos.equalTo(@15);
    D.heightSize.equalTo(A.heightSize);
    D.widthSize.equalTo(D.heightSize);
    [S addSubview:D];
    
    UIView *E = [UIView new];
    E.centerYPos.equalTo(@0);
    E.centerXPos.equalTo(@0);
    E.heightSize.equalTo(@40);
    E.widthSize.equalTo(S.widthSize).add(-20);
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
    [S addSubview:A];
    
    UIView *B = [UIView new];
    B.mySize = CGSizeMake(40,40);
    B.myRight = 0;
    [S addSubview:B];
    
    UIView *C = [UIView new];
    C.mySize = CGSizeMake(40,40);
    C.myCenterY = 0;
    [S addSubview:C];
    
    UIView *D = [UIView new];
    D.mySize = CGSizeMake(40,40);
    D.myCenter = CGPointZero;
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
    
    MyTableLayout *S = [MyTableLayout tableLayoutWithOrientation:MyOrientation_Vert];
    S.wrapContentWidth = YES;
    S.subviewHSpace = 10;
    S.subviewVSpace = 10;
    
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
    
    MyFlowLayout *S = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:4];
    S.wrapContentHeight = YES;
    S.myWidth = 300;
    S.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    S.gravity = MyGravity_Horz_Fill;
    S.subviewSpace = 10;
    
    for (int i = 0; i < 10; i++)
    {
        UIView *A = [UIView new];
        A.heightSize.equalTo(A.widthSize);
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
    
    MyFloatLayout *S  = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    S.wrapContentHeight = YES;
    S.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    S.subviewSpace = 10;
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
 MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.wrapContentHeight = NO;
    rootLayout.gravity = MyGravity_Horz_Fill;

//MySizeClass_wAny | MySizeClass_hCompact 表明的是iPhone设备的横屏.
 MyLinearLayout *lsc = [rootLayout fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact copyFrom:MySizeClass_wAny | MySizeClass_hAny];
 
    lsc.orientation = MyOrientation_Horz;
    lsc.wrapContentWidth = NO;
    lsc.gravity = MyGravity_Vert_Fill;


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

pod 'MyLayout', '~> 1.4.1'
```
   
然后运行如下命令:

```
$ pod install
```

### 使用[Carthage](https://github.com/Carthage/Carthage)

1.创建一个 `Cartfile` 文件，内容如下：

	github "youngsoft/MyLinearLayout"
	
2.终端执行`carthage update`。
 
3.点击“General”按钮，然后把`Carthage/Build/iOS/MyLayout.framework`拖拽到到“Linked Frameworks and Libraries”栏目里。

4.点击“Build Phases”按钮, 然后点击左上角的加号 “+” 选择“New Run Script Phase”，在`Shell`下面填写下面内容:

	/usr/local/bin/carthage copy-frameworks
	
  然后在 “Input Files”栏目加上：

	
	$(SRCROOT)/Carthage/Build/iOS/MyLayout.framework
	



## 版本历史
具体请查看 **[CHANGELOG.md](CHANGELOG.md)**

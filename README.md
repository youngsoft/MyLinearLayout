# MyLayout1.1.6


## 功能介绍

   一套功能强大的iOS布局库，他不是在自动布局的基础上进行的封装，而是一套原生的基于对frame设置的封装，通过重载layoutSubview函数来实现子视图的布局，因此可以无限制的运行在任何版本的iOS系统中。其设计思想以及原理则参考了android的布局和iOS自动布局以及SizeClass的功能，而比android的布局库以及iOS的自动布局库功能更加强大，使用则方便简单，其分别提供了：**线性布局MyLinearLayout**、**相对布局MyRelativeLayout**、**框架布局MyFrameLayout**、**表格布局MyTableLayout**、**流式布局MyFlowLayout**、**浮动布局MyFloatLayout**六个布局类，以及针对苹果的各种屏幕尺寸的设备添加了对**SizeClass**的支持，以便同时适配各种屏幕设备。各种类应用的场景不大一样，具体的使用方法请看Demo中的演示代码以及到我的CSDN主页中了解：

[http://blog.csdn.net/yangtiang/article/details/46483999](http://blog.csdn.net/yangtiang/article/details/46483999)   线性布局  
[http://blog.csdn.net/yangtiang/article/details/46795231](http://blog.csdn.net/yangtiang/article/details/46795231)   相对布局  
[http://blog.csdn.net/yangtiang/article/details/46492083](http://blog.csdn.net/yangtiang/article/details/46492083)   框架布局  
[http://blog.csdn.net/yangtiang/article/details/48011431](http://blog.csdn.net/yangtiang/article/details/48011431) 表格布局  
[http://blog.csdn.net/yangtiang/article/details/50652946](http://blog.csdn.net/yangtiang/article/details/50652946) 流式布局  

[http://www.jianshu.com/p/0c075f2fdab2](http://www.jianshu.com/p/0c075f2fdab2) 浮动布局

#### 线性布局MyLinearLayout
	线性布局分为垂直线性布局和水平线性布局，其中垂直线性布局中的子视图总是按照添加的顺序依次从上到下排列，而水平线性布局中的子视图则按照添加的顺序依次从左到右进行排列。这种布局中的子视图之间不需要设置任何依赖关系，因此是最简单也是最常见的一种布局方式。

#### 相对布局MyRelativeLayout
	相对布局就是实现了iOS的自动布局功能的一种布局方式，但是比自动布局功能更加强大，更加容易使用。相对布局中的子视图必须要设置视图与视图之间的依赖关系以及视图与布局视图的依赖关系，也就是需要设置视图自身上下左右的依赖关系以及高度和宽度的依赖关系。对于一些不规则的布局则最好使用相对布局。

#### 框架布局MyFrameLayout
	框架布局，故名思议要求布局必须设定明确的高度和宽度值，而且里面的子视图只能布局在框架布局的上中下以及左中右的某个具体的位置上，框架布局支持子视图之间的重叠排列。因此框架布局一般是用来做根布局使用。

#### 表格布局MyTableLayout
	表格布局，是一种增强的线性布局，也分为垂直表格和水平表格，表格布局必须要先添加一行，然后再在当前行上进行单元格视图的添加，表格布局的风格类似于HTML页面的表格实现机制，表格布局用于那些有规律的子视图的排列，以及可以用于实现瀑布流的效果。

#### 流式布局MyFlowLayout
	流式布局是一种子视图优先按特定方向排列布局，而当子视图填充尺寸或者数量满足一定条件后则后续的子视图会换行或者换列并回到起点重新进行排列布局。流式布局分为垂直内容填充约束流式布局、垂直数量约束流式布局、水平内容填充约束流式布局、水平数量约束流式布局四种布局。流式布局一般用于子视图有规律的排列。
	
#### 浮动布局MyFloatLayout
	浮动布局是一种子视图总是按特定的方向浮动进行排列的布局，一旦某个子视图的宽度或者高度按某个方向浮动而不能被容纳时，则将会自动的切换位置，以便找到一个最合适的位置进行容纳。浮动布局是从HTML的CSS的浮动布局功能实现的。浮动布局可以支持垂直浮动布局和水平浮动布局两种浮动方式，浮动布局主要用于一些不规则排列的布局，以及新闻类的卡片布局。

####  SizeClass的支持
	为了有效的同时适配苹果的各种屏幕尺寸的设备，在1.1.2版本中新增加了对SizeClass的支持，通过SizeClass可以完成对某个视图在各种屏幕尺寸下的布局约束设置。
	
## 演示效果图

![演示图](http://7xoymz.com1.z0.glb.clouddn.com/mylayout.gif)
![演示图](http://7xoymz.com1.z0.glb.clouddn.com/sizeClassLayout.gif)

## 使用方式
### 直接拷贝
1.  将github工程中的Lib文件夹下的所有文件复制到您的工程中。
2.  将`#import "MyLayout.h"` 头文件放入到您的pch文件中，或者在需要使用界面布局的源代码位置。

### Installation with CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AFNetworking in your projects. See the "Getting Started" guide for more information. You can install it with the following command:
```
$ gem install cocoapods
```

To integrate MyLayout into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

pod 'MyLayout', '~> 1.1.6'
```
   
Then, run the following command:

```
$ pod install
```

## V1.1.6版本新功能
1.  MyLayoutDime类的equalTo方法添加可以等于自身的功能。比如`a.widthDime.equalTo(a.widthDime).add(10);` 表示视图a的最终宽度等于其本身内容的宽度再加上10. 这种设置方法不会造成循环引用，主要用于那些需要在自身内容尺寸基础上再扩展尺寸的场景，具体例子见： *FLLTest2ViewController*。
2.  流式布局MyFlowLayout中的内容填充布局为了解决每行内容的填充空隙问题，增加了拉伸间距，拉伸尺寸，以及自动排列三种功能。拉伸间距需要设置属性*gravity*的值为*MyMarginGravity_Horz_Fill*或者*MyMarginGravity_Vert_Fill*；拉伸尺寸需要设置属性*averageArrange*的值为YES；自动排列则需要设置属性autoArrange的值为YES。具体例子见*FLLTest2ViewController*。
3.  添加了新的视图扩展属性*noLayout*。这个属性设置为YES时表示子视图会参与布局，但是并不会真实的调整其在布局视图中的位置和尺寸，而布局视图则会保留出这个子视图的布局位置和尺寸的空间。这个属性和*useFrame*混合使用用来实现一些动画效果。具体例子见：*FLLTest3ViewController*。
4.  框架布局MyFrameLayout支持了wrapContentHeight和wrapContentWidth设置为YES的功能。
5.  布局视图添加新的属性*highlightedOpacity*，用来指定当布局Touch事件的高亮不透明度值。具体例子见：AllTest1ViewController。
6.  修正了MyTableLayout中的一个BUG。
7.  将布局库中的所有注释部分重新进行了格式化和调整。
8.  优化了布局中的一些性能问题。
9.  去掉了对过期代码的兼容性。

## V1.1.5版本新功能
1. 添加了新的布局 **浮动布局**，浮动布局实现不规则的子视图的排列，卡片布局。设计思想是从HTML中的CSS样式的float属性得到了。
2. 新增智能边界线的功能，通过智能边界线的设定，可以让布局中的子布局根据排版而自动生成边界线，而不需要手动去设置。
3. 修正了各布局的wrapContentHeight和 wrapContentWidth 可能计算不正确的问题。
4. 修正了布局视图的leftBorderLineLayer的宽度不正确的问题。
5. 增加了MyLayoutDime和MyLayoutPos这两个类中的方法clear，以便能快速的清除掉所有的设置。
6. 优化了速度和性能的问题。



## V1.1.4版本新功能
1.	 修正了尺寸评估函数`estimateLayoutRect`的一个多层嵌套是无法正确评估尺寸的BUG。
2.	 添加了属性`myMargin`用来简单快速的设置myLeftMarign,myTopMargin,myRightMargin,myBottomMargin都是相等的值。
3.	 增加了`MyDimeScale`这个工具类，用来实现不同屏幕的尺寸和位置的缩放的功能，加入我们的UI给我们的是iPhone6的设计图，并指定了某个视图的高度为100但又同时希望在iPhone5上高度缩小，而在iPhone6Plus上高度增加，则可以通过`[MyDimeScale scale:100]`得到各种屏幕的缩放后的值了。


## V1.1.3版本新功能
1.  对SizeClass支持和竖屏MySizeClass_Portrait和横屏MySizeClass_Landscape。以便支持单独的横屏和竖屏的界面适配，尤其是对iPad设备的横竖屏进行区分适配。

## V1.1.2版本新功能
1.  全面升级，新增加了对SizeClass的支持，通过SizeClass的功能可以为苹果的不同尺寸的设备提供完美的适配功能，对SizeClass的支持，是在苹果的SizeClass能力上支持的，因此只有iOS8以上的版本才支持SizeClass.
2.  流式布局MyFlowLayout增加了按内容填充约束的方式的布局，当arrangedCount设置为0时则表示按内容约束方式进行布局。
2.  添加了一个新的视图扩展属性mySize，以便为了简化同时设置myWidth,myHeight的能力。
3.  将原先的布局基类名字MyLayoutBase更名为MyBaseLayout.
4.  修正了直接从MyLinearLayout或者MyFlowLayout建立派生类并初始化可能会出现的死循环的问题。
5.  增加了对布局视图的autoresizesSubviews属性的支持，这个属性默认是设置为YES，如果设置为NO则布局视图不会产生任何的布局动作，也就是所有的子视图的frame的设置是最终的布局的结果，设置这个属性的作用主要用来实现一些子视图的动画。
6.  修正了其他的BUG。

## V1.1.1版本新功能
1.	新增加了一个mySize属性可以设置布局的宽度和高度，相当于同时设置myWidth,myHeight
2.	修正了和iOS的AutoLayout结合使用时可能出现的布局定位不正确的问题，这个版本可以同时和frame,AutoLayout布局进行混合使用。
3.	修正了其他的小问题，以及注释进行了优化和完整。
4.	将原来的leftMargin,rightMargin,topMargin,bottomMargin,width,height,centerXOffset,centerYOffset,centerOffset这几个方法进行了命名冲突兼容，新版本都在前面增加了my前缀，如果要保持老版本请定义宏：`  #define MY_USEOLDMETHODDEF 1 ` 和`  #define MY_USEOLDMETHODNOWARNING 1 `。
5.	将原来的的MarginGravity枚举类型和LineViewOrientation枚举类型重新定义为：MyMarginGravity和MyLayoutViewOrientation。里面的枚举值也进行重新定义，但可以定义宏：`  #define MY_USEOLDENUMDEF 1 `和`  #define MY_USEOLDENUMNOWARNING 1 `来兼容老版本。


## V1.1.0版本新功能

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

## FAQ
1. 如果使用布局运行时造成CPU的100%占用则表示出现约束冲突了，请检查子视图约束的设置。	
2. 为支持布局而扩展的视图属性只对放在布局内才完全有效，如果在布局视图之外设置则无效。
3. 如果将布局视图放在非布局视图之中则只有部分属性有效，如果同时设置了leftMargin和rightMargin则表示设置自身的宽度，如果同时设置了topMargin,bottomMargin则表示设置自身的高度。
4. 如果设置wrapContentWidth,和wrapContentHeight的话，而又设置高度和宽度话可能会引起布局冲突。
5. 自动布局并不是不用设置位置和高宽，而只是通过一些手段或者关联减少设置绝对位置和高度而已。

# MyLayout1.1.0

## 功能介绍

   一套功能强大的iOS布局库，他不是在自动布局的基础上进行的封装，而是一套原生的基于对frame设置的封装，通过重载layoutSubview函数来实现子视图的布局，因此可以无限制的运行在任何版本的iOS系统中。其设计思想以及原理则参考了android的布局和iOS自动布局以及SizeClass的功能，而比android的布局库以及iOS的自动布局库功能更加强大，使用则方便简单，其分别提供了：**线性布局MyLinearLayout**、**相对布局MyRelativeLayout**、**框架布局MyFrameLayout**、**表格布局MyTableLayout**、**流式布局MyFlowLayout**五个布局类，各种类应用的场景不大一样，具体的使用方法请看Demo中的演示代码以及到我的CSDN主页中了解：

[http://blog.csdn.net/yangtiang/article/details/46483999](http://blog.csdn.net/yangtiang/article/details/46483999)   线性布局  
[http://blog.csdn.net/yangtiang/article/details/46795231](http://blog.csdn.net/yangtiang/article/details/46795231)   相对布局  
[http://blog.csdn.net/yangtiang/article/details/46492083](http://blog.csdn.net/yangtiang/article/details/46492083)   框架布局  
[http://blog.csdn.net/yangtiang/article/details/48011431](http://blog.csdn.net/yangtiang/article/details/48011431) 表格布局  

#### 线性布局MyLinearLayout
    线性布局分为垂直线性布局和水平线性布局，其中垂直线性布局中的子视图总是按照添加的顺序依次从上到下排列，而水平线性布局中的子视图则按照添加的顺序依次从左到右进行排列。这种布局中的子视图之间不需要设置任何依赖关系，因此是最简单也是最常见的一种布局方式。

#### 相对布局MyRelativeLayout
    相对布局就是实现了iOS的自动布局功能的一种布局方式，但是比自动布局功能更加强大，更加容易使用。相对布局中的子视图必须要设置视图与视图之间的依赖关系以及视图与布局视图的依赖关系，也就是需要设置视图自身上下左右的依赖关系以及高度和宽度的依赖关系。对于一些不规则的布局则最好使用相对布局。

#### 框架布局MyFrameLayout
    框架布局，故名思议要求布局必须设定明确的高度和宽度值，而且里面的子视图只能布局在框架布局的上中下以及左中右的某个具体的位置上，框架布局支持子视图之间的重叠排列。因此框架布局一般是用来做根布局使用。

#### 表格布局MyTableLayout
    表格布局，是一种增强的线性布局，也分为垂直表格和水平表格，表格布局必须要先添加一行，然后再在当前行上进行单元格视图的添加，表格布局的风格类似于HTML页面的表格实现机制，表格布局用于那些有规律的子视图的排列，以及可以用于实现瀑布流的效果。

#### 流式布局MyFlowLayout
	流式布局是一种限定了行数或者列数的布局，同样分为垂直流式布局和水平流式布局，对于垂直流式布局来说，需要设定每行的子视图数量，设定后子视图依次从左到右，从上到下依次排列，流式布局一般用于子视图有规律的排列。

## 演示效果图

![演示图](http://7xoymz.com1.z0.glb.clouddn.com/mylayout.gif)


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

## BUG修复

1. 修复了布局占用大量内存的问题。   
2. 修改了布局内添加UIScrollView时橡皮筋效果无效的问题。  
3. 优化了一些约束冲突的解决。
4. 优化了布局视图添加到非布局视图时的位置和尺寸调整功能。
5. 修正了子视图恢复隐藏时的界面不重绘的问题。
6. 修正了布局边界线的缩进显示的问题。
7. 修正UITableView，UICollectionView下添加布局可能会造成的问题。

## FAQ
1. 如果使用布局运行时造成CPU的100%占用则表示出现约束冲突了，请检查子视图约束的设置。    
2. 为支持布局而扩展的视图属性只对放在布局内才完全有效，如果在布局视图之外设置则无效。
3. 如果将布局视图放在非布局视图之中则只有部分属性有效，如果同时设置了leftMargin和rightMargin则表示设置自身的宽度，如果同时设置了topMargin,bottomMargin则表示设置自身的高度。
4. 如果设置wrapContentWidth,和wrapContentHeight的话，而又设置高度和宽度话可能会引起布局冲突。
5. 自动布局并不是不用设置位置和高宽，而只是通过一些手段或者关联减少设置绝对位置和高度而已。

## 版本迁移（老版本迁移需要注意）
  因为历史的原因，原先的枚举类型的值都是大写,以及原来的一些UIView的一些扩展方法可能会和其他的库的扩展方法产生冲突。下面列出新老名称的映射表：

  | 名称        | 老命名           | 新命名  |
| ------------- |:-------------:| -----:|
| 位置停靠枚举定义 | MarignGravity      |    MyMarginGravity |
| 位置停靠枚举值 | 大写格式      |    大小写格式 |
| 布局方向枚举定义 | LineViewOrientation      |    MyLayoutViewOrientation |
| 布局方向枚举值 | 大写格式      |    大小写格式 |
| 视图的xxMargin扩展方法 |    xxMargin   |    myXXMargin |
| 视图的高宽扩展方法 |    width,height   |    myWidth,myHeight |
| 视图的中心偏移 |    centerXXOffset   |    myCenterXXOffset |


如果您在代码中还使用老的命名系统也会让您编译通过，但是会提示过期的警告，因此建议您将名称迁移到新的命名中来，对于类名以及枚举的迁移相对简单，只要利用工程中的查找替换功能就能完成。最麻烦的就是原先的leftMargin,rightMargin,topMargin,bottomMargin,centerXoffset,centerYOffset,centerOffset,width,height这9个属性方法的迁移会比较麻烦，您不能用全局查找替换的方法，最好是通过编译出现的错误进行一一替换,或者通过全局查找替换功能并使用Preview进行有选择的替换（这里深表对不起）。  

如果您不想进行迁移，但是又不出现告警提示的话，则可以在***pch文件中***，***工程的宏定义中***，以及在***MyLayoutDef.h的最开头***这三种方法的任意一种方法中定义四个宏：

`  #define MY_USEOLDMETHODDEF 1 `   //表示继续使用那些老的方法， 

`  #define MY_USEOLDMETHODNOWARNING 1 `   //表示使用老方法时不出现告警

`  #define MY_USEOLDENUMDEF 1 `  //表示继续使用老的枚举类型定义 

`  #define MY_USEOLDENUMNOWARNING 1 ` //表示使用老的枚举类型时不出现警告
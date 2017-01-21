#版本变更日志
**MyLayout**的所有版本的变更日志都将会在这里记录.

---

## [V1.3.2](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.3.2)(2017/1/20)

#### Added
1. 流式布局`MyFlowLayout`添加了对分页滚动的支持，通过新增加的属性`pagedCount`来实现，这个属性只支持数量约束流式布局。`pagedCount`和`wrapContentHeight以及wrapContentWidth`配合使用能够实现各种方向上的分页滚动效果(具体见DEMO：FLLTest5ViewController)
2. 线性布局`MyLinearLayout`中完全支持了所有子视图的高度等于宽度的设置的功能，以及在水平线性布局中添加了子宽度等于高度的功能。

#### Changed
1. 流式布局`MyFlowLayout`中的子视图的widthDime,heightDime中可设置的相对类型尺寸的值的维多扩宽，不仅可以依赖兄弟视图，父视图，甚至还可以依赖别的任意的视图。

#### Fixed
1. 修复了[#BUG30](https://github.com/youngsoft/MyLinearLayout/issues/30)，主要原因是当计算出视图的尺寸为小于0时，而又将这个尺寸用来设置视图的bounds属性的尺寸时会调整bounds的origin部分而产生的BUG。具体展示是视图的位置产生了不正确的错误。




## [V1.3.1](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.3.1)(2016/12/28)

#### Added
1. 布局位置类`MyLayoutPos`和布局尺寸类`MyLayoutSize`类中添加了新属性：`active`.用来描述指定的位置或者尺寸所设置的约束是否有效。
2. 添加了Demo:ALLTest8ViewController这个例子专门用来演示把一个布局视图加入到非布局父视图时的使用方法。

#### Fixed
1. 修正了将一个具有`wrapContentWidth`或者`wrapContentHeight`属性设置的布局视图加入到非布局父视图时，且又设置centerXPos，centerYPos,rightPos,bottomPos来定位布局视图时无法正确定位布局视图位置的BUG。

#### Changed
1. 修改了将布局视图加入`UIScrollView`时会自动调整`UIScrollView`的`contentSize`的机制，新的机制中布局视图设置的`MyLayoutPos`边距值也会算到contentSize里面去。比如某个布局的高度是100，其中的myTopMargin = 10, 那么当将布局视图加入到UIScrollView时他的contentSize的高度则是110.


## [V1.3.0](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.3.0)(2016/12/21)

#### Added
1. 添加对布局位置类`MyLayoutPos`的方法:`lBound,uBound`用来设置视图的位置最小最大的依赖，`lBound，uBound`方法只有在相对布局中的子视图设置才有效。
2. 添加了Demo:RLTest5ViewController这个例子专门用来演示相对布局中的子视图设置lBound,uBound方法的例子。

#### Fixed
1. 修复路径布局`MyPathLayout`中设置`wrapContentWidth`和`wrapContentHeight`为YES时的计算错误的情况。
2. 修复线性布局`MyLinearLayout`里面均分间距和均分视图两个方法可能导致均分不正确的BUG。
3. 修复了相对布局`MyRelativeLayout`中如果设置了`topPadding`而子视图的`topPos`设置为数值时`topPadding`不起作用的[BUG#29](https://github.com/youngsoft/MyLinearLayout/issues/29)。
4. 修复了相对布局`MyRelativeLayout`中子视图的高度设置为`flexedHeight`时计算可能不正常的问题。

#### Changed
1. 优化了相对布局和框架布局时的性能。

## [V1.2.9](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.9)(2016/12/5)

#### Added
1. **MyMarginGravity**枚举类型添加了`MyMarginGravity_Horz_Between，MyMarginGravity_Vert_Between`两个新的类型的值，用于描述对布局里面子视图的拉伸操作。
2. 扩充了线性布局**MyLinearLayout**中的`gravity`属性的功能（具体见LLTest3ViewController应用）。
3. 扩充了流式布局**MyFlowLayout**中的`gravity`属性的功能(具体见FLLTest1ViewController应用)。
4. 为流式布局**MyFlowLayout**添加了新的方法：`-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace` 用来实现内容约束流式布局的动态间距调整的功能，通过这个方法可以实现多屏幕的完美适配。
5. 添加了工程中的单元测试的target和UI单元测试target。

#### Changed
1. 浮动布局**MyFloatLayout**中的方法：~~`-(void)setSubviewFloatMargin:(CGFloat)subviewSize minMargin:(CGFloat)minMargin`~~ 将过期，替换为新的方法：`-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace`。
2. 流式布局**MyFlowLayout**中的均分子视图尺寸的属性：~~`averageArrange`~~ 将过期，替换为对`gravity`属性的设置。
3. 对功能中的相同类型的DEMO进行了分组，以便更加方便的查找对应的例子。

#### Fixed
1. 修复了将布局视图添加到非布局父视图时，当父布局视图的位置变化因此布局视图更新布局的问题。

## [V1.2.8](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.8)(2016/11/25)
 
#### Changed
1. 将老版本中的**MyLayoutDime**类更名为**MyLayoutSize**类。
2. 将老版本提供的调试视图布局属性的方法改为了使用`po viewobj.myFrame.sizeClass` 或者 `expr -o -- viewobj.myFrame.sizeClass` 两种方法。


#### Fixed
1. 修复了将布局视图加入到非布局父视图时，而又在布局视图上设置了`transform`进行坐标变换时的布局可能失效的问题。最新版本已经能和视图的`transform`属性共同使用了，原因是老版本中最终进行布局时修改的是frame属性，而新版本中将所有对frame属性的修改都变化为了center和bounds两个属性。
2. 修复了布局里面布局计算时浮点数==, !=, <=, >=比较时可能会出现的精度误差而导致的布局不正确的问题。
3. 修复了流式布局**MyFlowLayout**在设置了间距时且最后一行(一列)设置了比重时的尺寸计算错误的BUG。
4. 修复了框架布局**MyFrameLayout**在iOS7上如果子视图宽度等于高度，且居中对齐时的布局错误的BUG。


##[V1.2.7](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.7)(2016/11/13)
 

#### Added
1. 为线性布局**MyLinearLayout**新增加了属性`shrinkType`。这个属性可以用来控制当子视图中有比重尺寸或者相对间距，而又有固定尺寸比布局视图的尺寸还大时，用于缩小这些固定尺寸视图的尺寸值的方法。(具体见AllTest7ViewController应用)。
2. 为布局视图添加了`rotationToDeviceOrientationBlock`属性。这个block给予用户在布局视图第一次完成或者有屏幕旋转时进行界面布局处理的机会。我们可以通过这个block块来处理设备屏幕旋转而需要改动布局的场景。这个block块不像`beginLayoutBlock`以及`endLayoutBlock`那样只调用一次，而是第一次布局完成以及每次屏幕旋转并布局完成后都会调用，因此要注意循环引用的问题。(具体见LLTest6ViewController应用）。
3. 添加了**MyLayoutDime**中的`uBound`和`lBound`方法中最大最小值设置时可以等于自己的情况，这样目的是为了保证视图本身的尺寸不被压缩。(具体见AllTest7ViewController应用)。
4. 添加了在调试时使用`po 视图对象.absPos.sizeClass` 或者`expr -o -- 视图.absPos.sizeClass` 方法时可以输出布局设置的各种布局属性值。
5. 添加了将布局视图作为非布局视图的子视图的四周边距值可以是相对边距的支持，也就是当布局视图作为非布局视图的子视图时设置的`topPos,rightPos,topPos,bottomPos`的值是大于0且小于1时表明的是相对边距。
6. 添加了AllTest7ViewController这个新的DEMO，用来解决一些实践中各种屏幕尺寸下布局的完美处理方案。

#### Changed 

1. 线性布局**MyLinearLayout**中去掉了当子视图中有设置比重，或者子视图中设置相对间距时而又设置了布局视图的`wrapContentWidth`或者`wrapContentHeight`属性时,`wrapContentWidth`或者`wrapContentHeight`设置失效的限制。(具体见AllTest7ViewController应用)。

#### Fixed
 
1. 线性布局**MyLinearLayout**中的水平线性布局中修复了一个当子视图中有比重尺寸或者相对间距，而又有固定尺寸比布局视图的尺寸还大时，缩小那些具有固定尺寸的子视图的宽度的一个BUG。
2. 修复了视图尺寸**MyLayoutDime**的`uBound,lBound`方法的最大最小尺寸设置为父布局视图时，而布局视图又有`padding`时，没有减去`padding`值的BUG。


## [V1.2.6](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.6)(2016/10/28)

#### Changed
1. 为了解决和**Masonry**两个库共存时，打开了**Masonry**的宏`MAS_SHORTHAND_GLOBALS`时造成`offset, equalTo`方法无法使用的问题，解决的方法是您可以在PCH或者在使用MyLayout.h之前定义：`#define MY_USEPREFIXMETHOD` 这个宏，这样所有**MyLayoutPos, MyLayoutDime**中的方法都增加了前缀my。 比如原来的: `A.leftPos.equalTo(@10) ==> A.leftPos.myEqualTo(@10)`
 
#### Fixed
1. 优化代码，修复一个设置布局尺寸**MyLayoutDime**的`uBound,lBound`方法时可以指定其他任意视图的问题。

##[V1.2.5](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.5)(2016/10/8)

#### Updated
1. 优化了`beginLayoutBlock`和`endLayoutBlock`的调用时机，以及解决了可能这两个block块会出现循环引用的问题，同时优化了`viewLayoutCompleteBlock`可能会出现循环引用的问题
   
#### Fixed
1. 修复了布局视图隐藏属性hidden设置时可能会出现的布局的问题，尤其是当布局视图作为相对布局视图里面的子视图时。

## [V1.2.4](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.4)(2016/8/18)

#### Added
 1. 浮动布局**MyFloatLayout**增加了新属性`noBoundaryLimit`，用来实现那些只要单向浮动且没有边界限制的场景。（具体见FOLTest6ViewController应用）。
 2. 添加了2个DEMO，一个是RLTest4ViewController用来介绍布局在滚动条上滚动式停靠的实现。一个是FOLTest6ViewController用来介绍用浮动布局实现一些用户配置方面的DEMO。
 
#### Updated
1. 优化了布局方法`estimateLayoutRect`，优化了那些布局套布局的尺寸的评估的计算方法，加快了对动态高度评估计算的速度。
  

## [V1.2.3](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.3)(2016/8/2)

#### Added
1. 添加了新的布局：路径布局**MyPathLayout**。通过路径布局您只需要提供一个生成路径曲线的方程、以及指定子视图在路径曲线之中的距离等信息就可以让子视图按照指定的路径曲线进行布局，因此路径布局可以实现一些非常酷炫的效果。(具体见PLTest1,2,3,4ViewController应用）

2. 添加了子视图的新方法:`@property(nonatomic,copy) void (^viewLayoutCompleteBlock)(MyBaseLayout* layout, UIView *v);` 这个方法是在每个子视图布局完成后会调用一次，然后自动销毁。您可以实现这个block来进行一些子视图布局完成后的设置，一般实现这个块用来完成一些特定的动画效果，以及取值操作。(具体见RLTest1ViewController,PLTest1ViewController应用）。

3. 添加了对布局视图里面的子视图通过transform进行坐标变换的支持功能，在您对子视图进行坐标变换操作时，您可以可以通过设置扩展属性来确定子视图的尺寸和位置。

#### Updated
1. 完善了智能边界线的能力，如果您在布局视图中设置了subviewMargin属性的话，布局系统将会自动的将智能边界线一分为二。（具体见TLTest3ViewController见）

#### Changed
1. 布局基类的属性：~~`adjustScrollViewContentSize`~~被设置为过期，改为通过`adjustScrollViewContentSizeMode`属性来设置当布局视图加入到UIScrollView时调整其contentSize的方式。

#### Fixed
1. 修正了一个线性布局中当布局视图的尺寸没有子视图尺寸大，而子视图又设置了`weight`属性时可能导致的计算不正确的问题。
 
## [V1.2.2](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.2)(2016/7/8)

#### Added
 1. 流式布局**MyFlowLayout**中的子视图添加了对`weight`属性的支持，流式布局中的`weight`属性表示的是剩余空间的占比。通过`weight`属性的使用，我们可以在很多用线性布局实现的布局，改用流式布局来完成，从而减少布局的嵌套。流式布局具有HTML中的Flex的特性。(具体见FLLTest4ViewController应用)。
 
2. 布局视图增加了子视图反序排列的功能属性：`@property(nonatomic, assign) BOOL reverseLayout;` 这个属性可以按子视图添加的逆顺序进行界面布局。(具体见AllTest4ViewController应用).

#### Fixed
 
1. 修正了浮动布局**MyFloatLayout**中`weight`计算的问题，由原先的减间距再乘比例改为先乘比例再减间距

## [V1.2.1](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.1)(2016/6/28)

#### Added
1. 垂直线性布局里面添加了A.heightDime.equalTo(A.widthDime)的支持。水平线性布局不支持。

#### Changed
1. 优化了代码结构，增加了代码的可读性。

#### Fixed
1. 修正了相对布局中子视图隐藏时，相关子视图重新排列布局可能导致不正确的问题。相对布局中子视图隐藏时其他视图重新排列布局的算法是：隐藏的子视图的尺寸设置为0，所以依赖隐藏的子视图的边距依赖无效，变为依赖隐藏子视图所依赖的边距。


##[V1.2.0](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.2.0)(2016/6/13)

#### Fixed
1. 修复了垂直线性布局中同时设置`myLeftMargin,myRightMargin`并且设置了`gravity=MyMarginGravity_Horz_Center`时前者设置失效的问题。水平线性布局亦然。


## [V1.1.9](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.1.9)(2016/6/11)

#### Added
1. 添加对DEMO的国际化的支持。


## [V1.1.8](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.1.8)(2016/6/8)

#### Added
1. 增加了浮动布局**MyFloatLayout**设置浮动间距的方法`setSubviewFloatMargin` (具体见：FOLTest4ViewController)。

#### Fixed
1. 修复了表格布局MyTableLayout和智能边界线的结合的问题。(具体见TLTest3ViewController)

## [V1.1.7](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.1.7)(2016/6/6)


#### Added

 1. 为表格布局添加行间距:`rowSpacing`和列间距:`colSpacing`两个属性，用来设置表格的行和列之间的间距。 (具体见TLTest2ViewController)
 2. 为布局添加方法：`layoutAnimationWithDuration`用来实现布局时的动画效果。(具体见：各个DEMO)
 3. 新增加了扩展`flexedHeight`属性对于**UIImageView**的支持。当对一个**UIImageView**设置`flexedHeight`为YES时则其在布局时会自动根据**UIImageView**设置的宽度等比例缩放其高度。这个特性在瀑布流实现中非常实用。(具体见TLTest2ViewController)
 4. 为浮动布局**MyFloatLayout**提供`subviewMargin、subviewVertMargin、subviewHorzMargin`三个新属性，用来设置浮动布局中各视图的水平和垂直间距。 (具体见：FOLTest4ViewController，FOLTest5ViewController)
 5. 为布局视图下的子视图的尺寸提供了设置最大尺寸以及最小尺寸的新功能，原先的MyLayoutDime中的`min,max`两个方法只能用来设置最小最大的常数值。**MyLayoutDime**新增加的方法`lBound,uBound`则功能更加强大。除了可以设置常数限制尺寸外，还可以设置对象限制尺寸。(具体见：AllTest2ViewController，AllTest3ViewController) 
 6. 系统自动处理了大部分可能出现布局约束冲突的地方，减少了约束冲突出现的可能性。以及出现了约束冲突时告警以及crash的提示。
 
#### Updated

1. 对线性布局中的浮动间距进行优化，支持宽度自动调整的能力.(具体见：AllTest3ViewController)
2. 完善了将布局视图加入到非布局父视图时的位置和尺寸设置。您可以用myXXXMargin方法以及myHeight,myWidth方法设置其在非布局父视图上的位置和尺寸。
3. 修改表格布局的`addRow:colSize:以及insertRow:colSize:atIndex`的方法名，将原来的`colWidth改为了colSize`。 (具体见：TLTest2ViewController)
4. 修改了表格布局的特殊尺寸的宏定义：MTLSIZE_XXXX  (具体见：TLTest1ViewController，TLTest2ViewController)
5. 所有代码部分的注释重新编写，更加有利于大家的理解。
6. 重新编写了大部分的DEMO例子。
 
#### Fixed 

1. 修复了浮动布局加入到**UIScrollview**中不能自动固定的问题。
2. 修正了相对布局嵌套其他布局时，高度评估方法可能不正确的问题。
3. 修正了线性布局在计算高度和宽度时的一个问题。

##[V1.1.6](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.1.6)(2016/5/3)

1.  **MyLayoutDime**类的`equalTo`方法添加可以等于自身的功能。比如`a.widthDime.equalTo(a.widthDime).add(10);` 表示视图a的最终宽度等于其本身内容的宽度再加上10. 这种设置方法不会造成循环引用，主要用于那些需要在自身内容尺寸基础上再扩展尺寸的场景，(具体见： FLLTest2ViewController).
2.  流式布局**MyFlowLayout**中的内容填充布局为了解决每行内容的填充空隙问题，增加了拉伸间距，拉伸尺寸，以及自动排列三种功能。拉伸间距需要设置属性`gravity`的值为`MyMarginGravity_Horz_Fill`或者`MyMarginGravity_Vert_Fill`；拉伸尺寸需要设置属性`averageArrange`的值为YES；自动排列则需要设置属性`autoArrange`的值为YES。（具体见*FLLTest2ViewController）。
3.  添加了新的视图扩展属性`noLayout`。这个属性设置为YES时表示子视图会参与布局，但是并不会真实的调整其在布局视图中的位置和尺寸，而布局视图则会保留出这个子视图的布局位置和尺寸的空间。这个属性和`useFrame`混合使用用来实现一些动画效果。(具体见FLLTest3ViewController）
4.  框架布局**MyFrameLayout**支持了`wrapContentHeight`和`wrapContentWidth`设置为YES的功能。
5.  布局视图添加新的属性`highlightedOpacity`，用来指定当布局Touch事件的高亮不透明度值。(具体例子见：AllTest1ViewController)
6. 修正了**MyTableLayout**中的一个BUG。
7.  将布局库中的所有注释部分重新进行了格式化和调整。
8.  优化了布局中的一些性能问题。
9.  去掉了对过期代码的兼容性。

## [V1.1.5](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.1.5)(2016/4/7)
1. 添加了新的布局浮动布局**MyFloatLayout*，浮动布局实现不规则的子视图的排列，卡片布局。设计思想是从HTML中的CSS样式的float属性得到了。
2. 新增智能边界线的功能，通过智能边界线的设定，可以让布局中的子布局根据排版而自动生成边界线，而不需要手动去设置。
3. 修正了各布局的`wrapContentHeight`和 `wrapContentWidth` 可能计算不正确的问题。
4. 修正了布局视图的`leftBorderLineLayer`的宽度不正确的问题。
5. 增加了**MyLayoutDime**和**MyLayoutPos**这两个类中的方法`clear`，以便能快速的清除掉所有的设置。
6. 优化了速度和性能的问题。


##[V1.1.4](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.1.4)(2016/3/10)
1. 修正了尺寸评估函数`estimateLayoutRect`的一个多层嵌套是无法正确评估尺寸的BUG。
2. 添加了属性`myMargin`用来简单快速的设置myLeftMarign,myTopMargin,myRightMargin,myBottomMargin都是相等的值。
3. 增加了`MyDimeScale`这个工具类，用来实现不同屏幕的尺寸和位置的缩放的功能，加入我们的UI给我们的是iPhone6的设计图，并指定了某个视图的高度为100但又同时希望在iPhone5上高度缩小，而在iPhone6Plus上高度增加，则可以通过`[MyDimeScale scale:100]`得到各种屏幕的缩放后的值了。


##[V1.1.3](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.1.3)(2016/2/22)
1.  对SizeClass支持和竖屏`MySizeClass_Portrait`和横屏`MySizeClass_Landscape`。以便支持单独的横屏和竖屏的界面适配，尤其是对iPad设备的横竖屏进行区分适配。

##[V1.1.2](https://github.com/youngsoft/MyLinearLayout/releases/tag/1.1.2)(2016/2/18)
1.  全面升级，新增加了对**SizeClass**的支持，通过**SizeClass**的功能可以为苹果的不同尺寸的设备提供完美的适配功能，对**SizeClass**的支持，是在苹果的**SizeClass**能力上支持的，因此只有iOS8以上的版本才支持SizeClass.
2.  流式布局**MyFlowLayout**增加了按内容填充约束的方式的布局，当`arrangedCount`设置为0时则表示按内容约束方式进行布局。
3.  添加了一个新的视图扩展属性`mySize`，以便为了简化同时设置myWidth,myHeight的能力。
4.  将原先的布局基类名字**MyLayoutBase**更名为**MyBaseLayout**.
5.  修正了直接从**MyLinearLayout**或者**MyFlowLayout**建立派生类并初始化可能会出现的死循环的问题。
6.  增加了对布局视图的autoresizesSubviews属性的支持，这个属性默认是设置为YES，如果设置为NO则布局视图不会产生任何的布局动作，也就是所有的子视图的frame的设置是最终的布局的结果，设置这个属性的作用主要用来实现一些子视图的动画。
7.  修正了其他的BUG。

## [V1.1.1]
1.	新增加了一个mySize属性可以设置布局的宽度和高度，相当于同时设置myWidth,myHeight
2.	修正了和iOS的AutoLayout结合使用时可能出现的布局定位不正确的问题，这个版本可以同时和frame,AutoLayout布局进行混合使用。
3.	修正了其他的小问题，以及注释进行了优化和完整。
4.	将原来的leftMargin,rightMargin,topMargin,bottomMargin,width,height,centerXOffset,centerYOffset,centerOffset这几个方法进行了命名冲突兼容，新版本都在前面增加了my前缀，如果要保持老版本请定义宏：`  #define MY_USEOLDMETHODDEF 1 ` 和`  #define MY_USEOLDMETHODNOWARNING 1 `。
5.	将原来的的MarginGravity枚举类型和LineViewOrientation枚举类型重新定义为：MyMarginGravity和MyLayoutViewOrientation。里面的枚举值也进行重新定义，但可以定义宏：`  #define MY_USEOLDENUMDEF 1 `和`  #define MY_USEOLDENUMNOWARNING 1 `来兼容老版本。


## [V1.1.0]
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
 

 

# MyLinearLayout
     一套功能强大的iOS布局库，他不是在自动布局的基础上进行的封装，而是一套原生的基于对frame设置的封装，因此可以无限制的运行在任何版本的iOS系统中。其设计思想以及原理则参考了android的布局原理，而比android的布局库以及iOS的自动布局库功能更加强大，其分别提供了：线性布局MyLinearLayout、相对布局MyRelativeLayout、框架布局MyFrameLayout、表格布局MyTableLayout、流式布局MyFlowLayout五个布局类，各种类应用的场景不大一样，具体的使用方法请看Demo中的演示代码以及到我的CSDN主页中了解：

[http://blog.csdn.net/yangtiang/article/details/46483999](http://blog.csdn.net/yangtiang/article/details/46483999)   线性布局
[http://blog.csdn.net/yangtiang/article/details/46795231](http://blog.csdn.net/yangtiang/article/details/46795231)   相对布局
[http://blog.csdn.net/yangtiang/article/details/46492083](http://blog.csdn.net/yangtiang/article/details/46492083)   框架布局
[http://blog.csdn.net/yangtiang/article/details/48011431](http://blog.csdn.net/yangtiang/article/details/48011431) 表格布局



![演示图](http://cdn.cocimg.com/bbs/attachment/postcate/topic/16/319791_189_96f0143980087354c17bbc75c8a37.gif)


版本V1.1更新功能如下：

1.增加了流式布局

2.修改了布局内添加UIScrollView时没有橡皮筋效果

3.添加了MGravity中的屏幕水平居中和屏幕垂直居中的功能。

4.添加了布局视图背景图片的设置功能。

5.添加了视图偏移约束的最大最小值限制，以及尺寸约束时的最大最小值限制

6.添加了布局尺寸评估以及视图的评估rect值的功能。

7.添加了框架布局中的子视图的高度和宽度设置功能。

8.优化了一些约束冲突的解决。

9.优化了布局视图添加到非布局视图时的位置和尺寸调整功能。

10.添加了在布局中让某个子视图不参与布局的功能。

11.添加了线性布局均分视图设置边距的功能。

12.修正了子视图恢复隐藏时的界面不重绘的问题。

13.修正了布局边界线的缩进显示的问题。

14.修正UITableView，UICollectionView下添加布局可能会造成的问题。

15.修正了布局占用大量内存的问题。

16.添加了线性布局中设置视图之间间距的功能

17.添加了布局视图设置按下事件，按下被取消的事件。

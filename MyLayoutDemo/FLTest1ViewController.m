//
//  FLTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@interface FLTest1ViewController ()

@end

@implementation FLTest1ViewController

-(UILabel*)createLabel:(NSString*)title backgroundColor:(UIColor*)color
{
    UILabel *v = UILabel.new;
    v.text = title;
    v.font = [CFTool font:15];
    v.textAlignment = NSTextAlignmentCenter;
    v.backgroundColor = color;
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [CFTool color:4].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;
    [v sizeToFit];

    return v;
}

-(void)loadView
{
    /*
     使用MyLayout时必读的知识点：
     
     
     1.布局视图：    就是从MyBaseLayout派生而出的不同的类型的视图，目前MyLayout中一共有：线性布局、框架布局、相对布局、表格布局、流式布局、浮动布局、路径布局7种布局。 布局视图也是一个视图，因为MyBaseLayout也是从UIView派生的。
     2.非布局视图：  除上面说的7种布局视图外的所有视图和控件。
     3.布局父视图：  如果某个视图的父视图是一个布局视图，那么这个父视图就是布局父视图。
     4.非布局父视图：如果某个视图的父视图不是一个布局视图，那么这个父视图就是非布局父视图。
     5.布局子视图：  如果某个视图的子视图是一个布局视图，那么这个子视图就是布局子视图。
     6.非布局子视图：如果某个视图的子视图不是一个布局视图，那么这个子视图就是非布局子视图。
     
     
     这要区分一下边距和间距和概念，所谓边距是指子视图距离父视图的距离；而间距则是指子视图距离兄弟视图的距离。myLeft,myRight,myTop,myBottom这几个子视图的扩展属性即可用来表示边距也可以用来表示间距，这个要根据子视图所归属的父布局视图的类型而确定：
     
     1.垂直线性布局MyLinearLayout中的子视图： myLeft,myRight表示边距，而myTop,myBottom则表示间距。
     2.水平线性布局MyLinearLayout中的子视图： myLeft,myRight表示间距，而myTop,myBottom则表示边距。
     3.表格布局中的子视图：                  myLeft,myRight,myTop,myBottom的定义和线性布局是一致的。
     4.框架布局MyFrameLayout中的子视图：     myLeft,myRight,myTop,myBottom都表示边距。
     5.相对布局MyRelativeLayout中的子视图：  myLeft,myRight,myTop,myBottom都表示边距。
     6.流式布局MyFlowLayout中的子视图：      myLeft,myRight,myTop,myBottom都表示间距。
     7.浮动布局MyFloatLayout中的子视图：     myLeft,myRight,myTop,myBottom都表示间距。
     8.路径布局MyPathLayout中的子视图：      myLeft,myRight,myTop,myBottom即不表示间距也不表示边距，它表示自己中心位置的偏移量。
     9.非布局父视图中的布局子视图：           myLeft,myRight,myTop,myBottom都表示边距。
     10.非布局父视图中的非布局子视图：         myLeft,myRight,myTop,myBottom的设置不会起任何作用，因为MyLayout已经无法控制了。
     
     再次强调的是：
     1. 如果同时设置了左右边距就能决定自己的宽度，同时设置左右间距不能决定自己的宽度！
     2. 如果同时设置了上下边距就能决定自己的高度，同时设置上下间距不能决定自己的高度！
     
     */

    
    
    /*
       这个例子主要介绍了框架布局的功能。框架布局里面的所有子视图的布局位置都只跟框架布局相关。
       框架布局中的子视图可以层叠显示，因此框架布局常用来作为视图控制器里面的跟视图。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    [super loadView];
    
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.backgroundColor = [UIColor whiteColor];
    frameLayout.myMargin = 0;              //这个表示框架布局的尺寸和self.view保持一致,四周离父视图的边距都是0
    frameLayout.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.view addSubview:frameLayout];
    
    /*
     建立12个子视图，并进行布局。这12个子视图表示可以在框架布局中定位和填充的12个位置和尺寸。
     */
    
    //显示全屏
    UILabel *fill = [self createLabel:@"" backgroundColor:[CFTool color:0]];
    fill.myMargin = 0;
    [frameLayout addSubview:fill];
    
    
    //左右填充。
    UILabel *horzFill = [self createLabel:@"horz fill" backgroundColor:[CFTool color:8]];
    horzFill.myHorzMargin = 0;  //右边边距是0
    horzFill.myTop = 40;
    [frameLayout addSubview:horzFill];
    
    //上下填充
    UILabel *vertFill = [self createLabel:@"vert fill" backgroundColor:[CFTool color:9]];
    vertFill.numberOfLines = 0;
    vertFill.myVertMargin = 0; //上下边距是0
    vertFill.myLeading = 90;
    vertFill.myWidth = 10;
    [frameLayout addSubview:vertFill];

        
    //左上(默认)
    UILabel *topLeading = [self createLabel:@"top leading" backgroundColor:[CFTool color:5]];
    topLeading.myLeading = 0;
    topLeading.myTop = 0;
    [frameLayout addSubview:topLeading];
    
    //左中
    UILabel *centerLeading = [self createLabel:@"center leading" backgroundColor:[CFTool color:5]];
    centerLeading.myLeading = 0;
    centerLeading.myCenterY = 0;
    [frameLayout addSubview:centerLeading];
    
    
    //左下
    UILabel *bottomLeading = [self createLabel:@"bottom leading" backgroundColor:[CFTool color:5]];
    bottomLeading.myLeading = 0;
    bottomLeading.myBottom = 0;
    [frameLayout addSubview:bottomLeading];
    
    
    //中上
    UILabel *topCenter = [self createLabel:@"top center" backgroundColor:[CFTool color:6]];
    topCenter.myCenterX = 0;
    topCenter.myTop = 0;
    [frameLayout addSubview:topCenter];
    
    
    //中中。
    UILabel *centerCenter = [self createLabel:@"center center" backgroundColor:[CFTool color:6]];
    centerCenter.myCenterX = 0;
    centerCenter.myCenterY = 0;
    [frameLayout addSubview:centerCenter];
    
    
    //中下
    UILabel *bottomCenter = [self createLabel:@"bottom center" backgroundColor:[CFTool color:6]];
    bottomCenter.myCenterX = 0;
    bottomCenter.myBottom = 0;
    [frameLayout addSubview:bottomCenter];
    
    
    //右上
    UILabel *topTrailing = [self createLabel:@"top trailing" backgroundColor:[CFTool color:7]];
    topTrailing.myTrailing = 0;
    topTrailing.myTop = 0;
    [frameLayout addSubview:topTrailing];
    
    
    //右中
    UILabel *centerTrailing = [self createLabel:@"center trailing" backgroundColor:[CFTool color:7]];
    centerTrailing.myTrailing = 0;
    centerTrailing.myCenterY = 0;
    [frameLayout addSubview:centerTrailing];
    
    
    //右下
    UILabel *bottomTrailing = [self createLabel:@"bottom trailing" backgroundColor:[CFTool color:7]];
    bottomTrailing.myTrailing = 0;
    bottomTrailing.myBottom = 0;
    [frameLayout addSubview:bottomTrailing];
    


    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

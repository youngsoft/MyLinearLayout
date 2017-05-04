//
//  LLTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@interface LLTest1ViewController ()

@end

@implementation LLTest1ViewController

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
     
     
     这要区分一下边距和间距和概念，所谓边距是指子视图距离父视图的距离；而间距则是指子视图距离兄弟视图的距离。myLeft,myRight,myTop,myBottom,myLeading,myTrailing这几个子视图的扩展属性即可用来表示边距也可以用来表示间距，这个要根据子视图所归属的父布局视图的类型而确定：
     
     1.垂直线性布局MyLinearLayout中的子视图： myLeft,myRight,myLeading,myTrailing表示边距，而myTop,myBottom则表示间距。
     2.水平线性布局MyLinearLayout中的子视图： myLeft,myRight,myLeading,myTrailing表示间距，而myTop,myBottom则表示边距。
     3.表格布局中的子视图：                  myLeft,myRight,myTop,myBottom,myLeading,myTrailing的定义和线性布局是一致的。
     4.框架布局MyFrameLayout中的子视图：     myLeft,myRight,myTop,myBottom,myLeading,myTrailing都表示边距。
     5.相对布局MyRelativeLayout中的子视图：  myLeft,myRight,myTop,myBottom,myLeading,myTrailing都表示边距。
     6.流式布局MyFlowLayout中的子视图：      myLeft,myRight,myTop,myBottom,myLeading,myTrailing都表示间距。
     7.浮动布局MyFloatLayout中的子视图：     myLeft,myRight,myTop,myBottom,myLeading,myTrailing都表示间距。
     8.路径布局MyPathLayout中的子视图：      myLeft,myRight,myTop,myBottom,myLeading,myTrailing即不表示间距也不表示边距，它表示自己中心位置的偏移量。
     9.非布局父视图中的布局子视图：           myLeft,myRight,myTop,myBottom,myLeading,myTrailing都表示边距。
     10.非布局父视图中的非布局子视图：         myLeft,myRight,myTop,myBottom,myLeading,myTrailing的设置不会起任何作用，因为MyLayout已经无法控制了。
     
     再次强调的是：
     1. 如果同时设置了左右边距就能决定自己的宽度，同时设置左右间距不能决定自己的宽度！
     2. 如果同时设置了上下边距就能决定自己的高度，同时设置上下间距不能决定自己的高度！
     
     */

    
    /*
       myLeft和myRight用来设置左右位置，myLeading和myTrailing用来设置首尾位置。大部分国家和语言在布局时总是遵循从左到右的方向进行(LTR),而有些国家比如阿拉伯国家和语言在布局时则遵循从右到左的方向进行(LTR)。因此为了统一概念我们不再用左右(left, right)来表示水平的方向而是用首尾(leading, trailing)来表示水平的方向。对于LTR方向来说leading和left是一致的，trailing和right是一致的；对于RTL方向来说leading和right是一致的，trailing和left是一致的。如果您的界面布局不考虑左右方向或者不考虑国际化时就直接使用leftPos和rightPos就可以了。
     */
    
    
    /*
       很多同学都反馈问我：为什么要在loadView方法中进行布局而不在viewDidLoad中进行布局？ 以及在什么时候需要调用[super loadView]；什么时候不需要？现在统一回复如下：
     
       1.所有视图控制中的根视图view(self.view)都是在loadView中完成建立的，也就是说如果你的VC关联了XIB或者SB，那么其实会在VC的loadView方法里面加载XIB或者SB中的所有视图以及子视图，如果您的VC没有关联XIB或者SB那么loadView方法中将建立一个默认的根视图。而系统提供的viewDidLoad方法则是表示VC里面关联的视图已经建立好了，您可以有机会做其他一些初始化的事情。因此如果你想完全自定义VC里面的根视图和子视图的话那么建议您应该重载loadView方法而不是在viewDidLoad里面进行视图的创建和加载，换句话说就是loadView负责创建视图而viewDidLoad则是负责视图创建后的一些设置工作。
       2.因为MyLayout是一套基于代码的界面布局库，因此建议您从VC的根视图就使用布局视图。所以我这边的很多DEMO都是直接在loadView里面进行布局，并且把一个布局视图作为根视图赋值给self.view。因此如果您直接想把布局视图作为根视图或者想自定义根视图的实现那么您就可以不必要在loadView里面调用[super loadView]方法；如果您只是想把布局视图作为默认根视图的一个子视图的话那么您就必须要调用[super loadView]方法，然后再通过[self.view addSubview:XXXX]来将布局视图加入到根视图里面；如果您只是想把布局视图作为根视图的一个子视图的话，那么您也可以不用重载loadView方法，而是直接在viewDidLoad里面添加布局视图也是一样的。
      3.因为很多DEMO里面都是在loadView里面进行代码布局的，这个是为了方便处理，实际中布局视图是可以用在任何一个地方的，也可以在任何一个地方被建立，因为布局视图就是UIView的一个子视图，因此所有可以使用视图的地方都可以用布局视图。
     
     */
    

    /*
      一个视图可以通过对frame的设置来完成其在父视图中的定位和尺寸大小的设定。这种方法的缺点是要明确的指出视图所在的位置origin和视图的尺寸size，而且在代码中会出现大量的常数，以及需要进行大量的计算。MyLayout的出现就是为了解决布局时的大量常数的使用，以及大量的计算，以及自动适配的问题。需要明确的是用MyLayout进行布局时并不是不要指定视图的位置和尺寸，而是可以通过一些特定的上下文来省略或者隐式的指定视图的位置和尺寸，因为不管何种布局方式，视图布局时都必须要指定视图的位置和尺寸。使用MyLayout后如果您的代码中还大量出现了计算的场景以及大量出现常数和宏的场景的话那就表明您还没有熟练的应用好这个库。
     */
    
       
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
        
    //下面的例子中vertLayout是一个垂直线性布局，垂直线性布局中的子视图按照添加的顺序依次从上到下排列。
    
    UILabel *vertTitleLabel = [self createSectionLabel:NSLocalizedString(@"vertical(from top to bottom)",@"")];
    /**
     * 当导航控制器中的导航条或者工具条是半透明时并将布局视图作为控制器中的根视图时，控制器中的根视图将会延伸到整个屏幕。
     * 如果导航条不是半透明，或者您设置了视图控制中的edgesForExtendedLayout属性，或者视图控制器中的根视图是UIScrollView时那么就不会延伸至整个屏幕
     * 为了使布局视图里面的子视图不会延伸到导航条下面，你可以将布局视图的第一个子视图的topPos的值设置为视图控制器的topLayoutGuide值。这样的话
     * 系统会自动检测如果您的导航条是半透明的那么这个视图的位置总是会在导航条下面出现，而如果不是半透明导航条也会在导航条下面出现，而如果没有导航条时则
     * 就出现在屏幕的顶部。
     */
    vertTitleLabel.topPos.equalTo(self.topLayoutGuide).offset(10);  //顶部边距设置为10。
   // vertTitleLabel.topPos.equalTo(@10); //您可以注释上面，解开这句看看运行效果。
    [rootLayout addSubview:vertTitleLabel];
    
    
     
    MyLinearLayout *vertLayout = [self createVertSubviewLayout];//垂直线性布局的高度默认是由子视图的高度决定的，也就是wrapContentHeight默认设置为YES
    vertLayout.myHorzMargin = 0;  //对于垂直线性布局rootLayout的子视图vertLayout来说，如果同时设置了左右边距为0则表示子视图的宽度和父视图宽度相等。
    [rootLayout addSubview:vertLayout];
    
    
    
    //下面的例子中horzLayout是一个水平线性布局，水平线性布局中的子视图按照添加的顺序依次从左到右排列。
    
    UILabel *horzTitleLabel = [self createSectionLabel:NSLocalizedString(@"horizontal(from left to right)",@"")];
    horzTitleLabel.myTop = 10;
    [rootLayout addSubview:horzTitleLabel];
    
    MyLinearLayout *horzLayout = [self createHorzSubviewLayout];
    horzLayout.myLeft = horzLayout.myRight = 0;  //对于垂直线性布局rootLayout的子视图vertLayout来说，如果同时设置了左右边距为0则表示子视图的宽度和父视图宽度相等。这句代码和horzLayout.horzMargin = 0; 是等价的。
    horzLayout.weight = 1.0;   //高度则由weight设置为1确定的，表示其高度将占用整个垂直线性布局父视图的剩余高度，具体weight属性的意义参考类库中的属性介绍。
    [rootLayout addSubview:horzLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

-(UILabel*)createSectionLabel:(NSString*)title
{
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.text = title;
    sectionLabel.font = [CFTool font:17];
    [sectionLabel sizeToFit];             //sizeToFit函数的意思是让视图的尺寸刚好包裹其内容。注意sizeToFit方法必要在设置字体、文字后调用才正确。
    return sectionLabel;
}

-(UILabel*)createLabel:(NSString*)title backgroundColor:(UIColor*)color
{
    UILabel *v = [UILabel new];
    v.text = title;
    v.font = [CFTool font:15];
    v.numberOfLines = 0;
    v.textAlignment = NSTextAlignmentCenter;
    v.adjustsFontSizeToFitWidth = YES;
    v.backgroundColor =  color;
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [CFTool color:4].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;

    return v;
}

/**
 * 创建一个垂直的线性子布局。
 */
-(MyLinearLayout*)createVertSubviewLayout
{
    //创建垂直布局视图。
    MyLinearLayout *vertLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    vertLayout.backgroundColor = [CFTool color:0];

    /*
      对于垂直线性布局里面的子视图来说:
       1.默认子视图的左边都跟父视图左对齐，而上下则依次按加入的顺序排列。
       2.myLeft, myRight的意义是子视图距离父视图的左右边距。
       3.myLeading,myTrailing的意义是子视图距离父视图的首尾边距。(在LTR方向上myLeading和myLeft是等价的，myTrailing和myRight是等价的)
       4.myTop, myBottom的意义是子视图和兄弟视图之间的上下间距。
       5.如果同时设置了myLeft,myRight则除了能确定左右边距，还能确定子视图的宽度 = 布局视图的宽度 - myLeft - myRight
       6.如果同时设置了myTop,myBottom则只能确定和其他兄弟视图之间的上下间距，但不能确定子视图的高度。
       7.myCenterX表示子视图的水平中心点在父视图的水平中心点上的偏移。
       8.myCenterY的设置没有意义。
     */
    
    
    UILabel *v1 = [self createLabel:NSLocalizedString(@"left margin", @"") backgroundColor:[CFTool color:5]];
    v1.myTop = 10;  //上边间距10
    v1.myLeading = 10; //左边边距10
    v1.myWidth = 200;
    v1.myHeight = 35;     //设置布局尺寸
    [vertLayout addSubview:v1];

    
    UILabel *v2 = [self createLabel:NSLocalizedString(@"horz center", @"") backgroundColor:[CFTool color:6]];
    v2.myTop = 10;
    v2.myCenterX = 0;            //水平居中,如果不等于0则会产生居中偏移
    v2.mySize = CGSizeMake(200, 35);   //效果和上面意义一致！
    [vertLayout addSubview:v2];

    
    UILabel *v3 = [self createLabel:NSLocalizedString(@"right margin", @"") backgroundColor:[CFTool color:7]];
    v3.myTop = 10;
    v3.myTrailing = 10; //右边边距10
    v3.frame = CGRectMake(0, 0, 200, 35);  //设置视图的尺寸，详见下面的注释。
    [vertLayout addSubview:v3];

    /*
      对于布局里面的子视图来说我们仍然可以使用frame方法来进行设置，但是frame中的origin部分的设置将不起任何作用，size部分仍然会起作用。
     
     通过frame设置子视图尺寸和通过myWidth, myHeight,mySize来设置子视图布局尺寸的异同如下：
     1.二者都可以用来设置子视图的尺寸。
     2.通过frame设置视图的尺寸会立即生效，而通过后者设置尺寸时则只有在完成布局后才生效。
     3.如果同时设置了frame和myWidth, myHeight,mySize时，最终起作用的是后者，也就是后者的优先级要高。
     4.不管通过何种方式设置尺寸，在布局完成时都可以通过frame属性读取到最终布局的位置和尺寸。
     */
    
    
    UILabel *v4 = [self createLabel:NSLocalizedString(@"left right", @"") backgroundColor:[CFTool color:8]];
    v4.myTop = 10;
    v4.myBottom = 10;
    v4.myLeading = 10;
    v4.myTrailing = 10; //上面两行代码将左右边距设置为10。对于垂直线性布局来说如果子视图同时设置了左右边距则宽度会自动算出，因此不需要设置myWidth的值了。
    v4.myHeight = 35;
    [vertLayout addSubview:v4];

    
    return vertLayout;
    
}

/**
 * 创建一个水平的线性子布局。
 */
-(MyLinearLayout*)createHorzSubviewLayout
{
    //创建水平布局视图。
    MyLinearLayout *horzLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    horzLayout.backgroundColor = [CFTool color:0];
    

    /*
     对于水平线性布局里面的子视图来说:
     1.默认子视图的上边都跟父视图上对齐，而左右则依次按加入的顺序排列。
     2.myTop, myBottom的意义是子视图距离父视图的上下边距。
     3.myLeft, myRight的意义是子视图和兄弟视图之间的左右间距。
     4.myLeading,myTrailing的意义是子视图和兄弟视图之间的首尾间距。(在LTR方向上myLeading和myLeft是等价的，myTrailing和myRight是等价的)
     5.如果同时设置了myTop,myBottom则除了能确定上下边距，还能确定子视图的高度 = 布局视图的高度 - myTop - myBottom。
     6.如果同时设置了myLeft,myRight则只能确定和其他兄弟视图之间的左右间距，但不能确定子视图的宽度。
     7.myCenterY表示子视图的垂直中心点在父视图的垂直中心点上的偏移。
     8.myCenterX的设置没有意义。
     */

    
    UILabel *v1 = [self createLabel:NSLocalizedString(@"top margin", @"") backgroundColor:[CFTool color:5]];
    v1.myTop = 10; //上边边距10
    v1.myLeading = 10; //左边间距10
    v1.myWidth = 60;
    v1.myHeight = 60;
    [horzLayout addSubview:v1];

    
    
    UILabel *v2 = [self createLabel:NSLocalizedString(@"vert center", @"") backgroundColor:[CFTool color:6]];
    v2.myLeading = 10;
    v2.myCenterY = 0; //垂直居中，如果不等于0则会产生居中偏移
    v2.mySize = CGSizeMake(60, 60);
    [horzLayout addSubview:v2];

    
    UILabel *v3 = [self createLabel:NSLocalizedString(@"bottom margin", @"") backgroundColor:[CFTool color:7]];
    v3.myBottom = 10; //下边边距10
    v3.myLeading = 10;
    v3.myTrailing = 5;
    v3.frame = CGRectMake(0, 0, 60, 60);
    [horzLayout addSubview:v3];

    
    UILabel *v4 = [self createLabel:NSLocalizedString(@"top bottom", @"") backgroundColor:[CFTool color:8]];
    v4.myTop = 10;
    v4.myBottom = 10; //上面两行代码将上下边距设置为10,对于水平线性布局来说如果子视图同时设置了上下边距则高度会自动算出,因此不需要设置myHeight的值了。
    v4.myLeading = 10;
    v4.myTrailing = 10;
    v4.myWidth = 60;
    [horzLayout addSubview:v4];

    
    return horzLayout;
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

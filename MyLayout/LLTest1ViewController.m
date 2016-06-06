//
//  Test1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest1ViewController.h"
#import "MyLayout.h"

@interface LLTest1ViewController ()

@end

@implementation LLTest1ViewController


-(void)loadView
{

    /*
      一个视图可以通过对frame的设置来完成其在父视图中的布局。这种方法的缺点是要明确的指出视图所在的位置origin和视图所在的尺寸size，而且在代码中会出现大量的常数，以及需要进行大量的计算。MyLayout的出现就是为了解决布局时的大量常数的使用，以及大量的计算，以及自动适配的问题。需要明确的是用MyLayout进行布局时并不是不要指定视图的位置和尺寸，而是可以通过一些特定的上下文来省略或者隐式的指定视图的位置和尺寸。因此不管何种布局方式，视图布局时都必须要指定视图的位置和尺寸。
     */
    
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.wrapContentHeight = NO;
    rootLayout.wrapContentWidth = NO;   //如果将布局视图作为视图控制器的根视图则必须将wrapContentWidth和wrapContentHeight设置为NO,
    self.view = rootLayout;
    

    /*
     vertTitle是垂直布局下的子视图，因此位置部分的y轴部分会根据添加的先后顺序确定；x轴部分则根据myCenterXOffset为0表示视图的水平中心点和父布局视图的水平中心点相等而确定；视图的尺寸则根据sizeToFit函数而确定。
     */
    UILabel *vertTitleLabel = [UILabel new];
    vertTitleLabel.text = @"垂直布局(从上到下)";
    vertTitleLabel.myCenterXOffset = 0;     //视图的水平中心点和布局视图的水平中心点保持一致。
    [vertTitleLabel sizeToFit];             //sizeToFit函数的意思是让视图的尺寸刚好包裹其内容。注意sizeToFit方法必要在设置字体、文字后调用才正确。
    [rootLayout addSubview:vertTitleLabel];

    /*
     vertLayout是垂直布局下的垂直布局子视图，因此位置部分的y轴部分会根据添加的先后顺序确定；x轴部分则是根据myLeftMargin=0表示左边和父视图保持一致而确定；宽度则是根据同时设置了左右边距而确定(注意！垂直线性布局里面的子视图同时设置左右边距才能决定宽度，而同时设置上下边距是不能决定高度。同理水平线性布局里面的子视图同时设置上下边距才能决定高度，而同时设置左右边距是不能决定宽度的。)；高度则因为vertLayout是垂直线性布局默认wrapContentHeight=YES，也就是说高度由里面的子视图决定的，所以高度也就是确定的。
     */
    MyLinearLayout *vertLayout = [self createVertSubviewLayout];
    vertLayout.myLeftMargin = vertLayout.myRightMargin = 0;  //对于垂直线性布局的子视图来说，如果同时设置了左右边距为0则表示子视图的宽度和父视图宽度相等。
    [rootLayout addSubview:vertLayout];
    

    
    UILabel *horzTitleLabel = [UILabel new];
    horzTitleLabel.text = @"水平布局(从左到右)";
    horzTitleLabel.myCenterXOffset = 0;  //视图的水平中心点和布局视图的水平中心点保持一致。
    [horzTitleLabel sizeToFit];          //sizeToFit函数的意思是让视图的尺寸刚好包裹其内容。
    [rootLayout addSubview:horzTitleLabel];
    
    /*
     horzLayout是垂直布局下的水平布局子视图，因此位置部分的y轴部分会根据添加的先后顺序确定；x轴部分则如果没有设置则默认是和父视图左对齐；宽度则因为水平线性布局在建立时默认wrapContentWidth=YES,也就是说宽度由里面的子视图决定的，所以宽度也就是确定的；高度则由weight设置为1确定的，表示其高度将占用整个垂直线性布局父视图的剩余高度，具体weight属性的意义参考类库中的属性介绍。
     */
    MyLinearLayout *horzLayout = [self createHorzSubviewLayout];
    horzLayout.weight = 1.0;     //高度占用父视图的剩余高度
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

/**
 * 创建一个垂直的线性子布局。
 */
-(MyLinearLayout*)createVertSubviewLayout
{
    //创建垂直布局视图。
    MyLinearLayout *vertLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    vertLayout.backgroundColor = [UIColor lightGrayColor];

    /*
      对于垂直线性布局里面的子视图来说:
       1.如果不设置任何边距则每个子视图的左边都跟父视图左对齐，而上下则依次按加入的顺序排列。
       2.myLeftMargin, myRightMargin的意义是子视图距离父视图的左右边距。
       3.myTopMargin, myBottomMargin的意义是子视图和兄弟视图之间的上下间距。
       4.如果同时设置了myLeftMargin,myRightMargin则除了能确定左右边距，还能确定子视图的宽度。
       5.如果同时设置了myTopMargin,myBottomMargin则只能确定和其他兄弟视图之间的上下间距，但不能确定子视图的高度。
       6.myCenterXOffset表示子视图的水平中心点在父视图的水平中心点上的偏移。
       7.myCenterYOffset的设置没有意义。
     */
    
    UILabel *v1 = [UILabel new];
    v1.text = @"左边边距";
    v1.textAlignment = NSTextAlignmentCenter;
    v1.adjustsFontSizeToFitWidth = YES;
    v1.backgroundColor = [UIColor redColor];
    v1.myTopMargin = 10;  //上边边距10
    v1.myLeftMargin = 10; //左边边距10
    v1.myWidth = 200;
    v1.myHeight = 25;     //设置布局尺寸
    [vertLayout addSubview:v1];

    
    UILabel *v2 = [UILabel new];
    v2.text = @"水平居中";
    v2.textAlignment = NSTextAlignmentCenter;
    v2.adjustsFontSizeToFitWidth = YES;
    v2.backgroundColor = [UIColor greenColor];
    v2.myTopMargin = 10;
    v2.myCenterXOffset = 0;            //水平居中,如果不等于0则会产生居中偏移
    v2.mySize = CGSizeMake(200, 25);   //效果和上面意义一致！
    [vertLayout addSubview:v2];

    
    UILabel *v3 = [UILabel new];
    v3.text = @"右边边距";
    v3.textAlignment = NSTextAlignmentCenter;
    v3.adjustsFontSizeToFitWidth = YES;
    v3.backgroundColor = [UIColor blueColor];
    v3.myTopMargin = 10;
    v3.myRightMargin = 10; //右边边距10
    v3.frame = CGRectMake(0, 0, 200, 25);  //设置视图的尺寸，详见下面的注释。
    [vertLayout addSubview:v3];

    /*
      对于布局里面的子视图来说我们仍然可以使用frame方法来进行布局，但是frame中的origin部分的设置将不起作用，size部分仍然会起作用。
     
     通过frame设置子视图尺寸和通过myWidth, myHeight,mySize来设置子视图布局尺寸的异同如下：
     1.二者都可以用来设置子视图的尺寸。
     2.通过frame设置视图的尺寸会立即生效，而通过后者设置尺寸时则只有在完成布局后才生效。
     3.如果同时设置了frame和myWidth, myHeight,mySize时，最终起作用的是后者。
     4.不管通过何种方式设置尺寸，在布局完成时都可以通过frame属性读取到最终布局的位置和尺寸。
     */
    
    
    UILabel *v4 = [UILabel new];
    v4.text = @"左右边距";
    v4.textAlignment = NSTextAlignmentCenter;
    v4.adjustsFontSizeToFitWidth = YES;
    v4.backgroundColor = [UIColor orangeColor];
    v4.myTopMargin = 10;
    v4.myBottomMargin = 10;
    v4.myLeftMargin = 10;
    v4.myRightMargin = 10; //上面两行代码将左右边距设置为10。对于垂直线性布局来说如果子视图同时设置了左右边距则宽度会自动算出，因此不需要设置myWidth的值了。
    v4.myHeight = 25;
    [vertLayout addSubview:v4];

    
    return vertLayout;
    
}

/**
 * 创建一个水平的线性子布局。
 */
-(MyLinearLayout*)createHorzSubviewLayout
{
    //创建水平布局视图。
    MyLinearLayout *horzLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    horzLayout.backgroundColor = [UIColor darkGrayColor];

    /*
     对于水平线性布局里面的子视图来说:
     1.如果不设置任何边距则每个子视图的上边都跟父视图上对齐，而左右则依次按加入的顺序排列。
     2.myTopMargin, myBottomMargin的意义是子视图距离父视图的上下边距。
     3.myLeftMargin, myRightMargin的意义是子视图和兄弟视图之间的左右间距。
     4.如果同时设置了myTopMargin,myBottomMargin则除了能确定上下边距，还能确定子视图的高度。
     5.如果同时设置了myLeftMargin,myRightMargin则只能确定和其他兄弟视图之间的左右间距，但不能确定子视图的宽度。
     6.myCenterYOffset表示子视图的垂直中心点在父视图的垂直中心点上的偏移。
     7.myCenterXOffset的设置没有意义。
     */

    
    UILabel *v1 = [UILabel new];
    v1.text = @"上边边距";
    v1.textAlignment = NSTextAlignmentCenter;
    v1.adjustsFontSizeToFitWidth = YES;
    v1.backgroundColor = [UIColor redColor];
    v1.myLeftMargin = 10;
    v1.myTopMargin = 10; //上边边距10
    v1.myWidth = 60;
    v1.myHeight = 60;
    [horzLayout addSubview:v1];

    
    
    UILabel *v2 = [UILabel new];
    v2.text = @"垂直居中";
    v2.textAlignment = NSTextAlignmentCenter;
    v2.adjustsFontSizeToFitWidth = YES;
    v2.backgroundColor = [UIColor greenColor];
    v2.myLeftMargin = 10;
    v2.myCenterYOffset = 0; //垂直居中，如果不等于0则会产生居中偏移
    v2.mySize = CGSizeMake(60, 60);
    [horzLayout addSubview:v2];

    
    UILabel *v3 = [UILabel new];
    v3.text = @"下边边距";
    v3.textAlignment = NSTextAlignmentCenter;
    v3.adjustsFontSizeToFitWidth = YES;
    v3.backgroundColor = [UIColor blueColor];
    v3.myLeftMargin = 10;
    v3.myBottomMargin = 10; //下边边距10
    v3.myRightMargin = 5;
    v3.frame = CGRectMake(0, 0, 60, 60);
    [horzLayout addSubview:v3];

    
    UILabel *v4 = [UILabel new];
    v4.text = @"上下边距";
    v4.textAlignment = NSTextAlignmentCenter;
    v4.adjustsFontSizeToFitWidth = YES;
    v4.backgroundColor = [UIColor orangeColor];
    v4.myLeftMargin = 10;
    v4.myRightMargin = 10;
    v4.myTopMargin = 10;
    v4.myBottomMargin = 10; //上面两行代码将上下边距设置为10,对于水平线性布局来说如果子视图同时设置了上下边距则高度会自动算出,因此不需要设置myHeight的值了。
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

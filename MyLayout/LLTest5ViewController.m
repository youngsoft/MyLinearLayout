//
//  Test5ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest5ViewController.h"
#import "MyLayout.h"

@interface LLTest5ViewController ()

@end

@implementation LLTest5ViewController


-(void)loadView
{
    /*
       这个例子主要用来介绍布局视图里面子视图的相对尺寸和相对间距的概念。对于线性布局来说子视图的相对尺寸我们需要用weight这个扩展属性来设置，而相对尺寸则通过将布局位置对象的值设置为大于0小于1的小数来确定。
     所谓子视图的相对值表示的是值不是一个明确的绝对值，而是一个比例或者比重值，最终的结果则会根据布局视图的剩余尺寸计算出来。布局视图的剩余尺寸是指将布局视图的尺寸扣除掉那些有绝对尺寸或者有绝对间距的子视图的尺寸和间距后剩余下来的空间。所有子视图的相对值的比重就是在布局视图的剩余尺寸下的比重。
     
        对于垂直线性布局来说当某个子视图的weight值大于0时则表示其高度是相对尺寸，而对于水平线性布局来说当某个子视图的weight值大于0时则表示其宽度是相对尺寸。
        对于线性布局和框架布局来说当某个子视图的myXXXMargin的值大于0且小于1时表示使用的相对的间距，否则使用的将是绝对的间距。
     
        下面的例子说明了相对尺寸和相对间距的概念：
          假如某个垂直线性布局的高度是200，其中里面有A,B,C,D四个子视图。其中：
           A的myTopMargin = 10,  myHeight=20,   myBottomMargin = 0.1
           B的myTopMargin = 0.2, myHeight = 30, myBottomMargin = 0
           C的myTopMargin = 5,   weight = 0.3,  myBottomMargin = 10
           D的myTopMargin = 0.3, weight = 0.2,  myBottomMargin = 0.4
         
      上面例子中：
      绝对部分的高度总和=A.myTopMargin + A.myHeight + B.myHeight + B.myBottomMargin + C.myTopMargin + C.myBottomMargin = 75
      相对部分的比重和为 = A.myBottomMargin + B.myTopMargin + C.weight + D.myTopMargin + D.weight + D.myBottomMargin = 1.5
      布局视图的剩余空间 = 总高度 - 绝对高度 = 200 - 75 = 125
      因此最终的上图中的各相对比重的转化为绝对值后的结果如下：
        A.myBottomMargin = 125 * 0.1/1.5 ≈ 8 
        B.myTopMargin = 125 * 0.2/1.5  ≈ 17
        C.myHeight  125 * 0.3/1.5 ≈  25
        D.myTopMargin  125 *0.3/1.5 ≈ 25
        D.myHeight  125 *0.2/1.5 ≈ 17
        D.myBottomMargin  ≈ 33
     
     
     如果布局视图里面的子视图使用了相对尺寸和相对间距我们必须要满足如下的条件：
     
     1.垂直线性布局里面如果有子视图设置了weight或者指定了垂直相对间距，则wrapContentHeight设置将失效；水平线性布局里面如果有子视图设置为weight或者指定了水平相对间距，则wrapContentWidth设置将失效。
     2.如果布局视图里面的子视图使用了相对间距和相对尺寸则必须要明确指定布局视图的宽度或者高度，否则相对设置可能会失效。
     
     */
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor grayColor];
    rootLayout.wrapContentWidth = NO;
    rootLayout.wrapContentHeight = NO;
    self.view = rootLayout;

    
    UILabel *v1 = [UILabel new];
    v1.text = @"宽度和父视图相等 高度为父视图剩余空间的20%";
    v1.adjustsFontSizeToFitWidth = YES;
    v1.textAlignment = NSTextAlignmentCenter;
    v1.backgroundColor = [UIColor redColor];
    v1.myTopMargin = 10;
    v1.myLeftMargin = v1.myRightMargin = 0; //宽度和父视图相等,等价于v1.widthDime.equalTo(rootLayout.widthDime);
    v1.weight = 0.2;     //高度的比重是剩余空间的20%
    [rootLayout addSubview:v1];
    
    
    UILabel *v2 = [UILabel new];
    v2.text = @"宽度是父视图的80% 高度为父视图剩余空间的30%";
    v2.adjustsFontSizeToFitWidth = YES;
    v2.textAlignment = NSTextAlignmentCenter;
    v2.backgroundColor = [UIColor greenColor];
    v2.myTopMargin = 10;
    v2.widthDime.equalTo(rootLayout.widthDime).multiply(0.8);  //子视图的宽度是父视图宽度的0.8
    v2.myCenterXOffset = 0;
    v2.weight = 0.3;    //高度的比重是剩余空间的30%
    [rootLayout addSubview:v2];
    
    
    UILabel *v3 = [UILabel new];
    v3.text = @"宽度是父视图的宽度-20 高度为父视图剩余空间的50%";
    v3.adjustsFontSizeToFitWidth = YES;
    v3.textAlignment = NSTextAlignmentCenter;
    v3.backgroundColor = [UIColor blueColor];
    v3.myTopMargin = 10;
    v3.widthDime.equalTo(rootLayout.widthDime).add(-20);  //父视图的宽度-20 或者v3.myLeftMargin = 20; v3.myRightMargin = 0;
    v3.myRightMargin = 0;
    v3.weight = 0.5;  //高度的比重是剩余空间的50%
    [rootLayout addSubview:v3];
    
    
    UILabel *v4 = [UILabel new];
    v4.text = @"宽度固定是200 高度固定是50";
    v4.textAlignment = NSTextAlignmentCenter;
    v4.adjustsFontSizeToFitWidth = YES;
    v4.backgroundColor = [UIColor yellowColor];
    v4.myTopMargin = 10;
    v4.myWidth = 200;
    v4.myHeight = 50;
    [rootLayout addSubview:v4];
    
    
    UILabel *v5 = [UILabel new];
    v5.text = @"左边20%，右边30%，宽度50%，高度是剩余的10%，顶部间距是剩余的5%，底部间距是剩余的10%";
    v5.numberOfLines = 0;
    v5.textAlignment = NSTextAlignmentCenter;
    v5.adjustsFontSizeToFitWidth = YES;
    v5.backgroundColor = [UIColor cyanColor];
    //下面设置的值都是0和1之间的值。表示都是相对。
    v5.myLeftMargin = 0.2;   //左边的边距是父视图的20%
    v5.myRightMargin = 0.3;  //左右的边距是父视图的30%， 这样也就是说视图的宽度是父视图的50%
    v5.weight = 0.1;
    v5.myTopMargin = 0.05;
    v5.myBottomMargin = 0.1;
    [rootLayout addSubview:v5];

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

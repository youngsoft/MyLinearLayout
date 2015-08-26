//
//  Test18ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test18ViewController.h"
#import "MyLayout.h"

@interface Test18ViewController ()

@end

@implementation Test18ViewController

-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    
    
    /*
     有的时候我们希望让一个布局视图放入到非布局视图中去，但又希望布局视图的宽高和非布局父视图宽高一致。
     这时候我们可以设置height,width来指定自身的高宽，我们也可以通过leftMargin = 0,rightMargin = 0来让其跟父视图保持一样的宽度，但如果是这样的话还需要设置wrapContentWidth = NO. 设置高度同理。
     */
    MyTableLayout *tbll = [MyTableLayout new];
    tbll.orientation = LVORIENTATION_HORZ;
    tbll.wrapContentWidth = NO;  //对于线性布局来说必须要设置为NO才能宽度和非布局的父视图一样宽
    tbll.wrapContentHeight = YES; //这里设定高度由子视图决定。
    tbll.leftMargin = tbll.rightMargin = 0;  //宽度和非布局父视图一样宽
    [scrollView addSubview:tbll];
    
    
    //需要注意的是因为这里的表格设置为水平表格，所以下面所的行高，其实是行宽，而列宽，其实是列高
    
    
    //第一行固定高度固定宽度
    [tbll addRow:30 colWidth:30];
    [tbll viewAtRowIndex:0].backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    UIView *colView = [UIView new];
    colView.leftMargin = 5; //可以使用leftMargin,topMargin,rightMargin,bottomMargin来调整间隔
    colView.topMargin = 5;
    colView.bottomMargin = 5;
    colView.rightMargin = 5;
    
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:0];
    
    colView = [UIView new];
    colView.topMargin = 20;
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:0];
    
    colView = [UIView new];
    colView.backgroundColor = [UIColor blueColor];
    [tbll addCol:colView atRow:0];
    
    //第二行固定高度，均分宽度
    [tbll addRow:40 colWidth:0];
    [tbll viewAtRowIndex:1].backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    
    
    colView = [UIView new];
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:1];
    
    colView = [UIView new];
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:1];
    
    colView = [UIView new];
    colView.backgroundColor = [UIColor blueColor];
    [tbll addCol:colView atRow:1];
    
    colView = [UIView new];
    colView.backgroundColor = [UIColor yellowColor];
    [tbll addCol:colView atRow:1];
    
    //第三行固定高度，子视图自己决定宽度。
    [tbll addRow:30 colWidth:-1];
    [tbll viewAtRowIndex:2].backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    colView = [UIView new];
    colView.height = 100;
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:2];
    
    colView = [UIView new];
    colView.height = 200;
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:2];
    
    colView = [UIView new];
    colView.height = 1000;
    colView.backgroundColor = [UIColor blueColor];
    [tbll addCol:colView atRow:2];
    
    //第四行固定高度，子视图自己决定宽度。
    [tbll addRow:30 colWidth:-2];
    [tbll viewAtRowIndex:3].backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    colView = [UIView new];
    colView.height = 80;
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:3];
    
    colView = [UIView new];
    colView.height = 200;
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:3];
    
    //第五行高度均分.这里设置为0表示剩余高度再均分。宽度均分,
    [tbll addRow:0 colWidth:0];
    MyLinearLayout *row4 = [tbll viewAtRowIndex:4];
    //可以设置行的属性.比如padding, 线条颜色，
    row4.padding = UIEdgeInsetsMake(3, 3, 3, 3);
    row4.leftBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor blackColor]];
    row4.leftBorderLine.thick = 2;
    row4.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    colView = [UIView new];
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:4];
    
    colView = [UIView new];
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:4];
    
    //第六行高度由子视图决定，均分宽度
    [tbll addRow:-1 colWidth:0];
    [tbll viewAtRowIndex:5].backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    
    colView = [UIView new];
    colView.width = 80;
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:5];
    
    colView = [UIView new];
    colView.width = 120;
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:5];
    
    colView = [UIView new];
    colView.width = 70;
    colView.backgroundColor = [UIColor blueColor];
    [tbll addCol:colView atRow:5];
    
    
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"表格布局-水平表格(瀑布流)";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

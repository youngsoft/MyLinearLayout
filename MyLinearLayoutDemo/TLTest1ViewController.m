//
//  Test17ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "TLTest1ViewController.h"
#import "MyLayout.h"

@interface TLTest1ViewController ()

@end

@implementation TLTest1ViewController


-(void)loadView
{
    [super loadView];
    
    /*
     有的时候我们希望让一个布局视图放入到非布局视图中去，但又希望布局视图的宽高和非布局父视图宽高一致。
     这时候我们可以设置height,width来指定自身的高宽，我们也可以通过leftMargin = 0,rightMargin = 0来让其跟父视图保持一样的宽度，但如果是这样的话还需要设置wrapContentWidth = NO. 设置高度同理。
     */
    MyTableLayout *tbll = [MyTableLayout tableLayoutWithOrientation:LVORIENTATION_VERT];
    tbll.leftMargin = tbll.rightMargin = 0;  //宽度和非布局父视图一样宽
    tbll.topMargin = tbll.bottomMargin = 0;  //高度和非布局父视图一样高
    [self.view addSubview:tbll];

    
    //第一行固定高度固定宽度
    [tbll addRow:30 colWidth:70];
    [tbll viewAtRowIndex:0].backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    UILabel *colView = [UILabel new];
    colView.text = @"Cell00";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.leftMargin = 10; //可以使用leftMargin,topMargin,rightMargin,bottomMargin来调整间隔
    colView.topMargin = 5;
    colView.bottomMargin = 5;
    colView.rightMargin = 40;
    
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:0];
    
    colView = [UILabel new];
    colView.text = @"Cell01";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    colView.leftMargin = 20;
    [tbll addCol:colView atRow:0];
    
    colView = [UILabel new];
    colView.text = @"Cell02";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor blueColor];
    [tbll addCol:colView atRow:0];
    
    //第二行固定高度，均分宽度
    [tbll addRow:40 colWidth:MTLCOLWIDTH_AVERAGE];
    [tbll viewAtRowIndex:1].backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];

    
    colView = [UILabel new];
    colView.text = @"Cell10";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:1];
    
    colView = [UILabel new];
    colView.text = @"Cell11";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:1];
    
    
    colView = [UILabel new];
    colView.text = @"Cell12";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor blueColor];
    [tbll addCol:colView atRow:1];
    
    colView = [UILabel new];
    colView.text = @"Cell13";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor yellowColor];
    [tbll addCol:colView atRow:1];
    
    //第三行固定高度，子视图自己决定宽度。
    [tbll addRow:30 colWidth:MTLCOLWIDTH_WRAPCONTENT];
    [tbll viewAtRowIndex:2].backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    colView = [UILabel new];
    colView.text = @"Cell20";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    colView.width = 100;
    [tbll addCol:colView atRow:2];

    colView = [UILabel new];
    colView.text = @"Cell21";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    colView.width = 200;
    [tbll addCol:colView atRow:2];
    
    //第四行固定高度，子视图自己决定宽度。
    [tbll addRow:30 colWidth:MTLCOLWIDTH_MATCHPARENT];
    [tbll viewAtRowIndex:3].backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    colView = [UILabel new];
    colView.text = @"Cell30";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    colView.width = 80;
    [tbll addCol:colView atRow:3];
    
    colView = [UILabel new];
    colView.text = @"Cell31";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    colView.width = 200;
    [tbll addCol:colView atRow:3];
    
    //第五行高度均分.这里设置为0表示剩余高度再均分。宽度均分,
    [tbll addRow:MTLROWHEIGHT_AVERAGE colWidth:MTLCOLWIDTH_AVERAGE];
    MyLinearLayout *row4 = [tbll viewAtRowIndex:4];
    //可以设置行的属性.比如padding, 线条颜色，
    row4.padding = UIEdgeInsetsMake(3, 3, 3, 3);
    row4.topBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor blackColor]];
    row4.topBorderLine.thick = 2;
    row4.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];

    colView = [UILabel new];
    colView.text = @"Cell40";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:4];
    
    colView = [UILabel new];
    colView.text = @"Cell41";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:4];
    
    //第六行高度由子视图决定，均分宽度
    [tbll addRow:MTLROWHEIGHT_WRAPCONTENT colWidth:MTLCOLWIDTH_AVERAGE];
    [tbll viewAtRowIndex:5].backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    
    colView = [UILabel new];
    colView.text = @"Cell50";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    colView.height = 80;
    [tbll addCol:colView atRow:5];
    
    colView = [UILabel new];
    colView.text = @"Cell51";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    colView.height = 120;
    [tbll addCol:colView atRow:5];
    
    colView = [UILabel new];
    colView.text = @"Cell52";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor blueColor];
    colView.height = 70;
    [tbll addCol:colView atRow:5];





    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"表格布局-垂直表格";
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

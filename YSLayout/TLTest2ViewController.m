//
//  Test18ViewController.m
//  YSLayout
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "TLTest2ViewController.h"
#import "YSLayout.h"

@interface TLTest2ViewController ()

@end

@implementation TLTest2ViewController

-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    
    
    /*
     有的时候我们希望让一个布局视图放入到非布局视图中去，但又希望布局视图的宽高和非布局父视图宽高一致。
     这时候我们可以设置ysHeight,ysWidth来指定自身的高宽，我们也可以通过ysLeftMargin = 0,ysRightMargin = 0来让其跟父视图保持一样的宽度，但如果是这样的话还需要设置wrapContentWidth = NO. 设置高度同理。
     */
    YSTableLayout *tbll = [YSTableLayout tableLayoutWithOrientation:YSLayoutViewOrientation_Horz];
    tbll.wrapContentHeight = YES; //这里设定高度由子视图决定。
    tbll.wrapContentWidth = NO;
    tbll.ysWidth = 500;
    [scrollView addSubview:tbll];
    
    
    //需要注意的是因为这里的表格设置为水平表格，所以下面所的行高，其实是行宽，而列宽，其实是列高
    
    
    //第一行固定高度固定宽度
    [tbll addRow:60 colWidth:30];
    [tbll viewAtRowIndex:0].backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    UILabel *colView = [UILabel new];
    colView.text = @"Cell00";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    colView.ysLeftMargin = 5; //可以使用ysLeftMargin,ysTopMargin,ysRightMargin,ysBottomMargin来调整间隔
    colView.ysTopMargin = 5;
    colView.ysBottomMargin = 5;
    colView.ysRightMargin = 5;
    [tbll addCol:colView atRow:0];
    
    colView = [UILabel new];
    colView.text = @"Cell10";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    colView.ysTopMargin = 20;
    [tbll addCol:colView atRow:0];
    
    colView = [UILabel new];
    colView.text = @"Cell20";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor blueColor];
    [tbll addCol:colView atRow:0];
    
    //第二行固定高度，均分宽度
    [tbll addRow:70 colWidth:MTLCOLWIDTH_AVERAGE];
    [tbll viewAtRowIndex:1].backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    
    
    colView = [UILabel new];
    colView.text = @"Cell01";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:1];
    
    colView = [UILabel new];
    colView.text = @"Cell11";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:1];
    
    colView = [UILabel new];
    colView.text = @"Cell21";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor blueColor];
    [tbll addCol:colView atRow:1];
    
    colView = [UILabel new];
    colView.text = @"Cell31";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor yellowColor];
    [tbll addCol:colView atRow:1];
    
    //第三行固定高度，子视图自己决定宽度。
    [tbll addRow:60 colWidth:MTLCOLWIDTH_WRAPCONTENT];
    [tbll viewAtRowIndex:2].backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    colView = [UILabel new];
    colView.text = @"Cell02";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    colView.ysHeight = 100;
    [tbll addCol:colView atRow:2];
    
    colView = [UILabel new];
    colView.text = @"Cell12";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    colView.ysHeight = 200;
    [tbll addCol:colView atRow:2];
    
    colView = [UILabel new];
    colView.text = @"Cell22";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor blueColor];
    colView.ysHeight = 1000;
    [tbll addCol:colView atRow:2];
    
    //第四行固定高度，子视图自己决定宽度。
    [tbll addRow:60 colWidth:MTLCOLWIDTH_MATCHPARENT];
    [tbll viewAtRowIndex:3].backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    colView = [UILabel new];
    colView.text = @"Cell03";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    colView.ysHeight = 80;
    [tbll addCol:colView atRow:3];
    
    colView = [UILabel new];
    colView.text = @"Cell13";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    colView.ysHeight = 200;
    [tbll addCol:colView atRow:3];
    
    //第五行高度均分.这里设置为0表示剩余高度再均分。宽度均分,
    [tbll addRow:MTLROWHEIGHT_AVERAGE colWidth:MTLCOLWIDTH_AVERAGE];
    YSLinearLayout *row4 = [tbll viewAtRowIndex:4];
    //可以设置行的属性.比如ysPadding, 线条颜色，
    row4.ysPadding = UIEdgeInsetsMake(3, 3, 3, 3);
    row4.leftBorderLine = [[YSBorderLineDraw alloc] initWithColor:[UIColor blackColor]];
    row4.leftBorderLine.thick = 2;
    row4.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    colView = [UILabel new];
    colView.text = @"Cell04";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    [tbll addCol:colView atRow:4];
    
    colView = [UILabel new];
    colView.text = @"Cell14";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    [tbll addCol:colView atRow:4];
    
    //第六行高度由子视图决定，均分宽度
    [tbll addRow:MTLROWHEIGHT_WRAPCONTENT colWidth:MTLCOLWIDTH_AVERAGE];
    [tbll viewAtRowIndex:5].backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    
    colView = [UILabel new];
    colView.text = @"Cell05";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor redColor];
    colView.ysWidth = 80;
    [tbll addCol:colView atRow:5];
    
    colView = [UILabel new];
    colView.text = @"Cell15";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor greenColor];
    colView.ysWidth = 120;
    [tbll addCol:colView atRow:5];
    
    colView = [UILabel new];
    colView.text = @"Cell25";
    colView.textAlignment = NSTextAlignmentCenter;
    colView.backgroundColor = [UIColor blueColor];
    colView.ysWidth = 70;
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

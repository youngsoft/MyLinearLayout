//
//  TLTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/18.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "TLTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface TLTest1ViewController ()

@end

@implementation TLTest1ViewController

-(UILabel*)createLabel:(NSString*)title backgroundColor:(UIColor*)color
{
    UILabel *v = [UILabel new];
    v.text = title;
    v.font = [CFTool font:14];
    v.textAlignment = NSTextAlignmentCenter;
    v.backgroundColor = color;

    return v;
}

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    [super loadView];
 
    
    /*
     有的时候我们希望让一个布局视图放入到非布局父视图中去，但又希望布局视图的宽高和非布局父视图宽高一致。
     这时候我们可以设置myHeight,myWidth来指定自身的高宽，我们也可以通过myMargin = 0来让其跟父视图保持一样的宽度。
     */
    MyTableLayout *tableLayout = [MyTableLayout tableLayoutWithOrientation:MyOrientation_Vert];
    tableLayout.backgroundColor = [CFTool color:0];
    tableLayout.subviewHSpace = 2;  //表格的列间距
    tableLayout.subviewVSpace = 2;  //表格的行间距
    tableLayout.myMargin = 0;   //和父视图保持一致的尺寸，因为这里和父视图四周的边距都是0
    [self.view addSubview:tableLayout];

    
    //第一行固定高度固定宽度
    [tableLayout addRow:30 colSize:70];
    
    UILabel *colView = [self createLabel:@"Cell00" backgroundColor:[CFTool color:1]];
    colView.myLeading = 10; //可以使用myLeft,myTop,myRight,myBottom,myLeading,myTrailing来调整间隔
    colView.myTop = 5;
    colView.myBottom = 5;
    colView.myTrailing = 40;
    [tableLayout addCol:colView atRow:0];
    
    colView = [self createLabel:@"Cell01" backgroundColor:[CFTool color:2]];
    colView.myLeading = 20;
    [tableLayout addCol:colView atRow:0];
    
    colView = [self createLabel:@"Cell02" backgroundColor:[CFTool color:3]];
    [tableLayout addCol:colView atRow:0];
    
    
    //第二行固定高度，均分宽度
    [tableLayout addRow:40 colSize:MTLSIZE_AVERAGE];

    colView = [self createLabel:@"Cell10" backgroundColor:[CFTool color:1]];
    [tableLayout addCol:colView atRow:1];
    
    colView = [self createLabel:@"Cell11" backgroundColor:[CFTool color:2]];
    [tableLayout addCol:colView atRow:1];
    
    colView = [self createLabel:@"Cell12" backgroundColor:[CFTool color:3]];
    [tableLayout addCol:colView atRow:1];
    
    colView = [self createLabel:@"Cell13" backgroundColor:[CFTool color:4]];
    [tableLayout addCol:colView atRow:1];
    
    
    //第三行固定高度，子视图自己决定宽度。
    [tableLayout addRow:30 colSize:MTLSIZE_WRAPCONTENT];
    colView = [self createLabel:@"Cell20" backgroundColor:[CFTool color:1]];
    colView.myWidth = 100;
    [tableLayout addCol:colView atRow:2];

    colView = [self createLabel:@"Cell21" backgroundColor:[CFTool color:2]];
    colView.myWidth = 200;
    [tableLayout addCol:colView atRow:2];
    
    //第四行固定高度，子视图自己决定宽度。
    [tableLayout addRow:30 colSize:MTLSIZE_MATCHPARENT];
    colView = [self createLabel:@"Cell30" backgroundColor:[CFTool color:1]];
    colView.myWidth = 80;
    [tableLayout addCol:colView atRow:3];
    
    colView = [self createLabel:@"Cell31" backgroundColor:[CFTool color:2]];
    colView.myWidth = 200;
    [tableLayout addCol:colView atRow:3];
    
    
    //第五行高度均分.这里设置为0表示剩余高度再均分。宽度均分,
    [tableLayout addRow:MTLSIZE_AVERAGE colSize:MTLSIZE_AVERAGE];
    MyLinearLayout *row4 = [tableLayout viewAtRowIndex:4];
    //可以设置行的属性.比如padding, 线条颜色，
    row4.padding = UIEdgeInsetsMake(3, 3, 3, 3);
    row4.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor blackColor]];
    row4.topBorderline.thick = 2;

    colView = [self createLabel:@"Cell40" backgroundColor:[CFTool color:1]];
    [tableLayout addCol:colView atRow:4];
    
    colView = [self createLabel:@"Cell41" backgroundColor:[CFTool color:2]];
    [tableLayout addCol:colView atRow:4];
    
    
    //第六行高度由子视图决定，均分宽度
    [tableLayout addRow:MTLSIZE_WRAPCONTENT colSize:MTLSIZE_AVERAGE];
    
    colView = [self createLabel:@"Cell50" backgroundColor:[CFTool color:1]];
    colView.myHeight = 80;
    [tableLayout addCol:colView atRow:5];
    
    colView = [self createLabel:@"Cell51" backgroundColor:[CFTool color:2]];
    colView.myHeight = 120;
    [tableLayout addCol:colView atRow:5];
    
    colView = [self createLabel:@"Cell52" backgroundColor:[CFTool color:3]];
    colView.myHeight = 70;
    [tableLayout addCol:colView atRow:5];





    
    
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

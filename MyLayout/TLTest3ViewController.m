//
//  TLT3ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/18.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "TLTest3ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface TLTest3ViewController ()

@property(nonatomic, strong) MyTableLayout *tableLayout;

@end

@implementation TLTest3ViewController


-(void)loadView
{
    /*
      这个例子是将表格布局和智能边界线的应用结合，实现一个表格界面。
     
     */
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.view.bounds, 10, 10)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    //建立一个垂直表格
    self.tableLayout = [MyTableLayout tableLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    self.tableLayout.myLeftMargin = self.tableLayout.myRightMargin = 0;  //宽度和非布局父视图一样宽
    [scrollView addSubview:self.tableLayout];
    
    
    //建立一个表格外边界的边界线。颜色为黑色，粗细为3.
    MyBorderLineDraw *outerBorderLine = [[MyBorderLineDraw alloc] initWithColor:[CFTool color:4]];
    outerBorderLine.thick = 3;
    self.tableLayout.boundBorderLine = outerBorderLine;
    
    //建立智能边界线。所谓智能边界线就是布局里面的如果有子布局视图，则子布局视图会根据自身的布局位置智能的设置边界线。
    //智能边界线只支持表格布局、线性布局、流式布局、浮动布局。
    //如果要想完美使用智能分界线，则请将cellview建立为一个布局视图，比如本例子中的createCellLayout。
    MyBorderLineDraw *innerBorderLine = [[MyBorderLineDraw alloc] initWithColor:[CFTool color:5]];
    self.tableLayout.IntelligentBorderLine = innerBorderLine;


    //添加第一行。行高为50，每列宽由自己确定。
   MyLinearLayout *firstRow = [self.tableLayout addRow:50 colSize:MTLSIZE_MATCHPARENT];
   firstRow.notUseIntelligentBorderLine = YES;  //因为智能边界线会影响到里面的所有子布局，包括每行，但是这里我们希望这行不受智能边界线的影响而想自己定义边界线，则将这个属性设置为YES。
   firstRow.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[CFTool color:7]]; //我们自定义第一行的底部边界线为蓝色边界线。
    
    NSArray *firstRowTitles = @[@"Name",@"Mon.",@"Tues.",@"Wed.", @"Thur.",@"Fri.",@"Sat.",@"Sun."];
    [firstRowTitles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * stop) {
        
        UIView *cellView = [self createCellLayout:obj];  //这里为什么要用布局视图作为单元格视图，是因为智能边界线只会影响到布局子视图，非布局子视图是没有智能边界线的。
        if (idx == 0)
            cellView.myWidth = 80;
        else
            cellView.weight = 1; //我们这里定义第一列的宽度为80，而其他的列宽平均分配。
        
        [self.tableLayout addSubview:cellView];  //表格布局重写了addSubview，表示总是添加到最后一行上。
    }];
    
    
    NSArray *names = @[@"欧阳大哥",@"周杰",@"{丸の子}",@"小鱼",@"Sarisha゛"];
    NSArray *values = @[@"", @"10",@"20"];
    
    //建立10行的数据。
    for (int i = 0; i < 10; i++)
    {
        [self.tableLayout addRow:40 colSize:MTLSIZE_MATCHPARENT]; //添加新的一行。
        
        for (int j = 0; j < firstRowTitles.count; j++)
        {
            UIView *cellView = nil;
            if (j == 0)
            {
                cellView = [self createCellLayout:names[arc4random_uniform((uint32_t)names.count)]];
                cellView.myWidth = 80;
            }
            else
            {
                cellView = [self createCellLayout:values[arc4random_uniform((uint32_t)values.count)]];
                cellView.weight = 1;
            }
            
            [self.tableLayout addSubview:cellView];
        }
    }
    
    //最后一行：
     MyLinearLayout *lastRow = [self.tableLayout addRow:60 colSize:MTLSIZE_MATCHPARENT];
    lastRow.notUseIntelligentBorderLine = YES;
    lastRow.topBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]];
    
    UIView *cellLayout = [self createCellLayout:@"Total:"];
    cellLayout.weight = 1;  //占用剩余宽度
    [self.tableLayout addSubview:cellLayout];
    
    cellLayout = [self createCellLayout:@"$1234.11"];
    cellLayout.myWidth = 100;  //固定宽度。
    [self.tableLayout addSubview:cellLayout];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Space" style:UIBarButtonItemStylePlain target:self action:@selector(handleSpace:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

-(MyFrameLayout*)createCellLayout:(NSString*)value
{
    MyFrameLayout *cellLayout = [MyFrameLayout new];
    [cellLayout setTarget:self action:@selector(handleCellTap:)];
    cellLayout.highlightedBackgroundColor = [CFTool color:8];
    
    UILabel *label = [UILabel new];
    label.text = value;
    label.font = [CFTool font:15];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.marginGravity = MyMarginGravity_Fill;
    [cellLayout addSubview:label];
    
    return cellLayout;
}


#pragma mark -- Handle Method

-(void)handleCellTap:(MyBaseLayout*)sender
{
    NSString *message = [NSString stringWithFormat:@"您单击了:%@", ((UILabel*)sender.subviews.firstObject).text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)handleSpace:(id)sender
{
    if (self.tableLayout.rowSpacing == 0)
        self.tableLayout.rowSpacing = 5;
    else if (self.tableLayout.colSpacing == 0)
        self.tableLayout.colSpacing = 5;
    else
        self.tableLayout.rowSpacing = self.tableLayout.colSpacing = 0;
    
    [self.tableLayout layoutAnimationWithDuration:0.3];
    
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

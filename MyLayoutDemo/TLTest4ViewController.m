//
//  TLTest4ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/18.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "TLTest4ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface TLTest4ViewController ()

@end

@implementation TLTest4ViewController

-(void)loadView
{
    /*
      这个例子是将表格布局和智能边界线以及对齐和动态高度的综合应用结合，实现一个表格界面。
     
     */
    
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.view = scrollView;
    
    if (@available(iOS 11.0, *)) {
    } else {
        // Fallback on earlier versions
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
   
    
    MyTableLayout *tableLayout = [MyTableLayout tableLayoutWithOrientation:MyOrientation_Vert];
    tableLayout.leadingPos.equalTo(@(MyLayoutPos.safeAreaMargin)).offset(10);
    tableLayout.trailingPos.equalTo(@(MyLayoutPos.safeAreaMargin)).offset(10);
    tableLayout.topPos.equalTo(@(MyLayoutPos.safeAreaMargin)).offset(10);
    tableLayout.boundBorderline = [[MyBorderline alloc] initWithColor:[UIColor blackColor] thick:3];
    tableLayout.intelligentBorderline = [[MyBorderline alloc] initWithColor:[UIColor lightGrayColor]];
    [self.view addSubview:tableLayout];
    
    NSArray *titles = @[@"身高(Height)(cm)", @"体重(Weight)(kg)", @"胸围(Bust)(cm)",@"腰围(Waist)(cm)",@"臀围(Hip)(cm)",@"鞋码(Shoes Size)(欧码)"];
    NSArray *values = @[@"177",@"54",@"88",@"88",@"88",@"43"];
    
 
    //第一行
    MyLinearLayout *row1 = [tableLayout addRow:MyLayoutSize.wrap colCount:titles.count];
    row1.gravity = MyGravity_Vert_Top;
    row1.backgroundColor = [CFTool color:8];
    for (NSString *title in titles)
    {
        [tableLayout addSubview:[self itemFrom:title alignment:NSTextAlignmentCenter isFitWidth:NO]];
    }
    
    //第二行
    MyLinearLayout *row2 = [tableLayout addRow:MyLayoutSize.wrap colCount:titles.count];
    row2.gravity = MyGravity_Vert_Center;
    for (NSString *title in titles)
    {
        [tableLayout addSubview:[self itemFrom:title alignment:NSTextAlignmentCenter  isFitWidth:NO]];
    }
    
    //第三行
    MyLinearLayout *row3 = [tableLayout addRow:MyLayoutSize.wrap colCount:titles.count];
    row3.gravity = MyGravity_Vert_Bottom;
    for (NSString *title in titles)
    {
        [tableLayout addSubview:[self itemFrom:title alignment:NSTextAlignmentCenter  isFitWidth:NO]];
    }
    
    //第四行
    /*MyLinearLayout *row4 =*/ [tableLayout addRow:50 colCount:titles.count];
    for (NSString *title in titles)
    {
        [tableLayout addSubview:[self itemFrom:title alignment:NSTextAlignmentCenter  isFitWidth:YES]];
    }
    
    
    //第五行
    /*MyLinearLayout *row5 =*/ [tableLayout addRow:MyLayoutSize.wrap colCount:values.count];
    for (NSString *value in values)
    {
        [tableLayout addSubview:[self itemFrom:value alignment:NSTextAlignmentLeft  isFitWidth:NO]];
    }
    
    //第六行
    /*MyLinearLayout *row6 =*/ [tableLayout addRow:MyLayoutSize.wrap colCount:values.count];
    for (NSString *value in values)
    {
        [tableLayout addSubview:[self itemFrom:value alignment:NSTextAlignmentCenter  isFitWidth:NO]];
    }
    
    //第7行
    /*MyLinearLayout *row7 =*/ [tableLayout addRow:MyLayoutSize.wrap colCount:values.count];
    for (NSString *value in values)
    {
        [tableLayout addSubview:[self itemFrom:value alignment:NSTextAlignmentRight  isFitWidth:NO]];
    }
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

-(MyBaseLayout*)itemFrom:(NSString*)itemString alignment:(NSTextAlignment)alignment isFitWidth:(BOOL)isFitWidth
{
    MyFrameLayout *itemLayout = [MyFrameLayout new];
    itemLayout.topPadding = itemLayout.bottomPadding = 10;
    itemLayout.leftPadding = itemLayout.rightPadding = 5;
    UILabel *label = [UILabel new];
    label.text = itemString;
    label.textAlignment = alignment;
    label.textColor = [CFTool color:4];
    [itemLayout addSubview:label];
    
    if (isFitWidth)
    {
        itemLayout.gravity = MyGravity_Fill;
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 0;
    }
    else
    {
        itemLayout.gravity = MyGravity_Horz_Fill;
        itemLayout.myHeight = MyLayoutSize.wrap;
        label.myHeight = MyLayoutSize.wrap;
    }
    
    
    return itemLayout;
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

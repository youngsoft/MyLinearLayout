//
//  Test10ViewController.m
//  MyLayout
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "LLTest7ViewController.h"
#import "MyLayout.h"

@interface LLTest7ViewController ()

@property(nonatomic, strong) MyLinearLayout *testLayout;

@end

@implementation LLTest7ViewController

-(UIButton*)createButton:(NSString*)title tag:(NSInteger)tag
{
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [button sizeToFit];
    
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1;
    
    return button;
}


-(void)loadView
{
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.wrapContentHeight = NO;
    rootLayout.wrapContentWidth = NO;
    rootLayout.gravity = MyMarginGravity_Horz_Fill;
    rootLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.view = rootLayout;
    
    
    MyLinearLayout *action1Layout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    action1Layout.wrapContentHeight = YES;
    [rootLayout addSubview:action1Layout];
    
    
    [action1Layout addSubview:[self createButton:@"均分视图1" tag:100]];
    [action1Layout addSubview:[self createButton:@"均分视图2" tag:200]];
    [action1Layout addSubview:[self createButton:@"均分视图3" tag:300]];
    [action1Layout averageSubviews:NO withMargin:5];

    MyLinearLayout *action2Layout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    action2Layout.wrapContentHeight = YES;
    action2Layout.myTopMargin = 5;
    [rootLayout addSubview:action2Layout];
    
    
    [action2Layout addSubview:[self createButton:@"均分视图4" tag:400]];
    [action2Layout addSubview:[self createButton:@"均分边距1" tag:500]];
    [action2Layout addSubview:[self createButton:@"均分边距2" tag:600]];
    [action2Layout averageSubviews:NO withMargin:5];
   
   
   
    //你也可以用流式布局来实现上面的操作按钮的排列更简单。
  /*  MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    actionLayout.averageArrange = YES;
    actionLayout.wrapContentHeight = YES;
    actionLayout.subviewVertMargin = 5;
    actionLayout.subviewHorzMargin = 5;
    [rootLayout addSubview:actionLayout];

    [actionLayout addSubview:[self createButton:@"均分视图1" tag:100]];
    [actionLayout addSubview:[self createButton:@"均分视图2" tag:200]];
    [actionLayout addSubview:[self createButton:@"均分视图3" tag:300]];
    [actionLayout addSubview:[self createButton:@"均分视图4" tag:400]];
    [actionLayout addSubview:[self createButton:@"均分边距1" tag:500]];
    [actionLayout addSubview:[self createButton:@"均分边距2" tag:600]];
    */
    
    self.testLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    self.testLayout.gravity = MyMarginGravity_Horz_Fill;  //所有子视图水平宽度充满布局，这样就不需要分别设置每个子视图的宽度了。
    self.testLayout.backgroundColor = [UIColor grayColor];
    self.testLayout.wrapContentHeight = NO;
    self.testLayout.weight = 1.0;
    self.testLayout.leftPadding = 10;
    self.testLayout.rightPadding = 10;
    self.testLayout.myTopMargin = 5;
    [rootLayout addSubview:self.testLayout];
    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    v1.myHeight = 100;
    
    
    [self.testLayout addSubview:v1];
   
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor greenColor];
    v2.myHeight = 50;
   
    [self.testLayout addSubview:v2];

    
    
    UIView *v3 = [UIView new];
    v3.backgroundColor = [UIColor blueColor];
    v3.myHeight = 70;
    [self.testLayout addSubview:v3];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"线性布局-均分视图和间距";
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleAction:(UIButton*)sender
{
    //恢复原来的设置。
   NSArray *arr = self.testLayout.subviews;
    
    UIView *v1 = arr[0];
    UIView *v2 = arr[1];
    UIView *v3 = arr[2];
    
    [v1 resetMyLayoutSetting];
    [v2 resetMyLayoutSetting];
    [v3 resetMyLayoutSetting];
    
    v1.myHeight = 100;
    v2.myHeight = 50;
    v3.myHeight = 70;
    
    
    
    switch (sender.tag) {
        case 100:
            [self.testLayout averageSubviews:NO];
            break;
        case 200:
            [self.testLayout averageSubviews:YES];
            break;
        case 300:
            [self.testLayout averageSubviews:NO withMargin:40];
            break;
        case 400:
            [self.testLayout averageSubviews:YES withMargin:40];
            break;
        case 500:
            [self.testLayout averageMargin:NO];
            break;
        case 600:
            [self.testLayout averageMargin:YES];
            break;
        default:
            break;
    }
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

//
//  Test8ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//


#import "Test8ViewController.h"
#import "MyLayout.h"

@interface Test8ViewController ()

@end

@implementation Test8ViewController

-(void)loadView
{
    [super loadView];
    
    //布局视图中不需要指定宽度，而是由最大子视图决定宽度
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(100, 100, 0,0)];
    ll.orientation = LVORIENTATION_VERT;
    ll.wrapContentWidth = YES;  //这句话表示宽度的尺寸由最大的子视图的宽度决定。
    ll.backgroundColor = [UIColor grayColor];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)]; //这个子视图最宽 10+90+20 父视图的宽度为110
    v1.backgroundColor = [UIColor redColor];
    v1.leftMargin = 10;
    v1.rightMargin = 20;
    v1.topMargin = 4;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    v2.backgroundColor = [UIColor greenColor];
    v2.topMargin = 6;
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    v3.backgroundColor = [UIColor blueColor];
    v3.topMargin = 3;
    v3.bottomMargin = 4;
    [ll addSubview:v3];
    
    [self.view addSubview:ll];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"布局视图尺寸由子视图决定";
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

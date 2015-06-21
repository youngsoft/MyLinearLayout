//
//  Test6ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "Test6ViewController.h"
#import "MyLinearLayout.h"
#import "MyFrameLayout.h"

@interface Test6ViewController ()

@end

@implementation Test6ViewController


-(UIView*)createView
{
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 100,200)];
    ll.orientation = LVORIENTATION_VERT;
    ll.backgroundColor = [UIColor grayColor];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    v1.backgroundColor = [UIColor redColor];
    v1.topMargin = 4;
    v1.matchParentWidth = 1.0;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
    v2.backgroundColor = [UIColor greenColor];
    v2.topMargin = 6;
    v2.matchParentWidth = 0.8;
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    v3.backgroundColor = [UIColor blueColor];
    v3.topMargin = 3;
    v3.matchParentWidth = -20;
    [ll addSubview:v3];
    
    UIView *v4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    v4.backgroundColor = [UIColor yellowColor];
    v4.topMargin = 3;
    v4.bottomMargin = 4;
    v4.matchParentWidth = 1;
    v4.leftMargin = 10;
    v4.rightMargin = 30;
    [ll addSubview:v4];
    
    
    
    return ll;
    
}


-(void)loadView
{
    
    self.view = [MyFrameLayout new];
    
    MyLinearLayout *test1ll = [MyLinearLayout new];
    test1ll.orientation = LVORIENTATION_HORZ; //水平布局
    test1ll.marginGravity = MGRAVITY_CENTER;  //本视图在父视图中居中
    test1ll.gravity = MGRAVITY_HORZ_CENTER;   //本视图里面的所有子视图整体水平居中停靠
    test1ll.wrapContent = YES;  //本视图的高度由子视图中最高的决定。
    [self.view addSubview:test1ll];
    
    [test1ll addSubview:[self createView]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"子视图的尺寸由父视图决定";
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

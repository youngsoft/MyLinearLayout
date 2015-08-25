//
//  Test3ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test3ViewController.h"
#import "MyLayout.h"

@interface Test3ViewController ()

@end

@implementation Test3ViewController


-(UIView*)createView:(MarignGravity)gravity padding:(UIEdgeInsets)padding
{
    //我们可以设置widthDime也可以设置
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 100,200)];
    ll.orientation = LVORIENTATION_VERT;
    ll.leftMargin = 10;
    ll.gravity = gravity;
    ll.padding = padding;
    ll.backgroundColor = [UIColor grayColor];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    v1.backgroundColor = [UIColor redColor];
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
    
    return ll;
    
}



-(void)loadView
{
    
    MyLinearLayout *test1ll = [MyLinearLayout new];
    test1ll.orientation = LVORIENTATION_HORZ; //水平布局
    test1ll.gravity = MGRAVITY_CENTER;   //本视图里面的所有子视图整体水平居中停靠
    self.view = test1ll;
    
    [test1ll addSubview:[self createView:MGRAVITY_HORZ_LEFT padding:UIEdgeInsetsMake(5, 5, 5, 5)]];
    [test1ll addSubview:[self createView:MGRAVITY_HORZ_CENTER padding:UIEdgeInsetsMake(5, 5, 5, 5)]];
    [test1ll addSubview:[self createView:MGRAVITY_HORZ_RIGHT padding:UIEdgeInsetsMake(5, 5, 5, 5)]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"布局内视图的停靠1";
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

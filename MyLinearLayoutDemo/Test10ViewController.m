//
//  Test10ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test10ViewController.h"
#import "MyLayout.h"

@interface Test10ViewController ()

@end

@implementation Test10ViewController


-(void)loadView
{
    
    MyLinearLayout *ll = [MyLinearLayout new];
    ll.backgroundColor = [UIColor grayColor];
    ll.wrapContentHeight  = NO;
    ll.leftPadding = 10;
    ll.rightPadding = 10;
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    v1.backgroundColor = [UIColor redColor];
    v1.leftMargin = v1.rightMargin = 0;
    
    
    [ll addSubview:v1];
   
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    v2.backgroundColor = [UIColor greenColor];
    v2.leftMargin = v2.rightMargin = 0;
   
    [ll addSubview:v2];

    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 70)];
    v3.backgroundColor = [UIColor blueColor];
    v3.leftMargin = v3.rightMargin = 0;
    [ll addSubview:v3];

   
    //每个视图的高度保持原始值，剩余的部分平分间距
   // [ll averageMargin:NO];
    //会把视图和间距都平分，即使设置了高度也无效。
    [ll averageSubviews:YES];
    
    self.view = ll;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"均分视图和间距";
   
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

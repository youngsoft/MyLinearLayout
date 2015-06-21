//
//  Test10ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "Test10ViewController.h"
#import "MyFrameLayout.h"
#import "MyLinearLayout.h"

@interface Test10ViewController ()

@end

@implementation Test10ViewController


-(void)loadView
{
    
    
    MyLinearLayout *ll = [MyLinearLayout new];
    ll.backgroundColor = [UIColor grayColor];
    ll.autoAdjustSize  = NO;
    ll.gravity = MGRAVITY_HORZ_CENTER;
    ll.leftPadding = 10;
    ll.rightPadding = 10;
    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    v1.matchParentWidth = 1;
    v1.topMargin = 1.0/7;
    v1.weight = 1.0/7;
    
    [ll addSubview:v1];
   
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor greenColor];
    v2.matchParentWidth = 1;
    v2.topMargin =1.0/7;
    v2.weight = 1.0/7;
    [ll addSubview:v2];

    
    
    UIView *v3 = [UIView new];
    v3.backgroundColor = [UIColor blueColor];
    v3.matchParentWidth = 1;
    v3.topMargin =1.0/7;
    v3.bottomMargin =1.0/7;
    v3.weight = 1.0/7;
    [ll addSubview:v3];

   //或者你可以调用这个函数不需要设置各比例值。 [ll averageSubviews:YES];
    
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

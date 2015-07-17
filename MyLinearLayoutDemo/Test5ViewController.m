//
//  Test5ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "Test5ViewController.h"
#import "MyFrameLayout.h"
#import "MyLinearLayout.h"

@interface Test5ViewController ()

@end

@implementation Test5ViewController

-(void)loadView
{
    MyLinearLayout *ll = [MyLinearLayout new];
    ll.orientation = LVORIENTATION_VERT;
    ll.gravity = MGRAVITY_VERT_CENTER;
    ll.backgroundColor = [UIColor grayColor];
    self.view = ll;
    
    //不再需要指定y的偏移值了。
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v1.backgroundColor = [UIColor redColor];

    v1.topPos.equalTo(@10);
    v1.leftPos.equalTo(@10); //左边偏移10
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    v2.backgroundColor = [UIColor greenColor];
    v2.topPos.equalTo(@10);
    v2.centerXPos.equalTo(ll.centerXPos);  //水平居中
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v3.backgroundColor = [UIColor blueColor];
    v3.topPos.equalTo(@10);
    v3.rightPos.equalTo(@10); //右对齐偏移10
    [ll addSubview:v3];
    
    UIView *v4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    v4.backgroundColor = [UIColor yellowColor];
    v4.topPos.equalTo(@10);
    v4.bottomPos.equalTo(@10);
    //同时设置左边和右边形成填充效果和v4.widthDime.equalTo(ll.widthDime)的效果一致
    v4.leftPos.equalTo(@0).offset(5);
    v4.rightPos.equalTo(@0).offset(5);
    [ll addSubview:v4];
    
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"布局内视图停靠3";
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

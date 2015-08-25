//
//  Test5ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test5ViewController.h"
#import "MyLayout.h"

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

    v1.topMargin = 10;
    v1.leftMargin = 10;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    v2.backgroundColor = [UIColor greenColor];
    v2.topMargin = 10;
    v2.centerXOffset = 0;  //这里是居中
    
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    v3.backgroundColor = [UIColor blueColor];
    v3.topMargin = 10;
    v3.rightMargin = 10;
    [ll addSubview:v3];
    
    UIView *v4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    v4.backgroundColor = [UIColor yellowColor];
    v4.topMargin = 10;
    v4.bottomMargin = 10;
    v4.leftMargin = 5;
    v4.rightMargin = 5;
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

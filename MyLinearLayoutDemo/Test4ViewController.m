//
//  Test4ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test4ViewController.h"
#import "MyLayout.h"

@interface Test4ViewController ()

@end

@implementation Test4ViewController


-(UIView*)createView:(MarignGravity)gravity
{
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 100,200)];
    ll.leftMargin = 10;
    ll.orientation = LVORIENTATION_VERT;
    ll.gravity = gravity;
    ll.backgroundColor = [UIColor grayColor];
    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    v1.topMargin = 4;
    v1.leftMargin = v1.rightMargin = 0;
    v1.height = 40;
    [ll addSubview:v1];
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor greenColor];
    v2.topMargin = 6;
    v2.width = 40;
    v2.height = 60;
    [ll addSubview:v2];
    
    
    UIView *v3 = [UIView new];
    v3.backgroundColor = [UIColor blueColor];
    
    v3.topMargin = 3;
    v3.bottomMargin = 4;
    v3.width = 75;
    v3.height = 30;
    
    [ll addSubview:v3];
    
    return ll;
    
    
}

-(void)loadView
{
    
    MyLinearLayout *test1ll = [MyLinearLayout new];
    test1ll.orientation = LVORIENTATION_HORZ; //水平布局
    test1ll.gravity = MGRAVITY_CENTER;   //本视图里面的所有子视图整体水平居中停靠
    self.view = test1ll;
    
    
    [test1ll addSubview:[self createView:MGRAVITY_VERT_TOP]];
    [test1ll addSubview:[self createView:MGRAVITY_VERT_CENTER]];
    [test1ll addSubview:[self createView:MGRAVITY_VERT_BOTTOM]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"布局内视图停靠2";
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

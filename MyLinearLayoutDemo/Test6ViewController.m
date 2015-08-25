//
//  Test6ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test6ViewController.h"
#import "MyLayout.h"

@interface Test6ViewController ()

@end

@implementation Test6ViewController


-(void)loadView
{
        
    MyLinearLayout *ll = [MyLinearLayout new];
    ll.orientation = LVORIENTATION_VERT;
    ll.gravity = MGRAVITY_VERT_CENTER;
    ll.backgroundColor = [UIColor grayColor];
    self.view = ll;
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    v1.backgroundColor = [UIColor redColor];
    v1.topMargin = 10;
    v1.leftMargin = v1.rightMargin = 0;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    v2.backgroundColor = [UIColor greenColor];
    v2.topMargin = 10;
    v2.widthDime.equalTo(ll.widthDime).multiply(0.8);  //父视图的宽度的0.8
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    v3.backgroundColor = [UIColor blueColor];
    v3.topMargin = 10;
    v3.widthDime.equalTo(ll.widthDime).add(-20);  //父视图的宽度-20
    [ll addSubview:v3];
    
    UIView *v4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    v4.backgroundColor = [UIColor yellowColor];
    v4.topMargin = 10;
    v4.bottomMargin = 10;
    v4.leftMargin = 10;
    v4.rightMargin = 10;
    [ll addSubview:v4];
    

    
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

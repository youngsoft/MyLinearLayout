//
//  Test7ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "Test7ViewController.h"
#import "MyFrameLayout.h"
#import "MyLinearLayout.h"

@interface Test7ViewController ()

@end

@implementation Test7ViewController

-(void)loadView
{
    MyLinearLayout *ll = [MyLinearLayout new];
    //保证容器和视图控制的视图的大小进行伸缩调整。
    ll.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ll.orientation = LVORIENTATION_VERT;
    ll.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    ll.backgroundColor = [UIColor grayColor];
    
    MyLinearLayout *topll = MyLinearLayout.new;
    topll.orientation = LVORIENTATION_HORZ;
    topll.weight = 0.5;
    topll.matchParentWidth = 1;
    
    UIView *topLeft = UIView.new;
    topLeft.backgroundColor = [UIColor redColor];
    topLeft.weight = 0.5;
    topLeft.matchParentHeight = 1.0;
    [topll addSubview:topLeft];
    
    UIView *topRight = UIView.new;
    topRight.backgroundColor = [UIColor greenColor];
    topRight.weight = 0.5;
    topRight.matchParentHeight = 1.0;
    topRight.leftMargin = 20;
    [topll addSubview:topRight];
    
    [ll addSubview:topll];
    
    
    UIView *bottom = UIView.new;
    bottom.backgroundColor = [UIColor blueColor];
    bottom.weight = 0.5;
    bottom.matchParentWidth = 1.0;
    bottom.topMargin = 20;
    [ll addSubview:bottom];
    
    
    self.view = ll;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相对视图尺寸";
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

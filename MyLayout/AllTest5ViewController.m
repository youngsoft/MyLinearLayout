//
//  AllTest5ViewController.m
//  MyLayout
//
//  Created by fzy on 16/1/24.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "AllTest5ViewController.h"
#import "MyLayout.h"

@interface AllTest5ViewController ()

@end

@implementation AllTest5ViewController

-(void)loadView
{
    //默认设置为垂直布局
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.wrapContentHeight = NO;
    rootLayout.gravity = MyMarginGravity_Horz_Fill;
    rootLayout.subviewMargin = 10;
    self.view = rootLayout;

    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    v1.weight = 1;
    [rootLayout addSubview:v1];
    
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor greenColor];
    v2.weight = 1;
    [rootLayout addSubview:v2];

    
    UIView *v3 = [UIView new];
    v3.backgroundColor = [UIColor blueColor];
    v3.weight = 1;
    [rootLayout addSubview:v3];
    
    
    //其他任何横屏都不参与布局
    [v3 mySizeClass:MySizeClass_wAny | MySizeClass_hCompact].hidden = YES;
    //只有iphone6Plus的横屏才参与布局
    [v3 mySizeClass:MySizeClass_wRegular | MySizeClass_hCompact].hidden = NO;
    [v3 mySizeClass:MySizeClass_wRegular | MySizeClass_hCompact].weight = 1;
    
    //针对iPhone设备的所有横屏的高度都是Compact的，而宽度则是任意，因此下面的设置横屏情况下布局变为水平布局。
    MyLayoutSizeClass *lsc = [rootLayout mySizeClass:MySizeClass_wAny | MySizeClass_hCompact];
    lsc.orientation = MyLayoutViewOrientation_Horz;
    lsc.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    lsc.wrapContentWidth = NO;
    lsc.gravity = MyMarginGravity_Vert_Fill;
    lsc.subviewMargin = 10;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SizeClass 测试1";
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

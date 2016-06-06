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

    
    UILabel *v1 = [UILabel new];
    v1.backgroundColor = [UIColor redColor];
    v1.numberOfLines = 0;
    v1.text = @"本例子里面设置了在iPhone设备上竖屏时红绿蓝三个子视图垂直排列，而横屏时则水平排列。同时非6plus设备在横屏时蓝色子视图不显示，而在6plus设备上蓝色子视图才显示,您可以用不同的模拟器来测试各种设备的横竖屏场景";
    v1.weight = 1;
    [rootLayout addSubview:v1];
    
    
    UILabel *v2 = [UILabel new];
    v2.backgroundColor = [UIColor greenColor];
    v2.weight = 1;
    [rootLayout addSubview:v2];

    
    UILabel *v3 = [UILabel new];
    v3.backgroundColor = [UIColor blueColor];
    v3.weight = 1;
    [rootLayout addSubview:v3];
    
    
    //v3视图在其他任何iPhone设备横屏都不参与布局
    [v3 fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact].hidden = YES;
    //只有iphone6Plus的横屏才参与布局
    [v3 fetchLayoutSizeClass:MySizeClass_wRegular | MySizeClass_hCompact copyFrom:MySizeClass_wAny | MySizeClass_hAny].hidden = NO;
    
    //针对iPhone设备的所有横屏的高度都是Compact的，而宽度则是任意，因此下面的设置横屏情况下布局变为水平布局。
    //虽然fetchLayoutSizeClass方法真实返回的是MyLayoutSize或者其派生类，但是仍然可以用视图以及布局来设置其中的属性
    //但是调用lsc.backgroundColor = xx 则会崩溃，因为fetchLayoutSizeClass返回的并不是真的视图对象。
    MyLinearLayout *lsc = [rootLayout fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    lsc.orientation = MyLayoutViewOrientation_Horz;
    lsc.wrapContentWidth = NO;
    lsc.gravity = MyMarginGravity_Vert_Fill;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

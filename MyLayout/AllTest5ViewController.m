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
    //[super loadView];
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.wrapContentHeight = NO;
    rootLayout.gravity = MyMarginGravity_Horz_Fill;
    rootLayout.subviewMargin = 10;
    
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
    
    self.view = rootLayout;
    
    MyLayoutSizeClass *lsc = [rootLayout mySizeClass:MySizeClass_wRegular | MySizeClass_hCompact];
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

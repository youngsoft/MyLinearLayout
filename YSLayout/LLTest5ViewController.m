//
//  Test5ViewController.m
//  YSLayout
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "LLTest5ViewController.h"
#import "YSLayout.h"

@interface LLTest5ViewController ()

@end

@implementation LLTest5ViewController


-(void)loadView
{
    YSLinearLayout *rootLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor grayColor];
    
    rootLayout.wrapContentWidth = NO;
    rootLayout.wrapContentHeight = NO;
    self.view = rootLayout;

    
    UILabel *v1 = [UILabel new];
    v1.text = @"宽度和父视图相等 高度为父视图剩余空间的20%";
    v1.adjustsFontSizeToFitWidth = YES;
    v1.textAlignment = NSTextAlignmentCenter;
    v1.backgroundColor = [UIColor redColor];
    
    v1.ysTopMargin = 10;
    v1.ysLeftMargin = v1.ysRightMargin = 0; //或者v1.widthDime.equalTo(rootLayout.widthDime);
    v1.weight = 0.2;
    [rootLayout addSubview:v1];
    
    
    UILabel *v2 = [UILabel new];
    v2.text = @"宽度是父视图的80% 高度为父视图剩余空间的30%";
    v2.adjustsFontSizeToFitWidth = YES;
    v2.textAlignment = NSTextAlignmentCenter;
    v2.backgroundColor = [UIColor greenColor];
    
    v2.ysTopMargin = 10;
    v2.widthDime.equalTo(rootLayout.widthDime).multiply(0.8);  //父视图的宽度的0.8
    v2.ysCenterXOffset = 0;
    v2.weight = 0.3;
    [rootLayout addSubview:v2];
    
    
    UILabel *v3 = [UILabel new];
    v3.text = @"宽度是父视图的宽度-20 高度为父视图剩余空间的50%";
    v3.adjustsFontSizeToFitWidth = YES;
    v3.textAlignment = NSTextAlignmentCenter;
    v3.backgroundColor = [UIColor blueColor];
    
    v3.ysTopMargin = 10;
    v3.widthDime.equalTo(rootLayout.widthDime).add(-20);  //父视图的宽度-20 或者v3.ysLeftMargin = 20; v3.ysRightMargin = 0;
    v3.ysRightMargin = 0;
    v3.weight = 0.5;
    [rootLayout addSubview:v3];
    
    
    UILabel *v4 = [UILabel new];
    v4.text = @"宽度固定是200 高度固定是50";
    v4.textAlignment = NSTextAlignmentCenter;
    v4.adjustsFontSizeToFitWidth = YES;
    v4.backgroundColor = [UIColor yellowColor];
    
    v4.ysTopMargin = 10;
    v4.ysWidth = 200;
    v4.ysHeight = 50;
    [rootLayout addSubview:v4];
    
    
    UILabel *v5 = [UILabel new];
    v5.text = @"左边20%，右边30%，宽度50%，高度是剩余的10%，顶部间距是剩余的5%，底部间距是剩余的10%";
    v5.numberOfLines = 0;
    v5.textAlignment = NSTextAlignmentCenter;
    v5.adjustsFontSizeToFitWidth = YES;
    v5.backgroundColor = [UIColor cyanColor];
    
    //下面设置的值都是0和1之间的值。表示都是相对。
    v5.ysLeftMargin = 0.2;
    v5.ysRightMargin = 0.3;
    v5.weight = 0.1;
    v5.ysTopMargin = 0.05;
    v5.ysBottomMargin = 0.1;
    [rootLayout addSubview:v5];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"线性布局-子视图尺寸由布局决定";
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

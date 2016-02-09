//
//  AllTest6ViewController.m
//  MyLayout
//
//  Created by apple on 16/2/5.
//  Copyright (c) 2016年 YoungSoft. All rights reserved.
//

#import "AllTest6ViewController.h"
#import "MyLayout.h"

@interface AllTest6ViewController ()

@end

@implementation AllTest6ViewController


-(void)loadView
{
    //竖屏顶部是菜单布局
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.gravity = MyMarginGravity_Horz_Fill;
    self.view = rootLayout;
    
    MyFlowLayout *menuLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    menuLayout.averageArrange = YES;
    menuLayout.wrapContentHeight = YES;
    menuLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    menuLayout.subviewMargin = 10;
    [rootLayout addSubview:menuLayout];
    
    UILabel *menu1Label = [UILabel new];
    menu1Label.text = @"菜单1";
    menu1Label.textAlignment = NSTextAlignmentCenter;
    menu1Label.backgroundColor = [UIColor redColor];
    menu1Label.heightDime.equalTo(menu1Label.widthDime);
    menu1Label.widthDime.equalTo(menu1Label.heightDime);
    [menuLayout addSubview:menu1Label];
    
    UILabel *menu2Label = [UILabel new];
    menu2Label.text = @"菜单2";
    menu2Label.textAlignment = NSTextAlignmentCenter;
    menu2Label.backgroundColor = [UIColor greenColor];
    menu2Label.heightDime.equalTo(menu2Label.widthDime);
    menu2Label.widthDime.equalTo(menu2Label.heightDime);
    [menuLayout addSubview:menu2Label];
    
    UILabel *menu3Label = [UILabel new];
    menu3Label.text = @"菜单3";
    menu3Label.textAlignment = NSTextAlignmentCenter;
    menu3Label.backgroundColor = [UIColor blueColor];
    menu3Label.heightDime.equalTo(menu3Label.widthDime);
    menu3Label.widthDime.equalTo(menu3Label.heightDime);
    [menuLayout addSubview:menu3Label];
    
    MyRelativeLayout *contentLayout = [MyRelativeLayout new];
    contentLayout.weight = 1;
    contentLayout.backgroundColor = [UIColor grayColor];
    contentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [rootLayout addSubview:contentLayout];
    
    
    UILabel *func1Label = [UILabel new];
    func1Label.text = @"内容1";
    func1Label.textAlignment = NSTextAlignmentCenter;
    func1Label.backgroundColor = [UIColor orangeColor];
    func1Label.heightDime.equalTo(contentLayout.heightDime).multiply(0.5).add(-5);
    [contentLayout addSubview:func1Label];
    
    UILabel *func2Label = [UILabel new];
    func2Label.text = @"内容2";
    func2Label.textAlignment = NSTextAlignmentCenter;
    func2Label.backgroundColor = [UIColor cyanColor];
    func2Label.heightDime.equalTo(contentLayout.heightDime).multiply(0.5).add(-5);
    [contentLayout addSubview:func2Label];
    
    func1Label.widthDime.equalTo(@[func2Label.widthDime]);
    func2Label.leftPos.equalTo(func1Label.rightPos);
    
    UILabel *func3Label = [UILabel new];
    func3Label.text = @"内容3:请分别尝试iPhone设备的横竖屏以及iPad设备的横竖屏";
    func3Label.numberOfLines = 0;
    func3Label.textAlignment = NSTextAlignmentCenter;
    func3Label.backgroundColor = [UIColor brownColor];
    func3Label.heightDime.equalTo(contentLayout.heightDime).multiply(0.5).add(-5);
    func3Label.widthDime.equalTo(contentLayout.widthDime);
    func3Label.topPos.equalTo(func1Label.bottomPos).offset(10);
    [contentLayout addSubview:func3Label];
    
    
    //下面定义横屏时的界面布局。
    MyLinearLayout *rootLayoutSC = [rootLayout fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact];
    rootLayoutSC.orientation = MyLayoutViewOrientation_Horz;
    rootLayoutSC.gravity = MyMarginGravity_Vert_Fill;
    
    
    MyFlowLayout *menuLayoutSC = [menuLayout fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact copyFrom:MySizeClass_hAny | MySizeClass_wAny];
    menuLayoutSC.orientation = MyLayoutViewOrientation_Horz;
    menuLayoutSC.wrapContentWidth = YES;
    
    
    UILabel *func1LabelSC = [func1Label fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact];
    UILabel *func2LabelSC = [func2Label fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact];
    UILabel *func3LabelSC = [func3Label fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact];

    func1LabelSC.widthDime.equalTo(@[func2LabelSC.widthDime, func3LabelSC.widthDime]);
    func2LabelSC.leftPos.equalTo(func1LabelSC.rightPos);
    func3LabelSC.leftPos.equalTo(func2LabelSC.rightPos);
    func1LabelSC.heightDime.equalTo(contentLayout.heightDime);
    func2LabelSC.heightDime.equalTo(contentLayout.heightDime);
    func3LabelSC.heightDime.equalTo(contentLayout.heightDime);
    
    //下面是定义在iPad上时的界面布局，iPad的布局只是菜单的高度有最大的限制。
    UILabel *menu1LabelSC = [menu1Label fetchLayoutSizeClass:MySizeClass_wRegular | MySizeClass_hRegular copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    menu1LabelSC.heightDime.max(200);
    UILabel *menu2LabelSC = [menu2Label fetchLayoutSizeClass:MySizeClass_wRegular | MySizeClass_hRegular copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    menu2LabelSC.heightDime.max(200);
    UILabel *menu3LabelSC = [menu3Label fetchLayoutSizeClass:MySizeClass_wRegular | MySizeClass_hRegular copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    menu3LabelSC.heightDime.max(200);

    

    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SizeClass--Demo2";

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

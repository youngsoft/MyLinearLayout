//
//  AllTest6ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/5.
//  Copyright (c) 2016年 YoungSoft. All rights reserved.
//

#import "AllTest6ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface AllTest6ViewController ()

@end

@implementation AllTest6ViewController


-(void)loadView
{
    /*
       这个DEMO 主要介绍了MyLayout对SizeClass的支持能力。下面的代码分别针对iPhone设备的横竖屏以及iPad设备的横竖屏分别做了适配处理。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.wrapContentHeight = NO;
    rootLayout.gravity = MyGravity_Horz_Fill;
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    //创建顶部的菜单布局部分。
    MyFlowLayout *menuLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    menuLayout.gravity = MyGravity_Fill; //填充所有尺寸。
    menuLayout.wrapContentHeight = YES;
    menuLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    menuLayout.subviewSpace = 10;
    [rootLayout addSubview:menuLayout];
    
    UILabel *menu1Label = [UILabel new];
    menu1Label.text = NSLocalizedString(@"Menu1", @"");
    menu1Label.textAlignment = NSTextAlignmentCenter;
    menu1Label.backgroundColor = [CFTool color:5];
    menu1Label.font = [CFTool font:16];
    menu1Label.heightSize.equalTo(menu1Label.widthSize);
    menu1Label.widthSize.equalTo(menu1Label.heightSize);
    [menuLayout addSubview:menu1Label];
    
    UILabel *menu2Label = [UILabel new];
    menu2Label.text = NSLocalizedString(@"Menu2", @"");
    menu2Label.textAlignment = NSTextAlignmentCenter;
    menu2Label.backgroundColor = [CFTool color:6];
    menu2Label.font = [CFTool font:16];
    menu2Label.heightSize.equalTo(menu2Label.widthSize);
    menu2Label.widthSize.equalTo(menu2Label.heightSize);
    [menuLayout addSubview:menu2Label];
    
    UILabel *menu3Label = [UILabel new];
    menu3Label.text = NSLocalizedString(@"Menu3", @"");
    menu3Label.textAlignment = NSTextAlignmentCenter;
    menu3Label.backgroundColor = [CFTool color:7];
    menu3Label.font = [CFTool font:16];
    menu3Label.heightSize.equalTo(menu3Label.widthSize);
    menu3Label.widthSize.equalTo(menu3Label.heightSize);
    [menuLayout addSubview:menu3Label];
    
    MyRelativeLayout *contentLayout = [MyRelativeLayout new];
    contentLayout.weight = 1;
    contentLayout.backgroundColor = [CFTool color:0];
    contentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [rootLayout addSubview:contentLayout];
    
    
    UILabel *func1Label = [UILabel new];
    func1Label.text = NSLocalizedString(@"Content1", @"");
    func1Label.textAlignment = NSTextAlignmentCenter;
    func1Label.backgroundColor = [CFTool color:5];
    func1Label.font = [CFTool font:16];
    func1Label.heightSize.equalTo(contentLayout.heightSize).multiply(0.5).add(-5);
    [contentLayout addSubview:func1Label];
    
    UILabel *func2Label = [UILabel new];
    func2Label.text = NSLocalizedString(@"Content2", @"");
    func2Label.textAlignment = NSTextAlignmentCenter;
    func2Label.backgroundColor = [CFTool color:6];
    func2Label.font = [CFTool font:16];
    func2Label.heightSize.equalTo(contentLayout.heightSize).multiply(0.5).add(-5);
    [contentLayout addSubview:func2Label];
    
    func1Label.widthSize.equalTo(@[func2Label.widthSize]);
    func2Label.leadingPos.equalTo(func1Label.trailingPos);
    
    UILabel *func3Label = [UILabel new];
    func3Label.text = NSLocalizedString(@"Content3:please run in different iPhone&iPad device and change different screen orientation", @"");
    func3Label.numberOfLines = 0;
    func3Label.textAlignment = NSTextAlignmentCenter;
    func3Label.backgroundColor = [CFTool color:7];
    func3Label.font = [CFTool font:16];
    func3Label.heightSize.equalTo(contentLayout.heightSize).multiply(0.5).add(-5);
    func3Label.widthSize.equalTo(contentLayout.widthSize);
    func3Label.topPos.equalTo(func1Label.bottomPos).offset(10);
    [contentLayout addSubview:func3Label];
    
    
    //下面定义iPhone设备横屏时的界面布局。
    MyLinearLayout *rootLayoutSC = [rootLayout fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact];
    rootLayoutSC.orientation = MyOrientation_Horz;
    rootLayoutSC.gravity = MyGravity_Vert_Fill;
    
    
    MyFlowLayout *menuLayoutSC = [menuLayout fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact copyFrom:MySizeClass_hAny | MySizeClass_wAny];
    menuLayoutSC.orientation = MyOrientation_Horz;
    menuLayoutSC.wrapContentWidth = YES;
    
    
    UILabel *func1LabelSC = [func1Label fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact];
    UILabel *func2LabelSC = [func2Label fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact];
    UILabel *func3LabelSC = [func3Label fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hCompact];

    func1LabelSC.widthSize.equalTo(@[func2LabelSC.widthSize, func3LabelSC.widthSize]);
    func2LabelSC.leadingPos.equalTo(func1LabelSC.trailingPos);
    func3LabelSC.leadingPos.equalTo(func2LabelSC.trailingPos);
    func1LabelSC.heightSize.equalTo(contentLayout.heightSize);
    func2LabelSC.heightSize.equalTo(contentLayout.heightSize);
    func3LabelSC.heightSize.equalTo(contentLayout.heightSize);
    
    //下面是定义在iPad上设备的横屏的界面布局，因为iPad上的SizeClass都是regular，所以这里要区分横竖屏的方法是使用MySizeClass_Portrait和MySizeClass_Landscape
    UILabel *menu1LabelSC = [menu1Label fetchLayoutSizeClass:MySizeClass_wRegular | MySizeClass_hRegular | MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    menu1LabelSC.heightSize.max(200);
    UILabel *menu2LabelSC = [menu2Label fetchLayoutSizeClass:MySizeClass_wRegular | MySizeClass_hRegular | MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    menu2LabelSC.heightSize.max(200);
    UILabel *menu3LabelSC = [menu3Label fetchLayoutSizeClass:MySizeClass_wRegular | MySizeClass_hRegular | MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    menu3LabelSC.heightSize.max(200);


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

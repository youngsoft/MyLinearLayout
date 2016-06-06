//
//  Test7ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLTest1ViewController.h"
#import "MyLayout.h"


@interface FLTest1ViewController ()

@end

@implementation FLTest1ViewController


-(void)loadView
{
    /*
       这个例子主要介绍了框架布局的功能。框架布局里面的所有子视图的布局位置都只跟框架布局相关。
       框架布局中的子视图通过设置marginGravity扩展属性来实现位置和尺寸的设置。
       框架布局中的子视图可以层叠显示，因此框架布局常用来作为视图控制器里面的跟视图。
     */
    
    [super loadView];
    
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.myMargin = 0;              //这个表示框架布局的尺寸和self.view保持一致,四周离父视图的边距都是0
    frameLayout.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    frameLayout.backgroundColor = [UIColor grayColor];
    [self.view addSubview:frameLayout];

    /*
     建立13个子视图，并进行布局。这13个子视图表示可以在框架布局中定位和填充的13个位置和尺寸。
     */
    
    //显示全屏
    UILabel *fill = UILabel.new;
    fill.text = @"                fill";
    fill.backgroundColor = [UIColor blueColor];
    fill.marginGravity = MyMarginGravity_Fill;
    [frameLayout addSubview:fill];
    
    
    //左右填充。
    UILabel *horzFill = UILabel.new;
    horzFill.text = @"Horz Fill";
    [horzFill sizeToFit];
    horzFill.textAlignment = NSTextAlignmentCenter;
    horzFill.backgroundColor = [UIColor greenColor];
    horzFill.marginGravity = MyMarginGravity_Horz_Fill | MyMarginGravity_Vert_Top;
    horzFill.myTopMargin = 40;
    [frameLayout addSubview:horzFill];
    
    
    //左右居中
    UILabel *horzCenter = UILabel.new;
    horzCenter.text = @"Horz Center";
    [horzCenter sizeToFit];
    horzCenter.backgroundColor = [UIColor whiteColor];
    horzCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Top;
    [frameLayout addSubview:horzCenter];
    
    
    //左上
    UILabel *topLeft = UILabel.new;
    topLeft.text = @"topLeft";
    [topLeft sizeToFit];
    topLeft.backgroundColor = [UIColor whiteColor];
    topLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Top;
    [frameLayout addSubview:topLeft];
    
    //左中
    UILabel *centerLeft = UILabel.new;
    centerLeft.text = @"centerLeft";
    [centerLeft sizeToFit];
    centerLeft.backgroundColor = [UIColor whiteColor];
    centerLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Center;
    [frameLayout addSubview:centerLeft];
    
    
    //左下
    UILabel *bottomLeft = UILabel.new;
    bottomLeft.text = @"bottomLeft";
    [bottomLeft sizeToFit];
    bottomLeft.backgroundColor = [UIColor whiteColor];
    bottomLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Bottom;
    [frameLayout addSubview:bottomLeft];
    
    
    //中上
    UILabel *topCenter = UILabel.new;
    topCenter.text = @"topCenter";
    [topCenter sizeToFit];
    topCenter.backgroundColor = [UIColor greenColor];
    topCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Top;
    [frameLayout addSubview:topCenter];
    
    
    //中中。
    UILabel *centerCenter = UILabel.new;
    centerCenter.text = @"centerCenter";
    [centerCenter sizeToFit];
    centerCenter.backgroundColor = [UIColor greenColor];
    centerCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Center;
    [frameLayout addSubview:centerCenter];
    
    
    //中下
    UILabel *bottomCenter = UILabel.new;
    bottomCenter.text = @"bottomCenter";
    [bottomCenter sizeToFit];
    bottomCenter.backgroundColor = [UIColor greenColor];
    bottomCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Bottom;
    [frameLayout addSubview:bottomCenter];
    
    
    //右上
    UILabel *topRight = UILabel.new;
    topRight.text = @"topRight";
    [topRight sizeToFit];
    topRight.backgroundColor = [UIColor greenColor];
    topRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Top;
    [frameLayout addSubview:topRight];
    
    
    //右中
    UILabel *centerRight = UILabel.new;
    centerRight.text = @"centerRight";
    [centerRight sizeToFit];
    centerRight.backgroundColor = [UIColor greenColor];
    centerRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Center;
    [frameLayout addSubview:centerRight];
    
    
    //右下
    UILabel *bottomRight = UILabel.new;
    bottomRight.text = @"bottomRight";
    [bottomRight sizeToFit];
    bottomRight.backgroundColor = [UIColor greenColor];
    bottomRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Bottom;
    [frameLayout addSubview:bottomRight];
    
    
    //居中显示。
    UILabel *center = UILabel.new;
    center.text = @"center";
    [center sizeToFit];
    center.backgroundColor = [UIColor orangeColor];
    center.marginGravity = MyMarginGravity_Center;
    [frameLayout addSubview:center];
    
    
    
    
    
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

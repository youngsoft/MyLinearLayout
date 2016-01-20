//
//  Test7ViewController.m
//  MyLayout
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "FLTest1ViewController.h"
#import "MyLayout.h"


@interface FLTest1ViewController ()

@end

@implementation FLTest1ViewController


-(void)loadView
{
    [super loadView];
    
    //建立13个子视图。并进行布局
    
    MyFrameLayout *fl = [MyFrameLayout new];
    fl.myLeftMargin = fl.myRightMargin = 0;
    fl.myTopMargin = fl.myBottomMargin = 0;
    fl.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    fl.backgroundColor = [UIColor grayColor];
    
    //显示全屏
    UILabel *fill = UILabel.new;
    fill.text = @"                fill";
    fill.backgroundColor = [UIColor blueColor];
    fill.marginGravity = MyMarginGravity_Fill;
    [fl addSubview:fill];
    
    
    
    //左右填充。
    UILabel *horzFill = UILabel.new;
    horzFill.text = @"Horz Fill";
    [horzFill sizeToFit];
    horzFill.textAlignment = NSTextAlignmentCenter;
    horzFill.backgroundColor = [UIColor greenColor];
    horzFill.marginGravity = MyMarginGravity_Horz_Fill | MyMarginGravity_Vert_Top;
    horzFill.myTopMargin = 40;
    [fl addSubview:horzFill];
    
    
    //左右居中
    UILabel *horzCenter = UILabel.new;
    horzCenter.text = @"Horz Center";
    [horzCenter sizeToFit];
    horzCenter.backgroundColor = [UIColor whiteColor];
    horzCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Top;
    [fl addSubview:horzCenter];
    
    
    //左上
    UILabel *topLeft = UILabel.new;
    topLeft.text = @"topLeft";
    [topLeft sizeToFit];
    topLeft.backgroundColor = [UIColor whiteColor];
    topLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Top;
    [fl addSubview:topLeft];
    
    //左中
    UILabel *centerLeft = UILabel.new;
    centerLeft.text = @"centerLeft";
    [centerLeft sizeToFit];
    centerLeft.backgroundColor = [UIColor whiteColor];
    centerLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Center;
    [fl addSubview:centerLeft];
    
    
    //左下
    UILabel *bottomLeft = UILabel.new;
    bottomLeft.text = @"bottomLeft";
    [bottomLeft sizeToFit];
    bottomLeft.backgroundColor = [UIColor whiteColor];
    bottomLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Bottom;
    [fl addSubview:bottomLeft];
    
    
    //中上
    UILabel *topCenter = UILabel.new;
    topCenter.text = @"topCenter";
    [topCenter sizeToFit];
    topCenter.backgroundColor = [UIColor greenColor];
    topCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Top;
    [fl addSubview:topCenter];
    
    
    //中中。
    UILabel *centerCenter = UILabel.new;
    centerCenter.text = @"centerCenter";
    [centerCenter sizeToFit];
    centerCenter.backgroundColor = [UIColor greenColor];
    centerCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Center;
    [fl addSubview:centerCenter];
    
    
    //中下
    UILabel *bottomCenter = UILabel.new;
    bottomCenter.text = @"bottomCenter";
    [bottomCenter sizeToFit];
    bottomCenter.backgroundColor = [UIColor greenColor];
    bottomCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Bottom;
    [fl addSubview:bottomCenter];
    
    
    //右上
    UILabel *topRight = UILabel.new;
    topRight.text = @"topRight";
    [topRight sizeToFit];
    topRight.backgroundColor = [UIColor greenColor];
    topRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Top;
    [fl addSubview:topRight];
    
    
    //右中
    UILabel *centerRight = UILabel.new;
    centerRight.text = @"centerRight";
    [centerRight sizeToFit];
    centerRight.backgroundColor = [UIColor greenColor];
    centerRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Center;
    [fl addSubview:centerRight];
    
    
    UILabel *bottomRight = UILabel.new;
    bottomRight.text = @"bottomRight";
    [bottomRight sizeToFit];
    bottomRight.backgroundColor = [UIColor greenColor];
    bottomRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Bottom;
    [fl addSubview:bottomRight];
    
    
    //居中显示。
    UILabel *center = UILabel.new;
    center.text = @"center";
    [center sizeToFit];
    center.backgroundColor = [UIColor orangeColor];
    center.marginGravity = MyMarginGravity_Center;
    [fl addSubview:center];
    
    
    [self.view addSubview:fl];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"框架布局1";
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

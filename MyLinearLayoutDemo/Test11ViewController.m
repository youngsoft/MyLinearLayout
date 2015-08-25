//
//  Test11ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test11ViewController.h"
#import "MyLayout.h"


@interface Test11ViewController ()

@end

@implementation Test11ViewController


-(void)loadView
{
    [super loadView];
    
    //建立13个子视图。并进行布局
    
    MyFrameLayout *fl = [MyFrameLayout new];
    fl.leftMargin = fl.rightMargin = 0;
    fl.topMargin = fl.bottomMargin = 0;
    fl.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    fl.backgroundColor = [UIColor grayColor];
    
    //显示全屏
    UILabel *fill = UILabel.new;
    fill.text = @"                fill";
    fill.backgroundColor = [UIColor blueColor];
    fill.marginGravity = MGRAVITY_FILL;
    [fl addSubview:fill];
    
    
    
    //左右填充。
    UILabel *horzFill = UILabel.new;
    horzFill.text = @"Horz Fill";
    [horzFill sizeToFit];
    horzFill.textAlignment = NSTextAlignmentCenter;
    horzFill.backgroundColor = [UIColor greenColor];
    horzFill.marginGravity = MGRAVITY_HORZ_FILL | MGRAVITY_VERT_TOP;
    horzFill.topMargin = 40;
    [fl addSubview:horzFill];
    
    
    //左右居中
    UILabel *horzCenter = UILabel.new;
    horzCenter.text = @"Horz Center";
    [horzCenter sizeToFit];
    horzCenter.backgroundColor = [UIColor whiteColor];
    horzCenter.marginGravity = MGRAVITY_HORZ_CENTER | MGRAVITY_VERT_TOP;
    [fl addSubview:horzCenter];
    
    
    //左上
    UILabel *topLeft = UILabel.new;
    topLeft.text = @"topLeft";
    [topLeft sizeToFit];
    topLeft.backgroundColor = [UIColor whiteColor];
    topLeft.marginGravity = MGRAVITY_HORZ_LEFT | MGRAVITY_VERT_TOP;
    [fl addSubview:topLeft];
    
    //左中
    UILabel *centerLeft = UILabel.new;
    centerLeft.text = @"centerLeft";
    [centerLeft sizeToFit];
    centerLeft.backgroundColor = [UIColor whiteColor];
    centerLeft.marginGravity = MGRAVITY_HORZ_LEFT | MGRAVITY_VERT_CENTER;
    [fl addSubview:centerLeft];
    
    
    //左下
    UILabel *bottomLeft = UILabel.new;
    bottomLeft.text = @"bottomLeft";
    [bottomLeft sizeToFit];
    bottomLeft.backgroundColor = [UIColor whiteColor];
    bottomLeft.marginGravity = MGRAVITY_HORZ_LEFT | MGRAVITY_VERT_BOTTOM;
    [fl addSubview:bottomLeft];
    
    
    //中上
    UILabel *topCenter = UILabel.new;
    topCenter.text = @"topCenter";
    [topCenter sizeToFit];
    topCenter.backgroundColor = [UIColor greenColor];
    topCenter.marginGravity = MGRAVITY_HORZ_CENTER | MGRAVITY_VERT_TOP;
    [fl addSubview:topCenter];
    
    
    //中中。
    UILabel *centerCenter = UILabel.new;
    centerCenter.text = @"centerCenter";
    [centerCenter sizeToFit];
    centerCenter.backgroundColor = [UIColor greenColor];
    centerCenter.marginGravity = MGRAVITY_HORZ_CENTER | MGRAVITY_VERT_CENTER;
    [fl addSubview:centerCenter];
    
    
    //中下
    UILabel *bottomCenter = UILabel.new;
    bottomCenter.text = @"bottomCenter";
    [bottomCenter sizeToFit];
    bottomCenter.backgroundColor = [UIColor greenColor];
    bottomCenter.marginGravity = MGRAVITY_HORZ_CENTER | MGRAVITY_VERT_BOTTOM;
    [fl addSubview:bottomCenter];
    
    
    //右上
    UILabel *topRight = UILabel.new;
    topRight.text = @"topRight";
    [topRight sizeToFit];
    topRight.backgroundColor = [UIColor greenColor];
    topRight.marginGravity = MGRAVITY_HORZ_RIGHT | MGRAVITY_VERT_TOP;
    [fl addSubview:topRight];
    
    
    //右中
    UILabel *centerRight = UILabel.new;
    centerRight.text = @"centerRight";
    [centerRight sizeToFit];
    centerRight.backgroundColor = [UIColor greenColor];
    centerRight.marginGravity = MGRAVITY_HORZ_RIGHT | MGRAVITY_VERT_CENTER;
    [fl addSubview:centerRight];
    
    
    UILabel *bottomRight = UILabel.new;
    bottomRight.text = @"bottomRight";
    [bottomRight sizeToFit];
    bottomRight.backgroundColor = [UIColor greenColor];
    bottomRight.marginGravity = MGRAVITY_HORZ_RIGHT | MGRAVITY_VERT_BOTTOM;
    [fl addSubview:bottomRight];
    
    
    //居中显示。
    UILabel *center = UILabel.new;
    center.text = @"center";
    [center sizeToFit];
    center.backgroundColor = [UIColor orangeColor];
    center.marginGravity = MGRAVITY_CENTER;
   [fl addSubview:center];
 
    
    [self.view addSubview:fl];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.title = @"框架布局";
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

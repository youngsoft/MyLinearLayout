//
//  Test7ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@interface FLTest1ViewController ()

@end

@implementation FLTest1ViewController

-(UILabel*)createLabel:(NSString*)title backgroundColor:(UIColor*)color
{
    UILabel *v = UILabel.new;
    v.text = title;
    v.font = [CFTool font:15];
    v.textAlignment = NSTextAlignmentCenter;
    v.backgroundColor = color;
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [CFTool color:4].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;
    [v sizeToFit];

    return v;
}

-(void)loadView
{
    /*
       这个例子主要介绍了框架布局的功能。框架布局里面的所有子视图的布局位置都只跟框架布局相关。
       框架布局中的子视图通过设置marginGravity扩展属性来实现位置和尺寸的设置。
       框架布局中的子视图可以层叠显示，因此框架布局常用来作为视图控制器里面的跟视图。
     */
    
    [super loadView];
    
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.backgroundColor = [UIColor whiteColor];
    frameLayout.myMargin = 0;              //这个表示框架布局的尺寸和self.view保持一致,四周离父视图的边距都是0
    frameLayout.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.view addSubview:frameLayout];

    /*
     建立13个子视图，并进行布局。这13个子视图表示可以在框架布局中定位和填充的13个位置和尺寸。
     */
    
    //显示全屏
    UILabel *fill = [self createLabel:@"" backgroundColor:[CFTool color:0]];
    fill.marginGravity = MyMarginGravity_Fill;
    [frameLayout addSubview:fill];
    
    
    //左右填充。
    UILabel *horzFill = [self createLabel:@"horz fill" backgroundColor:[CFTool color:8]];
    horzFill.marginGravity = MyMarginGravity_Horz_Fill | MyMarginGravity_Vert_Top;
    horzFill.myTopMargin = 40;
    [frameLayout addSubview:horzFill];
    
    //上下填充
    UILabel *vertFill = [self createLabel:@"vert fill" backgroundColor:[CFTool color:9]];
    vertFill.numberOfLines = 0;
    vertFill.marginGravity = MyMarginGravity_Vert_Fill | MyMarginGravity_Horz_Left;
    vertFill.myLeftMargin = 90;
    vertFill.myWidth = 10;
    [frameLayout addSubview:vertFill];

    
    
    //左上
    UILabel *topLeft = [self createLabel:@"top left" backgroundColor:[CFTool color:5]];
    topLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Top;
    [frameLayout addSubview:topLeft];
    
    //左中
    UILabel *centerLeft = [self createLabel:@"center left" backgroundColor:[CFTool color:5]];
    centerLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Center;
    [frameLayout addSubview:centerLeft];
    
    
    //左下
    UILabel *bottomLeft = [self createLabel:@"bottom left" backgroundColor:[CFTool color:5]];
    bottomLeft.marginGravity = MyMarginGravity_Horz_Left | MyMarginGravity_Vert_Bottom;
    [frameLayout addSubview:bottomLeft];
    
    
    //中上
    UILabel *topCenter = [self createLabel:@"top center" backgroundColor:[CFTool color:6]];
    topCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Top;
    [frameLayout addSubview:topCenter];
    
    
    //中中。
    UILabel *centerCenter = [self createLabel:@"center center" backgroundColor:[CFTool color:6]];
    centerCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Center;
    [frameLayout addSubview:centerCenter];
    
    
    //中下
    UILabel *bottomCenter = [self createLabel:@"bottom center" backgroundColor:[CFTool color:6]];
    bottomCenter.marginGravity = MyMarginGravity_Horz_Center | MyMarginGravity_Vert_Bottom;
    [frameLayout addSubview:bottomCenter];
    
    
    //右上
    UILabel *topRight = [self createLabel:@"top right" backgroundColor:[CFTool color:7]];
    topRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Top;
    [frameLayout addSubview:topRight];
    
    
    //右中
    UILabel *centerRight = [self createLabel:@"center right" backgroundColor:[CFTool color:7]];
    centerRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Center;
    [frameLayout addSubview:centerRight];
    
    
    //右下
    UILabel *bottomRight = [self createLabel:@"bottom right" backgroundColor:[CFTool color:7]];
    bottomRight.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Bottom;
    [frameLayout addSubview:bottomRight];
    
    

    
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

//
//  Test13ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/26.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "RLTest1ViewController.h"
#import "MyLayout.h"


@implementation RLTest1ViewController

-(void)loadView
{
    /*
       这个DEMO，主要介绍相对布局里面的子视图如果通过扩展属性MyLayoutPos对象属性来设置各视图之间的依赖关系。
       苹果系统原生的AutoLayout其本质就是一套相对布局体系。但是MyRelativeLayout所具有的功能比AutoLayout还要强大。
     */
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.backgroundColor = [UIColor grayColor];
    self.view = rootLayout;

    /*
       顶部区域部分
     */
    UILabel *todayLabel = [UILabel new];
    todayLabel.text = @"Today";
    [todayLabel sizeToFit];
    todayLabel.centerXPos.equalTo(@0);  //水平中心点在父布局水平中心点的偏移为0，意味着和父视图水平居中对齐。
    todayLabel.topPos.equalTo(@20);     //顶部离父视图的边距为20
    [rootLayout addSubview:todayLabel];
    
    
    /*
       左上角区域部分
     */
    UIView *greenCircle = [UIView new];
    greenCircle.backgroundColor = [UIColor greenColor];
    greenCircle.layer.cornerRadius = 100;
    greenCircle.widthDime.equalTo(rootLayout.widthDime).multiply(3/5.0).max(200); //宽度是父视图宽度的3/5,且最大只能是200。
    greenCircle.heightDime.equalTo(greenCircle.widthDime);    //高度和自身宽度相等。
    greenCircle.leftPos.equalTo(@10);    //左边距离父视图10
    greenCircle.topPos.equalTo(@90);     //顶部距离父视图90
    [rootLayout addSubview:greenCircle];

    
    UILabel *walkLabel = [UILabel new];
    walkLabel.text = @"Walk";
    walkLabel.textColor = [UIColor greenColor];
    [walkLabel sizeToFit];
    walkLabel.centerXPos.equalTo(greenCircle.centerXPos);      //水平中心点和greenCircle水平中心点一致，意味着和greenCircle水平居中对齐。
    walkLabel.bottomPos.equalTo(greenCircle.topPos).offset(5);  //底部是greenCircle的顶部再往上偏移5个点。
    [rootLayout addSubview:walkLabel];
    
    
    UILabel *walkSteps = [UILabel new];
    walkSteps.text = @"9,362";
    walkSteps.textColor = [UIColor whiteColor];
    walkSteps.font = [UIFont systemFontOfSize:30];
    [walkSteps sizeToFit];
    walkSteps.centerXPos.equalTo(greenCircle.centerXPos);
    walkSteps.centerYPos.equalTo(greenCircle.centerYPos);   //水平中心点和垂直中心点都和greenCircle一样，意味着二者居中对齐。
    [rootLayout addSubview:walkSteps];
    
    UILabel *steps = [UILabel new];
    steps.text = @"steps";
    steps.textColor = [UIColor whiteColor];
    steps.font = [UIFont systemFontOfSize:15];
    [steps sizeToFit];
    steps.centerXPos.equalTo(walkSteps.centerXPos);  //和walkSteps水平居中对齐。
    steps.topPos.equalTo(walkSteps.bottomPos);       //顶部是walkSteps的底部。
    [rootLayout addSubview:steps];
    
    
    /*
      右上角区域部分
     */
    UIView *blueCircle = [UIView new];
    blueCircle.backgroundColor = [UIColor blueColor];
    blueCircle.layer.cornerRadius = 60;
    blueCircle.topPos.equalTo(greenCircle.topPos).offset(-10);  //顶部和greenCircle顶部对齐，并且往上偏移10个点。
    blueCircle.rightPos.equalTo(rootLayout.rightPos).offset(10);  //右边和布局视图右对齐，并且往左边偏移10个点。
    blueCircle.widthDime.equalTo(@120);                           //宽度是120
    blueCircle.heightDime.equalTo(blueCircle.widthDime);           //高度和宽度相等。
    [rootLayout addSubview:blueCircle];
    
    
    UILabel *cycleLabel = [UILabel new];
    cycleLabel.text = @"Cycle";
    cycleLabel.textColor = [UIColor blueColor];
    [cycleLabel sizeToFit];
    cycleLabel.centerXPos.equalTo(blueCircle.centerXPos);        //和blueCircle水平居中对齐
    cycleLabel.bottomPos.equalTo(blueCircle.topPos).offset(5);   //底部在blueCircle的上面，再往上偏移5个点。
    [rootLayout addSubview:cycleLabel];
    
    
    UILabel *cycleMin = [UILabel new];
    cycleMin.text = @"39 Min";
    cycleMin.textColor = [UIColor whiteColor];
    cycleMin.font = [UIFont systemFontOfSize:18];
    [cycleMin sizeToFit];
    cycleMin.leftPos.equalTo(blueCircle.leftPos);     //左边和blueCircle左对齐
    cycleMin.centerYPos.equalTo(blueCircle.centerYPos);  //和blueCircle垂直居中对齐。
    [rootLayout addSubview:cycleMin];
    
 
    /*
       中间区域部分
     */
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [UIColor redColor];
    lineView1.leftPos.equalTo(@0);
    lineView1.rightPos.equalTo(@0);  //和父布局的左右边距为0，这个也同时确定了视图的宽度和父视图一样。
    lineView1.heightDime.equalTo(@2);  //高度固定为2
    lineView1.centerYPos.equalTo(@0);   //和父视图垂直居中对齐。
    [rootLayout addSubview:lineView1];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [UIColor greenColor];
    lineView2.widthDime.equalTo(rootLayout.widthDime).add(-20);  //宽度等于父视图的宽度减20
    lineView2.heightDime.equalTo(@2);                            //高度固定为2
    lineView2.topPos.equalTo(lineView1.bottomPos).offset(2);    //顶部在lineView1的下面往下偏移2
    lineView2.centerXPos.equalTo(rootLayout.centerXPos);       //和父视图水平居中对齐
    [rootLayout addSubview:lineView2];
    
    /*
       左下角区域部分。
     */
    UIView *bottomHalfCircleView = [UIView new];
    bottomHalfCircleView.backgroundColor = [UIColor whiteColor];
    bottomHalfCircleView.layer.cornerRadius = 25;
    bottomHalfCircleView.widthDime.equalTo(@50);      //宽度固定为50
    bottomHalfCircleView.heightDime.equalTo(bottomHalfCircleView.widthDime);  //高度等于宽度
    bottomHalfCircleView.centerYPos.equalTo(rootLayout.bottomPos).offset(10); //垂直中心点和父布局的底部对齐，并且往下偏移10个点。 因为rootLayout设置了bottomPadding为10，所以这里要偏移10，否则不需要设置偏移。
    bottomHalfCircleView.leftPos.equalTo(rootLayout.leftPos).offset(50); //左边父布局左对齐，并且向右偏移50个点。
    [rootLayout addSubview:bottomHalfCircleView];

    
    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = [UIColor greenColor];
    lineView3.widthDime.equalTo(@5);
    lineView3.heightDime.equalTo(@50);
    lineView3.bottomPos.equalTo(bottomHalfCircleView.topPos);
    lineView3.centerXPos.equalTo(bottomHalfCircleView.centerXPos);
    [rootLayout addSubview:lineView3];
    
    
    UILabel *walkLabel2 = [UILabel new];
    walkLabel2.text = @"Walk";
    walkLabel2.textColor = [UIColor greenColor];
    [walkLabel2 sizeToFit];
    walkLabel2.leftPos.equalTo(lineView3.rightPos).offset(15);
    walkLabel2.centerYPos.equalTo(lineView3.centerYPos);
    [rootLayout addSubview:walkLabel2];
    
    
    UILabel *walkLabel3 = [UILabel new];
    walkLabel3.text = @"18 Min";
    walkLabel3.textColor = [UIColor whiteColor];
    [walkLabel3 sizeToFit];
    walkLabel3.leftPos.equalTo(walkLabel2.rightPos).offset(5);
    walkLabel3.centerYPos.equalTo(walkLabel2.centerYPos);
    [rootLayout addSubview:walkLabel3];

    UILabel *timeLabel1 = [UILabel new];
    timeLabel1.text = @"9:12";
    timeLabel1.textColor = [UIColor lightGrayColor];
    [timeLabel1 sizeToFit];
    timeLabel1.rightPos.equalTo(lineView3.leftPos).offset(25);
    timeLabel1.centerYPos.equalTo(lineView3.topPos);
    [rootLayout addSubview:timeLabel1];
    
    
    UILabel *timeLabel2 = [UILabel new];
    timeLabel2.text = @"9:30";
    timeLabel2.textColor = [UIColor lightGrayColor];
    [timeLabel2 sizeToFit];
    timeLabel2.rightPos.equalTo(timeLabel1.rightPos);
    timeLabel2.centerYPos.equalTo(lineView3.bottomPos);
    [rootLayout addSubview:timeLabel2];
    
    
    
    UIView *lineView4 = [UIView new];
    lineView4.backgroundColor = [UIColor whiteColor];
    lineView4.layer.cornerRadius = 25;
    lineView4.widthDime.equalTo(bottomHalfCircleView.widthDime);
    lineView4.heightDime.equalTo(lineView4.widthDime).add(30);
    lineView4.bottomPos.equalTo(lineView3.topPos);
    lineView4.centerXPos.equalTo(lineView3.centerXPos);
    [rootLayout addSubview:lineView4];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    imageView4.widthDime.equalTo(lineView4.widthDime).multiply(1/3.0);
    imageView4.heightDime.equalTo(imageView4.widthDime);
    imageView4.centerXPos.equalTo(lineView4.centerXPos);
    imageView4.centerYPos.equalTo(lineView4.centerYPos);
    [rootLayout addSubview:imageView4];
    
    
    UILabel *homeLabel = [UILabel new];
    homeLabel.text = @"Home";
    homeLabel.textColor = [UIColor whiteColor];
    [homeLabel sizeToFit];
    homeLabel.leftPos.equalTo(lineView4.rightPos).offset(10);
    homeLabel.centerYPos.equalTo(lineView4.centerYPos);
    [rootLayout addSubview:homeLabel];
    
    /*
      右下角区域部分。
     */
    UIImageView *bottomRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    bottomRightImageView.backgroundColor = [UIColor whiteColor];
    bottomRightImageView.rightPos.equalTo(rootLayout.rightPos);
    bottomRightImageView.bottomPos.equalTo(rootLayout.bottomPos);
    [rootLayout addSubview:bottomRightImageView];

}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

@end

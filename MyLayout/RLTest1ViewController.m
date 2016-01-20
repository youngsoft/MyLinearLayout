//
//  Test13ViewController.m
//  MyLayout
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "RLTest1ViewController.h"
#import "MyLayout.h"


@implementation RLTest1ViewController

-(void)loadView
{
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.backgroundColor = [UIColor grayColor];
    self.view = rootLayout;

    UILabel *todayLabel = [UILabel new];
    todayLabel.text = @"Today";
    
    [todayLabel sizeToFit];
    todayLabel.centerXPos.equalTo(@0);
    todayLabel.topPos.equalTo(@20);
    [rootLayout addSubview:todayLabel];
    
    
    
    UIView *greenCircle = [UIView new];
    greenCircle.backgroundColor = [UIColor greenColor];
    greenCircle.layer.cornerRadius = 100;
    [rootLayout addSubview:greenCircle];

    
    
    greenCircle.widthDime.equalTo(rootLayout.widthDime).multiply(3/5.0).max(200);
    greenCircle.heightDime.equalTo(greenCircle.widthDime);
    greenCircle.leftPos.equalTo(@10);
    greenCircle.topPos.equalTo(@90);
    
    
    UILabel *walkLabel = [UILabel new];
    walkLabel.text = @"Walk";
    walkLabel.textColor = [UIColor greenColor];
    
    [walkLabel sizeToFit];
    walkLabel.centerXPos.equalTo(greenCircle.centerXPos);
    walkLabel.bottomPos.equalTo(greenCircle.topPos).offset(5);
    [rootLayout addSubview:walkLabel];
    
    
    UILabel *walkSteps = [UILabel new];
    walkSteps.text = @"9,362";
    walkSteps.textColor = [UIColor whiteColor];
    walkSteps.font = [UIFont systemFontOfSize:30];

    [walkSteps sizeToFit];
    walkSteps.centerXPos.equalTo(greenCircle.centerXPos);
    walkSteps.centerYPos.equalTo(greenCircle.centerYPos);
    [rootLayout addSubview:walkSteps];
    
    UILabel *steps = [UILabel new];
    steps.text = @"steps";
    steps.textColor = [UIColor whiteColor];
    steps.font = [UIFont systemFontOfSize:15];
    
    [steps sizeToFit];
    steps.centerXPos.equalTo(walkSteps.centerXPos);
    steps.topPos.equalTo(walkSteps.bottomPos);
    [rootLayout addSubview:steps];
    
    
    
    UIView *blueCircle = [UIView new];
    blueCircle.backgroundColor = [UIColor blueColor];
    blueCircle.layer.cornerRadius = 60;
    
    blueCircle.topPos.equalTo(greenCircle.topPos).offset(-10);
    blueCircle.rightPos.equalTo(rootLayout.rightPos).offset(10);
    blueCircle.widthDime.equalTo(@120);
    blueCircle.heightDime.equalTo(blueCircle.widthDime);
    [rootLayout addSubview:blueCircle];
    
    
    UILabel *cycleLabel = [UILabel new];
    cycleLabel.text = @"Cycle";
    cycleLabel.textColor = [UIColor blueColor];
    
    [cycleLabel sizeToFit];
    cycleLabel.centerXPos.equalTo(blueCircle.centerXPos);
    cycleLabel.bottomPos.equalTo(blueCircle.topPos).offset(5);
    [rootLayout addSubview:cycleLabel];
    
    
    UILabel *cycleMin = [UILabel new];
    cycleMin.text = @"39 Min";
    cycleMin.textColor = [UIColor whiteColor];
    cycleMin.font = [UIFont systemFontOfSize:18];
    
    [cycleMin sizeToFit];
    cycleMin.leftPos.equalTo(blueCircle.leftPos);
    cycleMin.centerYPos.equalTo(blueCircle.centerYPos);
    [rootLayout addSubview:cycleMin];
    
 
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [UIColor redColor];
    lineView1.leftPos.equalTo(@0);
    lineView1.rightPos.equalTo(@0);
    lineView1.heightDime.equalTo(@2);
    lineView1.centerYPos.equalTo(@0);
    [rootLayout addSubview:lineView1];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [UIColor greenColor];
    lineView2.widthDime.equalTo(rootLayout.widthDime).add(-20);
    lineView2.heightDime.equalTo(@2);
    lineView2.topPos.equalTo(lineView1.bottomPos).offset(2);
    lineView2.centerXPos.equalTo(rootLayout.centerXPos);
    [rootLayout addSubview:lineView2];
    
    
    UIView *bottomHalfCircleView = [UIView new];
    bottomHalfCircleView.backgroundColor = [UIColor whiteColor];
    bottomHalfCircleView.layer.cornerRadius = 25;
    
    bottomHalfCircleView.widthDime.equalTo(@50);
    bottomHalfCircleView.heightDime.equalTo(bottomHalfCircleView.widthDime);
    bottomHalfCircleView.centerYPos.equalTo(rootLayout.bottomPos).offset(10); //因为rootLayout设置了bottomPadding为10，所以这里要偏移10，否则不需要设置偏移。
    bottomHalfCircleView.leftPos.equalTo(rootLayout.leftPos).offset(50);
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
    [imageView4 sizeToFit];
    
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
    
    
    UIImageView *bottomRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    bottomRightImageView.backgroundColor = [UIColor whiteColor];
    
    [bottomRightImageView sizeToFit];
    bottomRightImageView.rightPos.equalTo(rootLayout.rightPos);
    bottomRightImageView.bottomPos.equalTo(rootLayout.bottomPos);
    [rootLayout addSubview:bottomRightImageView];


    
    return;
    
    

  
   
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"相对布局1-视图之间的依赖";
}

@end

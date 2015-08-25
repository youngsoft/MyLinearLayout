//
//  Test13ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test13ViewController.h"
#import "MyLayout.h"


@implementation Test13ViewController

-(void)loadView
{
    
    MyRelativeLayout *rl = [MyRelativeLayout new];
    rl.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rl.backgroundColor = [UIColor grayColor];
    self.view = rl;
    
    UILabel *lb1 = [UILabel new];
    [rl addSubview:lb1];
    lb1.text = @"你好";
    [lb1 sizeToFit];
    lb1.backgroundColor = [UIColor blueColor];
   
    
    lb1.leftPos.equalTo(rl.leftPos); //和父视图左边一致
    lb1.topPos.equalTo(rl.topPos).offset(10); //和父视图顶部一致并偏移10
    lb1.widthDime.equalTo(@60); //固定宽度
    
    UILabel *lb2 = [UILabel new];
    [rl addSubview:lb2];
    lb2.text = @"我好 hello";
    lb2.backgroundColor = [UIColor redColor];
    
    lb2.leftPos.equalTo(lb1.rightPos);
    lb2.topPos.equalTo(lb1.bottomPos);
    lb2.widthDime.equalTo(lb1.widthDime).add(30); //宽度是lb1的宽度加30
    lb2.heightDime.equalTo(lb1.heightDime).multiply(2).add(-10); //高度是lb1高度的2倍再-10
    
    UILabel *lb3 = [UILabel new];
    lb3.text = @"中间";
    lb3.backgroundColor = [UIColor greenColor];
    [rl addSubview:lb3];
    
    //下面两种方式都是设置为居中
   // lb3.centerXPos.equalTo(rl.centerXPos);
   // lb3.centerYPos.equalTo(rl.centerYPos);
    lb3.centerXPos.equalTo(@0);
    lb3.centerYPos.equalTo(@0);
    
    lb3.widthDime.equalTo(rl.widthDime).multiply(0.2);
    lb3.heightDime.equalTo(rl.heightDime).multiply(0.1);
    
    UILabel *lb4 = [UILabel new];
    lb4.text = @"他好";
    [lb4 sizeToFit];
    lb4.backgroundColor = [UIColor orangeColor];
    [rl addSubview:lb4];
    
    //宽度和高度由左右决定
    lb4.leftPos.equalTo(rl.leftPos);
    lb4.rightPos.equalTo(rl.rightPos);
    lb4.topPos.equalTo(@100);
   
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"相对布局1-视图之间的依赖";
}

@end

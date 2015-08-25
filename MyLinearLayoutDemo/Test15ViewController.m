//
//  Test15ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test15ViewController.h"
#import "MyLayout.h"

@interface Test15ViewController ()

@end

@implementation Test15ViewController

-(void)loadView
{
    [super loadView];
    
    MyRelativeLayout *rl = [[MyRelativeLayout alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    rl.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:rl];
    rl.wrapContentWidth = YES;
    rl.wrapContentHeight = YES; //设置宽度和高度由所有子视图包裹
    rl.backgroundColor = [UIColor grayColor];
    
    UILabel *lb1 = [UILabel new];
    lb1.leftPos.equalTo(rl.leftPos).offset(20);
    lb1.text = @"aaaa";
    lb1.backgroundColor = [UIColor redColor];
    [lb1 sizeToFit];
    lb1.rightPos.offset(20);
    
    [rl addSubview:lb1];
    
    
    UILabel *lb3 = [UILabel new];
    lb3.rightPos.equalTo(rl.rightPos).offset(5); //虽然这时候父视图的宽度为0,但还是可以设置离父视图的距离
    lb3.topPos.equalTo(rl.topPos).offset(30);
    lb3.bottomPos.offset(10);
    lb3.text = @"ccc";
    lb3.backgroundColor = [UIColor redColor];
    [lb3 sizeToFit];
    
    [rl addSubview:lb3];
    
    
    UILabel *lb2 = [UILabel new];
    lb2.text = @"bbbb";
    lb2.backgroundColor = [UIColor blueColor];
    
    lb2.leftPos.equalTo(lb1.centerXPos);
    lb2.topPos.equalTo(lb1.bottomPos).offset(40);
    lb2.widthDime.equalTo(@50);
    lb2.heightDime.equalTo(@50);
    lb2.bottomPos.offset(40);

   
    [rl addSubview:lb2];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相对布局3-父视图高宽由子视图决定";

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

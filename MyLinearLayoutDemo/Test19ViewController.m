//
//  Test19ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test19ViewController.h"
#import "MyLayout.h"

@interface Test19ViewController ()

@property(nonatomic, strong) UILabel *testlabel;
@property(nonatomic, strong) MyRelativeLayout *ll;

@end

@implementation Test19ViewController

-(void)handleBtn:(UIButton*)sender
{
    
    self.ll.beginLayoutBlock = ^()
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
    };
    
    self.ll.endLayoutBlock = ^()
    {
        [UIView commitAnimations];
    };
    
    self.testlabel.leftMargin += 20;
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"其他";
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    self.ll  = [[MyRelativeLayout alloc] initWithFrame:CGRectMake(0, 70, 320, 500)];
    self.ll.padding = UIEdgeInsetsMake(50, 50, 50, 50);
    self.ll.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.ll];
    
    
    //1依赖于左边视图，右边依赖于2的左边，2左边依赖于1的右边，右边依赖3的左边，3左边依赖于2的右边，右边依赖于右边。
    
    UILabel *lb1 = [UILabel new];
    lb1.text = @"hello1";
    lb1.backgroundColor = [UIColor redColor];
    [lb1 sizeToFit];
    
    UILabel *lb2 = [UILabel new];
    lb2.text = @"hello2";
    lb2.backgroundColor = [UIColor blueColor];
    [lb2 sizeToFit];
    
    self.testlabel = lb2;
    
    UILabel *lb3 = [UILabel new];
    lb3.text = @"hello3";
    lb3.backgroundColor = [UIColor greenColor];
    [lb3 sizeToFit];
    
    [self.ll addSubview:lb1];
    [self.ll addSubview:lb2];
    [self.ll addSubview:lb3];
    
    lb1.leftPos.equalTo(@10);
    lb1.rightPos.equalTo(lb2.leftPos).offset(10);
    lb2.rightPos.equalTo(lb3.leftPos).offset(20);
    lb3.rightPos.equalTo(@30);
    
    
    
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

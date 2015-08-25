//
//  Test2ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test2ViewController.h"
#import "MyLayout.h"

@interface Test2ViewController ()

@end

@implementation Test2ViewController

-(void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    
    MyLinearLayout *ll = [MyLinearLayout new];
    ll.backgroundColor = [UIColor grayColor];
    
    ll.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    ll.leftMargin = 0;
    ll.rightMargin = 0;
    
    UILabel *label = [UILabel new];
    label.leftMargin = 0;
    label.rightMargin = 0;
    label.flexedHeight = YES;  //这个属性会控制在固定宽度下自动调整视图的高度。
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor blueColor];
    label.text = @"这是一段可以隐藏的字符串，点击下面的按钮就可以实现文本的显示和隐藏，同时可以支持根据文字内容动态调整高度，这需要把flexedHeight设置为YES";
    [ll addSubview:label];
    
    UIButton *btn = [UIButton new];
    btn.leftMargin = 0;
    btn.rightMargin = 0;
    btn.height = 60;
    [btn setTitle:@"点击按钮显示隐藏文本" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleLabelShow:) forControlEvents:UIControlEventTouchUpInside];
    [ll addSubview:btn];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor greenColor];
    bottomView.leftMargin = 0;
    bottomView.rightMargin = 0;
    bottomView.height = 800;
    [ll addSubview:bottomView];
    
    

    
    [self.view addSubview:ll];
    
    
}

-(void)handleLabelShow:(UIButton*)sender
{
    
    UIView *supv = sender.superview;
    NSArray *arr = supv.subviews;
    
    UILabel *lab = [arr objectAtIndex:0];
    
    if (lab.isHidden)
        lab.hidden = NO;
    else
        lab.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"子视图的隐藏和滚动视图";
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

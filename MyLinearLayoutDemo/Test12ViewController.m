//
//  Test12ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test12ViewController.h"
#import "MyLayout.h"

@interface Test12ViewController ()

@property(nonatomic,strong) MyLinearLayout *myll;

@end

@implementation Test12ViewController

-(void)loadView
{
    self.view = [UIScrollView new];
    
    
    _myll =  [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _myll.backgroundColor = [UIColor grayColor];
    _myll.padding = UIEdgeInsetsMake(10, 2, 10, 2);
    _myll.leftMargin = _myll.rightMargin = 0;
    _myll.adjustScrollViewContentSize = YES;

    
    MyLinearLayout *l1 = [MyLinearLayout new];
    l1.orientation = LVORIENTATION_HORZ;
    l1.backgroundColor = [UIColor whiteColor];
    l1.leftMargin = l1.rightMargin = 0;
    l1.wrapContentHeight = YES;
    l1.padding = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    button.weight = 1;
    [button setTitle:@"添加行" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    [l1 addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    button.weight = 1;
    [button setTitle:@"删除行" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];
    
    [l1 addSubview:button];
    

    
    [_myll addSubview:l1];
    
    [self.view addSubview:_myll];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"边框的线以及布局动画,触摸事件";
    
    
}

-(void)handleAdd:(UIButton*)id
{
    
    MyLinearLayout *l1 = [MyLinearLayout new];
    l1.backgroundColor = [UIColor whiteColor];
    l1.leftMargin = l1.rightMargin = 0;
     l1.padding = UIEdgeInsetsMake(4, 4, 4, 4);
    
    MyBorderLineDraw   *bld = [[MyBorderLineDraw alloc] initWithColor:[UIColor colorWithRed:(rand() % 256)/256.0 green:(rand() % 256)/256.0 blue:(rand() % 256)/256.0 alpha:1]];

    bld.headIndent = rand() % 4;
    bld.tailIndent = rand() % 3;
    bld.dash = rand() % 2;
    bld.thick = rand()%4;
    
    l1.topBorderLine = bld;
    l1.bottomBorderLine = bld;
   
    UILabel *lb = [UILabel new];
    lb.leftMargin = lb.rightMargin = 0;
    lb.text = @"有了这个功能后就可以放弃用UITableView来做静态的线性布局了,点击一下我试试";
    lb.flexedHeight = YES;
    lb.numberOfLines = 0;
    
    
    l1.topMargin = l1.bottomMargin = 4;
    [l1 addSubview:lb];
    
    //这里设置触摸事件
    l1.highlightedBackgroundColor = [UIColor darkGrayColor];
    [l1 setTarget:self action:@selector(handleAction:)];
    
    [_myll addSubview:l1];
    
    _myll.beginLayoutBlock = ^()
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
    };
    
    _myll.endLayoutBlock = ^()
    {
        [UIView commitAnimations];
    };


    
}

-(void)handleAction:(id)sender
{
    NSLog(@"触摸:%@",sender);
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"test" message:@"触摸" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [av show];
}

-(void)handleDel:(UIButton*)id
{
    if (_myll.subviews.count >=2)
    {
        [(UIView*)[_myll.subviews lastObject] removeFromSuperview];
    }
    
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

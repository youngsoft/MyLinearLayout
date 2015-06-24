//
//  Test12ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "Test12ViewController.h"
#import "MyFrameLayout.h"
#import "MyLinearLayout.h"

@interface Test12ViewController ()

@property(nonatomic,strong) MyLinearLayout *myll;

@end

@implementation Test12ViewController

-(void)loadView
{
    [super loadView];
    
    
    _myll =  [[MyLinearLayout alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    _myll.backgroundColor = [UIColor grayColor];
    _myll.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    MyLinearLayout *l1 = [MyLinearLayout new];
    l1.orientation = LVORIENTATION_HORZ;
    l1.backgroundColor = [UIColor whiteColor];
    l1.matchParentWidth = 1;
    l1.wrapContent = YES;
    l1.padding = UIEdgeInsetsMake(4, 4, 4, 4);
    l1.topBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor blackColor]];
 //   l1.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor blackColor]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    button.weight = 1;
    button.marginGravity = MGRAVITY_CENTER;
    [button setTitle:@"添加行" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    [l1 addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    button.weight = 1;
    button.marginGravity = MGRAVITY_CENTER;
    [button setTitle:@"删除行" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];
    
    [l1 addSubview:button];
    

    
    [_myll addSubview:l1];
    
    [self.view addSubview:_myll];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"边框的线和动画";
    
    
}

-(void)handleAdd:(UIButton*)id
{
    
    MyLinearLayout *l1 = [MyLinearLayout new];
    l1.backgroundColor = [UIColor whiteColor];
    l1.matchParentWidth = 1;
    l1.padding = UIEdgeInsetsMake(4, 4, 4, 4);
    
    MyBorderLineDraw   *bld = [[MyBorderLineDraw alloc] initWithColor:[UIColor colorWithRed:(rand() % 256)/256.0 green:(rand() % 256)/256.0 blue:(rand() % 256)/256.0 alpha:1]];

    bld.headIndent = rand() % 4;
    bld.tailIndent = rand() % 3;
    bld.dash = rand() % 2;
    bld.thick = rand()%4;
    
    l1.topBorderLine = bld;
    l1.bottomBorderLine = bld;
   
    UILabel *lb = [UILabel new];
    lb.matchParentWidth = 1;
    lb.text = @"这是一个新的行";
    [lb sizeToFit];
    
    
    l1.topMargin = 4;
    l1.bottomMargin = 4;
    [l1 addSubview:lb];
    
    l1.highlightedBackgroundColor = [UIColor redColor];
    [l1 setTarget:self action:@selector(handleAction:)];
    
    [_myll addSubview:l1];

    
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

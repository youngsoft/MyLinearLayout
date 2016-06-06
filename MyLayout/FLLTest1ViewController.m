//
//  FLLTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLLTest1ViewController.h"
#import "MyLayout.h"

@interface FLLTest1ViewController ()

@property(nonatomic, strong) MyFlowLayout *flowLayout;

@end

@implementation FLLTest1ViewController

-(void)loadView
{
    /*
        这个例子用来介绍流式布局的特性，流式布局中的子视图总是按一定的规则一次排列，当数量到达一定程度或者内容到达一定程度时就会自动换行从新排列。
     */
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.wrapContentWidth = NO;
    rootLayout.wrapContentHeight = NO;
    rootLayout.gravity = MyMarginGravity_Horz_Fill;
    self.view = rootLayout;
    
    //添加操作按钮。
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:2];
    actionLayout.backgroundColor = [UIColor redColor];
    actionLayout.wrapContentHeight = YES;
    actionLayout.averageArrange = YES;
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    actionLayout.subviewHorzMargin = 5;
    actionLayout.subviewVertMargin = 5;
    [rootLayout addSubview:actionLayout];
    
    [actionLayout addSubview:[self createActionButton:@"调整方向" action:@selector(handleAdjustOrientation:)]];
    [actionLayout addSubview:[self createActionButton:@"调整数量" action:@selector(handleAdjustArrangedCount:)]];
    [actionLayout addSubview:[self createActionButton:@"平均尺寸" action:@selector(handleAdjustAverageMeasure:)]];
    [actionLayout addSubview:[self createActionButton:@"调整停靠" action:@selector(handleAdjustGravity:)]];
    [actionLayout addSubview:[self createActionButton:@"调整排列对齐" action:@selector(handleAdjustArrangeGravity:)]];
    [actionLayout addSubview:[self createActionButton:@"间隔设置" action:@selector(handleAdjustMargin:)]];


    UIScrollView *scrollView = [UIScrollView new];
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.weight = 1;
    scrollView.myTopMargin = 10;
    [rootLayout addSubview:scrollView];
    
    
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    self.flowLayout.backgroundColor = [UIColor lightGrayColor];
    self.flowLayout.frame = CGRectMake(0, 0, 800, 800);
    self.flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.flowLayout.subviewVertMargin = 5;
    self.flowLayout.subviewHorzMargin = 5;
    [scrollView addSubview:self.flowLayout];
    
    NSArray *imageArray = @[@"minions1",@"minions2",@"minions3",@"minions4",@"head1"];
    
    for (int i = 0; i < 60; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[random()%5]]];
        [imageView sizeToFit];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1;
        [self.flowLayout addSubview:imageView];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

//创建动作操作按钮。
-(UIButton*)createActionButton:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.myHeight = 44;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0;
    
    return button;
    
}


#pragma mark -- Handle Method

-(void)handleAdjustOrientation:(id)sender
{
    [self.flowLayout layoutAnimationWithDuration:0.4];
    
    if (self.flowLayout.orientation == MyLayoutViewOrientation_Vert)
        self.flowLayout.orientation = MyLayoutViewOrientation_Horz;
    else
        self.flowLayout.orientation = MyLayoutViewOrientation_Vert;
    
}

-(void)handleAdjustArrangedCount:(id)sender
{
    [self.flowLayout layoutAnimationWithDuration:0.4];
    
    self.flowLayout.arrangedCount = (self.flowLayout.arrangedCount + 1) % 6;
    
}

-(void)handleAdjustAverageMeasure:(id)sender
{
    
    [self.flowLayout layoutAnimationWithDuration:0.4];
    
    self.flowLayout.averageArrange = !self.flowLayout.averageArrange;
    
    if (!self.flowLayout.averageArrange)
    {
        for (UIView *vv in self.flowLayout.subviews)
        {
            [vv sizeToFit];
        }
        
    }
    
}

-(void)handleAdjustGravity:(id)sender
{
    [self.flowLayout layoutAnimationWithDuration:0.4];
    
    if (self.flowLayout.gravity == MyMarginGravity_None)
        self.flowLayout.gravity = MyMarginGravity_Vert_Center;
    else if (self.flowLayout.gravity == MyMarginGravity_Vert_Center)
        self.flowLayout.gravity = MyMarginGravity_Vert_Bottom;
    else if (self.flowLayout.gravity == MyMarginGravity_Vert_Bottom)
        self.flowLayout.gravity = MyMarginGravity_Horz_Center;
    else if (self.flowLayout.gravity == MyMarginGravity_Horz_Center)
        self.flowLayout.gravity = MyMarginGravity_Horz_Right;
    else if (self.flowLayout.gravity == MyMarginGravity_Horz_Right)
        self.flowLayout.gravity = MyMarginGravity_Center;
    else if (self.flowLayout.gravity == MyMarginGravity_Center)
        self.flowLayout.gravity = MyMarginGravity_None;
    
    
    
}

-(void)handleAdjustArrangeGravity:(id)sender
{
    
    [self.flowLayout layoutAnimationWithDuration:0.4];
    
    
    if (self.flowLayout.orientation == MyLayoutViewOrientation_Vert)
    {
        MyMarginGravity mg = self.flowLayout.arrangedGravity & MyMarginGravity_Horz_Mask;
        
        if (mg == MyMarginGravity_None || mg == MyMarginGravity_Vert_Top)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Center;
        else if (mg == MyMarginGravity_Vert_Center)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Bottom;
        else if (mg  == MyMarginGravity_Vert_Bottom)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Fill;
        else if (mg == MyMarginGravity_Vert_Fill)
        {
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Top;
            
            for (UIView *vv in self.flowLayout.subviews)
            {
                [vv sizeToFit];
            }
            
        }
    }
    else
    {
        MyMarginGravity mg = self.flowLayout.arrangedGravity & MyMarginGravity_Vert_Mask;
        
        if (mg == MyMarginGravity_None || mg == MyMarginGravity_Horz_Left)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Center;
        else if (mg == MyMarginGravity_Horz_Center)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Right;
        else if (mg  == MyMarginGravity_Horz_Right)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Fill;
        else if (mg == MyMarginGravity_Horz_Fill)
        {
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Left;
            
            for (UIView *vv in self.flowLayout.subviews)
            {
                [vv sizeToFit];
            }
            
        }
        
        
    }
    
}

-(void)handleAdjustMargin:(id)sender
{
    [self.flowLayout layoutAnimationWithDuration:0.4];
    
    if (self.flowLayout.subviewHorzMargin == 0)
        self.flowLayout.subviewHorzMargin = 5;
    else
        self.flowLayout.subviewHorzMargin = 0;
    
    if (self.flowLayout.subviewVertMargin == 0)
        self.flowLayout.subviewVertMargin = 5;
    else
        self.flowLayout.subviewVertMargin = 0;
    
    
    
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

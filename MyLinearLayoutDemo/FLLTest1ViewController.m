//
//  Test20ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/10/31.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "FLLTest1ViewController.h"
#import "MyLayout.h"

@interface FLLTest1ViewController ()

@property(nonatomic, strong) MyFlowLayout *flowLayout;

@end

@implementation FLLTest1ViewController

-(UIButton*)createActionButton:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.height = 44;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0;
    
    return button;
    
}

-(void)loadView
{
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    rootLayout.wrapContentWidth = NO;
    rootLayout.wrapContentHeight = NO;
    rootLayout.gravity = MGRAVITY_HORZ_FILL;
    self.view = rootLayout;
    
    //添加操作按钮。
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:LVORIENTATION_VERT arrangedCount:2];
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
    scrollView.topMargin = 10;
    [rootLayout addSubview:scrollView];
    
    
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:LVORIENTATION_VERT arrangedCount:3];
    self.flowLayout.backgroundColor = [UIColor lightGrayColor];
    
    self.flowLayout.frame = CGRectMake(0, 0, 800, 800);
    self.flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.flowLayout.subviewVertMargin = 5;
    self.flowLayout.subviewHorzMargin = 5;
    [scrollView addSubview:self.flowLayout];
    
    NSArray *imageArray = @[@"minions1",@"minions2",@"minions3",@"minions4",@"head1"];
    
    for (int i = 0; i < 14; i++)
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
    self.title = @"流式布局";
    // Do any additional setup after loading the view.
    
  //  [self performSelector:@selector(handleTest) withObject:nil afterDelay:4];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Handle Method

-(void)handleAdjustOrientation:(id)sender
{
    self.flowLayout.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
    };
    
    self.flowLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
        
    };
    
    if (self.flowLayout.orientation == LVORIENTATION_VERT)
        self.flowLayout.orientation = LVORIENTATION_HORZ;
    else
        self.flowLayout.orientation = LVORIENTATION_VERT;
    
}

-(void)handleAdjustArrangedCount:(id)sender
{
    self.flowLayout.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
    };
    
    self.flowLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
        
    };
    
    self.flowLayout.arrangedCount = (self.flowLayout.arrangedCount + 1) % 6;
    
}

-(void)handleAdjustAverageMeasure:(id)sender
{
    
    self.flowLayout.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
    };
    
    self.flowLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
        
    };
    
    
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
    self.flowLayout.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
    };
    
    self.flowLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
        
    };
    
    if (self.flowLayout.gravity == MGRAVITY_NONE)
        self.flowLayout.gravity = MGRAVITY_VERT_CENTER;
    else if (self.flowLayout.gravity == MGRAVITY_VERT_CENTER)
        self.flowLayout.gravity = MGRAVITY_VERT_BOTTOM;
    else if (self.flowLayout.gravity == MGRAVITY_VERT_BOTTOM)
        self.flowLayout.gravity = MGRAVITY_HORZ_CENTER;
    else if (self.flowLayout.gravity == MGRAVITY_HORZ_CENTER)
        self.flowLayout.gravity = MGRAVITY_HORZ_RIGHT;
    else if (self.flowLayout.gravity == MGRAVITY_HORZ_RIGHT)
        self.flowLayout.gravity = MGRAVITY_CENTER;
    else if (self.flowLayout.gravity == MGRAVITY_CENTER)
        self.flowLayout.gravity = MGRAVITY_NONE;
    
    
    
}

-(void)handleAdjustArrangeGravity:(id)sender
{
    
    self.flowLayout.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
    };
    
    self.flowLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
        
    };
    
    
    if (self.flowLayout.orientation == LVORIENTATION_VERT)
    {
        MarignGravity mg = self.flowLayout.arrangedGravity & MGRAVITY_HORZ_MASK;
        
        if (mg == MGRAVITY_NONE || mg == MGRAVITY_VERT_TOP)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MGRAVITY_VERT_MASK) | MGRAVITY_VERT_CENTER;
        else if (mg == MGRAVITY_VERT_CENTER)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MGRAVITY_VERT_MASK) | MGRAVITY_VERT_BOTTOM;
        else if (mg  == MGRAVITY_VERT_BOTTOM)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MGRAVITY_VERT_MASK) | MGRAVITY_VERT_FILL;
        else if (mg == MGRAVITY_VERT_FILL)
        {
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MGRAVITY_VERT_MASK) | MGRAVITY_VERT_TOP;
            
            for (UIView *vv in self.flowLayout.subviews)
            {
                [vv sizeToFit];
            }
            
        }
    }
    else
    {
        MarignGravity mg = self.flowLayout.arrangedGravity & MGRAVITY_VERT_MASK;
        
        if (mg == MGRAVITY_NONE || mg == MGRAVITY_HORZ_LEFT)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MGRAVITY_HORZ_MASK) | MGRAVITY_HORZ_CENTER;
        else if (mg == MGRAVITY_HORZ_CENTER)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MGRAVITY_HORZ_MASK) | MGRAVITY_HORZ_RIGHT;
        else if (mg  == MGRAVITY_HORZ_RIGHT)
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MGRAVITY_HORZ_MASK) | MGRAVITY_HORZ_FILL;
        else if (mg == MGRAVITY_HORZ_FILL)
        {
            self.flowLayout.arrangedGravity = (self.flowLayout.arrangedGravity & MGRAVITY_HORZ_MASK) | MGRAVITY_HORZ_LEFT;
            
            for (UIView *vv in self.flowLayout.subviews)
            {
                [vv sizeToFit];
            }
            
        }
        
        
    }
    
}

-(void)handleAdjustMargin:(id)sender
{
    self.flowLayout.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
    };
    
    self.flowLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
        
    };
    
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

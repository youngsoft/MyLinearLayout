//
//  FLLTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLLTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

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
    actionLayout.wrapContentHeight = YES;
    actionLayout.gravity = MyMarginGravity_Horz_Fill;  //所有子视图水平填充，也就是所有子视图的宽度相等。
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    actionLayout.subviewHorzMargin = 5;
    actionLayout.subviewVertMargin = 5;
    [rootLayout addSubview:actionLayout];
    
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust orientation", @"")
                                               action:@selector(handleAdjustOrientation:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust arrangedCount", @"")
                                               action:@selector(handleAdjustArrangedCount:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust vert gravity", @"")
                                               action:@selector(handleAdjustVertGravity:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust horz gravity", @"")
                                               action:@selector(handleAdjustHorzGravity:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust align", @"")
                                               action:@selector(handleAdjustArrangeGravity:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust spacing", @"")
                                               action:@selector(handleAdjustMargin:)]];


    UIScrollView *scrollView = [UIScrollView new];
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.weight = 1;
    scrollView.myTopMargin = 10;
    [rootLayout addSubview:scrollView];
    
    
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    self.flowLayout.backgroundColor = [CFTool color:0];
    self.flowLayout.frame = CGRectMake(0, 0, 800, 800);
    self.flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.flowLayout.subviewVertMargin = 5;
    self.flowLayout.subviewHorzMargin = 5;
    [scrollView addSubview:self.flowLayout];
    
    NSArray *imageArray = @[@"minions1",@"minions2",@"minions3",@"minions4",@"head1"];
    
    for (int i = 0; i < 30; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[random()%5]]];
        [imageView sizeToFit];
        imageView.layer.borderColor = [CFTool color:5].CGColor;
        imageView.layer.borderWidth = 0.5;
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [CFTool font:14];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.myHeight = 44;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5;
    
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

-(void)handleAdjustVertGravity:(id)sender
{
    
    MyMarginGravity vertGravity = self.flowLayout.gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity horzGravity = self.flowLayout.gravity & MyMarginGravity_Vert_Mask;
    
    switch (vertGravity) {
        case MyMarginGravity_None:
        case MyMarginGravity_Vert_Top:
            vertGravity = MyMarginGravity_Vert_Center;
            break;
        case MyMarginGravity_Vert_Center:
            vertGravity = MyMarginGravity_Vert_Bottom;
            break;
        case MyMarginGravity_Vert_Bottom:
            vertGravity = MyMarginGravity_Vert_Between;
            break;
        case MyMarginGravity_Vert_Between:
            vertGravity = MyMarginGravity_Vert_Fill;
            break;
        case MyMarginGravity_Vert_Fill:
        {
            vertGravity = MyMarginGravity_Vert_Top;
            [self.flowLayout.subviews makeObjectsPerformSelector:@selector(sizeToFit)];
        }
        default:
            break;
    }
    
    self.flowLayout.gravity = horzGravity | vertGravity;
    [self.flowLayout layoutAnimationWithDuration:0.4];

 }

-(void)handleAdjustHorzGravity:(id)sender
{
    MyMarginGravity vertGravity = self.flowLayout.gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity horzGravity = self.flowLayout.gravity & MyMarginGravity_Vert_Mask;
    
    switch (horzGravity) {
        case MyMarginGravity_None:
        case MyMarginGravity_Horz_Left:
            horzGravity = MyMarginGravity_Horz_Center;
            break;
        case MyMarginGravity_Horz_Center:
            horzGravity = MyMarginGravity_Horz_Right;
            break;
        case MyMarginGravity_Horz_Right:
            horzGravity = MyMarginGravity_Horz_Between;
            break;
        case MyMarginGravity_Horz_Between:
            horzGravity = MyMarginGravity_Horz_Fill;
            break;
        case MyMarginGravity_Horz_Fill:
        {
            horzGravity = MyMarginGravity_Horz_Left;
            [self.flowLayout.subviews makeObjectsPerformSelector:@selector(sizeToFit)];
        }
        default:
            break;
    }
    
    self.flowLayout.gravity = horzGravity | vertGravity;
    
    [self.flowLayout layoutAnimationWithDuration:0.4];
}


-(void)handleAdjustArrangeGravity:(id)sender
{
    
    
    MyMarginGravity vertArrangeGravity = self.flowLayout.arrangedGravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity horzArrangeGravity = self.flowLayout.arrangedGravity & MyMarginGravity_Vert_Mask;

    if (self.flowLayout.orientation == MyLayoutViewOrientation_Vert)
    {
        
        switch (vertArrangeGravity) {
            case MyMarginGravity_None:
            case MyMarginGravity_Vert_Top:
                vertArrangeGravity = MyMarginGravity_Vert_Center;
                break;
            case MyMarginGravity_Vert_Center:
                vertArrangeGravity = MyMarginGravity_Vert_Bottom;
                break;
            case MyMarginGravity_Vert_Bottom:
                vertArrangeGravity = MyMarginGravity_Vert_Fill;
                break;
            case MyMarginGravity_Vert_Fill:
            {
                vertArrangeGravity = MyMarginGravity_Vert_Top;
                [self.flowLayout.subviews makeObjectsPerformSelector:@selector(sizeToFit)];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (horzArrangeGravity) {
            case MyMarginGravity_None:
            case MyMarginGravity_Horz_Left:
                horzArrangeGravity = MyMarginGravity_Horz_Center;
                break;
            case MyMarginGravity_Horz_Center:
                horzArrangeGravity = MyMarginGravity_Horz_Right;
                break;
            case MyMarginGravity_Horz_Right:
                horzArrangeGravity = MyMarginGravity_Horz_Fill;
                break;
            case MyMarginGravity_Horz_Fill:
            {
                horzArrangeGravity = MyMarginGravity_Horz_Left;
                [self.flowLayout.subviews makeObjectsPerformSelector:@selector(sizeToFit)];
            }
                break;
            default:
                break;
        }
    }
    
    self.flowLayout.arrangedGravity = vertArrangeGravity | horzArrangeGravity;
    [self.flowLayout layoutAnimationWithDuration:0.4];
    

    
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

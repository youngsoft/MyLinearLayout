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

@property(nonatomic, weak) UILabel *flowLayoutSetLabel;
@property(nonatomic, weak) MyFlowLayout *flowLayout;

@end

@implementation FLLTest1ViewController

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    
    /*
        这个例子用来介绍流式布局的特性，流式布局中的子视图总是按一定的规则一次排列，当数量到达一定程度或者内容到达一定程度时就会自动换行从新排列。
     */
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.gravity = MyGravity_Horz_Fill; //里面所有子视图的宽度都填充为和父视图一样宽。
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    //添加操作按钮。
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:2];
    actionLayout.wrapContentHeight = YES;
    actionLayout.gravity = MyGravity_Horz_Fill;  //所有子视图水平填充，也就是所有子视图的宽度相等。
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    actionLayout.subviewHSpace = 5;
    actionLayout.subviewVSpace = 5;
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
    
    UILabel *flowLayoutSetLabel = [UILabel new];
    flowLayoutSetLabel.font = [CFTool font:13];
    flowLayoutSetLabel.textColor = [UIColor redColor];
    flowLayoutSetLabel.adjustsFontSizeToFitWidth = YES;
    flowLayoutSetLabel.wrapContentHeight = YES;
    flowLayoutSetLabel.numberOfLines = 5;
    [rootLayout addSubview:flowLayoutSetLabel];
    self.flowLayoutSetLabel = flowLayoutSetLabel;
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.weight = 1;   //占用剩余高度。
    scrollView.myTop = 10;
    [rootLayout addSubview:scrollView];
    
    
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    flowLayout.backgroundColor = [CFTool color:0];
    flowLayout.frame = CGRectMake(0, 0, 800, 800);
    flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.subviewVSpace = 5;
    flowLayout.subviewHSpace = 5;
    [scrollView addSubview:flowLayout];
    self.flowLayout = flowLayout;
    
    NSArray *imageArray = @[@"minions1",@"minions2",@"minions3",@"minions4",@"head1"];
    for (int i = 0; i < 30; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[random()%5]]];
        [imageView sizeToFit];
        imageView.layer.borderColor = [CFTool color:5].CGColor;
        imageView.layer.borderWidth = 0.5;
        [self.flowLayout addSubview:imageView];
    }
    
    
    [self flowlayoutInfo];

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
    button.myHeight = 30;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5;
    
    return button;
    
}


#pragma mark -- Handle Method

-(void)handleAdjustOrientation:(id)sender
{
    //调整方向
    if (self.flowLayout.orientation == MyOrientation_Vert)
        self.flowLayout.orientation = MyOrientation_Horz;
    else
        self.flowLayout.orientation = MyOrientation_Vert;
    
    [self.flowLayout layoutAnimationWithDuration:0.4];
    [self flowlayoutInfo];

    
}

-(void)handleAdjustArrangedCount:(id)sender
{
    //调整数量
    self.flowLayout.arrangedCount = (self.flowLayout.arrangedCount + 1) % 6;
    
    [self.flowLayout layoutAnimationWithDuration:0.4];
    [self flowlayoutInfo];

    
}

-(void)handleAdjustVertGravity:(id)sender
{
    //调整整体垂直方向的停靠
    
    MyGravity vertGravity = self.flowLayout.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = self.flowLayout.gravity & MyGravity_Vert_Mask;
    
    switch (vertGravity) {
        case MyGravity_None:
        case MyGravity_Vert_Top:
            vertGravity = MyGravity_Vert_Center;
            break;
        case MyGravity_Vert_Center:
            vertGravity = MyGravity_Vert_Bottom;
            break;
        case MyGravity_Vert_Bottom:
            vertGravity = MyGravity_Vert_Between;
            break;
        case MyGravity_Vert_Between:
            vertGravity = MyGravity_Vert_Fill;
            break;
        case MyGravity_Vert_Fill:
        {
            vertGravity = MyGravity_Vert_Top;
            [self.flowLayout.subviews makeObjectsPerformSelector:@selector(sizeToFit)];
        }
        default:
            break;
    }
    
    self.flowLayout.gravity = horzGravity | vertGravity;
    [self.flowLayout layoutAnimationWithDuration:0.4];
    [self flowlayoutInfo];


 }

-(void)handleAdjustHorzGravity:(id)sender
{
    //调整整体水平方向的停靠。
    
    MyGravity vertGravity = self.flowLayout.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = self.flowLayout.gravity & MyGravity_Vert_Mask;
    
    switch (horzGravity) {
        case MyGravity_None:
        case MyGravity_Horz_Left:
            horzGravity = MyGravity_Horz_Center;
            break;
        case MyGravity_Horz_Center:
            horzGravity = MyGravity_Horz_Right;
            break;
        case MyGravity_Horz_Right:
            horzGravity = MyGravity_Horz_Between;
            break;
        case MyGravity_Horz_Between:
            horzGravity = MyGravity_Horz_Fill;
            break;
        case MyGravity_Horz_Fill:
        {
            horzGravity = MyGravity_Horz_Left;
            [self.flowLayout.subviews makeObjectsPerformSelector:@selector(sizeToFit)];
        }
        default:
            break;
    }
    
    self.flowLayout.gravity = horzGravity | vertGravity;
    [self.flowLayout layoutAnimationWithDuration:0.4];
    [self flowlayoutInfo];

}


-(void)handleAdjustArrangeGravity:(id)sender
{
    //调整行内的对齐方式。
    MyGravity vertArrangeGravity = self.flowLayout.arrangedGravity & MyGravity_Horz_Mask;
    MyGravity horzArrangeGravity = self.flowLayout.arrangedGravity & MyGravity_Vert_Mask;

    if (self.flowLayout.orientation == MyOrientation_Vert)
    {
        
        switch (vertArrangeGravity) {
            case MyGravity_None:
            case MyGravity_Vert_Top:
                vertArrangeGravity = MyGravity_Vert_Center;
                break;
            case MyGravity_Vert_Center:
                vertArrangeGravity = MyGravity_Vert_Bottom;
                break;
            case MyGravity_Vert_Bottom:
                vertArrangeGravity = MyGravity_Vert_Fill;
                break;
            case MyGravity_Vert_Fill:
            {
                vertArrangeGravity = MyGravity_Vert_Top;
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
            case MyGravity_None:
            case MyGravity_Horz_Left:
                horzArrangeGravity = MyGravity_Horz_Center;
                break;
            case MyGravity_Horz_Center:
                horzArrangeGravity = MyGravity_Horz_Right;
                break;
            case MyGravity_Horz_Right:
                horzArrangeGravity = MyGravity_Horz_Fill;
                break;
            case MyGravity_Horz_Fill:
            {
                horzArrangeGravity = MyGravity_Horz_Left;
                [self.flowLayout.subviews makeObjectsPerformSelector:@selector(sizeToFit)];
            }
                break;
            default:
                break;
        }
    }
    
    self.flowLayout.arrangedGravity = vertArrangeGravity | horzArrangeGravity;
    [self.flowLayout layoutAnimationWithDuration:0.4];
    [self flowlayoutInfo];

    
}

-(void)handleAdjustMargin:(id)sender
{
    //调整所有子视图的水平和垂直间距。
    if (self.flowLayout.subviewHSpace == 0)
        self.flowLayout.subviewHSpace = 5;
    else
        self.flowLayout.subviewHSpace = 0;
    
    if (self.flowLayout.subviewVSpace == 0)
        self.flowLayout.subviewVSpace = 5;
    else
        self.flowLayout.subviewVSpace = 0;
    
    [self.flowLayout layoutAnimationWithDuration:0.4];
    [self flowlayoutInfo];
}

#pragma mark -- Private Method

-(void)flowlayoutInfo
{
    NSString *orientationStr = @"";
    if (self.flowLayout.orientation == MyOrientation_Vert)
        orientationStr = @"MyOrientation_Vert";
    else
        orientationStr = @"MyOrientation_Horz";
    
    NSString *arrangeCountStr = [NSString stringWithFormat:@"%ld", (long)self.flowLayout.arrangedCount];
    
    NSString *gravityStr = [self gravityInfo:self.flowLayout.gravity];
    
    NSString *arrangedGravityStr = [self gravityInfo:self.flowLayout.arrangedGravity];
    
    NSString *subviewSpaceStr = [NSString stringWithFormat:@"vert:%.0f,horz:%.0f",self.flowLayout.subviewVSpace, self.flowLayout.subviewHSpace];
    
    
    self.flowLayoutSetLabel.text = [NSString stringWithFormat:@"flowLayout:\norientation=%@, arrangedCount=%@\ngravity=%@\narrangedGravity=%@\nsubviewSpace=(%@)",orientationStr,arrangeCountStr,gravityStr,arrangedGravityStr,subviewSpaceStr];
}

-(NSString*)gravityInfo:(MyGravity)gravity
{
    //分别取出垂直和水平方向的停靠设置。
    MyGravity vertGravity = gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = gravity & MyGravity_Vert_Mask;
    
    NSString *vertGravityStr = @"";
    switch (vertGravity) {
        case MyGravity_Vert_Top:
            vertGravityStr = @"MyGravity_Vert_Top";
            break;
        case MyGravity_Vert_Center:
            vertGravityStr = @"MyGravity_Vert_Center";
            break;
        case MyGravity_Vert_Bottom:
            vertGravityStr = @"MyGravity_Vert_Bottom";
            break;
        case MyGravity_Vert_Fill:
            vertGravityStr = @"MyGravity_Vert_Fill";
            break;
        case MyGravity_Vert_Between:
            vertGravityStr = @"MyGravity_Vert_Between";
            break;
        case MyGravity_Vert_Window_Center:
            vertGravityStr = @"MyGravity_Vert_Window_Center";
            break;
        default:
            vertGravityStr = @"MyGravity_Vert_Top";
            break;
    }
    
    NSString *horzGravityStr = @"";
    switch (horzGravity) {
        case MyGravity_Horz_Left:
            horzGravityStr = @"MyGravity_Horz_Left";
            break;
        case MyGravity_Horz_Center:
            horzGravityStr = @"MyGravity_Horz_Center";
            break;
        case MyGravity_Horz_Right:
            horzGravityStr = @"MyGravity_Horz_Right";
            break;
        case MyGravity_Horz_Fill:
            horzGravityStr = @"MyGravity_Horz_Fill";
            break;
        case MyGravity_Horz_Between:
            horzGravityStr = @"MyGravity_Horz_Between";
            break;
        case MyGravity_Horz_Window_Center:
            horzGravityStr = @"MyGravity_Horz_Window_Center";
            break;
        default:
            horzGravityStr = @"MyGravity_Horz_Left";
            break;
    }
    
    
    return [NSString stringWithFormat:@"%@ | %@",vertGravityStr, horzGravityStr];
    
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

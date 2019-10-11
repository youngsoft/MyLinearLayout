//
//  FLXTest1ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "FLXTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLXTest1ViewController ()

-(UIButton*)createActionButton:(NSString*)title action:(SEL)action;


@end

@implementation FLXTest1ViewController

//创建动作操作按钮。
-(UIButton*)createActionButton:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [CFTool font:14];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5;
    
    return button;
    
}


-(void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];

    MyFlexLayout *rootLayout = MyFlexLayout.new.flex
    .flex_direction(MyFlex.column)
    .flex_wrap(MyFlex.nowrap)
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.fill)
    .addTo(self.view);
    
    
    
    
    MyFlexLayout *actionLayout = MyFlexLayout.new.flex
    .flex_direction(MyFlex.row)
    .flex_wrap(MyFlex.wrap)
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .addTo(rootLayout);
    
   
    
    
    
    [self createActionButton:NSLocalizedString(@"flex-direction", @"") action:@selector(handleFlex_Direction:)].flexItem
    .width(1/3.0)
    .height(30)
    .addTo(actionLayout);
    [self createActionButton:NSLocalizedString(@"flex-wrap", @"") action:@selector(handleFlex_Wrap:)].flexItem
    .width(1/3.0)
    .height(30)
    .addTo(actionLayout);
    
    [self createActionButton:NSLocalizedString(@"justify-content", @"") action:@selector(handleJustify_Content:)].flexItem
    .width(1/3.0)
    .height(30)
    .addTo(actionLayout);
    
    
    [self createActionButton:NSLocalizedString(@"align-items", @"") action:@selector(handleAlign_Items:)].flexItem
    .width(1/3.0)
    .height(30)
    .addTo(actionLayout);
    
    [self createActionButton:NSLocalizedString(@"align-content", @"") action:@selector(handleAlign_Content:)].flexItem
    .width(1/3.0)
    .height(30)
    .addTo(actionLayout);
    
    
    MyFlexLayout *contentLayout = MyFlexLayout.new.flex
    .vert_space(10)
    .horz_space(10)
    .flex_wrap(MyFlex.wrap)
    .width(MyLayoutSize.fill)
    .flex_grow(1)
    .addTo(rootLayout);
    
    
    for (int i = 0; i < 6; i++)
    {
        UILabel *label = UILabel.new.flexItem
        .width(100)
        .height(100)
        .addTo(contentLayout);
        
        label.backgroundColor = [UIColor redColor];
        
    }
    
    
    
    
    
//
//    //添加容器。
//    MyFlexLayout *contentLayout = MyFlexLayout.new.flex
//    .width(MyLayoutSize.fill)
//    .height(MyLayoutSize.)
//    
//    
    
   
//
//    //添加操作按钮。
//    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:2];
//    actionLayout.wrapContentHeight = YES;
//    actionLayout.gravity = MyGravity_Horz_Fill;  //所有子视图水平填充，也就是所有子视图的宽度相等。
//    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
//    actionLayout.subviewHSpace = 5;
//    actionLayout.subviewVSpace = 5;
//    [rootLayout addSubview:actionLayout];
//
//    [actionLayout addSubview:
//                                               ];
//    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust arrangedCount", @"")
//                                               action:@selector(handleAdjustArrangedCount:)]];
//    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust vert gravity", @"")
//                                               action:@selector(handleAdjustVertGravity:)]];
//    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust horz gravity", @"")
//                                               action:@selector(handleAdjustHorzGravity:)]];
//    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust align", @"")
//                                               action:@selector(handleAdjustArrangeGravity:)]];
//    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"adjust spacing", @"")
//                                               action:@selector(handleAdjustMargin:)]];
//
//    UILabel *flowLayoutSetLabel = [UILabel new];
//    flowLayoutSetLabel.font = [CFTool font:13];
//    flowLayoutSetLabel.textColor = [UIColor redColor];
//    flowLayoutSetLabel.adjustsFontSizeToFitWidth = YES;
//    flowLayoutSetLabel.wrapContentHeight = YES;
//    flowLayoutSetLabel.numberOfLines = 5;
//    [rootLayout addSubview:flowLayoutSetLabel];
//    self.flowLayoutSetLabel = flowLayoutSetLabel;
//
//    UIScrollView *scrollView = [UIScrollView new];
//    scrollView.alwaysBounceHorizontal = YES;
//    scrollView.alwaysBounceVertical = YES;
//    scrollView.weight = 1;   //占用剩余高度。
//    scrollView.myTop = 10;
//    [rootLayout addSubview:scrollView];
//
//
//    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
//    flowLayout.backgroundColor = [CFTool color:0];
//    flowLayout.frame = CGRectMake(0, 0, 800, 800);
//    flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
//    flowLayout.subviewVSpace = 5;
//    flowLayout.subviewHSpace = 5;
//    [scrollView addSubview:flowLayout];
//    self.flowLayout = flowLayout;
//
//    NSArray *imageArray = @[@"minions1",@"minions2",@"minions3",@"minions4",@"head1"];
//    for (int i = 0; i < 30; i++)
//    {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[random()%5]]];
//        [imageView sizeToFit];
//        imageView.layer.borderColor = [CFTool color:5].CGColor;
//        imageView.layer.borderWidth = 0.5;
//        [self.flowLayout addSubview:imageView];
//    }
//
//
//    [self flowlayoutInfo];
//
//
//
//
//    MyFlexLayout *layout = MyFlexLayout.new.flex
//    .flex_wrap(MyFlex.wrap)
//    .justify_content(MyFlex.space_between)
//    .flex_direction(MyFlex.row)
//    .align_items(MyFlex.center)
//    .align_content(MyFlex.stretch)
//    .padding(UIEdgeInsetsMake(10, 10, 10, 10))
//    .vert_space(10)
//    .horz_space(10)
//    .margin_left(0)
//    .margin_right(0)
//    .margin_top(0)
//    .margin_bottom(0)
//    .addTo(self.view);
//
//    for (int i = 0; i < 2; i++)
//    {
//        UILabel *label = UILabel.new.flexItem
//        .width(600)
//        .height(200)
//        .order(2-i)
//        .align_self(MyFlex.flex_start)
//        .flex_grow(1)
//        .flex_shrink(1)
//        .flex_basis(100)
//        .addTo(layout);
//
//        label.text = [NSString stringWithFormat:@"%d",i];
//        label.backgroundColor = UIColor.redColor;
//    }
//
    
}

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark -- Handle Method

-(void)handleFlex_Direction:(id)sender
{
   
    
    
}

-(void)handleFlex_Wrap:(id)sender
{
   
    
}

-(void)handleJustify_Content:(id)sender
{
   
    
}

-(void)handleAlign_Items:(id)sender
{
  
}


-(void)handleAlign_Content:(id)sender
{

}


@end

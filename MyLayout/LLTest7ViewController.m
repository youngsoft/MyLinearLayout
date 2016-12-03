//
//  Test10ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest7ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface LLTest7ViewController ()

@property(nonatomic, strong) MyLinearLayout *testLayout;

@end

@implementation LLTest7ViewController

-(UIView*)createView:(UIColor*)color
{
    UIView *v = [UIView new];
    v.backgroundColor = color;
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [CFTool color:4].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;
    return v;
}

-(void)loadView
{
    /*
       这个例子用来介绍线性布局提供的均分尺寸和均分间距的功能。这可以通过线性布局里面的averageSubviews和averageMargin方法来实现。
       需要注意的是这两个方法只能对当前已经加入了线性布局中的子视图有效。对后续再加入的子视图不会进行均分。因此要想后续加入的子视图也均分就需要再次调用者两个方法。
     */
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.gravity = MyMarginGravity_Horz_Fill;  //设置里面所有子视图的宽度填充布局视图的宽度。
    rootLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    rootLayout.wrapContentHeight = NO;
    rootLayout.wrapContentWidth = NO;
    self.view = rootLayout;
    
    //创建动作布局
    MyLinearLayout *action1Layout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    action1Layout.wrapContentHeight = YES;
    [rootLayout addSubview:action1Layout];
    
    [action1Layout addSubview:[self createActionButton:NSLocalizedString(@"average size&space no centered", @"") tag:100]];
    [action1Layout addSubview:[self createActionButton:NSLocalizedString(@"average size&space centered", @"") tag:200]];
    [action1Layout addSubview:[self createActionButton:NSLocalizedString(@"average size no centered",@"") tag:300]];
    [action1Layout averageSubviews:NO withMargin:5];  //均分action1Layout中的所有子视图的宽度

    //创建动作布局
    MyLinearLayout *action2Layout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    action2Layout.wrapContentHeight = YES;
    action2Layout.myTopMargin = 5;
    [rootLayout addSubview:action2Layout];
    
    [action2Layout addSubview:[self createActionButton:NSLocalizedString(@"average size centered",@"") tag:400]];
    [action2Layout addSubview:[self createActionButton:NSLocalizedString(@"average space no centered",@"") tag:500]];
    [action2Layout addSubview:[self createActionButton:NSLocalizedString(@"average space centered",@"") tag:600]];
    [action2Layout averageSubviews:NO withMargin:5]; //均分action1Layout中的所有子视图的宽度
   
    //创建供动作测试的布局。
    self.testLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    self.testLayout.backgroundColor = [CFTool color:0];
    self.testLayout.gravity = MyMarginGravity_Horz_Fill;  //所有子视图水平宽度充满布局，这样就不需要分别设置每个子视图的宽度了。
    self.testLayout.wrapContentHeight = NO;
    self.testLayout.weight = 1.0;
    self.testLayout.leftPadding = 10;
    self.testLayout.rightPadding = 10;
    self.testLayout.myTopMargin = 5;
    [rootLayout addSubview:self.testLayout];
    
    UIView *v1 = [self createView:[CFTool color:5]];
    v1.myHeight = 100;
    [self.testLayout addSubview:v1];
   
    UIView *v2 = [self createView:[CFTool color:6]];
    v2.myHeight = 50;
    [self.testLayout addSubview:v2];

    UIView *v3 = [self createView:[CFTool color:7]];
    v3.myHeight = 70;
    [self.testLayout addSubview:v3];
    
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

-(UIButton*)createActionButton:(NSString*)title tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [CFTool font:14];
    [button sizeToFit];
    button.heightDime.equalTo(button.heightDime).add(20);  //高度等于内容的高度再加20
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5;
    button.layer.cornerRadius = 4;
    
    
    
    return button;
}


#pragma mark -- Handle Method

-(void)handleAction:(UIButton*)sender
{
    //恢复原来的设置。
   NSArray *arr = self.testLayout.subviews;
    
    UIView *v1 = arr[0];
    UIView *v2 = arr[1];
    UIView *v3 = arr[2];
    
    [v1 resetMyLayoutSetting];
    [v2 resetMyLayoutSetting];
    [v3 resetMyLayoutSetting];
    
    v1.myHeight = 100;
    v2.myHeight = 50;
    v3.myHeight = 70;
    
    
    
    switch (sender.tag) {
        case 100:
            [self.testLayout averageSubviews:NO];  //均分所有子视图尺寸和间距不留最外面边距
            break;
        case 200:
            [self.testLayout averageSubviews:YES];  //均分所有子视图的尺寸和间距保留最外边距
            break;
        case 300:
            [self.testLayout averageSubviews:NO withMargin:40]; //均分所有子视图尺寸，固定边距，不保留最外边距
            break;
        case 400:
            [self.testLayout averageSubviews:YES withMargin:40];  //均分所有子视图尺寸，固定边距，保留最外边距
            break;
        case 500:
            [self.testLayout averageMargin:NO];   //均分所有边距，子视图尺寸不变，不保留最外边距
            break;
        case 600:
            [self.testLayout averageMargin:YES];  //均分所有边距，子视图尺寸不变，保留最外边距。
            break;
        default:
            break;
    }
    
    //变化后产生动画效果。
    [self.testLayout layoutAnimationWithDuration:0.2];
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

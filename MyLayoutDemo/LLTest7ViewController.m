//
//  LLTest7ViewController.m
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

-(UIView*)createView:(UIColor*)color title:(NSString*)title
{
    UILabel *v = [UILabel new];
    v.backgroundColor = color;
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [CFTool color:4].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;
    v.text = title;
    v.textAlignment = NSTextAlignmentCenter;
    return v;
}

-(void)loadView
{
    /*
       这个例子用来介绍线性布局提供的均分尺寸和均分间距的功能。这可以通过线性布局里面的equalizeSubviews和equalizeSubviewsSpace方法来实现。
       需要注意的是这两个方法只能对当前已经加入了线性布局中的子视图有效。对后续再加入的子视图不会进行均分。因此要想后续加入的子视图也均分就需要再次调用者两个方法。
     */
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.gravity = MyGravity_Horz_Fill;  //设置里面所有子视图的宽度填充布局视图的宽度。
    rootLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    rootLayout.wrapContentHeight = NO;
    rootLayout.wrapContentWidth = NO;
    rootLayout.subviewVSpace = 5;
    self.view = rootLayout;
    
    //创建动作布局
    MyLinearLayout *action1Layout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    action1Layout.wrapContentHeight = YES;
    action1Layout.topPos.equalTo(self.topLayoutGuide);
    [rootLayout addSubview:action1Layout];
    
    [action1Layout addSubview:[self createActionButton:NSLocalizedString(@"average size&space no centered", @"") tag:100]];
    [action1Layout addSubview:[self createActionButton:NSLocalizedString(@"average size&space centered", @"") tag:200]];
    [action1Layout addSubview:[self createActionButton:NSLocalizedString(@"average size no centered",@"") tag:300]];
    [action1Layout equalizeSubviews:NO withSpace:5];  //均分action1Layout中的所有子视图的宽度

    //创建动作布局
    MyLinearLayout *action2Layout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    action2Layout.wrapContentHeight = YES;
    [rootLayout addSubview:action2Layout];
    
    [action2Layout addSubview:[self createActionButton:NSLocalizedString(@"average size centered",@"") tag:400]];
    [action2Layout addSubview:[self createActionButton:NSLocalizedString(@"average space no centered",@"") tag:500]];
    [action2Layout addSubview:[self createActionButton:NSLocalizedString(@"average space centered",@"") tag:600]];
    [action2Layout equalizeSubviews:NO withSpace:5]; //均分action1Layout中的所有子视图的宽度
   
    //创建供动作测试的布局。
    self.testLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.testLayout.backgroundColor = [CFTool color:0];
    self.testLayout.gravity = MyGravity_Horz_Fill;  //所有子视图水平宽度充满布局，这样就不需要分别设置每个子视图的宽度了。
    self.testLayout.wrapContentHeight = NO;
    self.testLayout.wrapContentWidth = NO;
    self.testLayout.weight = 1.0;
    self.testLayout.leftPadding = 10;
    self.testLayout.rightPadding = 10;
    [rootLayout addSubview:self.testLayout];
    
    //这里用到了sizeclass的支持。您可以切换横竖屏看看效果。默认是垂直布局，横屏时是水平布局,并且垂直填充。
    MyLinearLayout *landscapeSC = [self.testLayout fetchLayoutSizeClass:MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    landscapeSC.orientation = MyOrientation_Horz;
    landscapeSC.gravity = MyGravity_Vert_Fill;
    
    
    UIView *v1 = [self createView:[CFTool color:5] title:@"A"];
    v1.myHeight = 100;
    [v1 fetchLayoutSizeClass:MySizeClass_Landscape].myWidth = 100;
    [self.testLayout addSubview:v1];
   
    UIView *v2 = [self createView:[CFTool color:6] title:@"B"];
    v2.myHeight = 50;
    [v2 fetchLayoutSizeClass:MySizeClass_Landscape].myWidth = 50;
    [self.testLayout addSubview:v2];

    UIView *v3 = [self createView:[CFTool color:7] title:@"C"];
    [v3 fetchLayoutSizeClass:MySizeClass_Landscape].myWidth = 70;
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
    button.heightSize.equalTo(button.heightSize).add(20);  //高度等于内容的高度再加20
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
    
    
    //清除所有横屏模式下的布局约束设置。
    [v1 resetMyLayoutSettingInSizeClass:MySizeClass_Landscape];
    [v2 resetMyLayoutSettingInSizeClass:MySizeClass_Landscape];
    [v3 resetMyLayoutSettingInSizeClass:MySizeClass_Landscape];
    
    [v1 fetchLayoutSizeClass:MySizeClass_Landscape].myWidth = 100;
    [v2 fetchLayoutSizeClass:MySizeClass_Landscape].myWidth = 50;
    [v3 fetchLayoutSizeClass:MySizeClass_Landscape].myWidth = 70;
    
    switch (sender.tag) {
        case 100:
            [self.testLayout equalizeSubviews:NO];  //均分所有子视图尺寸和间距不留最外面间距
            [self.testLayout equalizeSubviews:NO inSizeClass:MySizeClass_Landscape];  //均分所有子视图尺寸和间距不留最外面间距,横屏模式
            break;
        case 200:
            [self.testLayout equalizeSubviews:YES];  //均分所有子视图的尺寸和间距保留最外间距
            [self.testLayout equalizeSubviews:YES inSizeClass:MySizeClass_Landscape];  //均分所有子视图的尺寸和间距保留最外间距,横屏模式
            break;
        case 300:
            [self.testLayout equalizeSubviews:NO withSpace:40]; //均分所有子视图尺寸，固定间距，不保留最外间距
            [self.testLayout equalizeSubviews:NO withSpace:40 inSizeClass:MySizeClass_Landscape]; //均分所有子视图尺寸，固定间距，不保留最外间距,横屏模式
            break;
        case 400:
            [self.testLayout equalizeSubviews:YES withSpace:40];  //均分所有子视图尺寸，固定间距，保留最外间距
            [self.testLayout equalizeSubviews:YES withSpace:40 inSizeClass:MySizeClass_Landscape];  //均分所有子视图尺寸，固定间距，保留最外间距,横屏模式
            break;
        case 500:
            [self.testLayout equalizeSubviewsSpace:NO];   //均分所有间距，子视图尺寸不变，不保留最外间距
            [self.testLayout equalizeSubviewsSpace:NO inSizeClass:MySizeClass_Landscape];   //均分所有间距，子视图尺寸不变，不保留最外间距,横屏模式
            break;
        case 600:
            [self.testLayout equalizeSubviewsSpace:YES];  //均分所有间距，子视图尺寸不变，保留最外间距。
            [self.testLayout equalizeSubviewsSpace:YES inSizeClass:MySizeClass_Landscape];  //均分所有间距，子视图尺寸不变，保留最外间距。横屏模式
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

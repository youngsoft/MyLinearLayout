//
//  LLTest4ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest4ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface LLTest4ViewController ()

@property(nonatomic,strong) MyLinearLayout *rootLayout;

@end

@implementation LLTest4ViewController

-(void)loadView
{
    /*
       这个例子详细说明wrapContentHeight和wrapContentWidth的包裹属性的设置、以及边界线性的设定、以及布局中可局部缩放背景图片的设定方法。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *contentView = [UIView new];
    contentView.backgroundColor = [CFTool color:5];
    [self.view addSubview:contentView];
    contentView.wrapContentWidth = YES;
    contentView.wrapContentHeight = YES;   //如果一个非布局父视图里面有布局子视图，那么这个非布局父视图也是可以设置wrapContentHeight和wrapContentWidth的，他表示的意义是这个非布局父视图的尺寸由里面的布局子视图的尺寸来决定的。这个功能是在1.3.3版本支持的。 还有一个场景是非布局父视图是一个UIScrollView。他是左右滚动的，但是滚动视图的高度是由里面的布局子视图确定的，而宽度则是和窗口保持一致。这样只需要将滚动视图的宽度设置为和屏幕保持一致，高度设置为wrapContentHeight，并且把一个水平线性布局添加到滚动视图即可。
    
    
    self.rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.rootLayout.layer.borderWidth = 1;
    self.rootLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.rootLayout.wrapContentHeight = YES;
    self.rootLayout.wrapContentWidth = YES;  //布局的高度和宽度由子视图决定
    self.rootLayout.myTop = 10;
    self.rootLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.rootLayout.zeroPadding = NO;  //这个属性设置为NO时表示当布局视图的尺寸是wrap也就是由子视图决定时并且在没有任何子视图是不会参与布局视图高度的计算的。您可以在这个DEMO的测试中将所有子视图都删除掉，看看效果，然后注释掉这句代码看看效果。
    self.rootLayout.subviewVSpace = 5;
    [contentView addSubview:self.rootLayout];
    
    [self.rootLayout addSubview:[self addWrapContentLayout]];
    
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

//添加包裹内容布局视图
-(MyLinearLayout*)addWrapContentLayout
{
    
    MyLinearLayout *wrapContentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    wrapContentLayout.wrapContentHeight = YES;
    wrapContentLayout.wrapContentWidth = YES;  //布局的高度和宽度由子视图决定
    wrapContentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    wrapContentLayout.subviewHSpace = 5;

    
    /*
     布局视图的backgroundImage的属性的内部实现是通过设置视图的layer的content属性来实现的。因此如果我们希望实现具有拉升效果的
     背景图片的话。则可以设置布局视图的layer.contentCenter属性。这个属性的意义请参考CALayer方面的介绍。
     */
    wrapContentLayout.backgroundImage = [UIImage imageNamed:@"bk2"];
    wrapContentLayout.layer.contentsCenter = CGRectMake(0.1, 0.1, 0.5, 0.5);
    
    
    /*
     MyLayout中的布局视图可以设置四周的边界线，这可以通过布局视图的leftBorderLine、topBorderLine、bottomBorderLine、rightBorderLine四个属性来实现。
     属性的值是一个MyBorderline对象，这个对象可以设置边界线的颜色、粗细、点划线、缩进功能。在使用布局视图的边界线功能时，请先设置好MyBorderline对象的各属性后再赋值给布局视图的四个属性上。
     */
    MyBorderline *bl = [[MyBorderline alloc] initWithColor:[UIColor redColor]]; //边界线
    bl.headIndent = 10;  //头部缩进10个点
    bl.tailIndent = 30;  //尾部缩进30个点。
    bl.thick = 1;        //粗细为1
    wrapContentLayout.bottomBorderline = bl;
    wrapContentLayout.topBorderline = bl;
    wrapContentLayout.leadingBorderline = bl;
    wrapContentLayout.trailingBorderline = bl;
    
    
    
    MyLinearLayout *actionLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    actionLayout.layer.borderWidth = 1;
    actionLayout.layer.borderColor = [CFTool color:9].CGColor;
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    actionLayout.subviewVSpace = 5;
    actionLayout.wrapContentWidth = YES;
    actionLayout.wrapContentHeight = YES;  //布局的高度和宽度由子视图决定
    [wrapContentLayout addSubview:actionLayout];
    
    
    [actionLayout addSubview:[self addActionButton:NSLocalizedString(@"add vert layout", @"") tag:100]];
    [actionLayout addSubview:[self addActionButton:NSLocalizedString(@"add vert button", @"") tag:500]];
    
    
    [wrapContentLayout addSubview:[self addActionButton:NSLocalizedString(@"add horz button", @"") tag:200]];
    [wrapContentLayout addSubview:[self addActionButton:NSLocalizedString(@"remove layout", @"") tag:300]];
    
    return wrapContentLayout;
}

//添加动作按钮
-(UIButton*)addActionButton:(NSString *)title tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [CFTool font:14];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.backgroundColor = [CFTool color:14];
    button.layer.cornerRadius = 10;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth  = 0.5;
    button.tag = tag;
    button.myHeight = 50;
    button.myWidth = 80;
    
    return button;
}


#pragma mark -- Handle Method

-(void)handleAction:(UIButton*)sender
{
    
    if (sender.tag == 100)
    {
        [self.rootLayout addSubview:[self addWrapContentLayout]];
    }
    else if (sender.tag == 200)
    {
        MyLinearLayout*actionLayout = (MyLinearLayout*)sender.superview;
        [actionLayout addSubview:[self addActionButton:NSLocalizedString(@"remove self", @"") tag:400]];
    }
    else if (sender.tag == 300)
    {
         MyLinearLayout*actionLayout = (MyLinearLayout*)sender.superview;
        [actionLayout removeFromSuperview];
    }
    else if (sender.tag == 400)
    {
        [sender removeFromSuperview];
    }
    else if (sender.tag == 500)
    {
        MyLinearLayout*addLayout = (MyLinearLayout*)sender.superview;
        [addLayout addSubview:[self addActionButton:NSLocalizedString(@"remove self", @"") tag:400]];
    }
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

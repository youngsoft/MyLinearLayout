//
//  AllTest11ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "AllTest12ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface AllTest12ViewController ()


@end

@implementation AllTest12ViewController

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    /*
        这个DEMO演示MyLayout和AutoLayout的代码结合的例子。因为布局视图也是一个普通的视图，因此可以把一个布局视图添加到现有的其他非布局父视图中并且对布局视图设置
        约束。 因为布局视图可以设置尺寸自适应，就如UILabel一样因为具有intrinsicContentSize的能力，因此不需要在约束中明确设置宽度或者高度约束。当一个布局视图
        的高度或者宽度都是由子视图决定的，也就是尺寸设置为自适应时，布局视图也不需要明确的设置宽度或者高度的约束。而且其他视图还可以依赖这种布局视图尺寸的自包含的能力。
     
         本例子由3个子示例组成。
     
     */
    
    //容器视图包含一个垂直线性布局视图，垂直线性布局视图的尺寸由2个子视图决定，容器视图的尺寸由线性布局视图决定
    [self demo1];
    //一个线性布局视图的宽度为某个具体的约束值，高度由子视图决定。另外一个兄弟视图在线性布局视图的下面，一个兄弟视图在线性布局的右边。
    [self demo2];
    //一个水平线性布局的高度固定，宽度自适应，另外一个兄弟视图在水平线性布局视图的右边。
    [self demo3];
    

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

-(void)demo1
{
    //容器视图包含一个垂直线性布局视图，垂直线性布局视图的尺寸由2个子视图决定，容器视图的尺寸由线性布局视图决定
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor greenColor];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:containerView];
    
    
    MyLinearLayout *linelayout = [MyLinearLayout new];
    linelayout.translatesAutoresizingMaskIntoConstraints = NO;
    linelayout.backgroundColor = [UIColor redColor];
    [containerView addSubview:linelayout];
    
    
    UIView *sbv1 = [UIView new];
    sbv1.backgroundColor = [UIColor blueColor];
    [linelayout addSubview:sbv1];
    UIView *sbv2 = [UIView new];
    sbv2.backgroundColor = [UIColor blueColor];
    [linelayout addSubview:sbv2];

    
    
    //MyLayout中的约束设置方法
    linelayout.orientation = MyOrientation_Vert;
    linelayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    linelayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    linelayout.subviewSpace = 10;

    sbv1.mySize = CGSizeMake(100, 40);
    sbv2.mySize = CGSizeMake(150, 50);

    

    //AutoLayout中的约束设置方法，采用iOS9提供的约束设置方法。
    [containerView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    //父视图约束依赖子视图约束会产生父视图的尺寸由子视图进行自适应的效果。
    [containerView.bottomAnchor constraintEqualToAnchor:linelayout.bottomAnchor constant:10].active = YES;
    [containerView.rightAnchor constraintEqualToAnchor:linelayout.rightAnchor constant:10].active = YES;
    
    //线性布局视图的宽度和高度自适应，所以不需要设置任何高度和宽度的约束。
    [linelayout.leftAnchor constraintEqualToAnchor:containerView.leftAnchor constant:10].active = YES;
    [linelayout.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:10].active = YES;
    
}

-(void)demo2
{
    //一个线性布局视图的宽度为某个具体的约束值，高度由子视图决定。另外一个兄弟视图在线性布局视图的下面，一个兄弟视图在线性布局的右边。
   
    MyLinearLayout *linelayout = [MyLinearLayout new];
    linelayout.translatesAutoresizingMaskIntoConstraints = NO;
    linelayout.backgroundColor = [UIColor redColor];
    [self.view addSubview:linelayout];
    
    
    UIView *sbv1 = [UIView new];
    sbv1.backgroundColor = [UIColor blueColor];
    [linelayout addSubview:sbv1];
    UIView *sbv2 = [UIView new];
    sbv2.backgroundColor = [UIColor blueColor];
    [linelayout addSubview:sbv2];

    
    UIView *brotherView1 = [UIView new];
    brotherView1.translatesAutoresizingMaskIntoConstraints = NO;
    brotherView1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:brotherView1];
    
    UIView *brotherView2 = [UIView new];
    brotherView2.translatesAutoresizingMaskIntoConstraints = NO;
    brotherView2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:brotherView2];
    
    
    //MyLayout中的约束设置
    linelayout.orientation = MyOrientation_Vert;
    linelayout.myHeight = MyLayoutSize.wrap;
    linelayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    linelayout.subviewSpace = 10;
    
    sbv1.mySize = CGSizeMake(100, 40);
    sbv2.mySize = CGSizeMake(150, 50);
    
    
    //AutoLayout中的约束设置
    //线性布局因为高度是自适应的所以不需要设置高度约束。
    [linelayout.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;
    [linelayout.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:180].active = YES;
    //当布局视图的高度由子视图自适应且宽度为autolayout约束时，目前只支持对布局视图设置明确宽度约束才有效。
    //同时设置左右边界约束来推导布局视图宽度，并且高度又自适应目前不支持。
    [linelayout.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-150].active = YES;

    [brotherView1.leftAnchor constraintEqualToAnchor:linelayout.leftAnchor].active = YES;
    [brotherView1.topAnchor constraintEqualToAnchor:linelayout.bottomAnchor constant:10].active = YES;
    [brotherView1.widthAnchor constraintEqualToAnchor:linelayout.widthAnchor].active = YES;
    [brotherView1.heightAnchor constraintEqualToAnchor:linelayout.heightAnchor].active = YES;
    
    
    [brotherView2.leftAnchor constraintEqualToAnchor:linelayout.rightAnchor constant:10].active = YES;
    [brotherView2.topAnchor constraintEqualToAnchor:linelayout.topAnchor].active = YES;
    [brotherView2.widthAnchor constraintEqualToConstant:50].active = YES;
    [brotherView2.heightAnchor constraintEqualToAnchor:linelayout.heightAnchor].active = YES;
    
}

-(void)demo3
{
    MyLinearLayout *linelayout = [MyLinearLayout new];
    linelayout.translatesAutoresizingMaskIntoConstraints = NO;
    linelayout.backgroundColor = [UIColor redColor];
    [self.view addSubview:linelayout];
    
    
    UIView *sbv1 = [UIView new];
    sbv1.backgroundColor = [UIColor blueColor];
    [linelayout addSubview:sbv1];
    UIView *sbv2 = [UIView new];
    sbv2.backgroundColor = [UIColor blueColor];
    [linelayout addSubview:sbv2];
    
    
    UIView *brotherView1 = [UIView new];
    brotherView1.translatesAutoresizingMaskIntoConstraints = NO;
    brotherView1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:brotherView1];
    
    
    //MyLayout中的约束设置
    linelayout.orientation = MyOrientation_Horz;
    linelayout.myWidth = MyLayoutSize.wrap;
    linelayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    linelayout.subviewSpace = 10;
    linelayout.gravity = MyGravity_Vert_Fill;
    
    
    sbv1.myWidth = 50;
    sbv2.myWidth = 60;
    
    
    //AutoLayout中的约束设置
    [linelayout.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;
    [linelayout.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:500].active = YES;
    [linelayout.heightAnchor constraintEqualToConstant:60].active = YES;

    [brotherView1.leftAnchor constraintEqualToAnchor:linelayout.rightAnchor constant:10].active = YES;
    [brotherView1.topAnchor constraintEqualToAnchor:linelayout.topAnchor].active = YES;
    [brotherView1.widthAnchor constraintEqualToAnchor:linelayout.widthAnchor].active = YES;
    [brotherView1.heightAnchor constraintEqualToAnchor:linelayout.heightAnchor].active = YES;
    
        
}


@end

//
//  Test12ViewController.m
//  MyLayout
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "AllTest3ViewController.h"
#import "MyLayout.h"

@interface AllTest3ViewController ()

@property(nonatomic,strong) MyLinearLayout *pushLayout;

@end

@implementation AllTest3ViewController


-(MyLinearLayout*)createActionLayout:(NSString*)title action:(SEL)action
{
    MyLinearLayout *actionLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    actionLayout.backgroundColor = [UIColor whiteColor];
    [actionLayout setTarget:self action:action];    //这里设置布局的触摸事件处理。
    
    //左右边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
    actionLayout.leftPadding = 10;
    actionLayout.rightPadding = 10;
    actionLayout.wrapContentWidth = NO;
    actionLayout.heightDime.equalTo(@50);
    actionLayout.gravity = MyMarginGravity_Vert_Center;
    
    
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.rightPos.equalTo(@0.5);
    [actionLayout addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
    [imageView sizeToFit];
    imageView.leftPos.equalTo(@0.5);
    [actionLayout addSubview:imageView];
    
    return actionLayout;
    
}


-(MyLinearLayout*)createSwitchLayout:(NSString*)title action:(SEL)action
{
    MyLinearLayout *switchLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    switchLayout.backgroundColor = [UIColor whiteColor];
    
    //左右边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
    switchLayout.leftPadding = 10;
    switchLayout.rightPadding = 10;
    switchLayout.wrapContentWidth = NO;
    switchLayout.heightDime.equalTo(@50);
    switchLayout.gravity = MyMarginGravity_Vert_Center;
    
    
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.rightPos.equalTo(@0.5);
    [switchLayout addSubview:label];
    
    
    
    UISwitch *switchCtrl = [UISwitch new];
    [switchCtrl addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    switchCtrl.leftPos.equalTo(@0.5);
    [switchLayout addSubview:switchCtrl];
    
    return switchLayout;
}

-(void)handleTap:(MyBaseLayout*)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"test" message:@"执行单击测试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [av show];

}

-(void)handleSwitch:(UISwitch*)sender
{
    self.pushLayout.hidden = !self.pushLayout.isHidden;
    
}



-(void)loadView
{
   
    /*
     在一些应用的关于界面，以及用户个人信息的展示和修改界面我们通常都会用UITableView来实现，这些UITableView的特点是UITableViewCell的数量是固定的
     而且每个UITableViewCell的布局样式可能有很大的不同，而且通常都会有分组的情况。如果我们采用传统的UITableView来实现这些功能，将会有很多的缺陷：
     
     1。你的DataSourceDelegate 的实现如果是数量，cell, 还是选择都会产生一个很大的switch的分支来处理不同的情况，如果有分组则更加复杂
     2。不同的Cell难以实现不同样式的分割线，不同的背景设置。
     3。如果Cell中需要有输入的UITextField时，当改变文本框的值时难以更新其绑定的属性。
     4。因为Cell中有复用机制，所以Cell中的某些子视图的状态也需要单独的进行保存，比如高亮，enable等等。这样将增加程序的复杂性
     5。每个Cell中的内容的高度可能不一样，难以动态计算Cell的高度。
     
     因此综上所述，我们一般不建议这些界面通过UITableView来实现，而是采用UIScrollView加MyLinearLayout来实现，因为MyLinearLayout本身就支持事件的单击触摸和
     背景的设置以及分割线的设置等功能，下面的例子将采用线性布局实现一个关于的界面。
     
     */

    
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.backgroundColor = [UIColor grayColor];
    self.view = frameLayout;
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.marginGravity = MyMarginGravity_Fill;
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    contentLayout.leftPos.equalTo(@0);
    contentLayout.rightPos.equalTo(@0);
    contentLayout.gravity = MyMarginGravity_Horz_Fill;  //让子视图全部水平填充
    contentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [scrollView addSubview:contentLayout];
    
    
    //顶部用户头像信息。
    MyRelativeLayout *headerLayout = [MyRelativeLayout new];
    headerLayout.backgroundImage = [UIImage imageNamed:@"bk1"];  //可以为布局直接设备背景图片。
    headerLayout.wrapContentHeight = YES;
    [contentLayout addSubview:headerLayout];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head2"]];
    [headerImageView sizeToFit];
    headerImageView.centerXPos.equalTo(@0);
    headerImageView.centerYPos.equalTo(@0);
    headerImageView.backgroundColor = [UIColor whiteColor];
    headerImageView.layer.cornerRadius = headerImageView.estimatedRect.size.height / 2;
    [headerLayout addSubview:headerImageView];
    
    UILabel *headerNameLabel = [UILabel new];
    headerNameLabel.text = @"欧阳大哥";
    [headerNameLabel sizeToFit];
    headerNameLabel.centerXPos.equalTo(@0);
    headerNameLabel.topPos.equalTo(headerImageView.bottomPos).offset(10);
    [headerLayout addSubview:headerNameLabel];
    
    
    MyLinearLayout *layout1 = [self createActionLayout:@"请单击这里(没有高亮)" action:@selector(handleTap:)];
    layout1.topBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]];
    layout1.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]];  //设置底部和顶部都有红色的线
    
    layout1.topPos.equalTo(@10);
    [contentLayout addSubview:layout1];
    
    MyLinearLayout *layout2 = [self createActionLayout:@"请单击这里(有高亮颜色)" action:@selector(handleTap:)];
    layout2.highlightedBackgroundColor = [UIColor lightGrayColor]; //可以设置高亮的背景色用于单击事件
    layout2.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]];  //设置底部有红色的线，并且粗细为3
    layout2.bottomBorderLine.thick = 4;
    [contentLayout addSubview:layout2];
    
    MyLinearLayout *layout3 = [self createActionLayout:@"请单击这里(有高亮图片)" action:@selector(handleTap:)];
    layout3.highlightedBackgroundImage = [UIImage imageNamed:@"image2"]; //设置单击时的高亮背景图片。
    
    MyBorderLineDraw *dashLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor greenColor]];
    dashLine.dash = 3;
    layout3.leftBorderLine = dashLine; //设置左右边绿色的虚线
    layout3.rightBorderLine = dashLine;
    [contentLayout addSubview:layout3];
    
    
    //可以设置背景和高亮背景图片的布局。
    MyLinearLayout *layout11 = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    layout11.backgroundImage = [UIImage imageNamed:@"bk2"];
    layout11.highlightedBackgroundImage = [UIImage imageNamed:@"image2"];
    [layout11 setTarget:self action:@selector(handleTap:)];
    layout11.topPos.equalTo(@10);
    layout11.heightDime.equalTo(@50);
    [contentLayout addSubview:layout11];
    
    
    
    MyLinearLayout *layout4 = [self createSwitchLayout:@"推送消息隐藏开关" action:@selector(handleSwitch:)];
    layout4.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]]; //底部边界线设置可以缩进
    layout4.bottomBorderLine.headIndent = 10;
    layout4.bottomBorderLine.tailIndent = 10;
    layout4.topPos.equalTo(@10);
    [contentLayout addSubview:layout4];
    
    MyLinearLayout *layout6 = [self createActionLayout:@"向外缩进的底线布局" action:@selector(handleTap:)];
    layout6.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor greenColor]]; //底部边界线如果为负数则外部缩进
    layout6.bottomBorderLine.headIndent = -10;
    layout6.bottomBorderLine.tailIndent = -10;
    [contentLayout addSubview:layout6];

    
    MyLinearLayout *layout8 = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    layout8.backgroundColor = [UIColor whiteColor];
    layout8.gravity = MyMarginGravity_Horz_Fill;
    layout8.topPos.equalTo(@10);
    [contentLayout addSubview:layout8];
    self.pushLayout = layout8;

    
    MyLinearLayout *layout9 = [self createSwitchLayout:@"推送开关" action:nil];
    [layout8 addSubview:layout9];
    
    UILabel *pushLabel = [UILabel new];
    pushLabel.text = @"推送开关打开后将可以收到推送信息";
    pushLabel.font = [UIFont systemFontOfSize:13];
    pushLabel.adjustsFontSizeToFitWidth = YES;
    pushLabel.leftPos.equalTo(@10);
    pushLabel.rightPos.equalTo(@10);
    pushLabel.bottomPos.equalTo(@5);
    [pushLabel sizeToFit];
    [layout8 addSubview:pushLabel];
    

    //底部添加一个MyFlowLayout
    MyFlowLayout *layout10 = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    layout10.backgroundColor = [UIColor whiteColor];
    layout10.averageArrange = YES;
    layout10.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    layout10.subviewHorzMargin = 10;
    layout10.subviewVertMargin = 10;
    
    layout10.bottomPos.equalTo(@50);
    layout10.topPos.equalTo(@10);
    layout10.wrapContentHeight = YES;
    
    [contentLayout addSubview:layout10];

    
    for (int i = 0 ; i < 10; i++)
    {
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor blueColor];
        label.text = [NSString stringWithFormat:@"%d",i];
        label.textAlignment = NSTextAlignmentCenter;        
        [label sizeToFit];
        [layout10 addSubview:label];
        
    }

    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    imageView2.backgroundColor = [UIColor whiteColor];
    imageView2.frame = CGRectMake(5, 5, 30, 30);
    imageView2.useFrame = YES;   //设置了这个属性后，这个子视图将不会被布局控制，而是直接用frame设置的为准。
    [contentLayout addSubview:imageView2];
    

    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    
    button.myHeight = 50;
    button.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Fill;
    [self.view addSubview:button];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UITableView的替换方案";
    
    
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

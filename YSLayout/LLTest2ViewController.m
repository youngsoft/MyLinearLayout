//
//  Test2ViewController.m
//  YSLayout
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "LLTest2ViewController.h"
#import "YSLayout.h"

@interface LLTest2ViewController ()

@end

@implementation LLTest2ViewController

-(void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    YSLinearLayout *contentLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    
    contentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10); //设置布局内的子视图离自己的边距.
    contentLayout.ysLeftMargin = 0;
    contentLayout.ysRightMargin = 0;  //同时指定左右边距为0表示宽度和父视图一样宽
    [self.view addSubview:contentLayout];

    /*线性布局直接添加子视图*/
    UILabel *numLabel = [UILabel new];
    numLabel.text = @"编号:";
    
    [numLabel sizeToFit];
    numLabel.ysLeftMargin = 5;
    [contentLayout addSubview:numLabel];
    
    
    UITextField *numField = [UITextField new];
    numField.borderStyle = UITextBorderStyleRoundedRect;
    numField.placeholder = @"这里输入编号";
    
    numField.ysTopMargin = 5;
    numField.ysLeftMargin = numField.ysRightMargin = 0;
    numField.ysHeight = 40;
    [contentLayout addSubview:numField];
    
    /*线性布局套线性布局*/
    YSLinearLayout *infoLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Horz];
    infoLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    infoLayout.layer.borderWidth = 0.5;
    infoLayout.layer.cornerRadius = 4;
    
    infoLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    infoLayout.ysTopMargin = 20;
    infoLayout.ysLeftMargin = infoLayout.ysRightMargin = 0;
    infoLayout.wrapContentHeight = YES;
    [contentLayout addSubview:infoLayout];
    
    UIImageView *imageView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    
    [imageView sizeToFit];
    imageView.ysCenterYOffset = 0;
    [infoLayout addSubview:imageView];
    
    YSLinearLayout *nameLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    nameLayout.weight = 1.0;
    nameLayout.ysLeftMargin = 10;
    [infoLayout addSubview:nameLayout];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"姓名：欧阳大哥";
    [nameLabel sizeToFit];
    [nameLayout addSubview:nameLabel];
    
    UILabel *nickLabel = [UILabel new];
    nickLabel.text  = @"昵称：醉里挑灯看键";
    [nickLabel sizeToFit];
    [nameLayout addSubview:nickLabel];
    

    /*垂直线性布局套垂直线性布局*/
    YSLinearLayout *ageLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    ageLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ageLayout.layer.borderWidth = 0.5;
    ageLayout.layer.cornerRadius = 4;
    
    ageLayout.gravity = YSMarginGravity_Horz_Fill;
    ageLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    ageLayout.ysTopMargin = 20;
    ageLayout.ysLeftMargin = ageLayout.ysRightMargin = 0;
    [contentLayout addSubview:ageLayout];
    
    
    UILabel *ageLabel = [UILabel new];
    ageLabel.text = @"年龄:";
    
    [ageLabel sizeToFit];
    [ageLayout addSubview:ageLabel];
    
    /*垂直线性布局套水平线性布局*/
    YSLinearLayout *ageSelectLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Horz];
    
    ageSelectLayout.ysTopMargin = 5;
    ageSelectLayout.wrapContentHeight = YES;
    [ageLayout addSubview:ageSelectLayout];
    
    
    UILabel *age1Label = [UILabel new];
    age1Label.text = @"20";
    age1Label.textAlignment  = NSTextAlignmentCenter;
    age1Label.backgroundColor = [UIColor redColor];
    
    age1Label.ysHeight = 30;
    age1Label.weight = 1.0;
    [ageSelectLayout addSubview:age1Label];
    
    UILabel *age2Label = [UILabel new];
    age2Label.text = @"30";
    age2Label.textAlignment  = NSTextAlignmentCenter;
    age2Label.backgroundColor = [UIColor greenColor];
    
    age2Label.ysHeight = 30;
    age2Label.weight = 1.0;
    age2Label.ysLeftMargin = 10;
    [ageSelectLayout addSubview:age2Label];
    
    
    UILabel *age3Label = [UILabel new];
    age3Label.text = @"40";
    age3Label.textAlignment  = NSTextAlignmentCenter;
    age3Label.backgroundColor = [UIColor blueColor];
    
    age3Label.ysHeight = 30;
    age3Label.weight = 1.0;
    age3Label.ysLeftMargin = 10;
    [ageSelectLayout addSubview:age3Label];
    
    
    /*垂直线性布局套水平线性布局*/
    YSLinearLayout *addressLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Horz];
    addressLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    addressLayout.layer.borderWidth = 0.5;
    addressLayout.layer.cornerRadius = 4;
    
    addressLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    addressLayout.ysTopMargin = 20;
    addressLayout.ysLeftMargin = addressLayout.ysRightMargin = 0;
    addressLayout.wrapContentHeight = YES;
    [contentLayout addSubview:addressLayout];
    
    
    UILabel *addrLabel = [UILabel new];
    addrLabel.text = @"地址：";
    
    [addrLabel sizeToFit];
    [addressLayout addSubview:addrLabel];
    
    
    UILabel *addrText = [UILabel new];
    addrText.text = @"中华人民共和国北京市朝阳区CBD西大望路温特莱中心";
    addrText.numberOfLines = 0;
    
    addrText.ysLeftMargin = 10;
    addrText.weight = 1.0;
    addrText.flexedHeight = YES;
    [addressLayout addSubview:addrText];
    
    
    /*垂直线性布局套水平线性布局，水平线性布局利用相对边距实现左右布局*/
    YSLinearLayout *sexLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Horz];
    sexLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sexLayout.layer.borderWidth = 0.5;
    sexLayout.layer.cornerRadius = 4;
    
    sexLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    sexLayout.ysTopMargin = 20;
    sexLayout.ysLeftMargin = sexLayout.ysRightMargin = 0;
    sexLayout.wrapContentHeight = YES;
    [contentLayout addSubview:sexLayout];
    
    
    UILabel *sexLabel = [UILabel new];
    sexLabel.text = @"性别:";
    
    [sexLabel sizeToFit];
    sexLabel.ysCenterYOffset = 0;
    sexLabel.ysRightMargin = 0.5;  //这里使用的相对间距后续会介绍
    [sexLayout addSubview:sexLabel];
    
    
    UISwitch *sexSwitch = [UISwitch new];
    
    sexSwitch.ysLeftMargin = 0.5; //这里使用的相对间距后续会介绍
    [sexLayout addSubview:sexSwitch];
    
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor redColor];
    label.text = @"这是一段可以隐藏的字符串，点击下面的按钮就可以实现文本的显示和隐藏，同时可以支持根据文字内容动态调整高度，这需要把flexedHeight设置为YES.为了看到滚动以及自动换行的效果你可以尝试着转动屏幕看看结果！！！";
    label.tag = 1234;

    label.ysTopMargin = 20;
    label.ysLeftMargin = label.ysRightMargin = 0;
    label.flexedHeight = YES;  //这个属性会控制在固定宽度下自动调整视图的高度。
    [contentLayout addSubview:label];

    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 addTarget:self action:@selector(handleLabelShow:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"点击按钮显示隐藏文本" forState:UIControlStateNormal];

    btn1.ysCenterXOffset = 0;
    btn1.ysHeight = 60;
    [btn1 sizeToFit];
    [contentLayout addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"点击查看更多》" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(handleShowMore:) forControlEvents:UIControlEventTouchUpInside];

    
    btn2.ysTopMargin = 50;
    btn2.ysRightMargin = 0;
    [btn2 sizeToFit];
    [contentLayout addSubview:btn2];
    
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor greenColor];
    bottomView.tag = 4321;
    bottomView.hidden = YES;

    
    bottomView.ysTopMargin = 20;
    bottomView.ysLeftMargin = bottomView.ysRightMargin = 0;
    bottomView.ysHeight = 800;
    [contentLayout addSubview:bottomView];
    
}

-(void)handleLabelShow:(UIButton*)sender
{
    
    UIView *supv = sender.superview;
    UIView *v = [supv viewWithTag:1234];
    
    if (v.isHidden)
        v.hidden = NO;
    else
        v.hidden = YES;
}

-(void)handleShowMore:(UIButton*)sender
{
    
    UIView *supv = sender.superview;
    UIView *v = [supv viewWithTag:4321];
    
    if (v.isHidden)
    {
        v.hidden = NO;
        [sender setTitle:@"点击收起《" forState:UIControlStateNormal];
        [sender sizeToFit];
    }
    else
    {
        v.hidden = YES;
        [sender setTitle:@"点击查看更多》" forState:UIControlStateNormal];
        [sender sizeToFit];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"线性布局-和UIScrollView的结合";
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

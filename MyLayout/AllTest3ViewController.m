//
//  Test12ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/24.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "AllTest3ViewController.h"
#import "MyLayout.h"

@interface AllTest3ViewController ()

@property(nonatomic, strong) MyFrameLayout *frameLayout;

@property(nonatomic, strong) MyLinearLayout *popmenuLayout;
@property(nonatomic, strong) MyLinearLayout *popmenuContainerLayout;
@property(nonatomic, strong) UIScrollView *popmenuScrollView;
@property(nonatomic, strong) MyFlowLayout *popmenuItemLayout;


//用来测试隐藏子视图时重新布局一些视图
@property(nonatomic, strong) MyBaseLayout *hideSubviewRelayoutLayout;
@property(nonatomic, strong) UIButton *hiddenTestButton;

//浮动文本的布局
@property(nonatomic,strong) MyBaseLayout *flexedLayout;
@property(nonatomic,strong)  UILabel *leftFlexedLabel;
@property(nonatomic, strong) UILabel *rightFlexedLabel;

//伸缩布局
@property(nonatomic,strong) MyBaseLayout *shrinkLayout;

@end

@implementation AllTest3ViewController



-(void)loadView
{
   
    /*
     在一些应用的关于界面，以及用户个人信息的展示和修改界面我们通常都会用UITableView来实现，这些UITableView的特点是UITableViewCell的数量是固定的
     而且每个UITableViewCell的布局样式可能有很大的不同，而且通常都会有分组的情况。如果我们采用传统的UITableView来实现这些功能，将会有很多的缺陷：
     
     1。你的DataSourceDelegate 的实现如果是不同样式的Cell，每个Cell的逻辑不同，这样选择都会产生一个很大的switch的分支来处理不同的情况，如果有分组则更加复杂
     2。不同的Cell难以实现不同样式的分割线，不同的背景设置。
     3。如果Cell中需要有输入的UITextField时，当改变文本框的值时难以更新其绑定的属性。
     4。因为Cell中有复用机制，所以Cell中的某些子视图的状态也需要单独的进行保存，比如高亮，enable等等。这样将增加程序的复杂性
     5。每个Cell中的内容的高度可能不一样，难以动态计算Cell的高度。
     
     因此综上所述，我们一般不建议这些界面通过UITableView来实现，而是采用UIScrollView加MyLinearLayout来实现，因为布局库本身就支持事件的单击触摸和
     背景的设置以及分割线的设置等功能，下面的例子将采用线性布局实现一个关于的界面。
     
     */
    
    //根视图用框架布局的原因是底部有一个退出登录按钮是固定在底部的，因此这里用框架布局来实现整体布局是最好的方法。一般框架布局都是用来实现视图控制器的根本视图。
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.backgroundColor = [UIColor grayColor];
    self.view = frameLayout;
    self.frameLayout = frameLayout;
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.marginGravity = MyMarginGravity_Fill;  //scrollView的尺寸和frameLayout的尺寸一致，因为这里用了填充属性。
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    button.myHeight = 50;
    button.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Fill;  //按钮定位在框架布局的底部并且宽度填充。
    [self.view addSubview:button];

    //整体一个线性布局，实现各种片段。
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    contentLayout.myLeftMargin = contentLayout.myRightMargin = 0;
    contentLayout.gravity = MyMarginGravity_Horz_Fill;  //子视图里面的内容的宽度跟布局视图相等，这样子视图就不需要设置宽度了。
    contentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [scrollView addSubview:contentLayout];
    
    //头部布局。
    [self addHeaderLayout:contentLayout];

    //添加，弹出菜单的布局
    [self addPopmenuLayout:contentLayout];
    
    
     //添加事件处理，以及高亮背景，边界线的布局
    [self addHighlightedBackgroundAndBorderLineLayout:contentLayout];
    
    
    //添加，左右浮动间距，以及宽度最大限制的布局
    [self addFlexedWidthLayout:contentLayout];
    
    //添加，隐藏重新布局的布局。
    [self addHideSubviewReLayoutLayout:contentLayout];
   
    
    
    //添加，自动伸缩布局
    [self addShrinkLayout:contentLayout];
    

    
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

//添加头部布局。里面用的相对布局实现。
-(void)addHeaderLayout:(MyLinearLayout *)contentLayout
{
    MyRelativeLayout *headerLayout = [MyRelativeLayout new];
    headerLayout.backgroundImage = [UIImage imageNamed:@"bk1"];  //可以为布局直接设备背景图片。
    headerLayout.wrapContentHeight = YES;
    [contentLayout addSubview:headerLayout];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head2"]];
    [headerImageView sizeToFit];
    headerImageView.centerXPos.equalTo(@0);
    headerImageView.centerYPos.equalTo(@0);  //在父视图中居中。
    headerImageView.backgroundColor = [UIColor whiteColor];
    headerImageView.layer.cornerRadius = headerImageView.estimatedRect.size.height / 2; //
    [headerLayout addSubview:headerImageView];
    
    UILabel *headerNameLabel = [UILabel new];
    headerNameLabel.text = @"欧阳大哥";
    [headerNameLabel sizeToFit];
    headerNameLabel.centerXPos.equalTo(@0);
    headerNameLabel.topPos.equalTo(headerImageView.bottomPos).offset(10);
    [headerLayout addSubview:headerNameLabel];
    
    
    //将useFrame属性设置为YES后。即使是布局里面的子视图也不会参与自动布局，而是可以通过最原始的设置frame的值来进行位置定位和尺寸的确定。
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    imageView2.backgroundColor = [UIColor whiteColor];
    imageView2.frame = CGRectMake(5, 5, 30, 30);
    imageView2.useFrame = YES;   //设置了这个属性后，这个子视图将不会被布局控制，而是直接用frame设置的为准。
    [contentLayout addSubview:imageView2];
    
}

//添加高亮，以及边界线效果的布局
-(void)addHighlightedBackgroundAndBorderLineLayout:(MyLinearLayout *)contentLayout
{
    //如果您只想要高亮效果而不想处理事件则方法：setTarget中的action为nil即可。
    
    //具有事件处理的layout,以及边界线效果的layout
    MyLinearLayout *layout1 = [self createActionLayout:@"请单击这里(没有高亮)" action:@selector(handleTap:)];
    layout1.myTopMargin = 10;
    layout1.topBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor yellowColor]];
    layout1.topBorderLine.headIndent = -10;
    layout1.topBorderLine.tailIndent = -10; //底部边界线如果为负数则外部缩进
    layout1.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]];  //设置底部和顶部都有红色的线
    [contentLayout addSubview:layout1];
    
    //具有事件处理的layout,高亮背景色的设置。
    MyLinearLayout *layout2 = [self createActionLayout:@"请单击这里(有高亮颜色)" action:@selector(handleTap:)];
    layout2.highlightedBackgroundColor = [UIColor lightGrayColor]; //可以设置高亮的背景色用于单击事件
    layout2.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]];
    layout2.bottomBorderLine.thick = 4; //设置底部有红色的线，并且粗细为4
    //您还可以为布局视图设置按下、按下取消的事件处理逻辑。
    [layout2 setTouchDownTarget:self action:@selector(handleTouchDown:)];
    [layout2 setTouchCancelTarget:self action:@selector(handleTouchCancel:)];
    [contentLayout addSubview:layout2];
    
    //具有事件处理的layout, 可以设置触摸时的高亮背景图。虚线边界线。
    MyLinearLayout *layout3 = [self createActionLayout:@"请单击这里(有高亮图片)" action:@selector(handleTap:)];
    layout3.highlightedBackgroundImage = [UIImage imageNamed:@"image2"]; //设置单击时的高亮背景图片。
    MyBorderLineDraw *dashLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor greenColor]];
    dashLine.dash = 3;    //设置为非0表示虚线边界线。
    layout3.leftBorderLine = dashLine; //设置左右边绿色的虚线
    layout3.rightBorderLine = dashLine;
    [contentLayout addSubview:layout3];
    
}

-(void)addPopmenuLayout:(MyLinearLayout *)contentLayout
{
    MyLinearLayout *layout = [self createActionLayout:@"请单击这里(弹出可伸缩的菜单视图)" action:@selector(handleShowPopMenu:)];
    layout.highlightedOpacity = 0.2;  //按下时的高亮透明度。为1全部透明。
    layout.myTopMargin = 10;
    [contentLayout addSubview:layout];
}

//添加隐藏重新布局的布局
-(void)addHideSubviewReLayoutLayout:(MyLinearLayout *)contentLayout
{
    //下面两个布局用来测试布局视图的hideSubviewReLayout属性。
    MyLinearLayout *switchLayout = [self createSwitchLayout:@"下面的子视图隐藏重新布局开关" action:@selector(handleReLayoutSwitch:)];
    switchLayout.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]]; //底部边界线设置可以缩进
    switchLayout.bottomBorderLine.headIndent = 10;
    switchLayout.bottomBorderLine.tailIndent = 10;
    switchLayout.myTopMargin = 10;
    [contentLayout addSubview:switchLayout];


    MyLinearLayout *testLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    testLayout.backgroundColor = [UIColor whiteColor];
    testLayout.leftPadding = 10;
    testLayout.rightPadding = 10;
    testLayout.myHeight = 50;
    testLayout.gravity = MyMarginGravity_Vert_Fill;
    testLayout.subviewMargin = 10;
    [contentLayout addSubview:testLayout];
    self.hideSubviewRelayoutLayout = testLayout;
    
    UIButton *leftButton = [UIButton new];
    leftButton.myWidth = 50;
    leftButton.backgroundColor = [UIColor greenColor];
    [testLayout addSubview:leftButton];
    
    UIButton *centerButton = [UIButton new];
    [centerButton setTitle:@"点击我隐藏" forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(handleHideSelf:) forControlEvents:UIControlEventTouchUpInside];
    centerButton.backgroundColor = [UIColor redColor];
    [centerButton sizeToFit];
    [testLayout addSubview:centerButton];
    self.hiddenTestButton = centerButton;
    
    UIButton *rightButton = [UIButton new];
    [rightButton setTitle:@"点击我显示" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(handleShowBrother:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.backgroundColor = [UIColor blueColor];
    [rightButton sizeToFit];
    [testLayout addSubview:rightButton];
    
}

//添加，一个浮动宽度的布局，里面的子视图的宽度是浮动的，会进行宽度的合适的分配。您可以尝试着点击加减按钮测试结果。
-(void)addFlexedWidthLayout:(MyLinearLayout*)contentLayout
{
    MyBaseLayout *flexedLayout = [self createSegmentedLayout:@selector(handleLeftFlexed:) rightAction:@selector(handleRightFlexed:)];
    flexedLayout.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]]; //底部边界线设置可以缩进
    flexedLayout.bottomBorderLine.headIndent = 10;
    flexedLayout.bottomBorderLine.tailIndent = 10;
    flexedLayout.myTopMargin = 10;
    [contentLayout addSubview:flexedLayout];
    
    MyLinearLayout *testLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    testLayout.backgroundColor = [UIColor whiteColor];
    testLayout.leftPadding = 10;
    testLayout.rightPadding = 10;
    testLayout.myHeight = 50;
    testLayout.gravity = MyMarginGravity_Vert_Fill;
    [contentLayout addSubview:testLayout];
    self.flexedLayout = testLayout;
    
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = @"abc";
    leftLabel.textAlignment = NSTextAlignmentRight;
    leftLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.backgroundColor = [UIColor redColor];
    [leftLabel sizeToFit];
    leftLabel.rightPos.equalTo(@0.5).min(0); //右边浮动间距为0.5,最小为0
    leftLabel.widthDime.lBound(@(10),0,1).uBound(testLayout.widthDime, -10, 1); //宽度最小为10，最大为布局视图的宽度减10
    [testLayout addSubview:leftLabel];
    self.leftFlexedLabel = leftLabel;
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = @"123";
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.backgroundColor = [UIColor blueColor];
    [rightLabel sizeToFit];
    rightLabel.leftPos.equalTo(@0.5).min(0);   //左边浮动间距为0.5，最小为0
    rightLabel.widthDime.lBound(@(10),0,1).uBound(testLayout.widthDime, -10, 1); //宽度最小为10，最大为布局视图的宽度减10
    [testLayout addSubview:rightLabel];
    self.rightFlexedLabel = rightLabel;
    
    
}

//添加一个能伸缩的布局
-(void)addShrinkLayout:(MyLinearLayout*)contentLayout
{
    //下面两个布局用来测试布局视图的hideSubviewReLayout属性。
    MyLinearLayout *switchLayout = [self createSwitchLayout:@"显示全部开关" action:@selector(handleShrinkSwitch:)];
    switchLayout.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]]; //底部边界线设置可以缩进
    switchLayout.bottomBorderLine.headIndent = 10;
    switchLayout.bottomBorderLine.tailIndent = 10;
    switchLayout.myTopMargin = 10;
    [contentLayout addSubview:switchLayout];
    
    MyFlowLayout *testLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    testLayout.backgroundColor = [UIColor whiteColor];
    testLayout.averageArrange = YES;
    testLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    testLayout.subviewHorzMargin = 10;
    testLayout.subviewVertMargin = 10;
    testLayout.myBottomMargin = 50;   //这里设置底部间距的原因是登录按钮在最底部。为了使得滚动到底部时不被覆盖。
    testLayout.heightDime.equalTo(@50);
    testLayout.clipsToBounds = YES;
    [contentLayout addSubview:testLayout];
    self.shrinkLayout = testLayout;
    
    for (int i = 0 ; i < 10; i++)
    {
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor blueColor];
        label.text = [NSString stringWithFormat:@"%d",i];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [testLayout addSubview:label];
    }

    
}

//创建可执动作事件的布局
-(MyLinearLayout*)createActionLayout:(NSString*)title action:(SEL)action
{
    MyLinearLayout *actionLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    actionLayout.backgroundColor = [UIColor whiteColor];
    [actionLayout setTarget:self action:action];    //这里设置布局的触摸事件处理。
    
    //左右内边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
    actionLayout.leftPadding = 10;
    actionLayout.rightPadding = 10;
    actionLayout.wrapContentWidth = NO;
    actionLayout.heightDime.equalTo(@50);
    actionLayout.gravity = MyMarginGravity_Vert_Center;
    
    
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.tag = 1000;
    label.rightPos.equalTo(@0.5);  //水平线性布局通过相对间距来实现左右分开排列。
    [actionLayout addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
    [imageView sizeToFit];
    imageView.leftPos.equalTo(@0.5);
    [actionLayout addSubview:imageView];
    
    return actionLayout;
    
}

//创建具有开关的布局
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
    label.adjustsFontSizeToFitWidth = YES;
    [label sizeToFit];
    label.rightPos.equalTo(@0.5).min(0);  //设置右间距为相对距离，并且最小为0
    [switchLayout addSubview:label];
    
    
    
    UISwitch *switchCtrl = [UISwitch new];
    [switchCtrl addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    switchCtrl.leftPos.equalTo(@0.5);
    [switchLayout addSubview:switchCtrl];
    
    return switchLayout;
}

-(MyFloatLayout*)createSegmentedLayout:(SEL)leftAction rightAction:(SEL)rightAction
{
    MyFloatLayout *segmentedLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    segmentedLayout.backgroundColor = [UIColor whiteColor];
    
    //左右边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
    segmentedLayout.leftPadding = 10;
    segmentedLayout.rightPadding = 10;
    segmentedLayout.heightDime.equalTo(@50);
    segmentedLayout.gravity = MyMarginGravity_Vert_Center;
    
    
    UISegmentedControl *leftSegmented = [[UISegmentedControl alloc] initWithItems:@[@"  减  ",@"  加  "]];
    leftSegmented.momentary = YES;
    [leftSegmented addTarget:self action:leftAction forControlEvents:UIControlEventValueChanged];
    [segmentedLayout addSubview:leftSegmented];
    
    
    UISegmentedControl *rightSegmented = [[UISegmentedControl alloc] initWithItems:@[@"  加  ",@"  减  "]];
    rightSegmented.momentary = YES;
    [rightSegmented addTarget:self action:rightAction forControlEvents:UIControlEventValueChanged];
    [segmentedLayout addSubview:rightSegmented];
    rightSegmented.reverseFloat = YES;

    
    return segmentedLayout;

}



#pragma mark -- Handle Method

-(void)handleTap:(MyBaseLayout*)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"test" message:@"执行单击测试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [av show];
}

-(void)handleTouchDown:(MyBaseLayout*)sender
{
    UILabel *label = [sender viewWithTag:1000];
    label.textColor = [UIColor blueColor];
    
    NSLog(@"按下动作");
}

-(void)handleTouchCancel:(MyBaseLayout*)sender
{
    UILabel *label = [sender viewWithTag:1000];
    label.textColor = [UIColor blackColor];
    NSLog(@"按下取消");
}

-(void)handleReLayoutSwitch:(MyBaseLayout *)sender
{
    self.hideSubviewRelayoutLayout.hideSubviewReLayout = !self.hideSubviewRelayoutLayout.hideSubviewReLayout;
}

-(void)handleHideSelf:(UIButton*)sender
{
    self.hiddenTestButton.hidden = YES;
}

-(void)handleShowBrother:(UIButton*)sender
{
    self.hiddenTestButton.hidden = NO;
}

-(void)handleLeftFlexed:(UISegmentedControl*)segmented
{
 
    if (segmented.selectedSegmentIndex == 0)
    {
        if (self.leftFlexedLabel.text.length > 1)
        {
            self.leftFlexedLabel.text = [self.leftFlexedLabel.text stringByReplacingCharactersInRange:NSMakeRange(self.leftFlexedLabel.text.length - 1, 1) withString:@""];

        }
    }
    else
    {
        NSString *strs = @"abcdefghijklmnopqrstuvwxyz";
        self.leftFlexedLabel.text = [self.leftFlexedLabel.text stringByAppendingString:[strs substringWithRange:NSMakeRange(arc4random_uniform((uint32_t)strs.length), 1)]];
    }
   
    [self.leftFlexedLabel sizeToFit];
    
    
    //我们可以在布局视图布局结束后，计算如果包裹文字的真实宽度都超过布局视图的一半时，我们将二者的宽度都设置为布局视图的宽度一半。
    //而一旦不满足条件时我们将宽度的设置清除，而保持子视图的真实尺寸。
    //如果我们想要获得某个布局视图下所有子视图在布局完成后的真实frame，则可以为布局的endLayoutBlock进行设置。
    __weak AllTest3ViewController* weakSelf = self;
    self.flexedLayout.endLayoutBlock = ^{
    
        //算出左右的实际宽度。如果二者的宽度都超过一半，则将二者的宽度都设置为一半。
        CGSize leftRealSize = [weakSelf.leftFlexedLabel sizeThatFits:CGSizeZero];
        CGSize rightRealSize = [weakSelf.rightFlexedLabel sizeThatFits:CGSizeZero];
        
        CGFloat halfWidth = (weakSelf.flexedLayout.frame.size.width - 20)/2;  //这里的20是布局有左右10的内边距。
        if (leftRealSize.width > halfWidth && rightRealSize.width > halfWidth)
        {
            weakSelf.leftFlexedLabel.widthDime.equalTo(@(halfWidth));
            weakSelf.rightFlexedLabel.widthDime.equalTo(@(halfWidth));
        }
        else
        {
            weakSelf.leftFlexedLabel.widthDime.equalTo(nil);
            weakSelf.rightFlexedLabel.widthDime.equalTo(nil);  //这里面清除宽度的固定设置。
            [weakSelf.rightFlexedLabel sizeToFit];
        }
        
    };
    
    
}

-(void)handleRightFlexed:(UISegmentedControl*)segmented
{
    if (segmented.selectedSegmentIndex == 0)
    {
        NSString *strs = @"01234567890";
        self.rightFlexedLabel.text = [self.rightFlexedLabel.text stringByAppendingString:[strs substringWithRange:NSMakeRange(arc4random_uniform((uint32_t)strs.length), 1)]];
    }
    else
    {
        if (self.rightFlexedLabel.text.length > 1)
        {
            self.rightFlexedLabel.text = [self.rightFlexedLabel.text stringByReplacingCharactersInRange:NSMakeRange(self.rightFlexedLabel.text.length - 1, 1) withString:@""];
            
        }
    }
    
    [self.rightFlexedLabel sizeToFit];
    
    
    __weak AllTest3ViewController* weakSelf = self;
    self.flexedLayout.endLayoutBlock = ^{
        
        //算出左右的实际宽度。如果二者的宽度都超过一半，则将二者的宽度都设置为一半。
        CGSize leftRealSize = [weakSelf.leftFlexedLabel sizeThatFits:CGSizeZero];
        CGSize rightRealSize = [weakSelf.rightFlexedLabel sizeThatFits:CGSizeZero];
        
        CGFloat halfWidth = (weakSelf.flexedLayout.frame.size.width - 20)/2;
        if (leftRealSize.width > halfWidth && rightRealSize.width > halfWidth)
        {
            weakSelf.leftFlexedLabel.widthDime.equalTo(@(halfWidth));
            weakSelf.rightFlexedLabel.widthDime.equalTo(@(halfWidth));
        }
        else
        {
            weakSelf.leftFlexedLabel.widthDime.equalTo(nil);
            weakSelf.rightFlexedLabel.widthDime.equalTo(nil);
            [weakSelf.leftFlexedLabel sizeToFit];
        }
        
    };

}

-(void)handleShrinkSwitch:(UISwitch *)sender
{
    if (sender.isOn)
    {
        self.shrinkLayout.heightDime.equalTo(nil);
        self.shrinkLayout.wrapContentHeight = YES;
    }
    else
    {
        self.shrinkLayout.heightDime.equalTo(@50);
        self.shrinkLayout.wrapContentHeight = NO;
    }
    
    [self.shrinkLayout layoutAnimationWithDuration:0.3];
}

-(void)handleShowPopMenu:(MyBaseLayout*)sender
{
   CGRect rc = [sender convertRect:sender.bounds toView:self.frameLayout]; // 计算应该弹出的位置。要转化为框架布局的rect
    
    MyLinearLayout *menuLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    menuLayout.myWidth = CGRectGetWidth(rc) - 20;  //宽度是sender的宽度减20
    menuLayout.marginGravity = MyMarginGravity_Horz_Center;  //因为我们是把弹出菜单展示在self.view下，这时候self.view是一个框架布局。所以这里这是水平居中。
    menuLayout.myTopMargin = CGRectGetMaxY(rc) + 5;  //弹出菜单的顶部位置。

    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uptip"]];
    arrowImageView.myCenterXOffset = 0;
    [menuLayout addSubview:arrowImageView];
    
    
    MyLinearLayout *containerLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    containerLayout.backgroundColor = [UIColor colorWithRed:0xBF/255.0f green:0xBD/255.0 blue:0xBF/255.0 alpha:1];
    containerLayout.layer.cornerRadius = 4;
    containerLayout.myLeftMargin = containerLayout.myRightMargin = 0;
    containerLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    containerLayout.gravity = MyMarginGravity_Horz_Fill;
    [menuLayout addSubview:containerLayout];
    self.popmenuContainerLayout = containerLayout;
    
    UIScrollView *scrollView = [UIScrollView new];
    [containerLayout addSubview:scrollView];
    self.popmenuScrollView = scrollView;
    
    MyFlowLayout *itemLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    itemLayout.myLeftMargin = itemLayout.myRightMargin = 0;
    itemLayout.averageArrange = YES;
    itemLayout.subviewHorzMargin = 10;
    itemLayout.subviewVertMargin = 10;
    itemLayout.wrapContentHeight = YES;
    [scrollView addSubview:itemLayout];
    self.popmenuItemLayout = itemLayout;
    
    for (int i = 0 ; i < 6; i++)
    {
        UIButton *button = [UIButton new];
        if (i == 5)  //最后一个特殊处理！！！用于添加按钮。
        {
            [button setTitle:@"添加条目" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(handleAddMe:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor redColor];
        }
        else
        {
            [button setTitle:[NSString stringWithFormat:@"双击删除:%d",i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(handleDelMe:) forControlEvents:UIControlEventTouchDownRepeat];
            button.backgroundColor = [UIColor blueColor];
        }
        [button sizeToFit];
        [itemLayout addSubview:button];
    }
    
    //评估出itemLayout的尺寸，注意这里要明确指定itemLayout的宽度，因为弹出菜单的宽度是sender的宽度-20，而itemLayout的父容器又有20的左右内边距，因此这里要减去40.
    CGRect sz = [itemLayout estimateLayoutRect:CGSizeMake(CGRectGetWidth(rc) - 40, 0)];
    scrollView.heightDime.equalTo(@(sz.size.height)).min(50).max(155);  //设置scrollView的高度，以及最大最小高度。正是这个实现了拉伸限制功能。
    
    UIButton *closeButton = [UIButton new];
    closeButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    closeButton.layer.borderWidth = 1;
    [closeButton setTitle:@"关闭弹出菜单" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor whiteColor];
    [closeButton addTarget:self action:@selector(handleClosePopmenu:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.myTopMargin = 5;
    [closeButton sizeToFit];
    [containerLayout addSubview:closeButton];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"您可以通过添加条目和删除条目看到菜单有自动缩放的功能。";
    tipLabel.adjustsFontSizeToFitWidth = YES;
    [tipLabel sizeToFit];
    [containerLayout addSubview:tipLabel];

    
    //注意这里的self.view是框架布局实现的。
    [self.frameLayout addSubview:menuLayout];
    //为实现动画效果定义初始位置和尺寸。
    menuLayout.frame = CGRectMake(10, self.frameLayout.bounds.size.height, CGRectGetWidth(rc) - 20, 0);
    self.popmenuLayout = menuLayout;
    [self.frameLayout layoutAnimationWithDuration:0.3];
    
    
}

-(void)handleAddMe:(UIButton*)sender
{
    UIButton *button = [UIButton new];
    [button setTitle:[NSString stringWithFormat:@"双击删除:%lu",sender.superview.subviews.count ] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleDelMe:) forControlEvents:UIControlEventTouchDownRepeat];
    button.backgroundColor = [UIColor blueColor];
    [button sizeToFit];
    [self.popmenuItemLayout insertSubview:button belowSubview:sender];
    
    //重新评估popmenuItemLayout的高度，这里宽度是0的原因是因为宽度已经明确了，也就是在现有的宽度下评估。而前面是因为popmenuItemLayout的宽度还没有明确所以要指定宽度。
    CGRect sz = [self.popmenuItemLayout estimateLayoutRect:CGSizeMake(0, 0)];
    self.popmenuScrollView.heightDime.equalTo(@(sz.size.height));
    
    //多个布局同时动画。
    [self.popmenuItemLayout layoutAnimationWithDuration:0.3];
    [self.popmenuLayout layoutAnimationWithDuration:0.3];
    [self.popmenuContainerLayout layoutAnimationWithDuration:0.3];
    
}

-(void)handleDelMe:(UIButton*)sender
{
    [sender removeFromSuperview];
    CGRect sz = [self.popmenuItemLayout estimateLayoutRect:CGSizeMake(0, 0)];
    self.popmenuScrollView.heightDime.equalTo(@(sz.size.height));

    [self.popmenuItemLayout layoutAnimationWithDuration:0.3];
    [self.popmenuLayout layoutAnimationWithDuration:0.3];
    [self.popmenuContainerLayout layoutAnimationWithDuration:0.3];
}

-(void)handleClosePopmenu:(UIButton*)sender
{
    //因为popmenuLayout的设置会激发frameLayout的重新布局，所以这里用这个方法进行动画消失处理。
    self.popmenuLayout.myTopMargin = self.frameLayout.frame.size.height;

    [UIView animateWithDuration:0.3 animations:^{
        
        [self.frameLayout layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self.popmenuLayout removeFromSuperview];
        
    }];
   

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

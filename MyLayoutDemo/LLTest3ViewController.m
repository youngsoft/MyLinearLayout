//
//  LLTest3ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest3ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface LLTest3ViewController ()

@property(nonatomic, weak) UILabel *vertGravitySetLabel;
@property(nonatomic, weak) UILabel *horzGravitySetLabel;

@property(nonatomic, weak) MyLinearLayout *vertGravityLayout;
@property(nonatomic, weak) MyLinearLayout *horzGravityLayout;

@end

@implementation LLTest3ViewController

-(void)loadView
{
    /*
       这个例子主要用来了解布局视图的gravity这个属性。gravity这个属性主要用来控制布局视图里面的子视图的整体停靠方向以及子视图的填充。我们考虑下面的场景：
     
     1.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图都和父视图右对齐。第一个方法是分别为每个子视图设置myRight=0来实现；第二个方法是只需要设置布局视图的gravity的值为MyGravity_Horz_Right就可以实现了。
     2.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图整体水平居中对齐。第一个方法是分别为每个子视图设置myCenterXPos=0来实现；第二个方法是只需要设置布局视图的gravity的值为MyGravity_Horz_Center就可以实现了。
     3.假设某个垂直线性布局有A,B,C三个子视图，并且我们希望这三个子视图整体垂直居中。第一个方法是为设置A的myTop=0.5和设置C的myBottom=0.5;第二个方法是只需要设置布局视图的gravity的值为MyGravity_Vert_Center就可以实现了。
     4.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图整体居中。我们就只需要将布局视图的gravity值设置为MyGravity_Center就可以了。
     5.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图的宽度都和布局视图一样宽。第一个方法是分别为每个子视图的myLeft和myRight设置为0;第二个方法是只需要设置布局视图的gravity的值为MyGravity_Horz_Fill就可以了。
     
     通过上面的几个场景我们可以看出gravity属性的设置可以在很大程度上简化布局视图里面的子视图的布局属性的设置的，通过gravity属性的设置我们可以控制布局视图里面所有子视图的整体停靠方向和填充的尺寸。在使用gravity属性时需要明确如下几个条件：
       
    1.当使用gravity属性时意味着布局视图必须要有明确的尺寸才有意义，因为有确定的尺寸才能决定里面的子视图的停靠的方位。
    2.布局视图的wrapContentHeight设置为YES时是和gravity上设置垂直停靠方向以及垂直填充是互斥的；而布局视图的wrapContentWidth设置为YES时是和gravity上设置水平停靠方向和水平填充是互斥的。
    3.布局视图的gravity的属性的优先级要高于子视图的停靠和尺寸设置。
     
     */
    
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.myLeading = contentLayout.myTrailing = 0;
    [scrollView addSubview:contentLayout];
    
    contentLayout.gravity = MyGravity_Horz_Fill;  //设置这个属性后contentLayout的所有子视图都不需要指定宽度了，MyGravity_Horz_Fill的意义是所有子视图的宽度都填充满布局并和布局宽度相等。也就是说设置了这个值后每个子视图不需要通过设置myHorzMargin或者myWidth来指定宽度了。
    
    
    //创建垂直布局停靠操作动作布局。
    [self createVertLayoutGravityActionLayout:contentLayout];
    //创建垂直停靠布局。
    [self createVertGravityLayout:contentLayout];
    
    //创建水平布局停靠操作动作布局。
    [self createHorzLayoutGravityActionLayout:contentLayout];
    //创建水平停靠布局。
    [self createHorzGravityLayout:contentLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self handleNavigationTitleCentre:nil];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"centered title", <#comment#>) style:UIBarButtonItemStylePlain target:self action:@selector(handleNavigationTitleCentre:) ],[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"reset", @"") style:UIBarButtonItemStylePlain target:self action:@selector(handleNavigationTitleRestore:)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

-(UILabel*)createLabel:(NSString*)title backgroundColor:(UIColor*)color
{
    UILabel *v = [UILabel new];
    v.text = title;
    v.clipsToBounds = YES;   //这里必须要设置为YES，因为UILabel做高度调整动画时，如果不设置为YES则不会固定顶部。。。
    v.backgroundColor = color;
    v.adjustsFontSizeToFitWidth = YES;
    v.font = [CFTool font:15];
    [v sizeToFit];
    
    return v;

}

//创建垂直线性布局停靠操作动作布局。
-(void)createVertLayoutGravityActionLayout:(MyLinearLayout*)contentLayout
{
    
    UILabel *actionTitleLabel = [UILabel new];
    actionTitleLabel.font = [CFTool font:15];
    actionTitleLabel.text = NSLocalizedString(@"Vertical layout gravity control, you can click the following different button to show the effect:", @"");
    actionTitleLabel.textColor = [CFTool color:4];
    actionTitleLabel.adjustsFontSizeToFitWidth = YES;
    actionTitleLabel.wrapContentHeight = YES;
    actionTitleLabel.myTop = 10;
    [contentLayout addSubview:actionTitleLabel];
    
    
    //用流式布局来创建动作菜单布局。流式布局请参考后面关于流式布局的DEMO。
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    actionLayout.wrapContentHeight = YES;
    actionLayout.gravity = MyGravity_Horz_Fill; //平均分配里面所有子视图的宽度
    actionLayout.subviewHSpace = 5;
    actionLayout.subviewVSpace = 5;  //设置里面子视图的水平和垂直间距。
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [contentLayout addSubview:actionLayout];
    
    
    NSArray *actions = @[NSLocalizedString(@"top",@""),
                         NSLocalizedString(@"vert center",@""),
                         NSLocalizedString(@"bottom",@""),
                         NSLocalizedString(@"left",@""),
                         NSLocalizedString(@"horz center",@""),
                         NSLocalizedString(@"right",@""),
                         NSLocalizedString(@"screen vert center",@""),
                         NSLocalizedString(@"screen horz center",@""),
                         NSLocalizedString(@"between",@""),
                         NSLocalizedString(@"horz fill",@""),
                         NSLocalizedString(@"vert fill", @"")];
    
    for (NSInteger i = 0; i < actions.count; i++)
    {
        [actionLayout addSubview:[self createActionButton:actions[i] tag:(i + 1) action:@selector(handleVertLayoutGravity:)]];
    }
}

//创建垂直停靠线性布局
-(void)createVertGravityLayout:(MyLinearLayout*)contentLayout
{
    //这个标签显示设置gravity值。
    UILabel *vertGravitySetLabel = [UILabel new];
    vertGravitySetLabel.adjustsFontSizeToFitWidth = YES;
    vertGravitySetLabel.font = [CFTool font:13];
    vertGravitySetLabel.text = @"vertGravityLayout.gravity = ";
    [vertGravitySetLabel  sizeToFit];
    vertGravitySetLabel.numberOfLines = 2;
    [contentLayout addSubview:vertGravitySetLabel];
    self.vertGravitySetLabel = vertGravitySetLabel;

    
    MyLinearLayout *vertGravityLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    vertGravityLayout.wrapContentHeight = NO;
    vertGravityLayout.backgroundColor = [CFTool color:0];
    vertGravityLayout.myHeight = 160;
    vertGravityLayout.myTop = 10;
    vertGravityLayout.myLeading = 20;
    vertGravityLayout.subviewVSpace = 10; //设置每个子视图之间的间距为10
    [contentLayout addSubview:vertGravityLayout];
    self.vertGravityLayout = vertGravityLayout;

    
    UILabel *v1 = [self createLabel:NSLocalizedString(@"test text1", @"") backgroundColor:[CFTool color:5]];
    v1.myHeight = 20;
    [self.vertGravityLayout addSubview:v1];
    
    UILabel *v2 = [self createLabel:NSLocalizedString(@"always alignment to left", @"") backgroundColor:[CFTool color:6]];
    v2.myHeight = 20;
    v2.myAlignment = MyGravity_Horz_Left;  //对于垂直布局里面的子视图可以通过这个属性来设置水平对齐的方位，这样即使布局视图设置了gravity属性，这个视图的对齐都不会受到影响。
    [self.vertGravityLayout addSubview:v2];
    
    UILabel *v3 = [self createLabel:NSLocalizedString(@"test text3 test text3 test text3", @"") backgroundColor:[CFTool color:7]];
    v3.myHeight = 30;
    [self.vertGravityLayout addSubview:v3];
    
    UILabel *v4 = [self createLabel:NSLocalizedString(@"set left and right margin to determine width", @"") backgroundColor:[CFTool color:8]];
    v4.myHeight = 25;
    v4.myLeading = 20;
    v4.myTrailing = 30;
    [self.vertGravityLayout addSubview:v4];
}



//创建水平线性布局停靠操作动作布局。
-(void)createHorzLayoutGravityActionLayout:(MyLinearLayout*)contentLayout
{
    
    UILabel *actionTitleLabel = [UILabel new];
    actionTitleLabel.font = [CFTool font:15];
    actionTitleLabel.textColor = [CFTool color:4];
    actionTitleLabel.text =  NSLocalizedString(@"Horizontal layout gravity control, you can click the following different button to show the effect:", @"");
    actionTitleLabel.adjustsFontSizeToFitWidth = YES;
    actionTitleLabel.wrapContentHeight = YES;
    actionTitleLabel.myTop = 10;
    [contentLayout addSubview:actionTitleLabel];

    
    //用流式布局来创建动作菜单布局。流式布局请参考后面关于流式布局的DEMO。
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    actionLayout.wrapContentHeight = YES;
    actionLayout.gravity = MyGravity_Horz_Fill;  //平均分配里面所有子视图的宽度
    actionLayout.subviewHSpace = 5;
    actionLayout.subviewVSpace = 5;  //设置里面子视图的水平和垂直间距。
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [contentLayout addSubview:actionLayout];
    
    NSArray *actions = @[NSLocalizedString(@"top",@""),
                         NSLocalizedString(@"vert center",@""),
                         NSLocalizedString(@"bottom",@""),
                         NSLocalizedString(@"left",@""),
                         NSLocalizedString(@"horz center",@""),
                         NSLocalizedString(@"right",@""),
                         NSLocalizedString(@"screen vert center",@""),
                         NSLocalizedString(@"screen horz center",@""),
                         NSLocalizedString(@"between",@""),
                         NSLocalizedString(@"horz fill",@""),
                         NSLocalizedString(@"vert fill", @"")];
    
    for (NSInteger i = 0; i < actions.count; i++)
    {
        [actionLayout addSubview:[self createActionButton:actions[i] tag:(i + 1) action:@selector(handleHorzLayoutGravity:)]];
    }

}

-(void)createHorzGravityLayout:(MyLinearLayout*)contentLayout
{
    //这个标签显示设置gravity值。
    UILabel *horzGravitySetLabel = [UILabel new];
    horzGravitySetLabel.adjustsFontSizeToFitWidth = YES;
    horzGravitySetLabel.font = [CFTool font:13];
    horzGravitySetLabel.text = @"horzGravityLayout.gravity = ";
    [horzGravitySetLabel  sizeToFit];
    horzGravitySetLabel.numberOfLines = 2;
    [contentLayout addSubview:horzGravitySetLabel];
    self.horzGravitySetLabel = horzGravitySetLabel;
    
    MyLinearLayout *horzGravityLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    horzGravityLayout.backgroundColor = [CFTool color:0];
    horzGravityLayout.wrapContentWidth = NO;  //因为默认水平线性布局的宽度由子视图包裹，但这里的宽度由父布局决定的，所有这里必须设置为NO。
    horzGravityLayout.myHeight = 200;
    horzGravityLayout.myTop = 10;
    horzGravityLayout.myLeading = 20;
    horzGravityLayout.subviewHSpace = 5;  //设置子视图之间的水平间距为5
    [contentLayout addSubview:horzGravityLayout];
    self.horzGravityLayout = horzGravityLayout;
    
    UILabel *v1 = [self createLabel:NSLocalizedString(@"test text1", @"") backgroundColor:[CFTool color:5]];
    v1.wrapContentHeight = YES;
    v1.myWidth = 60;
    [self.horzGravityLayout addSubview:v1];
    
    UILabel *v2 = [self createLabel:NSLocalizedString(@"always alignment to top", @"") backgroundColor:[CFTool color:6]];
    v2.wrapContentHeight = YES;
    v2.myWidth = 60;
    v2.myAlignment = MyGravity_Vert_Top;  //对于水平布局里面的子视图可以通过这个属性来设置垂直对齐的方位，这样即使布局视图设置了gravity属性，这个视图的对齐都不会受到影响。
    [self.horzGravityLayout addSubview:v2];
    
    
    UILabel *v3 = [self createLabel:NSLocalizedString(@"test text3 test text3 test text3", @"") backgroundColor:[CFTool color:7]];
    v3.wrapContentHeight = YES;
    v3.myWidth = 60;
    [self.horzGravityLayout addSubview:v3];
    
    UILabel *v4 = [self createLabel:NSLocalizedString(@"set top and bottom margin to determine height", @"") backgroundColor:[CFTool color:8]];
    v4.wrapContentHeight = YES;
    v4.myTop = 20;
    v4.myBottom = 10;
    v4.myWidth = 60;
    [self.horzGravityLayout addSubview:v4];

  }


//创建动作按钮
-(UIButton*)createActionButton:(NSString*)title tag:(NSInteger)tag action:(SEL)action
{
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [actionButton setTitle:title forState:UIControlStateNormal];
    actionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    actionButton.titleLabel.font = [CFTool font:14];
    actionButton.tag = tag;
    [actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    actionButton.layer.borderColor = [UIColor grayColor].CGColor;
    actionButton.layer.cornerRadius = 4;
    actionButton.layer.borderWidth = 0.5;
    [actionButton sizeToFit];
    return actionButton;
}


#pragma mark -- Handle Method

-(void)handleVertLayoutGravity:(UIButton*)button
{
    //分别取出垂直和水平方向的停靠设置。
    MyGravity vertGravity = self.vertGravityLayout.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = self.vertGravityLayout.gravity & MyGravity_Vert_Mask;
    
    switch (button.tag) {
        case 1:  //上
            vertGravity = MyGravity_Vert_Top;
            break;
        case 2:  //垂直
            vertGravity = MyGravity_Vert_Center;
            break;
        case 3:   //下
            vertGravity = MyGravity_Vert_Bottom;
            break;
        case 4:  //左
            horzGravity = MyGravity_Horz_Left;
            break;
        case 5:  //水平
            horzGravity = MyGravity_Horz_Center;
            break;
        case 6:   //右
            horzGravity =  MyGravity_Horz_Right;
            break;
         case 7:   //窗口垂直居中
            vertGravity = MyGravity_Vert_Window_Center;
            break;
        case 8:   //窗口水平居中
            horzGravity = MyGravity_Horz_Window_Center;
            break;
        case 9:  //垂直间距拉伸
            vertGravity = MyGravity_Vert_Between;
            break;
        case 10:   //水平填充
            horzGravity  = MyGravity_Horz_Fill;
            break;
        case 11:  //垂直填充
            vertGravity = MyGravity_Vert_Fill;  //这里模拟器顶部出现黑线，真机是不会出现的。。
            break;
        default:
            break;
    }
    
    self.vertGravityLayout.gravity = vertGravity | horzGravity;
    
    [self.vertGravityLayout layoutAnimationWithDuration:0.2];
    
    self.vertGravitySetLabel.text = [self gravityText:self.vertGravityLayout.gravity prefixText:@"vertGravityLayout.gravity"];
    [self.vertGravitySetLabel sizeToFit];

}

-(void)handleHorzLayoutGravity:(UIButton*)button
{
    //分别取出垂直和水平方向的停靠设置。
    MyGravity vertGravity = self.horzGravityLayout.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = self.horzGravityLayout.gravity & MyGravity_Vert_Mask;
    
    switch (button.tag) {
        case 1:  //上
            vertGravity = MyGravity_Vert_Top;
            break;
        case 2:  //垂直
            vertGravity = MyGravity_Vert_Center;
            break;
        case 3:   //下
            vertGravity = MyGravity_Vert_Bottom;
            break;
        case 4:  //左
            horzGravity = MyGravity_Horz_Left;
            break;
        case 5:  //水平
            horzGravity = MyGravity_Horz_Center;
            break;
        case 6:   //右
            horzGravity =  MyGravity_Horz_Right;
            break;
        case 7:   //窗口垂直居中
            vertGravity = MyGravity_Vert_Window_Center;
            break;
        case 8:   //窗口水平居中
            horzGravity = MyGravity_Horz_Window_Center;
            break;
        case 9:  //水平间距拉伸
            horzGravity = MyGravity_Horz_Between;
            break;
        case 10:   //水平填充
            horzGravity  = MyGravity_Horz_Fill;
            break;
        case 11:
            vertGravity = MyGravity_Vert_Fill;
            break;
        default:
            break;
    }
    
    self.horzGravityLayout.gravity = vertGravity | horzGravity;
    
    [self.horzGravityLayout layoutAnimationWithDuration:0.2];
    
    self.horzGravitySetLabel.text = [self gravityText:self.horzGravityLayout.gravity prefixText:@"horzGravityLayout.gravity"];
    [self.horzGravitySetLabel sizeToFit];

}


-(void)handleNavigationTitleCentre:(id)sender
{
    MyLinearLayout *navigationItemLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    navigationItemLayout.wrapContentHeight = NO;
    navigationItemLayout.wrapContentWidth = NO; //将线性布局放入navigationItem.titleView需要把包裹属性设置为NO。
    
    //通过MyGravity_Horz_Window_Center的设置总是保证在窗口的中间而不是布局视图的中间。
    navigationItemLayout.gravity = MyGravity_Horz_Window_Center | MyGravity_Vert_Center;
    navigationItemLayout.frame = self.navigationController.navigationBar.bounds;
    self.navigationItem.titleView = navigationItemLayout;

    
    UILabel *topLabel = [UILabel new];
    topLabel.text = NSLocalizedString(@"title center in the screen", @"");
    topLabel.adjustsFontSizeToFitWidth = YES;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [CFTool color:4];
    topLabel.font = [CFTool font:17];
    topLabel.myLeading = topLabel.myTrailing = 10;
    [topLabel sizeToFit];
    [navigationItemLayout addSubview:topLabel];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = self.title;
    [bottomLabel sizeToFit];
    [navigationItemLayout addSubview:bottomLabel];
    
    
}

-(void)handleNavigationTitleRestore:(id)sender
{
    UILabel *topLabel = [UILabel new];
    topLabel.text = NSLocalizedString(@"title not center in the screen", @"");
    topLabel.textColor = [CFTool color:4];
    topLabel.font = [CFTool font:17];
    topLabel.adjustsFontSizeToFitWidth = YES;
    topLabel.textAlignment = NSTextAlignmentCenter;
    [topLabel sizeToFit];
    self.navigationItem.titleView = topLabel;
}


#pragma mark -- Private Method

-(NSString*)gravityText:(MyGravity)gravity prefixText:(NSString*)prefixText
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
    
    
    return [NSString stringWithFormat:@"%@ =\n %@ | %@",prefixText, vertGravityStr, horzGravityStr];

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

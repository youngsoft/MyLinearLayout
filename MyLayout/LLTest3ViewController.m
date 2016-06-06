//
//  Test3ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest3ViewController.h"
#import "MyLayout.h"

@interface LLTest3ViewController ()

@property(nonatomic, strong) MyLinearLayout *vertGravityLayout;
@property(nonatomic, strong) MyLinearLayout *horzGravityLayout;

@end

@implementation LLTest3ViewController

-(void)loadView
{
    /*
       这个例子主要用来了解布局视图的gravity这个属性。gravity这个属性主要用来控制布局视图里面的子视图的整体停靠方向以及子视图的填充。我们考虑下面的场景：
     
     1.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图都和父视图右对齐。第一个方法是分别为每个子视图设置myRightMargin=0来实现；第二个方法是只需要设置布局视图的gravity的值为MyMarginGravity_Horz_Right就可以实现了。
     2.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图整体水平居中对齐。第一个方法是分别为每个子视图设置myCenterXPos=0来实现；第二个方法是只需要设置布局视图的gravity的值为MyMarginGravity_Horz_Center就可以实现了。
     3.假设某个垂直线性布局有A,B,C三个子视图，并且我们希望这三个子视图整体垂直居中。第一个方法是为设置A的myTopMargin=0.5和设置C的myBottomMargin=0.5;第二个方法是只需要设置布局视图的gravity的值为MyMarginGravity_Vert_Center就可以实现了。
     4.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图整体居中。我们就只需要将布局视图的gravity值设置为MyMarginGravity_Center就可以了。
     5.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图的宽度都和布局视图一样宽。第一个方法是分别为每个子视图的myLeftMargin和myRightMargin设置为0;第二个方法是只需要设置布局视图的gravity的值为MyMarginGravity_Horz_Fill就可以了。
     
     通过上面的几个场景我们可以看出gravity属性的设置可以在很大程度上简化布局视图里面的子视图的布局属性的设置的，通过gravity属性的设置我们可以控制布局视图里面所有子视图的整体停靠方向和填充的尺寸。在使用gravity属性时需要明确如下几个条件：
       
    1.当使用gravity属性时意味着布局视图必须要有明确的尺寸才有意义，因为有确定的尺寸才能决定里面的子视图的停靠的方位。
    2.布局视图的wrapContentHeight设置为YES时是和gravity上设置垂直停靠方向以及垂直填充是互斥的；而布局视图的wrapContentWidth设置为YES时是和gravity上设置水平停靠方向和水平填充是互斥的。
    3.对于垂直线性布局来说不能设置gravity的值为MyMarginGravity_Vert_Fill；对于水平线性布局来说不能设置gravity的值为MyMarginGravity_Horz_Fill。
    4.布局视图的gravity的属性的优先级要高于子视图的停靠和尺寸设置。
     
     */
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    contentLayout.myLeftMargin = contentLayout.myRightMargin = 0;
    [scrollView addSubview:contentLayout];
    
    contentLayout.gravity = MyMarginGravity_Horz_Fill;  //设置这个属性后contentLayout的所有子视图都不需要指定宽度了，MyMarginGravity_Horz_Fill的意义是所有子视图的宽度都填充满布局并和布局宽度相等。也就是说设置了这个值后每个子视图不需要通过设置myLeftMargin, myRightMargin或者myWidth来指定宽度了。
    
    
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
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"居中标题" style:UIBarButtonItemStylePlain target:self action:@selector(handleNavigationTitleCentre:) ],[[UIBarButtonItem alloc] initWithTitle:@"还原" style:UIBarButtonItemStylePlain target:self action:@selector(handleNavigationTitleRestore:)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction


//创建垂直线性布局停靠操作动作布局。
-(void)createVertLayoutGravityActionLayout:(MyLinearLayout*)contentLayout
{
    
    UILabel *actionTitleLabel = [UILabel new];
    actionTitleLabel.text = @"垂直布局里面的停靠控制，您可以点击下面的不同停靠方式的按钮查看效果：";
    actionTitleLabel.numberOfLines = 0;
    actionTitleLabel.flexedHeight = YES;
    actionTitleLabel.adjustsFontSizeToFitWidth = YES;
    [contentLayout addSubview:actionTitleLabel];
    
    
    //用流式布局来创建动作菜单布局。流式布局请参考后面关于流式布局的DEMO。
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    actionLayout.wrapContentHeight = YES;
    actionLayout.averageArrange = YES;  //平均分配里面所有子视图的宽度
    actionLayout.subviewHorzMargin = 5;
    actionLayout.subviewVertMargin = 5;  //设置里面子视图的水平和垂直间距。
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [contentLayout addSubview:actionLayout];
    
    
    NSArray *actions = @[@"上停靠",
                         @"垂直居中停靠",
                         @"下停靠",
                         @"左停靠",
                         @"水平居中停靠",
                         @"右停靠",
                         @"水平填充",
                         @"屏幕垂直居中停靠",
                         @"屏幕水平居中停靠",
                         @"子视图间距设置"
                         ];
    
    
    for (NSInteger i = 0; i < actions.count; i++)
    {
        [actionLayout addSubview:[self createActionButton:actions[i] tag:(i + 1)* 100]];
    }
}

//创建垂直停靠线性布局
-(void)createVertGravityLayout:(MyLinearLayout*)contentLayout
{
    self.vertGravityLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    self.vertGravityLayout.backgroundColor = [UIColor grayColor];
    self.vertGravityLayout.myHeight = 200;
    self.vertGravityLayout.myTopMargin = 10;
    self.vertGravityLayout.myLeftMargin = 20;
    self.vertGravityLayout.subviewMargin = 10; //设置每个子视图之间的间距为10
    [contentLayout addSubview:self.vertGravityLayout];

    
    UILabel *v1 = [UILabel new];
    v1.text = @"测试文本1";
    v1.backgroundColor = [UIColor redColor];
    [v1 sizeToFit];
    [self.vertGravityLayout addSubview:v1];
    
    UILabel *v2 = [UILabel new];
    v2.text = @"测试文本2测试文本2";
    v2.backgroundColor = [UIColor greenColor];
    [v2 sizeToFit];
    [self.vertGravityLayout addSubview:v2];
    
    
    UILabel *v3 = [UILabel new];
    v3.text = @"测试文本3测试文本3测试文本3";
    v3.backgroundColor = [UIColor blueColor];
    [v3 sizeToFit];
    [self.vertGravityLayout addSubview:v3];
    
    UILabel *v4 = [UILabel new];
    v4.text = @"你可以自定义左右边距和宽度";
    v4.backgroundColor = [UIColor orangeColor];
    [v4 sizeToFit];
    v4.myLeftMargin = 20;
    v4.myRightMargin = 30;
    [self.vertGravityLayout addSubview:v4];
}



//创建水平线性布局停靠操作动作布局。
-(void)createHorzLayoutGravityActionLayout:(MyLinearLayout*)contentLayout
{
    
    UILabel *actionTitleLabel = [UILabel new];
    actionTitleLabel.text = @"水平布局里面的停靠控制，您可以点击下面的不同停靠方式的按钮查看效果：";
    actionTitleLabel.numberOfLines = 0;
    actionTitleLabel.flexedHeight = YES;
    actionTitleLabel.adjustsFontSizeToFitWidth = YES;
    [contentLayout addSubview:actionTitleLabel];

    
    //用流式布局来创建动作菜单布局。流式布局请参考后面关于流式布局的DEMO。
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    actionLayout.wrapContentHeight = YES;
    actionLayout.averageArrange = YES;  //平均分配里面所有子视图的宽度
    actionLayout.subviewHorzMargin = 5;
    actionLayout.subviewVertMargin = 5;  //设置里面子视图的水平和垂直间距。
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [contentLayout addSubview:actionLayout];
    
    NSArray *actions = @[@"左停靠",
                         @"水平居中停靠",
                         @"右停靠",
                         @"上停靠",
                         @"垂直居中停靠",
                         @"下停靠",
                         @"垂直填充",
                         @"屏幕垂直居中停靠",
                         @"屏幕水平居中停靠",
                         @"子视图间距设置"
                         ];
    
    
    for (NSInteger i = 0; i < actions.count; i++)
    {
        [actionLayout addSubview:[self createActionButton:actions[i] tag:(i + 1)* 100 + 1]];
    }

}

-(void)createHorzGravityLayout:(MyLinearLayout*)contentLayout
{
    self.horzGravityLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    self.horzGravityLayout.backgroundColor = [UIColor grayColor];
    self.horzGravityLayout.wrapContentWidth = NO;  //因为默认水平线性布局的宽度由子视图包裹，但这里的宽度由父布局决定的，所有这里必须设置为NO。
    self.horzGravityLayout.myHeight = 100;
    self.horzGravityLayout.myTopMargin = 10;
    self.horzGravityLayout.myLeftMargin = 20;
    self.horzGravityLayout.subviewMargin = 5;  //设置子视图之间的水平间距为5
    [contentLayout addSubview:self.horzGravityLayout];
    
    UILabel *v1 = [UILabel new];
    v1.text = @"测试1";
    v1.backgroundColor = [UIColor redColor];
    v1.numberOfLines = 0;
    [v1 sizeToFit];
    [self.horzGravityLayout addSubview:v1];
    
    UILabel *v2 = [UILabel new];
    v2.text = @"测试2\n测试2";
    v2.backgroundColor = [UIColor greenColor];
    v2.numberOfLines = 0;
    [v2 sizeToFit];
    [self.horzGravityLayout addSubview:v2];
    
    
    UILabel *v3 = [UILabel new];
    v3.text = @"测试3\n测试3\n测试3";
    v3.backgroundColor = [UIColor blueColor];
    v3.numberOfLines = 0;
    [v3 sizeToFit];
    [self.horzGravityLayout addSubview:v3];
    
    UILabel *v4 = [UILabel new];
    v4.text = @"你可以\n自定义\n左右边\n距和宽度";
    v4.backgroundColor = [UIColor orangeColor];
    v4.numberOfLines = 0;
    v4.adjustsFontSizeToFitWidth = YES;
    [v4 sizeToFit];
    v4.myTopMargin = 20;
    v4.myBottomMargin = 10;
    [self.horzGravityLayout addSubview:v4];
}


//创建动作按钮
-(UIButton*)createActionButton:(NSString*)title tag:(NSInteger)tag
{
    UIButton *actionButton = [UIButton new];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    actionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    actionButton.tag = tag;
    [actionButton addTarget:self action:@selector(handleGravity:) forControlEvents:UIControlEventTouchUpInside];
    actionButton.layer.borderColor = [UIColor grayColor].CGColor;
    actionButton.layer.borderWidth = 1.0;
    [actionButton sizeToFit];
    return actionButton;
}


#pragma mark -- Handle Method

-(void)handleGravity:(UIButton*)button
{
    
    switch (button.tag) {
        case 100:  //上
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Top;
            break;
        case 200:  //垂直
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Center;
            break;
        case 300:   //下
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Bottom;
            break;
        case 400:  //左
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Left;
            break;
        case 500:  //水平
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Center;
            break;
        case 600:   //右
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Right;
            break;
        case 700:   //填充
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Fill;
            break;
        case 800:   //窗口垂直居中
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Window_Center;
            break;
        case 900:   //窗口水平居中
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Window_Center;
            break;
        case 1000:
        {
            self.vertGravityLayout.subviewMargin = self.vertGravityLayout.subviewMargin == 10 ? -10 : 10;
            [self.vertGravityLayout layoutAnimationWithDuration:0.3];
        }
            break;
            
        case 101:  //左
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Left;
            break;
        case 201:  //水平
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Center;
            break;
        case 301:   //右
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Right;
            break;
        case 401:  //上
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Top;
            break;
        case 501:  //垂直
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Center;
            break;
        case 601:   //下
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Bottom;
            break;
        case 701:   //填充
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Fill;
            break;
        case 801:   //窗口垂直居中
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Vert_Mask) | MyMarginGravity_Vert_Window_Center;
            break;
        case 901:   //窗口水平居中
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & MyMarginGravity_Horz_Mask) | MyMarginGravity_Horz_Window_Center;
            break;
        case 1001:
        {
            self.horzGravityLayout.subviewMargin = self.horzGravityLayout.subviewMargin == 5 ? -5 : 5;
            [self.horzGravityLayout layoutAnimationWithDuration:0.3];

        }
            break;
 
        default:
            break;
    }
}


-(void)handleNavigationTitleCentre:(id)sender
{
    MyLinearLayout *navigationItemLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    navigationItemLayout.wrapContentHeight = NO;
    navigationItemLayout.wrapContentWidth = NO; //将线性布局放入navigationItem.titleView需要把包裹属性设置为NO。
    
    //通过MyMarginGravity_Horz_Window_Center的设置总是保证在窗口的中间而不是布局视图的中间。
    navigationItemLayout.gravity = MyMarginGravity_Horz_Window_Center | MyMarginGravity_Vert_Center;
    navigationItemLayout.frame = self.navigationController.navigationBar.bounds;
    
    UILabel *topLabel = [UILabel new];
    topLabel.text = @"标题的在具有左边按钮和右边按钮时都可以居中";
    topLabel.adjustsFontSizeToFitWidth = YES;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.myLeftMargin = topLabel.myRightMargin = 10;
    [topLabel sizeToFit];
    [navigationItemLayout addSubview:topLabel];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = self.title;
    [bottomLabel sizeToFit];
    [navigationItemLayout addSubview:bottomLabel];
    
    
    self.navigationItem.titleView = navigationItemLayout;
    
}

-(void)handleNavigationTitleRestore:(id)sender
{
    UILabel *topLabel = [UILabel new];
    topLabel.text = @"标题的在具有左边按钮和右边按钮时都可以居中";
    topLabel.adjustsFontSizeToFitWidth = YES;
    topLabel.textAlignment = NSTextAlignmentCenter;
    [topLabel sizeToFit];
    self.navigationItem.titleView = topLabel;
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

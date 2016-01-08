//
//  Test3ViewController.m
//  YSLayout
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "LLTest3ViewController.h"
#import "YSLayout.h"

@interface LLTest3ViewController ()

@property(nonatomic, strong) YSLinearLayout *vertGravityLayout;
@property(nonatomic, strong) YSLinearLayout *horzGravityLayout;

@end

@implementation LLTest3ViewController


-(void)addVertGravityLayoutItems:(YSLinearLayout*)layout
{
   
    UILabel *v1 = [UILabel new];
    v1.text = @"测试文本1";
    [v1 sizeToFit];
    v1.backgroundColor = [UIColor redColor];
    [layout addSubview:v1];
    
    UILabel *v2 = [UILabel new];
    v2.text = @"测试文本2测试文本2";
    [v2 sizeToFit];
    v2.backgroundColor = [UIColor greenColor];
    [layout addSubview:v2];
    
    
    UILabel *v3 = [UILabel new];
    v3.text = @"测试文本3测试文本3测试文本3";
    [v3 sizeToFit];
    v3.backgroundColor = [UIColor blueColor];
    [layout addSubview:v3];
    
    UILabel *v4 = [UILabel new];
    v4.text = @"你可以自定义左右边距和宽度";
    [v4 sizeToFit];
    v4.backgroundColor = [UIColor orangeColor];
    v4.ysLeftMargin = 20;
    v4.ysRightMargin = 30;
    [layout addSubview:v4];
}

-(void)addHorzGravityLayoutItems:(YSLinearLayout*)layout
{
    
    UILabel *v1 = [UILabel new];
    v1.text = @"测试1";
    v1.numberOfLines = 0;
    [v1 sizeToFit];
    v1.backgroundColor = [UIColor redColor];
    [layout addSubview:v1];
    
    UILabel *v2 = [UILabel new];
    v2.text = @"测试2\n测试2";
    v2.numberOfLines = 0;
    [v2 sizeToFit];
    v2.backgroundColor = [UIColor greenColor];
    [layout addSubview:v2];
    
    
    UILabel *v3 = [UILabel new];
    v3.text = @"测试3\n测试3\n测试3";
    v3.numberOfLines = 0;
    [v3 sizeToFit];
    v3.backgroundColor = [UIColor blueColor];
    [layout addSubview:v3];
    
    UILabel *v4 = [UILabel new];
    v4.text = @"你可以\n自定义\n左右边\n距和宽度";
    v4.numberOfLines = 0;
    v4.adjustsFontSizeToFitWidth = YES;
    [v4 sizeToFit];
    v4.backgroundColor = [UIColor orangeColor];
    v4.ysTopMargin = 20;
    v4.ysBottomMargin = 10;
    [layout addSubview:v4];
}

-(YSFlowLayout*)createVertGravityLayoutActionLayout
{
    //流式布局后面的例子有说明
    YSFlowLayout *flowLayout1 = [YSFlowLayout flowLayoutWithOrientation:YSLayoutViewOrientation_Vert arrangedCount:3];
    flowLayout1.wrapContentHeight = YES;
    flowLayout1.averageArrange = YES;
    flowLayout1.subviewHorzMargin = 5;
    flowLayout1.subviewVertMargin = 5;
    flowLayout1.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UIButton *topButton = [self createActionButton:@"上停靠" tag:100];
    [flowLayout1 addSubview:topButton];
    
    UIButton *centerVertButton = [self createActionButton:@"垂直居中停靠" tag:200];
    [flowLayout1 addSubview:centerVertButton];
    
    
    UIButton *bottomButton = [self createActionButton:@"下停靠" tag:300];
    [flowLayout1 addSubview:bottomButton];
    
    
    UIButton *leftButton = [self createActionButton:@"左停靠" tag:400];
    [flowLayout1 addSubview:leftButton];
    
    UIButton *centerHorzButton = [self createActionButton:@"水平居中停靠" tag:500];
    [flowLayout1 addSubview:centerHorzButton];
    
    UIButton *rightButton = [self createActionButton:@"右停靠" tag:600];
    [flowLayout1 addSubview:rightButton];
    
    UIButton *fillHorzButton = [self createActionButton:@"水平填充" tag:700];
    [flowLayout1 addSubview:fillHorzButton];
    
    UIButton *windowCenterVertButton = [self createActionButton:@"窗口垂直居中停靠" tag:800];
    [flowLayout1 addSubview:windowCenterVertButton];

    UIButton *windowCenterHorzButton = [self createActionButton:@"窗口水平居中停靠" tag:900];
    [flowLayout1 addSubview:windowCenterHorzButton];

    
    UIButton *subviewMarginButton = [self createActionButton:@"子视图间距设置" tag:1000];
    [flowLayout1 addSubview:subviewMarginButton];
    
    
    return flowLayout1;
}

-(YSFlowLayout*)createHorzGravityLayoutActionLayout
{
    //流式布局后面的例子有说明
    YSFlowLayout *flowLayout1 = [YSFlowLayout flowLayoutWithOrientation:YSLayoutViewOrientation_Vert arrangedCount:3];
    flowLayout1.wrapContentHeight = YES;
    flowLayout1.averageArrange = YES;
    flowLayout1.subviewHorzMargin = 5;
    flowLayout1.subviewVertMargin = 5;
    flowLayout1.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    
    UIButton *leftButton = [self createActionButton:@"左停靠" tag:101];
    [flowLayout1 addSubview:leftButton];
    
    UIButton *centerHorzButton = [self createActionButton:@"水平居中停靠" tag:201];
    [flowLayout1 addSubview:centerHorzButton];
    
    UIButton *rightButton = [self createActionButton:@"右停靠" tag:301];
    [flowLayout1 addSubview:rightButton];

    
    UIButton *topButton = [self createActionButton:@"上停靠" tag:401];
    [flowLayout1 addSubview:topButton];
    
    UIButton *centerVertButton = [self createActionButton:@"垂直居中停靠" tag:501];
    [flowLayout1 addSubview:centerVertButton];
    
    
    UIButton *bottomButton = [self createActionButton:@"下停靠" tag:601];
    [flowLayout1 addSubview:bottomButton];
    
    
    UIButton *fillVertButton = [self createActionButton:@"垂直填充" tag:701];
    [flowLayout1 addSubview:fillVertButton];
    
    
    UIButton *windowCenterVertButton = [self createActionButton:@"窗口垂直居中停靠" tag:801];
    [flowLayout1 addSubview:windowCenterVertButton];
    
    UIButton *windowCenterHorzButton = [self createActionButton:@"窗口水平居中停靠" tag:901];
    [flowLayout1 addSubview:windowCenterHorzButton];
    


    
    return flowLayout1;
}



-(UIButton*)createActionButton:(NSString*)title tag:(NSInteger)tag
{
    UIButton *actionButton = [UIButton new];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton sizeToFit];
    [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    actionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    actionButton.tag = tag;
    [actionButton addTarget:self action:@selector(handleGravity:) forControlEvents:UIControlEventTouchUpInside];
    actionButton.layer.borderColor = [UIColor grayColor].CGColor;
    actionButton.layer.borderWidth = 1.0;
    return actionButton;
}


-(void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    YSLinearLayout *rootLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    rootLayout.ysLeftMargin = rootLayout.ysRightMargin = 0;
    [scrollView addSubview:rootLayout];
    
    rootLayout.gravity = YSMarginGravity_Horz_Fill;  //设置这个属性后rootLayout的所有子视图都不需要指定宽度了，这个值的意义是所有子视图的宽度都填充满布局。也就是说设置了这个值后不需要为每个子视图设置ysLeftMargin, ysRightMargin来指定宽度了。
    
    
    UILabel *label1 = [UILabel new];
    label1.text = @"垂直布局里面的停靠控制，您可以点击下面的不同停靠方式的按钮查看效果：";
    label1.flexedHeight = YES;
    label1.adjustsFontSizeToFitWidth = YES;
    [rootLayout addSubview:label1];
    
   
    [rootLayout addSubview:[self createVertGravityLayoutActionLayout]];

    self.vertGravityLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    self.vertGravityLayout.ysHeight = 200;
    self.vertGravityLayout.ysTopMargin = 10;
    self.vertGravityLayout.ysLeftMargin = 20;
    self.vertGravityLayout.subviewMargin = 10;
    
    self.vertGravityLayout.backgroundColor = [UIColor grayColor];
    [rootLayout addSubview:self.vertGravityLayout];
    
    [self addVertGravityLayoutItems:self.vertGravityLayout];
    
    
    
    UILabel *label2 = [UILabel new];
    label2.text = @"水平布局里面的停靠控制，您可以点击下面的不同停靠方式的按钮查看效果：";
    label2.flexedHeight = YES;
    label2.adjustsFontSizeToFitWidth = YES;
    [rootLayout addSubview:label2];
    
    [rootLayout addSubview:[self createHorzGravityLayoutActionLayout]];
    
    self.horzGravityLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Horz];
    self.horzGravityLayout.wrapContentWidth = NO;
    self.horzGravityLayout.ysHeight = 100;
    self.horzGravityLayout.ysTopMargin = 10;
    self.horzGravityLayout.ysLeftMargin = 20;
    self.horzGravityLayout.subviewMargin = 5;
    
    self.horzGravityLayout.backgroundColor = [UIColor grayColor];
    [rootLayout addSubview:self.horzGravityLayout];
    
    [self addHorzGravityLayoutItems:self.horzGravityLayout];
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  self.title = @"线性布局-子视图的位置停靠";
    
    
    [self handleNavTitleCenter:nil];
    //   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"居中标题" style:UIBarButtonItemStylePlain target:self action:@selector(handleNavTitleCenter:) ],[[UIBarButtonItem alloc] initWithTitle:@"原始" style:UIBarButtonItemStylePlain target:self action:@selector(handleNavTitleDefault:)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Handle Method

-(void)handleGravity:(UIButton*)button
{
    switch (button.tag) {
        case 100:  //上
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Top;
            break;
        case 200:  //垂直
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Center;
            break;
        case 300:   //下
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Bottom;
            break;
        case 400:  //左
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Left;
            break;
        case 500:  //水平
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Center;
            break;
        case 600:   //右
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Right;
            break;
        case 700:   //填充
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Fill;
            break;
        case 800:   //窗口垂直居中
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Window_Center;
            break;
        case 900:   //窗口水平居中
            self.vertGravityLayout.gravity = (self.vertGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Window_Center;
            break;
        case 1000:
        {
            self.vertGravityLayout.subviewMargin = self.vertGravityLayout.subviewMargin == 10 ? -10 : 10;
            
            self.vertGravityLayout.beginLayoutBlock=^{
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                
            };
            
            self.vertGravityLayout.endLayoutBlock=^{
                
                [UIView commitAnimations];
                
            };
            

            
        }
            break;
            
        case 101:  //左
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Left;
            break;
        case 201:  //水平
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Center;
            break;
        case 301:   //右
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Right;
            break;
        case 401:  //上
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Top;
            break;
        case 501:  //垂直
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Center;
            break;
        case 601:   //下
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Bottom;
            break;
        case 701:   //填充
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Fill;
            break;
        case 801:   //窗口垂直居中
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Vert_Mask) | YSMarginGravity_Vert_Window_Center;
            break;
        case 901:   //窗口水平居中
            self.horzGravityLayout.gravity = (self.horzGravityLayout.gravity & YSMarginGravity_Horz_Mask) | YSMarginGravity_Horz_Window_Center;
            break;
 
        default:
            break;
    }
}

#pragma mark -- Handle Method
-(void)handleNavTitleCenter:(id)sender
{
    YSLinearLayout *navigationItemLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    navigationItemLayout.wrapContentHeight = navigationItemLayout.wrapContentWidth = NO;
    
    //通过YSMarginGravity_Horz_Window_Center的设置总是保证在窗口的中间而不是布局视图的中间。
    navigationItemLayout.gravity = YSMarginGravity_Horz_Window_Center | YSMarginGravity_Vert_Center;
    navigationItemLayout.frame = self.navigationController.navigationBar.bounds;
    
    UILabel *topLabel = [UILabel new];
    topLabel.text = @"标题的在具有左边按钮和右边按钮时都可以居中";
    topLabel.adjustsFontSizeToFitWidth = YES;
    topLabel.textAlignment = NSTextAlignmentCenter;
    
    topLabel.ysLeftMargin = topLabel.ysRightMargin = 10;
    [topLabel sizeToFit];
    [navigationItemLayout addSubview:topLabel];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"线性布局-子视图停靠";
    
    [bottomLabel sizeToFit];
    [navigationItemLayout addSubview:bottomLabel];
    
    
    self.navigationItem.titleView = navigationItemLayout;
    
}

-(void)handleNavTitleDefault:(id)sender
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

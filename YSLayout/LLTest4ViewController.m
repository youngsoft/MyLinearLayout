//
//  Test4ViewController.m
//  YSLayout
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "LLTest4ViewController.h"
#import "YSLayout.h"

@interface LLTest4ViewController ()

@property(nonatomic,strong) YSLinearLayout *rootLayout;

@end

@implementation LLTest4ViewController


-(UIButton*)addActionButton:(NSString *)title tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;

    button.ysHeight = 50;
    button.ysWidth = 90;
    
    return button;
}

-(YSLinearLayout*)addActionLayout
{
    
 
    YSLinearLayout *actionLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Horz];
    actionLayout.backgroundColor = [UIColor redColor];
    
    actionLayout.wrapContentHeight = YES;
    actionLayout.wrapContentWidth = YES;  //布局的高度和宽度由子视图决定
    actionLayout.ysPadding = UIEdgeInsetsMake(5, 5, 5, 5);
    actionLayout.subviewMargin = 5;

    //四周的边线
    YSBorderLineDraw *bl = [[YSBorderLineDraw alloc] initWithColor:[UIColor greenColor]];
    bl.headIndent = 10;
    bl.tailIndent = 30;
    bl.thick = 1;
    actionLayout.bottomBorderLine = bl;
    actionLayout.topBorderLine = bl;
    actionLayout.leftBorderLine = bl;
    actionLayout.rightBorderLine = bl;
    
    
    
    YSLinearLayout *addLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    addLayout.backgroundColor = [UIColor blueColor];
    
    addLayout.ysPadding = UIEdgeInsetsMake(5, 5, 5, 5);
    addLayout.subviewMargin = 5;
    addLayout.wrapContentWidth = YES;
    addLayout.wrapContentHeight = YES;  //布局的高度和宽度由子视图决定
    [actionLayout addSubview:addLayout];
    
    
    
    [addLayout addSubview:[self addActionButton:@"添加垂直布局" tag:100]];
    [addLayout addSubview:[self addActionButton:@"添加垂直按钮" tag:500]];

    
    [actionLayout addSubview:[self addActionButton:@"添加水平按钮" tag:200]];
    [actionLayout addSubview:[self addActionButton:@"删除自身布局" tag:300]];
    
    return actionLayout;
}


-(void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    
    self.rootLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    self.rootLayout.backgroundColor = [UIColor grayColor];
    self.rootLayout.wrapContentHeight = YES;
    self.rootLayout.wrapContentWidth = YES;  //布局的高度和宽度由子视图决定
    self.rootLayout.ysPadding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.rootLayout.subviewMargin = 5;
    [self.view addSubview:self.rootLayout];
    
    [self.rootLayout addSubview:[self addActionLayout]];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"线性布局-布局尺寸由子视图决定";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleAction:(UIButton*)sender
{
    
    if (sender.tag == 100)
    {
        [self.rootLayout addSubview:[self addActionLayout]];
    }
    else if (sender.tag == 200)
    {
        YSLinearLayout*actionLayout = (YSLinearLayout*)sender.superview;
        [actionLayout addSubview:[self addActionButton:@"删除自己" tag:400]];
    }
    else if (sender.tag == 300)
    {
         YSLinearLayout*actionLayout = (YSLinearLayout*)sender.superview;
        [actionLayout removeFromSuperview];
    }
    else if (sender.tag == 400)
    {
        [sender removeFromSuperview];
    }
    else if (sender.tag == 500)
    {
        YSLinearLayout*addLayout = (YSLinearLayout*)sender.superview;
        [addLayout addSubview:[self addActionButton:@"删除自己" tag:400]];

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

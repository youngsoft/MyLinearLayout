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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MyLinearLayout *layout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    layout.backgroundColor = [UIColor redColor];
    layout.gravity = MyGravity_Horz_Center;
    layout.padding = UIEdgeInsetsMake(15, 0, 0, 0);
    layout.subviewVSpace = 12;
    layout.myHorzMargin = 0;
    layout.myTop = 100;
    [self.view addSubview:layout];
    
    
    UILabel *timeLabel = UILabel.new;
    timeLabel.myHorzMargin = 0;
    timeLabel.wrapContentHeight = YES;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = @"剩余时间为";
    [layout addSubview:timeLabel];
    
    // 汇率
    MyLinearLayout *convertLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    convertLayout.backgroundColor = [UIColor greenColor];
    convertLayout.wrapContentHeight = YES;
    convertLayout.gravity = MyGravity_Vert_Center;
    convertLayout.subviewHSpace = 7;
    [layout addSubview:convertLayout];
    
    NSArray *items = @[@"$454", @"^sdsf"];
    for (int i=0; i<items.count; i++) {
        UILabel *label = UILabel.new;
        label.wrapContentSize = YES;
        label.text = items[i];
        label.font = [UIFont systemFontOfSize:28];
        [convertLayout addSubview:label];
        
        if (i==0) {
           
            UILabel *btn = [UILabel new];
            btn.wrapContentSize = YES;
            btn.text = @"->";
            [convertLayout addSubview:btn];
        }
    }
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

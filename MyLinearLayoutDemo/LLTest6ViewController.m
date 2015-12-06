//
//  Test6ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "LLTest6ViewController.h"
#import "MyLayout.h"

@interface LLTest6ViewController ()<UITextViewDelegate>

@end

@implementation LLTest6ViewController

-(void)loadView
{
    
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    rootLayout.backgroundColor = [UIColor grayColor];
    [rootLayout setTarget:self action:@selector(handleHideKeyboard:)];
    
    
    rootLayout.wrapContentHeight = NO;
    rootLayout.wrapContentWidth = NO;
    self.view = rootLayout;
    
    UILabel *labe1 = [UILabel new];
    labe1.text = @"用户信息";
    [labe1 sizeToFit];
    labe1.topMargin = 10;
    labe1.centerXOffset = 0;
    [rootLayout addSubview:labe1];
    
    
    
    //头像
    UIImageView *imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:@"head1"];
    imgView.backgroundColor = [UIColor whiteColor];
    [imgView sizeToFit];
    
    //距离顶部间隙剩余空间的35%，水平居中对齐。
    imgView.topMargin = 0.25;
    imgView.centerXOffset = 0;
    [rootLayout addSubview:imgView];
    
    
    //用户信息
    UITextField *txtField = [UITextField new];
    txtField.borderStyle = UITextBorderStyleLine;
    txtField.placeholder = @"请输入用户名称";
    txtField.textAlignment = NSTextAlignmentCenter;
    txtField.backgroundColor = [UIColor whiteColor];
    
    //高度为40，左右间距为布局的10%, 顶部间距为剩余空间的10%
    txtField.height = 40;
    txtField.leftMargin = 0.1;
    txtField.rightMargin = 0.1;
    txtField.topMargin = 0.1;
    [rootLayout addSubview:txtField];
    
    
    //用户描述
    UILabel *label2 = [UILabel new];
    label2.text = @"描述信息";
    
    [label2 sizeToFit];
    label2.topMargin = 10;
    label2.leftMargin = 0.05;
    [rootLayout addSubview:label2];
    
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = @"请尝试在这里连续输入文字以及换行的效果";
    textView.delegate = self;
    
    //左右间距为布局的10%，距离底部间距为65%,浮动高度，但高度最高为300，最低为30
    //flexedHeight和max,min的结合能做到一些完美的自动伸缩功能。
    textView.leftMargin = 0.05;
    textView.rightMargin = 0.05;
    textView.bottomMargin = 0.65;
    textView.flexedHeight = YES;
    textView.heightDime.max(300).min(60);
    [rootLayout addSubview:textView];
    
    
    
    UILabel *label3 = [UILabel new];
    label3.text = @"版权所有 XXX 公司";
    
    //总是固定在底部20的边距
    label3.bottomMargin = 20;
    label3.centerXOffset = 0;
    [label3 sizeToFit];
    [rootLayout addSubview:label3];
    
    
    
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    //让布局视图重新布局。
    [textView.superview setNeedsLayout];
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"线性布局-视图之间的浮动间距";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- Handle Method

-(void)handleHideKeyboard:(id)sender
{
    [self.view endEditing:YES];
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

//
//  Test9ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test9ViewController.h"
#import "MyLayout.h"

@interface Test9ViewController ()

@end

@implementation Test9ViewController

-(void)loadView
{
    
    
    MyLinearLayout *ll = [MyLinearLayout new];
    ll.backgroundColor = [UIColor grayColor];
    ll.wrapContentHeight = NO;
    ll.gravity = MGRAVITY_HORZ_CENTER;
    
    //头像
    UIImageView *imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:@"user"];
    imgView.backgroundColor = [UIColor whiteColor];
    [imgView sizeToFit];
    
    imgView.topMargin = 0.45;
    
    [ll addSubview:imgView];
    
    
    //输入框
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    txtField.borderStyle = UITextBorderStyleLine;
    txtField.placeholder = @"请输入用户名称";
    txtField.backgroundColor = [UIColor whiteColor];
    
    
    txtField.topMargin = 0.1;
    txtField.bottomMargin = 0.45;
    [ll addSubview:txtField];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lab.bottomMargin = 20;
    lab.text = @"版权所有 XXX 公司";
    [lab sizeToFit];
    
    [ll addSubview:lab];
    
    
    self.view = ll;
    
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视图之间的浮动间距";
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

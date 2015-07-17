//
//  Test1ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "Test1ViewController.h"
#import "MyLayout.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

-(UIView*)createView:(BOOL)wrapContentHeight
{
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 100,200)];
    ll.orientation = LVORIENTATION_VERT;
    ll.leftPos.equalTo(@10);
    ll.wrapContentHeight = wrapContentHeight;
    ll.backgroundColor = [UIColor grayColor];
    

    //不需要设置frame值了
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    v1.topPos.equalTo(@4);
    v1.leftPos.equalTo(@10);
    v1.widthDime.equalTo(@60);
    v1.heightDime.equalTo(@40);
    [ll addSubview:v1];
    
   /* [v1 makeLayout:^(MyMaker *make) {
       
        make.top.equalTo(@4);
        make.left.equalTo(@10);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];*/
    
    
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor greenColor];
    v2.topPos.equalTo(@6);
    v2.leftPos.equalTo(@20);
    v2.widthDime.equalTo(@40);
    v2.heightDime.equalTo(@60);
    [ll addSubview:v2];
    
    
    //您也可以不设置widthDime,heightDime而是直接设置frame的宽度和高度
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    v3.backgroundColor = [UIColor blueColor];
    v3.topPos.equalTo(@3);
    v3.leftPos.equalTo(@15);
    v3.bottomPos.equalTo(@4);
    [ll addSubview:v3];
    
    
    return ll;
}

-(void)loadView
{
    
    MyLinearLayout *test1ll = [MyLinearLayout new];
    test1ll.orientation = LVORIENTATION_HORZ; //水平布局
    test1ll.gravity = MGRAVITY_HORZ_CENTER;   //本视图里面的所有子视图整体水平和垂直居中
    self.view = test1ll;

    
    //标尺视图
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor blackColor];
    v.widthDime.equalTo(@10);
    v.heightDime.equalTo(@200);
    [test1ll addSubview:v];
    
    [test1ll addSubview:[self createView:NO]];
    [test1ll addSubview:[self createView:YES]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"子视图的布局和自动调整大小";
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

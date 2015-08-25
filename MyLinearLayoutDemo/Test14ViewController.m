//
//  Test14ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test14ViewController.h"
#import "MyLayout.h"

@interface Test14ViewController ()

@end

@implementation Test14ViewController



-(void)loadView
{
    MyRelativeLayout *rl = [MyRelativeLayout new];
    rl.padding = UIEdgeInsetsMake(0, 0, 0, 10);
    rl.backgroundColor = [UIColor grayColor];
    self.view = rl;
    
    /**水平平分3个子视图**/
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    v1.heightDime.equalTo(@40);
    [rl addSubview:v1];
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor redColor];
    v2.heightDime.equalTo(@40);
    [rl addSubview:v2];

    UIView *v3 = [UIView new];
    v3.backgroundColor = [UIColor redColor];
    v3.heightDime.equalTo(@40);
    [rl addSubview:v3];

    //v1,v2,v3平分父视图的宽度。在平分前减去了30用作间距
    v1.widthDime.equalTo(@[v2.widthDime.add(-10), v3.widthDime.add(-10)]).add(-10);
    v1.leftPos.offset(10);
    v2.leftPos.equalTo(v1.rightPos).offset(10);
    v3.leftPos.equalTo(v2.rightPos).offset(10);
    

    /**某个视图固定其他平分**/
    UIView *v4 = [UIView new];
    v4.backgroundColor = [UIColor greenColor];
    v4.topPos.equalTo(v1.bottomPos).offset(80);
    v4.heightDime.equalTo(@40);
    v4.widthDime.equalTo(@260); //第一个视图宽度固定
    [rl addSubview:v4];
    
    UIView *v5 = [UIView new];
    v5.backgroundColor = [UIColor greenColor];
    v5.topPos.equalTo(v4.topPos);
    v5.heightDime.equalTo(@40);
    [rl addSubview:v5];
    
    UIView *v6 = [UIView new];
    v6.backgroundColor = [UIColor greenColor];
    v6.topPos.equalTo(v4.topPos);
    v6.heightDime.equalTo(@40);
    [rl addSubview:v6];
    
    //v1,v2,v3平分父视图的宽度。在平分前减去了30用作间距
    v5.widthDime.equalTo(@[v4.widthDime.add(-10), v6.widthDime.add(-10)]).add(-10);
    v4.leftPos.offset(10);
    v5.leftPos.equalTo(v4.rightPos).offset(10);
    v6.leftPos.equalTo(v5.rightPos).offset(10);
    
    
 
    
    /**子视图按比例平分**/
    UIView *v7 = [UIView new];
    v7.backgroundColor = [UIColor blueColor];
    v7.topPos.equalTo(v4.bottomPos).offset(80);
    v7.heightDime.equalTo(@40);
    [rl addSubview:v7];
    
    UIView *v8 = [UIView new];
    v8.backgroundColor = [UIColor blueColor];
    v8.topPos.equalTo(v7.topPos);
    v8.heightDime.equalTo(@40);
    [rl addSubview:v8];
    
    UIView *v9 = [UIView new];
    v9.backgroundColor = [UIColor blueColor];
    v9.topPos.equalTo(v7.topPos);
    v9.heightDime.equalTo(@40);
    [rl addSubview:v9];
    
    v7.widthDime.equalTo(@[v8.widthDime.multiply(0.3).add(-10),v9.widthDime.multiply(0.5).add(-10)]).multiply(0.2).add(-10);
    v7.leftPos.offset(10);
    v8.leftPos.equalTo(v7.rightPos).offset(10);
    v9.leftPos.equalTo(v8.rightPos).offset(10);
    
    //请分别设置每个视图.hidden = YES 并且设置布局的@property(nonatomic, assign) BOOL flexOtherViewWidthWhenSubviewHidden为YES和NO的效果

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相对布局2-子视图之间尺寸分配";
    
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

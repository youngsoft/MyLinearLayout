//
//  Test7ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test7ViewController.h"
#import "MyLayout.h"

@interface Test7ViewController ()

@end

@implementation Test7ViewController

-(void)loadView
{
    //线性布局实现相对子视图
    MyLinearLayout *ll = [MyLinearLayout new];
    //保证容器和视图控制的视图的大小进行伸缩调整。
    ll.orientation = LVORIENTATION_VERT;
    ll.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    ll.backgroundColor = [UIColor grayColor];
    
    MyLinearLayout *topll = MyLinearLayout.new;
    topll.orientation = LVORIENTATION_HORZ;
    topll.weight = 0.5;
    topll.leftMargin = topll.rightMargin = 0;
    
    UIView *topLeft = UIView.new;
    topLeft.backgroundColor = [UIColor redColor];
    topLeft.weight = 0.5;
    topLeft.topMargin = topLeft.bottomMargin = 0;
    [topll addSubview:topLeft];
    
    UIView *topRight = UIView.new;
    topRight.backgroundColor = [UIColor greenColor];
    topRight.weight = 0.5;
    topRight.topMargin = topRight.bottomMargin = 0;
    topRight.leftMargin = 20;
    [topll addSubview:topRight];
    
    [ll addSubview:topll];
    
    
    UIView *bottom = UIView.new;
    bottom.backgroundColor = [UIColor blueColor];
    bottom.weight = 0.5;
    bottom.widthDime.equalTo(ll.widthDime);
    bottom.leftMargin = bottom.rightMargin = 0;
    bottom.topMargin = 20;
    [ll addSubview:bottom];
    
    
    self.view = ll;

    //下面是采用相对布局的方式进行布局，可以看到相对布局的代码比较少一些，缺点是在进行布局时需要对视图之间的关系要非常清楚
    //采用线性布局的优点是不需要考虑视图之间的关系，但代码多了一些。
 /*   MyRelativeLayout *ll = [MyRelativeLayout new];
    ll.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    ll.backgroundColor = [UIColor grayColor];
    
    UIView *topLeft = [UIView new];
    topLeft.backgroundColor = [UIColor redColor];
    
    UIView *topRight = [UIView new];
    topRight.backgroundColor = [UIColor greenColor];
    
    UIView *bottom = [UIView new];
    bottom.backgroundColor = [UIColor blueColor];
    
    [ll addSubview:topLeft];
    [ll addSubview:topRight];
    [ll addSubview:bottom];
    
    //上下高度平分，高度等于 = 父视图高度 - 20 再平分
    topLeft.heightDime.equalTo(@[bottom.heightDime]).add(-20);
    topLeft.widthDime.equalTo(@[topRight.widthDime]).add(-20);
    topRight.leftPos.equalTo(topLeft.rightPos).offset(20);
    topRight.heightDime.equalTo(topLeft.heightDime);
    bottom.topPos.equalTo(topLeft.bottomPos).offset(20);
    bottom.leftPos.equalTo(ll.leftPos);
    bottom.rightPos.equalTo(ll.rightPos);
    
    
    self.view = ll;*/
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相对视图尺寸";
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

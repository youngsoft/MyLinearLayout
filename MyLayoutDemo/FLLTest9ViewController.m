//
//  FLLTest9ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "FLLTest9ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLLTest9ViewController ()

@property(nonatomic, strong) MyFlowLayout *vertContentLayout;
@property(nonatomic, strong) MyFlowLayout *horzContentLayout;

@end

@implementation FLLTest9ViewController

-(void)loadView
{
    /*
       这个例子主要演示流式布局中进行行内的自定义停靠对齐属性lineGravity的使用方法。一般情况下我们可以通过gravity来设置布局内所有行的停靠特性，而通过arrangedGravity来设置行内的对齐特性。而如果我们想自定义某行的停靠和对齐特性时则需要实现lineGravity这个block。
     
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    rootLayout.isFlex = YES;
    rootLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    rootLayout.subviewSpace = 5;
    self.view = rootLayout;
    
    [self createVertContentLayout:rootLayout];
    
    [self createHorzContentLayout:rootLayout];
  
}

-(void)createVertContentLayout:(MyFlowLayout*)rootLayout
{
    UIButton *vertLayoutItemAddButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [vertLayoutItemAddButon addTarget:self action:@selector(handleVertLayoutItemAdd:) forControlEvents:UIControlEventTouchUpInside];
    [vertLayoutItemAddButon setTitle:@"Add" forState:UIControlStateNormal];
    [rootLayout addSubview:vertLayoutItemAddButon];
    vertLayoutItemAddButon.weight = 1.0;
    vertLayoutItemAddButon.heightSize.equalTo(@(40));
    
    UIButton *vertLayoutItemRemoveButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [vertLayoutItemRemoveButon addTarget:self action:@selector(handleVertLayoutItemRemove:) forControlEvents:UIControlEventTouchUpInside];
    [vertLayoutItemRemoveButon setTitle:@"Remove" forState:UIControlStateNormal];
    [rootLayout addSubview:vertLayoutItemRemoveButon];
    vertLayoutItemRemoveButon.weight = 1.0;
    vertLayoutItemRemoveButon.heightSize.equalTo(@(40));
    
    MyFlowLayout *vertContentLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:1];
    [rootLayout addSubview:vertContentLayout];
    vertContentLayout.widthSize.equalTo(rootLayout.widthSize);
    vertContentLayout.heightSize.equalTo(vertContentLayout.widthSize).multiply(3.0/5);
    vertContentLayout.gravity = MyGravity_Horz_Fill | MyGravity_Vert_Center;
    //单独设置行内的停靠方向。
    vertContentLayout.lineGravity = ^MyGravity(MyFlowLayout *layout, NSInteger lineIndex, NSInteger itemCount, BOOL isLastLine) {
        
        //只有当布局视图的子视图数量为3个，并且是最后一行时才水平居中，否则其他返回默认的停靠值
        if (layout.subviews.count == 3 && isLastLine)
            return MyGravity_Horz_Center;
        else
            return MyGravity_None;
    };
    
    self.vertContentLayout = vertContentLayout;
    self.vertContentLayout.backgroundColor = [UIColor lightGrayColor];
}

-(void)createHorzContentLayout:(MyFlowLayout*)rootLayout
{
    UIButton *horzLayoutItemAddButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [horzLayoutItemAddButon addTarget:self action:@selector(handleHorzLayoutItemAdd:) forControlEvents:UIControlEventTouchUpInside];
    [horzLayoutItemAddButon setTitle:@"Add" forState:UIControlStateNormal];
    [rootLayout addSubview:horzLayoutItemAddButon];
    horzLayoutItemAddButon.weight = 1.0;
    horzLayoutItemAddButon.heightSize.equalTo(@(40));
    
    UIButton *horzLayoutItemRemoveButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [horzLayoutItemRemoveButon addTarget:self action:@selector(handleHorzLayoutItemRemove:) forControlEvents:UIControlEventTouchUpInside];
    [horzLayoutItemRemoveButon setTitle:@"Remove" forState:UIControlStateNormal];
    [rootLayout addSubview:horzLayoutItemRemoveButon];
    horzLayoutItemRemoveButon.weight = 1.0;
    horzLayoutItemRemoveButon.heightSize.equalTo(@(40));
    
    MyFlowLayout *horzContentLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:1];
    [rootLayout addSubview:horzContentLayout];
    horzContentLayout.widthSize.equalTo(rootLayout.widthSize);
    horzContentLayout.heightSize.equalTo(horzContentLayout.widthSize).multiply(3.0/5);
    horzContentLayout.gravity = MyGravity_Vert_Fill | MyGravity_Horz_Center;
    horzContentLayout.lineGravity = ^MyGravity(MyFlowLayout *layout, NSInteger lineIndex, NSInteger itemCount, BOOL isLastLine) {
        
        //只有当布局视图的子视图数量为3个，并且是最后一行时才水平居中，否则其他返回默认的停靠值
        if (layout.subviews.count == 3 && isLastLine)
            return MyGravity_Vert_Center;
        else
            return MyGravity_None;
    };
    
    self.horzContentLayout = horzContentLayout;
    self.horzContentLayout.backgroundColor = [UIColor lightGrayColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark -- Handler

-(void)handleVertLayoutItemAdd:(id)sender
{
    UILabel *itemView = [UILabel new];
    itemView.backgroundColor = [CFTool color:arc4random_uniform(14) + 1];
    itemView.text = [NSString stringWithFormat:@"%ld", self.vertContentLayout.subviews.count];
    itemView.textAlignment = NSTextAlignmentCenter;
    [self.vertContentLayout addSubview:itemView];
    
    
    //1个就1，小于等于4个就2， 小于等于9个就3， 小于等于16个就4
    //也就是每行的数量是大于子视图数量开根的最小整数。
    self.vertContentLayout.arrangedCount = ceil(sqrt(self.vertContentLayout.subviews.count));
    //这里启用分页功能，这样子视图的高度将会被自动计算出来。
    self.vertContentLayout.pagedCount = self.vertContentLayout.arrangedCount * self.vertContentLayout.arrangedCount;
}

-(void)handleVertLayoutItemRemove:(id)sender
{
    [self.vertContentLayout.subviews.lastObject removeFromSuperview];
    //1个就1，小于等于4个就2， 小于等于9个就3， 小于等于16个就4
    //也就是每行的数量是大于子视图数量开根的最小整数。
    self.vertContentLayout.arrangedCount = ceil(sqrt(self.vertContentLayout.subviews.count));
    self.vertContentLayout.pagedCount = self.vertContentLayout.arrangedCount * self.vertContentLayout.arrangedCount;
}

-(void)handleHorzLayoutItemAdd:(id)sender
{
    UILabel *itemView = [UILabel new];
    itemView.backgroundColor = [CFTool color:arc4random_uniform(14) + 1];
    itemView.text = [NSString stringWithFormat:@"%ld", self.horzContentLayout.subviews.count];
    itemView.textAlignment = NSTextAlignmentCenter;
    [self.horzContentLayout addSubview:itemView];
    
    
    //1个就1，小于等于4个就2， 小于等于9个就3， 小于等于16个就4
    //也就是每行的数量是大于子视图数量开根的最小整数。
    self.horzContentLayout.arrangedCount = ceil(sqrt(self.horzContentLayout.subviews.count));
    //这里启用分页功能，这样子视图的高度将会被自动计算出来。
    self.horzContentLayout.pagedCount = self.horzContentLayout.arrangedCount * self.horzContentLayout.arrangedCount;
}

-(void)handleHorzLayoutItemRemove:(id)sender
{
    [self.horzContentLayout.subviews.lastObject removeFromSuperview];
    //1个就1，小于等于4个就2， 小于等于9个就3， 小于等于16个就4
    //也就是每行的数量是大于子视图数量开根的最小整数。
    self.horzContentLayout.arrangedCount = ceil(sqrt(self.horzContentLayout.subviews.count));
    self.horzContentLayout.pagedCount = self.horzContentLayout.arrangedCount * self.horzContentLayout.arrangedCount;
}

@end

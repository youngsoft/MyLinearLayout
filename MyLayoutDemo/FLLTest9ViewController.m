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
       这个例子主要演示流式布局中进行行内的自定义停靠对齐属性lineGravity的使用方法。
         在垂直流式布局中，我们可以通过gravity来设置每行的水平停靠对齐特性，并通过arrangedGravity来设置每行行内的垂直停靠对齐特性。
         在水平流式布局中，我们可以通过gravity来设置每列的垂直停靠对齐特性，并通过arrangedGravity来设置每列列内的水平停靠对齐特性。
     
         而如果我们想自定义某行或者某列的水平和垂直停靠对齐特性时则可以通过lineGravity来实现，lineGravity是一个block方法。这个方法的入参有布局对象、行的索引、行内条目的数量、是否是最后一行标志。而方法的返回则是这一行内的水平和垂直停靠对齐特性。如果某个方向返回MyGravity_None则表明用布局指定的gravity和arrangedGravity设置的值。
     
            比如在一个垂直流式布局中所有行都是右停靠，并且每行内都是垂直居中对齐。但是我们又想将其中的第1行设置为左停靠，并且是底部对齐。那么我们就可以进行如下设置：
     layout.gravity = MyGravity_Horz_Right;    //整体右停靠
     layout.arrangedGravity = MyGravity_Vert_Center;  //每行都是垂直居中对齐
     layout.lineGravity = ^(MyFlowLayout *layout, NSInteger lineIndex, NSInteger itemCount, BOOL isLastLine)
     {
         if (lineIndex == 1)
             return MyGravity_Horz_Left | MyGravity_Vert_Bottom;  //第一行左边停靠并且底部对齐
         else
            return MyGravity_None;
     };
     
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    rootLayout.isFlex = YES;   //这个属性设置为YES表明让流式布局兼容flexbox的一些特性。
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
    vertLayoutItemAddButon.weight = 1.0;   //两个按钮的比重为1表明平分宽度。
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
    vertContentLayout.gravity = MyGravity_Horz_Fill | MyGravity_Vert_Center;  //整体水平填充和垂直居中
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
    //这里子视图不需要设置任何宽高约束。
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

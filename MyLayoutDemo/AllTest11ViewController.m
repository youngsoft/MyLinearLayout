//
//  AllTest11ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "AllTest11ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface AllTest11ViewController ()

@property(nonatomic, strong) MyBaseLayout *contentLayout;  //对于布局视图来说，所有种类布局的布局视图都支持layoutTransform属性。

@end

@implementation AllTest11ViewController

-(void)loadView
{
    /*
     
      这个DEMO主要用来演示布局视图的layoutTransform属性的使用和设置方法，这个属性用来对布局视图内所有子视图的位置进行坐标变换。只要你了解CGAffineTransform的设置和使用
     方法，就可以用他来进行各种布局视图内子视图的整体的坐标变换，比如：平移、缩放、水平反转、垂直反转、旋转等以及一些复合的坐标变换。在下面的例子里面我分别列举了一些常见的布局位置
     坐标变换的设置方法以及参数。
     
     
     当你的布局内所有视图都需要有统一的变换的动画时，你可以借助layoutTransform属性并且配合layoutAnimationWithDuration方法来实现动画效果。
     
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.gravity = MyGravity_Horz_Fill; //里面所有子视图的宽度都填充为和父视图一样宽。
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    //添加操作按钮。
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    actionLayout.wrapContentHeight = YES;
    actionLayout.gravity = MyGravity_Horz_Fill;  //所有子视图水平填充，也就是所有子视图的宽度相等。
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    actionLayout.subviewHSpace = 5;
    actionLayout.subviewVSpace = 5;
    [rootLayout addSubview:actionLayout];
    
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"Identity", @"")
                                               action:@selector(handleIdentityTransform:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"Translation", @"")
                                               action:@selector(handleTranslationTransform:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"Scale", @"")
                                               action:@selector(handleScaleTransform:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"Horz Reflection", @"")
                                               action:@selector(handleHorzReflectionTransform:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"Vert Reflection", @"")
                                               action:@selector(handleVertReflectionTransform:)]];
    [actionLayout addSubview:[self createActionButton:NSLocalizedString(@"Reverse", @"")
                                               action:@selector(handleReverseTransform:)]];
    
    
    //下面是用于测试的layoutTransform属性的布局视图，本系统中的所有布局视图都支持layoutTransform属性。
    MyFlowLayout *contentLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:4];
    contentLayout.backgroundColor = [CFTool color:5];
    contentLayout.weight = 1.0;  //占用线性布局中的剩余高度。
    contentLayout.subviewSpace = 10;
    [rootLayout addSubview:contentLayout];
    self.contentLayout = contentLayout;
    
    for (int i = 0; i < 14; i++)
    {
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%d", i];
        label.backgroundColor = [UIColor redColor];
        label.mySize = CGSizeMake(40, 40);
        label.textAlignment = NSTextAlignmentCenter;
        [contentLayout addSubview:label];
    }
    
    
    
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

#pragma mark -- Layout Construction

//创建动作操作按钮。
-(UIButton*)createActionButton:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [CFTool font:14];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.myHeight = 30;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5;
    
    return button;
    
}

#pragma mark -- Handle Method

-(void)handleIdentityTransform:(id)sender
{
    //还原位置的坐标变换，这也是默认值。
    self.contentLayout.layoutTransform = CGAffineTransformIdentity;
    [self.contentLayout layoutAnimationWithDuration:0.3];
}

-(void)handleTranslationTransform:(id)sender
{
    //子视图的整体水平和垂直的平移变换。
    static BOOL flag = YES;
    if (flag)
        self.contentLayout.layoutTransform = CGAffineTransformMakeTranslation(100, 0);
    else
        self.contentLayout.layoutTransform = CGAffineTransformMakeTranslation(100, 100);

    flag = !flag;
        
    [self.contentLayout layoutAnimationWithDuration:0.3];
}

-(void)handleScaleTransform:(id)sender
{
    //布局内子视图位置的放大和缩小的位置变换。因为缩放是以布局视图的中心点为中心进行缩放的，所以如果是想要以某个点为中心进行缩放。所以在缩放的同时还需要进行位移的调整。
    //下面的例子里面，因为缩放默认是以布局视图的中心点为中心进行缩放，但这里是想以第一个子视图保持不变而进行缩放，所以除了要进行缩放外，还需要调整所有子视图的偏移，因为第一个
    //子视图的中心点的位置按照布局视图中心点原点坐标的话位置是：  (20 - 布局视图的宽度/2, 20 - 布局视图的高度/2)，  这里的20是因为视图的高度都是40。
    //所以只要保证第一个子视图的中心点在放大后的位置还是一样，就会实现以第一个子视图为中心进行放大的效果。

    
    CGSize size = self.contentLayout.frame.size;

    //缩放因子。
    static CGFloat factor = 2;
    self.contentLayout.layoutTransform =  CGAffineTransformMake(factor, 0, 0, factor, (1 - factor) * (20 - size.width / 2.0), (1 - factor) * (20 - size.height / 2));   //这里因为要让第一个子视图的位置保持不变，所以tx,ty参数需要进行特殊设置。
    
    if (factor == 2)
        factor = 0.9;
    else
        factor = 2;
    
    [self.contentLayout layoutAnimationWithDuration:0.3];
}

-(void)handleHorzReflectionTransform:(id)sender
{
    //布局内所有子视图都进行水平翻转排列，也就是水平镜像的效果。
    self.contentLayout.layoutTransform = CGAffineTransformMake(-1,0,0,1,0,0);
    [self.contentLayout layoutAnimationWithDuration:0.3];
}

-(void)handleVertReflectionTransform:(id)sender
{
    //布局内所有子视图都进行垂直翻转排列，也就是垂直镜像的效果。
    self.contentLayout.layoutTransform = CGAffineTransformMake(1,0,0,-1,0,0);
    [self.contentLayout layoutAnimationWithDuration:0.3];

}


-(void)handleReverseTransform:(id)sender
{
    //布局内所有子视图整体翻转180度的效果。
    self.contentLayout.layoutTransform = CGAffineTransformMake(-1,0,0,-1,0,0);
    [self.contentLayout layoutAnimationWithDuration:0.3];
}

@end

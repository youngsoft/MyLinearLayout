//
//  AllTest8ViewController.m
//  MyLayout
//
//  Created by apple on 16/12/22.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "AllTest8ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface AllTest8ViewController ()

@end

@implementation AllTest8ViewController


-(UIButton*)createDemoButton:(NSString*)title action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [CFTool font:15];
    [btn sizeToFit];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
        本例子演示当把一个布局视图加入到非布局视图时的各种场景。当把一个布局视图加入到非布局父视图时，因为无法完全对非布局父视图进行控制。所以一些布局视图的属性将不再起作用了，但是基本的视图扩展属性： leftPos,rightPos,topPos,bottomPos,centerXPos,centerYPos，widthDime,heightDime,wrapContentWidth, wrapContentHeight这几个属性仍然有意义，只不过这些属性的equalTo方法能设置的类型有限，而且这些设置都只是基于父视图的。
     */
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = self.view.bounds.size;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scrollView];

    //按钮用AutoLayout来实现，本例子说明AutoLayout是可以和MyLayout混合使用的。
    UIButton *button = [self createDemoButton:NSLocalizedString(@"Pop layoutview at center", "") action:@selector(handleDemo1:)];
    button.translatesAutoresizingMaskIntoConstraints = NO;  //button使用AutoLayout
    [scrollView addSubview:button];

    //下面的代码是iOS6以来自带的约束布局写法，可以看出代码量较大。
    [scrollView addConstraint:[NSLayoutConstraint  constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [scrollView addConstraint:[NSLayoutConstraint  constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    
    [scrollView addConstraint:[NSLayoutConstraint  constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
    
    [scrollView addConstraint:[NSLayoutConstraint  constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:-20]];
    
    //下面的代码是iOS9以后提供的一种简便的约束设置方法。可以看出其中各种属性设置方式和MyLayout是相似的。
    //在iOS9提供的NSLayoutXAxisAnchor，NSLayoutYAxisAnchor，NSLayoutDimension这三个类提供了和MyLayout中的MyLayoutPos,MyLayoutSize类等价的功能。
   /* if ([UIDevice currentDevice].systemVersion.doubleValue >= 9)
    {
        [button.centerXAnchor constraintEqualToAnchor:scrollView.centerXAnchor].active = YES;
        [button.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:10].active = YES;
        [button.heightAnchor constraintEqualToConstant:40].active = YES;
        [button.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor multiplier:1 constant:-20].active = YES;
    }
    */
    //如果您用MyLayout布局。并且button在一个垂直线性布局下那么可以写成如下：
   /* button.myTopMargin = 10;
    button.myHeight = 40;
    button.myLeftMargin = button.myRightMargin = 10;
    */

    
    
    /*
       下面例子用来建立一个不规则的功能区块。
     */
    
    //建立一个浮动布局,这个浮动布局不会控制父视图UIScrollView的contentSize。
    MyFloatLayout *floatLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    floatLayout.backgroundColor = [CFTool color:0];
    floatLayout.subviewMargin = 10;
    floatLayout.myLeftMargin = floatLayout.myRightMargin = 10;  //同时设定了左边和右边边距，布局视图的宽度就决定了。
    floatLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);  //设置内边距。
    floatLayout.myTopMargin = 60;
    floatLayout.myBottomMargin = 10; //底部边距为10，这样同样设置了顶部和底部边距后布局的高度就决定了。
    floatLayout.adjustScrollViewContentSizeMode = MyLayoutAdjustScrollViewContentSizeModeNo;  //布局视图不控制滚动视图的contentSize。
    /*这里面把布局视图加入到滚动视图时不会自动调整滚动视图的contentSize，如果不设置这个属性则当布局视图加入滚动视图时会自动调整滚动视图的contentSize。您可以把adjustScrollViewContentSizeMode属性设置这句话注释掉，可以看到当使用默认设置时，UIScrollView的contentSize的值会完全受到布局视图的尺寸和边距控制，这时候：
    
    contentSize.height = 布局视图的高度+布局视图的topPos设置的上边距值 + 布局视图的bottomPos设置的下边距值。
    contentSize.width = 布局视图的宽度+布局视图的leftPos设置的左距值 + 布局视图的rightPos设置的右边距值。

    */
    
    [scrollView addSubview:floatLayout];
    

    //这里定义高度占父视图的比例，每列分为5份，下面数组定义每个子视图的高度占比。
    CGFloat heightscale[7] = {0.4, 0.2, 0.2, 0.2, 0.2, 0.4, 0.4};
    //因为分为左右2列，而要求每个视图之间的垂直间距为10，左边列的总间距是30，一共有4个，因此前4个都要减去-30/4的间距高度；右边列总间距为20，一共有3个，因此后3个都要减去-20/3的间距高度。
    CGFloat heightinc[7] = {-30.0/4, -30.0/4, -30.0/4, -30.0/4, -20.0/3, -20.0/3, -20.0/3};
    for (int i = 0; i < 7; i++)
    {
        UIButton *buttonTag = [self createDemoButton:@"不规则功能块" action:@selector(handleDemo1:)];
        buttonTag.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        buttonTag.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //按钮内容左上角对齐。
        buttonTag.backgroundColor = [CFTool color:i + 5];
        buttonTag.widthDime.equalTo(floatLayout.widthDime).multiply(0.5).add(-5); //因为宽度都是父视图的一半，并且水平间距是10，所以这里比例是0.5，分别减去5个间距宽度。
        buttonTag.heightDime.equalTo(floatLayout.heightDime).multiply(heightscale[i]).add(heightinc[i]); //高度占比和所减的间距在上面数组里面定义。
        [floatLayout addSubview:buttonTag];
    }
    
    
    
}


/*
   这个例子用来演示让一个布局视图在非布局视图中居中，并且其尺寸是由子视图决定的，也就是wrapContentHeight设置为YES。
 */



-(void)handleDemo1AddText:(UIButton*)sender
{
   //这里可以看出当您调整了文字的长度，不需要编写任何更新布局视图位置的代码，系统会完全帮你自动更新布局，这样就简化了我们开发。
    
   UILabel *label = (UILabel*)sender.superview.superview.subviews[1]; //取第二个子视图
    label.text = [label.text stringByAppendingString:@"添加文字。"];
    [label sizeToFit];
}

-(void)handleDemo1RemoveLayout:(UIButton*)sender
{
    //这个系统的方法能执行视图的删除以及产生动画效果。
    [UIView performSystemAnimation:UISystemAnimationDelete onViews:@[sender.superview.superview] options:0 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)handleDemo1:(UIButton*)sender
{
    //布局视图用来实现弹框，这里把一个布局视图放入一个非布局视图里面。
    MyLinearLayout *layout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    layout.backgroundColor = [CFTool color:14];
    layout.layer.cornerRadius = 5;
    layout.padding = UIEdgeInsetsMake(5, 5, 5, 5);  //设置布局视图的内边距。
    layout.subviewMargin = 5;  //设置视图之间的间距，这样子视图就不再需要单独设置间距了。
    layout.gravity = MyMarginGravity_Horz_Fill;   //里面的子视图宽度和自己一样，这样就不再需要设置子视图的宽度了。
    layout.myLeftMargin = 0.2;
    layout.myRightMargin = 0.2;  //左右边距0.2表示相对边距，也就是左右边距都是父视图总宽度的20%，这样布局视图的宽度就默认为父视图的60%了。
    layout.myCenterYOffset = 0;  //布局视图在父视图中垂直居中出现。
    //layout.myBottomMargin = 0;  //布局视图在父视图中底部出现。您可以注释上面居中的代码并解开这句看看效果。
    [self.view addSubview:layout];
    
    //标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Title", "");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [CFTool color:4];
    titleLabel.font = [CFTool font:17];
    [titleLabel sizeToFit];
    [layout addSubview:titleLabel];
    
    //文本
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.flexedHeight = YES;
    label.font = [CFTool font:14];
    label.text = @"这是一段具有动态高度的文本，同时他也会影响着布局视图的高度。您可以单击下面的按钮来添加文本来查看效果：";
    [layout addSubview:label];
    
    
    //按钮容器。如果您想让两个按钮水平排列则只需在btnContainer初始化中把方向改为：MyLayoutViewOrientation_Horz 。您可以尝试看看效果。
    MyLinearLayout *btnContainer = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert /*MyLayoutViewOrientation_Horz*/];
    btnContainer.wrapContentHeight = YES;  //高度由子视图确定。
    btnContainer.subviewMargin = 5;   //视图之间的间距设置为5
    btnContainer.gravity = MyMarginGravity_Horz_Fill; //里面的子视图的宽度水平填充，如果是垂直线性布局则里面的所有子视图的宽度都和父视图相等。如果是水平线性布局则会均分所有子视图的宽度。
    [layout addSubview:btnContainer];
    
    /*
       MyLayout和SizeClass有着紧密的结合。如果你想在横屏时两个按钮水平排列而竖屏时垂直排列则设置如下 ：
     
       因为所有设置的布局属于默认都是基于wAny,hAny这种Size Classes的。所以我们要对按钮容器视图指定一个单独横屏的Size Classes: MySizeClass_Landscape
       这里的copyFrom表示系统会拷贝默认的Size Classes，最终方法返回横屏的Size Classes。 这样你只需要设置一下排列的方向就可以了。
     
       您可以将下面两句代码注释掉看看横竖屏切换的结果。
     */
    
    MyLinearLayout *btnContainerSC = [btnContainer fetchLayoutSizeClass:MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    btnContainerSC.orientation = MyLayoutViewOrientation_Horz;
    
    
    //您可以看到下面的两个按钮没有出现任何的需要进行布局的属性设置，直接添加到父视图就能达到想要的效果，这样就简化了程序的开发。
    [btnContainer addSubview:[self createDemoButton:@"Add Text" action:@selector(handleDemo1AddText:)]];
    [btnContainer addSubview:[self createDemoButton:@"Remove Layout" action:@selector(handleDemo1RemoveLayout:)]];

    
    //这里把一个布局视图加入到非布局父视图。
    [self.view addSubview:layout];
   
    
    //如果您要移动出现的动画效果则解开如下注释。
   /* layout.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height / 2);
    layout.alpha = 0.5;
    [UIView animateWithDuration:0.3 animations:^{
        layout.transform = CGAffineTransformIdentity;
        layout.alpha = 1;
    }];
    */
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

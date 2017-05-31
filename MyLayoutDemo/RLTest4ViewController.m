//
//  RLTest4ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/9.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "RLTest4ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface RLTest4ViewController ()<UIScrollViewDelegate>


@property(nonatomic, weak) UIView *testTopDockView;
@property(nonatomic, weak) UIView *testView1;


@end

@implementation RLTest4ViewController


-(UILabel*)createLabel:(NSString*)title backgroundColor:(UIColor*)color
{
    UILabel *v = [UILabel new];
    v.text = title;
    v.backgroundColor = color;
    v.textColor = [CFTool color:0];
    v.font = [CFTool font:17];
    v.numberOfLines = 0;
    return v;
}

-(void)loadView
{
    /*
       这个例子用来介绍相对布局和滚动视图的结合，来实现滚动以及子视图的停靠的实现，其中主要的方式是通过子视图的属性noLayout来简单的实现这个功能。
     
       这里之所以用相对布局来实现滚动和停靠的原因是，线性布局、流式布局、浮动布局这几种布局都是根据添加的顺序来排列的。一般情况下，前面添加的子视图会显示在底部，而后面添加的子视图则会显示在顶部，所以一旦我们出现这种滚动，且某个子视图固定停靠时，我们一般要求这个停靠的子视图要放在最上面，也就是最后一个。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.widthSize.equalTo(scrollView.widthSize);
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.wrapContentHeight = YES;
    [scrollView addSubview:rootLayout];
    
    
    //添加色块。
    UILabel *v1 = [self createLabel:NSLocalizedString(@"Scroll the view please", @"") backgroundColor:[CFTool color:1]];
    v1.widthSize.equalTo(rootLayout.widthSize);
    v1.heightSize.equalTo(@80);
    [rootLayout addSubview:v1];
    self.testView1 = v1;
    
    
    UIView *v2 = [self createLabel:@"" backgroundColor:[CFTool color:2]];
    v2.widthSize.equalTo(rootLayout.widthSize);
    v2.heightSize.equalTo(@200);
    [rootLayout addSubview:v2];
    
    
    UIView *v3 = [self createLabel:@"" backgroundColor:[CFTool color:3]];
    v3.widthSize.equalTo(rootLayout.widthSize);
    v3.heightSize.equalTo(@800);
    v3.topPos.equalTo(v2.bottomPos);
    [rootLayout addSubview:v3];
    
    
    //这里最后一个加入的子视图作为滚动时的停靠视图。。
    UILabel *v4 = [self createLabel:NSLocalizedString(@"This view will Dock to top when scroll", @"") backgroundColor:[CFTool color:4]];
    v4.widthSize.equalTo(rootLayout.widthSize);
    v4.heightSize.equalTo(@80);
    v4.topPos.equalTo(v1.bottomPos);
    [rootLayout addSubview:v4];
    self.testTopDockView = v4;
    
    v2.topPos.equalTo(v4.bottomPos);
    
    
    //当v4设置为noLayout时，出现了屏幕的旋转这时候是无法更新v4的frame值的，所以这里需要实现布局视图的这个block来再屏幕旋转是更新v4的frame值。
    __weak UIView *weakV4 = v4;
    __weak UIScrollView *weakScrollView = scrollView;
    rootLayout.rotationToDeviceOrientationBlock = ^(MyBaseLayout *layout, BOOL isFirst, BOOL isPortrait){
    
        if (weakV4.noLayout && !isFirst)
        {
          //如果V4不实际布局且不是第一次布局完成则这里要调整V4的frame。
          CGRect rect = weakV4.frame;
          weakV4.frame = CGRectMake(rect.origin.x, weakScrollView.contentOffset.y, layout.frame.size.width - 20, rect.size.height);
        }
        
    };
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //testTopDockView的上面视图是testView1。所以这里如果偏移超过testView1的最大则开始固定testTopDockView了
    if (scrollView.contentOffset.y > CGRectGetMaxY(self.testView1.frame))
    {
        
        /*
         当滚动条偏移的位置大于某个值后，我们将特定的子视图的noLayout设置为YES，表示特定的子视图虽然会参与布局，但是在布局完成后不会更新frame值。
         因为参与了布局，所以不会影响到依赖这个视图的其他视图，所以整体布局结构是保持不变，这时候虽然设置为了noLayout的视图留出了一个空挡，但是却可以通过frame值来进行任意的定位而不受到布局的控制。
        
         上面的代码中我们可以看到v4视图的位置和尺寸设置如下：
         v4.widthSize.equalTo(rootLayout.widthSize);  //宽度和父视图相等。
         v4.heightSize.equalTo(@80);              //高度等于80。
         v4.topPos.equalTo(v1.bottomPos);         //总是位于v1的下面。
         。。。。
         v2.topPos.equalTo(v4.bottomPos);         //v2则总是位于v4的下面。
         
         而当我们将v4的noLayout设置为了YES后，这时候v4仍然会参与布局，也就是说v4的那块区域和位置是保持不变的，v2还是会在v4的下面。但是v4却可以通过frame值进行任意位置和尺寸的改变。 这样就实现了当滚动时我们调整v4的真实frame值来达到悬停的功能，但是v2却保持了不变，还是向往常一样保持在那个v4假位置的下面，而随着滚动条滚动而滚动。
         
         ***需要注意的是这个特定的子视图一定要最后加入到布局视图中去。***
         */
        
        self.testTopDockView.noLayout = YES;
        CGRect rect = self.testTopDockView.frame;
        self.testTopDockView.frame = CGRectMake(rect.origin.x, scrollView.contentOffset.y, rect.size.width, rect.size.height); //这里可以自由设置位置和尺寸了。
        
        
        
    }
    else
    {
        
        //当滚动的偏移小于90后，我们将testTopDocView的noLayout设置回NO,这样这个视图就又会根据所设置的约束而受到布局视图的约束和控制了，这时候frame的设置将不再起作用了。
        self.testTopDockView.noLayout = NO;
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

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


@property(nonatomic, strong) UIView *testTopDockView;


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
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate = self;
    self.view = scrollView;
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.myLeftMargin = rootLayout.myRightMargin = 0;
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.wrapContentHeight = YES;
    [scrollView addSubview:rootLayout];
    
    
    //添加色块。
    UILabel *v1 = [self createLabel:NSLocalizedString(@"Scroll the view please", @"") backgroundColor:[CFTool color:1]];
    v1.widthDime.equalTo(rootLayout.widthDime);
    v1.heightDime.equalTo(@80);
    [rootLayout addSubview:v1];
    
    
    UIView *v2 = [self createLabel:@"" backgroundColor:[CFTool color:2]];
    v2.widthDime.equalTo(rootLayout.widthDime);
    v2.heightDime.equalTo(@200);
    [rootLayout addSubview:v2];
    
    
    UIView *v3 = [self createLabel:@"" backgroundColor:[CFTool color:3]];
    v3.widthDime.equalTo(rootLayout.widthDime);
    v3.heightDime.equalTo(@800);
    v3.topPos.equalTo(v2.bottomPos);
    [rootLayout addSubview:v3];
    
    
    //这里最后一个加入的子视图作为滚动时的停靠视图。。
    UILabel *v4 = [self createLabel:NSLocalizedString(@"This view will Dock to top when scroll", @"") backgroundColor:[CFTool color:4]];
    v4.widthDime.equalTo(rootLayout.widthDime);
    v4.heightDime.equalTo(@80);
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
    
    //因为这里第一个视图的高度是80外加10的顶部padding，这样这里判断的偏移位置是90.
    if (scrollView.contentOffset.y > 90)
    {
        
        //当偏移的位置大于某个值后，我们将特定的子视图的noLayout设置为YES，表示特定的子视图会参与布局，但是不会设置frame值
        //所以当特定的子视图的noLayout设置为YES后，我们就可以手动的设置其frame值来达到悬停的能力。
        //需要注意的是这个特定的子视图一定要最后加入到布局视图中去。
        //代码就是这么简单，这么任性。。。
        self.testTopDockView.noLayout = YES;
        
        CGRect rect = self.testTopDockView.frame;
        self.testTopDockView.frame = CGRectMake(rect.origin.x, scrollView.contentOffset.y, rect.size.width, rect.size.height);
        
        
        
    }
    else
    {
        
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

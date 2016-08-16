//
//  RLTest4ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/9.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "RLTest4ViewController.h"
#import "MyLayout.h"

@interface RLTest4ViewController ()<UIScrollViewDelegate>


@property(nonatomic, strong) UIView *testView;

@end

@implementation RLTest4ViewController

-(void)loadView
{
    /*
       这个例子用来介绍相对布局和滚动视图的结合，来实现滚动以及子视图的停靠的实现，其中主要的方式是通过子视图的属性noLayout来简单的实现这个功能。
     
       这里之所以用相对布局来实现滚动和停靠的原因是，线性布局、流式布局、浮动布局这几种布局都是根据添加的顺序来排列的。一般情况下，前面添加的子视图会显示在底部，而后面添加的子视图则会显示在顶部，所以一旦我们出现这种滚动，且某个子视图固定停靠时，我们一般要求这个停靠的子视图要放在最上面，也就是最后一个，而这些情况用线性布局、流式布局、浮动布局来实现是比较难的。
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
    UILabel *v1 = [UILabel new];
    v1.widthDime.equalTo(rootLayout.widthDime);
    v1.heightDime.equalTo(@80);
    v1.text = NSLocalizedString(@"Scroll the view please", @"");
    v1.backgroundColor = [UIColor redColor];
    [rootLayout addSubview:v1];
    
    
    UIView *v2 = [UIView new];
    v2.widthDime.equalTo(rootLayout.widthDime);
    v2.heightDime.equalTo(@200);
    v2.backgroundColor = [UIColor blueColor];
    [rootLayout addSubview:v2];
    
    
    UIView *v3 = [UIView new];
    v3.widthDime.equalTo(rootLayout.widthDime);
    v3.heightDime.equalTo(@800);
    v3.topPos.equalTo(v2.bottomPos);
    v3.backgroundColor = [UIColor greenColor];
    [rootLayout addSubview:v3];
    
    
    //这里最后一个加入的子视图作为滚动时的停靠视图。。
    UILabel *v4 = [UILabel new];
    v4.widthDime.equalTo(rootLayout.widthDime);
    v4.heightDime.equalTo(@80);
    v4.topPos.equalTo(v1.bottomPos);
    v4.backgroundColor = [UIColor orangeColor];
    v4.numberOfLines = 0;
    v4.text = NSLocalizedString(@"This view will Dock to top when scroll", @"");
    [rootLayout addSubview:v4];
    self.testView = v4;
    
    v2.topPos.equalTo(v4.bottomPos);
    
    
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
        if (!self.testView.noLayout)
        {
            self.testView.noLayout = YES;
        }
        
        if (self.testView.noLayout)
        {
            CGRect rect = self.testView.frame;
            self.testView.frame = CGRectMake(rect.origin.x, scrollView.contentOffset.y, rect.size.width, rect.size.height);
            
        }
        
    }
    else
    {
        if (self.testView.noLayout)
        {
            self.testView.noLayout = NO;
        }
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

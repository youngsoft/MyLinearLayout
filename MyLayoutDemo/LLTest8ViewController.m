//
//  LLTest8ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/9.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest8ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@interface DockViewInfo : NSObject

@property (nonatomic, strong) UIView *dockView;
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation DockViewInfo

@end

@interface LLTest8ViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) NSMutableArray< DockViewInfo *> *dockViewInfos;

@property(nonatomic, weak) MyLinearLayout *rootLayout;


@end

@implementation LLTest8ViewController


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
       这个例子用来介绍布局和滚动视图的结合，以及布局内子视图在滑动时停靠的实现方法。停靠功能通过子视图的属性useFrame以及占位视图来实现。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    
    self.dockViewInfos = [NSMutableArray new];

    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.insetsPaddingFromSafeArea = ~UIRectEdgeBottom;  //为了防止拉到底部时iPhoneX设备的抖动发生，不能将底部安全区叠加到padding中去。
    rootLayout.widthSize.equalTo(scrollView.widthSize);
    rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.gravity = MyGravity_Horz_Fill;
    [scrollView addSubview:rootLayout];
    self.rootLayout = rootLayout;
    
    
    //添加色块。
    UILabel *v1 = [self createLabel:NSLocalizedString(@"Scroll the view please", @"") backgroundColor:[CFTool color:1]];
    v1.heightSize.equalTo(@80);
    [rootLayout addSubview:v1];
        
    //这是一个停靠的视图。
    UIView *v2 = [self createLabel:@"This is a dock view1" backgroundColor:[CFTool color:2]];
    v2.heightSize.equalTo(@60);
    [rootLayout addSubview:v2];
    DockViewInfo *dockViewInfo1 = [DockViewInfo new];
    dockViewInfo1.dockView = v2;
    [self.dockViewInfos addObject:dockViewInfo1];
    
    UIView *v3 = [self createLabel:@"This is scrolled view ................" backgroundColor:[CFTool color:3]];
    v3.heightSize.equalTo(@100);
    [rootLayout addSubview:v3];
    
    
    UIView *v4 = [self createLabel:@"This is a dock view2" backgroundColor:[CFTool color:4]];
    v4.heightSize.equalTo(@40);
    [rootLayout addSubview:v4];
    
    DockViewInfo *dockViewInfo2 = [DockViewInfo new];
    dockViewInfo2.dockView = v4;
    [self.dockViewInfos addObject:dockViewInfo2];
    
    UIView *v5 = [self createLabel:@"This is scrolled view ................" backgroundColor:[CFTool color:5]];
    v5.heightSize.equalTo(@100);
    [rootLayout addSubview:v5];
    
    
    UIView *v6 = [self createLabel:@"This is a dock view3" backgroundColor:[CFTool color:6]];
    v6.heightSize.equalTo(@40);
    [rootLayout addSubview:v6];
    
    DockViewInfo *dockViewInfo3 = [DockViewInfo new];
    dockViewInfo3.dockView = v6;
    [self.dockViewInfos addObject:dockViewInfo3];

    
    UILabel *v7 = [self createLabel:NSLocalizedString(@"This is scrolled view ................", @"") backgroundColor:[CFTool color:7]];
    v7.heightSize.equalTo(@800);
    [rootLayout addSubview:v7];
    
    UILabel *v8 = [self createLabel:NSLocalizedString(@"This is last view", @"") backgroundColor:[CFTool color:8]];
    v8.heightSize.equalTo(@80);
    [rootLayout addSubview:v8];

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
    CGFloat totalDockedHeight = 0.0;
    DockViewInfo *prevDockViewInfo  = nil;
    for (DockViewInfo *dockViewInfo in self.dockViewInfos) {
        
        totalDockedHeight += CGRectGetHeight(prevDockViewInfo.placeHolderView.frame);

        CGFloat y = 0;
        if (dockViewInfo.dockView.useFrame) {
            y  = CGRectGetMinY(dockViewInfo.placeHolderView.frame);
        } else {
            y  = CGRectGetMinY(dockViewInfo.dockView.frame);
        }
        y -= totalDockedHeight;
        
        if (scrollView.contentOffset.y >= y) {
            if (!dockViewInfo.dockView.useFrame) {
                //创建一个占位视图，占位视图的布局特性和将要停靠的视图的布局特性以及位置要保持一致。同时需要把要停靠的视图放到最顶端的层级，这样剩余视图在滑动时就不会覆盖停靠的视图。
                UIView *placeholderView = [UIView new];
                id traits = [dockViewInfo.dockView fetchLayoutSizeClass:MySizeClass_wAny | MySizeClass_hAny];
                [placeholderView setLayoutSizeClass:MySizeClass_wAny | MySizeClass_hAny withValue:[traits copy]];
                [self.rootLayout insertSubview:placeholderView belowSubview:dockViewInfo.dockView];
                [self.rootLayout bringSubviewToFront:dockViewInfo.dockView];
                dockViewInfo.dockView.useFrame = YES;
                dockViewInfo.placeHolderView = placeholderView;
            }
            
            CGRect rect = dockViewInfo.dockView.frame;
            dockViewInfo.dockView.frame = CGRectMake(rect.origin.x, scrollView.contentOffset.y + totalDockedHeight, rect.size.width, rect.size.height);
        } else {
            if (dockViewInfo.dockView.useFrame) {
                dockViewInfo.dockView.useFrame = NO;
                [self.rootLayout insertSubview:dockViewInfo.dockView belowSubview:dockViewInfo.placeHolderView];
                [dockViewInfo.placeHolderView removeFromSuperview];
                dockViewInfo.placeHolderView = nil;
            }
        }
        
        prevDockViewInfo = dockViewInfo;
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

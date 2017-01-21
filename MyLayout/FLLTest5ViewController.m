//
//  FLLTest5ViewController.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLLTest5ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLLTest5ViewController ()


@end

@implementation FLLTest5ViewController


-(void)loadView
{
    /*
       这个例子主要是用来展示数量约束流式布局对分页滚动能力的支持。
     */
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delaysContentTouches = NO;  //因为里面也有滚动视图，优先处理子滚动视图的事件。
    self.view = scrollView;
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.myLeftMargin = rootLayout.myRightMargin = 0; //宽度和滚动视图保持一致。
    rootLayout.gravity = MyMarginGravity_Horz_Fill;  //里面的所有子视图和布局视图宽度一致。
    [scrollView addSubview:rootLayout];
    
    
    //创建一个水平数量流式布局分页从左到右滚动
    [self createHorzPagingFlowLayout1:rootLayout];
    
    //创建一个水平数量流式布局分页从上到下滚动的流式布局。
    [self createHorzPagingFlowLayout2:rootLayout];

    //创建一个垂直数量流式布局分页从上到下滚动
    [self createVertPagingFlowLayout1:rootLayout];

    //创建一个垂直数量流式布局分页从左到右滚动
    [self createVertPagingFlowLayout2:rootLayout];

    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

//添加所有测试子条目视图。
-(void)addAllItemSubviews:(MyFlowLayout*)flowLayout
{
    
    for (int i = 0; i < 40; i++)
    {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [CFTool color:random() % 14 + 1];
        label.text = [NSString stringWithFormat:@"%d",i];
        [flowLayout addSubview:label];
        
    }
    

}


/**
 *  创建一个水平分页从左向右滚动的流式布局
 */
-(void)createHorzPagingFlowLayout1:(UIView*)rootLayout
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"水平流式布局分页从左往右滚动:➡︎";
    [titleLabel sizeToFit];
    [rootLayout addSubview:titleLabel];
    titleLabel.myTopMargin = 20;
    
    //要开启分页功能，必须要将流式布局加入到一个滚动视图里面作为子视图！！！
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.pagingEnabled = YES;  //开启分页滚动模式！！您可以注释这句话看看非分页滚动的布局滚动效果。
    scrollView.myHeight = 200;   //设置明确的高度为200，因为宽度已经由父线性布局的gravity属性确定了，所以不需要设置了。
    [rootLayout addSubview:scrollView];
    
    
    //建立一个水平数量约束流式布局:每列展示3个子视图,每页展示9个子视图，整体从左往右滚动。
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Horz arrangedCount:3];
    flowLayout.pagedCount = 9; //pagedCount设置为非0时表示开始分页展示的功能，这里表示每页展示9个子视图，这个数量必须是arrangedCount的倍数。
    flowLayout.wrapContentWidth = YES; //设置布局视图的宽度由子视图包裹，当水平流式布局的这个属性设置为YES，并和pagedCount搭配使用会产生分页从左到右滚动的效果。
    flowLayout.heightDime.equalTo(scrollView.heightDime); //因为是分页从左到右滚动，因此布局视图的高度必须设置为和父滚动视图相等。
     /*
        上面是实现一个水平流式布局分页且从左往右滚动的标准属性设置方法。
      */
    
    flowLayout.subviewHorzMargin = 10;
    flowLayout.subviewVertMargin = 10;  //设置子视图的水平和垂直间距。
    flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5); //布局视图的内边距设置！您可以注释掉这句话看看效果！如果设置内边距且也有分页时请将这个值设置和子视图间距相等。
    [scrollView addSubview:flowLayout];
    flowLayout.backgroundColor = [CFTool color:0];

    [self addAllItemSubviews:flowLayout];
    
    //获取流式布局的横屏size classes，并且设置当设备处于横屏时每页的数量由9个变为了18个。您可以注释掉这段代码，然后横竖屏切换看看效果。
    MyFlowLayout *flowLayoutSC = [flowLayout fetchLayoutSizeClass:MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    flowLayoutSC.pagedCount = 18;
}

/**
 *  创建一个水平分页从上向下滚动的流式布局
 */
-(void)createHorzPagingFlowLayout2:(UIView*)rootLayout
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"水平流式布局分页从上往下滚动:⬇︎";
    [titleLabel sizeToFit];
    [rootLayout addSubview:titleLabel];
    titleLabel.myTopMargin = 20;
    
    //要开启分页功能，必须要将流式布局加入到一个滚动视图里面作为子视图！！！
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.pagingEnabled = YES;  //开启分页滚动模式！！您可以注释这句话看看非分页滚动的布局滚动效果。
    scrollView.myHeight = 250;   //设置明确的高度为250，因为宽度已经由父线性布局的gravity属性确定了，所以不需要设置了。
    [rootLayout addSubview:scrollView];
    
    
    //建立一个水平数量约束流式布局:每列展示3个子视图,每页展示9个子视图，整体从上往下滚动。
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Horz arrangedCount:3];
    flowLayout.pagedCount = 9; //pagedCount设置为非0时表示开始分页展示的功能，这里表示每页展示9个子视图，这个数量必须是arrangedCount的倍数。
    flowLayout.wrapContentHeight = YES; //设置布局视图的高度由子视图包裹，当水平流式布局的这个属性设置为YES，并和pagedCount搭配使用会产生分页从上到下滚动的效果。
    flowLayout.widthDime.equalTo(scrollView.widthDime); //因为是分页从左到右滚动，因此布局视图的宽度必须设置为和父滚动视图相等。
    /*
     上面是实现一个水平流式布局分页且从上往下滚动的标准属性设置方法。
     */
    
    flowLayout.subviewHorzMargin = 10;
    flowLayout.subviewVertMargin = 10;  //设置子视图的水平和垂直间距。
    flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5); //布局视图的内边距设置！您可以注释掉这句话看看效果！如果设置内边距且也有分页时请将这个值设置和子视图间距相等。
    [scrollView addSubview:flowLayout];
    flowLayout.backgroundColor = [CFTool color:0];
    
    [self addAllItemSubviews:flowLayout];
    
    //获取流式布局的横屏size classes，并且设置设备处于横屏时每页的数量由9个变为18个。您可以注释掉这段代码，然后横竖屏切换看看效果。
    MyFlowLayout *flowLayoutSC = [flowLayout fetchLayoutSizeClass:MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    flowLayoutSC.pagedCount = 18;
    
}


/**
 *  创建一个垂直分页从上向下滚动的流式布局
 */
-(void)createVertPagingFlowLayout1:(UIView*)rootLayout
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"垂直流式布局分页从上往下滚动:⬇︎";
    [titleLabel sizeToFit];
    [rootLayout addSubview:titleLabel];
    titleLabel.myTopMargin = 20;

    //要开启分页功能，必须要将流式布局加入到一个滚动视图里面作为子视图！！！
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.pagingEnabled = YES;  //开启分页滚动模式！！您可以注释这句话看看非分页滚动的布局滚动效果。
    scrollView.myHeight = 250;   //设置明确的高度为250，因为宽度已经由父线性布局的gravity属性确定了，所以不需要设置了。
    [rootLayout addSubview:scrollView];
    
    //建立一个垂直数量约束流式布局:每列展示3个子视图,每页展示9个子视图，整体从上往下滚动。
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    flowLayout.pagedCount = 9; //pagedCount设置为非0时表示开始分页展示的功能，这里表示每页展示9个子视图，这个数量必须是arrangedCount的倍数。
    flowLayout.wrapContentHeight = YES; //设置布局视图的高度由子视图包裹，当垂直流式布局的这个属性设置为YES，并和pagedCount搭配使用会产生分页从上到下滚动的效果。
    flowLayout.widthDime.equalTo(scrollView.widthDime);
    /*
     上面是实现一个垂直流式布局分页且从上往下滚动的标准属性设置方法。
     */
    
    
    flowLayout.subviewHorzMargin = 10;
    flowLayout.subviewVertMargin = 10;  //设置子视图的水平和垂直间距。
    flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5); //布局视图的内边距设置！您可以注释掉这句话看看效果！如果设置内边距且也有分页时请将这个值设置和子视图间距相等。
    [scrollView addSubview:flowLayout];
    flowLayout.backgroundColor = [CFTool color:0];
    
    [self addAllItemSubviews:flowLayout];
    
    //获取流式布局的横屏size classes，并且设置设备处于横屏时,每排数量由3个变为6个，每页的数量由9个变为18个。您可以注释掉这段代码，然后横竖屏切换看看效果。
    MyFlowLayout *flowLayoutSC = [flowLayout fetchLayoutSizeClass:MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    flowLayoutSC.arrangedCount = 6;
    flowLayoutSC.pagedCount = 18;

    
    
}

/**
 *  创建一个垂直分页从左向右滚动的流式布局
 */
-(void)createVertPagingFlowLayout2:(UIView*)rootLayout
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"垂直流式布局分页从左往右滚动:➡︎";
    [titleLabel sizeToFit];
    [rootLayout addSubview:titleLabel];
    titleLabel.myTopMargin = 20;
    
    //要开启分页功能，必须要将流式布局加入到一个滚动视图里面作为子视图！！！
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.pagingEnabled = YES;  //开启分页滚动模式！！您可以注释这句话看看非分页滚动的布局滚动效果。
    scrollView.myHeight = 200;   //设置明确的高度为200，因为宽度已经由父线性布局的gravity属性确定了，所以不需要设置了。
    [rootLayout addSubview:scrollView];
    
    //建立一个垂直数量约束流式布局:每列展示3个子视图,每页展示9个子视图，整体从左往右滚动。
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:3];
    flowLayout.pagedCount = 9; //pagedCount设置为非0时表示开始分页展示的功能，这里表示每页展示9个子视图，这个数量必须是arrangedCount的倍数。
    flowLayout.wrapContentWidth = YES; //设置布局视图的宽度由子视图包裹，当垂直流式布局的这个属性设置为YES，并和pagedCount搭配使用会产生分页从左到右滚动的效果。
    flowLayout.heightDime.equalTo(scrollView.heightDime);
    /*
     上面是实现一个垂直流式布局分页且从左往右滚动的标准属性设置方法。
     */
    
    
    flowLayout.subviewHorzMargin = 10;
    flowLayout.subviewVertMargin = 10;  //设置子视图的水平和垂直间距。
    flowLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5); //布局视图的内边距设置！您可以注释掉这句话看看效果！如果设置内边距且也有分页时请将这个值设置和子视图间距相等。
    [scrollView addSubview:flowLayout];
    flowLayout.backgroundColor = [CFTool color:0];
    
    [self addAllItemSubviews:flowLayout];
    
    //获取流式布局的横屏size classes，并且设置设备处于横屏时,每排数量由3个变为6个，每页的数量由9个变为18个。您可以注释掉这段代码，然后横竖屏切换看看效果。
    MyFlowLayout *flowLayoutSC = [flowLayout fetchLayoutSizeClass:MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
    flowLayoutSC.arrangedCount = 6;
    flowLayoutSC.pagedCount = 18;
    
}


#pragma mark -- Handle Method

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

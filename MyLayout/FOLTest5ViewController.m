//
//  FOLTest5ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "FOLTest5ViewController.h"
#import "MyLayout.h"


@interface FOLTest5ViewController ()

@end

@implementation FOLTest5ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    NSArray *titles = @[@"布局名称:",
                        @"线性布局:",
                        @"表格布局:",
                        @"框架布局:",
                        @"相对布局:",
                        @"流式布局:",
                        @"浮动布局:",
                        @"SIZECLASS:"
                        ];
    
    NSArray *descs = @[@"MyLayout布局是一套功能强大的界面布局体系，一共支持6种布局和支持SIZECLASS。",
                       @"是一种里面的子视图按添加的顺序并依照规定的方向依次排列的布局。根据其规定的方向可以分为垂直线性布局和水平线性布局。垂直线性布局里面的子视图按照添加的顺序从上到下依次排列，水平线性布局里面的子视图按照添加的顺序从左到右依次排列。",
                       @"是一种具有多行多列展示的布局。表格布局分为垂直表格和水平表格，垂直表格的行是从上到下排列，而列则是从左到又排列。水平表格的行是从左到右排列，而列则是从上到下排列。水平表格的一个典型的应用就是用来实现瀑布流的功能。",
                       @"是一种里面的子视图按照布局视图方位停靠的布局。框架布局里面垂直方向上分为上、中、下三个方位，而水平方向上则分为左、中、右三个方位。任何一个子视图都只能定位在垂直方向和水平方向上的一个方位上。",
                       @"是一种里面的子视图通过设置视图与视图之间依赖约束而进行定位和尺寸确认的布局。相对布局实现的机制以及约束设置的方式跟AutoLayout中设置子视图之间的约束方式是一致的。",
                       @"是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一行再重新按添加的顺序排列的布局。这里的约束限制主要有数量的约束和尺寸的约束两种，而排列的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些有规律排列的场景，在某种程度上可以作为UICollectionView的替代品。",
                       @"是一种里面的子视图按照约定的方向浮动，当尺寸不足以被容纳时，会自动寻找最佳的位置进行停靠的布局。浮动布局的理念源于HTML/CSS中的浮动定位技术,因此浮动布局可以专门用来实现那些不规则布局或者图文环绕的布局。根据浮动的方向不同，浮动布局可以分为左右浮动布局和上下浮动布局。",
                       @"MyLayout体系为了实现对不同设备的屏幕进行适配，提供了对SIZECLASS的支持能力，您可以将SIZECLASS和上述的6种布局搭配使用，以便实现各种设备下的完美适配。"
                       ];
    

    NSArray *colors = @[[UIColor redColor],
                        [UIColor greenColor],
                        [UIColor blueColor],
                        [UIColor orangeColor],
                        [UIColor blackColor],
                        [UIColor yellowColor],
                        [UIColor magentaColor],
                        [UIColor brownColor]
                        ];
    
    
    MyFloatLayout *rootLayout = [[MyFloatLayout alloc] initWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.myLeftMargin = rootLayout.myRightMargin = 0;  //宽度和滚动条视图保持一致。
    rootLayout.wrapContentHeight = YES;
    rootLayout.subviewHorzMargin = 5;
    rootLayout.subviewVertMargin = 5;
    [scrollView addSubview:rootLayout];
    
    
    UILabel *label = [UILabel new];
    label.text = @"MyLayout布局介绍：";
    label.myBottomMargin = 10;
    [label sizeToFit];
    [rootLayout addSubview:label];
    
    for (NSInteger i = 0; i < titles.count; i++)
    {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = titles[i];
        titleLabel.textColor = colors[i];
        titleLabel.clearFloat = YES;
        titleLabel.widthDime.equalTo(rootLayout.widthDime).multiply(0.25);
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [titleLabel sizeToFit];
        [rootLayout addSubview:titleLabel];
        
        UILabel *descLabel = [UILabel new];
        descLabel.text = descs[i];
        descLabel.font = [UIFont systemFontOfSize:14];
        descLabel.weight = 1;
        descLabel.numberOfLines = 0;
        descLabel.flexedHeight = YES;
        [descLabel sizeToFit];
        [rootLayout addSubview:descLabel];
        
    }
    
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

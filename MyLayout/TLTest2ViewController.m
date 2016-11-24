//
//  Test18ViewController.m
//  MyLayout
//
//  Created by oybq on 15/8/26.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "TLTest2ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface TLTest2ViewController ()

@property(nonatomic, strong) MyTableLayout *rootLayout;

@end

@implementation TLTest2ViewController

-(void)loadView
{    
    [super loadView];
    self.view.backgroundColor = [CFTool color:5];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    /*
       创建一个水平的表格布局，水平表格布局主要用于建立瀑布流视图。需要注意的是水平表格中row也就是行是从左到右排列的，而每行中的col也就是列是从上到下排列的。
     */
    
    _rootLayout = [MyTableLayout tableLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    _rootLayout.wrapContentWidth = NO;
    _rootLayout.rowSpacing = 5;
    _rootLayout.colSpacing = 10;
    _rootLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);  //分别设置表格布局里面的行间距、列间距、内部padding边距。
    
    _rootLayout.widthDime.equalTo(scrollView.widthDime);
    _rootLayout.wrapContentHeight = YES; //布局宽度和父视图一致，高度则由内容包裹。这是实现将布局视图加入滚动条视图并垂直滚动的标准方法。
    [scrollView addSubview:_rootLayout];
    
    //为瀑布流建立3个平均分配的行，每行的列的尺寸由内容决定。
    [_rootLayout addRow:MTLSIZE_AVERAGE colSize:MTLSIZE_WRAPCONTENT];
    [_rootLayout addRow:MTLSIZE_AVERAGE colSize:MTLSIZE_WRAPCONTENT];
    [_rootLayout addRow:MTLSIZE_AVERAGE colSize:MTLSIZE_WRAPCONTENT];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"add cell", @"") style:UIBarButtonItemStylePlain target:self action:@selector(handleAddColLayout:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark -- Layout Construction

//创建列布局视图
-(UIView*)createColLayout:(NSString*)image title:(NSString*)title
{
    MyLinearLayout *colLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    colLayout.gravity = MyMarginGravity_Horz_Fill;  //里面所有子视图的宽度都跟父视图保持一致，这样子视图就不需要设置宽度了。
    colLayout.wrapContentHeight = YES;
    colLayout.subviewMargin = 5;  //设置布局视图里面子视图之间的间距为5个点。
    colLayout.backgroundColor = [CFTool color:0];
    [colLayout setTarget:self action:@selector(handleColLayoutTap:)];
    colLayout.highlightedOpacity = 0.3; //设置触摸事件按下时的不透明度，来响应按下状态。
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    imageView.flexedHeight = YES;   //这个属性重点注意！！ 对于UIImageView来说，如果我们设置了这个属性为YES的话，表示视图的高度会根据视图的宽度进行等比例的缩放来确定，从而防止图片显示时出现变形的情况。
    [colLayout addSubview:imageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = [CFTool font:14];
    titleLabel.textColor = [CFTool color:4];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.myBottomMargin = 2;
    [titleLabel sizeToFit];
    [colLayout addSubview:titleLabel];
    
    
    
    return colLayout;
}


#pragma mark -- Handle Method

-(void)handleAddColLayout:(id)sender
{
    //获取表格布局中的每行的高度，找到高度最小的一行，如果高度都相等则选择索引号小的行。
    CGFloat minHeight = CGFLOAT_MAX;
    NSInteger rowIndex = 0;
    for (NSInteger i = 0; i < self.rootLayout.countOfRow; i++)
    {
        UIView *rowView = [self.rootLayout viewAtRowIndex:i];
        if (CGRectGetMaxY(rowView.frame) < minHeight)
        {
            minHeight = CGRectGetMaxY(rowView.frame);
            rowIndex = i;
        }
    }
    
    NSArray *images = @[@"p1-11",
                        @"p1-12",
                        @"p1-21",
                        @"p1-31",
                        @"p1-32",
                        @"p1-33",
                        @"p1-34",
                        @"p1-35",
                        @"image1",
                        @"image2",
                        @"image3",
                        @"image4"
                        ];
    
    static NSInteger sTag = 1000;
    
    
    UIView *colLayout = [self createColLayout:images[arc4random_uniform((uint32_t)images.count)]
                                          title:[NSString stringWithFormat:NSLocalizedString(@"cell title:%03ld", @""), (long)sTag]];
    colLayout.tag = sTag++;
    [self.rootLayout addCol:colLayout atRow:rowIndex];
}

-(void)handleColLayoutTap:(UIView*)sender
{
   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"cell:%03ld be selected", @""), (long)sender.tag] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
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

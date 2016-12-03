//
//  Test15ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/6.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "AllTest4ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

static NSInteger sBaseTag = 100000;

@interface AllTest4ViewController ()

@property(nonatomic, strong) MyLinearLayout *rootLayout;

@property(nonatomic,strong) NSMutableArray *containerLayouts;


@end

@implementation AllTest4ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CFTool color:0];
    
    NSArray *sections = @[@"品牌推荐",
                          @"时尚风格",
                          @"特价处理",
                          @"这是一段很长很长很长很长很长很长很长很长很长很长很长很长的文字"
                          ];
    
    NSArray *images = @[@"p1-11",
                        @"p1-12",
                        @"p1-21",
                        @"p1-31",
                        @"p1-32",
                        @"p1-33",
                        @"p1-34",
                        @"p1-35",
                        @"p1-36",
                        @"image1",
                        @"image2",
                        @"image3"
                        ];

    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //让uiscrollView的尺寸总是保持和父视图一致。
    [self.view addSubview:scrollView];
    
    _rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    _rootLayout.gravity = MyMarginGravity_Horz_Fill;  //设置垂直线性布局的水平填充值表明布局视图里面的所有子视图的宽度都和布局视图相等。
    
    _rootLayout.widthDime.equalTo(scrollView.widthDime);
    _rootLayout.wrapContentHeight = YES; //布局宽度和父视图一致，高度则由内容包裹。这是实现将布局视图加入滚动条视图并垂直滚动的标准方法。
    [scrollView addSubview:_rootLayout];
    
    self.containerLayouts = [NSMutableArray new];
    
    for (NSInteger i = 0; i < sections.count; i++)
    {
        //添加辅助视图
        [_rootLayout addSubview:[self createSupplementaryLayout:sections[i]]];
        
        //添加单元格容器视图
        MyFlowLayout *cellContainerLayout = [self createCellContainerLayout:i + 2];
        cellContainerLayout.myBottomMargin = 10;
        [self.containerLayouts addObject:cellContainerLayout];
        [_rootLayout addSubview:cellContainerLayout];
        
        //添加单元格视图
        NSInteger cellCount = arc4random_uniform(8) + 8; //随机数量，最少8个最多16个
        for (NSInteger j = 0; j < cellCount; j++)
        {
            UIView *cellLayout = [self createCellLayout1:images[arc4random_uniform((uint32_t)images.count)]
                                                     title:[NSString stringWithFormat:NSLocalizedString(@"cell title:%03ld", @""),(long)j]];
            cellLayout.tag = sBaseTag *i + j; //用于确定所在的辅助编号和单元格编号。
            
            [cellContainerLayout addSubview:cellLayout];
        }
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reverse" style:UIBarButtonItemStyleDone target:self action:@selector(handleReverse:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

//创建辅助布局视图
-(UIView*)createSupplementaryLayout:(NSString*)sectionTitle
{
    //建立一个相对布局
    MyRelativeLayout *supplementaryLayout = [MyRelativeLayout new];
    supplementaryLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    supplementaryLayout.myHeight = 40;
    supplementaryLayout.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];  //设置底部边界线。
    supplementaryLayout.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
    imageView.centerYPos.equalTo(supplementaryLayout.centerYPos);  //垂直居中
    imageView.rightPos.equalTo(supplementaryLayout.rightPos);      //和父视图右对齐。
    [supplementaryLayout addSubview:imageView];
        
    UILabel *sectionTitleLabel = [UILabel new];
    sectionTitleLabel.text = sectionTitle;
    sectionTitleLabel.adjustsFontSizeToFitWidth = YES;
    sectionTitleLabel.textColor = [CFTool color:4];
    sectionTitleLabel.font = [CFTool font:17];
    sectionTitleLabel.minimumScaleFactor = 0.7;
    sectionTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    sectionTitleLabel.centerYPos.equalTo(supplementaryLayout.centerYPos);  //垂直居中
    sectionTitleLabel.leftPos.equalTo(supplementaryLayout.leftPos);        //左边和父视图左对齐
    sectionTitleLabel.rightPos.equalTo(imageView.leftPos);                 //右边是图标的左边。
    [sectionTitleLabel sizeToFit];
    [supplementaryLayout addSubview:sectionTitleLabel];
    
    
    return supplementaryLayout;
}

//创建单元格容器布局视图，并指定每行的数量。
-(MyFlowLayout*)createCellContainerLayout:(NSInteger)arrangedCount
{
    MyFlowLayout *containerLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:arrangedCount];
    containerLayout.wrapContentHeight = YES;
    containerLayout.gravity = MyMarginGravity_Horz_Fill; //平均分配里面每个子视图的宽度或者拉伸子视图的宽度以便填充满整个布局。
    containerLayout.subviewHorzMargin = 5;
    containerLayout.subviewVertMargin = 5;
    containerLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    return containerLayout;
}

//创建单元格布局视图，其中的高度固定为100
-(UIView*)createCellLayout1:(NSString*)image title:(NSString*)title
{
    MyLinearLayout *cellLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    cellLayout.wrapContentHeight = NO;
    cellLayout.gravity = MyMarginGravity_Horz_Fill;  //里面所有子视图的宽度都跟父视图保持一致，这样子视图就不需要设置宽度了。
    cellLayout.myHeight = 100;
    cellLayout.subviewMargin = 5;  //设置布局视图里面子视图之间的间距为5个点。
    cellLayout.backgroundColor = [UIColor whiteColor];
    [cellLayout setTarget:self action:@selector(handleCellLayoutTap:)];
    cellLayout.highlightedOpacity = 0.3; //设置触摸事件按下时的不透明度，来响应按下状态。
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    imageView.weight = 1;   //图片视图占用剩余的高度。
    [cellLayout addSubview:imageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = [CFTool font:14];
    titleLabel.textColor = [CFTool color:4];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.myBottomMargin = 2;
    [titleLabel sizeToFit];
    [cellLayout addSubview:titleLabel];
    
    return cellLayout;

}



#pragma mark -- HandleMethod

-(void)handleCellLayoutTap:(UIView*)sender
{
   
    NSInteger supplementaryIndex = sender.tag / sBaseTag;
    NSInteger cellIndex = sender.tag % sBaseTag;
    
    NSString *message = [NSString stringWithFormat:@"You have select:\nSupplementaryIndex:%ld CellIndex:%ld",(long)supplementaryIndex, (long)cellIndex];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
   
}

-(void)handleReverse:(id)sender
{
    //MyBaseLayout的属性reverseLayout可以将子视图按照添加的顺序逆序布局。
    
    for (MyBaseLayout *layout in self.containerLayouts)
    {
        layout.reverseLayout = !layout.reverseLayout;
        [layout layoutAnimationWithDuration:0.3];
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

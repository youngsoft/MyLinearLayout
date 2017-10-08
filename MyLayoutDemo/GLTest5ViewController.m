//
//  GLTest5ViewController.m
//  MyLayout
//
//  Created by 吴斌 on 2017/9/14.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "GLTest5ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

static NSInteger sPartTag1 = 1000;
static NSInteger sPartTag2 = 1001;
static NSInteger sPartTag3 = 1002;
static NSInteger sPartTag4 = 1003;
static NSInteger sPartTag5 = 1004;


@interface GLTest5ViewController ()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@end

@implementation GLTest5ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLayout];
    
    [self bindView];
    
}


- (void)createLayout
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.myMargin = MyLayoutPos.safeAreaMargin;
    [self.view addSubview:rootLayout];
    self.rootLayout = rootLayout;
    
    //从JSON格式的文件中来构建栅格布局.
    NSString *jsonFilePath =  [NSBundle.mainBundle pathForResource:@"GridLayoutDemo5.json" ofType:nil];
    rootLayout.gridDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:NSJSONReadingAllowFragments error:nil];
}

-(void)bindView
{
    [self.rootLayout removeAllSubviews];
    
    //第一部分
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image2"]];
    UILabel *headTitleLabel = [UILabel new];
    headTitleLabel.backgroundColor = [CFTool color:2];
    headTitleLabel.textAlignment = NSTextAlignmentCenter;
    headTitleLabel.text = @"酒店0元住";
    headTitleLabel.font = [CFTool font:14];
    headTitleLabel.textColor = UIColor.whiteColor;
    
    UILabel *centerTitleLabel = [UILabel new];
    centerTitleLabel.backgroundColor = [CFTool color:3];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    centerTitleLabel.text = @"马上体验>";
    centerTitleLabel.font = [CFTool font:12];
    centerTitleLabel.textColor = UIColor.whiteColor;
    
    [self.rootLayout addViewGroup:@[backImageView,headTitleLabel,centerTitleLabel] withActionData:nil to:sPartTag1];
    
    
    //第二部分
    NSArray *titles = @[@"火车票立减50",@"国庆出境4免1",@"9元门票限量抢",@"高端酒店5折抢"];
    NSArray *images = @[@"image1",@"image2",@"image3",@"image4"];
    for (int i = 0; i < 4; i++)
    {
        UIImageView *titleBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[i]]];
        
        UILabel *headTitleLabel = [UILabel new];
        headTitleLabel.textAlignment = NSTextAlignmentCenter;
        headTitleLabel.text = titles[i];
        headTitleLabel.font = [CFTool font:14];
        headTitleLabel.textColor = UIColor.whiteColor;
        headTitleLabel.backgroundColor = [CFTool color:5];
        
        [self.rootLayout addViewGroup:@[titleBackImageView, headTitleLabel] withActionData:nil to:sPartTag2];
    }
    
    
    //第三部分
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"全球精选 大牌推荐";
    titleLabel.font = [CFTool font:24];
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.rootLayout addViewGroup:@[titleLabel] withActionData:nil to:sPartTag3];
    
    
    
    //第四部分
    NSArray *images2 = @[@"image2", @"image2"];
    NSArray *titles2 = @[@"火遍亚洲的\nINS双肩包",@"经典重工鞋\n靴 399元起"];
    for (int i = 0; i < 2; i++)
    {
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images2[i]]];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.6f];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.text = titles2[i];
        titleLabel.font = [CFTool font:13];
        titleLabel.textColor = UIColor.blackColor;
        titleLabel.numberOfLines = 2.f;
        
        [self.rootLayout addViewGroup:@[backImageView,titleLabel] withActionData:nil to:sPartTag4];
    }
    
    
    //第五部分
    UILabel *titleLabel2 = [UILabel new];
    titleLabel2.text = @"查看更多";
    titleLabel2.font = [CFTool font:16];
    titleLabel2.textColor = UIColor.blueColor;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
    
    [self.rootLayout addViewGroup:@[titleLabel2,arrowImageView] withActionData:nil to:sPartTag5];
    
}
@end

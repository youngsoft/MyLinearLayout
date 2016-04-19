//
//  FOLTest3ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "FOLTest3ViewController.h"
#import "MyLayout.h"

//数据模型
@interface DataModel : NSObject

@property(nonatomic,strong)  NSString *imageName; //图像的名称，如果为nil则没有图像
@property(nonatomic, strong) NSString *title; //标题
@property(nonatomic, strong) NSString *source; //来源

@end

@implementation DataModel

@end




@interface FOLTest3ViewController ()

@property(nonatomic, strong) MyFloatLayout *floatLayout;

@property(nonatomic, strong) NSMutableArray *datas;


@end

@implementation FOLTest3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"仿ZAKER新闻卡片布局";
    
    
    //构造6条数据,为了处理方便我们总是将有图的数据作为第一条，而实际中则会按新闻的时间返回数据数组。
    self.datas = [[NSMutableArray alloc] initWithCapacity:6];
    
    DataModel *data1 = [DataModel new];
    data1.imageName = @"p1";
    data1.title = @"广西鱼塘现大坑 一夜”吃掉“五万斤鱼";
    data1.source = @"";
    [self.datas addObject:data1];

    
    DataModel *data2 = [DataModel new];
    data2.imageName = nil;
    data2.title = @"习近平发展中国经济两个大局观";
    data2.source = @"专题";
    [self.datas addObject:data2];
    
    DataModel *data3 = [DataModel new];
    data3.imageName = nil;
    data3.title = @"习近平抵达不拉格开始对捷克国事访问";
    data3.source = @"专题";
    [self.datas addObject:data3];
    
    DataModel *data4 = [DataModel new];
    data4.imageName = nil;
    data4.title = @"解读：为何数万在缅汉族要入籍缅族";
    data4.source = @"海外网";
    [self.datas addObject:data4];
    
    
    DataModel *data5 = [DataModel new];
    data5.imageName = nil;
    data5.title = @"消费贷仍可用于首付银行：不可能杜绝";
    data5.source = @"新闻晨报";
    [self.datas addObject:data5];
    
    DataModel *data6 = [DataModel new];
    data6.imageName = nil;
    data6.title = @"3代人接力29年养保姆至108岁";
    data6.source = @"人民日报";
    [self.datas addObject:data6];
    
    
    // Do any additional setup after loading the view.
    _floatLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    _floatLayout.myMargin = 0;
    
    //通过智能分界线的使用，浮动布局里面的所有子布局视图的分割线都会进行智能的设置，从而解决了我们需求中需要提供边界线的问题。
    _floatLayout.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];
    _floatLayout.IntelligentBorderLine.headIndent = _floatLayout.IntelligentBorderLine.tailIndent = 5;
   // _floatLayout.IntelligentBorderLine.dash = 3;
    [self.view addSubview:_floatLayout];
    
    
    [self handleChangeStyle:nil];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"布局变换" style:UIBarButtonItemStylePlain target:self action:@selector(handleChangeStyle:)];
    
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

-(MyBaseLayout*)createPicNew:(DataModel*)dataModel
{
    
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    itemLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [itemLayout setTarget:self action:@selector(handleItemLayoutClick:)];
    itemLayout.highlightedBackgroundColor = [UIColor lightGrayColor];
    //让文字放入底部对齐。
    itemLayout.gravity = MyMarginGravity_Vert_Bottom;
    
    itemLayout.backgroundImage = [UIImage imageNamed:dataModel.imageName];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.weight = 1;
    titleLabel.numberOfLines = 0;
    titleLabel.flexedHeight = YES;
    titleLabel.text = dataModel.title;
    [itemLayout addSubview:titleLabel];
    
    itemLayout.heightDime.equalTo(_floatLayout.heightDime).multiply(2.0/5);
    itemLayout.widthDime.equalTo(_floatLayout.widthDime);
   
    return itemLayout;
}

-(MyBaseLayout*)createWholeWidthTextNew:(DataModel*)dataModel
{
    //里面每个元素可以是各种布局，这里为了突出浮动布局，因此条目布局也做成了浮动布局。
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    itemLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [itemLayout setTarget:self action:@selector(handleItemLayoutClick:)];
    itemLayout.highlightedBackgroundColor = [UIColor lightGrayColor];
    
    //让文字整体居中对齐
    itemLayout.gravity = MyMarginGravity_Vert_Center;
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.numberOfLines = 0;
    titleLabel.flexedHeight = YES;
    titleLabel.weight =1;
    [itemLayout addSubview:titleLabel];
    
    UILabel *sourceLabel = [UILabel new];
    sourceLabel.text = dataModel.source;
    sourceLabel.clearFloat = YES;
    sourceLabel.myTopMargin = 5;
    sourceLabel.font = [UIFont systemFontOfSize:11];
    sourceLabel.textColor = [UIColor lightGrayColor];
    [sourceLabel sizeToFit];
    [itemLayout addSubview:sourceLabel];
    
    itemLayout.heightDime.equalTo(_floatLayout.heightDime).multiply(1.0/5);
    itemLayout.widthDime.equalTo(_floatLayout.widthDime);
    
    return itemLayout;
    
}

-(MyBaseLayout*)createHalfWidthTextNew:(DataModel*)dataModel
{
    //里面每个元素可以是各种布局，这里为了突出浮动布局，因此条目布局也做成了浮动布局。
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    itemLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [itemLayout setTarget:self action:@selector(handleItemLayoutClick:)];
    itemLayout.highlightedBackgroundColor = [UIColor lightGrayColor];
    
    //让文字整体居中对齐
    itemLayout.gravity = MyMarginGravity_Vert_Center;
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.numberOfLines = 0;
    titleLabel.flexedHeight = YES;
    titleLabel.weight =1;
    [itemLayout addSubview:titleLabel];
    
    UILabel *sourceLabel = [UILabel new];
    sourceLabel.text = dataModel.source;
    sourceLabel.clearFloat = YES;
    sourceLabel.myTopMargin = 5;
    sourceLabel.font = [UIFont systemFontOfSize:11];
    sourceLabel.textColor = [UIColor lightGrayColor];
    [sourceLabel sizeToFit];
    [itemLayout addSubview:sourceLabel];
    
    itemLayout.heightDime.equalTo(_floatLayout.heightDime).multiply(1.0/5);
    itemLayout.widthDime.equalTo(_floatLayout.widthDime).multiply(0.5);
    
    return itemLayout;

}

-(void)handleChangeStyle:(id)sender
{
    
    //zaker的每页新闻中都有6条新闻，其中一条图片新闻和5条文字新闻。在布局上则高度分为5份，其中的图片新闻则占据了2/5，而高度则是全屏。
    //其他的5条新闻则分为3行来均分剩余的高度，而宽度则是有4条是屏幕宽度的一半，一条是全部屏幕的宽度。然后zaker通过配置好的模板来展示每个
    //不同的页，我们的例子为了展现效果。我们将随机产生4条半屏和1条全屏文字新闻和一张图片新闻。
    
    //6条新闻中，我们有有一条图片新闻的宽度和屏幕宽度一致，高度是屏幕高度的2/5。 有一条新闻的宽度和屏幕宽度一致，高度为屏幕高度的1/5。另外四条新闻
    //的宽度是屏幕宽度的一半，高度是屏幕高度的1/5。
    //我们将宽度为全屏宽度的文字新闻定义为1，而将半屏宽度的文字新闻视图定义为2，而将图片新闻的视图定义为3 这样就会形成1322,3122,1232,3212,1223,3221,2123,2321, 2132,2312, 2213,2231 一共12种布局
    //这样我们可以随机选取一种布局方式
    
    //所有可能的布局数组。
    int layoutStyless[12][4] = {
        {1,3,2,2},
        {3,1,2,2},
        {1,2,3,2},
        {3,2,1,2},
        {1,2,2,3},
        {3,2,2,1},
        {2,1,2,3},
        {2,3,2,1},
        {2,1,3,2},
        {2,3,1,2},
        {2,2,1,3},
        {2,2,3,1}};
    
    //随机取得一个布局。
    int *pLayoutStyles = layoutStyless[rand() % 12];
    
    
    while (self.floatLayout.subviews.count > 0) {
        [self.floatLayout.subviews.lastObject removeFromSuperview];
    }
    
    int index = 1;
    for (int i = 0; i < 4; i++)
    {
        int layoutStyle = pLayoutStyles[i];
        
       if (layoutStyle == 1)  //全部宽度文字新闻布局
       {
           [self.floatLayout addSubview:[self createWholeWidthTextNew:self.datas[index]]];
           index++;
       }
       else if (layoutStyle == 3)  //图片新闻布局
       {
           [self.floatLayout addSubview:[self createPicNew:self.datas[0]]];
       }
       else   //半宽文字新闻布局
       {
           [self.floatLayout addSubview:[self createHalfWidthTextNew:self.datas[index]]];
           index++;
           [self.floatLayout addSubview:[self createHalfWidthTextNew:self.datas[index]]];
           index++;
       }
    }
}

-(void)handleItemLayoutClick:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"详情" message:@"详情信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end

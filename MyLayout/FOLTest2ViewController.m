//
//  FOLTest2ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//
#import "MyLayout.h"

#import "FOLTest2ViewController.h"


//数据模型。
@interface TBDataModel : NSObject

@property(nonatomic, strong) NSString *title;   //标题
@property(nonatomic, strong) NSString *subTitle; //副标题
@property(nonatomic, strong) NSString *desc;     //描述
@property(nonatomic, strong) NSString *price;    //价格
@property(nonatomic, strong) NSString *image;    //图片。
@property(nonatomic, strong) NSString *subImage; //子图片。


@end

@implementation TBDataModel


@end

@interface FOLTest2ViewController ()

@property(nonatomic, strong) MyLinearLayout *rootLayout;


@end

@implementation FOLTest2ViewController


//各种不同风格的条目布局
#pragma mark -- 各种风格的条目布局。

//品牌特卖主条目布局
-(MyFloatLayout*)createItemLayout1_1:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    UIImageView *subImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.subImage]];
    subImageView.myLeftMargin = 5;
    subImageView.myTopMargin = 5;
    subImageView.myHeight = 20;
    [subImageView sizeToFit];
    [itemLayout addSubview:subImageView];
    
    
    //占用剩余的高度，宽度和父布局相等。
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.weight = 1;
    imageView.widthDime.equalTo(itemLayout.widthDime);
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}

//天猫超市条目布局
-(MyFloatLayout*)createItemLayout1_2:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.widthDime.equalTo(itemLayout.widthDime);
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    subTitleLabel.widthDime.equalTo(itemLayout.widthDime);
    subTitleLabel.myLeftMargin = 5;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.reverseFloat = YES;
    imageView.myRightMargin = 5;
    [imageView sizeToFit];
    [itemLayout addSubview:imageView];
    
    return itemLayout;
    
}

-(MyFloatLayout*)createItemLayout1_3:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.heightDime.equalTo(itemLayout.heightDime);
    imageView.reverseFloat = YES;
    [imageView sizeToFit];
    [itemLayout addSubview:imageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    titleLabel.weight = 1;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.clearFloat = YES;
    subTitleLabel.weight = 1;
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.flexedHeight = YES;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    
    if (dataModel.subImage != nil)
    {
        UIImageView *subImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.subImage]];
        subImageView.clearFloat = YES;
        subImageView.myLeftMargin = 5;
        [subImageView sizeToFit];
        [itemLayout addSubview:subImageView];
    }
    
    
    return itemLayout;
}

-(MyFloatLayout*)createItemLayout2_1:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    
    itemLayout.backgroundImage = [UIImage imageNamed:dataModel.image];
    
    return itemLayout;
}


//精选市场
-(MyFloatLayout*)createItemLayout3_1:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.text = dataModel.price;
    priceLabel.font = [UIFont systemFontOfSize:11];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.myLeftMargin = 5;
    priceLabel.myBottomMargin = 5;
    [priceLabel sizeToFit];
    priceLabel.reverseFloat = YES;
    [itemLayout addSubview:priceLabel];
    
    UILabel *descLabel = [UILabel new];
    descLabel.text = dataModel.desc;
    descLabel.font = [UIFont systemFontOfSize:11];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.myLeftMargin = 5;
    [descLabel sizeToFit];
    descLabel.reverseFloat = YES;
    [itemLayout addSubview:descLabel];

    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.widthDime.equalTo(itemLayout.widthDime);
    imageView.weight = 1;
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}

-(MyFloatLayout*)createItemLayout3_2:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    titleLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    subTitleLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [itemLayout addSubview:subTitleLabel];
    
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.text = dataModel.price;
    priceLabel.font = [UIFont systemFontOfSize:11];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.myLeftMargin = 5;
    priceLabel.myBottomMargin = 5;
    [priceLabel sizeToFit];
    priceLabel.reverseFloat = YES;
    priceLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [itemLayout addSubview:priceLabel];
    
    UILabel *descLabel = [UILabel new];
    descLabel.text = dataModel.desc;
    descLabel.font = [UIFont systemFontOfSize:11];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.myLeftMargin = 5;
    [descLabel sizeToFit];
    descLabel.reverseFloat = YES;
    descLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [itemLayout addSubview:descLabel];
    
      UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
     imageView.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
     imageView.heightDime.equalTo(itemLayout.heightDime);
     [itemLayout addSubview:imageView];
    

    
    return itemLayout;
}


-(MyFloatLayout*)createItemLayout4_1:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    titleLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    subTitleLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [itemLayout addSubview:subTitleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    imageView.heightDime.equalTo(itemLayout.heightDime);
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}


-(MyFloatLayout*)createItemLayout4_2:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.widthDime.equalTo(itemLayout.widthDime);
    imageView.weight = 1;
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}




-(MyFloatLayout*)createItemLayout5_1:(TBDataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.textColor = [UIColor redColor];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.widthDime.equalTo(itemLayout.widthDime);
    imageView.weight = 1;   //图片占用剩余的全部高度
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}



//其他布局
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view = scrollView;
    self.rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    self.rootLayout.myLeftMargin = self.rootLayout.myRightMargin = 0;
    self.rootLayout.gravity = MyMarginGravity_Horz_Fill;
    self.rootLayout.backgroundColor = [UIColor colorWithWhite:0xe7/255.0 alpha:1];
    self.rootLayout.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]]; //智能边界线
    [scrollView addSubview:self.rootLayout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"仿天猫淘宝首页布局";
    
    //数据模型
    TBDataModel *d1_1 = [TBDataModel new];
    d1_1.title = @"品牌特卖";
    d1_1.image = @"p1-11";
    d1_1.subImage = @"p1-12";

    
    
    TBDataModel *d1_31 = [TBDataModel new];
    d1_31.title = @"焕新";
    d1_31.subTitle = @"海军风荷叶摆";
    d1_31.image = @"p1-31";
    d1_31.subImage = @"p1-36";
    
    TBDataModel *d1_32 = [TBDataModel new];
    d1_32.title = @"必抢";
    d1_32.subTitle = @"购物券翻倍减最高立减100元";
    d1_32.image = @"p1-32";
    
    TBDataModel *d1_2 = [TBDataModel new];
    d1_2.title = @"天猫超市";
    d1_2.subTitle = @"买2付1再送电动牙刷";
    d1_2.image = @"p1-21";
    
    
    TBDataModel *d1_33 = [TBDataModel new];
    d1_33.title = @"全球精选";
    d1_33.subTitle = @"line限量气垫99元";
    d1_33.image = @"p1-33";
    d1_33.subImage = @"p1-36";

    TBDataModel *d1_34 = [TBDataModel new];
    d1_34.title = @"苏宁易购";
    d1_34.subTitle = @"iPhone SE 全网通新产品发售 原封全国";
    d1_34.image = @"p1-34";


    TBDataModel *d1_35 = [TBDataModel new];
    d1_35.title = @"免费试用";
    d1_35.subTitle = @"欧美范儿显瘦T裙春日新装";
    d1_35.image = @"p1-35";
    
    //品牌日
    TBDataModel *d2_1 = [TBDataModel new];
    d2_1.image = @"p2-1";
    
    TBDataModel *d2_2 = [TBDataModel new];
    d2_2.image = @"p2-3";
    
    TBDataModel *d2_3 = [TBDataModel new];
    d2_3.image = @"p2-3";
    
    TBDataModel *d2_4 = [TBDataModel new];
    d2_4.image = @"p2-4";

    
    TBDataModel *d3_1 = [TBDataModel new];
    d3_1.title = @"天天搞机";
    d3_1.subTitle = @"小米5开售";
    d3_1.image = @"p3-1";
    d3_1.desc = @"10点开抢";
    d3_1.price = @"￥1999";
    
    TBDataModel *d3_21 = [TBDataModel new];
    d3_21.title = @"全球时尚";
    d3_21.subTitle = @"大牌精致时尚";
    d3_21.image = @"p3-21";
    d3_21.desc = @"清新小花";
    d3_21.price = @"";
    
    TBDataModel *d3_22 = [TBDataModel new];
    d3_22.title = @"物色";
    d3_22.subTitle = @"每日惊喜主题";
    d3_22.image = @"p3-22";
    d3_22.desc = @"减龄背带裤";
    d3_22.price = @"￥189";
    
    TBDataModel *d3_23 = [TBDataModel new];
    d3_23.title = @"生活家";
    d3_23.subTitle = @"好生活并不贵";
    d3_23.image = @"p3-23";
    d3_23.desc = @"樱花手机壳";
    d3_23.price = @"￥37";
    
    TBDataModel *d3_24 = [TBDataModel new];
    d3_24.title = @"喵鲜生";
    d3_24.subTitle = @"全进口好生鲜";
    d3_24.image = @"p3-24";
    d3_24.desc = @"抢无门槛红包";
    d3_24.price = @"￥49";

    
    TBDataModel *d4_11 = [TBDataModel new];
    d4_11.title = @"天猫女装";
    d4_11.subTitle = @"大牌1折起";
    d4_11.image = @"p4-11";
   
    TBDataModel *d4_12 = [TBDataModel new];
    d4_12.title = @"天猫男装";
    d4_12.subTitle = @"商场同款5折";
    d4_12.image = @"p4-12";

    TBDataModel *d4_21 = [TBDataModel new];
    d4_21.title = @"鞋履";
    d4_21.subTitle = @"寒冬不再冷";
    d4_21.image = @"p4-21";

    TBDataModel *d4_22 = [TBDataModel new];
    d4_22.title = @"母婴玩具";
    d4_22.subTitle = @"新年新装备";
    d4_22.image = @"p4-22";

    TBDataModel *d4_23 = [TBDataModel new];
    d4_23.title = @"美妆";
    d4_23.subTitle = @"新春送礼";
    d4_23.image = @"p4-23";

    TBDataModel *d4_24 = [TBDataModel new];
    d4_24.title = @"电器城";
    d4_24.subTitle = @"工夫熊猫来啦";
    d4_24.image = @"p4-24";

    
    TBDataModel *d5_1 = [TBDataModel new];
    d5_1.title = @"布置小家";
    d5_1.subTitle = @"格调摆件低价";
    d5_1.image = @"p5-1";
    
    TBDataModel *d5_2 = [TBDataModel new];
    d5_2.title = @"疯狂吃货";
    d5_2.subTitle = @"零食9元起";
    d5_2.image = @"p5-2";
    
    TBDataModel *d5_3 = [TBDataModel new];
    d5_3.title = @"妈咪萌宝";
    d5_3.subTitle = @"为宝贝超划算";
    d5_3.image = @"p5-3";
    
    TBDataModel *d5_4 = [TBDataModel new];
    d5_4.title = @"有车一族";
    d5_4.subTitle = @"爱车装备优惠";
    d5_4.image = @"p5-4";
    


    

    
    //平台特卖模型布局。每个条目的高度为50
    //这里的所有条目布局都用浮动布局，是为了展示浮动布局的使用。但实际中可以使用其他的布局。
    CGFloat itemHeight = 90;
    
    //品牌特卖
    MyFloatLayout *layout1 = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    layout1.backgroundColor = [UIColor whiteColor];
    layout1.wrapContentHeight = YES;
    layout1.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
    [self.rootLayout addSubview:layout1];
    
    MyBaseLayout *itemLayout = [self createItemLayout1_1:d1_1];
    itemLayout.heightDime.equalTo(@(itemHeight*2));
    itemLayout.widthDime.equalTo(layout1.widthDime).multiply(0.5);
    [layout1 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout1_3:d1_31];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout1.widthDime).multiply(0.5);
    [layout1 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout1_3:d1_32];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout1.widthDime).multiply(0.5);
    [layout1 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout1_2:d1_2];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout1.widthDime).multiply(0.5);
    [layout1 addSubview:itemLayout];

    itemLayout = [self createItemLayout1_3:d1_33];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout1.widthDime).multiply(0.5);
    [layout1 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout1_3:d1_34];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout1.widthDime).multiply(0.5);
    [layout1 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout1_3:d1_35];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout1.widthDime).multiply(0.5);
    [layout1 addSubview:itemLayout];
    
  
    //超级品牌日
    UILabel *label = [UILabel new];
    label.text = @"超级品牌日";
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.myHeight = 30;
    label.myTopMargin = 10;
    [self.rootLayout addSubview:label];
    
    MyFloatLayout *layout2 = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    layout2.backgroundColor = [UIColor whiteColor];
    layout2.wrapContentHeight = YES;
    layout2.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
    [self.rootLayout addSubview:layout2];
    
    itemLayout = [self createItemLayout2_1:d2_1];
    itemLayout.widthDime.equalTo(layout2.widthDime).multiply(0.5);
    itemLayout.heightDime.equalTo(@(itemHeight * 2));
    [layout2 addSubview:itemLayout];
    
    
    itemLayout = [self createItemLayout2_1:d2_2];
    itemLayout.widthDime.equalTo(layout2.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight * 2));
    [layout2 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout2_1:d2_3];
    itemLayout.widthDime.equalTo(layout2.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight * 2));
    [layout2 addSubview:itemLayout];
    
    
    itemLayout = [self createItemLayout2_1:d2_4];
    itemLayout.widthDime.equalTo(layout2.widthDime);
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.notUseIntelligentBorderLine = YES;
    [layout2 addSubview:itemLayout];
    

    //精选市场
    label = [UILabel new];
    label.text = @"精选市场";
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.myHeight = 30;
    label.myTopMargin = 10;
    [self.rootLayout addSubview:label];
    
    
    MyFloatLayout *layout3 = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    layout3.backgroundColor = [UIColor whiteColor];
    layout3.wrapContentHeight = YES;
    layout3.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
    [self.rootLayout addSubview:layout3];
    
    itemLayout = [self createItemLayout3_1:d3_1];
    itemLayout.heightDime.equalTo(@(itemHeight * 2));
    itemLayout.widthDime.equalTo(layout3.widthDime).multiply(0.4);
    [layout3 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout3_2:d3_21];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout3.widthDime).multiply(0.6);
    [layout3 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout3_2:d3_22];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout3.widthDime).multiply(0.6);
    [layout3 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout3_2:d3_23];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout3.widthDime).multiply(0.4);
    [layout3 addSubview:itemLayout];

    itemLayout = [self createItemLayout3_2:d3_24];
    itemLayout.heightDime.equalTo(@(itemHeight));
    itemLayout.widthDime.equalTo(layout3.widthDime).multiply(0.6);
    [layout3 addSubview:itemLayout];

    
    //热门市场
    label = [UILabel new];
    label.text = @"热门市场";
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.myHeight = 30;
    label.myTopMargin = 10;
    [self.rootLayout addSubview:label];
    
    
    MyFloatLayout *layout4 = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    layout4.backgroundColor = [UIColor whiteColor];
    layout4.wrapContentHeight = YES;
    layout4.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
    [self.rootLayout addSubview:layout4];
    
    itemLayout = [self createItemLayout4_1:d4_11];
    itemLayout.widthDime.equalTo(layout4.widthDime).multiply(0.5);
    itemLayout.heightDime.equalTo(@(itemHeight));
    [layout4 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout4_1:d4_12];
    itemLayout.widthDime.equalTo(layout4.widthDime).multiply(0.5);
    itemLayout.heightDime.equalTo(@(itemHeight));
    [layout4 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout4_2:d4_21];
    itemLayout.widthDime.equalTo(layout4.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight + 20));
    [layout4 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout4_2:d4_22];
    itemLayout.widthDime.equalTo(layout4.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight + 20));
    [layout4 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout4_2:d4_23];
    itemLayout.widthDime.equalTo(layout4.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight + 20));
    [layout4 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout4_2:d4_24];
    itemLayout.widthDime.equalTo(layout4.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight + 20));
    [layout4 addSubview:itemLayout];
    

    //主题市场
    label = [UILabel new];
    label.text = @"主题市场";
    label.font = [UIFont boldSystemFontOfSize:15];
    label.backgroundColor = [UIColor whiteColor];
    label.myHeight = 30;
    label.myTopMargin = 10;
    [self.rootLayout addSubview:label];

    MyFloatLayout *layout5 = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    layout5.backgroundColor = [UIColor whiteColor];
    layout5.wrapContentHeight = YES;
    layout5.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
    [self.rootLayout addSubview:layout5];
    
    
    itemLayout = [self createItemLayout5_1:d5_1];
    itemLayout.widthDime.equalTo(layout5.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight + 20));
    [layout5 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout5_1:d5_2];
    itemLayout.widthDime.equalTo(layout5.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight + 20));
    [layout5 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout5_1:d5_3];
    itemLayout.widthDime.equalTo(layout5.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight + 20));
    [layout5 addSubview:itemLayout];
    
    itemLayout = [self createItemLayout5_1:d5_4];
    itemLayout.widthDime.equalTo(layout5.widthDime).multiply(0.25);
    itemLayout.heightDime.equalTo(@(itemHeight + 20));
    [layout5 addSubview:itemLayout];

    
    

    
    
    
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

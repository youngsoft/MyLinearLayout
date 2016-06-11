//
//  FOLTest2ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//
#import "MyLayout.h"

#import "FOLTest2ViewController.h"

static CGFloat sItemLayoutHeight = 90;
static NSInteger sBaseTag = 100000;


//布局模型
@interface FOLTest2LayoutTemplate : NSObject

@property(nonatomic, assign) SEL layoutSelector;  //布局实现的方法
@property(nonatomic, assign) CGFloat width;       //布局宽度，如果设置的值<=1则是相对宽度
@property(nonatomic, assign) CGFloat height;      //布局高度，如果设置的值<=1则是相对高度

@end

@implementation FOLTest2LayoutTemplate

@end



//数据模型。
@interface FOLTest2DataModel : NSObject

@property(nonatomic, strong) NSString *title;    //标题
@property(nonatomic, strong) NSString *subTitle; //副标题
@property(nonatomic, strong) NSString *desc;     //描述
@property(nonatomic, strong) NSString *price;    //价格
@property(nonatomic, strong) NSString *image;    //图片。
@property(nonatomic, strong) NSString *subImage; //子图片。
@property(nonatomic, assign) NSInteger templateIndex;  //数据模型使用布局的索引。通常由服务端决定使用的布局模型，所以这里作为一个属性保存在模型数据结构中。


@end

@implementation FOLTest2DataModel


@end

//数据片段模型。
@interface FOLTest2SectionModel : NSObject

@property(nonatomic, strong) NSString *title;      //片段标题
@property(nonatomic, strong) NSMutableArray *datas;  //数据

@end

@implementation FOLTest2SectionModel


@end




@interface FOLTest2ViewController ()

@property(nonatomic, strong) MyLinearLayout *rootLayout;

@property(nonatomic, strong) NSMutableArray *layoutTemplates;  //所有的布局模板数组

@property(nonatomic, strong) NSMutableArray *sectionDatas;    //片段数据数组，FOLTest2SectionModel类型的元素。

@end

@implementation FOLTest2ViewController

//界面布局模板数组
-(NSMutableArray*)layoutTemplates
{
    if (_layoutTemplates == nil)
    {
        _layoutTemplates = [NSMutableArray new];
        
        NSArray *templateSources = @[@{
                                         @"selector":@"createItemLayout1_1:",
                                         @"width":@0.5,
                                         @"height":@(sItemLayoutHeight*2),
                                         },
                                     @{
                                         @"selector":@"createItemLayout1_2:",
                                         @"width":@0.5,
                                         @"height":@(sItemLayoutHeight),
                                         },
                                     @{
                                         @"selector":@"createItemLayout1_3:",
                                         @"width":@0.5,
                                         @"height":@(sItemLayoutHeight),
                                         },
                                     @{
                                         @"selector":@"createItemLayout2_1:",
                                         @"width":@0.5,
                                         @"height":@(sItemLayoutHeight * 2),
                                         },
                                     @{
                                         @"selector":@"createItemLayout2_1:",
                                         @"width":@0.25,
                                         @"height":@(sItemLayoutHeight * 2),
                                         },
                                     @{
                                         @"selector":@"createItemLayout2_1:",
                                         @"width":@1,
                                         @"height":@(sItemLayoutHeight),
                                         },
                                     @{
                                         @"selector":@"createItemLayout3_1:",
                                         @"width":@0.4,
                                         @"height":@(sItemLayoutHeight * 2),
                                         },
                                     @{
                                         @"selector":@"createItemLayout3_2:",
                                         @"width":@0.6,
                                         @"height":@(sItemLayoutHeight),
                                         },
                                     @{
                                         @"selector":@"createItemLayout3_2:",
                                         @"width":@0.4,
                                         @"height":@(sItemLayoutHeight),
                                         },
                                     @{
                                         @"selector":@"createItemLayout4_1:",
                                         @"width":@0.5,
                                         @"height":@(sItemLayoutHeight),
                                         },
                                     @{
                                         @"selector":@"createItemLayout4_2:",
                                         @"width":@0.25,
                                         @"height":@(sItemLayoutHeight + 20),
                                         },
                                     @{
                                         @"selector":@"createItemLayout5_1:",
                                         @"width":@0.25,
                                         @"height":@(sItemLayoutHeight + 20),
                                         }
                                     ];
        
        
        
        for (NSDictionary *dict in templateSources)
        {
            FOLTest2LayoutTemplate *template = [FOLTest2LayoutTemplate new];
            
            template.layoutSelector = NSSelectorFromString(dict[@"selector"]);
            template.width = [dict[@"width"] doubleValue];
            template.height = [dict[@"height"] doubleValue];
            
            [_layoutTemplates addObject:template];
            
        }
        
    }
    
    return _layoutTemplates;
}

//片段数据数组
-(NSMutableArray*)sectionDatas
{
    if (_sectionDatas == nil)
    {
        _sectionDatas = [NSMutableArray new];
        
        NSArray *dataSources = @[@{@"title:":@"",
                                   @"datas":@[@{
                                                  @"title":@"品牌特卖",
                                                  @"image":@"p1-11",
                                                  @"subImage":@"p1-12",
                                                  @"templateIndex":@0
                                                  },
                                              @{
                                                  @"title":@"焕新",
                                                  @"subTitle":@"海军风荷叶摆",
                                                  @"image":@"p1-31",
                                                  @"subImage":@"p1-36",
                                                  @"templateIndex":@2
                                                  },
                                              @{
                                                  @"title":@"必抢",
                                                  @"subTitle":@"购物券翻倍减最高立减100元",
                                                  @"image":@"p1-32",
                                                  @"templateIndex":@2
                                                  },
                                              @{
                                                  @"title":@"天猫超市",
                                                  @"subTitle":@"买2付1再送电动牙刷",
                                                  @"image":@"p1-21",
                                                  @"templateIndex":@1
                                                  },
                                              @{
                                                  @"title":@"全球精选",
                                                  @"subTitle":@"line限量气垫99元",
                                                  @"image":@"p1-33",
                                                  @"subImage":@"p1-36",
                                                  @"templateIndex":@2
                                                  },
                                              @{
                                                  @"title":@"苏宁易购",
                                                  @"subTitle":@"iPhone SE 全网通新产品发售 原封全国",
                                                  @"image":@"p1-34",
                                                  @"templateIndex":@2
                                                  },
                                              @{
                                                  @"title":@"免费试用",
                                                  @"subTitle":@"欧美范儿显瘦T裙春日新装",
                                                  @"image":@"p1-35",
                                                  @"templateIndex":@2
                                                  }]
                                   },
                                 @{@"title":@"超级品牌日",
                                   @"datas":@[@{
                                                  @"image":@"p2-1",
                                                  @"templateIndex":@3
                                                  },
                                              @{
                                                  @"image":@"p2-3",
                                                  @"templateIndex":@4
                                                  },
                                              @{
                                                  @"image":@"p2-3",
                                                  @"templateIndex":@4
                                                  },
                                              @{
                                                  @"image":@"p2-4",
                                                  @"templateIndex":@5
                                                  }]
                                   },
                                 @{@"title":@"精选市场",
                                   @"datas":@[@{
                                                  @"title":@"天天搞机",
                                                  @"subTitle":@"小米5开售",
                                                  @"image":@"p3-1",
                                                  @"desc":@"10点开抢",
                                                  @"price":@"￥1999",
                                                  @"templateIndex":@6
                                                  },
                                              @{
                                                  @"title":@"全球时尚",
                                                  @"subTitle":@"大牌精致时尚",
                                                  @"image":@"p3-21",
                                                  @"desc":@"清新小花",
                                                  @"price":@"",
                                                  @"templateIndex":@7
                                                  },
                                              @{
                                                  @"title":@"物色",
                                                  @"subTitle":@"每日惊喜主题",
                                                  @"image":@"p3-22",
                                                  @"desc":@"减龄背带裤",
                                                  @"price":@"￥189",
                                                  @"templateIndex":@7
                                                  },
                                              @{
                                                  @"title":@"生活家",
                                                  @"subTitle":@"好生活并不贵",
                                                  @"image":@"p3-23",
                                                  @"desc":@"樱花手机壳",
                                                  @"price":@"￥37",
                                                  @"templateIndex":@8
                                                  },
                                              @{
                                                  @"title":@"喵鲜生",
                                                  @"subTitle":@"全进口好生鲜",
                                                  @"image":@"p3-24",
                                                  @"desc":@"抢无门槛红包",
                                                  @"price":@"￥49",
                                                  @"templateIndex":@7
                                                  }]
                                   },
                                 @{@"title":@"热门市场",
                                   @"datas":@[@{
                                                  @"title":@"天猫女装",
                                                  @"subTitle":@"大牌1折起",
                                                  @"image":@"p4-11",
                                                  @"templateIndex":@9
                                                  },
                                              @{
                                                  @"title":@"天猫男装",
                                                  @"subTitle":@"商场同款5折",
                                                  @"image":@"p4-12",
                                                  @"templateIndex":@9
                                                  },
                                              @{
                                                  @"title":@"鞋履",
                                                  @"subTitle":@"寒冬不再冷",
                                                  @"image":@"p4-21",
                                                  @"templateIndex":@10
                                                  },
                                              @{
                                                  @"title":@"母婴玩具",
                                                  @"subTitle":@"新年新装备",
                                                  @"image":@"p4-22",
                                                  @"templateIndex":@10
                                                  },
                                              @{
                                                  @"title":@"美妆",
                                                  @"subTitle":@"新春送礼",
                                                  @"image":@"p4-23",
                                                  @"templateIndex":@10
                                                  },
                                              @{
                                                  @"title":@"电器城",
                                                  @"subTitle":@"工夫熊猫来啦",
                                                  @"image":@"p4-24",
                                                  @"templateIndex":@10
                                                  }]
                                   },
                                 @{@"title":@"主题市场",
                                   @"datas":@[@{
                                                  @"title":@"布置小家",
                                                  @"subTitle":@"格调摆件低价",
                                                  @"image":@"p5-1",
                                                  @"templateIndex":@11
                                                  },
                                              @{
                                                  @"title":@"疯狂吃货",
                                                  @"subTitle":@"零食9元起",
                                                  @"image":@"p5-2",
                                                  @"templateIndex":@11
                                                  },
                                              @{
                                                  @"title":@"妈咪萌宝",
                                                  @"subTitle":@"为宝贝超划算",
                                                  @"image":@"p5-3",
                                                  @"templateIndex":@11
                                                  },
                                              @{
                                                  @"title":@"有车一族",
                                                  @"subTitle":@"爱车装备优惠",
                                                  @"image":@"p5-4",
                                                  @"templateIndex":@11
                                                  }]
                                   }
                                 ];
        
        
        
        for (NSDictionary *sectionDict in dataSources)
        {
            FOLTest2SectionModel *sectionModel = [FOLTest2SectionModel new];
            sectionModel.title = sectionDict[@"title"];
            sectionModel.datas = [NSMutableArray new];
            
            
            for (NSDictionary *dict in sectionDict[@"datas"])
            {
                FOLTest2DataModel *model = [FOLTest2DataModel new];
                [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
                    [model setValue:obj forKey:key];
                }];
                
                [sectionModel.datas addObject:model];
            }
            
            [_sectionDatas addObject:sectionModel];
        }
    }
    
    
    return _sectionDatas;
    
    
}

//其他布局
-(void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    
    self.rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    self.rootLayout.myLeftMargin = self.rootLayout.myRightMargin = 0;
    self.rootLayout.gravity = MyMarginGravity_Horz_Fill;
    self.rootLayout.backgroundColor = [UIColor colorWithWhite:0xe7/255.0 alpha:1];
    self.rootLayout.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]]; //设置智能边界线，布局里面的子视图会根据布局自动产生边界线。
    [scrollView addSubview:self.rootLayout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    for (NSInteger i = 0; i < self.sectionDatas.count; i++)
    {
        [self addSectionLayout:i];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

//添加片段布局
-(void)addSectionLayout:(NSInteger)sectionIndex
{
    
    FOLTest2SectionModel *sectionModel = self.sectionDatas[sectionIndex];
    
    //如果有标题则创建标题文本
    if (sectionModel.title.length != 0)
    {
        UILabel *sectionTitleLabel = [UILabel new];
        sectionTitleLabel.text = sectionModel.title;
        sectionTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        sectionTitleLabel.backgroundColor = [UIColor whiteColor];
        sectionTitleLabel.myHeight = 30;
        sectionTitleLabel.myTopMargin = 10;
        [self.rootLayout addSubview:sectionTitleLabel];
    }
    
    //创建条目容器布局。
    MyFloatLayout *itemContainerLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    itemContainerLayout.backgroundColor = [UIColor whiteColor];
    itemContainerLayout.wrapContentHeight = YES;
    itemContainerLayout.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
    [self.rootLayout addSubview:itemContainerLayout];
    
    //创建条目布局，并加入到容器布局中去。
    for (NSInteger i = 0; i < sectionModel.datas.count; i++)
    {
        FOLTest2DataModel *model = sectionModel.datas[i];
        
        FOLTest2LayoutTemplate *layoutTemplate = self.layoutTemplates[model.templateIndex];  //取出数据模型对应的布局模板对象。
        
        
        //布局模型对象的layoutSelector负责建立布局，并返回一个布局条目布局视图。
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        MyBaseLayout *itemLayout = [self performSelector:layoutTemplate.layoutSelector withObject:model];
#pragma clang diagnostic pop
        itemLayout.tag = sectionIndex * sBaseTag + i;
        [itemLayout setTarget:self action:@selector(handleItemLayoutTap:)];
        itemLayout.highlightedOpacity = 0.4;
        
        
        //根据上面布局模型对高度和宽度的定义指定条目布局的尺寸。如果小于等于1则用相对尺寸，否则用绝对尺寸。
        if (layoutTemplate.width <= 1)
            itemLayout.widthDime.equalTo(itemContainerLayout.widthDime).multiply(layoutTemplate.width);
        else
            itemLayout.widthDime.equalTo(@(layoutTemplate.width));
        
        if (layoutTemplate.height <= 1)
            itemLayout.heightDime.equalTo(itemContainerLayout.heightDime).multiply(layoutTemplate.height);
        else
            itemLayout.heightDime.equalTo(@(layoutTemplate.height));
        
        [itemContainerLayout addSubview:itemLayout];
    }

    
}


//品牌特卖主条目布局,这是一个从上到下的布局,因此可以用上下浮动来实现。
-(MyFloatLayout*)createItemLayout1_1:(FOLTest2DataModel*)dataModel
{
    /*
      这个例子是为了重点演示浮动布局，所以里面的所有条目布局都用了浮动布局。您也可以使用其他布局来建立您的条目布局。
     */
    
    //建立上下浮动布局
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    //向上浮动，左边顶部边距为5
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    //向上浮动，左边顶部边距为5，高度为20
    UIImageView *subImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.subImage]];
    subImageView.myLeftMargin = 5;
    subImageView.myTopMargin = 5;
    subImageView.myHeight = 20;
    [subImageView sizeToFit];
    [itemLayout addSubview:subImageView];
    
    
    //向上浮动，高度占用剩余的高度，宽度和父布局保持一致。
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.weight = 1;
    imageView.widthDime.equalTo(itemLayout.widthDime);
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}

//天猫超时条目布局，这是一个整体左右结构，因此用左右浮动布局来实现。
-(MyFloatLayout*)createItemLayout1_2:(FOLTest2DataModel*)dataModel
{
    //建立左右浮动布局
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    
    //向左浮动，宽度和父视图宽度保持一致，顶部和左边距为5
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.widthDime.equalTo(itemLayout.widthDime);
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    //向左浮动，因为上面占据了全部宽度，这里会自动换行显示并且也是全宽。
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    subTitleLabel.widthDime.equalTo(itemLayout.widthDime);
    subTitleLabel.myLeftMargin = 5;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    //图片向右浮动，并且右边距为5，上面因为占据了全宽，因此这里会另起一行向右浮动。
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.reverseFloat = YES;
    imageView.myRightMargin = 5;
    [itemLayout addSubview:imageView];
    
    return itemLayout;
    
}

//建立品牌特卖的其他条目布局，这种布局整体是左右结构，因此建立左右浮动布局。
-(MyFloatLayout*)createItemLayout1_3:(FOLTest2DataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];

    //因为图片要占据全高，所以必须优先向右浮动。
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.heightDime.equalTo(itemLayout.heightDime);
    imageView.reverseFloat = YES;
    [itemLayout addSubview:imageView];
    
    //向左浮动，并占据剩余的宽度，边距为5
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    titleLabel.weight = 1;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    //向左浮动，直接另起一行，占据剩余宽度，内容高度动态。
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.clearFloat = YES; //清除浮动，另起一行。
    subTitleLabel.weight = 1;
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.flexedHeight = YES;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    
    //如果有小图片则图片另起一行，向左浮动。
    if (dataModel.subImage != nil)
    {
        UIImageView *subImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.subImage]];
        subImageView.clearFloat = YES;
        subImageView.myLeftMargin = 5;
        [itemLayout addSubview:subImageView];
    }
    
    
    return itemLayout;
}

//建立超级品牌日布局，这里因为就只有一张图，所以设置布局的背景图片即可。
-(MyFloatLayout*)createItemLayout2_1:(FOLTest2DataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    
    itemLayout.backgroundImage = [UIImage imageNamed:dataModel.image];
    
    return itemLayout;
}


//精选市场主条目布局，这个布局整体从上到下因此用上下浮动布局建立。
-(MyFloatLayout*)createItemLayout3_1:(FOLTest2DataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    //向上浮动
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    //继续向上浮动。
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    //价格部分在底部，因此改为向下浮动。
    UILabel *priceLabel = [UILabel new];
    priceLabel.text = dataModel.price;
    priceLabel.font = [UIFont systemFontOfSize:11];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.myLeftMargin = 5;
    priceLabel.myBottomMargin = 5;
    [priceLabel sizeToFit];
    priceLabel.reverseFloat = YES;
    [itemLayout addSubview:priceLabel];
    
    //描述部分在价格的上面，因此改为向下浮动。
    UILabel *descLabel = [UILabel new];
    descLabel.text = dataModel.desc;
    descLabel.font = [UIFont systemFontOfSize:11];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.myLeftMargin = 5;
    [descLabel sizeToFit];
    descLabel.reverseFloat = YES;
    [itemLayout addSubview:descLabel];
    
    //向上浮动，并占用剩余的空间高度。
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.widthDime.equalTo(itemLayout.widthDime);
    imageView.weight = 1;
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}

//建立精选市场其他条目布局，这个布局整体还是从上到下，因此用上下浮动布局
-(MyFloatLayout*)createItemLayout3_2:(FOLTest2DataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    //向上浮动
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    titleLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    //继续向上浮动
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    subTitleLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [itemLayout addSubview:subTitleLabel];
    
    //价格向下浮动
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
    
    //描述向下浮动
    UILabel *descLabel = [UILabel new];
    descLabel.text = dataModel.desc;
    descLabel.font = [UIFont systemFontOfSize:11];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.myLeftMargin = 5;
    [descLabel sizeToFit];
    descLabel.reverseFloat = YES;
    descLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [itemLayout addSubview:descLabel];
    
    //向上浮动，因为宽度无法再容纳，所以这里会换列继续向上浮动。
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    imageView.heightDime.equalTo(itemLayout.heightDime);
    [itemLayout addSubview:imageView];
    
    
    
    return itemLayout;
}

//热门市场主条目布局，这个结构可以用上下浮动布局也可以用左右浮动布局。
-(MyFloatLayout*)createItemLayout4_1:(FOLTest2DataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    //向上浮动
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    titleLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    //继续向上浮动
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    subTitleLabel.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    [itemLayout addSubview:subTitleLabel];
    
    //继续向上浮动，这里因为高度和父布局高度一致，因此会换列浮动。
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.widthDime.equalTo(itemLayout.widthDime).multiply(0.5);
    imageView.heightDime.equalTo(itemLayout.heightDime);
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}

//热门市场其他条目布局，这个整体是上下布局，因此用上下浮动布局。
-(MyFloatLayout*)createItemLayout4_2:(FOLTest2DataModel*)dataModel
{
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    
    //向上浮动
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.myLeftMargin = 5;
    titleLabel.myTopMargin = 5;
    [titleLabel sizeToFit];
    [itemLayout addSubview:titleLabel];
    
    //继续向上浮动
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = dataModel.subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    subTitleLabel.myLeftMargin = 5;
    subTitleLabel.myTopMargin = 5;
    [subTitleLabel sizeToFit];
    [itemLayout addSubview:subTitleLabel];
    
    //继续向上浮动，占据剩余高度。
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.image]];
    imageView.widthDime.equalTo(itemLayout.widthDime);
    imageView.weight = 1;
    [itemLayout addSubview:imageView];
    
    return itemLayout;
}

//主题市场条目布局，这个整体就是上下浮动布局
-(MyFloatLayout*)createItemLayout5_1:(FOLTest2DataModel*)dataModel
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


#pragma mark -- Handle Method

-(void)handleItemLayoutTap:(UIView*)sender
{
    NSInteger sectionIndex = sender.tag / sBaseTag;
    NSInteger itemIndex = sender.tag % sBaseTag;
    
    NSString *message = [NSString stringWithFormat:@"You have select\nSectionIndex:%ld ItemIndex:%ld",(long)sectionIndex, (long)itemIndex];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
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

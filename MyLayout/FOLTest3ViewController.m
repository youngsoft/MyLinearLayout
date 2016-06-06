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
@interface FOLTest3DataModel : NSObject

@property(nonatomic, strong) NSString *imageName;    //图像的名称，如果为nil则没有图像
@property(nonatomic, strong) NSString *title;        //标题
@property(nonatomic, strong) NSString *source;       //来源

@end

@implementation FOLTest3DataModel

@end




@interface FOLTest3ViewController ()

@property(nonatomic, strong) MyFloatLayout *floatLayout;

@property(nonatomic, strong) NSMutableArray *datas;


@end

@implementation FOLTest3ViewController


-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        
        NSArray *dataSource = @[@{
                                    @"imageName":@"p1",
                                    @"title":@"广西鱼塘现大坑 一夜”吃掉“五万斤鱼"
                                    },
                                @{
                                    @"title":@"习近平发展中国经济两个大局观",
                                    @"source":@"专题"
                                    },
                                @{
                                    @"title":@"习近平抵达不拉格开始对捷克国事访问",
                                    @"source":@"专题"
                                    },
                                @{
                                    @"title":@"解读：为何数万在缅汉族要入籍缅族",
                                    @"source":@"海外网"
                                    },
                                @{
                                    @"title":@"消费贷仍可用于首付银行：不可能杜绝",
                                    @"source":@"新闻晨报"
                                    },
                                @{
                                    @"title":@"3代人接力29年养保姆至108岁",
                                    @"source":@"人民日报"
                                    }
                                ];
        
        for (NSDictionary *dict in dataSource)
        {
            FOLTest3DataModel *model = [FOLTest3DataModel new];
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [model setValue:obj forKey:key];
            }];
            
            [_datas addObject:model];
        }
        
    }
    
    return _datas;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _floatLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    _floatLayout.myMargin = 0;  //浮动布局和父视图四周的边界是0，也就是说浮动布局的宽度和高度和父视图相等。
     [self.view addSubview:_floatLayout];
    
    //通过智能分界线的使用，浮动布局里面的所有子布局视图的分割线都会进行智能的设置，从而解决了我们需求中需要提供边界线的问题。
    _floatLayout.IntelligentBorderLine = [[MyBorderLineDraw alloc] initWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"布局变换" style:UIBarButtonItemStylePlain target:self action:@selector(handleStyleChange:)];
    
    [self handleStyleChange:nil];

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

#pragma mark -- Layout Construction

//创建宽度和父布局宽度相等且具有图片新闻的浮动布局
-(UIView*)createPictureNewsItemLayout:(FOLTest3DataModel*)dataModel tag:(NSInteger)tag
{
    //创建一个左右浮动布局。这个DEMO是为了介绍浮动布局,在实践中你可以用其他布局来创建条目布局
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    itemLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [itemLayout setTarget:self action:@selector(handleItemLayoutTap:)];
    itemLayout.highlightedBackgroundColor = [UIColor lightGrayColor];
    itemLayout.tag = tag;
    
    
    //图片作为布局的背景图片
    itemLayout.backgroundImage = [UIImage imageNamed:dataModel.imageName];  //将图片作为布局的背景图片
    
    
    //新闻的标题文本
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.weight = 1;         //向左浮动，宽度和父视图保持一致。
    titleLabel.numberOfLines = 0;
    titleLabel.flexedHeight = YES; //如果想让文本消息的高度是动态的，请在设置明确宽度的情况下将numberOfLines设置为0并且将flexedHeight设置为YES。
    [itemLayout addSubview:titleLabel];
    
    itemLayout.gravity = MyMarginGravity_Vert_Bottom; //将整个布局中的所有子视图垂直居底部。
    itemLayout.heightDime.equalTo(_floatLayout.heightDime).multiply(2.0/5);  //布局的高度是父布局的2/5。
    itemLayout.widthDime.equalTo(_floatLayout.widthDime);   //布局的宽度和父布局相等。
   
    return itemLayout;
}

//创建宽度和父布局宽度相等只有文字新闻的浮动布局
-(UIView*)createWholeWidthTextNewsItemLayout:(FOLTest3DataModel*)dataModel tag:(NSInteger)tag
{
    //创建一个左右浮动布局。这个DEMO是为了介绍浮动布局,在实践中你可以用其他布局来创建条目布局
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    itemLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [itemLayout setTarget:self action:@selector(handleItemLayoutTap:)];
    itemLayout.highlightedBackgroundColor = [UIColor lightGrayColor];
    itemLayout.tag = tag;
    
    //标题文本部分
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.weight =1;   //向左浮动，宽度和父视图保持一致。
    titleLabel.numberOfLines = 0;
    titleLabel.flexedHeight = YES; //如果想让文本消息的高度是动态的，请在设置明确宽度的情况下将numberOfLines设置为0并且将flexedHeight设置为YES。
    [itemLayout addSubview:titleLabel];
    
    //来源部分
    UILabel *sourceLabel = [UILabel new];
    sourceLabel.text = dataModel.source;
    sourceLabel.font = [UIFont systemFontOfSize:11];
    sourceLabel.textColor = [UIColor lightGrayColor];
    sourceLabel.clearFloat = YES;     //换行向左浮动。
    sourceLabel.myTopMargin = 5;
    [sourceLabel sizeToFit];
    [itemLayout addSubview:sourceLabel];
    
    itemLayout.gravity = MyMarginGravity_Vert_Center;  //将整个布局中的所有子视图整体垂直居中。
    itemLayout.heightDime.equalTo(_floatLayout.heightDime).multiply(1.0/5);  //布局高度是父布局的1/5
    itemLayout.widthDime.equalTo(_floatLayout.widthDime);   //布局宽度和父布局相等。
    
    return itemLayout;
    
}

//创建宽度是父布局宽度一半的只有文字新闻的浮动布局
-(MyBaseLayout*)createHalfWidthTextNewsItemLayout:(FOLTest3DataModel*)dataModel tag:(NSInteger)tag
{
    //里面每个元素可以是各种布局，这里为了突出浮动布局，因此条目布局也做成了浮动布局。
    MyFloatLayout *itemLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    itemLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [itemLayout setTarget:self action:@selector(handleItemLayoutTap:)];
    itemLayout.highlightedBackgroundColor = [UIColor lightGrayColor];
    itemLayout.tag = tag;
    
    //标题文本部分
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.weight =1;   //向左浮动，宽度和父视图保持一致。
    titleLabel.numberOfLines = 0;
    titleLabel.flexedHeight = YES; //如果想让文本消息的高度是动态的，请在设置明确宽度的情况下将numberOfLines设置为0并且将flexedHeight设置为YES。
    [itemLayout addSubview:titleLabel];
    
    //来源部分
    UILabel *sourceLabel = [UILabel new];
    sourceLabel.text = dataModel.source;
    sourceLabel.font = [UIFont systemFontOfSize:11];
    sourceLabel.textColor = [UIColor lightGrayColor];
    sourceLabel.clearFloat = YES;  //换行向左浮动。
    sourceLabel.myTopMargin = 5;
    [sourceLabel sizeToFit];
    [itemLayout addSubview:sourceLabel];
    
    itemLayout.gravity = MyMarginGravity_Vert_Center;   //将整个布局中的所有子视图整体垂直居中。
    itemLayout.heightDime.equalTo(_floatLayout.heightDime).multiply(1.0/5);  //布局高度是父布局的1/5
    itemLayout.widthDime.equalTo(_floatLayout.widthDime).multiply(0.5);      //布局宽度是父布局的一半。
    
    return itemLayout;

}

#pragma mark -- Handle Method

-(void)handleStyleChange:(id)sender
{
    
    /*
     zaker的每页新闻中都有6条新闻，其中有1条图片新闻和5条文字新闻。在布局上则每页新闻高度分为5份，其中的图片新闻则占据了2/5，宽度则是全屏，其他的5条新闻则分为3行来均分剩余的高度，宽度则有4条是屏幕宽度的一半，一条全屏宽度。
    
     zaker内部的实现是通过配置好的模板来展示每个不同的页。我们的例子为了展现效果。我们将随机产生4条半屏和1条全屏文字新闻和一张图片新闻。
    
     我们将宽度为全屏宽度的文字新闻定义为1，而将半屏宽度的文字新闻定义为2，而将图片新闻的定义为3。这样就会形成1322,3122,1232,3212,1223,3221,2123,2321, 2132,2312, 2213,2231 一共12种布局。我们界面右上角的“布局变换”按钮每次将随机选择一种布局进行显示。
     */
    
    //所有可能的布局样式数组。
    int layoutStyless[12][4] =
    {
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
        {2,2,3,1}
    };
    
    //随机取得一个布局样式
    int *pLayoutStyles = layoutStyless[arc4random_uniform(12)];
    
    //布局前先把所有子视图删除掉。
    while (self.floatLayout.subviews.count > 0) {
        [self.floatLayout.subviews.lastObject removeFromSuperview];
    }
    
    NSInteger index = 1;
    for (NSInteger i = 0; i < 4; i++)
    {
        int layoutStyle = pLayoutStyles[i];
        if (layoutStyle == 1)  //全部宽度文字新闻布局
        {
            [self.floatLayout addSubview:[self createWholeWidthTextNewsItemLayout:self.datas[index] tag:index]];
            index++;
        }
        else if (layoutStyle == 2)  //半宽文字新闻布局
        {
            [self.floatLayout addSubview:[self createHalfWidthTextNewsItemLayout:self.datas[index] tag:index]];
            index++;
            [self.floatLayout addSubview:[self createHalfWidthTextNewsItemLayout:self.datas[index] tag:index]];
            index++;
        }
        else //图片新闻布局
        {
            [self.floatLayout addSubview:[self createPictureNewsItemLayout:self.datas[0] tag:0]];
        }
        
        
    }
}

-(void)handleItemLayoutTap:(UIView*)sender
{
    NSString *message = [NSString stringWithFormat:@"您单击了:%ld", (long)sender.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end

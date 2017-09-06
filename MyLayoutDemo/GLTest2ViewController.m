//
//  GLTest1ViewController.m
//  MyLayout
//
//  Created by oubaiquan on 2017/8/20.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "GLTest2ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@interface GLTest1DataModel : NSObject

@property(nonatomic, strong) NSString *imageName;    //图像的名称，如果为nil则没有图像
@property(nonatomic, strong) NSString *title;        //标题
@property(nonatomic, strong) NSString *source;       //来源



@end

@implementation GLTest1DataModel



@end


@interface GLTest2ViewController ()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@property(nonatomic, strong) NSMutableArray<GLTest1DataModel*> *datas;


@end

@implementation GLTest2ViewController


-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        
        NSArray *dataSource = @[@{
                                    @"title":@"习近平发展中国经济两个大局观",
                                    @"source":@"专题"
                                    },
                                @{
                                    @"imageName":@"p1",
                                    @"title":@"广西鱼塘现大坑 一夜”吃掉“五万斤鱼"
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
            GLTest1DataModel *model = [GLTest1DataModel new];
            [dict enumerateKeysAndObjectsUsingBlock:^(id key, id  obj, BOOL * stop) {
                [model setValue:obj forKey:key];
            }];
            
            [_datas addObject:model];
        }
        
    }
    
    return _datas;
}


-(void)handleTest1:(id<MyGrid>)sender
{
    NSString *message = [NSString stringWithFormat:@"您单击了:%@", ((GLTest1DataModel*)[sender actionData]).title];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    self.rootLayout = rootLayout;
    
    //添加子视图序列。
    for (GLTest1DataModel *dataModel in self.datas)
    {
        NSArray *viewGroup = nil;
        NSInteger gridTag = 0;
        if (dataModel.imageName != nil)
        {
            gridTag = 2;
            viewGroup = [self createType1ViewsFromModel:dataModel];
        }
        else
        {
            gridTag = 1;
            viewGroup = [self createType2ViewsFromModel:dataModel];
        }
        
        
        //这里将视图组，和tag，以及数据进行关联。。
        [rootLayout addViewGroup:viewGroup withActionData:dataModel to:gridTag];
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"change style", @"") style:UIBarButtonItemStylePlain target:self action:@selector(handleStyleChange:)];
    
    [self handleStyleChange:nil];

    
}

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
    

    //切换栅格样式时，先将所有的栅格都删除掉。
    [self.rootLayout removeGrids];
    
    MyBorderline *borderline = [[MyBorderline alloc] initWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];

    for (NSInteger i = 0; i < 4; i++)
    {
        int layoutStyle = pLayoutStyles[i];
        if (layoutStyle == 1)  //全部宽度文字新闻布局
        {
         
            //建立一个高度为1/5的栅格，里面的子栅格垂直居中，并且间隔为10
            id<MyGrid> g1 = [self.rootLayout addRow:1.0/5];
            g1.tag = 1;
            g1.gravity = MyGravity_Vert_Center;
            g1.padding = UIEdgeInsetsMake(0, 10, 0, 10);
            g1.subviewSpace = 10;
            
            //建立2个高度由内容包裹的行叶子栅格
            [g1 addRow:MyLayoutSize.wrap];
            [g1 addRow:MyLayoutSize.wrap];
            
            g1.bottomBorderline = borderline;
            [g1 setTarget:self action:@selector(handleTest1:)];


            
        }
        else if (layoutStyle == 2)  //半宽文字新闻布局
        {
            
            //建立一个高度为1/5的栅格
            id<MyGrid>g2 = [self.rootLayout addRow:1.0/5];
            
            //建立一个宽度均分的列子栅格，里面的子栅格间距为10并且垂直居中
            id<MyGrid> g21 = [g2 addCol:MyLayoutSize.fill];
            g21.tag = 1;
            g21.subviewSpace = 10;
            g21.gravity = MyGravity_Vert_Center;
            g21.padding = UIEdgeInsetsMake(0, 10, 0, 10);
            [g21 setTarget:self action:@selector(handleTest1:)];

            
            //建立2个高度由内容包裹的行叶子栅格
            [g21 addRow:MyLayoutSize.wrap];
            [g21 addRow:MyLayoutSize.wrap];

            
            //建立一个新的列子栅格，其结构完全拷贝自g21.
            [g2 addColGrid:g21.cloneGrid];
            
            g21.rightBorderline = borderline;
            g2.bottomBorderline = borderline;
            
            
        }
        else if (layoutStyle == 3)//图片新闻布局
        {
            //建立一个高度为2/5的栅格
            id<MyGrid>g3 = [self.rootLayout addRow:2.0/5];
            g3.tag = 2;
            g3.anchor = YES;  //这个栅格是可以存放显示视图的。
            [g3 addRow:MyLayoutSize.fill].placeholder = YES;   //这里建立一个占位栅格的目的是为了让下面的兄弟栅格保持在第二行栅格的底部。
            [g3 addRow:MyLayoutSize.wrap].padding = UIEdgeInsetsMake(0, 10, 0, 0);  //建立一个高度由内容包裹的叶子栅格并指定其内边距。
            
            g3.bottomBorderline = borderline;
            
            [g3 setTarget:self action:@selector(handleTest1:)];


        }
        else;
        
        
    }

    
    [self.rootLayout setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)createType1ViewsFromModel:(GLTest1DataModel*)dataModel
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageName]];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.textColor = [UIColor whiteColor];

    return @[imageView, titleLabel];
}

-(NSArray*)createType2ViewsFromModel:(GLTest1DataModel*)dataModel
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = dataModel.title;
    titleLabel.numberOfLines = 0;
    
    UILabel *sourceLabel = [UILabel new];
    sourceLabel.text = dataModel.source;
    sourceLabel.font = [UIFont systemFontOfSize:11];
    sourceLabel.textColor = [UIColor lightGrayColor];
    
    return @[titleLabel, sourceLabel];

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

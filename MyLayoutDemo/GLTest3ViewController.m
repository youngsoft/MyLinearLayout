//
//  GLTest3ViewController.m
//  MyLayout
//
//  Created by oubaiquan on 2017/8/20.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "GLTest3ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


//从服务器下发下来的数据模型。
@interface GLTest3DataModel : NSObject

@property(nonatomic, strong) NSString *title;        //标题
@property(nonatomic, strong) NSString *subTitle;       //副标题
@property(nonatomic, strong) NSMutableArray<NSString*> *imageNames;    //图像的名称，如果为nil则没有图像
@property(nonatomic, strong) NSString *actionData;     //执行的动作。


@end

@implementation GLTest3DataModel



@end


@interface GLTest3ViewController ()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@property(nonatomic, strong) NSMutableArray<GLTest3DataModel*> *datas;


@end

@implementation GLTest3ViewController


-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        
        NSArray *dataSource = @[@{
                                    @"title":@"智能生活",
                                    @"subTitle":@"黑科技智能装备1元抢",
                                    @"imageNames":@[@"p1-31",@"p1-32"],
                                    },
                                @{
                                    @"title":@"白条商城",
                                    @"subTitle":@"iPhone7低至每期324元",
                                    @"imageNames":@[@"p1-33",@"p1-34"],
                                    },
                                @{
                                    @"title":@"京东众筹",
                                    @"subTitle":@"猛追科技前沿",
                                    @"imageNames":@[@"p3-21"],
                                    },
                                @{
                                    @"title":@"生活娱乐",
                                    @"subTitle":@"疯狂大扫除",
                                    @"imageNames":@[@"p3-21"],
                                    },
                                @{
                                    @"title":@"特产.扶贫",
                                    @"subTitle":@"湖北牛肉罐头",
                                    @"imageNames":@[@"p3-21"],
                                    },
                                @{
                                    @"title":@"爱车生活",
                                    @"subTitle":@"低至9.9元",
                                    @"imageNames":@[@"p3-21"],
                                    },
                                @{
                                    @"title":@"大药房",
                                    @"subTitle":@"每盒减20元",
                                    @"imageNames":@[@"p3-21"],
                                    },
                                @{
                                    @"title":@"设计师",
                                    @"subTitle":@"潮流设计精选",
                                    @"imageNames":@[@"p3-21"],
                                    },
                                @{
                                    @"title":@"陪伴宝宝",
                                    @"subTitle":@"1元抢好品",
                                    @"imageNames":@[@"p3-21"],
                                    },
                                @{
                                    @"title":@"京东拍卖",
                                    @"subTitle":@"尖货包经典表",
                                    @"imageNames":@[@"p3-21"],
                                    },

                                ];
        
        for (NSDictionary *dict in dataSource)
        {
            GLTest3DataModel *model = [GLTest3DataModel new];
            [dict enumerateKeysAndObjectsUsingBlock:^(id key, id  obj, BOOL * stop) {
                [model setValue:obj forKey:key];
            }];
            
            [_datas addObject:model];
        }
        
    }
    
    return _datas;
}



-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    self.view = rootLayout;
    self.rootLayout = rootLayout;
    
    //定义栅格样式。。
    
    rootLayout.tag = 1000;
    
    [rootLayout addRow:40];   //顶部图片
    id<MyGrid> gg1 = [rootLayout addRow:50];  //文字和图片。
    gg1.anchor = YES;
    [gg1 addRow:MyLayoutSize.fill];
    
    
    
    //建立栅格模板1
    id<MyGrid> templateGrid1 = [MyGridLayout createTemplateGrid:1];
    templateGrid1.subviewSpace = 5;
    templateGrid1.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [templateGrid1 addRow:MyLayoutSize.wrap];
    [templateGrid1 addRow:MyLayoutSize.wrap];
   id<MyGrid> tg1 = [templateGrid1 addRow:MyLayoutSize.fill];

    tg1.subviewSpace = 10;
    [tg1 addCol:MyLayoutSize.fill];
    [tg1 addCol:MyLayoutSize.fill];

    
    //建立栅格模板2
    id<MyGrid> templateGrid2 = [MyGridLayout createTemplateGrid:2];
    templateGrid2.subviewSpace = 5;
    templateGrid2.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [templateGrid2 addRow:MyLayoutSize.wrap];
    [templateGrid2 addRow:MyLayoutSize.wrap];
    [templateGrid2 addRow:MyLayoutSize.fill];
    
    
    
    
    

    //第一行
   id<MyGrid> line1 = [rootLayout addRow:MyLayoutSize.fill];
    [line1 addColGrid:templateGrid1.cloneGrid measure:0.5];
    [line1 addColGrid:templateGrid2.cloneGrid measure:0.25];
    [line1 addColGrid:templateGrid2.cloneGrid measure:0.25];
    
    //第二行
    [rootLayout addRowGrid:line1.cloneGrid measure:MyLayoutSize.fill];
    
    
    //第三行
    id<MyGrid> line3 = [rootLayout addRow:MyLayoutSize.fill];
    [line3 addColGrid:templateGrid2.cloneGrid measure:MyLayoutSize.fill];
    [line3 addColGrid:templateGrid2.cloneGrid measure:MyLayoutSize.fill];
    [line3 addColGrid:templateGrid2.cloneGrid measure:MyLayoutSize.fill];
    [line3 addColGrid:templateGrid2.cloneGrid measure:MyLayoutSize.fill];

    
    

    //底部图片
    [rootLayout addRow:80];
    [rootLayout addRow:20];


    
    //加载头尾视图。。。
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk1"]];
    
    UIImageView *backgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk2"]];
    
    UILabel *label = [UILabel new];
    label.text = @"特色推荐";
    
    
    //底部
    UIScrollView *scrollView =[UIScrollView new];
    
    //
    UIPageControl *pageCtrl = [UIPageControl new];
    pageCtrl.numberOfPages = 5;
    pageCtrl.currentPage = 0;
    pageCtrl.pageIndicatorTintColor = [UIColor redColor];
    
    
    [rootLayout addViewGroup:@[headImageView,backgroudImageView,label,scrollView,pageCtrl] withActionData:nil to:1000];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //假设这里发送网络请求数据。
    
    for (GLTest3DataModel *dataModel in self.datas)
    {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = dataModel.title;
        
        UILabel *subTitleLabel = [UILabel new];
        subTitleLabel.text = dataModel.subTitle;
        
        if (dataModel.imageNames.count == 1)
        {
            UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageNames[0]]];
            
            [self.rootLayout addViewGroup:@[titleLabel, subTitleLabel, imageView1] withActionData:dataModel.actionData to:2];
            
        }
        else
        {
         
            UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageNames[0]]];

            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageNames[1]]];

            [self.rootLayout addViewGroup:@[titleLabel, subTitleLabel, imageView1, imageView2] withActionData:dataModel.actionData to:1];

        }
        
    }
    
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

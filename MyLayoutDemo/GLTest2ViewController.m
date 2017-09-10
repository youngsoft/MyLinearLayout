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
}

-(void)loadDataFromServer
{
    //这里假设数据是从服务器请求并下发下来。实践中数据模型数组可能是网络请求后通过回调得到的。
    //在实际中，除了从服务器下发数据还可能定期从服务器中进行数据的更新。一般情况下我们的做法如下：
       // 1.是将视图组从栅格布局中删除
       // 2.然后再建立视图组
       // 3.然后再次将视图组添加到栅格布局中。
    
    //上面的方法会出现视图组的不停删除以及添加。而实际中我们是可以复用原先填充在栅格布局中的视图组
    
    //添加子视图序列。
    for (GLTest1DataModel *dataModel in self.datas)
    {
        NSArray *viewGroup = nil;
        NSInteger gridTag = 0;
        //根据数据模型的不同而构建不同的视图组，并设定一种展现的样式标签。
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
        
        
        //这里将视图组，和样式标签，以及数据进行关联。
        [self.rootLayout addViewGroup:viewGroup withActionData:dataModel to:gridTag];
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"change style", @"") style:UIBarButtonItemStylePlain target:self action:@selector(handleStyleChange:)];
    
    [self handleStyleChange:nil];

    
    
    [self loadDataFromServer];
    
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
    
    //创建一个样板栅格并指定样式标签为1
    id<MyGrid> templateGrid = [MyGridLayout createTemplateGrid:1];
    templateGrid.gravity = MyGravity_Vert_Center;
    templateGrid.padding = UIEdgeInsetsMake(0, 10, 0, 10);
    templateGrid.subviewSpace = 10;
    [templateGrid addRow:MyLayoutSize.wrap];
    [templateGrid addRow:MyLayoutSize.wrap];
    [templateGrid setTarget:self action:@selector(handleTest1:)];
    

    for (NSInteger i = 0; i < 4; i++)
    {
        int layoutStyle = pLayoutStyles[i];
        if (layoutStyle == 1)  //全部宽度文字新闻布局
        {
            //建立一个高度为1/5的栅格，使用模板栅格，并指定一条尾部边界线
            [self.rootLayout addRowGrid:templateGrid.cloneGrid measure:1.0/5].bottomBorderline = borderline;
            
        }
        else if (layoutStyle == 2)  //半宽文字新闻布局
        {
            
            //建立一个高度为1/5的栅格
            id<MyGrid>g2 = [self.rootLayout addRow:1.0/5];
            g2.bottomBorderline = borderline;
            
            //建立一个宽度均分的列子栅格，使用模板栅格，第一列子栅格指定一条右边边界线
            [g2 addColGrid:templateGrid.cloneGrid measure:MyLayoutSize.fill].rightBorderline = borderline;
            [g2 addColGrid:templateGrid.cloneGrid measure:MyLayoutSize.fill];
            
            
            
        }
        else if (layoutStyle == 3)//图片新闻布局
        {
            //建立一个高度为2/5的栅格
            id<MyGrid>g3 = [self.rootLayout addRow:2.0/5];
            g3.tag = 2;  //指定栅格样式。
            g3.bottomBorderline = borderline;
            [g3 setTarget:self action:@selector(handleTest1:)];

            
            [g3 addRow:MyLayoutSize.fill];   //建立一个子行栅格，高度为填充父栅格剩余空间，你会发现下面的栅格的高度为0，也就是这个栅格高度和父栅格高度保持一致。
            
            
            /*
             正常情况下子栅格是按一定的规则来切分父栅格的高度或者宽度并顺序排列的，因此不具有重叠或者覆盖的效果。而实际中我们可能希望某个子视图会覆盖另外一个子视图而显示，这时候的一个解决方案是让某个栅格的子栅格的高度或者宽度设置为0，并且设定其里面的子视图在这个0尺寸的栅格上的对齐停靠方式，因为高度是0所以就可以出现子视图覆盖其他栅格上的子视图的情况。
             
             我们这里的高度为0的子栅格是在父栅格的最后添加的，因此这个高度为0的子栅格里面的子视图将展现在父栅格的最下面。而这里面又设置了是底部对齐。所以呈现的效果就是这个栅格里面的视图覆盖住其兄弟栅格中的子视图的内容了。
            */
            id<MyGrid> g32 = [g3 addRow:0];  //建立一个0高度的栅格
            g32.anchor = YES;
            g32.padding = UIEdgeInsetsMake(0, 10, 0, 0);
            g32.gravity = MyGravity_Vert_Bottom | MyGravity_Horz_Left;  //指定栅格内视图对齐方式
            
        }
        else;
        
        
    }

    
    [self.rootLayout setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- view From DataModel
/*
 在实际中，服务器返回的数据模型可能具有不同的类型，不同类型的模型需要用不同类型的视图来描述，因此下面的两个方法就是根据数据模型的不同而构建的两类不同的视图.
*/

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

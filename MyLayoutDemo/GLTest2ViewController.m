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

//定义两种不同的展示风格标签
static NSInteger sImageStyleTag = 2;   //图片风格的标签
static NSInteger sTextStyleTag = 1;    //文本风格的标签

//数据模型
@interface GLTest2DataModel : NSObject

@property(nonatomic, strong) NSString *imageName;    //图像的名称，如果为nil则没有图像
@property(nonatomic, strong) NSString *title;        //标题
@property(nonatomic, strong) NSString *source;       //来源

@end

@implementation GLTest2DataModel

@end


@interface GLTest2ViewController ()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@property(nonatomic, strong) NSMutableArray<GLTest2DataModel*> *datas;


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
            GLTest2DataModel *model = [GLTest2DataModel new];
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
   //这里面栅格的actionData保存的是对应的栅格的数据模型对象。因此您可以在栅格中用actionData来保存某个栅格所对应要处理的任何数据。
    NSString *message = [NSString stringWithFormat:@"您单击了:%@", ((GLTest2DataModel*)[sender actionData]).title];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"style", @"") style:UIBarButtonItemStylePlain target:self action:@selector(handleStyleChange:)],
                                                [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"update", @"") style:UIBarButtonItemStylePlain target:self action:@selector(handleDataFromServer:)
                                                ]];
    
    //建立本地的栅格布局样式。
    [self handleStyleChange:nil];

    
    //处理从服务器下载的数据并更新界面。
    [self handleDataFromServer:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    //建立一个边界线模板
    MyBorderline *borderlineTemplate = [[MyBorderline alloc] initWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];
    
    //为了方便，可以创建一个样板栅格并指定风格标签为sTextStyleTag
    id<MyGrid> gridTemplate = [MyGridLayout createTemplateGrid:sTextStyleTag];
    gridTemplate.gravity = MyGravity_Vert_Center;
    gridTemplate.padding = UIEdgeInsetsMake(0, 10, 0, 10);
    gridTemplate.subviewSpace = 10;
    [gridTemplate addRow:MyLayoutSize.wrap];
    [gridTemplate addRow:MyLayoutSize.wrap];
    [gridTemplate setTarget:self action:@selector(handleTest1:)];


    //切换栅格样式时，先将所有的栅格都删除掉。注意这里只是删除了栅格并没有删除子视图。
    [self.rootLayout removeGrids];
    
    for (NSInteger i = 0; i < 4; i++)
    {
        int layoutStyle = pLayoutStyles[i];
        if (layoutStyle == 1)  //全部宽度文字新闻布局
        {
            //建立一个高度为1/5的栅格，使用模板栅格，并指定一条尾部边界线。如果measure的值是大于0小于1则表示的是整体高度的比例值。
            //我们不能直接将一个模板栅格作为子栅格加入到父栅格中，但是我们可以对模板栅格使用clone来克隆复制一个和模板栅格一模一样的栅格结构。
            //栅格的克隆处理可以很方便的为我们处理很多重复定义的栅格的构建。
            [self.rootLayout addRowGrid:gridTemplate.cloneGrid measure:1.0/5].bottomBorderline = borderlineTemplate;
            
        }
        else if (layoutStyle == 2)  //半宽文字新闻布局
        {
            
            //建立一个高度为1/5的栅格
            id<MyGrid>g2 = [self.rootLayout addRow:1.0/5];
            g2.bottomBorderline = borderlineTemplate;
            
            //建立一个宽度均分的列子栅格，使用模板栅格，第一列子栅格指定一条右边边界线
            [g2 addColGrid:gridTemplate.cloneGrid measure:MyLayoutSize.fill].rightBorderline = borderlineTemplate;
            [g2 addColGrid:gridTemplate.cloneGrid measure:MyLayoutSize.fill];
            
            
            
        }
        else if (layoutStyle == 3)//图片新闻布局
        {
            //建立一个高度为2/5的栅格
            id<MyGrid>g3 = [self.rootLayout addRow:2.0/5];
            g3.tag = sImageStyleTag;  //指定栅格样式。我们可以通过栅格的tag来指定栅格的风格标签样式。
            g3.bottomBorderline = borderlineTemplate;
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


-(void)handleDataFromServer:(id)sender
{
    //这里假设数据是从服务器请求并下发下来。实践中数据模型数组可能是网络请求后通过回调得到的。
    //在实际中，除了从服务器下发数据还可能定期从服务器中进行数据的更新。一般情况下我们的做法如下：
    // 1.是将视图组从栅格布局中删除
    // 2.然后再建立视图组
    // 3.然后再次将视图组添加到栅格布局中。
    
    
    //上面的方法会出现视图组和栅格的不停删除以及添加。而实际中我们是可以复用原先填充在栅格布局中的视图组的，下面的例子展示了这种复用的机制，下面的方法不会删除栅格和视图组
    //而是做到尽量的复用，以便提升系统的性能：
    
    NSInteger textStyleTagIndex = 0;  //每种风格标签下的开始索引
    NSInteger imageStyleTagIndex = 0;
    
    //假设这里的self.datas是每次从服务器下发下来的不同的数据模型。下面的代码是为了模拟self.datas的随机排列特性。
    [self.datas sortUsingComparator:^NSComparisonResult(GLTest2DataModel  * obj1, GLTest2DataModel* obj2) {
        
        int  rand = (int)arc4random_uniform(10);
        
        return [obj1.title characterAtIndex:rand] - [obj2.title characterAtIndex:rand];
    }];
    
    for (GLTest2DataModel *dataModel in self.datas)
    {
        NSInteger gridTag;
        NSInteger index;
        //根据数据模型的不同而构建不同的视图组，并设定一种展现的风格标签。这里是根据数据模型是否有图片来判断，实际中你可以在数据模型中添加一个标志来指定风格。
        if (dataModel.imageName != nil)
        {
            index = imageStyleTagIndex++;
            gridTag = sImageStyleTag;
        }
        else
        {
            index = textStyleTagIndex++;
            gridTag = sTextStyleTag;
        }
        
        //建立或者获取指定风格标签下的视图组。
        NSArray *viewGroup = [self createOrGetViewGroupFrom:gridTag atIndex:index];
        //更新视图组的内容。
        [self updateViewGroup:viewGroup atIndex:index toTag:gridTag withDataModel:dataModel];
    }
    
}


-(NSArray*)createOrGetViewGroupFrom:(NSInteger)tag atIndex:(NSInteger)index
{
    /*
     在实际中，服务器返回的数据模型可能具有不同的类型，不同类型的模型需要用不同风格类型的视图来描述，因此下面的两个方法就是根据数据模型的不同而构建的两类不同风格的视图.
     */

    NSArray *retViewGroup = nil;
    
    //先判断索引的值是否小于风格标签已经有了的视图组数。如果有则直接复用。没有就建立
    if (index < [self.rootLayout viewGroupCountOf:tag])
    {
        //直接复用
        retViewGroup = [self.rootLayout viewGroupAtIndex:index from:tag];
    }
    else
    {
        //不同的风格标签建立不同类型的视图组。
        if (tag == sImageStyleTag)
        {
            UIImageView *imageView = [UIImageView new];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.textColor = [UIColor whiteColor];
            
            retViewGroup =  @[imageView, titleLabel];
        }
        else if (tag == sTextStyleTag)
        {
            UILabel *titleLabel = [UILabel new];
            titleLabel.numberOfLines = 0;
            
            UILabel *sourceLabel = [UILabel new];
            sourceLabel.font = [UIFont systemFontOfSize:11];
            sourceLabel.textColor = [UIColor lightGrayColor];
            
            retViewGroup = @[titleLabel, sourceLabel];
        }
        else
        {
            //..
        }
        
    }
    
    return retViewGroup;
}

-(void)updateViewGroup:(NSArray*)viewGroup  atIndex:(NSInteger)index toTag:(NSInteger)tag withDataModel:(GLTest2DataModel*)dataModel
{
    if (tag == sImageStyleTag)
    {
        ((UIImageView*)(viewGroup.firstObject)).image = [UIImage imageNamed:dataModel.imageName];
        ((UILabel*)(viewGroup.lastObject)).text = dataModel.title;
    }
    else if (tag == sTextStyleTag)
    {
        ((UILabel*)(viewGroup.firstObject)).text = dataModel.title;
        ((UILabel*)(viewGroup.lastObject)).text = dataModel.source;
    }
    else
    {
         //...
    }
    
    //这里将视图组，和风格标签，以及数据模型进行关联。
    //视图组是一个子视图数组，通过如下方法我们可以让这个视图数组和某个对应的栅格标签建立联系。这样这个视图组里面的子视图将填充到对应标签的栅格下面的子栅格里面去。
    //replaceViewGroup方法在执行时如果发现视图组要插入的索引大于标签的所有视图组时则内部执行addViewGroup方法。因此尽可能用这个方法来绑定视图组。
    [self.rootLayout replaceViewGroup:viewGroup withActionData:dataModel atIndex:index to:tag];
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

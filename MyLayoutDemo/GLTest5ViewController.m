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
#import "UIColor+MyLayout.h"

//从服务器下发下来的数据模型。
@interface GLTest5DataModel : NSObject

@property(nonatomic, strong) NSString *title;        //标题
@property(nonatomic, strong) NSString *subTitle;       //副标题
@property(nonatomic, strong) NSMutableArray<NSString*> *imageNames;    //图像的名称，如果为nil则没有图像
@property(nonatomic, strong) NSNumber *hasSales;          //促销标志
@property(nonatomic, strong) NSString *actionData;     //执行的动作。


@end

@implementation GLTest5DataModel



@end

@interface GLTest5ViewController ()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@property(nonatomic, strong) NSMutableArray<GLTest5DataModel*> *datas;

@end

@implementation GLTest5ViewController

-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        
        NSArray *dataSource = @[@{
                                    @"title":@"智能生活",
                                    @"subTitle":@"黑科技智能装备1元抢",
                                    @"imageNames":@[@"p1-31",@"p1-32"],
                                    @"actionData":@"aa",
                                    @"hasSales":@(YES)
                                    },
                                @{
                                    @"title":@"白条商城",
                                    @"subTitle":@"iPhone7低至每期324元",
                                    @"imageNames":@[@"p1-33",@"p1-34"],
                                    @"actionData":@"bb",
                                    },
                                @{
                                    @"title":@"京东众筹",
                                    @"subTitle":@"猛追科技前沿",
                                    @"imageNames":@[@"p3-21"],
                                    @"actionData":@"cc",
                                    },
                                @{
                                    @"title":@"生活娱乐",
                                    @"subTitle":@"疯狂大扫除",
                                    @"imageNames":@[@"p3-22"],
                                    @"actionData":@"dd",
                                    @"hasSales":@(YES)
                                    },
                                @{
                                    @"title":@"特产.扶贫",
                                    @"subTitle":@"湖北牛肉罐头",
                                    @"imageNames":@[@"p3-23"],
                                    @"actionData":@"ee",
                                    },
                                @{
                                    @"title":@"爱车生活",
                                    @"subTitle":@"低至9.9元",
                                    @"imageNames":@[@"p3-24"],
                                    @"actionData":@"ff",
                                    },
                                @{
                                    @"title":@"大药房",
                                    @"subTitle":@"每盒减20元",
                                    @"imageNames":@[@"p5-1"],
                                    @"actionData":@"gg",
                                    },
                                @{
                                    @"title":@"设计师",
                                    @"subTitle":@"潮流设计精选",
                                    @"imageNames":@[@"p5-2"],
                                    @"actionData":@"hh",
                                    
                                    },
                                @{
                                    @"title":@"陪伴宝宝",
                                    @"subTitle":@"1元抢好品",
                                    @"imageNames":@[@"p5-3"],
                                    @"actionData":@"ii",
                                    },
                                @{
                                    @"title":@"京东拍卖",
                                    @"subTitle":@"尖货包经典表",
                                    @"imageNames":@[@"p5-4"],
                                    @"actionData":@"jj",
                                    },
                                @{
                                    @"title":@"京东拍卖2",
                                    @"subTitle":@"尖货包经典表",
                                    @"imageNames":@[@"p5-4"],
                                    @"actionData":@"jj",
                                    },
                                
                                
                                ];
        
        for (NSDictionary *dict in dataSource)
        {
            GLTest5DataModel *model = [GLTest5DataModel new];
            [dict enumerateKeysAndObjectsUsingBlock:^(id key, id  obj, BOOL * stop) {
                [model setValue:obj forKey:key];
            }];
            
            [_datas addObject:model];
        }
        
    }
    
    return _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test1];
}


- (void)test1
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.padding = UIEdgeInsetsMake(0, 0, 10, 0);
    rootLayout.gridTarget  = self;
    self.view = rootLayout;
    self.rootLayout = rootLayout;
    
    
    rootLayout.tag = 1000;
    
    
    NSString *path =  [NSBundle.mainBundle pathForResource:@"GridLayoutDemo5.geojson" ofType:nil];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    id temp = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    rootLayout.gridDictionary = temp;
}

- (void)gridLayoutJSON
{
    NSDictionary *dictionary = self.rootLayout.gridDictionary;
    
    NSLog(@"gridLayoutJSON..........%@",dictionary.description);
    
    self.rootLayout.gridDictionary = dictionary;
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self gridLayoutJSON];
    
    [self loadDataFromServer];
    
}

-(void)handleTap:(id<MyGrid>)sender
{
    NSString *message = [NSString stringWithFormat:@"您单击了:%@", sender.actionData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}


-(void)loadDataFromServer
{
    
    for (GLTest5DataModel *dataModel in self.datas)
    {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = dataModel.title;
        titleLabel.font = [CFTool font:16];
        titleLabel.textColor = [CFTool color:4];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        
        UILabel *subTitleLabel = [UILabel new];
        subTitleLabel.text = dataModel.subTitle;
        subTitleLabel.font = [CFTool font:13];
        subTitleLabel.textColor = [CFTool color:5];
        subTitleLabel.adjustsFontSizeToFitWidth = YES;
        
        if (dataModel.imageNames.count == 1)
        {
            UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageNames[0]]];
            
            //  UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageNames[0]]];
            
            UIView *vv = [NSNull null];
            if (dataModel.hasSales.integerValue)
            {
                vv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1-12"]];
            }
            //视图组绑定标签2
            [self.rootLayout addViewGroup:@[titleLabel, subTitleLabel, imageView1, vv] withActionData:dataModel.actionData to:2];
            
        }
        else
        {
            
            UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageNames[0]]];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageNames[1]]];
            
            UIView *vv = [NSNull null];
            if (dataModel.hasSales.integerValue)
            {
                vv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1-12"]];
            }
            
            [self.rootLayout addViewGroup:@[titleLabel, subTitleLabel, imageView1, imageView2, vv] withActionData:dataModel.actionData to:1];
            
        }
        
    }
    
    
    //.......
    //上面定义了栅格的样式，下面填充头部和尾部的栅格部分的视图。
    
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p2-4"]];
    
    UIImageView *backgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk1"]];
    UILabel *label = [UILabel new];
    label.text = @"特色推荐";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [CFTool font:18];
    label.textColor = [CFTool color:3];
    
    
    //底部
    UIScrollView *scrollView =[UIScrollView new];
    scrollView.pagingEnabled = YES;
    MyFlowLayout *scrollFlowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:1];
    scrollFlowLayout.pagedCount = 1; //pagedCount设置为非0时表示开始分页展示的功能，这里表示每页展示9个子视图，这个数量必须是arrangedCount的倍数。
    scrollFlowLayout.wrapContentWidth = YES; //设置布局视图的宽度由子视图包裹，当水平流式布局的这个属性设置为YES，并和pagedCount搭配使用会产生分页从左到右滚动的效果。
    scrollFlowLayout.heightSize.equalTo(scrollView.heightSize); //因为是分页从左到右滚动，因此布局视图的高度必须设置为和父滚动视图相等。
    
    [scrollView addSubview:scrollFlowLayout];
    
    //添加三个广告
    UIImageView *advImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk3"]];
    [scrollFlowLayout addSubview:advImageView1];
    UIImageView *advImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk2"]];
    [scrollFlowLayout addSubview:advImageView2];
    UIImageView *advImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk1"]];
    [scrollFlowLayout addSubview:advImageView3];
    
    
    
    //最后一行的分页控制器
    UIPageControl *pageCtrl = [UIPageControl new];
    pageCtrl.numberOfPages = 5;
    pageCtrl.currentPage = 0;
    pageCtrl.pageIndicatorTintColor = [UIColor redColor];
    
    
    //将头尾部分的视图组和栅格标签1000绑定
    [_rootLayout addViewGroup:@[headImageView,backgroudImageView,label,scrollView,pageCtrl] withActionData:nil to:1000];
}
@end

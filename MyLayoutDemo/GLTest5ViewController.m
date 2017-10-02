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

//从服务器下发下来的数据模型。
@interface GLTest5DataModel : NSObject

@property(nonatomic, strong) NSNumber *homeBackgroundView; //整个背景图片
@property(nonatomic, strong) NSString *homeTitle;        //首页标题
@property(nonatomic, strong) NSString *titleBackImageView;        //背景图片
@property(nonatomic, strong) NSNumber *hasPlaceholder;// 占位
@property(nonatomic, strong) NSString *title;        //标题
@property(nonatomic, strong) NSString *subTitle;       //副标题
@property(nonatomic, strong) NSMutableArray<NSString*> *imageNames;    //图像的名称，如果为nil则没有图像
@property(nonatomic, strong) NSMutableArray<NSString*> *titles;    //标题的名称，如果为nil则没有标题
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
{
    BOOL flag;
}

-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        
        
        NSArray *dataSource = @[
                                @{
                                    @"titleBackImageView":@"image2",
                                    @"titles":@[@"酒店0元住",@"马上体验>"]
                                    },
                                @{
                                    @"subTitle":@"火车票立减50",
                                    @"titleBackImageView":@"image3"
                                    },
                                @{
                                    @"subTitle":@"国庆出境4免1",
                                    @"titleBackImageView":@"image3"
                                    },
                                @{
                                    @"subTitle":@"9元门票限量抢",
                                    @"titleBackImageView":@"image3"
                                    },
                                @{
                                    @"subTitle":@"高端酒店5折抢",
                                    @"titleBackImageView":@"image3"
                                    },
                                @{
                                    @"homeBackgroundView":@(YES)
                                    },
                                @{
                                    @"homeTitle":@"全球精选 大牌推荐",
                                    @"actionData":@"aa"
                                    },
                                @{
                                    @"titleBackImageView":@"image2",
                                    @"hasPlaceholder":@(YES),
                                    @"title":@"火遍亚洲的\nINS双肩包",
                                    @"actionData":@"bb",
                                    },
                                @{
                                    @"titleBackImageView":@"image2",
                                    @"hasPlaceholder":@(YES),
                                    @"title":@"经典重工鞋\n靴 399元起",
                                    @"actionData":@"cc",
                                    }
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
    
    [self loadDataFromServer];
}


- (void)test1
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.padding = UIEdgeInsetsMake(0, 0, 10, 0);
    rootLayout.gridActionTarget  = self;
    self.view = rootLayout;
    self.rootLayout = rootLayout;
    
//    rootLayout.tag = 1000;
    
    
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


-(void)handleTap:(id<MyGrid>)sender
{
    NSString *message = [NSString stringWithFormat:@"您单击了:%@", sender.actionData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}


-(void)loadDataFromServer
{
    [self.rootLayout removeAllSubviews];
    for (GLTest5DataModel *dataModel in self.datas)
    {
        if (dataModel.homeBackgroundView) {
            UIView *backgrondView = [UIView new];
            backgrondView.backgroundColor = UIColor.whiteColor;
            
            UIView *bottomLineView = [UIView new];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = @"查看更多";
            titleLabel.font = [CFTool font:16];
            titleLabel.textColor = UIColor.blueColor;
            
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
            
            //视图组绑定标签111
            [self.rootLayout addViewGroup:@[backgrondView,bottomLineView,titleLabel,arrowImageView] withActionData:dataModel.actionData to:111];
        }else if (dataModel.homeTitle){
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = dataModel.homeTitle;
            titleLabel.font = [CFTool font:24];
            titleLabel.textColor = UIColor.blackColor;
            titleLabel.adjustsFontSizeToFitWidth = YES;
            //视图组绑定标签1
            [self.rootLayout addViewGroup:@[titleLabel] withActionData:dataModel.actionData to:1];
        }else if (dataModel.titleBackImageView && dataModel.hasPlaceholder){
            
            UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.titleBackImageView]];
            
            UIView *backgroundView = [UIView new];
            backgroundView.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.6f];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = dataModel.title;
            titleLabel.font = [CFTool font:13];
            titleLabel.textColor = UIColor.blackColor;
            titleLabel.numberOfLines = 2.f;
            //视图组绑定标签2
            [self.rootLayout addViewGroup:@[backImageView,backgroundView,titleLabel] withActionData:dataModel.actionData to:2];
        }else if (dataModel.titles){
            
            UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.titleBackImageView]];
            
            UIView *headView = [UIView new];
            headView.backgroundColor = [UIColor myColorWithHexString:@"#E76472"];
            
            UILabel *headTitleLabel = [UILabel new];
            headTitleLabel.textAlignment = NSTextAlignmentCenter;
            headTitleLabel.text = dataModel.titles.firstObject;
            headTitleLabel.font = [CFTool font:14];
            headTitleLabel.textColor = UIColor.whiteColor;

            UIView *centerView = [UIView new];
            centerView.backgroundColor = [UIColor myColorWithHexString:@"#353E48"];
            
            UILabel *centerTitleLabel = [UILabel new];
            centerTitleLabel.textAlignment = NSTextAlignmentCenter;
            centerTitleLabel.text = dataModel.titles.lastObject;
            centerTitleLabel.font = [CFTool font:12];
            centerTitleLabel.textColor = UIColor.whiteColor;
            //视图组绑定标签2
            [self.rootLayout addViewGroup:@[backImageView,headView,headTitleLabel,centerView,centerTitleLabel] withActionData:dataModel.actionData to:222];
            
        }else if (dataModel.subTitle){
            
            UIImageView *titleBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.titleBackImageView]];
            
            UILabel *headTitleLabel = [UILabel new];
            headTitleLabel.textAlignment = NSTextAlignmentCenter;
            headTitleLabel.text = dataModel.subTitle;
            headTitleLabel.font = [CFTool font:14];
            headTitleLabel.textColor = UIColor.whiteColor;
            headTitleLabel.backgroundColor = [UIColor myColorWithHexString:@"#B66AD2"];
            
            [self.rootLayout addViewGroup:@[titleBackImageView,headTitleLabel] withActionData:dataModel.actionData to:333];
        }
    }
}
@end

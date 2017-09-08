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
                                    @"actionData":@"aa",
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
                               /* @{
                                    @"title":@"京东拍卖2",
                                    @"subTitle":@"尖货包经典表2",
                                    @"imageNames":@[@"p5-4"],
                                    },
*/

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
                                               
    
    
}

-(void)loadDataFromServer
{
    //删除原先绑定的数据视图。
    [self.rootLayout removeViewGroupFrom:1];
    [self.rootLayout removeViewGroupFrom:2];
    
    for (GLTest3DataModel *dataModel in self.datas)
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
            
            //视图组绑定标签2
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //假设这里发送网络请求并返回数据。
    [self loadDataFromServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleTap:(id<MyGrid>)sender
{
    NSString *message = [NSString stringWithFormat:@"您单击了:%@", sender.actionData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

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

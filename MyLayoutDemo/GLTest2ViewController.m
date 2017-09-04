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
    NSString *message = [NSString stringWithFormat:@"您单击了:%ld", (long)sender.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    MyBorderline *borderline = [[MyBorderline alloc] initWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];
    
    
    //建立第一行栅格
    id<MyGrid> g1 = [rootLayout addRow:1.0/5];
    g1.gravity = MyGravity_Vert_Center;
    g1.padding = UIEdgeInsetsMake(0, 10, 0, 10);
    g1.subviewSpace = 10;
    [g1 setTarget:self  action:@selector(handleTest1:)];
    
    //第1行栅格内2个子栅格内容包裹。
    [g1 addRow:MyLayoutSize.wrap];
    [g1 addRow:MyLayoutSize.wrap];
    
    
    //建立第二行图片栅格
    id<MyGrid>g2 = [rootLayout addRow:2.0/5];
    g2.anchor = YES;
    g2.topBorderline = borderline;
    [g2 setTarget:self  action:@selector(handleTest1:)];
    
    [g2 addRow:MyLayoutSize.fill].placeholder = YES;   //这里建立一个占位栅格的目的是为了让下面的兄弟栅格保持在第二行栅格的底部。
    [g2 addRow:MyLayoutSize.wrap].padding = UIEdgeInsetsMake(0, 10, 0, 0);
    


    //建立第三行栅格
    id<MyGrid>g3 = [rootLayout addRow:1.0/5];
    
    id<MyGrid> g31 = [g3 addColGrid:g1.cloneGrid measure:MyLayoutSize.fill];
    id<MyGrid> g32 = [g3 addColGrid:g31.cloneGrid];
    g32.leftBorderline = borderline;
    
    
    //建立第4行栅格，第4行和第三行一致，所以拷贝。
    id<MyGrid> g4 = [rootLayout addRowGrid:g3.cloneGrid];
    g4.topBorderline = borderline;
    
    
    //添加子视图序列。
    for (GLTest1DataModel *dataModel in self.datas)
    {
        if (dataModel.imageName != nil)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataModel.imageName]];
            [rootLayout addSubview:imageView];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = dataModel.title;
            titleLabel.textColor = [UIColor whiteColor];
            [rootLayout addSubview:titleLabel];
        }
        else
        {
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = dataModel.title;
            titleLabel.numberOfLines = 0;
            [rootLayout addSubview:titleLabel];
            
            UILabel *sourceLabel = [UILabel new];
            sourceLabel.text = dataModel.source;
            sourceLabel.font = [UIFont systemFontOfSize:11];
            sourceLabel.textColor = [UIColor lightGrayColor];
            [rootLayout addSubview:sourceLabel];
        }
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

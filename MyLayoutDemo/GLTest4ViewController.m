//
//  GLTest4ViewController.m
//  MyLayout
//
//  Created by 吴斌 on 2017/9/7.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "GLTest4ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"
#import <UIKit/UIKit.h>


//从服务器下发下来的数据模型。
@interface GLTest4DataModel : NSObject
@property(nonatomic, strong) NSMutableArray<NSString*> *categorysImages;    //分类图片
@property(nonatomic, strong) NSMutableArray<NSString*> *categorysTitles;    //分类标题
@property(nonatomic, strong) NSString *title;        //标题
@property(nonatomic, strong) NSString *subTitle;       //副标题
@property(nonatomic, strong) NSMutableArray<NSString*> *titleNames;    //标题的名称，如果为nil则没有标题
@property(nonatomic, strong) NSMutableArray<NSString*> *imageNames;    //图像的名称，如果为nil则没有图像
@property(nonatomic, strong) NSNumber *hasSales;          //促销标志
@property(nonatomic, strong) NSString *actionData;     //执行的动作。
@end

@implementation GLTest4DataModel



@end





@interface GLTest4ViewController()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@property(nonatomic, strong) NSMutableArray<GLTest4DataModel*> *datas;

@end

@implementation GLTest4ViewController


-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        
        NSArray *dataSource = @[
                                @{
                                    @"categorysImages":@[
                                                          @"head2",@"head2",@"head2",@"head2",
                                                          @"head2",@"head2",@"head2",@"head2",
                                                          @"head2",@"head2"
                                                        ],
                                    @"categorysTitles":@[
                                                          @"天猫",@"聚划算",@"天猫",@"外卖",
                                                          @"天猫超市",@"充值中心",@"飞猪旅行",@"领金币",
                                                          @"拍卖",@"分类"
                                                        ]
                                },
                                @{
                                    @"title":@"南京精选",
                                    @"subTitle":@"天猫超市",
                                    @"titleNames":@[@"周末疯狂趴",@"送5升菜籽油"],
                                    @"imageNames":@[@"p1-31",@"p1-32"],
                                    @"actionData":@"aa",
                                    @"hasSales":@(YES)
                                    },
                                @{
                                    @"title":@"海抢购",
                                    @"subTitle":@"01:29:45",
                                    @"imageNames":@[@"p1-33",@"p1-34"],
                                    @"actionData":@"bb",
                                    },
                                @{
                                    @"title":@"有好货",
                                    @"subTitle":@"高颜值美物",
                                    @"imageNames":@[@"p1-33",@"p1-34"],
                                    @"actionData":@"cc",
                                    },
                                @{
                                    @"title":@"必买清单",
                                    @"subTitle":@"都整理好",
                                    @"imageNames":@[@"p1-33",@"p1-34"],
                                    @"actionData":@"dd",
                                    @"hasSales":@(YES)
                                    }
                                ];
        
        for (NSDictionary *dict in dataSource)
        {
            GLTest4DataModel *model = [GLTest4DataModel new];
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
  //  rootLayout.padding = UIEdgeInsetsMake(0, 0, 10, 0);
    rootLayout.gridActionTarget  = self;
    self.view = rootLayout;
    self.rootLayout = rootLayout;
    
    
    rootLayout.tag = 1000;
    
    
    NSString *path =  [NSBundle.mainBundle pathForResource:@"GridLayoutDemo4.geojson" ofType:nil];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
   id temp = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    rootLayout.gridDictionary = temp;
}

-(void)loadDataFromServer
{
    for (GLTest4DataModel *dataModel in self.datas)
    {
        if (dataModel.categorysImages && dataModel.categorysTitles) {
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dataModel.categorysImages.count];
            for (int i = 0; i < dataModel.categorysImages.count; i++) {
                NSString *title = [dataModel.categorysTitles objectAtIndex:i];
                NSString *imageName = [dataModel.categorysImages objectAtIndex:i];
                MyFloatLayout *layout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
                layout.myHorzMargin = 0.f;
                [temp addObject:layout];
                UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName] highlightedImage:[UIImage imageNamed:imageName]];
                titleImageView.weight = 1.f;
                titleImageView.myHeight = 50.f;
                [layout addSubview:titleImageView];
                
                UILabel *titleLabel = [UILabel new];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = title;
                titleLabel.font = [CFTool font:12];
                titleLabel.textColor = [CFTool color:4];
                [layout addSubview:titleLabel];
                titleLabel.weight = 1.f;
                titleLabel.myHeight = 20.f;
            }
            [self.rootLayout addViewGroup:temp withActionData:dataModel.actionData to:1];
        }else if (dataModel.titleNames){
            NSMutableArray *temp = [NSMutableArray array];
            UIImageView *backgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk1"]];
            [temp addObject:backgroudImageView];
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = dataModel.title;
            titleLabel.font = [CFTool font:13];
            titleLabel.textColor = UIColor.whiteColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.adjustsFontSizeToFitWidth = YES;
            [temp addObject:titleLabel];
            UILabel *subTitleLabel = [UILabel new];
            subTitleLabel.text = dataModel.subTitle;
            subTitleLabel.font = [CFTool font:11];
            subTitleLabel.textColor = UIColor.whiteColor;
            subTitleLabel.textAlignment = NSTextAlignmentCenter;
            subTitleLabel.adjustsFontSizeToFitWidth = YES;
            [temp addObject:subTitleLabel];
            for (int i = 0; i < dataModel.titleNames.count; i++) {
                NSString *title = [dataModel.titleNames objectAtIndex:i];
                UILabel *lb = [UILabel new];
                lb.text = title;
                lb.font = [CFTool font:12];
                lb.textColor = UIColor.redColor;
                lb.adjustsFontSizeToFitWidth = YES;
                [temp addObject:lb];
            }
            for (int i = 0; i < dataModel.imageNames.count; i++) {
                NSString *imageName = [dataModel.imageNames objectAtIndex:i];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [temp addObject:imageView];
            }
            if ([dataModel.hasSales boolValue]) {
                UIImageView *optionalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1-12"]];
                [temp addObject:optionalView];
            }
            [self.rootLayout addViewGroup:temp withActionData:dataModel.actionData to:2];
        }else{
            NSMutableArray *temp = [NSMutableArray array];
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = dataModel.title;
            titleLabel.font = [CFTool font:16];
            titleLabel.textColor = [CFTool color:4];
            titleLabel.adjustsFontSizeToFitWidth = YES;
            [temp addObject:titleLabel];
            UILabel *subTitleLabel = [UILabel new];
            subTitleLabel.text = dataModel.subTitle;
            subTitleLabel.font = [CFTool font:13];
            subTitleLabel.textColor = [CFTool color:5];
            subTitleLabel.adjustsFontSizeToFitWidth = YES;
            [temp addObject:subTitleLabel];
            for (int i = 0; i < dataModel.imageNames.count; i++) {
                NSString *imageName = [dataModel.imageNames objectAtIndex:i];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [temp addObject:imageView];
            }
            if ([dataModel.hasSales boolValue]) {
                UIImageView *optionalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1-12"]];
                [temp addObject:optionalView];
            }
            [self.rootLayout addViewGroup:temp withActionData:dataModel.actionData to:3];
        }
    }
    //顶部
    UIScrollView *scrollView =[UIScrollView new];
    scrollView.pagingEnabled = YES;
    MyFlowLayout *scrollFlowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:1];
    scrollFlowLayout.pagedCount = 1; //pagedCount设置为非0时表示开始分页展示的功能，这里表示每页展示9个子视图，这个数量必须是arrangedCount的倍数。
    scrollFlowLayout.wrapContentWidth = YES; //设置布局视图的宽度由子视图包裹，当水平流式布局的这个属性设置为YES，并和pagedCount搭配使用会产生分页从左到右滚动的效果。
    scrollFlowLayout.heightSize.equalTo(scrollView.heightSize); //因为是分页从左到右滚动，因此布局视图的高度必须设置为和父滚动视图相等。
    [scrollView addSubview:scrollFlowLayout];
    UIImageView *advImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk3"]];
    [scrollFlowLayout addSubview:advImageView1];
    UIImageView *advImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk2"]];
    [scrollFlowLayout addSubview:advImageView2];
    UIImageView *advImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk1"]];
    [scrollFlowLayout addSubview:advImageView3];
    UIPageControl *pageCtrl = [UIPageControl new];
    pageCtrl.numberOfPages = 5;
    pageCtrl.currentPage = 0;
    pageCtrl.pageIndicatorTintColor = [UIColor redColor];
    UIView *bottomLineView = [UIView new];
    bottomLineView.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.5f];
    [_rootLayout addViewGroup:@[scrollView,pageCtrl,bottomLineView] withActionData:nil to:1000];
}


-(void)handleTap:(id<MyGrid>)sender
{
    NSString *message = [NSString stringWithFormat:@"您单击了:%@", sender.actionData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}


@end

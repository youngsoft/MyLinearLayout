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

static NSInteger sPartTag1 = 1000;
static NSInteger sPartTag2 = 1001;
static NSInteger sPartTag3 = 1002;
static NSInteger sPartTag4 = 1003;

// 第2部分模型
@interface GLTest4Model2 : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imageName;

@end

@implementation  GLTest4Model2

@end

// 第4部分模型
@interface GLTest4Model4 : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, copy) NSArray *imageNames;

@property (nonatomic, copy) NSString *actionDatas;

@property (nonatomic, strong) NSNumber *hasSales;

@end

@implementation  GLTest4Model4

@end




//............................分割线.............................
@interface GLTest4ViewController()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@property (nonatomic, strong) NSMutableArray<GLTest4Model2 *> *part2Datas;

@property (nonatomic, strong) NSMutableArray<GLTest4Model4 *> *part4Datas;

@end

@implementation GLTest4ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLayout];
    
    [self bindView];
}

- (NSMutableArray<GLTest4Model2 *> *)part2Datas
{
    if(_part2Datas == nil) {
        _part2Datas = [NSMutableArray<GLTest4Model2 *> array];
        NSArray *dataSource = @[
                                @{
                                    @"title":@"天猫",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"聚划算",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"天猫",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"外卖",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"天猫超市",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"充值中心",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"飞猪旅行",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"领金币",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"拍卖",
                                    @"imageName":@"head2"
                                },
                                @{
                                    @"title":@"分类",
                                    @"imageName":@"head2"
                                }
                                ];
        for(NSDictionary *dic in dataSource) {
            GLTest4Model2 *model = [GLTest4Model2 new];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [model setValue:obj forKey:key];
            }];
            [_part2Datas addObject:model];
        }
    }
    return _part2Datas;
}

- (NSMutableArray<GLTest4Model4 *> *)part4Datas
{
    if(_part4Datas == nil) {
        _part4Datas = [NSMutableArray<GLTest4Model4 *> array];
        NSArray *dataSource = @[
                                    @{
                                        @"title":@"海抢购",
                                        @"subTitle":@"01:29:45",
                                        @"imageNames":@[@"p1-33",@"p1-34"],
                                        @"actionDatas":@"bb"
                                     },
                                    @{
                                        @"title":@"有好货",
                                        @"subTitle":@"高颜值美物",
                                        @"imageNames":@[@"p1-33",@"p1-34"],
                                        @"actionDatas":@"cc"
                                    },
                                    @{
                                        @"title":@"必买清单",
                                        @"subTitle":@"都整理好",
                                        @"imageNames":@[@"p1-33",@"p1-34"],
                                        @"actionDatas":@"dd",
                                        @"hasSales":@(YES)
                                    }
                                ];
        for(NSDictionary *dic in dataSource) {
            GLTest4Model4 *model = [GLTest4Model4 new];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [model setValue:obj forKey:key];
            }];
            [_part4Datas addObject:model];
        }
    }
    return _part4Datas;
}




- (void)createLayout
{
    /*
       这个例子演示一个通过JSON格式描述的栅格来构建栅格布局的示例。
     */
    
     if (@available(iOS 11.0, *))
     {
     }
     else
     {
         self.edgesForExtendedLayout = UIRectEdgeNone;
     }
    
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.myMargin = MyLayoutPos.safeAreaMargin;
    [self.view addSubview:rootLayout];
    self.rootLayout = rootLayout;
    
    
    rootLayout.gridActionTarget = self;  //因为JSON格式的栅格描述是无法指定事件的执行者的，因此栅格布局提供了这个属性来设置所有通过字典或者通过JSON来构建栅格布局时的事件执行者。
    
    //从JSON格式的文件中来构建栅格布局.
    NSString *jsonFilePath =  [NSBundle.mainBundle pathForResource:@"GridLayoutDemo4.json" ofType:nil];
    rootLayout.gridDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:NSJSONReadingAllowFragments error:nil];
}


-(void)bindView
{
    [self.rootLayout removeAllSubviews];
    {
        //第一部分
        UIScrollView *scrollView =[UIScrollView new];
        scrollView.pagingEnabled = YES;
        MyFlowLayout *scrollFlowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:1];
        scrollFlowLayout.pagedCount = 1;
        scrollFlowLayout.wrapContentWidth = YES;
        scrollFlowLayout.heightSize.equalTo(scrollView.heightSize); 
        [scrollView addSubview:scrollFlowLayout];
        NSArray *temp = @[@"bk1",@"bk2",@"bk3",@"bk1",@"bk2"];
        for(NSString *imageName in temp) {
            UIImageView *advImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            [scrollFlowLayout addSubview:advImageView];
        }
        UIPageControl *pageCtrl = [UIPageControl new];
        pageCtrl.numberOfPages = 5;
        pageCtrl.currentPage = 0;
        pageCtrl.pageIndicatorTintColor = [UIColor redColor];
        UIView *bottomLineView = [UIView new];
        bottomLineView.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.5f];
        [_rootLayout addViewGroup:@[scrollView,pageCtrl,bottomLineView] withActionData:nil to:sPartTag1];
    }
    {
        //第二部分
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.part2Datas.count];
        for (GLTest4Model2 *model in self.part2Datas) {
            MyFloatLayout *layout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
            layout.myHorzMargin = 0.f;
            [temp addObject:layout];
            UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.imageName] highlightedImage:[UIImage imageNamed:model.imageName]];
            titleImageView.weight = 1.f;
            titleImageView.myHeight = 50.f;
            [layout addSubview:titleImageView];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = model.title;
            titleLabel.font = [CFTool font:12];
            titleLabel.textColor = [CFTool color:4];
            [layout addSubview:titleLabel];
            titleLabel.weight = 1.f;
            titleLabel.myHeight = 20.f;
        }
        [self.rootLayout addViewGroup:temp withActionData:nil to:sPartTag2];
    }
    {
        //第三部分
        NSMutableArray *temp = [NSMutableArray array];
        UIImageView *backgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk1"]];
        [temp addObject:backgroudImageView];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"南京精选";
        titleLabel.font = [CFTool font:13];
        titleLabel.textColor = UIColor.whiteColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [temp addObject:titleLabel];
        
        UILabel *subTitleLabel = [UILabel new];
        subTitleLabel.text = @"天猫超市";
        subTitleLabel.font = [CFTool font:11];
        subTitleLabel.textColor = UIColor.whiteColor;
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.adjustsFontSizeToFitWidth = YES;
        [temp addObject:subTitleLabel];
        
        NSArray *titles = @[@"周末疯狂趴",@"送5升菜籽油"];
        for (NSString *title in titles) {
            UILabel *lb = [UILabel new];
            lb.text = title;
            lb.font = [CFTool font:12];
            lb.textColor = UIColor.redColor;
            lb.adjustsFontSizeToFitWidth = YES;
            [temp addObject:lb];
        }
        
        NSArray *imageNames = @[@"p1-31",@"p1-32"];
        for (NSString *imageName in imageNames) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            [temp addObject:imageView];
        }
        
        UIImageView *optionalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1-12"]];
        [temp addObject:optionalView];
        [self.rootLayout addViewGroup:temp withActionData:@"aa" to:sPartTag3];
    }
    {
        //第四部分
        for(GLTest4Model4 *model in self.part4Datas) {
            NSMutableArray *temp = [NSMutableArray array];
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = model.title;
            titleLabel.font = [CFTool font:16];
            titleLabel.textColor = [CFTool color:4];
            titleLabel.adjustsFontSizeToFitWidth = YES;
            [temp addObject:titleLabel];
            
            UILabel *subTitleLabel = [UILabel new];
            subTitleLabel.text = model.subTitle;
            subTitleLabel.font = [CFTool font:13];
            subTitleLabel.textColor = [CFTool color:5];
            subTitleLabel.adjustsFontSizeToFitWidth = YES;
            [temp addObject:subTitleLabel];
            for (NSString *imageName in model.imageNames) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [temp addObject:imageView];
            }
            if ([model.hasSales boolValue]) {
                UIImageView *optionalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1-12"]];
                [temp addObject:optionalView];
            }
            [self.rootLayout addViewGroup:temp withActionData:model.actionDatas to:sPartTag4];
        }
    }
}


-(void)handleTap:(id<MyGrid>)sender
{
    NSString *message = [NSString stringWithFormat:@"您单击了:%@", sender.actionData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}


@end

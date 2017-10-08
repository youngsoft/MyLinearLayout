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


@interface GLTest4ViewController()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@end

@implementation GLTest4ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test1];
    
    [self bindView];
}

- (void)test1
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.gridActionTarget  = self;
    self.view = rootLayout;
    self.rootLayout = rootLayout;
    NSString *path =  [NSBundle.mainBundle pathForResource:@"GridLayoutDemo4.json" ofType:nil];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
   id temp = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    rootLayout.gridDictionary = temp;
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
        NSArray *imageNames = @[
                                @"head2",@"head2",@"head2",@"head2",
                                @"head2",@"head2",@"head2",@"head2",
                                @"head2",@"head2"
                                ];
        NSArray *titles = @[
                            @"天猫",@"聚划算",@"天猫",@"外卖",
                            @"天猫超市",@"充值中心",@"飞猪旅行",@"领金币",
                            @"拍卖",@"分类"
                            ];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:titles.count];
        for (int i = 0; i < imageNames.count; i++) {
            NSString *title = [titles objectAtIndex:i];
            NSString *imageName = [imageNames objectAtIndex:i];
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
        NSArray *titles = @[@"海抢购",@"有好货",@"必买清单"];
        NSArray *subTitles = @[@"01:29:45",@"高颜值美物",@"都整理好"];
        NSArray *imageNames = @[@[@"p1-33",@"p1-34"],@[@"p1-33",@"p1-34"],@[@"p1-33",@"p1-34"]];
        NSArray *actionDatas = @[@"bb",@"cc",@"dd"];
        NSArray *hasSales = @[@(NO),@(NO),@(YES)];
        for(int i = 0 ; i < titles.count; i++) {
            NSString *title = [titles objectAtIndex:i];
            NSString *subTitle = [subTitles objectAtIndex:i];
            NSArray *tempImages = [imageNames objectAtIndex:i];
            NSString *actionData = [actionDatas objectAtIndex:i];
            NSString *hasSale = [hasSales objectAtIndex:i];
            
            NSMutableArray *temp = [NSMutableArray array];
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = title;
            titleLabel.font = [CFTool font:16];
            titleLabel.textColor = [CFTool color:4];
            titleLabel.adjustsFontSizeToFitWidth = YES;
            [temp addObject:titleLabel];
            
            UILabel *subTitleLabel = [UILabel new];
            subTitleLabel.text = subTitle;
            subTitleLabel.font = [CFTool font:13];
            subTitleLabel.textColor = [CFTool color:5];
            subTitleLabel.adjustsFontSizeToFitWidth = YES;
            [temp addObject:subTitleLabel];
            for (NSString *imageName in tempImages) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [temp addObject:imageView];
            }
            if ([hasSale boolValue]) {
                UIImageView *optionalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1-12"]];
                [temp addObject:optionalView];
            }
            [self.rootLayout addViewGroup:temp withActionData:actionData to:sPartTag4];
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

//
//  ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "ViewController.h"
#import "LLTest1ViewController.h"
#import "LLTest2ViewController.h"
#import "LLTest3ViewController.h"
#import "LLTest4ViewController.h"
#import "LLTest5ViewController.h"
#import "LLTest6ViewController.h"
#import "LLTest7ViewController.h"

#import "FLTest1ViewController.h"
#import "FLTest2ViewController.h"

#import "RLTest1ViewController.h"
#import "RLTest2ViewController.h"
#import "RLTest3ViewController.h"


#import "TLTest1ViewController.h"
#import "TLTest2ViewController.h"

#import "FLLTest1ViewController.h"
#import "FLLTest2ViewController.h"
#import "FLLTest3ViewController.h"


#import "AllTest1ViewController.h"
#import "AllTest2ViewController.h"
#import "AllTest3ViewController.h"
#import "AllTest4ViewController.h"
#import "AllTest5ViewController.h"
#import "AllTest6ViewController.h"


#import "FOLTest1ViewController.h"
#import "FOLTest2ViewController.h"
#import "FOLTest3ViewController.h"
#import "FOLTest4ViewController.h"
#import "FOLTest5ViewController.h"


@interface ViewController ()

@property(nonatomic, strong) NSArray *demoVCLists;

@end


@implementation ViewController


-(NSArray*)demoVCLists
{
    if (_demoVCLists == nil)
    {
        _demoVCLists = @[@{@"title":@"1线性布局-垂直布局和水平布局",
                           @"class":[LLTest1ViewController class]
                           },
                         @{@"title":@"2线性布局-和UIScrollView的结合",
                           @"class":[LLTest2ViewController class]
                           },
                         @{@"title":@"3线性布局-子视图的停靠和填充",
                           @"class":[LLTest3ViewController class]
                           },
                         @{@"title":@"4线性布局-布局尺寸由子视图决定",
                           @"class":[LLTest4ViewController class]
                           },
                         @{@"title":@"5线性布局-子视图尺寸由布局决定",
                           @"class":[LLTest5ViewController class]
                           },
                         @{@"title":@"6线性布局-子视图之间的浮动间距",
                           @"class":[LLTest6ViewController class]
                           },
                         @{@"title":@"7线性布局-均分子视图尺寸和间距",
                           @"class":[LLTest7ViewController class]
                           },
                         @{@"title":@"8框架布局-子视图在布局各方位停靠",
                           @"class":[FLTest1ViewController class],
                           },
                         @{@"title":@"9框架布局-复杂的界面布局",
                           @"class":[FLTest2ViewController class]
                           },
                         @{@"title":@"10相对布局-子视图之间的约束依赖",
                           @"class":[RLTest1ViewController class]
                           },
                         @{@"title":@"11相对布局-子视图的尺寸按比例分配",
                           @"class":[RLTest2ViewController class]
                           },
                         @{@"title":@"12相对布局-子视图整体居中",
                           @"class":[RLTest3ViewController class]
                           },
                         @{@"title":@"13表格布局-垂直表格",
                           @"class":[TLTest1ViewController class]
                           },
                         @{@"title":@"14表格布局-水平表格实现瀑布流",
                           @"class":[TLTest2ViewController class]
                           },
                         @{@"title":@"15流式布局-有规律的子视图排列",
                           @"class":[FLLTest1ViewController class]
                           },
                         @{@"title":@"16流式布局-标签流",
                           @"class":[FLLTest2ViewController class]
                           },
                         @{@"title":@"17流式布局-子视图的拖拽调整功能",
                           @"class":[FLLTest3ViewController class]
                           },
                         @{@"title":@"18浮动布局-浮动效果的演示",
                           @"class":[FOLTest1ViewController class]
                           },
                         @{@"title":@"19浮动布局-仿天猫淘宝首页实现",
                           @"class":[FOLTest2ViewController class]
                           },
                         @{@"title":@"20浮动布局-仿ZAKER今日头条实现",
                           @"class":[FOLTest3ViewController class]
                           },
                         @{@"title":@"21浮动布局-标签流",
                           @"class":[FOLTest4ViewController class]
                           },
                         @{@"title":@"22浮动布局-左右排列的文本",
                           @"class":[FOLTest5ViewController class]
                           },
                         @{@"title":@"23综合布局-布局和UITableView(动态高度)",
                           @"class":[AllTest1ViewController class]
                           },
                         @{@"title":@"24综合布局-布局和UITableView(静态高度)",
                           @"class":[AllTest2ViewController class]
                           },
                         @{@"title":@"25综合布局-UITableView的替换方案",
                           @"class":[AllTest3ViewController class]
                           },
                         @{@"title":@"26综合布局-UICollectionView的替换方案",
                           @"class":[AllTest4ViewController class]
                           },
                         @{@"title":@"27SizeClass-不同屏幕下的布局样式1",
                           @"class":[AllTest5ViewController class]
                           },
                         @{@"title":@"28SizeClass-不同屏幕下的布局样式2",
                           @"class":[AllTest6ViewController class]
                           }
                         ];
        
        
        
        
    }
    
    return _demoVCLists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"目录";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoVCLists.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    
    cell.textLabel.text = self.demoVCLists[indexPath.row][@"title"];
    return cell;
    
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *demoVC = [[self.demoVCLists[indexPath.row][@"class"] alloc] init];
    demoVC.title = self.demoVCLists[indexPath.row][@"title"];
    [self.navigationController pushViewController:demoVC animated:YES];

}





@end

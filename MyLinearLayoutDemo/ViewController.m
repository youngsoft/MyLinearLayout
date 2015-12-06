//
//  ViewController.m
//  MyLinearLayoutDemo
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


#import "AllTest1ViewController.h"
#import "AllTest2ViewController.h"
#import "AllTest3ViewController.h"
#import "AllTest4ViewController.h"


@interface ViewController ()

@end


@implementation ViewController


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
    return 20;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"线性布局-垂直布局和水平布局";
            break;
        case 1:
            cell.textLabel.text = @"线性布局-和UIScrollView的结合";
            break;
        case 2:
            cell.textLabel.text = @"线性布局-子视图停靠";
            break;
        case 3:
            cell.textLabel.text = @"线性布局-布局尺寸由子视图决定";
            break;
        case 4:
            cell.textLabel.text = @"线性布局-子视图尺寸由布局决定";
            break;
        case 5:
            cell.textLabel.text = @"线性布局-视图之间的浮动间距";
            break;
        case 6:
            cell.textLabel.text = @"线性布局-均分视图和间距";
            break;
        case 7:
            cell.textLabel.text = @"框架布局1";
            break;
        case 8:
            cell.textLabel.text = @"框架布局2";
            break;
        case 9:
            cell.textLabel.text = @"相对布局1-视图之间的依赖";
            break;
        case 10:
            cell.textLabel.text = @"相对布局2-子视图之间尺寸分配";
            break;
        case 11:
            cell.textLabel.text = @"相对布局3-一组视图整体居中";
            break;
        case 12:
            cell.textLabel.text = @"表格布局-垂直表格";
            break;
        case 13:
            cell.textLabel.text = @"表格布局-水平表格(瀑布流)";
            break;
        case 14:
            cell.textLabel.text = @"流式布局";
            break;
        case 15:
            cell.textLabel.text = @"UITableViewCell动态高度";
            break;
        case 16:
            cell.textLabel.text = @"完美屏幕适配";
            break;
        case 17:
            cell.textLabel.text = @"UITableView的替换方案";
            break;
        case 18:
            cell.textLabel.text = @"五种布局实现同一功能";
            break;
        default:
            break;
    }
    
    return cell;
    
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [LLTest1ViewController new];
            break;
        case 1:
            vc = [LLTest2ViewController new];
            break;
        case 2:
            vc = [LLTest3ViewController new];
            break;
        case 3:
            vc = [LLTest4ViewController new];
            break;
        case 4:
            vc = [LLTest5ViewController new];
            break;
        case 5:
            vc = [LLTest6ViewController new];
            break;
        case 6:
            vc = [LLTest7ViewController new];
            break;
        case 7:
            vc = [FLTest1ViewController new];
            break;
        case 8:
            vc = [FLTest2ViewController new];
            break;
        case 9:
            vc = [RLTest1ViewController new];
            break;
        case 10:
            vc = [RLTest2ViewController new];
            break;
        case 11:
            vc = [RLTest3ViewController new];
            break;
        case 12:
            vc = [TLTest1ViewController new];
            break;
        case 13:
            vc = [TLTest2ViewController new];
            break;
        case 14:
            vc = [FLLTest1ViewController new];
            break;
        case 15:
            vc = [AllTest1ViewController new];
            break;
        case 16:
            vc = [AllTest2ViewController new];
            break;
        case 17:
            vc = [AllTest3ViewController new];
            break;
        case 18:
            vc = [AllTest4ViewController new];
            break;
        default:
            break;
    }
    
    
    [self.navigationController pushViewController:vc animated:YES];
}





@end

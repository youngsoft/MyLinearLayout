//
//  ViewController.m
//  MyLinearLayoutDemo
//
//  Created by oybq on 15/6/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "ViewController.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "Test3ViewController.h"
#import "Test4ViewController.h"
#import "Test5ViewController.h"
#import "Test6ViewController.h"
#import "Test7ViewController.h"
#import "Test8ViewController.h"
#import "Test9ViewController.h"
#import "Test10ViewController.h"
#import "Test11ViewController.h"
#import "Test12ViewController.h"
#import "Test13ViewController.h"
#import "Test14ViewController.h"
#import "Test15ViewController.h"
#import "Test16ViewController.h"
#import "Test17ViewController.h"
#import "Test18ViewController.h"
#import "Test19ViewController.h"


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
    return 19;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"子视图布局和自动调整大小";
            break;
        case 1:
            cell.textLabel.text = @"子视图的隐藏显示以及UIScrollView的自动调整";
            break;
        case 2:
            cell.textLabel.text = @"布局内视图停靠1-左中右";
            break;
        case 3:
            cell.textLabel.text = @"布局内视图停靠2-上中下";
            break;
        case 4:
            cell.textLabel.text = @"布局内视图停靠3-自定义";
            break;
        case 5:
            cell.textLabel.text = @"子视图的尺寸由父视图决定";
            break;
        case 6:
            cell.textLabel.text = @"相对视图尺寸";
            break;
        case 7:
            cell.textLabel.text = @"布局视图尺寸由子视图决定";
            break;
        case 8:
            cell.textLabel.text = @"视图之间的浮动间距";
            break;
        case 9:
            cell.textLabel.text = @"均分视图和间距";
            break;
        case 10:
            cell.textLabel.text = @"框架布局";
            break;
        case 11:
            cell.textLabel.text = @"边框的线以及布局动画,触摸事件";
            break;
        case 12:
            cell.textLabel.text = @"相对布局1-视图之间的依赖";
            break;
        case 13:
            cell.textLabel.text = @"相对布局2-子视图之间尺寸分配";
            break;
        case 14:
            cell.textLabel.text = @"相对布局3-父视图高宽由子视图决定";
            break;
        case 15:
            cell.textLabel.text = @"相对布局4-一组视图居中";
            break;
        case 16:
            cell.textLabel.text = @"表格布局-垂直表格";
            break;
        case 17:
            cell.textLabel.text = @"表格布局-水平表格(瀑布流)";
            break;
        case 18:
            cell.textLabel.text = @"其他";
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
            vc = [Test1ViewController new];
            break;
        case 1:
            vc = [Test2ViewController new];
            break;
        case 2:
            vc = [Test3ViewController new];
            break;
        case 3:
            vc = [Test4ViewController new];
            break;
        case 4:
            vc = [Test5ViewController new];
            break;
        case 5:
            vc = [Test6ViewController new];
            break;
        case 6:
            vc = [Test7ViewController new];
            break;
        case 7:
            vc = [Test8ViewController new];
            break;
        case 8:
            vc = [Test9ViewController new];
            break;
        case 9:
            vc = [Test10ViewController new];
            break;
        case 10:
            vc = [Test11ViewController new];
            break;
        case 11:
            vc = [Test12ViewController new];
            break;
        case 12:
            vc = [Test13ViewController new];
            break;
        case 13:
            vc = [Test14ViewController new];
            break;
        case 14:
            vc = [Test15ViewController new];
            break;
        case 15:
            vc = [Test16ViewController new];
            break;
        case 16:
            vc = [Test17ViewController new];
            break;
        case 17:
            vc = [Test18ViewController new];
            break;
        case 18:
            vc = [Test19ViewController new];
            break;
        default:
            break;
    }
    
    
    [self.navigationController pushViewController:vc animated:YES];
}





@end

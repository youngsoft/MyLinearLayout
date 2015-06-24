//
//  ViewController.m
//  MyLinearLayoutDemo
//
//  Created by oybq on 15/6/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "ViewController.h"
#import "MyLinearLayout.h"
#import "MyFrameLayout.h"

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

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"子视图间距设置以及自动调整大小的属性1";
            break;
        case 1:
            cell.textLabel.text = @"子视图的隐藏显示以及UIScrollView的自动调整";
            break;
        case 2:
            cell.textLabel.text = @"布局内视图停靠1";
            break;
        case 3:
            cell.textLabel.text = @"布局内视图停靠2";
            break;
        case 4:
            cell.textLabel.text = @"布局内视图停靠3";
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
            cell.textLabel.text = @"边框的线以及布局动画";
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
        default:
            break;
    }
    
    
    [self.navigationController pushViewController:vc animated:YES];
}





@end

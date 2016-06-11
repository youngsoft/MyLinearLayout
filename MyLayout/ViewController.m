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
#import "TLTest3ViewController.h"

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
        _demoVCLists = @[@{@"title":NSLocalizedString(@"1.MyLinearLayout - Vert&Horz", @""),
                           @"class":[LLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.MyLinearLayout - Combine with UIScrollView", @""),
                           @"class":[LLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"3.MyLinearLayout - Gravity&Fill", @""),
                           @"class":[LLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"4.MyLinearLayout - Wrap content", @""),
                           @"class":[LLTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"5.MyLinearLayout - Weight & Relative margin", @""),
                           @"class":[LLTest5ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"6.MyLinearLayout - Size limit & Flexed margin", @""),
                           @"class":[LLTest6ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"7.MyLinearLayout - Average size&spacing", @""),
                           @"class":[LLTest7ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"8.MyFrameLayout - Gravity&Fill", @""),
                           @"class":[FLTest1ViewController class],
                           },
                         @{@"title":NSLocalizedString(@"9.MyFrameLayout - Complex UI", @""),
                           @"class":[FLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"10.MyRelativeLayout - Constraint&Dependence", @""),
                           @"class":[RLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"11.MyRelativeLayout - Prorate size", @""),
                           @"class":[RLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"12.MyRelativeLayout - Centered", @""),
                           @"class":[RLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"13.MyTableLayout - Vert", @""),
                           @"class":[TLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"14.MyTableLayout - Waterfall(Horz)", @""),
                           @"class":[TLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"15.MyTableLayout - Intelligent borderLine", @""),
                           @"class":[TLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"16.MyFlowLayout - Regular arrangement", @""),
                           @"class":[FLLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"17.MyFlowLayout - Tag cloud", @""),
                           @"class":[FLLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"18.MyFlowLayout - Drag", @""),
                           @"class":[FLLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"19.MyFloatLayout - Float", @""),
                           @"class":[FOLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"20.MyFloatLayout - Jagged", @""),
                           @"class":[FOLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"21.MyFloatLayout - Card news", @""),
                           @"class":[FOLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"22.MyFloatLayout - Tag cloud", @""),
                           @"class":[FOLTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"23.MyFloatLayout - Title & Description", @""),
                           @"class":[FOLTest5ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"24.UITableView - Dynamic height", @""),
                           @"class":[AllTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"25.UITableView - Static height", @""),
                           @"class":[AllTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"26.Replacement of UITableView", @""),
                           @"class":[AllTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"27.Replacement of UICollectionView", @""),
                           @"class":[AllTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"28.SizeClass - Demo1", @""),
                           @"class":[AllTest5ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"29.SizeClass - Demo2", @""),
                           @"class":[AllTest6ViewController class]
                           }
                         ];
        
        
        
        
    }
    
    return _demoVCLists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = NSLocalizedString(@"Category",@"");
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    tipLabel.text = @"如果您在模拟器中运行时看到的不是中文则请到系统设置里面将语言设置为中文(english ignore this text)";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.numberOfLines = 0;
    self.tableView.tableHeaderView = tipLabel;
    
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
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
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

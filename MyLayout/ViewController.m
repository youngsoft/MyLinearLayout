//
//  ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "ViewController.h"
#import "CFTool.h"
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
#import "RLTest4ViewController.h"
#import "RLTest5ViewController.h"


#import "TLTest1ViewController.h"
#import "TLTest2ViewController.h"
#import "TLTest3ViewController.h"

#import "FLLTest1ViewController.h"
#import "FLLTest2ViewController.h"
#import "FLLTest3ViewController.h"
#import "FLLTest4ViewController.h"
#import "FLLTest5ViewController.h"


#import "AllTest1ViewController.h"
#import "AllTest2ViewController.h"
#import "AllTest3ViewController.h"
#import "AllTest4ViewController.h"
#import "AllTest5ViewController.h"
#import "AllTest6ViewController.h"
#import "AllTest7ViewController.h"
#import "AllTest8ViewController.h"


#import "FOLTest1ViewController.h"
#import "FOLTest2ViewController.h"
#import "FOLTest3ViewController.h"
#import "FOLTest4ViewController.h"
#import "FOLTest5ViewController.h"
#import "FOLTest6ViewController.h"

#import "PLTest1ViewController.h"
#import "PLTest2ViewController.h"
#import "PLTest3ViewController.h"
#import "PLTest4ViewController.h"


@interface ViewController ()

@property(nonatomic, strong) NSArray *demoVCLists;

@end


@implementation ViewController

-(NSArray*)demoVCLists
{
    if (_demoVCLists == nil)
    {
        _demoVCLists = @[@{@"title":NSLocalizedString(@"1.LinearLayout - Vert&Horz", @""),
                           @"class":[LLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.LinearLayout - Combine with UIScrollView", @""),
                           @"class":[LLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"3.LinearLayout - Gravity&Fill", @""),
                           @"class":[LLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"4.LinearLayout - Wrap content", @""),
                           @"class":[LLTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"5.LinearLayout - Weight & Relative margin", @""),
                           @"class":[LLTest5ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"6.LinearLayout - Size limit & Flexed margin", @""),
                           @"class":[LLTest6ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"7.LinearLayout - Average size&space", @""),
                           @"class":[LLTest7ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"1.FrameLayout - Gravity&Fill", @""),
                           @"class":[FLTest1ViewController class],
                           },
                         @{@"title":NSLocalizedString(@"2.FrameLayout - Complex UI", @""),
                           @"class":[FLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"1.RelativeLayout - Constraint&Dependence", @""),
                           @"class":[RLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.RelativeLayout - Prorate size", @""),
                           @"class":[RLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"3.RelativeLayout - Centered", @""),
                           @"class":[RLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"4.RelativeLayout - Scroll&Dock", @""),
                           @"class":[RLTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"5.RelativeLayout - Boundary limit", @""),
                           @"class":[RLTest5ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"1.TableLayout - Vert", @""),
                           @"class":[TLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.TableLayout - Waterfall(Horz)", @""),
                           @"class":[TLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"3.TableLayout - Intelligent Borderline", @""),
                           @"class":[TLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"1.FlowLayout - Regular arrangement", @""),
                           @"class":[FLLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.FlowLayout - Tag cloud", @""),
                           @"class":[FLLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"3.FlowLayout - Drag", @""),
                           @"class":[FLLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"4.FlowLayout - Weight", @""),
                           @"class":[FLLTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"5.FlowLayout - Paging", @""),
                           @"class":[FLLTest5ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"1.FloatLayout - Float", @""),
                           @"class":[FOLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.FloatLayout - Jagged", @""),
                           @"class":[FOLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"3.FloatLayout - Card news", @""),
                           @"class":[FOLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"4.FloatLayout - Tag cloud", @""),
                           @"class":[FOLTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"5.FloatLayout - Title & Description", @""),
                           @"class":[FOLTest5ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"6.FloatLayout - User Profiles", @""),
                           @"class":[FOLTest6ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"1.PathLayout - Animations", @""),
                           @"class":[PLTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.PathLayout - Curves", @""),
                           @"class":[PLTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"3.PathLayout - Menu in Circle", @""),
                           @"class":[PLTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"4.PathLayout - Fan", @""),
                           @"class":[PLTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"1.UITableView - Dynamic height", @""),
                           @"class":[AllTest1ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.UITableView - Static height", @""),
                           @"class":[AllTest2ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"3.Replacement of UITableView", @""),
                           @"class":[AllTest3ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"4.Replacement of UICollectionView", @""),
                           @"class":[AllTest4ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"1.SizeClass - Demo1", @""),
                           @"class":[AllTest5ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"2.SizeClass - Demo2", @""),
                           @"class":[AllTest6ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"❁1.Screen perfect fit - Demo1", @""),
                           @"class":[AllTest7ViewController class]
                           },
                         @{@"title":NSLocalizedString(@"❁2.Screen perfect fit - Demo2", @""),
                           @"class":[AllTest8ViewController class]
                           }
                         ];
        
        
        
        
    }
    
    return _demoVCLists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = NSLocalizedString(@"Category",@"");
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[CFTool font:15],NSForegroundColorAttributeName:[CFTool color:4]};
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    tipLabel.text = @"如果您在模拟器中运行时看到的不是中文则请到系统设置里面将语言设置为中文(english ignore this text)";
    tipLabel.font = [CFTool font:16];
    tipLabel.numberOfLines = 0;
    tipLabel.adjustsFontSizeToFitWidth = YES;
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
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [CFTool font:15];
    cell.textLabel.textColor = [CFTool color:4];
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

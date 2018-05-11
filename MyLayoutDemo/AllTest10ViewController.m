//
//  AllTest10ViewController.m
//  FriendListDemo
//
//  Created by bsj_mac_2 on 2018/5/7.
//  Copyright © 2018年 bsj_mac_2. All rights reserved.
//

#import "AllTest10ViewController.h"
#import "AllTest10Cell.h"
#import "YYFPSLabel.h"
#import "AllTest10HeaderView.h"
#import "AllTest10Model.h"

@interface AllTest10ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray * cellDatas;
@property (strong, nonatomic) UITableView * tableView;
@end

@implementation AllTest10ViewController

-(void)loadView
{
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    //为了支持iPhoneX的全屏幕适配。我们只需要对根布局视图设置一些扩展的属性，默认情况下是不需要进行特殊设置的，MyLayout自动会对iPhoneX进行适配
    //我们知道iOS11中引入了安全区域的概念，MyLayout中的根布局视图会自动将安全区域叠加到设置的padding中去。这个属性是通过insetsPaddingFromSafeArea来完成的。
    //默认情况下四周的安全区域都会叠加到padding中去，因此您可以根据特殊情况来设置只需要叠加哪一个方向的安全区域。您可以通过如下的方法：
    rootLayout.insetsPaddingFromSafeArea = UIRectEdgeAll;  //您可以在这里将值改变为UIRectEdge的其他类型然后试试运行的效果。并且在运行时切换横竖屏看看效果
    
    //iPhoneX设备中具有一个尺寸为44的刘海区域。当您横屏时为了对齐，左右两边的安全缩进区域都是44。但是有些时候我们希望没有刘海的那一边不需要缩进对齐而是延伸到安全区域以外。这时候您可以通过给根布局视图设置insetLandscapeFringePadding属性来达到效果。
    //注意这个属性只有insetsPaddingFromSafeArea设置了左右都缩进时才有效。
    rootLayout.insetLandscapeFringePadding = NO;   //您可以在横屏下将这个属性设置为YES后，然后尝试一下进行左右旋转后查看运行的效果。
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBar];
    [self setupUI];
    [self loadDatas];
}

- (void)setNavBar {
    self.navigationItem.titleView = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    self.title = @"朋友圈";
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.myHorzMargin = 0;
    self.tableView.heightSize.lBound(self.view.heightSize, 0, 1);
    self.tableView.delegate = self;
    self.tableView.sectionFooterHeight = 0.0001;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 10);
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerClass:[AllTest10Cell class] forCellReuseIdentifier:@"AllTest10Cell"];
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 100;
    [self.tableView registerClass:[AllTest10HeaderView class] forHeaderFooterViewReuseIdentifier:@"AllTest10HeaderView"];
    [self.view addSubview:self.tableView];
}

- (void)loadDatas {
    [self.cellDatas addObjectsFromArray:[AllTest10Model getRandTestDatasWithNumber:60]];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDatas.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AllTest10HeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AllTest10HeaderView"];
    headerView.model = self.cellDatas[section];
    __weak typeof(self) weakSelf = self;
    headerView.praiseClickHandler = ^(AllTest10HeaderView *headerView, AllTest10Model *model) {
        model.isGiveLike = !model.isGiveLike;
        if (model.isGiveLike) {
            [model.giveLikeNames addObject:@"乐天"];
        } else {
            [model.giveLikeNames removeObject:@"乐天"];
        }
        [weakSelf.tableView reloadData];
    };
    headerView.commentsClickHandler = ^(AllTest10HeaderView *headerView, AllTest10Model *model) {
        [model.comments addObject:[AllTest10Model randTestComments]];
        [weakSelf.tableView reloadData];
    };
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MyBaseLayout *footerView = [[MyBaseLayout alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    footerView.backgroundColor = [UIColor whiteColor];
    MyBorderline  *bld = [[MyBorderline alloc] initWithColor:[UIColor colorWithRed:216.0/255 green:214.0/255 blue:216.0/255 alpha:1]];
    footerView.bottomBorderline = bld;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AllTest10Model *model = self.cellDatas[section];
    return model.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllTest10Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllTest10Cell"];
    AllTest10Model *model = self.cellDatas[indexPath.section];
    cell.selectionStyle = 0;
    [cell setCommentsText:model.comments[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除此条信息" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AllTest10Model *model = weakSelf.cellDatas[indexPath.section];
        [model.comments removeObjectAtIndex:indexPath.row];
        [UIView performWithoutAnimation:^{
            [weakSelf.tableView reloadData];
        }];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSMutableArray *)cellDatas {
    if (!_cellDatas) {
        _cellDatas = [NSMutableArray array];
    }
    return _cellDatas;
}

@end

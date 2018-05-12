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
    MyFrameLayout *rootLayout = [[MyFrameLayout alloc] init];
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
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
    self.tableView.myMargin = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.0001;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 100;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 10);
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerClass:[AllTest10Cell class] forCellReuseIdentifier:@"AllTest10Cell"];
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
    footerView.myHorzMargin = MyLayoutPos.safeAreaMargin;
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

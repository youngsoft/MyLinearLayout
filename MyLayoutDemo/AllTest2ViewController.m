//
//  AllTest2ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "AllTest2ViewController.h"
#import "AllTestDataModel.h"
#import "AllTest2TableViewCell.h"

#import "MyLayout.h"


@interface AllTest2ViewController ()


@property(nonatomic, strong) NSMutableArray *datas;      //数据模型数组




@end

@implementation AllTest2ViewController


-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        
        NSArray *headImages = @[@"head1",
                                @"head2",
                                @"minions1",
                                @"minions4"
                                ];
        
        NSArray *names = @[@"欧阳大哥",
                           @"醉里挑灯看键",
                           @"张三",
                           @"尼古拉・阿列克赛耶维奇・奥斯特洛夫斯基"
                           ];
        
        NSArray *descs = @[@"只有一行文本",
                           @"这个例子是用于测试自动布局在UITableView中实现静态高度的解决方案。",
                           @"通过布局视图的estimateLayoutRect函数能够评估出UITableViewCell的动态高度",
                           @"这是一段既有文本也有图片，文本在上面，图片在下面"
                           ];
        
        
        NSArray *prices = @[@"1235.34",
                            @"0",
                            @"34246466.32",
                            @"100"
                            ];
        
        
        
        for (int i = 0; i < 50; i++)
        {
            AllTest2DataModel *model = [AllTest2DataModel new];
            
            model.headImage    =  headImages[arc4random_uniform((uint32_t)headImages.count)];
            model.name     =  names[arc4random_uniform((uint32_t)names.count)];
            model.desc  =  descs[arc4random_uniform((uint32_t)descs.count)];
            model.price =  prices[arc4random_uniform((uint32_t)prices.count)];
            
            [_datas addObject:model];
        }
        
    }
    
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -- Layout Construction


#pragma mark -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllTest2TableViewCell *cell = (AllTest2TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"alltest2_cell"];
    if (cell == nil)
        cell = [[AllTest2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alltest2_cell"];
    
    AllTest2DataModel *model = [self.datas objectAtIndex:indexPath.row];
    [cell setModel:model];
    
    return cell;
}



#pragma mark -- UITableVewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- Handle Method

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

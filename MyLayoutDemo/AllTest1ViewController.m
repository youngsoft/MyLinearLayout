//
//  AllTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "AllTest1ViewController.h"
#import "AllTestDataModel.h"
#import "AllTest1TableViewCell.h"
#import "AllTest1TableViewHeaderFooterView.h"

#import "MyLayout.h"
#import "YYFPSLabel.h"
#import "CFTool.h"

@interface AllTest1ViewController ()


@property(nonatomic, strong) NSMutableArray *datas;             //数据模型数组
@property(nonatomic, strong) NSMutableArray *imageHiddenFlags;  //动态数据记录图片是否被隐藏的标志数组。




@end

@implementation AllTest1ViewController


-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        _imageHiddenFlags = [NSMutableArray new];
        
        NSArray *headImages = @[@"head1",
                                @"head2",
                                @"minions1",
                                @"minions4"
                                ];
        
        NSArray *nickNames = @[@"欧阳大哥",
                               @"醉里挑灯看键",
                               @"张三",
                               @"李四"
                               ];
        
        NSArray *textMessages = @[@"",
                                  NSLocalizedString(@"a single line text", @""),
                                  NSLocalizedString(@"This Demo is used to introduce the solution when use layout view to realize the UITableViewCell's dynamic height. We only need to use the layout view's estimateLayoutRect method to evaluate the size of the layout view. and you can touch the Cell to shrink the height when the Cell has a picture.", @""),
                                  NSLocalizedString(@"Through layout view's estimateLayoutRect method can assess a UITableViewCell dynamic height.EstimateLayoutRect just to evaluate layout size but not set the size of the layout. here don't preach the width of 0 is the cause of the above UITableViewCell set the default width is 320 (regardless of any screen), so if we pass the width of 0 will be according to the width of 320 to evaluate UITableViewCell dynamic height, so when in 375 and 375 the width of the assessment of height will not be right, so here you need to specify the real width dimension;And the height is set to 0 mean height is not a fixed value need to evaluate. you can use all type layout view to realize UITableViewCell.", @""),
                                  NSLocalizedString(@"This section not only has text but also hav picture. and picture below at text, text will wrap", @"")
                                  ];
        
        NSArray *imageMessages = @[@"",
                                   @"bk3",
                                   @"image1",
                                   @"image2"
                                   ];
        
        for (int i = 0; i < 30; i++)
        {
            AllTest1DataModel *model = [AllTest1DataModel new];
            
            model.headImage    =  headImages[arc4random_uniform((uint32_t)headImages.count)];
            model.nickName     =  nickNames[arc4random_uniform((uint32_t)nickNames.count)];
            model.textMessage  =  textMessages[arc4random_uniform((uint32_t)textMessages.count)];
            model.imageMessage =  imageMessages[arc4random_uniform((uint32_t)imageMessages.count)];
            
            [_datas addObject:model];
            [_imageHiddenFlags addObject:@(NO)];
        }

    }
    
    return _datas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // 注意这里。为了达到动态高度UITableviewCell的加载性能最高以及高性能，一定要设置estimatedRowHeight这个属性。这个属性用来评估
    //UITableViewCell的高度。如果实现了这个方法，系统会根据数量重复调用这个方法，得出评估的总体高度。然后再根据显示的需要调用-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath方法来确定真实的高度。如果您不设置estimatedRowHeight，加载性能将非常的低下！！！！
    //如果不同的cell有差异那么可以通过实现协议方法-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath来定制化
    self.tableView.estimatedRowHeight = 60;
    
    //设置所有cell的高度为高度自适应，如果cell高度是动态的请这么设置。 如果不同的cell有差异那么可以通过实现协议方法-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    //如果您最低要支持到iOS7那么请您实现-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath方法来代替这个属性的设置。
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.tableView registerClass:[AllTest1TableViewCell class] forCellReuseIdentifier:@"alltest1_cell"];
    
    
    
    /**
        布局视图和UITableView的结合可以很简单的实现静态和动态高度的tableviewcell。以及tableview的section,tableheaderfooter部分使用布局视图的方法
     */

    
    /*
       将一个布局视图作为uitableview的tableHeaderViewLayout时，因为其父视图是非布局视图，因此需要明确的指明宽度和高度。这个可以用frame来设置。比如：
     
     tableHeaderViewLayout.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 100);
     
      而如果某个布局视图的高度有可能是动态的高度，也就是用了wrapContentHeight为YES时，可以不用指定明确的指定高度，但要指定宽度。而且在布局视图添加到self.tableView.tableHeaderView 之前一定要记得调用：
            [tableHeaderViewLayout layoutIfNeeded]
     
     */
    
    [self createTableHeaderView];
    [self createTableFooterView];
   
   //经测试发现如果你没有指定footerview时，如果使用动态高度，而且又实现了estimatedHeightForRowAtIndexPath方法来评估高度，那么有可能在操作某些cell时
    //会出现cell高度变化时(本例子是隐藏显示图片)会闪动，解决问题的方法就是建立一个0高度的tableFooterView，也就是上下面的方法。
    //您可以把：    [self createTableFooterView]; 注释掉，然后把下面这句解注释看看效果。
   // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -- Layout Construction

-(void)createTableHeaderView
{
    //这个例子用来构建一个动态高度的头部布局视图。
    MyLinearLayout *tableHeaderViewLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    tableHeaderViewLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    tableHeaderViewLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0); //高度不确定可以设置为0。但是宽度一定要写明确的值。尽量不要在代码中使用kScreenWidth,kScreenHeight，SCREEN_WIDTH。之类这样的宏来设定视图的宽度和高度。要充分利用MyLayout的特性，减少常数的使用。
    tableHeaderViewLayout.myHorzMargin = 0; //这里注意设置宽度和父布局保持一致。
    tableHeaderViewLayout.backgroundImage = [UIImage imageNamed:@"bk1"];
    [tableHeaderViewLayout setTarget:self action:@selector(handleTableHeaderViewLayoutClick:)];
    
    UILabel *label1 = [UILabel new];
    label1.text = NSLocalizedString(@"add tableHeaderView(please touch me)", @"");
    label1.tag = 1000;
    label1.textColor = [CFTool color:0];
    label1.font = [CFTool font:17];
    label1.myCenterX = 0;
    [label1 sizeToFit];
    [tableHeaderViewLayout addSubview:label1];
    
    
    
    UILabel *label2 = [UILabel new];
    label2.text = NSLocalizedString(@" if you use layout view to realize the dynamic height tableHeaderView, please use frame to set view's width and use wrapContentHeight to set view's height. the layoutIfNeeded method is needed to call before the layout view assignment to the UITableview's tableHeaderView.", @"");
    label2.textColor = [CFTool color:4];
    label2.font = [CFTool font:15];
    label2.myHorzMargin = 5;
    label2.wrapContentHeight = YES;
    label2.myTop = 10;
    [label2 sizeToFit];
    [tableHeaderViewLayout addSubview:label2];
    
    
    [tableHeaderViewLayout layoutIfNeeded];    //因为高度是wrap的，所以这里必须要在加入前执行这句！！！ 原因是tableHeaderView必须要明确的指定frame。所以通过layoutIfNeeded来算出真实视图真实的frame值。因为tableHeaderViewLayout这时候并没有父视图，所以这里必须要明确的通过frame指定宽度，这样最终的计算结果才正确。
    self.tableView.tableHeaderView = tableHeaderViewLayout;
    
    
    //因为tableHeaderViewLayout的高度是通过layoutIfNeed来确定的。因此在屏幕旋转时我们需要手动再次调整tableHeaderViewLayout的frame值。
    //因此您需要实现这个block来实现当布局视图在横竖屏切换时的frame的动态更新。。。
    //注意这个block不会只执行一次，而是长期存在，因此要注意block内对象的引用的问题。
    __weak UITableView *weakTableview = self.tableView;
    tableHeaderViewLayout.rotationToDeviceOrientationBlock = ^(MyBaseLayout *layout, BOOL isFirst, BOOL isPortrait)
    {
        if (!isFirst)
        {
            [weakTableview.tableHeaderView layoutIfNeeded];
            weakTableview.tableHeaderView = weakTableview.tableHeaderView;
        }
    };

}


-(void)createTableFooterView
{
    //这个例子用来构建一个固定高度的尾部布局视图。
    MyLinearLayout *tableFooterViewLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    tableFooterViewLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    tableFooterViewLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 80); //这里明确设定高度。
    tableFooterViewLayout.myHorzMargin = 0; //这里注意设置宽度和父布局保持一致。
    tableFooterViewLayout.backgroundColor = [CFTool color:6];
    tableFooterViewLayout.gravity = MyGravity_Vert_Center | MyGravity_Horz_Fill;
    
    UILabel *label3 = [UILabel new];
    label3.text = NSLocalizedString(@"add tableFooterView", @"");
    label3.textColor = [CFTool color:4];
    label3.font = [CFTool font:16];
    label3.textAlignment = NSTextAlignmentCenter;
    [label3 sizeToFit];
    [tableFooterViewLayout addSubview:label3];
    
    UILabel *label4 = [UILabel new];
    label4.text = NSLocalizedString(@"the layoutIfNeeded is not need to call when you use frame to set layout view's size", @"");
    label4.textAlignment = NSTextAlignmentCenter;
    label4.textColor = [CFTool color:3];
    label4.font = [CFTool font:14];
    label4.myTop = 10;
    label4.adjustsFontSizeToFitWidth = YES;
    [label4 sizeToFit];
    [tableFooterViewLayout addSubview:label4];
    self.tableView.tableFooterView = tableFooterViewLayout;  //这里因为明确的设置了视图的frame值，因此不需要调用layoutIfNeeded来计算尺寸了。
    

}

#pragma mark -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    AllTest1TableViewCell *cell;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8)
    {
     //如果您的系统要求最低支持到iOS7那么需要通过-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 来评估高度，因此请不要使用- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath 这个方法来初始化UITableviewCell，否则可能造成系统崩溃！！！
        cell = (AllTest1TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"alltest1_cell"];
    }
    else
    {
        //如果你最低支持到iOS8那么请用这个方法来初始化一个UITableviewCell,用这个方法要记得调用registerClass来注册UITableviewCell，否则可能会返回nil
        cell = (AllTest1TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"alltest1_cell" forIndexPath:indexPath];
    }
    
        
    AllTest1DataModel *model = [self.datas objectAtIndex:indexPath.row];
    BOOL isImageMessageHidden = [[self.imageHiddenFlags objectAtIndex:indexPath.row] boolValue];
    [cell setModel:model isImageMessageHidden:isImageMessageHidden];
    
    //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
    if (indexPath.row  == self.datas.count - 1)
    {
        cell.rootLayout.bottomBorderline = nil;
    }
    else
    {
        MyBorderline  *bld = [[MyBorderline alloc] initWithColor:[UIColor redColor]];
        cell.rootLayout.bottomBorderline = bld;
    }
    
    return cell;
}



#pragma mark -- UITableVewDelegate


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AllTest1TableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerfooterview"];
    if (headerFooterView == nil)
        headerFooterView = [[AllTest1TableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerfooterview"];
    
    
    [headerFooterView setItemChangedAction:^(NSInteger index){
    
        NSString *message = [NSString stringWithFormat:@"You have select index:%ld",(long)index];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    
    }];

    return headerFooterView;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  44;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果您的系统最低支持到iOS7那么需要实现这个方法来算出每个UITableviewCell的动态高度。如果最低支持到iOS8那么您可以直接返回UITableViewAutomaticDimension，或者不实现这个方法而通过设置UITableView的rowHeight为UITableViewAutomaticDimension就可以了。
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8)
    {
        //这里注意一下：不是调用tableview的cellForRowAtIndexPath方法！！！！，而是调用的UITableviewDataSource的方法。
        AllTest1TableViewCell *cell = (AllTest1TableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        //通过布局视图的sizeThatFits函数能够评估出UITableViewCell的动态高度。sizeThatFits并不会进行布局
        //而只是评估布局的尺寸，这里的宽度不传0的原因是上面的UITableViewCell在建立时默认的宽度是320(不管任何尺寸都如此),因此如果我们
        //传递了宽度为0的话则会按320的宽度来评估UITableViewCell的动态高度，这样当在375和414的宽度时评估出来的高度将不会正确，因此这里需要
        //指定出真实的宽度尺寸；而高度设置为0的意思是表示高度不是固定值需要评估出来。
        CGSize size = [cell.rootLayout sizeThatFits:CGSizeMake(tableView.frame.size.width, 0)];
        return size.height;  //如果使用系统自带的分割线，请返回size.height+1
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.imageHiddenFlags[indexPath.row] = @(![self.imageHiddenFlags[indexPath.row] boolValue]);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -- Handle Method

-(void)handleTableHeaderViewLayoutClick:(MyBaseLayout*)sender
{
    UILabel *label1 = [sender viewWithTag:1000];
    if (label1.myVisibility == MyVisibility_Visible)
        label1.myVisibility = MyVisibility_Gone;
    else
        label1.myVisibility = MyVisibility_Visible;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //因为tableHeaderView的特殊情况。如果需要调整tableHeaderView的高度时需要编写如下代码！！！！！
        [self.tableView.tableHeaderView layoutIfNeeded];
        self.tableView.tableHeaderView = self.tableView.tableHeaderView;
        
    }];
  
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

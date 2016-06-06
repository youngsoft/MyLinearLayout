//
//  Test9ViewController.m
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
                                  @"只有一行文本",
                                  @"这个例子是用于测试自动布局在UITableView中实现动态高度的解决方案，我们只需要使用布局视图的estimateLayoutRect就可以对布局的尺寸进行评估,您也可以在有图片的Cell中触摸查看自动伸缩的情况",
                                  @"通过布局视图的estimateLayoutRect函数能够评估出UITableViewCell的动态高度。estimateLayoutRect并不会进行布局而只是评估布局的尺寸，这里的宽度不传0的原因是上面的UITableViewCell在建立时默认的宽度是320(不管任何尺寸都如此),因此如果我们传递了宽度为0的话则会按320的宽度来评估UITableViewCell的动态高度，这样当在375和414的宽度时评估出来的高度将不会正确，因此这里需要指定出真实的宽度尺寸；而高度设置为0的意思是表示高度不是固定值需要评估出来。UITableViewCell的动态高度评估不局限于线性布局，相对布局也是同样适用的。",
                                  @"这是一段既有文本也有图片，文本在上面，图片在下面。文本会自动的进行换行，而图片则在文本下面居中显示",
                                  @"这个布局的DEMO可以分别用线性布局、相对布局、浮动布局来实现。其中的线性布局需要进行布局的嵌套，而相对布局则需要通过设置视图之间的依赖来实现，而浮动布局则会自动根据内容进行对应的浮动来进行自适应的布局，因此浮动布局这里的实现比较强大。"
                                  ];
        
        NSArray *imageMessages = @[@"",
                                   @"image1",
                                   @"image2",
                                   @"image3"
                                   ];
        
        for (int i = 0; i < 100; i++)
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    MyLinearLayout *tableHeaderViewLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    tableHeaderViewLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    tableHeaderViewLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 0); //高度不确定可以设置为0。尽量不要在代码中使用kScreenWidth,kScreenHeight，SCREEN_WIDTH。之类这样的宏来设定视图的宽度和高度。要充分利用MyLayout的特性，减少常数的使用。
    tableHeaderViewLayout.myLeftMargin = tableHeaderViewLayout.myRightMargin = 0; //这里注意设置宽度和父布局保持一致。
    tableHeaderViewLayout.backgroundImage = [UIImage imageNamed:@"bk1"];
    [tableHeaderViewLayout setTarget:self action:@selector(handleTableHeaderViewLayoutClick:)];
    
    UILabel *label1 = [UILabel new];
    label1.text = @"设置tableHeaderView(点我试试)";
    label1.tag = 1000;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:17];
    label1.myCenterXOffset = 0;
    [label1 sizeToFit];
    [tableHeaderViewLayout addSubview:label1];
    
    
    UILabel *label2 = [UILabel new];
    label2.text = @"  设置具有动态高度的tableHeaderView的时候需要用frame指定明确的宽度，高度则可以设置wrapContentHeight为YES，并且在赋值给tableView之前要调用layoutIfNeeded方法来明确高度。";
    label2.textColor = [UIColor redColor];
    label2.myLeftMargin = label2.myRightMargin = 5;
    label2.numberOfLines = 0;
    label2.flexedHeight = YES;
    label2.myTopMargin = 10;
    [label2 sizeToFit];
    [tableHeaderViewLayout addSubview:label2];
    
    
    [tableHeaderViewLayout layoutIfNeeded];    //这里必须要在加入前执行这句！！！
    self.tableView.tableHeaderView = tableHeaderViewLayout;

    
}

-(void)createTableFooterView
{
    //这个例子用来构建一个固定高度的尾部布局视图。
    MyLinearLayout *tableFooterViewLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    tableFooterViewLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    tableFooterViewLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 80); //这里明确设定高度。
    tableFooterViewLayout.myLeftMargin = tableFooterViewLayout.myRightMargin = 0; //这里注意设置宽度和父布局保持一致。
    tableFooterViewLayout.backgroundColor = [UIColor magentaColor];
    tableFooterViewLayout.gravity = MyMarginGravity_Vert_Center | MyMarginGravity_Horz_Fill;
    
    UILabel *label3 = [UILabel new];
    label3.text = @"设置tableFooterView";
    label3.textAlignment = NSTextAlignmentCenter;
    [label3 sizeToFit];
    [tableFooterViewLayout addSubview:label3];
    
    UILabel *label4 = [UILabel new];
    label4.text = @"如果通过frame设置了明确的尺寸则不需要调用layoutIfNeeded";
    label4.textAlignment = NSTextAlignmentCenter;
    label4.myTopMargin = 10;
    label4.adjustsFontSizeToFitWidth = YES;
    [label4 sizeToFit];
    [tableFooterViewLayout addSubview:label4];
    self.tableView.tableFooterView = tableFooterViewLayout;  //这里尺寸固定因此不需要调用layoutIfNeeded
    

}

#pragma mark -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllTest1TableViewCell *cell = (AllTest1TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"alltest1_cell"];
    if (cell == nil)
        cell = [[AllTest1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alltest1_cell"];
    
    AllTest1DataModel *model = [self.datas objectAtIndex:indexPath.row];
    BOOL isImageMessageHidden = [[self.imageHiddenFlags objectAtIndex:indexPath.row] boolValue];
    [cell setModel:model isImageMessageHidden:isImageMessageHidden];
    
    //这里最后一行没有下划线
    if (indexPath.row  == self.datas.count - 1)
    {
        cell.rootLayout.bottomBorderLine = nil;
    }
    else
    {
        MyBorderLineDraw  *bld = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]];
        cell.rootLayout.bottomBorderLine = bld;
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
    
        NSString *message = [NSString stringWithFormat:@"section:%ld, index:%ld", (long)section, (long)index];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    
    }];

    return headerFooterView;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  44;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // 注意这里。为了达到动态高度TableViewCell的加载性能最高以及高性能，一定要实现estimatedHeightForRowAtIndexPath这个方法。这个方法用来评估
    //UITableViewCell的高度。如果实现了这个方法，系统会根据数量重复调用这个方法，得出评估的总体高度。然后再根据显示的需要调用heightForRowAtIndexPath方法来确定真实的高度。如果您不实现estimatedHeightForRowAtIndexPath这个方法，加载性能将非常的低下！！！！
    return 40;  //这个评估尺寸你可以根据你的cell的一般高度来设置一个最合适的值。
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AllTest1TableViewCell *cell = (AllTest1TableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];

    //通过布局视图的estimateLayoutRect函数能够评估出UITableViewCell的动态高度。estimateLayoutRect并不会进行布局
    //而只是评估布局的尺寸，这里的宽度不传0的原因是上面的UITableViewCell在建立时默认的宽度是320(不管任何尺寸都如此),因此如果我们
    //传递了宽度为0的话则会按320的宽度来评估UITableViewCell的动态高度，这样当在375和414的宽度时评估出来的高度将不会正确，因此这里需要
    //指定出真实的宽度尺寸；而高度设置为0的意思是表示高度不是固定值需要评估出来。
    //UITableViewCell的动态高度评估不局限于线性布局，相对布局也是同样适用的。
    CGRect rect = [cell.rootLayout estimateLayoutRect:CGSizeMake(tableView.frame.size.width, 0)];
    return rect.size.height;  //如果使用系统自带的分割线，请返回rect.size.height+1
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
    label1.hidden = !label1.isHidden;
    
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

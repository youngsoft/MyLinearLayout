//
//  Test9ViewController.m
//  MyLayout
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "AllTest1ViewController.h"
#import "MyLayout.h"


@interface DialogInfo : NSObject

@property(nonatomic,strong) NSString *headImage; //头像
@property(nonatomic, strong) NSString *nickName; //昵称
@property(nonatomic, strong) NSString *textMessage; //文本消息，如果为空则是图片消息
@property(nonatomic, strong) NSString *imageMessage; //图片消息
@property(nonatomic,assign) BOOL isHidden;

@end

@implementation DialogInfo


@end


@interface AllTest1ViewController ()


//DialogInfo 对象数组
@property(nonatomic, strong) NSArray *dialogs;


@end

@implementation AllTest1ViewController


-(id)init
{
    self = [super init];
    if (self != nil)
    {
        NSMutableArray *arr = [NSMutableArray new];
        
        DialogInfo *info = [DialogInfo new];
        info.headImage = @"head1";
        info.nickName = @"欧阳大哥";
        info.textMessage = @"这个例子是用于测试自动布局在UITableView中实现动态高度的解决方案，我们只需要使用布局视图的estimateLayoutRect就可以对布局的尺寸进行评估,您也可以在有图片的Cell中触摸查看自动伸缩的情况";
        
        [arr addObject:info];
        
        info = [DialogInfo new];
        info.headImage = @"head2";
        info.nickName = @"醉里挑灯看键";
        info.textMessage = @"只有一行文本";
        
        [arr addObject:info];
        
        
        info = [DialogInfo new];
        info.headImage = @"head1";
        info.nickName = @"欧阳大哥";
        info.textMessage = @"";
        info.imageMessage = @"image1";
        
        [arr addObject:info];
        
        info = [DialogInfo new];
        info.headImage = @"head1";
        info.nickName = @"欧阳大哥";
        info.textMessage = @"通过布局视图的estimateLayoutRect函数能够评估出UITableViewCell的动态高度。estimateLayoutRect并不会进行布局而只是评估布局的尺寸，这里的宽度不传0的原因是上面的UITableViewCell在建立时默认的宽度是320(不管任何尺寸都如此),因此如果我们传递了宽度为0的话则会按320的宽度来评估UITableViewCell的动态高度，这样当在375和414的宽度时评估出来的高度将不会正确，因此这里需要指定出真实的宽度尺寸；而高度设置为0的意思是表示高度不是固定值需要评估出来。UITableViewCell的动态高度评估不局限于线性布局，相对布局也是同样适用的。";
        
        [arr addObject:info];
        
        
        info = [DialogInfo new];
        info.headImage = @"head2";
        info.nickName = @"醉里挑灯看键";
        info.textMessage = @"";
        info.imageMessage = @"image2";
        
        [arr addObject:info];
        
        
        info = [DialogInfo new];
        info.headImage = @"head1";
        info.nickName = @"醉里挑灯看键";
        info.textMessage = @"这是一段既有文本也有图片，文本在上面，图片在下面。文本会自动的进行换行，而图片则在文本下面居中显示";
        info.imageMessage = @"image3";
        
        [arr addObject:info];
        
        
        info = [DialogInfo new];
        info.headImage = @"head2";
        info.nickName = @"欧阳大哥";
        info.textMessage = @"这个布局的DEMO可以分别用线性布局、相对布局、浮动布局来实现。其中的线性布局需要进行布局的嵌套，而相对布局则需要通过设置视图之间的依赖来实现，而浮动布局则会自动根据内容进行对应的浮动来进行自适应的布局，因此浮动布局这里的实现比较强大。";
        info.imageMessage = @"image2";
        
        [arr addObject:info];
        
        
        
        self.dialogs = arr;
        
        
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UITableViewCell动态高度";
    
    //添加tableHeaderView
    MyLinearLayout *headerViewLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    headerViewLayout.backgroundColor = [UIColor grayColor];
    headerViewLayout.frame = CGRectMake(0, 0, 0, 100);
    headerViewLayout.gravity = MyMarginGravity_Center;
    
    UILabel *label1 = [UILabel new];
    label1.text = @"设置tableHeaderView";
    label1.myCenterXOffset = 0;
    [label1 sizeToFit];
    [headerViewLayout addSubview:label1];
    
    UILabel *label2 = [UILabel new];
    label2.text = @"可以直接设置frame值来指定高度";
    label2.myCenterXOffset = 0;
    label2.myTopMargin = 10;
    [label2 sizeToFit];
    [headerViewLayout addSubview:label2];
    
    self.tableView.tableHeaderView = headerViewLayout;
    
    
    MyLinearLayout *bottomViewLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    bottomViewLayout.backgroundColor = [UIColor grayColor];
    
    UILabel *label3 = [UILabel new];
    label3.text = @"设置tableFooterView";
    label3.myCenterXOffset = 0;
    [label3 sizeToFit];
    [bottomViewLayout addSubview:label3];
    
    UILabel *label4 = [UILabel new];
    label4.text = @"如果不用frame则需要调用layoutIfNeeded";
    label4.myCenterXOffset = 0;
    label4.myTopMargin = 10;
    [label4 sizeToFit];
    [bottomViewLayout addSubview:label4];
    
    [bottomViewLayout layoutIfNeeded];
    self.tableView.tableFooterView = bottomViewLayout;
    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dialog_cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dialog_cell"];
    
        
        //您可以用相对布局来实现，下面用的是相对布局来实现。
        MyRelativeLayout *dialogLayout = [MyRelativeLayout new];
        dialogLayout.tag = 50;
        [dialogLayout setTarget:self action:@selector(handleTest:)];
        
        
        dialogLayout.widthDime.equalTo(cell.contentView.widthDime);
        dialogLayout.wrapContentHeight = YES;
        [cell.contentView addSubview:dialogLayout];
        
        
        UIImageView *headImageView = [UIImageView new];
        headImageView.tag = 100;
        [dialogLayout addSubview:headImageView];
        
        
        UILabel *nickNameLabel = [UILabel new];
        nickNameLabel.tag = 200;
        nickNameLabel.textColor = [UIColor blueColor];
        nickNameLabel.font = [UIFont systemFontOfSize:15];
        
        nickNameLabel.leftPos.equalTo(headImageView.rightPos).offset(5);
        [dialogLayout addSubview:nickNameLabel];
        
        
        UILabel *textMessageLabel = [UILabel new];
        textMessageLabel.tag = 300;
        textMessageLabel.font = [UIFont systemFontOfSize:13];
        
        textMessageLabel.flexedHeight = YES;
        textMessageLabel.numberOfLines = 0;
        textMessageLabel.leftPos.equalTo(headImageView.rightPos).offset(5);
        textMessageLabel.rightPos.equalTo(dialogLayout.rightPos);
        textMessageLabel.topPos.equalTo(nickNameLabel.bottomPos).offset(5);
        [dialogLayout addSubview:textMessageLabel];
        
        
        UIImageView *imageMessageView = [UIImageView new];
        imageMessageView.tag = 400;
        
        imageMessageView.centerXPos.equalTo(@5);
        imageMessageView.topPos.equalTo(textMessageLabel.bottomPos).offset(5);
        [dialogLayout addSubview:imageMessageView];
        /*
         
         //您也可以用线性布局来实现，下面用的是线性布局来实现。线性布局需要比相对布局多增加一个布局层
         MyLinearLayout *dialogLayout= [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
         dialogLayout.tag = 50;
         [dialogLayout setTarget:self action:@selector(handleTest:)];
         
         
         
         dialogLayout.myLeftMargin = 0;
         dialogLayout.myRightMargin = 0;
         dialogLayout.wrapContentHeight = YES;
         [cell.contentView addSubview:dialogLayout];
         
         
         UIImageView *headImageView = [UIImageView new];
         headImageView.tag = 100;
         [dialogLayout addSubview:headImageView];
         
         
         MyLinearLayout *messageLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
         
         messageLayout.weight = 1;
         messageLayout.myLeftMargin = 5;
         [dialogLayout addSubview:messageLayout];
         
         
         UILabel *nickNameLabel = [UILabel new];
         nickNameLabel.tag = 200;
         nickNameLabel.textColor = [UIColor blueColor];
         nickNameLabel.font = [UIFont systemFontOfSize:15];
         
         nickNameLabel.myBottomMargin = 5;
         [messageLayout addSubview:nickNameLabel];
         
         
         UILabel *textMessageLabel = [UILabel new];
         textMessageLabel.tag = 300;
         textMessageLabel.font = [UIFont systemFontOfSize:13];
         
         textMessageLabel.myLeftMargin = 0;
         textMessageLabel.myRightMargin = 0;
         textMessageLabel.flexedHeight = YES;
         textMessageLabel.numberOfLines = 0;
         [messageLayout addSubview:textMessageLabel];
         
         
         UIImageView *imageMessageView = [UIImageView new];
         imageMessageView.tag = 400;
         
         imageMessageView.myCenterXOffset = 0;
         imageMessageView.myTopMargin = 5;
         [messageLayout addSubview:imageMessageView];
         */
        
        
        // 您也可以用浮动布局,浮动布局的代码最少。因为会自动根据内容和浮动设置进行排版布局，也不需要去设置视图之间的约束，也不需要进行布局视图的嵌套。
      /*  MyFloatLayout *dialogLayout= [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
        dialogLayout.tag = 50;
        [dialogLayout setTarget:self action:@selector(handleTest:)];
        
        dialogLayout.myLeftMargin = 0;
        dialogLayout.myRightMargin = 0;
        dialogLayout.wrapContentHeight = YES;
        [cell.contentView addSubview:dialogLayout];
        
        //第一个子视图浮动到最左边。
        UIImageView *headImageView = [UIImageView new];
        headImageView.tag = 100;
        headImageView.myRightMargin = 5;
        [dialogLayout addSubview:headImageView];
        
        //第二个子视图紧跟在第一个子视图后面，并且通过设置weight来占据剩余的宽度
        UILabel *nickNameLabel = [UILabel new];
        nickNameLabel.tag = 200;
        nickNameLabel.textColor = [UIColor blueColor];
        nickNameLabel.font = [UIFont systemFontOfSize:15];
        
        nickNameLabel.myBottomMargin = 5;
        nickNameLabel.weight = 1;
        [dialogLayout addSubview:nickNameLabel];
        
        //第三个子视图也是紧跟在第一个子视图后面，并且通过设置weight来占据剩余的宽度
        UILabel *textMessageLabel = [UILabel new];
        textMessageLabel.tag = 300;
        textMessageLabel.font = [UIFont systemFontOfSize:13];
        textMessageLabel.weight = 1;
        textMessageLabel.flexedHeight = YES;
        textMessageLabel.numberOfLines = 0;
        [dialogLayout addSubview:textMessageLabel];
        
        //第四个子视图占据整个宽度
        UIImageView *imageMessageView = [UIImageView new];
        imageMessageView.tag = 400;
        
        imageMessageView.myTopMargin = 5;
        imageMessageView.reverseFloat = YES;
        imageMessageView.weight = 1;
        imageMessageView.contentMode = UIViewContentModeCenter;
        [dialogLayout addSubview:imageMessageView];
      */
    
    }
    
    //这里最后一行没有下划线
    MyBaseLayout *dialogLayout = (MyBaseLayout*)[cell viewWithTag:50];
    if (indexPath.row  == self.dialogs.count - 1)
        dialogLayout.bottomBorderLine = nil;
    else
    {
        MyBorderLineDraw  *bld = [[MyBorderLineDraw alloc] initWithColor:[UIColor redColor]];
        dialogLayout.bottomBorderLine = bld;
    }
    
    
    UIImageView *headImageView = (UIImageView*)[cell viewWithTag:100];
    UILabel *nickNameLabel = (UILabel*)[cell viewWithTag:200];
    UILabel *textMessageLabel = (UILabel*)[cell viewWithTag:300];
    UIImageView *imageMessageView = (UIImageView*)[cell viewWithTag:400];
    
    
    DialogInfo *dialogInfo = [self.dialogs objectAtIndex:indexPath.row];
    
    headImageView.image = [UIImage imageNamed:dialogInfo.headImage];
    [headImageView sizeToFit];
    
    
    nickNameLabel.text = dialogInfo.nickName;
    [nickNameLabel sizeToFit];
    
    textMessageLabel.text = dialogInfo.textMessage;
    
    imageMessageView.hidden = (dialogInfo.imageMessage.length == 0);
    if (dialogInfo.imageMessage.length != 0)
    {
        imageMessageView.image = [UIImage imageNamed:dialogInfo.imageMessage];
        [imageMessageView sizeToFit];
        
        //通过银行实现高度的变化
        if (dialogInfo.isHidden == YES)
            imageMessageView.hidden = YES;
    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dialogs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    MyBaseLayout *dialogLayout = (MyBaseLayout*)[cell viewWithTag:50];
    
    //通过布局视图的estimateLayoutRect函数能够评估出UITableViewCell的动态高度。estimateLayoutRect并不会进行布局
    //而只是评估布局的尺寸，这里的宽度不传0的原因是上面的UITableViewCell在建立时默认的宽度是320(不管任何尺寸都如此),因此如果我们
    //传递了宽度为0的话则会按320的宽度来评估UITableViewCell的动态高度，这样当在375和414的宽度时评估出来的高度将不会正确，因此这里需要
    //指定出真实的宽度尺寸；而高度设置为0的意思是表示高度不是固定值需要评估出来。
    //UITableViewCell的动态高度评估不局限于线性布局，相对布局也是同样适用的。
    CGRect rect = [dialogLayout estimateLayoutRect:CGSizeMake(tableView.frame.size.width, 0)];
    //  NSLog(@"rect.height:%g", rect.size.height);
    
    return rect.size.height;  //如果使用系统自带的分割线，请返回rect.size.height+1
}

-(void)handleTest:(MyBaseLayout*)sender
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[self.tableView convertPoint:sender.center fromView:sender]];
    DialogInfo *dialogInfo = [self.dialogs objectAtIndex:indexPath.row];
    dialogInfo.isHidden = !dialogInfo.isHidden;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
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

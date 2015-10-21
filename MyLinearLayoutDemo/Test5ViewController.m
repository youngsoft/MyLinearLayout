//
//  Test5ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test5ViewController.h"
#import "MyLayout.h"


@interface DialogInfo : NSObject

@property(nonatomic,strong) NSString *headImage; //头像
@property(nonatomic, strong) NSString *nickName; //昵称
@property(nonatomic, strong) NSString *textMessage; //文本消息，如果为空则是图片消息
@property(nonatomic, strong) NSString *imageMessage; //图片消息

@end

@implementation DialogInfo


@end


@interface Test5ViewController ()


//DialogInfo 对象数组
@property(nonatomic, strong) NSArray *dialogs;


@end

@implementation Test5ViewController


-(id)init
{
    self = [super init];
    if (self != nil)
    {
        NSMutableArray *arr = [NSMutableArray new];
        
        DialogInfo *info = [DialogInfo new];
        info.headImage = @"head1";
        info.nickName = @"欧阳大哥";
        info.textMessage = @"这个例子是用于测试自动布局在UITableView中实现动态高度的解决方案，我们只需要使用布局视图的estimateLayoutRect就可以对布局的尺寸进行评估";
        
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
        info.textMessage = @"通过布局视图的estimateLayoutRect函数能够评估出UITableViewCell的动态高度。estimateLayoutRect并不会进行布局而只是评估布局的尺寸，这里的宽度不传0的原因是上面的UITableViewCell在建立时默认的宽度是320(不管任何尺寸都如此),因此如果我们传递了宽度为0的话则会按320的宽度来评估UITableViewCell的动态高度，这样当在375和414的宽度时评估出来的高度将不会正确，因此这里需要指定出真实的宽度尺寸；而高度设置为0的意思是表示高度不是固定值需要评估出来。UITableViewCell的动态高度评估不局限于线性布局，相对布局也是同样适用的。";
        info.imageMessage = @"image2";
        
        [arr addObject:info];


        
        self.dialogs = arr;
        

        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"线性布局-UITableViewCell动态高度";
    
    
    
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
        
        //您可以用相对布局来实现，也可以用线性布局来实现，下面用的是相对布局来实现。
      /*  MyRelativeLayout *dialogLayout = [MyRelativeLayout new];
        dialogLayout.tag = 50;
        
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
       */

        //您可以用相对布局来实现，也可以用线性布局来实现，下面用的是线性布局来实现。线性布局需要比相对布局多增加一个布局层
        MyLinearLayout *dialogLayout= [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_HORZ];
        dialogLayout.tag = 50;
        
        dialogLayout.leftMargin = 0;
        dialogLayout.rightMargin = 0;
        dialogLayout.wrapContentHeight = YES;
        [cell.contentView addSubview:dialogLayout];

        
        UIImageView *headImageView = [UIImageView new];
        headImageView.tag = 100;
        [dialogLayout addSubview:headImageView];
        
        
        MyLinearLayout *messageLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
       
        messageLayout.weight = 1;
        messageLayout.leftMargin = 5;
        [dialogLayout addSubview:messageLayout];

        
        UILabel *nickNameLabel = [UILabel new];
        nickNameLabel.tag = 200;
        nickNameLabel.textColor = [UIColor blueColor];
        nickNameLabel.font = [UIFont systemFontOfSize:15];
        
        nickNameLabel.bottomMargin = 5;
        [messageLayout addSubview:nickNameLabel];
        
        
        UILabel *textMessageLabel = [UILabel new];
        textMessageLabel.tag = 300;
        textMessageLabel.font = [UIFont systemFontOfSize:13];
        
        textMessageLabel.leftMargin = 0;
        textMessageLabel.rightMargin = 0;
        textMessageLabel.flexedHeight = YES;
        textMessageLabel.numberOfLines = 0;
        [messageLayout addSubview:textMessageLabel];
        
        
        UIImageView *imageMessageView = [UIImageView new];
        imageMessageView.tag = 400;
        
        imageMessageView.centerXOffset = 0;
        imageMessageView.topMargin = 5;
        [messageLayout addSubview:imageMessageView];
        
    }
    
    UIImageView *headImageView = (UIImageView*)[cell.contentView viewWithTag:100];
    UILabel *nickNameLabel = (UILabel*)[cell.contentView viewWithTag:200];
    UILabel *textMessageLabel = (UILabel*)[cell.contentView viewWithTag:300];
    UIImageView *imageMessageView = (UIImageView*)[cell.contentView viewWithTag:400];
    
    
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
    MyLayoutBase *dialogLayout = (MyLayoutBase*)[cell viewWithTag:50];
    
    //通过布局视图的estimateLayoutRect函数能够评估出UITableViewCell的动态高度。estimateLayoutRect并不会进行布局
    //而只是评估布局的尺寸，这里的宽度不传0的原因是上面的UITableViewCell在建立时默认的宽度是320(不管任何尺寸都如此),因此如果我们
    //传递了宽度为0的话则会按320的宽度来评估UITableViewCell的动态高度，这样当在375和414的宽度时评估出来的高度将不会正确，因此这里需要
    //指定出真实的宽度尺寸；而高度设置为0的意思是表示高度不是固定值需要评估出来。
    //UITableViewCell的动态高度评估不局限于线性布局，相对布局也是同样适用的。
    CGRect rect = [dialogLayout estimateLayoutRect:CGSizeMake(tableView.frame.size.width, 0)];
    return rect.size.height + 1;  //这里+1的原因是显示出分割线
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

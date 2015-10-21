//
//  Test12ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test12ViewController.h"
#import "MyLayout.h"

@interface Test12ViewController ()

@property(nonatomic,strong) MyLinearLayout *myll;

@end

@implementation Test12ViewController

-(void)loadView
{
    [super loadView];
    
    /*
     在一些应用的关于界面，以及用户个人信息的展示和修改界面我们通常都会用UITableView来实现，这些UITableView的特点是UITableViewCell的数量是固定的
     而且每个UITableViewCell的布局样式可能有很大的不同，而且通常都会有分组的情况。如果我们采用传统的UITableView来实现这些功能，将会有很多的缺陷：
      
     1。你的DataSourceDelegate 的实现如果是数量，cell, 还是选择都会产生一个很大的switch的分支来处理不同的情况，如果有分组则更加复杂
     2。不同的Cell难以实现不同样式的分割线，不同的背景设置。
     3。如果Cell中需要有输入的UITextField时，当改变文本框的值时难以更新其绑定的属性。
     4。因为Cell中有复用机制，所以Cell中的某些子视图的状态也需要单独的进行保存，比如高亮，enable等等。这样将增加程序的复杂性
     5。每个Cell中的内容的高度可能不一样，难以动态计算Cell的高度。
     
     因此综上所述，我们一般不建议这些界面通过UITableView来实现，而是采用UIScrollView加MyLinearLayout来实现，因为MyLinearLayout本身就支持事件的单击触摸和
     背景的设置以及分割线的设置等功能，下面的例子将采用线性布局实现一个关于的界面。
     
    */
    
    /*
    //顶部个人信息的头像 头像 姓名
    
    //消息通知分组
       声音     》
       通知显示消息内容    开关
         退出后仍接受消息通知     开关， 这个开关受那个开关控制
       夜间防骚扰模式   开关
    打开后你的系统将在23：00-6:00之间屏蔽接受任何消息
    
    
    
    //聊天记录分组
       清空消息列表
       清空所有聊天记录
       清空缓存数据
    
    //隐私
    联系人隐私  》
    设备锁、账号安全   图片  未开启 》
    设备密码：  右边文本框。
    
    
    //底部退出登录按钮
    */
    
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view.backgroundColor = [UIColor redColor];
    
    
    _myll =  [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    _myll.backgroundColor = [UIColor grayColor];
    _myll.padding = UIEdgeInsetsMake(10, 2, 10, 2);
    _myll.leftMargin = _myll.rightMargin = 0;
    _myll.adjustScrollViewContentSize = YES;

    
    MyLinearLayout *l1 = [MyLinearLayout new];
    l1.orientation = LVORIENTATION_HORZ;
    l1.backgroundColor = [UIColor whiteColor];
    l1.leftMargin = l1.rightMargin = 0;
    l1.wrapContentHeight = YES;
    l1.padding = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    button.weight = 1;
    [button setTitle:@"添加行" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    [l1 addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    button.weight = 1;
    [button setTitle:@"删除行" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];
    
    [l1 addSubview:button];
    

    
    [_myll addSubview:l1];
    
    [self.view addSubview:_myll];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UITableView静态界面的替换方案";
    
    
}

-(void)handleAdd:(UIButton*)id
{
    
    MyLinearLayout *l1 = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    l1.tag = 100;
    l1.backgroundColor = [UIColor whiteColor];
    l1.leftMargin = l1.rightMargin = 0;
     l1.padding = UIEdgeInsetsMake(4, 4, 4, 4);
    
  /*  MyBorderLineDraw   *bld = [[MyBorderLineDraw alloc] initWithColor:[UIColor colorWithRed:(rand() % 256)/256.0 green:(rand() % 256)/256.0 blue:(rand() % 256)/256.0 alpha:1]];

    bld.headIndent = rand() % 4;
    bld.tailIndent = rand() % 3;
    bld.dash = rand() % 2;
    bld.thick = rand()%4;
    
    l1.topBorderLine = bld;
    l1.bottomBorderLine = bld;*/
    
    MyBorderLineDraw *bld = [[MyBorderLineDraw alloc] initWithColor:[UIColor blueColor]];
    bld.insetColor = [UIColor redColor];
    bld.thick = 3;
    l1.boundBorderLine = bld;
    
   
    UILabel *lb = [UILabel new];
    lb.leftMargin = lb.rightMargin = 0;
    lb.text = @"有了这个功能后就可以放弃用UITableView来做静态的线性布局了,点击一下我试试";
    lb.flexedHeight = YES;
    lb.numberOfLines = 0;
    
    
    l1.topMargin = l1.bottomMargin = 4;
    [l1 addSubview:lb];
    
    //这里设置触摸事件
    l1.highlightedBackgroundColor = [UIColor darkGrayColor];
    [l1 setTarget:self action:@selector(handleAction:)];
    
    [_myll addSubview:l1];
    
    _myll.beginLayoutBlock = ^()
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
    };
    
    _myll.endLayoutBlock = ^()
    {
        [UIView commitAnimations];
    };


    
}

-(void)handleAction:(id)sender
{
    NSLog(@"触摸:%@",sender);
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"test" message:@"触摸" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [av show];
}

-(void)handleDel:(UIButton*)id
{
    if (_myll.subviews.count >=2)
    {
        [(UIView*)[_myll.subviews lastObject] removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

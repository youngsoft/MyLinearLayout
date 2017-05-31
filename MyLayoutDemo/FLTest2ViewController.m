//
//  FLTest2ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//


#import "FLTest2ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLTest2ViewController ()

@end

@implementation FLTest2ViewController

-(void)loadView
{
    /*
       这个例子里面我们可以用框架布局来实现一些复杂的界面布局。框架布局中的子视图还可以利用widthSize和heightSize属性来确定自己的尺寸，其中的equalTo方法的值可以是一个确定的数字，也可以是父布局视图，也可以是自己。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyFrameLayout *rootLayout = [MyFrameLayout new];
    rootLayout.backgroundColor = [CFTool color:15];
    self.view = rootLayout;
    
 
    //背景占用用户信息布局的一半高度，宽度和布局一样宽
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk1"]];
    backImageView.contentMode = UIViewContentModeScaleToFill;
    backImageView.heightSize.equalTo(rootLayout.heightSize).multiply(0.5);
    backImageView.widthSize.equalTo(rootLayout.widthSize);
    [rootLayout addSubview:backImageView];
    
    //右上角图片
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    rightImageView.backgroundColor = [UIColor whiteColor];
    rightImageView.layer.cornerRadius = 16;
    rightImageView.myTop = 10;
    rightImageView.myTrailing = 10;  //顶部和右边边距10
    [rootLayout addSubview:rightImageView];
  
    
     //头像在用户信息布局的中间，并且高度为布局视图的1/3。而宽度和高度相等。
    UIImageView *headImage = [UIImageView new];
    headImage.image = [UIImage imageNamed:@"minions1"];
    headImage.layer.borderColor = [CFTool color:0].CGColor;
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 5;
    headImage.layer.borderWidth = 0.5;
    headImage.heightSize.equalTo(rootLayout.heightSize).multiply(1.0/3); //高度是父布局高度1/3
    headImage.widthSize.equalTo(headImage.heightSize);    //宽度等于高度
    headImage.centerXPos.equalTo(@0);
    headImage.centerYPos.equalTo(@0);
    [rootLayout addSubview:headImage];
    
    
    //这里昵称在头像的下面。而头像是居中，昵称也是居中的,但是因为头像的高度是1/3。而高度的一半就是1/6，因此
    //昵称的偏移可以设置为居中的相对偏移量， 再加上文本本身的高度的一半就是昵称在头像的下面。
    UILabel *nickName = [UILabel new];
    nickName.text = @"欧阳大哥";
    nickName.textColor = [CFTool color:0];
    nickName.font = [CFTool font:17];
    [nickName sizeToFit];
    nickName.centerXPos.equalTo(@0);
    nickName.centerYPos.equalTo(@(1/6.0)).offset(nickName.frame.size.height / 2); //对于框架布局来说中心点偏移也可以设置为相对偏移。
    [rootLayout addSubview:nickName];
    
    
    //左中右三张图片,设定宽度和限制高度。
    UIImageView *leadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image2"]];
    leadingView.widthSize.equalTo(rootLayout.widthSize).multiply(1/3.0); // 宽度是父布局宽度的1/3
    leadingView.heightSize.equalTo(leadingView.widthSize).max(100);  //高度和宽度相等，当最大只能是100
    leadingView.leadingPos.equalTo(@0);
    leadingView.bottomPos.equalTo(@0);
    [rootLayout addSubview:leadingView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image3"]];
    centerView.widthSize.equalTo(rootLayout.widthSize).multiply(1/3.0);
    centerView.heightSize.equalTo(centerView.widthSize).max(100);
    centerView.centerXPos.equalTo(@0);
    centerView.bottomPos.equalTo(@0);
    [rootLayout addSubview:centerView];

    
    UIImageView *trailingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image4"]];
    trailingView.widthSize.equalTo(rootLayout.widthSize).multiply(1/3.0);
    trailingView.heightSize.equalTo(trailingView.widthSize).max(100);
    trailingView.trailingPos.equalTo(@0);
    trailingView.bottomPos.equalTo(@0);
    [rootLayout addSubview:trailingView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

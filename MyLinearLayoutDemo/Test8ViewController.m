//
//  Test8ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//


#import "Test8ViewController.h"
#import "MyLayout.h"

@interface Test8ViewController ()

@end

@implementation Test8ViewController

-(void)loadView
{
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    rootLayout.backgroundColor = [UIColor grayColor];
    self.view = rootLayout;
    
    MyLinearLayout *topLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    topLayout.backgroundColor = [UIColor redColor];
    topLayout.wrapContentHeight = NO;
    topLayout.gravity = MGRAVITY_HORZ_CENTER;  //里面所有子视图水平居中
    topLayout.weight = 0.3;
    topLayout.leftMargin = 0;
    topLayout.rightMargin = 0;
    [rootLayout addSubview:topLayout];
    
     //头像
    UIImageView *headImage = [UIImageView new];
    headImage.image = [UIImage imageNamed:@"head1"];
    [headImage sizeToFit];
    headImage.topMargin = 0.45;
    headImage.bottomMargin = 0.05;
    [topLayout addSubview:headImage];
    
    
    UILabel *nickName = [UILabel new];
    nickName.text = @"欧阳大哥";
    nickName.font = [UIFont systemFontOfSize:14];
    nickName.textColor = [UIColor whiteColor];
    [nickName sizeToFit];
    nickName.topMargin = 0.05;
    nickName.bottomMargin = 0.45;
    [topLayout addSubview:nickName];
    
    
    UILabel *lastLoginTime = [UILabel new];
    lastLoginTime.text = @"上次登录时间：2015年10月20日 16:11:11";
    lastLoginTime.font = [UIFont systemFontOfSize:13];
    lastLoginTime.textColor = [UIColor whiteColor];
    [lastLoginTime sizeToFit];
    lastLoginTime.bottomMargin = 1;  //固定在底部
    [topLayout addSubview:lastLoginTime];
    
    
    MyLinearLayout *bottomLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    bottomLayout.wrapContentHeight = NO;
    bottomLayout.weight = 0.7;
    bottomLayout.leftMargin = 0;
    bottomLayout.rightMargin = 0;
    bottomLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [rootLayout addSubview:bottomLayout];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"    这个DEMO通过设置weight和margin的值来实现,请尝试旋转屏幕或者切换不同尺寸的屏幕测试结果。";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.leftMargin = 0;
    tipLabel.rightMargin = 0;
    tipLabel.numberOfLines = 0;
    tipLabel.flexedHeight = YES;
    [bottomLayout addSubview:tipLabel];
    
    
    MyLinearLayout *imageViewLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_HORZ];
    imageViewLayout.gravity = MGRAVITY_VERT_FILL; //里面所有子视图的高度都跟自己相等。
    imageViewLayout.weight = 0.8;
    imageViewLayout.leftMargin = 0;
    imageViewLayout.rightMargin = 0;
    imageViewLayout.topMargin = 5;
    [bottomLayout addSubview:imageViewLayout];
    
    
    UIImageView *imageView1 = [UIImageView new];
    imageView1.image = [UIImage imageNamed:@"image1"];
    
    imageView1.weight = 1.0;
    [imageViewLayout addSubview:imageView1];
    
    
    UIImageView *imageView2 = [UIImageView new];
    imageView2.image = [UIImage imageNamed:@"image2"];
    imageView2.weight = 1.0;
    [imageViewLayout addSubview:imageView2];
    

    UIImageView *imageView3 = [UIImageView new];
    imageView3.image = [UIImage imageNamed:@"image3"];
    imageView3.weight = 1.0;
    [imageViewLayout addSubview:imageView3];
    
    
    MyLinearLayout *functionLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_HORZ];
    functionLayout.gravity = MGRAVITY_VERT_CENTER; //里面所有子视图都垂直居中。
    functionLayout.weight = 0.2;
    functionLayout.leftMargin = 0;
    functionLayout.rightMargin = 0;
    functionLayout.topMargin = 5;
    [bottomLayout addSubview:functionLayout];
    
    UILabel *leftFunctionLabel = [UILabel new];
    leftFunctionLabel.backgroundColor = [UIColor blueColor];
    leftFunctionLabel.textAlignment = NSTextAlignmentCenter;
    leftFunctionLabel.text = @"添   加";
    leftFunctionLabel.leftMargin = 0.1;
    leftFunctionLabel.rightMargin = 0.1;
    leftFunctionLabel.weight = 0.3;
    leftFunctionLabel.heightDime.equalTo(functionLayout.heightDime).multiply(0.6);
    [functionLayout addSubview:leftFunctionLabel];
    
    
    UILabel *rightFunctionLabel = [UILabel new];
    rightFunctionLabel.backgroundColor = [UIColor redColor];
    rightFunctionLabel.textAlignment = NSTextAlignmentCenter;
    rightFunctionLabel.text = @"删   除";
    rightFunctionLabel.leftMargin = 0.1;
    rightFunctionLabel.rightMargin = 0.1;
    rightFunctionLabel.weight = 0.3;
    rightFunctionLabel.heightDime.equalTo(functionLayout.heightDime).multiply(0.6);
    [functionLayout addSubview:rightFunctionLabel];


    //申明文字
    UILabel *copyrightLabel = [UILabel new];
    copyrightLabel.text = @"本界面库遵从MIT协议";
    copyrightLabel.font = [UIFont systemFontOfSize:13];
    [copyrightLabel sizeToFit];
    copyrightLabel.bottomMargin = 5;
    copyrightLabel.centerXOffset = 0;
    [rootLayout addSubview:copyrightLabel];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"完美适配";
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

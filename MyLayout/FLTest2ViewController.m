//
//  Test8ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//


#import "FLTest2ViewController.h"
#import "MyLayout.h"

@interface FLTest2ViewController ()

@end

@implementation FLTest2ViewController

-(void)loadView
{
    MyFrameLayout *rootLayout = [MyFrameLayout new];    
    self.view = rootLayout;
    
    
    //背景占用用户信息布局的一半高度，宽度和布局一样宽
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk1"]];
    backImageView.contentMode = UIViewContentModeScaleToFill;
    
    backImageView.heightDime.equalTo(rootLayout.heightDime).multiply(0.5);
    backImageView.widthDime.equalTo(rootLayout.widthDime);
    [rootLayout addSubview:backImageView];
    
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    rightImageView.backgroundColor = [UIColor whiteColor];
    rightImageView.layer.cornerRadius = 16;

    [rightImageView sizeToFit];
    rightImageView.marginGravity = MyMarginGravity_Horz_Right | MyMarginGravity_Vert_Top;
    rightImageView.myTopMargin = 10;
    rightImageView.myRightMargin = 10;
    [rootLayout addSubview:rightImageView];
    
    
     //头像在用户信息布局的中间，并且高度为布局视图的1/3。而宽度和高度相等。
    UIImageView *headImage = [UIImageView new];
    headImage.image = [UIImage imageNamed:@"minions1"];
    headImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    headImage.layer.cornerRadius = 4;
    headImage.layer.borderWidth = 1;
    headImage.backgroundColor = [UIColor whiteColor];
    
    headImage.heightDime.equalTo(rootLayout.heightDime).multiply(0.3);
    headImage.widthDime.equalTo(headImage.heightDime);
    headImage.marginGravity = MyMarginGravity_Center;
    [rootLayout addSubview:headImage];
    
    
    UILabel *nickName = [UILabel new];
    nickName.text = @"欧阳大哥";
    nickName.font = [UIFont systemFontOfSize:14];
    nickName.textColor = [UIColor redColor];
    
    //这里昵称在头像的下面。而头像是居中，昵称也是居中的,但是因为头像的高度是1/3。而高度的一半就是1/6，因此
    //昵称的偏移可以设置为居中的相对偏移量， 再加上文本本身的高度的一半就是昵称在头像的下面。
    [nickName sizeToFit];
    nickName.marginGravity = MyMarginGravity_Center;
    nickName.centerYPos.equalTo(@(1/6.0)).offset(nickName.frame.size.height / 2);
    [rootLayout addSubview:nickName];
    
    
    //左中右三张图片,设定宽度和限制高度。
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image1"]];
    leftView.widthDime.equalTo(rootLayout.widthDime).multiply(1/3.0);
    leftView.heightDime.equalTo(leftView.widthDime).max(80);
    leftView.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Left;
    [rootLayout addSubview:leftView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image2"]];
    centerView.widthDime.equalTo(rootLayout.widthDime).multiply(1/3.0);
    centerView.heightDime.equalTo(centerView.widthDime).max(80);
    centerView.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Center;
    [rootLayout addSubview:centerView];

    
    UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image3"]];
    rightView.widthDime.equalTo(rootLayout.widthDime).multiply(1/3.0);
    rightView.heightDime.equalTo(rightView.widthDime).max(80);
    rightView.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Right;
    [rootLayout addSubview:rightView];

    
    
      
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"框架布局2";
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

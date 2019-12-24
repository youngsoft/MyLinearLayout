//
//  AllTestExampleViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "AllTestExampleViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface AllTestExampleViewController ()


@end

@implementation AllTestExampleViewController

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    
   // [self example1];
   // [self example2];
    //[self example3];
   // [self example4];
    [self example5];
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

-(void)example1
{
    //验证相对布局的其他分支覆盖。
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.myMargin = 0;
    [self.view addSubview:rootLayout];
    
    
    UIView *v1 = [UIView new];
    v1.mySize = CGSizeMake(100, 100);
    v1.myTop = 100;
    v1.myLeft = 100;
    v1.visibility = MyVisibility_Gone;
    [rootLayout addSubview:v1];
    
    //某个视图的水平居中依赖另外一个视图，另外一个视图隐藏。
    UIView *v2 = [UIView new];
    v2.mySize = CGSizeMake(100, 100);
    v2.centerXPos.equalTo(v1.centerXPos).offset(20);
    v2.centerYPos.equalTo(v1.centerYPos).offset(20);
    [rootLayout addSubview:v2];
    
    //某个视图的左边依赖另外一个视图，另外一个视图隐藏。
    UIView *v3 = [UIView new];
    v3.mySize = CGSizeMake(100, 100);
    v3.leadingPos.equalTo(v1.leadingPos).offset(20);
    v3.bottomPos.equalTo(v1.bottomPos).offset(20);
    [rootLayout addSubview:v3];

    UIView *v4 = [UIView new];
    v4.mySize = CGSizeMake(100, 100);
    v4.leadingPos.lBound(v3.leadingPos, 0);
    v4.trailingPos.uBound(rootLayout.trailingPos,0);
    v4.bottomPos.equalTo(@(10));
    [rootLayout addSubview:v4];

    UIView *v5 = [UIView new];
    v5.mySize = CGSizeMake(100, 100);
    v5.baselinePos.equalTo(v4.baselinePos).offset(20);
    [rootLayout addSubview:v5];
    
    UILabel *v6 = [UILabel new];
    v6.mySize = CGSizeMake(100, 100);
    v6.baselinePos.equalTo(v1.baselinePos).offset(20);
    [rootLayout addSubview:v6];

    UILabel *v7 = [UILabel new];
    v7.mySize = CGSizeMake(100, 100);
    v7.baselinePos.equalTo(@(40));
    [rootLayout addSubview:v7];
    
}

-(void)example2
{
    MyFrameLayout *rootLayout = [MyFrameLayout new];
    rootLayout.myMargin = 0;
    [self.view addSubview:rootLayout];
    
    // B 视图
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.backgroundColor = [UIColor blueColor];
    scrollview.myHorzMargin = 0;
    scrollview.wrapContentHeight = YES;
    scrollview.heightSize.max(400).min(280);
    [rootLayout addSubview:scrollview];
    
    // 内容C视图
    MyLinearLayout * backLinear = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    backLinear.backgroundColor = [UIColor greenColor];
    backLinear.myHorzMargin = 0;
    backLinear.heightSize.min(280);
    backLinear.gravity = MyGravity_Vert_Bottom;
    [scrollview addSubview:backLinear];
    
    UIView *v = [UIView new];
    v.myHeight = 500;  //调整不同的尺寸得到不同的结果。分别设置为100， 350， 500
    v.myWidth = 100;
    v.backgroundColor = [UIColor redColor];
    [backLinear addSubview:v];

}

-(void)example3
{
    //用链式语法创建一个弹性布局，宽度和父视图一致，高度为100
    MyFlexLayout *layout = MyFlexLayout.new.myFlex
    .flex_direction(MyFlexDirection_Row)
    .flex_wrap(MyFlexWrap_Wrap)
    .align_content(MyFlexGravity_Center)
    .align_items(MyFlexGravity_Flex_End)
    .vert_space(10)
    .horz_space(10)
    .padding(UIEdgeInsetsMake(10, 10, 10, 10))
    .margin_top(50)
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .addTo(self.view);
    
    
    UILabel *itemA = UILabel.new.myFlex
    .width(MyLayoutSize.fill)
    .height(30)
    .addTo(layout);
    
    UILabel *itemB = UILabel.new.myFlex
    .flex_grow(1)
    .align_self(MyFlexGravity_Flex_Start)
    .height(30)
    .addTo(layout);
    
    UILabel *itemC = UILabel.new.myFlex
    .flex_grow(1)
    .height(40)
    .addTo(layout);
    
    UILabel *itemD = UILabel.new.myFlex
    .flex_grow(1)
    .height(50)
    .addTo(layout);
    
    
    layout.backgroundColor = [UIColor grayColor];
    itemA.text = @"A";
    itemA.backgroundColor = [UIColor redColor];
    itemB.text = @"B";
    itemB.backgroundColor = [UIColor greenColor];
    itemC.text = @"C";
    itemC.backgroundColor = [UIColor blueColor];
    itemD.text = @"D";
    itemD.backgroundColor = [UIColor yellowColor];

}


-(void)example4
{
    MyRelativeLayout *_rootLayout = [MyRelativeLayout new];
    
    _rootLayout.widthSize.equalTo(self.view.widthSize);
    _rootLayout.wrapContentHeight = YES;
    _rootLayout.topPadding = 15;
    _rootLayout.bottomPadding = 15;
    _rootLayout.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rootLayout];
    
   
    
    MyLinearLayout *topLayout = [MyLinearLayout linearLayoutWithOrientation:(MyOrientation_Vert)];
    
    topLayout.wrapContentWidth = YES;
    topLayout.myHorzMargin = 0;
    topLayout.wrapContentHeight = YES;
    topLayout.subviewVSpace = 5;
    [_rootLayout addSubview:topLayout];
    
    
    UILabel *topLable = [UILabel new];
    topLable.text = @"宿州学院-皁阳火车站";
    topLable.myTop = 0;
    topLable.myLeft = 11;
    topLable.wrapContentSize = YES;
    [topLayout addSubview:topLable];
    

    
    UIButton *checkMarkBtn = [UIButton new];
    [checkMarkBtn setImage:[UIImage imageNamed:@"train_progresscomplete"] forState:(UIControlStateNormal)];
    checkMarkBtn.widthSize.equalTo(@(13));
    checkMarkBtn.heightSize.equalTo(@(13));
    checkMarkBtn.rightPos.equalTo(@(10));
    checkMarkBtn.centerYPos.equalTo(@(0));
    [_rootLayout addSubview:checkMarkBtn];
        
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = @"途径：蒙城、嘎县、阜阳师范学院、嘎县、阜阳师范学院、嘎县、阜阳师范学院";
    contentLabel.myLeft = 11;
    
    contentLabel.wrapContentHeight= YES;
    contentLabel.myRight = 27;
    contentLabel.hidden = NO;
    [topLayout addSubview:contentLabel];
}

-(void)example5
{

    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.myHeight = MyLayoutSize.wrap;
    rootLayout.myHorzMargin = 0;
    rootLayout.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    
    MyLinearLayout *headerLayout = [MyLinearLayout linearLayoutWithOrientation:(MyOrientation_Horz)];
    headerLayout.topPos.equalTo(rootLayout.topPos);
    headerLayout.leftPos.equalTo(rootLayout.leftPos);
    headerLayout.wrapContentHeight = YES;
    [rootLayout addSubview:headerLayout];
    
    UIImageView *headerView = UIImageView.alloc.init;
    headerView.mySize = CGSizeMake(32, 32);
    [headerLayout addSubview:headerView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"欧阳大哥";
    nameLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    nameLabel.alignment = MyGravity_Vert_Center;
    nameLabel.myLeft = 5;
    [headerLayout addSubview:nameLabel];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"大师傅阿萨德阿斯蒂芬阿斯蒂芬";
    titleLabel.myHeight = MyLayoutSize.wrap;
    titleLabel.leftPos.equalTo(headerLayout.leftPos).offset(32 + 5);
    titleLabel.topPos.equalTo(headerLayout.bottomPos).offset(5);
    titleLabel.rightPos.equalTo(rootLayout.rightPos);
    [rootLayout addSubview:titleLabel];
    
    MyLinearLayout *barView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    barView.myHeight = 20;
    barView.leftPos.equalTo(titleLabel.leftPos);
    barView.rightPos.equalTo(rootLayout.rightPos);
    barView.topPos.equalTo(titleLabel.bottomPos);
    [rootLayout addSubview:barView];
    
    [self.view addSubview:rootLayout];
}

@end

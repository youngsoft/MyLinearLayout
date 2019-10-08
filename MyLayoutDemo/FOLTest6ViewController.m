//
//  FOLTest6ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "FOLTest6ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FOLTest6ViewController ()

@end

@implementation FOLTest6ViewController


-(void)loadView
{
    /**
     *  这个例子用浮动布局来实现各种用户个人信息的页面布局，当然浮动布局不是万能的，这里只是为了强调用浮动布局实现的机制。
     *  在很多界面中，有人诟病用线性布局来实现时会要嵌套很多的子布局，因此在一些场景中其实您不必全部都用线性布局，可以用浮动布局、流式布局或者相对布局来实现一些复杂一点的界面布局。
     */
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.backgroundColor = [CFTool color:0];
    rootLayout.myHorzMargin = 0;
    rootLayout.heightSize.lBound(scrollView.heightSize,0,1); //默认虽然高度包裹，但是最小的高度要和滚动视图相等。
    rootLayout.subviewVSpace = 10;
    [scrollView addSubview:rootLayout];
    
    //Create First User Profile type。
    [self createUserProfile1Layout:rootLayout];
    
    //Create Second User Profile type.
    [self createUserProfile2Layout:rootLayout];

    [self createUserProfile3Layout:rootLayout];

    [self createUserProfile4Layout:rootLayout];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    
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

#pragma mark -- Layout Construction

-(void)createUserProfile1Layout:(MyLinearLayout*)rootLayout
{
    //这个例子建立一个只向上浮动的浮动布局视图，注意这里要想布局高度由子视图包裹的话则必须要设置布局视图的高度自适应。
    //当在水平浮动布局中设置高度自适应，子视图不能逆向浮动只能向上浮动，并且子视图的weight不能设置为非0.
    //当在水平浮动布局中设置高度自适应，需要我们设置某个子视图的clearFloat为YES进行手动换行处理。
    
    MyFloatLayout *contentLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.backgroundColor = [UIColor whiteColor];
    contentLayout.myHeight = MyLayoutSize.wrap;
    contentLayout.myHorzMargin = 0;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewHSpace = 5;
    contentLayout.subviewVSpace = 5;
    [rootLayout addSubview:contentLayout];
    
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    headImageView.mySize = CGSizeMake(40, 40);  //头像部分固定尺寸。。
    [contentLayout addSubview:headImageView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"欧阳大哥";
    nameLabel.font = [CFTool font:17];
    nameLabel.textColor = [CFTool color:4];
    nameLabel.clearFloat = YES; //注意这里要另外起一行。
    nameLabel.widthSize.equalTo(contentLayout.widthSize).add(-45); //40的头像宽度外加5的左右间距。
    [nameLabel sizeToFit];
    [contentLayout addSubview:nameLabel];
    
    
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text = @"醉里挑灯看键";
    nickNameLabel.font = [CFTool font:15];
    nickNameLabel.textColor = [CFTool color:3];
    [nickNameLabel sizeToFit];
    [contentLayout addSubview:nickNameLabel];
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = @"联系地址：中华人民共和国北京市朝阳区盈科中心B座2楼,其他的我就不会再告诉你了。";
    addressLabel.font = [CFTool font:15];
    addressLabel.textColor = [CFTool color:4];
    addressLabel.heightSize.equalTo(@(MyLayoutSize.wrap));
    addressLabel.widthSize.equalTo(contentLayout.widthSize).add(-45); //40的头像宽度外加5的左右间距。
    [addressLabel sizeToFit];
    [contentLayout addSubview:addressLabel];
    
    UILabel *qqlabel = [UILabel new];
    qqlabel.text = @"QQ群:178573773";
    qqlabel.textColor = [CFTool color:4];
    qqlabel.font = [CFTool font:15];
    [qqlabel sizeToFit];
    [contentLayout addSubview:qqlabel];
    
    UILabel *githublabel = [UILabel new];
    githublabel.text = @"github: https://github.com/youngsoft";
    githublabel.font = [CFTool font:15];
    githublabel.textColor = [CFTool color:9];
    githublabel.widthSize.equalTo(contentLayout.widthSize).add(-45); //40的头像宽度外加5的左右间距。
    githublabel.adjustsFontSizeToFitWidth = YES;
    [githublabel sizeToFit];
    [contentLayout addSubview:githublabel];
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = @"坚持原创，以造轮子为乐!";
    detailLabel.textColor = [CFTool color:2];
    detailLabel.font = [CFTool font:20];
    detailLabel.widthSize.equalTo(contentLayout.widthSize).add(-45); //40的头像宽度外加5的左右间距。
    detailLabel.adjustsFontSizeToFitWidth = YES;
    [detailLabel sizeToFit];
    [contentLayout addSubview:detailLabel];

}


-(void)createUserProfile2Layout:(MyLinearLayout*)rootLayout
{
    //浮动布局的一个缺点是居中对齐难以实现，所以这里需要对子视图做一些特殊处理.注意这里weight的使用。
    
    MyFloatLayout *contentLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.backgroundColor = [UIColor whiteColor];
    contentLayout.myHeight = MyLayoutSize.wrap;
    contentLayout.myHorzMargin = 0;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [rootLayout addSubview:contentLayout];

    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions4"]];
    headImageView.contentMode = UIViewContentModeCenter;
    headImageView.weight = 1; //占据全部宽度。
    headImageView.heightSize.equalTo(@80);
    [contentLayout addSubview:headImageView];

    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"欧阳大哥";
    nameLabel.font = [CFTool font:17];
    nameLabel.textColor = [CFTool color:4];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.weight = 1;
    nameLabel.myTop = 10;
    [nameLabel sizeToFit];
    [contentLayout addSubview:nameLabel];
    
    
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text = @"醉里挑灯看键";
    nickNameLabel.font = [CFTool font:15];
    nickNameLabel.textColor =  [CFTool color:3];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    nickNameLabel.weight = 1;
    nickNameLabel.myTop = 5;
    nickNameLabel.myBottom = 15;
    [nickNameLabel sizeToFit];
    [contentLayout addSubview:nickNameLabel];
    
    NSArray *images = @[@"section1",@"section2", @"section3"];
    NSArray *menus = @[@"Followers",@"Starred", @"Following"];
    NSArray *values = @[@"140",@"5",@"0"];
    
    //三个小图标均分宽度。
    for (int i = 0; i < 3; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[i]]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.heightSize.equalTo(@20);
        imageView.weight = 1.0/ (3 - i);  //这里三个，第一个占用全部的1/3，第二个占用剩余的1/2，第三个占用剩余的1/1。这样就实现了均分宽度的效果。
        [contentLayout addSubview:imageView];
    }
    
    //文本均分宽度
    for (int i = 0; i < 3; i++)
    {
        UILabel *menuLabel = [UILabel new];
        menuLabel.text = menus[i];
        menuLabel.textColor = [CFTool color:2];
        menuLabel.font = [CFTool font:14];
        menuLabel.textAlignment = NSTextAlignmentCenter;
        menuLabel.adjustsFontSizeToFitWidth = YES;
        menuLabel.weight = 1.0/ (3 - i);
        menuLabel.myTop = 10;
        [menuLabel sizeToFit];
        [contentLayout addSubview:menuLabel];
    }
    
    //文本均分宽度。
    for (int i = 0; i < 3; i++)
    {
        UILabel *valueLabel = [UILabel new];
        valueLabel.text = values[i];
        valueLabel.textColor = [CFTool color:2];
        valueLabel.font = [CFTool font:14];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.weight = 1.0/ (3 - i);
        valueLabel.myTop = 5;
        [valueLabel sizeToFit];
        [contentLayout addSubview:valueLabel];
    }


    
}

-(void)createUserProfile3Layout:(MyLinearLayout*)rootLayout
{
    //这个例用了viewLayoutCompleteBlock来实现一些特殊化处理。
    
    MyFloatLayout *contentLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.backgroundColor = [UIColor whiteColor];
    contentLayout.myHeight = MyLayoutSize.wrap;
    contentLayout.myHorzMargin = 0;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [rootLayout addSubview:contentLayout];
    
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions4"]];
    headImageView.mySize = CGSizeMake(80, 80);
    headImageView.myTrailing = 10;
    headImageView.layer.cornerRadius = 5;
    headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    headImageView.layer.borderWidth = 0.5;
    [contentLayout addSubview:headImageView];
    headImageView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
    {
        //这里我们建立一个特殊的子视图，我们可以在这个block里面建立子视图，不会影响到这次的子视图的布局。
        UILabel *label = [UILabel new];
        label.useFrame = YES;  //这里我们设置useFrame为YES表示他不会参与布局，这样这个视图就可以摆脱浮动布局视图的约束。
        label.text = @"99";
        label.font = [CFTool font:12];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [CFTool color:2];
        [label sizeToFit]; //这里内部会设置frame值。
        label.layer.cornerRadius = label.frame.size.width/2;
        label.layer.masksToBounds = YES;
        CGRect labelRect = label.frame;
        labelRect.origin.x = CGRectGetMaxX(sbv.frame) - label.frame.size.width / 2;
        labelRect.origin.y = CGRectGetMinY(sbv.frame) - label.frame.size.height / 2;
        label.frame = labelRect;
        [layout addSubview:label];
        
    };
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"欧阳大哥";
    nameLabel.font = [CFTool font:17];
    nameLabel.textColor = [CFTool color:4];
    nameLabel.clearFloat = YES;
    [nameLabel sizeToFit];
    [contentLayout addSubview:nameLabel];
    
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text = @"醉里挑灯看键";
    nickNameLabel.font = [CFTool font:15];
    nickNameLabel.textColor =  [CFTool color:3];
    [nickNameLabel sizeToFit];
    [contentLayout addSubview:nickNameLabel];
    
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = @"坚持原创，以造轮子为乐!";
    detailLabel.textColor = [CFTool color:2];
    detailLabel.font = [CFTool font:20];
    detailLabel.adjustsFontSizeToFitWidth = YES;
    [detailLabel sizeToFit];
    [contentLayout addSubview:detailLabel];

}


-(void)createUserProfile4Layout:(MyLinearLayout*)rootLayout
{
    MyFloatLayout *contentLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.backgroundColor = [UIColor whiteColor];
    contentLayout.myHeight = MyLayoutSize.wrap;
    contentLayout.myHorzMargin = 0;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [rootLayout addSubview:contentLayout];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions4"]];
    headImageView.mySize = CGSizeMake(80, 80);
    headImageView.myTrailing = 10;
    headImageView.layer.cornerRadius = 5;
    headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    headImageView.layer.borderWidth = 0.5;
    [contentLayout addSubview:headImageView];
    
    
    UILabel *editButton = [UILabel new];
    editButton.text = @"Edit";
    editButton.textAlignment = NSTextAlignmentCenter;
    editButton.backgroundColor = [CFTool color:5];
    editButton.textColor = [CFTool color:4];
    editButton.layer.cornerRadius = 5;
    editButton.layer.masksToBounds = YES;
    editButton.widthSize.equalTo(@(MyLayoutSize.wrap)).add(20);
    editButton.heightSize.equalTo(@(MyLayoutSize.wrap)).add(4);
    editButton.reverseFloat = YES;
    [contentLayout addSubview:editButton];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"欧阳大哥";
    nameLabel.font = [CFTool font:17];
    nameLabel.textColor = [CFTool color:4];
    nameLabel.weight  = 1;
    [nameLabel sizeToFit];
    [contentLayout addSubview:nameLabel];
    
    UIImageView *nickNameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    [nickNameImageView sizeToFit];
    nickNameImageView.myTop = 5;
    [contentLayout addSubview:nickNameImageView];
    
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text = @"醉里挑灯看键";
    nickNameLabel.font = [CFTool font:15];
    nickNameLabel.textColor =  [CFTool color:3];
    [nickNameLabel sizeToFit];
    nickNameLabel.myTop = 5;
    [contentLayout addSubview:nickNameLabel];
    
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = @"坚持原创，以造轮子为乐!";
    detailLabel.textColor = [CFTool color:2];
    detailLabel.font = [CFTool font:20];
    detailLabel.adjustsFontSizeToFitWidth = YES;
    [detailLabel sizeToFit];
    detailLabel.weight = 1;
    detailLabel.clearFloat = YES;
    detailLabel.myTop = 5;
    [contentLayout addSubview:detailLabel];

}



@end

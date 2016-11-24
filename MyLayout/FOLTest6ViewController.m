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
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [CFTool color:0];
    rootLayout.myLeftMargin = rootLayout.myRightMargin = 0;
    rootLayout.heightDime.lBound(scrollView.heightDime,0,1); //默认虽然高度包裹，但是最小的高度要和滚动视图相等。
    rootLayout.subviewMargin = 10;
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
    //这个例子建立一个只向上浮动的浮动布局视图，注意这里要想布局高度由子视图包裹的话则必须要同时设置noBoundaryLimit为YES。
    //在常规情况下，如果使用左右浮动布局时，要求必须有明确的宽度，也就是不要用wrapContentWidth。同样使用上下浮动布局时，要求必须要有明确的高度，也就是不要用wrapContentHeight。这样设置明确宽度或者高度的原因是浮动布局需要根据这些宽度或者高度的约束自动换行浮动。但是在实践的场景中，有时候我们在浮动方向上没有尺寸约束限制，而是人为的来控制子视图的换行，并且还要布局视图的宽度和高度具有包裹属性，那么这时候我们就可以用浮动布局的noBoundaryLimit属性来进行控制了。
    //设置noBoundaryLimit为YES时必要同时设置包裹属性。具体情况见属性noBoundaryLimit的说明。
    
    MyFloatLayout *contentLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    contentLayout.backgroundColor = [UIColor whiteColor];
    contentLayout.noBoundaryLimit = YES;
    contentLayout.wrapContentHeight = YES;  //对于上下浮动布局来说，如果只想向上浮动，而高度又希望是由子视图决定，则必须要设置noBoundaryLimit的值为YES。
    contentLayout.myLeftMargin = contentLayout.myRightMargin = 0;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewHorzMargin = 5;
    contentLayout.subviewVertMargin = 5;
    [rootLayout addSubview:contentLayout];
    
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    headImageView.mySize = CGSizeMake(40, 40);  //头像部分固定尺寸。。
    [contentLayout addSubview:headImageView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"欧阳大哥";
    nameLabel.font = [CFTool font:17];
    nameLabel.textColor = [CFTool color:4];
    nameLabel.clearFloat = YES; //注意这里要另外起一行。
    nameLabel.widthDime.equalTo(contentLayout.widthDime).add(-45); //40的头像宽度外加5的左右间距。
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
    addressLabel.numberOfLines = 0;
    addressLabel.flexedHeight = YES;
    addressLabel.widthDime.equalTo(contentLayout.widthDime).add(-45); //40的头像宽度外加5的左右间距。
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
    githublabel.widthDime.equalTo(contentLayout.widthDime).add(-45); //40的头像宽度外加5的左右间距。
    githublabel.adjustsFontSizeToFitWidth = YES;
    [githublabel sizeToFit];
    [contentLayout addSubview:githublabel];
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = @"坚持原创，以造轮子为乐!";
    detailLabel.textColor = [CFTool color:2];
    detailLabel.font = [CFTool font:20];
    detailLabel.widthDime.equalTo(contentLayout.widthDime).add(-45); //40的头像宽度外加5的左右间距。
    detailLabel.adjustsFontSizeToFitWidth = YES;
    [detailLabel sizeToFit];
    [contentLayout addSubview:detailLabel];

}


-(void)createUserProfile2Layout:(MyLinearLayout*)rootLayout
{
    //浮动布局的一个缺点是居中对齐难以实现，所以这里需要对子视图做一些特殊处理.注意这里weight的使用。
    
    MyFloatLayout *contentLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    contentLayout.backgroundColor = [UIColor whiteColor];
    contentLayout.wrapContentHeight = YES;
    contentLayout.myLeftMargin = contentLayout.myRightMargin = 0;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [rootLayout addSubview:contentLayout];

    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions4"]];
    headImageView.contentMode = UIViewContentModeCenter;
    headImageView.weight = 1; //占据全部宽度。
    headImageView.heightDime.equalTo(@80);
    [contentLayout addSubview:headImageView];

    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"欧阳大哥";
    nameLabel.font = [CFTool font:17];
    nameLabel.textColor = [CFTool color:4];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.weight = 1;
    nameLabel.myTopMargin = 10;
    [nameLabel sizeToFit];
    [contentLayout addSubview:nameLabel];
    
    
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text = @"醉里挑灯看键";
    nickNameLabel.font = [CFTool font:15];
    nickNameLabel.textColor =  [CFTool color:3];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    nickNameLabel.weight = 1;
    nickNameLabel.myTopMargin = 5;
    nickNameLabel.myBottomMargin = 15;
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
        imageView.heightDime.equalTo(@20);
        imageView.weight = 1.0/ (3 - i);  //这里三个，第一个占用全部的1/3，第二个占用剩余的1/2，第三个占用剩余的1/1。这样就实现了均分宽度的效果。
        [contentLayout addSubview:imageView];
    }
    
    //文本均分宽度
    for (int i = 0; i < 3; i++)
    {
        UILabel *menuLabel = [UILabel new];
        menuLabel.text = menus[i];
        menuLabel.textColor = [CFTool color:20];
        menuLabel.font = [CFTool font:14];
        menuLabel.textAlignment = NSTextAlignmentCenter;
        menuLabel.adjustsFontSizeToFitWidth = YES;
        menuLabel.weight = 1.0/ (3 - i);
        menuLabel.myTopMargin = 10;
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
        valueLabel.myTopMargin = 5;
        [valueLabel sizeToFit];
        [contentLayout addSubview:valueLabel];
    }


    
}

-(void)createUserProfile3Layout:(MyLinearLayout*)rootLayout
{
    //这个例子里面上下浮动布局还是可以设置wrapContentHeight的，并且这里用了viewLayoutCompleteBlock来实现一些特殊化处理。
    
    MyFloatLayout *contentLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    contentLayout.backgroundColor = [UIColor whiteColor];
    contentLayout.wrapContentHeight = YES;   //虽然说上下浮动布局一般要明确有高度，但是我们依然可以用wrapContentHeight属性，这时候布局视图的高度就是子视图里面高度最高的子视图了。
    contentLayout.myLeftMargin = contentLayout.myRightMargin = 0;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [rootLayout addSubview:contentLayout];
    
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions4"]];
    headImageView.mySize = CGSizeMake(80, 80);
    headImageView.myRightMargin = 10;
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
    detailLabel.reverseFloat = YES;
    [detailLabel sizeToFit];
    [contentLayout addSubview:detailLabel];

    

}


-(void)createUserProfile4Layout:(MyLinearLayout*)rootLayout
{
    MyFloatLayout *contentLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    contentLayout.backgroundColor = [UIColor whiteColor];
    contentLayout.wrapContentHeight = YES;
    contentLayout.myLeftMargin = contentLayout.myRightMargin = 0;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [rootLayout addSubview:contentLayout];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions4"]];
    headImageView.mySize = CGSizeMake(80, 80);
    headImageView.myRightMargin = 10;
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
    editButton.widthDime.equalTo(editButton.widthDime).add(20);
    editButton.heightDime.equalTo(editButton.heightDime).add(4);
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
    nickNameImageView.myTopMargin = 5;
    [contentLayout addSubview:nickNameImageView];
    
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text = @"醉里挑灯看键";
    nickNameLabel.font = [CFTool font:15];
    nickNameLabel.textColor =  [CFTool color:3];
    [nickNameLabel sizeToFit];
    nickNameLabel.myTopMargin = 5;
    [contentLayout addSubview:nickNameLabel];
    
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = @"坚持原创，以造轮子为乐!";
    detailLabel.textColor = [CFTool color:2];
    detailLabel.font = [CFTool font:20];
    detailLabel.adjustsFontSizeToFitWidth = YES;
    [detailLabel sizeToFit];
    detailLabel.weight = 1;
    detailLabel.clearFloat = YES;
    detailLabel.myTopMargin = 5;
    [contentLayout addSubview:detailLabel];

}



@end

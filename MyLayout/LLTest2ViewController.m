//
//  Test2ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest2ViewController.h"
#import "MyLayout.h"

@interface LLTest2ViewController ()

@property(nonatomic, strong) MyLinearLayout *contentLayout;

@property(nonatomic, strong) UILabel *shrinkLabel;
@property(nonatomic, strong) UIView *hiddenView;

@end

@implementation LLTest2ViewController

-(void)loadView
{
    /*
       本例子用来实现将一个布局视图嵌入到一个UIScrollView里面的功能。
       我们可以把一个布局视图作为一个子视图加入到UIScrollView中，布局库内部会根据布局视图的尺寸自动调整UIScrollView的contentSize。如果您不想调整contentSize则请在加入到UIScrollView后将布局视图的adjustScrollViewContentSize属性设置为NO。
       而布局视图里面的wrapContentHeight和wrapContentWidth属性则可以确定动态确定一个布局视图的尺寸。
     */
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    /*
     这里的contentLayout是非布局视图UIScrollView的子视图。因为同时设置了myLeftMargin和myRightMargin为0表示宽度和UIScrollView是保持一致；而高度则因为垂直线性布局的wrapContentHeight属性设置来确定；而其中的x,y轴的位置则因为没有设置默认是0。
     */
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10); //设置布局内的子视图离自己的边距.
    contentLayout.myLeftMargin = 0;
    contentLayout.myRightMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    contentLayout.heightDime.lBound(scrollView.heightDime, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
    [scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
    
    
    /*
      布局视图里面的padding属性用来设置布局视图的内边距。内边距是指布局视图里面的子视图离自己间距。外边距则是布局视图与父视图或者兄弟视图之间的间距。
      内边距是在自己的尺寸内离子视图的距离，而外边距则不是自己尺寸内离其他视图的距离。下面是内边距和外边距的效果图：
     
             ^
             | topMargin
             |           width
           +------------------------------+
           |                              |------------>
           |  l                       r   | rightMargin
           |  e       topPadding      i   |
           |  f                       g   |
           |  t   +---------------+   h   |
<----------|  P   |               |   t   |
 leftMargin|  a   |               |   P   |
           |  d   |   subviews    |   a   |  height
           |  d   |    content    |   d   |
           |  i   |               |   d   |
           |  n   |               |   i   |
           |  g   +---------------+   n   |
           |                          g   |
           |        bottomPadding         |
           +------------------------------+
             |bottomMargin
             |
             V
     
     
     如果一个布局视图中的每个子视图都离自己有一定的距离就可以通过设置布局视图的内边距来实现，而不需要为每个子视图都设置外边距。
     
     */
    

    /*垂直线性布局直接添加子视图*/
    [self createSection1:contentLayout];
    
    /*垂直线性布局套水平线性布局*/
    [self createSection2:contentLayout];

    /*垂直线性布局套垂直线性布局*/
    [self createSection3:contentLayout];

    /*垂直线性布局套水平线性布局*/
    [self createSection4:contentLayout];

    /*垂直线性布局套水平线性布局，水平线性布局利用相对边距实现左右布局*/
    [self createSection5:contentLayout];

    /*对子视图的高度的缩放调整*/
    [self createSection6:contentLayout];
    
    /*子视图的显示和隐藏*/
    [self createSection7:contentLayout];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

//线性布局片段1：上面编号文本，下面一个编辑框
-(void)createSection1:(MyLinearLayout*)contentLayout
{
    //numTitleLabel的sizeToFit确定了视图的尺寸；myLeftMargin确定了视图在x轴的位置；垂直线性布局下的子视图可以自动算出在y轴的位置。
    UILabel *numTitleLabel = [UILabel new];
    numTitleLabel.text = @"编号:";
    [numTitleLabel sizeToFit];
    numTitleLabel.myLeftMargin = 5;
    [contentLayout addSubview:numTitleLabel];
    
    //numField的myHeight确定了视图的高度；myLeftMargin,myRightMargin确定了视图的宽度和x轴的位置；myTopMargin确定了y轴上离兄弟视图偏移5.
    UITextField *numField = [UITextField new];
    numField.borderStyle = UITextBorderStyleRoundedRect;
    numField.placeholder = @"这里输入编号";
    numField.myTopMargin = 5;
    numField.myLeftMargin = numField.myRightMargin = 0;
    numField.myHeight = 40;
    [contentLayout addSubview:numField];
}


//线性布局片段2：垂直线性布局套水平线性布局
-(void)createSection2:(MyLinearLayout*)contentLayout
{
    //userInfoLayout的myLeftMargin,myRightMargin确定了视图的x轴的位置和宽度；wrapContentHeight为YES确定了视图的高度；myTopMargin确定了y轴上离兄弟视图偏移20
    MyLinearLayout *userInfoLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    userInfoLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    userInfoLayout.layer.borderWidth = 0.5;
    userInfoLayout.layer.cornerRadius = 4;
    userInfoLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    userInfoLayout.myTopMargin = 20;
    userInfoLayout.myLeftMargin = userInfoLayout.myRightMargin = 0;
    userInfoLayout.wrapContentHeight = YES;
    [contentLayout addSubview:userInfoLayout];
    
    //headImageView的sizeToFit确定了视图的尺寸；myCenterYOffset确定了在y轴垂直居中；水平线性布局下的子视图可以自动算出在x轴的位置。
    UIImageView *headImageView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    [headImageView sizeToFit];
    headImageView.myCenterYOffset = 0;
    [userInfoLayout addSubview:headImageView];
 
    //nameLayout是垂直线性布局因此默认的wrapContentHeight确定了视图的高度；weight=1设置宽度比重值，表示占用父布局infoLayout的剩余宽度；y轴上默认和父布局上边对齐；x轴则根据其在父布局下的顺序自动算出。这个部分也是一个水平线性布局套垂直线性布局的场景。
    MyLinearLayout *nameLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    nameLayout.weight = 1.0;
    nameLayout.myLeftMargin = 10;
    [userInfoLayout addSubview:nameLayout];
    
    //userNameLabel的sizeToFit确定视图的尺寸;x轴位置和父布局左对齐;y轴位置由添加到父布局中的顺序决定。
    UILabel *userNameLabel = [UILabel new];
    userNameLabel.text = @"姓名：欧阳大哥";
    [userNameLabel sizeToFit];
    [nameLayout addSubview:userNameLabel];

    //nickNameLabel的sizeToFit确定视图的尺寸;x轴位置和父布局左对齐;y轴位置由添加到父布局中的顺序决定。
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text  = @"昵称：醉里挑灯看键";
    nickNameLabel.textColor = [UIColor darkGrayColor];
    [nickNameLabel sizeToFit];
    [nameLayout addSubview:nickNameLabel];
}

//线性布局片段3：垂直线性布局套垂直线性布局
-(void)createSection3:(MyLinearLayout*)contentLayout
{
    //ageLayout是垂直线性布局默认的wrapContentHeight决定了视图的高度；myLeftMargin,myRightMargin决定了视图的x轴的位置和宽度；添加到垂直布局父视图的顺序决定了y轴的位置。
    MyLinearLayout *ageLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    ageLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ageLayout.layer.borderWidth = 0.5;
    ageLayout.layer.cornerRadius = 4;
    ageLayout.gravity = MyMarginGravity_Horz_Fill;   //布局视图里面的所有子视图的宽度和布局相等。
    ageLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    ageLayout.myTopMargin = 20;
    ageLayout.myLeftMargin = ageLayout.myRightMargin = 0;
    [contentLayout addSubview:ageLayout];
    
    
    UILabel *ageTitleLabel = [UILabel new];
    ageTitleLabel.text = @"年龄:";
    [ageTitleLabel sizeToFit];
    [ageLayout addSubview:ageTitleLabel];
    
    /*垂直线性布局套水平线性布局*/
    MyLinearLayout *ageSelectLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    ageSelectLayout.myTopMargin = 5;
    ageSelectLayout.wrapContentHeight = YES;
    ageSelectLayout.subviewMargin = 10;   //里面所有子视图之间的水平间距。
    [ageLayout addSubview:ageSelectLayout];
    
    for (NSInteger i = 0; i < 3; i++)
    {
        UILabel *ageLabel = [UILabel new];
        ageLabel.text = [NSString stringWithFormat:@"%ld", (i+2)*10];
        ageLabel.textAlignment  = NSTextAlignmentCenter;
        ageLabel.backgroundColor = [UIColor redColor];
        ageLabel.myHeight = 30;
        ageLabel.weight = 1.0;   //这里面每个子视图的宽度都是比重为1，最终的宽度是均分父视图的宽度。
        [ageSelectLayout addSubview:ageLabel];
    }
}

//线性布局片段4：垂直线性布局套水平线性布局，里面有动态高度的文本。
-(void)createSection4:(MyLinearLayout*)contentLayout
{
    MyLinearLayout *addressLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    addressLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    addressLayout.layer.borderWidth = 0.5;
    addressLayout.layer.cornerRadius = 4;
    addressLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    addressLayout.myTopMargin = 20;
    addressLayout.myLeftMargin = addressLayout.myRightMargin = 0;
    addressLayout.wrapContentHeight = YES;
    [contentLayout addSubview:addressLayout];
    
    
    UILabel *addressTitleLabel = [UILabel new];
    addressTitleLabel.text = @"地址：";
    [addressTitleLabel sizeToFit];
    [addressLayout addSubview:addressTitleLabel];
    
    
    //addressLabel的y轴位置和父布局视图上边对齐;x轴的位置则根据添加到父布局的顺序确定；视图的宽度由weight=1表示占用父视图的剩余宽度决定；视图的高度由flexedHeight设置为YES表示高度由内容动态决定。
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = @"中华人民共和国北京市朝阳区CBD西大望路温特莱中心";
    addressLabel.myLeftMargin = 10;
    addressLabel.weight = 1.0;
    addressLabel.numberOfLines = 0;
    addressLabel.flexedHeight = YES;     //这个属性设置为YES表示视图的高度动态确定。设置这个属性的前提是必须有指定视图的宽度，对于UILabel来说必须同时设置numberOfLines=0
    [addressLayout addSubview:addressLabel];
}

//线性布局片段5：垂直线性布局套水平线性布局，水平线性布局利用相对边距实现左右布局
-(void)createSection5:(MyLinearLayout*)contentLayout
{
    MyLinearLayout *sexLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    sexLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sexLayout.layer.borderWidth = 0.5;
    sexLayout.layer.cornerRadius = 4;
    sexLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    sexLayout.myTopMargin = 20;
    sexLayout.myLeftMargin = sexLayout.myRightMargin = 0;
    sexLayout.wrapContentHeight = YES;
    [contentLayout addSubview:sexLayout];
    
    
    //sexLabel, sexSwitch两个子视图在水平线性布局里面一个左一个右的原理是使用了相对间距的原因。假设某个水平线性布局的宽度是100，里面有两个子视图A，B。其中A的宽度是20，B的宽度是30。同时假设A的myRightMargin = 0.5。B的myLeftMarigin=0.5。则这时候A的右边距 = (100 - 20 - 30) * 0.5 / (0.5 + 0.5) = 25， B的左边距也是25。通过相对间距可以实现动态的视图之间的间距。
    UILabel *sexTitleLabel = [UILabel new];
    sexTitleLabel.text = @"性别:";
    [sexTitleLabel sizeToFit];
    sexTitleLabel.myCenterYOffset = 0;
    sexTitleLabel.myRightMargin = 0.5;  //线性布局中的子视图的边距如果设置为大于0小于1的值表示的是相对间距，0.5的右边距表示右边是父布局剩余空间的50%。
    [sexLayout addSubview:sexTitleLabel];
    
    UISwitch *sexSwitch = [UISwitch new];
    sexSwitch.myLeftMargin = 0.5; //线性布局中的子视图的边距如果设置为大于0小于1的值表示的是相对间距，0.5的左边距表示左边是父布局剩余空间的50%
    [sexLayout addSubview:sexSwitch];

    
}

//线性布局片段6：实现子视图的缩放。
-(void)createSection6:(MyLinearLayout*)contentLayout
{
    UILabel *shrinkLabel = [UILabel new];
    shrinkLabel.text = @"这是一段可以缩放的字符串，点击下面的按钮就可以实现文本高度的缩放，同时可以支持根据文字内容动态调整高度，这需要把flexedHeight设置为YES.为了看到滚动以及自动换行的效果你可以尝试着转动屏幕看看结果！！！";
    shrinkLabel.backgroundColor = [UIColor redColor];
    shrinkLabel.clipsToBounds = YES;  //为了实现文本可缩放，需要将这个标志设置为YES，否则效果无法实现。但要慎重使用这个标志，因为如果设置YES的话会影响性能。
    shrinkLabel.myTopMargin = 20;
    shrinkLabel.myLeftMargin = shrinkLabel.myRightMargin = 0;
    shrinkLabel.numberOfLines = 0;
    shrinkLabel.flexedHeight = YES;  //这个属性会控制在固定宽度下自动调整视图的高度。
    [contentLayout addSubview:shrinkLabel];
    self.shrinkLabel = shrinkLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(handleLabelShrink:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"点击按钮显示隐藏文本" forState:UIControlStateNormal];
    button.myCenterXOffset = 0;
    button.myHeight = 60;
    [button sizeToFit];
    [contentLayout addSubview:button];
    
}

//线性布局片段7：子视图的隐藏设置能够激发布局视图的重新布局。
-(void)createSection7:(MyLinearLayout*)contentLayout
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"点击查看更多》" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleHideAndShowMore:) forControlEvents:UIControlEventTouchUpInside];
    button.myTopMargin = 50;
    button.myRightMargin = 0;
    [button sizeToFit];
    [contentLayout addSubview:button];
    
    UIView *hiddenView = [UIView new];
    hiddenView.backgroundColor = [UIColor greenColor];
    hiddenView.hidden = YES;
    hiddenView.myTopMargin = 20;
    hiddenView.myLeftMargin = hiddenView.myRightMargin = 0;
    hiddenView.myHeight = 800;
    [contentLayout addSubview:hiddenView];
    self.hiddenView = hiddenView;

}



#pragma mark -- Handle Method


-(void)handleLabelShrink:(UIButton*)sender
{
    //因为self.shrinkLabel设置了flexedHeight来实现动态的文本高度。因此这里可以通过这个标志来实现文本伸缩功能。
    if (self.shrinkLabel.isFlexedHeight)
    {
        self.shrinkLabel.flexedHeight = NO;
        self.shrinkLabel.heightDime.equalTo(@0);  //如果当前是动态高度则将动态高度属性设置为NO，并且把高度设置为0来实现文本框的高度缩小。
    }
    else
    {
        self.shrinkLabel.flexedHeight = YES;
        self.shrinkLabel.heightDime.equalTo(nil);  //如果当前的动态高度属性为NO，则将动态高度属性设置为YES，并且把高度设置清除。
    }
    
    [self.contentLayout layoutAnimationWithDuration:0.3];
    
}

-(void)handleHideAndShowMore:(UIButton*)sender
{
    if (self.hiddenView.isHidden)
    {
        self.hiddenView.hidden = NO;
        [sender setTitle:@"点击收起《" forState:UIControlStateNormal];
        [sender sizeToFit];
    }
    else
    {
        self.hiddenView.hidden = YES;
        [sender setTitle:@"点击查看更多》" forState:UIControlStateNormal];
        [sender sizeToFit];
    }
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

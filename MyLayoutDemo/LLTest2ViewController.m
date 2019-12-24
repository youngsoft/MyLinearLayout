//
//  LLTest2ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest2ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

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
     我们可以把一个布局视图作为一个子视图加入到UIScrollView中，布局库内部会根据布局视图的尺寸自动调整UIScrollView的contentSize。如果您不想调整contentSize则请将布局视图的adjustScrollViewContentSizeMode属性设置为MyAdjustScrollViewContentSizeModeNo。
     */
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    /*
     这里的contentLayout是非布局视图UIScrollView的子视图。因为同时设置了myHorzMargin为0表示宽度和UIScrollView是保持一致；而高度则因为垂直线性布局的高度默认是自适应,表示垂直线性布局的高度等于里面的所有子视图高度；而其中的x,y轴的位置则因为没有设置默认是0。
     */
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10); //设置布局内的子视图离自己的边距.
    contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    contentLayout.heightSize.lBound(scrollView.heightSize, 10, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度加10.
    [scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
    
    
    /*
     布局视图里面的padding属性用来设置布局视图的内边距。内边距是指布局视图里面的子视图离自己距离。外边距则是视图与父视图之间的距离。
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
    
    
    //垂直线性布局直接添加子视图
    [self createSection1:contentLayout];
    
    //垂直线性布局套水平线性布局
    [self createSection2:contentLayout];
    
    //垂直线性布局套垂直线性布局
    [self createSection3:contentLayout];
    
    //垂直线性布局套水平线性布局
    [self createSection4:contentLayout];
    
    //垂直线性布局套水平线性布局，水平线性布局利用相对边距实现左右布局
    [self createSection5:contentLayout];
    
    //水平线性布局中的基线对齐
    [self createSection6:contentLayout];
    
    //对子视图的高度的缩放调整
    [self createSection7:contentLayout];
    
    //子视图的显示和隐藏
    [self createSection8:contentLayout];
    
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
    //numTitleLabel的sizeToFit确定了视图的尺寸；myLeading确定了视图在x轴的位置；垂直线性布局下的子视图可以自动算出在y轴的位置。
    UILabel *numTitleLabel = [UILabel new];
    numTitleLabel.text = NSLocalizedString(@"No.:", @"");
    numTitleLabel.font = [CFTool font:15];
    [numTitleLabel sizeToFit];
    numTitleLabel.myLeading = 5;
    [contentLayout addSubview:numTitleLabel];
    
    //numField的myHeight确定了视图的高度；myHorzMargin确定了视图的宽度和x轴的位置；myTop确定了y轴上离兄弟视图间距5.
    UITextField *numField = [UITextField new];
    numField.borderStyle = UITextBorderStyleRoundedRect;
    numField.font = [CFTool font:15];
    numField.placeholder = NSLocalizedString(@"Input the No. here", @"");
    numField.myTop = 5;
    numField.myHorzMargin = 0;
    numField.myHeight = 40;
    [contentLayout addSubview:numField];
}


//线性布局片段2：垂直线性布局套水平线性布局
-(void)createSection2:(MyLinearLayout*)contentLayout
{
    
    //userInfoLayout的myHorzMargin确定了视图的x轴的位置和宽度；myHeight设置为MyLayoutSize.wrap表示高度自适应；myTop确定了y轴上离兄弟视图间距20
    MyLinearLayout *userInfoLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    userInfoLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    userInfoLayout.layer.borderWidth = 0.5;
    userInfoLayout.layer.cornerRadius = 4;
    userInfoLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    userInfoLayout.myTop = 20;
    userInfoLayout.myHorzMargin = 0;
    userInfoLayout.myHeight = MyLayoutSize.wrap;
    [contentLayout addSubview:userInfoLayout];
    
    //headImageView的sizeToFit确定了视图的尺寸；myCenterY确定了在y轴垂直居中；水平线性布局下的子视图可以自动算出在x轴的位置。
    UIImageView *headImageView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    headImageView.myCenterY = 0;
    [userInfoLayout addSubview:headImageView];
    
    //nameLayout是垂直线性布局因此默认高度自适应；weight=1设置宽度比重值，表示占用父布局infoLayout的剩余宽度；y轴上默认和父布局上边对齐；x轴则根据其在父布局下的顺序自动算出。这个部分也是一个水平线性布局套垂直线性布局的场景。
    MyLinearLayout *nameLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    nameLayout.weight = 1.0;
    nameLayout.myLeading = 10;
    [userInfoLayout addSubview:nameLayout];
    
    //userNameLabel的sizeToFit确定视图的尺寸;x轴位置和父布局左对齐;y轴位置由添加到父布局中的顺序决定。
    UILabel *userNameLabel = [UILabel new];
    userNameLabel.text = NSLocalizedString(@"Name:欧阳大哥", @"");
    userNameLabel.font = [CFTool font:15];
    [userNameLabel sizeToFit];
    [nameLayout addSubview:userNameLabel];
    
    //nickNameLabel的sizeToFit确定视图的尺寸;x轴位置和父布局左对齐;y轴位置由添加到父布局中的顺序决定。
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text  = NSLocalizedString(@"Nickname:醉里挑灯看键", @"");
    nickNameLabel.textColor = [CFTool color:4];
    nickNameLabel.font = [CFTool font:14];
    [nickNameLabel sizeToFit];
    [nameLayout addSubview:nickNameLabel];
    
    
    
    //使用线性布局实现这个功能的一个缺点就是必须使用线性布局嵌套线性布局来完成，这样嵌套层次就可能会比较多，因此您可以尝试改用流式布局局来实现这个功能,从而减少嵌套的问题
    /*
     MyFlowLayout *userInfoLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:2];
     userInfoLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
     userInfoLayout.layer.borderWidth = 0.5;
     userInfoLayout.layer.cornerRadius = 4;
     userInfoLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
     userInfoLayout.myTop = 20;
     userInfoLayout.myLeading = userInfoLayout.myTrailing = 0;
     userInfoLayout.subviewHSpace = 10;  //子视图的水平间距为10
     userInfoLayout.myHeight = MyLayoutSize.wrap;
     userInfoLayout.gravity = MyGravity_Vert_Center; //里面的子视图整体垂直居中。
     [contentLayout addSubview:userInfoLayout];
     
     //第一列： 一个头像视图，一个占位视图。
     UIImageView *headImageView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"head1"]];
     [userInfoLayout addSubview:headImageView];
     
     //因为数量约束水平流式布局每列必须要2个所以这里建立一个占位视图填满第一列。
     UIView *placeHolderView = [UIView new];
     [userInfoLayout addSubview:placeHolderView];
     
     
     //第二列： 姓名视图，昵称视图。
     UILabel *userNameLabel = [UILabel new];
     userNameLabel.text = NSLocalizedString(@"Name:欧阳大哥", @"");
     userNameLabel.font = [CFTool font:15];
     [userNameLabel sizeToFit];
     [userInfoLayout addSubview:userNameLabel];
     
     UILabel *nickNameLabel = [UILabel new];
     nickNameLabel.text  = NSLocalizedString(@"Nickname:醉里挑灯看键", @"");
     nickNameLabel.textColor = [CFTool color:4];
     nickNameLabel.font = [CFTool font:14];
     [nickNameLabel sizeToFit];
     [userInfoLayout addSubview:nickNameLabel];
     */
    
}

//线性布局片段3：垂直线性布局套垂直线性布局
-(void)createSection3:(MyLinearLayout*)contentLayout
{
    
    //ageLayout是垂直线性布局默认高度自适应；myHorzMargin决定了视图的x轴的位置和宽度；添加到垂直布局父视图的顺序决定了y轴的位置。
    MyLinearLayout *ageLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    ageLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ageLayout.layer.borderWidth = 0.5;
    ageLayout.layer.cornerRadius = 4;
    ageLayout.gravity = MyGravity_Horz_Fill;   //布局视图里面的所有子视图的宽度和布局相等。
    ageLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    ageLayout.myTop = 20;
    ageLayout.myHorzMargin = 0;
    [contentLayout addSubview:ageLayout];
    
    
    UILabel *ageTitleLabel = [UILabel new];
    ageTitleLabel.text = NSLocalizedString(@"Age:", @"");
    ageTitleLabel.font = [CFTool font:15];
    [ageTitleLabel sizeToFit];
    [ageLayout addSubview:ageTitleLabel];
    
    //垂直线性布局套水平线性布局
    MyLinearLayout *ageSelectLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    ageSelectLayout.myTop = 5;
    ageSelectLayout.myHeight = MyLayoutSize.wrap;
    ageSelectLayout.subviewHSpace = 10;   //里面所有子视图之间的水平间距。
    [ageLayout addSubview:ageSelectLayout];
    
    for (int i = 0; i < 3; i++)
    {
        UILabel *ageLabel = [UILabel new];
        ageLabel.text = [NSString stringWithFormat:@"%d", (i+2)*10];
        ageLabel.textAlignment  = NSTextAlignmentCenter;
        ageLabel.layer.cornerRadius = 15;
        ageLabel.layer.borderColor = [CFTool color:3].CGColor;
        ageLabel.layer.borderWidth = 0.5;
        ageLabel.font = [CFTool font:13];
        ageLabel.myHeight = 30;
        ageLabel.weight = 1.0;   //这里面每个子视图的宽度都是比重为1，最终的宽度是均分父视图的宽度。
        [ageSelectLayout addSubview:ageLabel];
    }
    
    
    
    //为实现这个功能，线性布局需要2层嵌套来完成，这无疑增加了代码量，因此您可以改为用一个垂直浮动布局来实现相同的能力。
    
    /* MyFloatLayout *ageLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
     ageLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
     ageLayout.layer.borderWidth = 0.5;
     ageLayout.layer.cornerRadius = 4;
     ageLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
     ageLayout.myTop = 20;
     ageLayout.myLeading = ageLayout.myTrailing = 0;  // 宽度和父布局相等
     ageLayout.myHeight = MyLayoutSize.wrap;  //高度由子视图包裹。
     ageLayout.subviewVSpace = 5; //所有子视图垂直间距为5
     ageLayout.subviewHSpace = 10; //所有子视图水平间距为10
     [contentLayout addSubview:ageLayout];
     
     UILabel *ageTitleLabel = [UILabel new];
     ageTitleLabel.text = NSLocalizedString(@"Age:", @"");
     ageTitleLabel.font = [CFTool font:15];
     [ageTitleLabel sizeToFit];
     ageTitleLabel.widthSize.equalTo(ageLayout.widthSize);
     [ageLayout addSubview:ageTitleLabel];
     
     
     for (int i = 0; i < 3; i++)
     {
     UILabel *ageLabel = [UILabel new];
     ageLabel.text = [NSString stringWithFormat:@"%d", (i+2)*10];
     ageLabel.textAlignment  = NSTextAlignmentCenter;
     ageLabel.layer.cornerRadius = 15;
     ageLabel.layer.borderColor = [CFTool color:3].CGColor;
     ageLabel.layer.borderWidth = 0.5;
     ageLabel.font = [CFTool font:13];
     ageLabel.heightSize.equalTo(@30);
     //宽度这样设置的原因是：3个子视图要平分布局视图的宽度，这里每个子视图的间距是10。
     //因此每个子视图的宽度 = (布局视图宽度 - 2 * 子视图间距)/3 = 布局视图宽度 * 1/3 - 2*子视图间距/3
     //MyLayoutSize中的equalTo方法设置布局宽度，multiply方法用来设置1/3，add方法用来设置2*子视图间距/3. 因此可以进行如下设置：
     ageLabel.widthSize.equalTo(ageLayout.widthSize).multiply(1.0/3).add(-1 * 2 * ageLayout.subviewHSpace / 3);
     [ageLayout addSubview:ageLabel];
     }
     */
    
    
}

//线性布局片段4：垂直线性布局套水平线性布局，里面有动态高度的文本。
-(void)createSection4:(MyLinearLayout*)contentLayout
{
    MyLinearLayout *addressLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    addressLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    addressLayout.layer.borderWidth = 0.5;
    addressLayout.layer.cornerRadius = 4;
    addressLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    addressLayout.myTop = 20;
    addressLayout.myLeading = addressLayout.myTrailing = 0;
    addressLayout.myHeight = MyLayoutSize.wrap;
    [contentLayout addSubview:addressLayout];
    
    
    UILabel *addressTitleLabel = [UILabel new];
    addressTitleLabel.text = NSLocalizedString(@"Address:", @"");
    addressTitleLabel.font = [CFTool font:15];
    [addressTitleLabel sizeToFit];
    [addressLayout addSubview:addressTitleLabel];
    
    
    //addressLabel的y轴位置和父布局视图上边对齐;x轴的位置则根据添加到父布局的顺序确定；视图的宽度由weight=1表示占用父视图的剩余宽度决定；视图的高度根据内容自适应。
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = NSLocalizedString(@"Winterless Building, West Dawang Road, Chaoyang district CBD, Beijing, People's Republic of China", @"");
    addressLabel.textColor = [CFTool color:4];
    addressLabel.font = [CFTool font:14];
    addressLabel.myLeading = 10;
    addressLabel.weight = 1.0;
    addressLabel.myHeight = MyLayoutSize.wrap;     //这个属性设置为YES表示视图的高度动态确定。设置这个属性的前提是必须有指定视图的宽度.
    [addressLayout addSubview:addressLabel];
}

//线性布局片段5：垂直线性布局套水平线性布局，水平线性布局利用相对边距实现左右布局
-(void)createSection5:(MyLinearLayout*)contentLayout
{
    MyLinearLayout *sexLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    sexLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sexLayout.layer.borderWidth = 0.5;
    sexLayout.layer.cornerRadius = 4;
    sexLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    sexLayout.myTop = 20;
    sexLayout.myLeading = sexLayout.myTrailing = 0;
    sexLayout.myHeight = MyLayoutSize.wrap;
    [contentLayout addSubview:sexLayout];
    
    
    //sexLabel, sexSwitch两个子视图在水平线性布局里面一个左一个右的原理是使用了相对间距的原因。假设某个水平线性布局的宽度是100，里面有两个子视图A，B。其中A的宽度是20，B的宽度是30。同时假设A的myTrailing = 0.5。B的myLeadingMarigin=0.5。则这时候A的右边距 = (100 - 20 - 30) * 0.5 / (0.5 + 0.5) = 25， B的左边距也是25。通过相对间距可以实现动态的视图之间的间距。
    UILabel *sexTitleLabel = [UILabel new];
    sexTitleLabel.text = NSLocalizedString(@"Sex:", @"");
    sexTitleLabel.font = [CFTool font:15];
    [sexTitleLabel sizeToFit];
    sexTitleLabel.myCenterY = 0;
    sexTitleLabel.myTrailing = 0.5;  //线性布局中的子视图的边距如果设置为大于0小于1的值表示的是相对间距，0.5的右边距表示右边是父布局剩余空间的50%。
    [sexLayout addSubview:sexTitleLabel];
    
    UISwitch *sexSwitch = [UISwitch new];
    sexSwitch.myLeading = 0.5; //线性布局中的子视图的边距如果设置为大于0小于1的值表示的是相对间距，0.5的左边距表示左边是父布局剩余空间的50%
    [sexLayout addSubview:sexSwitch];
    
    
}

//建立一个基线对齐的水平线性布局
-(void)createSection6:(MyLinearLayout*)contentLayout
{
    //这个例子主要介绍基线对齐的使用方法，目前只有水平线性布局和相对布局是支持基线对齐的。水平线性布局里面要实现基线对齐，必须要设置一个基线对齐的标准视图。
    //线性布局里面的baselineBaseView属性用来指定基线的标准视图，设置为baselineBaseView的子视图必须是一个UILabel或者UITextField或者UITextView，并且只能是一行。
    //除了指定基线对齐的标准视图外，还需要为线性布局的gravity属性设置上MyGravity_Vert_Baseline才可以完成基线对齐的设置。所有其他的UILabel，UITextField，UITextView都将和标准视图的基线进行对齐，而其他类型的子视图则忽略。
    //基线对齐对于中文来说基本没有什么效果，主要是针对英文以及具有基线的字符集。
    
    MyLinearLayout *baselineLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    baselineLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    baselineLayout.layer.borderWidth = 0.5;
    baselineLayout.layer.cornerRadius = 4;
    baselineLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    baselineLayout.myTop = 20;
    baselineLayout.myLeading = baselineLayout.myTrailing = 0;
    baselineLayout.myHeight = 50;
    baselineLayout.gravity = MyGravity_Horz_Center | MyGravity_Vert_Baseline;  //整体水平居中，垂直方向则是基线对齐。
    [contentLayout addSubview:baselineLayout];
    
    UILabel *baselineLabel = [UILabel new];
    baselineLabel.text = @"Baseline view";
    baselineLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    baselineLabel.font = [CFTool font:20];
    baselineLabel.backgroundColor = [CFTool color:5];
    baselineLabel.alignment = MyGravity_Vert_Center;  //标准视图垂直居中。
    [baselineLayout addSubview:baselineLabel];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = @"Right view";
    rightLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    rightLabel.font = [CFTool font:32];
    rightLabel.backgroundColor = [CFTool color:6];
    [baselineLayout addSubview:rightLabel];
    
    baselineLayout.baselineBaseView = baselineLabel;  //这里将左边的视图设置为基线对齐的标准视图。
    
}

//线性布局片段7：实现子视图的缩放。
-(void)createSection7:(MyLinearLayout*)contentLayout
{
    UILabel *shrinkLabel = [UILabel new];
    shrinkLabel.text = NSLocalizedString(@"This is a can automatically wrap text.To realize this function, you need to set the width exact, and set the heightSize to MyLayoutSize.wrap.You can try to switch different simulator or different orientation screen to see the effect.", @"");
    shrinkLabel.backgroundColor = [CFTool color:2];
    shrinkLabel.font = [CFTool font:14];
    shrinkLabel.myTop = 20;
    shrinkLabel.myLeading = shrinkLabel.myTrailing = 0;
    
    //下面四个属性配合一起简单的实现文本的收起和展开。
    shrinkLabel.clipsToBounds = YES;  //为了实现文本可缩放，需要将这个标志设置为YES，否则效果无法实现。但要慎重使用这个标志，因为如果设置YES的话会影响性能。
    shrinkLabel.myHeight = MyLayoutSize.wrap;
    [contentLayout addSubview:shrinkLabel];
    self.shrinkLabel = shrinkLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(handleLabelShrink:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizedString(@"Show&Hide the Text", @"") forState:UIControlStateNormal];
    button.titleLabel.font = [CFTool font:16];
    button.myCenterX = 0;
    button.myHeight = 60;
    [button sizeToFit];
    [contentLayout addSubview:button];
    
}

//线性布局片段8：子视图的隐藏设置能够激发布局视图的重新布局。
-(void)createSection8:(MyLinearLayout*)contentLayout
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:NSLocalizedString(@"Show more》", @"") forState:UIControlStateNormal];
    button.titleLabel.font = [CFTool font:16];
    [button addTarget:self action:@selector(handleHideAndShowMore:) forControlEvents:UIControlEventTouchUpInside];
    button.myTop = 30;
    button.myTrailing = 0;
    [button sizeToFit];
    [contentLayout addSubview:button];
    
    UIView *hiddenView = [UIView new];
    hiddenView.backgroundColor = [CFTool color:3];
    hiddenView.visibility = MyVisibility_Gone;
    hiddenView.myTop = 20;
    hiddenView.myLeading = hiddenView.myTrailing = 0;
    hiddenView.myHeight = 800;
    [contentLayout addSubview:hiddenView];
    self.hiddenView = hiddenView;
    
}

#pragma mark -- Handle Method


-(void)handleLabelShrink:(UIButton*)sender
{
    //通过设置文本的高度在自适应和0之间切换来实现文本的伸缩显示功能。
    if (self.shrinkLabel.myHeight == MyLayoutSize.wrap)
    {
        self.shrinkLabel.myHeight = 0;  //当设置为NO时，视图的myHeight将起作用，这边高度就变为了0
    }
    else
    {
        self.shrinkLabel.myHeight = MyLayoutSize.wrap; //当设置为YES时，视图的myHeight将不起作用，这样高度就由内容包裹。
    }
    
    [self.contentLayout layoutAnimationWithDuration:0.3];
}

-(void)handleHideAndShowMore:(UIButton*)sender
{
    if (self.hiddenView.visibility == MyVisibility_Visible)
    {
        self.hiddenView.visibility = MyVisibility_Gone;
        [sender setTitle:NSLocalizedString(@"Show more》", @"") forState:UIControlStateNormal];
        [sender sizeToFit];
    }
    else
    {
        self.hiddenView.visibility = MyVisibility_Visible;
        [sender setTitle:NSLocalizedString(@"Close up《", @"") forState:UIControlStateNormal];
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

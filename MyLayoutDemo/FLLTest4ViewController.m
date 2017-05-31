//
//  FLLTest4ViewController.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLLTest4ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLLTest4ViewController ()


@end

@implementation FLLTest4ViewController


-(void)loadView
{
    /*
       这个例子主要展示流式布局对子视图weight属性的支持。对于垂直流式布局来说，子视图的weight值用来指定子视图的宽度在当前行剩余空间所占用的比例值，比如某个流式布局的宽度是100，而每行的数量为2个，且假如第一个子视图的宽度为20，则如果第二个子视图的weight设置为1的话则第二个子视图的真实宽度 = （100-20）*1 = 80。而假如第二个子视图的weight设置为0.5的话则第二个子视图的真实宽度 = (100 - 20) * 0.5 = 40。
     对于水平流式布局来说weight值用来指定一列内的剩余高度的比重值。
     通过对子视图weight值的合理使用，可以很方便的替换掉需要用线性布局来实现的嵌套布局的能力。
     
     */
    
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.backgroundColor = [CFTool color:11];
    rootLayout.myHorzMargin = 0;
    rootLayout.wrapContentHeight = YES;
    rootLayout.subviewVSpace = 10; //子视图之间的间距设置为10
    rootLayout.gravity = MyGravity_Horz_Fill; //所有子视图的宽度都和自己相等，这样子视图就不再需要设置宽度了。
    [scrollView addSubview:rootLayout];
    
    //这里一个模拟的用户登录界面，用垂直流式布局来实现。
    [self createFlowLayout1:rootLayout];
    
    //这是一个水平流式布局的例子。
    [self createFlowLayout2:rootLayout];
    
    //这是一个内容填充布局的例子。通过weight来进行均分处理。可以看出内容约束流式布局中的子视图的weight和数量约束流式布局中的子视图的weight之间的差异。
    [self createFlowLayout3:rootLayout];

    //这是一个综合的例子。
    [self createFlowLayout4:rootLayout];

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

//创建流式布局例子1
-(void)createFlowLayout1:(MyLinearLayout*)rootLayout
{
    //如果是我们用线性布局来实现这个登录界面，一般用法是建立一个垂直线性布局，然后其中的用户和密码部分则通过建立2个子的水平线性布局来实现。但是如果我们用流式布局的话则不再需要用嵌套子布局来实现了。
    
    //每行2列的垂直流式布局。
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:2];
    flowLayout.backgroundColor = [UIColor whiteColor];
    flowLayout.wrapContentHeight = YES;  //高度由子视图决定。
    flowLayout.gravity = MyGravity_Horz_Center; //所有子视图整体水平居中
    flowLayout.arrangedGravity = MyGravity_Vert_Center; //每行子视图垂直居中对齐。您可以这里尝试设置为：MyGravity_Vert_Top, MyGravity_Vert_Bottom的效果。
    flowLayout.padding = UIEdgeInsetsMake(20, 20, 20, 20);  //四周内边距设置为20
    [rootLayout addSubview:flowLayout];
    
    //the first line: head image
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions1"]];
    headerImageView.myTop = 20;
    headerImageView.myBottom = 20;
    [flowLayout addSubview:headerImageView];
    
    UIView *placeholderView1 = [UIView new]; //因为流式布局这里面每行两列，所以这里建立一个宽高为0的占位视图。我们可以在流式布局中通过使用占位视图来充满行的数量。
    [flowLayout addSubview:placeholderView1];
    
    
    
    //the second line: user name
    UILabel *userNameLabel = [UILabel new];
    userNameLabel.text = @"User Name:";
    userNameLabel.textColor = [CFTool color:4];
    userNameLabel.font = [CFTool font:15];
    [userNameLabel sizeToFit];
    [flowLayout addSubview:userNameLabel];
    
    UITextField *userNameTextField = [UITextField new];
    userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    userNameTextField.weight = 1;  //这里weight = 1表示宽度用来占用流式布局每行的剩余宽度，这样就不需要明确的设置宽度了。
    userNameTextField.myHeight = 44;  //高度44
    userNameTextField.myLeading = 20; //文本输入框距的左边间距为20
    [flowLayout addSubview:userNameTextField];
    
    
    
    //the third line: password
    UILabel *passwordLabel = [UILabel new];
    passwordLabel.text = @"Password:";
    passwordLabel.textColor = [CFTool color:4];
    passwordLabel.font = [CFTool font:15];
    passwordLabel.widthSize.lBound(userNameLabel.widthSize,0,1);  //注意这里，因为"password"的长度要小于"User name",所以我们这里设定passwordLabel的最小宽度要和userNameLabel相等。这样目的是为了让后面的输入框具有左对齐的效果。
    passwordLabel.myTop = 20;  //距离上行的顶部间距为20
    [passwordLabel sizeToFit];
    [flowLayout addSubview:passwordLabel];
    
    UITextField *passwordTextField = [UITextField new];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.weight = 1;   //这里weight = 1表示宽度用来占用流式布局每行的剩余宽度，这样就不需要明确的设置宽度了。
    passwordTextField.myHeight = 44;
    passwordTextField.myTop = 20;  //距离上行的顶部间距为20,注意这里要和passwordLabel设置的顶部间距一致，否则可能导致无法居中对齐。
    passwordTextField.myLeading = 20; //文本输入框距的左边间距为20
    [flowLayout addSubview:passwordTextField];
    
    
    //the fourth line: forgot password.
    UIView *placeholderView2 = [UIView new]; //因为流式布局这里面每行两列，所以这里建立一个宽高为0的占位视图。我们可以在流式布局中通过使用占位视图来充满行的数量。
    placeholderView2.weight = 1;
    [flowLayout addSubview:placeholderView2];

    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [forgetPasswordButton sizeToFit];
    [flowLayout addSubview:forgetPasswordButton];
    
    
    //the fifth line: remember me
    UILabel *rememberLabel = [UILabel new];
    rememberLabel.text = @"Remember me:";
    rememberLabel.textColor = [CFTool color:4];
    rememberLabel.font = [CFTool font:15];
    rememberLabel.weight = 1;
    rememberLabel.myAlignment = MyGravity_Vert_Bottom;   //流式布局通过arrangedGravity设置每行的对齐方式，如果某个子视图不想使用默认的对齐方式则可以通过myAlignment属性来单独设置对齐方式，这个例子中所有都是居中对齐，但是这个标题则是底部对齐。
    [rememberLabel sizeToFit];
    [flowLayout addSubview:rememberLabel];
    
    UISwitch *rememberSwitch = [UISwitch new];
    [flowLayout addSubview:rememberSwitch];
    
    
    
    //the sixth line: submit button
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [CFTool font:15];
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.borderColor = [CFTool color:3].CGColor;
    submitButton.layer.borderWidth = 0.5;
    submitButton.myTop = 20;
    submitButton.myHeight = 44;
    submitButton.widthSize.equalTo(flowLayout.widthSize).add(-40);  //宽度等于父视图的宽度再减去40。
    [flowLayout addSubview:submitButton];
    
    //第六行因为最后只有一个按钮，所以这里不需要建立占位视图。
    
    
    
}

//流式布局例子2
-(void)createFlowLayout2:(MyLinearLayout*)rootLayout
{
    //这个例子建立一个水平流式布局来
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:3];
    flowLayout.backgroundColor = [CFTool color:7];
    flowLayout.myHeight = 240;
    flowLayout.gravity = MyGravity_Vert_Bottom | MyGravity_Horz_Center;   //子视图整体垂直底部对齐，水平居中对齐。
    flowLayout.arrangedGravity = MyGravity_Horz_Center;  //每列子视图水平居中对齐。
    flowLayout.padding = UIEdgeInsetsMake(10, 10, 5, 10);  //四周内边距设置。
    [rootLayout addSubview:flowLayout];
    
    
    //the first col
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions4"]];
    headerImageView.mySize = CGSizeMake(80, 80);
    headerImageView.layer.cornerRadius = 40;
    headerImageView.layer.masksToBounds = YES;
    [flowLayout addSubview:headerImageView];
    
    UIView *lineView = [UIView new];
    lineView.myWidth = 2;
    lineView.weight = 1;    //高度占用剩余空间
    lineView.backgroundColor = [CFTool color:2];
    [flowLayout addSubview:lineView];
    
    UIView *placeholderView1 = [UIView new];
    [flowLayout addSubview:placeholderView1];
    
    
    //the second，third, fourth cols
    NSArray *images = @[@"image2", @"image3",@"image3", @"image4"];
    for (int i = 0; i < 9; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[arc4random_uniform((uint32_t)images.count)]]];
      //  imageView.layer.cornerRadius = 5;
       // imageView.layer.masksToBounds = YES;
        imageView.weight = 1;      //每个子视图的高度比重都是1，也就是意味着均分处理。
        imageView.myLeading = 10;
        imageView.myTrailing = 10;
        imageView.myTop = 10;
        imageView.widthSize.equalTo(imageView.heightSize);   //宽度等于高度，对于水平流式布局来说，子视图的宽度可以等于高度，反之不可以；而对于垂直流式布局来说则高度可以等于宽度，反之则不可以。
        if (i % flowLayout.arrangedCount == 0)
        {
            imageView.myTop = 60;   //每列的第一个增加缩进量。。
        }
        
        [flowLayout addSubview:imageView];
    }
    
    //the last col
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.myLeading = 10;
    [flowLayout addSubview:addButton];
    
}

-(void)createFlowLayout3:(MyLinearLayout *)rootLayout
{
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    flowLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:flowLayout];
   flowLayout.wrapContentHeight = YES;
    flowLayout.subviewSpace = 10;
    flowLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //第一行占据全部
    UILabel *v1 = [UILabel new];
    v1.text = @"100%";
    v1.textAlignment = NSTextAlignmentCenter;
    v1.adjustsFontSizeToFitWidth = YES;
    v1.backgroundColor = [CFTool color:5];
    v1.weight = 1;
    v1.myHeight = 50;
    [flowLayout addSubview:v1];
    
    //第二行第一个固定，剩余的占据全部
    UILabel *v2 = [UILabel new];
    v2.text = @"50";
    v2.textAlignment = NSTextAlignmentCenter;
    v2.adjustsFontSizeToFitWidth = YES;
    v2.backgroundColor = [CFTool color:6];
    v2.myWidth = 50;
    v2.myHeight = 50;
    [flowLayout addSubview:v2];
    
    UILabel *v3 = [UILabel new];
    v3.text = @"100%";
    v3.textAlignment = NSTextAlignmentCenter;
    v3.adjustsFontSizeToFitWidth = YES;
    v3.backgroundColor = [CFTool color:7];
    v3.weight = 1;
    v3.myHeight = 50;
    [flowLayout addSubview:v3];
    
    //第三行，三个子视图均分。
    UILabel *v4 = [UILabel new];
    v4.text = @"1/3";
    v4.textAlignment = NSTextAlignmentCenter;
    v4.adjustsFontSizeToFitWidth = YES;
    v4.backgroundColor = [CFTool color:5];
    v4.weight = 1/3.0;
    v4.widthSize.add(-20);  //因为要均分为3部分，而我们设置了水平间距subviewHSpace为10.所以我们这里要减去20。也就是减去2个间隔。
    v4.myHeight = 50;
    [flowLayout addSubview:v4];
    
    UILabel *v5 = [UILabel new];
    v5.text = @"1/2";
    v5.textAlignment = NSTextAlignmentCenter;
    v5.adjustsFontSizeToFitWidth = YES;
    v5.backgroundColor = [CFTool color:6];
    v5.weight = 1/2.0;
    v5.widthSize.add(-10); //因为剩下的要均分为2部分，而我们设置了水平间距subviewHSpace为10.所以我们这里要减去10。也就是减去1个间隔。
    v5.myHeight = 50;
    [flowLayout addSubview:v5];
    
    
    UILabel *v6 = [UILabel new];
    v6.text = @"1/1";
    v6.textAlignment = NSTextAlignmentCenter;
    v6.adjustsFontSizeToFitWidth = YES;
    v6.backgroundColor = [CFTool color:7];
    v6.weight = 1/1.0;  //最后一个占用剩余的所有空间。这里没有间距了，所以不需要再减。
    v6.myHeight = 50;
    [flowLayout addSubview:v6];


    
}

-(void)createFlowLayout4:(MyLinearLayout *)rootLayout
{
    /**
       这个例子中有2行，每行2列，这个符合流式布局的规律。因此你不需要用一个垂直布局套两个水平线性布局来实现，而是一个流式布局就好了。另外这个例子里面还展示了边界线的功能，你可以设置边界线的首尾缩进，还可以设置边界线的偏移。这样在一些场合您可以用边界线来代替横线的视图。
     */
    
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:2];
    flowLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:flowLayout];
    flowLayout.wrapContentHeight = YES;
    flowLayout.subviewSpace = 10;
    flowLayout.arrangedGravity = MyGravity_Vert_Center;
    flowLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    MyBorderline *bottomBorderline = [[MyBorderline alloc] initWithColor:[CFTool color:5]];
    bottomBorderline.offset = 45;   //下面的边界线往上偏移45
    bottomBorderline.headIndent = 10;  //头部缩进10
    bottomBorderline.tailIndent = 30;  //尾部缩进30
    flowLayout.bottomBorderline = bottomBorderline;
    
    //第一行占据全部
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"这个例子里面有2行，每行有2个子视图，这样符合流式布局的规则。因此可以用一个流式布局来实现而不必要用一个垂直线性布局套2个水平线性布局来实现。";
    titleLabel.textColor = [CFTool color:5];
    titleLabel.font = [CFTool font:14];
    titleLabel.weight = 1;   //对于指定数量的流式布局来说这个weight的是剩余的占比。
    titleLabel.wrapContentHeight = YES;
    [flowLayout addSubview:titleLabel];
    
    //第二行第一个固定，剩余的占据全部
    UIImageView *editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    [flowLayout addSubview:editImageView];
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.text = @"$123.23 - $200.12";
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = [CFTool font:13];
    priceLabel.wrapContentWidth = YES;
    priceLabel.myHeight = 30;
    [flowLayout addSubview:priceLabel];
    
    //第三行，三个子视图均分。
    UILabel *buyButton = [UILabel new];
    buyButton.text = @"Buy";
    buyButton.font = [CFTool font:12];
    buyButton.wrapContentWidth = YES;
    buyButton.myLeading = 20;
    buyButton.myHeight = 30;
    [flowLayout addSubview:buyButton];
    
}


#pragma mark -- Handle Method

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

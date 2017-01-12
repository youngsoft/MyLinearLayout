//
//  Test6ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest6ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface LLTest6ViewController ()<UITextViewDelegate>

@property(nonatomic, weak) UIButton *editButton;

@property(nonatomic, weak) UIImageView *headImageView;


@end

@implementation LLTest6ViewController

-(void)loadView
{
    [super loadView];
    
    //注意这个DEMO进来慢的原因是其中使用了UITextView,和MyLayout无关。UITextView会在第一次使用时非常的慢，后续就快了。。
    
    
    /*
       这个例子主要说的是视图之间的浮动间距设置，以及间距和尺寸的最大最小值限制的应用场景。子视图的布局尺寸类MyLayoutSize可以通过设置min,max的方法来实现最低尺寸和最高尺寸的限制设置。
     */
    
    /*
       1.如果把一个布局视图作为视图控制器根视图请务必将wrapContentHeight和wrapContentWidth设置为NO。
       2.如果想让一个布局视图的宽度和非布局视图的宽度相等则请将布局视图的myLeftMargin = myRightMargin = 0或者widthDime.equalTo(superview.widthDime)
       3.如果想让一个布局视图的高度和非布局视图的高度相等则请将布局视图的myTopMargin = myBottomMargin = 0或者heightDime.equalTo(superview.heightDime)
     */
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.wrapContentHeight = NO;
    rootLayout.backgroundColor = [UIColor whiteColor];
    [rootLayout setTarget:self action:@selector(handleHideKeyboard:)];  //设置布局上的触摸事件。布局视图支持触摸事件的设置，可以使用setTarget方法来实现。
    
    //设置布局视图的宽度等于父视图的宽度，这个方法等价于 rootLayout.myLeftMargin = rootLayout.myRightMargin = 0;
    rootLayout.widthDime.equalTo(scrollView.widthDime);
    //设置布局视图的高度等于父视图的高度，并且最低高度不能低于568-64.这两个数字的意思是iPhone5的高度减去导航条的高度部分。这句话的意思也就是说明最低不能低于iPhone5的高度，因此在iPhone4上就会出现滚动的效果！！！通过lBound,uBound方法的应用可以很容易实现各种屏幕的完美适配！！。
    //rootLayout.heightDime.equalTo(scrollView.heightDime)等于于rootLayout.myTopMargin = rootLayout.myBottomMargin = 0;
    //请您分别测试在iPhone4设备和非iPhone4设备上的情况，看看这个神奇的效果。你不再需要写if条件来做适配处理了。
    rootLayout.heightDime.equalTo(scrollView.heightDime).min(568 - 64);
    [scrollView addSubview:rootLayout];
    
    UILabel *userInfoLabel = [UILabel new];
    userInfoLabel.text = NSLocalizedString(@"user info(run in iPhone4 will have scroll effect)",@"");
    userInfoLabel.textColor = [CFTool color:4];
    userInfoLabel.font = [CFTool font:15];
    userInfoLabel.adjustsFontSizeToFitWidth = YES;
    userInfoLabel.textAlignment = NSTextAlignmentCenter;
    [userInfoLabel sizeToFit];
    userInfoLabel.myTopMargin = 10;
    userInfoLabel.myCenterXOffset = 0;
    userInfoLabel.widthDime.uBound(rootLayout.widthDime, 0, 1);  //最大的宽度和父视图相等。
    [rootLayout addSubview:userInfoLabel];
    
    
    
    //头像
    UIImageView *headImageView = [UIImageView new];
    headImageView.image = [UIImage imageNamed:@"head1"];
    headImageView.backgroundColor = [CFTool color:1];
    [headImageView sizeToFit];
    headImageView.myTopMargin = 0.25;
    headImageView.myCenterXOffset = 0;     //距离顶部间隙剩余空间的25%，水平居中对齐。
    [rootLayout addSubview:headImageView];
    self.headImageView = headImageView;
    
    
    UITextField *nameField = [UITextField new];
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.placeholder = NSLocalizedString(@"input user name here", @"");
    nameField.textAlignment = NSTextAlignmentCenter;
    nameField.font = [CFTool font:15];
    nameField.myHeight = 40;
    nameField.myLeftMargin = 0.1;
    nameField.myRightMargin = 0.1;
    nameField.myTopMargin = 0.1;     //高度为40，左右间距为布局的10%, 顶部间距为剩余空间的10%
    [rootLayout addSubview:nameField];
    
    
    /*
     用户描述，距离父视图左边为布局视图宽度的5%,但是最小不能小于17，最大不能超过19。
     如果在iPhone4上左边距按0.05算的话是16,但是因为左边距不能小于17，所以iPhone4上的左边距为17。
     如果在iPhone6+上左边距按0.05算的话是20.7,但是因为左边距不能大于19，所以iPhone6+上的左边距为19。
     如果在iPhone6上左边距按0.05算的话是18.75,没有超过最小最大限制，所以iPhone6上的左边距就是18.75
     */
    UILabel *userDescLabel = [UILabel new];
    userDescLabel.text = NSLocalizedString(@"desc info", @"");
    userDescLabel.textColor = [CFTool color:4];
    userDescLabel.font = [CFTool font:14];
    [userDescLabel sizeToFit];
    userDescLabel.myTopMargin = 10;
    userDescLabel.leftPos.equalTo(@0.05).min(17).max(19);
    [rootLayout addSubview:userDescLabel];
    
    
    UITextView *textView = [UITextView new];
    textView.text = NSLocalizedString(@"please try input text and carriage return continuous to see effect", @"");
    textView.font = [CFTool font:15];
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 0.5;
    textView.layer.cornerRadius = 5;
    textView.delegate = self;

    //左右间距为布局的10%，距离底部间距为65%,浮动高度，但高度最高为300，最低为30
    //flexedHeight和max,min的结合能做到一些完美的自动伸缩功能。
    textView.myLeftMargin = 0.05;
    textView.myRightMargin = 0.05;
    textView.myBottomMargin = 0.65;
    textView.flexedHeight = YES;
    textView.heightDime.max(300).min(60);  //虽然flexedHeight属性设置了视图的高度为动态高度，但是仍然不能超过300的高度以及不能小于60的高度。
    [rootLayout addSubview:textView];
    
    
    UILabel *copyRightLabel = [UILabel new];
    copyRightLabel.text = NSLocalizedString(@"copy rights reserved by Youngsoft", @"");
    copyRightLabel.textColor = [CFTool color:4];
    copyRightLabel.font = [CFTool font:15];
    copyRightLabel.myBottomMargin = 20;   //总是固定在底部20的边距,因为上面的textView用了底部相对间距。
    copyRightLabel.myCenterXOffset = 0;
    [copyRightLabel sizeToFit];
    [rootLayout addSubview:copyRightLabel];
    
    
    //因为在垂直线性布局里面每一列只能有一个子视图，但在实际中我们希望某个子视图边缘有一个子视图并列，为了不破坏线性布局的能力，而又能实现这种功能
    //我们可以用如下的方法。
    __weak LLTest6ViewController *weakVC = self;
    rootLayout.rotationToDeviceOrientationBlock = ^(MyBaseLayout *ll, BOOL isFirst, BOOL isPortrait)
    {//rotationToDeviceOrientationBlock方法会在第一次完成布局或者因为屏幕旋转而完成布局时调用这个block。而且布局不会在调用完成后释放这个block。
      //因此需要注意循环引用的问题。
        if (isFirst)
        {
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [editButton setTitle:@"Edit" forState:UIControlStateNormal];
            editButton.titleLabel.font = [CFTool font:15];
            editButton.useFrame = YES;  //注意这里必须要设置为useFrame为YES，目的是为了不破坏线性布局的概念，而改用直接frame的设置。
            [ll addSubview:editButton];
            weakVC.editButton = editButton;
        }
        //下面是直接用frame设置editButton的位置和尺寸。这里设置在头像图片的右边。。
        weakVC.editButton.frame = CGRectMake(CGRectGetMaxX(weakVC.headImageView.frame) + 5, CGRectGetMaxY(weakVC.headImageView.frame) - 30, 50, 30);
        
    };

    
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    //每次输入变更都让布局重新布局。
    MyBaseLayout *layout = (MyBaseLayout*)textView.superview;
    [layout setNeedsLayout];
    
    
    //这里设置在布局结束后将textView滚动到光标所在的位置了。在布局执行布局完毕后如果设置了endLayoutBlock的话可以在这个block里面读取布局里面子视图的真实布局位置和尺寸，也就是可以在block内部读取每个子视图的真实的frame的值。
    layout.endLayoutBlock = ^{
    
        NSRange rg =  textView.selectedRange;
        [textView scrollRangeToVisible:rg];
        
        
        //因为这里面的editButton已经被设置为了useFrame.所以每次布局的变化都要手动的调整editButton的frame值！！！
        //而且endLayout只会被执行一次，所以这里面不会产生相互引用的问题。
        self.editButton.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 5, CGRectGetMaxY(self.headImageView.frame) - 30, 50, 30);

        
    };
    
    
}

#pragma mark -- Handle Method

-(void)handleHideKeyboard:(id)sender
{
    [self.view endEditing:YES];
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

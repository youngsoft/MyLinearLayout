//
//  GLTest1ViewController.m
//  MyLayout
//
//  Created by oubaiquan on 2017/8/20.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "GLTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@interface GLTest1ViewController ()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@end

@implementation GLTest1ViewController

-(void)loadView
{
    /*
        本例子是介绍栅格布局的主要功能。 我们的视图其实是一个矩形区域，而进行布局的本质就是将视图这个矩形区域摆放在某个特定的位置。也就是布局的本质是确定一个视图的区域和位置。
     
        栅格也称为单元格，就是指定的一个矩形区域。我们可以将一个栅格按某个方向以固定尺寸或者某个比例尺寸分割为数个小的栅格，而这种分割是可以递归进行的，最终的结果是一个矩形区域可以分为多个按某种规则排列的栅格(这些栅格有具体的位置和尺寸)。既然栅格也具有位置和尺寸的特性，因此我们可以将某个视图填充到对应的栅格中去，从而实现了视图的布局。
     
        栅格布局就是用来实现这种布局的解决方案。栅格布局中通过建立栅格来指定位置和尺寸，同时将添加到布局中的子视图依次填充到对应的栅格中去。这样在建立子视图时不需要指定任何位置和尺寸的，只需要关心子视图本身的内容和样式，而把位置和尺寸的设置交给栅格来管理，从而实现了内容和布局的解耦分离。当我们需要更改布局中的子视图的位置和尺寸时只需要调整对应的栅格即可，而不需要对子视图进行位置和尺寸的调整，这样最大的好处是我们可以在运行时随时调整界面的布局样式，从而增加了布局的灵活性。
     
     
        栅格既然是一个区域，那么栅格布局本身除了是一个视图外，也是一个栅格，我们称栅格布局视图对应的栅格为根栅格。因此栅格布局除了负责管理子视图的添加外，还负责子栅格的建立删除等管理工作。  在栅格布局中，栅格的建立和子视图建立的分开的。子视图所填充的栅格是叶子栅格和设置为anchor属性的非叶子栅格，而填充的顺序是按栅格树的深度优先顺序填充的。 当然你可以用视图组的方式来将某些视图绑定在特定的栅格之中。
     
     */
    
    
    //在iOS11以后因为有安全区的概念，因此不需要设置edgesForExtendedLayout属性了。否则可能出现push一个视图时，出现从下往上移动的动画效果。
    if (@available(iOS 11.0, *)) {
    } else {
        // Fallback on earlier versions
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.myHorzMargin = 0;
    rootLayout.wrapContentHeight = YES;
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.subviewSpace = 10;  //直接子栅格之间的间隔。
    [scrollView addSubview:rootLayout];
    self.rootLayout = rootLayout;
    
    
    //这个例子也许你会问，为什么我要用栅格来将视图的内容和位置和尺寸分开来建立，我直接设置视图的约束不就可以了吗。
    //这是一个好问题，本例子的目的是为了介绍栅格布局而建立的。栅格布局并不一定适用于所有情况，栅格布局只适用于那些希望布局和内容分开的场景，比如后面的几个例子。但是栅格布局也是可以用于一般的场景的。如果你在一般的场景中用到了栅格布局，那么栅格布局最好用在那些界面不会动态变化的场景中。
    
 
    //建立第一行叶子栅格，高度由内容包裹
    [rootLayout addRow:MyLayoutSize.wrap];
    
    //填充视图到第一行叶子栅格中
    UILabel *numTitleLabel = [UILabel new];
    numTitleLabel.text = NSLocalizedString(@"No.:", @"");
    numTitleLabel.font = [CFTool font:15];
    [rootLayout addSubview:numTitleLabel];
    
    
    
    //建立第二行叶子栅格，高度固定为40
    [rootLayout addRow:40];
    
    //填充视图到第二行叶子栅格中
    UITextField *numField = [UITextField new];
    numField.borderStyle = UITextBorderStyleRoundedRect;
    numField.font = [CFTool font:15];
    numField.placeholder = NSLocalizedString(@"Input the No. here", @"");
    [rootLayout addSubview:numField];
    
    
    
    //建立第三行栅格，高度为固定60
    id<MyGrid> line3 = [rootLayout addRow:60];
    line3.padding = UIEdgeInsetsMake(5, 5, 5, 5);  //设置栅格的内边距。
    line3.subviewSpace = 5;   //栅格内子栅格的间距为5
    line3.anchor = YES;  //表示这个栅格虽然是非叶子栅格，但是添加的子视图可以填充到这个栅格中去。
    
    //第三行栅格内建立一个固定列宽的叶子栅格
    [line3 addCol:50];
    //第三行栅格内建立占用剩余宽度的子栅格
    id<MyGrid> line32 = [line3 addCol:MyLayoutSize.fill];
    line32.gravity = MyGravity_Vert_Center;  //line32内的所有子栅格整体垂直居中。
    [line32 addRow:MyLayoutSize.wrap];  //建立一个高度由内容包裹的叶子栅格
    [line32 addRow:MyLayoutSize.wrap];  //建立一个高度由内容包裹的叶子栅格
    
    //建立一个背景子视图用来填充到line3栅格内。虽然line3栅格为非叶子栅格，但是因为具有anchor属性，所以子视图会优先填充这块栅格区域
    UIView *backView3 = [UIView new];
    backView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView3.layer.borderWidth = 0.5;
    backView3.layer.cornerRadius = 4;
    [rootLayout addSubview:backView3];
    
    //建立的视图将填充到line3内的第一个列叶子栅格中。
    UIImageView *headImageView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    [rootLayout addSubview:headImageView];
    
    UILabel *userNameLabel = [UILabel new];
    userNameLabel.text = NSLocalizedString(@"Name:欧阳大哥", @"");
    userNameLabel.font = [CFTool font:15];
    [rootLayout addSubview:userNameLabel];
    
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.text  = NSLocalizedString(@"Nickname:醉里挑灯看键", @"");
    nickNameLabel.textColor = [CFTool color:4];
    nickNameLabel.font = [CFTool font:14];
    [rootLayout addSubview:nickNameLabel];
    
  
    
    
    //建立一个高度由子栅格包裹的行栅格
    id<MyGrid> line4 = [rootLayout addRow:MyLayoutSize.wrap];
    line4.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    line4.subviewSpace = 5;  //子栅格之间的间距为5
    line4.anchor = YES;
    
    //建立一个高度由内容包裹的叶子栅格
    [line4 addRow:MyLayoutSize.wrap];
    
    //建立一个高度为30，并且子栅格间隔为10的行栅格
    id<MyGrid> line42 = [line4 addRow:30];
    line42.subviewSpace = 10;
    
    //建立三个宽度均分的列叶子栅格。因为每个子栅格都是填充剩余宽度，因此最终的结果就是来均分父栅格的宽度。
    [line42 addCol:MyLayoutSize.fill];
    [line42 addCol:MyLayoutSize.fill];
    [line42 addCol:MyLayoutSize.fill];
    
    //建立一个视图来填充栅格line4的区域
    UIView *backView4 = [UIView new];
    backView4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView4.layer.borderWidth = 0.5;
    backView4.layer.cornerRadius = 4;
    [rootLayout addSubview:backView4];
    
    UILabel *ageTitleLabel = [UILabel new];
    ageTitleLabel.text = NSLocalizedString(@"Age:", @"");
    ageTitleLabel.font = [CFTool font:15];
    [rootLayout addSubview:ageTitleLabel];
    
    //三个子视图分别填充上面的三个等宽的列叶子栅格
    for (int i = 0; i < 3; i++)
    {
        UILabel *ageLabel = [UILabel new];
        ageLabel.text = [NSString stringWithFormat:@"%d", (i+2)*10];
        ageLabel.textAlignment  = NSTextAlignmentCenter;
        ageLabel.layer.cornerRadius = 15;
        ageLabel.layer.borderColor = [CFTool color:3].CGColor;
        ageLabel.layer.borderWidth = 0.5;
        ageLabel.font = [CFTool font:13];
        [rootLayout addSubview:ageLabel];
    }
    
    
    
    //建立第五行高度固定的栅格。
    id<MyGrid> line5 = [rootLayout addRow:40];
    line5.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    line5.anchor = YES;
    line5.gravity = MyGravity_Vert_Center;  //栅格内子栅格垂直居中。
    
    [line5 addCol:MyLayoutSize.fill];
    [line5 addCol:MyLayoutSize.wrap];
    
    UIView *backView5 = [UIView new];
    backView5.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView5.layer.borderWidth = 0.5;
    backView5.layer.cornerRadius = 4;
    [rootLayout addSubview:backView5];
    
    UILabel *sexTitleLabel = [UILabel new];
    sexTitleLabel.text = NSLocalizedString(@"Sex:", @"");
    sexTitleLabel.font = [CFTool font:15];
    [rootLayout addSubview:sexTitleLabel];
    
    UISwitch *sexSwitch = [UISwitch new];
    [rootLayout addSubview:sexSwitch];
    
    
    
    
    //建立一个栅格高度由内容决定的叶子栅格。
    [rootLayout addRow:MyLayoutSize.wrap];
    
    UILabel *shrinkLabel = [UILabel new];
    shrinkLabel.text = NSLocalizedString(@"This is a can automatically wrap text.To realize this function, you need to set the clear width, and set the wrapContentHeight to YES.You can try to switch different simulator or different orientation screen to see the effect.", @"");
    shrinkLabel.backgroundColor = [CFTool color:2];
    shrinkLabel.font = [CFTool font:14];
    shrinkLabel.numberOfLines = 0;
    [rootLayout addSubview:shrinkLabel];
    
  
    
    //建立一个高度为30的栅格，里面的子栅格垂直居中对齐。
   id<MyGrid> line7 = [rootLayout addRow:30];
    line7.gravity = MyGravity_Vert_Center;
    line7.anchor = YES;
    line7.subviewSpace = 5;
    line7.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [line7 addCol:MyLayoutSize.wrap];
    [line7 addCol:MyLayoutSize.wrap];
    [line7 addCol:MyLayoutSize.fill].placeholder = YES;  //这里设置为placeholder的意思是表示这个栅格是一个占位栅格，子视图并不会填充到这个栅格区域。也就是在line7里面只能添加三个子视图。这样做的目的是让最后一个栅格总是在最右边。
    [line7 addCol:MyLayoutSize.wrap];
    
    
    UIView *backView7 = [UIView new];
    backView7.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView7.layer.borderWidth = 0.5;
    backView7.layer.cornerRadius = 4;
    [rootLayout addSubview:backView7];

    
    UILabel *left1Label = [UILabel new];
    left1Label.text = @"欧阳大哥";
    left1Label.font = [CFTool font:15];
    [rootLayout addSubview:left1Label];
    
    UIImageView *left1ImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    [rootLayout addSubview:left1ImageView];
    
    UIImageView *right1ImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
    [rootLayout addSubview:right1ImageView];
    
    
    //建立一个高度为30的子栅格。
    id<MyGrid> line8 = [rootLayout addRow:30];
    line8.subviewSpace = 5;
    
    //分别建立一个宽度为20%，30%， 50%的列子栅格，如果measure的值是大于0并且小于1的话就是建立一个占用总体尺寸比例的子栅格
    [line8 addCol:0.2];
    [line8 addCol:0.3];
    [line8 addCol:0.5];
    
    UILabel *redLabel = [UILabel new];
    redLabel.text = @"red";
    redLabel.textAlignment = NSTextAlignmentCenter;
    redLabel.backgroundColor = [UIColor redColor];
    [rootLayout addSubview:redLabel];
    
    UILabel *greenLabel = [UILabel new];
    greenLabel.text = @"green";
    greenLabel.textAlignment = NSTextAlignmentCenter;
    greenLabel.backgroundColor = [UIColor greenColor];
    [rootLayout addSubview:greenLabel];
    
    UILabel *blueLabel = [UILabel new];
    blueLabel.text = @"blue";
    blueLabel.textAlignment = NSTextAlignmentCenter;
    blueLabel.backgroundColor = [UIColor blueColor];
    [rootLayout addSubview:blueLabel];
    
    
    //上面的栅格演示的是正数百分比，如果值是一个小于0并且大于-1的数则表示的是尺寸占用剩余空间的比例。
    //这里需要记住的是当比例是负数时表示的是剩余空间的比例，而当比例是正数时则表示的是总体空间的比例。！！！！
    id<MyGrid> line9 = [rootLayout addRow:30];
    line9.subviewSpace = 5;
    
    [line9 addCol:-0.2];  //第一列占用剩余空间的20%
    [line9 addCol:-0.375];  //第二列占用剩余空间的37.5%。这里不是30%的原因是因为第一列占用剩余20%后整体还剩余80%，所以要在80%里面占用37.5%才能达到整体占用30%的效果。
    [line9 addCol:MyLayoutSize.fill];  //最后一列是占用剩余所有空间，也就是扣除前面两个占用的空间，最终是得到剩余的100%也就是整体的50%了。
    
    UILabel *redLabel2 = [UILabel new];
    redLabel2.text = @"red";
    redLabel2.textAlignment = NSTextAlignmentCenter;
    redLabel2.backgroundColor = [UIColor redColor];
    [rootLayout addSubview:redLabel2];
    
    UILabel *greenLabel2 = [UILabel new];
    greenLabel2.text = @"green";
    greenLabel2.textAlignment = NSTextAlignmentCenter;
    greenLabel2.backgroundColor = [UIColor greenColor];
    [rootLayout addSubview:greenLabel2];
    
    UILabel *blueLabel2 = [UILabel new];
    blueLabel2.text = @"blue";
    blueLabel2.textAlignment = NSTextAlignmentCenter;
    blueLabel2.backgroundColor = [UIColor blueColor];
    [rootLayout addSubview:blueLabel2];
    
    
    
    //建立一个高度由内容包裹并且里面填充的子视图右对齐的的叶子栅格。
    [rootLayout addRow:MyLayoutSize.wrap].gravity = MyGravity_Horz_Right;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:NSLocalizedString(@"Show more》", @"") forState:UIControlStateNormal];
    [button2 addTarget:self  action:@selector(handleHideAndShowMore:) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [CFTool font:16];
    [rootLayout addSubview:button2];
    

    
    //建立一个高度为0的叶子栅格，这里面实现高度的动态调整。
    [rootLayout addRow:0];
    
    //添加对应的视图
    UIView *hiddenView = [UIView new];
    hiddenView.backgroundColor = [CFTool color:3];
    [rootLayout addSubview:hiddenView];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Handle Method

-(void)handleHideAndShowMore:(UIButton*)sender
{
    
    id<MyGrid> lastGrid = self.rootLayout.subGrids.lastObject;
    
    if (lastGrid.measure == 0)
        lastGrid.measure = 800;
    else
        lastGrid.measure = 0;
    
    [self.rootLayout setNeedsLayout];
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

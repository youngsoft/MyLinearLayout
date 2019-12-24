//
//  FLLTest7ViewController.m
//  MyLayout
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "FLLTest7ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@implementation FLLTest7ViewController


-(void)createItems:(NSArray*)titles inFlowLayout:(MyFlowLayout*)flowLayout
{
    for (NSString *title in titles)
    {
        UILabel *label = [UILabel new];
        label.text = title;
        label.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        label.backgroundColor = [CFTool color:(random()%14 + 1)];
        label.font = [CFTool font:16];
        [flowLayout addSubview:label];
    }
}

-(void)loadView
{
    /*
        这个例子主要用来介绍数量约束流式布局的自动排列和紧凑排列的能力，目的是为了实现类似于瀑布流的功能，下面的代码您将能看到水平和垂直两种应用场景。
        每种应用场景中，我们通过设置autoArrange为YES和arrangedGravity属性为MyGravity_Horz_Between或者MyGravity_Vert_Between来分别实现两种不同的
        排列策略：
     autoArrange: 的策略是让总体的空间达到最高效的利用，但是他会打乱视图添加的顺序。
     arrangedGravity: 的策略则不会打乱视图的添加顺序，因此他的总体空间的利用率可能会不如autoArrange那么高。
     */
    
    /*
       需要注意的是，当您的数据量比较小时，我们可以考虑使用流式布局来实现瀑布流，而当你的数据量比较大，并且需要考虑复用，那么为了内存上的考虑建议您还是使用tableView或者collectionView来实现。
     */
    
    NSArray *titles = @[@"11111111111111111", @"222222222222222222222222222",@"3333333333333", @"4444444444444444444444", @"55555555", @"6666666666666", @"77777777", @"8888888888888888888888", @"99"];

    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.gravity = MyGravity_Horz_Fill;
    rootLayout.subviewSpace = 20;
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    //水平瀑布流1。
    UIScrollView *scrollView1 = [UIScrollView new];
    scrollView1.myHeight = MyLayoutSize.wrap; //这里可以设置滚动视图的高度为包裹属性，表示他的高度依赖于布局视图的高度。
    [rootLayout addSubview:scrollView1];
    
    MyFlowLayout *flowLayout1 = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:3];
    flowLayout1.backgroundColor = [CFTool color:5];
    //流式布局的尺寸由里面的子视图的整体尺寸决定。
    flowLayout1.heightSize.equalTo(@(MyLayoutSize.wrap));
    flowLayout1.widthSize.equalTo(@(MyLayoutSize.wrap)).lBound(scrollView1.widthSize, 0, 1);  //虽然尺寸是包裹的，但是最小宽度不能小于父视图的宽度
    flowLayout1.autoArrange = YES;  //通过将流式布局的autoArrange属性设置为YES可以实现里面的子视图进行紧凑的自动排列。
    flowLayout1.subviewSpace = 10;
    flowLayout1.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [scrollView1 addSubview:flowLayout1];
    [self createItems:titles inFlowLayout:flowLayout1];
    
    
    //水平瀑布流2。
    UIScrollView *scrollView2 = [UIScrollView new];
    scrollView2.myHeight = MyLayoutSize.wrap;
    [rootLayout addSubview:scrollView2];
    
    MyFlowLayout *flowLayout2 = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:3];
    flowLayout2.backgroundColor = [CFTool color:6];
    flowLayout2.heightSize.equalTo(@(MyLayoutSize.wrap));
    flowLayout2.widthSize.equalTo(@(MyLayoutSize.wrap)).lBound(scrollView2.widthSize, 0, 1);  //虽然尺寸是包裹的，但是最小宽度不能小于父视图的宽度
    flowLayout2.subviewSpace = 10;
    flowLayout2.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout2.arrangedGravity = MyGravity_Horz_Between;  //通过将水平流式布局的arrangeGravity属性设置为MyGravity_Horz_Between，我们将得到里面的子视图在每行都会被紧凑的排列。大家可以看到和上面的将autoArrange设置为YES的不同的效果。
    [scrollView2 addSubview:flowLayout2];
    [self createItems:titles inFlowLayout:flowLayout2];
    
    
    //垂直瀑布流1
    UIScrollView *scrollView3 = [UIScrollView new];
    scrollView3.weight = 0.5;  //占用父布局剩余的高度的一半
    [rootLayout addSubview:scrollView3];
    
    MyFlowLayout *flowLayout3 = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    flowLayout3.backgroundColor = [CFTool color:5];
    flowLayout3.heightSize.equalTo(@(MyLayoutSize.wrap)).lBound(scrollView3.heightSize, 0, 1); //虽然是包裹尺寸，但是最小不能小于父视图的高度。
    flowLayout3.myHorzMargin = 0;
    flowLayout3.gravity = MyGravity_Horz_Fill; //均分宽度。
    flowLayout3.autoArrange = YES;  //通过将流式布局的autoArrange属性设置为YES可以实现里面的子视图进行紧凑的自动排列。
    flowLayout3.subviewSpace = 10;
    flowLayout3.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [scrollView3 addSubview:flowLayout3];
    [self createItems:titles inFlowLayout:flowLayout3];
    
    
    //垂直瀑布流2
    UIScrollView *scrollView4 = [UIScrollView new];
    scrollView4.weight = 0.5;  //占用父布局剩余的高度的一半
    [rootLayout addSubview:scrollView4];
    
    MyFlowLayout *flowLayout4 = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    flowLayout4.backgroundColor = [CFTool color:6];
    flowLayout4.heightSize.equalTo(@(MyLayoutSize.wrap)).lBound(scrollView4.heightSize, 0, 1);
    flowLayout4.myHorzMargin = 0;
    flowLayout4.gravity = MyGravity_Horz_Fill; //均分宽度。
    flowLayout4.arrangedGravity = MyGravity_Vert_Between;  //通过将垂直流式布局的arrangeGravity属性设置为MyGravity_Vert_Between，我们将得到里面的子视图在每列都会被紧凑的排列。大家可以看到和上面的将autoArrange设置为YES的不同的效果。
    flowLayout4.subviewSpace = 10;
    flowLayout4.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [scrollView4 addSubview:flowLayout4];
    [self createItems:titles inFlowLayout:flowLayout4];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

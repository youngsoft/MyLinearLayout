//
//  RLTest6ViewController.m
//  MyLayout
//
//  Created by oybq on 16/12/19.
//  Copyright (c) 2016年 YoungSoft. All rights reserved.
//

#import "RLTest6ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface RLTest6ViewController ()<UIScrollViewDelegate>




@end

@implementation RLTest6ViewController


-(void)loadView
{
    [super loadView];
    //宽度和高度。
    //
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.myMargin = 0;
    [self.view addSubview:rootLayout];
    
    MyRelativeLayout *layout1 = [self createLayoutName:@"张三" date:@"2019-10-07" detail:@"short detail"];
    layout1.topPos.equalTo(rootLayout.topPos);
    layout1.leftPos.equalTo(rootLayout.leftPos);
    layout1.backgroundColor = [CFTool color:3];
   // [rootLayout addSubview:layout1];
    
    MyRelativeLayout *layout2 = [self createLayoutName:@"欧阳大哥" date:@"2019-10-07" detail:@"this is a middle length detail"];
    layout2.topPos.equalTo(layout1.bottomPos).offset(20);
    layout2.leftPos.equalTo(rootLayout.leftPos);
    layout2.backgroundColor = [CFTool color:4];
  //  [rootLayout addSubview:layout2];

    
    MyRelativeLayout *layout3 = [self createLayoutName:@"李四" date:@"2019-10-07" detail:@"this is a long long long long long long long long length detail"];
  //  layout3.topPos.equalTo(layout2.bottomPos).offset(20);
  //  layout3.leftPos.equalTo(rootLayout.leftPos);
    layout3.backgroundColor = [CFTool color:5];
    [rootLayout addSubview:layout3];

    
    //三个例子: 底下的文字太少，底下的文字中等，底下的文字太长。
    
    
    
}

-(MyRelativeLayout*)createLayoutName:(NSString*)name date:(NSString*)date detail:(NSString*)detail
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.widthSize.equalTo(@(MyLayoutSize.wrap));
    rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    //名字控件，尺寸是自适应的。
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = name;
    nameLabel.widthSize.equalTo(@(MyLayoutSize.wrap));
    nameLabel.heightSize.equalTo(@(MyLayoutSize.wrap));
 //   [rootLayout addSubview:nameLabel];
    
    //详情控件，尺寸是自适应的，但是最宽是屏幕宽度减20，这里减20的原因是因为布局视图设置了左右padding为10。
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = detail;
    //宽度自适应，最宽是屏幕的宽度减去20
    detailLabel.widthSize.equalTo(@(MyLayoutSize.wrap)).uBound(self.view.widthSize, -20, 1);
    detailLabel.heightSize.equalTo(@(MyLayoutSize.wrap));
    detailLabel.topPos.equalTo(nameLabel.bottomPos).offset(10);
    detailLabel.leftPos.equalTo(nameLabel.leftPos);
    [rootLayout addSubview:detailLabel];
    
    //日期控件，右边和详情控件对齐，但是当详情控件的内容太少时，起码要和名字控件最小的距离是40
    UILabel *dateLabel = [UILabel new];
    dateLabel.text = date;
    [dateLabel sizeToFit];   //这里直接计算出date的size是自适应的
//    [rootLayout addSubview:dateLabel];
    dateLabel.topPos.equalTo(nameLabel.topPos);
    //最新版本的相对布局可以让子视图的位置设置为某些视图位置中的最大或者最小值，也就是极限值，我们可以对一个数组调用扩展分类的方法myMaxPos或者myMinPos来获取
    //到数组中元素的最大或者最小位置值。使用最大最小值的前提是在计算当前位置的约束时，要求数组中的元素的约束都是已经计算好了的，否则得到的结果是未可知，就如本例中
    //在计算dateLabel的右边距时，detailLabel以及nameLabel的右边距都是已经计算好了的。
    dateLabel.rightPos.equalTo(@[detailLabel.rightPos, nameLabel.rightPos.detach(-1 *(40+dateLabel.frame.size.width))].myMaxPos);
    
    return rootLayout;
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

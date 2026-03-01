//
//  FLLTest10ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "FLLTest10ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLLTest10ViewController ()

@property(nonatomic, strong) MyFlowLayout *rootLayout;

@property(nonatomic, strong) MyFlowLayout *vertLayout;
@property(nonatomic, strong) UILabel *linesLabel1;

@property(nonatomic, strong) MyFlowLayout *horzLayout;
@property(nonatomic, strong) UILabel *linesLabel2;


@end

@implementation FLLTest10ViewController

-(void)loadView
{
    /*
       这个例子主要用于演示流式布局中的maxLines属性和arrangedLines属性的用法。这两个属性可以用来限制流式布局最大显示的行数。
     然后我们通过按钮操作来取消这种行数限制。
     
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    rootLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    rootLayout.subviewSpacing = 5;
    self.view = rootLayout;
    self.view.backgroundColor = [UIColor whiteColor];
    self.rootLayout = rootLayout;
    
    [self createVertLayout:rootLayout];
    
    [self createHorzLayout:rootLayout];
  
}

-(void)createVertLayout:(MyFlowLayout*)rootLayout
{
    UILabel *label = [UILabel new];
    label.text = @"下面是一个垂直尺寸限制流式布局";
    label.weight = 1.0;
    label.myHeight = 40;
    [rootLayout addSubview:label];
    
    UIButton *addButon = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButon addTarget:self action:@selector(handleVertLayoutItemAdd:) forControlEvents:UIControlEventTouchUpInside];
    [addButon setTitle:@"Add" forState:UIControlStateNormal];
    [rootLayout addSubview:addButon];
    addButon.weight = 0.5;   //两个按钮的比重为1表明平分宽度。
    addButon.myHeight = 40;
    
    UIButton *removeButon = [UIButton buttonWithType:UIButtonTypeSystem];
    [removeButon addTarget:self action:@selector(handleVertLayoutItemRemove:) forControlEvents:UIControlEventTouchUpInside];
    [removeButon setTitle:@"Remove" forState:UIControlStateNormal];
    [rootLayout addSubview:removeButon];
    removeButon.weight = 1.0;
    removeButon.myHeight = 40;
    
    UILabel *linesLabel = [UILabel new];
    linesLabel.text = @"当前行数:0，最大显示行数：4";
    linesLabel.myHeight = 20;
    linesLabel.widthSize.equalTo(rootLayout.widthSize).add(-45);
    self.linesLabel1 = linesLabel;
    [rootLayout addSubview:linesLabel];
    
    UIButton *showMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showMoreButton addTarget:self action:@selector(handleVertLayoutItemShowMore:) forControlEvents:UIControlEventTouchUpInside];
    [showMoreButton setTitle:@"🔽" forState:UIControlStateNormal];
    [rootLayout addSubview:showMoreButton];
    showMoreButton.myWidth = 40;
    showMoreButton.myHeight = 20;
    
    
    MyFlowLayout *vertContentLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    [rootLayout addSubview:vertContentLayout];
    vertContentLayout.weight = 1.0;
    vertContentLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    vertContentLayout.subviewSpacing = 20;
    vertContentLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    vertContentLayout.maxLines = 4;
    vertContentLayout.clipsToBounds = YES;
    vertContentLayout.backgroundColor = [UIColor lightGrayColor];
    self.vertLayout = vertContentLayout;
    
}

-(void)createHorzLayout:(MyFlowLayout*)rootLayout
{
    UILabel *label = [UILabel new];
    label.text = @"下面是一个水平尺寸限制流式布局";
    label.weight = 1.0;
    label.myHeight = 40;
    [rootLayout addSubview:label];
    
    UIButton *addButon = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButon addTarget:self action:@selector(handleHorzLayoutItemAdd:) forControlEvents:UIControlEventTouchUpInside];
    [addButon setTitle:@"Add" forState:UIControlStateNormal];
    [rootLayout addSubview:addButon];
    addButon.weight = 0.5;   //两个按钮的比重为1表明平分宽度。
    addButon.myHeight = 40;
    
    UIButton *removeButon = [UIButton buttonWithType:UIButtonTypeSystem];
    [removeButon addTarget:self action:@selector(handleHorzLayoutItemRemove:) forControlEvents:UIControlEventTouchUpInside];
    [removeButon setTitle:@"Remove" forState:UIControlStateNormal];
    [rootLayout addSubview:removeButon];
    removeButon.weight = 1.0;
    removeButon.myHeight = 40;
    
    UILabel *linesLabel = [UILabel new];
    linesLabel.text = @"当前行数:0，最大显示行数：3";
    linesLabel.myHeight = 20;
    linesLabel.widthSize.equalTo(rootLayout.widthSize).add(-45);
    self.linesLabel2 = linesLabel;
    [rootLayout addSubview:linesLabel];
    
    UIButton *showMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showMoreButton addTarget:self action:@selector(handleHorzLayoutItemShowMore:) forControlEvents:UIControlEventTouchUpInside];
    [showMoreButton setTitle:@"▶️" forState:UIControlStateNormal];
    [rootLayout addSubview:showMoreButton];
    showMoreButton.myWidth = 40;
    showMoreButton.myHeight = 20;
    
    
    MyFlowLayout *horzLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:3];
    [rootLayout addSubview:horzLayout];
    horzLayout.widthSize.equalTo(@(MyLayoutSize.wrap)).uBound(rootLayout.widthSize,-10,1);
    horzLayout.heightSize.equalTo(@(300));
    horzLayout.subviewSpacing = 20;
    horzLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    horzLayout.maxLines = 3;
    horzLayout.clipsToBounds = YES;
    horzLayout.backgroundColor = [UIColor lightGrayColor];
    self.horzLayout = horzLayout;
    horzLayout.tag = 100;
    rootLayout.tag = 200;
    self.vertLayout.tag = 300;
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

#pragma mark -- Handler

-(void)handleVertLayoutItemAdd:(id)sender
{
    //这里子视图不需要设置任何宽高约束。
    UILabel *itemView = [UILabel new];
    itemView.backgroundColor = [CFTool color:arc4random_uniform(14) + 1];
    itemView.text = [NSString stringWithFormat:@"%ld", self.vertLayout.subviews.count];
    itemView.textAlignment = NSTextAlignmentCenter;
    itemView.myWidth = arc4random_uniform(90) + 20;
    itemView.myHeight = arc4random_uniform(20) + 20;
    [self.vertLayout addSubview:itemView];
    
    __weak typeof(self) weakSelf = self;
    self.vertLayout.endLayoutBlock = ^{
        weakSelf.linesLabel1.text = [NSString stringWithFormat:@"当前行数：%ld，最大显示行数：%ld", weakSelf.vertLayout.arrangedLines, weakSelf.vertLayout.maxLines];
    };
    

}

-(void)handleVertLayoutItemRemove:(id)sender
{
    [self.vertLayout.subviews.lastObject removeFromSuperview];
    
    __weak typeof(self) weakSelf = self;
    self.vertLayout.endLayoutBlock = ^{
        weakSelf.linesLabel1.text = [NSString stringWithFormat:@"当前行数：%ld，最大显示行数：%ld", weakSelf.vertLayout.arrangedLines, weakSelf.vertLayout.maxLines];
    };
    
}

-(void)handleVertLayoutItemShowMore:(UIButton *)sender
{
    if (self.vertLayout.maxLines != NSIntegerMax) {
       self.vertLayout.maxLines = NSIntegerMax;
      [sender setTitle:@"🔼" forState:UIControlStateNormal];
        
    } else {
        self.vertLayout.maxLines = 4;
        [sender setTitle:@"🔽" forState:UIControlStateNormal];
    }
    
    //因为vertLayout会放大缩小而且有动画效果，同时整体的下面部分会往上移，所以除了自身动画外，父视图也要同时动画。你可以试试分别注释下面两行代码看效果。
    [self.vertLayout layoutAnimationWithDuration:0.3];
    [self.rootLayout layoutAnimationWithDuration:0.3];
    
    self.linesLabel1.text = [NSString stringWithFormat:@"当前行数：%ld，最大显示行数：%ld", self.vertLayout.arrangedLines, self.vertLayout.maxLines];
}


-(void)handleHorzLayoutItemAdd:(id)sender
{
    //这里子视图不需要设置任何宽高约束。
    UILabel *itemView = [UILabel new];
    itemView.backgroundColor = [CFTool color:arc4random_uniform(14) + 1];
    itemView.text = [NSString stringWithFormat:@"%ld", self.horzLayout.subviews.count];
    itemView.textAlignment = NSTextAlignmentCenter;
    itemView.myWidth = arc4random_uniform(20) + 20;
    itemView.myHeight = arc4random_uniform(80) + 10;
    [self.horzLayout addSubview:itemView];
    
    __weak typeof(self) weakSelf = self;
    self.horzLayout.endLayoutBlock = ^{
        weakSelf.linesLabel2.text = [NSString stringWithFormat:@"当前行数：%ld，最大显示行数：%ld", weakSelf.horzLayout.arrangedLines, weakSelf.horzLayout.maxLines];
    };
    

}

-(void)handleHorzLayoutItemRemove:(id)sender
{
    [self.horzLayout.subviews.lastObject removeFromSuperview];
    
    __weak typeof(self) weakSelf = self;
    self.horzLayout.endLayoutBlock = ^{
        weakSelf.linesLabel2.text = [NSString stringWithFormat:@"当前行数：%ld，最大显示行数：%ld", weakSelf.horzLayout.arrangedLines, weakSelf.horzLayout.maxLines];
    };
    
}

-(void)handleHorzLayoutItemShowMore:(UIButton *)sender
{
    if (self.horzLayout.maxLines != NSIntegerMax) {
       self.horzLayout.maxLines = NSIntegerMax;
      [sender setTitle:@"◀️" forState:UIControlStateNormal];
        
    } else {
        self.horzLayout.maxLines = 3;
        [sender setTitle:@"▶️" forState:UIControlStateNormal];
    }
    
    //因为vertLayout会放大缩小而且有动画效果，同时整体的下面部分会往上移，所以除了自身动画外，父视图也要同时动画。你可以试试分别注释下面两行代码看效果。
    [self.horzLayout layoutAnimationWithDuration:0.3];
    [self.rootLayout layoutAnimationWithDuration:0.3];
    
    self.linesLabel2.text = [NSString stringWithFormat:@"当前行数：%ld，最大显示行数：%ld", self.horzLayout.arrangedLines, self.horzLayout.maxLines];
}

@end

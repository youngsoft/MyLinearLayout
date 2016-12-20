//
//  RLTest5ViewController.m
//  MyLayout
//
//  Created by oybq on 16/12/19.
//  Copyright (c) 2016年 YoungSoft. All rights reserved.
//

#import "RLTest5ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface RLTest5ViewController ()<UIScrollViewDelegate>




@end

@implementation RLTest5ViewController


-(void)loadView
{
    /*
        本例子是要用来介绍在相对布局中的子视图可以使用MyLayoutPos对象的uBound,lBound设置来实现最大和最小边界约束。
     */
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.leftPos.equalTo(@0);
    rootLayout.rightPos.equalTo(@0);
    rootLayout.wrapContentHeight = YES;
    rootLayout.subviewMargin = 10;
    [scrollView addSubview:rootLayout];
    
    //最小最大间距限制例子。segment的简易实现。
    [self createDemo1:rootLayout];
    
    //右边边距限制的例子。
    [self createDemo2:rootLayout];

    //左边边距限制和上下边距限制的例子。
    [self createDemo3:rootLayout];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleButtonSelect:(UIButton*)button
{
    if (button.isSelected)
        return;
    
    MyRelativeLayout *containerLayout = (MyRelativeLayout*)button.superview;
    
    UIButton *leftButton = [containerLayout viewWithTag:1];
    UIButton *rightButton = [containerLayout viewWithTag:2];
    UIView  *underLineView = [containerLayout viewWithTag:3];
    
    NSInteger tag = button.tag;
    leftButton.selected = (tag == 1);
    rightButton.selected = (tag == 2);
    
    //调整underLineView的位置。
    underLineView.leftPos.equalTo(button.leftPos);
    underLineView.widthDime.equalTo(button.widthDime);
    
    
    [containerLayout layoutAnimationWithDuration:0.3];
    
}

-(void)createDemo1:(UIView*)rootLayout
{
    /*
       本例子实现一个带动画效果的segment的简单实现。只有在相对布局中的子视图才支持使用MyLayoutPos中的lBound和uBound方法。
       通过这个方法能设置视图的最小和最大的边距。
     */
    
    MyRelativeLayout *containerLayout = [MyRelativeLayout new];
    containerLayout.leftPos.equalTo(rootLayout.leftPos);
    containerLayout.rightPos.equalTo(rootLayout.rightPos);
    containerLayout.wrapContentHeight = YES;
    containerLayout.topPadding = 6;
    containerLayout.bottomPadding = 6;
    containerLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:containerLayout];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"Left button" forState:UIControlStateNormal];
    [leftButton setTitleColor:[CFTool color:4] forState:UIControlStateNormal];
    [leftButton setTitleColor:[CFTool color:7] forState:UIControlStateSelected];
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(handleButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit]; //根据内容得到高度和宽度
    leftButton.leftPos.lBound(containerLayout.leftPos, 0);  //左边最小边距是父视图左边偏移0
    leftButton.rightPos.uBound(containerLayout.centerXPos, 0); //右边最大的边距是父视图中心点偏移0
    //在相对布局中可以不设置左右边距而是设置最小和最大的左右边距，可以让子视图在指定的范围内居中，并且如果宽度超过最小和最大的边距设定时会自动压缩子视图的宽度。
    [containerLayout addSubview:leftButton];
    leftButton.selected = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"Right button" forState:UIControlStateNormal];
    [rightButton setTitleColor:[CFTool color:4] forState:UIControlStateNormal];
    [rightButton setTitleColor:[CFTool color:7] forState:UIControlStateSelected];
    rightButton.tag = 2;
    [rightButton addTarget:self action:@selector(handleButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit]; //根据内容得到高度和宽度
    rightButton.leftPos.lBound(containerLayout.centerXPos, 0); //左边最小边距是父视图中心点偏移0
    rightButton.rightPos.uBound(containerLayout.rightPos, 0);   //右边最大边距是父视图右边偏移0
    //在相对布局中可以不设置左右边距而是设置最小和最大的左右边距，可以让子视图在指定的范围内居中，并且如果宽度超过最小和最大的边距设定时会自动压缩子视图的宽度。
    [containerLayout addSubview:rightButton];
    
    
    //添加下划线视图。
    UIView *underLineView = [UIView new];
    underLineView.backgroundColor = [CFTool color:7];
    underLineView.tag = 3;
    underLineView.heightDime.equalTo(@1);
    underLineView.widthDime.equalTo(leftButton.widthDime);
    underLineView.leftPos.equalTo(leftButton.leftPos);
    underLineView.topPos.equalTo(leftButton.bottomPos).offset(6);
    [containerLayout addSubview:underLineView];
    

}


-(void)createDemo2:(UIView*)rootLayout
{
    /*
       这个例子通常用于UITableViewCell中的某些元素的最大尺寸的限制，您可以横竖屏切换，看看效果。
     */
    
    MyRelativeLayout *containerLayout = [MyRelativeLayout new];
    containerLayout.leftPos.equalTo(rootLayout.leftPos);
    containerLayout.rightPos.equalTo(rootLayout.rightPos);
    containerLayout.wrapContentHeight = YES;
    containerLayout.padding = UIEdgeInsetsMake(6, 6, 6, 6);
    containerLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:containerLayout];
    
    
    NSArray *images = @[@"minions1",@"minions2",@"minions3",@"minions4"];
    NSArray *texts = @[@"test text1",
                       @"test text1 test text2",
                       @"test text1 test text2 test text3 test text4",
                       @"test text1 test text2 test text3 test text4 test text5"];
    
    NSArray *rightTexts =  @[@"100.00",@"1000.00",@"10000.00",@"100000.00"];
    
    for (int i = 0; i < images.count; i++)
    {
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[arc4random()%4]]];
        leftImageView.topPos.equalTo(@(90*i));
        [containerLayout addSubview:leftImageView];
        
        UILabel *flexedLabel = [UILabel new];
        flexedLabel.text = texts[arc4random()%4];
        flexedLabel.font = [CFTool font:17];
        flexedLabel.textColor = [CFTool color:4];
        flexedLabel.lineBreakMode = NSLineBreakByCharWrapping;
        flexedLabel.numberOfLines = 0;
        flexedLabel.flexedHeight = YES;   //高度自动计算。
        flexedLabel.leftPos.equalTo(leftImageView.rightPos).offset(5);  //左边等于leftImageView的右边
        flexedLabel.topPos.equalTo(leftImageView.topPos);  //顶部和leftImageView相等。
        [containerLayout addSubview:flexedLabel];
        
        UIImageView *editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
        editImageView.leftPos.equalTo(flexedLabel.rightPos);  //这个图片总是跟随在flexedLabel的后面。
        editImageView.topPos.equalTo(leftImageView.topPos).offset(4);
        [containerLayout addSubview:editImageView];
        
        UILabel *rightLabel = [UILabel new];
        rightLabel.text = rightTexts[arc4random()%4];
        rightLabel.font = [CFTool font:15];
        rightLabel.textColor = [CFTool color:7];
        [rightLabel sizeToFit];
        rightLabel.rightPos.equalTo(containerLayout.rightPos);  //右边等于父视图的右边，也就是现实在最右边。
        rightLabel.topPos.equalTo(leftImageView.topPos).offset(4);
        [containerLayout addSubview:rightLabel];
        
        flexedLabel.widthDime.equalTo(flexedLabel.widthDime); //宽度等于自身的宽度
        flexedLabel.rightPos.uBound(rightLabel.leftPos, editImageView.frame.size.width + 10); //右边的最大的边界就等于rightLabel的最左边再减去editImageView的尺寸外加上10,这里的10是视图之间的间距，为了让视图之间保持有足够的边距。这样当flexedLabel的宽度超过这个最大的右边界时，系统自动会缩小flexedLabel的宽度，以便来满足右边界的限制。 这个场景非常适合某个UITableViewCell里面的两个子视图之间有尺寸长度约束的情况。
        
        
    }
    
    
}


-(void)handleClick:(UITapGestureRecognizer*)sender
{
    UILabel *label = (UILabel*)sender.view;
    NSString *text = label.text;
    label.text = [text stringByAppendingString:@"+++"];
    
    [label.superview setNeedsLayout];
    
}

-(void)createDemo3:(UIView*)rootLayout
{
    /*
      这个例子用来了解上下边距的约束和左边边距的约束的场景。这些约束的设置特别适合那些有尺寸依赖以及位置依赖的UITableViewCell的场景。
     */
     
    
    MyRelativeLayout *containerLayout = [MyRelativeLayout new];
    containerLayout.leftPos.equalTo(rootLayout.leftPos);
    containerLayout.rightPos.equalTo(rootLayout.rightPos);
    containerLayout.heightDime.equalTo(@150);
    containerLayout.padding = UIEdgeInsetsMake(6, 6, 6, 6);
    containerLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:containerLayout];
    
    
    //左边文字居中并且根据内容变化。
    UILabel *leftLabel = [UILabel new];
    leftLabel.backgroundColor = [CFTool color:5];
    leftLabel.text = @"Click me:";
    leftLabel.textColor = [CFTool color:4];
    leftLabel.numberOfLines = 0;
    leftLabel.widthDime.equalTo(@100);  //宽度固定为100
    leftLabel.flexedHeight = YES;       //高度由子视图的内容确定，自动计算高度。
    leftLabel.topPos.lBound(containerLayout.topPos,0);   //最小的顶部位置是父布局的顶部。
    leftLabel.bottomPos.uBound(containerLayout.bottomPos, 0);  //最大的底部位置是父布局的底部
    //通过这两个位置的最小最大约束，视图leftLabel将会在这个范围内居中，并且当高度超过这个约束时，会自动的压缩子视图的高度。
    [containerLayout addSubview:leftLabel];
    
    //添加手势处理。
    UITapGestureRecognizer *leftLabelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClick:)];
    leftLabel.userInteractionEnabled = YES;
    [leftLabel addGestureRecognizer:leftLabelTapGesture];
    
    
    
    //右边按钮
    UILabel *rightLabel = [UILabel new];
    rightLabel.backgroundColor = [CFTool color:6];
    rightLabel.text = @"Click me:";
    rightLabel.textColor = [CFTool color:4];
    rightLabel.numberOfLines = 0;
    rightLabel.rightPos.equalTo(containerLayout.rightPos);  //和父布局视图右对齐。
    rightLabel.centerYPos.equalTo(leftLabel.centerYPos);   //和左边视图垂直居中对齐。
    rightLabel.leftPos.lBound(leftLabel.rightPos, 10);     //右边视图的最小左间距是等于左边视图的右边偏移10，这样当右边视图的宽度超过这个最小间距时则会自动压缩视图的宽度。
    rightLabel.widthDime.equalTo(rightLabel.widthDime);    //宽度等于自身的宽度。这个设置和上面的leftPos.lBound方法配合使用实现子视图宽度的压缩。
    rightLabel.flexedHeight = YES;  //高度动态调整
    rightLabel.heightDime.uBound(containerLayout.heightDime, 0, 1); //但是最大的高度等于父布局视图的高度(注意这里内部自动减去了padding的值)
    [containerLayout addSubview:rightLabel];
    
    //添加手势处理。
    UITapGestureRecognizer *rightLabelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClick:)];
    rightLabel.userInteractionEnabled = YES;
    [rightLabel addGestureRecognizer:rightLabelTapGesture];

    
    
    
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

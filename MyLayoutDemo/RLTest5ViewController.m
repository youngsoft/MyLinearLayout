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
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.leadingPos.equalTo(@0);
    rootLayout.trailingPos.equalTo(@0);
    rootLayout.wrapContentHeight = YES;
    rootLayout.subviewVSpace = 10;
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
    
    UIButton *leadingButton = [containerLayout viewWithTag:1];
    UIButton *trailingButton = [containerLayout viewWithTag:2];
    UIView  *underLineView = [containerLayout viewWithTag:3];
    
    NSInteger tag = button.tag;
    leadingButton.selected = (tag == 1);
    trailingButton.selected = (tag == 2);
    
    //调整underLineView的位置。
    underLineView.leadingPos.equalTo(button.leadingPos);
    underLineView.widthSize.equalTo(button.widthSize);
    
    
    [containerLayout layoutAnimationWithDuration:0.3];
    
}

-(void)createDemo1:(UIView*)rootLayout
{
    /*
       本例子实现一个带动画效果的segment的简单实现。只有在相对布局中的子视图的MyLayoutPos位置对象才支持lBound和uBound方法。
       通过这个方法能设置子视图的最小和最大的边界值。
     */
    
    MyRelativeLayout *containerLayout = [MyRelativeLayout new];
    containerLayout.leadingPos.equalTo(rootLayout.leadingPos);
    containerLayout.trailingPos.equalTo(rootLayout.trailingPos);
    containerLayout.wrapContentHeight = YES;
    containerLayout.topPadding = 6;
    containerLayout.bottomPadding = 6;
    containerLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:containerLayout];
    
    UIButton *leadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leadingButton setTitle:@"Leading Button" forState:UIControlStateNormal];
    [leadingButton setTitleColor:[CFTool color:4] forState:UIControlStateNormal];
    [leadingButton setTitleColor:[CFTool color:7] forState:UIControlStateSelected];
    leadingButton.tag = 1;
    [leadingButton addTarget:self action:@selector(handleButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [leadingButton sizeToFit]; //根据内容得到高度和宽度
    leadingButton.leadingPos.lBound(containerLayout.leadingPos, 0);  //左边最小边界是父视图左边偏移0
    leadingButton.trailingPos.uBound(containerLayout.centerXPos, 0); //右边最大的边界是父视图中心点偏移0
    //在相对布局中子视图可以不设置左右边距而是设置最小和最大的边界值，就可以让子视图在指定的边界范围内居中，并且如果宽度超过最小和最大的边界设定时会自动压缩子视图的宽度。在这个例子中leadingButton始终在父视图的左边和父视图的水平中心这个边界内居中显示。
    [containerLayout addSubview:leadingButton];
    leadingButton.selected = YES;
    
    UIButton *trailingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [trailingButton setTitle:@"Trailing Button" forState:UIControlStateNormal];
    [trailingButton setTitleColor:[CFTool color:4] forState:UIControlStateNormal];
    [trailingButton setTitleColor:[CFTool color:7] forState:UIControlStateSelected];
    trailingButton.tag = 2;
    [trailingButton addTarget:self action:@selector(handleButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [trailingButton sizeToFit]; //根据内容得到高度和宽度
    trailingButton.leadingPos.lBound(containerLayout.centerXPos, 0); //左边最小边界是父视图中心点偏移0
    trailingButton.trailingPos.uBound(containerLayout.trailingPos, 0);   //右边最大边界是父视图右边偏移0
    //在相对布局中子视图可以不设置左右边距而是设置最小和最大的边界值，就可以让子视图在指定的边界范围内居中，并且如果宽度超过最小和最大的边界设定时会自动压缩子视图的宽度。在这个例子中trailingButton始终在父视图的水平中心和父视图的右边这个边界内居中显示。
    [containerLayout addSubview:trailingButton];
    
    
    //添加下划线视图。
    UIView *underLineView = [UIView new];
    underLineView.backgroundColor = [CFTool color:7];
    underLineView.tag = 3;
    underLineView.heightSize.equalTo(@1);
    underLineView.widthSize.equalTo(leadingButton.widthSize);
    underLineView.leadingPos.equalTo(leadingButton.leadingPos);
    underLineView.topPos.equalTo(leadingButton.bottomPos).offset(6);
    [containerLayout addSubview:underLineView];
    

}


-(void)createDemo2:(UIView*)rootLayout
{
    /*
       这个例子通常用于UITableViewCell中的某些元素的最大尺寸的限制，您可以横竖屏切换，看看效果。
       对于某些布局场景中，某个子视图的尺寸是不确定的，因此你不能设置一个固定的值，同时这个尺寸又不能无限制的延生而会受到某些边界的约束控制。因此可以用如下的方法来进行视图的尺寸设置。
     */
    
    MyRelativeLayout *containerLayout = [MyRelativeLayout new];
    containerLayout.leadingPos.equalTo(rootLayout.leadingPos);
    containerLayout.trailingPos.equalTo(rootLayout.trailingPos);
    containerLayout.wrapContentHeight = YES;
    containerLayout.padding = UIEdgeInsetsMake(6, 6, 6, 6);
    containerLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:containerLayout];
    
    /*
      这个例子中，水平方向一共有leadingImageView,flexedLabel,editImageView,trailingLabel四个子视图水平排列。其中leadingImageView在最左边且宽度固定，flexedLabel则跟在leadingImageView的右边但是宽度是不确定的，editImageView则是跟在flexedLabel的后面宽度是固定的，trailingLabel则总是在屏幕的右边且宽度是固定的，但是其中的flexedLabel的宽度最宽不能无限制的延生，且不能和trailingLabel进行重叠。
     */
    
    NSArray *images = @[@"minions1",@"minions2",@"minions3",@"minions4"];
    NSArray *texts = @[@"这是一段很长的文本，目的是为了实现最大限度的利用整个空间而不出现多余的缝隙",
                       @"您好",
                       @"北京市朝阳区三里屯SOHO城",
                       @"我是醉里挑灯看键",
                       @"欧阳大哥",
                       @"MyLayout是一套功能强大的综合界面布局库"];
    
    NSArray *trailingTexts =  @[@"100.00",@"1000.00",@"10000.00",@"100000.00"];
    
    for (int i = 0; i < images.count; i++)
    {
        UIImageView *leadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[arc4random()%4]]];
        leadingImageView.topPos.equalTo(@(90*i));
        [containerLayout addSubview:leadingImageView];
        
        UILabel *flexedLabel = [UILabel new];
        flexedLabel.text = texts[arc4random()%6];
        flexedLabel.font = [CFTool font:17];
        flexedLabel.textColor = [CFTool color:4];
        flexedLabel.lineBreakMode = NSLineBreakByCharWrapping;
        flexedLabel.wrapContentHeight = YES;   //高度自动计算。
        flexedLabel.leadingPos.equalTo(leadingImageView.trailingPos).offset(5);  //左边等于leadingImageView的右边
        flexedLabel.topPos.equalTo(leadingImageView.topPos);  //顶部和leadingImageView相等。
        [containerLayout addSubview:flexedLabel];
        
        UIImageView *editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
        editImageView.leadingPos.equalTo(flexedLabel.trailingPos);  //这个图片总是跟随在flexedLabel的后面。
        editImageView.topPos.equalTo(leadingImageView.topPos).offset(4);
        [containerLayout addSubview:editImageView];
        
        UILabel *trailingLabel = [UILabel new];
        trailingLabel.text = trailingTexts[arc4random()%4];
        trailingLabel.font = [CFTool font:15];
        trailingLabel.textColor = [CFTool color:7];
        [trailingLabel sizeToFit]; //尺寸固定。
        trailingLabel.trailingPos.equalTo(containerLayout.trailingPos);  //右边等于父视图的右边，也就是现实在最右边。
        trailingLabel.topPos.equalTo(leadingImageView.topPos).offset(4);
        [containerLayout addSubview:trailingLabel];
        
        flexedLabel.widthSize.equalTo(flexedLabel.widthSize); //宽度等于自身的宽度
        flexedLabel.trailingPos.uBound(trailingLabel.leadingPos, editImageView.frame.size.width + 10); //右边的最大的边界就等于trailingLabel的最左边再减去editImageView的尺寸外加上10,这里的10是视图之间的间距，为了让视图之间保持有足够的间距。这样当flexedLabel的宽度超过这个最大的右边界时，系统自动会缩小flexedLabel的宽度，以便来满足右边界的限制。 这个场景非常适合某个UITableViewCell里面的两个子视图之间有尺寸长度约束的情况。
        
        
    }
    
    
}


-(void)handleClick:(UITapGestureRecognizer*)sender
{
    UILabel *label = (UILabel*)sender.view;
    NSString *text = label.text;
    label.text = [text stringByAppendingString:@"+++"];
    
}

-(void)createDemo3:(UIView*)rootLayout
{
    /*
      这个例子用来了解上下边距的约束和左边边距的约束的场景。这些约束的设置特别适合那些有尺寸依赖以及位置依赖的UITableViewCell的场景。
     */
     
    
    MyRelativeLayout *containerLayout = [MyRelativeLayout new];
    containerLayout.leadingPos.equalTo(rootLayout.leadingPos);
    containerLayout.trailingPos.equalTo(rootLayout.trailingPos);
    containerLayout.heightSize.equalTo(@150);
    containerLayout.padding = UIEdgeInsetsMake(6, 6, 6, 6);
    containerLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:containerLayout];
    
    
    //左边文字居中并且根据内容变化。
    UILabel *leadingLabel = [UILabel new];
    leadingLabel.backgroundColor = [CFTool color:5];
    leadingLabel.text = @"Click me:";
    leadingLabel.textColor = [CFTool color:4];
    leadingLabel.widthSize.equalTo(@100);  //宽度固定为100
    leadingLabel.wrapContentHeight = YES;       //高度由子视图的内容确定，自动计算高度。
    leadingLabel.topPos.lBound(containerLayout.topPos,0);   //最小的上边界是父布局的顶部。
    leadingLabel.bottomPos.uBound(containerLayout.bottomPos, 0);  //最大的下边界是父布局的底部
    //通过这两个位置的最小最大边界设置，视图leadingLabel将会在这个范围内垂直居中显示，并且当高度超过这个边界时，会自动的压缩子视图的高度。
    [containerLayout addSubview:leadingLabel];
    
    //添加手势处理。
    UITapGestureRecognizer *leadingLabelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClick:)];
    leadingLabel.userInteractionEnabled = YES;
    [leadingLabel addGestureRecognizer:leadingLabelTapGesture];
    
    
    
    //右边按钮
    UILabel *trailingLabel = [UILabel new];
    trailingLabel.backgroundColor = [CFTool color:6];
    trailingLabel.text = @"Click me:";
    trailingLabel.textColor = [CFTool color:4];
    trailingLabel.trailingPos.equalTo(containerLayout.trailingPos);  //和父布局视图右对齐。
    trailingLabel.centerYPos.equalTo(leadingLabel.centerYPos);   //和左边视图垂直居中对齐。
    trailingLabel.leadingPos.lBound(leadingLabel.trailingPos, 10);     //右边视图的最小边界是等于左边视图的右边再偏移10，这样当右边视图的宽度超过这个最小边界时则会自动压缩视图的宽度。
    trailingLabel.widthSize.equalTo(trailingLabel.widthSize);    //宽度等于自身的宽度。这个设置和上面的leadingPos.lBound方法配合使用实现子视图宽度的压缩。
    trailingLabel.wrapContentHeight = YES;  //高度动态调整
    trailingLabel.heightSize.uBound(containerLayout.heightSize, 0, 1); //但是最大的高度等于父布局视图的高度(注意这里内部自动减去了padding的值)
    [containerLayout addSubview:trailingLabel];
    
    //添加手势处理。
    UITapGestureRecognizer *trailingLabelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClick:)];
    trailingLabel.userInteractionEnabled = YES;
    [trailingLabel addGestureRecognizer:trailingLabelTapGesture];

    
    
    
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

//
//  Test15ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "AllTest4ViewController.h"
#import "MyLayout.h"

typedef enum : NSUInteger {
    ItemType_LinearLayout,
    ItemType_RelativeLayout,
    ItemType_FrameLayout,
    ItemType_TableLayout,
    ItemType_FlowLayout
} ItemType;


@interface AllTest4ViewController ()<UITextViewDelegate>


@property(nonatomic,assign) ItemType currentItemType;

@property(nonatomic,strong) MyLinearLayout *rootLayout;
@property(nonatomic,strong) MyLinearLayout *contentLayout;

@end

@implementation AllTest4ViewController

#pragma mark -- MyLinearLayout

-(MyLinearLayout*)createLinearItemLayout:(NSString*)leftTitle rightTitle:(NSString*)rightTitle
{
    MyLinearLayout *itemLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_HORZ];
    itemLayout.wrapContentWidth = NO;
    itemLayout.gravity = MGRAVITY_VERT_CENTER;
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = leftTitle;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.rightMargin = 0.5;
    [leftLabel sizeToFit];
    [itemLayout addSubview:leftLabel];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = rightTitle;
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.leftMargin = 0.5;
    [rightLabel sizeToFit];
    [itemLayout addSubview:rightLabel];
    
    return itemLayout;
}

-(MyLinearLayout*)createLinearLayout
{
    MyLinearLayout *linearLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    linearLayout.subviewMargin = 5;
    linearLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    //第一行
    NSArray *titleArray = @[@"左1",@"右1",@"左2",@"右2",@"左3",@"右3",@"左4",@"右4",@"左5",@"右5"];
    
    
    for (int i = 0; i < 2; i++)
    {
        MyLinearLayout *lineLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_HORZ];
        lineLayout.leftMargin = lineLayout.rightMargin = 0;
        lineLayout.wrapContentWidth = NO;
        lineLayout.subviewMargin = 5;
        lineLayout.wrapContentHeight = YES;
        
        UIView *itemView1 = [self createItemLayout:titleArray[i*4] rightTitle:titleArray[i*4+1]];
        itemView1.weight = 1;
        [lineLayout addSubview:itemView1];
        
        UIView *itemView2 = [self createItemLayout:titleArray[i*4 + 2] rightTitle:titleArray[i*4+3]];
        itemView2.weight = 1;
        [lineLayout addSubview:itemView2];
        
        [linearLayout addSubview:lineLayout];
    }
    
    UIView *itemView1 = [self createItemLayout:titleArray[8] rightTitle:titleArray[9]];
    itemView1.widthDime.equalTo(linearLayout.widthDime).multiply(0.5).add(-2.5);
    [linearLayout addSubview:itemView1];
    
    
    return linearLayout;
}



#pragma mark -- MyRelativeLayout

-(MyRelativeLayout*)createRelativeItemLayout:(NSString*)leftTitle rightTitle:(NSString*)rightTitle
{
    MyRelativeLayout *itemLayout = [MyRelativeLayout new];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = leftTitle;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.leftMargin = 0;
    leftLabel.centerYOffset = 0;
    [leftLabel sizeToFit];
    [itemLayout addSubview:leftLabel];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = rightTitle;
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.rightMargin = 0;
    rightLabel.centerYOffset = 0;
    [rightLabel sizeToFit];
    [itemLayout addSubview:rightLabel];
    
    return itemLayout;

}

-(MyRelativeLayout*)createRelativeLayout
{
    MyRelativeLayout *relativeLayout = [MyRelativeLayout new];
    relativeLayout.wrapContentHeight = YES;
    relativeLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    
    NSArray *titleArray = @[@"左1",@"右1",@"左2",@"右2",@"左3",@"右3",@"左4",@"右4",@"左5",@"右5"];
    
    UIView *item1 = [self createItemLayout:titleArray[0] rightTitle:titleArray[1]];
    [relativeLayout addSubview:item1];
    UIView *item2 = [self createItemLayout:titleArray[2] rightTitle:titleArray[3]];
    [relativeLayout addSubview:item2];
    UIView *item3 = [self createItemLayout:titleArray[4] rightTitle:titleArray[5]];
    [relativeLayout addSubview:item3];
    UIView *item4 = [self createItemLayout:titleArray[6] rightTitle:titleArray[7]];
    [relativeLayout addSubview:item4];
    UIView *item5 = [self createItemLayout:titleArray[8] rightTitle:titleArray[9]];
    [relativeLayout addSubview:item5];
    
    
    item1.topPos.equalTo(relativeLayout.topPos);
    item1.leftPos.equalTo(relativeLayout.leftPos);
    
    item1.widthDime.equalTo(@[item2.widthDime.add(-2.5)]).add(-2.5);
    item2.leftPos.equalTo(item1.rightPos).offset(5);
    item2.topPos.equalTo(item1.topPos);
    
    
    item3.topPos.equalTo(item1.bottomPos).offset(5);
    item3.leftPos.equalTo(relativeLayout.leftPos);
    
    item3.widthDime.equalTo(@[item4.widthDime.add(-2.5)]).add(-2.5);
    item4.leftPos.equalTo(item3.rightPos).offset(5);
    item4.topPos.equalTo(item3.topPos);
    
    
    item5.topPos.equalTo(item3.bottomPos).offset(5);
    item5.leftPos.equalTo(relativeLayout.leftPos);
    item5.widthDime.equalTo(relativeLayout.widthDime).multiply(0.5).add(-2.5);
    
    
    
    return relativeLayout;
}


#pragma mark -- MyFrameLayout


-(MyFrameLayout*)createFrameItemLayout:(NSString*)leftTitle rightTitle:(NSString*)rightTitle
{
    MyFrameLayout *itemLayout = [MyFrameLayout new];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = leftTitle;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.marginGravity = MGRAVITY_VERT_CENTER | MGRAVITY_HORZ_LEFT;
    [leftLabel sizeToFit];
    [itemLayout addSubview:leftLabel];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = rightTitle;
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.marginGravity = MGRAVITY_VERT_CENTER | MGRAVITY_HORZ_RIGHT;
    [rightLabel sizeToFit];
    [itemLayout addSubview:rightLabel];

    
    return itemLayout;

}

-(MyFrameLayout*)createFrameLayout
{
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    frameLayout.height = 4 *5 + 30 *3; //框架布局不支持由子视图决定高度和宽度
    
    NSArray *titleArray = @[@"左1",@"右1",@"左2",@"右2",@"左3",@"右3",@"左4",@"右4",@"左5",@"右5"];
    
    UIView *item1 = [self createItemLayout:titleArray[0] rightTitle:titleArray[1]];
    [frameLayout addSubview:item1];
    UIView *item2 = [self createItemLayout:titleArray[2] rightTitle:titleArray[3]];
    [frameLayout addSubview:item2];
    UIView *item3 = [self createItemLayout:titleArray[4] rightTitle:titleArray[5]];
    [frameLayout addSubview:item3];
    UIView *item4 = [self createItemLayout:titleArray[6] rightTitle:titleArray[7]];
    [frameLayout addSubview:item4];
    UIView *item5 = [self createItemLayout:titleArray[8] rightTitle:titleArray[9]];
    [frameLayout addSubview:item5];
    
    //注意这里减去7.5的原因是因为框架布局计算宽度时不会扣除掉padding的值。
    item1.marginGravity = MGRAVITY_HORZ_LEFT | MGRAVITY_VERT_TOP;
    item1.widthDime.equalTo(frameLayout.widthDime).multiply(0.5).add(-2.5);
    
    item2.marginGravity = MGRAVITY_HORZ_RIGHT |MGRAVITY_VERT_TOP;
    item2.widthDime.equalTo(frameLayout.widthDime).multiply(0.5).add(-2.5);
    
    item3.marginGravity = MGRAVITY_HORZ_LEFT |MGRAVITY_VERT_CENTER;
    item3.widthDime.equalTo(frameLayout.widthDime).multiply(0.5).add(-2.5);
    
    item4.marginGravity = MGRAVITY_HORZ_RIGHT |MGRAVITY_VERT_CENTER;
    item4.widthDime.equalTo(frameLayout.widthDime).multiply(0.5).add(-2.5);
    
    item5.marginGravity = MGRAVITY_HORZ_LEFT |MGRAVITY_VERT_BOTTOM;
    item5.widthDime.equalTo(frameLayout.widthDime).multiply(0.5).add(-2.5);
    
    
    return frameLayout;
}


#pragma mark -- MyTableLayout

-(MyTableLayout*)createTableItemLayout:(NSString*)leftTitle rightTitle:(NSString*)rightTitle
{
    MyTableLayout *itemLayout = [MyTableLayout tableLayoutWithOrientation:LVORIENTATION_VERT];
    itemLayout.gravity = MGRAVITY_VERT_CENTER;
    
    [itemLayout addRow:MTLROWHEIGHT_WRAPCONTENT colWidth:MTLCOLWIDTH_AVERAGE];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = leftTitle;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [leftLabel sizeToFit];
    [itemLayout addSubview:leftLabel];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = rightTitle;
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel sizeToFit];
    [itemLayout addSubview:rightLabel];

    
    return itemLayout;
}

-(MyTableLayout*)createTableLayout
{
    MyTableLayout *tableLayout = [MyTableLayout tableLayoutWithOrientation:LVORIENTATION_VERT];
    tableLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    tableLayout.subviewMargin = 5;
    
    
    NSArray *titleArray = @[@"左1",@"右1",@"左2",@"右2",@"左3",@"右3",@"左4",@"右4",@"左5",@"右5"];
    
    for (int i = 0; i < 2; i++)
    {
        [tableLayout addRow:MTLROWHEIGHT_WRAPCONTENT colWidth:MTLCOLWIDTH_AVERAGE];
        [tableLayout viewAtRowIndex:i].subviewMargin = 5;
        [tableLayout addSubview:[self createItemLayout:titleArray[i*4] rightTitle:titleArray[i*4 + 1]]];
        [tableLayout addSubview:[self createItemLayout:titleArray[i*4 + 2] rightTitle:titleArray[i*4 + 3]]];
    }
    
    [tableLayout addRow:MTLROWHEIGHT_WRAPCONTENT colWidth:MTLCOLWIDTH_AVERAGE];
    UIView *itemView = [self createItemLayout:titleArray[8] rightTitle:titleArray[9] ];
    [tableLayout addSubview:itemView];
    itemView.weight = 0.5;
    itemView.rightPos.equalTo(@0.5).offset(5);
    
    return tableLayout;
}


#pragma mark -- MyFlowLayout

-(MyFlowLayout*)createFlowItemLayout:(NSString*)leftTitle rightTitle:(NSString*)rightTitle
{
    MyFlowLayout *itemLayout = [MyFlowLayout flowLayoutWithOrientation:LVORIENTATION_VERT arrangedCount:2];
    itemLayout.averageArrange = YES;
    itemLayout.gravity = MGRAVITY_VERT_CENTER;
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = leftTitle;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [leftLabel sizeToFit];
    [itemLayout addSubview:leftLabel];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = rightTitle;
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel sizeToFit];
    [itemLayout addSubview:rightLabel];
    
    return itemLayout;
}

-(MyFlowLayout*)createFlowLayout
{
    MyFlowLayout *flowLayout = [MyFlowLayout flowLayoutWithOrientation:LVORIENTATION_VERT arrangedCount:2];
    flowLayout.padding = UIEdgeInsetsMake(5,5,5,5);
    flowLayout.subviewHorzMargin = 5;
    flowLayout.subviewVertMargin = 5;
    flowLayout.averageArrange = YES;
    
    NSArray *titleArray = @[@"左1",@"右1",@"左2",@"右2",@"左3",@"右3",@"左4",@"右4",@"左5",@"右5"];
    
    for (int i = 0; i < 5; i++)
    {
        [flowLayout addSubview:[self createItemLayout:titleArray[i*2] rightTitle:titleArray[i*2+1]]];
    }
    
    return flowLayout;
    
}



-(MyLayoutBase*)createItemLayout:(NSString*)leftTitle rightTitle:(NSString*)rightTitle
{
    //创建一个左右条目的布局，高度固定为50，而宽度则随父视图决定，里面的子视图垂直居中
    //下面用各种布局实现同一个功能。
    MyLayoutBase *itemLayout = nil;
    
    if (self.currentItemType == ItemType_LinearLayout)
    {
        itemLayout = [self createLinearItemLayout:leftTitle rightTitle:rightTitle];
        itemLayout.backgroundColor = [UIColor redColor];
    }
    else if (self.currentItemType == ItemType_RelativeLayout)
    {
        itemLayout = [self createRelativeItemLayout:leftTitle rightTitle:rightTitle];
        itemLayout.backgroundColor = [UIColor greenColor];
    }
    else if (self.currentItemType == ItemType_FrameLayout)
    {
        itemLayout = [self createFrameItemLayout:leftTitle rightTitle:rightTitle];
        itemLayout.backgroundColor = [UIColor yellowColor];
    }
    else if (self.currentItemType == ItemType_TableLayout)
    {
        itemLayout = [self createTableItemLayout:leftTitle rightTitle:rightTitle];
        itemLayout.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        itemLayout = [self createFlowItemLayout:leftTitle rightTitle:rightTitle];
        itemLayout.backgroundColor = [UIColor cyanColor];
    }
    
    itemLayout.height = 30;
    itemLayout.layer.borderColor = [UIColor blueColor].CGColor;
    itemLayout.layer.borderWidth = 1;
    
    return itemLayout;
    
}

-(MyLinearLayout*)createContentLayout
{
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    contentLayout.leftMargin = self.contentLayout.rightMargin = 0;
    contentLayout.gravity = MGRAVITY_HORZ_FILL;
    
    //线性布局实现功能。
    UILabel *linearLayoutLabel = [UILabel new];
    linearLayoutLabel.text = @"线性布局实现功能";
    [linearLayoutLabel sizeToFit];
    linearLayoutLabel.topMargin = 5;
    [contentLayout addSubview:linearLayoutLabel];
    MyLayoutBase *linearLayout = [self createLinearLayout];
    linearLayout.wrapContentHeight = YES;
    linearLayout.backgroundColor = [UIColor grayColor];
    [contentLayout addSubview:linearLayout];
    
    //相对布局实现功能。
    UILabel *relativeLayoutLabel = [UILabel new];
    relativeLayoutLabel.text = @"相对布局实现功能";
    [relativeLayoutLabel sizeToFit];
    relativeLayoutLabel.topMargin = 5;
    [contentLayout addSubview:relativeLayoutLabel];
    MyLayoutBase *relativeLayout = [self createRelativeLayout];
    relativeLayout.wrapContentHeight = YES;
    relativeLayout.backgroundColor = [UIColor grayColor];
    [contentLayout addSubview:relativeLayout];
    
    //表格布局实现功能。
    UILabel *tableLayoutLabel = [UILabel new];
    tableLayoutLabel.text = @"表格布局实现功能";
    [tableLayoutLabel sizeToFit];
    tableLayoutLabel.topMargin = 5;
    [contentLayout addSubview:tableLayoutLabel];
    MyLayoutBase *tableLayout = [self createTableLayout];
    tableLayout.wrapContentHeight = YES;
    tableLayout.backgroundColor = [UIColor grayColor];
    [contentLayout addSubview:tableLayout];
    
    //流式布局实现功能
    UILabel *flowLayoutLabel = [UILabel new];
    flowLayoutLabel.text = @"流式布局实现功能";
    [flowLayoutLabel sizeToFit];
    flowLayoutLabel.topMargin = 5;
    [contentLayout addSubview:flowLayoutLabel];
    MyLayoutBase *flowLayout = [self createFlowLayout];
    flowLayout.wrapContentHeight = YES;
    flowLayout.backgroundColor = [UIColor grayColor];
    [contentLayout addSubview:flowLayout];
    
    //框架布局
    UILabel *frameLayoutLabel = [UILabel new];
    frameLayoutLabel.text = @"框架布局实现功能";
    [frameLayoutLabel sizeToFit];
    frameLayoutLabel.topMargin = 5;
    [contentLayout addSubview:frameLayoutLabel];
    MyFrameLayout *frameLayout = [self createFrameLayout];
    frameLayout.wrapContentHeight = YES;
    frameLayout.backgroundColor = [UIColor grayColor];
    [contentLayout addSubview:frameLayout];
    
    return contentLayout;

}

-(void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    
    self.rootLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    self.rootLayout.leftMargin = self.rootLayout.rightMargin = 0;
    self.rootLayout.gravity = MGRAVITY_HORZ_FILL;
    [scrollView addSubview:self.rootLayout];
    
    
    //创建动作布局
    UILabel *actionLabel = [UILabel new];
    actionLabel.text = @"子条目视图的布局实现";
    [actionLabel sizeToFit];
    [self.rootLayout addSubview:actionLabel];
    MyFlowLayout *actionLayout = [MyFlowLayout flowLayoutWithOrientation:LVORIENTATION_VERT arrangedCount:3];
    actionLayout.backgroundColor = [UIColor redColor];
    actionLayout.averageArrange = YES;
    actionLayout.wrapContentHeight = YES;
    actionLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    actionLayout.subviewHorzMargin = 5;
    actionLayout.subviewVertMargin = 5;
    [self.rootLayout addSubview:actionLayout];
    
    NSArray *arrayAction = @[@"线性布局",@"相对布局",@"框架布局",@"表格布局",@"流式布局"];
    NSArray *arrayColor = @[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor cyanColor]];
    
    for (int i = 0; i < arrayAction.count; i++)
    {
        UIButton *button = [UIButton new];
        [button setTitle:arrayAction[i] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor greenColor].CGColor;
        button.layer.borderWidth = 1;
        button.backgroundColor = arrayColor[i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        button.height = 40;
        [actionLayout addSubview:button];
    }
    
    self.contentLayout = [self createContentLayout];
    [self.rootLayout addSubview:self.contentLayout];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"五种布局实现同一个功能";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- HandleMethod

-(void)handleAction:(UIButton*)button
{
    self.currentItemType = button.tag;
    [self.contentLayout removeFromSuperview];
    self.contentLayout = [self createContentLayout];
    [self.rootLayout addSubview:self.contentLayout];
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

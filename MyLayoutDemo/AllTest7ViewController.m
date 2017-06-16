//
//  AllTest7ViewController.m
//  MyLayout
//
//  Created by apple on 16/10/21.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "AllTest7ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface AllTest7ViewController ()

@end

@implementation AllTest7ViewController

-(void) loadView
{
    /**
     * 这个例子主要是用线性布局来实现一些在各种屏幕尺寸下内容适配的场景，通过各种属性的设置，我们可以不需要写if，else等判断屏幕的条件，而是直接根据属性来设置就能达到我们想要的效果，并且能在各种屏幕尺寸以及横竖屏下的具有完美适配的能力。下面的8个例子是在实践中会遇到的一些需要适配的场景。
     */
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.myHorzMargin = 0;
    rootLayout.gravity = MyGravity_Horz_Fill;
    rootLayout.heightSize.lBound(scrollView.heightSize, 0, 1);
    [scrollView addSubview:rootLayout];
    
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"在编程中，我们经常会遇到一些需要在各种屏幕下完美适配的界面，一个解决的方法就是写if else语句在不同的屏幕尺寸下进行不同的设置。而MyLayout则提供了一套完美的解决方案，除了支持SizeClass外，布局本身也提供一些机制来支持多种屏幕适配处理，您不再需要编写各种条件语句来进行屏幕尺寸的适配了，下面的例子里面我列举出了我们在实践中会遇到的9种场景：";
    tipLabel.font = [CFTool font:16];
    tipLabel.textColor = [CFTool color:3];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    [self createDemo1:rootLayout];
   
    [self createDemo2:rootLayout];

    [self createDemo3:rootLayout];
    
    [self createDemo4:rootLayout];
    
    [self createDemo5:rootLayout];
    
    [self createDemo6:rootLayout];
    
    [self createDemo7:rootLayout];
    
    [self createDemo8:rootLayout];

    [self createDemo9:rootLayout];

    [self createDemo10:rootLayout];
    
    [self createDemo11:rootLayout];

    
}


-(void)createDemo1:(MyLinearLayout*)rootLayout
{
     //一行内，多个子视图从左往右排列。如果在小屏幕下显示则会压缩所有子视图的空间，如果能够被容纳的话则正常显示。
     //具体的实现方法是用一个水平线性布局来做容器，然后子视图依次添加，然后最后一个子视图的右间距设置为浮动间距即可。因为线性布局内部对于那些有浮动间距的情况下，如果那些固定尺寸的子视图的总宽度超过布局视图的宽度时就会自动压缩这些固定尺寸的子视图。
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"1.下面的例子实现一行内多个子视图从左往右排列。如果在小屏幕下显示则会压缩所有子视图的空间，如果能够被容纳的话则正常显示。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.wrapContentWidth = NO;
    contentLayout.wrapContentHeight = YES;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewHSpace = 5;
    contentLayout.shrinkType = MySubviewsShrink_Weight; //这个属性用来设置当子视图的总尺寸大于布局视图的尺寸时如何压缩这些具有固定尺寸的方法为按比例缩小。您可以分别试试设置为：MySubviewsShrink_Weight，MySubviewsShrink_Average,MySubviewsShrink_None，MySubviewsShrink_Auto四种值的效果。

    contentLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:contentLayout];
    
    //第一个子视图。
    UILabel *label1 = [UILabel new];
    label1.text = @"不压缩子视图";
    label1.font = [CFTool font:16];
    label1.backgroundColor = [CFTool color:5];
    label1.adjustsFontSizeToFitWidth = YES;
    label1.wrapContentSize = YES; //尺寸等于视图的内容包裹。
    label1.widthSize.lBound(label1.widthSize,0,1); //并且最小宽度也等于自己，这样设置的话可以保证这个视图永远不会被压缩。您可以注释掉这句看看效果。
    [contentLayout addSubview:label1];
    
    //第二个子视图。
    UILabel *label2 = [UILabel new];
    label2.text = @"被压缩子视图";
    label2.font = [CFTool font:16];
    label2.backgroundColor = [CFTool color:6];
    label2.adjustsFontSizeToFitWidth = YES;
    label2.wrapContentSize = YES; //尺寸等于自身的内容
    label2.numberOfLines = 1; //如果你只想要一行，那么要记得在设置包裹后设置行数。。
    [contentLayout addSubview:label2];

    //第三个子视图。
    UILabel *label3 = [UILabel new];
    label3.text = @"您可以分别在各种设备上测试";
    label3.font = [CFTool font:15];
    label3.backgroundColor = [CFTool color:7];
    label3.adjustsFontSizeToFitWidth = YES;
    label3.wrapContentSize = YES;
    [contentLayout addSubview:label3];
    label3.myTrailing = 0.5;  //这句设置非常重要，设置为右间距为相对间距，从而达到如果屏幕小则会缩小固定尺寸，如果大则不会的效果。

}

-(void)createDemo2:(MyLinearLayout*)rootLayout
{
    //一行内某一个子视图内容拉升其他内容固定。也就是某个子视图的内容将占用剩余的空间。
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"2.下面的例子里面最右边的两个子视图的宽度是固定的，而第一个子视图则占用剩余的空间。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.wrapContentWidth = NO;
    contentLayout.wrapContentHeight = YES;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewHSpace = 5;
    contentLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:contentLayout];
    
    //第一个子视图。
    UILabel *label1 = [UILabel new];
    label1.text = @"第一个子视图的宽度是占用整个屏幕的剩余空间，您可以切换屏幕和设备查看效果";
    label1.font = [CFTool font:15];
    label1.backgroundColor = [CFTool color:5];
    label1.adjustsFontSizeToFitWidth = YES;
    [label1 sizeToFit];
    label1.wrapContentHeight = YES; //自动换行。
    label1.weight = 1;  //占用剩余的空间。
    [contentLayout addSubview:label1];
    
    //第二个子视图。
    UILabel *label2 = [UILabel new];
    label2.text = @"第二个子视图";
    label2.font = [CFTool font:15];
    label2.backgroundColor = [CFTool color:6];
    [label2 sizeToFit];
    [contentLayout addSubview:label2];
    
    //第三个子视图。
    UILabel *label3 = [UILabel new];
    label3.text = @"第三个子视图";
    label3.font = [CFTool font:15];
    label3.backgroundColor = [CFTool color:7];
    [label3 sizeToFit];
    [contentLayout addSubview:label3];
}


-(void)handleAdd:(UIButton*)sender
{
    UILabel *label1 = [sender.superview viewWithTag:1000];
    
    label1.text = [label1.text stringByAppendingString:@"/您好！"];
    
}

-(void)handleDel:(UIButton*)sender
{
    UILabel *label1 = [sender.superview viewWithTag:1000];
    
    label1.text =  [label1.text stringByDeletingLastPathComponent];

}

-(void)createDemo3:(MyLinearLayout*)rootLayout
{
    //某一些子视图的宽度固定，而剩余的一个子视图的宽度最宽不能超过屏幕的宽度。
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"3.下面的例子里面最右边的两个子视图的宽度是固定的，而第一个子视图的尺寸动态变化，但是最宽不能超过布局剩余的宽度。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上分别测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.wrapContentWidth = NO;
    contentLayout.wrapContentHeight = YES;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewHSpace = 5;
    contentLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:contentLayout];
    
    //第一个子视图。
    UILabel *label1 = [UILabel new];
    label1.text = @"点击右边的按钮：";
    label1.font = [CFTool font:14];
    label1.backgroundColor = [CFTool color:5];
    label1.tag = 1000; //为了测试用。。
    label1.wrapContentSize = YES;   //尺寸由内容包裹
    label1.myTrailing = 0.5;  //设置相对间距
    [contentLayout addSubview:label1];
    
    //第二个子视图。
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Add Click" forState:UIControlStateNormal];
    button2.tintColor = [UIColor blueColor];
    button2.titleLabel.font = [CFTool font:14];
    [button2 sizeToFit];
    button2.myLeading = 0.5;  //设置相对间距。
    [contentLayout addSubview:button2];
    [button2 addTarget:self action:@selector(handleAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    //第三个子视图。
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"Del Click" forState:UIControlStateNormal];
    button3.tintColor = [UIColor redColor];
    button3.titleLabel.font = [CFTool font:14];
    [button3 sizeToFit];
    [contentLayout addSubview:button3];
    [button3 addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];

    
    //因为button2,和button3的宽度是固定的，因此这里面label1的最大宽是父视图的宽度减去2个按钮的宽度之和，外加上所有子视图的间距的和。
    label1.widthSize.uBound(contentLayout.widthSize, -1 *(CGRectGetWidth(button2.bounds) + CGRectGetWidth(button3.bounds) + 2 * contentLayout.subviewHSpace), 1);
}



-(void)handleChangeText:(UIButton*)sender
{
    
    NSArray *texts = @[@"这是一段很长的文本，目的是为了实现最大限度的利用整个空间而不出现多余的缝隙",@"您好",@"北京市朝阳区三里屯SOHO城",@"我是醉里挑灯看键",@"欧阳大哥",@"MyLayout是一套功能强大的综合界面布局库"];
    
    
    MyLinearLayout *layout = [sender.superview viewWithTag:4000];
    UILabel *leadingLabel = [layout viewWithTag:1000];
    UILabel *trailingLabel = [layout viewWithTag:2000];
    
    
    leadingLabel.text = texts[arc4random_uniform((uint32_t)texts.count)];
    trailingLabel.text = texts[arc4random_uniform((uint32_t)texts.count)];
    
}


-(void)createDemo4:(MyLinearLayout*)rootLayout
{
    //左右两个子视图宽度不确定，但是不会覆盖和重叠。
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"4.下面的例子展示左右2个子视图的内容分别向两边延伸，但是不会重叠。这样做的好处就是不会产生空间的浪费。一个具体例子就是UITableviewCell中展示内容时，一部分在左边而一部分在右边，两边的内容长度都不确定，但是不能重叠以及浪费空间。 您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [changeButton setTitle:@"Change Text" forState:UIControlStateNormal];
    [changeButton sizeToFit];
    [rootLayout addSubview:changeButton];
    [changeButton addTarget:self action:@selector(handleChangeText:) forControlEvents:UIControlEventTouchUpInside];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.wrapContentWidth = NO;
    contentLayout.wrapContentHeight = YES;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewHSpace = 20;
    contentLayout.shrinkType = MySubviewsShrink_Auto;  //为了实现左右两边文本的自动缩放调整，必须要将线性布局的属性设置MySubviewsShrink_Auto。当设置为Auto属性时，必要要满足当前子视图中只有2个子视图的宽度设置为等于自身内容，否则无效。这个属性用来实现左右2个子视图根据内容来占用最佳的空间的例子。
    contentLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:contentLayout];
    contentLayout.tag = 4000;  //为了方便查找。
    
    //您可以解开如下注释再看看运行的效果。
    /*
    UILabel *fixedLabel = [UILabel new];
    fixedLabel.myWidth = 40;
    fixedLabel.myHeight = 30;
    fixedLabel.backgroundColor = [UIColor orangeColor];
    [contentLayout addSubview:fixedLabel];
     */
     
    //左边子视图。
    UILabel *leadingLabel = [UILabel new];
    leadingLabel.font = [UIFont systemFontOfSize:14];
    leadingLabel.textColor = [UIColor redColor];
    leadingLabel.wrapContentSize = YES;
    leadingLabel.trailingPos.equalTo(@0.5); //设置右边的相对间距.
    [contentLayout addSubview:leadingLabel];
    leadingLabel.tag = 1000;

    
    //右边子视图。
    UILabel *trailingLabel = [UILabel new];
    trailingLabel.font = [UIFont systemFontOfSize:14];
    trailingLabel.textColor = [UIColor blueColor];
    trailingLabel.wrapContentSize = YES;
    trailingLabel.leadingPos.equalTo(@0.5); //设置右边的相对间距.
    [contentLayout addSubview:trailingLabel];
    trailingLabel.tag = 2000;

    
    
    [self handleChangeText:changeButton];
    
}



/*
 * 下面这个DEMO实现子视图之间的间距压缩，来达到最完美的适配。
 */

-(void)handleAddButton:(UIButton*)sender
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.layer.cornerRadius = 6;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [CFTool color:5].CGColor;
    [button setTitle:@"Del" forState:UIControlStateNormal];
    button.tintColor = [CFTool color:0];
    button.backgroundColor = [CFTool color:2];
    [button addTarget:self action:@selector(handleDelButton:) forControlEvents:UIControlEventTouchDownRepeat];
    button.myHeight = 40;
    [sender.superview addSubview:button];

}

-(void)handleDelButton:(UIButton*)sender
{
    [sender removeFromSuperview];
}

-(void)createDemo5:(MyLinearLayout*)rootLayout
{
    //一行内添加多个视图，并在子视图具有固定宽度的情况下，将子视图之间的间距调整为最优，以便最完美的放置子视图。
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"5.下面的例子中(响应式布局！！)，您可以添加按钮来添加多个按钮形成多行多列的布局。在不同的屏幕尺寸下，子视图之间的间距会自动调整以便满足最佳的布局状态。比如多个子视图有规律排列，每个子视图的宽度是固定的，在iPhone4下以及iPhone6下都能放置4个子视图，但是iPhone4中子视图之间的间距要比iPhone6上的小，而在iPhone6+上则因为空间足够可以放置5个子视图。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    CGFloat subviewWidth = 60;  //您可以修改这个宽度值，可以看出不管宽度设置多大都能完美的填充整个屏幕，因为系统会自动调整子视图之间的间距。
    
    MyFlowLayout *contentLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    contentLayout.backgroundColor = [CFTool color:0];
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.wrapContentHeight = YES;
    contentLayout.subviewVSpace = 5; //设置流式布局里面子视图之间的垂直间距。
    [contentLayout setSubviewsSize:subviewWidth minSpace:5 maxSpace:10];  //这里面水平间距用浮动间距，浮动间距设置为子视图固定宽度为60，最小的间距为5,最大间距为10。注意这里要求所有子视图的宽度都是60。
    [rootLayout addSubview:contentLayout];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.layer.cornerRadius = 6;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [CFTool color:6].CGColor;
    [button setTitle:@"Add" forState:UIControlStateNormal];
    button.backgroundColor = [CFTool color:1];
    button.tintColor = [CFTool color:0];
    [button  addTarget:self action:@selector(handleAddButton:) forControlEvents:UIControlEventTouchUpInside];
    button.myHeight = 30; //上面设置了宽度为60，所以这里不再需要设置宽度了。
    [contentLayout addSubview:button];


}

/*
 * 下面这个DEMO实现子视图之间的尺寸压缩，来达到最完美的适配。
 */

-(void)handleAddCell:(UIButton*)sender
{
    //在创建时指定了6000.所以这里为了方便使用。
    MyTableLayout *tableLayout = (MyTableLayout*)[sender.superview viewWithTag:6000];
    
    UILabel *cellLabel = [UILabel new];
    cellLabel.text =@"测试文本";
    cellLabel.adjustsFontSizeToFitWidth = YES;
    cellLabel.font = [CFTool font:15];
    cellLabel.backgroundColor = [CFTool color:random()%14 + 1];
    cellLabel.myWidth = 80;  //宽度是80
    cellLabel.myTrailing = 0.1;  //右间距占用剩余的空间，这里设置为 0 < myTrailing < 1 的结果都是一样的。这样子视图总是会往左边靠拢。
    [cellLabel sizeToFit];
    
    
    //如果还没有行则建立第一行，这里的行高是由子视图决定，而列宽则是和表格视图保持一致，但是子视图还需要设置单元格的宽度。
    if (tableLayout.countOfRow == 0)
    {
        //这里设置shrinkType的作用是当子视图的尺寸不被容纳时自动缩小子视图的宽度
        [tableLayout addRow:MTLSIZE_WRAPCONTENT colSize:MTLSIZE_MATCHPARENT].shrinkType = MySubviewsShrink_Average;
    }
    
    /*
       取到最后一行的最后一个单元格视图。
     */
    UIView *lastView = nil;
    NSInteger lastRowIndex = tableLayout.countOfRow - 1;
    if ([tableLayout countOfColInRow:lastRowIndex] > 0)
    {
        lastView = [tableLayout viewAtIndexPath:[NSIndexPath indexPathForCol:[tableLayout countOfColInRow:lastRowIndex] - 1 inRow:lastRowIndex]];
    }
    
    //如果有最后一个单元格视图。那么判断这个单元格视图的宽度是不是小于40，如果是则新建立一行。这样当一行内所有的单元格的宽度都小于40时就会自动换行。
    if (lastView != nil)
    {
        if (CGRectGetWidth(lastView.bounds) <= 60)
        {
            //这里设置shrinkType的作用是当子视图的尺寸不被容纳时自动缩小子视图的宽度
            [tableLayout addRow:MTLSIZE_WRAPCONTENT colSize:MTLSIZE_MATCHPARENT].shrinkType = MySubviewsShrink_Average;
        }
        else
        {
            lastView.myTrailing = 0;  //因为新添加的单元格视图的右边是相对间距，也就是占用剩余空间，因此这里要把最后一个单元的右间距设置为0，这样就不会造成有多个单元格的右间距占用剩余空间。注意理解一下这里的设置！！！。
        }
    }
    
    
    [tableLayout addSubview:cellLabel];  //表格布局重载了addSubview，他总是在最后一行上添加新的单元格。
    
}

-(void)createDemo6:(MyLinearLayout*)rootLayout
{
    //一行多列，然后压缩每个子视图的宽度，压缩到某个阈值后再换行。。
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"6.下面的例子用来实现子视图依次从左往右添加，并且当空间不够时会自动压缩前面的所有子视图的宽度。而当所有子视图的宽度都到达了最小的阈值时就会自动换行，并继续添加上去。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上分别测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton setTitle:@"Add Cell" forState:UIControlStateNormal];
    [addButton sizeToFit];
    [rootLayout addSubview:addButton];
    [addButton addTarget:self action:@selector(handleAddCell:) forControlEvents:UIControlEventTouchUpInside];

    MyTableLayout *contentLayout = [MyTableLayout tableLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewVSpace = 5;
    contentLayout.subviewHSpace = 5;  //设置行间距和列间距都为5.
    contentLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:contentLayout];
    
    contentLayout.tag = 6000; //为了方便查找。
    
}


-(void)createDemo7:(MyLinearLayout*)rootLayout
{
    //多行多列，里面的子视图根据屏幕的尺寸智能的排列。
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"7.下面的例子里面有多个宽度不一致的子视图，但是布局会根据屏幕的大小而智能的排列这些子视图，从而充分的利用好布局视图的空间。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上分别测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    
    MyFlowLayout *contentLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    contentLayout.wrapContentHeight = YES;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewSpace = 5;
    contentLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:contentLayout];
    
    contentLayout.autoArrange = YES;  //自动排列，布局视图会根据里面子视图的尺寸进行智能的排列。
    contentLayout.gravity = MyGravity_Horz_Fill;  //对于内容填充流式布局来说会拉升所有子视图的尺寸，以便铺满整个布局视图。
        
    //添加N个长短不一的子视图。
    for (int i = 0; i < 15; i++)
    {
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%02d",i];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.myWidth = random() % 150 + 20; //最宽170，最小20.
        label.myHeight = 30;
        label.backgroundColor = [UIColor colorWithRed:random()%256 / 255.0 green:random()%256 / 255.0 blue:random()%256 / 255.0 alpha:1];
        [contentLayout addSubview:label];
    }
    
}



-(void)createDemo8:(MyLinearLayout*)rootLayout
{
    //一行内，如果屏幕尺寸足够宽则左边的视图居左，中间的视图居中，右边的视图居右，如果宽度不够宽则产生滚动效果。
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"8.下面的例子中如果屏幕足够宽则左边视图居左，中间视图居中，右边视图居右。这时候不会产生滚动，而当屏幕宽度不足时则会压缩中间视图和两边视图之间的间距并且产生滚动效果。这样的例子也可以同样应用在纵向屏幕中：通常在大屏幕设备上中间的部分要居中显示，而在小屏幕上则依次排列产生滚动效果。 您可以分别在iPhone4/5/6/6+上以及横竖屏测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.myHeight = 60;
    [rootLayout addSubview:scrollView];
    
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.backgroundColor = [CFTool color:0];
    contentLayout.myTop = 0;
    contentLayout.myBottom = 0;
    contentLayout.gravity = MyGravity_Vert_Fill;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewHSpace = 5;
    contentLayout.widthSize.lBound(scrollView.widthSize,0,1); //默认水平线性布局的宽度是wrapContentWidth的但是最小的宽度和父视图相等，这样对于一些大尺寸屏幕因为能够容纳内容而不会产生滚动。
    [scrollView addSubview:contentLayout];
    
    
    //第一个子视图。
    UILabel *label1 = [UILabel new];
    label1.text = @"左边的子视图";
    label1.font = [CFTool font:15];
    label1.backgroundColor = [CFTool color:5];
    [label1 sizeToFit];
    [contentLayout addSubview:label1];
    
    //第二个子视图。
    UILabel *label2 = [UILabel new];
    label2.text = @"中间稍微长一点的子视图";
    label2.font = [CFTool font:15];
    label2.backgroundColor = [CFTool color:6];
    [label2 sizeToFit];
    //中间视图的左边间距是0.5,右边间距是0.5。表明中间视图的左右间距占用剩余的空间而达到居中的效果。这样在屏幕尺寸足够时则会产生居中效果，而屏幕尺寸不足时则会缩小间距，但是这里面最左边的最小间距是0而最右边的最小间距是30，这样布局视图因为具有wrapContentWidth属性所以会扩充宽度而达到滚动的效果。
    label2.leadingPos.equalTo(@0.5).min(0);
    label2.trailingPos.equalTo(@0.5).min(30);
    [contentLayout addSubview:label2];
    
    //第三个子视图。
    UILabel *label3 = [UILabel new];
    label3.text = @"右边的子视图";
    label3.font = [CFTool font:15];
    label3.backgroundColor = [CFTool color:7];
    [label3 sizeToFit];
    [contentLayout addSubview:label3];
    
    
}

-(void)createDemo9:(MyLinearLayout*)rootLayout
{
    //一行内，如果最后的子视图能够被容纳在屏幕中则放到最右边，如果不能容纳则会产生滚动。
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"9.下面的例子中最右边的视图如果能够被屏幕容纳则放在最右边，否则就会产生滚动效果。这个例子同样也可以应用在纵向屏幕中:很多页面里面最下边需要放一个按钮，如果屏幕尺寸够高则总是放在最底部，如果屏幕尺寸不够则会产生滚动效果。 您可以分别在iPhone4/5/6/6+上以及横竖屏测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.myHeight = 60;
    [rootLayout addSubview:scrollView];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.backgroundColor = [CFTool color:0];
    contentLayout.myTop = 0;
    contentLayout.myBottom = 0;
    contentLayout.gravity = MyGravity_Vert_Fill;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.subviewHSpace = 5;
    contentLayout.widthSize.lBound(scrollView.widthSize,0,1); //默认水平线性布局的宽度是wrapContentWidth的但是最小的宽度和父视图相等，这样对于一些大尺寸屏幕因为能够容纳内容而不会产生滚动。
    [scrollView addSubview:contentLayout];
    
    
    //第一个子视图。
    UILabel *label1 = [UILabel new];
    label1.text = @"第一个视图";
    label1.font = [CFTool font:15];
    label1.backgroundColor = [CFTool color:5];
    [label1 sizeToFit];
    [contentLayout addSubview:label1];
    
    //第二个子视图。
    UILabel *label2 = [UILabel new];
    label2.text = @"第二个子视图的内容稍微长一点";
    label2.font = [CFTool font:15];
    label2.backgroundColor = [CFTool color:6];
    [label2 sizeToFit];
    [contentLayout addSubview:label2];
    
    //第三个子视图。
    UILabel *label3 = [UILabel new];
    label3.text = @"第三个";
    label3.font = [CFTool font:15];
    label3.backgroundColor = [CFTool color:7];
    [label3 sizeToFit];
    label3.leadingPos.equalTo(@0.5).min(30); //最后一个视图的左边距占用剩余的空间，但是最低不能小于30。这样设置的意义是如果布局视图够宽则第三个子视图的左边间距是剩余的空间，这样就保证了第三个子视图总是在最右边。而如果剩余空间不够时，则因为这里最小的宽度是30，而布局视图又是wrapContentWidth,所以就会扩充布局视图的宽度，而产生滚动效果。这里的最小值30很重要，也就是第三个子视图和其他子视图的最小间距，具体设置多少就要看UI的界面效果图了。
    [contentLayout addSubview:label3];
    
}

-(UILabel*)createLabel:(NSString*)title color:(NSInteger)idx
{
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [CFTool font:15];
    label.backgroundColor = [CFTool color:idx];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    [label sizeToFit];
    
    return label;
}


-(void)createDemo10:(MyLinearLayout*)rootLayout
{
    //一行内所有的子视图的宽度都按屏幕的尺寸来进行按比例的拉伸和缩放。
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"10.下面的例子中展示了一行中各个子视图的宽度和间距都将根据屏幕的尺寸来进行拉伸和收缩，这样不管在任何尺寸的屏幕下都能达到完美的适配。在实践中UI人员往往会按某个设备的尺寸给出一张效果图，那么我们只需要按这个效果图中的子视图的宽度来计算好所占用的宽度和间距的比例，然后我们通过对视图的宽度和间距按比例值进行设置，这样就会使得子视图的真实宽度和间距将根据屏幕的尺寸进行拉升和收缩。您可以分别在iPhone4/5/6/6+上以及横竖屏测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.wrapContentWidth = NO;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.myHeight = 60;  //高度为60.
    contentLayout.gravity = MyGravity_Vert_Center;  //内容垂直居中。
    contentLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:contentLayout];

    
    //假设我们以iPhone6的尺寸作为UI的原型。并且假设:
    /*
     1.A的宽度不管任何设备下总是固定为30；
     2.B的宽度在iphone6下是60，与A的间距是10；
     3.C的宽度在iphone6下是80，与B的间距是16；
     4.D的宽度在iPhone6下是100，与C的间距在任何设备下总是16；
     5.E的宽度不管任何设备下总是固定为40，与D的间距就是iPhone6宽度的剩余空间13(375-左右padding只和10-30-60-10-80-16-100-16)了。
     
     这种动态比例的展示非常适合用线性布局来完成，iPhone6的总宽度为375。而上面列出的总的浮动宽度部分的和：
     
     总的浮动部分的和 = B的宽度60 + 与A的间距10 + C的宽度80 + 与B的间距16 + D的宽度100 + 与D的间距13 = 279.
     因此我们对B的宽度，与A的间距，C的宽度，与B的间距，D的宽度，与D的间距这部分的值设置为比例值。而不是绝对值！
     
     这样我们设置比例值时，只要将视图在iPhone6下的尺寸值除以这个总的浮动宽度就可以得到每个子视图的相对的比例值了。
     
     */
    
    CGFloat totalFloatWidth = 60 + 10 + 80 + 16 + 100 + 13;
    
    UILabel *A = [self createLabel:@"A" color:5];
    A.myWidth = 60;   //不管任何设备固定宽度为60,高度根据内容确定。
    [contentLayout addSubview:A];
    
    UILabel *B = [self createLabel:@"B" color:6];
    B.myLeading = 10 / totalFloatWidth;  //B与A的间距，也就是左间距用浮动间距。对于线性布局来说如果间距值大于0小于1则表示是浮动间距。
    B.weight = 60 / totalFloatWidth;   //对象水平线性布局来说weight值设置的是视图的比重宽度.
    [contentLayout addSubview:B];
    
    UILabel *C  = [self createLabel:@"C" color:7];
    C.myLeading = 16 / totalFloatWidth;
    C.weight = 80 / totalFloatWidth;
    [contentLayout addSubview:C];
    
    UILabel *D = [self createLabel:@"D" color:8];
    D.myLeading = 16;  //D与C的间距是固定的16
    D.weight = 100 / totalFloatWidth;
    [contentLayout addSubview:D];
    
    UILabel *E = [self createLabel:@"E" color:9];
    E.myLeading = 13 / totalFloatWidth;
    E.myWidth = 40; //固定的宽度。
    [contentLayout addSubview:E];
    
    
}


-(void)createDemo11:(MyLinearLayout*)rootLayout
{
    //一行内的子视图的间距会根据屏幕尺寸自动缩小。
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"11.下面一个例子展示了当某个布局视图的尺寸能够容纳里面所有子视图的尺寸和间距时就按正常显示，而当尺寸不足以容纳所有子视图的尺寸和间距之和时我们就对子视图之间的间距进行压缩，以便能将所有子视图的内容都显示出来。您可以分别在iPhone4/5/6/6+上以及横竖屏测试效果:";
    tipLabel.font = [CFTool font:14];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.wrapContentHeight = YES;
    tipLabel.myTop = 10;
    [tipLabel sizeToFit];
    [rootLayout addSubview:tipLabel];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    contentLayout.wrapContentWidth = NO;
    contentLayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    contentLayout.myHeight = 60;  //高度为60.
    contentLayout.gravity = MyGravity_Vert_Center;  //内容垂直居中。
    contentLayout.backgroundColor = [CFTool color:0];
    [rootLayout addSubview:contentLayout];
    
    
    contentLayout.subviewHSpace = 50;  //默认设定固定间距为50
    contentLayout.shrinkType = MySubviewsShrink_Space | MySubviewsShrink_Average;  //当整体内容的总宽度不超过布局视图的宽度时则正常布局，当布局视图的宽度不能容纳总体宽度时，则会平均缩小子视图之间的间距以保证一行内能容纳下所有的内容。shrinkType支持压缩尺寸和压缩间距两种压缩方法，默认是压缩尺寸。你可以选择MySubviewsShrink_Size或者MySubviewsShrink_Space来指定当布局尺寸不能容纳内容时是压缩所有子视图之间的间距还是尺寸来实现完美适配。
    
    
    UILabel *A = [self createLabel:@"Objective-C" color:5];
   // A.myLeading = 80;   //您可以解注释这条语句，并将上面的shrinkType设置为MySubviewsShrink_Average或者MySubviewsShrink_Weight查看效果
    [contentLayout addSubview:A];
    
    UILabel *B = [self createLabel:@"Swift" color:6];
    [contentLayout addSubview:B];
    
    UILabel *C  = [self createLabel:@"C++" color:7];
    [contentLayout addSubview:C];
    
    UILabel *D = [self createLabel:@"JAVA" color:8];
    [contentLayout addSubview:D];
    
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

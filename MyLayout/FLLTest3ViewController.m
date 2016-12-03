//
//  FLLTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLLTest3ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLLTest3ViewController ()

@property(nonatomic, strong) MyFlowLayout *flowLayout;
@property(nonatomic, assign) NSInteger oldIndex;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign) BOOL    hasDrag;

@property(nonatomic, strong) UIButton *addButton;

@end

@implementation FLLTest3ViewController


-(void)loadView
{
    /*
       这个例子用来介绍布局视图对动画的支持，以及通过布局视图的autoresizesSubviews属性，以及子视图的扩展属性useFrame和noLayout来实现子视图布局的个性化设置。
     
     布局视图的autoresizesSubviews属性用来设置当布局视图被激发要求重新布局时，是否会对里面的所有子视图进行重新布局。
     子视图的扩展属性useFrame表示某个子视图不受布局视图的布局控制，而是用最原始的frame属性设置来实现自定义的位置和尺寸的设定。
     子视图的扩展属性noLayout表示某个子视图会参与布局，但是并不会正真的调整布局后的frame值。
     
     */
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.gravity = MyMarginGravity_Horz_Fill;  //垂直线性布局里面的子视图的宽度和布局视图一致。
    rootLayout.wrapContentWidth = NO;
    rootLayout.wrapContentHeight = NO;
    self.view = rootLayout;
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.font = [CFTool font:13];
    tipLabel.text = NSLocalizedString(@"  You can drag the following tag to adjust location in layout, MyLayout can use subview's useFrame,noLayout property and layout view's autoresizesSubviews propery to complete some position adjustment and the overall animation features: \n useFrame set to YES indicates subview is not controlled by the layout view but use its own frame to set the location and size instead.\n \n autoresizesSubviews set to NO indicate layout view will not do any layout operation, and will remain in the position and size of all subviews.\n \n noLayout set to YES indicate subview in the layout view just only take up the position and size but not real adjust the position and size when layouting.", @"");
    tipLabel.textColor = [CFTool color:4];
    tipLabel.numberOfLines = 0;
    tipLabel.flexedHeight = YES; //这两个属性结合着使用实现自动换行和文本的动态高度。
    [rootLayout addSubview:tipLabel];
    
    
    UILabel *tip2Label = [UILabel new];
    tip2Label.text = NSLocalizedString(@"double click to remove tag", @"");
    tip2Label.font = [CFTool font:13];
    tip2Label.textColor = [CFTool color:3];
    tip2Label.textAlignment = NSTextAlignmentCenter;
    tip2Label.myTopMargin = 3;
    [tip2Label sizeToFit];
    [rootLayout addSubview:tip2Label];
    
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:4];
    self.flowLayout.backgroundColor = [CFTool color:0];
    self.flowLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.flowLayout.subviewMargin = 10;   //流式布局里面的子视图的水平和垂直间距都设置为10
    self.flowLayout.gravity = MyMarginGravity_Horz_Fill;  //流式布局里面的子视图的宽度将平均分配。
    self.flowLayout.weight = 1;   //流式布局占用线性布局里面的剩余高度。
    self.flowLayout.myTopMargin = 10;
    [rootLayout addSubview:self.flowLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (NSInteger i = 0; i < 14; i++)
    {
        NSString *label = [NSString stringWithFormat:NSLocalizedString(@"drag me %ld", @""),i];
        [self.flowLayout addSubview:[self createTagButton:label]];
    }
    
    //最后添加添加按钮。
    self.addButton = [self createAddButton];
    [self.flowLayout addSubview:self.addButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Layout Construction

//创建标签按钮
-(UIButton*)createTagButton:(NSString*)text
{
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:text forState:UIControlStateNormal];
    tagButton.titleLabel.font = [CFTool font:14];
    tagButton.layer.cornerRadius = 20;
    tagButton.backgroundColor = [CFTool color:(random()%14 + 1)];
    tagButton.heightDime.equalTo(@44);
    
    [tagButton addTarget:self action:@selector(handleTouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside]; //注册拖动事件。
    [tagButton addTarget:self action:@selector(handleTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown]; //注册按下事件
    [tagButton addTarget:self action:@selector(handleTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside]; //注册抬起事件
    [tagButton addTarget:self action:@selector(handleTouchDownRepeat:withEvent:) forControlEvents:UIControlEventTouchDownRepeat]; //注册多次点击事件

    return tagButton;
    
}

//创建添加按钮
-(UIButton*)createAddButton
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton setTitle:NSLocalizedString(@"add tag", @"") forState:UIControlStateNormal];
    addButton.titleLabel.font = [CFTool font:14];
    addButton.layer.cornerRadius = 20;
    addButton.layer.borderWidth = 0.5;
    addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    addButton.heightDime.equalTo(@44);
    
    [addButton addTarget:self action:@selector(handleAddTagButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return addButton;
}




#pragma mark -- Handle Method

-(void)handleAddTagButton:(id)sender
{
    NSString *label = [NSString stringWithFormat:NSLocalizedString(@"drag me %ld", @""),self.flowLayout.subviews.count - 1];
    [self.flowLayout insertSubview:[self createTagButton:label] atIndex:self.flowLayout.subviews.count - 1];

}

- (IBAction)handleTouchDown:(UIButton*)sender withEvent:(UIEvent*)event {
    
    self.oldIndex = [self.flowLayout.subviews indexOfObject:sender];
    self.currentIndex = self.oldIndex;
    self.hasDrag = NO;
    
}

- (IBAction)handleTouchUp:(UIButton*)sender withEvent:(UIEvent*)event {
    
    if (!self.hasDrag)
        return;
    
    sender.useFrame = NO;
    self.flowLayout.autoresizesSubviews = YES;
    
     //调整索引。
    for (NSInteger i = self.flowLayout.subviews.count - 1; i > self.currentIndex; i--)
    {
        [self.flowLayout exchangeSubviewAtIndex:i withSubviewAtIndex:i - 1];
    }
    
}


- (IBAction)handleTouchDrag:(UIButton*)sender withEvent:(UIEvent*)event {
    
    self.hasDrag = YES;
    
    CGPoint pt = [[event touchesForView:sender].anyObject locationInView:self.flowLayout];
    
    UIView *sbv2 = nil;
    //判断当前手指在具体视图的位置。这里要排除self.addButton的位置。
    for (UIView *sbv in self.flowLayout.subviews)
    {
        if (sbv != sender && sender.useFrame && sbv != self.addButton)
        {
            CGRect rc1 =  sbv.frame;
            if (CGRectContainsPoint(rc1, pt))
            {
                sbv2 = sbv;
                break;
            }
        }
    }
    
    if (sbv2 != nil)
    {
        
        [self.flowLayout layoutAnimationWithDuration:0.2];
        
        //得到要移动的视图的位置索引。
        self.currentIndex = [self.flowLayout.subviews indexOfObjectIdenticalTo:sbv2];
        
        if (self.oldIndex != self.currentIndex)
        {
            self.oldIndex = self.currentIndex;
        }
        else
        {
            self.currentIndex = self.oldIndex + 1;
        }
        

        
        //因为sender在bringSubviewToFront后变为了最后一个子视图，因此要调整正确的位置。
        for (NSInteger i = self.flowLayout.subviews.count - 1; i > self.currentIndex; i--)
        {
            [self.flowLayout exchangeSubviewAtIndex:i withSubviewAtIndex:i - 1];
        }
        
        self.flowLayout.autoresizesSubviews = YES;
        sender.useFrame = NO;
        sender.noLayout = YES;  //这里设置为YES表示布局时不会改变sender的真实位置而只是在布局视图中占用一个位置和尺寸，正是因为只是占用位置，因此会调整其他视图的位置。
        [self.flowLayout layoutIfNeeded];
        
    }
    
    //在进行sender的位置调整时，要把sender移动到最顶端，也就子视图数组的的最后，这时候布局视图不能布局，因此要把autoresizesSubviews设置为NO，同时因为要自定义
    //sender的位置，因此要把useFrame设置为YES，并且恢复noLayout为NO。
    [self.flowLayout bringSubviewToFront:sender];
    self.flowLayout.autoresizesSubviews = NO;
    sender.useFrame = YES;
    sender.noLayout = NO;
    sender.center = pt;  //因为useFrame设置为了YES所有这里可以直接调整center，从而实现了位置的自定义设置。
    
}

- (IBAction)handleTouchDownRepeat:(UIButton*)sender withEvent:(UIEvent*)event {
    
    [sender removeFromSuperview];
    [self.flowLayout layoutAnimationWithDuration:0.2];
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

//
//  FLLTest1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "FLLTest3ViewController.h"
#import "MyLayout.h"

@interface FLLTest3ViewController ()

@property(nonatomic, strong) MyFlowLayout *flowLayout;
@property(nonatomic, assign) BOOL oldIndex;
@property(nonatomic, assign) BOOL currentIndex;

@end

@implementation FLLTest3ViewController

-(void)createTagButton:(NSString*)text
{
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:text forState:UIControlStateNormal];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:14];
    tagButton.layer.cornerRadius = 20;
    tagButton.backgroundColor = [UIColor colorWithRed:random()%256 / 255.0 green:random()%256 / 255.0 blue:random()%256 / 255.0 alpha:1];
    tagButton.heightDime.equalTo(@44);
    
    [tagButton addTarget:self action:@selector(handleTouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [tagButton addTarget:self action:@selector(handleTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [tagButton addTarget:self action:@selector(handleTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowLayout addSubview:tagButton];
    
}

-(void)loadView
{
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.wrapContentWidth = NO;
    rootLayout.wrapContentHeight = NO;
    rootLayout.gravity = MyMarginGravity_Horz_Fill;
    self.view = rootLayout;
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.text = @"  您可以拖动下面任意一个标签进行位置的调整，MyLayout可以通过子视图的useFrame，noLayout和布局视图的autoresizesSubviews属性结合使用来完成一些位置调整以及整体的动画特性：\n useFrame设置为YES时表示子视图不受布局视图的控制而是使用自身的frame来确定位置和尺寸。\n\n autoresizesSubviews设置为NO表示布局视图不会执行任何布局操作，而不是保持里面子视图的位置和尺寸。\n\n noLayout设置为YES表示子视图在布局时只会占用位置和尺寸而不会真实的调整位置和尺寸。";
    tipLabel.numberOfLines = 0;
    tipLabel.flexedHeight = YES; //这两个属性结合着使用实现自动换行。
    [rootLayout addSubview:tipLabel];
    
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyLayoutViewOrientation_Vert arrangedCount:4];
    self.flowLayout.backgroundColor = [UIColor lightGrayColor];
    self.flowLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.flowLayout.subviewMargin = 10;
    self.flowLayout.averageArrange = YES;
    self.flowLayout.weight = 1;
    self.flowLayout.myTopMargin = 10;
    [rootLayout addSubview:self.flowLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流式布局 -- 拖动调整位置";
    // Do any additional setup after loading the view.
    
    for (int i = 0; i < 14; i++)
    {
        NSString *labl = [NSString stringWithFormat:@"拖动我%d",i];
        [self createTagButton:labl];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Handle Method

- (IBAction)handleTouchDown:(UIButton*)sender withEvent:(UIEvent*)event {
    
    self.oldIndex = [self.flowLayout.subviews indexOfObject:sender];
    self.currentIndex = self.oldIndex;
    
}

- (IBAction)handleTouchUp:(UIButton*)sender withEvent:(UIEvent*)event {
    
    sender.useFrame = NO;
    self.flowLayout.autoresizesSubviews = YES;
    
     //调整索引。
    for (NSInteger i = self.flowLayout.subviews.count - 1; i > self.currentIndex; i--)
    {
        [self.flowLayout exchangeSubviewAtIndex:i withSubviewAtIndex:i - 1];
    }
    
}


- (IBAction)handleTouchDrag:(UIButton*)sender withEvent:(UIEvent*)event {
    
    
    CGPoint pt = [[event touchesForView:sender].anyObject locationInView:self.flowLayout];
    
    UIView *sbv2 = nil;
    
    //判断当前手指在具体视图的位置。
    for (UIView *sbv in self.flowLayout.subviews)
    {
        if (sbv != sender && sender.useFrame)
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
        //把所有子视图
           self.flowLayout.beginLayoutBlock = ^{
         
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:0.2];
         };
         
         self.flowLayout.endLayoutBlock = ^{
         
         [UIView commitAnimations];
         
         };
        
        //得到要移动的视图的位置索引。
        self.currentIndex = [self.flowLayout.subviews indexOfObject:sbv2];
        
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
        sender.noLayout = YES;  //这里设置为YES表示即使布局时也不会改变sender的真实位置而只是在布局视图中占用一个位置和尺寸，正是因为只是占用位置，因此会调整其他视图的位置。
        [self.flowLayout layoutIfNeeded];
        
    }
    
    //在进行sender的位置调整时，要把sender移动到最顶端，也就子视图数组的的最后，这时候布局视图不能布局，因此要把autoresizesSubviews设置为NO，同时因为要自定义
    //sender的位置，因此要把useFrame设置为YES，并且恢复noLayout为NO。
    [self.flowLayout bringSubviewToFront:sender];
    self.flowLayout.autoresizesSubviews = NO;
    sender.useFrame = YES;
    sender.noLayout = NO;
    sender.center = pt;  //因为useFrame设置为了YES所有这里可以直接调整center，而调整视图的位置。
    
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

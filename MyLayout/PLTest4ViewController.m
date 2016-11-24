//
//  PLTest4ViewController.m
//  MyLayout
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "PLTest4ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface PLTest4ViewController ()

@property(nonatomic, strong) MyPathLayout *pathLayout;

@end

@implementation PLTest4ViewController

-(void)loadView
{
    
    _pathLayout = [MyPathLayout new];
    self.view = _pathLayout;
    
    _pathLayout.backgroundColor = [CFTool color:0];
    _pathLayout.leftPadding = 20;
    _pathLayout.coordinateSetting.origin = CGPointMake(0, 0.5);  //原点坐标在(0,0.5)的位置。
    _pathLayout.coordinateSetting.start = -60.0 / 180.0 * M_PI;  //从-60度到60度
    _pathLayout.coordinateSetting.end = 60.0 / 180.0 * M_PI;
    _pathLayout.distanceError = 0.01;  //因为曲线半径非常的小，为了要求高精度的距离间距，所以要把距离误差调整的非常的小。
    _pathLayout.polarEquation = ^(CGFloat angle)
    {
        return (CGFloat)1.0;
    };
    
    //设置原点视图。
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.backgroundColor = [UIColor darkGrayColor];
    button.layer.cornerRadius = 10;
    [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    _pathLayout.originView = button;
    
    for (int i = 0; i < 9; i ++)
    {
        UILabel *label = [UILabel new];
        label.layer.anchorPoint = CGPointMake(0.05, 0.5);   //把子视图的相对中心点换成（0.05，0.5)这个相对值，这样曲线上的点就定位在了子视图的这个特定位置。
        label.myLeftMargin = -1; //这里通过margin的设置还可以设置曲线上定位的点的中心点的偏移值。
        label.myWidth = 200;
        label.myHeight = 30;
        
        label.text = [NSString stringWithFormat:@"Text:%d",i];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [CFTool color:4];
        label.font = [CFTool font:15];
        label.layer.cornerRadius = 2;
        label.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        label.layer.shadowOffset = CGSizeMake(0, 0);
        label.layer.shadowRadius = 3;
        label.layer.shadowOpacity = 0.5;
        
        label.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            MyPathLayout *playout = (MyPathLayout*)layout;
            CGFloat angle = [playout argumentFrom:sbv]; //MyPathLayout的argumentFrom方法能够取得子视图在曲线上的点的方程函数的自变量的输入的值。
            NSLog(@"angle:%f",angle / M_PI * 180); //您可以这里打印看看效果。
            sbv.transform = CGAffineTransformMakeRotation(-1 * angle); //这里通过调整子视图的transform来实现旋转的功能。
        };
        [_pathLayout addSubview:label];
        
    }
    
    
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
#pragma mark -- Handle Method
-(void)handleAction:(UIButton*)sender
{
    NSArray *pathSubviews = self.pathLayout.pathSubviews;
    NSInteger count = pathSubviews.count;
    
    if (!sender.isSelected)
    {
        for (NSInteger i = count - 1; i >=0; i--)
        {
            UIView *sbv = pathSubviews[i];
            
            sbv.useFrame = YES;  //动画前防止调整可能引起重新布局，因此这里要设置为YES，不让这个子视图重新布局。
            [UIView animateWithDuration:0.9/9 * (count - i) delay:0.9 / 9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                sbv.transform =CGAffineTransformMakeRotation(-90.0 /180 *M_PI);  //所有子视图都旋转到-90度的地方。
                
            } completion:nil];
        }
    }
    else
    {
        
        for (NSInteger i = 0; i < count; i++)
        {
            UIView *sbv = self.pathLayout.subviews[i];
            
            [UIView animateWithDuration:0.9/9 * (count - i) delay:0.9 / 9 * i options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                sbv.transform =CGAffineTransformMakeRotation(-1 * [self.pathLayout argumentFrom:sbv]); //这里还原到原来的角度，注意这里又使用了argumentFrom这个方法来获取当时子视图被定位时的角度值。
                
            } completion:^(BOOL finished){
                
                sbv.useFrame = NO;
                
            }];
        }
        
        
    }
    
    
    sender.selected = !sender.isSelected;
    
}


@end

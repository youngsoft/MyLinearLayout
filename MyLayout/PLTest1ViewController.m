//
//  PLTest1ViewController.m
//  MyLayout
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//
#import "MyLayout.h"
#import "PLTest1ViewController.h"

@interface PLTest1ViewController ()

@property(nonatomic, strong) MyPathLayout *pathLayout;

@end

@implementation PLTest1ViewController

-(void)loadView
{
    /**
     *本例子是介绍MyPathLayout布局视图的。用来建立曲线布局。
     */
    
    _pathLayout = [MyPathLayout new];
    
     self.view  = _pathLayout;
    _pathLayout.padding = UIEdgeInsetsMake(20, 20, 20, 20);  //因为路径布局里面的点算的都是子视图的中心点，所以为了避免子视图被遮盖这里设置了4个内边距。
    _pathLayout.backgroundColor = [UIColor whiteColor];
    
    //添加原点视图，原点视图是可选的视图。
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(handleAdd:) forControlEvents:UIControlEventTouchUpInside];
    _pathLayout.originView = button; //设置原点视图，路径布局会把原点视图作为布局视图的第一个子视图。
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(handleStretch1:)],
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(handleStretch2:)]
                                                ];
    
    
    
    self.toolbarItems = @[
                          [[UIBarButtonItem alloc] initWithTitle:@"Circle" style:UIBarButtonItemStyleDone target:self action:@selector(handleCircle:)],
                          [[UIBarButtonItem alloc] initWithTitle:@"Arc" style:UIBarButtonItemStylePlain target:self action:@selector(handleArc:)],
                          [[UIBarButtonItem alloc] initWithTitle:@"Arc2" style:UIBarButtonItemStylePlain target:self action:@selector(handleArc2:)],
                          [[UIBarButtonItem alloc] initWithTitle:@"Line1" style:UIBarButtonItemStylePlain target:self action:@selector(handleLine1:)],
                          [[UIBarButtonItem alloc] initWithTitle:@"Line2" style:UIBarButtonItemStylePlain target:self action:@selector(handleLine2:)],
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          
                          [[UIBarButtonItem alloc] initWithTitle:@"Flexed" style:UIBarButtonItemStyleDone target:self action:@selector(handleFlexed:)],
                          [[UIBarButtonItem alloc] initWithTitle:@"Fixed" style:UIBarButtonItemStylePlain target:self action:@selector(handleFixed:)],
                          [[UIBarButtonItem alloc] initWithTitle:@"Count" style:UIBarButtonItemStylePlain target:self action:@selector(handleCount:)]
                          ];


    [self changeToCircleStyle];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
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

-(void)handleAdd:(id)sender
{
    UIButton * button = [UIButton new];
    button.center = self.pathLayout.originView.center; //默认的位置和原点视图的中心点保持一致。。
    button.myWidth = 40;
    button.myHeight = 40;
    
    
    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor blackColor], [UIColor orangeColor]];
    button.backgroundColor = colors[(NSInteger)arc4random_uniform((uint32_t)colors.count)];
    
    [self.pathLayout insertSubview:button atIndex:0];
    [self.pathLayout layoutAnimationWithDuration:0.5];
    
    [button addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(handleDrag:) forControlEvents:UIControlEventTouchDragInside];

}

-(void)handleDel:(UIButton *)sender
{
    
    sender.useFrame = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
        sender.center = self.pathLayout.originView.center;
        sender.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        
        [sender removeFromSuperview];
    }];
    
    [self.pathLayout layoutAnimationWithDuration:0.3];

    

}

-(void)handleDrag:(UIButton*)sender
{
    //这个效果只有在圆环中才有效果，你拖动时可以通过调整坐标的开始和结束点来很轻易的实现转动的效果。
    self.pathLayout.coordinateSetting.start += (M_PI/180);
    self.pathLayout.coordinateSetting.end += (M_PI/180);
}

-(void)handleCircle:(UIBarButtonItem*)sender
{
    self.toolbarItems[0].style = UIBarButtonItemStyleDone;
    self.toolbarItems[1].style = UIBarButtonItemStylePlain;
    self.toolbarItems[2].style = UIBarButtonItemStylePlain;
    self.toolbarItems[3].style = UIBarButtonItemStylePlain;
    self.toolbarItems[4].style = UIBarButtonItemStylePlain;

    [self changeToCircleStyle];

    [self.pathLayout layoutAnimationWithDuration:0.5];


}

-(void)handleArc:(UIBarButtonItem*)sender
{
    self.toolbarItems[0].style = UIBarButtonItemStylePlain;
    self.toolbarItems[1].style = UIBarButtonItemStyleDone;
    self.toolbarItems[2].style = UIBarButtonItemStylePlain;
    self.toolbarItems[3].style = UIBarButtonItemStylePlain;
    self.toolbarItems[4].style = UIBarButtonItemStylePlain;

    [self changeToArcStyle1];
    
    [self.pathLayout layoutAnimationWithDuration:0.5];

}

-(void)handleArc2:(UIBarButtonItem*)sender
{
    self.toolbarItems[0].style = UIBarButtonItemStylePlain;
    self.toolbarItems[1].style = UIBarButtonItemStylePlain;
    self.toolbarItems[2].style = UIBarButtonItemStyleDone;
    self.toolbarItems[3].style = UIBarButtonItemStylePlain;
    self.toolbarItems[4].style = UIBarButtonItemStylePlain;
 
    [self changeToArcStyle2];
    
    [self.pathLayout layoutAnimationWithDuration:0.5];
    
}

-(void)handleLine1:(UIBarButtonItem*)sender
{
    self.toolbarItems[0].style = UIBarButtonItemStylePlain;
    self.toolbarItems[1].style = UIBarButtonItemStylePlain;
    self.toolbarItems[2].style = UIBarButtonItemStylePlain;
    self.toolbarItems[3].style = UIBarButtonItemStyleDone;
    self.toolbarItems[4].style = UIBarButtonItemStylePlain;

    [self changeToLine1];
    
    [self.pathLayout layoutAnimationWithDuration:0.5];
    
}

-(void)handleLine2:(UIBarButtonItem*)sender
{
    self.toolbarItems[0].style = UIBarButtonItemStylePlain;
    self.toolbarItems[1].style = UIBarButtonItemStylePlain;
    self.toolbarItems[2].style = UIBarButtonItemStylePlain;
    self.toolbarItems[3].style = UIBarButtonItemStylePlain;
    self.toolbarItems[4].style = UIBarButtonItemStyleDone;
    
    [self changeToLine2];
    
    [self.pathLayout layoutAnimationWithDuration:0.5];
    
}




-(void)handleFlexed:(UIBarButtonItem*)sender
{
    self.toolbarItems[6].style = UIBarButtonItemStyleDone;
    self.toolbarItems[7].style = UIBarButtonItemStylePlain;
    self.toolbarItems[8].style = UIBarButtonItemStylePlain;

    self.pathLayout.spaceType = [MyPathSpace flexed];   //表示路径布局视图里面的子视图的间距会根据路径曲线自动的调整。
    [self.pathLayout layoutAnimationWithDuration:0.5];

}

-(void)handleFixed:(UIBarButtonItem*)sender
{
    self.toolbarItems[6].style = UIBarButtonItemStylePlain;
    self.toolbarItems[7].style = UIBarButtonItemStyleDone;
    self.toolbarItems[8].style = UIBarButtonItemStylePlain;

    self.pathLayout.spaceType = [MyPathSpace fixed:100]; //表示路径布局视图里面的子视图的间距是固定为80的。
    [self.pathLayout layoutAnimationWithDuration:0.5];
    
}

-(void)handleCount:(UIBarButtonItem*)sender
{
    self.toolbarItems[6].style = UIBarButtonItemStylePlain;
    self.toolbarItems[7].style = UIBarButtonItemStylePlain;
    self.toolbarItems[8].style = UIBarButtonItemStyleDone;

    
    self.pathLayout.spaceType = [MyPathSpace count:6]; //表示路径布局视图里面的子视图的间距会根据尺寸和数量为10来调整。
    [self.pathLayout layoutAnimationWithDuration:0.5];

}


-(void)handleStretch1:(UIBarButtonItem*)sender
{
    UIView *originView = self.pathLayout.originView;
    if (originView == nil)
        return;
    
    
    if (sender.style == UIBarButtonItemStylePlain)
    {
        sender.style = UIBarButtonItemStyleDone;
        
        CGPoint originCenterPoint = originView.center;
        
        
        NSArray *pathSuviews = self.pathLayout.pathSubviews;  //只对所有曲线路径中的子视图做动画处理。
        for (UIView *sbv in pathSuviews)
        {
            sbv.useFrame = YES;  //设置为YES表示布局不控制子视图的布局了。
            sbv.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *v)  //viewLayoutCompleteBlock是1.2.3中新添加的属性，用来给子视图一个机会设置一些布局完成之后的事情。通常用在动画处理中，而且您也可以在这个block中获取v的最真实的frame的值，这里的v和sbv是同一个对象。
            {
                NSLog(@"realFrame:%@", NSStringFromCGRect(v.frame));
                v.alpha = 0;
                v.center = originCenterPoint;
                v.transform = CGAffineTransformMakeRotation(M_PI);
            };
        }
        
        [self.pathLayout layoutAnimationWithDuration:0.4];
        
        
    }
    else
    {
        sender.style = UIBarButtonItemStylePlain;
        
        NSArray *pathSuviews = self.pathLayout.pathSubviews;
        for (UIView *sbv in pathSuviews)
        {
            sbv.useFrame = NO;
            sbv.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *v)
            {
                v.alpha = 1;
                v.transform = CGAffineTransformIdentity;
            };
        }
        
        // [self.pathLayout layoutAnimationWithDuration:0.4];
        //带弹簧效果的动画效果。
        [UIView animateWithDuration:1.5 // 动画时长
                              delay:0.0 // 动画延迟
             usingSpringWithDamping:0.15 // 类似弹簧振动效果 0~1
              initialSpringVelocity:3.0 // 初始速度
                            options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                         animations:^{
                            
                             [self.pathLayout layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             // 动画完成后执行
                             // code...
                             //  [_imageView setAlpha:1];
                         }];

    }

}

-(void)handleStretch2:(UIBarButtonItem*)sender
{
    UIView *originView = self.pathLayout.originView;
    if (originView == nil)
        return;
    
    
    if (sender.style == UIBarButtonItemStylePlain)
    {
        sender.style = UIBarButtonItemStyleDone;
        
        
        [self.pathLayout beginSubviewPathPoint:YES]; //开始获取所有子视图的路径曲线方法。记得调用getSubviewPathPoint方法前必须要调用beginSubviewPathPoint方法。
        
        NSInteger count = self.pathLayout.pathSubviews.count;
        for (NSInteger i = count - 1; i >= 0; i--)
        {
            NSArray *pts = [self.pathLayout getSubviewPathPoint:i toIndex:0];  //pts返回两个子视图之间的所有点。因为pts是返回两个子视图之间的所有的路劲的点，因此非常适合用来做关键帧动画。
            CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            [ani setDuration:0.08 * (i + 1)];
            ani.values = pts;
            
            UIView *sbv = self.pathLayout.subviews[i];
            [sbv.layer addAnimation:ani forKey:nil];
            [UIView animateWithDuration:0.08 *(i + 1) animations:^{
                
                sbv.alpha = 0;
                sbv.transform = CGAffineTransformMakeRotation(M_PI);

            }];
            
        }
        [self.pathLayout endSubviewPathPoint]; //调用完毕后需要调用这个方法来释放一些数据资源。
        
    }
    else
    {
        sender.style = UIBarButtonItemStylePlain;
        
        [self.pathLayout beginSubviewPathPoint:YES];
        
        NSInteger count = self.pathLayout.pathSubviews.count;
        for (NSInteger i = count - 1; i >= 0; i--)
        {
            NSArray *pts = [self.pathLayout getSubviewPathPoint:0 toIndex:i];  //上面的从i到0，这里是从0到i，因此getSubviewPathPoint方法是可以返回任意两个点之间的路径点的。
            CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            [ani setDuration:0.08 * (i + 1)];
            ani.values = pts;
            
            UIView *sbv = self.pathLayout.subviews[i];
            [sbv.layer addAnimation:ani forKey:nil];
            
            [UIView animateWithDuration:0.08 *(i + 1) animations:^{
                
                sbv.alpha = 1;
                sbv.transform = CGAffineTransformIdentity;

            }];
            
        }
        [self.pathLayout endSubviewPathPoint];
        
    }
    
    
}



#pragma mark -- Private Method
-(void)changeToCircleStyle
{
    
    self.pathLayout.coordinateSetting.origin = CGPointMake(0.5, 0.5);  //坐标原点居中。默认y轴往下是正值。。
    self.pathLayout.coordinateSetting.isMath = NO;  //为NO 表示y轴下是正值。
    self.pathLayout.coordinateSetting.isReverse = NO;  //变量为x轴，值为y轴。
    self.pathLayout.coordinateSetting.start = 0;     //极坐标开始和结束是0和 2* M_PI。
    self.pathLayout.coordinateSetting.end = 2 * M_PI;

    
    //提供一个计算圆的极坐标函数。
     self.pathLayout.polarEquation = ^(CGFloat angle)
    {
        CGFloat radius = (CGRectGetWidth(self.view.bounds) - 40) / 2;  //半径是视图的宽度 - 两边的左右边距 再除2
        return radius;
    };

}

-(void)changeToArcStyle1
{
    self.pathLayout.coordinateSetting.origin = CGPointMake(0, 1);  //坐标原点在视图的左下角。
    self.pathLayout.coordinateSetting.isMath = YES;  //为YES 表示y轴往上是正值。
    self.pathLayout.coordinateSetting.isReverse = NO;
    self.pathLayout.coordinateSetting.start = -CGFLOAT_MAX;
    self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;

    
    //提供一个计算圆弧的极坐标函数
    self.pathLayout.polarEquation = ^(CGFloat angle)
    {
        CGFloat radius = (CGRectGetWidth(self.view.bounds) - 40);  //半径是视图的宽度 - 两边的左右边距
        
        if (angle >= 0 && angle <= M_PI_2)   //angle的单位是弧度，这里我们只处理0度 - 90度之间的路径，其他返回NAN。如果coordinateSetting.isMath设置为NO则需要把有效角度改为270到360度。
            return radius;
        else
            return (CGFloat)NAN;   //如果我们不想要某个区域或者某个点的值则可以直接函数返回NAN
    };
}

-(void)changeToArcStyle2
{
    self.pathLayout.coordinateSetting.origin = CGPointMake(0.5, 1);  //坐标原点x轴居中，y轴在最下面。
    self.pathLayout.coordinateSetting.isMath = YES;  //为YES 表示y轴往上是正值。
    self.pathLayout.coordinateSetting.isReverse = NO;
    self.pathLayout.coordinateSetting.start = -CGFLOAT_MAX;
    self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;
    
    //提供一个计算圆弧的极坐标函数
    self.pathLayout.polarEquation = ^(CGFloat angle)
    {
        CGFloat radius = (CGRectGetWidth(self.view.bounds) - 40)/2;  //半径是视图的宽度 - 两边的左右边距 再除2
        
        if (angle >= 0 && angle <= M_PI)   //angle的单位是弧度，这里我们只处理0度 - 180度之间的路径，因为用的是数学坐标系
            return radius;
        else
            return (CGFloat)NAN;   //如果我们不想要某个区域或者某个点的值则可以直接函数返回NAN
    };

}

-(void)changeToLine1
{
    self.pathLayout.coordinateSetting.origin = CGPointMake(0.5, 1);  //坐标原点x轴居中，y轴在最下面。
    self.pathLayout.coordinateSetting.isMath = YES;  //为YES 表示y轴往上是正值。
    self.pathLayout.coordinateSetting.isReverse = YES;  //这里设置为YES表示方程的入参是y轴的变量，返回的是x轴的值。
    self.pathLayout.coordinateSetting.start = 40;       //因为最底下的按钮是原点，所以这里要往上偏移40
    self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;  //结束位置默认。
    
    //提供一个  x = 0;  的方程，注意这里面是因为将isReverse设置为YES表示变量为y轴，值为x轴。
    self.pathLayout.rectangularEquation =^(CGFloat y)
    {
        return (CGFloat)0.0;
    };
    
}


-(void)changeToLine2
{
    self.pathLayout.coordinateSetting.origin = CGPointMake(0, 1);  //坐标原点x轴居左，y轴在最下面。
    self.pathLayout.coordinateSetting.isMath = YES;  //为YES 表示y轴往上是正值。
    self.pathLayout.coordinateSetting.isReverse = NO;
    self.pathLayout.coordinateSetting.start = 0;
    self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;
    
    //提供一个： y = sqrt(200 * x) + 40的方程。
     self.pathLayout.rectangularEquation = ^(CGFloat x)
    {
        return (CGFloat)(sqrt(200 * x) + 40);
    };

}




@end

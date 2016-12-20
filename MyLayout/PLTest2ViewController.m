//
//  PLTest2ViewController.m
//  MyLayout
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyPathLayout.h"
#import "PLTest2ViewController.h"


@interface MyTestPathLayou : MyPathLayout


@end


@implementation MyTestPathLayou

+(Class)layerClass  //您可以实现一个MyPathLayout的派生类，并重载layerClass方法，并返回CAShapeLayer。这样系统自动会将路径布局的曲线形成的path赋值给CAShapeLayer的path属性。
{
    return [CAShapeLayer class];
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        CAShapeLayer *shapeLayer = (CAShapeLayer*)self.layer;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.lineWidth = 2;
        shapeLayer.fillColor = nil;  //您可以在这里设置路径曲线的颜色、大小、填充方案等等。
        
        
        
    }
    
    return self;
}

@end


@interface PLTest2ViewController ()<UIActionSheetDelegate>

@property(nonatomic, strong) MyPathLayout *pathLayout;

@end

@implementation PLTest2ViewController

-(void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    
    _pathLayout = [MyTestPathLayou new];
    _pathLayout.wrapContentHeight = YES;
    _pathLayout.wrapContentWidth = YES;   //这里面的布局视图的宽度和高度都是wrap属性，因此这个例子里面出现不同函数切换时不会立即得到真实的位置，而是要在添加或者删除子视图后才会更新真实的高度和宽度，这个并不是一个BUG。
    _pathLayout.widthDime.lBound(scrollView.widthDime, 0, 1);
    _pathLayout.heightDime.lBound(scrollView.heightDime, 0, 1);  //设置最小的宽度和高度和父视图保持一致。
    _pathLayout.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    
    [scrollView addSubview:_pathLayout];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(handleRevrse:)],
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(handleAction:)],
                                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAdd:)]
                                                ];
    
    
    [self changeFunc:0]; //默认设置为第一种函数。
    
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

-(void)handleRevrse:(id)sender
{
    self.pathLayout.coordinateSetting.isReverse = !self.pathLayout.coordinateSetting.isReverse;
    [self.pathLayout layoutAnimationWithDuration:0.3];
}

-(void)handleAction:(id)sender
{
    [[[UIActionSheet alloc] initWithTitle:@"Curve Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Straight-line",@"Sin",@"Cycloid",@"Spiral-like",@"Cardioid",@"Astroid",nil] showFromBarButtonItem:sender animated:YES];
    
}

-(void)handleAdd:(id)sender
{
    //取路径布局中最后一个子视图的中心点。
    CGPoint pt = CGPointZero;
    if (self.pathLayout.pathSubviews.count > 0)  //这里不取subviews的原因是，有可能会出现设置了原点视图的情况。
        pt = ((UIView*)self.pathLayout.pathSubviews.lastObject).frame.origin;
    
    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor blackColor], [UIColor orangeColor]];

    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(pt.x, pt.y, 40, 40)];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    button.backgroundColor = colors[(NSInteger)arc4random_uniform((uint32_t)colors.count)];
    [button addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];
    [self.pathLayout addSubview:button];
    
    
    [self.pathLayout layoutAnimationWithDuration:0.3];

    
}

-(void)handleDel:(UIButton *)sender
{
    [sender removeFromSuperview];
    [self.pathLayout layoutAnimationWithDuration:0.3];
    
}


#pragma mark -- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self changeFunc:buttonIndex];
    [self.pathLayout setNeedsLayout];
    [self.pathLayout layoutAnimationWithDuration:0.5];
    
}


// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}

#pragma mark -- Private Method
-(void)changeFunc:(NSInteger)index
{
    if (index == 0) //直线函数 y = a *x + b;
    {
        self.pathLayout.coordinateSetting.origin = CGPointMake(0, 0);
        self.pathLayout.coordinateSetting.isMath = NO;
        self.pathLayout.coordinateSetting.start = -CGFLOAT_MAX;
        self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;
        self.pathLayout.spaceType = [MyPathSpace fixed:60];
        
        self.pathLayout.rectangularEquation = ^(CGFloat x)
        {
            return 2 * x;
        };
        
    }
    else if (index == 1) //正玄函数 y = sin(x);
    {
        self.pathLayout.coordinateSetting.origin = CGPointMake(0, 0.5);
        self.pathLayout.coordinateSetting.isMath = YES;
        self.pathLayout.coordinateSetting.start = -CGFLOAT_MAX;
        self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;
        self.pathLayout.spaceType = [MyPathSpace fixed:60];
        
        self.pathLayout.rectangularEquation = ^(CGFloat x)
        {
            return (CGFloat)(100 * sin(x / 180.0 * M_PI));
        };
        
    }
    else if (index == 2) //摆线函数, 用参数方程： x = a * (t - sin(t); y = a *(1 - cos(t));
    {
        self.pathLayout.coordinateSetting.origin = CGPointMake(0, 0.5);
        self.pathLayout.coordinateSetting.isMath = YES;
        self.pathLayout.coordinateSetting.start = -CGFLOAT_MAX;
        self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;
        self.pathLayout.spaceType = [MyPathSpace fixed:100];
        
        self.pathLayout.parametricEquation = ^(CGFloat t)
        {
            CGFloat t2 = t / 180 * M_PI;  //角度转化为弧度。
            
            CGFloat a = 50;
            
            return CGPointMake(a * (t2 - sin(t2)), a * (1 - cos(t2)));
            
        };
        
    }
    else if (index == 3)  //阿基米德螺旋线函数: r = a * θ   用的是极坐标。
    {
        self.pathLayout.coordinateSetting.origin = CGPointMake(0.5, 0.5);
        self.pathLayout.coordinateSetting.isMath = NO;
        self.pathLayout.coordinateSetting.start = -CGFLOAT_MAX;
        self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;
        self.pathLayout.spaceType = [MyPathSpace fixed:60];
        
        self.pathLayout.polarEquation = ^(CGFloat angle)
        {
            return 20 * angle;
        };
        
    }
    else if (index == 4)  //心形线 r = a *(1 + cos(θ)
    {
        
        self.pathLayout.coordinateSetting.origin = CGPointMake(0.2, 0.5);
        self.pathLayout.coordinateSetting.isMath = YES;
        self.pathLayout.coordinateSetting.start = -CGFLOAT_MAX;
        self.pathLayout.coordinateSetting.end = CGFLOAT_MAX;
        self.pathLayout.spaceType = [MyPathSpace flexed];
        
        self.pathLayout.polarEquation = ^(CGFloat angle)
        {
            return (CGFloat)(120 * (1 + cos(angle)));
        };
        
    }
    else if (index == 5)  //星型线 x = a * cos^3(θ); y =a * sin^3(θ);
    {
        self.pathLayout.coordinateSetting.origin = CGPointMake(0.5, 0.5);
        self.pathLayout.coordinateSetting.isMath = YES;
        self.pathLayout.coordinateSetting.start = 0;
        self.pathLayout.coordinateSetting.end = 360;
        self.pathLayout.spaceType = [MyPathSpace flexed];
        
        self.pathLayout.parametricEquation = ^(CGFloat t)
        {
            
            return CGPointMake(150 * pow(cos(t / 180 * M_PI),3), 150 * pow(sin(t / 180 * M_PI),3));
            
        };
    }

}



@end

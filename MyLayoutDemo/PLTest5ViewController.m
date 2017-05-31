//
//  PLTest5ViewController.m
//  MyLayout
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "PLTest5ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@interface ItemLayout : MyLinearLayout

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *nameLabel;

-(instancetype)initWithImage:(UIImage*)image name:(NSString*)name color:(UIColor*)color;


@end

@implementation ItemLayout

-(instancetype)initWithImage:(UIImage*)image name:(NSString*)name color:(UIColor*)color
{
    self = [super initWithOrientation:MyOrientation_Horz];
    if (self != nil)
    {
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.widthSize.equalTo(@50).multiply(1);
        _imageView.heightSize.equalTo(@50).multiply(1);
        _imageView.layer.cornerRadius = 25 * 1;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.myCenterY = 0; //垂直居中。
        [self addSubview:_imageView];
        
        _nameLabel = [UILabel new];
        _nameLabel.text = name;
        _nameLabel.textColor = color;
        _nameLabel.myVertMargin = 0;
        _nameLabel.myLeft = 20;
        _nameLabel.weight = 1;  //占用剩余宽度。
        [self addSubview:_nameLabel];
    }
    
    return self;
}

@end

@interface PLTest5ViewController ()

@property(nonatomic, strong) MyPathLayout *pathLayout;

@end

@implementation PLTest5ViewController

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    
    _pathLayout = [MyPathLayout new];
    self.view = _pathLayout;
    
    _pathLayout.backgroundColor = [CFTool color:0];
    _pathLayout.coordinateSetting.origin = CGPointMake(-1.5, 0.5);  //原点坐标在(-0.5,0.5)的位置，这里x轴为负数就会偏移出屏幕。
    _pathLayout.coordinateSetting.isMath = YES;   //数学坐标系
    _pathLayout.coordinateSetting.start = 0;      //定义域从0到2PI。
    _pathLayout.coordinateSetting.end = 2 *M_PI;
    _pathLayout.distanceError = 0.1;    //间距误差设置0.1,误差越小间距精度越精准。
    
    __weak UIView *weakPathLayout = _pathLayout;
    _pathLayout.polarEquation = ^(CGFloat angle)
    {
        return weakPathLayout.bounds.size.height;  //圆函数半径为布局的高度。
    };
    
    
    NSArray *images = @[@"head1",@"head2",@"minions1",@"minions3",@"minions4"];
    NSArray *names = @[@"梅西",@"罗纳尔多",@"克里斯蒂亚诺·罗纳尔多(C罗)",@"贝克汉姆",@"贝利",@"内马尔·达席尔瓦",@"马拉多纳",@"路易斯·阿尔贝托·苏亚雷斯",@"安德雷斯·伊涅斯塔",@"哈维·埃尔南德兹·克雷乌斯",@"罗纳尔迪尼奥",@"罗马里奥",@"巴蒂斯图塔",@"克鲁伊夫",@"贝肯鲍尔",@"劳尔·冈萨雷斯"];
    
    for (int i = 0; i < 80; i ++)
    {
        ItemLayout *itemLayout = [[ItemLayout alloc] initWithImage:[UIImage imageNamed:images[arc4random_uniform((uint32_t)images.count)]]
                                                              name:names[arc4random_uniform((uint32_t)names.count)]
                                                             color:[CFTool color:arc4random_uniform(14) + 1]];
        
       itemLayout.layer.anchorPoint = CGPointMake(0.05, 0.5);   //把子视图的相对中心点换成（0.05，0.5)这个相对值，
        itemLayout.myWidth = 300;
        itemLayout.myHeight = 25;

        itemLayout.viewLayoutCompleteBlock = [self viewLayoutCompleteBlock];  //这里更新一些子视图的属性。
        
        [_pathLayout addSubview:itemLayout];
        
    }
    
    
}

-(void (^)(MyBaseLayout *, UIView *))viewLayoutCompleteBlock
{
    return ^(MyBaseLayout *layout, UIView *sbv)
    {
        MyPathLayout *playout = (MyPathLayout*)layout;
        CGFloat angle =  [playout argumentFrom:sbv]; //MyPathLayout的argumentFrom方法能够取得子视图在曲线上的点的方程函数的自变量的输入的值。
        
        sbv.transform = CGAffineTransformMakeRotation(-1 * angle); //这里通过调整子视图的transform来实现旋转的功能。因为每个子视图的对应的曲线函数的自变量就是偏移的角度。
            
        
        ItemLayout *itemLayout = (ItemLayout*)sbv;
        
        
        //将弧度转化角度，并且范围限制在0 到 360 之间。
        int  degree = fabs(angle / M_PI * 180);
        degree %= 360;
        
        //根据角度来计算缩放比例因子。从而实现中间的文字大，两边的文字的小的效果。
        CGFloat factor = abs(180 - degree)/180.0;
        factor = pow(factor, 5);
        itemLayout.nameLabel.font = [CFTool font:20*factor];  //调整字体中间大两边小。
        
        //图片的缩放比例因子比文字的缩放还要大。
      //  factor = pow(factor, 3);
        itemLayout.imageView.widthSize.multiply(factor);
        itemLayout.imageView.heightSize.multiply(factor);
        itemLayout.imageView.layer.cornerRadius = 25 * factor;
        
    };
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //上下上下轻扫手势。
    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeDownGesture.direction =  UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGesture];
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeUpGesture.direction =  UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGesture];

    
}

-(void)doRotate:(UISwipeGestureRecognizerDirection)direction
{
    CGFloat step = 0;
    if (direction == UISwipeGestureRecognizerDirectionDown)
    {
        step = M_PI / -36;
    }
    else if (direction == UISwipeGestureRecognizerDirectionUp)
    {
        step = M_PI / 36;
    }
    else;
    
    
    //通过调整曲线函数开始角度和结束角度来实现旋转的效果。
    _pathLayout.coordinateSetting.start += step;
    _pathLayout.coordinateSetting.end += step;
    
    for (UIView *sbv in _pathLayout.subviews)
    {
        //因为每个子视图的角度调整了，所以更新旋转角度以及字体大小。
        sbv.viewLayoutCompleteBlock = [self viewLayoutCompleteBlock];
    }

}

-(void)handleSwipe:(UISwipeGestureRecognizer*)sender
{
    [self doRotate:sender.direction];
    
    [UIView animateWithDuration:0.08 animations:^{
        
        [_pathLayout layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self doRotate:sender.direction];
        
        [UIView animateWithDuration:0.08 animations:^{
            
            [_pathLayout layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [self doRotate:sender.direction];
            
            [UIView animateWithDuration:0.08 animations:^{
                
                [_pathLayout layoutIfNeeded];
                
            }];
            
        }];
        
        
    }];
    
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

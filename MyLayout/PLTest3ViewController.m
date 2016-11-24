//
//  PLTest3ViewController.m
//  MyLayout
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "PLTest3ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

#pragma mark -- PLTest3View

/**
 * 这个例子是建立一个直接从MyRelativeLayout派生的子视图的例子。通过直接从布局视图派生子类来构造一些特定功能的控件子视图。
 */
@interface PLTest3View : MyRelativeLayout

-(id)initWithImage:(NSString*)image title:(NSString*)title index:(NSInteger)index;


@property(nonatomic, strong) MyPathLayout *circleView;


@end


@implementation PLTest3View

-(id)initWithImage:(NSString*)image title:(NSString*)title index:(NSInteger)index
{
    self = [super init];
    if (self != nil)
    {
        self.wrapContentHeight = YES;
        self.wrapContentWidth = YES;
        
        _circleView = [MyPathLayout new];  //这里这是为路径布局的原因是其中的numLabel是跟随园所在的位置而确定的。
        _circleView.widthDime.equalTo(@60);
        _circleView.heightDime.equalTo(@60);
        _circleView.layer.cornerRadius = 30;
        _circleView.backgroundColor = [CFTool color:2];
        _circleView.coordinateSetting.origin = CGPointMake(0.5, 0.5);
        _circleView.polarEquation = ^(CGFloat angle)
        {
            return (CGFloat)30.0;
        };
        
        [self addSubview:_circleView];

        
        UILabel *numLabel = [UILabel new];
        numLabel.widthDime.equalTo(@15);
        numLabel.heightDime.equalTo(@15);
        numLabel.layer.cornerRadius = 7.5;
        numLabel.backgroundColor = [UIColor whiteColor];
        numLabel.font = [CFTool font:12];
        numLabel.textColor = [CFTool color:4];
        numLabel.clipsToBounds = YES;
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
        numLabel.textAlignment = NSTextAlignmentCenter;
        [_circleView addSubview:numLabel];

        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        [imageView sizeToFit];
        imageView.centerXPos.equalTo(_circleView.centerXPos);
        imageView.centerYPos.equalTo(_circleView.centerYPos);
        [self addSubview:imageView];
        
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = title;
        titleLabel.textColor = [CFTool color:4];
        titleLabel.font = [CFTool font:15];
        [titleLabel sizeToFit];
        titleLabel.centerXPos.equalTo(_circleView.centerXPos);
        titleLabel.topPos.equalTo(_circleView.bottomPos).offset(10);
        [self addSubview:titleLabel];
        
        
    }
    
    return self;
}


@end



@interface PLTest3ViewController ()

@property(nonatomic,strong) MyPathLayout *pathLayout;

@end

@implementation PLTest3ViewController


-(void)loadView
{
    _pathLayout = [MyPathLayout new];
    self.view =  _pathLayout;
    
    _pathLayout.backgroundImage = [UIImage imageNamed:@"bk1"];
    _pathLayout.coordinateSetting.origin = CGPointMake(0.5, 0.5);
    _pathLayout.coordinateSetting.start = -90.0 / 180 * M_PI;      //从-90度
    _pathLayout.coordinateSetting.end =  270.0 / 180 * M_PI;  //到270度。
    _pathLayout.padding = UIEdgeInsetsMake(30, 30, 30, 30);
    
    __weak UIView *weakPathLayout = _pathLayout;
    _pathLayout.polarEquation = ^(CGFloat angle)
    {
        CGFloat radius = (CGRectGetWidth(weakPathLayout.bounds) - 60) / 2;  //半径为视图的宽度减去两边的内边距30再除2。这里需要注意block的循环引用的问题。
        return radius;
    };
    
    
    UIButton *centerButton = [UIButton new];
    [centerButton setTitle:@"Click me" forState:UIControlStateNormal];
    [centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    centerButton.backgroundColor = [UIColor colorWithRed:0xA3/255.0 green:0x88/255.0 blue:0xC1/255.0 alpha:1];
    centerButton.titleLabel.font = [CFTool font:20];
    centerButton.layer.borderWidth = 5;
    centerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    centerButton.widthDime.equalTo(_pathLayout.widthDime).multiply(0.5).add(-30);  //宽度是父视图宽度的一半再减去30
    centerButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
    { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
      
        sbv.layer.cornerRadius = sbv.frame.size.width / 2;  //这里取子视图的圆角半径为宽度的一半，也就是形成了圆形按钮。
        sbv.heightDime.equalTo(@(sbv.frame.size.width));    //这里取子视图的高度等于他的宽度。
    };
    
    [centerButton addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    _pathLayout.originView = centerButton;  //把centerButton设置为布局视图的原点视图。
    
    
    NSArray *images = @[@"section1",@"section2",@"section3"];
    NSArray *titles = @[@"Fllow",@"WatchList",@"Add",@"Center", @"Del",@"Search",@"Other"];
    
    for (NSInteger i = 0; i < 7; i ++)
    {
        PLTest3View *plView = [[PLTest3View alloc] initWithImage:images[arc4random_uniform((uint32_t)images.count)]
                                                           title:titles[i]
                                                           index:i];
        
        
        plView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            PLTest3View *vplv = (PLTest3View*)sbv;
            MyPathLayout *vLayout = (MyPathLayout*)layout;
            
            CGFloat arg = [vLayout argumentFrom:sbv];  //MyPathLayout中的argumentFrom方法的作用是返回子视图在路径布局时所定位的点的自变量的值。上面因为我们用的是极坐标方程来算出每个子视图的位置，因此这里的argumentFrom方法返回的就是子视图所定位的角度。又因为我们的圆环角度是从270度开始的。而PLTest3View的圆环里面的numLabel的初始值又是从180度开始的，所以这里相差了刚好一个M_PI的值，所以我们这里把sbv所在的角度减去M_PI,就是PLTest3View里面的numLabel的开始的角度。
            vplv.circleView.coordinateSetting.start = (arg - M_PI);
            
        };
        
        [_pathLayout addSubview:plView];

    };
        
    
    
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

-(void)handleClick:(id)sender
{
    //例子中一共有7个子视图。因此每次旋转都是增加 360 / 7度。如果您要实现拖拽进行调整位置时，也只需要动态改变坐标的开始和结束位置就可以了。
    self.pathLayout.coordinateSetting.start += 2 *M_PI / self.pathLayout.pathSubviews.count;
    self.pathLayout.coordinateSetting.end += 2 *M_PI / self.pathLayout.pathSubviews.count;
    
    //因为角度的改变，所以这里也要激发PLTest3View里面的numLabel的角度的调整。
    NSArray *arr = self.pathLayout.pathSubviews;
    for (UIView *v in arr)
    {
        v.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            PLTest3View *vplv = (PLTest3View*)sbv;
            MyPathLayout *vLayout = (MyPathLayout*)layout;
            
            CGFloat arg = [vLayout argumentFrom:sbv];  //MyPathLayout中的argumentFrom方法的作用是返回子视图在路径布局时所定位的点的自变量的值。上面因为我们用的是极坐标方程来算出每个子视图的位置，因此这里的argumentFrom方法返回的就是子视图所定位的角度。又因为我们的圆环角度是从270度开始的。而PLTest3View的圆环里面的numLabel的初始值又是从180度开始的，所以这里相差了刚好一个M_PI的值，所以我们这里把sbv所在的角度减去M_PI,就是PLTest3View里面的numLabel的开始的角度。
            vplv.circleView.coordinateSetting.start = (arg - M_PI);
            
            [vplv.circleView layoutAnimationWithDuration:0.2];
            
        };

    }
        
    [self.pathLayout layoutAnimationWithDuration:0.3];

}


@end

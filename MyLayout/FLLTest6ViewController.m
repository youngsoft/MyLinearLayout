//
//  FLLTest6ViewController.m
//  MyLayout
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "FLLTest6ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLLTest6ViewController ()

@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) MyFlowLayout *rootLayout;

@end

@implementation FLLTest6ViewController


-(void)loadView
{
    /*
        这个例子用于介绍流式布局来实现2种风格的切换，多行多列到单行单列的切换,以及滚动方向的切换。
     */
    
    UIScrollView *scrollView = [UIScrollView new];
    self.view = scrollView;
    self.scrollView = scrollView;

    MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:3];
    rootLayout.backgroundColor = [CFTool color:0];
    rootLayout.pagedCount = 9;
    rootLayout.wrapContentHeight = YES;  //上下滚动，每页9个。
    rootLayout.subviewSpace = 10;
    rootLayout.padding = UIEdgeInsetsMake(10, 5, 10, 5);
    rootLayout.leftPos.equalTo(@0).active = YES; //active属性用来表示是否让这个属性设置生效。
    rootLayout.rightPos.equalTo(@0).active = YES;  //这里设置左右的边距是0并生效，表示宽度和父视图相等。
    rootLayout.topPos.equalTo(@0).active = NO;
    rootLayout.bottomPos.equalTo(@0).active = NO;  //这里设置上下边距是0但是不生效，这时候高度是不能生效的。
    [scrollView addSubview:rootLayout];
    self.rootLayout = rootLayout;
    
    
    NSArray *images = @[@"image1",@"image2",@"image3",@"image4"];
    for (int i = 0; i < 28; i++)
    {
        //因为使用了分页技术，系统默认会设置布局视图里面子控件的高度和宽度，因此一般情况下你不需要单独指定。
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:images[arc4random_uniform((uint32_t)images.count)]] forState:UIControlStateNormal];
        [self. rootLayout addSubview:button];
        
        button.tag = i + 100;
        [button addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
}

-(IBAction)handleTap:(UIButton*)sender
{
    //这里实现单击里面控件按钮来实现多行多列到单行单列的切换。多行多列时布局视图的宽度和父视图相等，而单行单列时布局视图的高度和父视图的高度相等。
    //下面这段话就是用来设置每次切换时的布局尺寸的处理。
    self.rootLayout.leftPos.active = !self.rootLayout.leftPos.isActive;
    self.rootLayout.rightPos.active = !self.rootLayout.rightPos.isActive;
    self.rootLayout.topPos.active = !self.rootLayout.topPos.isActive;
    self.rootLayout.bottomPos.active = !self.rootLayout.bottomPos.isActive;
    
    //当前是多行多列。
    if (self.rootLayout.wrapContentHeight)
    {
        //换成单行单列
        self.rootLayout.arrangedCount = 1;
        self.rootLayout.pagedCount = 1;
        self.rootLayout.padding = UIEdgeInsetsZero;
        self.rootLayout.subviewSpace = 0;
    
    }
    else
    {
        //恢复为多行多列
        self.rootLayout.arrangedCount = 3;
        self.rootLayout.pagedCount = 9;
        self.rootLayout.padding = UIEdgeInsetsMake(10, 5, 10, 5);
        self.rootLayout.subviewSpace = 10;
        
    }
   
    //这里切换水平滚动还是垂直滚动。
    self.rootLayout.wrapContentHeight = !self.rootLayout.wrapContentHeight;
    self.rootLayout.wrapContentWidth = !self.rootLayout.wrapContentWidth;
    
    
    
    BOOL isHorzScroll = self.rootLayout.wrapContentWidth;
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.rootLayout layoutIfNeeded];  //上面因为进行布局属性的设置变更，必定会激发重新布局，因此如果想要应用动画时可以在动画块内调用layoutIfNeeded来实现
        
        if (isHorzScroll)
        {
            self.scrollView.contentOffset = sender.frame.origin;
        }
        else
        {
            CGPoint offsetPoint = CGPointMake(0, sender.frame.origin.y);
            if (offsetPoint.y > self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
                offsetPoint.y = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
            self.scrollView.contentOffset = offsetPoint;
        }
        
        
    } completion:^(BOOL finished) {
       
    }];
    
    
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

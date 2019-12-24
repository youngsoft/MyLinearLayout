//
//  FLLTest8ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "FLLTest8ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLLTest8ViewController ()

@property(nonatomic, strong) MyFlowLayout *vertLayout;
@property(nonatomic, strong) MyFlowLayout *horzLayout;
@property(nonatomic, strong) MyFlowLayout *vertLayout2;
@property(nonatomic, strong) MyFlowLayout *horzLayout2;


@end

@implementation FLLTest8ViewController

-(void)loadView
{
    /*
    这个例子主要用于展示流式布局的间距的可伸缩性。当我们布局视图中的子视图的宽度或者高度为固定值，但是其中的间距又希望是可以伸缩的，那么就可以借助流式布局提供的方法
     
     -(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered
     
     来设置子视图的尺寸，以及最小和最大的间距值。并且当布局视图中子视图的间距小于最小值时会自动调整子视图的尺寸来满足这个最小的间距。
     
     对于垂直流式布局来说，这个方法只用于设置子视图的宽度和水平间距。
     对于水平流式布局来说，这个方法只用于设置子视图的高度和垂直间距。
     
     
     你可以在这个界面中尝试一下屏幕的旋转，看看布局为了支持横屏和竖屏而进行的布局调整，以便达到最完美的布局效果。
     
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    //这里的根视图是一个每列只有一个子视图的垂直流式布局，效果就相当于垂直线性布局了。
    MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:1];
    rootLayout.gravity = MyGravity_Fill;  //这里将gravity设置为MyGravity_Fill表明子视图的宽度和高度都将平分这个流式布局，可见一个简单的属性设置就可以很容易的实现子视图的尺寸的设置，而不需要编写太复杂的约束。
    rootLayout.subviewSpace = 10;
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    
    MyFlowLayout *vertLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:4];
    vertLayout.padding = UIEdgeInsetsMake(5, 0, 5, 0);
    vertLayout.backgroundColor = [CFTool color:5];
    vertLayout.subviewVSpace = 20;
    vertLayout.gravity = MyGravity_Vert_Fill;  //因为上面setSubviewsSize设置了固定宽度，这个属性设置子视图的高度是填充满子布局视图，因此系统内部会自动设置每个子视图的高度，如果你不设置这个属性，那么你就需要在下面分别为每个子视图设置高度。
    [rootLayout addSubview:vertLayout];
    self.vertLayout = vertLayout;
    
    for (int i = 0; i < 14; i++)
    {
        UILabel *label = [UILabel new];
        //label.myHeight = 60;  因为子视图的宽度在布局视图的setSubviewsSize:minSpace:maxSpace:中设置了，你也可以在这里单独为每个子视图设置高度，当然如果你的父布局视图使用了gravity来设置填充属性的话，那么子视图是不需要单独设置高度尺寸的。
        label.text = [NSString stringWithFormat:@"%d", i];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [CFTool color:2];
        [vertLayout addSubview:label];
    }
    

    
    MyFlowLayout *horzLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:4];
    
    horzLayout.padding = UIEdgeInsetsMake(0, 5, 0, 5);
    horzLayout.backgroundColor = [CFTool color:6];
    horzLayout.subviewHSpace = 20;
    horzLayout.gravity = MyGravity_Horz_Fill; //因为上面setSubviewsSize设置了固定高度，这个属性设置子视图的宽度是填充满子布局视图，因此系统内部会自动设置每个子视图的宽度，如果你不设置这个属性，那么你就需要在下面分别为每个子视图设置宽度。
    [rootLayout addSubview:horzLayout];
    self.horzLayout = horzLayout;
    
    for (int i = 0; i < 14; i++)
    {
        UILabel *label = [UILabel new];
        //label.myWidth = 60;  因为子视图的高度在布局视图的setSubviewsSize:minSpace:maxSpace:中设置了，你也可以在这里单独为每个子视图设置宽度，当然如果你的父布局视图使用了gravity来设置填充属性的话，那么子视图是不需要单独设置宽度尺寸的。
        label.text = [NSString stringWithFormat:@"%d", i];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [CFTool color:3];;
        [horzLayout addSubview:label];
    }
    
    
    MyFlowLayout *vertLayout2 = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    vertLayout2.padding = UIEdgeInsetsMake(5, 0, 5, 0);
    vertLayout2.backgroundColor = [CFTool color:5];
    vertLayout2.subviewVSpace = 20;
    vertLayout2.gravity = MyGravity_Vert_Fill;  //因为上面setSubviewsSize设置了固定宽度，这个属性设置子视图的高度是填充满子布局视图，因此系统内部会自动设置每个子视图的高度，如果你不设置这个属性，那么你就需要在下面分别为每个子视图设置高度。
    [rootLayout addSubview:vertLayout2];
    self.vertLayout2 = vertLayout2;
    
    for (int i = 0; i < 14; i++)
    {
        UILabel *label = [UILabel new];
        //label.myHeight = 60;  因为子视图的宽度在布局视图的setSubviewsSize:minSpace:maxSpace:中设置了，你也可以在这里单独为每个子视图设置高度，当然如果你的父布局视图使用了gravity来设置填充属性的话，那么子视图是不需要单独设置高度尺寸的。
        label.text = [NSString stringWithFormat:@"%d", i];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [CFTool color:2];
        [vertLayout2 addSubview:label];
    }
    
    
    
    MyFlowLayout *horzLayout2 = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:0];
    
    horzLayout2.padding = UIEdgeInsetsMake(0, 5, 0, 5);
    horzLayout2.backgroundColor = [CFTool color:6];
    horzLayout2.subviewHSpace = 20;
    horzLayout2.gravity = MyGravity_Horz_Fill; //因为上面setSubviewsSize设置了固定高度，这个属性设置子视图的宽度是填充满子布局视图，因此系统内部会自动设置每个子视图的宽度，如果你不设置这个属性，那么你就需要在下面分别为每个子视图设置宽度。
    [rootLayout addSubview:horzLayout2];
    self.horzLayout2 = horzLayout2;
    
    for (int i = 0; i < 14; i++)
    {
        UILabel *label = [UILabel new];
        //label.myWidth = 60;  因为子视图的高度在布局视图的setSubviewsSize:minSpace:maxSpace:中设置了，你也可以在这里单独为每个子视图设置宽度，当然如果你的父布局视图使用了gravity来设置填充属性的话，那么子视图是不需要单独设置宽度尺寸的。
        label.text = [NSString stringWithFormat:@"%d", i];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [CFTool color:3];;
        [horzLayout2 addSubview:label];
    }
    
    
    //这个垂直流式布局中，每个子视图之间的水平间距是浮动的，并且子视图的宽度是固定为60。间距最小为10，最大不限制。
    [vertLayout setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:NO];

    //这个水平流式布局中，每个子视图之间的垂直间距是浮动的，并且子视图的高度是固定为60。间距最小为10，最大不限制。
    [horzLayout setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:NO];

    //这个垂直流式布局中，每个子视图之间的水平间距是浮动的，并且子视图的宽度是固定为60。间距最小为10，最大不限制。
    [vertLayout2 setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:NO];

    //这个水平流式布局中，每个子视图之间的垂直间距是浮动的，并且子视图的高度是固定为60。间距最小为10，最大不限制。
    [horzLayout2 setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"center off" style:UIBarButtonItemStylePlain target:self action:@selector(handleCenterOnOff:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)handleCenterOnOff:(UIBarButtonItem*)sender {
    
    if ([sender.title isEqualToString:@"center off"]) {
        sender.title = @"center on";
        [self.vertLayout setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:YES];
        [self.horzLayout setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:YES];
        [self.vertLayout2 setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:YES];
        [self.horzLayout2 setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:YES];

    } else {
        sender.title = @"center off";
        [self.vertLayout setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:NO];
        [self.horzLayout setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:NO];
        [self.vertLayout2 setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:NO];
        [self.horzLayout2 setSubviewsSize:60 minSpace:10 maxSpace:CGFLOAT_MAX centered:NO];
    }
    
    [self.vertLayout layoutAnimationWithDuration:0.3];
    [self.horzLayout layoutAnimationWithDuration:0.3];
    [self.vertLayout2 layoutAnimationWithDuration:0.3];
    [self.horzLayout2 layoutAnimationWithDuration:0.3];
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

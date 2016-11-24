//
//  Test13ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/26.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "RLTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@implementation RLTest1ViewController

-(void)loadView
{
    /*
       这个DEMO，主要介绍相对布局里面的子视图如果通过扩展属性MyLayoutPos对象属性来设置各视图之间的依赖关系。
       苹果系统原生的AutoLayout其本质就是一套相对布局体系。但是MyRelativeLayout所具有的功能比AutoLayout还要强大。
     */
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.view = rootLayout;

    /*
       顶部区域部分
     */
    UILabel *todayLabel = [UILabel new];
    todayLabel.text = @"Today";
    todayLabel.font = [CFTool font:17];
    todayLabel.textColor = [CFTool color:4];
    [todayLabel sizeToFit];
    todayLabel.centerXPos.equalTo(@0);  //水平中心点在父布局水平中心点的偏移为0，意味着和父视图水平居中对齐。
    todayLabel.topPos.equalTo(@20);     //顶部离父视图的边距为20
    [rootLayout addSubview:todayLabel];
    
    
    /*
       左上角区域部分
     */
    UIView *topLeftCircle = [UIView new];
    topLeftCircle.backgroundColor = [CFTool color:2];
    topLeftCircle.widthDime.equalTo(rootLayout.widthDime).multiply(3/5.0).max(200); //宽度是父视图宽度的3/5,且最大只能是200。
    topLeftCircle.heightDime.equalTo(topLeftCircle.widthDime);    //高度和自身宽度相等。
    topLeftCircle.leftPos.equalTo(@10);    //左边距离父视图10
    topLeftCircle.topPos.equalTo(@90);     //顶部距离父视图90
    [rootLayout addSubview:topLeftCircle];
    
    __weak UIView* weakGreenCircle = topLeftCircle;
    rootLayout.rotationToDeviceOrientationBlock = ^(MyBaseLayout *layout, BOOL isFirst, BOOL isPortrait)
    {//rotationToDeviceOrientationBlock是在布局视图第一次布局后或者有屏幕旋转时给布局视图一个机会进行一些特殊设置的block。这里面我们将子视图的半径设置为尺寸的一半，这样就可以实现在任意的屏幕上，这个子视图总是呈现为圆形。这里rotationToDeviceOrientationBlock和子视图的viewLayoutCompleteBlock的区别是前者是针对布局的，后者是针对子视图的。前者是在布局视图第一次完成布局或者后续屏幕有变化时布局视图调用，而后者则是子视图在布局视图完成后调用。
        //这里不用子视图的viewLayoutCompleteBlock原因是，viewLayoutCompleteBlock只会在布局后执行一次，无法捕捉屏幕旋转的情况，而因为这里面的子视图的宽度是依赖于父视图的，所以必须要用rotationToDeviceOrientationBlock来实现。
        weakGreenCircle.layer.cornerRadius = weakGreenCircle.frame.size.width / 2;

    };

    
    UILabel *walkLabel = [UILabel new];
    walkLabel.text = @"Walk";
    walkLabel.textColor = [CFTool color:5];
    walkLabel.font = [CFTool font:15];
    [walkLabel sizeToFit];
    walkLabel.centerXPos.equalTo(topLeftCircle.centerXPos);      //水平中心点和greenCircle水平中心点一致，意味着和greenCircle水平居中对齐。
    walkLabel.bottomPos.equalTo(topLeftCircle.topPos).offset(5);  //底部是greenCircle的顶部再往上偏移5个点。
    [rootLayout addSubview:walkLabel];
    
    
    UILabel *walkSteps = [UILabel new];
    walkSteps.text = @"9,362";
    walkSteps.font = [CFTool font:15];
    walkSteps.textColor = [CFTool color:0];
    [walkSteps sizeToFit];
    walkSteps.centerXPos.equalTo(topLeftCircle.centerXPos);
    walkSteps.centerYPos.equalTo(topLeftCircle.centerYPos);   //水平中心点和垂直中心点都和greenCircle一样，意味着二者居中对齐。
    [rootLayout addSubview:walkSteps];
    
    UILabel *steps = [UILabel new];
    steps.text = @"steps";
    steps.textColor = [CFTool color:8];
    steps.font = [CFTool font:15];
    [steps sizeToFit];
    steps.centerXPos.equalTo(walkSteps.centerXPos);  //和walkSteps水平居中对齐。
    steps.topPos.equalTo(walkSteps.bottomPos);       //顶部是walkSteps的底部。
    [rootLayout addSubview:steps];
    
    
    /*
      右上角区域部分
     */
    UIView *topRightCircle = [UIView new];
    topRightCircle.backgroundColor = [CFTool color:3];
    topRightCircle.topPos.equalTo(topLeftCircle.topPos).offset(-10);  //顶部和greenCircle顶部对齐，并且往上偏移10个点。
    topRightCircle.rightPos.equalTo(rootLayout.rightPos).offset(10);  //右边和布局视图右对齐，并且往左边偏移10个点。
    topRightCircle.widthDime.equalTo(@120);                           //宽度是120
    topRightCircle.heightDime.equalTo(topRightCircle.widthDime);           //高度和宽度相等。
    topRightCircle.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
    {//viewLayoutCompleteBlock是在子视图布局完成后给子视图一个机会进行一些特殊设置的block。这里面我们将子视图的半径设置为尺寸的一半，这样就可以实现在任意的屏幕上，这个子视图总是呈现为圆形。viewLayoutCompleteBlock只会在布局完成后调用一次，就会被布局系统销毁。
        sbv.layer.cornerRadius = sbv.frame.size.width / 2;
    };
    [rootLayout addSubview:topRightCircle];
    
    
    UILabel *cycleLabel = [UILabel new];
    cycleLabel.text = @"Cycle";
    cycleLabel.textColor = [CFTool color:6];
    cycleLabel.font = [CFTool font:15];
    [cycleLabel sizeToFit];
    cycleLabel.centerXPos.equalTo(topRightCircle.centerXPos);        //和blueCircle水平居中对齐
    cycleLabel.bottomPos.equalTo(topRightCircle.topPos).offset(5);   //底部在blueCircle的上面，再往下偏移5个点。
    [rootLayout addSubview:cycleLabel];
    
    
    UILabel *cycleMin = [UILabel new];
    cycleMin.text = @"39 Min";
    cycleMin.textColor = [CFTool color:0];
    cycleMin.font = [CFTool font:15];
    [cycleMin sizeToFit];
    cycleMin.leftPos.equalTo(topRightCircle.leftPos);     //左边和blueCircle左对齐
    cycleMin.centerYPos.equalTo(topRightCircle.centerYPos);  //和blueCircle垂直居中对齐。
    [rootLayout addSubview:cycleMin];
    
 
    /*
       中间区域部分
     */
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [CFTool color:7];
    lineView1.leftPos.equalTo(@0);
    lineView1.rightPos.equalTo(@0);  //和父布局的左右边距为0，这个也同时确定了视图的宽度和父视图一样。
    lineView1.heightDime.equalTo(@2);  //高度固定为2
    lineView1.centerYPos.equalTo(@0);   //和父视图垂直居中对齐。
    [rootLayout addSubview:lineView1];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [CFTool color:8];
    lineView2.widthDime.equalTo(rootLayout.widthDime).add(-20);  //宽度等于父视图的宽度减20
    lineView2.heightDime.equalTo(@2);                            //高度固定为2
    lineView2.topPos.equalTo(lineView1.bottomPos).offset(2);    //顶部在lineView1的下面往下偏移2
    lineView2.centerXPos.equalTo(rootLayout.centerXPos);       //和父视图水平居中对齐
    [rootLayout addSubview:lineView2];
    
    /*
       左下角区域部分。
     */
    UIView *bottomHalfCircleView = [UIView new];
    bottomHalfCircleView.backgroundColor = [CFTool color:5];
    bottomHalfCircleView.layer.cornerRadius = 25;
    bottomHalfCircleView.widthDime.equalTo(@50);      //宽度固定为50
    bottomHalfCircleView.heightDime.equalTo(bottomHalfCircleView.widthDime);  //高度等于宽度
    bottomHalfCircleView.centerYPos.equalTo(rootLayout.bottomPos).offset(10); //垂直中心点和父布局的底部对齐，并且往下偏移10个点。 因为rootLayout设置了bottomPadding为10，所以这里要偏移10，否则不需要设置偏移。
    bottomHalfCircleView.leftPos.equalTo(rootLayout.leftPos).offset(50); //左边父布局左对齐，并且向右偏移50个点。
    [rootLayout addSubview:bottomHalfCircleView];

    
    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = [CFTool color:5];
    lineView3.widthDime.equalTo(@5);
    lineView3.heightDime.equalTo(@50);
    lineView3.bottomPos.equalTo(bottomHalfCircleView.topPos);
    lineView3.centerXPos.equalTo(bottomHalfCircleView.centerXPos);
    [rootLayout addSubview:lineView3];
    
    
    UILabel *walkLabel2 = [UILabel new];
    walkLabel2.text = @"Walk";
    walkLabel2.font = [CFTool font:15];
    walkLabel2.textColor = [CFTool color:11];
    [walkLabel2 sizeToFit];
    walkLabel2.leftPos.equalTo(lineView3.rightPos).offset(15);
    walkLabel2.centerYPos.equalTo(lineView3.centerYPos);
    [rootLayout addSubview:walkLabel2];
    
    
    UILabel *walkLabel3 = [UILabel new];
    walkLabel3.text = @"18 Min";
    walkLabel3.font = [CFTool font:15];
    walkLabel3.textColor = [CFTool color:12];
    [walkLabel3 sizeToFit];
    walkLabel3.leftPos.equalTo(walkLabel2.rightPos).offset(5);
    walkLabel3.centerYPos.equalTo(walkLabel2.centerYPos);
    [rootLayout addSubview:walkLabel3];

    UILabel *timeLabel1 = [UILabel new];
    timeLabel1.text = @"9:12";
    timeLabel1.font = [CFTool font:14];
    timeLabel1.textColor = [CFTool color:12];
    [timeLabel1 sizeToFit];
    timeLabel1.rightPos.equalTo(lineView3.leftPos).offset(25);
    timeLabel1.centerYPos.equalTo(lineView3.topPos);
    [rootLayout addSubview:timeLabel1];
    
    
    UILabel *timeLabel2 = [UILabel new];
    timeLabel2.text = @"9:30";
    timeLabel2.font = [CFTool font:14];
    timeLabel2.textColor = [CFTool color:12];
    [timeLabel2 sizeToFit];
    timeLabel2.rightPos.equalTo(timeLabel1.rightPos);
    timeLabel2.centerYPos.equalTo(lineView3.bottomPos);
    [rootLayout addSubview:timeLabel2];
    
    
    
    UIView *lineView4 = [UIView new];
    lineView4.backgroundColor = [CFTool color:5];
    lineView4.layer.cornerRadius = 25;
    lineView4.widthDime.equalTo(bottomHalfCircleView.widthDime);
    lineView4.heightDime.equalTo(lineView4.widthDime).add(30);
    lineView4.bottomPos.equalTo(lineView3.topPos);
    lineView4.centerXPos.equalTo(lineView3.centerXPos);
    [rootLayout addSubview:lineView4];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    imageView4.widthDime.equalTo(lineView4.widthDime).multiply(1/3.0);
    imageView4.heightDime.equalTo(imageView4.widthDime);
    imageView4.centerXPos.equalTo(lineView4.centerXPos);
    imageView4.centerYPos.equalTo(lineView4.centerYPos);
    [rootLayout addSubview:imageView4];
    
    
    UILabel *homeLabel = [UILabel new];
    homeLabel.text = @"Home";
    homeLabel.font = [CFTool font:15];
    homeLabel.textColor = [CFTool color:4];
    [homeLabel sizeToFit];
    homeLabel.leftPos.equalTo(lineView4.rightPos).offset(10);
    homeLabel.centerYPos.equalTo(lineView4.centerYPos);
    [rootLayout addSubview:homeLabel];
    
    /*
      右下角区域部分。
     */
    UIImageView *bottomRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head1"]];
    bottomRightImageView.rightPos.equalTo(rootLayout.rightPos);
    bottomRightImageView.bottomPos.equalTo(rootLayout.bottomPos);
    [rootLayout addSubview:bottomRightImageView];

}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

@end

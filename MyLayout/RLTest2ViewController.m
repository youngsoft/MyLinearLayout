//
//  Test14ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/6.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "RLTest2ViewController.h"
#import "MyLayout.h"

@interface RLTest2ViewController ()

@property(nonatomic,strong) UIButton *hiddenButton;

@end

@implementation RLTest2ViewController



-(void)loadView
{
    /*
       这个例子展示的是相对布局里面 多个子视图按比例分配宽度或者高度的实现机制，通过对子视图扩展的MyLayoutDime尺寸对象的equalTo方法的值设置为一个数组对象，即可实现尺寸的按比例分配能力。而这个方法要比AutoLayout实现起来要简单的多。
     */
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 10);
    rootLayout.backgroundColor = [UIColor grayColor];
    self.view = rootLayout;
    
    UISwitch *hiddenSwitch = [UISwitch new];
    [hiddenSwitch addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventValueChanged];
    hiddenSwitch.rightPos.equalTo(@0);
    hiddenSwitch.topPos.equalTo(@10);
    [rootLayout addSubview:hiddenSwitch];
    
    UILabel *hiddenSwitchLabel = [UILabel new];
    hiddenSwitchLabel.text = @"隐藏时伸缩其他子视图:";
    [hiddenSwitchLabel sizeToFit];
    hiddenSwitchLabel.leftPos.equalTo(@10);
    hiddenSwitchLabel.centerYPos.equalTo(hiddenSwitch.centerYPos);
    [rootLayout addSubview:hiddenSwitchLabel];
    
    
    /**水平平分3个子视图**/
    UIButton *v1 = [UIButton new];
    v1.backgroundColor = [UIColor redColor];
    [v1 setTitle:@"平均1/3宽度\n切换上面开关试试" forState:UIControlStateNormal];
    v1.titleLabel.numberOfLines = 2;
    v1.titleLabel.adjustsFontSizeToFitWidth = YES;
    v1.titleLabel.textAlignment = NSTextAlignmentCenter;
    v1.heightDime.equalTo(@40);
    v1.topPos.equalTo(@60);
    v1.leftPos.equalTo(@10);
    [rootLayout addSubview:v1];
    
    
    UIButton *v2 = [UIButton new];
    v2.backgroundColor = [UIColor redColor];
    [v2 setTitle:@"平均1/3宽度\n点击我隐藏" forState:UIControlStateNormal];
    [v2 addTarget:self action:@selector(handleHidden:) forControlEvents:UIControlEventTouchUpInside];
    v2.titleLabel.numberOfLines = 2;
    v2.titleLabel.adjustsFontSizeToFitWidth = YES;
    v2.titleLabel.textAlignment = NSTextAlignmentCenter;
    v2.heightDime.equalTo(v1.heightDime);
    v2.topPos.equalTo(v1.topPos);
    v2.leftPos.equalTo(v1.rightPos).offset(10);
    [rootLayout addSubview:v2];
    

    UIButton *v3 = [UIButton new];
    v3.backgroundColor = [UIColor redColor];
    [v3 setTitle:@"平均1/3宽度\n点击我恢复" forState:UIControlStateNormal];
    [v3 addTarget:self action:@selector(handleShow:) forControlEvents:UIControlEventTouchUpInside];
    v3.titleLabel.numberOfLines = 2;
    v3.titleLabel.adjustsFontSizeToFitWidth = YES;
    v3.titleLabel.textAlignment = NSTextAlignmentCenter;
    v3.heightDime.equalTo(v1.heightDime);
    v3.topPos.equalTo(v1.topPos);
    v3.leftPos.equalTo(v2.rightPos).offset(10);
    [rootLayout addSubview:v3];
    

    //v1,v2,v3平分父视图的宽度。因为每个子视图之间都有10的间距，因此平分时要减去这个间距值。这里的宽度通过设置等于数组来完成均分。
    v1.widthDime.equalTo(@[v2.widthDime.add(-10), v3.widthDime.add(-10)]).add(-10);
    

    
    /**某个视图宽度固定其他平分**/
    UILabel *v4 = [UILabel new];
    v4.backgroundColor = [UIColor greenColor];
    v4.text = @"固定宽度为260";
    v4.adjustsFontSizeToFitWidth = YES;
    v4.textAlignment = NSTextAlignmentCenter;
    v4.topPos.equalTo(v1.bottomPos).offset(30);
    v4.leftPos.equalTo(@10);
    v4.heightDime.equalTo(@40);
    v4.widthDime.equalTo(@160); //第一个视图宽度固定
    [rootLayout addSubview:v4];
    
    
    UILabel *v5 = [UILabel new];
    v5.backgroundColor = [UIColor greenColor];
    v5.text = @"剩余1/2宽度";
    v5.adjustsFontSizeToFitWidth = YES;
    v5.textAlignment = NSTextAlignmentCenter;
    v5.topPos.equalTo(v4.topPos);
    v5.leftPos.equalTo(v4.rightPos).offset(10);
    v5.heightDime.equalTo(v4.heightDime);
    [rootLayout addSubview:v5];
    

    UILabel *v6 = [UILabel new];
    v6.backgroundColor = [UIColor greenColor];
    v6.text = @"剩余1/2宽度";
    v6.adjustsFontSizeToFitWidth = YES;
    v6.textAlignment = NSTextAlignmentCenter;
    v6.topPos.equalTo(v4.topPos);
    v6.leftPos.equalTo(v5.rightPos).offset(10);
    v6.heightDime.equalTo(v4.heightDime);
    [rootLayout addSubview:v6];
    
    
    //v4固定,v5,v6按一定的比例来平分父视图的宽度，这里同样也是因为每个子视图之间有间距，因此都要减10
    v5.widthDime.equalTo(@[v4.widthDime.add(-10), v6.widthDime.add(-10)]).add(-10);
    
    
    
    
    /**子视图按比例平分**/
    UILabel *v7 = [UILabel new];
    v7.backgroundColor = [UIColor blueColor];
    v7.text = @"2/10比例宽度";
    v7.adjustsFontSizeToFitWidth = YES;
    v7.textAlignment = NSTextAlignmentCenter;
    v7.topPos.equalTo(v4.bottomPos).offset(30);
    v7.leftPos.equalTo(@10);
    v7.heightDime.equalTo(@40);
    [rootLayout addSubview:v7];
    
    
    UILabel *v8 = [UILabel new];
    v8.backgroundColor = [UIColor blueColor];
    v8.text = @"3/10比例宽度";
    v8.adjustsFontSizeToFitWidth = YES;
    v8.textAlignment = NSTextAlignmentCenter;
    v8.topPos.equalTo(v7.topPos);
    v8.leftPos.equalTo(v7.rightPos).offset(10);
    v8.heightDime.equalTo(v7.heightDime);
    [rootLayout addSubview:v8];
    
    
    UILabel *v9 = [UILabel new];
    v9.backgroundColor = [UIColor blueColor];
    v9.text = @"5/10比例宽度";
    v9.adjustsFontSizeToFitWidth = YES;
    v9.textAlignment = NSTextAlignmentCenter;
    v9.topPos.equalTo(v7.topPos);
    v9.leftPos.equalTo(v8.rightPos).offset(10);
    v9.heightDime.equalTo(v7.heightDime);
    [rootLayout addSubview:v9];
    
    //v7,v8,v9按照2：3：5的比例均分父视图。
    v7.widthDime.equalTo(@[v8.widthDime.multiply(0.3).add(-10),v9.widthDime.multiply(0.5).add(-10)]).multiply(0.2).add(-10);
    
    
    /*
       下面部分是一个高度均分的实现方法。
     */
    
    MyRelativeLayout * bottomLayout = [MyRelativeLayout new];
    bottomLayout.backgroundColor = [UIColor lightGrayColor];
    bottomLayout.leftPos.equalTo(@10);
    bottomLayout.rightPos.equalTo(@0);
    bottomLayout.topPos.equalTo(v7.bottomPos).offset(30);
    bottomLayout.bottomPos.equalTo(@10);
    [rootLayout addSubview:bottomLayout];
    
    /*高度均分*/
    UIView *v10 = [UIView new];
    v10.backgroundColor = [UIColor redColor];
    v10.widthDime.equalTo(@40);
    v10.rightPos.equalTo(bottomLayout.centerXPos).offset(50);
    v10.topPos.equalTo(@10);
    [bottomLayout addSubview:v10];
    
    UIView *v11 = [UIView new];
    v11.backgroundColor = [UIColor redColor];
    v11.widthDime.equalTo(v10.widthDime);
    v11.rightPos.equalTo(v10.rightPos);
    v11.topPos.equalTo(v10.bottomPos).offset(10);
    [bottomLayout addSubview:v11];

    //V10,V11实现了高度均分
    v10.heightDime.equalTo(@[v11.heightDime.add(-20)]).add(-10);
    
    
    UIView *v12 = [UIView new];
    v12.backgroundColor = [UIColor greenColor];
    v12.widthDime.equalTo(@40);
    v12.leftPos.equalTo(bottomLayout.centerXPos).offset(50);
    v12.topPos.equalTo(@10);
    [bottomLayout addSubview:v12];
    
    UIView *v13 = [UIView new];
    v13.backgroundColor = [UIColor greenColor];
    v13.widthDime.equalTo(v12.widthDime);
    v13.leftPos.equalTo(v12.leftPos);
    v13.topPos.equalTo(v12.bottomPos).offset(10);
    [bottomLayout addSubview:v13];
    
    UIView *v14 = [UIView new];
    v14.backgroundColor = [UIColor greenColor];
    v14.widthDime.equalTo(v12.widthDime);
    v14.leftPos.equalTo(v12.leftPos);
    v14.topPos.equalTo(v13.bottomPos).offset(10);
    [bottomLayout addSubview:v14];
    
    //注意这里最后一个偏移-20，也能达到和底部边距的效果。
    v12.heightDime.equalTo(@[v13.heightDime.add(-10),v14.heightDime.add(-20)]).add(-10);
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Handle Method

-(void)handleSwitch:(id)sender
{
    //flexOtherViewWidthWhenSubviewHidden这个相对布局的属性表示当某个均分宽度的视图隐藏后，是否会激发剩余的子视图重新均分宽度。
    MyRelativeLayout *rl = (MyRelativeLayout*)self.view;
    rl.flexOtherViewWidthWhenSubviewHidden = !rl.flexOtherViewWidthWhenSubviewHidden;
}

-(void)handleHidden:(UIButton*)sender
{
    sender.hidden = YES;
    self.hiddenButton = sender;
}

-(void)handleShow:(UIButton*)sender
{
    if (self.hiddenButton != nil)
    {
        self.hiddenButton.hidden = NO;
        self.hiddenButton = nil;
    }
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

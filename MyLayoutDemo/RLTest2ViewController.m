//
//  RLTest2ViewController.m
//  MyLayout
//
//  Created by oybq on 15/7/6.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "RLTest2ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface RLTest2ViewController ()

@property(nonatomic,strong) UIButton *visibilityButton;
@property(nonatomic, strong) UISwitch *visibilitySwitch;

@end

@implementation RLTest2ViewController

-(UIButton*)createButton:(NSString*)title backgroundColor:(UIColor*)color
{
    UIButton *v = [UIButton new];
    v.backgroundColor = color;
    [v setTitle:title forState:UIControlStateNormal];
    [v setTitleColor:[CFTool color:4] forState:UIControlStateNormal];
    v.titleLabel.font = [CFTool font:14];
    v.titleLabel.numberOfLines = 2;
    v.titleLabel.adjustsFontSizeToFitWidth = YES;
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [CFTool color:4].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;


    return v;
}

-(void)loadView
{
    /*
       这个例子展示的是相对布局里面 多个子视图按比例分配宽度或者高度的实现机制，通过对子视图扩展的MyLayoutSize尺寸对象的equalTo方法的值设置为一个数组对象，即可实现尺寸的按比例分配能力。
     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.trailingPadding = 10;
    self.view = rootLayout;
    
    UISwitch *visibilitySwitch = [UISwitch new];
    visibilitySwitch.trailingPos.equalTo(@0);
    visibilitySwitch.topPos.equalTo(@10);
    [rootLayout addSubview:visibilitySwitch];
    self.visibilitySwitch = visibilitySwitch;
    
    UILabel *visibilitySwitchLabel = [UILabel new];
    visibilitySwitchLabel.text = NSLocalizedString(@"flex size when subview hidden switch:", @"");
    visibilitySwitchLabel.textColor = [CFTool color:4];
    visibilitySwitchLabel.font = [CFTool font:15];
    [visibilitySwitchLabel sizeToFit];
    visibilitySwitchLabel.leadingPos.equalTo(@10);
    visibilitySwitchLabel.centerYPos.equalTo(visibilitySwitch.centerYPos);
    [rootLayout addSubview:visibilitySwitchLabel];
    
    
    /**水平平分3个子视图**/
    UIButton *v1 = [self createButton:NSLocalizedString(@"average 1/3 width\nturn above switch", @"") backgroundColor:[CFTool color:5]];
    v1.heightSize.equalTo(@40);
    v1.topPos.equalTo(@60);
    v1.leadingPos.equalTo(@10);
    [rootLayout addSubview:v1];
    
    
    UIButton *v2 = [self createButton:NSLocalizedString(@"average 1/3 width\nhide me", @"") backgroundColor:[CFTool color:6]];
    [v2 addTarget:self action:@selector(handleHidden:) forControlEvents:UIControlEventTouchUpInside];
    v2.heightSize.equalTo(v1.heightSize);
    v2.topPos.equalTo(v1.topPos);
    v2.leadingPos.equalTo(v1.trailingPos).offset(10);
    [rootLayout addSubview:v2];
    self.visibilityButton = v2;
    

    UIButton *v3 = [self createButton:NSLocalizedString(@"average 1/3 width\nshow me", @"") backgroundColor:[CFTool color:7]];
    [v3 addTarget:self action:@selector(handleShow:) forControlEvents:UIControlEventTouchUpInside];
    v3.heightSize.equalTo(v1.heightSize);
    v3.topPos.equalTo(v1.topPos);
    v3.leadingPos.equalTo(v2.trailingPos).offset(10);
    [rootLayout addSubview:v3];
    

    //v1,v2,v3平分父视图的宽度。因为每个子视图之间都有10的间距，因此平分时要减去这个间距值。这里的宽度通过设置等于数组来完成均分。
    v1.widthSize.equalTo(@[v2.widthSize.add(-10), v3.widthSize.add(-10)]).add(-10);
    

    
    /**某个视图宽度固定其他平分**/
    UIButton *v4 = [self createButton:NSLocalizedString(@"width equal to 260", @"") backgroundColor:[CFTool color:5]];
    v4.topPos.equalTo(v1.bottomPos).offset(30);
    v4.leadingPos.equalTo(@10);
    v4.heightSize.equalTo(@40);
    v4.widthSize.equalTo(@160); //第一个视图宽度固定
    [rootLayout addSubview:v4];
    
    
    UIButton *v5 = [self createButton:NSLocalizedString(@"1/2 with of free superview", @"") backgroundColor:[CFTool color:6]];
    v5.topPos.equalTo(v4.topPos);
    v5.leadingPos.equalTo(v4.trailingPos).offset(10);
    v5.heightSize.equalTo(v4.heightSize);
    [rootLayout addSubview:v5];
    

    UIButton *v6 = [self createButton:NSLocalizedString(@"1/2 with of free superview", @"") backgroundColor:[CFTool color:7]];
    v6.topPos.equalTo(v4.topPos);
    v6.leadingPos.equalTo(v5.trailingPos).offset(10);
    v6.heightSize.equalTo(v4.heightSize);
    [rootLayout addSubview:v6];
    
    
    //v4宽度固定,v5,v6按一定的比例来平分父视图的宽度，这里同样也是因为每个子视图之间有间距，因此都要减10
    v5.widthSize.equalTo(@[v4.widthSize.add(-10), v6.widthSize.add(-10)]).add(-10);
    
    
    
    
    /**子视图按比例平分**/
    UIButton *v7 = [self createButton:NSLocalizedString(@"20% with of superview", @"") backgroundColor:[CFTool color:5]];
    v7.topPos.equalTo(v4.bottomPos).offset(30);
    v7.leadingPos.equalTo(@10);
    v7.heightSize.equalTo(@40);
    [rootLayout addSubview:v7];
    
    
    UIButton *v8 = [self createButton:NSLocalizedString(@"30% with of superview", @"") backgroundColor:[CFTool color:6]];
    v8.topPos.equalTo(v7.topPos);
    v8.leadingPos.equalTo(v7.trailingPos).offset(10);
    v8.heightSize.equalTo(v7.heightSize);
    [rootLayout addSubview:v8];
    
    
    UIButton *v9 = [self createButton:NSLocalizedString(@"50% with of superview", @"") backgroundColor:[CFTool color:7]];
    v9.topPos.equalTo(v7.topPos);
    v9.leadingPos.equalTo(v8.trailingPos).offset(10);
    v9.heightSize.equalTo(v7.heightSize);
    [rootLayout addSubview:v9];
    
    //v7,v8,v9按照2：3：5的比例均分父视图。
    v7.widthSize.equalTo(@[v8.widthSize.multiply(0.3).add(-10),v9.widthSize.multiply(0.5).add(-10)]).multiply(0.2).add(-10);
    
    
    /*
       下面部分是一个高度均分的实现方法。
     */
    
    MyRelativeLayout * bottomLayout = [MyRelativeLayout new];
    bottomLayout.backgroundColor = [CFTool color:0];
    bottomLayout.leadingPos.equalTo(@10);
    bottomLayout.trailingPos.equalTo(@0);
    bottomLayout.topPos.equalTo(v7.bottomPos).offset(30);
    bottomLayout.bottomPos.equalTo(@10);
    [rootLayout addSubview:bottomLayout];
    
    /*高度均分*/
    UIButton *v10 = [self createButton:@"1/2" backgroundColor:[CFTool color:5]];
    v10.widthSize.equalTo(@40);
    v10.trailingPos.equalTo(bottomLayout.centerXPos).offset(50);
    v10.topPos.equalTo(@10);
    [bottomLayout addSubview:v10];
    
    UIButton *v11 = [self createButton:@"1/2" backgroundColor:[CFTool color:6]];
    v11.widthSize.equalTo(v10.widthSize);
    v11.trailingPos.equalTo(v10.trailingPos);
    v11.topPos.equalTo(v10.bottomPos).offset(10);
    [bottomLayout addSubview:v11];

    //V10,V11实现了高度均分
    v10.heightSize.equalTo(@[v11.heightSize.add(-20)]).add(-10);
    
    
    UIButton *v12 = [self createButton:@"1/3" backgroundColor:[CFTool color:5]];
    v12.widthSize.equalTo(@40);
    v12.leadingPos.equalTo(bottomLayout.centerXPos).offset(50);
    v12.topPos.equalTo(@10);
    [bottomLayout addSubview:v12];
    
    UIButton *v13 = [self createButton:@"1/3" backgroundColor:[CFTool color:6]];
    v13.widthSize.equalTo(v12.widthSize);
    v13.leadingPos.equalTo(v12.leadingPos);
    v13.topPos.equalTo(v12.bottomPos).offset(10);
    [bottomLayout addSubview:v13];
    
    UIButton *v14 = [self createButton:@"1/3" backgroundColor:[CFTool color:7]];
    v14.widthSize.equalTo(v12.widthSize);
    v14.leadingPos.equalTo(v12.leadingPos);
    v14.topPos.equalTo(v13.bottomPos).offset(10);
    [bottomLayout addSubview:v14];
    
    //注意这里最后一个偏移-20，也能达到和底部边距的效果。
    v12.heightSize.equalTo(@[v13.heightSize.add(-10),v14.heightSize.add(-20)]).add(-10);
    
    
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

-(void)handleHidden:(UIButton*)sender
{
    if (self.visibilitySwitch.isOn)
    {
        self.visibilityButton.myVisibility = MyVisibility_Gone;
    }
    else
    {
        self.visibilityButton.myVisibility = MyVisibility_Invisible;
    }

}

-(void)handleShow:(UIButton*)sender
{
    self.visibilityButton.myVisibility = MyVisibility_Visible;
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

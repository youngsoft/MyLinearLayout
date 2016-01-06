//
//  Test11ViewController.m
//  YSLayout
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "AllTest2ViewController.h"
#import "YSLayout.h"

@interface AllTest2ViewController ()

@end

@implementation AllTest2ViewController

-(void)loadView
{
    //上下均分和左右均分
    
    
    //线性布局实现
   /* YSLinearLayout *rootLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor grayColor];
    
    rootLayout.ysPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    rootLayout.subviewMargin = 20;
    
    YSLinearLayout *topLayout = [YSLinearLayout linearLayoutWithOrientation:YSLayoutViewOrientation_Horz];
    topLayout.weight = 0.5;
    topLayout.ysLeftMargin = topLayout.ysRightMargin = 0;
    topLayout.subviewMargin = 20;
    [rootLayout addSubview:topLayout];
    
    UIView *topLeft = UIView.new;
    topLeft.backgroundColor = [UIColor redColor];
    
    topLeft.weight = 0.5;
    topLeft.ysTopMargin = topLeft.ysBottomMargin = 0;
    [topLayout addSubview:topLeft];
    
    UIView *topRight = UIView.new;
    topRight.backgroundColor = [UIColor greenColor];
    topRight.weight = 0.5;
    topRight.ysTopMargin = topRight.ysBottomMargin = 0;
    [topLayout addSubview:topRight];
    
    
    UIView *bottom = UIView.new;
    bottom.backgroundColor = [UIColor blueColor];
    bottom.weight = 0.5;
    bottom.widthDime.equalTo(rootLayout.widthDime);
    // bottom.ysLeftMargin = bottom.ysRightMargin = 0; 这句和上面一句是等价的。
    [rootLayout addSubview:bottom];
    
    self.view = rootLayout; */
    
    
    //相对布局实现
   /*  YSRelativeLayout *rootLayout = [YSRelativeLayout new];
    rootLayout.backgroundColor = [UIColor grayColor];
    rootLayout.ysPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    
    UIView *topLeft = [UIView new];
    topLeft.backgroundColor = [UIColor redColor];
    
    UIView *topRight = [UIView new];
    topRight.backgroundColor = [UIColor greenColor];
    
    UIView *bottom = [UIView new];
    bottom.backgroundColor = [UIColor blueColor];
    
    [rootLayout addSubview:topLeft];
    [rootLayout addSubview:topRight];
    [rootLayout addSubview:bottom];
    
    //上下高度平分，高度等于 = 父视图高度 - 20 再平分
    topLeft.heightDime.equalTo(@[bottom.heightDime]).add(-20);
    topLeft.widthDime.equalTo(@[topRight.widthDime]).add(-20);
    topRight.leftPos.equalTo(topLeft.rightPos).offset(20);
    topRight.heightDime.equalTo(topLeft.heightDime);
    bottom.topPos.equalTo(topLeft.bottomPos).offset(20);
    bottom.leftPos.equalTo(rootLayout.leftPos);
    bottom.rightPos.equalTo(rootLayout.rightPos);
    
    self.view = rootLayout;
    */
    
    //表格布局实现
    YSTableLayout *rootLayout = [YSTableLayout tableLayoutWithOrientation:YSLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor grayColor];
    rootLayout.ysPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    rootLayout.subviewMargin = 20;

    [rootLayout addRow:MTLROWHEIGHT_AVERAGE colWidth:MTLCOLWIDTH_AVERAGE];
    UIView *topLeft = UIView.new;
    topLeft.backgroundColor = [UIColor redColor];
    topLeft.ysRightMargin = 10;
    [rootLayout addSubview:topLeft];
    
    UIView *topRight = UIView.new;
    topRight.backgroundColor = [UIColor greenColor];
    topRight.ysLeftMargin = 10;
    [rootLayout addSubview:topRight];
    
    
    [rootLayout addRow:MTLROWHEIGHT_AVERAGE colWidth:MTLCOLWIDTH_AVERAGE];
    UIView *bottom = UIView.new;
    bottom.backgroundColor = [UIColor blueColor];
    [rootLayout addSubview:bottom];
    
    self.view = rootLayout;
    
    
    //框架布局实现
   /* YSFrameLayout *rootLayout = [YSFrameLayout new];
    rootLayout.backgroundColor = [UIColor grayColor];
    rootLayout.ysPadding = UIEdgeInsetsMake(20, 20, 20, 20);

    UIView *topLeft = UIView.new;
    topLeft.backgroundColor = [UIColor redColor];
    topLeft.marginGravity = YSMarignGravity_Horz_Left | YSMarignGravity_Vert_Top;
    topLeft.widthDime.equalTo(rootLayout.widthDime).multiply(0.5).add(-10);
    topLeft.heightDime.equalTo(rootLayout.heightDime).multiply(0.5).add(-10);
    [rootLayout addSubview:topLeft];
    
    UIView *topRight = UIView.new;
    topRight.backgroundColor = [UIColor greenColor];
    topRight.marginGravity = YSMarignGravity_Horz_Right | YSMarignGravity_Vert_Top;
    topRight.widthDime.equalTo(rootLayout.widthDime).multiply(0.5).add(-10);
    topRight.heightDime.equalTo(rootLayout.heightDime).multiply(0.5).add(-10);
    [rootLayout addSubview:topRight];
    
    UIView *bottom = UIView.new;
    bottom.backgroundColor = [UIColor blueColor];
    bottom.marginGravity = YSMarignGravity_Horz_Fill | YSMarignGravity_Vert_Bottom;
    bottom.heightDime.equalTo(rootLayout.heightDime).multiply(0.5).add(-10);
    [rootLayout addSubview:bottom];
    
    self.view = rootLayout;
    */
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"屏幕完美适配";
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

//
//  Test1ViewController.m
//  MyLayout
//
//  Created by oybq on 15/6/21.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "LLTest1ViewController.h"
#import "MyLayout.h"

@interface LLTest1ViewController ()

@end

@implementation LLTest1ViewController

-(void)addVertSubView:(MyLinearLayout*)vertLayout
{
   
    UILabel *v1 = [UILabel new];
    v1.text = @"左边边距";
    v1.textAlignment = NSTextAlignmentCenter;
    v1.adjustsFontSizeToFitWidth = YES;
    v1.backgroundColor = [UIColor redColor];
    [vertLayout addSubview:v1];

    v1.myTopMargin = 10;
    v1.myLeftMargin = 10; //左边边距10
    v1.myWidth = 200;
    v1.myHeight = 25;
        
     
   /*
    您也可以采用如下的语法来专门设置布局属性，详情请参考MyMaker
    [v1 makeLayout:^(MyMaker *make) {
       
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.width.equalTo(@200);
        make.height.equalTo(@25);
    }];
    */
    
    
    
    
    UILabel *v2 = [UILabel new];
    v2.text = @"水平居中";
    v2.textAlignment = NSTextAlignmentCenter;
    v2.adjustsFontSizeToFitWidth = YES;
    v2.backgroundColor = [UIColor greenColor];
    [vertLayout addSubview:v2];

    v2.myTopMargin = 10;
    v2.myCenterXOffset = 0; //水平居中,如果不等于0则会产生偏移
    v2.myWidth = 200;
    v2.myHeight = 25;
    
    
  /*  [v2 makeLayout:^(MyMaker *make) {
        
        make.top.equalTo(@10);
        make.centerX.equalTo(@0);
        make.width.equalTo(@200);
        make.height.equalTo(@25);
        
    }];
  */
    
    UILabel *v3 = [UILabel new];
    v3.text = @"右边边距";
    v3.textAlignment = NSTextAlignmentCenter;
    v3.adjustsFontSizeToFitWidth = YES;
    v3.backgroundColor = [UIColor blueColor];
    [vertLayout addSubview:v3];

    v3.myTopMargin = 10;
    v3.myRightMargin = 10; //右边边距10
    v3.myWidth = 200;
    v3.myHeight = 25;
    
   /* [v3 makeLayout:^(MyMaker *make) {
        
        make.top.equalTo(@10);
        make.right.equalTo(@10);
        make.width.equalTo(@200);
        make.width.equalTo(@25);
        
    }];
  */
    
    
    UILabel *v4 = [UILabel new];
    v4.text = @"左右边距";
    v4.textAlignment = NSTextAlignmentCenter;
    v4.adjustsFontSizeToFitWidth = YES;
    v4.backgroundColor = [UIColor orangeColor];
    [vertLayout addSubview:v4];

    v4.myTopMargin = 10;
    v4.myBottomMargin = 10;
    v4.myLeftMargin = 10;
    v4.myRightMargin = 10; //两边边距为10,如果设置了两边边距则不需要指定宽度了
    v4.myHeight = 25;
    
   /* [v4 makeLayout:^(MyMaker *make) {
        make.margin.equalTo(@10);
        make.height.equalTo(@25);
    }]; */
    
}

-(void)addHorzSubView:(MyLinearLayout*)horzLayout
{    
    UILabel *v1 = [UILabel new];
    v1.text = @"顶部边距";
    v1.textAlignment = NSTextAlignmentCenter;
    v1.adjustsFontSizeToFitWidth = YES;
    v1.backgroundColor = [UIColor redColor];
    [horzLayout addSubview:v1];
    
    v1.myLeftMargin = 10;
    v1.myTopMargin = 10; //顶部边距10
    v1.myWidth = 60;
    v1.myHeight = 60;
    
    /*
    [v1 makeLayout:^(MyMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    */
    
    
    UILabel *v2 = [UILabel new];
    v2.text = @"垂直居中";
    v2.textAlignment = NSTextAlignmentCenter;
    v2.adjustsFontSizeToFitWidth = YES;
    v2.backgroundColor = [UIColor greenColor];
    [horzLayout addSubview:v2];
    
    v2.myLeftMargin = 10;
    v2.myCenterYOffset = 0; //垂直居中，如果不等于0则会产生偏移
    v2.myWidth = 60;
    v2.myHeight = 60;
    
    
    /*[v2 makeLayout:^(MyMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(@0);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    */
    
    
    UILabel *v3 = [UILabel new];
    v3.text = @"底部边距";
    v3.textAlignment = NSTextAlignmentCenter;
    v3.adjustsFontSizeToFitWidth = YES;
    v3.backgroundColor = [UIColor blueColor];
    [horzLayout addSubview:v3];

    v3.myLeftMargin = 10;
    v3.myBottomMargin = 10; //底部边距10
    v3.myRightMargin = 5;
    v3.myWidth = 60;
    v3.myHeight = 60;
    
    /*
    [v3 makeLayout:^(MyMaker *make) {
       
        make.left.equalTo(@10);
        make.bottom.equalTo(@10);
        make.right.equalTo(@5);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    */
    
    
    UILabel *v4 = [UILabel new];
    v4.text = @"上下边距";
    v4.textAlignment = NSTextAlignmentCenter;
    v4.adjustsFontSizeToFitWidth = YES;
    v4.backgroundColor = [UIColor orangeColor];
    [horzLayout addSubview:v4];

    v4.myLeftMargin = 10;
    v4.myRightMargin = 10;
    v4.myTopMargin = 10;
    v4.myBottomMargin = 10; //两边边距为10,如果设置了则不需要指定高度了。
    v4.myWidth = 60;
    
    /*
    [v4 makeLayout:^(MyMaker *make) {
        make.margin.equalTo(@10);
        make.width.equalTo(@60);
    }];*/
}


-(void)loadView
{
    
   // [MyDimeScale sc]
    
    


    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    //如果布局作为视图控制器的视图则请设置wrapContentWidth和wrapContentHeight都为NO,
    rootLayout.wrapContentHeight = NO;
    rootLayout.wrapContentWidth = NO;
    
   /* [rootLayout makeLayout:^(MyMaker *make) {
        make.wrapContentHeight.equalTo(@NO);
        make.wrapContentWidth.equalTo(@NO);
    }];
    */
    
    self.view = rootLayout;
    
    UILabel *vertTitle = [UILabel new];
    vertTitle.text = @"垂直布局(从上到下)";
    
    [vertTitle sizeToFit];
    vertTitle.myCenterXOffset = 0;  //水平居中
    
   /* [vertTitle makeLayout:^(MyMaker *make) {
        [make sizeToFit];
        make.centerX.equalTo(@0);
    }];
    */
    
    [rootLayout addSubview:vertTitle];
    
    MyLinearLayout *vertLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    vertLayout.backgroundColor = [UIColor lightGrayColor];
    
    vertLayout.myLeftMargin = vertLayout.myRightMargin = 0;  //宽度和父视图等宽
    
  /*  [vertLayout makeLayout:^(MyMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        
    }];
    */
    
    [rootLayout addSubview:vertLayout];
    [self addVertSubView:vertLayout];
    
    
    
    UILabel *horzTitle = [UILabel new];
    horzTitle.text = @"水平布局(从左到右)";
   
    
    [horzTitle sizeToFit];
    horzTitle.myCenterXOffset = 0;  //水平居中
    
   /* [horzTitle makeLayout:^(MyMaker *make) {
        
        [make sizeToFit];
        make.centerX.equalTo(@0);
        
    }];*/
    
    [rootLayout addSubview:horzTitle];
    
    MyLinearLayout *horzLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    horzLayout.backgroundColor = [UIColor darkGrayColor];
    
    horzLayout.weight = 1.0;                            //高度占用父视图的剩余高度
   
    /*
    [horzLayout makeLayout:^(MyMaker *make) {
        
        make.weight.equalTo(@1.0);
        
    }];*/
    
    [rootLayout addSubview:horzLayout];
    [self addHorzSubView:horzLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"线性布局-垂直布局和水平布局";
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

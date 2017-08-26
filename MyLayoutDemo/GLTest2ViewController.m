//
//  GLTest1ViewController.m
//  MyLayout
//
//  Created by oubaiquan on 2017/8/20.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "GLTest2ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"


@interface GLTest2ViewController ()

@end

@implementation GLTest2ViewController

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
    rootLayout.subviewSpace = 10;
    rootLayout.padding = UIEdgeInsetsMake(10, 20, 30, 40);
    
    id<MyGrid> g1 = [rootLayout addCol:MTLSIZE_MATCHPARENT];
    id<MyGrid> g2 = [rootLayout addCol:0.5];
    id<MyGrid> g3 = [rootLayout addCol:MTLSIZE_MATCHPARENT];
    id<MyGrid> g4 = [g2 addRow:MTLSIZE_MATCHPARENT];
    
    g4.subviewSpace = 40;
    id<MyGrid> g5 = [g4 addRow:100];
    
    id<MyGrid> g6 = [g4 addRow:200];
    

    //[g1 addGrid:g4.cloneGrid];
  
  
    
  /*  id<MyGrid> g1 = [rootLayout addCol:-0.25];
   id<MyGrid> g2 =  [rootLayout addColGrid:g1.cloneGrid];
   id<MyGrid> g3 = [rootLayout addColGrid:g1.cloneGrid];
   id<MyGrid> g4 = [rootLayout addColGrid:g1.cloneGrid];
  */
    
    g1.rightBorderline = [[MyBorderline alloc] initWithColor:[UIColor blackColor] thick:2];
    g2.bottomBorderline = [[MyBorderline alloc] initWithColor:[UIColor blackColor] thick:2];
    g6.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor blackColor] thick:2];
    g4.rightBorderline = [[MyBorderline alloc] initWithColor:[UIColor blackColor] thick:2];

    
   id<MyGrid> rootGrid = [rootLayout fetchLayoutSizeClass:MySizeClass_Landscape];
    rootGrid.subviewSpace = 10;
    [rootGrid addRowGrid:g1.cloneGrid];
    [rootGrid addRowGrid:g1.cloneGrid];
    [rootGrid addRowGrid:g1.cloneGrid];
    [rootGrid addRowGrid:g1.cloneGrid];

    
    

    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    [rootLayout addSubview:v1];
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor greenColor];
    [rootLayout addSubview:v2];
    
    UIView *v3 = [UIView new];
    v3.backgroundColor = [UIColor blueColor];
    [rootLayout addSubview:v3];
    
    UIView *v4 = [UIView new];
    v4.backgroundColor = [UIColor orangeColor];
    [rootLayout addSubview:v4];

    
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

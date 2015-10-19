//
//  Test3ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test3ViewController.h"
#import "MyLayout.h"

@interface Test3ViewController ()

@property(nonatomic, strong) MyLinearLayout *gravityLayout;

@end

@implementation Test3ViewController


-(void)addSubLayout:(MyLinearLayout*)layout
{
   
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    v1.topMargin = 10;
    v1.leftMargin = 10;
    v1.width = 80;
    v1.height = 40;
    [layout addSubview:v1];
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor greenColor];
    v2.topMargin = 10;
    v2.centerXOffset = 0;
    v2.width = 80;
    v2.height = 40;
    [layout addSubview:v2];
    
    
    UIView *v3 = [UIView new];
    v3.backgroundColor = [UIColor blueColor];
    v3.topMargin = 10;
    v3.rightMargin = 10;
    v3.width = 80;
    v3.height = 40;
    [layout addSubview:v3];
    
    UIView *v4 = [UIView new];
    v4.backgroundColor = [UIColor orangeColor];
    v4.topMargin = 10;
    v4.bottomMargin = 10;
    v4.leftMargin = 10;
    v4.rightMargin = 10;
    v4.width = 80;
    v4.height = 40;
    [layout addSubview:v4];
    
}


-(UIButton*)createActionButton:(NSString*)title tag:(NSInteger)tag
{
    UIButton *actionButton = [UIButton new];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton sizeToFit];
    [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    actionButton.tag = tag;
    [actionButton addTarget:self action:@selector(handleGravity:) forControlEvents:UIControlEventTouchUpInside];
    return actionButton;
}


-(void)loadView
{
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_HORZ];
    rootLayout.wrapContentHeight = NO;
    rootLayout.wrapContentWidth = NO;
    rootLayout.gravity = MGRAVITY_VERT_CENTER;
    self.view = rootLayout;
    
    
    MyLinearLayout *leftLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    leftLayout.backgroundColor = [UIColor grayColor];
    
    leftLayout.padding = UIEdgeInsetsMake(0, 5, 0, 5);
    leftLayout.wrapContentWidth = YES;
    leftLayout.gravity = MGRAVITY_HORZ_CENTER;
    [rootLayout addSubview:leftLayout];
    
    UILabel *label = [UILabel new];
    label.text = @"点击选择停靠方式";
    
    [label sizeToFit];
    [leftLayout addSubview:label];
    
    UIButton *topButton = [self createActionButton:@"上停靠" tag:100];
    topButton.topMargin = 10;
    [leftLayout addSubview:topButton];
    
    UIButton *centerYButton = [self createActionButton:@"垂直居中停靠" tag:200];
    centerYButton.topMargin = 10;
    [leftLayout addSubview:centerYButton];
    
    
    UIButton *bottomButton = [self createActionButton:@"下停靠" tag:300];
    bottomButton.topMargin = 10;
    [leftLayout addSubview:bottomButton];
    
    
    UIButton *leftButton = [self createActionButton:@"左停靠" tag:400];
    leftButton.topMargin = 10;
    [leftLayout addSubview:leftButton];
    
    UIButton *centerXButton = [self createActionButton:@"水平居中停靠" tag:500];
    centerXButton.topMargin = 10;
    [leftLayout addSubview:centerXButton];
    
    UIButton *rightButton = [self createActionButton:@"右停靠" tag:600];
    rightButton.topMargin = 10;
    [leftLayout addSubview:rightButton];
    
    UIButton *customButton = [self createActionButton:@"自定义停靠" tag:700];
    customButton.topMargin = 10;
    customButton.bottomMargin = 10;
    [leftLayout addSubview:customButton];
    
    
    MyLinearLayout *rightLayout = [MyLinearLayout linearLayoutWithOrientation:LVORIENTATION_VERT];
    rightLayout.backgroundColor = [UIColor lightGrayColor];
    
    rightLayout.leftMargin = 10;
    //下面三行表示高度是父视图高度，宽度是剩余的宽度
    rightLayout.topMargin = 0;
    rightLayout.bottomMargin = 0;
    rightLayout.weight = 1;
    [rootLayout addSubview:rightLayout];

    [self addSubLayout:rightLayout];
    
    
    self.gravityLayout = rightLayout;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"线性布局-子视图的位置停靠";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleGravity:(UIButton*)button
{
    switch (button.tag) {
        case 100:  //上
            self.gravityLayout.gravity = (self.gravityLayout.gravity & MGRAVITY_VERT_MASK) | MGRAVITY_VERT_TOP;
            break;
        case 200:  //垂直
            self.gravityLayout.gravity = (self.gravityLayout.gravity & MGRAVITY_VERT_MASK) | MGRAVITY_VERT_CENTER;
            break;
        case 300:   //下
            self.gravityLayout.gravity = (self.gravityLayout.gravity & MGRAVITY_VERT_MASK) | MGRAVITY_VERT_BOTTOM;
            break;
        case 400:  //左
            self.gravityLayout.gravity = (self.gravityLayout.gravity & MGRAVITY_HORZ_MASK) | MGRAVITY_HORZ_LEFT;
            break;
        case 500:  //水平
            self.gravityLayout.gravity = (self.gravityLayout.gravity & MGRAVITY_HORZ_MASK) | MGRAVITY_HORZ_CENTER;
            break;
        case 600:   //右
            self.gravityLayout.gravity = (self.gravityLayout.gravity & MGRAVITY_HORZ_MASK) | MGRAVITY_HORZ_RIGHT;
            break;
        case 700:   //自定义
            self.gravityLayout.gravity = MGRAVITY_NONE;
            break;
        default:
            break;
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

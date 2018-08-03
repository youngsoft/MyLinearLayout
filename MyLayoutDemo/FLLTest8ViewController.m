//
//  FLLTest8ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "FLLTest8ViewController.h"
#import "MyFlowLayout.h"

@interface FLLTest8ViewController ()

@end

@implementation FLLTest8ViewController

-(void)loadView
{
    MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:4];
    rootLayout.gravity = MyGravity_Vert_Between;
    
    for (int i = 0; i < 14; i++)
    {
        UILabel *label = [UILabel new];
        label.myHeight = 60;
        label.backgroundColor = [UIColor redColor];
        [rootLayout addSubview:label];
    }
    
    [rootLayout setSubviewsSize:60 minSpace:0 maxSpace:CGFLOAT_MAX];
    
    self.view = rootLayout;
    
    
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

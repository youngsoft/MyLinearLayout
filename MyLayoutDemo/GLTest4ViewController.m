//
//  GLTest4ViewController.m
//  MyLayout
//
//  Created by 吴斌 on 2017/9/7.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "GLTest4ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface GLTest4ViewController()

@property(nonatomic, weak) MyGridLayout *rootLayout;

@end

@implementation GLTest4ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test1];

    
    
    
  
}

- (void)test1
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyGridLayout *rootLayout = [MyGridLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.padding = UIEdgeInsetsMake(0, 0, 10, 0);
    self.view = rootLayout;
    self.rootLayout = rootLayout;
    
    
    NSString *path =  [NSBundle.mainBundle pathForResource:@"GridLayoutDemo4.geojson" ofType:nil];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
   id temp = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    
    rootLayout.gridDictionary = temp;
}



@end

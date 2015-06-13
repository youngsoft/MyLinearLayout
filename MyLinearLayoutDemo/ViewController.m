//
//  ViewController.m
//  MyLinearLayoutDemo
//
//  Created by oybq on 15/6/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "ViewController.h"
#import "MyLinearLayout.h"

@interface ViewController ()

@end


@implementation ViewController


-(void)test1:(BOOL)autoAdjustSize autoAdjustDir:(LineViewAutoAdjustDir)autoAdjustDir x:(CGFloat)x
{
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(x, 100, 100,200)];
    ll.orientation = LVORIENTATION_VERT;
    ll.autoAdjustSize = autoAdjustSize;
    ll.autoAdjustDir = autoAdjustDir;
    ll.backgroundColor = [UIColor grayColor];
    
    //不再需要指定y的偏移值了。
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    v1.backgroundColor = [UIColor redColor];
    v1.headMargin = 4;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 40, 60)];
    v2.backgroundColor = [UIColor greenColor];
    v2.headMargin = 6;
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 75, 30)];
    v3.backgroundColor = [UIColor blueColor];
    v3.headMargin = 3;
    v3.tailMargin = 4;
    [ll addSubview:v3];

    [self.view addSubview:ll];

}

-(void)test2:(LineViewAlign)align padding:(UIEdgeInsets)padding x:(CGFloat)x
{
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(x, 100, 100,200)];
    ll.orientation = LVORIENTATION_VERT;
    ll.align = align;
    ll.padding = padding;
    ll.backgroundColor = [UIColor grayColor];
    
    //不再需要指定y的偏移值了。
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    v1.backgroundColor = [UIColor redColor];
    v1.headMargin = 4;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    v2.backgroundColor = [UIColor greenColor];
    v2.headMargin = 6;
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    v3.backgroundColor = [UIColor blueColor];
    v3.headMargin = 3;
    v3.tailMargin = 4;
    [ll addSubview:v3];
    
    [self.view addSubview:ll];
    
    
}

-(void)test3:(CGFloat)relativeMeasure x:(CGFloat)x
{
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(x, 100, 100,200)];
    ll.orientation = LVORIENTATION_VERT;
    ll.backgroundColor = [UIColor grayColor];
    
    //不再需要指定y的偏移值了。
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    v1.backgroundColor = [UIColor redColor];
    v1.headMargin = 4;
    v1.matchParent = relativeMeasure;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    v2.backgroundColor = [UIColor greenColor];
    v2.headMargin = 6;
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    v3.backgroundColor = [UIColor blueColor];
    v3.headMargin = 3;
    v3.tailMargin = 4;
    [ll addSubview:v3];
    
    [self.view addSubview:ll];
    
}


-(void)test4:(LineViewAlign)gravity x:(CGFloat)x
{
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(x, 100, 100,200)];
    ll.orientation = LVORIENTATION_VERT;
    ll.gravity = gravity;
    ll.backgroundColor = [UIColor grayColor];
    
    //不再需要指定y的偏移值了。
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    v1.backgroundColor = [UIColor redColor];
    v1.headMargin = 4;
    v1.matchParent = 1.0;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    v2.backgroundColor = [UIColor greenColor];
    v2.headMargin = 6;
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    v3.backgroundColor = [UIColor blueColor];
    v3.headMargin = 3;
    v3.tailMargin = 4;
    [ll addSubview:v3];
    
    [self.view addSubview:ll];
    
    
}

-(void)test5
{
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:self.view.bounds];
    //保证容器和视图控制的视图的大小进行伸缩调整。
    ll.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ll.orientation = LVORIENTATION_VERT;
    ll.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    ll.backgroundColor = [UIColor grayColor];
    
    MyLinearLayout *topll = MyLinearLayout.new;
    topll.orientation = LVORIENTATION_HORZ;
    topll.weight = 0.5;
    topll.matchParent = 1;
    
    UIView *topLeft = UIView.new;
    topLeft.backgroundColor = [UIColor redColor];
    topLeft.weight = 0.5;
    topLeft.matchParent = 1.0;
    [topll addSubview:topLeft];
    
    UIView *topRight = UIView.new;
    topRight.backgroundColor = [UIColor greenColor];
    topRight.weight = 0.5;
    topRight.matchParent = 1.0;
    topRight.headMargin = 20;
    [topll addSubview:topRight];
    
    [ll addSubview:topll];
    
    
    UIView *bottom = UIView.new;
    bottom.backgroundColor = [UIColor blueColor];
    bottom.weight = 0.5;
    bottom.matchParent = 1.0;
    bottom.headMargin = 20;
    [ll addSubview:bottom];

    
    [self.view addSubview:ll];
    
    
    
    
}

-(void)test6
{
    
    MyLinearLayout *ll = [[MyLinearLayout alloc] initWithFrame:CGRectMake(100, 100, 0,0)];
    ll.orientation = LVORIENTATION_VERT;
    ll.wrapContent = YES;
    ll.backgroundColor = [UIColor grayColor];
    
    //不再需要指定y的偏移值了。
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    v1.backgroundColor = [UIColor redColor];
    v1.headMargin = 4;
    [ll addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    v2.backgroundColor = [UIColor greenColor];
    v2.headMargin = 6;
    [ll addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    v3.backgroundColor = [UIColor blueColor];
    v3.headMargin = 3;
    v3.tailMargin = 4;
    [ll addSubview:v3];
    
    [self.view addSubview:ll];

    
}


/* UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 10, 200)];
 v.backgroundColor = [UIColor blackColor];
 [self.view addSubview:v];
 
 [self test1:NO autoAdjustDir:LVAUTOADJUSTDIR_TAIL x:60];
 [self test1:YES autoAdjustDir:LVAUTOADJUSTDIR_TAIL x:60 + 100 + 20];
 [self test1:YES autoAdjustDir:LVAUTOADJUSTDIR_CENTER x:60 + (100 + 20)*2];
 [self test1:YES autoAdjustDir:LVAUTOADJUSTDIR_HEAD x:60 + (100 + 20)*3];*/

/*
 [self test2:LVALIGN_LEFT padding:UIEdgeInsetsMake(5, 5, 5, 5) x:60];
 [self test2:LVALIGN_CENTER padding:UIEdgeInsetsMake(5, 5, 5, 5) x:60 + 100 + 20];
 [self test2:LVALIGN_RIGHT padding:UIEdgeInsetsMake(5, 5, 5, 5) x:60 + (100 + 20)*2];
 */

/*
 
 [self test3:1.0 x:60];
 [self test3:0.8 x:60 + 100 + 20];
 [self test3:-20 x:60 + (100 + 20)*2];
 */

/*
 
 [self test4:LVALIGN_TOP x:60];
 [self test4:LVALIGN_CENTER x:60 + 100 + 20];
 [self test4:LVALIGN_BOTTOM x:60 + (100 + 20)*2];
 */

 //[self test5];

-(void)loadView
{
    [super loadView];
    
    [self test6];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

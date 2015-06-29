//
//  Test13ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "Test13ViewController.h"
#import "MyLinearLayout.h"
#import "Masonry.h"

@implementation Test13ViewController

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor  = [UIColor whiteColor];
    
    UILabel *lab=[UILabel new];
    lab.text=@"高级信息";
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(@0);
    }];
    
    UILabel *lab2=[UILabel new];
    lab2.text=@"222222";
    [self.view addSubview:lab2];
    
    UITextField *textField=[UITextField new];
    textField.backgroundColor=[UIColor greenColor];
    [self.view addSubview:textField];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textField).offset(-5);
        make.left.greaterThanOrEqualTo(@10).priorityLow();
        make.right.equalTo(textField.mas_left).offset(-15);
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(10);
        make.left.equalTo(lab2.mas_right).offset(15);
        make.right.equalTo(@-20);
        make.height.equalTo(@40);
        make.width.greaterThanOrEqualTo(@150).priorityLow();
    }];
    
   /*
    
    MyLinearLayout *ll =  [MyLinearLayout new];
    ll.backgroundColor = [UIColor whiteColor];
    self.view = ll;
    
    
    UILabel *labe = [UILabel new];
    labe.text = @"高级信息";
    labe.marginGravity = MGRAVITY_HORZ_CENTER;
    labe.topMargin = 10;
    [labe sizeToFit];
    
    [ll addSubview:labe];
    
    
    MyLinearLayout *O1 = [MyLinearLayout new];
    O1.gravity = MGRAVITY_VERT_BOTTOM;
    O1.orientation = LVORIENTATION_HORZ;
    O1.topMargin = 10;
    O1.matchParentWidth = 1;
    O1.wrapContent = YES;
    O1.topPadding = 3;
    O1.bottomPadding = 3;
    
    MyBorderLineDraw *topDraw = [[MyBorderLineDraw alloc] initWithColor:[UIColor grayColor]];
    
    MyBorderLineDraw *bottomDraw = [[MyBorderLineDraw alloc] initWithColor:[UIColor grayColor]];
    bottomDraw.headIndent = 20;
    O1.topBorderLine = topDraw;
    O1.bottomBorderLine = bottomDraw;
    

    UILabel *lb = [UILabel new];
    lb.text = @"税后月收入";
    [lb sizeToFit];
    lb.leftMargin = 10;
    
    [O1 addSubview:lb];
    
    UITextField *txtFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    txtFiled.text = @"asfasfasfasfasdf";
    txtFiled.leftMargin = 2;
    txtFiled.weight = 1;
    txtFiled.rightMargin = 10;
    txtFiled.matchParentHeight = 1;
    
    [O1 addSubview:txtFiled];
    
    [ll addSubview:O1];
    
    
    */
    
    
    
    
}

@end

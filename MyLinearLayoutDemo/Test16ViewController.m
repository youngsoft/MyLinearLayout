//
//  Test16ViewController.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "Test16ViewController.h"
#import "MyLayout.h"

@interface Test16ViewController ()

@end

@implementation Test16ViewController

-(void)loadView
{
    MyRelativeLayout *rl = [MyRelativeLayout new];
    self.view = rl;
    
    UILabel *lb1up = [UILabel new];
    lb1up.text = @"左上面";
    lb1up.backgroundColor = [UIColor greenColor];
    lb1up.font = [UIFont systemFontOfSize:17];
    [lb1up sizeToFit];
    [rl addSubview:lb1up];
    
    UILabel *lb1down = [UILabel new];
    lb1down.text = @"我左在下面";
    lb1down.backgroundColor = [UIColor greenColor];
    [lb1down sizeToFit];
    [rl addSubview:lb1down];
    
    
    UILabel *lb2up = [UILabel new];
    lb2up.text = @"我在中间上面";
    lb2up.backgroundColor = [UIColor greenColor];
    lb2up.font = [UIFont systemFontOfSize:12];
    [lb2up sizeToFit];
    [rl addSubview:lb2up];
    
    UILabel *lb2down = [UILabel new];
    lb2down.text = @"中";
    lb2down.backgroundColor = [UIColor greenColor];
    [lb2down sizeToFit];
    [rl addSubview:lb2down];
    
    
    UILabel *lb3up = [UILabel new];
    lb3up.text = @"右上";
    lb3up.backgroundColor = [UIColor greenColor];
    [lb3up sizeToFit];
    [rl addSubview:lb3up];
    
    UILabel *lb3down = [UILabel new];
    lb3down.text = @"右边的下方";
    lb3down.backgroundColor = [UIColor greenColor];
    lb3down.font = [UIFont systemFontOfSize:16];
    [lb3down sizeToFit];
    [rl addSubview:lb3down];
    
    //左，中，右三组视图分别垂直居中显示，并且下面和上面间隔10
    lb1up.centerYPos.equalTo(@[lb1down.centerYPos.offset(10)]);
    lb2up.centerYPos.equalTo(@[lb2down.centerYPos.offset(10)]);
    lb3up.centerYPos.equalTo(@[lb3down.centerYPos.offset(10)]);
    
    //上面的三个视图水平居中显示并且间隔60
    lb1up.centerXPos.equalTo(@[lb2up.centerXPos.offset(60),lb3up.centerXPos.offset(60)]);
    
    //下面的三个视图的水平中心点和上面三个视图的水平中心点对齐
    lb1down.centerXPos.equalTo(lb1up.centerXPos);
    lb2down.centerXPos.equalTo(lb2up.centerXPos);
    lb3down.centerXPos.equalTo(lb3up.centerXPos);


    
    
}

/*
-(void)loadView
{
    
    MyRelativeLayout *rl = [MyRelativeLayout new];
    rl.backgroundColor = [UIColor grayColor];
    self.view = rl;
    
    //一组视图水平居中。
    UILabel *lb1 = [UILabel new];
    lb1.text = @"abcdefg";
    [lb1 sizeToFit];
    lb1.backgroundColor = [UIColor redColor];
    lb1.topPos.offset(100);
    [rl addSubview:lb1];
    
    UILabel *lb2 = [UILabel new];
    lb2.text = @"abcdefgfd";
    [lb2 sizeToFit];
    lb2.backgroundColor = [UIColor blueColor];
    lb2.topPos.offset(100);
    [rl addSubview:lb2];
    
    
    UILabel *lb3 = [UILabel new];
    lb3.text = @"abc";
    [lb3 sizeToFit];
    lb3.backgroundColor = [UIColor greenColor];
    lb3.topPos.offset(100);
    [rl addSubview:lb3];
    
    
    //lb1, lb2, lb3 三个视图组成一个组在父视图,lb2离lb15的间隔，lb3离lb210的间隔。如果要3个整体往右移则设置
    //lb1的offset。
    lb1.centerXPos.equalTo(@[lb2.centerXPos.offset(5), lb3.centerXPos.offset(10)]);
    
    //对照。
    UILabel *lb4 = [UILabel new];
    lb4.text = @"你好";
    [lb4 sizeToFit];
    lb4.backgroundColor = [UIColor orangeColor];
    [rl addSubview:lb4];
    lb4.leftPos.equalTo(lb1.leftPos);
    lb4.topPos.equalTo(lb2.bottomPos).offset(10);
    
    
    //一组视图垂直居中
    UILabel *lb5 = [UILabel new];
    lb5.text = @"abcdefg";
    [lb5 sizeToFit];
    lb5.backgroundColor = [UIColor redColor];
    lb5.centerXPos.equalTo(rl.centerXPos);
    [rl addSubview:lb5];
    
    UILabel *lb6 = [UILabel new];
    lb6.text = @"abcdefgfd";
    [lb6 sizeToFit];
    lb6.backgroundColor = [UIColor blueColor];
    lb6.centerXPos.equalTo(rl.centerXPos);
    [rl addSubview:lb6];
    
    
    UILabel *lb7 = [UILabel new];
    lb7.text = @"abc";
    [lb7 sizeToFit];
    lb7.backgroundColor = [UIColor greenColor];
    lb7.centerXPos.equalTo(rl.centerXPos);
    [rl addSubview:lb7];
    
    lb5.centerYPos.equalTo(@[lb6.centerYPos.offset(5), lb7.centerYPos.offset(10)]);

    
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相对布局4-一组视图居中";
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

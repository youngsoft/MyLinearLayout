//
//  Test16ViewController.m
//  MyLayout
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "RLTest3ViewController.h"
#import "MyLayout.h"

@interface RLTest3ViewController ()

@end

@implementation RLTest3ViewController

-(MyRelativeLayout*)createLayout1
{
    MyRelativeLayout *layout = [MyRelativeLayout new];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"子视图整体水平居中";
    [titleLabel sizeToFit];
    [layout addSubview:titleLabel];
    
    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor greenColor];
    v1.widthDime.equalTo(@100);
    v1.heightDime.equalTo(@50);
    v1.centerYPos.equalTo(@0);
    [layout addSubview:v1];
    
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor blueColor];
    v2.widthDime.equalTo(@50);
    v2.heightDime.equalTo(@50);
    v2.centerYPos.equalTo(@0);
    [layout addSubview:v2];
    
    //通过为centerXPos等于一个数组值，表示他们之间整体居中,还可以设置其他视图的偏移量。
    v1.centerXPos.equalTo(@[v2.centerXPos.offset(20)]);

    
    
    
    
    
    return layout;
}

-(MyRelativeLayout*)createLayout2
{
    MyRelativeLayout *layout = [MyRelativeLayout new];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"子视图整体垂直居中";
    [titleLabel sizeToFit];
    [layout addSubview:titleLabel];
    
    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor redColor];
    v1.widthDime.equalTo(@200);
    v1.heightDime.equalTo(@50);
    v1.centerXPos.equalTo(@0);
    [layout addSubview:v1];
    
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = [UIColor blueColor];
    v2.widthDime.equalTo(@200);
    v2.heightDime.equalTo(@30);
    v2.centerXPos.equalTo(@0);
    [layout addSubview:v2];
    
    //通过为centerYPos等于一个数组值，表示他们之间整体居中,还可以设置其他视图的偏移量。
    v1.centerYPos.equalTo(@[v2.centerYPos.offset(10)]);

    return layout;
}


-(MyRelativeLayout*)createLayout3
{
    MyRelativeLayout *layout = [MyRelativeLayout new];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"子视图整体居中";
    [titleLabel sizeToFit];
    [layout addSubview:titleLabel];
    
    UILabel *lb1up = [UILabel new];
    lb1up.text = @"左上面";
    lb1up.backgroundColor = [UIColor redColor];
    lb1up.font = [UIFont systemFontOfSize:17];
    [lb1up sizeToFit];
    [layout addSubview:lb1up];
    
    UILabel *lb1down = [UILabel new];
    lb1down.text = @"我左在下面";
    lb1down.backgroundColor = [UIColor greenColor];
    [lb1down sizeToFit];
    [layout addSubview:lb1down];
    
    
    UILabel *lb2up = [UILabel new];
    lb2up.text = @"我在中间上面";
    lb2up.backgroundColor = [UIColor redColor];
    lb2up.font = [UIFont systemFontOfSize:12];
    [lb2up sizeToFit];
    [layout addSubview:lb2up];
    
    UILabel *lb2down = [UILabel new];
    lb2down.text = @"中";
    lb2down.backgroundColor = [UIColor greenColor];
    [lb2down sizeToFit];
    [layout addSubview:lb2down];
    
    
    UILabel *lb3up = [UILabel new];
    lb3up.text = @"右上";
    lb3up.backgroundColor = [UIColor redColor];
    [lb3up sizeToFit];
    [layout addSubview:lb3up];
    
    UILabel *lb3down = [UILabel new];
    lb3down.text = @"右边的下方";
    lb3down.backgroundColor = [UIColor greenColor];
    lb3down.font = [UIFont systemFontOfSize:16];
    [lb3down sizeToFit];
    [layout addSubview:lb3down];
    
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
    

    
    
    return layout;
}


-(void)loadView
{
    
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    self.view = rootLayout;
    
    MyRelativeLayout *layout1 =  [self createLayout1]; //[MyRelativeLayout new];
    MyRelativeLayout *layout2 = [self createLayout2];
    MyRelativeLayout *layout3 = [self createLayout3];
   
    layout1.backgroundColor = [UIColor redColor];
    layout2.backgroundColor = [UIColor greenColor];
    layout3.backgroundColor = [UIColor blueColor];
    
    
    layout1.widthDime.equalTo(rootLayout.widthDime);
    layout2.widthDime.equalTo(rootLayout.widthDime);
    layout3.widthDime.equalTo(rootLayout.widthDime);
    layout1.heightDime.equalTo(@[layout2.heightDime, layout3.heightDime]);
    layout2.topPos.equalTo(layout1.bottomPos);
    layout3.topPos.equalTo(layout2.bottomPos);
    
    
    [rootLayout addSubview:layout1];
    [rootLayout addSubview:layout2];
    [rootLayout addSubview:layout3];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相对布局4-一组视图整体居中";
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

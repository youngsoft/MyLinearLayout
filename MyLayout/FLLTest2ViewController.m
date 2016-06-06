//
//  FLLTest2ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/12.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "FLLTest2ViewController.h"
#import "MyLayout.h"

@interface FLLTest2ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet MyFlowLayout *flowLayout;

@end

@implementation FLLTest2ViewController

- (void)viewDidLoad {
    
    /*
       这个例子用来介绍流式布局中的内容填充流式布局，主要用来实现标签流的功能。内容填充流式布局的每行的数量是不固定的，而是根据其内容的尺寸来自动换行。
     */
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
            
    [self createTagButton:@"点击标签可删除"];
    [self createTagButton:@"标签2"];
    [self createTagButton:@"本例子通过用XIB来建立布局视图"];


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

#pragma mark -- Layout Construction

-(void)createTagButton:(NSString*)text
{
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:text forState:UIControlStateNormal];
    tagButton.layer.cornerRadius = 15;
    tagButton.backgroundColor = [UIColor colorWithRed:random()%256 / 255.0 green:random()%256 / 255.0 blue:random()%256 / 255.0 alpha:1];
    
    //这里可以看到尺寸宽度等于自己的尺寸宽度并且再增加10，且最小是40，意思是按钮的宽度是等于自身内容的宽度再加10，但最小的宽度是40
    //如果没有这个设置，而是直接调用了sizeToFit则按钮的宽度就是内容的宽度。
    tagButton.widthDime.equalTo(tagButton.widthDime).add(10).min(40);
    tagButton.heightDime.equalTo(tagButton.heightDime).add(10); //高度根据自身的内容再增加10
    [tagButton sizeToFit];
    [tagButton addTarget:self action:@selector(handleDelTag:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowLayout addSubview:tagButton];
    
}

#pragma mark -- Handle Method

- (IBAction)handleShrinkMargin:(UISwitch *)sender {
    
    //间距拉伸
    if (sender.isOn)
        self.flowLayout.gravity = MyMarginGravity_Horz_Fill;  //流式布局的gravity如果设置为MyMarginGravity_Horz_Fill表示子视图的间距会被拉伸，以便填充满整个布局。
    else
        self.flowLayout.gravity = MyMarginGravity_None;
    
    [self.flowLayout layoutAnimationWithDuration:0.2];
}

- (IBAction)handleShrinkContent:(UISwitch *)sender {
    
    //内容拉伸
    if (sender.isOn)
        self.flowLayout.averageArrange = YES;  //对于内容填充的流时布局来说，averageArrange属性如果设置为YES表示里面的子视图的内容会自动的拉伸以便填充整个布局。
    else
        self.flowLayout.averageArrange = NO;
    
    [self.flowLayout layoutAnimationWithDuration:0.2];

}

- (IBAction)handleShrinkAuto:(UISwitch *)sender {
    
    //自动调整位置。
    if (sender.isOn)
        self.flowLayout.autoArrange = YES;  //autoArrange属性会根据子视图的内容自动调整，以便以最合适的布局来填充布局。
    else
        self.flowLayout.autoArrange = NO;
    
    [self.flowLayout layoutAnimationWithDuration:0.2];

}

- (IBAction)handleAddTag:(id)sender {
    
    if (self.tagTextField.text.length == 0)
        return;
    
    [self createTagButton:self.tagTextField.text];
    
    self.tagTextField.text = @"";
    
    [self.flowLayout layoutAnimationWithDuration:0.2];
    
}

- (IBAction)handleDelTag:(UIButton*)sender {
    
    [sender removeFromSuperview];
    
    [self.flowLayout layoutAnimationWithDuration:0.2];
}


@end

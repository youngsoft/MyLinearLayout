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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"流式布局 - 标签流";
        
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

-(void)createTagButton:(NSString*)text
{
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:text forState:UIControlStateNormal];
    tagButton.layer.cornerRadius = 15;
    tagButton.backgroundColor = [UIColor colorWithRed:random()%256 / 255.0 green:random()%256 / 255.0 blue:random()%256 / 255.0 alpha:1];
    tagButton.heightDime.equalTo(@((random() % 40) + 30));
    
    //这里可以看到尺寸宽度等于自己的尺寸宽度并且再增加10，且最小是40，意思是按钮的宽度是等于自身内容的宽度再加10，但最小的宽度是40
    //如果没有这个设置，而是直接调用了sizeToFit则按钮的宽度就是内容的宽度。
    tagButton.widthDime.equalTo(tagButton.widthDime).add(10).min(40);
    [tagButton sizeToFit];
    [tagButton addTarget:self action:@selector(handleDelTag:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowLayout addSubview:tagButton];
    
}

#pragma mark -- Handle Method

- (IBAction)handleShrinkMargin:(UISwitch *)sender {
    
    //间距拉伸
    if (sender.isOn)
        self.flowLayout.gravity = MyMarginGravity_Horz_Fill;
    else
        self.flowLayout.gravity = MyMarginGravity_None;
    
    self.flowLayout.beginLayoutBlock =^{
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
    
    };
    
    self.flowLayout.endLayoutBlock =^{
    
        [UIView commitAnimations];
    
    };
    
}

- (IBAction)handleShrinkContent:(UISwitch *)sender {
    
    //内容拉伸
    if (sender.isOn)
        self.flowLayout.averageArrange = YES;
    else
        self.flowLayout.averageArrange = NO;
    
    self.flowLayout.beginLayoutBlock =^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
    };
    
    self.flowLayout.endLayoutBlock =^{
        
        [UIView commitAnimations];
        
    };

}

- (IBAction)handleShrinkAuto:(UISwitch *)sender {
    
    //自动调整位置。
    if (sender.isOn)
        self.flowLayout.autoArrange = YES;
    else
        self.flowLayout.autoArrange = NO;
    
    self.flowLayout.beginLayoutBlock =^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
    };
    
    self.flowLayout.endLayoutBlock =^{
        
        [UIView commitAnimations];
        
    };

}

- (IBAction)handleAddTag:(id)sender {
    
    if (self.tagTextField.text.length == 0)
        return;
    
    [self createTagButton:self.tagTextField.text];
    
    self.tagTextField.text = @"";
    
    self.flowLayout.beginLayoutBlock =^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
    };
    
    self.flowLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
    };

    
}

- (IBAction)handleDelTag:(UIButton*)sender {
    
    [sender removeFromSuperview];
    self.flowLayout.beginLayoutBlock =^{
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
    };
    
    self.flowLayout.endLayoutBlock = ^{
    
        [UIView commitAnimations];
    };
}


@end

//
//  FOLTest1ViewController.m
//  MyLayout
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//
#import "MyLayout.h"

#import "FOLTest1ViewController.h"

@interface FOLTest1ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *whTextField;
@property (weak, nonatomic) IBOutlet MyFloatLayout *floatLayout;
@property (weak, nonatomic) IBOutlet UISwitch *reverseFloatSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *clearFloatSwitch;
@property (weak, nonatomic) IBOutlet UIStepper *weightStepper;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@end

@implementation FOLTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.floatLayout.orientation = MyLayoutViewOrientation_Horz;
   self.title = @"浮动布局1--Demo1";
    
    
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

#pragma mark -- Handle Method

-(void)createTagButton:(NSString*)text
{
    NSArray *arr = [text componentsSeparatedByString:@","];
    if (arr.count != 2 && arr.count != 6)
        return;
    
    UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [arr[0] floatValue], [arr[1] floatValue])];
    [tagButton setTitle:text forState:UIControlStateNormal];
    tagButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    tagButton.backgroundColor = [UIColor colorWithRed:random()%256 / 255.0 green:random()%256 / 255.0 blue:random()%256 / 255.0 alpha:1];
    [tagButton addTarget:self action:@selector(handleDelTag:) forControlEvents:UIControlEventTouchUpInside];
    [self.floatLayout addSubview:tagButton];
    
    if (arr.count == 6)
    {
        tagButton.myLeftMargin = [arr[2] floatValue];
        tagButton.myTopMargin = [arr[3] floatValue];
        tagButton.myRightMargin = [arr[4] floatValue];
        tagButton.myBottomMargin = [arr[5] floatValue];
    }
    
    tagButton.reverseFloat = self.reverseFloatSwitch.isOn;
    tagButton.clearFloat = self.clearFloatSwitch.isOn;
    tagButton.weight = self.weightStepper.value;
    
    self.weightStepper.value = 0;
    self.weightLabel.text = @"0";
    
    self.reverseFloatSwitch.on = NO;
    self.clearFloatSwitch.on = NO;
    
    
    self.floatLayout.beginLayoutBlock =^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
    };
    
    self.floatLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
    };
    
}


- (IBAction)handleAddSubView:(id)sender {
    
    if (self.whTextField.text.length == 0)
        return;
    
    [self createTagButton:self.whTextField.text];
    
    self.whTextField.text = @"";
    
    
}
- (IBAction)handleChangeOrientaion:(id)sender {
    
    if (self.floatLayout.orientation == MyLayoutViewOrientation_Vert)
        self.floatLayout.orientation = MyLayoutViewOrientation_Horz;
    else
        self.floatLayout.orientation = MyLayoutViewOrientation_Vert;
    
    self.floatLayout.beginLayoutBlock =^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
    };
    
    self.floatLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
    };

    
}
- (IBAction)handleWeightStepper:(id)sender {
    
    self.weightLabel.text = [NSString stringWithFormat:@"%.1f", self.weightStepper.value];
    
}

-(IBAction)handleDelTag:(UIButton*)sender
{
    [sender removeFromSuperview];
    self.floatLayout.beginLayoutBlock =^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
    };
    
    self.floatLayout.endLayoutBlock = ^{
        
        [UIView commitAnimations];
    };

}

@end

//
//  FOLTest5ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "FOLTest5ViewController.h"
#import "MyLayout.h"


@interface FOLTest5ViewController ()

@end

@implementation FOLTest5ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    NSArray *titles = @[NSLocalizedString(@"Layout view:", @""),
                        NSLocalizedString(@"MyLinearLayout:",@""),
                        NSLocalizedString(@"MyTableLayout:",@""),
                        NSLocalizedString(@"MyFrameLayout:",@""),
                        NSLocalizedString(@"MyRelativeLayout:",@""),
                        NSLocalizedString(@"MyFlowLayout:",@""),
                        NSLocalizedString(@"MyFloatLayout:",@""),
                        @"SIZECLASS:"
                        ];
    
    NSArray *descs = @[NSLocalizedString(@"MyLayout is a powerful view layout library, it support 6 kinds of layout views and SIZECLASS.", @""),
                       NSLocalizedString(@"Linear layout is a single line layout view that the subviews are arranged in sequence according to the added order（from top to bottom or from left to right). So the subviews' origin&size constraints are established by the added order. Subviews arranged in top-to-bottom order is called vertical linear layout view, and the subviews arranged in left-to-right order is called horizontal linear layout.", @""),
                       NSLocalizedString(@"Table layout is a layout view that the subviews are multi-row&col arranged like a table. First you must create a rowview and add it to the table layout, then add the subview to the rowview. If the rowviews arranged in top-to-bottom order,the tableview is caled vertical table layout,in which the subviews are arranged from left to right; If the rowviews arranged in in left-to-right order,the tableview is caled horizontal table layout,in which the subviews are arranged from top to bottom.",@""),
                       
                       NSLocalizedString(@"Frame layout is a layout view that the subviews can be overlapped and gravity in a special location of the superview.The subviews' layout position&size is not depended to the adding order and establish dependency constraint with the superview. Frame layout devided the vertical orientation to top,vertical center and bottom, while horizontal orientation is devided to left,horizontal center and right. Any of the subviews is just gravity in either vertical orientation or horizontal orientation.", @""),
                       
                       NSLocalizedString(@"Relative layout is a layout view that the subviews layout and position through mutual constraints.The subviews in the relative layout are not depended to the adding order but layout and position by setting the subviews' constraints.", @""),
                       NSLocalizedString(@"Flow layout is a layout view presents in multi-line that the subviews are arranged in sequence according to the added order, and when meeting with a arranging constraint it will start a new line and rearrange. The constrains mentioned here includes count constraints and size constraints. The orientation of the new line would be vertical and horizontal, so the flow layout is divided into: count constraints vertical flow layout, size constraints vertical flow layout, count constraints horizontal flow layout,  size constraints horizontal flow layout. Flow layout often used in the scenes that the subviews is  arranged regularly, it can be substitutive of UICollectionView to some extent.", @""),
                       NSLocalizedString(@"Float layout is a layout view that the subviews are floating gravity in the given orientations, when the size is not enough to be hold, it will automatically find the best location to gravity. float layout's conception is reference from the HTML/CSS's floating positioning technology, so the float layout can be designed in implementing irregular layout. According to the different orientation of the floating, float layout can be divided into left-right float layout and up-down float layout.", @""),
                       NSLocalizedString(@"MyLayout provided support to SIZECLASS in order to fit the different screen sizes of devices. You can combinate the SIZECLASS with any of the 6 kinds of layout views mentioned above to perfect fit the UI of all equipments.", @"")
                       ];
    

    NSArray *colors = @[[UIColor redColor],
                        [UIColor darkGrayColor],
                        [UIColor blueColor],
                        [UIColor orangeColor],
                        [UIColor blackColor],
                        [UIColor purpleColor],
                        [UIColor magentaColor],
                        [UIColor brownColor]
                        ];
    
    
    MyFloatLayout *rootLayout = [[MyFloatLayout alloc] initWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.myLeftMargin = rootLayout.myRightMargin = 0;  //宽度和滚动条视图保持一致。
    rootLayout.wrapContentHeight = YES;
    rootLayout.subviewHorzMargin = 5;
    rootLayout.subviewVertMargin = 5;
    [scrollView addSubview:rootLayout];
    
    
    UILabel *label = [UILabel new];
    label.text = @"MyLayout Introduction：";
    label.myBottomMargin = 10;
    [label sizeToFit];
    [rootLayout addSubview:label];
    
    for (NSInteger i = 0; i < titles.count; i++)
    {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = titles[i];
        titleLabel.textColor = colors[i];
        titleLabel.clearFloat = YES;     //换行重新布局。
        titleLabel.widthDime.equalTo(rootLayout.widthDime).multiply(0.25); //宽度是父视图宽度的1/4
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [titleLabel sizeToFit];
        [rootLayout addSubview:titleLabel];
        
        UILabel *descLabel = [UILabel new];
        descLabel.text = descs[i];
        descLabel.font = [UIFont systemFontOfSize:14];
        descLabel.weight = 1;      //占用剩余的宽度
        descLabel.numberOfLines = 0;
        descLabel.flexedHeight = YES; //多行自动换行。
        [descLabel sizeToFit];
        [rootLayout addSubview:descLabel];
        
    }
    
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

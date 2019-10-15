//
//  FLXTest1ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2018/8/1.
//  Copyright © 2018年 YoungSoft. All rights reserved.
//

#import "FLXTest1ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FLXTest1ViewController ()

@property(nonatomic, strong) UISegmentedControl *flex_directionSeg;
@property(nonatomic, strong) UISegmentedControl *flex_wrapSeg;
@property(nonatomic, strong) UISegmentedControl *justify_contentSeg;
@property(nonatomic, strong) UISegmentedControl *align_itemsSeg;
@property(nonatomic, strong) UISegmentedControl *align_contentSeg;

@property(nonatomic, strong) UILabel *flexlayoutStyleDescLabel;

@property(nonatomic, strong) MyFlexLayout *contentLayout;


@end

@implementation FLXTest1ViewController

-(void)loadView
{
    MyFlexLayout *rootLayout = MyFlexLayout.new.flex
    .flex_direction(MyFlexDirection_Column)
    .vert_space(10)
    .view;
    self.view = rootLayout;
    
    //布局属性设置。
    MyFlexLayout *flexAttrLayout = MyFlexLayout.new.flex
    .flex_direction(MyFlexDirection_Row)
    .align_items(MyFlexGravity_Center)
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .addTo(rootLayout);
    
    UILabel *flexAttrTitleLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(flexAttrLayout);
    
    flexAttrTitleLabel.text = @"flex:";
    
    UISegmentedControl *flexAttrSeg = UISegmentedControl.new.flexItem
    .flex_grow(1)
    .height(MyLayoutSize.wrap)
    .addTo(flexAttrLayout);
    
    [flexAttrSeg insertSegmentWithTitle:@"flex-direction" atIndex:0 animated:NO];
    [flexAttrSeg insertSegmentWithTitle:@"flex-wrap" atIndex:1 animated:NO];
    [flexAttrSeg insertSegmentWithTitle:@"justify-content" atIndex:2 animated:NO];
    [flexAttrSeg insertSegmentWithTitle:@"align_items" atIndex:3 animated:NO];
    [flexAttrSeg insertSegmentWithTitle:@"align_content" atIndex:4 animated:NO];
    [flexAttrSeg addTarget:self action:@selector(handleFlexLayoutAttributeChange:) forControlEvents:UIControlEventValueChanged];
    
    UISegmentedControl *flex_directionSeg = UISegmentedControl.new.flexItem
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .addTo(rootLayout);
    
    
    [flex_directionSeg insertSegmentWithTitle:@"row" atIndex:0 animated:NO];
    [flex_directionSeg insertSegmentWithTitle:@"row_reverse" atIndex:1 animated:NO];
    [flex_directionSeg insertSegmentWithTitle:@"column" atIndex:2 animated:NO];
    [flex_directionSeg insertSegmentWithTitle:@"column_reverse" atIndex:3 animated:NO];
    [flex_directionSeg addTarget:self action:@selector(handleFlex_Direction:) forControlEvents:UIControlEventValueChanged];
    self.flex_directionSeg = flex_directionSeg;
    
    UISegmentedControl *flex_wrapSeg = UISegmentedControl.new.flexItem
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .visibility(MyVisibility_Gone)
    .addTo(rootLayout);
    
    [flex_wrapSeg insertSegmentWithTitle:@"nowrap" atIndex:0 animated:NO];
    [flex_wrapSeg insertSegmentWithTitle:@"wrap" atIndex:1 animated:NO];
    [flex_wrapSeg insertSegmentWithTitle:@"wrap_reverse" atIndex:2 animated:NO];
    [flex_wrapSeg addTarget:self action:@selector(handleFlex_Wrap:) forControlEvents:UIControlEventValueChanged];
    self.flex_wrapSeg = flex_wrapSeg;
    
    UISegmentedControl *justify_contentSeg = UISegmentedControl.new.flexItem
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .visibility(MyVisibility_Gone)
    .addTo(rootLayout);
    
    [justify_contentSeg insertSegmentWithTitle:@"flex-start" atIndex:0 animated:NO];
    [justify_contentSeg insertSegmentWithTitle:@"flex-end" atIndex:1 animated:NO];
    [justify_contentSeg insertSegmentWithTitle:@"center" atIndex:2 animated:NO];
    [justify_contentSeg insertSegmentWithTitle:@"space-between" atIndex:3 animated:NO];
    [justify_contentSeg insertSegmentWithTitle:@"space-around" atIndex:4 animated:NO];
    [justify_contentSeg addTarget:self action:@selector(handleJustify_Content:) forControlEvents:UIControlEventValueChanged];
    self.justify_contentSeg = justify_contentSeg;
    
    UISegmentedControl *align_itemsSeg = UISegmentedControl.new.flexItem
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .visibility(MyVisibility_Gone)
    .addTo(rootLayout);
    
    [align_itemsSeg insertSegmentWithTitle:@"flex-start" atIndex:0 animated:NO];
    [align_itemsSeg insertSegmentWithTitle:@"flex-end" atIndex:1 animated:NO];
    [align_itemsSeg insertSegmentWithTitle:@"center" atIndex:2 animated:NO];
    [align_itemsSeg insertSegmentWithTitle:@"stretch" atIndex:3 animated:NO];
    [align_itemsSeg insertSegmentWithTitle:@"baseline" atIndex:4 animated:NO];
    [align_itemsSeg addTarget:self action:@selector(handleAlign_Items:) forControlEvents:UIControlEventValueChanged];
    self.align_itemsSeg = align_itemsSeg;

    
    UISegmentedControl *align_contentSeg = UISegmentedControl.new.flexItem
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .visibility(MyVisibility_Gone)
    .addTo(rootLayout);
    
    [align_contentSeg insertSegmentWithTitle:@"flex-start" atIndex:0 animated:NO];
    [align_contentSeg insertSegmentWithTitle:@"flex-end" atIndex:1 animated:NO];
    [align_contentSeg insertSegmentWithTitle:@"center" atIndex:2 animated:NO];
    [align_contentSeg insertSegmentWithTitle:@"space-between" atIndex:3 animated:NO];
    [align_contentSeg insertSegmentWithTitle:@"space-around" atIndex:4 animated:NO];
    [align_contentSeg insertSegmentWithTitle:@"stretch" atIndex:5 animated:NO];
    [align_contentSeg addTarget:self action:@selector(handleAlign_Content:) forControlEvents:UIControlEventValueChanged];
    self.align_contentSeg = align_contentSeg;

    
    MyFlexLayout *paddingLayout = MyFlexLayout.new.flex
    .flex_direction(MyFlexDirection_Row)
    .align_items(MyFlexGravity_Center)
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .addTo(rootLayout);
    
    UILabel *paddingTitleLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(paddingLayout);
    
    paddingTitleLabel.text = @"padding:";
    
    UISwitch *paddingSwitch = UISwitch.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(paddingLayout);
    
    [paddingSwitch addTarget:self action:@selector(handlePaddingChange:) forControlEvents:UIControlEventValueChanged];
    
    MyFlexLayout *spaceLayout = MyFlexLayout.new.flex
    .flex_direction(MyFlexDirection_Row)
    .align_items(MyFlexGravity_Center)
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .addTo(rootLayout);
    
    UILabel *spaceTitleLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(spaceLayout);
    
    spaceTitleLabel.text = @"space:";
    
    UISwitch *spaceSwitch = UISwitch.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(spaceLayout);
    
    [spaceSwitch addTarget:self action:@selector(handleSpaceChange:) forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *flexlayoutStyleDescLabel = UILabel.new.flexItem
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .addTo(rootLayout);
    
    flexlayoutStyleDescLabel.text = @"";
    flexlayoutStyleDescLabel.textColor = [CFTool color:6];
    self.flexlayoutStyleDescLabel = flexlayoutStyleDescLabel;
    
    UIButton *button = UIButton.new.flexItem
    .width(MyLayoutSize.fill)
    .height(MyLayoutSize.wrap)
    .addTo(rootLayout);
    
    [button setTitle:@"Add Subview" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleAddItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIScrollView *scrollView = UIScrollView.new.flexItem
//    .width(MyLayoutSize.fill)
//    .flex_grow(1)
//    .addTo(rootLayout);
    
    MyFlexLayout *contentLayout = MyFlexLayout.new.flex
    .width(MyLayoutSize.fill)
    .flex_grow(1)
    .addTo(rootLayout);
    
    contentLayout.backgroundColor = [UIColor lightGrayColor];
    self.contentLayout = contentLayout;
    
    flexAttrSeg.selectedSegmentIndex = 0;
    self.flex_directionSeg.selectedSegmentIndex = 0;
    [self handleFlex_Direction:self.flex_directionSeg];
    
}

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

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

-(void)updateStyleDesc
{
    NSString *strFlexDirection = @"";
    switch (self.contentLayout.flex.flex_direction_val) {
        case MyFlexDirection_Row:
            strFlexDirection =@"row;";
            break;
        case MyFlexDirection_Column:
            strFlexDirection = @"column;";
            break;
        case MyFlexDirection_Row_Reverse:
            strFlexDirection = @"row-reverse;";
            break;
        case MyFlexDirection_Column_Reverse:
            strFlexDirection = @"column-reverse;";
            break;
        default:
            break;
    }
    
    NSString *strFlexWrap = @"";
    switch (self.contentLayout.flex.flex_wrap_val) {
        case MyFlexWrap_NoWrap:
            strFlexWrap = @"nowrap;";
            break;
        case MyFlexWrap_Wrap:
            strFlexWrap = @"wrap;";
            break;
        case MyFlexWrap_Wrap_Reverse:
            strFlexWrap = @"wrap-reverse;";
            break;
        default:
            break;
    }
    
    NSString *strJustifyContent = @"";
    switch (self.contentLayout.flex.justify_content_val) {
        case MyFlexGravity_Flex_Start:
            strJustifyContent = @"flex-start;";
            break;
        case MyFlexGravity_Flex_End:
            strJustifyContent = @"flex-end;";
            break;
        case MyFlexGravity_Center:
            strJustifyContent = @"center;";
            break;
        case MyFlexGravity_Space_Between:
            strJustifyContent = @"space-between;";
            break;
        case MyFlexGravity_Space_Around:
            strJustifyContent = @"space-around;";
        default:
            break;
    }
    
    NSString *strAlignItems = @"";
    switch (self.contentLayout.flex.align_items_val) {
        case MyFlexGravity_Flex_End:
            strAlignItems = @"flex-end;";
            break;
        case MyFlexGravity_Center:
            strAlignItems = @"center;";
            break;
        case MyFlexGravity_Baseline:
            strAlignItems = @"baseline;";
            break;
        case MyFlexGravity_Flex_Start:
            strAlignItems = @"flex-start;";
            break;
        case MyFlexGravity_Stretch:
            strAlignItems = @"stretch;";
            break;
        default:;
    }
    
    NSString *strAlignContent = @"";
    switch (self.contentLayout.flex.align_content_val) {
        case MyFlexGravity_Flex_End:
            strAlignContent = @"flex-end;";
            break;
        case MyFlexGravity_Center:
            strAlignContent = @"center;";
            break;
        case MyFlexGravity_Space_Between:
            strAlignContent = @"space-between;";
            break;
        case MyFlexGravity_Flex_Start:
            strAlignContent = @"flex-start;";
            break;
        case MyFlexGravity_Space_Around:
            strAlignContent = @"space-around;";
            break;
        case MyFlexGravity_Stretch:
            strAlignContent = @"stretch;";
            break;
        default:;
    }
    
    self.flexlayoutStyleDescLabel.text = [NSString stringWithFormat:@"Style=\"flex-direction:%@ flex-wrap:%@ justify-content:%@ align-items:%@ align-content:%@\"",
                                          strFlexDirection,
                                          strFlexWrap,
                                          strJustifyContent,
                                          strAlignItems,
                                          strAlignContent];
    
}


-(void)editFlexItem:(UIView*)itemView
{
    //创建一个
    MyFlexLayout *dialogLayout = MyFlexLayout.new.flex
    .flex_direction(MyFlexDirection_Row)
    .align_items(MyFlexGravity_Center)
    .flex_wrap(MyFlexWrap_Wrap)
    .padding(UIEdgeInsetsMake(10, 10, 10, 10))
    .vert_space(10)
    .horz_space(10)
    .width(220)
    .height(MyLayoutSize.wrap)
    .margin_top(80)
    .margin_left((self.view.window.frame.size.width - 200)/2.0)
    .addTo(self.view.window);
    
    dialogLayout.backgroundColor = [CFTool color:2];
    
    UILabel *widthLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(dialogLayout);
    
    widthLabel.text = @"width:";
    
    UITextField *widthTextField = UITextField.new.flexItem
    .width(100)
    .flex_grow(1)
    .height(30)
    .addTo(dialogLayout);
    
    widthTextField.tag = 100;
    widthTextField.borderStyle =  UITextBorderStyleRoundedRect;
    
    UILabel *heightLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(dialogLayout);
    
    heightLabel.text = @"height:";
    
    UITextField *heightTextField = UITextField.new.flexItem
    .width(100)
    .flex_grow(1)
    .height(30)
    .addTo(dialogLayout);
    
    heightTextField.tag = 200;
    heightTextField.borderStyle =  UITextBorderStyleRoundedRect;
    
    
    UILabel *orderLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(dialogLayout);
    
    orderLabel.text = @"order:";
    
    UITextField *orderTextField = UITextField.new.flexItem
    .width(100)
    .flex_grow(1)
    .height(30)
    .addTo(dialogLayout);
    
    orderTextField.tag = 300;
    orderTextField.borderStyle =  UITextBorderStyleRoundedRect;
    
    
    UILabel *flex_growLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(dialogLayout);
    
    flex_growLabel.text = @"flex-grow:";
    
    UITextField *flex_growTextField = UITextField.new.flexItem
    .width(100)
    .flex_grow(1)
    .height(30)
    .addTo(dialogLayout);
    
    flex_growTextField.tag = 400;
    flex_growTextField.borderStyle =  UITextBorderStyleRoundedRect;
    
    
    UILabel *flex_shrinkLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(dialogLayout);
    
    flex_shrinkLabel.text = @"flex-shrink:";
    
    UITextField *flex_shrinkTextField = UITextField.new.flexItem
    .width(100)
    .flex_grow(1)
    .height(30)
    .addTo(dialogLayout);
    
    flex_shrinkTextField.tag = 500;
    flex_shrinkTextField.borderStyle =  UITextBorderStyleRoundedRect;
    
    
    UILabel *flex_basisLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(dialogLayout);
    
    flex_basisLabel.text = @"flex-basis:";
    
    UITextField *flex_basisTextField = UITextField.new.flexItem
    .width(100)
    .flex_grow(1)
    .height(30)
    .addTo(dialogLayout);
    
    flex_basisTextField.tag = 600;
    flex_basisTextField.borderStyle =  UITextBorderStyleRoundedRect;
    
    
    UILabel *align_selfLabel = UILabel.new.flexItem
    .width(MyLayoutSize.wrap)
    .height(MyLayoutSize.wrap)
    .addTo(dialogLayout);
    
    align_selfLabel.text = @"align-self:";
    
    UITextField *align_selfTextField = UITextField.new.flexItem
    .width(100)
    .flex_grow(1)
    .height(30)
    .addTo(dialogLayout);
    
    align_selfTextField.tag = 700;
    align_selfTextField.borderStyle =  UITextBorderStyleRoundedRect;
    
    
    UIButton *addButton = UIButton.new.flexItem
    .flex_grow(1)
    .width(50)
    .height(30)
    .addTo(dialogLayout);
    
    
    if (itemView != nil)
    {
        addButton.tag = (NSInteger)itemView;
        [addButton setTitle:@"Save" forState:UIControlStateNormal];
    }
    else
        [addButton setTitle:@"Add" forState:UIControlStateNormal];
    
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(handleSaveItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeButton = UIButton.new.flexItem
    .flex_grow(1)
    .width(50)
    .height(30)
    .addTo(dialogLayout);
    
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(handleCloseDialog:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (itemView != nil)
    {
        if (itemView.flexItem.width_val == MyLayoutSize.wrap)
            widthTextField.text = @"wrap";
        else if (itemView.flexItem.width_val == MyLayoutSize.fill)
            widthTextField.text = @"fill";
        else if (itemView.flexItem.width_val != 0)
            widthTextField.text = [@(itemView.flexItem.width_val) stringValue];
        else
            widthTextField.text = @"";
        
        
        if (itemView.flexItem.height_val == MyLayoutSize.wrap)
            heightTextField.text = @"wrap";
        else if (itemView.flexItem.height_val == MyLayoutSize.fill)
            heightTextField.text = @"fill";
        else if (itemView.flexItem.height_val != 0)
            heightTextField.text = [@(itemView.flexItem.height_val) stringValue];
        else
            heightTextField.text = @"";
        
        
        if (itemView.flexItem.order_val != 0)
            orderTextField.text = [@(itemView.flexItem.order_val) stringValue];
        
        
        if (itemView.flexItem.flex_grow_val != 0)
            flex_growTextField.text = [@(itemView.flexItem.flex_grow_val) stringValue];
        
        if (itemView.flexItem.flex_shrink_val != 1)
            flex_shrinkTextField.text = [@(itemView.flexItem.flex_shrink_val) stringValue];
        
        if (itemView.flexItem.flex_basis_val != MyFlex_Auto)
            flex_basisTextField.text = [@(itemView.flexItem.flex_basis_val) stringValue];
        
        switch (itemView.flexItem.align_self_val) {
            case MyFlexGravity_Flex_Start:
                align_selfTextField.text = @"flex-start";
                break;
            case MyFlexGravity_Flex_End:
                align_selfTextField.text = @"flex-end";
                break;
            case MyFlexGravity_Center:
                align_selfTextField.text = @"center";
                break;
            case MyFlexGravity_Baseline:
                align_selfTextField.text = @"baseline";
                break;
            case MyFlexGravity_Stretch:
                align_selfTextField.text = @"stretch";
                break;
            default:
                break;
        }
    }
}


#pragma mark -- Handle Method

-(IBAction)handleFlexLayoutAttributeChange:(UISegmentedControl*)sender
{
    self.flex_directionSeg.flexItem.visibility(MyVisibility_Gone);
    self.flex_wrapSeg.flexItem.visibility(MyVisibility_Gone);
    self.justify_contentSeg.flexItem.visibility(MyVisibility_Gone);
    self.align_itemsSeg.flexItem.visibility(MyVisibility_Gone);
    self.align_contentSeg.flexItem.visibility(MyVisibility_Gone);

    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.flex_directionSeg.flexItem.visibility(MyVisibility_Visible);
            switch (self.contentLayout.flex.flex_direction_val) {
                case MyFlexDirection_Row:
                    self.flex_directionSeg.selectedSegmentIndex = 0;
                    break;
                case MyFlexDirection_Column:
                    self.flex_directionSeg.selectedSegmentIndex = 2;
                    break;
                case MyFlexDirection_Row_Reverse:
                    self.flex_directionSeg.selectedSegmentIndex = 1;
                    break;
                case MyFlexDirection_Column_Reverse:
                    self.flex_directionSeg.selectedSegmentIndex = 3;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            self.flex_wrapSeg.flexItem.visibility(MyVisibility_Visible);
            switch (self.contentLayout.flex.flex_wrap_val) {
                case MyFlexWrap_Wrap:
                    self.flex_wrapSeg.selectedSegmentIndex = 1;
                    break;
                case MyFlexWrap_NoWrap:
                    self.flex_wrapSeg.selectedSegmentIndex = 0;
                    break;
                case MyFlexWrap_Wrap_Reverse:
                    self.flex_wrapSeg.selectedSegmentIndex = 2;
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            self.justify_contentSeg.flexItem.visibility(MyVisibility_Visible);
            switch (self.contentLayout.flex.justify_content_val) {
                case MyFlexGravity_Flex_Start:
                    self.justify_contentSeg.selectedSegmentIndex = 0;
                    break;
                case MyFlexGravity_Flex_End:
                    self.justify_contentSeg.selectedSegmentIndex = 1;
                    break;
                case MyFlexGravity_Center:
                    self.justify_contentSeg.selectedSegmentIndex = 2;
                    break;
                case MyFlexGravity_Space_Between:
                    self.justify_contentSeg.selectedSegmentIndex = 3;
                    break;
                case MyFlexGravity_Space_Around:
                    self.justify_contentSeg.selectedSegmentIndex = 4;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            self.align_itemsSeg.flexItem.visibility(MyVisibility_Visible);
            switch (self.contentLayout.flex.align_items_val) {
                case MyFlexGravity_Flex_Start:
                    self.align_itemsSeg.selectedSegmentIndex = 0;
                    break;
                case MyFlexGravity_Flex_End:
                    self.align_itemsSeg.selectedSegmentIndex = 1;
                    break;
                case MyFlexGravity_Center:
                    self.align_itemsSeg.selectedSegmentIndex = 2;
                    break;
                case MyFlexGravity_Stretch:
                    self.align_itemsSeg.selectedSegmentIndex = 3;
                    break;
                case MyFlexGravity_Baseline:
                    self.align_itemsSeg.selectedSegmentIndex = 4;
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            self.align_contentSeg.flexItem.visibility(MyVisibility_Visible);
            switch (self.contentLayout.flex.align_content_val) {
                case MyFlexGravity_Flex_Start:
                    self.align_contentSeg.selectedSegmentIndex = 0;
                    break;
                case MyFlexGravity_Flex_End:
                    self.align_contentSeg.selectedSegmentIndex = 1;
                    break;
                case MyFlexGravity_Center:
                    self.align_contentSeg.selectedSegmentIndex = 2;
                    break;
                case MyFlexGravity_Space_Between:
                    self.align_contentSeg.selectedSegmentIndex = 3;
                    break;
                case MyFlexGravity_Space_Around:
                    self.align_contentSeg.selectedSegmentIndex = 4;
                    break;
                case MyFlexGravity_Stretch:
                    self.align_contentSeg.selectedSegmentIndex = 5;
                    break;
                default:;
            }
        }
            break;
        default:
            break;
    }
}

-(void)handleFlex_Direction:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.contentLayout.flex.flex_direction(MyFlexDirection_Row);
            break;
        case 1:
            self.contentLayout.flex.flex_direction(MyFlexDirection_Row_Reverse);
            break;
        case 2:
            self.contentLayout.flex.flex_direction(MyFlexDirection_Column);
            break;
        case 3:
            self.contentLayout.flex.flex_direction(MyFlexDirection_Column_Reverse);
        case 4:
        default:
            break;
    }
    
    [self updateStyleDesc];
    [self.contentLayout setNeedsLayout];
}

-(void)handleFlex_Wrap:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.contentLayout.flex.flex_wrap(MyFlexWrap_NoWrap);
            break;
        case 1:
            self.contentLayout.flex.flex_wrap(MyFlexWrap_Wrap);
            break;
        case 2:
            self.contentLayout.flex.flex_wrap(MyFlexWrap_Wrap_Reverse);
            break;
        default:
            break;
    }
    
    [self updateStyleDesc];
    [self.contentLayout setNeedsLayout];
}

-(void)handleJustify_Content:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.contentLayout.flex.justify_content(MyFlexGravity_Flex_Start);
            break;
        case 1:
            self.contentLayout.flex.justify_content(MyFlexGravity_Flex_End);
            break;
        case 2:
            self.contentLayout.flex.justify_content(MyFlexGravity_Center);
            break;
        case 3:
            self.contentLayout.flex.justify_content(MyFlexGravity_Space_Between);
            break;
        case 4:
            self.contentLayout.flex.justify_content(MyFlexGravity_Space_Around);
            break;
        default:
            break;
    }
    
    [self updateStyleDesc];
    [self.contentLayout setNeedsLayout];
}

-(void)handleAlign_Items:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.contentLayout.flex.align_items(MyFlexGravity_Flex_Start);
            break;
        case 1:
            self.contentLayout.flex.align_items(MyFlexGravity_Flex_End);
            break;
        case 2:
            self.contentLayout.flex.align_items(MyFlexGravity_Center);
            break;
        case 3:
            self.contentLayout.flex.align_items(MyFlexGravity_Stretch);
            break;
        case 4:
            self.contentLayout.flex.align_items(MyFlexGravity_Baseline);
            break;
        default:
            break;
    }
    
    [self updateStyleDesc];
    [self.contentLayout setNeedsLayout];
}


-(void)handleAlign_Content:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.contentLayout.flex.align_content(MyFlexGravity_Flex_Start);
            break;
        case 1:
            self.contentLayout.flex.align_content(MyFlexGravity_Flex_End);
            break;
        case 2:
            self.contentLayout.flex.align_content(MyFlexGravity_Center);
            break;
        case 3:
            self.contentLayout.flex.align_content(MyFlexGravity_Space_Between);
            break;
        case 4:
            self.contentLayout.flex.align_content(MyFlexGravity_Space_Around);
            break;
        case 5:
            self.contentLayout.flex.align_content(MyFlexGravity_Stretch);
            break;
        default:
            break;
    }
    
    [self updateStyleDesc];
    [self.contentLayout setNeedsLayout];
}

-(IBAction)handleSpaceChange:(UISwitch*)sender
{
    if (sender.isOn)
        self.contentLayout.flex.vert_space(10).horz_space(10);
    else
        self.contentLayout.flex.vert_space(0).horz_space(0);
}


-(IBAction)handlePaddingChange:(UISwitch*)sender
{
    if (sender.isOn)
        self.contentLayout.flex.padding(UIEdgeInsetsMake(20, 20, 20, 20));
    else
        self.contentLayout.flex.padding(UIEdgeInsetsZero);
}


-(IBAction)handleAddItem:(UIButton*)sender
{
    [self editFlexItem:nil];
}

-(IBAction)handleCloseDialog:(UIButton*)sender
{
    [sender.superview removeFromSuperview];
}

-(IBAction)handleSaveItem:(UIButton*)sender
{
    
    UIButton *itemView = nil;
    if (sender.tag != 0)
       itemView = (__bridge UIButton*)((void*)sender.tag);
    
    UITextField *widthTextField = [sender.superview viewWithTag:100];
    UITextField *heightTextField = [sender.superview viewWithTag:200];
    UITextField *orderTextField = [sender.superview viewWithTag:300];
    UITextField *flex_growTextField = [sender.superview viewWithTag:400];
    UITextField *flex_shrinkTextField = [sender.superview viewWithTag:500];
    UITextField *flex_basisTextField = [sender.superview viewWithTag:600];
    UITextField *align_selfTextField = [sender.superview viewWithTag:700];
    
    if (itemView == nil)
    {
        itemView = [UIButton new];
        itemView.backgroundColor = [CFTool color:arc4random_uniform(14) + 1];
        [self.contentLayout addSubview:itemView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleModifyItemView:)];
        [itemView addGestureRecognizer:tapGesture];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemoveItemView:)];
        [itemView addGestureRecognizer:longPressGesture];
        
    }
    
    //设置属性！！
    if (widthTextField.text.length == 0 && heightTextField.text.length == 0)
        return;
    
    NSString *widthStr = widthTextField.text;
    if ([widthStr isEqualToString:@"wrap"])
        itemView.flexItem.width_val = MyLayoutSize.wrap;
    else if ([widthStr isEqualToString:@"fill"])
        itemView.flexItem.width_val = MyLayoutSize.fill;
    else
        itemView.flexItem.width_val = widthStr.doubleValue;
    
    NSString *heightStr = heightTextField.text;
    if ([heightStr isEqualToString:@"wrap"])
        itemView.flexItem.height_val = MyLayoutSize.wrap;
    else if ([heightStr isEqualToString:@"fill"])
        itemView.flexItem.height_val = MyLayoutSize.fill;
    else
        itemView.flexItem.height_val = heightStr.doubleValue;
    
    [itemView setTitle:orderTextField.text forState:UIControlStateNormal];
    itemView.flexItem.order_val = orderTextField.text.integerValue;
    
    
    itemView.flexItem.flex_grow_val = flex_growTextField.text.doubleValue;
    
    if (flex_shrinkTextField.text.length > 0)
        itemView.flexItem.flex_shrink_val = flex_shrinkTextField.text.doubleValue;
    else
        itemView.flexItem.flex_shrink_val = 1;
    
     if (flex_basisTextField.text.length > 0)
         itemView.flexItem.flex_basis_val = flex_basisTextField.text.doubleValue;
    else
        itemView.flexItem.flex_basis_val = MyFlex_Auto;
    
    if (align_selfTextField.text.length > 0)
    {
        if ([align_selfTextField.text isEqualToString:@"flex-start"])
            itemView.flexItem.align_self_val = MyFlexGravity_Flex_Start;
        else if ([align_selfTextField.text isEqualToString:@"flex-end"])
            itemView.flexItem.align_self_val = MyFlexGravity_Flex_End;
        else if ([align_selfTextField.text isEqualToString:@"center"])
            itemView.flexItem.align_self_val = MyFlexGravity_Center;
        else if ([align_selfTextField.text isEqualToString:@"baseline"])
            itemView.flexItem.align_self_val = MyFlexGravity_Baseline;
        else if ([align_selfTextField.text isEqualToString:@"stretch"])
            itemView.flexItem.align_self_val = MyFlexGravity_Stretch;
        else
            itemView.flexItem.align_self_val = MyFlex_Auto;
    }
    else
    {
        itemView.flexItem.align_self_val = MyFlex_Auto;
    }
    
    //销毁对话框。
    [sender.superview removeFromSuperview];
    
    [self.contentLayout setNeedsLayout];
}

-(IBAction)handleModifyItemView:(UITapGestureRecognizer*)sender
{
    [self editFlexItem:sender.view];
}

-(IBAction)handleRemoveItemView:(UILongPressGestureRecognizer*)sender
{
    [sender.view removeFromSuperview];
}


@end

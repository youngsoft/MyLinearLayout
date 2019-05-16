//
//  AllTest1TableViewCellForAutoLayout.h
//  MyLayout
//
//  Created by apple on 19/5/16.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"
#import "AllTestDataModel.h"

/**
 * 动态高度UITableViewCellForAutoLayout
 * 本例子是将布局视图的高度自适应能力和使用Autolayout的情况下实现UITableViewCell高度自适应的能力
 */
@interface AllTest1TableViewCellForAutoLayout : UITableViewCell

//对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
@property(nonatomic, strong, readonly) MyBaseLayout *rootLayout;


-(void)setModel:(AllTest1DataModel*)model isImageMessageHidden:(BOOL)isImageMessageHidden;

@end

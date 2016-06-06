//
//  AllTest1TableViewCell.h
//  MyLayout
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"
#import "AllTestDataModel.h"

/**
 * 动态高度UITableViewCell
 */
@interface AllTest1TableViewCell : UITableViewCell

//对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
@property(nonatomic, strong, readonly) MyBaseLayout *rootLayout;


-(void)setModel:(AllTest1DataModel*)model isImageMessageHidden:(BOOL)isImageMessageHidden;

@end

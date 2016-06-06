//
//  AllTest1TableViewHeaderFooterView.h
//  MyLayout
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * UITableView中Section上的HeaderFooterView
 */
@interface AllTest1TableViewHeaderFooterView : UITableViewHeaderFooterView


-(void)setItemChangedAction:(void(^)(NSInteger index))action;


@end
//
//  AllTest10HeaderView.h
//  FriendListDemo
//
//  Created by 谢海龙 on 2018/5/8.
//  Copyright © 2018年 bsj_mac_2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"
@class AllTest10Model;
@class AllTest10HeaderView;
typedef void(^PraiseClickHandler)(AllTest10HeaderView *headerView, AllTest10Model *model);
typedef void(^CommentsClickHandler)(AllTest10HeaderView *headerView, AllTest10Model *model);

@interface AllTest10HeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) AllTest10Model * model;
@property (copy, nonatomic) PraiseClickHandler praiseClickHandler;
@property (copy, nonatomic) CommentsClickHandler commentsClickHandler;
@end

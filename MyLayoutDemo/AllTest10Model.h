//
//  AllTest10Model.h
//  FriendListDemo
//
//  Created by bsj_mac_2 on 2018/5/9.
//  Copyright © 2018年 bsj_mac_2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllTest10Model : NSObject

@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * icon;
@property (copy, nonatomic) NSString * content;
@property (copy, nonatomic) NSString * time;
@property (strong, nonatomic) NSArray * commentsImageUrls;
/*
 浏览次数
 */
@property (assign, nonatomic) NSInteger browCount;
/*
 点赞姓名集合(简洁起见，实际开发中转换为对应)
 */
@property (strong, nonatomic) NSMutableArray * giveLikeNames;
/*
 评论集合
 */
@property (strong, nonatomic) NSMutableArray * comments;
/*
 是否点赞
 */
@property (assign, nonatomic) BOOL isGiveLike;

/*
 模拟评论数据
 */
+ (NSArray<AllTest10Model *>*)getRandTestDatasWithNumber:(NSInteger)modelsNumber;

/*
 返回单挑模拟评论数据
 */
+ (NSString *)randTestComments;

@end

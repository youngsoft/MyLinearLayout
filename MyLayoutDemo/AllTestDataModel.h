//
//  AllTestDataModel.h
//  MyLayout
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//
#import <Foundation/Foundation.h>

//动态高度cell数据模型
@interface AllTest1DataModel : NSObject

@property(nonatomic, strong) NSString *headImage;     //头像
@property(nonatomic, strong) NSString *nickName;      //昵称
@property(nonatomic, strong) NSString *textMessage;   //文本消息
@property(nonatomic, strong) NSString *imageMessage;  //图片消息

@end


//静态高度cell数据模型
@interface AllTest2DataModel : NSObject

@property(nonatomic, strong) NSString *headImage;     //头像
@property(nonatomic, strong) NSString *name;          //名称
@property(nonatomic, strong) NSString *desc;          //描述
@property(nonatomic, strong) NSString *price;         //价格

@end


//动态尺寸cell数据模型
@interface AllTest9DataModel : NSObject

@property(nonatomic, strong) NSString *title;          //标题
@property(nonatomic, strong) NSString *subtitle;         //子标题

@end

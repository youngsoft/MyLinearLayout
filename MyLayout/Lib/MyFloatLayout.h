//
//  MyFloatLayout.h
//  MyLayout
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"


@interface UIView(MyFloatLayoutExt)

@property(nonatomic,assign) MyLayoutDirection floatDirection;   //定义浮动的方向,默认是None
@property(nonatomic,assign) MyLayoutDirection clearDirection;   //定义清除的方向,默认是None

@end



/**
 *  浮动布局，类似CCS提供的float类型的布局
 */
@interface MyFloatLayout : MyBaseLayout


//初始化一个浮动布局并指定布局的方向。
-(id)initWithOrientation:(MyLayoutViewOrientation)orientation;

+(id)floatLayoutWithOrientation:(MyLayoutViewOrientation)orientation;

//浮动布局的方向：
//如果是MyLayoutViewOrientation_Vert则表示从左到右，从上到下的垂直布局方式，这个方式是默认方式。
//如果是MyLayoutViewOrientation_Horz则表示从上到下，从左到右的水平布局方式
@property(nonatomic,assign) MyLayoutViewOrientation orientation;



@end

//
//  MyFloatLayout.h
//  MyLayout
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"


@interface UIView(MyFloatLayoutExt)

@property(nonatomic,assign,getter=isReverseFloat) BOOL reverseFloat; //是否反方向浮动，默认是NO表示正向浮动，具体方向则根据浮动布局视图的方向
@property(nonatomic,assign) BOOL clearFloat;   //清除浮动，默认是NO。

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

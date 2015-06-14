//
//  MyFrameLayout.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"


//视图自身在父视图的停靠位置
typedef enum : unsigned char {
    MGRAVITY_NONE = 0,
    
    //水平
    MGRAVITY_HORZ_LEFT = 1,
    MGRAVITY_HORZ_CENTER = 2,
    MGRAVITY_HORZ_RIGHT = 4,
    //水平填满
    MGRAVITY_HORZ_FILL = MGRAVITY_HORZ_LEFT | MGRAVITY_HORZ_CENTER | MGRAVITY_HORZ_RIGHT,
    
    //垂直
    MGRAVITY_VERT_TOP = 1 << 4,
    MGRAVITY_VERT_CENTER = 2 << 4,
    MGRAVITY_VERT_BOTTOM = 4 << 4,
    //垂直填满
    MGRAVITY_VERT_FILL = MGRAVITY_VERT_TOP | MGRAVITY_VERT_CENTER | MGRAVITY_VERT_BOTTOM,
    
    //居中
    MGRAVITY_CENTER = MGRAVITY_HORZ_CENTER | MGRAVITY_VERT_CENTER,
    
    //全屏填满
    MGRAVITY_FILL = MGRAVITY_HORZ_FILL | MGRAVITY_VERT_FILL
    
} MarignGravity;


//用于框架布局的子视图的属性，描述离兄弟视图的间隔距离，以及在父视图中的比重。
@interface UIView(FrameLayoutExtra)

//下面4个属性用于MyFrameLayout和MyRelativeLayout
@property(nonatomic,assign) CGFloat topMargin;
@property(nonatomic,assign) CGFloat leftMargin;
@property(nonatomic,assign) CGFloat bottomMargin;
@property(nonatomic,assign) CGFloat rightMargin;

//用于MyFrameLayout
@property(nonatomic, assign) MarignGravity marginGravity;

@end


@interface MyFrameLayout : MyLayout



@end

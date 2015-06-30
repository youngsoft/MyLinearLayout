//
//  MyLayout.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


/*专门为布局设置的简化操作类，以便在统一的地方进行布局设置*/
@interface MyMaker : NSObject

-(MyMaker*)topMargin;
-(MyMaker*)leftMargin;
-(MyMaker*)bottomMargin;
-(MyMaker*)rightMargin;
-(MyMaker*)margin;
-(MyMaker*)marginGravity;
-(MyMaker*)matchParentWidth;
-(MyMaker*)matchParentHeight;
-(MyMaker*)flexedHeight;
-(MyMaker*)weight;
-(MyMaker*)height;
-(MyMaker*)width;
-(MyMaker*)size;

//布局独有
-(MyMaker*)topPadding;
-(MyMaker*)leftPadding;
-(MyMaker*)bottomPadding;
-(MyMaker*)rightPadding;

-(MyMaker*)orientation;
-(MyMaker*)wrapContent;
-(MyMaker*)adjustScrollViewContentSize;
-(MyMaker*)gravity;
-(MyMaker*)autoAdjustSize;
-(MyMaker*)autoAdjustDir;


//赋值操支持NSNumber,以及UIView的值。
-(MyMaker* (^)(id val))equalTo;

@end



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

@interface UIView(LayoutExt)

//下面4个属性用于指定视图跟他相关视图之间的间距，如果为0则是没有间距，如果>0 <1则是相对间距,比如父视图是100，而左间距是0.1则值是10。如果大于等于1则是绝对间距
//一般当使用相对间距时主要用图是子视图的宽度和高度是固定的，只是边距随父视图的大小而调整。
@property(nonatomic,assign) CGFloat topMargin;
@property(nonatomic,assign) CGFloat leftMargin;
@property(nonatomic,assign) CGFloat bottomMargin;
@property(nonatomic,assign) CGFloat rightMargin;

@property(nonatomic,assign) UIEdgeInsets margin; //上面四个边距

//用于指定边距的停靠位置，也就是在父视图中的停靠策略，如果设置为MGRAVITY_NONE则不使用停靠策略而是使用frame中x,y来定位视图的位置。
@property(nonatomic, assign) MarignGravity marginGravity;


//视图的相对尺寸，如果为0则视图使用绝对的高度或宽度。值的范围是0-1表示自身的高度或者宽度是父视图高度和宽度的百分比，如果是1则表示和父视图是一样的高度和宽度
//如果为负数则表示子视图离父视图的两边的边距。
@property(nonatomic,assign) CGFloat matchParentWidth;
@property(nonatomic,assign) CGFloat matchParentHeight;



//设定视图的高度在宽度是固定的情况下根据内容的大小而浮动,如果内容无法容纳的话则自动拉升视图的高度,如果原始高度高于内容则会缩小视图的高度。默认为NO, 这个属性主要用UILabel,UITextView的多行的情况。
@property(nonatomic, assign, getter=isFlexedHeight) BOOL flexedHeight;


//设置视图的高度和宽度,取代初始化时的frame的设置
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGSize size;


//对视图进行统一的布局，方便操作，跟masonry库的设置一致，请参考DEMO1中的设置。
-(void)makeLayout:(void(^)(MyMaker *make))layoutMaker;

@end


/**画线用于布局的四周的线的绘制**/
@interface MyBorderLineDraw : NSObject

@property(nonatomic) UIColor *color;             //颜色
@property(nonatomic) UIColor *insetColor;        //嵌入颜色，用于实现立体效果
@property(nonatomic,assign) CGFloat thick;       //厚度,默认为1
@property(nonatomic,assign) CGFloat headIndent;  //头部缩进
@property(nonatomic, assign) CGFloat tailIndent;  //尾部缩进
@property(nonatomic, assign) CGFloat dash;        //虚线的点数如果为0则是实线。

-(id)initWithColor:(UIColor*)color;


@end



@interface MyLayout : UIView

@property(nonatomic,assign) UIEdgeInsets padding;  //用来描述里面的子视图的离自己的边距，默认上下左右都是0
//这个是上面属性的简化设置版本。
@property(nonatomic, assign) CGFloat topPadding;
@property(nonatomic, assign) CGFloat leftPadding;
@property(nonatomic, assign) CGFloat bottomPadding;
@property(nonatomic, assign) CGFloat rightPadding;



//布局时是否调用基类的布局方法，这个属性设置的作用体现在当自身的高度或者宽度调整时而且里面的子视图又设置了autoresizingMask时
//优先进行子视图的位置和高度宽度的拉升缩放，属性默认是NO
@property(nonatomic, assign) BOOL priorAutoresizingMask;


//设置自动布局前后的处理块，主要用于动画处理，可以在这两个函数中添加动画的代码。,如果为nil
@property(nonatomic,copy) void (^beginLayoutBlock)();
@property(nonatomic,copy) void (^endLayoutBlock)();


@property(nonatomic,assign) BOOL isLayouting;


//指定四个边界线的绘制。
@property(nonatomic, strong) MyBorderLineDraw *leftBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *rightBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *topBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *bottomBorderLine;

//同时设置4个边界线。
@property(nonatomic, strong) MyBorderLineDraw *boundBorderLine;


//下面的功能支持在布局视图中的触摸功能。

//高亮的背景色,我们支持在布局中执行单击的事件，用户按下时背景会高亮.只有设置了事件才会高亮
@property(nonatomic,strong) UIColor *highlightedBackgroundColor;

//设置单击触摸的事件，如果target为nil则取消事件。
-(void)setTarget:(id)target action:(SEL)action;



//内部使用函数，外部不需要调用。。
-(void)construct;

//派生类重载这个函数进行布局
-(void)doLayoutSubviews;

//判断margin是否是相对margin
-(BOOL)isRelativeMargin:(CGFloat)margin;

-(void)vertGravity:(MarignGravity)vert
        selfHeight:(CGFloat)selfHeight
         topMargin:(CGFloat)topMargin
      bottomMargin:(CGFloat)bottomMargin
              rect:(CGRect*)pRect;

-(void)horzGravity:(MarignGravity)horz
         selfWidth:(CGFloat)selfWidth
        leftMargin:(CGFloat)leftMargin
       rightMargin:(CGFloat)rightMargin
              rect:(CGRect*)pRect;

-(void)calcMatchParentWidth:(CGFloat)matchParent selfWidth:(CGFloat)selfWidth leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding rect:(CGRect*)pRect;

-(void)calcMatchParentHeight:(CGFloat)matchParent selfHeight:(CGFloat)selfHeight topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin topPadding:(CGFloat)topPadding bottomPadding:(CGFloat)bottomPadding rect:(CGRect*)pRect;





@end

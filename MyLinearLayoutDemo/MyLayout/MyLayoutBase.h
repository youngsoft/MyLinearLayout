//
//  MyLayoutBase.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <UIKit/UIKit.h>


//视图的停靠属性
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



/*布局位置对象*/
@interface MyLayoutPos : NSObject

//偏移
-(MyLayoutPos* (^)(CGFloat val))offset;


/*
 val的取值可以是NSNumber,MyLayoutPos,NSArray类型的对象。
 **如果是NSNumber类型的值表示在这个方向相对父视图或者兄弟视图(线性布局)的偏移值，比如：
   v.leftPos.equalTo(@10) 表示视图v左边偏移父视图或者兄弟视图10个点的位置。
   v.centerXPos.equalTo(@10) 表示视图v的水平中心点在父视图的水平中心点并偏移10个点的位置
   v.leftPos.equalTo(@0.1) 如果值被设置为大于0小于1则只在框架布局和线性布局里面有效表示左边距的值占用父视图宽度的10%
 **如果是MyLayoutPos类型的值则表示这个方向的值是相对于另外一个视图的边界值，比如：
   v1.leftPos.equal(v2.rightPos) 表示视图v1的左边边界值等于v2的右边边界值
 **如果是NSArray类型的值则只能用在相对布局的centerXPos,centerYPos中，数组里面里面也必须是centerXPos，表示指定的视图数组在父视图中居中，比如： A.centerXPos.equalTo(@[B.centerXPos.offset(20)].offset(20)  表示A和B在父视图中居中往下偏移20，B在A的右边，间隔20。
 */
-(MyLayoutPos* (^)(id val))equalTo;

@end


/*布局尺寸对象*/
@interface MyLayoutDime : NSObject

//乘
-(MyLayoutDime* (^)(CGFloat val))multiply;

//加,用这个和equalTo的数组功能可以实现均分子视图宽度以及间隔的设定。
-(MyLayoutDime* (^)(CGFloat val))add;


//NSNumber, MyLayoutDime以及MyLayoutDime数组，数组的概念就是所有数组里面的子视图的尺寸平分父视图的尺寸。
-(MyLayoutDime* (^)(id val))equalTo;


@end


@interface UIView(MyLayoutExt)

/*
 视图四周的边界值,主要用于相对布局的设置，也可以用于线性布局和框架布局
 如果这些值设置为NSNumber类型表示对应的方向上的偏移值
 */
@property(nonatomic, readonly)  MyLayoutPos *leftPos;
@property(nonatomic, readonly)  MyLayoutPos *topPos;
@property(nonatomic, readonly)  MyLayoutPos *rightPos;
@property(nonatomic, readonly)  MyLayoutPos *bottomPos;
@property(nonatomic, readonly)  MyLayoutPos *centerXPos;
@property(nonatomic, readonly)  MyLayoutPos *centerYPos;


//尺寸,如果设置了尺寸则以设置尺寸优先，否则以视图自身的frame的高宽为基准
@property(nonatomic, readonly)  MyLayoutDime *widthDime;
@property(nonatomic, readonly)  MyLayoutDime *heightDime;

//设定视图的高度在宽度是固定的情况下根据内容的大小而浮动,如果内容无法容纳的话则自动拉升视图的高度,如果原始高度高于内容则会缩小视图的高度。默认为NO, 这个属性主要用UILabel,UITextView的多行的情况。
@property(nonatomic, assign, getter=isFlexedHeight) BOOL flexedHeight;


/*
 下面四个属性是上面leftPos,topPos,rightPos,bottomPos的equalTo设置NSNumber类型的值时的简化版本主要用在线性布局和框架布局里面，
 表示距布局视图或者兄弟视图四周的边界值
 比如：
   v.leftMargin = 10   <==>   v.leftPos.equalTo(@10)  表示左边偏移10
 
 对于线性布局和框架布局来说当边界值设置为>0 并且<1时表示的相对的边界值，而为0和大于等于1时表示的是决定边界值。比如：
 v.leftMargin = 10;  表示视图v离左边10个距离的位置
 v.leftMargin = 0.1; 则表示视图v的左边距占用布局视图宽度的10%,如果布局视图宽度为200则左边距为20
 
 这四个属性的值最好别用于读取，而只是单纯用于设置
*/
@property(nonatomic, assign) CGFloat leftMargin;
@property(nonatomic, assign) CGFloat topMargin;
@property(nonatomic, assign) CGFloat rightMargin;
@property(nonatomic, assign) CGFloat bottomMargin;

/*
 下面两个属性是上面centerXPos,centerYPos的equalTo设置NSNumber类型的值时的简化版本，主要用在线性布局和相对布局里面表示距离布局视图
 中心的偏移量，如果设置为0则表示在布局视图的中间, 这三个属性的值最好别用于读取，而只是单纯用于设置
 
 v.centerXOffset = 0  <==> v.centerXPos.equalTo(@0)
 
 */
@property(nonatomic, assign) CGFloat centerXOffset;
@property(nonatomic, assign) CGFloat centerYOffset;
@property(nonatomic, assign) CGPoint centerOffset;


/*
 下面两个属性是上面widthDime,heightDime的equalTo设置NSNumber类型值的简化版本，主要用在线性布局和框架布局里面
 表示设置视图的宽度和高度，需要注意的是设置这三个值并不是直接设置frame里面的size的宽度和高度，而是设置的布局的高度和宽度值。
 也就是说设置和获取值并不一定是最终视图在布局时的真实高度和宽度，这三个属性的值最好别用于读取，而只是单纯用于设置
 
 v.width = 10    <=>   v.widthDime.equalTo(@10)
 
 */
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;

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


/*布局基类，基类不支持实例化对象*/
@interface MyLayoutBase : UIView

@property(nonatomic,assign) UIEdgeInsets padding;  //用来描述里面的子视图的离自己的边距，默认上下左右都是0
//这个是上面属性的简化设置版本。
@property(nonatomic, assign) CGFloat topPadding;
@property(nonatomic, assign) CGFloat leftPadding;
@property(nonatomic, assign) CGFloat bottomPadding;
@property(nonatomic, assign) CGFloat rightPadding;


//高宽是否由子视图决定，这两个属性只对线性和相对布局有效，框架布局无效
@property(nonatomic,assign) BOOL wrapContentWidth;
@property(nonatomic,assign) BOOL wrapContentHeight;


//如果布局的父视图是UIScrollView或者子类则在布局的位置调整后是否调整滚动视图的contentsize,默认是NO
//这个属性适合与整个布局作为滚动视图的唯一子视图来使用。
@property(nonatomic, assign, getter = isAdjustScrollViewContentSize) BOOL adjustScrollViewContentSize;



//布局时是否调用基类的布局方法，这个属性设置的作用体现在当自身的高度或者宽度调整时而且里面的子视图又设置了autoresizingMask时
//优先进行子视图的位置和高度宽度的拉升缩放，属性默认是NO
@property(nonatomic, assign) BOOL priorAutoresizingMask;


//指定当子视图隐藏时是否重新布局，默认为YES，表示一旦子视图隐藏则关联视图会重新布局。如果设置为NO的话则隐藏的子视图是不会重新布局的。
@property(nonatomic, assign) BOOL hideSubviewReLayout;


//设置自动布局前后的处理块，主要用于动画处理，可以在这两个函数中添加动画的代码。
//如果设置这两个函数则会在每次布局完成之后函数都将会置为nil
@property(nonatomic,copy) void (^beginLayoutBlock)();
@property(nonatomic,copy) void (^endLayoutBlock)();

//当前是否正在布局中。
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


-(void)calcMatchParentWidth:(MyLayoutDime*)match
                  selfWidth:(CGFloat)selfWidth
                 leftMargin:(CGFloat)leftMargin
               centerMargin:(CGFloat)centerMargin
                rightMargin:(CGFloat)rightMargin
                leftPadding:(CGFloat)leftPadding
               rightPadding:(CGFloat)rightPadding
                       rect:(CGRect*)pRect;

-(void)calcMatchParentHeight:(MyLayoutDime*)match
                  selfHeight:(CGFloat)selfHeight
                   topMargin:(CGFloat)topMargin
                centerMargin:(CGFloat)centerMargin
                bottomMargin:(CGFloat)bottomMargin
                  topPadding:(CGFloat)topPadding
               bottomPadding:(CGFloat)bottomPadding
                        rect:(CGRect*)pRect;





@end

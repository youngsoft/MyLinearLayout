//
//  MyLayoutBase.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutDef.h"
#import "MyLayoutPos.h"
#import "MyLayoutDime.h"



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


//得到视图的评估rect，在调用前请先调用父布局的-(CGRect)estimateLayoutRect;
-(CGRect)estimatedRect;

//清除所有布局设置
-(void)resetMyLayoutSetting;


//如果设置为YES则表示这个视图不会受任何布局视图的布局控制，而是用自身的frame的值进行布局，默认设置为NO
@property(nonatomic, assign) BOOL useFrame;


@end



/**画线用于布局的四周的线的绘制**/
@interface MyBorderLineDraw : NSObject

@property(nonatomic,strong) UIColor *color;             //颜色
@property(nonatomic,strong) UIColor *insetColor __attribute__((deprecated));       //嵌入颜色，用于实现立体效果,这个属性无效。
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


//高亮的背景色,我们支持在布局中执行单击的事件，用户按下时背景会高亮.只有设置了事件才会高亮
@property(nonatomic,strong) UIColor *highlightedBackgroundColor;

//设置背景图片，和高亮的背景图片.只有在布局中执行单击的事件按下时会有背景图片，只有设置了事件才会高亮。
@property(nonatomic,strong) UIImage *backgroundImage;
@property(nonatomic,strong) UIImage *highlightedBackgroundImage;


//设置单击触摸的事件，这个是触摸成功后的事件。如果target为nil则取消事件。
-(void)setTarget:(id)target action:(SEL)action;
//设置按下，按下取消(被取消，以及移动超过范围的取消)两个事件。如果设置为nil则取消事件，请不要在这两个事件中修改高亮颜色，背景图，以及高亮背景图。
-(void)setTouchDownTarget:(id)target action:(SEL)action;
-(void)setTouchCancelTarget:(id)target action:(SEL)action;


/*
 评估布局的尺寸,这个方法并不会进行真正的布局，只是对布局的尺寸进行评估。
 size指定期望的宽度或者高度，如果size中对应的值设置为0则根据布局自身的高度和宽度来进行评估，而设置为非0则固定指定的高度或者宽度来进行评估
 
 estimateLayoutRect:CGSizeMake(0,0) 表示按布局的位置和尺寸根据布局的子视图来进行动态评估。
 estimateLayoutRect:CGSizeMake(320,0) 表示布局的宽度固定为320,而高度则根据布局的子视图来进行动态评估。这个情况非常适用于UITableViewCell的动态高度的计算评估。
 estimateLayoutRect:CGSizeMake(0,100) 表示布局的高度固定为100,而宽度则根据布局的子视图来进行动态评估。
 
 通过对布局进行尺寸的评估，可以在不进行布局的情况下动态的计算出布局的位置和大小，但需要注意的是这个评估值有可能不是真实显示的实际位置和尺寸。
 
 */
-(CGRect)estimateLayoutRect:(CGSize)size;


@end

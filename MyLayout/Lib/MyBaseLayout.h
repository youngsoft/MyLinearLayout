//
//  MyBaseLayout.h
//  MyLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutDef.h"
#import "MyLayoutPos.h"
#import "MyLayoutDime.h"
#import "MyLayoutSizeClass.h"


/*
  视图的布局扩展属性，扩展属性的设置只有当视图作为布局视图的子视图时才会产生效果
 */
@interface UIView(MyLayoutExt)


//视图四周的边界值,用于设置视图与其他视图或者与父布局视图在左，上，右，下，水平中心，垂直中心6个方位之间的关系
@property(nonatomic, readonly)  MyLayoutPos *leftPos;
@property(nonatomic, readonly)  MyLayoutPos *topPos;
@property(nonatomic, readonly)  MyLayoutPos *rightPos;
@property(nonatomic, readonly)  MyLayoutPos *bottomPos;
@property(nonatomic, readonly)  MyLayoutPos *centerXPos;
@property(nonatomic, readonly)  MyLayoutPos *centerYPos;


//视图宽度和高度的尺寸值,如果设置了尺寸值则以设置的尺寸值优先，否则以视图自身的frame中的高宽设置为准。
@property(nonatomic, readonly)  MyLayoutDime *widthDime;
@property(nonatomic, readonly)  MyLayoutDime *heightDime;


/*
 下面四个属性是上面leftPos,topPos,rightPos,bottomPos的equalTo设置NSNumber类型的值时的简化版本，表示距布局视图或者兄弟视图四周的具体边界值
 比如：
   v.myLeftMargin = 10   <==>   v.leftPos.equalTo(@10)  表示左边偏移10
   v.myRightMargin = 20  <==>   v.rightPos.equalTo(@20) 表示右边偏移20
 
 对于线性布局和框架布局来说当: 0<边界值<1 时表示的相对的边界值，边界值<=0 OR 边界值>=1时表示的是绝对边界值。
 所谓相对边界值表示占用父布局视图剩余空间的百分比，而绝对边界值则是指绝对的高度或者宽度，只有在线性布局和框架布局中才支持相对边界值的设置，其他布局是不支持的。
 
 比如：
 v.myLeftMargin = 10;  表示视图v离左边10个距离的位置
 v.myLeftMargin = 0.1; 则表示视图v的左边距占用布局视图宽度的10%,如果布局视图宽度为200则左边距为20
 
 这四个属性的值最好别用于读取，而只是单纯用于设置
*/

//因为上面四个属性值可能会和其他库的名字有冲突，所以这里增加前缀
@property(nonatomic, assign) IBInspectable CGFloat myLeftMargin;
@property(nonatomic, assign) IBInspectable CGFloat myTopMargin;
@property(nonatomic, assign) IBInspectable CGFloat myRightMargin;
@property(nonatomic, assign) IBInspectable CGFloat myBottomMargin;
@property(nonatomic, assign) IBInspectable CGFloat myMargin;      //前面四个简易设置。

//如果您要使用下面的方法请定义MY_USEOLDMETHODDEF这个宏，如果想用老的方法不告警则定义MY_USEOLDMETHODNOWARNING这个宏
#ifdef MY_USEOLDMETHODDEF

@property(nonatomic, assign) CGFloat leftMargin   MYMETHODDEPRECATED("use myLeftMargin");
@property(nonatomic, assign) CGFloat topMargin    MYMETHODDEPRECATED("use myTopMargin");
@property(nonatomic, assign) CGFloat rightMargin  MYMETHODDEPRECATED("use myRightMargin");
@property(nonatomic, assign) CGFloat bottomMargin MYMETHODDEPRECATED("use myBottomMargin");

#endif



/*
 下面三个属性是上面centerXPos,centerYPos的equalTo设置NSNumber类型的值时的简化版本，表示视图距离布局视图
 中心的偏移量，如果设置为0则表示在布局视图的中间。
 
 v.myCenterXOffset = 0  <==> v.centerXPos.equalTo(@0)   表示视图v在布局视图的水平居中
 v.myCenterYOffset = 10 <==> v.centerYPos.equalTo(@10)  表示视图v在布局视图的垂直居中并往下偏移10个点
 v.myCenterOffset = CGPointMake(10,10) <==> v.centerXPos.equalTo(@10);v.centerYPos.equalTo(@10)
 
 这三个属性的值最好别用于读取，而只是单纯用于设置
 */
@property(nonatomic, assign) IBInspectable CGFloat myCenterXOffset;
@property(nonatomic, assign) IBInspectable CGFloat myCenterYOffset;
@property(nonatomic, assign) IBInspectable CGPoint myCenterOffset;


//如果您要使用下面的方法请定义MY_USEOLDMETHODDEF这个宏，如果想用老的方法不告警则定义MY_USEOLDMETHODNOWARNING这个宏
#ifdef MY_USEOLDMETHODDEF

@property(nonatomic, assign) CGFloat centerXOffset MYMETHODDEPRECATED("use myCenterXOffset");
@property(nonatomic, assign) CGFloat centerYOffset MYMETHODDEPRECATED("use myCenterYOffset");
@property(nonatomic, assign) CGPoint centerOffset  MYMETHODDEPRECATED("use myCenterOffset");

#endif



/*
 下面两个属性是上面widthDime,heightDime的equalTo设置NSNumber类型值的简化版本,表示设置视图的高度和宽度的尺寸。
 需要注意的是设置这三个值并不是直接设置frame里面的size的宽度和高度，而是设置的在布局中的高度和宽度值。
 
 v.myWidth = 10    <=>   v.widthDime.equalTo(@10)
 
 这两个属性的值最好别用于读取，而只是单纯用于设置
 */
@property(nonatomic,assign) IBInspectable CGFloat myWidth;
@property(nonatomic,assign) IBInspectable CGFloat myHeight;
@property(nonatomic,assign) IBInspectable CGSize  mySize;       //myWith,myHeight的结合


//如果您要使用下面的方法请定义MY_USEOLDMETHODDEF这个宏，如果想用老的方法不告警则定义MY_USEOLDMETHODNOWARNING这个宏
#ifdef MY_USEOLDMETHODDEF

@property(nonatomic,assign) CGFloat width  MYMETHODDEPRECATED("use myWidth");
@property(nonatomic,assign) CGFloat height MYMETHODDEPRECATED("use myHeight");

#endif





//设定视图的高度在宽度固定情况下是否根据内容的大小而自动调整,如果内容无法容纳的话则自动拉升视图的高度,如果原始高度高于内容的高度则会缩小视图的高度。默认为NO。
//这个属性主要用UILabel,UITextView的需要显示多行的情况，如果是UILabel则请numberOfLines的值。其他控件有可能设置这个属性无效，只有支持sizeThatFits这个方法的控件设置才有效
@property(nonatomic, assign, getter=isFlexedHeight) IBInspectable BOOL flexedHeight;


//如果设置为YES则表示这个视图不会受任何布局视图的布局控制，而是用自身的frame的值进行布局，默认设置为NO
//当这个属性设置为YES后，所有视图设置的扩展属性都不会生效，而是使用最原始的frame的设置来决定在布局中的大小和位置。
@property(nonatomic, assign) IBInspectable BOOL useFrame;


//得到视图的评估rect，在调用前请先调用父布局的-(CGRect)estimateLayoutRect，否则得到的结果未可知。
//函数的返回和视图的frame值有可能一致，有可能一致，这个方法用来得到视图在布局时的评估值，因为自动布局对上述的各种扩展属性的设置并不会立即进行布局而得到视图
//真实的位置和尺寸，因此可以通过这个方法来得到评估的位置和尺寸。
-(CGRect)estimatedRect;

//清除所有视图的扩展属性的设置。
-(void)resetMyLayoutSetting;
-(void)resetMyLayoutSettingInSizeClass:(MySizeClass)sizeClass;


//获取某个SizeClass下的MyLayoutSizeClass对象，然后用户可以通过MyLayoutSizeClass来设置这种SizeClass下的各种约束属性
//具体参考MyLayoutSizeClass和MySizeClass的定义和说明。
//这里虽然返回的是instancetype但实际返回的是MyLayoutSizeClass或者其派生类，默认函数不拷贝其他sizeClass。
-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass;

/*
 获取某个sizeClass的MyLayoutSizeClass或者其派生类，如果sizeClass不存在则会建立一个新的sizeClass，并且其布局内容都拷贝自srcSizeClass
的属性，如果sizeClass已经存在则srcSizeClass不起作用，如果srcSizeClass本来就不存在则也不会起作用.
 */
-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass;




@end


/**布局的边界画线，用于绘制布局的四周的边界线条**/
@interface MyBorderLineDraw : NSObject

@property(nonatomic,strong) UIColor *color;       //边界线的颜色
@property(nonatomic,strong) UIColor *insetColor __attribute__((deprecated));       //嵌入颜色，用于实现立体效果,这个属性无效。
@property(nonatomic,assign) CGFloat thick;        //边界线厚度,默认为1
@property(nonatomic,assign) CGFloat headIndent;   //边界线头部缩进单位
@property(nonatomic, assign) CGFloat tailIndent;  //边界线尾部缩进单位
@property(nonatomic, assign) CGFloat dash;        //虚线的点数如果为0则是实线。

-(id)initWithColor:(UIColor*)color;

@end



/*布局视图基类，基类不支持实例化对象*/
@interface MyBaseLayout : UIView


//用来设置所有子视图的离自己四周的距离，也就是内容的四周的缩进值， 默认上下左右都是0
@property(nonatomic,assign) UIEdgeInsets padding;

//这四个是上面属性的简化设置版本。
@property(nonatomic, assign) IBInspectable CGFloat topPadding;
@property(nonatomic, assign) IBInspectable CGFloat leftPadding;
@property(nonatomic, assign) IBInspectable CGFloat bottomPadding;
@property(nonatomic, assign) IBInspectable CGFloat rightPadding;


//指定布局的高度和宽度是否由所有子视图共同决定，这两个属性对于框架布局无效，
//如果设置为YES的话则表示布局视图的高度和宽度将会包裹所有的子视图，这样布局视图就不需要明确的设置自身的高度和宽度。
//如果设置为NO的话则表示布局视图需要指定自身的高度和宽度。
//这两个属性默认是设置为NO，但是派生类则不一定，比如线性布局就会根据子视图的排列方向而默认设置为YES。
//如果对某个布局设置了包裹子视图为YES而又同时设置了具体的高度或者宽度时则有可能会导致布局设置约束的冲突，因此在设置时需要注意可能会造成的约束冲突。
@property(nonatomic,assign) IBInspectable BOOL wrapContentWidth;
@property(nonatomic,assign) IBInspectable BOOL wrapContentHeight;


//如果布局的父视图是UIScrollView或者其子类的话则在布局的位置调整后是否调整滚动视图的contentsize,默认是NO
//这个属性适合与整个布局作为滚动视图的唯一子视图来使用，通过建立一个布局视图并设置wrapContentWidth或者wrapContentHeight为YES,然后将所有子视图都加入到这个布局视图中，再把布局视图放入到滚动条视图中去。
//如果将布局视图放入UIScrollView，UITableView,UICollectionView的话则自动会设置为YES,
/*
    UIScrollView *scrollView = UIScrollView.new;
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    contentLayout.myLeftMargin = contentLayout.myRightMargin = 0;
    [scrollView addSubview:contentLayout];
    //把所有子视图添加到contentLayout中去。
 
 */
@property(nonatomic, assign, getter = isAdjustScrollViewContentSize) BOOL adjustScrollViewContentSize;



//布局时是否调用基类的默认布局方法，这个属性设置的作用体现在当自身的高度或者宽度调整时而且里面的子视图又设置了autoresizingMask时优先进行子视图的位置和高度宽度的拉升缩放，属性默认是NO。
//布局视图的布局其实是重载了layoutSubviews方法，设置这个属性的目的是是否调用基类的layoutSubviews的方法
@property(nonatomic, assign) BOOL priorAutoresizingMask;


//指定当子视图隐藏时是否重新布局，默认为YES，表示一旦子视图隐藏则关联视图会重新布局。如果设置为NO的话则隐藏的子视图是不会重新布局的。
//设置这个属性为YES的话则只要子视图的hidden设置为YES时则会激发视图的重新布局，隐藏的子视图将不会占据任何的位置和尺寸，其他的未隐藏子视图将会覆盖这部分区域。
@property(nonatomic, assign) BOOL hideSubviewReLayout;



//设置自动布局前后的处理块，主要用于动画处理，可以在这两个函数中添加动画执行的代码。
//如果设置这两个函数则会在每次布局完成之后函数都将会置为nil
@property(nonatomic,copy) void (^beginLayoutBlock)();
@property(nonatomic,copy) void (^endLayoutBlock)();

//当前是否正在布局中,如果正在布局中则返回YES,否则返回NO
@property(nonatomic,assign,readonly) BOOL isMyLayouting;


//指定布局四个要绘制的边界线。
@property(nonatomic, strong) MyBorderLineDraw *leftBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *rightBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *topBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *bottomBorderLine;
//同时设置4个边界线。
@property(nonatomic, strong) MyBorderLineDraw *boundBorderLine;


//智能分割线，智能分割线会对布局里面所有的布局子视图添加边界线.
//只有当某两个布局子视图有交界边界的时候才会生成分割线，布局子视图和布局交界的边以及布局子视图和非布局子
//视图之间的交界的边不产生分割线。
//智能边界线只对布局视图里面的子布局视图产生效果
//v1.1.5版本暂时只支持线性布局和流式布局和浮动布局和表格布局这四种布局的
@property(nonatomic, strong) MyBorderLineDraw *IntelligentBorderLine;

//当布局视图的父布局视图定义了IntelligentBorderLine时，默认情况下父布局视图里面的所有子布局视图都会根据规则自动生成边界线
//而如果我们们将这个属性设置为YES时，则即使父布局视图设定了智能边界线，布局视图也不会自动生成边界线，而是根据上面定义的边界线来展示自己的边界线
//这个属性默认为NO。
@property(nonatomic, assign) BOOL notUseIntelligentBorderLine;



//布局高亮的背景色,我们支持在布局中执行触摸的事件，用户触摸手势按下时背景会高亮.只有设置了手势触摸事件才会高亮
@property(nonatomic,strong) IBInspectable UIColor *highlightedBackgroundColor;

//设置布局背景图片和高亮的背景图片，只有设置手势触摸事件高亮背景图片才会生效。
@property(nonatomic,strong) IBInspectable UIImage *backgroundImage;
@property(nonatomic,strong) IBInspectable UIImage *highlightedBackgroundImage;


//设置手势触摸的事件，这个是触摸成功后的事件。如果target为nil则取消事件，请不要在这个事件中调整高亮颜色，背景图，以及高亮背景图。
-(void)setTarget:(id)target action:(SEL)action;
//设置按下，按下取消(被取消，以及移动超过范围的取消)两个事件。如果设置为nil则取消事件，请不要在这两个事件中调整高亮颜色，背景图，以及高亮背景图。
-(void)setTouchDownTarget:(id)target action:(SEL)action;
-(void)setTouchCancelTarget:(id)target action:(SEL)action;


/*
 评估布局的尺寸,这个方法并不会进行真正的布局，只是对布局的尺寸进行评估。
 size指定期望的宽度或者高度，如果size中对应的值设置为0则根据布局自身的高度和宽度来进行评估，而设置为非0则固定指定的高度或者宽度来进行评估
 
 estimateLayoutRect:CGSizeMake(0,0) 表示按布局的位置和尺寸根据布局的子视图来进行动态评估。
 estimateLayoutRect:CGSizeMake(320,0) 表示布局的宽度固定为320,而高度则根据布局的子视图来进行动态评估。这个情况非常适用于UITableViewCell的动态高度的计算评估。
 estimateLayoutRect:CGSizeMake(0,100) 表示布局的高度固定为100,而宽度则根据布局的子视图来进行动态评估。
 
 通过对布局进行尺寸的评估，可以在不进行布局的情况下动态的计算出布局的位置和大小，但需要注意的是这个评估值有可能不是真实显示的实际位置和尺寸。

 sizeClass参数表示评估某个sizeClass下的尺寸值，如果没有找到指定的sizeClass则会根据继承规则得到最合适的sizeClass

 */
-(CGRect)estimateLayoutRect:(CGSize)size;
-(CGRect)estimateLayoutRect:(CGSize)size inSizeClass:(MySizeClass)sizeClass;


@end

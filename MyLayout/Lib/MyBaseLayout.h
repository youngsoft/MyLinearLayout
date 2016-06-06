//
//  MyBaseLayout.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"
#import "MyLayoutPos.h"
#import "MyLayoutDime.h"
#import "MyLayoutSizeClass.h"


@interface UIView(MyLayoutExt)


/*
   视图的布局位置对象属性，用来指定视图水平布局位置和垂直布局位置。对于一个视图来说我们可以使用frame属性中的origin部分来确定一个视图的左上方位在父视图的位置。这种方法的缺点是需要明确的指定一个常数值，以及需要进行位置的计算，缺乏可扩展性以及可维护性。因此对于布局视图里面的子视图来说我们将不再通过设置frame属性中的origin部分来确定位置，而是通过视图扩展的布局位置对象属性来设置视图的布局位置。子视图的布局位置对象在不同类型的布局视图里和不同的场景下所表达的意义以及能设置的值类型将会有一定的差异性。下面的表格将列出这些差异性：
 
 +--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------+
 |                    |Scene1            | Scene2               |Scene3         |Scene4     |Scene5              |Scene6 |Scene7 |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |Vert MyLinearLayout |   L,R,CX         | T,B                  | L,R,CX,T,B    |    -      |    -               | L,R   | -     |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |Horz MyLinearLayout |   T,B,CY         | L,R                  | L,R,T,B,CY    |    -      |    -               |  -    |T,B    |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |Vert MyTableLayout  |   T,B,CY         | L,R                  | L,R,T,B,CY    |    -      |    -               |  -    |T,B    |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |Horz MyTableLayout  |   L,R,CX         | T,B                  | L,R,CX,T,B    |    -      |    -               | L,R   |	-    |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |MyFrameLayout       |   ALL            |  -                   | L,R,T,B,CX,CY |    -      |    -               |  -    | -     |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |MyRelativeLayout    |   ALL            |  -                   |  -            |   ALL     |   CX,CY            | L,R   |T,B    |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |Vert MyFlowLayout   |   -              | T,B,R,L              |  -            |   -       |   -                | -     | -     |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |Horz MyFlowLayout   |   -              | T,B,R,L              |  -            |   -       |    -               | -     | -     |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |Vert MyFloatLayout  |   -              | T,B,R,L              |  -            |   -       |    -               | -     | -     |
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |Horz MyFloatLayout  |   -              | T,B,R,L              |  -            |   -       |    -               | -	 | -     |
 +--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------+

 *上面表格中L=leftPos, R=rightPos, T=topPos, B=bottomPos,CX=centerXPos,CY=centerYPos,ALL是所有布局位置对象,-表示不支持。
 *Scene表示在这种场景下支持的布局位置对象的种类，以及设置的值所表达的意义。
    比如上表中的行Vert MyLinearLayout,列Scene1中的值 L,R,CX 的意思是垂直线性布局下的子视图的leftPos,rightPos,centerXPos的位置值设置为数值时表示的是子视图的左右边距以及水平中心点在父布局下的中心点边距。
 
 Scene1:布局位置对象的值设置为数值,且表示他离父视图的边距。所谓边距就是指子视图跟父视图之间的距离。
     比如A.leftPos.equalTo(10)表示A的左边距是10，也就是A视图的左边和父视图的左边距离10个点。
 
 Scene2:布局位置对象的值设置为数值,且表示的是视图之间的间距。所谓间距就是指视图和其他视图之间的距离。这里要注意边距和间距的区别，边距是子视图和父视图之间的距离，间距是子视图和兄弟视图之间的距离。
     比如垂直线性布局视图L分别添加了A,B两个子视图则设置A.topPos.equalTo(10),A.bottomPos.equalTo(10),B.topPos.equalTo(10)的意思是A的顶部间距是10，底部间距也是10。视图B的顶部间距10。这样视图B和视图A之间的间距就是20
 Scene3:布局位置对象的值设置为大于0且小于1的数值,表示视图之间的相对距离。
      相对距离的最终距离 = (布局视图尺寸 - 所有固定尺寸和间距的视图) * 当前视图的相对距离 /(所有子视图相对距离的总和)
 
 Scene4:布局位置对象的值设置为MyLayoutPos对象，表示某个位置依赖于另外一个位置。只有在相对布局中的子视图的布局位置对象的位置值才能设置为MyLayoutPos对象。
    比如： A.leftPos.equalTo(B.rightPos)表示视图A的左边等于视图B的右边。
 
 Scene5:布局位置对象的值设置为NSArray<MyLayoutPos>数组对象，表示一组视图整体居中。只有在相对布局中的子视图的centerXPos或者centerYPos中的位置值才可以被设置为这种值。
    比如：A.centerXPos.equalTo(@[B.centerXPos,C.centerXPos])表示A,B,C三个子视图在相对布局中整体水平居中。
 
 Scene6:当同时设置了leftPos和rightPos左右边距后就能确定出视图的布局宽度了，这样就不需要为子视图指定布局宽度值了。需要注意的是只有同时设置了左右边距才能确定视图的宽度，而设置左右间距时则不能。
    比如：某个布局布局视图的宽度是100，而某个子视图的leftPos.equalTo(@10),rightPos.equalTo(@20).则这个子视图的宽度=70(100-10-20)
 
 Scene7:当同时设置了topPos和bottomPos上下边距后就能确定出视图的布局高度了，这样就不需要为子视图指定布局高度值了。需要注意的是只有同时设置了上下边距才能确定视图的高度，而设置上下间距是则不能。
    比如：某个布局布局视图高度是100，而某个子视图的topPos.equalTo(@10),bottomPos.equalTo(@20).则这个子视图的高度=70(100-10-20)

*/

/**
 *视图的左边布局位置对象。(left layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *leftPos;

/**
 *视图的上边布局位置对象。(top layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *topPos;

/**
 *视图的右边布局位置对象。(right layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *rightPos;

/**
 *视图的下边布局位置对象。(bottom layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *bottomPos;

/**
 *视图的水平中心布局位置对象。(horizontal center layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *centerXPos;

/**
 *视图的垂直中心布局位置对象。(vertical center layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *centerYPos;



/*
 下面定义的八个属性是上面定义的leftPos,topPos,rightPos,bottomPos,centerXPos,centerYPos的equalTo设置NSNumber类型的值时的简化版本。
 比如：
 v.myLeftMargin = 10    <==>   v.leftPos.equalTo(@10)
 v.myRightMargin = 20   <==>   v.rightPos.equalTo(@20)
 v.myCenterXOffset = 0  <==>   v.centerXPos.equalTo(@0)


 这八个属性的值最好别用于读取，而只是单纯用于设置
*/

/**
 *视图左边的布局位置, 是leftPos.equalTo方法的简化版本
 */
/**
 *Left layout position of the view. Equivalent to leftPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myLeftMargin;

/**
 *视图上边的布局位置, 是topPos.equalTo方法的简化版本
 */
/**
 *Top layout position of the view. Equivalent to topPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myTopMargin;

/**
 *视图右边的布局位置, 是rightPos.equalTo方法的简化版本
 */
/**
 *Right layout position of the view. Equivalent to rightPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myRightMargin;

/**
 *视图下边的布局位置, 是bottomPos.equalTo方法的简化版本
 */
/**
 *Bottom layout position of the view. Equivalent to bottomPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myBottomMargin;

/**
 *视图四边的布局位置, 是myLeftMargin,myTopMargin,myRightMargin,myBottomMargin的简化版本
 */
/**
 *Boundary layout position of the view. Equivalent to myLeftMargin,myTopMargin,myRightMargin,myBottomMargin set to the same number.
 */
@property(nonatomic, assign) IBInspectable CGFloat myMargin;

/**
 *视图水平中心布局位置, 是centerXPos.equalTo方法的简化版本
 */
/**
 *Horizontal center layout position of the view. Equivalent to centerXPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myCenterXOffset;

/**
 *视图垂直中心布局位置, 是centerYPos.equalTo方法的简化版本
 */
/**
 *Vertical center layout position of the view. Equivalent to centerYPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myCenterYOffset;

/**
 *视图中心布局位置, 是myCenterXOffset,myCenterYOffset方法的简化版本
 */
/**
 *Center layout position of the view. Equivalent to set myCenterXOffset and myCenterYOffset .
 */
@property(nonatomic, assign) IBInspectable CGPoint myCenterOffset;


/*
 视图的布局尺寸对象MyLayoutDime,用于设置视图的宽度和高度尺寸。视图可以通过设置frame值来设置自身的尺寸，也可以通过设置widthDime和heightDime来
 设置布局尺寸，通过frame设置的结果会立即生效，而通过widthDime和heightDime设置则会在布局后才生效，如果同时设置了frame值和MyLayoutDime值则MyLayoutDime的设置值优先。
 
 其中的equalTo方法可用于设置布局尺寸的具体值：
 1.如果设置为NSNumber则表示布局尺寸是一个具体的数值。比如widthDime.equalTo(@20)表示视图的宽度设置为20个点。
 2.如果设置为MyLayoutDime则表示布局尺寸依赖于另外一个视图的布局尺寸。比如A.widthDime.equalTo(B.widthDime)表示A的宽度和B的宽度相等
 3.如果设置为NSArray<MyLayoutDime*>则表示视图和数组里面的视图均分布局视图的宽度或者高度。比如A.widthDime.equalTo(@[B.widthDime,C.widthDime])表示视图A,B,C三个视图均分父视图的宽度。
 4.如果设置为nil则表示取消布局尺寸的值的设置。
 
 其中的add方法可以用于设置布局尺寸的增加值，一般只和equalTo设置为MyLayoutDime和NSArray时配合使用。比如A.widthDime.equalTo(B.widthDime).add(20)表示视图A的宽度等于视图B的宽度再加上20个点。
 
 其中的multiply方法可用于设置布局尺寸放大的倍数值。比如A.widthDime.equalTo(B.widthDime).multiply(2)表示视图A的宽度是视图B的宽度的2倍。
 
 其中的min,max表示用来设置布局尺寸的最大最小值。比如A.widthDime.min(10).max(40)表示宽度的最小是10最大是40。
 
 下面的表格描述了在各种布局下的子视图的布局尺寸对象的equalTo方法可以设置的值。
 为了表示方便我们把：
     线性布局简写为L、垂直线性布局简写为L-V、水平线性布局简写为L-H 相对布局简写为R、表格布局简写为T、框架布局简写为FR、
     流式布局简写为FL、垂直流式布局简写为FL-V，水平流式布局简写为FL-H、浮动布局简写为FO、左右浮动布局简写为FO-V、上下浮动布局简写为FO-H、
     全部简写为ALL，不支持为-，
 
 定义A为操作的视图本身，B为A的兄弟视图，P为A的父视图。
 +-------------+----------+-------------+--------------+------------+--------------+---------------+--------------+----------------------+
 | 对象 \ 值    | NSNumber |A.widthDime	|A.heightDime  |B.widthDime	| B.heightDime |	P.widthDime|P.heightDime  |NSArray<MyLayoutDime*>|
 +-------------+----------+-------------+--------------+------------+--------------+---------------+--------------+----------------------+
 |A.widthDime  | ALL	  |ALL	        |FR/R/FL-H/FO  |FR/R/FO	    | R	           |L/FR/R/FL/FO   | R	          |R                     |
 +-------------+----------+-------------+--------------+------------+--------------+---------------+--------------+----------------------+
 |A.heightDime | ALL	  |FR/R/FL-V/FO	|ALL           |R	        |FR/R/FO       |R              |L/FR/R/FL/FO  |R                     |
 +-------------+----------+-------------+--------------+------------+--------------+---------------+--------------+----------------------+

  上表中所有的布局尺寸的值都支持设置为数值，而且所有布局下的子视图的宽度和高度尺寸都可以设置为等于自身的宽度和高度尺寸，布局库这里做了特殊处理，是不会造成循环引用的。比如：
    A.widthDime.equalTo(A.widthDime)，支持这种设置的原因是有时候比如希望某个UILabel的宽度是在其本身内容宽度的基础上再添加一个增加值，这时候就可以设置如下：
    A.widthDime.equalTo(A.widthDime).add(30);
    表示视图A的宽度总是视图内容的宽度+30，这样即使视图调用了sizeToFit方法来计算出包裹内容的宽度，但是最终的布局宽度还是会再增加30个点。
 
 */
/**
 the MyLayoutDime is layout dimension object object of the UIView. used to set the width and height of the View which is in Layout View
 */



/**
 *视图的宽度布局尺寸对象，可以通过其中的euqalTo方法来设置NSNumber,MyLayoutDime,NSArray<MyLayoutDime*>,nil这四种值
 */
@property(nonatomic, readonly)  MyLayoutDime *widthDime;

/**
 *视图的高度布局尺寸对象，可以通过其中的euqalTo方法来设置NSNumber,MyLayoutDime,NSArray<MyLayoutDime*>,nil这四种值
 */
@property(nonatomic, readonly)  MyLayoutDime *heightDime;



/*
 下面三个属性是上面widthDime,heightDime的equalTo设置NSNumber类型值的简化版本,表示设置视图的高度和宽度的布局尺寸。
 需要注意的是设置这三个值并不是直接设置frame里面的size的宽度和高度，而是设置的是布局尺寸的数值
 
 v.myWidth = 10    <=>   v.widthDime.equalTo(@10)
 v.myHeight = 20   <=>   v.heightDime.equalTo(@10)
 
 这三个属性的值最好别用于读取，而只是单纯用于设置
 */

/**
 *视图的宽度布局尺寸,是widthDime.equalTo方法的简化版本
 */
@property(nonatomic,assign) IBInspectable CGFloat myWidth;

/**
 *视图的高度布局尺寸,是heightDime.equalTo方法的简化版本
 */
@property(nonatomic,assign) IBInspectable CGFloat myHeight;

/**
 *视图的宽度高度布局尺寸,是myWidth,myHeight方法的简化版本
 */
@property(nonatomic,assign) IBInspectable CGSize  mySize;



/**
 *视图的高度根据内容自适应。当设置为YES时视图会在固定宽度的情况下自动调整高度来自适应视图的内容,默认设置为NO。这个属性主要用于UILabel,UITextView以及实现了sizeThatFits方法的视图，当设置这个属性为YES时，视图的宽度必须要明确的被指定。UILabel在使用这个属性时请同时设置numberOfLines不等于1。UITextView可以用这个属性以及heightDime中的max方法来实现到达指定的高度后若继续输入则产生滚动的效果。UIImageView可以用这个属性来在确定宽度的情况下高度根据宽度的缩放情况进行等比例的缩放。
 */
@property(nonatomic, assign, getter=isFlexedHeight) IBInspectable BOOL flexedHeight;


/**
 *设置视图不受布局视图的布局约束控制，所有的视图扩展属性失效而是用自身原始的frame的设置值来进行定位和布局，默认值是NO。这个属性一般用来实现视图在特定场景下的动画效果，以及可以和布局视图的autoresizesSubviews方法配合使用来实现一些特殊功能。
 */
@property(nonatomic, assign) IBInspectable BOOL useFrame;

/**
 *设置视图在进行布局时只占位置而不真实的调整位置和尺寸。也就是视图的真实位置和尺寸不变，但在布局视图布局时会保留出子视图的布局位置和布局尺寸的空间，这个属性通常和useFrame混合使用来实现一些动画特效。通常在处理时设置：noLayout为YES同时useFrame为NO时布局时视图的frame是不会改变的，而当useFrame设置为YES时则noLayout属性无效。
 */
@property(nonatomic, assign) IBInspectable BOOL noLayout;


/**
 *视图的评估Rect值。评估的Rect值是在布局前评估计算的值，而frame则是视图真正完成布局后的真实的Rect值。在调用这个方法前请先调用父布局视图的-(CGRect)estimateLayoutRect方法进行布局视图的尺寸评估，否则此方法返回的值未可知。这个方法主要用于在视图布局前而想得到其在父布局视图中的Rect值的场景。
 */
-(CGRect)estimatedRect;

/**
 *清除所有为布局而设置的视图扩展属性值。
 *@sizeClass: 清除某个MySizeClass下设置的视图扩展属性值。
 */
-(void)resetMyLayoutSetting;
-(void)resetMyLayoutSettingInSizeClass:(MySizeClass)sizeClass;


/**
 *获取视图在某个SizeClass下的MyLayoutSizeClass对象。可以通过得到的MyLayoutSizeClass对象来设置视图在对应SizeClass下的各种布局约束属性。
 */
-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass;

/**
 *获取视图在某个SizeClass下的MyLayoutSizeClass对象，如果对象不存在则会新建立一个MyLayoutSizeClass对象，并且其布局约束属性都拷贝自srcSizeClass的属性，如果对象已经存在则srcSizeClass不起作用，如果srcSizeClass本来就不存在则也不会起作用。
 */
-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass;



@end


/**布局的边界画线类，用于实现绘制布局的四周的边界线的功能**/
@interface MyBorderLineDraw : NSObject

/**边界线的颜色*/
@property(nonatomic,strong) UIColor *color;
/**边界线的厚度，默认是1*/
@property(nonatomic,assign) CGFloat thick;
/**边界线的头部缩进单位*/
@property(nonatomic,assign) CGFloat headIndent;
/**边界线的尾部缩进单位*/
@property(nonatomic, assign) CGFloat tailIndent;
/**设置边界线为点划线,如果是0则边界线是实线*/
@property(nonatomic, assign) CGFloat dash;


-(id)initWithColor:(UIColor*)color;

@end



/*布局视图基类，基类不支持实例化对象*/
@interface MyBaseLayout : UIView

/**
 * 设置布局视图四周的内边距值。所谓内边距是指布局视图内的所有子视图离布局视图四周的边距。通过为布局视图设置内边距可以减少为所有子视图设置外边距的工作，而外边距则是指视图离父视图四周的距离。
 */
@property(nonatomic,assign) UIEdgeInsets padding;
@property(nonatomic, assign) IBInspectable CGFloat topPadding;
@property(nonatomic, assign) IBInspectable CGFloat leftPadding;
@property(nonatomic, assign) IBInspectable CGFloat bottomPadding;
@property(nonatomic, assign) IBInspectable CGFloat rightPadding;


/**
 *布局视图的宽度包裹属性，表示布局视图的宽度等于所有子视图的整体宽度。默认值是NO。当设置为NO是必须要明确指定布局的宽度，而当设置为YES时则不需要明确的指定布局视图的宽度了，否则可能会产生约束冲突而导致死循环的出现。wrapContentWidth的优先级最低，一旦布局视图明确的指定了宽度则属性设置无效。
 */
@property(nonatomic,assign) IBInspectable BOOL wrapContentWidth;
/**
 *布局视图的高度包裹属性，表示布局视图的高度等于所有子视图的整体高度。默认值是NO。当设置为NO是必须要明确指定布局的高度，而当设置为YES时则不需要明确的指定布局视图的高度了，否则可能会产生约束冲突而导致死循环的出现。wrapContentHeight的优先级最低，一旦布局视图明确的指定了高度则属性设置无效。
 */
@property(nonatomic,assign) IBInspectable BOOL wrapContentHeight;


/**
 *把一个布局视图放入到UIScrollView内时是否自动调整UIScrollView的contentSize值，默认是YES。你可以将这个属性设置NO而不调整contentSize的值，要设置这个属性值为NO请在将布局视图添加到UIScrollView以后再设置才能生效
 */
@property(nonatomic, assign, getter = isAdjustScrollViewContentSize) BOOL adjustScrollViewContentSize;


/**
 *在布局视图进行布局时是否调用基类的layoutSubviews方法，默认设置为NO。
 */
@property(nonatomic, assign) BOOL priorAutoresizingMask;


/**
 *设置当布局视图里面的子视图隐藏时，是否重新布局所有非隐藏的子视图。默认值是YES，表示当有子视图隐藏时，隐藏的子视图将不会占据任何位置和尺寸，而其他的未隐藏的子视图将会覆盖掉隐藏的子视图的位置和尺寸。如果布局视图的宽度或者高度在设置了包裹属性后也会重新调整。
 */
@property(nonatomic, assign) BOOL hideSubviewReLayout;


/**
 *设置布局视图在布局之前和布局完成之后的处理块。这两个处理块主要用来实现布局的动画功能。系统会在每次布局完成之后将处理块清空为nil。您也可以在endLayoutBlock块内取到所有子视图真实布局后的frame值。
 */
@property(nonatomic,copy) void (^beginLayoutBlock)();
@property(nonatomic,copy) void (^endLayoutBlock)();

/**
 *设置布局时的动画。并指定时间。这个函数是下面方法的简单实现：
 
  self.beginLayoutBlock = ^{
 
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:duration];
 };
 
 self.endLayoutBlock = ^{
 
 [UIView commitAnimations];
 };

 
 */
-(void)layoutAnimationWithDuration:(NSTimeInterval)duration;



/**当前是否正在布局中,如果正在布局中则返回YES,否则返回NO*/
@property(nonatomic,assign,readonly) BOOL isMyLayouting;


/**
 *设置布局的四周的边界线对象,boundBorderLine是同时设置四周的边界线。
 */
@property(nonatomic, strong) MyBorderLineDraw *leftBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *rightBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *topBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *bottomBorderLine;
@property(nonatomic, strong) MyBorderLineDraw *boundBorderLine;


/**
 *智能边界线，智能边界线不是设置自身的边界线而是对添加到布局视图里面的子布局视图根据子视图之间的关系智能的生成边界线，对于布局视图里面的非布局子视图则不会生成边界线。目前的版本只支持线性布局，表格布局，流式布局和浮动布局这四种布局。
 */
@property(nonatomic, strong) MyBorderLineDraw *IntelligentBorderLine;

/**
 *不使用父布局视图提供的智能边界线功能。当布局视图的父布局视图设置了IntelligentBorderLine时但是布局视图又想自己定义边界线时则将这个属性设置为YES
 */
@property(nonatomic, assign) BOOL notUseIntelligentBorderLine;


/**
 *设置布局按下时背景的高亮的颜色。只有设置了setTarget:action方法此属性才生效。
 */
@property(nonatomic,strong) IBInspectable UIColor *highlightedBackgroundColor;

/**
 *设置布局按下时的高亮不透明度。值的范围是[0,1]，默认是0表示完全不透明，为1表示完全透明。只有设置了setTarget:action方法此属性才生效。
 */
@property(nonatomic,assign) IBInspectable CGFloat highlightedOpacity;

/**
 *设置布局的背景图片。这个属性的设置就是设置了布局的layer.contents的值，因此如果要实现背景图的局部拉伸请用layer.contentsXXX这些属性进行调整
 */
@property(nonatomic,strong) IBInspectable UIImage *backgroundImage;

/**
 *设置布局按下时的高亮背景图片。只有设置了setTarget:action方法此属性才生效。
 */
@property(nonatomic,strong) IBInspectable UIImage *highlightedBackgroundImage;

/**
 *设置布局的Touch、按下、取消事件的处理动作,后两个事件的处理必须依赖于第一个事件的处理。请不要在这些处理动作中修改背景色，不透明度，以及背景图片。如果您只想要高亮效果但是不想处理事件则将action设置为nil即可了。
 * @target: 事件的处理对象，如果设置为nil则表示取消事件。
 * @action: 事件的处理动作，格式为：-(void)handleAction:(MyBaseLayout*)sender。
 */
-(void)setTarget:(id)target action:(SEL)action;
-(void)setTouchDownTarget:(id)target action:(SEL)action;
-(void)setTouchCancelTarget:(id)target action:(SEL)action;


/**
 *评估布局视图的尺寸,这个方法并不会进行真正的布局，只是对布局的尺寸进行评估，主要用于在布局前想预先知道布局尺寸的场景。通过对布局进行尺寸的评估，可以在不进行布局的情况下动态的计算出布局的位置和大小，但需要注意的是这个评估值有可能不是真实显示的实际位置和尺寸。
 *@size：指定期望的宽度或者高度，如果size中对应的值设置为0则根据布局自身的高度和宽度来进行评估，而设置为非0则固定指定的高度或者宽度来进行评估。比如下面的例子：
 * estimateLayoutRect:CGSizeMake(0,0) 表示按布局的位置和尺寸根据布局的子视图来进行动态评估。
 * estimateLayoutRect:CGSizeMake(320,0) 表示布局的宽度固定为320,而高度则根据布局的子视图来进行动态评估。这个情况非常适用于UITableViewCell的动态高度的计算评估。
 * estimateLayoutRect:CGSizeMake(0,100) 表示布局的高度固定为100,而宽度则根据布局的子视图来进行动态评估。
 *@sizeClass:参数表示评估某个sizeClass下的尺寸值，如果没有找到指定的sizeClass则会根据继承规则得到最合适的sizeClass
 */
-(CGRect)estimateLayoutRect:(CGSize)size;
-(CGRect)estimateLayoutRect:(CGSize)size inSizeClass:(MySizeClass)sizeClass;


@end

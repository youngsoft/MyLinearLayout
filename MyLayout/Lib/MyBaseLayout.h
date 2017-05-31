//
//  MyBaseLayout.h
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"
#import "MyLayoutPos.h"
#import "MyLayoutSize.h"
#import "MyLayoutSizeClass.h"

/*
 几种视图类型的定义：
1.布局视图：    就是从MyBaseLayout派生而出的视图，目前MyLayout中一共有：线性布局、框架布局、相对布局、表格布局、流式布局、浮动布局、路径布局7种布局。 布局视图也是一个视图。
2.非布局视图：  除上面说的7种布局视图外的所有视图和控件。
3.布局父视图：  如果某个视图的父视图是一个布局视图，那么这个父视图就是布局父视图。
4.非布局父视图：如果某个视图的父视图不是一个布局视图，那么这个父视图就是非布局父视图。
5.布局子视图：  如果某个视图的子视图是一个布局视图，那么这个子视图就是布局子视图。
6.非布局子视图：如果某个视图的子视图不是一个布局视图，那么这个子视图就是非布局子视图。
*/


@class MyBaseLayout;

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
 |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
 |MyPathLayout        |   -              | T,L                  |  -            |   -       |    -               | -	 | -     |
 +--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------+

 *上面表格中L=leftPos, R=rightPos, T=topPos, B=bottomPos,CX=centerXPos,CY=centerYPos,ALL是所有布局位置对象,-表示不支持。
 *Scene表示在这种场景下支持的布局位置对象的种类，以及设置的值所表达的意义。
    比如上表中的行Vert MyLinearLayout,列Scene1中的值 L,R,CX 的意思是垂直线性布局下的子视图的leftPos,rightPos,centerXPos的位置值设置为数值时表示的是子视图的左右边距以及水平中心点在父布局下的中心点边距。
 
 Scene1:布局位置对象的值设置为数值,且表示他离父视图的边距。所谓边距就是指子视图跟父视图之间的距离。
     比如A.leftPos.equalTo(10)表示A的左边距是10，也就是A视图的左边和父视图的左边距离10个点。
 
 Scene2:布局位置对象的值设置为数值,且表示的是视图之间的间距。所谓间距就是指视图和其他视图之间的距离。这里要注意边距和间距的区别，边距是子视图和父视图之间的距离，间距是子视图和兄弟视图之间的距离。
     比如垂直线性布局视图L分别添加了A,B两个子视图则设置A.topPos.equalTo(10),A.bottomPos.equalTo(10),B.topPos.equalTo(10)的意思是A的顶部间距是10，底部间距也是10。视图B的顶部间距10。这样视图B和视图A之间的间距就是20
 Scene3:布局位置对象的值设置为大于0且小于1的数值,表示视图之间的相对间距值或者边距值。
      视图的相对间距的最终距离 = (布局视图尺寸 - 所有固定尺寸和固定间距之和) * 当前视图的相对间距值 /(所有子视图相对间距的总和)
      视图的相对边距的最终距离 = 布局视图尺寸 * 当前视图的相对边距值

 
 Scene4:布局位置对象的值设置为MyLayoutPos对象，表示某个位置依赖于另外一个位置。只有在相对布局中的子视图的布局位置对象的位置值才能设置为MyLayoutPos对象。
    比如： A.leftPos.equalTo(B.rightPos)表示视图A的左边等于视图B的右边。
 
 Scene5:布局位置对象的值设置为NSArray<MyLayoutPos>数组对象，表示一组视图整体居中。只有在相对布局中的子视图的centerXPos或者centerYPos中的位置值才可以被设置为这种值。
    比如：A.centerXPos.equalTo(@[B.centerXPos,C.centerXPos])表示A,B,C三个子视图在相对布局中整体水平居中。
 
 Scene6:当同时设置了leftPos和rightPos左右边距后就能确定出视图的布局宽度了，这样就不需要为子视图指定布局宽度值了。需要注意的是只有同时设置了左右边距才能确定视图的宽度，而设置左右间距时则不能。
    比如：某个布局布局视图的宽度是100，而某个子视图的leftPos.equalTo(@10),rightPos.equalTo(@20).则这个子视图的宽度=70(100-10-20)
 
 Scene7:当同时设置了topPos和bottomPos上下边距后就能确定出视图的布局高度了，这样就不需要为子视图指定布局高度值了。需要注意的是只有同时设置了上下边距才能确定视图的高度，而设置上下间距是则不能。
    比如：某个布局布局视图高度是100，而某个子视图的topPos.equalTo(@10),bottomPos.equalTo(@20).则这个子视图的高度=70(100-10-20)

 另外如果某个布局视图是视图控制器的根视图，那么你可以将布局视图里面的第一个子视图的topPos设置为： topPos.equalTo(vc.topLayoutGuide) 或者最后一个子视图的bottomPos设置为bottomPos.equalTo(vc.bottomLayoutGuide） 这样不管视图控制器所在的导航条是否半透明，总是会显示在导航条下面的位置。。
 
*/


/**
 *视图的上边布局位置对象。(top layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *topPos;

/**
 *视图的头部布局位置对象,对于非阿拉伯国家就是左边，对于阿拉伯国家就是右边(leading layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *leadingPos;


/**
 *视图的下边布局位置对象。(bottom layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *bottomPos;


/**
 *视图的尾部布局位置对象,对于非阿拉伯国家就是右边，对于阿拉伯国家就是左边。(trailing layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *trailingPos;


/**
 *视图的水平中心布局位置对象。(horizontal center layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *centerXPos;

/**
 *视图的垂直中心布局位置对象。(vertical center layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *centerYPos;



/**
 *视图的左边布局位置对象。如果您不考虑国际化布局就用这个属性，如果考虑国际化则请用leadingPos(left layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *leftPos;

/**
 *视图的右边布局位置对象。如果您不考虑国际化布局就用这个属性，如果考虑国际化则请用trailingPos(right layout position of the view.)
 */
@property(nonatomic, readonly)  MyLayoutPos *rightPos;





/*
 下面定义的八个属性是上面定义的leftPos,topPos,rightPos,bottomPos,centerXPos,centerYPos的equalTo设置NSNumber类型的值时的简化版本。
 比如：
 v.myLeft = 10    <==>   v.leftPos.equalTo(@10)
 v.myRight = 20   <==>   v.rightPos.equalTo(@20)
 v.myCenterX = 0  <==>   v.centerXPos.equalTo(@0)


 这八个属性的值最好别用于读取，而只是单纯用于设置
 
 这要再次区分一下边距和间距和概念，所谓边距是指子视图距离父视图的距离；而间距则是指子视图距离兄弟视图的距离。myLeft,myRight,myTop,myBottom这几个子视图的扩展属性即可用来表示边距也可以用来表示间距，这个要根据子视图所归属的父布局视图的类型而确定：
 
 1.垂直线性布局MyLinearLayout中的子视图： myLeft,myRight表示边距，而myTop,myBottom则表示间距。
 2.水平线性布局MyLinearLayout中的子视图： myLeft,myRight表示间距，而myTop,myBottom则表示边距。
 3.表格布局中的子视图：                  myLeft,myRight,myTop,myBottom的定义和线性布局是一致的。
 4.框架布局MyFrameLayout中的子视图：     myLeft,myRight,myTop,myBottom都表示边距。
 5.相对布局MyRelativeLayout中的子视图：  myLeft,myRight,myTop,myBottom都表示边距。
 6.流式布局MyFlowLayout中的子视图：      myLeft,myRight,myTop,myBottom都表示间距。
 7.浮动布局MyFloatLayout中的子视图：     myLeft,myRight,myTop,myBottom都表示间距。
 8.路径布局MyPathLayout中的子视图：      myLeft,myRight,myTop,myBottom即不表示间距也不表示边距，它表示自己中心位置的偏移量。
 9.非布局父视图中的布局子视图：           myLeft,myRight,myTop,myBottom都表示边距。
 10.非布局父视图中的非布局子视图：         myLeft,myRight,myTop,myBottom的设置不会起任何作用，因为MyLayout已经无法控制了。
 
 再次强调的是：
 1. 如果同时设置了左右边距就能决定自己的宽度，同时设置左右间距不能决定自己的宽度！
 2. 如果同时设置了上下边距就能决定自己的高度，同时设置上下间距不能决定自己的高度！
*/



/**
 *视图上边的布局位置, 是topPos.equalTo方法的简化版本
 */
/**
 *Top layout position of the view. Equivalent to topPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myTop;


/**
 *视图头部的布局位置, 是leadingPos.equalTo方法的简化版本
 */
/**
 *Leading layout position of the view. Equivalent to leadingPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myLeading;


/**
 *视图下边的布局位置, 是bottomPos.equalTo方法的简化版本
 */
/**
 *Bottom layout position of the view. Equivalent to bottomPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myBottom;


/**
 *视图尾部的布局位置, 是trailingPos.equalTo方法的简化版本
 */
/**
 *Trailing layout position of the view. Equivalent to trailingPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myTrailing;


/**
 *视图水平中心布局位置, 是centerXPos.equalTo方法的简化版本
 */
/**
 *Horizontal center layout position of the view. Equivalent to centerXPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myCenterX;

/**
 *视图垂直中心布局位置, 是centerYPos.equalTo方法的简化版本
 */
/**
 *Vertical center layout position of the view. Equivalent to centerYPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myCenterY;

/**
 *视图中心布局位置, 是myCenterX,myCenterY方法的简化版本
 */
/**
 *Center layout position of the view. Equivalent to set myCenterX and myCenterY .
 */
@property(nonatomic, assign) IBInspectable CGPoint myCenter;


/**
 *视图左边的布局位置, 是leftPos.equalTo方法的简化版本
 */
/**
 *Left layout position of the view. Equivalent to leftPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myLeft;


/**
 *视图右边的布局位置, 是rightPos.equalTo方法的简化版本
 */
/**
 *Right layout position of the view. Equivalent to rightPos.equalTo(NSNumber).
 */
@property(nonatomic, assign) IBInspectable CGFloat myRight;



/**
 *视图四边的布局位置, 是myLeading,myTop,myTrailing,myBottom的简化版本
 */
/**
 *Boundary layout position of the view. Equivalent to myLeading,myTop,myTrailing,myBottom set to the same number.
 */
@property(nonatomic, assign) IBInspectable CGFloat myMargin;

/**
 *leading and trailing margin of the view to the superview. Equivalent to myLeading,myTrailing set to the same number
 */
@property(nonatomic, assign) IBInspectable CGFloat myHorzMargin;

/**
 *top and bottom margin of the view to the superview. Equivalent to myTop,myBottom set to the same number
 */
@property(nonatomic, assign) IBInspectable CGFloat myVertMargin;



/*
 视图的布局尺寸对象MyLayoutSize,用于设置视图的宽度和高度尺寸。视图可以通过设置frame值来设置自身的尺寸，也可以通过设置widthSize和heightSize来
 设置布局尺寸，通过frame设置的结果会立即生效，而通过widthSize和heightSize设置则会在布局后才生效，如果同时设置了frame值和MyLayoutSize值则MyLayoutSize的设置值优先。
 
 其中的equalTo方法可用于设置布局尺寸的具体值：
 1.如果设置为NSNumber则表示布局尺寸是一个具体的数值。比如widthSize.equalTo(@20)表示视图的宽度设置为20个点。
 2.如果设置为MyLayoutSize则表示布局尺寸依赖于另外一个视图的布局尺寸。比如A.widthSize.equalTo(B.widthSize)表示A的宽度和B的宽度相等
 3.如果设置为NSArray<MyLayoutSize*>则表示视图和数组里面的视图均分布局视图的宽度或者高度。比如A.widthSize.equalTo(@[B.widthSize,C.widthSize])表示视图A,B,C三个视图均分父视图的宽度。
 4.如果设置为nil则表示取消布局尺寸的值的设置。
 
 其中的add方法可以用于设置布局尺寸的增加值，一般只和equalTo设置为MyLayoutSize和NSArray时配合使用。比如A.widthSize.equalTo(B.widthSize).add(20)表示视图A的宽度等于视图B的宽度再加上20个点。
 
 其中的multiply方法可用于设置布局尺寸放大的倍数值。比如A.widthSize.equalTo(B.widthSize).multiply(2)表示视图A的宽度是视图B的宽度的2倍。
 
 其中的min,max表示用来设置布局尺寸的最大最小值。比如A.widthSize.min(10).max(40)表示宽度的最小是10最大是40。
 
 下面的表格描述了在各种布局下的子视图的布局尺寸对象的equalTo方法可以设置的值。
 为了表示方便我们把：
     线性布局简写为L、垂直线性布局简写为L-V、水平线性布局简写为L-H 相对布局简写为R、表格布局简写为T、框架布局简写为FR、
     流式布局简写为FL、垂直流式布局简写为FL-V，水平流式布局简写为FL-H、浮动布局简写为FO、左右浮动布局简写为FO-V、上下浮动布局简写为FO-H、
     路径布局简写为P、全部简写为ALL，不支持为-，
 
 定义A为操作的视图本身，B为A的兄弟视图，P为A的父视图。
 +-------------+----------+--------------+---------------+------------+--------------+---------------+--------------+----------------------+
 | 对象 \ 值    | NSNumber |A.widthSize   |A.heightSize   |B.widthSize | B.heightSize |	P.widthSize  |P.heightSize  |NSArray<MyLayoutSize*>|
 +-------------+----------+--------------+---------------+------------+--------------+---------------+--------------+----------------------+
 |A.widthSize  | ALL	  |ALL	         |FR/R/FL-H/FO/LH|FR/R/FO/P	  | R	         |L/FR/R/FL/FO/P | R	        |R                     |
 +-------------+----------+--------------+---------------+------------+--------------+---------------+--------------+----------------------+
 |A.heightSize | ALL	  |FR/R/FL-V/FO/L|ALL            |R	          |FR/R/FO/P     |R              |L/FR/R/FL/FO/P|R                     |
 +-------------+----------+--------------+---------------+------------+--------------+---------------+--------------+----------------------+

  上表中所有的布局尺寸的值都支持设置为数值，而且所有布局下的子视图的宽度和高度尺寸都可以设置为等于自身的宽度和高度尺寸，布局库这里做了特殊处理，是不会造成循环引用的。比如：
    A.widthSize.equalTo(A.widthSize)，支持这种设置的原因是有时候比如希望某个UILabel的宽度是在其本身内容宽度的基础上再添加一个增加值，这时候就可以设置如下：
    A.widthSize.equalTo(A.widthSize).add(30);
    表示视图A的宽度总是视图内容的宽度+30，这样即使视图调用了sizeToFit方法来计算出包裹内容的宽度，但是最终的布局宽度还是会再增加30个点。
 
 */
/**
 the MyLayoutSize is layout dimension object object of the UIView. used to set the width and height of the View which is in Layout View
 */



/**
 *视图的宽度布局尺寸对象，可以通过其中的euqalTo方法来设置NSNumber,MyLayoutSize,NSArray<MyLayoutSize*>,nil这四种值
 */
@property(nonatomic, readonly)  MyLayoutSize *widthSize;

/**
 *视图的高度布局尺寸对象，可以通过其中的euqalTo方法来设置NSNumber,MyLayoutSize,NSArray<MyLayoutSize*>,nil这四种值
 */
@property(nonatomic, readonly)  MyLayoutSize *heightSize;



/*
 下面三个属性是上面widthSize,heightSize的equalTo设置NSNumber类型值的简化版本,表示设置视图的高度和宽度的布局尺寸。
 需要注意的是设置这三个值并不是直接设置frame里面的size的宽度和高度，而是设置的是布局尺寸的数值
 
 v.myWidth = 10    <=>   v.widthSize.equalTo(@10)
 v.myHeight = 20   <=>   v.heightSize.equalTo(@10)
 
 这三个属性的值最好别用于读取，而只是单纯用于设置
 */

/**
 *视图的宽度布局尺寸,是widthSize.equalTo方法的简化版本
 */
@property(nonatomic,assign) IBInspectable CGFloat myWidth;

/**
 *视图的高度布局尺寸,是heightSize.equalTo方法的简化版本
 */
@property(nonatomic,assign) IBInspectable CGFloat myHeight;

/**
 *视图的宽度高度布局尺寸,是myWidth,myHeight方法的简化版本
 */
@property(nonatomic,assign) IBInspectable  CGSize  mySize;



/**
 *视图的宽度包裹属性，表示视图的宽度由所有子视图的整体宽度来确定或者根据视图内容来宽度自适应。默认值是NO(水平线性布局默认这个属性是YES)，表示必须要明确指定视图的宽度，而当设置为YES时则不需要明确的指定视图的宽度了。这个属性不能和widthSize(或者设置了左右边距)同时设置否则可能会产生约束冲突，因为前者表明宽度由子视图或者内容来决定而后者则表示宽度是一个明确的值。如果同时设置了宽度包裹属性又同时设置了明确的宽度则系统会出现约束冲突告警，虽然如此，系统在布局时做了一些优化，如果同时设置了明确的宽度和宽度包裹则会在布局前将宽度包裹属性置为NO。
 */
@property(nonatomic,assign) IBInspectable BOOL wrapContentWidth;

/**
 *视图的高度包裹属性，表示视图的高度由所有子视图的整体高度来确定或者根据视图内容来高度自适应。默认值是NO(垂直线性布局默认这个属性是YES)，表示必须要明确指定布局的高度，而当设置为YES时则不需要明确的指定视图的高度了。这个属性不能和heightSize(或者设置了上下边距)同时设置否则可能会产生约束冲突，因为前者表明高度由子视图或者内容来决定而后者则表示高度是一个明确的值。如果同时设置了高度包裹属性又同时设置了明确的高度则系统会出现约束冲突告警，虽然如此，系统在布局时做了一些优化，如果同时设置了明确的高度和高度包裹则会在布局前将高度包裹属性置为NO。如果某个非布局视图指定了明确的宽度，而又将这个属性设置为了YES的话就能实现在固定宽度的情况下视图的高度根据内容自适应的效果，这个特性主要用于UILabel,UITextView以及实现了sizeThatFits方法的视图来实现高度根据内容自适应的场景。UILabel在使用这个属性时会自动设置numberOfLines为0，因此如果您要修改numberOfLines则需要在设置这个属性后进行；UITextView可以用这个属性以及heightSize中的max方法来实现到达指定的高度后若继续输入则产生滚动的效果；UIImageView可以用这个属性来在实现在确定宽度的情况下高度根据宽度的缩放情况进行等比例的缩放。
 */
@property(nonatomic,assign) IBInspectable BOOL wrapContentHeight;


/**
 *视图的尺寸根据内容来决定，也就是视图的尺寸由内容包裹。这个属性是: A.wrapContentWidth = YES; A.wrapContentHeight = YES;的简化版本。
 *在历史版本中对UILabel进行text赋值后总要手动调用sizeToFit来重新更新布局，在1.3.6以后的新版本中，如果你希望视图的尺寸根据内容而确定则请将这个属性
 *设置为YES。这样就可以在设置完毕text后系统会自动激发布局处理。
 */
@property(nonatomic, assign) IBInspectable BOOL wrapContentSize;


/**
 设置子视图的相对比重尺寸。也就是子视图的尺寸并不是一个绝对值而是一个相对值，在最终布局时系统会根据布局视图的剩余尺寸来将这个相对的值转化为绝对的值。通过对子视图设置相对的尺寸可以很方便的适配各种屏幕尺寸的设备，以便达到完美的布局效果。这个属性默认值是0表示不使用相对尺寸。weight属性的引入是参考android中的weight的概念而来的。
 
 目前只有在线性布局、表格布局、流式布局、浮动布局下的子视图设置weight才有效，相对布局、框架布局、路径布局里面的子视图不支持weight属性的设置。
 在不同的布局下的子视图的weight属性所表达的意义也有所差异：
 
 @note
 1.在线性布局和表格布局下：

    1.1. 当线性布局是垂直线性布局时这个属性用来设置子视图高度占用父线性布局剩余高度的比重，这样子视图就不需要明确的设定高度值。
 
    1.2. 当线性布局是水平线性布局时这个属性用来设置子视图宽度占用父线性布局剩余宽度的比重，这样子视图就不需要明确的设定宽度值。
 
    @code
    视图的真实尺寸值 = 布局视图剩余尺寸 * 当前视图的weight比重/(布局视图内所有设置了weight比重值的子视图比重之和)。
    @endcode
 
    对一个垂直线性布局举例来说：假设布局视图的高度是100，A子视图占据了20的固定高度，B子视图的weight设置为0.4，C子视图的weight设置为0.6 那么:
    @code
    A子视图的高度 = 20
    B子视图的高度 = (100-20)*0.4/(0.4+0.6) = 32
    C子视图的高度 = (100-20)*0.6/(0.4+0.6) = 48
    @endcode
 
 子视图设置weight属性时要注意如下几点：
 
    - 垂直线性布局必须指定明确的高度，而不能使用wrapContentHeight属性；水平线性布局必须指定明确的宽度，而不能使用wrapContentWidth属性。
 
    - 如果比重属性设置为0的话则表示视图的尺寸必须要明确的被指定，这也是默认值。
 
    - 线性布局里面的所有子视图的比重值的和不一定要求是1，比如线性布局里面两个视图的比重都设置为1和都设置为0.5以及都设置为0.1的意义是一样的，都是占用50%。

 @note
 2.在流式布局下：
 
    2.1. 当流式布局是垂直流式布局时这个属性用来设置子视图宽度占用父流式布局当前行的剩余宽度的比重，这样子视图就不需要明确的设定宽度值。
    
    2.2. 当流式布局是水平流式布局时这个属性用来设置子视图高度占用父流式布局当前列的剩余高度的比重，这样子视图就不需要明确的设定高度值。
 
    同时在数量约束和内容约束两种布局中视图设置的比重值在最终计算出真实尺寸时也是有差异的：
 
    @code
    数量约束流式布局内的视图的真实尺寸值 = 布局视图剩余尺寸 * 当前视图的weight比重/(视图所在行的所有设置了weight比重值的视图比重之和)。
 
    内容约束流式布局内的视图的真实尺寸值 = 布局视图剩余尺寸 * 当前视图的weight比重。
 
    对一个垂直数量约束流式布局举例来说：假设布局视图的宽度是100，A子视图占据了20的固定宽度，B子视图的weight设置为0.4，C子视图的weight设置为0.6 那么:
    A子视图的宽度 = 20
    B子视图的宽度 = (100-20)*0.4/(0.4+0.6) = 32
    C子视图的宽度 = (100-20)*0.6/(0.4+0.6) = 48
 
    对一个垂直内容约束流式布局举例来说：假设布局视图的宽度是100，A子视图占据了20的固定宽度，B子视图的weight设置为0.4，C子视图的weight设置为0.6 那么：
    A子视图的宽度 = 20
    B子视图的宽度 = (100-20)*0.4 = 32
    C子视图的宽度 = (100-20-32)*0.6 = 28.8
 @endcode
 

 @note
 3. 在浮动布局下：
 
    3.1. 当浮动布局的方向是垂直布局时，这个属性用来设置视图宽度占用当前浮动布局父视图剩余宽度的比重，这样视图就不需要明确的设定宽度值。
  
    3.2. 当浮动布局的方向是水平布局时，这个属性用来设置视图高度占用当前浮动布局父视图剩余高度的比重，这样子视图就不需要明确的设定高度值。
 
  @code
 视图的真实尺寸 = 布局父视图的剩余尺寸 * 视图的weight比重值。
  @endcode
 
 举例来说：假设一个垂直浮动布局视图的宽度是100，A子视图占据了20的固定宽度，B子视图的weight设置为0.4，C子视图的weight设置为0.6 那么：
 
 @code
 A子视图的宽度 = 20
 B子视图的宽度 = (100-20)*0.4 = 32
 C子视图的宽度 = (100-20-32)*0.6 = 28.8
 @endcode
 
 */
@property(nonatomic, assign) IBInspectable CGFloat weight;



/**
 设置视图不受布局父视图的布局约束控制和不再参与视图的布局，所有设置的其他扩展属性都将失效而必须用frame来设置视图的位置和尺寸，默认值是NO。这个属性主要用于某些视图希望在布局视图中进行特殊处理和进行自定义的设置的场景。比如一个垂直线性布局下有A,B,C三个子视图设置如下：

 @code
 A.mySize = CGSizeMake(100,100);
 B.mySize = CGSizeMake(100,50);
 C.mySize = CGSizeMake(100,200);
 B.frame = CGRectMake(20,20,200,100);
 
 正常情况下当布局完成后:
 A.frame == {0,0,100,100}
 B.frame == {0,100,100,50}  //可以看出即使B设置了frame值，但是因为布局约束属性优先级高所以对B设置的frame值是无效的。
 C.frame == {0,150,100,200}
 
 而当我们设置如下时：
 A.mySize = CGSizeMake(100,100);
 B.mySize = CGSizeMake(100,50);
 C.mySize = CGSizeMake(100,200);
 B.frame = CGRectMake(20,20,200,100);
 B.useFrame = YES;

 那么在布局完成后：
 A.frame == {0, 0, 100, 100}
 B.frame == {20,20,200,100}   //可以看出B并没有受到约束的限制，结果就是B设置的frame值。
 C.frame == {0, 100,100,200}  //因为B不再参与布局了，所以C就往上移动了，由原来的150变为了100.
 
 @endcode 
 
 @note
 useFrame的应用场景是某个视图虽然是布局视图的子视图但不想受到父布局视图的约束，而是可以通过frame进行自由位置和尺寸调整的场景。

 */
@property(nonatomic, assign) IBInspectable BOOL useFrame;


/**
 设置视图在进行布局时只会参与布局但不会真实的调整位置和尺寸，默认值是NO。当设置为YES时会在布局时保留出视图的布局位置和布局尺寸的空间，但不会更新视图的位置和尺寸，也就是说只会占位但不会更新。因此你可以通过frame值来进行位置和尺寸的任意设置，而不会受到你的布局视图的影响。这个属性主要用于某些视图希望在布局视图中进行特殊处理和进行自定义的设置的场景。比如一个垂直线性布局下有A,B,C三个子视图设置如下：

 @code
 A.mySize = CGSizeMake(100,100);
 B.mySize = CGSizeMake(100,50);
 C.mySize = CGSizeMake(100,200);
 B.frame = CGRectMake(20,20,200,100);
 
 正常情况下当布局完成后:
 A.frame == {0,0,100,100}
 B.frame == {0,100,100,50}  //可以看出即使B设置了frame值，但是因为布局约束属性优先级高所以对B设置的frame值是无效的。
 C.frame == {0,150,100,200}
 
 而当我们设置如下时：
 A.mySize = CGSizeMake(100,100);
 B.mySize = CGSizeMake(100,50);
 C.mySize = CGSizeMake(100,200);
 B.frame = CGRectMake(20,20,200,100);
 B.noLayout = YES;
 
 那么在布局完成后：
 A.frame == {0,0,100,100}
 B.frame == {20,20,200,100}  //可以看出虽然B参与了布局，但是并没有更新B的frame值，而是保持为通过frame设置的原始值。
 C.frame == {0,150,100,200}  //因为B参与了布局，占用了50的高度，所以这里C的位置还是150，而不是100.
@endcode

 @note
 useFrame和noLayout的区别是：
  
 1.前者不会参与布局而必须要通过frame值进行设置，而后者则会参与布局但是不会将布局的结果更新到frame中。
 
 2.当前者设置为YES时后者的设置将无效，而后者的设置并不会影响前者的设置。
 
 
 @note
 noLayout的应用场景是那些想在运行时动态调整某个视图的位置和尺寸，但是又不想破坏布局视图中其他子视图的布局结构的场景，也就是调整了视图的位置和尺寸，但是不会调整其他的兄弟子视图的位置和尺寸。
 
*/
@property(nonatomic, assign) IBInspectable BOOL noLayout;


/**
 指定视图的可见性，默认是visible。这个属性是对视图hidden属性的扩展，布局系统对视图的hidden属性设置后，视图将不再参与布局。但在实际中有些场景我们希望视图隐藏后
 仍然会占用空间仍然会参与布局。因此我们可以用这个属性来设置当视图隐藏后是否继续参与布局。
 如果您使用了这个属性来对视图进行隐藏和取消隐藏操作则请不要再去操作hidden属性，否则可能出现二者效果不一致的情况。因此建议视图的隐藏和显示用这个属性进行设置。
 在老版本中布局中的子视图隐藏时要么都参与布局，要么都不参与布局，这是通过布局属性hideSubviewReLayout来设置，新版本中这个属性将会设置为无效了！
 
 属性可以设置的值如下：
 
  1. MyVisibility_Visible     视图可见，等价于hidden = NO
 
  2. MyVisibility_Invisible   视图不可见，等价于hidden = YES, 但是会在父布局视图中占位空白区域
 
  3. MyVisibility_Gone        视图不可见，等价于hidden = YES, 但是不会在父视图中占位空白区域
 
 
 @note
   建议您用这个属性设置视图的隐藏的显示而不用系统默认的hidden来进行设置。
 
 */
@property(nonatomic, assign) MyVisibility  myVisibility;


/**
 指定子在布局视图上的对齐方式，默认是None表示未指定，这个属性目前只支持框架布局，线性布局，流式布局下的属性设置。
 
 1. 在框架布局中支持上、中、下、垂直拉伸和左、中、右、水平拉伸8个设置
 
 2. 在垂直线性布局中只支持左、中、右、水平拉伸对齐。(如果父布局视图设置了gravity，子视图设置了这个属性则这个属性优先级最高)
 
 3. 在水平线性布局中只支持上、中、下、垂直拉伸对齐。(如果父布局视图设置了gravity，子视图设置了这个属性则这个属性优先级最高)
 
 4. 在垂直流式布局中用来设置一行内的上、中、下、垂直拉伸对齐。(如果父布局视图设置了arrangedGravity，子视图设置了这个属性则这个属性优先级最高)
 
 5. 在水平流式布局中用来设置一列内的左、中、右、水平拉伸对齐。(如果父布局视图设置了arrangedGravity，子视图时设置了这个属性则这个属性优先级最高)
 */
@property(nonatomic, assign) MyGravity myAlignment;



/**
 视图在父布局视图中布局完成后也就是视图的frame更新完成后执行的block，执行完block后会被重置为nil。通过在viewLayoutCompleteBlock中我们可以得到这个视图真实的frame值,当然您也可以在里面进行其他业务逻辑的操作和属性的获取和更新。block方法中layout参数就是父布局视图，而v就是视图本身，block中这两个参数目的是为了防止循环引用的问题。
 */
@property(nonatomic,copy) void (^viewLayoutCompleteBlock)(MyBaseLayout* layout, UIView *v);


/**
 视图的在父布局视图调用完评估尺寸的方法后，可以通过这个方法来获取评估的CGRect值。评估的CGRect值是在布局前评估计算的值，而frame则是视图真正完成布局后的真实的CGRect值。在调用这个方法前请先调用父布局视图的-(CGRect)estimateLayoutRect方法进行布局视图的尺寸评估，否则此方法返回的值未可知。这个方法主要用于在视图布局前而想得到其在父布局视图中的位置和尺寸的场景。
 
 @return 返回被子视图的评估的CGRect值。
 */
-(CGRect)estimatedRect;


/**
 *清除视图所有为布局而设置的扩展属性值。如果是布局视图调用这个方法则同时会清除布局视图中所有关于布局设置的属性值。
 */
-(void)resetMyLayoutSetting;
-(void)resetMyLayoutSettingInSizeClass:(MySizeClass)sizeClass;


/**
  获取视图在某个Size Classes下的MyLayoutSizeClass对象。视图可以通过得到的MyLayoutSizeClass对象来设置视图在对应Size Classes下的各种布局约束属性。
 
 @param sizeClass 指定获取某种SizeClass
 @return 返回指定的SizeClass
 */
-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass;


/**
  获取视图在某个Size Classes下的MyLayoutSizeClass对象，如果对象不存在则会新建立一个MyLayoutSizeClass对象，并且其布局约束属性都拷贝自srcSizeClass中的属性，如果对象已经存在则srcSizeClass不起作用，如果srcSizeClass本来就不存在则也不会起作用。
 @param sizeClass 指定获取某个SizeClass
 @param srcSizeClass 指定从哪种SizeClass中拷贝
 @return 返回指定的SizeClass
 */
-(instancetype)fetchLayoutSizeClass:(MySizeClass)sizeClass copyFrom:(MySizeClass)srcSizeClass;


@end


@interface UIView(MyLayoutExtDeprecated)

/**
 * 过期的位置和尺寸设置方法，老版本中带Margin后缀就明确为了边距的概念，但是这个和属性定义的概念是不一致的，位置即可表示边距也可以表示间距。所以这些方法将设置为过期。您可以在相应的位置定义宏：#define MY_USEOLDMETHODNOWARNING = 1 则不会出现老方法告警，不过不建议这么做。
 */


/**
 *过期属性,请用myLeft
 */
@property(nonatomic, assign)  CGFloat myLeftMargin MYMETHODDEPRECATED("use myLeft to instead");

/**
 *过期属性,请用myTop
 */
@property(nonatomic, assign)  CGFloat myTopMargin MYMETHODDEPRECATED("use myTop to instead");

/**
 *过期属性,请用myRight
 */
@property(nonatomic, assign)  CGFloat myRightMargin MYMETHODDEPRECATED("use myRight to instead");

/**
 *过期属性,请用myBottom
 */
@property(nonatomic, assign)  CGFloat myBottomMargin MYMETHODDEPRECATED("use myBottom to instead");

/**
 *过期属性,请用myCenterX
 */
@property(nonatomic, assign)  CGFloat myCenterXOffset MYMETHODDEPRECATED("use myCenterX to instead");

/**
 *过期属性,请用myCenterY
 */
@property(nonatomic, assign)  CGFloat myCenterYOffset MYMETHODDEPRECATED("use myCenterY to instead");

/**
 *过期属性,请用myCenter
 */
@property(nonatomic, assign)  CGPoint myCenterOffset MYMETHODDEPRECATED("use myCenter to instead");

/**
 *过期属性,请用widthSize
 */
@property(nonatomic, readonly) MyLayoutSize *widthDime MYMETHODDEPRECATED("use widthSize to instead");

/**
 *过期属性,请用heightSize
 */
@property(nonatomic, readonly) MyLayoutSize *heightDime MYMETHODDEPRECATED("use heightSize to instead");


/**
 *过期属性,请用wrapContentHeight
 */
@property(nonatomic, assign, getter=isFlexedHeight)  BOOL flexedHeight MYMETHODDEPRECATED("use wrapContentHeight to instead");



@end



/**
 *布局的边界画线类，用于实现绘制布局的四周的边界线的功能。一个布局视图中提供了上下左右4个方向的边界画线类对象。
 */
@interface MyBorderline : NSObject


/**
 *边界线的颜色
 */
@property(nonatomic,strong) UIColor *color;

/**
 *边界线的厚度，默认是1,设置的值不能小于1. 单位是像素。
 */
@property(nonatomic,assign) CGFloat thick;

/**
 *边界线的头部缩进单位。比如某个布局视图宽度是100，头部缩进单位是20，那么边界线将从20的位置开始绘制。
 */
@property(nonatomic,assign) CGFloat headIndent;

/**
 *边界线的尾部缩进单位。比如某个布局视图宽度是100，尾部缩进单位是20，那么边界线将绘制到80的位置结束。
 */
@property(nonatomic, assign) CGFloat tailIndent;

/**
 *设置边界线为点划线,如果是0则边界线是实线
 */
@property(nonatomic, assign) CGFloat dash;

/**
 *边界线绘制时的偏移量
 */
@property(nonatomic, assign) CGFloat offset;

-(id)initWithColor:(UIColor*)color;


@end

//兼容老版本的类名命名不规则的问题，这样老版本仍然可以用MyBorderLineDraw这个类名。
typedef MyBorderline MyBorderLineDraw MYMETHODDEPRECATED("use MyBorderline to instead");


/**
 布局视图基类，基类不支持实例化对象。在编程时我们经常会用到一些视图，这种视图只是负责将里面的子视图按照某种规则进行排列和布局，而别无其他的作用。因此我们称这种视图为容器视图或者称为布局视图。
 布局视图通过重载layoutSubviews方法来完成子视图的布局和排列的工作。对于每个加入到布局视图中的子视图，都会在加入时通过KVO机制监控子视图的center和bounds以及frame值的变化，每当子视图的这些属性一变化时就又会重新引发布局视图的布局动作。同时对每个视图的布局扩展属性的设置以及对布局视图的布局属性的设置都会引发布局视图的布局动作。布局视图在添加到非布局父视图时也会通过KVO机制来监控非布局父视图的frame值和bounds值，这样每当非布局父视图的尺寸变更时也会引发布局视图的布局动作。前面说的引起变动的方法就是会在KVO处理逻辑以及布局扩展属性和布局属性设置完毕后通过调用setNeedLayout来实现的，当布局视图收到setNeedLayout的请求后，会在下一个runloop中对布局视图进行重新布局而这就是通过调用layoutSubviews方法来实现的。布局视图基类只提供了更新所有子视图的位置和尺寸以及一些基础的设置，而至于如何排列和布局这些子视图则要根据应用的场景和需求来确定，因此布局基类视图提供了一个：
   -(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
     的方法，要求派生类去重载这个方法，这样不同的派生类就可以实现不同的应用场景，这就是布局视图的核心实现机制。
 
 MyLayout布局库根据实际中常见的场景实现了7种不同的布局视图派生类他们分别是：线性布局、表格布局、相对布局、框架布局、流式布局、浮动布局、路径布局。
 */
@interface MyBaseLayout : UIView

#if UIKIT_DEFINE_AS_PROPERTIES

/**
  用于实现对阿拉伯国家的布局适配。对于非阿拉伯国家来说，界面布局都是默认从左到右排列。而对于阿拉伯国家来说界面布局则默认是从右往左排列。默认这个属性是NO，您可以将这个属性设置为YES，这样布局里面的所有视图都将从右到左进行排列布局。如果您需要考虑国际化布局的问题，那么您应该用leadingPos来表示头部的位置，而用trailingPos来表示尾部的位置，这样当布局方向是LTR时那么leadingPos就表示的是左边而trailingPos则表示的是右边；而当布局方向是RTL时那么leadingPos表示的是右边而trailingPos则表示的是左边。如果您的界面布局不会考虑到国际化以及不需要考虑RTL时那么您可以用leftPos和rightPos来表示左右而不需要用leadingPos和trailingPos。
 */
@property(class, nonatomic, assign) BOOL isRTL;
#else
+(BOOL)isRTL;
+(void)setIsRTL:(BOOL)isRTL;
#endif

/*
 布局视图里面的padding属性用来设置布局视图的内边距。内边距是指布局视图里面的子视图离自己距离。外边距则是视图与父视图之间的距离。
 内边距是在自己的尺寸内离子视图的距离，而外边距则不是自己尺寸内离其他视图的距离。下面是内边距和外边距的效果图：
 
                    ^
                    | topMargin
                    |           width
                +------------------------------+
                |                              |------------>
                |  l                       r   | rightMargin
                |  e       topPadding      i   |
                |  f                       g   |
                |  t   +---------------+   h   |
     <----------|  P   |               |   t   |
      leftMargin|  a   |               |   P   |
                |  d   |   subviews    |   a   |  height
                |  d   |    content    |   d   |
                |  i   |               |   d   |
                |  n   |               |   i   |
                |  g   +---------------+   n   |
                |                          g   |
                |        bottomPadding         |
                +------------------------------+
                    |bottomMargin
                    |
                    V
 
 
 如果一个布局视图中的每个子视图都离自己有一定的距离就可以通过设置布局视图的内边距来实现，而不需要为每个子视图都设置外边距。
 
 */

/**
 * 设置布局视图四周的内边距值。所谓内边距是指布局视图内的所有子视图离布局视图四周的边距。通过为布局视图设置内边距可以减少为所有子视图设置外边距的工作，而外边距则是指视图离父视图四周的距离。
 */
@property(nonatomic,assign) UIEdgeInsets padding;

/**
 * 顶部内边距，用来设置子视图离自身顶部的边距值。
 */
@property(nonatomic, assign) IBInspectable CGFloat topPadding;
/**
 *头部内边距，用来设置子视图离自身头部的边距值。对于LTR方向的布局来说就是指的左边内边距，而对于RTL方向的布局来说就是指的右边内边距
 */
@property(nonatomic, assign) IBInspectable CGFloat leadingPadding;
/**
 *底部内边距，用来设置子视图离自身底部的边距值。
 */
@property(nonatomic, assign) IBInspectable CGFloat bottomPadding;
/**
 *尾部内边距，用来设置子视图离自身尾部的边距值。对于LTR方向的布局来说就是指的右边内边距，而对于RTL方向的布局来说就是指的左边内边距
 */
@property(nonatomic, assign) IBInspectable CGFloat trailingPadding;

/**
 *左边内边距，用来设置子视图离自身左边的边距值。如果您不需要考虑布局的方向，那么请用这个属性来设置左边的内部边距，如果您需要考虑国际化则请用leadingPadding
 */
@property(nonatomic, assign) IBInspectable CGFloat leftPadding;

/**
 *右边内边距，用来设置子视图离自身右边的边距值。如果您不需要考虑布局的方向，那么请用这个属性来设置右边的内部边距，如果您需要考虑国际化则请用trailingPadding
 */
@property(nonatomic, assign) IBInspectable CGFloat rightPadding;


/**
 * 设置当布局的尺寸由子视图决定并且在没有子视图加入的情况下padding的设置值是否会加入到布局的尺寸值里面。默认是YES，表示当布局视图没有子视图时padding值也会加入到尺寸里面。
 * 举例来说假设某个布局视图的高度是wrapContentHeight,并且设置了topPadding为10，bottomPadding为20。那么默认情况下当没有任何子视图时布局视图的高度是30；而当我们将这个属性设置为NO时，那么在没有任何子视图时布局视图的高度就是0，也就是说topPadding和bottomPadding不会参与高度的计算了。
 */
@property(nonatomic, assign) BOOL zeroPadding;


/**
 *设置布局视图里面子视图之间的垂直间距。如果布局内每个子视图的垂直间距都相等则可以用这个属性来设置。这个属性不支持框架布局、相对布局、路径布局。
 */
@property(nonatomic ,assign) IBInspectable CGFloat subviewVSpace;
/**
 *设置布局视图里面子视图之间的水平间距。如果布局内每个子视图的水平间距都相等则可以用这个属性来设置。这个属性不支持框架布局、相对布局、路径布局。
 */
@property(nonatomic, assign) IBInspectable CGFloat subviewHSpace;
/**
 *设置布局视图里面子视图之间的间距。如果布局内每个子视图的间距都相等则可以用这个属性来设置。这个属性不支持框架布局、相对布局、路径布局。
 */
@property(nonatomic, assign) IBInspectable CGFloat subviewSpace;


/**
 布局里面的所有子视图的整体停靠方向以及填充，所谓停靠是指布局视图里面的所有子视图整体在布局视图中的位置，系统默认的停靠是在布局视图的左上角。
 
 @note
 只有框架布局、线性布局、表格布局、流式布局、浮动布局支持gravity属性，相对布局和路径布局不支持。
 
 1. MyGravity_Vert_Top,MyGravity_Vert_Center,MyGravity_Vert_Bottom 表示整体垂直居上，居中，居下 (支持：框架布局,线性布局,表格布局,流式布局,垂直浮动布局)
 
 2. MyGravity_Horz_Left,MyGravity_Horz_Center,MyGravity_Horz_Right 表示整体水平居左，居中，居右 (支持：框架布局,线性布局,表格布局,流式布局,水平浮动布局)
 
 3. MyGravity_Vert_Between 表示每行之间的行间距都被拉伸，以便使里面的子视图垂直方向填充满整个布局视图。 (支持：垂直线性布局,垂直表格布局，流式布局)
 
 4. MyGravity_Horz_Between 表示每列之间的列间距都被拉伸，以便使里面的子视图水平方向填充满整个布局视图。 (支持：水平线性布局,水平表格布局，流式布局)
 
 5. MyGravity_Vert_Fill 表示布局会拉伸子视图的高度，以便使里面的子视图垂直方向填充满整个布局视图的高度或者子视图平分布局视图的高度。(支持：框架布局，水平线性布局，水平表格布局，流式布局)
 
 6. MyGravity_Horz_Fill 表示布局会拉伸子视图的宽度，以便使里面的子视图水平方向填充满整个布局视图的宽度或者子视图平分布局视图的宽度。 (支持：框架布局，垂直线性布局，垂直表格布局，流式布局)
 */
@property(nonatomic, assign) IBInspectable MyGravity gravity;


/**
 *设置是否布局里面的所有子视图按添加的顺序逆序进行布局。默认是NO，表示按子视图添加的顺序排列。比如一个垂直线性布局依次添加A,B,C三个子视图，那么在正常布局时A,B,C从上到下依次排列，而当这个属性设置为YES时，则布局时就会变成按C,B,A依次从上到下排列。这个属性的设置对框架布局和相对布局无效。
 */
@property(nonatomic, assign)  BOOL reverseLayout;


/**
 *把一个布局视图放入到UIScrollView(UITableView和UICollectionView除外)内时是否自动调整UIScrollView的contentSize值。默认是MyAdjustScrollViewContentSizeModeAuto表示布局视图会自动接管UIScrollView的contentSize的值。 你可以将这个属性设置MyAdjustScrollViewContentSizeModeNo而不调整和控制contentSize的值，设置为MyAdjustScrollViewContentSizeModeYes则一定会调整contentSize.
 */
@property(nonatomic, assign) MyAdjustScrollViewContentSizeMode adjustScrollViewContentSizeMode;


/**
 *在布局视图进行布局时是否调用基类的layoutSubviews方法，默认设置为NO。
 */
@property(nonatomic, assign) BOOL priorAutoresizingMask;




/**
 *设置布局视图在布局开始之前的处理块。系统会在每次布局完成前调用对应的处理块后将处理块清空为nil。系统会在调用layoutSubviews方法前执行beginLayoutBlock。
 */
@property(nonatomic,copy) void (^beginLayoutBlock)();
/**
 *设置布局视图在布局完成之后的处理块。系统会在每次布局完成后调用对应的处理块后将处理块清空为nil。您也可以在endLayoutBlock块内取到所有子视图真实布局后的frame值。系统会在调用layoutSubviews方法后执行endLayoutBlock。
 */
@property(nonatomic,copy) void (^endLayoutBlock)();


/**
 *设置布局时的动画。并指定时间。这个函数是下面方法的简单实现：
 
 @code
  self.beginLayoutBlock = ^{
 
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:duration];
 };
 
 self.endLayoutBlock = ^{
 
 [UIView commitAnimations];
 };

@endcode
 
 @param duration 指定动画的时间间隔
 */
-(void)layoutAnimationWithDuration:(NSTimeInterval)duration;


/**
 设置布局视图在第一次布局完成之后或者有横竖屏切换时进行处理的block。这个block不像beginLayoutBlock以及endLayoutBlock那样只会执行一次,而是会一直存在
 因此需要注意代码块里面的循环引用的问题。这个block调用的时机是第一次布局完成或者每次横竖屏切换时布局完成被调用。
 这个方法会在endLayoutBlock后调用。
 
 layout 参数就是布局视图本身。
 
 isFirst 表明当前是否是第一次布局时调用。
 
 isPortrait 表明当前是横屏还是竖屏。
 */
@property(nonatomic,copy) void (^rotationToDeviceOrientationBlock)(MyBaseLayout *layout, BOOL isFirst, BOOL isPortrait);


/**
 *判断当前是否正在布局中,如果正在布局中则返回YES,否则返回NO
 */
@property(nonatomic,assign,readonly) BOOL isMyLayouting;


/**
 *设置布局视图的四周的边界线对象。boundBorderLine是同时设置四周的边界线。您也可以单独设置布局视图某些边的边界线。边界线对象默认是nil，您必须通过建立边界线类MyBorderline的对象实例并赋值给下面的属性来实现边界线的指定。
 */

/**顶部边界线*/
@property(nonatomic, strong) MyBorderline *topBorderline;
/**头部边界线*/
@property(nonatomic, strong) MyBorderline *leadingBorderline;
/**底部边界线*/
@property(nonatomic, strong) MyBorderline *bottomBorderline;
/**尾部边界线*/
@property(nonatomic, strong) MyBorderline *trailingBorderline;
/**四周边界线*/
@property(nonatomic, strong) MyBorderline *boundBorderline;

/**
 *如果您不需要考虑国际化的问题则请用这个属性设置左边边界线，否则用leadingBorderline
 */
@property(nonatomic, strong) MyBorderline *leftBorderline;
/**
 *如果您不需要考虑国际化的问题则请用这个属性设置右边边界线，否则用trailingBorderline
 */
@property(nonatomic, strong) MyBorderline *rightBorderline;


/**
 *智能边界线，智能边界线不是设置布局自身的边界线而是对添加到布局视图里面的子布局视图根据子视图之间的关系智能的生成边界线，对于布局视图里面的非布局子视图则不会生成边界线。目前的版本只支持线性布局，表格布局，流式布局和浮动布局这四种布局。
 *举例来说如果为某个垂直线性布局设置了智能边界线，那么当这垂直线性布局里面添加了A和B两个子布局视图时，系统会智能的在A和B之间绘制一条边界线。
 */
@property(nonatomic, strong) MyBorderline *intelligentBorderline;

/**
 *不使用父布局视图提供的智能边界线功能。当某个布局视图的父布局视图设置了intelligentBorderline时但是这个布局视图又想自己定义边界线或者不想要边界线时则将这个属性设置为YES即可。
 */
@property(nonatomic, assign) BOOL notUseIntelligentBorderline;



/**
 *在有布局触摸事件时布局按下时背景的高亮的颜色。只有设置了setTarget:action方法此属性才生效。
 */
@property(nonatomic,strong)  UIColor *highlightedBackgroundColor;

/**
 *在有布局触摸事件时布局按下时的高亮不透明度。值的范围是[0,1]，默认是0表示完全不透明，为1表示完全透明。只有设置了setTarget:action方法此属性才生效。
 */
@property(nonatomic,assign)  CGFloat highlightedOpacity;

/**
 *设置布局的背景图片。这个属性的设置就是设置了布局的layer.contents的值，因此如果要实现背景图的局部拉伸请用layer的其他contentsXXX属性进行调整和处理
 */
@property(nonatomic,strong)  UIImage *backgroundImage;

/**
 *在有布局触摸事件时布局按下时的高亮背景图片。只有设置了setTarget:action方法此属性才生效。
 */
@property(nonatomic,strong)  UIImage *highlightedBackgroundImage;

/**
  设置布局的touch up 、touch down、touch cancel事件的处理动作,后两个事件的处理必须依赖于第一个事件的处理。请不要在这些处理动作中修改背景色，不透明度，以及背景图片。如果您只想要高亮效果但是不想处理事件则将action设置为nil即可了。
 @param target 事件的处理对象，如果设置为nil则表示取消事件。
 @param action 事件的处理动作，格式为：-(void)handleAction:(MyBaseLayout*)sender。
 */
-(void)setTarget:(id)target action:(SEL)action;
-(void)setTouchDownTarget:(id)target action:(SEL)action;
-(void)setTouchCancelTarget:(id)target action:(SEL)action;


/**
评估布局视图的尺寸。这个方法并不会让布局视图进行真正的布局，只是对布局的尺寸进行评估，主要用于在布局完成前想预先知道布局尺寸的场景。通过对布局进行尺寸的评估，可以在不进行布局的情况下动态的计算出布局的位置和大小，但需要注意的是这个评估值有可能不是真实显示的实际位置和尺寸。
 @param size 指定期望的宽度或者高度，如果size中对应的值设置为0则根据布局自身的高度和宽度来进行评估，而设置为非0则固定指定的高度或者宽度来进行评估。比如下面的例子：
  1.estimateLayoutRect:CGSizeMake(0,0) 表示按布局的位置和尺寸根据布局的子视图来进行动态评估。
  2.estimateLayoutRect:CGSizeMake(320,0) 表示布局的宽度固定为320,而高度则根据布局的子视图来进行动态评估。这个情况非常适用于UITableViewCell的动态高度的计算评估。
  3.estimateLayoutRect:CGSizeMake(0,100) 表示布局的高度固定为100,而宽度则根据布局的子视图来进行动态评估。
 @return 返回评估的尺寸。
 */
-(CGRect)estimateLayoutRect:(CGSize)size;
-(CGRect)estimateLayoutRect:(CGSize)size inSizeClass:(MySizeClass)sizeClass;


/**
  是否缓存经过estimateLayoutRect方法评估后的所有子视图的位置和尺寸一次!，默认设置为NO不缓存。当我们用estimateLayoutRect方法评估布局视图的尺寸后，所有子视图都会生成评估的位置和尺寸，因为此时并没有执行布局所以子视图并没有真实的更新frame值。而当布局视图要进行真实布局时又会重新计算所有子视图的位置和尺寸，因此为了优化性能当我们对布局进行评估后在下次真实布局时我们可以不再重新计算子视图的位置和尺寸而是用前面评估的值来设置位置和尺寸。这个属性设置为YES时则每次评估后到下一次布局时不会再重新计算子视图的布局了，而是用评估值来布局子视图的位置和尺寸。而当这个属性设置为NO时则每次布局都会重新计算子视图的位置和布局。
   这个属性一般用在那些动态高度UITableviewCell中进行配合使用，我们一般将布局视图作为UITableviewCell的contentView的子视图:
 
 @code
 MyXXXLayout *rootLayout= [MyXXXLayout new];
 rootLayout.cacheEstimatedRect = YES;   //设置缓存评估的rect,如果您的cell是高度自适应的话，强烈建立打开这个属性，这会大大的增强您的tableview的性能！！
 rootLayout.myHorzMargin = 0;           //宽度和父视图相等
 rootLayout.wrapContentHeight = YES;    //高度动态包裹。
 [self.contentView addSubview:rootLayout];
 self.rootLayout = rootLayout;
  
 //在rootLayout添加子视图。。。
 
 *************************************
 
 然后我们在heightForRowAtIndexPath中按如下格式进行高度的评估的计算。
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     UITableViewCellXXX *cell = (UITableViewCellXXX*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
     CGRect rect = [cell.rootLayout estimateLayoutRect:CGSizeMake(tableView.frame.size.width, 0)];
     return rect.size.height;
 }
 
 @endcode
 */
@property(nonatomic, assign) BOOL cacheEstimatedRect;


/**
 评估计算一个未加入到布局视图中的子视图subview在加入后的frame值。在实践中我们希望得到某个未加入的子视图在添加到布局视图后的应该具有的frame值，这时候就可以用这个方法来获取。比如我们希望把一个子视图从一个布局视图里面移到另外一个布局视图的末尾时希望能够提供动画效果,这时候就可以通过这个方法来得到加入后的子视图的位置和尺寸。
     这个方法只有针对那些通过添加顺序进行约束的布局视图才有意义，相对布局和框架布局则没有意义。
 
 @note 使用示例：假设存在两个布局视图L1,L2他们的父视图是S，现在要实现将L1中的任意一个子视图A移动到L2的末尾中去，而且要带动画效果，那么代码如下：
 @code
   //得到A在S中的frame，这里需要进行坐标转换为S在中的frame
   CGRect rectOld =  [L1 convertRect:A.frame toView:S];
   //得到将A加入到L2后的评估的frame值，注意这时候A还没有加入到L2。
   CGRect rectNew = [L2 subview:A estimatedRectInLayoutSize:CGSizeZero];
   //将新位置的评估的frame值，这里需要进行坐标转换为S在中的frame。
   rectNew = [L2 convertRect:rectNew toView:self.view];
 
   //动画的过程是先将A作为S的子视图进行位置的调整后再加入到L2中去
   [A removeFromSuperview];
   //因为A要使用frame进行位置的调整，所以这里要记得将useFrame设置为YES。
   A.useFrame = YES;
   A.frame = rectOld;
   [S addSubview:A];
   [UIView animateWithDuration:0.3 animations:^{
 
     A.frame = rectNew;
 
   } completion:^(BOOL finished) {
 
     //动画结束后再将A移植到L2中。
     [A removeFromSuperview];
     //将useFrame设置为NO表示，视图A重新受到布局视图的约束控制
     A.useFrame = NO;
     [L2 addSubview:A];
   }];
 @endcode
 
 @param subview 一个未加入布局视图的子视图，如果子视图已经加入则直接返回子视图的frame值。
 @param size 指定布局视图期望的宽度或者高度，一般请将这个值设置为CGSizeZero。 具体请参考estimateLayoutRect方法中的size的说明。
 @return 子视图在布局视图最后一个位置(假如加入后)的frame值。
 */
-(CGRect)subview:(UIView*)subview estimatedRectInLayoutSize:(CGSize)size;


@end


@interface MyBaseLayout(MyBaseLayoutDeprecated)

/**
 *过期方法，对于间距统一用space来描述，而边距用margin来描述。
 *原先子视图之间的间距属性的命名规范不合理，所以这里将原先的设置间距的属性设置为过期。这里也和TangramKit中的命名统一。
 *您可以在相应的位置定义宏：#define MY_USEOLDMETHODNOWARNING = 1 则不会出现老方法告警，不过不建议这么做。
 */

/**
*过期属性,请用subviewVSpace
*/
@property(nonatomic ,assign, getter=subviewVSpace, setter=setSubviewVSpace:) CGFloat subviewVertMargin MYMETHODDEPRECATED("use subviewVSpace to instead");

/**
 *过期属性,请用subviewHSpace
 */
@property(nonatomic, assign, getter=subviewHSpace, setter=setSubviewHSpace:) CGFloat subviewHorzMargin MYMETHODDEPRECATED("use subviewHSpace to instead");

/**
 *过期属性,请用subviewSpace
 */
@property(nonatomic, assign, getter=subviewSpace, setter=setSubviewSpace:) CGFloat subviewMargin MYMETHODDEPRECATED("use subviewSpace to instead");

/**
 *过期方法, 原先对边界线命名BorderLine不符合规则，Borderline是一个单词不是一个词组。这里也和TangramKit中的命名统一。
 */

/**
 *过期属性,请用leftBorderline
 */
@property(nonatomic, strong, getter=leftBorderline, setter=setLeftBorderline:) MyBorderline *leftBorderLine MYMETHODDEPRECATED("use leftBorderline to instead");

/**
 *过期属性,请用rightBorderline
 */
@property(nonatomic, strong, getter=rightBorderline, setter=setRightBorderline:) MyBorderline *rightBorderLine MYMETHODDEPRECATED("use rightBorderline to instead");

/**
 *过期属性,请用topBorderline
 */
@property(nonatomic, strong, getter=topBorderline, setter=setTopBorderline:) MyBorderline *topBorderLine MYMETHODDEPRECATED("use topBorderline to instead");

/**
 *过期属性,请用bottomBorderline
 */
@property(nonatomic, strong, getter=bottomBorderline, setter=setBottomBorderline:) MyBorderline *bottomBorderLine MYMETHODDEPRECATED("use bottomBorderline to instead");

/**
 *过期属性,请用boundBorderline
 */
@property(nonatomic, strong, getter=boundBorderline, setter=setBoundBorderline:) MyBorderline *boundBorderLine MYMETHODDEPRECATED("use boundBorderline to instead");

/**
 *过期属性,请用intelligentBorderline
 */
@property(nonatomic, strong, getter=intelligentBorderline, setter=setIntelligentBorderline:) MyBorderline *IntelligentBorderLine MYMETHODDEPRECATED("use intelligentBorderline to instead");

/**
 *过期属性,请用notUseIntelligentBorderline
 */
@property(nonatomic, assign, getter=notUseIntelligentBorderline, setter=setNotUseIntelligentBorderline:) BOOL notUseIntelligentBorderLine MYMETHODDEPRECATED("use notUseIntelligentBorderline to instead");


/**
 *这个属性在新版本将失效并且无任何意义了。如果想让子视图隐藏时是否继续占据位置则请参考使用子视图的myVisibility属性来进行单独设置。
 */
@property(nonatomic, assign) BOOL hideSubviewReLayout  MYMETHODDEPRECATED("this property was invalid, please use subview's myVisibility to instead");


@end



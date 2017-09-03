//
//  MyGrid.h
//  MyLayout
//
//  Created by oubaiquan on 2017/8/23.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutDef.h"
#import "MyBorderline.h"


extern NSString * const kMyGridTag;
extern NSString * const kMyGridAction;
extern NSString * const kMyGridActionData;
extern NSString * const kMyGridRows;
extern NSString * const kMyGridCols;
extern NSString * const kMyGridSize;
extern NSString * const kMyGridPadding;
extern NSString * const kMyGridSpace;
extern NSString * const kMyGridGravity;
extern NSString * const kMyGridPlaceholder;
extern NSString * const kMyGridAnchor;
extern NSString * const kMyGridTopBorderline;
extern NSString * const kMyGridBottomBorderline;
extern NSString * const kMyGridLeftBorderline;
extern NSString * const kMyGridRightBorderline;

extern NSString * const kMyGridBorderlineColor;
extern NSString * const kMyGridBorderlineThick;
extern NSString * const kMyGridBorderlineHeadIndent;
extern NSString * const kMyGridBorderlineTailIndent;
extern NSString * const kMyGridBorderlineOffset;


extern NSString * const vMyGridSizeWrap;
extern NSString * const vMyGridSizeFill;


extern NSString * const vMyGridGravityTop;
extern NSString * const vMyGridGravityBottom;
extern NSString * const vMyGridGravityLeft;
extern NSString * const vMyGridGravityRight;
extern NSString * const vMyGridGravityCenterX;
extern NSString * const vMyGridGravityCenterY;
extern NSString * const vMyGridGravityWidthFill;
extern NSString * const vMyGridGravityHeightFill;



/**
 栅格动作接口，您可以触摸栅格来执行特定的动作和事件。
 */
@protocol MyGridAction<NSObject>


/**
 栅格的标识，用于在事件中区分栅格。
 */
@property(nonatomic)  NSInteger tag;

/**
 栅格的动作数据，这个数据是栅格的扩展数据，您可以在动作中使用这个附加的数据来进行一系列操作。他可以是一个数值，也可以是个字符串，甚至可以是一段JS脚本。
 */
@property(nonatomic, strong) id actionData;


/**
 设置栅格的事件,如果取消栅格事件则设置target为nil

 @param target action事件的调用者
 @param action action事件，格式为：-(void)handle:(id<MyGrid>)sender
 */
-(void)setTarget:(id)target action:(SEL)action;

@end




/**
 栅格协议。用来描述栅格块，以及栅格的添加和删除。栅格可以按某个方向拆分为众多子栅格，而且这个过程可以递归进行。
 所有栅格布局中的子视图都将依次放入叶子栅格的区域中。
 */
@protocol MyGrid <MyGridAction>


//得到父栅格。根栅格的父栅格为nil
@property(nonatomic, weak, readonly) id<MyGrid> superGrid;


//得到所有子栅格
@property(nonatomic, strong, readonly) NSArray<id<MyGrid>> *subGrids;


//克隆出一个新栅格以及其下的所有子栅格。
-(id<MyGrid>)cloneGrid;


/**
 栅格内子栅格之间的间距。
 */
@property(nonatomic, assign) CGFloat subviewSpace;

/**
 栅格内子栅格或者叶子栅格内视图的四周内边距。
 */
@property(nonatomic, assign) UIEdgeInsets padding;


/**
 栅格内子栅格或者叶子栅格内视图的对齐停靠方式.
 
 1.对于非叶子栅格来说只能设置一个方向的停靠。具体只能设置左中右或者上中下
 2.对于叶子栅格来说，如果设置了gravity 则填充的子视图必须要设置明确的尺寸。
 */
@property(nonatomic, assign) MyGravity gravity;

/**
 占位标志，只用叶子栅格，当设置为YES时则表示这个格子只用于占位，子视图不能填充到这个栅格中。
 */
@property(nonatomic, assign) BOOL placeholder;


/**
  锚点标志，表示这个栅格虽然是非叶子栅格，也可以用来填充视图。如果将非叶子栅格的锚点标志设置为YES，那么这个栅格也可以用来填充子视图，一般用来当做背景视图使用。
 */
@property(nonatomic, assign) BOOL anchor;

/**顶部边界线*/
@property(nonatomic, strong) MyBorderline *topBorderline;
/**头部边界线*/
@property(nonatomic, strong) MyBorderline *leadingBorderline;
/**底部边界线*/
@property(nonatomic, strong) MyBorderline *bottomBorderline;
/**尾部边界线*/
@property(nonatomic, strong) MyBorderline *trailingBorderline;

/**如果您不需要考虑国际化的问题则请用这个属性设置左边边界线，否则用leadingBorderline*/
@property(nonatomic, strong) MyBorderline *leftBorderline;
/**如果您不需要考虑国际化的问题则请用这个属性设置右边边界线，否则用trailingBorderline*/
@property(nonatomic, strong) MyBorderline *rightBorderline;



/**
 添加行栅格，返回新的栅格。其中的measure可以设置如下的值：
 1.大于等于1的常数，表示固定尺寸。
 2.大于0小于1的常数，表示占用整体尺寸的比例
 3.小于0大于-1的常数，表示占用剩余尺寸的比例
 4.MyLayoutSize.wrap 表示尺寸由子栅格包裹
 5.MyLayoutSize.fill 表示占用栅格剩余的尺寸
 */
-(id<MyGrid>)addRow:(CGFloat)measure;

//添加列栅格，返回新的栅格。
-(id<MyGrid>)addCol:(CGFloat)measure;

//添加栅格，返回被添加的栅格。这个方法和下面的cloneGrid配合使用可以用来构建那些需要重复添加栅格的场景。
-(id<MyGrid>)addRowGrid:(id<MyGrid>)grid;
-(id<MyGrid>)addColGrid:(id<MyGrid>)grid;


//从父栅格中删除。
-(void)removeFromSuperGrid;


//用字典的方式来构造栅格。
@property(nonatomic, strong) NSDictionary *gridDictionary;


@end



//
//  MyGridLayout.h
//  MyLayout
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"

//固定尺寸。
//百分比尺寸。 (剩余的百分比还是整体百分比)
//剩余尺寸。
//包裹尺寸。
//填充尺寸。

@protocol MyGrid <NSObject>

//格子内子栅格的间距
@property(nonatomic, assign) CGFloat subviewSpace;

//添加行。返回新的栅格。
-(id<MyGrid>)addRow:(CGFloat)size;

//添加列。返回新的栅格。
-(id<MyGrid>)addCol:(CGFloat)size;

//从父栅格中删除。
-(void)removeFromSuperGrid;

//支持边界线。

//格子的内间距
@property(nonatomic, assign) UIEdgeInsets padding;

@end




/**
 栅格布局，布局默认情况下就是一个栅格。
 */
@interface MyGridLayout : MyBaseLayout<MyGrid>


//为某中size class设定
-(id<MyGrid>)gridIn:(MySizeClass)sizeClass;

//删除栅格
-(void)removeGrid;

-(void)removeGridIn:(MySizeClass)sizeClass;

//栅格的描述。
@property(nonatomic, strong) NSDictionary *gridDesc;


@end

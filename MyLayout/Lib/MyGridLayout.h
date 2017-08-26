//
//  MyGridLayout.h
//  MyLayout
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"
#import "MyGrid.h"



/**
 栅格布局，布局默认情况下就是一个行栅格。
 */
@interface MyGridLayout : MyBaseLayout<MyGrid>


//删除布局下所有的子栅格
-(void)removeGrids;
-(void)removeGridsIn:(MySizeClass)sizeClass;


/*
 栅格的描述。你可以用格子描述语言来建立格子
 
 @code
 
    {rows:[
 
 {size:100, size:"100%", size:"-20%",size:"wrap", size:"fill", padding:"{10,10,10,10}", space:10.0, gravity:@"top|bottom|left|right|centerX|centerY|width|height","top-borderline":{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1} },
 {},
 ]
 }
 
 @endcode
 
 */
@property(nonatomic, strong) NSDictionary *gridDictionary;


@end

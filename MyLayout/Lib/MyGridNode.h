//
//  MyGridNode.h
//  MyLayout
//
//  Created by oubaiquan on 2017/8/24.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyGrid.h"


//子栅格类型。
typedef enum : unsigned char {
    MySubGridsType_Unknown,
    MySubGridsType_Row,
    MySubGridsType_Col,
} MySubGridsType;


@protocol MyGridNode<MyGrid>

@property(nonatomic, weak) id<MyGridNode> superGrid;


//子栅格类型
@property(nonatomic, assign) MySubGridsType subGridsType;
//子栅格数组
@property(nonatomic, strong) NSMutableArray<id<MyGridNode>> *subGrids;


//栅格的尺寸
@property(nonatomic, assign) CGFloat gridMeasure;
//栅格的Size
@property(nonatomic) CGSize gridSize;

//得到布局视图的层
-(CALayer*)gridLayoutLayer;

//更新栅格尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure;


-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer*)layer;

-(void)showBorderline:(BOOL)show;

@end


//普通节点。
@interface MyGridNode : NSObject<MyGridNode>


-(instancetype)initWithMeasure:(CGFloat)measure superGrid:(id<MyGridNode>)superGrid;


@property(nonatomic, weak) id<MyGridNode> superGrid;


//格子内子栅格的间距
@property(nonatomic, assign) CGFloat subviewSpace;

//格子内视图的内边距。
@property(nonatomic, assign) UIEdgeInsets padding;

//格子内子视图的对齐停靠方式。
@property(nonatomic, assign) MyGravity gravity;

@property(nonatomic, assign) BOOL placeholder;


@property(nonatomic, assign) CGFloat gridMeasure;
@property(nonatomic) CGSize gridSize;


//子栅格是否列栅格
@property(nonatomic, assign) MySubGridsType subGridsType;
@property(nonatomic, strong) NSMutableArray<id<MyGridNode>> *subGrids;


@end







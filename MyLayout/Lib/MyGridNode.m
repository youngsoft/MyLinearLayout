//
//  MyGridNode.m
//  MyLayout
//
//  Created by oubaiquan on 2017/8/24.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyGridNode.h"


/**
 为节省栅格的内存而构建的可选属性列表1:子栅格间距，栅格内边距，停靠方式。
 */
typedef struct  _MyGridOptionalProperties1
{
    //格子内子栅格的间距
    CGFloat subviewSpace;
    //格子内视图的内边距。
    UIEdgeInsets padding;
    //格子内子视图的对齐停靠方式。
    MyGravity gravity;
}MyGridOptionalProperties1;


@interface MyGridNode()

@property(nonatomic, assign) MyGridOptionalProperties1 *optionalProperties1;
@property(nonatomic, strong) MyBorderlineLayerDelegate *borderlineLayerDelegate;


@end


@implementation MyGridNode

-(instancetype)initWithMeasure:(CGFloat)measure superGrid:(id<MyGridNode>)superGrid
{
    self = [self init];
    if (self != nil)
    {
        _gridMeasure = measure;
        _subGridsType  = MySubGridsType_Unknown;
        _subGrids = nil;
        _gridSize = CGSizeZero;
        _superGrid = superGrid;
        _optionalProperties1 = NULL;
        _borderlineLayerDelegate = nil;
    }
    
    return self;
}

-(MyGridOptionalProperties1*)optionalProperties1
{
    if (_optionalProperties1 == NULL)
    {
        _optionalProperties1 = (MyGridOptionalProperties1*)malloc(sizeof(MyGridOptionalProperties1));
        memset(_optionalProperties1, 0, sizeof(MyGridOptionalProperties1));
    }
    
    return _optionalProperties1;
}

-(void)dealloc
{
    if (_optionalProperties1 != NULL)
        free(_optionalProperties1);
    _optionalProperties1 = NULL;
}


#pragma mark -- MyGrid

-(id<MyGrid>)addRow:(CGFloat)measure
{
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == MySubGridsType_Col)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    
    MyGridNode *rowGrid = [[MyGridNode alloc] initWithMeasure:measure superGrid:self];
    self.subGridsType = MySubGridsType_Row;
    [self.subGrids addObject:rowGrid];
    return rowGrid;
}

-(id<MyGrid>)addCol:(CGFloat)measure
{
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == MySubGridsType_Row)
    {
        NSAssert(0, @"oops! 当前的子格子是行格子，不能再添加列格子。");
    }
    
    MyGridNode *colGrid = [[MyGridNode alloc] initWithMeasure:measure superGrid:self];
    self.subGridsType = MySubGridsType_Col;
    [self.subGrids addObject:colGrid];
    return colGrid;
}

-(id<MyGrid>)addRowGrid:(id<MyGrid>)grid
{
    NSAssert(grid.superGrid == nil, @"oops!");
    
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == MySubGridsType_Col)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    
    self.subGridsType = MySubGridsType_Row;
    [self.subGrids addObject:(id<MyGridNode>)grid];
    ((MyGridNode*)grid).superGrid = self;
    return grid;
}

-(id<MyGrid>)addColGrid:(id<MyGrid>)grid
{
    NSAssert(grid.superGrid == nil, @"oops!");
    
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == MySubGridsType_Row)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    
    self.subGridsType = MySubGridsType_Col;
    [self.subGrids addObject:(id<MyGridNode>)grid];
    ((MyGridNode*)grid).superGrid = self;
    return grid;
    
}


-(id<MyGrid>)cloneGrid
{
    MyGridNode *grid = [[MyGridNode alloc] initWithMeasure:self.gridMeasure superGrid:nil];
    //克隆各种属性。
    grid.subGridsType = self.subGridsType;
    if (self->_optionalProperties1 != NULL)
    {
        grid.subviewSpace = self.subviewSpace;
        grid.gravity = self.gravity;
        grid.padding = self.padding;
    }
    
    //拷贝分割线。。
    if (self->_borderlineLayerDelegate != nil)
    {
        
    }
    
    //克隆子节点。
    if (self.subGridsType != MySubGridsType_Unknown)
    {
        for (MyGridNode *subGrid in self.subGrids)
        {
            MyGridNode *newsubGrid = (MyGridNode*)[subGrid cloneGrid];
            if (self.subGridsType == MySubGridsType_Row)
                [grid addRowGrid:newsubGrid];
            else
                [grid addColGrid:newsubGrid];
        }
    }
    
    return grid;
}


-(void)removeFromSuperGrid
{
    [self.superGrid.subGrids removeObject:self];
    if (self.superGrid.subGrids.count == 0)
    {
        self.superGrid.subGridsType = MySubGridsType_Unknown;
    }
    self.superGrid = nil;
}

#pragma mark --  MyGridNode

-(NSMutableArray<id<MyGridNode>>*)subGrids
{
    if (_subGrids == nil)
    {
        _subGrids = [NSMutableArray new];
    }
    return _subGrids;
}

//格子内子栅格的间距
-(CGFloat)subviewSpace
{
    if (_optionalProperties1 == NULL)
        return 0;
    else
        return _optionalProperties1->subviewSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    self.optionalProperties1->subviewSpace = subviewSpace;
}

//格子内视图的内边距。
-(UIEdgeInsets)padding
{
    if (_optionalProperties1 == NULL)
        return UIEdgeInsetsZero;
    else
        return _optionalProperties1->padding;
    
}

-(void)setPadding:(UIEdgeInsets)padding
{
    self.optionalProperties1->padding = padding;
}

//格子内子视图的对齐停靠方式。
-(MyGravity)gravity
{
    if (_optionalProperties1 == NULL)
        return MyGravity_None;
    else
        return _optionalProperties1->gravity;
}

-(void)setGravity:(MyGravity)gravity
{
    self.optionalProperties1->gravity = gravity;
}

-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure
{
    if (superGrid.subGridsType == MySubGridsType_Col)
    {
        _gridSize.width = measure;
        _gridSize.height = superSize.height - superGrid.padding.top - superGrid.padding.bottom;
    }
    else
    {
        _gridSize.width = superSize.width - superGrid.padding.left - superGrid.padding.right;
        _gridSize.height = measure;
        
    }
    
    return measure;
}

-(CALayer*)gridLayoutLayer
{
    //找到根
    return [[self superGrid] gridLayoutLayer];
}


-(void)setBorderlineNeedLayoutIn:(CGRect)rect
{
    [_borderlineLayerDelegate setNeedsLayoutIn:rect];
}

-(void)showBorderline:(BOOL)show
{
    _borderlineLayerDelegate.topBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.bottomBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.leadingBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.trailingBorderlineLayer.hidden = !show;
    
    for (MyGridNode *subGrid in self.subGrids)
    {
        [subGrid showBorderline:show];
    }
}


-(MyBorderline*)topBorderline
{
    return _borderlineLayerDelegate.topBorderline;
}

-(void)setTopBorderline:(MyBorderline *)topBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutLayer]];
    }
    
    _borderlineLayerDelegate.topBorderline = topBorderline;
}


-(MyBorderline*)bottomBorderline
{
    return _borderlineLayerDelegate.bottomBorderline;
}

-(void)setBottomBorderline:(MyBorderline *)bottomBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutLayer]];
    }
    
    _borderlineLayerDelegate.bottomBorderline = bottomBorderline;
}


-(MyBorderline*)leftBorderline
{
    return _borderlineLayerDelegate.leftBorderline;
}

-(void)setLeftBorderline:(MyBorderline *)leftBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutLayer]];
    }
    
    _borderlineLayerDelegate.leftBorderline = leftBorderline;
}


-(MyBorderline*)rightBorderline
{
    return _borderlineLayerDelegate.rightBorderline;
}

-(void)setRightBorderline:(MyBorderline *)rightBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutLayer]];
    }
    
    _borderlineLayerDelegate.rightBorderline = rightBorderline;
}


-(MyBorderline*)leadingBorderline
{
    return _borderlineLayerDelegate.leadingBorderline;
}

-(void)setLeadingBorderline:(MyBorderline *)leadingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutLayer]];
    }
    
    _borderlineLayerDelegate.leadingBorderline = leadingBorderline;
}



-(MyBorderline*)trailingBorderline
{
    return _borderlineLayerDelegate.trailingBorderline;
}

-(void)setTrailingBorderline:(MyBorderline *)trailingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutLayer]];
    }
    
    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}



@end


//
//  MyGridNode.m
//  MyLayout
//
//  Created by oubaiquan on 2017/8/24.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyGridNode.h"
#import "MyLayoutDelegate.h"
#import "MyBaseLayout.h"



/**
 为支持栅格触摸而建立的触摸委托派生类。
 */
@interface MyGridNodeTouchEventDelegate : MyTouchEventDelegate

@property(nonatomic, weak) id<MyGridNode> grid;
@property(nonatomic, weak) CALayer *gridLayer;

-(instancetype)initWithLayout:(MyBaseLayout*)layout grid:(id<MyGridNode>)grid;

@end


@implementation MyGridNodeTouchEventDelegate

-(instancetype)initWithLayout:(MyBaseLayout*)layout grid:(id<MyGridNode>)grid
{
    self = [super initWithLayout:layout];
    if (self != nil)
    {
        _grid = grid;
    }
    
    return self;
}


-(void)mySetTouchHighlighted
{
    //如果有高亮则建立一个高亮子层。
    if (self.layout.highlightedBackgroundColor != nil)
    {
        if (self.gridLayer == nil)
        {
            CALayer *layer = [[CALayer alloc] init];
            layer.zPosition = -1;
            [self.layout.layer addSublayer:layer];
            self.gridLayer = layer;
        }
        self.gridLayer.frame = self.grid.gridRect;
        self.gridLayer.backgroundColor = self.layout.highlightedBackgroundColor.CGColor;
    }
}

-(void)myResetTouchHighlighted
{
    //恢复高亮，删除子图层
    if (self.gridLayer != nil)
    {
        [self.gridLayer removeFromSuperlayer];
    }
    self.gridLayer = nil;
}

-(id)myActionSender
{
    return _grid;
}

-(void)dealloc
{
    [self myResetTouchHighlighted];
}


@end





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
    //占位标志
    BOOL placeholder;
}MyGridOptionalProperties1;


@interface MyGridNode()

@property(nonatomic, assign) MyGridOptionalProperties1 *optionalProperties1;
@property(nonatomic, strong) MyBorderlineLayerDelegate *borderlineLayerDelegate;
@property(nonatomic, strong) MyTouchEventDelegate *touchEventDelegate;


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
        _gridRect = CGRectZero;
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

#pragma mark -- MyGridAction

-(void)setTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil && target != nil)
    {
        _touchEventDelegate = [[MyGridNodeTouchEventDelegate alloc] initWithLayout:(MyBaseLayout*)[self gridLayoutView] grid:self];
    }
    
    [_touchEventDelegate setTarget:target action:action];
    
    if (target == nil)
        _touchEventDelegate = nil;
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
    grid.tag = self.tag;
    if (self->_optionalProperties1 != NULL)
    {
        grid.subviewSpace = self.subviewSpace;
        grid.gravity = self.gravity;
        grid.padding = self.padding;
    }
    
    //拷贝分割线。
    if (self->_borderlineLayerDelegate != nil)
    {
        grid.topBorderline = self.topBorderline;
        grid.bottomBorderline = self.bottomBorderline;
        grid.leadingBorderline = self.leadingBorderline;
        grid.trailingBorderline = self.trailingBorderline;
    }
    
    //拷贝事件处理。
    if (self->_touchEventDelegate != nil)
    {
        [grid setTarget:self->_touchEventDelegate.target action:self->_touchEventDelegate.action];
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
    
    //如果可能销毁高亮层。
    [_touchEventDelegate myResetTouchHighlighted];
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

-(BOOL)placeholder
{
    if (_optionalProperties1 == NULL)
        return NO;
    else
        return _optionalProperties1->placeholder;
}

-(void)setPlaceholder:(BOOL)placeholder
{
    self.optionalProperties1->placeholder = placeholder;
}


-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure
{
    if (superGrid.subGridsType == MySubGridsType_Col)
    {
        _gridRect.size.width = measure;
        _gridRect.size.height = superSize.height - superGrid.padding.top - superGrid.padding.bottom;
    }
    else
    {
        _gridRect.size.width = superSize.width - superGrid.padding.left - superGrid.padding.right;
        _gridRect.size.height = measure;
        
    }
    
    return measure;
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<MyGridNode>)superGrid withOffset:(CGFloat)offset
{
    if (superGrid.subGridsType == MySubGridsType_Col)
    {
        _gridRect.origin.x = offset;
        _gridRect.origin.y = superOrigin.y + superGrid.padding.top;
        return _gridRect.size.width;
    }
    else if (superGrid.subGridsType == MySubGridsType_Row)
    {
        _gridRect.origin.x = superOrigin.x + superGrid.padding.left;
        _gridRect.origin.y = offset;
        
        return _gridRect.size.height;
    }
    else
    {
        return 0;
    }

}


-(UIView*)gridLayoutView
{
    return [[self superGrid] gridLayoutView];
}


-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer*)layer
{
    [_borderlineLayerDelegate setNeedsLayoutIn:rect withLayer:layer];
}

-(void)showBorderline:(BOOL)show
{
    _borderlineLayerDelegate.topBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.bottomBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.leadingBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.trailingBorderlineLayer.hidden = !show;
    
    //销毁高亮。。 按理来说不应该出现在这里的。。。。
    [_touchEventDelegate myResetTouchHighlighted];
    
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
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
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
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
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
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
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
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
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
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
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
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    
    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}


-(id<MyGridNode>)gridhitTest:(CGPoint *)pt
{
    
    //如果不在范围内点击则直接返回
    if (!CGRectContainsPoint(self.gridRect, *pt))
        return nil;
    
    
    //优先测试子视图。。然后再自己。。
    NSArray<id<MyGridNode>> * subGrids = nil;
    if (self.subGridsType != MySubGridsType_Unknown)
        subGrids = self.subGrids;
        
    
    for (id<MyGridNode> sbvGrid in subGrids)
    {
        id<MyGridNode> testGrid =  [sbvGrid gridhitTest:pt];
        if (testGrid != nil)
            return testGrid;
    }
    
    if (_touchEventDelegate != nil)
        return self;
    
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (MyBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (MyBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (MyBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (MyBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesCancelled:touches withEvent:event];
}



@end



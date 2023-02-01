//
//  MyGridNode.m
//  MyLayout
//
//  Created by oubaiquan on 2017/8/24.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyGridNode.h"
#import "MyBaseLayout.h"
#import "MyGridLayout.h"
#import "MyLayoutDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////

/**
 为支持栅格触摸而建立的触摸委托派生类。
 */
@interface MyGridNodeTouchEventDelegate : MyTouchEventDelegate

@property (nonatomic, weak) id<MyGridNode> grid;
@property (nonatomic, weak) CALayer *gridLayer;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) id actionData;

- (instancetype)initWithLayout:(MyBaseLayout *)layout grid:(id<MyGridNode>)grid;

@end

@implementation MyGridNodeTouchEventDelegate

- (instancetype)initWithLayout:(MyBaseLayout *)layout grid:(id<MyGridNode>)grid {
    self = [super initWithLayout:layout];
    if (self != nil) {
        _grid = grid;
    }
    return self;
}

- (void)mySetTouchHighlighted {
    //如果有高亮则建立一个高亮子层。
    if (self.layout.highlightedBackgroundColor != nil) {
        if (self.gridLayer == nil) {
            CALayer *layer = [[CALayer alloc] init];
            layer.zPosition = -1;
            [self.layout.layer addSublayer:layer];
            self.gridLayer = layer;
        }
        self.gridLayer.frame = self.grid.gridRect;
        self.gridLayer.backgroundColor = self.layout.highlightedBackgroundColor.CGColor;
    }
}

- (void)myResetTouchHighlighted {
    //恢复高亮，删除子图层
    if (self.gridLayer != nil) {
        [self.gridLayer removeFromSuperlayer];
    }
    self.gridLayer = nil;
}

- (id)myActionSender {
    return _grid;
}

- (void)dealloc {
    [self myResetTouchHighlighted];
}

@end

typedef struct _MyGridOptionalProperties1 {
    uint32_t subGridType : 2;
    uint32_t gravity : 16;
    uint32_t placeholder : 1;
    uint32_t anchor : 1;

} MyGridOptionalProperties1;

/**
 为节省栅格的内存而构建的可选属性列表1:子栅格间距，栅格内边距，停靠方式。
 */
typedef struct _MyGridOptionalProperties2 {
    //格子内子栅格的间距
    CGFloat subviewSpace;
    //格子内视图的内边距。
    UIEdgeInsets padding;
    //格子内子视图的对齐停靠方式。
} MyGridOptionalProperties2;

@interface MyGridNode ()

@property (nonatomic, assign) MyGridOptionalProperties1 optionalProperties1;
@property (nonatomic, assign) MyGridOptionalProperties2 *optionalProperties2;
@property (nonatomic, strong) MyBorderlineLayerDelegate *borderlineLayerDelegate;
@property (nonatomic, strong) MyGridNodeTouchEventDelegate *touchEventDelegate;

@end

@implementation MyGridNode

- (instancetype)initWithMeasure:(CGFloat)measure superGrid:(id<MyGridNode>)superGrid {
    self = [self init];
    if (self != nil) {
        _measure = measure;
        _subGrids = nil;
        _gridRect = CGRectZero;
        _superGrid = superGrid;
        _optionalProperties2 = NULL;
        _borderlineLayerDelegate = nil;
        _touchEventDelegate = nil;
        memset(&_optionalProperties1, 0, sizeof(MyGridOptionalProperties1));
    }
    return self;
}

- (MyGridOptionalProperties2 *)optionalProperties2 {
    if (_optionalProperties2 == NULL) {
        _optionalProperties2 = (MyGridOptionalProperties2 *)malloc(sizeof(MyGridOptionalProperties2));
        memset(_optionalProperties2, 0, sizeof(MyGridOptionalProperties2));
    }
    return _optionalProperties2;
}

- (void)dealloc {
    if (_optionalProperties2 != NULL) {
        free(_optionalProperties2);
    }
    _optionalProperties2 = NULL;
}

#pragma mark-- MyGridAction

- (NSInteger)tag {
    return _touchEventDelegate.tag;
}

- (void)setTag:(NSInteger)tag {
    if (_touchEventDelegate == nil && tag != 0) {
        _touchEventDelegate = [[MyGridNodeTouchEventDelegate alloc] initWithLayout:(MyBaseLayout *)[self gridLayoutView] grid:self];
    }
    _touchEventDelegate.tag = tag;
}

- (id)actionData {
    return _touchEventDelegate.actionData;
}

- (NSString *)action {
    return NSStringFromSelector(_touchEventDelegate.action);
}

- (void)setActionData:(id)actionData {
    if (_touchEventDelegate == nil && actionData != nil) {
        _touchEventDelegate = [[MyGridNodeTouchEventDelegate alloc] initWithLayout:(MyBaseLayout *)[self gridLayoutView] grid:self];
    }
    _touchEventDelegate.actionData = actionData;
}

- (void)setTarget:(id)target action:(SEL)action {
    if (_touchEventDelegate == nil && target != nil) {
        _touchEventDelegate = [[MyGridNodeTouchEventDelegate alloc] initWithLayout:(MyBaseLayout *)[self gridLayoutView] grid:self];
    }
    [_touchEventDelegate setTarget:target action:action];
}

- (NSDictionary *)gridDictionary {
    return [MyGridNode translateGridNode:self
                        toGridDictionary:[NSMutableDictionary new]];
}

- (void)setGridDictionary:(NSDictionary *)gridDictionary {
    [_subGrids removeAllObjects];
    self.subGridsType = MySubGridsType_Unknown;
    if (gridDictionary == nil) {
        return;
    }
    [MyGridNode translateGridDicionary:gridDictionary toGridNode:self];
}

#pragma mark-- MyGrid

- (MySubGridsType)subGridsType {
    return (MySubGridsType)_optionalProperties1.subGridType;
}

- (void)setSubGridsType:(MySubGridsType)subGridsType {
    _optionalProperties1.subGridType = subGridsType;
}

- (MyGravity)gravity {
    return (MyGravity)_optionalProperties1.gravity;
}

- (void)setGravity:(MyGravity)gravity {
    _optionalProperties1.gravity = gravity;
}

- (BOOL)placeholder {
    return _optionalProperties1.placeholder == 1;
}

- (void)setPlaceholder:(BOOL)placeholder {
    _optionalProperties1.placeholder = placeholder ? 1 : 0;
}

- (BOOL)anchor {
    return _optionalProperties1.anchor;
}

- (void)setAnchor:(BOOL)anchor {
    _optionalProperties1.anchor = anchor ? 1 : 0;
}

- (MyGravity)overlap {
    return self.gravity;
}

- (void)setOverlap:(MyGravity)overlap {
    self.anchor = YES;
    self.measure = 0;
    self.gravity = overlap;
}

- (id<MyGrid>)addRow:(CGFloat)measure {
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == MySubGridsType_Col) {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    MyGridNode *rowGrid = [[MyGridNode alloc] initWithMeasure:measure superGrid:self];
    self.subGridsType = MySubGridsType_Row;
    [self.subGrids addObject:rowGrid];
    return rowGrid;
}

- (id<MyGrid>)addCol:(CGFloat)measure {
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == MySubGridsType_Row) {
        NSAssert(0, @"oops! 当前的子格子是行格子，不能再添加列格子。");
    }
    MyGridNode *colGrid = [[MyGridNode alloc] initWithMeasure:measure superGrid:self];
    self.subGridsType = MySubGridsType_Col;
    [self.subGrids addObject:colGrid];
    return colGrid;
}

- (id<MyGrid>)addRowGrid:(id<MyGrid>)grid {
    NSAssert(grid.superGrid == nil, @"oops!");

    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == MySubGridsType_Col) {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    self.subGridsType = MySubGridsType_Row;
    [self.subGrids addObject:(id<MyGridNode>)grid];
    ((MyGridNode *)grid).superGrid = self;
    return grid;
}

- (id<MyGrid>)addColGrid:(id<MyGrid>)grid {
    NSAssert(grid.superGrid == nil, @"oops!");

    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == MySubGridsType_Row) {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    self.subGridsType = MySubGridsType_Col;
    [self.subGrids addObject:(id<MyGridNode>)grid];
    ((MyGridNode *)grid).superGrid = self;
    return grid;
}

- (id<MyGrid>)addRowGrid:(id<MyGrid>)grid measure:(CGFloat)measure {
    id<MyGridNode> gridNode = (id<MyGridNode>)[self addRowGrid:grid];
    gridNode.measure = measure;
    return gridNode;
}

- (id<MyGrid>)addColGrid:(id<MyGrid>)grid measure:(CGFloat)measure {
    id<MyGridNode> gridNode = (id<MyGridNode>)[self addColGrid:grid];
    gridNode.measure = measure;
    return gridNode;
}

- (id<MyGrid>)cloneGrid {
    MyGridNode *grid = [[MyGridNode alloc] initWithMeasure:self.measure superGrid:nil];
    //克隆各种属性。
    grid.subGridsType = self.subGridsType;
    grid.placeholder = self.placeholder;
    grid.anchor = self.anchor;
    grid.gravity = self.gravity;
    grid.tag = self.tag;
    grid.actionData = self.actionData;
    if (self->_optionalProperties2 != NULL) {
        grid.subviewSpace = self.subviewSpace;
        grid.padding = self.padding;
    }

    //拷贝分割线。
    if (self->_borderlineLayerDelegate != nil) {
        grid.topBorderline = self.topBorderline;
        grid.bottomBorderline = self.bottomBorderline;
        grid.leadingBorderline = self.leadingBorderline;
        grid.trailingBorderline = self.trailingBorderline;
    }

    //拷贝事件处理。
    if (self->_touchEventDelegate != nil) {
        [grid setTarget:self->_touchEventDelegate.target action:self->_touchEventDelegate.action];
    }
    //克隆子节点。
    if (self.subGridsType != MySubGridsType_Unknown) {
        for (MyGridNode *subGrid in self.subGrids) {
            MyGridNode *newsubGrid = (MyGridNode *)[subGrid cloneGrid];
            if (self.subGridsType == MySubGridsType_Row) {
                [grid addRowGrid:newsubGrid];
            } else {
                [grid addColGrid:newsubGrid];
            }
        }
    }
    return grid;
}

- (void)removeFromSuperGrid {
    [self.superGrid.subGrids removeObject:self];
    if (self.superGrid.subGrids.count == 0) {
        self.superGrid.subGridsType = MySubGridsType_Unknown;
    }
    //如果可能销毁高亮层。
    [_touchEventDelegate myResetTouchHighlighted];
    _borderlineLayerDelegate = nil;
    self.superGrid = nil;
}

#pragma mark--  MyGridNode

- (NSMutableArray<id<MyGridNode>> *)subGrids {
    if (_subGrids == nil) {
        _subGrids = [NSMutableArray new];
    }
    return _subGrids;
}

//格子内子栅格的间距
- (CGFloat)subviewSpace {
    if (_optionalProperties2 == NULL) {
        return 0;
    } else {
        return _optionalProperties2->subviewSpace;
    }
}

- (void)setSubviewSpace:(CGFloat)subviewSpace {
    self.optionalProperties2->subviewSpace = subviewSpace;
}

//格子内视图的内边距。
- (UIEdgeInsets)padding {
    if (_optionalProperties2 == NULL) {
        return UIEdgeInsetsZero;
    } else {
        return _optionalProperties2->padding;
    }
}

- (void)setPadding:(UIEdgeInsets)padding {
    self.optionalProperties2->padding = padding;
}

- (CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure {
    if (superGrid.subGridsType == MySubGridsType_Col) {
        _gridRect.size.width = measure;
        _gridRect.size.height = superSize.height;
    } else {
        _gridRect.size.width = superSize.width;
        _gridRect.size.height = measure;
    }
    return measure;
}

- (CGFloat)updateWrapGridSizeInSuperGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure {
    if (superGrid.subGridsType == MySubGridsType_Col) {
        _gridRect.size.width = measure;
        if (self.subGrids.count > 0) {
            _gridRect.size.height = self.subGrids.firstObject.gridRect.size.height;
        }
        return _gridRect.size.height;
    } else {
        _gridRect.size.height = measure;
        if (self.subGrids.count > 0) {
            _gridRect.size.width = self.subGrids.firstObject.gridRect.size.width;
        }
        return _gridRect.size.width;
    }
    return 0.0f;
}

- (CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<MyGridNode>)superGrid withOffset:(CGFloat)offset {
    if (superGrid.subGridsType == MySubGridsType_Col) {
        _gridRect.origin.x = offset;
        _gridRect.origin.y = superOrigin.y;
        return _gridRect.size.width;
    } else if (superGrid.subGridsType == MySubGridsType_Row) {
        _gridRect.origin.x = superOrigin.x;
        _gridRect.origin.y = offset;
        return _gridRect.size.height;
    } else {
        return 0;
    }
}

- (UIView *)gridLayoutView {
    return [[self superGrid] gridLayoutView];
}

- (SEL)gridAction {
    return _touchEventDelegate.action;
}

- (void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer {
    [_borderlineLayerDelegate setNeedsLayoutIn:rect withLayer:layer];
}

- (void)showBorderline:(BOOL)show {
    _borderlineLayerDelegate.topBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.bottomBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.leadingBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.trailingBorderlineLayer.hidden = !show;

    //销毁高亮。。 按理来说不应该出现在这里的。。。。
    if (!show) {
        [_touchEventDelegate myResetTouchHighlighted];
    }
    for (MyGridNode *subGrid in self.subGrids) {
        [subGrid showBorderline:show];
    }
}

- (MyBorderline *)topBorderline {
    return _borderlineLayerDelegate.topBorderline;
}

- (void)setTopBorderline:(MyBorderline *)topBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    _borderlineLayerDelegate.topBorderline = topBorderline;
}

- (MyBorderline *)bottomBorderline {
    return _borderlineLayerDelegate.bottomBorderline;
}

- (void)setBottomBorderline:(MyBorderline *)bottomBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    _borderlineLayerDelegate.bottomBorderline = bottomBorderline;
}

- (MyBorderline *)leftBorderline {
    return _borderlineLayerDelegate.leftBorderline;
}

- (void)setLeftBorderline:(MyBorderline *)leftBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    _borderlineLayerDelegate.leftBorderline = leftBorderline;
}

- (MyBorderline *)rightBorderline {
    return _borderlineLayerDelegate.rightBorderline;
}

- (void)setRightBorderline:(MyBorderline *)rightBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    _borderlineLayerDelegate.rightBorderline = rightBorderline;
}

- (MyBorderline *)leadingBorderline {
    return _borderlineLayerDelegate.leadingBorderline;
}

- (void)setLeadingBorderline:(MyBorderline *)leadingBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    _borderlineLayerDelegate.leadingBorderline = leadingBorderline;
}

- (MyBorderline *)trailingBorderline {
    return _borderlineLayerDelegate.trailingBorderline;
}

- (void)setTrailingBorderline:(MyBorderline *)trailingBorderline {
    if (_borderlineLayerDelegate == nil) {
        _borderlineLayerDelegate = [[MyBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}

- (id<MyGridNode>)gridHitTest:(CGPoint)point {
    //如果不在范围内点击则直接返回
    if (!CGRectContainsPoint(self.gridRect, point)) {
        return nil;
    }
    //优先测试子视图。。然后再自己。。
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (self.subGridsType != MySubGridsType_Unknown) {
        subGrids = self.subGrids;
    }
    for (id<MyGridNode> sbvGrid in subGrids) {
        id<MyGridNode> testGrid = [sbvGrid gridHitTest:point];
        if (testGrid != nil) {
            return testGrid;
        }
    }

    if (_touchEventDelegate != nil) {
        return self;
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil) {
        _touchEventDelegate.layout = (MyBaseLayout *)[self gridLayoutView];
    }
    [_touchEventDelegate touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil) {
        _touchEventDelegate.layout = (MyBaseLayout *)[self gridLayoutView];
    }
    [_touchEventDelegate touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil) {
        _touchEventDelegate.layout = (MyBaseLayout *)[self gridLayoutView];
    }
    [_touchEventDelegate touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil) {
        _touchEventDelegate.layout = (MyBaseLayout *)[self gridLayoutView];
    }
    [_touchEventDelegate touchesCancelled:touches withEvent:event];
}

////////////////////////////////////////////

+ (void)translateGridDicionary:(NSDictionary *)gridDictionary toGridNode:(id<MyGridNode>)gridNode {
    id actionData = [gridDictionary objectForKey:kMyGridActionData];
    [self createActionData:actionData gridNode:gridNode];

    NSNumber *tag = [gridDictionary objectForKey:kMyGridTag];
    [self createTag:tag.integerValue gridNode:gridNode];

    NSString *action = [gridDictionary objectForKey:kMyGridAction];
    [self createAction:action gridNode:gridNode];

    NSString *padding = [gridDictionary objectForKey:kMyGridPadding];
    [self createPadding:padding gridNode:gridNode];

    NSNumber *space = [gridDictionary objectForKey:kMyGridSpace];
    [self createSpace:space.doubleValue gridNode:gridNode];

    NSNumber *placeholder = [gridDictionary objectForKey:kMyGridPlaceholder];
    [self createPlaceholder:placeholder.boolValue gridNode:gridNode];

    NSNumber *anchor = [gridDictionary objectForKey:kMyGridAnchor];
    [self createAnchor:anchor.boolValue gridNode:gridNode];

    NSString *overlap = [gridDictionary objectForKey:kMyGridOverlap];
    [self createOverlap:overlap gridNode:gridNode];

    NSString *gravity = [gridDictionary objectForKey:kMyGridGravity];
    [self createGravity:gravity gridNode:gridNode];

    NSDictionary *dictionary = [gridDictionary objectForKey:kMyGridTopBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:0];

    dictionary = [gridDictionary objectForKey:kMyGridLeftBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:1];

    dictionary = [gridDictionary objectForKey:kMyGridBottomBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:2];

    dictionary = [gridDictionary objectForKey:kMyGridRightBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:3];

    id tempCols = [gridDictionary objectForKey:kMyGridCols];
    [self createCols:tempCols gridNode:gridNode];

    id tempRows = [gridDictionary objectForKey:kMyGridRows];
    [self createRows:tempRows gridNode:gridNode];
}

/**
 添加行栅格，返回新的栅格。其中的measure可以设置如下的值：
 1.大于等于1的常数，表示固定尺寸。
 2.大于0小于1的常数，表示占用整体尺寸的比例
 3.小于0大于-1的常数，表示占用剩余尺寸的比例
 4.MyLayoutSize.wrap 表示尺寸由子栅格包裹
 5.MyLayoutSize.fill 表示占用栅格剩余的尺寸
 */
+ (CGFloat)createLayoutSize:(id)gridSize {
    if ([gridSize isKindOfClass:[NSNumber class]]) {
        return [gridSize doubleValue];
    } else if ([gridSize isKindOfClass:[NSString class]]) {
        if ([gridSize isEqualToString:vMyGridSizeFill]) {
            return MyLayoutSize.fill;
        } else if ([gridSize isEqualToString:vMyGridSizeWrap]) {
            return MyLayoutSize.wrap;
        } else if ([gridSize hasSuffix:@"%"]) {
            if ([gridSize isEqualToString:@"100%"] ||
                [gridSize isEqualToString:@"-100%"]) {
                return MyLayoutSize.fill;
            }
            return [gridSize doubleValue] / 100.0;
        }
    }
    return MyLayoutSize.fill;
}

//action-data 数据
+ (void)createActionData:(id)actionData gridNode:(id<MyGridNode>)gridNode {
    if (actionData) {
        gridNode.actionData = actionData;
    }
}

//tag:1
+ (void)createTag:(NSInteger)tag gridNode:(id<MyGridNode>)gridNode {
    if (tag != 0) {
        gridNode.tag = tag;
    }
}

//action
+ (void)createAction:(NSString *)action gridNode:(id<MyGridNode>)gridNode {
    if (action.length > 0) {
        MyGridLayout *layout = (MyGridLayout *)[gridNode gridLayoutView];
        SEL sel = NSSelectorFromString(action);
        if (layout.gridActionTarget != nil && sel != nil && [layout.gridActionTarget respondsToSelector:sel]) {
            [gridNode setTarget:layout.gridActionTarget action:sel];
        }
    }
}

//padding:"{10,10,10,10}"
+ (void)createPadding:(NSString *)padding gridNode:(id<MyGridNode>)gridNode {
    if (padding.length > 0) {
        gridNode.padding = UIEdgeInsetsFromString(padding);
    }
}

//space:10.0
+ (void)createSpace:(CGFloat)space gridNode:(id<MyGridNode>)gridNode {
    if (space != 0.0) {
        gridNode.subviewSpace = space;
    }
}

//palceholder:true/false
+ (void)createPlaceholder:(BOOL)placeholder gridNode:(id<MyGridNode>)gridNode {
    if (placeholder) {
        gridNode.placeholder = placeholder;
    }
}

//anchor:true/false
+ (void)createAnchor:(BOOL)anchor gridNode:(id<MyGridNode>)gridNode {
    if (anchor) {
        gridNode.anchor = anchor;
    }
}

//overlap:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)createOverlap:(NSString *)overlap gridNode:(id<MyGridNode>)gridNode {
    MyGravity tempGravity = MyGravity_None;
    NSArray *array = [overlap componentsSeparatedByString:@"|"];
    for (NSString *temp in array) {
        tempGravity |= [self returnGravity:temp];
    }
    if (tempGravity != MyGravity_None) {
        gridNode.overlap = tempGravity;
    }
}

//gravity:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)createGravity:(NSString *)gravity gridNode:(id<MyGridNode>)gridNode {
    MyGravity tempGravity = MyGravity_None;
    NSArray *array = [gravity componentsSeparatedByString:@"|"];
    for (NSString *temp in array) {
        tempGravity |= [self returnGravity:temp];
    }

    if (tempGravity != MyGravity_None) {
        gridNode.gravity = tempGravity;
    }
}

+ (MyGravity)returnGravity:(NSString *)gravity {
    if ([gravity rangeOfString:vMyGridGravityTop].location != NSNotFound) {
        return MyGravity_Vert_Top;
    } else if ([gravity rangeOfString:vMyGridGravityBottom].location != NSNotFound) {
        return MyGravity_Vert_Bottom;
    } else if ([gravity rangeOfString:vMyGridGravityLeft].location != NSNotFound) {
        return MyGravity_Horz_Left;
    } else if ([gravity rangeOfString:vMyGridGravityRight].location != NSNotFound) {
        return MyGravity_Horz_Right;
    } else if ([gravity rangeOfString:vMyGridGravityLeading].location != NSNotFound) {
        return MyGravity_Horz_Leading;
    } else if ([gravity rangeOfString:vMyGridGravityTrailing].location != NSNotFound) {
        return MyGravity_Horz_Trailing;
    } else if ([gravity rangeOfString:vMyGridGravityCenterX].location != NSNotFound) {
        return MyGravity_Horz_Center;
    } else if ([gravity rangeOfString:vMyGridGravityCenterY].location != NSNotFound) {
        return MyGravity_Vert_Center;
    } else if ([gravity rangeOfString:vMyGridGravityWidthFill].location != NSNotFound) {
        return MyGravity_Horz_Fill;
    } else if ([gravity rangeOfString:vMyGridGravityHeightFill].location != NSNotFound) {
        return MyGravity_Vert_Fill;
    } else {
        return MyGravity_None;
    }
}

//{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1} borderline:{上,左,下,右}
+ (void)createBorderline:(NSDictionary *)dictionary gridNode:(id<MyGridNode>)gridNode borderline:(NSInteger)borderline {
    if (dictionary) {
        MyBorderline *line = [MyBorderline new];
        NSString *color = [dictionary objectForKey:kMyGridBorderlineColor];
        if (color) {
            line.color = [UIColor myColorWithHexString:color];
        }
        line.thick = [[dictionary objectForKey:kMyGridBorderlineThick] doubleValue];
        line.headIndent = [[dictionary objectForKey:kMyGridBorderlineHeadIndent] doubleValue];
        line.tailIndent = [[dictionary objectForKey:kMyGridBorderlineTailIndent] doubleValue];
        line.offset = [[dictionary objectForKey:kMyGridBorderlineOffset] doubleValue];
        line.dash = [[dictionary objectForKey:kMyGridBorderlineDash] doubleValue];
        switch (borderline) {
            case 0:
                gridNode.topBorderline = line;
                break;
            case 1:
                gridNode.leftBorderline = line;
                break;
            case 2:
                gridNode.bottomBorderline = line;
                break;
            case 3:
                gridNode.rightBorderline = line;
                break;
            default:
                break;
        }
    }
}

//"cols":[{}]
+ (void)createCols:(NSArray<NSDictionary *> *)cols gridNode:(id<MyGridNode>)gridNode {
    for (NSDictionary *dic in cols) {
        NSString *gridSize = [dic objectForKey:kMyGridSize];
        CGFloat measure = [self createLayoutSize:gridSize];
        MyGridNode *temp = (MyGridNode *)[gridNode addCol:measure];
        [self translateGridDicionary:dic toGridNode:temp];
    }
}

//"rows":[{}]
+ (void)createRows:(id)rows gridNode:(id<MyGrid>)gridNode {
    for (NSDictionary *dic in rows) {
        NSString *gridSize = [dic objectForKey:kMyGridSize];
        CGFloat measure = [self createLayoutSize:gridSize];
        MyGridNode *temp = (MyGridNode *)[gridNode addRow:measure];
        [self translateGridDicionary:dic toGridNode:temp];
    }
}

#pragma mark 节点转换字典

/**
 节点转换字典
 
 @param gridNode 节点
 @return 字典
 */
+ (NSDictionary *)translateGridNode:(id<MyGridNode>)gridNode toGridDictionary:(NSMutableDictionary *)gridDictionary {
    if (gridNode == nil) {
        return nil;
    }
    [self returnLayoutSizeWithGridNode:gridNode result:gridDictionary];

    [self returnActionDataWithGridNode:gridNode result:gridDictionary];

    [self returnTagWithGridNode:gridNode result:gridDictionary];

    [self returnActionWithGridNode:gridNode result:gridDictionary];

    [self returnPaddingWithGridNode:gridNode result:gridDictionary];

    [self returnSpaceWithGridNode:gridNode result:gridDictionary];

    [self returnPlaceholderWithGridNode:gridNode result:gridDictionary];

    [self returnAnchorWithGridNode:gridNode result:gridDictionary];

    [self returnOverlapWithGridNode:gridNode result:gridDictionary];

    [self returnGravityWithGridNode:gridNode result:gridDictionary];

    [self returnBorderlineWithGridNode:gridNode borderline:0 result:gridDictionary];

    [self returnBorderlineWithGridNode:gridNode borderline:1 result:gridDictionary];

    [self returnBorderlineWithGridNode:gridNode borderline:2 result:gridDictionary];

    [self returnBorderlineWithGridNode:gridNode borderline:3 result:gridDictionary];

    [self returnArrayColsRowsGridNode:gridNode result:gridDictionary];

    return gridDictionary;
}

/**
 添加行栅格，返回新的栅格。其中的measure可以设置如下的值：
 1.大于等于1的常数，表示固定尺寸。
 2.大于0小于1的常数，表示占用整体尺寸的比例
 3.小于0大于-1的常数，表示占用剩余尺寸的比例
 4.MyLayoutSize.wrap 表示尺寸由子栅格包裹
 5.MyLayoutSize.fill 表示占用栅格剩余的尺寸
 */
+ (void)returnLayoutSizeWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    id value = nil;
    if (gridNode.measure == MyLayoutSize.wrap) {
        value = vMyGridSizeWrap;
    } else if (gridNode.measure == MyLayoutSize.fill) {
        value = vMyGridSizeFill;
    } else {
        if (gridNode.measure > 0 && gridNode.measure < 1) {
            value = [NSString stringWithFormat:@"%@%%", (@(gridNode.measure * 100)).stringValue];
        } else if (gridNode.measure > -1 && gridNode.measure < 0) {
            value = [NSString stringWithFormat:@"%@%%", (@(gridNode.measure * 100)).stringValue];
        } else {
            value = [NSNumber numberWithDouble:gridNode.measure];
        }
    }
    [result setObject:value forKey:kMyGridSize];
}

//action-data 数据
+ (void)returnActionDataWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    if (gridNode.actionData) {
        [result setObject:gridNode.actionData forKey:kMyGridActionData];
    }
}

//tag:1
+ (void)returnTagWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    if (gridNode.tag != 0) {
        [result setObject:[NSNumber numberWithInteger:gridNode.tag] forKey:kMyGridTag];
    }
}

//action
+ (void)returnActionWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    SEL action = gridNode.gridAction;
    if (action) {
        [result setObject:NSStringFromSelector(action) forKey:kMyGridAction];
    }
}

//padding:"{10,10,10,10}"
+ (void)returnPaddingWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    NSString *temp = NSStringFromUIEdgeInsets(gridNode.padding);
    if (temp && ![temp isEqualToString:@"{0, 0, 0, 0}"]) {
        [result setObject:temp forKey:kMyGridPadding];
    }
}

//space:10.0
+ (void)returnSpaceWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    if (gridNode.subviewSpace != 0.0) {
        [result setObject:[NSNumber numberWithDouble:gridNode.subviewSpace] forKey:kMyGridSpace];
    }
}

//palceholder:true/false
+ (void)returnPlaceholderWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    if (gridNode.placeholder) {
        [result setObject:[NSNumber numberWithBool:gridNode.placeholder] forKey:kMyGridPlaceholder];
    }
}

//anchor:true/false
+ (void)returnAnchorWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    if (gridNode.anchor) {
        [result setObject:[NSNumber numberWithBool:gridNode.anchor] forKey:kMyGridAnchor];
    }
}

//overlap:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)returnOverlapWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    MyGravity gravity = gridNode.overlap;
    if (gravity != MyGravity_None) {
        static NSDictionary *data = nil;
        if (data == nil) {
            data = @{
                [NSNumber numberWithUnsignedShort:MyGravity_Vert_Top]: vMyGridGravityTop,
                [NSNumber numberWithUnsignedShort:MyGravity_Vert_Bottom]: vMyGridGravityBottom,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Left]: vMyGridGravityLeft,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Right]: vMyGridGravityRight,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Leading]: vMyGridGravityLeading,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Trailing]: vMyGridGravityTrailing,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Center]: vMyGridGravityCenterX,
                [NSNumber numberWithUnsignedShort:MyGravity_Vert_Center]: vMyGridGravityCenterY,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Fill]: vMyGridGravityWidthFill,
                [NSNumber numberWithUnsignedShort:MyGravity_Vert_Fill]: vMyGridGravityHeightFill
            };
        }

        NSMutableArray *gravitystrs = [NSMutableArray new];
        MyGravity horzGravity = MYHORZGRAVITY(gravity);
        NSString *horzstr = data[@(horzGravity)];
        if (horzstr != nil) {
            [gravitystrs addObject:horzstr];
        }
        MyGravity vertGravity = MYVERTGRAVITY(gravity);
        NSString *vertstr = data[@(vertGravity)];
        if (vertstr != nil) {
            [gravitystrs addObject:vertstr];
        }
        NSString *temp = [gravitystrs componentsJoinedByString:@"|"];
        if (temp.length) {
            [result setObject:temp forKey:kMyGridOverlap];
        }
    }
}

//gravity:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)returnGravityWithGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    MyGravity gravity = gridNode.gravity;
    if (gravity != MyGravity_None) {
        static NSDictionary *data = nil;
        if (data == nil) {
            data = @{
                [NSNumber numberWithUnsignedShort:MyGravity_Vert_Top]: vMyGridGravityTop,
                [NSNumber numberWithUnsignedShort:MyGravity_Vert_Bottom]: vMyGridGravityBottom,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Left]: vMyGridGravityLeft,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Right]: vMyGridGravityRight,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Leading]: vMyGridGravityLeading,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Trailing]: vMyGridGravityTrailing,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Center]: vMyGridGravityCenterX,
                [NSNumber numberWithUnsignedShort:MyGravity_Vert_Center]: vMyGridGravityCenterY,
                [NSNumber numberWithUnsignedShort:MyGravity_Horz_Fill]: vMyGridGravityWidthFill,
                [NSNumber numberWithUnsignedShort:MyGravity_Vert_Fill]: vMyGridGravityHeightFill
            };
        }

        NSMutableArray *gravitystrs = [NSMutableArray new];
        MyGravity horzGravity = MYHORZGRAVITY(gravity);
        NSString *horzstr = data[@(horzGravity)];
        if (horzstr != nil) {
            [gravitystrs addObject:horzstr];
        }
        MyGravity vertGravity = MYVERTGRAVITY(gravity);
        NSString *vertstr = data[@(vertGravity)];
        if (vertstr != nil) {
            [gravitystrs addObject:vertstr];
        }
        NSString *temp = [gravitystrs componentsJoinedByString:@"|"];
        if (temp.length) {
            [result setObject:temp forKey:kMyGridGravity];
        }
    }
}

//{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1} borderline:{上,左,下,右}
+ (void)returnBorderlineWithGridNode:(id<MyGridNode>)gridNode borderline:(NSInteger)borderline result:(NSMutableDictionary *)result {
    NSString *key = nil;
    MyBorderline *line = nil;
    switch (borderline) {
        case 0:
            key = kMyGridTopBorderline;
            line = gridNode.topBorderline;
            break;
        case 1:
            key = kMyGridLeftBorderline;
            line = gridNode.leftBorderline;
            break;
        case 2:
            key = kMyGridBottomBorderline;
            line = gridNode.bottomBorderline;
            break;
        case 3:
            key = kMyGridRightBorderline;
            line = gridNode.rightBorderline;
            break;
        default:
            break;
    }
    if (line) {
        NSMutableDictionary *dictionary = [NSMutableDictionary new];
        if (line.color) {
            [dictionary setObject:[line.color myHexString] forKey:kMyGridBorderlineColor];
        }
        if (line.thick != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.thick] forKey:kMyGridBorderlineThick];
        }
        if (line.headIndent != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.headIndent] forKey:kMyGridBorderlineHeadIndent];
        }
        if (line.tailIndent != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.tailIndent] forKey:kMyGridBorderlineTailIndent];
        }
        if (line.offset != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.offset] forKey:kMyGridBorderlineOffset];
        }
        if (line.dash != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.offset] forKey:kMyGridBorderlineDash];
        }
        [result setObject:dictionary forKey:key];
    }
}

//"cols":[{}] "rows":[{}]
+ (void)returnArrayColsRowsGridNode:(id<MyGridNode>)gridNode result:(NSMutableDictionary *)result {
    MySubGridsType subGridsType = gridNode.subGridsType;
    if (subGridsType != MySubGridsType_Unknown) {
        NSMutableArray<NSDictionary *> *temp = [NSMutableArray<NSDictionary *> arrayWithCapacity:gridNode.subGrids.count];
        NSString *key = nil;
        switch (subGridsType) {
            case MySubGridsType_Col: {
                key = kMyGridCols;
                break;
            }
            case MySubGridsType_Row: {
                key = kMyGridRows;
                break;
            }
            default:
                break;
        }
        for (id<MyGridNode> node in gridNode.subGrids) {
            [temp addObject:[self translateGridNode:node toGridDictionary:[NSMutableDictionary new]]];
        }

        if (key) {
            [result setObject:temp forKey:key];
        }
    }
}

@end

@implementation UIColor (MyGrid)

static NSDictionary *myDefaultColors() {
    static NSDictionary *colors = nil;
    if (colors == nil) {
        colors = @{
            @"black": UIColor.blackColor,
            @"darkgray": UIColor.darkGrayColor,
            @"lightgray": UIColor.lightGrayColor,
            @"white": UIColor.whiteColor,
            @"gray": UIColor.grayColor,
            @"red": UIColor.redColor,
            @"green": UIColor.greenColor,
            @"cyan": UIColor.cyanColor,
            @"yellow": UIColor.yellowColor,
            @"magenta": UIColor.magentaColor,
            @"orange": UIColor.orangeColor,
            @"purple": UIColor.purpleColor,
            @"brown": UIColor.brownColor,
            @"clear": UIColor.clearColor
        };
    }

    return colors;
}

+ (UIColor *)myColorWithHexString:(NSString *)hexString {
    if (hexString.length == 0) {
        return nil;
    }
    //判断是否以#开头,如果不是则直接读取具体的颜色值。
    if ([hexString characterAtIndex:0] != '#') {
        return [myDefaultColors() objectForKey:hexString.lowercaseString];
    }
    if (hexString.length != 7 && hexString.length != 9) {
        return nil;
    }
    NSScanner *scanner = [NSScanner scannerWithString:[hexString substringFromIndex:1]];
    unsigned int val = 0;
    [scanner scanHexInt:&val];

    unsigned char blue = val & 0xFF;
    unsigned char green = (val >> 8) & 0xFF;
    unsigned char red = (val >> 16) & 0xFF;
    unsigned char alpha = hexString.length == 7 ? 0xFF : (val >> 24) & 0xFF;

    return [[UIColor alloc] initWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 255.0f];
}

- (NSString *)myHexString {
    CGFloat red = 0, green = 0, blue = 0, alpha = 1;
    if (![self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return nil;
    }
    if (alpha != 1) {
        return [NSString stringWithFormat:@"#%02X%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255), (int)(alpha * 255)];
    } else {
        return [NSString stringWithFormat:@"#%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
    }
}

@end

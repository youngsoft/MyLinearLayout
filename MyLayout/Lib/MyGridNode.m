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
#import "UIColor+MyLayout.h"
#import "MyGridLayout.h"



/**
 为支持栅格触摸而建立的触摸委托派生类。
 */
@interface MyGridNodeTouchEventDelegate : MyTouchEventDelegate

@property(nonatomic, weak) id<MyGridNode> grid;
@property(nonatomic, weak) CALayer *gridLayer;

@property(nonatomic, assign) NSInteger tag;
@property(nonatomic, strong) id actionData;

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



typedef struct _MyGridOptionalProperties1
{
    uint32_t subGridType:2;
    uint32_t gravity:16;
    uint32_t placeholder:1;
    uint32_t anchor:1;
    
}MyGridOptionalProperties1;


/**
 为节省栅格的内存而构建的可选属性列表1:子栅格间距，栅格内边距，停靠方式。
 */
typedef struct  _MyGridOptionalProperties2
{
    //格子内子栅格的间距
    CGFloat subviewSpace;
    //格子内视图的内边距。
    UIEdgeInsets padding;
    //格子内子视图的对齐停靠方式。
}MyGridOptionalProperties2;


@interface MyGridNode()

@property(nonatomic, assign) MyGridOptionalProperties1 optionalProperties1;
@property(nonatomic, assign) MyGridOptionalProperties2 *optionalProperties2;
@property(nonatomic, strong) MyBorderlineLayerDelegate *borderlineLayerDelegate;
@property(nonatomic, strong) MyGridNodeTouchEventDelegate *touchEventDelegate;


@end


@implementation MyGridNode

-(instancetype)initWithMeasure:(CGFloat)measure superGrid:(id<MyGridNode>)superGrid
{
    self = [self init];
    if (self != nil)
    {
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

-(MyGridOptionalProperties2*)optionalProperties2
{
    if (_optionalProperties2 == NULL)
    {
        _optionalProperties2 = (MyGridOptionalProperties2*)malloc(sizeof(MyGridOptionalProperties2));
        memset(_optionalProperties2, 0, sizeof(MyGridOptionalProperties2));
    }
    
    return _optionalProperties2;
}

-(void)dealloc
{
    if (_optionalProperties2 != NULL)
        free(_optionalProperties2);
    _optionalProperties2 = NULL;
}

#pragma mark -- MyGridAction

-(NSInteger)tag
{
    return _touchEventDelegate.tag;
}

-(void)setTag:(NSInteger)tag
{
    
    if (_touchEventDelegate == nil && tag != 0)
    {
        _touchEventDelegate =  [[MyGridNodeTouchEventDelegate alloc] initWithLayout:(MyBaseLayout*)[self gridLayoutView] grid:self];
    }
    
    _touchEventDelegate.tag = tag;
}

-(id)actionData
{
    return _touchEventDelegate.actionData;
}

-(void)setActionData:(id)actionData
{
    if (_touchEventDelegate == nil && actionData != nil)
    {
        _touchEventDelegate =  [[MyGridNodeTouchEventDelegate alloc] initWithLayout:(MyBaseLayout*)[self gridLayoutView] grid:self];
    }
    
    _touchEventDelegate.actionData = actionData;
}


-(void)setTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil && target != nil)
    {
        _touchEventDelegate = [[MyGridNodeTouchEventDelegate alloc] initWithLayout:(MyBaseLayout*)[self gridLayoutView] grid:self];
    }
    
    [_touchEventDelegate setTarget:target action:action];
    
    //  if (target == nil)
    //    _touchEventDelegate = nil;
}

//gridDictionary



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
- (void)setGridDictionary:(NSDictionary *)gridDictionary
{
    if (gridDictionary == nil || gridDictionary.count <= 0) return;
    
    _gridDictionary = gridDictionary;
    
    [self settingNodeAttributes:gridDictionary gridNode:self];
}


/**
 设置节点属性

 @param gridDictionary 数据
 */
- (void)settingNodeAttributes:(NSDictionary *)gridDictionary gridNode:(MyGridNode *)gridNode
{
    NSString *tag = [gridDictionary objectForKey:kMyGridTag];
    [self createTag:tag gridNode:gridNode];

    NSString *action = [gridDictionary objectForKey:kMyGridAction];
    [self createAction:action gridNode:gridNode];
    
    NSString *padding = [gridDictionary objectForKey:kMyGridPadding];
    [self createPadding:padding gridNode:gridNode];
    
    NSString *space = [gridDictionary objectForKey:kMyGridSpace];
    [self createSpace:space gridNode:gridNode];
    
    NSString *placeholder = [gridDictionary objectForKey:kMyGridPlaceholder];
    if (placeholder.myIsNotBlank) {
        gridNode.placeholder = [placeholder boolValue];
    }
    
    NSString *anchor = [gridDictionary objectForKey:kMyGridAnchor];;
    if (anchor.myIsNotBlank) {
        gridNode.anchor = [anchor boolValue];
    }
    
    NSString *gravity = [gridDictionary objectForKey:kMyGridGravity];
    [self createGravity:gravity gridNode:gridNode];
    
    NSDictionary *dictionary = [gridDictionary objectForKey:kMyGridTopBorderline];
    if (dictionary != nil) {
        gridNode.topBorderline = [self createBorderline:dictionary];
    }
    
    dictionary = [gridDictionary objectForKey:kMyGridBottomBorderline];
    if (dictionary != nil) {
        gridNode.bottomBorderline = [self createBorderline:dictionary];
    }
    
    dictionary = [gridDictionary objectForKey:kMyGridLeftBorderline];
    if (dictionary != nil) {
        gridNode.leftBorderline = [self createBorderline:dictionary];
    }
    
    dictionary = [gridDictionary objectForKey:kMyGridRightBorderline];
    if (dictionary != nil) {
        gridNode.rightBorderline = [self createBorderline:dictionary];
    }
    
    id tempCols = [gridDictionary objectForKey:kMyGridCols];
    [self createCols:tempCols gridNode:gridNode];
    
    id tempRows = [gridDictionary objectForKey:kMyGridRows];
    [self createRows:tempRows gridNode:gridNode];
}

#pragma mark private GridDictionary


/**
 添加行栅格，返回新的栅格。其中的measure可以设置如下的值：
 1.大于等于1的常数，表示固定尺寸。
 2.大于0小于1的常数，表示占用整体尺寸的比例
 3.小于0大于-1的常数，表示占用剩余尺寸的比例
 4.MyLayoutSize.wrap 表示尺寸由子栅格包裹
 5.MyLayoutSize.fill 表示占用栅格剩余的尺寸
 */
- (CGFloat)createLayoutSize:(NSString *)gridSize
{
    if ([gridSize isKindOfClass:[NSNumber class]]) {
        return [gridSize integerValue];
    }else if ([gridSize isKindOfClass:[NSString class]]){
        if ([gridSize isEqualToString:vMyGridSizeFill]) {
            return MyLayoutSize.fill;
        }else if ([gridSize isEqualToString:vMyGridSizeWrap]){
            return MyLayoutSize.wrap;
        }else if ([gridSize hasSuffix:@"%"]){
            
            if ([gridSize isEqualToString:@"100%"] ||
                [gridSize isEqualToString:@"-100%"])return MyLayoutSize.fill;
            
            NSInteger temp = [gridSize integerValue];
            return temp / 100.f;
        }
    }
    return -1;
}

//tag:1
- (void)createTag:(NSString *)tag gridNode:(MyGridNode *)gridNode
{
    if (tag) {
        gridNode.tag = [tag integerValue];
    }
}

//action
- (void)createAction:(NSString *)action gridNode:(MyGridNode *)gridNode
{
    if (action.myIsNotBlank) {
        MyGridLayout *layout = (MyGridLayout *)[gridNode gridLayoutView];
        if (layout.gridTarget != nil) {
            [gridNode setTarget:layout.gridTarget action:NSSelectorFromString(action)];
        }
    }
}

//padding:"{10,10,10,10}"
- (void)createPadding:(NSString *)padding gridNode:(MyGridNode *)gridNode
{
    if (padding.myIsNotBlank){
        gridNode.padding = UIEdgeInsetsFromString(padding);
    }
}

//space:10.0
- (void)createSpace:(NSString *)space gridNode:(MyGridNode *)gridNode
{
    if (space){
        gridNode.subviewSpace = [space doubleValue];
    }
}

//gravity:@"top|bottom|left|right|centerX|centerY|width|height"
- (void)createGravity:(NSString *)gravity gridNode:(MyGridNode *)gridNode
{
    if (gravity.myIsNotBlank){
        MyGravity tempGravity = MyGravity_None;
        
        if ([gravity containsString:@"|"]) {
            NSArray *array = [gravity componentsSeparatedByString:@"|"];
            for (NSString *temp in array) {
                tempGravity += [self returnGravity:temp];
            }
            gridNode.gravity = tempGravity;
        }else{
            gridNode.gravity = [self returnGravity:gravity];
        }
    }
}

- (MyGravity)returnGravity:(NSString *)gravity
{
    if ([gravity isEqualToString:vMyGridGravityTop]) {
        return  MyGravity_Vert_Top;
    }else if ([gravity isEqualToString:vMyGridGravityBottom]) {
        return MyGravity_Vert_Bottom;
    }else if ([gravity isEqualToString:vMyGridGravityLeft]) {
        return MyGravity_Horz_Left;
    }else if ([gravity isEqualToString:vMyGridGravityRight]) {
        return MyGravity_Horz_Right;
    }else if ([gravity isEqualToString:vMyGridGravityCenterX]) {
        return MyGravity_Horz_Center;
    }else if ([gravity isEqualToString:vMyGridGravityCenterY]) {
        return MyGravity_Vert_Center;
    }else if ([gravity isEqualToString:vMyGridGravityWidthFill]) {
        return MyGravity_Horz_Fill;
    }else if ([gravity isEqualToString:vMyGridGravityHeightFill]) {
        return MyGravity_Vert_Fill;
    }else{
        return MyGravity_None;
    }
}


//{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1}
- (MyBorderline *)createBorderline:(NSDictionary *)dictionary
{
    if (dictionary == nil || dictionary.count == 0) return nil;
    
    MyBorderline *line = [MyBorderline new];
    NSString *color = [dictionary objectForKey:kMyGridBorderlineColor];
    if (color) {
        line.color = [UIColor myColorWithHexString:color];
    }
    CGFloat thick = [[dictionary objectForKey:kMyGridBorderlineThick] doubleValue];
    if (thick > 0.f) {
        line.thick = thick;
    }
    
    CGFloat head = [[dictionary objectForKey:kMyGridBorderlineHeadIndent] doubleValue];
    if (head > 0.f) {
        line.headIndent = head;
    }
    
    CGFloat tail = [[dictionary objectForKey:kMyGridBorderlineTailIndent] doubleValue];
    if (tail > 0.f) {
        line.tailIndent = tail;
    }
    
    CGFloat offset = [[dictionary objectForKey:kMyGridBorderlineOffset] doubleValue];
    if (offset > 0.f) {
        line.offset = offset;
    }
    return line;
}

//"cols":[{}]
- (void)createCols:(id)cols gridNode:(MyGridNode *)gridNode
{
    if (cols != nil) {
        if ([cols isKindOfClass:[NSArray<NSDictionary *> class]]) {
            for (NSDictionary *dic in cols) {
                NSString *gridSize = [dic objectForKey:kMyGridSize];
                CGFloat measure = [self createLayoutSize:gridSize];
                MyGridNode *temp = (MyGridNode *)[gridNode addCol:measure];
                [self settingNodeAttributes:dic gridNode:temp];
            }
        }
    }
}

//"rows":[{}]
- (void)createRows:(id)rows gridNode:(MyGridNode *)gridNode
{
    if (rows != nil) {
        if ([rows isKindOfClass:[NSArray<NSDictionary *> class]]) {
            for (NSDictionary *dic in rows) {
                NSString *gridSize = [dic objectForKey:kMyGridSize];
                CGFloat measure = [self createLayoutSize:gridSize];
                MyGridNode *temp = (MyGridNode *)[gridNode addRow:measure];
                [self settingNodeAttributes:dic gridNode:temp];
            }
        }
    }
}

#pragma mark -- MyGrid

-(MySubGridsType)subGridsType
{
    return (MySubGridsType)_optionalProperties1.subGridType;
}

-(void)setSubGridsType:(MySubGridsType)subGridsType
{
    _optionalProperties1.subGridType = subGridsType;
}


-(MyGravity)gravity
{
    return (MyGravity)_optionalProperties1.gravity;
}

-(void)setGravity:(MyGravity)gravity
{
    _optionalProperties1.gravity = gravity;
}


-(BOOL)placeholder
{
    return _optionalProperties1.placeholder == 1;
}

-(void)setPlaceholder:(BOOL)placeholder
{
    _optionalProperties1.placeholder = placeholder ? 1 : 0;
}

-(BOOL)anchor
{
    return _optionalProperties1.anchor;
}

-(void)setAnchor:(BOOL)anchor
{
    _optionalProperties1.anchor = anchor ? 1 : 0;
}


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

-(id<MyGrid>)addRowGrid:(id<MyGrid>)grid measure:(CGFloat)measure
{
   id<MyGridNode> gridNode =  (id<MyGridNode>)[self addRowGrid:grid];
    gridNode.measure = measure;
    return gridNode;
}

-(id<MyGrid>)addColGrid:(id<MyGrid>)grid measure:(CGFloat)measure
{
    id<MyGridNode> gridNode =  (id<MyGridNode>)[self addColGrid:grid];
    gridNode.measure = measure;
    return gridNode;
}



-(id<MyGrid>)cloneGrid
{
    MyGridNode *grid = [[MyGridNode alloc] initWithMeasure:self.measure superGrid:nil];
    //克隆各种属性。
    grid.subGridsType = self.subGridsType;
    grid.placeholder = self.placeholder;
    grid.anchor = self.anchor;
    grid.gravity = self.gravity;
    grid.tag = self.tag;
    grid.actionData = self.actionData;
    if (self->_optionalProperties2 != NULL)
    {
        grid.subviewSpace = self.subviewSpace;
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
    _borderlineLayerDelegate = nil;
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
    if (_optionalProperties2 == NULL)
        return 0;
    else
        return _optionalProperties2->subviewSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    self.optionalProperties2->subviewSpace = subviewSpace;
}

//格子内视图的内边距。
-(UIEdgeInsets)padding
{
    if (_optionalProperties2 == NULL)
        return UIEdgeInsetsZero;
    else
        return _optionalProperties2->padding;
    
}

-(void)setPadding:(UIEdgeInsets)padding
{
    self.optionalProperties2->padding = padding;
}


-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure
{
    if (superGrid.subGridsType == MySubGridsType_Col)
    {
        _gridRect.size.width = measure;
        _gridRect.size.height = superSize.height;
    }
    else
    {
        _gridRect.size.width = superSize.width;
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
    if (!show)
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


-(id<MyGridNode>)gridHitTest:(CGPoint)point
{
    
    //如果不在范围内点击则直接返回
    if (!CGRectContainsPoint(self.gridRect, point))
        return nil;
    
    
    //优先测试子视图。。然后再自己。。
    NSArray<id<MyGridNode>> * subGrids = nil;
    if (self.subGridsType != MySubGridsType_Unknown)
        subGrids = self.subGrids;
    
    
    for (id<MyGridNode> sbvGrid in subGrids)
    {
        id<MyGridNode> testGrid =  [sbvGrid gridHitTest:point];
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


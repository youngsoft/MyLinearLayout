//
//  MyGridLayout.m
//  MyLayout
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyGridLayout.h"
#import "MyGridNode.h"
#import "MyLayoutInner.h"

NSString *const kMyGridTag = @"tag";
NSString *const kMyGridAction = @"action";
NSString *const kMyGridActionData = @"action-data";
NSString *const kMyGridRows = @"rows";
NSString *const kMyGridCols = @"cols";
NSString *const kMyGridSize = @"size";
NSString *const kMyGridPadding = @"padding";
NSString *const kMyGridSpace = @"space";
NSString *const kMyGridGravity = @"gravity";
NSString *const kMyGridPlaceholder = @"placeholder";
NSString *const kMyGridAnchor = @"anchor";
NSString *const kMyGridOverlap = @"overlap";
NSString *const kMyGridTopBorderline = @"top-borderline";
NSString *const kMyGridBottomBorderline = @"bottom-borderline";
NSString *const kMyGridLeftBorderline = @"left-borderline";
NSString *const kMyGridRightBorderline = @"right-borderline";

NSString *const kMyGridBorderlineColor = @"color";
NSString *const kMyGridBorderlineThick = @"thick";
NSString *const kMyGridBorderlineHeadIndent = @"head";
NSString *const kMyGridBorderlineTailIndent = @"tail";
NSString *const kMyGridBorderlineOffset = @"offset";
NSString *const kMyGridBorderlineDash = @"dash";

NSString *const vMyGridSizeWrap = @"wrap";
NSString *const vMyGridSizeFill = @"fill";

NSString *const vMyGridGravityTop = @"top";
NSString *const vMyGridGravityBottom = @"bottom";
NSString *const vMyGridGravityLeft = @"left";
NSString *const vMyGridGravityRight = @"right";
NSString *const vMyGridGravityLeading = @"leading";
NSString *const vMyGridGravityTrailing = @"trailing";
NSString *const vMyGridGravityCenterX = @"centerX";
NSString *const vMyGridGravityCenterY = @"centerY";
NSString *const vMyGridGravityWidthFill = @"width";
NSString *const vMyGridGravityHeightFill = @"height";

//视图组和动作数据
@interface MyViewGroupAndActionData : NSObject

//视图组，这里除了可以添加UIView外还可以添加占位类型NSNull
@property (nonatomic, strong) NSMutableArray<UIView *> *viewGroup;
@property (nonatomic, strong) id actionData;

+ (instancetype)viewGroup:(NSArray *)viewGroup actionData:(id)actionData;

@end

@implementation MyViewGroupAndActionData

- (instancetype)initWithViewGroup:(NSArray *)viewGroup actionData:(id)actionData {
    self = [self init];
    if (self != nil) {
        _viewGroup = [NSMutableArray arrayWithArray:viewGroup];
        _actionData = actionData;
    }
    return self;
}

+ (instancetype)viewGroup:(NSArray *)viewGroup actionData:(id)actionData {
    return [[[self class] alloc] initWithViewGroup:viewGroup actionData:actionData];
}

@end

@interface MyGridLayout () <MyGridNode>

@property (nonatomic, weak) MyGridLayoutTraits *lastSizeClass;
//保存某个标签下对应的 视图组和数据 数组。字典。一个标签下可以有N个视图组。
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, NSMutableArray<MyViewGroupAndActionData *> *> *tagsDict;
//这个锁并不是用于同步处理，而是用来区分是外部主动调用删除子视图还是类内部删除子视图。因为二者都会触发willRemoveSubview方法的调用，这个标志
//用来表明是否是内部触发的删除子视图的标志。
@property (nonatomic, assign) BOOL tagsDictLock;

@end

@implementation MyGridLayout

- (NSMutableDictionary *)tagsDict {
    if (_tagsDict == nil) {
        _tagsDict = [NSMutableDictionary new];
    }
    return _tagsDict;
}

#pragma mark-- Public Methods

+ (id<MyGrid>)createTemplateGrid:(NSInteger)gridTag {
    id<MyGrid> grid = [[MyGridNode alloc] initWithMeasure:0 superGrid:nil];
    grid.tag = gridTag;
    return grid;
}

//删除所有子栅格
- (void)removeGrids {
    [self removeGridsIn:MySizeClass_hAny | MySizeClass_wAny];
}

- (void)removeGridsIn:(MySizeClass)sizeClass {
    id<MyGridNode> gridNode = (id<MyGridNode>)[self fetchLayoutSizeClass:sizeClass];
    [gridNode.subGrids removeAllObjects];
    gridNode.subGridsType = MySubGridsType_Unknown;
    [self setNeedsLayout];
}

- (id<MyGrid>)gridContainsSubview:(UIView *)subview {
    return [self gridHitTest:subview.center];
}

- (NSArray<UIView *> *)subviewsContainedInGrid:(id<MyGrid>)grid {
    id<MyGridNode> gridNode = (id<MyGridNode>)grid;

#ifdef DEBUG
    NSAssert([gridNode gridLayoutView] == self, @"oops! 非栅格布局中的栅格");
#endif

    NSMutableArray *retSbs = [NSMutableArray new];
    for (UIView *subview in self.subviews) {
        if (!subview.isHidden && CGRectContainsRect(gridNode.gridRect, subview.frame)) {
            [retSbs addObject:subview];
        }
    }
    return retSbs;
}

- (void)addViewGroup:(NSArray<UIView *> *)viewGroup withActionData:(id)actionData to:(NSInteger)gridTag {
    [self insertViewGroup:viewGroup withActionData:actionData atIndex:(NSUInteger)-1 to:gridTag];
}

- (void)insertViewGroup:(NSArray<UIView *> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag {
    if (gridTag != 0) {
        NSNumber *key = @(gridTag);
        NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray = [self.tagsDict objectForKey:key];
        if (viewGroupArray == nil) {
            viewGroupArray = [NSMutableArray new];
            [self.tagsDict setObject:viewGroupArray forKey:key];
        }
        
        MyViewGroupAndActionData *va = [MyViewGroupAndActionData viewGroup:viewGroup actionData:actionData];
        if (index == (NSUInteger)-1) {
            [viewGroupArray addObject:va];
        } else {
            [viewGroupArray insertObject:va atIndex:index];
        }
    }
    
    for (UIView *sbv in viewGroup) {
        if (sbv != (UIView *)[NSNull null]) {
            [self addSubview:sbv];
        }
    }

    [self setNeedsLayout];
}

- (void)replaceViewGroup:(NSArray<UIView *> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag {
    if (gridTag == 0) {
        return;
    }
    //...
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray == nil || (index >= viewGroupArray.count)) {
        [self addViewGroup:viewGroup withActionData:actionData to:gridTag];
        return;
    }

    //这里面有可能有存在的视图， 有可能存在于子视图数组里面，有可能存在于其他视图组里面。
    //如果存在于其他标签则要从其他标签删除。。。
    //而且多余的还要删除。。。这个好复杂啊。。
    //先不考虑这么复杂的情况，只认为替换掉当前索引的视图即可，如果视图本来就在子视图里面则不删除，否则就添加。而被替换掉的则需要删除。
    //每个视图都在老的里面查找，如果找到则处理，如果没有找到
    self.tagsDictLock = YES;

    MyViewGroupAndActionData *va = viewGroupArray[index];
    va.actionData = actionData;

    if (va.viewGroup != viewGroup) {
        for (UIView *sbv in viewGroup) {
            NSUInteger oldIndex = [va.viewGroup indexOfObject:sbv];
            if (oldIndex == NSNotFound) {
                if (sbv != (UIView *)[NSNull null]) {
                    [self addSubview:sbv];
                }
            } else {
                [va.viewGroup removeObjectAtIndex:oldIndex];
            }
        }

        //原来多余的视图删除
        for (UIView *sbv in va.viewGroup) {
            if (sbv != (UIView *)[NSNull null]) {
                [sbv removeFromSuperview];
            }
        }
        //将新的视图组给替换掉。
        [va.viewGroup setArray:viewGroup];
    }
    self.tagsDictLock = NO;
    [self setNeedsLayout];
}

- (void)moveViewGroupAtIndex:(NSUInteger)index from:(NSInteger)origGridTag to:(NSInteger)destGridTag {
    [self moveViewGroupAtIndex:index from:origGridTag toIndex:-1 to:destGridTag];
}

- (void)moveViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)origGridTag toIndex:(NSUInteger)index2 to:(NSInteger)destGridTag {
    if (origGridTag == 0 || destGridTag == 0 || (origGridTag == destGridTag)) {
        return;
    }
    if (_tagsDict == nil) {
        return;
    }
    NSNumber *origKey = @(origGridTag);
    NSMutableArray<MyViewGroupAndActionData *> *origViewGroupArray = [self.tagsDict objectForKey:origKey];

    if (index1 < origViewGroupArray.count) {
        NSNumber *destKey = @(destGridTag);
        NSMutableArray<MyViewGroupAndActionData *> *destViewGroupArray = [self.tagsDict objectForKey:destKey];
        if (destViewGroupArray == nil) {
            destViewGroupArray = [NSMutableArray new];
            [self.tagsDict setObject:destViewGroupArray forKey:destKey];
        }

        if (index2 > destViewGroupArray.count) {
            index2 = destViewGroupArray.count;
        }
        MyViewGroupAndActionData *va = origViewGroupArray[index1];
        [origViewGroupArray removeObjectAtIndex:index1];
        if (origViewGroupArray.count == 0) {
            [self.tagsDict removeObjectForKey:origKey];
        }
        [destViewGroupArray insertObject:va atIndex:index2];
    }
    [self setNeedsLayout];
}

- (void)removeViewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag {
    if (gridTag == 0) {
        return;
    }
    if (_tagsDict == nil) {
        return;
    }
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (index < viewGroupArray.count) {
        MyViewGroupAndActionData *va = viewGroupArray[index];

        self.tagsDictLock = YES;
        for (UIView *sbv in va.viewGroup) {
            if (sbv != (UIView *)[NSNull null]) {
                [sbv removeFromSuperview];
            }
        }
        self.tagsDictLock = NO;
        [viewGroupArray removeObjectAtIndex:index];

        if (viewGroupArray.count == 0) {
            [self.tagsDict removeObjectForKey:key];
        }
    }
    [self setNeedsLayout];
}

- (void)removeViewGroupFrom:(NSInteger)gridTag {
    if (gridTag == 0) {
        return;
    }
    if (_tagsDict == nil) {
        return;
    }
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray != nil) {
        self.tagsDictLock = YES;
        for (MyViewGroupAndActionData *va in viewGroupArray) {
            for (UIView *sbv in va.viewGroup) {
                if (sbv != (UIView *)[NSNull null]) {
                    [sbv removeFromSuperview];
                }
            }
        }
        self.tagsDictLock = NO;
        [self.tagsDict removeObjectForKey:key];
    }
    [self setNeedsLayout];
}

- (void)exchangeViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)gridTag1 withViewGroupAtIndex:(NSUInteger)index2 from:(NSInteger)gridTag2 {
    if (gridTag1 == 0 || gridTag2 == 0) {
        return;
    }
    NSNumber *key1 = @(gridTag1);
    NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray1 = [self.tagsDict objectForKey:key1];

    NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray2 = nil;

    if (gridTag1 == gridTag2) {
        viewGroupArray2 = viewGroupArray1;
        if (index1 == index2) {
            return;
        }
    } else {
        NSNumber *key2 = @(gridTag2);
        viewGroupArray2 = [self.tagsDict objectForKey:key2];
    }

    if (index1 < viewGroupArray1.count && index2 < viewGroupArray2.count) {
        self.tagsDictLock = YES;
        if (gridTag1 == gridTag2) {
            [viewGroupArray1 exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        } else {
            MyViewGroupAndActionData *va1 = viewGroupArray1[index1];
            MyViewGroupAndActionData *va2 = viewGroupArray2[index2];

            [viewGroupArray1 removeObjectAtIndex:index1];
            [viewGroupArray2 removeObjectAtIndex:index2];

            [viewGroupArray1 insertObject:va2 atIndex:index1];
            [viewGroupArray2 insertObject:va1 atIndex:index2];
        }
        self.tagsDictLock = NO;
    }
    [self setNeedsLayout];
}

- (NSUInteger)viewGroupCountOf:(NSInteger)gridTag {
    if (gridTag == 0) {
        return 0;
    }
    if (_tagsDict == nil) {
        return 0;
    }
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray = [self.tagsDict objectForKey:key];

    return viewGroupArray.count;
}

- (NSArray<UIView *> *)viewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag {
    if (gridTag == 0) {
        return nil;
    }
    if (_tagsDict == nil) {
        return nil;
    }
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (index < viewGroupArray.count) {
        return viewGroupArray[index].viewGroup;
    }
    return nil;
}

#pragma mark-- MyGrid

- (id)actionData {
    return self.myDefaultSizeClass.actionData;
}

- (void)setActionData:(id)actionData {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.actionData = actionData;
}

//添加行。返回新的栅格。
- (id<MyGrid>)addRow:(CGFloat)measure {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列。返回新的栅格。
- (id<MyGrid>)addCol:(CGFloat)measure {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addCol:measure];
    node.superGrid = self;
    return node;
}

- (id<MyGrid>)addRowGrid:(id<MyGrid>)grid {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addRowGrid:grid];
    node.superGrid = self;
    return node;
}

- (id<MyGrid>)addColGrid:(id<MyGrid>)grid {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addColGrid:grid];
    node.superGrid = self;
    return node;
}

- (id<MyGrid>)addRowGrid:(id<MyGrid>)grid measure:(CGFloat)measure {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addRowGrid:grid measure:measure];
    node.superGrid = self;
    return node;
}

- (id<MyGrid>)addColGrid:(id<MyGrid>)grid measure:(CGFloat)measure {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addColGrid:grid measure:measure];
    node.superGrid = self;
    return node;
}

- (id<MyGrid>)cloneGrid {
    return [self.myDefaultSizeClass cloneGrid];
}

- (void)removeFromSuperGrid {
    return [self.myDefaultSizeClass removeFromSuperGrid];
}

- (id<MyGrid>)superGrid {
    return self.myDefaultSizeClass.superGrid;
}

- (void)setSuperGrid:(id<MyGridNode>)superGrid {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.superGrid = superGrid;
}

- (BOOL)placeholder {
    return self.myDefaultSizeClass.placeholder;
}

- (void)setPlaceholder:(BOOL)placeholder {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.placeholder = placeholder;
}

- (BOOL)anchor {
    return self.myDefaultSizeClass.anchor;
}

- (void)setAnchor:(BOOL)anchor {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.anchor = anchor;
}

- (MyGravity)overlap {
    return self.myDefaultSizeClass.overlap;
}

- (void)setOverlap:(MyGravity)overlap {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.overlap = overlap;
}

- (NSDictionary *)gridDictionary {
    return self.myDefaultSizeClass.gridDictionary;
}

- (void)setGridDictionary:(NSDictionary *)gridDictionary {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.gridDictionary = gridDictionary;
}

#pragma mark-- MyGridNode

- (NSMutableArray<id<MyGridNode>> *)subGrids {
    return (NSMutableArray<id<MyGridNode>> *)(self.myDefaultSizeClass.subGrids);
}

- (void)setSubGrids:(NSMutableArray<id<MyGridNode>> *)subGrids {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.subGrids = subGrids;
}

- (MySubGridsType)subGridsType {
    return self.myDefaultSizeClass.subGridsType;
}

- (void)setSubGridsType:(MySubGridsType)subGridsType {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.subGridsType = subGridsType;
}

- (CGFloat)measure {
    return self.myDefaultSizeClass.measure;
}

- (void)setMeasure:(CGFloat)measure {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.measure = measure;
}

- (CGRect)gridRect {
    return self.myDefaultSizeClass.gridRect;
}

- (void)setGridRect:(CGRect)gridRect {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    lsc.gridRect = gridRect;
}

//更新格子尺寸。
- (CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure {
    return [self.myDefaultSizeClass updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

- (CGFloat)updateWrapGridSizeInSuperGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure {
    return [self.myDefaultSizeClass updateWrapGridSizeInSuperGrid:superGrid withMeasure:measure];
}


- (CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<MyGridNode>)superGrid withOffset:(CGFloat)offset {
    return [self.myDefaultSizeClass updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}

- (UIView *)gridLayoutView {
    return self;
}

- (SEL)gridAction {
    return nil;
}

- (void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    [lsc setBorderlineNeedLayoutIn:rect withLayer:layer];
}

- (void)showBorderline:(BOOL)show {
    MyGridLayout *lsc = self.myDefaultSizeClass;
    [lsc showBorderline:show];
}

- (id<MyGrid>)gridHitTest:(CGPoint)point {
    return [self.myDefaultSizeClass gridHitTest:point];
}

#pragma mark-- Touches Event

- (id<MyGridNode>)myBestHitGrid:(NSSet *)touches {
    MySizeClass sizeClass = [self myGetGlobalSizeClass];
    id<MyGridNode> bestSC = (id<MyGridNode>)[self.myEngine fetchView:self bestLayoutSizeClass:sizeClass];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return [bestSC gridHitTest:point];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self myBestHitGrid:touches] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self myBestHitGrid:touches] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self myBestHitGrid:touches] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self myBestHitGrid:touches] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark-- Override Methods

- (void)dealloc {
    //这里提前释放所有的数据，防止willRemoveSubview中重复删除。。
    _tagsDict = nil;
}

- (void)removeAllSubviews {
    _tagsDict = nil; //提前释放所有绑定的数据
    [super removeAllSubviews];
}

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];

    //如果子试图在样式里面则从样式里面删除
    if (_tagsDict != nil && !self.tagsDictLock) {
        [_tagsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSMutableArray *viewGroupArray = (NSMutableArray *)obj;
            NSInteger sbsCount = viewGroupArray.count;
            for (NSInteger j = 0; j < sbsCount; j++) {
                MyViewGroupAndActionData *va = viewGroupArray[j];
                NSInteger sbvCount = va.viewGroup.count;
                for (NSInteger i = 0; i < sbvCount; i++) {
                    if (va.viewGroup[i] == subview) {
                        [va.viewGroup removeObjectAtIndex:i];
                        break;
                        *stop = YES;
                    }
                }

                if (va.viewGroup.count == 0) {
                    [viewGroupArray removeObjectAtIndex:j];
                    break;
                }

                if (*stop) {
                    break;
                }
            }
        }];
    }
}

- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray *)subviewEngines context:(MyLayoutContext *)context {
    CGSize selfSize = [super calcLayoutSize:size subviewEngines:subviewEngines context:context];
    
    MyGridLayoutTraits<MyGridNode> *layoutTraits = (MyGridLayoutTraits<MyGridNode>  *)context->layoutViewEngine.currentSizeClass;
    
       context->paddingTop = layoutTraits.myLayoutPaddingTop;
       context->paddingBottom = layoutTraits.myLayoutPaddingBottom;
       context->paddingLeading = layoutTraits.myLayoutPaddingLeading;
       context->paddingTrailing = layoutTraits.myLayoutPaddingTrailing;
       context->vertGravity = MYVERTGRAVITY(layoutTraits.gravity);
       context->horzGravity = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(layoutTraits.gravity)];
       context->vertSpace = layoutTraits.subviewVSpace;
       context->horzSpace = layoutTraits.subviewHSpace;
       if (context->subviewEngines == nil) {
           context->subviewEngines = [layoutTraits filterEngines:subviewEngines];
       }

    //只有在非评估，并且当sizeclass的数量大于1个，并且当前的sizeclass和lastSizeClass不一致的时候
    if (!context->isEstimate && context->layoutViewEngine.multiple) {
        //将子栅格中的layer隐藏。
        if (self.lastSizeClass != nil && ((MyGridLayoutTraits *)layoutTraits) != self.lastSizeClass) {
            [((id<MyGridNode>)self.lastSizeClass) showBorderline:NO];
        }
        self.lastSizeClass = (MyGridLayoutTraits *)layoutTraits;
    }

    //设置根格子的rect为布局视图的大小。
    layoutTraits.gridRect = CGRectMake(0, 0, selfSize.width, selfSize.height);

    NSMutableDictionary *tagKeyIndexDict = [NSMutableDictionary dictionaryWithCapacity:self.tagsDict.count];
    for (NSNumber *key in self.tagsDict) {
        [tagKeyIndexDict setObject:@(0) forKey:key];
    }
    
    //构造出子视图列表。
    NSMutableArray *subviews = [NSMutableArray arrayWithCapacity:context->subviewEngines.count];
    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        [subviews addObject:subviewEngine.currentSizeClass.view];
    }

    //遍历尺寸
    NSInteger index = 0;
    CGFloat selfMeasure = [self myTraversalGrid:layoutTraits gridSize:selfSize lsc:layoutTraits sbs:subviews pIndex:&index tagViewGroupIndexDict:tagKeyIndexDict tagViewGroup:nil pTagIndex:nil withContext:context];
    if (layoutTraits.heightSizeInner.wrapVal) {
        selfSize.height = selfMeasure;
    }
    if (layoutTraits.widthSizeInner.wrapVal) {
        selfSize.width = selfMeasure;
    }
    //遍历位置。
    for (NSNumber *key in self.tagsDict) {
        [tagKeyIndexDict setObject:@(0) forKey:key];
    }

    NSEnumerator<UIView *> *enumerator = subviews.objectEnumerator;
    [self myTraversalGrid:layoutTraits gridOrigin:CGPointMake(0, 0) layoutTraits:layoutTraits sbvEnumerator:enumerator tagViewGroupIndexDict:tagKeyIndexDict tagSbvEnumerator:nil withContext:context];

    //遍历那些还剩余的然后设置为0.
    [tagKeyIndexDict enumerateKeysAndObjectsUsingBlock:^(id key, NSNumber *viewGroupIndexNumber, BOOL *stop) {
        NSArray<MyViewGroupAndActionData *> *viewGroupArray = self.tagsDict[key];
        NSInteger viewGroupIndex = viewGroupIndexNumber.integerValue;
        for (NSInteger i = viewGroupIndex; i < viewGroupArray.count; i++) {
            MyViewGroupAndActionData *va = viewGroupArray[i];
            for (UIView *sbv in va.viewGroup) {
                if (sbv != (UIView *)[NSNull null]) {
                    sbv.myEngine.frame = CGRectZero;

                    //这里面让所有视图的枚举器也走一遍，解决下面的重复设置的问题。
                    UIView *anyway = enumerator.nextObject;
                    anyway = nil; //防止有anyway编译告警而设置。
                }
            }
        }
    }];

    //处理那些剩余没有放入格子的子视图的frame设置为0
    for (UIView *sbv = enumerator.nextObject; sbv; sbv = enumerator.nextObject) {
        sbv.myEngine.frame = CGRectZero;
    }
    context->selfSize = selfSize;
    return [self myAdjustLayoutViewSizeWithContext:context];
}

- (id)createSizeClassInstance {
    return [MyGridLayoutTraits new];
}

#pragma mark-- Private Methods

//遍历位置
- (void)myTraversalGrid:(id<MyGridNode>)grid gridOrigin:(CGPoint)gridOrigin layoutTraits:(MyGridLayoutTraits *)layoutTraits sbvEnumerator:(NSEnumerator<UIView *> *)sbvEnumerator tagViewGroupIndexDict:(NSMutableDictionary *)tagViewGroupIndexDict tagSbvEnumerator:(NSEnumerator<UIView *> *)tagSbvEnumerator withContext:(MyLayoutContext *)context {
    //这要优化减少不必要的空数组的建立。。
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown)
        subGrids = grid.subGrids;

    //绘制边界线。。
    if (!context->isEstimate) {
        [grid setBorderlineNeedLayoutIn:grid.gridRect withLayer:self.layer];
    }

    if (grid.tag != 0) {
        NSNumber *key = @(grid.tag);
        NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray = [self.tagsDict objectForKey:key];
        NSNumber *viewGroupIndex = [tagViewGroupIndexDict objectForKey:key];
        if (viewGroupArray != nil && viewGroupIndex != nil) {
            if (viewGroupIndex.integerValue < viewGroupArray.count) {
                //这里将动作的数据和栅格进行关联。
                grid.actionData = viewGroupArray[viewGroupIndex.integerValue].actionData;

                tagSbvEnumerator = viewGroupArray[viewGroupIndex.integerValue].viewGroup.objectEnumerator;
                [tagViewGroupIndexDict setObject:@(viewGroupIndex.integerValue + 1) forKey:key];
            } else {
                grid.actionData = nil;
                tagSbvEnumerator = nil;
                sbvEnumerator = nil;
            }
        } else {
            tagSbvEnumerator = nil;
        }
    }

    CGFloat paddingTop;
    CGFloat paddingLeading;
    CGFloat paddingBottom;
    CGFloat paddingTrailing;
    if (grid == (id<MyGridNode>)layoutTraits) {
        paddingTop = layoutTraits.myLayoutPaddingTop;
        paddingLeading = layoutTraits.myLayoutPaddingLeading;
        paddingBottom = layoutTraits.myLayoutPaddingBottom;
        paddingTrailing = layoutTraits.myLayoutPaddingTrailing;
    } else {
        UIEdgeInsets gridPadding = grid.padding;
        paddingTop = gridPadding.top;
        paddingLeading = [MyBaseLayout isRTL] ? gridPadding.right : gridPadding.left;
        paddingBottom = gridPadding.bottom;
        paddingTrailing = [MyBaseLayout isRTL] ? gridPadding.left : gridPadding.right;
    }

    //处理叶子节点。
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder) {
        //设置子视图的位置和尺寸。。
        UIView *sbv = nil;
        UIView *tagSbv = tagSbvEnumerator.nextObject;

        if (tagSbv != (UIView *)[NSNull null]) {
            sbv = sbvEnumerator.nextObject;
        }
        if (tagSbv != nil && tagSbv != (UIView *)[NSNull null] && tagSbvEnumerator != nil) {
            sbv = tagSbv;
        }
        if (sbv != nil) {
            //调整位置和尺寸。。。
            MyLayoutEngine *subviewEngine = sbv.myEngine;
            //取垂直和水平对齐
            MyGravity vertGravity = MYVERTGRAVITY(grid.gravity);
            if (vertGravity == MyGravity_None) {
                vertGravity = MyGravity_Vert_Fill;
            }
            MyGravity horzGravity = MYHORZGRAVITY(grid.gravity);
            if (horzGravity == MyGravity_None) {
                horzGravity = MyGravity_Horz_Fill;
            } else {
                horzGravity = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:horzGravity];
            }
            //如果非叶子栅格设置为anchor则子视图的内容总是填充的
            CGFloat tempPaddingTop = paddingTop;
            CGFloat tempPaddingLeading = paddingLeading;
            CGFloat tempPaddingBottom = paddingBottom;
            CGFloat tempPaddingTrailing = paddingTrailing;

            if (grid.anchor && subGrids.count > 0) {
                vertGravity = MyGravity_Vert_Fill;
                horzGravity = MyGravity_Horz_Fill;
                tempPaddingTop = 0;
                tempPaddingLeading = 0;
                tempPaddingBottom = 0;
                tempPaddingTrailing = 0;
            }
            //如果是尺寸为0，并且设置为了anchor的话那么就根据自身
            //如果尺寸是0则因为前面有算出尺寸，所以这里就不进行调整了。
            if (grid.measure != 0 && [sbv isKindOfClass:[MyBaseLayout class]]) {
                context->horzGravity = horzGravity;
                context->vertGravity = vertGravity;
                context->selfSize = grid.gridRect.size;
                [self myAdjustSizeSettingOfSubviewEngine:subviewEngine withContext:context];
            }
            context->paddingTop = tempPaddingTop;
            context->paddingBottom = tempPaddingBottom;
            context->paddingLeading = tempPaddingLeading;
            context->paddingTrailing = tempPaddingTrailing;
            context->horzGravity = horzGravity;
            context->vertGravity = vertGravity;
            context->selfSize = grid.gridRect.size;
            [self myCalcRectOfSubviewEngine:subviewEngine pMaxWrapSize:NULL withContext:context];
            
            subviewEngine.leading += gridOrigin.x;
            subviewEngine.top += gridOrigin.y;
        }
    }

    //处理子格子的位置。
    CGFloat offset = 0;
    if (grid.subGridsType == MySubGridsType_Col) {
        offset = gridOrigin.x + paddingLeading;

        MyGravity horzGravity = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(grid.gravity)];
        if (horzGravity == MyGravity_Horz_Center || horzGravity == MyGravity_Horz_Trailing) {
            //得出所有子栅格的宽度综合
            CGFloat subGridsWidth = 0;
            for (id<MyGridNode> sbvGrid in subGrids) {
                subGridsWidth += sbvGrid.gridRect.size.width;
            }

            if (subGrids.count > 1) {
                subGridsWidth += grid.subviewSpace * (subGrids.count - 1);
            }
            if (horzGravity == MyGravity_Horz_Center) {
                offset += (grid.gridRect.size.width - paddingLeading - paddingTrailing - subGridsWidth) / 2;
            } else {
                offset += grid.gridRect.size.width - paddingLeading - paddingTrailing - subGridsWidth;
            }
        }

    } else if (grid.subGridsType == MySubGridsType_Row) {
        offset = gridOrigin.y + paddingTop;

        MyGravity vertGravity = MYVERTGRAVITY(grid.gravity);
        if (vertGravity == MyGravity_Vert_Center || vertGravity == MyGravity_Vert_Bottom) {
            //得出所有子栅格的宽度综合
            CGFloat subGridsHeight = 0;
            for (id<MyGridNode> sbvGrid in subGrids) {
                subGridsHeight += sbvGrid.gridRect.size.height;
            }

            if (subGrids.count > 1) {
                subGridsHeight += grid.subviewSpace * (subGrids.count - 1);
            }
            if (vertGravity == MyGravity_Vert_Center) {
                offset += (grid.gridRect.size.height - paddingTop - paddingBottom - subGridsHeight) / 2;
            } else {
                offset += grid.gridRect.size.height - paddingTop - paddingBottom - subGridsHeight;
            }
        }
    }

    CGPoint paddingGridOrigin = CGPointMake(gridOrigin.x + paddingLeading, gridOrigin.y + paddingTop);
    for (id<MyGridNode> sbvGrid in subGrids) {
        offset += [sbvGrid updateGridOrigin:paddingGridOrigin superGrid:grid withOffset:offset];
        offset += grid.subviewSpace;
        [self myTraversalGrid:sbvGrid gridOrigin:sbvGrid.gridRect.origin layoutTraits:layoutTraits sbvEnumerator:sbvEnumerator tagViewGroupIndexDict:tagViewGroupIndexDict tagSbvEnumerator:((sbvGrid.tag != 0) ? nil : tagSbvEnumerator) withContext:context];
    }

    //如果栅格中的tagSbvEnumerator还有剩余的视图没有地方可填，那么就将尺寸和位置设置为0
    if (grid.tag != 0) {
        //枚举那些剩余的
        for (UIView *sbv = tagSbvEnumerator.nextObject; sbv; sbv = tagSbvEnumerator.nextObject) {
            if (sbv != (UIView *)[NSNull null]) {
                sbv.myEngine.frame = CGRectZero;

                //所有子视图枚举器也要移动。
                UIView *anyway = sbvEnumerator.nextObject;
                anyway = nil;
            }
        }
    }
}

- (void)myBlankTraverse:(id<MyGridNode>)grid sbs:(NSArray<UIView *> *)sbs pIndex:(NSInteger *)pIndex tagSbs:(NSArray<UIView *> *)tagSbs pTagIndex:(NSInteger *)pTagIndex {
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown) {
        subGrids = grid.subGrids;
    }
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder) {
        BOOL isNoNullSbv = YES;
        if (grid.tag == 0 && pTagIndex != NULL) {
            *pTagIndex = *pTagIndex + 1;

            if (tagSbs != nil && *pTagIndex < tagSbs.count && tagSbs[*pTagIndex] == (UIView *)[NSNull null]) {
                isNoNullSbv = NO;
            }
        }

        if (isNoNullSbv) {
            *pIndex = *pIndex + 1;
        }
    }

    for (id<MyGridNode> sbvGrid in subGrids) {
        [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagSbs pTagIndex:(grid.tag != 0) ? NULL : pTagIndex];
    }
}

/*
遍历尺寸。
 pIndex 指定格子所对应的子视图的索引指针。
 pTagIndex 指格子所对应的视图组内的索引指针？
 tagViewGroupIndexDict： 记录标签中的视图组索引字典。
 函数返回格子的尺寸值。
 */
- (CGFloat)myTraversalGrid:(id<MyGridNode>)grid gridSize:(CGSize)gridSize lsc:(MyGridLayoutTraits *)lsc sbs:(NSArray<UIView *> *)sbs pIndex:(NSInteger *)pIndex tagViewGroupIndexDict:(NSMutableDictionary<NSNumber*, NSNumber*> *)tagViewGroupIndexDict tagViewGroup:(NSArray<UIView *> *)tagViewGroup pTagIndex:(NSInteger *)pTagIndex withContext:(MyLayoutContext *)context {
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown) {
        subGrids = grid.subGrids;
    }
        
    CGFloat paddingTop;
    CGFloat paddingLeading;
    CGFloat paddingBottom;
    CGFloat paddingTrailing;
    if (grid == (id<MyGridNode>)lsc) {
        paddingTop = lsc.myLayoutPaddingTop;
        paddingLeading = lsc.myLayoutPaddingLeading;
        paddingBottom = lsc.myLayoutPaddingBottom;
        paddingTrailing = lsc.myLayoutPaddingTrailing;
    } else {
        UIEdgeInsets gridPadding = grid.padding;
        paddingTop = gridPadding.top;
        paddingLeading = [MyBaseLayout isRTL] ? gridPadding.right : gridPadding.left;
        paddingBottom = gridPadding.bottom;
        paddingTrailing = [MyBaseLayout isRTL] ? gridPadding.left : gridPadding.right;
    }

    CGFloat fixedMeasure = 0; //固定部分的尺寸
    CGFloat validMeasure = 0; //整体有效的尺寸
    if (subGrids.count > 1) {
        fixedMeasure += (subGrids.count - 1) * grid.subviewSpace;
    }
    if (grid.subGridsType == MySubGridsType_Col) {
        fixedMeasure += paddingLeading + paddingTrailing;
        validMeasure = grid.gridRect.size.width - fixedMeasure;
    } else if (grid.subGridsType == MySubGridsType_Row) {
        fixedMeasure += paddingTop + paddingBottom;
        validMeasure = grid.gridRect.size.height - fixedMeasure;
    }

    //要从格子找到对应的视图，因为格子是树形结构而视图是数组结构，因此每遍历完一个可以放视图的格子，视图的索引就要加1
    //还有一种特殊的就是开启了视图组的功能，因此某些标签下的格子要单独遍历对应视图组中的视图。
    //但是这里是否存在视图组和非视图组并存的情况呢？
    
    //得到匹配的form
    if (grid.tag != 0) {
        NSNumber *key = @(grid.tag);
        NSMutableArray<MyViewGroupAndActionData *> *viewGroupArray = [self.tagsDict objectForKey:key];
        NSNumber *viewGroupIndex = [tagViewGroupIndexDict objectForKey:key];
        if (viewGroupArray != nil && viewGroupIndex != nil) {
            if (viewGroupIndex.integerValue < viewGroupArray.count) {
                tagViewGroup = viewGroupArray[viewGroupIndex.integerValue].viewGroup;
                NSInteger tagIndex = 0;
                pTagIndex = &tagIndex;
                [tagViewGroupIndexDict setObject:@(viewGroupIndex.integerValue + 1) forKey:key];
            } else {
                tagViewGroup = nil;
                pTagIndex = NULL;
                sbs = nil;
            }
        } else {
            tagViewGroup = nil;
            pTagIndex = NULL;
        }
    }

    //叶子节点，或者用来放置视图的格子。
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder) {
        BOOL isNotNullSbv = YES;
        NSArray<UIView *> *tempSbs = sbs;
        NSInteger *pTempIndex = pIndex;

        if (tagViewGroup != nil && pTagIndex != NULL) {
            tempSbs = tagViewGroup;
            pTempIndex = pTagIndex;
        }

        //如果尺寸是包裹
        if (grid.measure == MyLayoutSize.wrap || (grid.measure == 0 && grid.anchor)) {
            if (*pTempIndex < tempSbs.count) {
                //加这个条件是根栅格如果是叶子栅格的话不处理这种情况。
                if (grid.superGrid != nil) {
                    UIView *sbv = tempSbs[*pTempIndex];
                    if (sbv != (UIView *)[NSNull null]) {
                        //叶子节点
                        if (!grid.anchor || (grid.measure == 0 && grid.anchor)) {
                            MyLayoutEngine *subviewEngine = sbv.myEngine;
                            MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
                            subviewEngine.frame = sbv.bounds;

                            //如果子视图不设置任何约束要进行特殊处理。
                            if (subviewTraits.widthSizeInner.val == nil && subviewTraits.heightSizeInner.val == nil) {
                                CGSize size = CGSizeZero;
                                if (grid.superGrid.subGridsType == MySubGridsType_Row) {
                                    size.width = gridSize.width - paddingLeading - paddingTrailing;
                                } else {
                                    size.height = gridSize.height - paddingTop - paddingBottom;
                                }
                                size = [sbv sizeThatFits:size];
                                subviewEngine.width = size.width;
                                subviewEngine.height = size.height;
                                
                            } else {
                                context->vertGravity = MyGravity_None;
                                context->horzGravity = MyGravity_None;
                                context->paddingTop = paddingTop;
                                context->paddingBottom = paddingBottom;
                                context->paddingLeading = paddingLeading;
                                context->paddingTrailing = paddingTrailing;
                                context->selfSize = grid.gridRect.size;
                                [self myCalcRectOfSubviewEngine:subviewEngine pMaxWrapSize:NULL withContext:context];
                            }

                            if (grid.superGrid.subGridsType == MySubGridsType_Row) {
                                fixedMeasure = paddingTop + paddingBottom + subviewEngine.height;
                                if (grid.superGrid.measure == MyLayoutSize.wrap && grid.superGrid.superGrid != nil && grid.superGrid.superGrid.subGridsType == MySubGridsType_Col) {
                                    [grid updateWrapGridSizeInSuperGrid:grid.superGrid.superGrid withMeasure:paddingLeading + paddingTrailing + subviewEngine.width];
                                }
                                
                            } else {
                                fixedMeasure = paddingLeading + paddingTrailing + subviewEngine.width;
                                if (grid.superGrid.measure == MyLayoutSize.wrap && grid.superGrid.superGrid != nil && grid.superGrid.superGrid.subGridsType == MySubGridsType_Row) {
                                    [grid updateWrapGridSizeInSuperGrid:grid.superGrid.superGrid withMeasure:paddingTop + paddingBottom + subviewEngine.height];
                                }
                            }
                        }
                    } else {
                        isNotNullSbv = NO;
                    }
                }
            }
        }

        //索引加1跳转到下一个节点。
        if (tagViewGroup != nil && pTagIndex != NULL) {
            *pTempIndex = *pTempIndex + 1;
        }
        if (isNotNullSbv) {
            *pIndex = *pIndex + 1;
        }
    }

    //如果自己的尺寸是wrap的并且子节点的行列类型和自身的行列类型不一致，则尺寸为最大的值。
    BOOL wrapMeasure = NO;
    CGFloat maxMeasure = 0.0;

    if (subGrids.count > 0) {
        NSMutableArray<id<MyGridNode>> *weightSubGrids = [NSMutableArray new];      //比重尺寸子格子数组
        NSMutableArray<NSNumber *> *weightSubGridsIndexs = [NSMutableArray new];    //比重尺寸格子的开头子视图位置索引
        NSMutableArray<NSNumber *> *weightSubGridsTagIndexs = [NSMutableArray new]; //比重尺寸格子的开头子视图位置索引

        NSMutableArray<id<MyGridNode>> *fillSubGrids = [NSMutableArray new];      //填充尺寸格子数组
        NSMutableArray<NSNumber *> *fillSubGridsIndexs = [NSMutableArray new];    //填充尺寸格子的开头子视图位置索引
        NSMutableArray<NSNumber *> *fillSubGridsTagIndexs = [NSMutableArray new]; //填充尺寸格子的开头子视图位置索引

        //包裹尺寸先遍历所有子格子
        CGSize gridSize2 = gridSize;
        if (grid.subGridsType == MySubGridsType_Row) {
            gridSize2.width -= (paddingLeading + paddingTrailing);
        } else {
            gridSize2.height -= (paddingTop + paddingBottom);
        }
        
        if (grid == (id<MyGridNode>)lsc) {
            
            if (lsc.heightSizeInner.isWrap && grid.subGridsType == MySubGridsType_Col) {
                wrapMeasure =  YES;
            }
            
            if (lsc.widthSizeInner.isWrap && grid.subGridsType == MySubGridsType_Row) {
                wrapMeasure = YES;
            }
            
        } else {
            wrapMeasure = (grid.measure == MyLayoutSize.wrap) && (grid.superGrid.subGridsType != grid.subGridsType);
        }
        
        for (id<MyGridNode> sbvGrid in subGrids) {
            if (sbvGrid.measure == MyLayoutSize.wrap) {

                //先将父节点的尺寸更新到非wrap维度的自身尺寸上，便于计算另外维度的子格子尺寸。
                [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:0];
                CGFloat measure = [self myTraversalGrid:sbvGrid gridSize:gridSize2 lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex withContext:context];
                if (wrapMeasure) {
                    fixedMeasure += measure;
                    measure = [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                    //取子节点中的最高值。
                    if (measure > maxMeasure) {
                        maxMeasure = measure;
                    }
                } else {
                    
                    fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:measure];
                }

            } else if (sbvGrid.measure >= 1 || sbvGrid.measure == 0) {
                
                CGFloat measure = sbvGrid.measure;
                if (wrapMeasure) {
                    fixedMeasure += measure;
                    [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                } else {
                    fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:measure];
                }

                //遍历儿子节点。。
                [self myTraversalGrid:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex withContext:context];
                
                if (wrapMeasure) {
                    measure = [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                    if (measure > maxMeasure) {
                        maxMeasure = measure;
                    }
                }

            } else if (sbvGrid.measure > 0 && sbvGrid.measure < 1) {
                
                CGFloat measure = validMeasure * sbvGrid.measure;
                if (wrapMeasure) {
                    fixedMeasure += measure;
                    [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                } else {
                    fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:measure];
                }

                //遍历儿子节点。。
                [self myTraversalGrid:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex withContext:context];
                
                if (wrapMeasure) {
                    measure = [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                    if (measure > maxMeasure) {
                        maxMeasure = measure;
                    }
                }

            } else if (sbvGrid.measure < 0 && sbvGrid.measure > -1) {
                [weightSubGrids addObject:sbvGrid];
                [weightSubGridsIndexs addObject:@(*pIndex)];

                if (pTagIndex != NULL) {
                    [weightSubGridsTagIndexs addObject:@(*pTagIndex)];
                }
                //这里面空转一下。
                [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagViewGroup pTagIndex:pTagIndex];

            } else if (sbvGrid.measure == MyLayoutSize.fill) {
                [fillSubGrids addObject:sbvGrid];

                [fillSubGridsIndexs addObject:@(*pIndex)];

                if (pTagIndex != NULL) {
                    [fillSubGridsTagIndexs addObject:@(*pTagIndex)];
                }
                //这里面空转一下。
                [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagViewGroup pTagIndex:pTagIndex];
            } else {
                NSAssert(0, @"oops!");
            }
        }

        //算出剩余的尺寸。
        BOOL hasTagIndex = (pTagIndex != NULL);
        CGFloat remainedMeasure = 0;
        if (grid.subGridsType == MySubGridsType_Col) {
            remainedMeasure = grid.gridRect.size.width - fixedMeasure;
        } else if (grid.subGridsType == MySubGridsType_Row) {
            remainedMeasure = grid.gridRect.size.height - fixedMeasure;
        }

        NSInteger weightSubGridCount = weightSubGrids.count;
        if (weightSubGridCount > 0) {
            for (NSInteger i = 0; i < weightSubGridCount; i++) {
                id<MyGridNode> sbvGrid = weightSubGrids[i];
                
                CGFloat measure = -1 * remainedMeasure * sbvGrid.measure;
                if (wrapMeasure) {
                    remainedMeasure -= measure;
                    [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                } else {
                    remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:measure];
                }

                NSInteger index = weightSubGridsIndexs[i].integerValue;
                if (hasTagIndex) {
                    NSInteger tagIndex = weightSubGridsTagIndexs[i].integerValue;
                    pTagIndex = &tagIndex;
                } else {
                    pTagIndex = NULL;
                }

                [self myTraversalGrid:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex withContext:context];
                
                if (wrapMeasure) {
                    measure = [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                    if (measure > maxMeasure) {
                        maxMeasure = measure;
                    }
                }
            }
        }

        NSInteger fillSubGridsCount = fillSubGrids.count;
        if (fillSubGridsCount > 0) {
            NSInteger totalCount = fillSubGridsCount;
            for (NSInteger i = 0; i < fillSubGridsCount; i++) {
                id<MyGridNode> sbvGrid = fillSubGrids[i];
                CGFloat measure = _myCGFloatRound(remainedMeasure * (1.0 / totalCount));
                if (wrapMeasure) {
                    remainedMeasure -= measure;
                    [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                } else {
                    remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:measure];
                }
                totalCount -= 1;
                NSInteger index = fillSubGridsIndexs[i].integerValue;
                if (hasTagIndex) {
                    NSInteger tagIndex = fillSubGridsTagIndexs[i].integerValue;
                    pTagIndex = &tagIndex;
                } else {
                    pTagIndex = nil;
                }
                [self myTraversalGrid:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex withContext:context];
                
                if (wrapMeasure) {
                    measure = [sbvGrid updateWrapGridSizeInSuperGrid:grid withMeasure:measure];
                    if (measure > maxMeasure) {
                        maxMeasure = measure;
                    }
                }
            }
        }
    }
    
    if (wrapMeasure) {
        
        if (self.subGridsType == MySubGridsType_Col) {
            maxMeasure += paddingTop + paddingBottom;
        }else {
            maxMeasure += paddingLeading + paddingTrailing;
        }
        
        return maxMeasure;
    } else {
        return fixedMeasure;
    }
}

@end

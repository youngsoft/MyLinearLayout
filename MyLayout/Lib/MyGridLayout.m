//
//  MyGridLayout.m
//  MyLayout
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyGridLayout.h"
#import "MyLayoutInner.h"
#import "MyGridNode.h"

 NSString * const kMyGridTag = @"tag";
 NSString * const kMyGridAction = @"action";
 NSString * const kMyGridActionData = @"action-data";
 NSString * const kMyGridRows = @"rows";
 NSString * const kMyGridCols = @"cols";
 NSString * const kMyGridSize = @"size";
 NSString * const kMyGridPadding = @"padding";
 NSString * const kMyGridSpace = @"space";
 NSString * const kMyGridGravity = @"gravity";
 NSString * const kMyGridPlaceholder = @"placeholder";
 NSString * const kMyGridAnchor = @"anchor";
 NSString * const kMyGridOverlap = @"overlap";
 NSString * const kMyGridTopBorderline = @"top-borderline";
 NSString * const kMyGridBottomBorderline = @"bottom-borderline";
 NSString * const kMyGridLeftBorderline = @"left-borderline";
 NSString * const kMyGridRightBorderline = @"right-borderline";

 NSString * const kMyGridBorderlineColor = @"color";
 NSString * const kMyGridBorderlineThick = @"thick";
 NSString * const kMyGridBorderlineHeadIndent = @"head";
 NSString * const kMyGridBorderlineTailIndent = @"tail";
 NSString * const kMyGridBorderlineOffset = @"offset";
 NSString * const kMyGridBorderlineDash = @"dash";


 NSString * const vMyGridSizeWrap = @"wrap";
 NSString * const vMyGridSizeFill = @"fill";


 NSString * const vMyGridGravityTop = @"top";
 NSString * const vMyGridGravityBottom = @"bottom";
 NSString * const vMyGridGravityLeft = @"left";
 NSString * const vMyGridGravityRight = @"right";
 NSString * const vMyGridGravityLeading = @"leading";
 NSString * const vMyGridGravityTrailing = @"trailing";
 NSString * const vMyGridGravityCenterX = @"centerX";
 NSString * const vMyGridGravityCenterY = @"centerY";
 NSString * const vMyGridGravityWidthFill = @"width";
 NSString * const vMyGridGravityHeightFill = @"height";


//视图组和动作数据
@interface MyViewGroupAndActionData : NSObject

@property(nonatomic, strong) NSMutableArray *viewGroup;
@property(nonatomic, strong) id actionData;

+(instancetype)viewGroup:(NSArray*)viewGroup actionData:(id)actionData;

@end

@implementation MyViewGroupAndActionData

-(instancetype)initWithViewGroup:(NSArray*)viewGroup actionData:(id)actionData
{
    self = [self init];
    if (self != nil)
    {
        _viewGroup = [NSMutableArray arrayWithArray:viewGroup];
        _actionData = actionData;
    }
    
    return self;
}

+(instancetype)viewGroup:(NSArray*)viewGroup actionData:(id)actionData
{
    return [[[self class] alloc] initWithViewGroup:viewGroup actionData:actionData];
}


@end





@interface MyGridLayout()<MyGridNode>

@property(nonatomic, weak) MyGridLayoutViewSizeClass *lastSizeClass;

@property(nonatomic, strong) NSMutableDictionary *tagsDict;
@property(nonatomic, assign) BOOL tagsDictLock;

@end


@implementation MyGridLayout

-(NSMutableDictionary*)tagsDict
{
    if (_tagsDict == nil)
    {
        _tagsDict = [NSMutableDictionary new];
    }
    
    return _tagsDict;
}

#pragma mark -- Public Methods

+(id<MyGrid>)createTemplateGrid:(NSInteger)gridTag
{
    id<MyGrid> grid  =  [[MyGridNode alloc] initWithMeasure:0 superGrid:nil];
    grid.tag = gridTag;
    
    return grid;
}


//删除所有子栅格
-(void)removeGrids
{
    [self removeGridsIn:MySizeClass_hAny | MySizeClass_wAny];
}

-(void)removeGridsIn:(MySizeClass)sizeClass
{
    id<MyGridNode> lsc = (id<MyGridNode>)[self fetchLayoutSizeClass:sizeClass];
    [lsc.subGrids removeAllObjects];
    lsc.subGridsType = MySubGridsType_Unknown;
    
    [self setNeedsLayout];
}

-(id<MyGrid>) gridContainsSubview:(UIView*)subview
{
    return [self gridHitTest:subview.center];
}

-(NSArray<UIView*>*) subviewsContainedInGrid:(id<MyGrid>)grid
{
    
    id<MyGridNode> gridNode = (id<MyGridNode>)grid;
    
#ifdef DEBUG
    NSAssert([gridNode gridLayoutView] == self, @"oops! 非栅格布局中的栅格");
#endif
    
    NSMutableArray *retSbs = [NSMutableArray new];
    NSArray *sbs = [self myGetLayoutSubviews];
    for (UIView *sbv in sbs)
    {
        if (CGRectContainsRect(gridNode.gridRect, sbv.frame))
        {
            [retSbs addObject:sbv];
        }
    }
    
    return retSbs;
}


-(void)addViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData to:(NSInteger)gridTag
{
    [self insertViewGroup:viewGroup withActionData:actionData atIndex:(NSUInteger)-1 to:gridTag];
}

-(void)insertViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag
{
    if (gridTag == 0)
    {
        for (UIView *sbv in viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [self addSubview:sbv];
        }
        
        return;
    }
    
    //...
    NSNumber *key = @(gridTag);
    NSMutableArray *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray == nil)
    {
        viewGroupArray = [NSMutableArray new];
        [self.tagsDict setObject:viewGroupArray forKey:key];
    }
    
    MyViewGroupAndActionData *va = [MyViewGroupAndActionData viewGroup:viewGroup actionData:actionData];
    if (index == (NSUInteger)-1)
    {
        [viewGroupArray addObject:va];
    }
    else
    {
        [viewGroupArray insertObject:va atIndex:index];
    }
    
    for (UIView *sbv in viewGroup)
    {
        if (sbv != (UIView*)[NSNull null])
            [self addSubview:sbv];
    }

    [self setNeedsLayout];
}

-(void)replaceViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag
{
    if (gridTag == 0)
    {
        return;
    }
    
    //...
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray == nil || (index >= viewGroupArray.count))
    {
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
    
    if (va.viewGroup != viewGroup)
    {
        for (UIView *sbv in viewGroup)
        {
            NSUInteger oldIndex = [va.viewGroup indexOfObject:sbv];
            if (oldIndex == NSNotFound)
            {
                if (sbv != (UIView*)[NSNull null])
                    [self addSubview:sbv];
            }
            else
            {
                [va.viewGroup removeObjectAtIndex:oldIndex];
            }
        }
        
        //原来多余的视图删除
        for (UIView *sbv in va.viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [sbv removeFromSuperview];
        }
        
        //将新的视图组给替换掉。
        [va.viewGroup setArray:viewGroup];
    }
    
    self.tagsDictLock = NO;

 
    [self setNeedsLayout];
    
}


-(void)moveViewGroupAtIndex:(NSUInteger)index from:(NSInteger)origGridTag to:(NSInteger)destGridTag
{
    [self moveViewGroupAtIndex:index from:origGridTag toIndex:-1 to:destGridTag];
}

-(void)moveViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)origGridTag  toIndex:(NSUInteger)index2 to:(NSInteger)destGridTag
{
    if (origGridTag == 0 || destGridTag == 0 || (origGridTag == destGridTag))
        return;
    
    if (_tagsDict == nil)
        return;
    
    NSNumber *origKey = @(origGridTag);
    NSMutableArray<MyViewGroupAndActionData*> *origViewGroupArray = [self.tagsDict objectForKey:origKey];
    
    if (index1 < origViewGroupArray.count)
    {
        
        NSNumber *destKey = @(destGridTag);
        
        NSMutableArray<MyViewGroupAndActionData*> *destViewGroupArray = [self.tagsDict objectForKey:destKey];
        if (destViewGroupArray == nil)
        {
            destViewGroupArray = [NSMutableArray new];
            [self.tagsDict setObject:destViewGroupArray forKey:destKey];
        }
        
        if (index2 > destViewGroupArray.count)
            index2 = destViewGroupArray.count;
        
        
        MyViewGroupAndActionData *va = origViewGroupArray[index1];
        [origViewGroupArray removeObjectAtIndex:index1];
        if (origViewGroupArray.count == 0)
        {
            [self.tagsDict removeObjectForKey:origKey];
        }
        
        [destViewGroupArray insertObject:va atIndex:index2];
        
        
    }
    
    [self setNeedsLayout];

}



-(void)removeViewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag
{
    if (gridTag == 0)
        return;
    
    if (_tagsDict == nil)
        return;
    
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (index < viewGroupArray.count)
    {
        MyViewGroupAndActionData *va = viewGroupArray[index];
        
        self.tagsDictLock = YES;
        for (UIView *sbv in va.viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [sbv removeFromSuperview];
        }
        self.tagsDictLock = NO;
        
        
        [viewGroupArray removeObjectAtIndex:index];
        
        if (viewGroupArray.count == 0)
        {
            [self.tagsDict removeObjectForKey:key];
        }
        
    }

    [self setNeedsLayout];
}



-(void)removeViewGroupFrom:(NSInteger)gridTag
{
    if (gridTag == 0)
        return;
    
    if (_tagsDict == nil)
        return;

    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray != nil)
    {
        self.tagsDictLock = YES;
        for (MyViewGroupAndActionData * va in viewGroupArray)
        {
            for (UIView *sbv in va.viewGroup)
            {
                if (sbv != (UIView*)[NSNull null])
                    [sbv removeFromSuperview];
            }
        }
        
        self.tagsDictLock = NO;
        
        [self.tagsDict removeObjectForKey:key];
    }
    
    [self setNeedsLayout];

}



-(void)exchangeViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)gridTag1  withViewGroupAtIndex:(NSUInteger)index2 from:(NSInteger)gridTag2
{
    if (gridTag1 == 0 || gridTag2 == 0)
        return;
    
    NSNumber *key1 = @(gridTag1);
    NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray1 = [self.tagsDict objectForKey:key1];
    
    NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray2 = nil;
    
    if (gridTag1 == gridTag2)
    {
        viewGroupArray2 = viewGroupArray1;
        if (index1 == index2)
            return;
    }
    else
    {
        NSNumber *key2 = @(gridTag2);
        viewGroupArray2 = [self.tagsDict objectForKey:key2];
    }
    
    if (index1 < viewGroupArray1.count && index2 < viewGroupArray2.count)
    {
        self.tagsDictLock = YES;
        
        if (gridTag1 == gridTag2)
        {
            [viewGroupArray1 exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        }
        else
        {
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


-(NSUInteger)viewGroupCountOf:(NSInteger)gridTag
{
    if (gridTag == 0)
        return 0;
    
    if (_tagsDict == nil)
        return 0;
    
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];

    return viewGroupArray.count;
}



-(NSArray<UIView*> *)viewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag
{
    if (gridTag == 0)
        return nil;
    
    if (_tagsDict == nil)
        return nil;

    
    NSNumber *key = @(gridTag);
    NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (index < viewGroupArray.count)
    {
        return viewGroupArray[index].viewGroup;
    }
    
    return nil;
}








#pragma mark -- MyGrid

-(id)actionData
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return lsc.actionData;
}

-(void)setActionData:(id)actionData
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.actionData = actionData;
}

//添加行。返回新的栅格。
-(id<MyGrid>)addRow:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列。返回新的栅格。
-(id<MyGrid>)addCol:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addCol:measure];
    node.superGrid = self;
    return node;
}

-(id<MyGrid>)addRowGrid:(id<MyGrid>)grid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addRowGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<MyGrid>)addColGrid:(id<MyGrid>)grid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addColGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<MyGrid>)addRowGrid:(id<MyGrid>)grid measure:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addRowGrid:grid measure:measure];
    node.superGrid = self;
    return node;

}

-(id<MyGrid>)addColGrid:(id<MyGrid>)grid measure:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    id<MyGridNode> node = (id<MyGridNode>)[lsc addColGrid:grid measure:measure];
    node.superGrid = self;
    return node;

}



-(id<MyGrid>)cloneGrid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc cloneGrid];
}

-(void)removeFromSuperGrid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc removeFromSuperGrid];
    
}

-(id<MyGrid>)superGrid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;

    return lsc.superGrid;
}

-(void)setSuperGrid:(id<MyGridNode>)superGrid
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.superGrid = superGrid;
}

-(BOOL)placeholder
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    
    return lsc.placeholder;
}

-(void)setPlaceholder:(BOOL)placeholder
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.placeholder = placeholder;
}


-(BOOL)anchor
{
    
    MyGridLayout *lsc = self.myCurrentSizeClass;
    
    return lsc.anchor;
}

-(void)setAnchor:(BOOL)anchor
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.anchor = anchor;
}

-(MyGravity)overlap
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    
    return lsc.overlap;
}

-(void)setOverlap:(MyGravity)overlap
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.overlap = overlap;
}

-(NSDictionary*)gridDictionary
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return lsc.gridDictionary;
}


-(void)setGridDictionary:(NSDictionary *)gridDictionary
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.gridDictionary = gridDictionary;
}


#pragma mark -- MyGridNode


-(NSMutableArray<id<MyGridNode>> *)subGrids
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return (NSMutableArray<id<MyGridNode>> *)(lsc.subGrids);
}

-(void)setSubGrids:(NSMutableArray<id<MyGridNode>> *)subGrids
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.subGrids = subGrids;
}

-(MySubGridsType)subGridsType
{
    MyGridLayout *lsc = self.myCurrentSizeClass;

    return lsc.subGridsType;
}

-(void)setSubGridsType:(MySubGridsType)subGridsType
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.subGridsType = subGridsType;
}


-(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return lsc.measure;
}

-(void)setMeasure:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.measure = measure;
}

-(CGRect)gridRect
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return lsc.gridRect;
}

-(void)setGridRect:(CGRect)gridRect
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    lsc.gridRect = gridRect;
}

//更新格子尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<MyGridNode>)superGrid withMeasure:(CGFloat)measure
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<MyGridNode>)superGrid withOffset:(CGFloat)offset
{
    MyGridLayout *lsc = self.myCurrentSizeClass;

    return [lsc updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}



-(UIView*)gridLayoutView
{
    return self;
}

-(SEL)gridAction
{
    return nil;
}

-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    [lsc setBorderlineNeedLayoutIn:rect withLayer:layer];

}

-(void)showBorderline:(BOOL)show
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    [lsc showBorderline:show];

}

-(id<MyGrid>)gridHitTest:(CGPoint)point
{
    MyGridLayout *lsc = self.myCurrentSizeClass;
    return [lsc gridHitTest:point];
}


#pragma mark -- Touches Event

-(id<MyGridNode>)myBestHitGrid:(NSSet *)touches
{
    MySizeClass sizeClass = [self myGetGlobalSizeClass];
    id<MyGridNode> bestSC = (id<MyGridNode>)[self myBestSizeClass:sizeClass];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return  [bestSC gridHitTest:point];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [[self myBestHitGrid:touches] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myBestHitGrid:touches] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myBestHitGrid:touches] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myBestHitGrid:touches] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}



#pragma mark -- Override Methods

-(void)dealloc
{
    //这里提前释放所有的数据，防止willRemoveSubview中重复删除。。
    _tagsDict = nil;
}

-(void)removeAllSubviews
{
    _tagsDict = nil;  //提前释放所有绑定的数据
    [super removeAllSubviews];
}

-(void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    
    //如果子试图在样式里面则从样式里面删除
    if (_tagsDict != nil && !self.tagsDictLock)
    {
        [_tagsDict enumerateKeysAndObjectsUsingBlock:^(id   key, id   obj, BOOL *  stop) {
            
            NSMutableArray *viewGroupArray = (NSMutableArray*)obj;
            NSInteger sbsCount = viewGroupArray.count;
            for (NSInteger j = 0; j < sbsCount; j++)
            {
                MyViewGroupAndActionData *va = viewGroupArray[j];
                NSInteger sbvCount = va.viewGroup.count;
                for (NSInteger i = 0; i < sbvCount; i++)
                {
                    if (va.viewGroup[i] == subview)
                    {
                        [va.viewGroup removeObjectAtIndex:i];
                        break;
                        *stop = YES;
                    }
                }
                
                if (va.viewGroup.count == 0)
                {
                    [viewGroupArray removeObjectAtIndex:j];
                    break;
                }
                
                if (*stop)
                    break;
            }
            
            
        }];
    }
}


-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    
    MyFrame *myFrame = self.myFrame;
    
    MyGridLayout *lsc =  [self myCurrentSizeClassFrom:myFrame];
    
    //只有在非评估，并且当sizeclass的数量大于1个，并且当前的sizeclass和lastSizeClass不一致的时候
    if (!isEstimate && myFrame.multiple)
    {
        //将子栅格中的layer隐藏。
        if (self.lastSizeClass != nil && ((MyGridLayoutViewSizeClass*)lsc) != self.lastSizeClass)
            [((id<MyGridNode>)self.lastSizeClass) showBorderline:NO];
        
        self.lastSizeClass = (MyGridLayoutViewSizeClass*)lsc;
    }
    
    
    //设置根格子的rect为布局视图的大小。
    lsc.gridRect = CGRectMake(0, 0, selfSize.width, selfSize.height);
    
    
    NSMutableDictionary *tagKeyIndexDict = [NSMutableDictionary dictionaryWithCapacity:self.tagsDict.count];
    for (NSNumber *key in self.tagsDict)
    {
        [tagKeyIndexDict setObject:@(0) forKey:key];
    }
    
    //遍历尺寸
    NSInteger index = 0;
    CGFloat selfMeasure = [self myTraversalGridSize:lsc gridSize:selfSize lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagKeyIndexDict tagViewGroup:nil pTagIndex:nil];
    if (lsc.wrapContentHeight)
    {
        selfSize.height =  selfMeasure;
    }
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = selfMeasure;
    }
    
    //遍历位置。
    for (NSNumber *key in self.tagsDict)
    {
        [tagKeyIndexDict setObject:@(0) forKey:key];
    }
    
    NSEnumerator<UIView*> *enumerator = sbs.objectEnumerator;
    [self myTraversalGridOrigin:lsc gridOrigin:CGPointMake(0, 0) lsc:lsc sbvEnumerator:enumerator tagViewGroupIndexDict:tagKeyIndexDict tagSbvEnumerator:nil  isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    
    
    //遍历那些还剩余的然后设置为0.
    [tagKeyIndexDict enumerateKeysAndObjectsUsingBlock:^(id key, NSNumber *viewGroupIndexNumber, BOOL *  stop) {
        
        NSArray<MyViewGroupAndActionData*> *viewGroupArray = self.tagsDict[key];
        NSInteger viewGroupIndex = viewGroupIndexNumber.integerValue;
        for (NSInteger i = viewGroupIndex; i < viewGroupArray.count; i++)
        {
            MyViewGroupAndActionData *va = viewGroupArray[i];
            for (UIView *sbv in va.viewGroup)
            {
                if (sbv != (UIView*)[NSNull null])
                {
                    sbv.myFrame.frame = CGRectZero;
                    
                    //这里面让所有视图的枚举器也走一遍，解决下面的重复设置的问题。
                    UIView *anyway = enumerator.nextObject;
                    anyway = nil;  //防止有anyway编译告警而设置。
                }
            }
        }
    }];
    
    
    //处理那些剩余没有放入格子的子视图的frame设置为0
    for (UIView *sbv = enumerator.nextObject; sbv; sbv = enumerator.nextObject)
    {
        sbv.myFrame.frame = CGRectZero;
    }
    
    
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    [self myAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [MyGridLayoutViewSizeClass new];
}

#pragma mark -- Private Methods

//遍历位置
-(void)myTraversalGridOrigin:(id<MyGridNode>)grid  gridOrigin:(CGPoint)gridOrigin lsc:(MyGridLayout*)lsc sbvEnumerator:(NSEnumerator<UIView*>*)sbvEnumerator tagViewGroupIndexDict:(NSMutableDictionary*)tagViewGroupIndexDict tagSbvEnumerator:(NSEnumerator<UIView*>*)tagSbvEnumerator isEstimate:(BOOL)isEstimate sizeClass:(MySizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout
{
    //这要优化减少不必要的空数组的建立。。
    NSArray<id<MyGridNode>> * subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown)
         subGrids = grid.subGrids;

    //绘制边界线。。
    if (!isEstimate)
    {
        [grid setBorderlineNeedLayoutIn:grid.gridRect withLayer:self.layer];
    }
    
    
    if (grid.tag != 0)
    {
        NSNumber *key = @(grid.tag);

        NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
        NSNumber *viewGroupIndex = [tagViewGroupIndexDict objectForKey:key];
        if (viewGroupArray != nil && viewGroupIndex != nil)
        {
            if (viewGroupIndex.integerValue < viewGroupArray.count)
            {
                //这里将动作的数据和栅格进行关联。
                grid.actionData = viewGroupArray[viewGroupIndex.integerValue].actionData;
                
                tagSbvEnumerator =  viewGroupArray[viewGroupIndex.integerValue].viewGroup.objectEnumerator;
                [tagViewGroupIndexDict setObject:@(viewGroupIndex.integerValue + 1) forKey:key];
            }
            else
            {
                grid.actionData = nil;
                tagSbvEnumerator = nil;
                sbvEnumerator = nil;
            }
        }
        else
        {
            tagSbvEnumerator = nil;
        }
    }

    CGFloat paddingTop;
    CGFloat paddingLeading;
    CGFloat paddingBottom;
    CGFloat paddingTrailing;
    if (grid == lsc)
    {
        paddingTop = lsc.myLayoutTopPadding;
        paddingLeading = lsc.myLayoutLeadingPadding;
        paddingBottom = lsc.myLayoutBottomPadding;
        paddingTrailing = lsc.myLayoutTrailingPadding;
    }
    else
    {
        UIEdgeInsets gridPadding = grid.padding;
        paddingTop = gridPadding.top;
        paddingLeading = [MyBaseLayout isRTL] ? gridPadding.right : gridPadding.left;
        paddingBottom = gridPadding.bottom;
        paddingTrailing = [MyBaseLayout isRTL] ? gridPadding.left : gridPadding.right;
    }
    
    //处理叶子节点。
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        //设置子视图的位置和尺寸。。
        UIView *sbv = nil;
        UIView *tagSbv = tagSbvEnumerator.nextObject;

        if (tagSbv != (UIView*)[NSNull null])
             sbv = sbvEnumerator.nextObject;
        
        if (tagSbv != nil && tagSbv != (UIView*)[NSNull null] && tagSbvEnumerator != nil)
            sbv = tagSbv;
        
        if (sbv != nil)
        {
            //调整位置和尺寸。。。
            MyFrame *sbvmyFrame = sbv.myFrame;
            
            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
            
            //取垂直和水平对齐
            MyGravity vertGravity = grid.gravity & MyGravity_Horz_Mask;
            if (vertGravity == MyGravity_None)
                vertGravity = MyGravity_Vert_Fill;
            
            MyGravity horzGravity = grid.gravity & MyGravity_Vert_Mask;
            if (horzGravity == MyGravity_None)
                horzGravity = MyGravity_Horz_Fill;
            else
                horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:horzGravity];
            
            
            //如果非叶子栅格设置为anchor则子视图的内容总是填充的
            CGFloat tempPaddingTop = paddingTop;
            CGFloat tempPaddingLeading = paddingLeading;
            CGFloat tempPaddingBottom = paddingBottom;
            CGFloat tempPaddingTrailing = paddingTrailing;
            
            if (grid.anchor && subGrids.count > 0)
            {
                vertGravity = MyGravity_Vert_Fill;
                horzGravity = MyGravity_Horz_Fill;
                tempPaddingTop = 0;
                tempPaddingLeading = 0;
                tempPaddingBottom = 0;
                tempPaddingTrailing = 0;
            }

            //如果是尺寸为0，并且设置为了anchor的话那么就根据自身
            
            //如果尺寸是0则因为前面有算出尺寸，所以这里就不进行调整了。
            if (grid.measure != 0 && [sbv isKindOfClass:[MyBaseLayout class]])
            {
                [self myAdjustSubviewWrapContentSet:sbv isEstimate:isEstimate sbvmyFrame:sbvmyFrame sbvsc:sbvsc selfSize:grid.gridRect.size sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
            }
            else
            {
            }
            
            [self myCalcSubViewRect:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame lsc:lsc vertGravity:vertGravity horzGravity:horzGravity inSelfSize:grid.gridRect.size paddingTop:tempPaddingTop paddingLeading:tempPaddingLeading paddingBottom:tempPaddingBottom paddingTrailing:tempPaddingTrailing pMaxWrapSize:NULL];
            
            sbvmyFrame.leading += gridOrigin.x;
            sbvmyFrame.top += gridOrigin.y;
            
        }
    }



    //处理子格子的位置。
    
    CGFloat offset = 0;
    if (grid.subGridsType == MySubGridsType_Col)
    {
        offset = gridOrigin.x + paddingLeading;
        
        MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:grid.gravity & MyGravity_Vert_Mask];
        if (horzGravity == MyGravity_Horz_Center || horzGravity == MyGravity_Horz_Trailing)
        {
            //得出所有子栅格的宽度综合
            CGFloat subGridsWidth = 0;
            for (id<MyGridNode> sbvGrid in subGrids)
            {
                subGridsWidth += sbvGrid.gridRect.size.width;
            }
            
            if (subGrids.count > 1)
                subGridsWidth += grid.subviewSpace * (subGrids.count - 1);

            
            if (horzGravity == MyGravity_Horz_Center)
            {
                offset += (grid.gridRect.size.width - paddingLeading - paddingTrailing - subGridsWidth)/2;
            }
            else
            {
                offset += grid.gridRect.size.width - paddingLeading - paddingTrailing - subGridsWidth;
            }
        }
        
        
    }
    else if (grid.subGridsType == MySubGridsType_Row)
    {
        offset = gridOrigin.y + paddingTop;
        
        MyGravity vertGravity = grid.gravity & MyGravity_Horz_Mask;
        if (vertGravity == MyGravity_Vert_Center || vertGravity == MyGravity_Vert_Bottom)
        {
            //得出所有子栅格的宽度综合
            CGFloat subGridsHeight = 0;
            for (id<MyGridNode> sbvGrid in subGrids)
            {
                subGridsHeight += sbvGrid.gridRect.size.height;
            }
            
            if (subGrids.count > 1)
                subGridsHeight += grid.subviewSpace * (subGrids.count - 1);
            
            if (vertGravity == MyGravity_Vert_Center)
            {
                offset += (grid.gridRect.size.height - paddingTop - paddingBottom - subGridsHeight)/2;
            }
            else
            {
                offset += grid.gridRect.size.height - paddingTop - paddingBottom - subGridsHeight;
            }
        }
        
    }
    else
    {
        
    }
    
    

    CGPoint paddingGridOrigin = CGPointMake(gridOrigin.x + paddingLeading, gridOrigin.y + paddingTop);
    for (id<MyGridNode> sbvGrid in subGrids)
    {
        offset += [sbvGrid updateGridOrigin:paddingGridOrigin superGrid:grid withOffset:offset];
        offset += grid.subviewSpace;
        [self myTraversalGridOrigin:sbvGrid gridOrigin:sbvGrid.gridRect.origin lsc:lsc sbvEnumerator:sbvEnumerator tagViewGroupIndexDict:tagViewGroupIndexDict tagSbvEnumerator:((sbvGrid.tag != 0)? nil: tagSbvEnumerator) isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    }
    
    //如果栅格中的tagSbvEnumerator还有剩余的视图没有地方可填，那么就将尺寸和位置设置为0
    if (grid.tag != 0)
    {
        //枚举那些剩余的
        for (UIView *sbv = tagSbvEnumerator.nextObject; sbv; sbv = tagSbvEnumerator.nextObject)
        {
            if (sbv != (UIView*)[NSNull null])
            {
                sbv.myFrame.frame = CGRectZero;
                
                //所有子视图枚举器也要移动。
                UIView *anyway = sbvEnumerator.nextObject;
                anyway = nil;
            }
        }
    }
    
 }

-(void)myBlankTraverse:(id<MyGridNode>)grid sbs:(NSArray<UIView*>*)sbs pIndex:(NSInteger*)pIndex tagSbs:(NSArray<UIView*> *)tagSbs pTagIndex:(NSInteger*)pTagIndex
{
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown)
        subGrids = grid.subGrids;
    
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        BOOL isNoNullSbv = YES;
        if (grid.tag == 0 && pTagIndex != NULL)
        {
            *pTagIndex = *pTagIndex + 1;
            
            if (tagSbs != nil && *pTagIndex < tagSbs.count && tagSbs[*pTagIndex] == (UIView*)[NSNull null])
                isNoNullSbv = NO;
        }
        
        if (isNoNullSbv)
            *pIndex = *pIndex + 1;

    }
    
    for (id<MyGridNode> sbvGrid in subGrids)
    {
        [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagSbs pTagIndex:(grid.tag != 0)? NULL : pTagIndex];
    }
}

//遍历尺寸。
-(CGFloat)myTraversalGridSize:(id<MyGridNode>)grid gridSize:(CGSize)gridSize lsc:(MyGridLayout*)lsc sbs:(NSArray<UIView*>*)sbs pIndex:(NSInteger*)pIndex tagViewGroupIndexDict:(NSMutableDictionary*)tagViewGroupIndexDict  tagViewGroup:(NSArray<UIView*>*)tagViewGroup  pTagIndex:(NSInteger*)pTagIndex
{
    NSArray<id<MyGridNode>> *subGrids = nil;
    if (grid.subGridsType != MySubGridsType_Unknown)
         subGrids = grid.subGrids;
    
    
    CGFloat paddingTop;
    CGFloat paddingLeading;
    CGFloat paddingBottom;
    CGFloat paddingTrailing;
    if (grid == lsc)
    {
        paddingTop = lsc.myLayoutTopPadding;
        paddingLeading = lsc.myLayoutLeadingPadding;
        paddingBottom = lsc.myLayoutBottomPadding;
        paddingTrailing = lsc.myLayoutTrailingPadding;
    }
    else
    {
        UIEdgeInsets gridPadding = grid.padding;
        paddingTop = gridPadding.top;
        paddingLeading = [MyBaseLayout isRTL] ? gridPadding.right : gridPadding.left;
        paddingBottom = gridPadding.bottom;
        paddingTrailing = [MyBaseLayout isRTL] ? gridPadding.left : gridPadding.right;
    }

    CGFloat fixedMeasure = 0;  //固定部分的尺寸
    CGFloat validMeasure = 0;  //整体有效的尺寸
    if (subGrids.count > 1)
        fixedMeasure += (subGrids.count - 1) * grid.subviewSpace;
    
    if (grid.subGridsType == MySubGridsType_Col)
    {
        fixedMeasure += paddingLeading + paddingTrailing;
        validMeasure = grid.gridRect.size.width - fixedMeasure;
    }
    else if(grid.subGridsType == MySubGridsType_Row)
    {
        fixedMeasure += paddingTop + paddingBottom;
        validMeasure = grid.gridRect.size.height - fixedMeasure;
    }
    else;
    
    
    //得到匹配的form
    if (grid.tag != 0)
    {
        NSNumber *key = @(grid.tag);
        NSMutableArray<MyViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
        NSNumber *viewGroupIndex = [tagViewGroupIndexDict objectForKey:key];
        if (viewGroupArray != nil && viewGroupIndex != nil)
        {
            if (viewGroupIndex.integerValue < viewGroupArray.count)
            {
                tagViewGroup = viewGroupArray[viewGroupIndex.integerValue].viewGroup;
                NSInteger tagIndex = 0;
                pTagIndex = &tagIndex;
                [tagViewGroupIndexDict setObject:@(viewGroupIndex.integerValue + 1) forKey:key];
            }
            else
            {
                tagViewGroup = nil;
                pTagIndex = NULL;
                sbs = nil;
            }
        }
        else
        {
            tagViewGroup = nil;
            pTagIndex = NULL;
        }
    }

    
    //叶子节点
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        BOOL isNotNullSbv = YES;
        NSArray *tempSbs = sbs;
        NSInteger *pTempIndex = pIndex;
        
        if (tagViewGroup != nil && pTagIndex != NULL)
        {
            tempSbs = tagViewGroup;
            pTempIndex = pTagIndex;
        }
        
        //如果尺寸是包裹
        if (grid.measure == MyLayoutSize.wrap ||  (grid.measure == 0 && grid.anchor))
        {
            if (*pTempIndex < tempSbs.count)
            {
                //加这个条件是根栅格如果是叶子栅格的话不处理这种情况。
                if (grid.superGrid != nil)
                {
                    UIView *sbv = tempSbs[*pTempIndex];
                    if (sbv != (UIView*)[NSNull null])
                    {
                        
                        //叶子节点
                        if (!grid.anchor || (grid.measure == 0 && grid.anchor))
                        {
                            MyFrame *sbvmyFrame = sbv.myFrame;
                            UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
                            sbvmyFrame.frame = sbv.bounds;
                            
                            //如果子视图不设置任何约束但是又是包裹的则这里特殊处理。
                            if (sbvsc.widthSizeInner == nil && sbvsc.heightSizeInner == nil && !sbvsc.wrapContentSize)
                            {
                                CGSize size = CGSizeZero;
                                if (grid.superGrid.subGridsType == MySubGridsType_Row)
                                {
                                    size.width = gridSize.width - paddingLeading - paddingTrailing;
                                }
                                else
                                {
                                    size.height = gridSize.height - paddingTop - paddingBottom;
                                }
                                
                                size = [sbv sizeThatFits:size];
                                sbvmyFrame.width = size.width;
                                sbvmyFrame.height = size.height;
                            }
                            else
                            {
                                
                                [self myCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame];
                                
                                [self myCalcSubViewRect:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame lsc:lsc vertGravity:MyGravity_None horzGravity:MyGravity_None inSelfSize:grid.gridRect.size paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:NULL];
                            }
                            
                            if (grid.superGrid.subGridsType == MySubGridsType_Row)
                            {
                                fixedMeasure = paddingTop + paddingBottom + sbvmyFrame.height;
                            }
                            else
                            {
                                fixedMeasure = paddingLeading + paddingTrailing + sbvmyFrame.width;
                            }
                        }
                    }
                    else
                        isNotNullSbv = NO;
                }
            }
        }
        
        //索引加1跳转到下一个节点。
        if (tagViewGroup != nil &&  pTagIndex != NULL)
        {
            *pTempIndex = *pTempIndex + 1;
        }
        
        if (isNotNullSbv)
            *pIndex = *pIndex + 1;
    }

    
    if (subGrids.count > 0)
    {
        
        NSMutableArray<id<MyGridNode>> *weightSubGrids = [NSMutableArray new];  //比重尺寸子格子数组
        NSMutableArray<NSNumber*> *weightSubGridsIndexs = [NSMutableArray new]; //比重尺寸格子的开头子视图位置索引
        NSMutableArray<NSNumber*> *weightSubGridsTagIndexs = [NSMutableArray new]; //比重尺寸格子的开头子视图位置索引
        
        
        NSMutableArray<id<MyGridNode>> *fillSubGrids = [NSMutableArray new];    //填充尺寸格子数组
        NSMutableArray<NSNumber*> *fillSubGridsIndexs = [NSMutableArray new];   //填充尺寸格子的开头子视图位置索引
        NSMutableArray<NSNumber*> *fillSubGridsTagIndexs = [NSMutableArray new];   //填充尺寸格子的开头子视图位置索引
        
        
        //包裹尺寸先遍历所有子格子
        CGSize gridSize2 = gridSize;
        if (grid.subGridsType == MySubGridsType_Row)
        {
            gridSize2.width -= (paddingLeading + paddingTrailing);
        }
        else
        {
            gridSize2.height -= (paddingTop + paddingBottom);
        }
        
        for (id<MyGridNode> sbvGrid in subGrids)
        {
            if (sbvGrid.measure == MyLayoutSize.wrap)
            {
                
                CGFloat measure = [self myTraversalGridSize:sbvGrid gridSize:gridSize2 lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid  withMeasure:measure];
                
            }
            else if (sbvGrid.measure >= 1 || sbvGrid.measure == 0)
            {
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:sbvGrid.measure];
                
                //遍历儿子节点。。
                [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
                
            }
            else if (sbvGrid.measure > 0 && sbvGrid.measure < 1)
            {
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:validMeasure * sbvGrid.measure];
                
                //遍历儿子节点。。
                [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
                
            }
            else if (sbvGrid.measure < 0 && sbvGrid.measure > -1)
            {
                [weightSubGrids addObject:sbvGrid];
                [weightSubGridsIndexs addObject:@(*pIndex)];
                
                if (pTagIndex != NULL)
                {
                    [weightSubGridsTagIndexs addObject:@(*pTagIndex)];
                }
                
                //这里面空转一下。
                [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagViewGroup pTagIndex:pTagIndex];
                
                
            }
            else if (sbvGrid.measure == MyLayoutSize.fill)
            {
                [fillSubGrids addObject:sbvGrid];
                
                [fillSubGridsIndexs addObject:@(*pIndex)];
                
                if (pTagIndex != NULL)
                {
                    [fillSubGridsTagIndexs addObject:@(*pTagIndex)];
                }
                
                //这里面空转一下。
                [self myBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagViewGroup pTagIndex:pTagIndex];
            }
            else
            {
                NSAssert(0, @"oops!");
            }
        }
        
        
        //算出剩余的尺寸。
        BOOL hasTagIndex = (pTagIndex != NULL);
        CGFloat remainedMeasure = 0;
        if (grid.subGridsType == MySubGridsType_Col)
        {
            remainedMeasure = grid.gridRect.size.width - fixedMeasure;
        }
        else if (grid.subGridsType == MySubGridsType_Row)
        {
            remainedMeasure = grid.gridRect.size.height - fixedMeasure;
        }
        else;
        
        NSInteger weightSubGridCount = weightSubGrids.count;
        if (weightSubGridCount > 0)
        {
            for (NSInteger i = 0; i < weightSubGridCount; i++)
            {
                id<MyGridNode> sbvGrid = weightSubGrids[i];
                remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:-1 * remainedMeasure * sbvGrid.measure];
                
                NSInteger index = weightSubGridsIndexs[i].integerValue;
                if (hasTagIndex)
                {
                    NSInteger tagIndex = weightSubGridsTagIndexs[i].integerValue;
                    pTagIndex = &tagIndex;
                }
                else
                {
                    pTagIndex = NULL;
                }
                
                [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
            }
        }
        
        NSInteger fillSubGridsCount = fillSubGrids.count;
        if (fillSubGridsCount > 0)
        {
            NSInteger totalCount = fillSubGridsCount;
            for (NSInteger i = 0; i < fillSubGridsCount; i++)
            {
                id<MyGridNode> sbvGrid = fillSubGrids[i];
                remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:_myCGFloatRound(remainedMeasure * (1.0/totalCount))];
                totalCount -= 1;
                
                NSInteger index = fillSubGridsIndexs[i].integerValue;
                
                if (hasTagIndex)
                {
                    NSInteger tagIndex = fillSubGridsTagIndexs[i].integerValue;
                    pTagIndex = &tagIndex;
                }
                else
                {
                    pTagIndex = nil;
                }
                
                [self myTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
            }
        }
    }
    return fixedMeasure;
}


@end

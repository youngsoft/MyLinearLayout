//
//  MyPathLayout.m
//  MyLayout
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyPathLayout.h"
#import "MyLayoutInner.h"


@implementation MyPathSpace

-(id)initWithType:(MyPathSpaceType)type value:(CGFloat)value
{
    self = [super init];
    if (self != nil)
    {
        _type = type;
        _value = value;
    }
    
    return self;
}

//浮动距离，根据布局视图的尺寸和子视图的数量动态决定
+(id)flexed
{
    return [[self alloc] initWithType:MyPathSpace_Flexed value:0];
}

//固定距离，len为长度，每个子视图之间的距离都是len
+(id)fixed:(CGFloat)len
{
    return [[self alloc] initWithType:MyPathSpace_Fixed value:len];
}

//数量距离，根据布局视图的尺寸和指定的数量动态决定。
+(id)count:(NSInteger)count
{
    return [[self alloc] initWithType:MyPathSpace_Count value:count];
}



@end


@implementation MyCoordinateSetting
{
    __weak MyPathLayout *_pathLayout;
}

-(id)initWithPathLayout:(MyPathLayout*)pathLayout
{
    self = [super init];
    if (self != nil)
    {
        _pathLayout = pathLayout;
        _start = -CGFLOAT_MAX;
        _end =  CGFLOAT_MAX;
    }
    
    return self;
}

-(void)setIsMath:(BOOL)isMath
{
    if (_isMath != isMath)
    {
        _isMath = isMath;
        [_pathLayout setNeedsLayout];
    }
    
}

-(void)setIsReverse:(BOOL)isReverse
{
    if (_isReverse != isReverse)
    {
        _isReverse = isReverse;
        [_pathLayout setNeedsLayout];
    }
}

-(void)setOrigin:(CGPoint)origin
{
    if (!CGPointEqualToPoint(_origin, origin))
    {
        _origin = origin;
        [_pathLayout setNeedsLayout];
    }
}

-(void)setStart:(CGFloat)start
{
    if (_start != start)
    {
        _start = start;
        [_pathLayout setNeedsLayout];
    }
    
    
}

-(void)setEnd:(CGFloat)end
{
    if (_end != end)
    {
        _end = end;
        [_pathLayout setNeedsLayout];
        
    }
}

-(void)reset
{
    _start = -CGFLOAT_MAX;
    _end =  CGFLOAT_MAX;
    _isMath = NO;
    _isReverse = NO;
    _origin = CGPointZero;
    [_pathLayout setNeedsLayout];
}

@end



@interface MyPathLayout()

@property(nonatomic, strong) NSArray *pathPoints;        //记录路径内所有算出来的点，内容为NSValue(CGPoint)
@property(nonatomic, strong) NSArray *pointIndexs;           //记录每个子视图在pathPoints中的索引位置。内容为NSNumber。比如pathPoints有1000个点，一共有10个子视图那么pointIndexs的长度就是10，每个元素就是在subviewPoints里面的索引。
@property(nonatomic, strong) NSMutableArray *argumentArray;  //记录每个子视图在路径曲线函数中的变量值的数组，数组的内容为NSValue。

@end



@implementation MyPathLayout
{
    MyCoordinateSetting  *_coordinateSetting;
    BOOL _hasOriginView;
    MyPathSpace *_spaceType;
}

/*
+(Class)layerClass
{
    return [CAShapeLayer class];
}
*/

-(MyCoordinateSetting*)coordinateSetting
{
    if (_coordinateSetting == nil)
    {
        _coordinateSetting = [[MyCoordinateSetting alloc] initWithPathLayout:self];
    }
    
    return _coordinateSetting;
}

-(MyPathSpace*)spaceType
{
    if (_spaceType == nil)
    {
        _spaceType = [MyPathSpace flexed];
    }
    
    return _spaceType;
}

-(void)setSpaceType:(MyPathSpace *)spaceType
{
    if (_spaceType != spaceType)
    {
        _spaceType = spaceType;
        
        [self setNeedsLayout];
    }
}

-(void)setRectangularEquation:(CGFloat (^)(CGFloat))rectangularEquation
{
    _rectangularEquation = [rectangularEquation copy];
    _parametricEquation = nil;
    _polarEquation = nil;
    [self setNeedsLayout];
}

-(void)setParametricEquation:(CGPoint (^)(CGFloat))parametricEquation
{
    _parametricEquation = [parametricEquation copy];
    _rectangularEquation = nil;
    _polarEquation = nil;
    [self setNeedsLayout];
}

-(void)setPolarEquation:(CGFloat (^)(CGFloat))polarEquation
{
    _polarEquation = [polarEquation copy];
    _rectangularEquation = nil;
    _parametricEquation = nil;
    [self setNeedsLayout];
}


-(UIView*)originView
{
    if (_hasOriginView && self.subviews.count > 0)
        return self.subviews.lastObject;
    return nil;
}

-(void)setOriginView:(UIView *)originView
{
    if (_hasOriginView)
    {
        if (originView != nil)
        {
            if (self.subviews.count > 0)
            {
                if (self.subviews.lastObject != originView)
                {
                    [self.subviews.lastObject removeFromSuperview];
                    [super addSubview:originView];
                }
                
            }
            else
            {
                [self addSubview:originView];
            }
            
        }
        else
        {
            if (self.subviews.count > 0)
                [self.subviews.lastObject removeFromSuperview];
            
            _hasOriginView = NO;
        }
        
    }
    else
    {
        if (originView != nil)
        {
            [super addSubview:originView];
            _hasOriginView = YES;
        }
    }
}

-(NSArray*)pathSubviews
{
    if (_hasOriginView)
    {
        NSArray *sbs = self.subviews;
        if (sbs.count == 0)
            return sbs;
        
        NSMutableArray *pathsbs = [NSMutableArray arrayWithCapacity:self.subviews.count];
        for (UIView *sbv in sbs)
        {
            if (sbv == sbs.lastObject)
                continue;
            
            [pathsbs addObject:sbv];
        }
        
        return pathsbs;
    }
    else
        return self.subviews;
}

-(NSMutableArray*)argumentArray
{
    if (_argumentArray == nil)
    {
        _argumentArray = [NSMutableArray new];
    }
    
    return _argumentArray;
}

-(CGFloat)argumentFrom:(UIView*)subview
{
    NSUInteger index = [self.subviews indexOfObject:subview];
    if (index == NSNotFound)
        return NAN;
    
    if (self.originView == subview)
        return NAN;
    
    if (index < self.argumentArray.count)
    {
        if (self.polarEquation != nil)
            return [self.argumentArray[index] doubleValue] / 180 * M_PI;
        else
            return [self.argumentArray[index] doubleValue];
    }
    else
        return NAN;
    
}


//开始和结束子视图之间的路径创建
-(void)beginSubviewPathPoint:(BOOL)full
{
    //这里先把所有点都创建出来。
    if (full)
    {
        NSMutableArray *pointIndexs = [NSMutableArray new];
        self.pathPoints = [self myCalcPoints:self.pathSubviews path:nil pointIndexArray:pointIndexs lsc:self.myCurrentSizeClass];
        self.pointIndexs = pointIndexs;
    }
    else
    {
        self.pathPoints = [self myCalcPoints:self.pathSubviews path:nil pointIndexArray:nil lsc:self.myCurrentSizeClass];
        self.pointIndexs = nil;
    }
    
}

-(void)endSubviewPathPoint
{
    self.pathPoints = nil;
    self.pointIndexs = nil;
}

-(NSArray*)getSubviewPathPoint:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (self.pathPoints == nil)
        return nil;
    
    NSInteger realFromIndex = fromIndex;
    NSInteger realToIndex = toIndex;
    
    if (realFromIndex == realToIndex)
        return [NSArray new];
    
    //要求外界传递进来的索引要考虑原点视图的索引。
    NSMutableArray *retPoints = [NSMutableArray new];
    
    if (realFromIndex < realToIndex)
    {
        NSInteger start;
        NSInteger end;
        if (self.pointIndexs == nil)
        {
            start = realFromIndex;
            end = realToIndex;
        }
        else
        {
            start = [self.pointIndexs[realFromIndex] integerValue];
            end = [self.pointIndexs[realToIndex] integerValue];
        }
        
        for (NSInteger i = start; i <= end; i++)
        {
            [retPoints addObject:self.pathPoints[i]];
        }
    }
    else
    {
        NSInteger end = [self.pointIndexs[realFromIndex] integerValue];
        NSInteger start = [self.pointIndexs[realToIndex] integerValue];
        
        for (NSInteger i = end; i >= start; i--)
        {
            [retPoints addObject:self.pathPoints[i]];
        }
    }
    
    return  retPoints;
    
}

-(CGPathRef)createPath:(NSInteger)subviewCount
{
    CGMutablePathRef retPath = CGPathCreateMutable();
    
    if (self.spaceType.type != MyPathSpace_Fixed)
    {
        [self myCalcPathPoints:retPath pPathLen:NULL subviewCount:-1 pointIndexArray:nil viewSpace:0 lsc:self.myCurrentSizeClass];
    }
    else
    {
        if (subviewCount == -1)
            subviewCount = self.pathSubviews.count;
        
        [self myCalcPathPoints:retPath pPathLen:NULL subviewCount:subviewCount pointIndexArray:nil viewSpace:self.spaceType.value lsc:self.myCurrentSizeClass];
    }
    
    return retPath;
    
}

#pragma mark -- Override Method

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    if (self.originView != nil)
    {
        if (index == self.subviews.count)
            index -=1;
    }
    
    [super insertSubview:view atIndex:index];
}

- (void)addSubview:(UIView *)view
{
    if (self.originView != nil)
    {
        [super insertSubview:view atIndex:self.subviews.count - 1];
    }
    else
        [super addSubview:view];
}


- (void)sendSubviewToBack:(UIView *)view
{
    if (self.originView == view)
        return;
    
    [super sendSubviewToBack:view];
    
}


- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    if (_hasOriginView)
    {
        if (self.subviews.count > 0 && subview == self.subviews.lastObject)
        {
            _hasOriginView = NO;
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


 /*
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    
    
    NSArray *sbs = self.pathSubviews;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    MyPathLayout *lsc = self.myCurrentSizeClass;
    
    NSArray *pts = nil;
    if (sbs.count > 0)
    {
        if (self.spaceType.type != MyPathSpace_Fixed)
        {
            CGFloat totalLen = 0;
            NSArray *tempArray = [self myCalcPathPoints:path pPathLen:&totalLen subviewCount:-1 pointIndexArray:nil viewSpace:0 lsc:lsc];
            BOOL bClose = NO;
            if (tempArray.count > 1)
            {
                CGPoint p1 = [tempArray.firstObject CGPointValue];
                CGPoint p2 = [tempArray.lastObject CGPointValue];
                bClose = [self myCalcDistance:p1 with:p2] <=1;
            }
            
            CGFloat viewSpacing = 0;
            NSInteger sbvcount = sbs.count;
            if (self.spaceType.type == MyPathSpace_Count)
                sbvcount = (NSInteger)self.spaceType.value;
            
            if (sbvcount > 1)
            {
                viewSpacing = totalLen / (sbvcount - (bClose ? 0 : 1));
            }
            
            pts = [self myCalcPathPoints:nil pPathLen:NULL subviewCount:sbs.count pointIndexArray:nil viewSpace:viewSpacing lsc:lsc];
            
        }
        else
        {
            pts = [self myCalcPathPoints:path pPathLen:NULL subviewCount:sbs.count pointIndexArray:nil viewSpace:self.spaceType.value lsc:lsc];
        }
    }
 
 
 CGContextAddPath(ctx, path);
 CGContextStrokePath(ctx);
 
 
 for (NSValue *val in pts)
 {
 CGPoint pt2 = val.CGPointValue;
 CGContextStrokeEllipseInRect(ctx, CGRectMake(pt2.x - 4, pt2.y - 4, 8, 8));
 }
 
 }
 
*/



-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    NSArray *sbs2 = sbs;
    
    MyPathLayout *lsc = self.myCurrentSizeClass;
    
    for (UIView *sbv in sbs)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
       
        if (!isEstimate)
        {
            sbvmyFrame.frame = sbv.bounds;
            [self myCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvmyFrame:sbvmyFrame selfLayoutSize:selfSize];
        }
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            
            if (pHasSubLayout != nil && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
                *pHasSubLayout = YES;
            
            if (isEstimate && (sbvsc.wrapContentWidth || sbvsc.wrapContentHeight))
            {
                [(MyBaseLayout*)sbv estimateLayoutRect:sbvmyFrame.frame.size inSizeClass:sizeClass];
                if (sbvmyFrame.multiple)
                {
                    sbvmyFrame.sizeClass = [sbv myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    sbvsc = sbvmyFrame.sizeClass;
                }
            }
        }
    }
    
    
    CGFloat minXPos = CGFLOAT_MAX;
    CGFloat maxXPos = -CGFLOAT_MAX;
    CGFloat minYPos = CGFLOAT_MAX;
    CGFloat maxYPos = -CGFLOAT_MAX;
    
    
    //算路径子视图的。
    sbs = [self myGetLayoutSubviewsFrom:self.pathSubviews];
    
    CGMutablePathRef path = nil;
    if ([self.layer isKindOfClass:[CAShapeLayer class]] && !isEstimate)
    {
        path = CGPathCreateMutable();
    }
    
    NSArray *pts = [self myCalcPoints:sbs path:path pointIndexArray:nil lsc:lsc];
    
    if (path != nil)
    {
        CAShapeLayer *slayer = (CAShapeLayer*)self.layer;
        slayer.path = path;
        CGPathRelease(path);
    }
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
       
        CGPoint pt = CGPointZero;
        if (pts.count > i)
        {
            pt = [pts[i] CGPointValue];
        }
        
        //计算得到最大的高度和最大的宽度。
        
        CGRect rect = sbvmyFrame.frame;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil)
        {
            if (sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner)
            {
                rect.size.width = [sbvsc.widthSizeInner measureWith:(selfSize.width - lsc.leftPadding - lsc.rightPadding) ];
            }
            else
            {
                rect.size.width = [sbvsc.widthSizeInner measureWith: sbvsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width ];
            }
        }
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil)
        {
            if (sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
            {
                rect.size.height = [sbvsc.heightSizeInner measureWith:(selfSize.height - lsc.topPadding - lsc.bottomPadding) ];
            }
            else
            {
                rect.size.height = [sbvsc.heightSizeInner measureWith:sbvsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height ];
            }
        }
        
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        }
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        //中心点的位置。。
        rect.origin.x = pt.x - rect.size.width * sbv.layer.anchorPoint.x - sbvsc.rightPosInner.absVal + sbvsc.leftPosInner.absVal;
        rect.origin.y = pt.y - rect.size.height * sbv.layer.anchorPoint.y - sbvsc.bottomPosInner.absVal + sbvsc.topPosInner.absVal;
        
        if (CGRectGetMinY(rect) < minYPos)
        {
            minYPos = CGRectGetMinY(rect);
        }
        
        if (CGRectGetMaxY(rect) > maxYPos)
        {
            maxYPos = CGRectGetMaxY(rect);
        }
        
        if (CGRectGetMinX(rect) < minXPos)
        {
            minXPos = CGRectGetMinX(rect);
        }
        
        if (CGRectGetMaxX(rect) > maxXPos)
        {
            maxXPos = CGRectGetMaxX(rect);
        }

        
        sbvmyFrame.frame = rect;
        
    }
    
    //特殊填充中心视图。
    UIView *sbv = [self originView];
    if (sbv != nil)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [self myCurrentSizeClassFrom:sbvmyFrame];
        
        CGRect rect = sbvmyFrame.frame;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil)
        {
            if (sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner)
            {
                rect.size.width =  [sbvsc.widthSizeInner measureWith:(selfSize.width - lsc.leftPadding - lsc.rightPadding)];
            }
            else
            {
                rect.size.width = [sbvsc.widthSizeInner measureWith:sbvsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
            }
        }
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil)
        {
            if (sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
            {
                rect.size.height =  [sbvsc.heightSizeInner measureWith:selfSize.height - lsc.topPadding - lsc.bottomPadding];
            }
            else if (sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            {
                rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            }
            else
            {
                rect.size.height = [sbvsc.heightSizeInner measureWith:sbvsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
            }
        }
        
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        }
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算宽度等于高度的情况。
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
        {
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
        }
        
        //位置在原点位置。。
        rect.origin.x = (selfSize.width - lsc.leftPadding - lsc.rightPadding)*self.coordinateSetting.origin.x  - rect.size.width *sbv.layer.anchorPoint.x + sbvsc.leftPosInner.absVal + lsc.leftPadding - sbvsc.rightPosInner.absVal;
        rect.origin.y = (selfSize.height - lsc.topPadding - lsc.bottomPadding)*self.coordinateSetting.origin.y - rect.size.height * sbv.layer.anchorPoint.y + sbvsc.topPosInner.absVal + lsc.topPadding - sbvsc.bottomPosInner.absVal;
        
        if (CGRectGetMinY(rect) < minYPos)
        {
            minYPos = CGRectGetMinY(rect);
        }
        
        if (CGRectGetMaxY(rect) > maxYPos)
        {
            maxYPos = CGRectGetMaxY(rect);
        }
        
        if (CGRectGetMinX(rect) < minXPos)
        {
            minXPos = CGRectGetMinX(rect);
        }
        
        if (CGRectGetMaxX(rect) > maxXPos)
        {
            maxXPos = CGRectGetMaxX(rect);
        }
        
        sbvmyFrame.frame = rect;
        
    }
    
    if (minYPos == CGFLOAT_MAX)
    {
        minYPos = 0;
    }
    
    if (maxYPos == -CGFLOAT_MAX)
    {
        maxYPos = lsc.topPadding + lsc.bottomPadding;
    }
    
    if (minXPos == CGFLOAT_MAX)
    {
        minXPos = 0;
    }
    
    if (maxXPos == -CGFLOAT_MAX)
    {
        maxXPos = lsc.leftPadding + lsc.rightPadding;
    }

    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = maxXPos - minXPos;
    }
    
    if (lsc.wrapContentHeight)
    {
        selfSize.height = maxYPos - minYPos;
    }
    
    //调整布局视图自己的尺寸。
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    
    //路径布局不支持RTL。
   // [self myAdjustSubviewsRTLPos:sbs2 selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs2 lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [MyPathLayoutViewSizeClass new];
}



#pragma mark -- Private Method


-(CGFloat)myCalcDistance:(CGPoint)pt1 with:(CGPoint)pt2
{
    return sqrt(pow(pt1.x - pt2.x, 2) + pow(pt1.y - pt2.y, 2));
}


-(CGPoint)myGetNearestDistancePoint:(CGFloat)startArg lastXY:(CGPoint)lastXY distance:(CGFloat)distance viewSpace:(CGFloat)viewSpace pLastValidArg:(CGFloat*)pLastValidArg func:(CGPoint (^)(CGFloat))func
{
    
    //判断pLastValidArg和Arg的差距如果超过1则按pLastValidArg + 1作为开始计算的变量。
    if (startArg - *pLastValidArg > 1)
        startArg = *pLastValidArg + 1;
    
    CGFloat step = 1;
    while(true)
    {
        
        CGFloat arg = startArg - step + step/10;
        while (arg - startArg < 0.0001)
        {
            
            CGPoint realXY = func(arg);
            if (!isnan(realXY.x) && !isnan(realXY.y))
            {
                CGFloat oldDistance = distance;
                distance +=  [self myCalcDistance:realXY with:lastXY];
                if ( _myCGFloatGreatOrEqual(distance, viewSpace))
                {
                    if (_myCGFloatLessOrEqual(distance - viewSpace, self.distanceError))
                    {
                        *pLastValidArg = arg;
                        return realXY;
                    }
                    else
                    {
                        distance = oldDistance;
                        break;
                    }
                }
                
                lastXY = realXY;
            }
            else
            {
            }
            
            arg += step / 10;
        }
        
        if (arg > startArg)
        {
            startArg += 1;
            step = 1;
        }
        else
        {
            startArg = arg;
            step /= 10;
        }
        if (_myCGFloatLessOrEqual(step, 0.001))
        {
            *pLastValidArg = arg;            
            break;
        }
    }
    
    return lastXY;
    
}


-(void)myCalcPathPointsHelper:(NSMutableArray*)pathPointArray
                   showPath:(CGMutablePathRef)showPath
                  pPathLen:(CGFloat*)pPathLen
               subviewCount:(NSInteger)subviewCount
            pointIndexArray:(NSMutableArray*)pointIndexArray
                viewSpace:(CGFloat)viewSpace
                   startArg:(CGFloat)startArg    //定义域最小值
                     endArg:(CGFloat)endArg      //定义域最大值
                       func:(CGPoint (^)(CGFloat))func
{
    
    if (self.distanceError <= 0)
        self.distanceError = 0.5;
    
    [self.argumentArray removeAllObjects];
    
    CGFloat distance = 0;
    CGPoint lastXY = CGPointZero;
    
    CGFloat arg = startArg;
    CGFloat lastValidArg = arg;
    
    //曲线有可能不是连续的，因此这两个标志用来记录是否某段曲线的开始标志以及曲线的段数
    BOOL isSegmentStart = YES;
    int segmentCount = 0;
    while (true)
    {
        
        if (subviewCount < 0)
        {
            //如果曲线变量超过了定义域则退出。
            if (arg - endArg > 0.1)  //这里不能用arg > endArg 的原因是有精度问题。
            {
                break;
            }
        }
        else if (subviewCount == 0)
        {
            break;
        }
        else
        {
            if (isSegmentStart && segmentCount >= 1)
            {
                if (pointIndexArray != nil)
                    [pointIndexArray addObject:@(pathPointArray.count)];
                
                [pathPointArray addObject:[NSValue valueWithCGPoint:lastXY]];
                
                [self.argumentArray addObject:@(arg)];
                
                if (showPath != nil)
                {
                    CGPathAddLineToPoint(showPath, NULL, lastXY.x, lastXY.y);
                }
                break;
            }
            
        }
        
        CGPoint realXY = func(arg);
        if (!isnan(realXY.x) && !isnan(realXY.y))
        {
            if (isSegmentStart)
            {
                
                isSegmentStart = NO;
                segmentCount += 1;
                if (subviewCount > 0 && segmentCount == 1)
                {
                    subviewCount -=1;
                    lastValidArg = arg;
                    
                    if (pointIndexArray != nil)
                        [pointIndexArray addObject:@(pathPointArray.count)];
                    
                    [self.argumentArray addObject:@(arg)];
                }
                
                [pathPointArray addObject:[NSValue valueWithCGPoint:realXY]];
                
                if (showPath != nil)
                {
                    CGPathMoveToPoint(showPath,NULL, realXY.x, realXY.y);
                }
                
                
            }
            else
            {
                if (subviewCount >= 0)
                {
                    //点的距离累加
                    CGFloat oldDistance = distance;
                    distance += [self myCalcDistance:realXY with:lastXY];
                    if (_myCGFloatGreatOrEqual(distance, viewSpace) )
                    {//如果距离超过间距。则需要缩小自变量步长。以便达到最小的间距误差
                        if (_myCGFloatGreatOrEqual(distance - viewSpace, self.distanceError) )
                        {
                            realXY = [self myGetNearestDistancePoint:arg lastXY:lastXY distance:oldDistance viewSpace:viewSpace pLastValidArg:&lastValidArg func:func];
                        }
                        else
                        {
                            lastValidArg = arg;
                        }
                        
                        if (pointIndexArray == nil)
                            [pathPointArray addObject:[NSValue valueWithCGPoint:realXY]];
                        else
                            [pointIndexArray addObject:@(pathPointArray.count)];
                        
                        distance = 0;
                        subviewCount -=1;
                        [self.argumentArray addObject:@(lastValidArg)];
                        
                    }
                    else if (distance - viewSpace > -1 * self.distanceError)
                    {//如果距离和间距小于误差则认为是一个视图可以存放的点。
                        if (pointIndexArray == nil)
                            [pathPointArray addObject:[NSValue valueWithCGPoint:realXY]];
                        else
                            [pointIndexArray addObject:@(pathPointArray.count)];
                        
                        distance = 0;
                        subviewCount -=1;
                        lastValidArg = arg;
                        [self.argumentArray addObject:@(arg)];
                    }
                    else
                    {
                        lastValidArg = arg;
                    }
                }
                else
                {
                    if (pointIndexArray == nil)
                        [pathPointArray addObject:[NSValue valueWithCGPoint:realXY]];
                }
                
                if (pointIndexArray != nil)
                    [pathPointArray addObject:[NSValue valueWithCGPoint:realXY]];
                
                
                if (showPath != nil)
                {
                    CGPathAddLineToPoint(showPath,NULL, realXY.x, realXY.y);
                }
                
                if (pPathLen != NULL)
                {
                    *pPathLen +=  [self myCalcDistance:realXY with:lastXY];
                }
            }
            
            lastXY = realXY;
        }
        else
        {//只要自变量和因变量是无效值，则认为是一个新的段的开始。
            isSegmentStart = YES;
        }
        arg += 1;
    }
    
    
}


/**
 计算曲线路径

 @param showPath 将计算的路径保存到showPath中，可选参数
 @param pPathLen 返回路径的总长度
 @param subviewCount 子视图的数量，如果为-1则表示只计算路径的长度不会把每个子视图所在的路径点索引保存
 @param pointIndexArray 返回所有子视图在路径点的索引
 @param viewSpace 子视图之间的间距
 @param lsc lsc
 @return 返回所有路径点
 */
-(NSArray*)myCalcPathPoints:(CGMutablePathRef)showPath
                pPathLen:(CGFloat*)pPathLen
             subviewCount:(NSInteger)subviewCount
          pointIndexArray:(NSMutableArray*)pointIndexArray
              viewSpace:(CGFloat)viewSpace
                        lsc:(MyPathLayout*)lsc
{
    NSMutableArray *pathPointArray = [NSMutableArray new];
    
    CGFloat selfWidth = CGRectGetWidth(self.bounds) - lsc.leftPadding - lsc.rightPadding;
    CGFloat selfHeight = CGRectGetHeight(self.bounds) - lsc.topPadding - lsc.bottomPadding;
    
    CGFloat startArg;
    CGFloat endArg;
    
    if (self.rectangularEquation != nil)
    {
        startArg = 0 - selfWidth * self.coordinateSetting.origin.x;
        if (self.coordinateSetting.isReverse)
        {
            if (self.coordinateSetting.isMath)
                startArg = -1 * selfHeight *(1 - self.coordinateSetting.origin.y);
            else
                startArg = selfHeight *(0 - self.coordinateSetting.origin.y);
        }
        
        if (self.coordinateSetting.start != -CGFLOAT_MAX)
            startArg = self.coordinateSetting.start;
        
        endArg = selfWidth - selfWidth * self.coordinateSetting.origin.x;
        if (self.coordinateSetting.isReverse)
        {
            if (self.coordinateSetting.isMath)
                endArg = -1 * selfHeight *(0 - self.coordinateSetting.origin.y);
            else
                endArg = selfHeight *(1 - self.coordinateSetting.origin.y);
        }
        if (self.coordinateSetting.end != CGFLOAT_MAX)
            endArg = self.coordinateSetting.end;
        
        [self myCalcPathPointsHelper:pathPointArray showPath:showPath pPathLen:pPathLen subviewCount:subviewCount pointIndexArray:pointIndexArray viewSpace:viewSpace startArg:startArg endArg:endArg func:^(CGFloat arg){
            
            CGFloat val = self.rectangularEquation(arg);
            if (!isnan(val))
            {
                if (self.coordinateSetting.isReverse)
                {
                    return CGPointMake(val + selfWidth * self.coordinateSetting.origin.x + lsc.leftPadding,
                                       (self.coordinateSetting.isMath ? -arg : arg) + selfHeight * self.coordinateSetting.origin.y + lsc.topPadding);
                    
                }
                else
                {
                    return CGPointMake(arg + selfWidth * self.coordinateSetting.origin.x + lsc.leftPadding,
                                       (self.coordinateSetting.isMath ? -val : val) + selfHeight * self.coordinateSetting.origin.y + lsc.topPadding);
                    
                }
            }
            else
                return CGPointMake(NAN, NAN);
            
        }];
    }
    else if (self.parametricEquation != nil)
    {
        startArg = 0 - selfWidth * self.coordinateSetting.origin.x;
        if (self.coordinateSetting.isReverse)
        {
            if (self.coordinateSetting.isMath)
                startArg = -1 * selfHeight *(1 - self.coordinateSetting.origin.y);
            else
                startArg = selfHeight *(0 - self.coordinateSetting.origin.y);
        }
        if (self.coordinateSetting.start != -CGFLOAT_MAX)
            startArg = self.coordinateSetting.start;
        
        endArg = selfWidth - selfWidth * self.coordinateSetting.origin.x;
        if (self.coordinateSetting.isReverse)
        {
            if (self.coordinateSetting.isMath)
                endArg = -1 * selfHeight *(0 - self.coordinateSetting.origin.y);
            else
                endArg = selfHeight *(1 - self.coordinateSetting.origin.y);
        }
        if (self.coordinateSetting.end != CGFLOAT_MAX)
            endArg = self.coordinateSetting.end;
        
        [self myCalcPathPointsHelper:pathPointArray showPath:showPath pPathLen:pPathLen subviewCount:subviewCount pointIndexArray:pointIndexArray  viewSpace:viewSpace startArg:startArg endArg:endArg func:^(CGFloat arg){
            
            CGPoint val = self.parametricEquation(arg);
            if (!isnan(val.x) && !isnan(val.y))
            {
                if (self.coordinateSetting.isReverse)
                {
                    return CGPointMake(val.y + selfWidth * self.coordinateSetting.origin.x + lsc.leftPadding,
                                       (self.coordinateSetting.isMath ? -val.x : val.x) + selfHeight * self.coordinateSetting.origin.y + lsc.topPadding);
                    
                }
                else
                {
                    return CGPointMake(val.x + selfWidth * self.coordinateSetting.origin.x + lsc.leftPadding,
                                       (self.coordinateSetting.isMath ? -val.y : val.y) + selfHeight * self.coordinateSetting.origin.y + lsc.topPadding);
                }
            }
            else
                return CGPointMake(NAN, NAN);
            
        }];
        
    }
    else if (self.polarEquation != nil)
    {
        
        startArg = 0;
        if (self.coordinateSetting.start != -CGFLOAT_MAX)
            startArg = self.coordinateSetting.start * 180.0 / M_PI;
        
        endArg = 360;
        if (self.coordinateSetting.end != CGFLOAT_MAX)
            endArg = self.coordinateSetting.end * 180.0 / M_PI;
        
        
        [self myCalcPathPointsHelper:pathPointArray showPath:showPath pPathLen:pPathLen subviewCount:subviewCount pointIndexArray:pointIndexArray  viewSpace:viewSpace startArg:startArg endArg:endArg func:^(CGFloat arg){
            
            //计算用弧度
            CGFloat r = self.polarEquation(arg * M_PI / 180.0);
            if (!isnan(r))
            {
                if (self.coordinateSetting.isReverse)
                {
                    CGFloat y = r * cos(arg / 180.0 * M_PI);
                    
                    return CGPointMake(r * sin(arg / 180.0 * M_PI) + selfWidth * self.coordinateSetting.origin.x + lsc.leftPadding,
                                       (self.coordinateSetting.isMath ? -y : y) + selfHeight * self.coordinateSetting.origin.y + lsc.topPadding);
                    
                }
                else
                {
                    
                    CGFloat y = r * sin(arg / 180 * M_PI);
                    
                    return CGPointMake(r * cos(arg / 180 * M_PI) + selfWidth * self.coordinateSetting.origin.x + lsc.leftPadding,
                                       (self.coordinateSetting.isMath ? -y : y) + selfHeight * self.coordinateSetting.origin.y + lsc.topPadding);
                }
            }
            else
                return CGPointMake(NAN, NAN);
            
        }];
        
    }
    
    return pathPointArray;
}

-(NSArray*)myCalcPoints:(NSArray*)sbs path:(CGMutablePathRef)path pointIndexArray:(NSMutableArray*)pointIndexArray lsc:(MyPathLayout*)lsc
{
    if (sbs.count > 0)
    {
        if (self.spaceType.type != MyPathSpace_Fixed)
        {
            //如果间距不是固定的，那么要先算出路径的长度pathLen,以及是否是封闭曲线标志来算出每个子视图在曲线上的间距viewSpacing
            
            CGFloat pathLen = 0;  //曲线的总长度
            NSArray *tempArray = [self myCalcPathPoints:path pPathLen:&pathLen subviewCount:-1 pointIndexArray:nil viewSpace:0 lsc:lsc];
            
            //判断是否是封闭路径，方法为第一个路径点和最后一个之间的距离差小于1
            BOOL bClose = NO;
            if (tempArray.count > 1)
            {
                CGPoint p1 = [tempArray.firstObject CGPointValue];
                CGPoint p2 = [tempArray.lastObject CGPointValue];
                bClose = [self myCalcDistance:p1 with:p2] <= 1;
                
            }
            
            
            CGFloat viewSpace = 0;  //每个视图之间的间距。
            NSInteger sbvcount = sbs.count;
            if (self.spaceType.type == MyPathSpace_Count)  //如果是固定数量则按固定数量来分配间距
                sbvcount = (NSInteger)self.spaceType.value;
            
            //总长度除视图数量得出子视图的间距。
            if (sbvcount > 1)
            {
                viewSpace = pathLen / (sbvcount - (bClose ? 0 : 1));
            }
            
            //有间距后再重新计算一遍
            return [self myCalcPathPoints:nil pPathLen:NULL subviewCount:sbs.count pointIndexArray:pointIndexArray viewSpace:viewSpace lsc:lsc];
            
        }
        else
        {
            return [self myCalcPathPoints:path pPathLen:NULL subviewCount:sbs.count pointIndexArray:pointIndexArray viewSpace:self.spaceType.value lsc:lsc];
        }
    }
    
    return nil;
    
}




@end


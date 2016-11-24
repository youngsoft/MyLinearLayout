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

@property(nonatomic, strong) NSArray *subviewPoints;
@property(nonatomic, strong) NSArray *pointIndexs;
@property(nonatomic, strong) NSMutableArray *argumentArray;  //保存变量数组。

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
        
        NSMutableArray *pathsbs = [NSMutableArray new];
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
        self.subviewPoints = [self calcPoints:self.pathSubviews path:nil pointIndexArray:pointIndexs];
        self.pointIndexs = pointIndexs;
    }
    else
    {
        self.subviewPoints = [self calcPoints:self.pathSubviews path:nil pointIndexArray:nil];
        self.pointIndexs = nil;
    }
    
}

-(void)endSubviewPathPoint
{
    self.subviewPoints = nil;
    self.pointIndexs = nil;
}

-(NSArray*)getSubviewPathPoint:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (self.subviewPoints == nil)
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
            [retPoints addObject:self.subviewPoints[i]];
        }
    }
    else
    {
        NSInteger end = [self.pointIndexs[realFromIndex] integerValue];
        NSInteger start = [self.pointIndexs[realToIndex] integerValue];
        
        for (NSInteger i = end; i >= start; i--)
        {
            [retPoints addObject:self.subviewPoints[i]];
        }
    }
    
    return  retPoints;
    
}

-(CGPathRef)createPath:(NSInteger)subviewCount
{
    CGMutablePathRef retPath = CGPathCreateMutable();
    
    if (self.spaceType.type != MyPathSpace_Fixed)
    {
        [self calcPathPoints:retPath pTotalLen:NULL subviewCount:-1 pointIndexArray:nil viewSpacing:0];
    }
    else
    {
        if (subviewCount == -1)
            subviewCount = self.pathSubviews.count;
        
        [self calcPathPoints:retPath pTotalLen:NULL subviewCount:subviewCount pointIndexArray:nil viewSpacing:self.spaceType.value];
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


#pragma mark -- Private Method


-(CGFloat)calcDistance:(CGPoint)pt1 with:(CGPoint)pt2
{
    return sqrt(pow(pt1.x - pt2.x, 2) + pow(pt1.y - pt2.y, 2));
}


-(CGPoint)getNearestDistancePoint:(CGFloat)startArg lastXY:(CGPoint)lastXY distance:(CGFloat)distance viewSpace:(CGFloat)viewSpace pLastValidArg:(CGFloat*)pLastValidArg func:(CGPoint (^)(CGFloat))func
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
                distance +=  [self calcDistance:realXY with:lastXY];
                if (/*distance >= viewSpace*/ _myCGFloatGreatOrEqual(distance, viewSpace))
                {
                    if (/*distance - viewSpace <= self.distanceError*/ _myCGFloatLessOrEqual(distance - viewSpace, self.distanceError))
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
        if (/*step <= 0.001*/ _myCGFloatLessOrEqual(step, 0.001))
        {
            break;
        }
    }
    
    return lastXY;
    
}

-(void)calcPathPointsHelper:(NSMutableArray*)pointArray
                   showPath:(CGMutablePathRef)showPath
                  pTotalLen:(CGFloat*)pTotalLen
               subviewCount:(NSInteger)subviewCount
            pointIndexArray:(NSMutableArray*)pointIndexArray
                viewSpacing:(CGFloat)viewSpacing
                   startArg:(CGFloat)startArg
                     endArg:(CGFloat)endArg
                       func:(CGPoint (^)(CGFloat))func
{
    
    if (self.distanceError <= 0)
        self.distanceError = 0.5;
    
    [self.argumentArray removeAllObjects];
    
    CGFloat distance = 0;
    CGPoint lastXY = CGPointZero;
    
    CGFloat arg = startArg;
    CGFloat lastValidArg = arg;
    BOOL isStart = YES;
    int startCount = 0;
    while (true)
    {
        
        if (subviewCount < 0)
        {
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
            if (isStart && startCount >= 1)
            {
                if (pointIndexArray != nil)
                    [pointIndexArray addObject:@(pointArray.count)];
                
                [pointArray addObject:[NSValue valueWithCGPoint:lastXY]];
                
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
            if (isStart)
            {
                
                isStart = NO;
                startCount += 1;
                if (subviewCount > 0 && startCount == 1)
                {
                    subviewCount -=1;
                    lastValidArg = arg;
                    
                    if (pointIndexArray != nil)
                        [pointIndexArray addObject:@(pointArray.count)];
                    
                    [self.argumentArray addObject:@(arg)];
                }
                
                [pointArray addObject:[NSValue valueWithCGPoint:realXY]];
                
                if (showPath != nil)
                {
                    CGPathMoveToPoint(showPath,NULL, realXY.x, realXY.y);
                }
                
                
            }
            else
            {
                if (subviewCount >= 0)
                {
                    CGFloat oldDistance = distance;
                    distance += [self calcDistance:realXY with:lastXY];
                    if (/*distance >= viewSpacing*/ _myCGFloatGreatOrEqual(distance, viewSpacing) )
                    {
                        if (/*distance - viewSpacing >= self.distanceError*/ _myCGFloatGreatOrEqual(distance - viewSpacing, self.distanceError) )
                        {
                            realXY = [self getNearestDistancePoint:arg lastXY:lastXY distance:oldDistance viewSpace:viewSpacing pLastValidArg:&lastValidArg func:func];
                        }
                        else
                        {
                            lastValidArg = arg;
                        }
                        
                        if (pointIndexArray == nil)
                            [pointArray addObject:[NSValue valueWithCGPoint:realXY]];
                        else
                            [pointIndexArray addObject:@(pointArray.count)];
                        
                        distance = 0;
                        subviewCount -=1;
                        [self.argumentArray addObject:@(lastValidArg)];

                    }
                    else if (distance - viewSpacing > -1 * self.distanceError)
                    {
                        if (pointIndexArray == nil)
                            [pointArray addObject:[NSValue valueWithCGPoint:realXY]];
                        else
                            [pointIndexArray addObject:@(pointArray.count)];
                        
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
                        [pointArray addObject:[NSValue valueWithCGPoint:realXY]];
                }
                
                if (pointIndexArray != nil)
                    [pointArray addObject:[NSValue valueWithCGPoint:realXY]];
                
                
                if (showPath != nil)
                {
                    CGPathAddLineToPoint(showPath,NULL, realXY.x, realXY.y);
                }
                
                if (pTotalLen != NULL)
                {
                    *pTotalLen +=  [self calcDistance:realXY with:lastXY];
                }
            }
            
            lastXY = realXY;
        }
        else
        {
            isStart = YES;
        }
        arg += 1;
    }
    
    
}


-(NSArray*)calcPathPoints:(CGMutablePathRef)showPath
                pTotalLen:(CGFloat*)pTotalLen
             subviewCount:(NSInteger)subviewCount
          pointIndexArray:(NSMutableArray*)pointIndexArray
              viewSpacing:(CGFloat)viewSpacing
{
    NSMutableArray *pointArray = [NSMutableArray new];
    
    CGFloat selfWidth = CGRectGetWidth(self.bounds) - self.leftPadding - self.rightPadding;
    CGFloat selfHeight = CGRectGetHeight(self.bounds) - self.topPadding - self.bottomPadding;
    
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
        
        [self calcPathPointsHelper:pointArray showPath:showPath pTotalLen:pTotalLen subviewCount:subviewCount pointIndexArray:pointIndexArray viewSpacing:viewSpacing startArg:startArg endArg:endArg func:^(CGFloat arg){
            
            CGFloat val = self.rectangularEquation(arg);
            if (!isnan(val))
            {
                if (self.coordinateSetting.isReverse)
                {
                    return CGPointMake(val + selfWidth * self.coordinateSetting.origin.x + self.leftPadding,
                                       (self.coordinateSetting.isMath ? -arg : arg) + selfHeight * self.coordinateSetting.origin.y + self.topPadding);
                    
                }
                else
                {
                    return CGPointMake(arg + selfWidth * self.coordinateSetting.origin.x + self.leftPadding,
                                       (self.coordinateSetting.isMath ? -val : val) + selfHeight * self.coordinateSetting.origin.y + self.topPadding);
                    
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
        
        [self calcPathPointsHelper:pointArray showPath:showPath pTotalLen:pTotalLen subviewCount:subviewCount pointIndexArray:pointIndexArray  viewSpacing:viewSpacing startArg:startArg endArg:endArg func:^(CGFloat arg){
            
            CGPoint val = self.parametricEquation(arg);
            if (!isnan(val.x) && !isnan(val.y))
            {
                if (self.coordinateSetting.isReverse)
                {
                    return CGPointMake(val.y + selfWidth * self.coordinateSetting.origin.x + self.leftPadding,
                                       (self.coordinateSetting.isMath ? -val.x : val.x) + selfHeight * self.coordinateSetting.origin.y + self.topPadding);
                    
                }
                else
                {
                    return CGPointMake(val.x + selfWidth * self.coordinateSetting.origin.x + self.leftPadding,
                                       (self.coordinateSetting.isMath ? -val.y : val.y) + selfHeight * self.coordinateSetting.origin.y + self.topPadding);
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
        
        
        [self calcPathPointsHelper:pointArray showPath:showPath pTotalLen:pTotalLen subviewCount:subviewCount pointIndexArray:pointIndexArray  viewSpacing:viewSpacing startArg:startArg endArg:endArg func:^(CGFloat arg){
            
            //计算用弧度
            CGFloat r = self.polarEquation(arg * M_PI / 180.0);
            if (!isnan(r))
            {
                if (self.coordinateSetting.isReverse)
                {
                    CGFloat y = r * cos(arg / 180.0 * M_PI);
                    
                    return CGPointMake(r * sin(arg / 180.0 * M_PI) + selfWidth * self.coordinateSetting.origin.x + self.leftPadding,
                                       (self.coordinateSetting.isMath ? -y : y) + selfHeight * self.coordinateSetting.origin.y + self.topPadding);
                    
                }
                else
                {
                    
                    CGFloat y = r * sin(arg / 180 * M_PI);
                    
                    return CGPointMake(r * cos(arg / 180 * M_PI) + selfWidth * self.coordinateSetting.origin.x + self.leftPadding,
                                       (self.coordinateSetting.isMath ? -y : y) + selfHeight * self.coordinateSetting.origin.y + self.topPadding);
                }
            }
            else
                return CGPointMake(NAN, NAN);
            
        }];
        
    }
    
    return pointArray;
}

-(NSArray*)calcPoints:(NSArray*)sbs path:(CGMutablePathRef)path pointIndexArray:(NSMutableArray*)pointIndexArray
{
    if (sbs.count > 0)
    {
        if (self.spaceType.type != MyPathSpace_Fixed)
        {
            CGFloat totalLen = 0;
            NSArray *tempArray = [self calcPathPoints:path pTotalLen:&totalLen subviewCount:-1 pointIndexArray:nil viewSpacing:0];
            
            
            BOOL bClose = NO;
            if (tempArray.count > 1)
            {
                CGPoint p1 = [tempArray.firstObject CGPointValue];
                CGPoint p2 = [tempArray.lastObject CGPointValue];
                bClose = [self calcDistance:p1 with:p2] <= 1;
                
            }
            
            
            CGFloat viewSpacing = 0;
            NSInteger sbvcount = sbs.count;
            if (self.spaceType.type == MyPathSpace_Count)
                sbvcount = (NSInteger)self.spaceType.value;
            
            if (sbvcount > 1)
            {
                viewSpacing = totalLen / (sbvcount - (bClose ? 0 : 1));
            }
            
            return [self calcPathPoints:nil pTotalLen:NULL subviewCount:sbs.count pointIndexArray:pointIndexArray viewSpacing:viewSpacing];
            
        }
        else
        {
            return [self calcPathPoints:path pTotalLen:NULL subviewCount:sbs.count pointIndexArray:pointIndexArray viewSpacing:self.spaceType.value];
        }
    }
    
    return nil;
    
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
    
    
    NSArray *pts = nil;
    if (sbs.count > 0)
    {
        if (self.spaceType.type != MyPathSpace_Fixed)
        {
            CGFloat totalLen = 0;
            NSArray *tempArray = [self calcPathPoints:path pTotalLen:&totalLen subviewCount:-1 pointIndexArray:nil viewSpacing:0];
            BOOL bClose = NO;
            if (tempArray.count > 1)
            {
                CGPoint p1 = [tempArray.firstObject CGPointValue];
                CGPoint p2 = [tempArray.lastObject CGPointValue];
                bClose = [self calcDistance:p1 with:p2] <=1;
            }
            
            CGFloat viewSpacing = 0;
            NSInteger sbvcount = sbs.count;
            if (self.spaceType.type == MyPathSpace_Count)
                sbvcount = (NSInteger)self.spaceType.value;
            
            if (sbvcount > 1)
            {
                viewSpacing = totalLen / (sbvcount - (bClose ? 0 : 1));
            }
            
            pts = [self calcPathPoints:nil pTotalLen:NULL subviewCount:sbs.count pointIndexArray:nil viewSpacing:viewSpacing];
            
        }
        else
        {
            pts = [self calcPathPoints:path pTotalLen:NULL subviewCount:sbs.count pointIndexArray:nil viewSpacing:self.spaceType.value];
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


-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass];
    
    NSArray *sbs = [self getLayoutSubviews];
    
    for (UIView *sbv in sbs)
    {
        
        if (!isEstimate)
        {
            sbv.myFrame.frame = sbv.bounds;
            [self calcSizeOfWrapContentSubview:sbv selfLayoutSize:selfSize];
        }
        
        if ([sbv isKindOfClass:[MyBaseLayout class]])
        {
            
            MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
            
            if (pHasSubLayout != nil && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                *pHasSubLayout = YES;
            
            if (isEstimate && (sbvl.wrapContentWidth || sbvl.wrapContentHeight))
            {
                [sbvl estimateLayoutRect:sbvl.myFrame.frame.size inSizeClass:sizeClass];
                sbvl.myFrame.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
        }
    }
    
    CGSize maxSize = CGSizeMake(self.leftPadding, self.topPadding);
    
    //算路径子视图的。
    sbs = [self getLayoutSubviewsFrom:self.pathSubviews];
    
    CGMutablePathRef path = nil;
    if ([self.layer isKindOfClass:[CAShapeLayer class]] && !isEstimate)
    {
        path = CGPathCreateMutable();
    }
    
    NSArray *pts = [self calcPoints:sbs path:path pointIndexArray:nil];
    
    if (path != nil)
    {
        CAShapeLayer *slayer = (CAShapeLayer*)self.layer;
        slayer.path = path;
        CGPathRelease(path);
    }
    
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        CGPoint pt = CGPointZero;
        if (pts.count > i)
        {
            pt = [pts[i] CGPointValue];
        }
        
        //计算得到最大的高度和最大的宽度。
        
        CGRect rect = sbv.myFrame.frame;
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.widthDime.dimeRelaVal != nil)
        {
            if (sbv.widthDime.dimeRelaVal == self.widthDime)
            {
                rect.size.width = (selfSize.width - self.leftPadding - self.rightPadding) * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            }
            else
            {
                rect.size.width = sbv.widthDime.dimeRelaVal.view.estimatedRect.size.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            }
        }
        
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        
        if (sbv.heightDime.dimeRelaVal != nil)
        {
            if (sbv.heightDime.dimeRelaVal == self.heightDime)
            {
                rect.size.height = (selfSize.height - self.topPadding - self.bottomPadding) * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            }
            else
            {
                rect.size.height = sbv.heightDime.dimeRelaVal.view.estimatedRect.size.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            }
        }
        
        if (sbv.isFlexedHeight)
        {
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
        }
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        //中心点的位置。。
        rect.origin.x = pt.x - rect.size.width * sbv.layer.anchorPoint.x + sbv.leftPos.margin;
        rect.origin.y = pt.y - rect.size.height *sbv.layer.anchorPoint.y + sbv.topPos.margin;
        
        if (CGRectGetMaxX(rect) > maxSize.width)
            maxSize.width = CGRectGetMaxX(rect);
        
        if (CGRectGetMaxY(rect) > maxSize.height)
            maxSize.height = CGRectGetMaxY(rect);
        
        sbv.myFrame.frame = rect;
        
    }
    
    //特殊填充中心视图。
    UIView *sbv = [self originView];
    if (sbv != nil)
    {
        CGRect rect = sbv.myFrame.frame;
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.widthDime.dimeRelaVal != nil)
        {
            if (sbv.widthDime.dimeRelaVal == self.widthDime)
            {
                rect.size.width = (selfSize.width - self.leftPadding - self.rightPadding) * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            }
            else
            {
                rect.size.width = sbv.widthDime.dimeRelaVal.view.estimatedRect.size.width * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            }
        }
        
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        
        if (sbv.heightDime.dimeRelaVal != nil)
        {
            if (sbv.heightDime.dimeRelaVal == self.heightDime)
            {
                rect.size.height = (selfSize.height - self.topPadding - self.bottomPadding) * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            }
            else
            {
                rect.size.height = sbv.heightDime.dimeRelaVal.view.estimatedRect.size.height * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
            }
        }
        
        if (sbv.isFlexedHeight)
        {
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
        }
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //位置在原点位置。。
        rect.origin.x = (selfSize.width - self.leftPadding - self.rightPadding)*self.coordinateSetting.origin.x - rect.size.width / 2 + sbv.leftPos.margin + self.leftPadding;
        rect.origin.y = (selfSize.height - self.topPadding - self.bottomPadding)*self.coordinateSetting.origin.y - rect.size.height / 2 + sbv.topPos.margin + self.topPadding;
        
        if (CGRectGetMaxX(rect) > maxSize.width)
            maxSize.width = CGRectGetMaxX(rect);
        
        if (CGRectGetMaxY(rect) > maxSize.height)
            maxSize.height = CGRectGetMaxY(rect);
        
        sbv.myFrame.frame = rect;
        
    }
    
    if (self.wrapContentWidth)
    {
        selfSize.width = maxSize.width + self.rightPadding;
    }
    
    if (self.wrapContentHeight)
    {
        selfSize.height = maxSize.height + self.bottomPadding;
    }
    
    
    selfSize.height = [self validMeasure:self.heightDime sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self validMeasure:self.widthDime sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    return selfSize;
}

-(id)createSizeClassInstance
{
    return [MyPathLayoutViewSizeClass new];
}

@end


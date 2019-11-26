//
//  MyLayoutPos.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutPos.h"
#import "MyLayoutPosInner.h"
#import "MyBaseLayout.h"
#import "MyLayoutInner.h"


@implementation MyLayoutPos
{
    id _posVal;
    CGFloat _offsetVal;
    MyLayoutPos *_lBoundVal;
    MyLayoutPos *_uBoundVal;
}

+(CGFloat)safeAreaMargin
{
    //在2017年10月3号定义的一个数字，没有其他特殊意义。
    return -20171003.0;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _active = YES;
        _view = nil;
        _pos = MyGravity_None;
        _posVal = nil;
        _posValType = MyLayoutValueType_Nil;
        _offsetVal = 0;
        _lBoundVal = nil;
        _uBoundVal = nil;
        _shrink = 0.0;
    }
    
    return self;
}

-(MyLayoutPos* (^)(id val))myEqualTo
{
    return ^id(id val){
        
        [self __equalTo:val];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutPos* (^)(CGFloat val))myOffset
{
    return ^id(CGFloat val){
        
        [self __offset:val];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutPos* (^)(CGFloat val))myMin
{
    return ^id(CGFloat val){
        
        [self __min:val];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutPos* (^)(CGFloat val))myMax
{
    return ^id(CGFloat val){
        
        [self __max:val];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutPos* (^)(id posVal, CGFloat offset))myLBound
{
    return ^id(id posVal, CGFloat offset){
        
        [self __lBound:posVal offsetVal:offset];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutPos* (^)(id posVal, CGFloat offset))myUBound
{
    return ^id(id posVal, CGFloat offset){
        
        [self __uBound:posVal offsetVal:offset];
        [self setNeedsLayout];
        return self;
    };
}

-(void)myClear
{
    [self __clear];
    [self setNeedsLayout];
}

-(MyLayoutPos* (^)(id val))equalTo
{
    return self.myEqualTo;
}

-(MyLayoutPos* (^)(CGFloat val))offset
{
    return self.myOffset;
}

-(MyLayoutPos* (^)(CGFloat val))min
{
    return self.myMin;
}

-(MyLayoutPos* (^)(id posVal, CGFloat offsetVal))lBound
{
    return self.myLBound;
}

-(MyLayoutPos* (^)(CGFloat val))max
{
    return self.myMax;
}

-(MyLayoutPos* (^)(id posVal, CGFloat offsetVal))uBound
{
    return self.myUBound;
}

-(void)clear
{
    [self myClear];
}

-(void)setActive:(BOOL)active
{
    if (_active != active)
    {
        [self __setActive:active];
        [self setNeedsLayout];
    }
}

-(CGFloat)shrink
{
    return self.isActive ? _shrink : 0;
}

-(id)posVal
{
    return self.isActive ? _posVal : nil;
}

-(CGFloat)offsetVal
{
    return self.isActive? _offsetVal : 0;
}

#pragma mark -- NSCopying  

-(id)copyWithZone:(NSZone *)zone
{
    MyLayoutPos *layoutPos = [[[self class] allocWithZone:zone] init];
    layoutPos.view = self.view;
    layoutPos->_active = _active;
    layoutPos->_shrink = _shrink;
    layoutPos->_pos = _pos;
    layoutPos->_posValType = _posValType;
    layoutPos->_posVal = _posVal;
    layoutPos->_offsetVal = _offsetVal;
    if (_lBoundVal != nil)
    {
        layoutPos->_lBoundVal = [[[self class] allocWithZone:zone] init];
        layoutPos->_lBoundVal->_active = _active;
        [[layoutPos->_lBoundVal __equalTo:_lBoundVal.posVal] __offset:_lBoundVal.offsetVal];
    }
    if (_uBoundVal != nil)
    {
        layoutPos->_uBoundVal = [[[self class] allocWithZone:zone] init];
        layoutPos->_uBoundVal->_active = _active;
        [[layoutPos->_uBoundVal __equalTo:_uBoundVal.posVal] __offset:_uBoundVal.offsetVal];
    }
    
    return layoutPos;
}


#pragma mark -- Private Methods

-(NSNumber*)posNumVal
{
    if (_posVal == nil || !self.isActive)
        return nil;
    
    if (_posValType == MyLayoutValueType_NSNumber)
    {
        return _posVal;
    }
    else if (_posValType == MyLayoutValueType_UILayoutSupport)
    {
       //只有在11以后并且是设置了safearea缩进才忽略UILayoutSupport。
        UIView *superview = self.view.superview;
            if (superview != nil &&
                [UIDevice currentDevice].systemVersion.doubleValue >= 11 &&
                [superview isKindOfClass:[MyBaseLayout class]])
            {
                UIRectEdge edge = ((MyBaseLayout*)superview).insetsPaddingFromSafeArea;
                if ((_pos == MyGravity_Vert_Top && (edge & UIRectEdgeTop) == UIRectEdgeTop) ||
                    (_pos == MyGravity_Vert_Bottom && (edge & UIRectEdgeBottom) == UIRectEdgeBottom))
                {
                    return @(0);
                }
            }
        
        return @([((id<UILayoutSupport>)_posVal) length]);
    }
    else if (_posValType == MyLayoutValueType_SafeArea)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            
            UIView *superView = self.view.superview;
           /* UIEdgeInsets insets = superView.safeAreaInsets;
            UIScrollView *superScrollView = nil;
            if ([superView isKindOfClass:[UIScrollView class]])
            {
                superScrollView = (UIScrollView*)superView;
                
            }
            */
            
            switch (_pos) {
                case MyGravity_Horz_Leading:
                    return  [MyBaseLayout isRTL]? @(superView.safeAreaInsets.right) : @(superView.safeAreaInsets.left);
                    break;
                case MyGravity_Horz_Trailing:
                    return  [MyBaseLayout isRTL]? @(superView.safeAreaInsets.left) : @(superView.safeAreaInsets.right);
                    break;
                case MyGravity_Vert_Top:
                    return @(superView.safeAreaInsets.top);
                    break;
                case MyGravity_Vert_Bottom:
                    return @(superView.safeAreaInsets.bottom);
                    break;
                default:
                    return @(0);
                    break;
            }
        }
#endif
        if (_pos == MyGravity_Vert_Top)
        {
            return @([self findContainerVC].topLayoutGuide.length);
        }
        else if (_pos == MyGravity_Vert_Bottom)
        {
            return @([self findContainerVC].bottomLayoutGuide.length);
        }
        
        return @(0);
    }
    
    return nil;
}

-(UIViewController*)findContainerVC
{
    UIViewController *vc = nil;
    
    @try {
        
        UIView *v = self.view;
        while (v != nil)
        {
            vc = [v valueForKey:@"viewDelegate"];
            if (vc != nil)
                break;
            v = [v superview];
        }
        
    } @catch (NSException *exception) {
    }
    
    return vc;
}

-(MyLayoutPos*)posRelaVal
{
    if (_posVal == nil || !self.isActive)
        return nil;
    
    if (_posValType == MyLayoutValueType_LayoutPos)
        return _posVal;
    
    return nil;
}


-(NSArray*)posArrVal
{
    if (_posVal == nil || !self.isActive)
        return nil;
    
    if (_posValType == MyLayoutValueType_Array)
        return _posVal;
    
    return nil;
}

-(NSNumber*)posMostVal
{
   if (_posVal == nil || !self.isActive)
       return nil;
    
    if (_posValType == MyLayoutValueType_Most)
    {
        return @([((MyLayoutMostPos*)_posVal) getMostPosFrom:self]);
    }
    
    return nil;
}


-(MyLayoutPos*)lBoundVal
{
    if (_lBoundVal == nil)
    {
        _lBoundVal = [[MyLayoutPos alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal __equalTo:@(-CGFLOAT_MAX)];
    }
    return _lBoundVal;
}

-(MyLayoutPos*)uBoundVal
{
    if (_uBoundVal == nil)
    {
        _uBoundVal = [[MyLayoutPos alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal __equalTo:@(CGFLOAT_MAX)];
    }
    
    return _uBoundVal;
}

-(MyLayoutPos*)lBoundValInner
{
    return _lBoundVal;
}

-(MyLayoutPos*)uBoundValInner
{
    return _uBoundVal;
}

-(MyLayoutPos*)__equalTo:(id)val
{
    if (![_posVal isEqual:val])
    {
        if ([val isKindOfClass:[NSNumber class]])
        {
            //特殊处理设置为safeAreaMargin边距的值。
            if ([val doubleValue] == [MyLayoutPos safeAreaMargin])
                _posValType = MyLayoutValueType_SafeArea;
            else
                _posValType = MyLayoutValueType_NSNumber;
        }
        else if ([val isKindOfClass:[MyLayoutPos class]])
            _posValType = MyLayoutValueType_LayoutPos;
        else if ([val isKindOfClass:[NSArray class]])
            _posValType = MyLayoutValueType_Array;
        else if ([val conformsToProtocol:@protocol(UILayoutSupport)])
        {
            //这里只有上边和下边支持，其他不支持。。
            if (_pos != MyGravity_Vert_Top && _pos != MyGravity_Vert_Bottom)
            {
                NSAssert(0, @"oops! only topPos or bottomPos can set to id<UILayoutSupport>");
            }
            
            _posValType = MyLayoutValueType_UILayoutSupport;
        }
        else if ([val isKindOfClass:[MyLayoutMostPos class]])
        {
            _posValType = MyLayoutValueType_Most;
        }
        else if ([val isKindOfClass:[UIView class]])
        {
            UIView *rview = (UIView*)val;
            _posValType = MyLayoutValueType_LayoutPos;
            
            switch (_pos) {
                case MyGravity_Horz_Leading:
                    val = rview.leadingPos;
                    break;
                case MyGravity_Horz_Center:
                    val = rview.centerXPos;
                    break;
                case MyGravity_Horz_Trailing:
                    val = rview.trailingPos;
                    break;
                case MyGravity_Vert_Top:
                    val = rview.topPos;
                    break;
                case MyGravity_Vert_Center:
                    val = rview.centerYPos;
                    break;
                case MyGravity_Vert_Bottom:
                    val = rview.bottomPos;
                    break;
                case MyGravity_Vert_Baseline:
                    val = rview.baselinePos;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }
        }
        else
            _posValType = MyLayoutValueType_Nil;
        
        _posVal = val;
    }
    
    return self;
}

-(MyLayoutPos*)__offset:(CGFloat)val
{
    if (_offsetVal != val)
    {
        _offsetVal = val;
    }
    
    return self;
}

-(MyLayoutPos*)__min:(CGFloat)val
{
    
    if (self.lBoundVal.posNumVal.doubleValue != val)
    {
        [self.lBoundVal __equalTo:@(val)];
    }
    
    return self;
}

-(MyLayoutPos*)__lBound:(id)posVal offsetVal:(CGFloat)offsetVal
{
    [[self.lBoundVal __equalTo:posVal] __offset:offsetVal];
    
    return self;
}

-(MyLayoutPos*)__max:(CGFloat)val
{
    if (self.uBoundVal.posNumVal.doubleValue != val)
        [self.uBoundVal __equalTo:@(val)];
    
    return self;
}

-(MyLayoutPos*)__uBound:(id)posVal offsetVal:(CGFloat)offsetVal
{
    [[self.uBoundVal __equalTo:posVal] __offset:offsetVal];
    return self;
}

-(void)__clear
{
    _active = YES;
    _posVal = nil;
    _posValType = MyLayoutValueType_Nil;
    _offsetVal = 0;
    _lBoundVal = nil;
    _uBoundVal = nil;
    _shrink = 0;
}

-(void)__setActive:(BOOL)active
{
    _active = active;
    [_lBoundVal __setActive:active];
    [_uBoundVal __setActive:active];
}

-(CGFloat)absVal
{
    if (self.isActive)
    {
        CGFloat retVal = _offsetVal;
        
        if (self.posNumVal != nil)
            retVal +=self.posNumVal.doubleValue;
        
        if (_uBoundVal != nil)
            retVal = _myCGFloatMin(_uBoundVal.posNumVal.doubleValue, retVal);
        
        if (_lBoundVal != nil)
            retVal = _myCGFloatMax(_lBoundVal.posNumVal.doubleValue, retVal);
        
        return retVal;
    }
    else
        return 0;
}

-(BOOL)isRelativePos
{
    if (self.isActive)
    {
        CGFloat realPos = self.posNumVal.doubleValue;
        return realPos > 0 && realPos < 1;
        
    }
    else
    {
        return NO;
    }
}

-(BOOL)isSafeAreaPos
{
    return self.isActive && (_posValType == MyLayoutValueType_SafeArea || _posValType == MyLayoutValueType_UILayoutSupport);
}

-(CGFloat)realPosIn:(CGFloat)size
{
    if (self.isActive)
    {
        CGFloat realPos = self.posNumVal.doubleValue;
        if (realPos > 0 && realPos < 1)
            realPos *= size;
        
        realPos += _offsetVal;
        
        if (_uBoundVal != nil)
            realPos = _myCGFloatMin(_uBoundVal.posNumVal.doubleValue, realPos);
        
        if (_lBoundVal != nil)
            realPos = _myCGFloatMax(_lBoundVal.posNumVal.doubleValue, realPos);

        return realPos;
    }
    else
    {
        return 0;
    }
}

-(void)setNeedsLayout
{
    if (_view != nil && _view.superview != nil && [_view.superview isKindOfClass:[MyBaseLayout class]])
    {
        MyBaseLayout* lb = (MyBaseLayout*)_view.superview;
        if (!lb.isMyLayouting)
            [_view.superview setNeedsLayout];
    }
}

+(NSString*)posstrFromPos:(MyLayoutPos*)posobj showView:(BOOL)showView
{
    NSString *viewstr = @"";
    if (showView)
        viewstr = [NSString stringWithFormat:@"View:%p.", posobj.view];
    
    NSString *posStr = @"";
    
    switch (posobj.pos) {
        case MyGravity_Horz_Leading:
            posStr = @"leadingPos";
            break;
        case MyGravity_Horz_Center:
            posStr = @"centerXPos";
            break;
        case MyGravity_Horz_Trailing:
            posStr = @"trailingPos";
            break;
        case MyGravity_Vert_Top:
            posStr = @"topPos";
            break;
        case MyGravity_Vert_Center:
            posStr = @"centerYPos";
            break;
        case MyGravity_Vert_Bottom:
            posStr = @"bottomPos";
            break;
        case MyGravity_Vert_Baseline:
            posStr = @"baselinePos";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",viewstr,posStr];
}

#pragma mark -- Override Method

-(NSString*)description
{
    NSString *posValStr = @"";
    switch (_posValType) {
        case MyLayoutValueType_Nil:
            posValStr = @"nil";
            break;
        case MyLayoutValueType_NSNumber:
            posValStr = [_posVal description];
            break;
        case MyLayoutValueType_LayoutPos:
            posValStr = [MyLayoutPos posstrFromPos:_posVal showView:YES];
            break;
        case MyLayoutValueType_Array:
        {
            posValStr = @"[";
            for (NSObject *obj in _posVal)
            {
                if ([obj isKindOfClass:[MyLayoutPos class]])
                    posValStr = [posValStr stringByAppendingString:[MyLayoutPos posstrFromPos:(MyLayoutPos*)obj showView:YES]];
                else
                    posValStr = [posValStr stringByAppendingString:[obj description]];
                
                if (obj != [_posVal lastObject])
                    posValStr = [posValStr stringByAppendingString:@", "];
            }
            
            posValStr = [posValStr stringByAppendingString:@"]"];
            
        }
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@=%@, Offset=%g, Max=%g, Min=%g",[MyLayoutPos posstrFromPos:self showView:NO], posValStr, _offsetVal, _uBoundVal.posNumVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.posNumVal.doubleValue , _uBoundVal.posNumVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.posNumVal.doubleValue];
}

@end

@implementation MyLayoutPos(Clone)

-(MyLayoutPos* (^)(CGFloat offsetVal))clone
{
    return ^id(CGFloat offsetVal){
        
        MyLayoutPos *clonedPos = [[[self class] allocWithZone:nil] init];
        clonedPos->_offsetVal = offsetVal;
        clonedPos->_posVal = self;
        clonedPos->_posValType = MyLayoutValueType_LayoutDimeClone;
        return clonedPos;
    };
}

@end

#pragma mark -- MyLayoutMostPos

@implementation MyLayoutMostPos
{
    NSArray *_poss;
    BOOL _isMax;
}

-(instancetype)initWith:(NSArray *)poss isMax:(BOOL)isMax
{
    self = [self init];
    if (self != nil)
    {
        _poss = poss;
        _isMax = isMax;
    }
    return self;
}

-(CGFloat)getMostPosFrom:(MyLayoutPos *)layoutPos
{
    CGFloat retVal = _isMax ? -CGFLOAT_MAX : CGFLOAT_MAX;
    
    for (id pos in _poss)
    {
        CGFloat val = 0;
        if ([pos isKindOfClass:[NSNumber class]])
        {
            val = [(NSNumber*)pos doubleValue];
        }
        else if ([pos isKindOfClass:[MyLayoutPos class]])
        {
            MyLayoutPos *lpos = (MyLayoutPos *)pos;
            CGFloat offsetVal = 0;
            if (lpos.posValType == MyLayoutValueType_LayoutDimeClone)
            {
                offsetVal = lpos.offsetVal;
                lpos = (MyLayoutPos *)lpos.posVal;
            }
            
            MyFrame *myFrame = lpos.view.myFrame;
            
            if (layoutPos.pos & MyGravity_Vert_Mask)
            {//水平
                if (lpos.pos == MyGravity_Horz_Leading)
                    val = myFrame.leading + offsetVal;
                else if (lpos.pos == MyGravity_Horz_Center)
                    val = myFrame.leading + myFrame.width / 2.0 + offsetVal;
                else
                    val = myFrame.trailing - offsetVal;
            }
            else
            {//垂直
                if (lpos.pos == MyGravity_Vert_Top)
                    val = myFrame.top + offsetVal;
                else if (lpos.pos == MyGravity_Vert_Center)
                    val = myFrame.top + myFrame.height / 2.0 + offsetVal;
                else
                    val = myFrame.bottom - offsetVal;
            }
        }
        else
        {
            NSAssert(NO, @"oops!, invalid type, only support NSNumber or MyLayoutPos");
        }
        
        retVal = _isMax ? _myCGFloatMax(val, retVal) : _myCGFloatMin(val, retVal);
    }
    
    return retVal;
}

@end


@implementation NSArray(MyLayoutMostPos)

-(MyLayoutMostPos *)myMinPos
{
    return [[MyLayoutMostPos alloc] initWith:self isMax:NO];
}

-(MyLayoutMostPos *)myMaxPos
{
    return [[MyLayoutMostPos alloc] initWith:self isMax:YES];
}

@end


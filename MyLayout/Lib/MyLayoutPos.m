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



@implementation MyLayoutPos
{
    id _posVal;
    CGFloat _offsetVal;
    MyLayoutPos *_lBoundVal;
    MyLayoutPos *_uBoundVal;
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
    }
    
    return self;
}



-(MyLayoutPos* (^)(id val))myEqualTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}


-(MyLayoutPos* (^)(CGFloat val))myOffset
{
    return ^id(CGFloat val){
        
        return [self __offset:val];
    };
}


-(MyLayoutPos* (^)(CGFloat val))myMin
{
    return ^id(CGFloat val){
        
        return [self __min:val];
    };
}


-(MyLayoutPos* (^)(CGFloat val))myMax
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(MyLayoutPos* (^)(id posVal, CGFloat offset))myLBound
{
    return ^id(id posVal, CGFloat offset){
        
        return [self __lBound:posVal offsetVal:offset];
    };
}

-(MyLayoutPos* (^)(id posVal, CGFloat offset))myUBound
{
    return ^id(id posVal, CGFloat offset){
        
        return [self __uBound:posVal offsetVal:offset];
    };
}





-(void)myClear
{
    [self __clear];
}


-(MyLayoutPos* (^)(id val))equalTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}


-(MyLayoutPos* (^)(CGFloat val))offset
{
    return ^id(CGFloat val){

        return [self __offset:val];
    };
}


-(MyLayoutPos* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
    
        return [self __min:val];
    };
}

-(MyLayoutPos* (^)(id posVal, CGFloat offsetVal))lBound
{
    return ^id(id posVal, CGFloat offsetVal){
        
        return [self __lBound:posVal offsetVal:offsetVal];
    };
}


-(MyLayoutPos* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
    
        return [self __max:val];
    };
}

-(MyLayoutPos* (^)(id posVal, CGFloat offsetVal))uBound
{
    return ^id(id posVal, CGFloat offsetVal){
        
        return [self __uBound:posVal offsetVal:offsetVal];
    };
}




-(void)clear
{
    [self __clear];
}


-(void)setActive:(BOOL)active
{
    if (_active != active)
    {
       _active = active;
        _lBoundVal.active = active;
        _uBoundVal.active = active;
      [self setNeedsLayout];
    }
}

-(id)posVal
{
    return self.isActive ? _posVal : nil;
}

-(CGFloat)offsetVal
{
    return self.isActive? _offsetVal : 0;
}

-(CGFloat)minVal
{
    return self.isActive && _lBoundVal != nil ? _lBoundVal.posNumVal.doubleValue : -CGFLOAT_MAX;
}

-(CGFloat)maxVal
{
    return self.isActive && _uBoundVal != nil ?  _uBoundVal.posNumVal.doubleValue : CGFLOAT_MAX;
}



#pragma mark -- NSCopying  

-(id)copyWithZone:(NSZone *)zone
{
    MyLayoutPos *lp = [[[self class] allocWithZone:zone] init];
    lp.view = self.view;
    lp->_active = _active;
    lp->_pos = _pos;
    lp->_posValType = _posValType;
    lp->_posVal = _posVal;
    lp->_offsetVal = _offsetVal;
    if (_lBoundVal != nil)
    {
        lp->_lBoundVal = [[[self class] allocWithZone:zone] init];
        lp->_lBoundVal->_active = _active;
        [[lp->_lBoundVal __equalTo:_lBoundVal.posVal] __offset:_lBoundVal.offsetVal];
    }
    if (_uBoundVal != nil)
    {
        lp->_uBoundVal = [[[self class] allocWithZone:zone] init];
        lp->_uBoundVal->_active = _active;
        [[lp->_uBoundVal __equalTo:_uBoundVal.posVal] __offset:_uBoundVal.offsetVal];
    }
    
    return lp;

}


#pragma mark -- Private Method


-(NSNumber*)posNumVal
{
    if (_posVal == nil || !self.isActive)
        return nil;
    
    if (_posValType == MyLayoutValueType_NSNumber)
        return _posVal;
    else if (_posValType == MyLayoutValueType_UILayoutSupport)
        return @([((id<UILayoutSupport>)_posVal) length]);
    
    
    return nil;
    
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
            _posValType = MyLayoutValueType_NSNumber;
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
                default:
                    NSAssert(0, @"oops!");
                    break;
            }
            
        }
        else
            _posValType = MyLayoutValueType_Nil;
        
        _posVal = val;
        [self setNeedsLayout];
    }
    
    return self;
}

-(MyLayoutPos*)__offset:(CGFloat)val
{
    
    if (_offsetVal != val)
    {
        _offsetVal = val;
        [self setNeedsLayout];
    }
    
    return self;
}

-(MyLayoutPos*)__min:(CGFloat)val
{
    
    if (self.lBoundVal.posNumVal.doubleValue != val)
    {
        [self.lBoundVal __equalTo:@(val)];
        
        [self setNeedsLayout];
    }
    
    return self;
}

-(MyLayoutPos*)__lBound:(id)posVal offsetVal:(CGFloat)offsetVal
{
    
    [[self.lBoundVal __equalTo:posVal] __offset:offsetVal];
    
    [self setNeedsLayout];
    
    return self;
}


-(MyLayoutPos*)__max:(CGFloat)val
{
    
    if (self.uBoundVal.posNumVal.doubleValue != val)
    {
        [self.uBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }
    
    return self;
}

-(MyLayoutPos*)__uBound:(id)posVal offsetVal:(CGFloat)offsetVal
{
    
    [[self.uBoundVal __equalTo:posVal] __offset:offsetVal];
    
    [self setNeedsLayout];
    
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
    [self setNeedsLayout];
}




-(CGFloat)absVal
{
    if (self.isActive)
    {
        CGFloat retVal = _offsetVal;
        
        if (self.posNumVal != nil)
            retVal +=self.posNumVal.doubleValue;
        
        if (_uBoundVal != nil)
            retVal = MIN(_uBoundVal.posNumVal.doubleValue, retVal);
        
        if (_lBoundVal != nil)
            retVal = MAX(_lBoundVal.posNumVal.doubleValue, retVal);
        
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
        return NO;
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
            realPos = MIN(_uBoundVal.posNumVal.doubleValue, realPos);
        
        if (_lBoundVal != nil)
            realPos = MAX(_lBoundVal.posNumVal.doubleValue, realPos);

        return realPos;
    }
    else
        return 0;
    
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
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", posobj.view];
    }
    
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
                {
                    posValStr = [posValStr stringByAppendingString:[MyLayoutPos posstrFromPos:(MyLayoutPos*)obj showView:YES]];
                }
                else
                {
                    posValStr = [posValStr stringByAppendingString:[obj description]];
                    
                }
                
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


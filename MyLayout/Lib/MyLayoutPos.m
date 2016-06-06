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
        _view = nil;
        _pos = MyMarginGravity_None;
        _posVal = nil;
        _posValType = MyLayoutValueType_Nil;
        _offsetVal = 0;
        _lBoundVal = [[MyLayoutPos alloc] initWithNoBound];
        _lBoundVal.equalTo(@(-CGFLOAT_MAX));
        _uBoundVal = [[MyLayoutPos alloc] initWithNoBound];
        _uBoundVal.equalTo(@(CGFLOAT_MAX));
    }
    
    return self;
}

-(id)initWithNoBound
{
    self = [super init];
    if (self !=nil)
    {
        _view = nil;
        _pos = MyMarginGravity_None;
        _posVal = nil;
        _posValType = MyLayoutValueType_Nil;
        _offsetVal = 0;
    }
    
    return self;
}


-(MyLayoutPos* (^)(id val))equalTo
{
    return ^id(id val){
        
        if (![_posVal isEqual:val])
        {
            _posVal = val;
            if ([val isKindOfClass:[NSNumber class]])
                _posValType = MyLayoutValueType_NSNumber;
            else if ([val isKindOfClass:[MyLayoutPos class]])
                _posValType = MyLayoutValueType_LayoutPos;
            else if ([val isKindOfClass:[NSArray class]])
                _posValType = MyLayoutValueType_Array;
            else
                _posValType = MyLayoutValueType_Nil;
            
            [self setNeedLayout];
        }
        
        return self;
    };
    
}

-(MyLayoutPos* (^)(CGFloat val))offset
{
    return ^id(CGFloat val){
        
        if (_offsetVal != val)
        {
            _offsetVal = val;
            [self setNeedLayout];
        }
        
        return self;
    };
}

-(MyLayoutPos* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        if (_lBoundVal.posNumVal.doubleValue != val)
        {
            _lBoundVal.equalTo(@(val));
            
            [self setNeedLayout];
        }
        
        return self;
    };
}

-(MyLayoutPos* (^)(id posVal, CGFloat offsetVal))lBound
{
    return ^id(id posVal, CGFloat offsetVal){
        
        _lBoundVal.equalTo(posVal).offset(offsetVal);
        
        [self setNeedLayout];
        
        return self;
    };
    
}


-(MyLayoutPos* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        if (_uBoundVal.posNumVal.doubleValue != val)
        {
            _uBoundVal.equalTo(@(val));
            [self setNeedLayout];
        }
        
        return self;
    };
}

-(MyLayoutPos* (^)(id posVal, CGFloat offsetVal))uBound
{
    return ^id(id posVal, CGFloat offsetVal){
        
        _uBoundVal.equalTo(posVal).offset(offsetVal);
        
        [self setNeedLayout];
        
        return self;
    };
    
}



-(void)clear
{
    _posVal = nil;
    _posValType = MyLayoutValueType_Nil;
    _offsetVal = 0;
    _lBoundVal.equalTo(@(-CGFLOAT_MAX)).offset(0);
    _uBoundVal.equalTo(@(CGFLOAT_MAX)).offset(0);
    [self setNeedLayout];
}



-(NSNumber*)posNumVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_NSNumber)
        return _posVal;
        
    return nil;
    
}



-(MyLayoutPos*)posRelaVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_LayoutPos)
        return _posVal;
    
    return nil;
    
}


-(NSArray*)posArrVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Array)
        return _posVal;
    
    return nil;
    
}

-(MyLayoutPos*)lBoundVal
{
    return _lBoundVal;
}

-(MyLayoutPos*)uBoundVal
{
    return _uBoundVal;
}




-(CGFloat)margin
{
    CGFloat retVal = _offsetVal;
    
    if (self.posNumVal != nil)
        retVal +=self.posNumVal.doubleValue;
    
    retVal = MIN(_uBoundVal.posNumVal.doubleValue, retVal);
    retVal = MAX(_lBoundVal.posNumVal.doubleValue, retVal);
    return retVal;
}

-(BOOL)isRelativeMargin:(CGFloat)margin
{
    return margin > 0 && margin < 1;
}

-(CGFloat)realMarginInSize:(CGFloat)size
{
    CGFloat realMargin = self.posNumVal.doubleValue;
    if ([self isRelativeMargin:realMargin])
        realMargin *= size;
    
    return  realMargin + _offsetVal;
}


#pragma mark -- NSCopying  

-(id)copyWithZone:(NSZone *)zone
{
    MyLayoutPos *lp = [[[self class] allocWithZone:zone] init];
    lp.view = self.view;
    lp.pos = self.pos;
    lp.posValType = self.posValType;
    lp->_offsetVal = self.offsetVal;
    lp->_lBoundVal.equalTo(_lBoundVal.posVal).offset(_lBoundVal.offsetVal);
    lp->_uBoundVal.equalTo(_uBoundVal.posVal).offset(_uBoundVal.offsetVal);
    lp->_posVal = self->_posVal;
    
    return lp;

}


#pragma mark -- Private Method
-(void)setNeedLayout
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
        case MyMarginGravity_Horz_Left:
            posStr = @"LeftPos";
            break;
        case MyMarginGravity_Horz_Center:
            posStr = @"CenterXPos";
            break;
        case MyMarginGravity_Horz_Right:
            posStr = @"RightPos";
            break;
        case MyMarginGravity_Vert_Top:
            posStr = @"TopPos";
            break;
        case MyMarginGravity_Vert_Center:
            posStr = @"CenterYPos";
            break;
        case MyMarginGravity_Vert_Bottom:
            posStr = @"BottomPos";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",viewstr,posStr];
    
    
}

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


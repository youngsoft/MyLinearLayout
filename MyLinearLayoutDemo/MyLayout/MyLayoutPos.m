//
//  MyLayoutPos.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutPos.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutBase.h"



@implementation MyLayoutPos

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _view = nil;
        _pos = MGRAVITY_NONE;
        _posVal = nil;
        _posValType = MyLayoutValueType_NULL;
        _offsetVal = 0;
        _minVal = -CGFLOAT_MAX;
        _maxVal = CGFLOAT_MAX;
    }
    
    return self;
}

-(void)setNeedLayout
{
    if (_view.superview != nil && [_view.superview isKindOfClass:[MyLayoutBase class]])
    {
        MyLayoutBase* lb = (MyLayoutBase*)_view.superview;
        if (!lb.isLayouting)
            [_view.superview setNeedsLayout];
    }
    
}


-(NSNumber*)posNumVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_NSNumber)
        return _posVal;
    
    return nil;
    
}

-(void)setPosNumVal:(NSNumber *)posNumVal
{
    NSAssert(0, @"oops");
}


-(MyLayoutPos*)posRelaVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Layout)
        return _posVal;
    
    return nil;
    
}

-(void)setPosRelaVal:(MyLayoutPos *)posRelaVal
{
    NSAssert(0, @"oops");
    
}



-(MyLayoutPos*)posArrVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Array)
        return _posVal;
    
    return nil;
    
}

-(void)setPosArrVal:(NSArray *)posArrVal
{
    NSAssert(0, @"oops");
}


-(CGFloat)margin
{
    CGFloat retVal = _offsetVal;
    
    if (self.posNumVal != nil)
        retVal +=self.posNumVal.floatValue;
    
    return [self validMargin:retVal];
}

-(void)setMargin:(CGFloat)margin
{
    NSAssert(0, @"oops");
    
}

-(CGFloat)validMargin:(CGFloat)margin
{
    margin = MAX(_minVal, margin);
    return MIN(_maxVal, margin);
}



-(MyLayoutPos* (^)(CGFloat val))offset
{
    return ^id(CGFloat val){
        
        _offsetVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}

-(MyLayoutPos* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        _minVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}

-(MyLayoutPos* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        _maxVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}


-(MyLayoutPos* (^)(id val))equalTo
{
    return ^id(id val){
        
        _posVal = val;
        if ([val isKindOfClass:[NSNumber class]])
            _posValType = MyLayoutValueType_NSNumber;
        else if ([val isKindOfClass:[MyLayoutPos class]])
            _posValType = MyLayoutValueType_Layout;
        else if ([val isKindOfClass:[NSArray class]])
            _posValType = MyLayoutValueType_Array;
        else
            _posValType = MyLayoutValueType_NULL;
        
        [self setNeedLayout];
        
        return self;
    };
    
}

-(void)dealloc
{
    
}


@end


//
//  MyLayoutDime.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutDime.h"
#import "MyLayoutDimeInner.h"
#import "MyBaseLayout.h"

@implementation MyLayoutDime
{
    id _dimeVal;
    CGFloat _addVal;
    CGFloat _mutilVal;
    CGFloat _minVal;
    CGFloat _maxVal;
}

-(id)init
{
    self= [super init];
    if (self !=nil)
    {
        _view = nil;
        _dime = MyMarginGravity_None;
        _dimeVal = nil;
        _dimeValType = MyLayoutValueType_Nil;
        _addVal = 0;
        _mutilVal = 1;
        _minVal = -CGFLOAT_MAX;
        _maxVal = CGFLOAT_MAX;
    }
    
    return self;
}


-(MyLayoutDime* (^)(id val))equalTo
{
    return ^id(id val){
        
        if (![_dimeVal isEqual:val])
        {
            _dimeVal = val;
            
            if ([val isKindOfClass:[NSNumber class]])
            {
                _dimeValType = MyLayoutValueType_NSNumber;
            }
            else if ([val isKindOfClass:[MyLayoutDime class]])
            {
                _dimeValType = MyLayoutValueType_Layout;
                
                //我们支持尺寸等于自己的情况，用来支持那些尺寸包裹内容但又想扩展尺寸的场景，为了不造成循环引用这里做特殊处理
                //当尺寸等于自己时，我们只记录_dimeValType，而把值设置为nil
                if (val == self)
                    _dimeVal = nil;
            }
            else if ([val isKindOfClass:[NSArray class]])
            {
                _dimeValType = MyLayoutValueType_Array;
            }
            else
            {
                _dimeValType = MyLayoutValueType_Nil;
            }
            
            [self setNeedLayout];
        }
        else
        {
            //参考上面自己等于自己的特殊情况需要特殊处理。
            if (val == nil && _dimeVal == nil && _dimeValType == MyLayoutValueType_Layout)
            {
                _dimeValType = MyLayoutValueType_Nil;
                [self setNeedLayout];
            }
        }
        
        return self;
    };
    
}

//加
-(MyLayoutDime* (^)(CGFloat val))add
{
    return ^id(CGFloat val){
        
        if (_addVal != val)
        {
            _addVal = val;
            [self setNeedLayout];
        }
        
        return self;
        
    };
    
}


//乘
-(MyLayoutDime* (^)(CGFloat val))multiply
{
    return ^id(CGFloat val){
        
        if (_mutilVal != val)
        {
            _mutilVal = val;
            [self setNeedLayout];
        }
        
        return self;
    };
    
}


-(MyLayoutDime* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        if (_minVal != val)
        {
            _minVal = val;
            [self setNeedLayout];
        }
        
        return self;
    };
}

-(MyLayoutDime* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        if (_maxVal != val)
        {
            _maxVal = val;
            [self setNeedLayout];
        }
        
        return self;
    };
}


-(void)clear
{
    _addVal = 0;
    _mutilVal = 1;
    _minVal = -CGFLOAT_MAX;
    _maxVal = CGFLOAT_MAX;
    _dimeVal = nil;
    _dimeValType = MyLayoutValueType_Nil;
    
    [self setNeedLayout];
}



-(id)dimeVal
{
    if (_dimeValType == MyLayoutValueType_Layout && _dimeVal == nil)
        return self;
    
    return _dimeVal;
}

-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_NSNumber)
        return _dimeVal;
    return nil;
}

-(MyLayoutDime*)dimeRelaVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_Layout)
        return _dimeVal;
    return nil;
    
}


-(NSArray*)dimeArrVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_Array)
        return _dimeVal;
    return nil;
    
}


-(MyLayoutDime*)dimeSelfVal
{
    if (_dimeValType == MyLayoutValueType_Layout && _dimeVal == nil)
        return self;
    
    return nil;
}


-(BOOL)isMatchParent
{
    return self.dimeRelaVal != nil && self.dimeRelaVal.view == _view.superview;
}


-(BOOL)isMatchView:(UIView*)v
{
    return self.dimeRelaVal != nil && self.dimeRelaVal.view == v;
}


-(CGFloat) measure
{
    CGFloat retVal = self.dimeNumVal.doubleValue * _mutilVal + _addVal;
    return [self validMeasure:retVal];
}

-(CGFloat)validMeasure:(CGFloat)measure
{
    measure = MAX(_minVal, measure);
    return MIN(_maxVal, measure);
}

#pragma mark -- NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    MyLayoutDime *ld = [[[self class] allocWithZone:zone] init];
    ld.view = self.view;
    ld.dime = self.dime;
    ld->_addVal = self.addVal;
    ld->_minVal = self.minVal;
    ld->_maxVal = self.maxVal;
    ld->_mutilVal = self.mutilVal;
    ld->_dimeVal = self->_dimeVal;
    ld.dimeValType = self.dimeValType;
    
    return self;
}

#pragma mark -- Private Method

-(void)setNeedLayout
{
    if (_view.superview != nil && [_view.superview isKindOfClass:[MyBaseLayout class]])
    {
        MyBaseLayout* lb = (MyBaseLayout*)_view.superview;
        if (!lb.isMyLayouting)
            [_view.superview setNeedsLayout];
    }
    
}


+(NSString*)dimestrFromDime:(MyLayoutDime*)dimeobj showView:(BOOL)showView
{
    
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", dimeobj.view];
    }
    
    NSString *dimeStr = @"";
    
    switch (dimeobj.dime) {
        case MyMarginGravity_Horz_Fill:
            dimeStr = @"WidthDime";
            break;
        case MyMarginGravity_Vert_Fill:
            dimeStr = @"HeightDime";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",viewstr,dimeStr];
    
}

-(NSString*)description
{
    NSString *dimeValStr = @"";
    switch (_dimeValType) {
        case MyLayoutValueType_Nil:
            dimeValStr = @"nil";
            break;
        case MyLayoutValueType_NSNumber:
            dimeValStr = [_dimeVal description];
            break;
        case MyLayoutValueType_Layout:
            dimeValStr = [MyLayoutDime dimestrFromDime:_dimeVal showView:YES];
            break;
        case MyLayoutValueType_Array:
        {
            dimeValStr = @"[";
            for (NSObject *obj in _dimeVal)
            {
                if ([obj isKindOfClass:[MyLayoutDime class]])
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[MyLayoutDime dimestrFromDime:(MyLayoutDime*)obj showView:YES]];
                }
                else
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[obj description]];
                    
                }
                
                if (obj != [_dimeVal lastObject])
                    dimeValStr = [dimeValStr stringByAppendingString:@", "];
                
            }
            
            dimeValStr = [dimeValStr stringByAppendingString:@"]"];
            
        }
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@=%@, Multiply=%g, Add=%g, Max=%g, Min=%g",[MyLayoutDime dimestrFromDime:self showView:NO], dimeValStr, _mutilVal, _addVal, _maxVal == CGFLOAT_MAX ? NAN : _maxVal , _minVal == -CGFLOAT_MAX ? NAN : _minVal];
    
}



@end


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
    MyLayoutDime *_lBoundVal;
    MyLayoutDime *_uBoundVal;
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
        _lBoundVal = [[MyLayoutDime alloc] initWithNoBound];
        [_lBoundVal __equalTo:@(-CGFLOAT_MAX)];
        _uBoundVal = [[MyLayoutDime alloc] initWithNoBound];
        [_uBoundVal __equalTo:@(CGFLOAT_MAX)];

        
    }
    
    return self;
}

-(id)initWithNoBound
{
    self = [super init];
    if (self !=nil)
    {
        _view = nil;
        _dime = MyMarginGravity_None;
        _dimeVal = nil;
        _dimeValType = MyLayoutValueType_Nil;
        _addVal = 0;
        _mutilVal = 1;
        _lBoundVal = nil;
        _uBoundVal = nil;
    }
    
    return self;
}


-(MyLayoutDime*)__equalTo:(id)val
{
    
    if (![_dimeVal isEqual:val])
    {
        _dimeVal = val;
        
        if ([val isKindOfClass:[NSNumber class]])
        {
            _dimeValType = MyLayoutValueType_NSNumber;
        }
        else if ([val isKindOfClass:[MyLayoutDime class]])
        {
            _dimeValType = MyLayoutValueType_LayoutDime;
            
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
        if (val == nil && _dimeVal == nil && _dimeValType == MyLayoutValueType_LayoutDime)
        {
            _dimeValType = MyLayoutValueType_Nil;
            [self setNeedLayout];
        }
    }
    
    return self;
}

//加
-(MyLayoutDime*)__add:(CGFloat)val
{
    
    
    if (_addVal != val)
    {
        _addVal = val;
        [self setNeedLayout];
    }
    
    return self;
}


//乘
-(MyLayoutDime*)__multiply:(CGFloat)val
{
    
    if (_mutilVal != val)
    {
        _mutilVal = val;
        [self setNeedLayout];
    }
    
    return self;
    
}


-(MyLayoutDime*)__min:(CGFloat)val
{
    if (_lBoundVal.dimeNumVal.doubleValue != val)
    {
        [_lBoundVal __equalTo:@(val)];
        [self setNeedLayout];
    }
    
    return self;
}


-(MyLayoutDime*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
        sizeVal = _lBoundVal;
    
    [[[_lBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    [self setNeedLayout];
    
    return self;
}


-(MyLayoutDime*)__max:(CGFloat)val
{
    if (_uBoundVal.dimeNumVal.doubleValue != val)
    {
        [_uBoundVal __equalTo:@(val)];
        [self setNeedLayout];
    }
    
    return self;
}

-(MyLayoutDime*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
        sizeVal = _uBoundVal;
    
    [[[_uBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    [self setNeedLayout];
    
    return self;
}



-(void)__clear
{
    _addVal = 0;
    _mutilVal = 1;
    [[[_lBoundVal __equalTo:@(-CGFLOAT_MAX)] __add:0] __multiply:1];
    [[[_uBoundVal __equalTo:@(CGFLOAT_MAX)] __add:0] __multiply:1];
    _dimeVal = nil;
    _dimeValType = MyLayoutValueType_Nil;
    
    [self setNeedLayout];
}


-(MyLayoutDime* (^)(id val))myEqualTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}

-(MyLayoutDime* (^)(CGFloat val))myAdd
{
    return ^id(CGFloat val){
        
        return [self __add:val];
    };
}

-(MyLayoutDime* (^)(CGFloat val))myMultiply
{
    return ^id(CGFloat val){
        
        return [self __multiply:val];
    };
    
}

-(MyLayoutDime* (^)(CGFloat val))myMin
{
    return ^id(CGFloat val){
        
        return [self __min:val];
    };
    
}

-(MyLayoutDime* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myLBound
{
    
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        
        return [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
        
    };
}

-(MyLayoutDime* (^)(CGFloat val))myMax
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(MyLayoutDime* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myUBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        
        return [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
    };
    
}

-(void)myClear
{
    [self __clear];
}


-(MyLayoutDime* (^)(id val))equalTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}

-(MyLayoutDime* (^)(CGFloat val))add
{
     return ^id(CGFloat val){
     
         return [self __add:val];
     };
}

-(MyLayoutDime* (^)(CGFloat val))multiply
{
    return ^id(CGFloat val){
        
        return [self __multiply:val];
    };

}

-(MyLayoutDime* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
    
        return [self __min:val];
    };

}

-(MyLayoutDime* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))lBound
{
    
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
      
        return [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
        
    };
}

-(MyLayoutDime* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(MyLayoutDime* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))uBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
    
        return [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
    };

}

-(void)clear
{
    [self __clear];
}



-(id)dimeVal
{
    if (_dimeValType == MyLayoutValueType_LayoutDime && _dimeVal == nil)
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
    if (_dimeValType == MyLayoutValueType_LayoutDime)
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
    if (_dimeValType == MyLayoutValueType_LayoutDime && _dimeVal == nil)
        return self;
    
    return nil;
}


-(MyLayoutDime*)lBoundVal
{
    return _lBoundVal;
}

-(MyLayoutDime*)uBoundVal
{
    return _uBoundVal;
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
    return self.dimeNumVal.doubleValue * _mutilVal + _addVal;
}

-(CGFloat)measureWith:(CGFloat)size
{
    return size * _mutilVal + _addVal;
}



#pragma mark -- NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    MyLayoutDime *ld = [[[self class] allocWithZone:zone] init];
    ld.view = self.view;
    ld.dime = self.dime;
    ld->_addVal = self.addVal;
    [[[ld->_lBoundVal __equalTo:_lBoundVal.dimeVal] __add:_lBoundVal.addVal] __multiply:_lBoundVal.mutilVal];
    [[[ld->_uBoundVal __equalTo:_uBoundVal.dimeVal] __add:_uBoundVal.addVal] __multiply:_uBoundVal.mutilVal];
    ld->_mutilVal = self.mutilVal;
    ld->_dimeVal = self->_dimeVal;
    ld.dimeValType = self.dimeValType;
    
    return self;
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
            dimeStr = @"widthDime";
            break;
        case MyMarginGravity_Vert_Fill:
            dimeStr = @"heightDime";
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
        case MyLayoutValueType_LayoutDime:
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
    
    return [NSString stringWithFormat:@"%@=%@, Multiply=%g, Add=%g, Max=%g, Min=%g",[MyLayoutDime dimestrFromDime:self showView:NO], dimeValStr, _mutilVal, _addVal, _uBoundVal.dimeNumVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.dimeNumVal.doubleValue , _lBoundVal.dimeNumVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.dimeNumVal.doubleValue];
    
}



@end


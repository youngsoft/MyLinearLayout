//
//  MyLayoutSize.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLayoutSize.h"
#import "MyLayoutSizeInner.h"
#import "MyBaseLayout.h"


@implementation MyLayoutSize
{
    id _dimeVal;
    CGFloat _addVal;
    CGFloat _multiVal;
    MyLayoutSize *_lBoundVal;
    MyLayoutSize *_uBoundVal;
}

-(id)init
{
    self= [super init];
    if (self !=nil)
    {
        _active = YES;
        _view = nil;
        _dime = MyGravity_None;
        _dimeVal = nil;
        _dimeValType = MyLayoutValueType_Nil;
        _addVal = 0;
        _multiVal = 1;
        _lBoundVal = nil;
        _uBoundVal = nil;
    }
    
    return self;
}


-(MyLayoutSize* (^)(id val))myEqualTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}

-(MyLayoutSize* (^)(CGFloat val))myAdd
{
    return ^id(CGFloat val){
        
        return [self __add:val];
    };
}

-(MyLayoutSize* (^)(CGFloat val))myMultiply
{
    return ^id(CGFloat val){
        
        return [self __multiply:val];
    };
    
}

-(MyLayoutSize* (^)(CGFloat val))myMin
{
    return ^id(CGFloat val){
        
        return [self __min:val];
    };
    
}

-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myLBound
{
    
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        
        return [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
        
    };
}

-(MyLayoutSize* (^)(CGFloat val))myMax
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myUBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        
        return [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
    };
    
}

-(void)myClear
{
    [self __clear];
}


-(MyLayoutSize* (^)(id val))equalTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}

-(MyLayoutSize* (^)(CGFloat val))add
{
     return ^id(CGFloat val){
     
         return [self __add:val];
     };
}

-(MyLayoutSize* (^)(CGFloat val))multiply
{
    return ^id(CGFloat val){
        
        return [self __multiply:val];
    };

}

-(MyLayoutSize* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
    
        return [self __min:val];
    };

}

-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))lBound
{
    
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
      
        return [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
        
    };
}

-(MyLayoutSize* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))uBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
    
        return [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
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



-(id)dimeVal
{
    if (self.isActive)
    {
        if (_dimeValType == MyLayoutValueType_LayoutDime && _dimeVal == nil)
            return self;
        
        return _dimeVal;
    }
    else
        return nil;
    
}

-(CGFloat)minVal
{
    return (self.isActive && _lBoundVal != nil) ?  _lBoundVal.dimeNumVal.doubleValue : -CGFLOAT_MAX;
}

-(CGFloat)maxVal
{
    return (self.isActive && _uBoundVal != nil) ?  _uBoundVal.dimeNumVal.doubleValue : CGFLOAT_MAX;
}


#pragma mark -- NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    MyLayoutSize *ld = [[[self class] allocWithZone:zone] init];
    ld.view = self.view;
    ld->_active = _active;
    ld->_dime = _dime;
    ld->_addVal = _addVal;
    ld->_multiVal = _multiVal;
    ld->_dimeVal = _dimeVal;
    ld->_dimeValType = _dimeValType;
    if (_lBoundVal != nil)
    {
        ld->_lBoundVal = [[[self class] allocWithZone:zone] init];
        ld->_lBoundVal->_active = _active;
        [[[ld->_lBoundVal __equalTo:_lBoundVal.dimeVal] __add:_lBoundVal.addVal] __multiply:_lBoundVal.multiVal];

    }
    
    if (_uBoundVal != nil)
    {
        ld->_uBoundVal = [[[self class] allocWithZone:zone] init];
        ld->_uBoundVal->_active = _active;
        [[[ld->_uBoundVal __equalTo:_uBoundVal.dimeVal] __add:_uBoundVal.addVal] __multiply:_uBoundVal.multiVal];
        
    }
  
    
    return self;
}

#pragma mark -- Private Method


-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    
    if (_dimeValType == MyLayoutValueType_NSNumber)
        return _dimeVal;
    return nil;
}

-(MyLayoutSize*)dimeRelaVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    if (_dimeValType == MyLayoutValueType_LayoutDime)
        return _dimeVal;
    return nil;
    
}


-(NSArray*)dimeArrVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    if (_dimeValType == MyLayoutValueType_Array)
        return _dimeVal;
    return nil;
    
}


-(MyLayoutSize*)dimeSelfVal
{
    if (_dimeValType == MyLayoutValueType_LayoutDime && _dimeVal == nil && self.isActive)
        return self;
    
    return nil;
}


-(MyLayoutSize*)lBoundVal
{
    if (_lBoundVal == nil)
    {
        _lBoundVal = [[MyLayoutSize alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal __equalTo:@(-CGFLOAT_MAX)];
    }
    
    return _lBoundVal;
}

-(MyLayoutSize*)uBoundVal
{
    
    if (_uBoundVal == nil)
    {
        _uBoundVal = [[MyLayoutSize alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal __equalTo:@(CGFLOAT_MAX)];
    }
    return _uBoundVal;
}

-(MyLayoutSize*)lBoundValInner
{
    return _lBoundVal;
}

-(MyLayoutSize*)uBoundValInner
{
    return _uBoundVal;
}


-(MyLayoutSize*)__equalTo:(id)val
{
    
    if (![_dimeVal isEqual:val])
    {
        if ([val isKindOfClass:[NSNumber class]])
        {
            _dimeValType = MyLayoutValueType_NSNumber;
        }
        else if ([val isMemberOfClass:[MyLayoutSize class]])
        {
            _dimeValType = MyLayoutValueType_LayoutDime;
            
            //我们支持尺寸等于自己的情况，用来支持那些尺寸包裹内容但又想扩展尺寸的场景，为了不造成循环引用这里做特殊处理
            //当尺寸等于自己时，我们只记录_dimeValType，而把值设置为nil
            if (val == self)
            {
                val = nil;
            }
        }
        else if ([val isKindOfClass:[UIView class]])
        {
            
            UIView *rview = (UIView*)val;
            _dimeValType = MyLayoutValueType_LayoutDime;
            
            switch (_dime) {
                case MyGravity_Horz_Fill:
                    val = rview.widthSize;
                    break;
                case MyGravity_Vert_Fill:
                    val = rview.heightSize;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }

        }
        else if ([val isKindOfClass:[NSArray class]])
        {
            _dimeValType = MyLayoutValueType_Array;
        }
        else
        {
            _dimeValType = MyLayoutValueType_Nil;
        }
        
        _dimeVal = val;
        [self setNeedsLayout];
    }
    else
    {
        //参考上面自己等于自己的特殊情况需要特殊处理。
        if (val == nil && _dimeVal == nil && _dimeValType == MyLayoutValueType_LayoutDime)
        {
            _dimeValType = MyLayoutValueType_Nil;
            [self setNeedsLayout];
        }
    }
    
    return self;
}

//加
-(MyLayoutSize*)__add:(CGFloat)val
{
    
    if (_addVal != val)
    {
        _addVal = val;
        [self setNeedsLayout];
    }
    
    return self;
}


//乘
-(MyLayoutSize*)__multiply:(CGFloat)val
{
    
    if (_multiVal != val)
    {
        _multiVal = val;
        [self setNeedsLayout];
    }
    
    return self;
    
}


-(MyLayoutSize*)__min:(CGFloat)val
{
    if (self.lBoundVal.dimeNumVal.doubleValue != val)
    {
        [self.lBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }
    
    return self;
}


-(MyLayoutSize*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
        sizeVal = self.lBoundVal;
    
    [[[self.lBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    [self setNeedsLayout];
    
    return self;
}


-(MyLayoutSize*)__max:(CGFloat)val
{
    if (self.uBoundVal.dimeNumVal.doubleValue != val)
    {
        [self.uBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }
    
    return self;
}

-(MyLayoutSize*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
        sizeVal = self.uBoundVal;
    
    [[[self.uBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    [self setNeedsLayout];
    
    return self;
}



-(void)__clear
{
    _active = YES;
    _addVal = 0;
    _multiVal = 1;
    _lBoundVal = nil;
    _uBoundVal = nil;
    _dimeVal = nil;
    _dimeValType = MyLayoutValueType_Nil;
    
    [self setNeedsLayout];
}





-(CGFloat) measure
{
    return self.isActive ? self.dimeNumVal.doubleValue * _multiVal + _addVal : 0;
}

-(CGFloat)measureWith:(CGFloat)size
{
    return self.isActive ?  size * _multiVal + _addVal : size;
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


+(NSString*)dimestrFromDime:(MyLayoutSize*)dimeobj showView:(BOOL)showView
{
    
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", dimeobj.view];
    }
    
    NSString *dimeStr = @"";
    
    switch (dimeobj.dime) {
        case MyGravity_Horz_Fill:
            dimeStr = @"widthSize";
            break;
        case MyGravity_Vert_Fill:
            dimeStr = @"heightSize";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",viewstr,dimeStr];
    
}

#pragma mark -- Override Method

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
            dimeValStr = [MyLayoutSize dimestrFromDime:_dimeVal showView:YES];
            break;
        case MyLayoutValueType_Array:
        {
            dimeValStr = @"[";
            for (NSObject *obj in _dimeVal)
            {
                if ([obj isMemberOfClass:[MyLayoutSize class]])
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[MyLayoutSize dimestrFromDime:(MyLayoutSize*)obj showView:YES]];
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
    
    return [NSString stringWithFormat:@"%@=%@, Multiply=%g, Add=%g, Max=%g, Min=%g",[MyLayoutSize dimestrFromDime:self showView:NO], dimeValStr, _multiVal, _addVal, _uBoundVal.dimeNumVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.dimeNumVal.doubleValue , _lBoundVal.dimeNumVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.dimeNumVal.doubleValue];
    
}



@end


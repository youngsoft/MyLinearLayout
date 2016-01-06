//
//  YSLayoutDime.m
//  YSLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "YSLayoutDime.h"
#import "YSLayoutDimeInner.h"
#import "YSLayoutBase.h"

@implementation YSLayoutDime
{
    CGFloat _addVal;
    CGFloat _minVal;
    CGFloat _maxVal;
    CGFloat _mutilVal;
    id _dimeVal;
}

-(id)init
{
    self= [super init];
    if (self !=nil)
    {
        _view = nil;
        _dime = YSMarginGravity_None;
        _addVal = 0;
        _mutilVal = 1;
        _minVal = -CGFLOAT_MAX;
        _maxVal = CGFLOAT_MAX;
        _dimeVal = nil;
        _dimeValType = YSLayoutValueType_Nil;
    }
    
    return self;
}

-(void)setNeedLayout
{
    if (_view.superview != nil && [_view.superview isKindOfClass:[YSLayoutBase class]])
    {
        YSLayoutBase* lb = (YSLayoutBase*)_view.superview;
        if (!lb.isLayouting)
            [_view.superview setNeedsLayout];
    }
    
}

//乘
-(YSLayoutDime* (^)(CGFloat val))multiply
{
    return ^id(CGFloat val){
        
        _mutilVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
    
}

//加
-(YSLayoutDime* (^)(CGFloat val))add
{
    return ^id(CGFloat val){
        
        _addVal = val;
        
        [self setNeedLayout];
        
        return self;
        
    };
    
}

-(YSLayoutDime* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        _minVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}

-(YSLayoutDime* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        _maxVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}


-(YSLayoutDime* (^)(id val))equalTo
{
    return ^id(id val){
        
        _dimeVal = val;
        
        if ([val isKindOfClass:[NSNumber class]])
            _dimeValType = YSLayoutValueType_NSNumber;
        else if ([val isKindOfClass:[YSLayoutDime class]])
            _dimeValType = YSLayoutValueType_Layout;
        else if ([val isKindOfClass:[NSArray class]])
            _dimeValType = YSLayoutValueType_Array;
        else
            _dimeValType = YSLayoutValueType_Nil;
        
        [self setNeedLayout];
        
        return self;
    };
    
}

-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == YSLayoutValueType_NSNumber)
        return _dimeVal;
    return nil;
}

-(void)setDimeNumVal:(NSNumber *)dimeNumVal
{
    NSAssert(0, @"oops");
}


-(NSArray*)dimeArrVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == YSLayoutValueType_Array)
        return _dimeVal;
    return nil;
    
}

-(void)setDimeArrVal:(NSArray *)dimeArrVal
{
    NSAssert(0, @"oops");
    
}

-(YSLayoutDime*)dimeRelaVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == YSLayoutValueType_Layout)
        return _dimeVal;
    return nil;
    
}

-(void)setDimeRelaVal:(YSLayoutDime *)dimeRelaVal
{
    NSAssert(0, @"oops");
    
}

-(BOOL)isMatchParent
{
    return self.dimeRelaVal != nil && self.dimeRelaVal.view == _view.superview;
}

-(void)setIsMatchParent:(BOOL)isMatchParent
{
    NSAssert(0, @"oops");
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



-(void)setMeasure:(CGFloat)measure
{
    NSAssert(0, @"oops");
}


+(NSString*)dimestrFromDime:(YSLayoutDime*)dimeobj showView:(BOOL)showView
{
    
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", dimeobj.view];
    }
    
    NSString *dimeStr = @"";
    
    switch (dimeobj.dime) {
        case YSMarignGravity_Horz_Fill:
            dimeStr = @"WidthDime";
            break;
        case YSMarignGravity_Vert_Fill:
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
        case YSLayoutValueType_Nil:
            dimeValStr = @"nil";
            break;
        case YSLayoutValueType_NSNumber:
            dimeValStr = [_dimeVal description];
            break;
        case YSLayoutValueType_Layout:
            dimeValStr = [YSLayoutDime dimestrFromDime:_dimeVal showView:YES];
            break;
        case YSLayoutValueType_Array:
        {
            dimeValStr = @"[";
            for (NSObject *obj in _dimeVal)
            {
                if ([obj isKindOfClass:[YSLayoutDime class]])
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[YSLayoutDime dimestrFromDime:(YSLayoutDime*)obj showView:YES]];
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
    
    return [NSString stringWithFormat:@"%@=%@, Multiply=%g, Add=%g, Max=%g, Min=%g",[YSLayoutDime dimestrFromDime:self showView:NO], dimeValStr, _mutilVal, _addVal, _maxVal == CGFLOAT_MAX ? NAN : _maxVal , _minVal == -CGFLOAT_MAX ? NAN : _minVal];
    
}


@end


//
//  YSLayoutPos.m
//  YSLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "YSLayoutPos.h"
#import "YSLayoutPosInner.h"
#import "YSLayoutBase.h"



@implementation YSLayoutPos
{
    CGFloat _offsetVal;
    CGFloat _minVal;
    CGFloat _maxVal;
    id _posVal;

}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _view = nil;
        _pos = YSMarginGravity_None;
        _posVal = nil;
        _posValType = YSLayoutValueType_Nil;
        _offsetVal = 0;
        _minVal = -CGFLOAT_MAX;
        _maxVal = CGFLOAT_MAX;
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


-(NSNumber*)posNumVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == YSLayoutValueType_NSNumber)
        return _posVal;
        
    return nil;
    
}


-(YSLayoutPos*)posRelaVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == YSLayoutValueType_Layout)
        return _posVal;
    
    return nil;
    
}



-(YSLayoutPos*)posArrVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == YSLayoutValueType_Array)
        return _posVal;
    
    return nil;
    
}


-(CGFloat)margin
{
    CGFloat retVal = _offsetVal;
    
    if (self.posNumVal != nil)
        retVal +=self.posNumVal.doubleValue;
    
    return [self validMargin:retVal];
}


-(CGFloat)validMargin:(CGFloat)margin
{
    margin = MAX(_minVal, margin);
    return MIN(_maxVal, margin);
}



-(YSLayoutPos* (^)(CGFloat val))offset
{
    return ^id(CGFloat val){
        
        _offsetVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}

-(YSLayoutPos* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        _minVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}

-(YSLayoutPos* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        _maxVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}


-(YSLayoutPos* (^)(id val))equalTo
{
    return ^id(id val){
        
        _posVal = val;
        if ([val isKindOfClass:[NSNumber class]])
            _posValType = YSLayoutValueType_NSNumber;
        else if ([val isKindOfClass:[YSLayoutPos class]])
            _posValType = YSLayoutValueType_Layout;
        else if ([val isKindOfClass:[NSArray class]])
            _posValType = YSLayoutValueType_Array;
        else
            _posValType = YSLayoutValueType_Nil;
        
        [self setNeedLayout];
        
        return self;
    };
    
}


+(NSString*)posstrFromPos:(YSLayoutPos*)posobj showView:(BOOL)showView
{
    
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", posobj.view];
    }
    
    NSString *posStr = @"";
    
    switch (posobj.pos) {
        case YSMarignGravity_Horz_Left:
            posStr = @"LeftPos";
            break;
        case YSMarignGravity_Horz_Center:
            posStr = @"CenterXPos";
            break;
        case YSMarignGravity_Horz_Right:
            posStr = @"RightPos";
            break;
        case YSMarignGravity_Vert_Top:
            posStr = @"TopPos";
            break;
        case YSMarignGravity_Vert_Center:
            posStr = @"CenterYPos";
            break;
        case YSMarignGravity_Vert_Bottom:
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
        case YSLayoutValueType_Nil:
            posValStr = @"nil";
            break;
        case YSLayoutValueType_NSNumber:
            posValStr = [_posVal description];
            break;
        case YSLayoutValueType_Layout:
            posValStr = [YSLayoutPos posstrFromPos:_posVal showView:YES];
            break;
        case YSLayoutValueType_Array:
        {
            posValStr = @"[";
            for (NSObject *obj in _posVal)
            {
                if ([obj isKindOfClass:[YSLayoutPos class]])
                {
                    posValStr = [posValStr stringByAppendingString:[YSLayoutPos posstrFromPos:(YSLayoutPos*)obj showView:YES]];
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

    return [NSString stringWithFormat:@"%@=%@, Offset=%g, Max=%g, Min=%g",[YSLayoutPos posstrFromPos:self showView:NO], posValStr, _offsetVal, _maxVal == CGFLOAT_MAX ? NAN : _maxVal , _minVal == -CGFLOAT_MAX ? NAN : _minVal];
   
}



@end


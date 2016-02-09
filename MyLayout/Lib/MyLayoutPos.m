//
//  MyLayoutPos.m
//  MyLayout
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutPos.h"
#import "MyLayoutPosInner.h"
#import "MyBaseLayout.h"



@implementation MyLayoutPos
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
        _pos = MyMarginGravity_None;
        _posVal = nil;
        _posValType = MyLayoutValueType_Nil;
        _offsetVal = 0;
        _minVal = -CGFLOAT_MAX;
        _maxVal = CGFLOAT_MAX;
    }
    
    return self;
}

-(void)setNeedLayout
{
    if (_view.superview != nil && [_view.superview isKindOfClass:[MyBaseLayout class]])
    {
        MyBaseLayout* lb = (MyBaseLayout*)_view.superview;
        if (!lb.isMyLayouting)
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


-(MyLayoutPos*)posRelaVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Layout)
        return _posVal;
    
    return nil;
    
}



-(MyLayoutPos*)posArrVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Array)
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
            _posValType = MyLayoutValueType_Nil;
        
        [self setNeedLayout];
        
        return self;
    };
    
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
        case MyLayoutValueType_Layout:
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

    return [NSString stringWithFormat:@"%@=%@, Offset=%g, Max=%g, Min=%g",[MyLayoutPos posstrFromPos:self showView:NO], posValStr, _offsetVal, _maxVal == CGFLOAT_MAX ? NAN : _maxVal , _minVal == -CGFLOAT_MAX ? NAN : _minVal];
   
}

#pragma mark -- NSCopying  

-(id)copyWithZone:(NSZone *)zone
{
    MyLayoutPos *lp = [[[self class] allocWithZone:zone] init];
    lp.view = self.view;
    lp.pos = self.pos;
    lp.posValType = self.posValType;
    lp->_offsetVal = self.offsetVal;
    lp->_minVal = self.minVal;
    lp->_maxVal = self.maxVal;
    lp->_posVal = self->_posVal;
    
    return lp;

}



@end


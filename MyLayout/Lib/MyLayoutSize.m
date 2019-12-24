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
#import "MyLayoutInner.h"


@implementation MyLayoutSize
{
    id _dimeVal;
    CGFloat _addVal;
    CGFloat _multiVal;
    MyLayoutSize *_lBoundVal;
    MyLayoutSize *_uBoundVal;
}

+(NSInteger)empty
{
    return -100000; //这么定义存粹是一个数字没有其他意义
}

+(NSInteger)wrap
{
    return -99999;  //这么定义纯粹是一个数字没有其他意义
}

+(NSInteger)fill
{
    return -99998;  //这么定义纯粹是一个数字没有其他意义
}

+(NSInteger)average
{
    return -99997;  //这么定义纯粹是一个数字没有其他意义
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
        _shrink = 0.0;
        _priority = MyPriority_Normal;
    }
    
    return self;
}

-(MyLayoutSize* (^)(id val))myEqualTo
{
    return ^id(id val){
        
        [self __equalTo:val];
        
        //如果尺寸是自适应，并且当前视图是布局视图则直接布局视图自身刷新布局，否则由视图的父视图来刷新布局，这里特殊处理。
        if ([val isKindOfClass:[NSNumber class]])
        {
            if ([val integerValue] == MyLayoutSize.wrap && [self->_view isKindOfClass:[MyBaseLayout class]])
            {
                [self->_view setNeedsLayout];
                return self;
            }
        }
        [self setNeedsLayout];
        
        return self;
    };
}

-(MyLayoutSize* (^)(CGFloat val))myAdd
{
    return ^id(CGFloat val){
        [self __add:val];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutSize* (^)(CGFloat val))myMultiply
{
    return ^id(CGFloat val){
        [self __multiply:val];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutSize* (^)(CGFloat val))myMin
{
    return ^id(CGFloat val){
        [self __min:val];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myLBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutSize* (^)(CGFloat val))myMax
{
    return ^id(CGFloat val){
        [self __max:val];
        [self setNeedsLayout];
        return self;
    };
}

-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))myUBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
        [self setNeedsLayout];
        return self;
    };
}

-(void)myClear
{
    [self __clear];
    [self setNeedsLayout];
}

-(MyLayoutSize* (^)(id val))equalTo
{
    return self.myEqualTo;
}

-(MyLayoutSize* (^)(CGFloat val))add
{
    return self.myAdd;
}

-(MyLayoutSize* (^)(CGFloat val))multiply
{
    return self.myMultiply;
}

-(MyLayoutSize* (^)(CGFloat val))min
{
    return self.myMin;
}

-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))lBound
{
    return self.myLBound;
}

-(MyLayoutSize* (^)(CGFloat val))max
{
    return self.myMax;
}

-(MyLayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))uBound
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
    return _active ? _shrink : 0.0;
}

-(id)dimeVal
{
    return self.isActive ? _dimeVal : nil;
}

-(BOOL)isWrap
{
    return _dimeValType == MyLayoutValueType_Wrap;
}

-(BOOL)isFill
{
    return _dimeValType == MyLayoutValueType_Fill;
}

#pragma mark -- NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    MyLayoutSize *layoutSize = [[[self class] allocWithZone:zone] init];
    layoutSize.view = self.view;
    layoutSize->_active = _active;
    layoutSize->_shrink = _shrink;
    layoutSize->_dime = _dime;
    layoutSize->_addVal = _addVal;
    layoutSize->_multiVal = _multiVal;
    layoutSize->_dimeVal = _dimeVal;
    layoutSize->_dimeValType = _dimeValType;
    layoutSize->_priority = _priority;
    if (_lBoundVal != nil)
    {
        layoutSize->_lBoundVal = [[[self class] allocWithZone:zone] init];
        layoutSize->_lBoundVal->_active = _active;
        [[[layoutSize->_lBoundVal __equalTo:_lBoundVal.dimeVal] __add:_lBoundVal.addVal] __multiply:_lBoundVal.multiVal];
    }
    
    if (_uBoundVal != nil)
    {
        layoutSize->_uBoundVal = [[[self class] allocWithZone:zone] init];
        layoutSize->_uBoundVal->_active = _active;
        [[[layoutSize->_uBoundVal __equalTo:_uBoundVal.dimeVal] __add:_uBoundVal.addVal] __multiply:_uBoundVal.multiVal];
    }
  
    return layoutSize;
}

#pragma mark -- Private Methods

-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    
    if (_dimeValType == MyLayoutValueType_NSNumber)
        return _dimeVal;
    
    if (_dimeValType == MyLayoutValueType_Most)
        return @([((MyLayoutMostSize*)_dimeVal) getMostSizeFrom:self]);
    
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

-(BOOL)dimeWrapVal
{
    return self.isActive && _dimeValType == MyLayoutValueType_Wrap;
}

-(BOOL)dimeFillVal
{
    return self.isActive && _dimeValType == MyLayoutValueType_Fill;
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
    return [self __equalTo:val priority:MyPriority_Normal];
}

-(MyLayoutSize*)__equalTo:(id)val priority:(NSInteger)priority
{
    _priority = priority;
    
    if (![_dimeVal isEqual:val])
    {
        if ([val isKindOfClass:[NSNumber class]])
        {
            //特殊处理。
            if ([val integerValue] == MyLayoutSize.wrap)
                _dimeValType = MyLayoutValueType_Wrap;
            else if ([val integerValue] == MyLayoutSize.fill)
                _dimeValType = MyLayoutValueType_Fill;
            else if ([val integerValue] == MyLayoutSize.empty)
            {
                _dimeValType = MyLayoutValueType_Nil;
                val = nil;
            }
            else
                _dimeValType = MyLayoutValueType_NSNumber;
        }
        else if ([val isMemberOfClass:[MyLayoutSize class]])
        {
            //我们支持尺寸等于自己的情况，用来支持那些尺寸包裹内容但又想扩展尺寸的场景，为了不造成循环引用这里做特殊处理
            //当尺寸等于自己时，我们只记录_dimeValType，而把值设置为nil
            if (val == self)
            {
#if DEBUG
                NSLog(@"不建议这样设置，请使用MyLayoutSize.wrap代替！");
#endif
                _dimeValType = MyLayoutValueType_Wrap;
                val = @(MyLayoutSize.wrap);
            }
            else
            {
                _dimeValType = MyLayoutValueType_LayoutDime;
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
        else if ([val isKindOfClass:[MyLayoutMostSize class]])
        {
            _dimeValType = MyLayoutValueType_Most;
        }
        else
        {
            _dimeValType = MyLayoutValueType_Nil;
        }
        
        //特殊处理UILabel的高度是wrap的情况。
        if (_dimeValType == MyLayoutValueType_Wrap && _view != nil && _dime == MyGravity_Vert_Fill)
        {
            if([_view isKindOfClass:[UILabel class]])
            {
                if (((UILabel*)_view).numberOfLines == 1)
                    ((UILabel*)_view).numberOfLines = 0;
            }
        }
        
        _dimeVal = val;
    }
    
    return self;
}

//加
-(MyLayoutSize*)__add:(CGFloat)val
{
    if (_addVal != val)
        _addVal = val;
    
    return self;
}

//乘
-(MyLayoutSize*)__multiply:(CGFloat)val
{
    if (_multiVal != val)
        _multiVal = val;
    
    return self;
}

-(MyLayoutSize*)__min:(CGFloat)val
{
    if (self.lBoundVal.dimeNumVal.doubleValue != val)
        [self.lBoundVal __equalTo:@(val)];
    
    return self;
}

-(MyLayoutSize*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
    {
#if DEBUG
        NSLog(@"不建议这样设置，请使用MyLayoutSize.wrap代替！");
#endif
        sizeVal = @(MyLayoutSize.wrap);
    }
    
    [[[self.lBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    return self;
}


-(MyLayoutSize*)__max:(CGFloat)val
{
    if (self.uBoundVal.dimeNumVal.doubleValue != val)
        [self.uBoundVal __equalTo:@(val)];
    
    return self;
}

-(MyLayoutSize*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
    {
#if DEBUG
        NSLog(@"不建议这样设置，请使用MyLayoutSize.wrap代替！");
#endif
        sizeVal = @(MyLayoutSize.wrap);
    }
    
    [[[self.uBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    
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
    _shrink = 0;
    _priority = MyPriority_Normal;
    _dimeValType = MyLayoutValueType_Nil;
}

-(void)__setActive:(BOOL)active
{
    _active = active;
    [_lBoundVal __setActive:active];
    [_uBoundVal __setActive:active];
}

-(CGFloat) measure
{
    return self.isActive ? _myCGFloatFma(self.dimeNumVal.doubleValue,  _multiVal,  _addVal) : 0;
}

-(CGFloat)measureWith:(CGFloat)size
{
    return self.isActive ?  _myCGFloatFma(size, _multiVal , _addVal) : size;
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
        viewstr = [NSString stringWithFormat:@"View:%p.", dimeobj.view];
    
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

#pragma mark -- Override Methods

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
        case MyLayoutValueType_Wrap:
            dimeValStr = @"wrap";
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
                    dimeValStr = [dimeValStr stringByAppendingString:[MyLayoutSize dimestrFromDime:(MyLayoutSize*)obj showView:YES]];
                else
                    dimeValStr = [dimeValStr stringByAppendingString:[obj description]];
                
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


@implementation MyLayoutSize(Clone)

-(MyLayoutSize* (^)(CGFloat addVal, CGFloat multiVal))clone
{
    return ^id(CGFloat addVal, CGFloat multiVal){
        
        MyLayoutSize *clonedSize = [[[self class] allocWithZone:nil] init];
        clonedSize->_addVal = addVal;
        clonedSize->_multiVal = multiVal;
        clonedSize->_dimeVal = self;
        clonedSize->_dimeValType = MyLayoutValueType_LayoutDimeClone;
        return clonedSize;
    };
}

@end

#pragma mark -- MyLayoutMostSize

@implementation MyLayoutMostSize
{
    NSArray *_sizes;
    BOOL _isMax;
}

-(instancetype)initWith:(NSArray *)sizes isMax:(BOOL)isMax
{
    self = [self init];
    if (self != nil)
    {
        _sizes = sizes;
        _isMax = isMax;
    }
    
    return self;
}

-(CGFloat)getMostSizeFrom:(MyLayoutSize *)layoutSize
{
    CGFloat retVal = _isMax ? -CGFLOAT_MAX : CGFLOAT_MAX;
    
    for (id size in _sizes)
    {
        CGFloat val = 0;
        
        if ([size isKindOfClass:[NSNumber class]])
        {
            val = [(NSNumber*)size doubleValue];
            if (val == MyLayoutSize.wrap)
            {//特殊的自适应值。
                CGSize sz = [layoutSize.view sizeThatFits:CGSizeZero];
                if (layoutSize.dime == MyGravity_Horz_Fill)
                    val = sz.width;
                else
                    val = sz.height;
            }
        }
        else if ([size isKindOfClass:[MyLayoutSize class]])
        {
            MyLayoutSize *lsize = (MyLayoutSize *)size;
            CGFloat addVal = 0;
            CGFloat multiVal = 1;
            if (lsize.dimeValType == MyLayoutValueType_LayoutDimeClone)
            {
                addVal = lsize.addVal;
                multiVal = lsize.multiVal;
                lsize = (MyLayoutSize *)lsize.dimeVal;
            }
           
            val = (lsize.dime == MyGravity_Horz_Fill) ? lsize.view.myEstimatedWidth : lsize.view.myEstimatedHeight;
            val *= multiVal;
            val += addVal;
        }
        else
        {
            NSAssert(NO, @"oops!, invalid type, only support NSNumber or MyLayoutSize");
        }
        
        retVal = _isMax ? _myCGFloatMax(val, retVal) : _myCGFloatMin(val, retVal);
    }
    
    return retVal;
}

@end


@implementation NSArray(MyLayoutMostSize)

-(MyLayoutMostSize *)myMinSize
{
    return [[MyLayoutMostSize alloc] initWith:self isMax:NO];
}

-(MyLayoutMostSize *)myMaxSize
{
    return [[MyLayoutMostSize alloc] initWith:self isMax:YES];
}

@end

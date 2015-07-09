//
//  MyRelativeLayout.m
//  MyLinearLayoutDemo
//
//  Created by fzy on 15/7/1.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyRelativeLayout.h"

#import <objc/runtime.h>


const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_LEFT = "associatedobject_key_relativeleft";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_TOP = "associatedobject_key_relativetop";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_RIGHT = "associatedobject_key_relativeright";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_BOTTOM = "associatedobject_key_relativebottom";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_WIDTH = "associatedobject_key_relativewidth";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_HEIGHT = "associatedobject_key_relativeheight";

const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERX = "associatedobject_key_relativecenterx";
const char * const ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERY = "associatedobject_key_relativecentery";


const char * const ASSOCIATEDOBJECT_KEY_ABSOLUTE_POS = "associatedobject_key_absolutepos";



//相对位置。
@interface MyRelativePos()
@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MarignGravity pos;
@property(nonatomic, strong) id posVal;

@property(nonatomic, readonly) NSNumber *posNumVal;
@property(nonatomic, readonly) MyRelativePos *posRelaVal;
@property(nonatomic, readonly) NSArray *posArrVal;

@end

@implementation MyRelativePos

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _view = nil;
        _pos = MGRAVITY_NONE;
        _posVal = nil;
    }
    
    return self;
}

-(NSNumber*)posNumVal
{
    if (_posVal == nil)
        return nil;
    
    if ([_posVal isKindOfClass:[NSNumber class]])
        return _posVal;
    
    return nil;
    
}

-(MyRelativePos*)posRelaVal
{
    if (_posVal == nil)
        return nil;
    
    if ([_posVal isKindOfClass:[MyRelativePos class]])
        return _posVal;
    
    return nil;

}

-(MyRelativePos*)posArrVal
{
    if (_posVal == nil)
        return nil;
    
    if ((_pos == MGRAVITY_HORZ_CENTER || _pos == MGRAVITY_VERT_CENTER) && [_posVal isKindOfClass:[NSArray class]])
        return _posVal;
    
    return nil;
    
}

-(MyRelativePos* (^)(CGFloat val))offset
{
    return ^id(CGFloat val){
       
        switch (_pos) {
            case MGRAVITY_HORZ_LEFT:
                _view.leftMargin = val;
                break;
            case MGRAVITY_HORZ_RIGHT:
                _view.rightMargin = val;
                break;
            case MGRAVITY_VERT_TOP:
                _view.topMargin = val;
                break;
            case MGRAVITY_VERT_BOTTOM:
                _view.bottomMargin = val;
                break;
            case MGRAVITY_HORZ_CENTER:
                _view.leftMargin = val;
                break;
            case MGRAVITY_VERT_CENTER:
                _view.topMargin = val;
                break;
            default:
                break;
        }
        
        return self;
    };
}

-(MyRelativePos* (^)(id val))equalTo
{
    return ^id(id val){
        
            _posVal = val;
        return self;
    };

}


@end


@interface MyRelativeDime()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MarignGravity dime;
@property(nonatomic, assign) CGFloat addVal;
@property(nonatomic, assign) CGFloat mutilVal;
@property(nonatomic, strong) id dimeVal;

@property(nonatomic, readonly) NSNumber *dimeNumVal;
@property(nonatomic, readonly) NSArray *dimeArrVal;
@property(nonatomic, readonly) MyRelativeDime *dimeRelaVal;

@end

@implementation MyRelativeDime

-(id)init
{
    self= [super init];
    if (self !=nil)
    {
        _view = nil;
        _dime = MGRAVITY_NONE;
        _addVal = 0;
        _mutilVal = 1;
        _dimeVal = nil;
    }
    
    return self;
}

//乘
-(MyRelativeDime* (^)(CGFloat val))multiply
{
    return ^id(CGFloat val){
        
        _mutilVal = val;
        return self;
        };

}

//加
-(MyRelativeDime* (^)(CGFloat val))add
{
    return ^id(CGFloat val){
        
        
        _addVal = val;
        return self;
        
        };

}

-(MyRelativeDime* (^)(id val))equalTo
{
    return ^id(id val){
        
        _dimeVal = val;
        return self;
    };
    
}

-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil)
        return nil;
    if ([_dimeVal isKindOfClass:[NSNumber class]])
        return _dimeVal;
    return nil;
}

-(NSArray*)dimeArrVal
{
    if (_dimeVal == nil)
        return nil;
    if ([_dimeVal isKindOfClass:[NSArray class]])
        return _dimeVal;
    return nil;

}

-(MyRelativeDime*)dimeRelaVal
{
    if (_dimeVal == nil)
        return nil;
    if ([_dimeVal isKindOfClass:[MyRelativeDime class]])
        return _dimeVal;
    return nil;
    
}



@end

//绝度位置
@interface MyAbsolutePos : NSObject

@property(nonatomic, assign) CGFloat leftPos;
@property(nonatomic, assign) CGFloat rightPos;
@property(nonatomic, assign) CGFloat topPos;
@property(nonatomic, assign) CGFloat bottomPos;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@end

@implementation MyAbsolutePos

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _leftPos = CGFLOAT_MIN;
        _rightPos = CGFLOAT_MIN;
        _topPos = CGFLOAT_MIN;
        _bottomPos = CGFLOAT_MIN;
        _width = CGFLOAT_MIN;
        _height = CGFLOAT_MIN;
    }
    
    return self;
}

-(void)reset
{
    _leftPos = CGFLOAT_MIN;
    _rightPos = CGFLOAT_MIN;
    _topPos = CGFLOAT_MIN;
    _bottomPos = CGFLOAT_MIN;
    _width = CGFLOAT_MIN;
    _height = CGFLOAT_MIN;
}

@end

@interface UIView(MyRelativeLayoutAbsEx)

@property(nonatomic, strong) MyAbsolutePos *absPos;

@end


@implementation UIView(MyRelativeLayoutEx)

-(MyRelativePos*)leftPos
{
    MyRelativePos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_LEFT);
    if (pos == nil)
    {
        pos = [MyRelativePos new];
        pos.view = self;
        pos.pos = MGRAVITY_HORZ_LEFT;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_LEFT, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}



-(MyRelativePos*)topPos
{
    MyRelativePos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_TOP);
    if (pos == nil)
    {
        pos = [MyRelativePos new];
        pos.view = self;
        pos.pos = MGRAVITY_VERT_TOP;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_TOP, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}


-(MyRelativePos*)rightPos
{
    MyRelativePos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_RIGHT);
    if (pos == nil)
    {
        pos = [MyRelativePos new];
        pos.view = self;
        pos.pos = MGRAVITY_HORZ_RIGHT;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_RIGHT, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}


-(MyRelativePos*)bottomPos
{
    MyRelativePos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_BOTTOM);
    if (pos == nil)
    {
        pos = [MyRelativePos new];
        pos.view = self;
        pos.pos = MGRAVITY_VERT_BOTTOM;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_BOTTOM, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}




-(MyRelativeDime*)widthDime
{
    MyRelativeDime *dime = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_WIDTH);
    if (dime == nil)
    {
        dime = [MyRelativeDime new];
        dime.view = self;
        dime.dime = MGRAVITY_HORZ_FILL;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_WIDTH, dime, OBJC_ASSOCIATION_RETAIN);
    }
    return dime;
}


-(MyRelativeDime*)heightDime
{
    MyRelativeDime *dime = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_HEIGHT);
    if (dime == nil)
    {
        dime = [MyRelativeDime new];
        dime.view = self;
        dime.dime = MGRAVITY_VERT_FILL;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_HEIGHT, dime, OBJC_ASSOCIATION_RETAIN);
    }
    return dime;
}



-(MyRelativePos*)centerXPos
{
    MyRelativePos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERX);
    if (pos == nil)
    {
        pos = [MyRelativePos new];
        pos.view = self;
        pos.pos = MGRAVITY_HORZ_CENTER;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERX, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}



-(MyRelativePos*)centerYPos
{
    MyRelativePos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERY);
    if (pos == nil)
    {
        pos = [MyRelativePos new];
        pos.view = self;
        pos.pos = MGRAVITY_VERT_CENTER;
        
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_RELATIVE_CENTERY, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}




@end

@implementation UIView(MyRelativeLayoutAbsEx)

-(MyAbsolutePos*)absPos
{
    MyAbsolutePos *pos = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_ABSOLUTE_POS);
    if (pos == nil)
    {
        pos = [MyAbsolutePos new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_ABSOLUTE_POS, pos, OBJC_ASSOCIATION_RETAIN);
    }
    return pos;
}

-(void)setAbsPos:(MyAbsolutePos *)absPos
{
    objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_ABSOLUTE_POS, absPos, OBJC_ASSOCIATION_RETAIN);
    
}

@end


@implementation MyRelativeLayout

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)construct
{
    [super construct];
    _flexOtherViewHeightWhenSubviewHidden = NO;
    _flexOtherViewWidthWhenSubviewHidden = NO;
    _wrapContentHeight = NO;
    _wrapContentWidth = NO;
    _adjustScrollViewContentSize = NO;
}


-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    if (self.matchParentWidth)
        wrapContentWidth = NO;
    
    if (_wrapContentWidth != wrapContentWidth)
    {
        _wrapContentWidth = wrapContentWidth;
        [self setNeedsLayout];
    }
}

-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    if (self.matchParentHeight)
        wrapContentHeight = NO;
    
    if (_wrapContentHeight != wrapContentHeight)
    {
        _wrapContentHeight = wrapContentHeight;
        [self setNeedsLayout];
    }
}

-(BOOL)wrapContent
{
    return self.wrapContentHeight && self.wrapContentWidth;
}

-(void)setWrapContent:(BOOL)wrapContent
{
    self.wrapContentWidth = wrapContent;
    self.wrapContentHeight = wrapContent;
}



-(void)setFlexOtherViewWidthWhenSubviewHidden:(BOOL)flexOtherViewWidthWhenSubviewHidden
{
    if (_flexOtherViewWidthWhenSubviewHidden != flexOtherViewWidthWhenSubviewHidden)
    {
        _flexOtherViewWidthWhenSubviewHidden = flexOtherViewWidthWhenSubviewHidden;
        [self setNeedsLayout];
    }
}

-(void)setFlexOtherViewHeightWhenSubviewHidden:(BOOL)flexOtherViewHeightWhenSubviewHidden
{
    if (_flexOtherViewHeightWhenSubviewHidden != flexOtherViewHeightWhenSubviewHidden)
    {
        _flexOtherViewHeightWhenSubviewHidden = flexOtherViewHeightWhenSubviewHidden;
        [self setNeedsLayout];
    }
}


#pragma mark -- Private Method
-(void)calcSubViewLeftRight:(UIView*)sbv
{
    
    
    //确定宽度，如果跟父一样宽则设置宽度和设置左右值，这时候三个参数设置完毕
    //如果和其他视图的宽度一样，则先计算其他视图的宽度并返回其他视图的宽度
    //如果没有指定宽度
    //检测左右设置。
    //如果设置了左右值则计算左右值。然后再计算宽度为两者之间的差
    //如果没有设置则宽度为width
    
    //检测是否有centerX，如果设置了centerX的值为父视图则左右值都设置OK，这时候三个参数完毕
    //如果不是父视图则计算其他视图的centerX的值。并返回位置，根据宽度设置后，三个参数完毕。
    
    //如果没有设置则计算左边的位置。
    
    //如果设置了左边，计算左边的值， 右边的值确定。
    
    //如果设置右边，则计算右边的值，左边的值确定。
    
    //如果都没有设置则，左边为左边距，右边为左边+宽度。
    
    //左右和宽度设置完毕。
    
    
    if (sbv.absPos.leftPos != CGFLOAT_MIN && sbv.absPos.rightPos != CGFLOAT_MIN && sbv.absPos.width != CGFLOAT_MIN)
        return;

    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcWidth:sbv])
        return;
    
    
    if (sbv.centerXPos.posRelaVal != nil)
    {
        sbv.absPos.leftPos = [self calcSubView:sbv.centerXPos.posRelaVal.view gravity:sbv.centerXPos.posRelaVal.pos] - sbv.absPos.width / 2 + sbv.leftMargin;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        return;
    }
    else if (sbv.centerXPos.posNumVal != nil)
    {
        sbv.absPos.leftPos = sbv.centerXPos.posNumVal.floatValue - sbv.absPos.width / 2 + sbv.leftMargin;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        return;
    }
    else
    {
        if (sbv.leftPos.posRelaVal != nil)
        {
            sbv.absPos.leftPos = [self calcSubView:sbv.leftPos.posRelaVal.view gravity:sbv.leftPos.posRelaVal.pos] + sbv.leftMargin;
            sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
            return;
        }
        else if (sbv.leftPos.posNumVal != nil)
        {
            sbv.absPos.leftPos = sbv.leftPos.posNumVal.floatValue + sbv.leftMargin;
            sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
            return;
        }
        
        if (sbv.rightPos.posRelaVal != nil)
        {
            
            sbv.absPos.rightPos = [self calcSubView:sbv.rightPos.posRelaVal.view gravity:sbv.rightPos.posRelaVal.pos] - sbv.rightMargin + sbv.leftMargin;
            sbv.absPos.leftPos = sbv.absPos.rightPos - sbv.absPos.width;
            
            return;
        }
        else if (sbv.rightPos.posNumVal != nil)
        {
            sbv.absPos.rightPos = sbv.rightPos.posNumVal.floatValue - sbv.rightMargin + sbv.leftMargin;
            sbv.absPos.leftPos = sbv.absPos.rightPos - sbv.absPos.width;
            return;
        }
        
        sbv.absPos.leftPos = sbv.leftMargin + self.leftPadding;
        sbv.absPos.rightPos = sbv.absPos.leftPos + sbv.absPos.width;
        
    }
    
}

-(void)calcSubViewTopBottom:(UIView*)sbv
{
    if (sbv.absPos.topPos != CGFLOAT_MIN && sbv.absPos.bottomPos != CGFLOAT_MIN && sbv.absPos.height != CGFLOAT_MIN)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self calcHeight:sbv])
        return;
    
    if (sbv.centerYPos.posRelaVal != nil)
    {
        sbv.absPos.topPos = [self calcSubView:sbv.centerYPos.posRelaVal.view gravity:sbv.centerYPos.posRelaVal.pos] - sbv.absPos.height / 2 + sbv.topMargin;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        return;
    }
    else if (sbv.centerYPos.posNumVal != nil)
    {
        sbv.absPos.topPos = sbv.centerYPos.posNumVal.floatValue - sbv.absPos.height / 2 + sbv.topMargin;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        return;
    }
    else
    {
        if (sbv.topPos.posRelaVal != nil)
        {
            sbv.absPos.topPos = [self calcSubView:sbv.topPos.posRelaVal.view gravity:sbv.topPos.posRelaVal.pos] + sbv.topMargin;
            sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
            return;
        }
        else if (sbv.topPos.posNumVal != nil)
        {
            sbv.absPos.topPos = sbv.topPos.posNumVal.floatValue + sbv.topMargin;
            sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
            return;
        }
        
        if (sbv.bottomPos.posRelaVal != nil)
        {
            
            sbv.absPos.bottomPos = [self calcSubView:sbv.bottomPos.posRelaVal.view gravity:sbv.bottomPos.posRelaVal.pos] - sbv.bottomMargin + sbv.topMargin;
            sbv.absPos.topPos = sbv.absPos.bottomPos - sbv.absPos.height;
            
            return;
        }
        else if (sbv.bottomPos.posNumVal != nil)
        {
            sbv.absPos.bottomPos = sbv.bottomPos.posNumVal.floatValue - sbv.bottomMargin + sbv.topMargin;
            sbv.absPos.topPos = sbv.absPos.bottomPos - sbv.absPos.height;
            return;
        }
        
        sbv.absPos.topPos = sbv.topMargin + self.topPadding;
        sbv.absPos.bottomPos = sbv.absPos.topPos + sbv.absPos.height;
        
    }

}



-(CGFloat)calcSubView:(UIView*)sbv gravity:(MarignGravity)gravity
{
    switch (gravity) {
        case MGRAVITY_HORZ_LEFT:
        {
            if (sbv == self)
                return self.leftPadding;
            
            
            if (sbv.absPos.leftPos != CGFLOAT_MIN)
                return sbv.absPos.leftPos - ((sbv.isHidden && self.hideSubviewReLayout) ? sbv.leftMargin : 0);
            
           
            [self calcSubViewLeftRight:sbv];
            
            return sbv.absPos.leftPos - ((sbv.isHidden && self.hideSubviewReLayout) ? sbv.leftMargin : 0);
            
        }
            break;
        case MGRAVITY_HORZ_RIGHT:
        {
            if (sbv == self)
                return self.width - self.rightPadding;
            
            if (sbv.isHidden && self.hideSubviewReLayout)
            {
                if (sbv.absPos.leftPos != CGFLOAT_MIN)
                    return sbv.absPos.leftPos - sbv.leftMargin;
                
                [self calcSubViewLeftRight:sbv];
                
                return sbv.absPos.leftPos - sbv.leftMargin;
            }
            
            
            if (sbv.absPos.rightPos != CGFLOAT_MIN)
                return sbv.absPos.rightPos;
            
            [self calcSubViewLeftRight:sbv];
            
            return sbv.absPos.rightPos;
            
        }
            break;
        case MGRAVITY_VERT_TOP:
        {
            if (sbv == self)
                return self.topPadding;
            
            
            if (sbv.absPos.topPos != CGFLOAT_MIN)
                return sbv.absPos.topPos - ((sbv.isHidden && self.hideSubviewReLayout) ? sbv.topMargin : 0);
            
            [self calcSubViewTopBottom:sbv];
            
            return sbv.absPos.topPos - ((sbv.isHidden && self.hideSubviewReLayout) ? sbv.topMargin : 0);
            
        }
            break;
        case MGRAVITY_VERT_BOTTOM:
        {
            if (sbv == self)
                return self.height - self.bottomPadding;
            
            if (sbv.isHidden && self.hideSubviewReLayout)
            {
                if (sbv.absPos.topPos != CGFLOAT_MIN)
                    return sbv.absPos.topPos - sbv.topMargin;
                
                [self calcSubViewTopBottom:sbv];
                
                return sbv.absPos.topPos - sbv.topMargin;
            }

            
            
            if (sbv.absPos.bottomPos != CGFLOAT_MIN)
                return sbv.absPos.bottomPos;
            
            [self calcSubViewTopBottom:sbv];
            
            return sbv.absPos.bottomPos;
        }
            break;
        case MGRAVITY_HORZ_FILL:
        {
            if (sbv == self)
                return self.width - self.leftPadding - self.rightPadding;
            
    
            if (sbv.absPos.width != CGFLOAT_MIN)
                return sbv.absPos.width;
            
            [self calcSubViewLeftRight:sbv];
            
            return sbv.absPos.width;
            
        }
            break;
        case MGRAVITY_VERT_FILL:
        {
            if (sbv == self)
                return self.height - self.topPadding - self.bottomPadding;
            
            
            if (sbv.absPos.height != CGFLOAT_MIN)
                return sbv.absPos.height;
            
            [self calcSubViewTopBottom:sbv];
            
            return sbv.absPos.height;
        }
            break;
        case MGRAVITY_HORZ_CENTER:
        {
            if (sbv == self)
                return (self.width - self.leftPadding - self.rightPadding) / 2 + self.leftPadding;
            
            if (sbv.isHidden && self.hideSubviewReLayout)
            {
                if (sbv.absPos.leftPos != CGFLOAT_MIN)
                    return sbv.absPos.leftPos - sbv.leftMargin;
                
                [self calcSubViewLeftRight:sbv];
                
                return sbv.absPos.leftPos - sbv.leftMargin;
            }

            
            if (sbv.absPos.leftPos != CGFLOAT_MIN && sbv.absPos.rightPos != CGFLOAT_MIN &&  sbv.absPos.width != CGFLOAT_MIN)
                return sbv.absPos.leftPos + sbv.absPos.width / 2;
            
            [self calcSubViewLeftRight:sbv];
            
            return sbv.absPos.leftPos + sbv.absPos.width / 2;
            
        }
            break;
            
        case MGRAVITY_VERT_CENTER:
        {
            if (sbv == self)
                return (self.height - self.topPadding - self.bottomPadding) / 2 + self.topPadding;
            
            if (sbv.isHidden && self.hideSubviewReLayout)
            {
                if (sbv.absPos.topPos != CGFLOAT_MIN)
                    return sbv.absPos.topPos - sbv.topMargin;
                
                [self calcSubViewTopBottom:sbv];
                
                return sbv.absPos.topPos - sbv.topMargin;
            }

            
            if (sbv.absPos.topPos != CGFLOAT_MIN && sbv.absPos.bottomPos != CGFLOAT_MIN &&  sbv.absPos.height != CGFLOAT_MIN)
                return sbv.absPos.topPos + sbv.absPos.height / 2;
            
            [self calcSubViewTopBottom:sbv];
            
            return sbv.absPos.topPos + sbv.absPos.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)calcWidth:(UIView*)sbv
{
    if (sbv.absPos.width == CGFLOAT_MIN)
    {
        if (sbv.widthDime.dimeRelaVal != nil)
        {
            
            sbv.absPos.width = [self calcSubView:sbv.widthDime.dimeRelaVal.view gravity:sbv.widthDime.dimeRelaVal.dime] * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
        }
        else if (sbv.widthDime.dimeNumVal != nil)
        {
            sbv.absPos.width = sbv.widthDime.dimeNumVal.floatValue * sbv.widthDime.mutilVal + sbv.widthDime.addVal;
        }
        else;
        
        if (sbv.leftPos.posRelaVal != nil && sbv.rightPos.posRelaVal != nil)
        {
            sbv.absPos.leftPos = [self calcSubView:sbv.leftPos.posRelaVal.view gravity:sbv.leftPos.posRelaVal.pos] + sbv.leftMargin;
            sbv.absPos.rightPos = [self calcSubView:sbv.rightPos.posRelaVal.view gravity:sbv.rightPos.posRelaVal.pos] - sbv.rightMargin;
            sbv.absPos.width = sbv.absPos.rightPos - sbv.absPos.leftPos;
            
            return YES;
        }
        
        if (sbv.leftPos.posNumVal != nil && sbv.rightPos.posNumVal != nil)
        {
            sbv.absPos.leftPos = sbv.leftPos.posNumVal.floatValue + sbv.leftMargin;
            sbv.absPos.rightPos = sbv.rightPos.posNumVal.floatValue - sbv.rightMargin;
            sbv.absPos.width = sbv.absPos.rightPos - sbv.absPos.leftPos;
            
            return YES;
        }
        
        
        if (sbv.absPos.width == CGFLOAT_MIN)
        {
            sbv.absPos.width = sbv.width;
        }
    }
    
    return NO;
}


-(BOOL)calcHeight:(UIView*)sbv
{
    if (sbv.absPos.height == CGFLOAT_MIN)
    {
        if (sbv.heightDime.dimeRelaVal != nil)
        {
            
            sbv.absPos.height = [self calcSubView:sbv.heightDime.dimeRelaVal.view gravity:sbv.heightDime.dimeRelaVal.dime] * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        }
        else if (sbv.heightDime.dimeNumVal != nil)
        {
            sbv.absPos.height = sbv.heightDime.dimeNumVal.floatValue * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        }
        else;
        
        if (sbv.topPos.posRelaVal != nil && sbv.bottomPos.posRelaVal != nil)
        {
            sbv.absPos.topPos = [self calcSubView:sbv.topPos.posRelaVal.view gravity:sbv.topPos.posRelaVal.pos] + sbv.topMargin;
            sbv.absPos.bottomPos = [self calcSubView:sbv.bottomPos.posRelaVal.view gravity:sbv.bottomPos.posRelaVal.pos] - sbv.bottomMargin;
            sbv.absPos.height = sbv.absPos.bottomPos - sbv.absPos.topPos;
            
            return YES;
        }
        
        if (sbv.topPos.posNumVal != nil && sbv.bottomPos.posNumVal != nil)
        {
            sbv.absPos.topPos = sbv.topPos.posNumVal.floatValue + sbv.topMargin;
            sbv.absPos.bottomPos = sbv.bottomPos.posNumVal.floatValue - sbv.bottomMargin;
            sbv.absPos.height = sbv.absPos.bottomPos - sbv.absPos.topPos;
            
            return YES;
        }
        
        
        if (sbv.absPos.height == CGFLOAT_MIN)
        {
            sbv.absPos.height = sbv.height;
        }
    }
    
    return NO;

}


-(CGSize)calcLayout:(BOOL*)pRecalc
{
    *pRecalc = NO;
    
    //均分宽度和高度。把这部分提出来是为了实现不管数组是哪个视图指定都可以。
    for (UIView *sbv in self.subviews)
    {
        if (sbv.widthDime.dimeArrVal != nil)
        {
            *pRecalc = YES;
            //平分视图。
            
            NSArray *arr = sbv.widthDime.dimeArrVal;
            
            BOOL ok1 = sbv.isHidden && self.hideSubviewReLayout && self.flexOtherViewWidthWhenSubviewHidden;
            
            
            CGFloat totalMutil = ok1 ? 0 : sbv.widthDime.mutilVal;
            CGFloat totalAdd =  ok1 ? 0 : sbv.widthDime.addVal;
            for (MyRelativeDime *d in arr)
            {
                BOOL ok = d.view.isHidden && self.hideSubviewReLayout && self.flexOtherViewWidthWhenSubviewHidden;
                
                if (!ok)
                {
                    if (d.dimeNumVal != nil)
                        totalAdd += -1 * d.dimeNumVal.floatValue;
                    else
                        totalMutil += d.mutilVal;
                    
                    totalAdd += d.addVal;
                    
                }
                
                
            }
            
            CGFloat floatWidth = self.width - self.leftPadding - self.rightPadding + totalAdd;
            if (floatWidth <= 0)
                floatWidth = 0;
            
            if (totalMutil != 0)
            {
                sbv.absPos.width = floatWidth * (sbv.widthDime.mutilVal / totalMutil);
                for (MyRelativeDime *d in arr) {
                    
                    if (d.dimeNumVal == nil)
                        d.view.absPos.width = floatWidth * (d.mutilVal / totalMutil);
                    else
                        d.view.absPos.width = d.dimeNumVal.floatValue;
                }
            }
        }
        
        if (sbv.heightDime.dimeArrVal != nil)
        {
            *pRecalc = YES;
            
            NSArray *arr = sbv.heightDime.dimeArrVal;
            
            BOOL ok1 = sbv.isHidden && self.hideSubviewReLayout && self.flexOtherViewHeightWhenSubviewHidden;
            
            CGFloat totalMutil = ok1 ? 0 : sbv.heightDime.mutilVal;
            CGFloat totalAdd = ok1 ? 0 : sbv.heightDime.addVal;
            for (MyRelativeDime *d in arr)
            {
                BOOL ok = d.view.isHidden && self.hideSubviewReLayout && self.flexOtherViewHeightWhenSubviewHidden;
                
                if (!ok)
                {
                    if (d.dimeNumVal != nil)
                        totalAdd += -1 * d.dimeNumVal.floatValue;
                    else
                        totalMutil += d.mutilVal;
                    
                    totalAdd += d.addVal;
                }
                
            }
            
            CGFloat floatHeight = self.height - self.topPadding - self.bottomPadding + totalAdd;
            if (floatHeight <= 0)
                floatHeight = 0;
            
            if (totalMutil != 0)
            {
                sbv.absPos.height = floatHeight * (sbv.heightDime.mutilVal / totalMutil);
                for (MyRelativeDime *d in arr) {
                    
                    if (d.dimeNumVal == nil)
                        d.view.absPos.height = floatHeight * (d.mutilVal / totalMutil);
                    else
                        d.view.absPos.height = d.dimeNumVal.floatValue;
                }
            }
        }
        
        
        //表示视图数组水平居中
        if (sbv.centerXPos.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *arr = sbv.centerXPos.posArrVal;
            
            CGFloat totalWidth = 0;
            
            if (!(sbv.isHidden && self.hideSubviewReLayout))
            {
                [self calcWidth:sbv];
                totalWidth += sbv.absPos.width + sbv.leftMargin;
            }
            
            
            for (MyRelativePos *p in arr)
            {
                if (!(p.view.isHidden && self.hideSubviewReLayout))
                {
                    [self calcWidth:p.view];
                    totalWidth += p.view.absPos.width + p.view.leftMargin;
                }
            }
            
            //所有宽度算出后，再分别设置
            CGFloat leftOffset = (self.width - self.leftPadding - self.rightPadding - totalWidth) / 2;
            leftOffset += self.leftPadding;
            
            id prev = @(leftOffset);
            if (!(sbv.isHidden && self.hideSubviewReLayout))
            {
                sbv.leftPos.equalTo(prev);
                prev = sbv.rightPos;
            }
            
            for (MyRelativePos *p in arr)
            {
                if (!(p.view.isHidden && self.hideSubviewReLayout))
                {
                    p.view.leftPos.equalTo(prev);
                    prev = p.view.rightPos;
                }
            }
        }
        
        //表示视图数组垂直居中
        if (sbv.centerYPos.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *arr = sbv.centerYPos.posArrVal;
            
            CGFloat totalHeight = 0;
            
            if (!(sbv.isHidden && self.hideSubviewReLayout))
            {
                [self calcHeight:sbv];
                totalHeight += sbv.absPos.height + sbv.topMargin;
            }
            
            
            for (MyRelativePos *p in arr)
            {
                if (!(p.view.isHidden && self.hideSubviewReLayout))
                {
                    [self calcHeight:p.view];
                    totalHeight += p.view.absPos.height + p.view.topMargin;
                }
            }
            
            //所有宽度算出后，再分别设置
            CGFloat topOffset = (self.height - self.topPadding - self.topPadding - totalHeight) / 2;
            topOffset += self.topPadding;
            
            id prev = @(topOffset);
            if (!(sbv.isHidden && self.hideSubviewReLayout))
            {
                sbv.topPos.equalTo(prev);
                prev = sbv.bottomPos;
            }
            
            for (MyRelativePos *p in arr)
            {
                if (!(p.view.isHidden && self.hideSubviewReLayout))
                {
                    p.view.topPos.equalTo(prev);
                    prev = p.view.bottomPos;
                }
            }
        }

        
    }
    
    //计算最大的宽度和高度
    CGFloat maxWidth = self.leftPadding;
    CGFloat maxHeight = self.topPadding;
    
    for (UIView *sbv in self.subviews)
    {
        //左边检测。
        
        [self calcSubViewLeftRight:sbv];
        
        if (sbv.rightPos.posRelaVal != nil && sbv.rightPos.posRelaVal.view == self)
            *pRecalc = YES;
        
        
        if (sbv.isFlexedHeight)
        {
            CGSize sz = [sbv sizeThatFits:CGSizeMake(sbv.absPos.width, 0)];
            sbv.height = sz.height;
        }
        
        [self calcSubViewTopBottom:sbv];
        
        if (sbv.bottomPos.posRelaVal != nil && sbv.bottomPos.posRelaVal.view == self)
            *pRecalc = YES;
        
        if (sbv.isHidden && self.hideSubviewReLayout)
            continue;
        
        if (maxWidth < sbv.absPos.rightPos + sbv.rightMargin)
            maxWidth = sbv.absPos.rightPos + sbv.rightMargin;
        
        if (maxHeight < sbv.absPos.bottomPos + sbv.bottomMargin)
            maxHeight = sbv.absPos.bottomPos + sbv.bottomMargin;
    }
    
    maxWidth += self.rightPadding;
    maxHeight += self.bottomPadding;
    
    return CGSizeMake(maxWidth, maxHeight);
    
}


-(void)doLayoutSubviews
{
    [super doLayoutSubviews];
    
    //第一次布局计算。检测时序
    BOOL reCalc = NO;
    CGSize maxSize = [self calcLayout:&reCalc];
    
    if (self.wrapContentWidth || self.wrapContentHeight)
    {
        CGRect newRect = self.frame;
        if (newRect.size.height != maxSize.height || newRect.size.width != maxSize.width)
        {
            CGRect oldRect = newRect;
            
            if (self.wrapContentWidth)
            {
                newRect.size.width = maxSize.width;
            }
            
            if (self.wrapContentHeight)
            {
                newRect.size.height = maxSize.height;
            }
            
            
            self.frame = newRect;
            
            if (self.adjustScrollViewContentSize && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
            {
                UIScrollView *scrolv = (UIScrollView*)self.superview;
                
                CGSize contsize = scrolv.contentSize;
                
                if (self.wrapContentHeight && newRect.size.height != oldRect.size.height)
                {
                    contsize.height = newRect.size.height;
                    
                }
                
                if(self.wrapContentWidth && newRect.size.width != oldRect.size.width)
                {
                    contsize.width = newRect.size.width;
                    
                }
                
                scrolv.contentSize = contsize;
                
            }
            
            //如果里面有需要重新计算的就重新计算布局
            if (reCalc)
            {
                for (UIView *sbv in self.subviews)
                {
                    [sbv.absPos reset];
                }
                
                [self calcLayout:&reCalc];
            }
        }

    }
    
    for (UIView *sbv in self.subviews)
    {
            
        CGRect rect = CGRectMake(sbv.absPos.leftPos, sbv.absPos.topPos, sbv.absPos.width, sbv.absPos.height);
        sbv.frame = rect;
            
        [sbv.absPos reset];
    }
   }

@end

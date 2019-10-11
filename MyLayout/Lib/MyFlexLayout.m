//
//  MyFlexLayout.m
//  MyLayout
//
//  Created by oubaiquan on 2019/8/30.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import "MyFlexLayout.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>

const char * const ASSOCIATEDOBJECT_KEY_MYLAYOUT_FLEXITEM = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_FLEXITEM";


static const int _sauto = -1;

static const int _srow = 0;
static const int _srow_reverse = 2;
static const int _scolumn = 1;
static const int _scolumn_reverse = 3;

static const int _snowrap = 0;
static const int _swrap = 4;
static const int _swrap_reverse = 12;

static const int _sflex_start = 0;
static const int _sflex_end = 1;
static const int _scenter = 2;
static const int _sspace_between = 3;
static const int _sspace_around = 4;
static const int _sbaseline = 5;
static const int _sstretch = 6;


@implementation MyFlexItem
{
    @package
    int _align_self;
    NSInteger _order;
    CGFloat _flex_grow;
    CGFloat _flex_shrink;
    CGFloat _flex_basis;
    CGFloat _width;
    CGFloat _height;
    
    __weak UIView *_view;
}

+(CGFloat)_auto
{
    return _sauto;
}


-(instancetype)initWithView:(UIView*)view;
{
    self = [super init];
    if (self != nil)
    {
        _order = 0;
        _flex_grow = 0;
        _flex_basis = _sauto;
        _flex_shrink = 1;
        _align_self = _sauto;
        _view = view;
        _width = CGFLOAT_MAX;
        _height = CGFLOAT_MAX;
    }
    return self;
}

-(MyFlexItem* (^)(NSInteger))order
{
    return ^id(NSInteger val) {
        self->_order = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))flex_grow
{
    return ^id(CGFloat val) {
        self->_flex_grow = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))flex_shrink
{
    return ^id(CGFloat val) {
        self->_flex_shrink = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))flex_basis
{
    return ^id(CGFloat val) {
        self->_flex_basis = val;
        return self;
    };
}

-(MyFlexItem* (^)(int))align_self
{
    return ^id(int val) {
        self->_align_self = val;
        return self;
    };
}

-(__kindof UIView* (^)(UIView*))addTo
{
    return ^(UIView *val) {
        
//        if (_width != CGFLOAT_MAX)
//        {
//            if (_width == MyLayoutSize.fill)
//                [self->_view.widthSize __equalTo:val];
//            else if (_width < 1 && _width > 0)
//                [[self->_view.widthSize __equalTo:val.widthSize] __multiply:_width];
//            else;
//        }
//
//        if (_height != CGFLOAT_MAX)
//        {
//            if (_height == MyLayoutSize.fill)
//                [self->_view.heightSize __equalTo:val];
//            else if (_height < 1 && _height > 0)
//                [[self->_view.heightSize __equalTo:val.heightSize] __multiply:_height];
//            else;
//        }

        [val addSubview:self->_view];
        return self->_view;
    };
}

-(MyFlexItem* (^)(CGFloat))width
{
    return ^id(CGFloat val) {
        _width = val;
//        if (_width == MyLayoutSize.fill)
//        {
//            if (self->_view.superview)
//                [self->_view.widthSize __equalTo:self->_view.superview];
//        }
//        else
//        {
//            if (_width < 1 && _width > 0)
//            {
//                if (self->_view.superview)
//                    [[self->_view.widthSize __equalTo:self->_view.superview] __multiply:_width];
//            }
//            else
//                self->_view.myWidth = _width;
//        }
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))height
{
    return ^id(CGFloat val) {
        _height = val;
//        if (_height == MyLayoutSize.fill)
//        {
//            if (self->_view.superview)
//                [self->_view.heightSize __equalTo:self->_view.superview];
//        }
//        else
//        {
//            if (_height < 1 && _height > 0)
//            {
//                if (self->_view.superview)
//                    [[self->_view.heightSize __equalTo:self->_view.superview] __multiply:_height];
//            }
//            else
//                self->_view.myHeight = _height;
//        }
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin_top
{
    return ^id(CGFloat val) {
        self->_view.myTop = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin_bottom
{
    return ^id(CGFloat val) {
        self->_view.myBottom = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin_left
{
    return ^id(CGFloat val) {
        self->_view.myLeft = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin_right
{
    return ^id(CGFloat val) {
        self->_view.myRight = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin
{
    return ^id(CGFloat val) {
        self->_view.myLeft = val;
        self->_view.myRight = val;
        self->_view.myTop = val;
        self->_view.myBottom = val;
        return self;
    };
}


-(UIView*)view
{
    return self->_view;
}

@end


@implementation MyFlex
{
    @package
    int _flex_direction;
    int _flex_wrap;
    int _justify_content;
    int _align_items;
    int _align_content;
}

+(int)row
{
    return _srow;
}

+(int)row_reverse
{
    return _srow_reverse;
}
+(int)column
{
    return _scolumn;
}
+(int)column_reverse
{
    return _scolumn_reverse;
}

+(int)nowrap
{
    return _snowrap;
}
+(int)wrap
{
    return _swrap;
}
+(int)wrap_reverse
{
    return _swrap_reverse;
}

+(int)flex_start
{
    return _sflex_start;
}
+(int)flex_end
{
    return _sflex_end;
}
+(int)center
{
    return _scenter;
}
+(int)space_between
{
    return _sspace_between;
}
+(int)sapce_around
{
    return _sspace_around;
}
+(int)baseline
{
    return _sbaseline;
}
+(int)stretch
{
    return _sstretch;
}

-(instancetype)initWithView:(UIView*)view
{
    self = [super initWithView:view];
    if (self != nil)
    {
        _flex_direction = _srow;
        _flex_wrap = _snowrap;
        _justify_content = _sflex_start;
        _align_items = _sstretch;
        _align_content = _sstretch;
    }
    return self;
}

-(MyFlexLayout*)layout
{
    return (MyFlexLayout*)_view;
}

-(MyFlex* (^)(int))flex_direction
{
    return ^id(int val){
        self->_flex_direction = val;
        return self;
    };
}

-(MyFlex* (^)(int))flex_wrap
{
    return ^id(int val){
        self->_flex_wrap = val;
        return self;
    };
}

-(MyFlex* (^)(int))flex_flow
{
    return ^id(int val) {
        //取方向值。
        int direction = val & 0x03;
        //取换行值。
        int wrap = val & 0x0c;
        return self.flex_direction(direction).flex_wrap(wrap);
    };
}

-(MyFlex* (^)(int))justify_content
{
    return ^id(int val) {
        self->_justify_content = val;
        return self;
    };
}

-(MyFlex* (^)(int))align_items
{
    return ^id(int val) {
        self->_align_items = val;
        return self;
    };
}

-(MyFlex* (^)(int))align_content
{
    return ^id(int val) {
        self->_align_content = val;
        return self;
    };
}

-(MyFlex* (^)(UIEdgeInsets))padding
{
    return ^id(UIEdgeInsets val) {
        self.layout.padding = val;
        return self;
    };
}

-(MyFlex* (^)(CGFloat))vert_space
{
    return ^id(CGFloat val) {
        self.layout.subviewVSpace = val;
        return self;
    };
}

-(MyFlex* (^)(CGFloat))horz_space
{
    return ^id(CGFloat val) {
        self.layout.subviewHSpace = val;
        return self;
    };
}

@end

@implementation UIView(MyFlexLayout)

-(UIView* (^)(UIView*))add
{
    return ^id(UIView* val) {
        [self addSubview:val];
        return self;
    };
}

-(MyFlexItem*)flexItem
{
    MyFlexItem *obj = nil;
    if ([self isKindOfClass:[MyFlexLayout class]] )
    {
        obj = ((MyFlexLayout*)self).flex;
    }
    else
    {
        obj = (MyFlexItem*)objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_FLEXITEM);
        if (obj == nil)
        {
            obj = [[MyFlexItem alloc] initWithView:self];
            objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_FLEXITEM, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return obj;
}

@end



@implementation MyFlexLayout

-(instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _flex = [[MyFlex alloc] initWithView:self];
        self.orientation = MyOrientation_Vert; //默认row
        self.arrangedCount = NSIntegerMax; //默认单行
        self.isFlex = YES; //满足flexbox的需求。
    }
    return self;
}


-(CGSize)calcLayoutSize:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    MyFlexLayout *lsc = self.myCurrentSizeClass;

    //最先设置方向。
    switch (self.flex->_flex_direction) {
        case _scolumn_reverse:  //column_reverse
            lsc.orientation = MyOrientation_Horz;
            lsc.layoutTransform =  CGAffineTransformMake(1,0,0,-1,0,0);
            break;
        case _scolumn:  //column;
            lsc.orientation = MyOrientation_Horz;
            lsc.layoutTransform = CGAffineTransformIdentity;
            break;
        case _srow_reverse:  //row_reverse
            lsc.orientation = MyOrientation_Vert;
            lsc.layoutTransform = CGAffineTransformMake(-1,0,0,1,0,0);
            break;
        case _srow:
        default:
            lsc.orientation = MyOrientation_Vert;
            lsc.layoutTransform = CGAffineTransformIdentity;
            break;
    }
    
    int flex_wrap = self.flex->_flex_wrap;
    
    //处理子视图的flexitem设置。
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    //按order排序。
    [sbs sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(UIView*  _Nonnull obj1, UIView*  _Nonnull obj2) {
        
        return obj1.flexItem->_order - obj2.flexItem->_order;
    }];
    
    for (UIView *sbv in sbs)
    {
        MyFlexItem *flexItem = sbv.flexItem;
        UIView *sbvsc = sbv.myCurrentSizeClass;
        
        //flex_grow，如果子视图有设置grow则父视图的换行不起作用。
        sbvsc.weight = flexItem->_flex_grow;
        if (flexItem->_flex_grow != 0)
        {
            flex_wrap = _snowrap;
        }
        
        
        //flex_shrink
        if (lsc.orientation == MyOrientation_Vert)
        {
            sbvsc.widthSize.shrink =  flexItem->_flex_shrink !=_sauto?flexItem->_flex_shrink:0;
        }
        else
        {
            sbvsc.heightSize.shrink = flexItem->_flex_shrink !=_sauto?flexItem->_flex_shrink:0;
        }
        
        //伸缩基准值设置。
        if (flexItem->_flex_basis != _sauto)
        {
            if (lsc.orientation == MyOrientation_Vert)
            {
                if (flexItem->_flex_basis < 1)
                    [[sbvsc.widthSize __equalTo:lsc.widthSize] __multiply:flexItem->_flex_basis];
                else
                    [sbvsc.widthSize __equalTo:@(flexItem->_flex_basis)];
            }
            else
            {
                if (flexItem->_flex_basis < 1)
                    [[sbvsc.heightSize __equalTo:lsc.heightSize] __multiply:flexItem->_flex_basis];
                else
                    [sbvsc.heightSize __equalTo:@(flexItem->_flex_basis)];
            }
        }
        
        //对齐方式设置。
        switch (flexItem->_align_self) {
            case _sauto:
                sbvsc.alignment = MyGravity_None;
                break;
            case _sflex_start:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Top : MyGravity_Horz_Leading;
                break;
            case _sflex_end:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Bottom : MyGravity_Horz_Trailing;
                break;
            case _scenter:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Center : MyGravity_Horz_Center;
                break;
            case _sbaseline:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Baseline : MyGravity_None;
                break;
            case _sstretch:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Stretch : MyGravity_Horz_Stretch;
                break;
            default:
                break;
        }
    }
    
    
    //再次处理布局视图的其他属性设置，这里因为子视图的一些特性会影响布局视图的属性设置，所以这里放在子视图后面。
    
    //设置换行,如果子视图有grow则不支持换行。
    switch (flex_wrap) {
        case _swrap:
            lsc.arrangedCount = 0;
            lsc.layoutTransform = CGAffineTransformIdentity;
            break;
        case _swrap_reverse:
            lsc.arrangedCount = 0;
            lsc.layoutTransform = (lsc.orientation == MyOrientation_Vert)? CGAffineTransformMake(-1,0,0,1,0,0):CGAffineTransformMake(1,0,0,-1,0,0);
            break;
        case _snowrap:
        default:
            lsc.arrangedCount = NSIntegerMax;
            lsc.layoutTransform = CGAffineTransformIdentity;
            break;
    }
    
    //设置主轴的水平对齐和拉伸
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = lsc.gravity & MyGravity_Vert_Mask;
    
    switch (self.flex->_justify_content) {
        case _sflex_end:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Trailing | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Bottom | horzGravity;
            break;
        case _scenter:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Center | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Center | horzGravity;
            break;
        case _sspace_between:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Between | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Between | horzGravity;
            break;
        case _sspace_around:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Around | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Around | horzGravity;
            break;
        case _sflex_start:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Leading | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Top | horzGravity;
        default:
            break;
    }
    
    //次轴的对齐处理。
    MyGravity vertArrangedGravity = lsc.arrangedGravity & MyGravity_Horz_Mask;
    MyGravity horzArrangedGravity = lsc.arrangedGravity & MyGravity_Vert_Mask;
    
    switch (self.flex->_align_items) {
        case _sflex_end:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Bottom | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Trailing | vertArrangedGravity;
            break;
        case _scenter:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Center | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Center | vertArrangedGravity;
            break;
        case _sbaseline:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Baseline | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Leading | vertArrangedGravity;
            break;
        case _sflex_start:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Top | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Leading | vertArrangedGravity;
            break;
        case _sstretch:
        default:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Stretch | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Stretch | vertArrangedGravity;
            break;
    }
    
    vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    horzGravity = lsc.gravity & MyGravity_Vert_Mask;
    //只有换行才有用，单行不起作用。
    if (lsc.arrangedCount == 0)
    {
        switch (self.flex->_align_content) {
            case _sflex_end:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Trailing | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Bottom | horzGravity;
                break;
            case _scenter:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Center | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Center | horzGravity;
                break;
            case _sspace_between:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Between | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Between | horzGravity;
                break;
            case _sspace_around:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Around | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Around | horzGravity;
                break;
            case _sflex_start:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Leading | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Top | horzGravity;
                break;
            case _sstretch:
            default:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Stretch | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Stretch | horzGravity;
                break;
        }
    }
    else
    {
        if (lsc.orientation == MyOrientation_Horz)
        {
            lsc.gravity = vertGravity;
        }
        else
        {
            lsc.gravity = horzGravity;
        }
    }
    
    return [super calcLayoutSize:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
}



@end

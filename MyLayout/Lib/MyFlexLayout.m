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


 const int MyFlex_Auto = -1;


@implementation MyFlexItem
{
    @package
    __weak UIView *_view;
}


-(instancetype)initWithView:(UIView*)view;
{
    self = [super init];
    if (self != nil)
    {
        _order_val = 0;
        _flex_grow_val = 0;
        _flex_basis_val = MyFlex_Auto;
        _flex_shrink_val = 1;
        _align_self_val = MyFlex_Auto;
        _view = view;
        _width_val = 0;
        _height_val = 0;
    }
    return self;
}

-(CGFloat)margin_top_val
{
    return self.view.myTop;
}

-(void)setMargin_top_val:(CGFloat)margin_top_val
{
    self.view.myTop = margin_top_val;
}

-(CGFloat)margin_bottom_val
{
    return self.view.myBottom;
}

-(void)setMargin_bottom_val:(CGFloat)margin_bottom_val
{
    self.view.myBottom = margin_bottom_val;
}

-(CGFloat)margin_left_val
{
    return self.view.myLeft;
}

-(void)setMargin_left_val:(CGFloat)margin_left_val
{
    self.view.myLeft = margin_left_val;
}

-(CGFloat)margin_right_val
{
    return self.view.myRight;
}

-(void)setMargin_right_val:(CGFloat)margin_right_val
{
    self.view.myRight = margin_right_val;
}

-(MyVisibility)visibility_val
{
    return self.view.visibility;
}

-(void)setVisibility_val:(MyVisibility)visibility_val
{
    self.view.visibility = visibility_val;
}


-(MyFlexItem* (^)(NSInteger))order
{
    return ^id(NSInteger val) {
        self.order_val = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))flex_grow
{
    return ^id(CGFloat val) {
        self.flex_grow_val = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))flex_shrink
{
    return ^id(CGFloat val) {
        self.flex_shrink_val = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))flex_basis
{
    return ^id(CGFloat val) {
        self.flex_basis_val = val;
        return self;
    };
}

-(MyFlexItem* (^)(MyFlexGravity))align_self
{
    return ^id(MyFlexGravity val) {
        self.align_self_val = val;
        return self;
    };
}

-(__kindof UIView* (^)(UIView*))addTo
{
    return ^(UIView *val) {
        
        //当前是布局视图，并且父视图是非布局视图则特殊设置。
        if ([self.view isKindOfClass:[MyFlexLayout class]] && ![val isKindOfClass:[MyBaseLayout class]])
            [self setSizeConstraintWithSuperview:val];
        
        [val addSubview:self.view];
        return self.view;
    };
}

-(MyFlexItem* (^)(CGFloat))width
{
    return ^id(CGFloat val) {
        self.width_val = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))min_width
{
    return ^id(CGFloat val) {
        self.view.widthSize.min(val);
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))max_width
{
    return ^id(CGFloat val) {
        self.view.widthSize.max(val);
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))height
{
    return ^id(CGFloat val) {
        self.height_val = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))min_height
{
    return ^id(CGFloat val) {
        self.view.heightSize.min(val);
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))max_height
{
    return ^id(CGFloat val) {
        self.view.heightSize.max(val);
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin_top
{
    return ^id(CGFloat val) {
        self.view.myTop = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin_bottom
{
    return ^id(CGFloat val) {
        self.view.myBottom = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin_left
{
    return ^id(CGFloat val) {
        self.view.myLeft = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin_right
{
    return ^id(CGFloat val) {
        self.view.myRight = val;
        return self;
    };
}

-(MyFlexItem* (^)(CGFloat))margin
{
    return ^id(CGFloat val) {
        self.view.myLeft = val;
        self.view.myRight = val;
        self.view.myTop = val;
        self.view.myBottom = val;
        return self;
    };
}

-(MyFlexItem* (^)(MyVisibility))visibility
{
    return ^id(MyVisibility val) {
        self.view.visibility = val;
        return self;
    };
}

-(void)setSizeConstraintWithSuperview:(UIView*)superview
{
    //宽度设置
    if (self.width_val == MyLayoutSize.wrap)
        [self.view.widthSize __equalTo:@(MyLayoutSize.wrap)];
    else if (self.width_val == MyLayoutSize.fill)
        [self.view.widthSize __equalTo:superview.widthSize];
    else if (self.width_val > 0 && self.width_val < 1)
        [[self.view.widthSize __equalTo:superview.widthSize] __multiply:self.width_val];
    else if (self.width_val == 0.0)
        [self.view.widthSize __equalTo:nil];
    else
        [self.view.widthSize __equalTo:@(self.width_val)];
    
    //高度设置
    if (self.height_val == MyLayoutSize.wrap)
        [self.view.heightSize __equalTo:@(MyLayoutSize.wrap)];
    else if (self.height_val == MyLayoutSize.fill)
        [self.view.heightSize __equalTo:superview.heightSize];
    else if (self.height_val > 0 && self.height_val < 1)
        [[self.view.heightSize __equalTo:superview.heightSize] __multiply:self.height_val];
    else if (self.height_val == 0.0)
        [self.view.heightSize __equalTo:nil];
    else
        [self.view.heightSize __equalTo:@(self.height_val)];
}

@end


@implementation MyFlex

-(instancetype)initWithView:(UIView*)view
{
    self = [super initWithView:view];
    if (self != nil)
    {
        _flex_direction_val = MyFlexDirection_Row;
        _flex_wrap_val = MyFlexWrap_NoWrap;
        _justify_content_val = MyFlexGravity_Flex_Start;
        _align_items_val = MyFlexGravity_Stretch;
        _align_content_val = MyFlexGravity_Stretch;
    }
    return self;
}

-(UIEdgeInsets)padding_val
{
    return ((MyFlexLayout*)self.view).padding;
}

-(void)setPadding_val:(UIEdgeInsets)padding_val
{
    ((MyFlexLayout*)self.view).padding = padding_val;
}

-(CGFloat)vert_space_val
{
    return ((MyFlexLayout*)self.view).subviewVSpace;
}

-(void)setVert_space_val:(CGFloat)vert_space_val
{
    ((MyFlexLayout*)self.view).subviewVSpace = vert_space_val;
}

-(CGFloat)horz_space_val
{
    return ((MyFlexLayout*)self.view).subviewHSpace;
}

-(void)setHorz_space_val:(CGFloat)horz_space_val
{
    ((MyFlexLayout*)self.view).subviewHSpace = horz_space_val;
}


-(MyFlex* (^)(MyFlexDirection))flex_direction
{
    return ^id(MyFlexDirection val){
        self.flex_direction_val = val;
        return self;
    };
}

-(MyFlex* (^)(MyFlexWrap))flex_wrap
{
    return ^id(MyFlexWrap val){
        self.flex_wrap_val = val;
        return self;
    };
}

-(MyFlex* (^)(int))flex_flow
{
    return ^id(int val) {
        //取方向值。
        MyFlexDirection direction = val & 0x03;
        //取换行值。
        MyFlexWrap wrap = val & 0x0c;
        return self.flex_direction(direction).flex_wrap(wrap);
    };
}

-(MyFlex* (^)(MyFlexGravity))justify_content
{
    
    return ^id(MyFlexGravity val) {
        self.justify_content_val = val;
        return self;
    };
}

-(MyFlex* (^)(MyFlexGravity))align_items
{
    return ^id(MyFlexGravity val) {
        self.align_items_val = val;
        return self;
    };
}

-(MyFlex* (^)(MyFlexGravity))align_content
{
    return ^id(MyFlexGravity val) {
        self.align_content_val = val;
        return self;
    };
}

-(MyFlex* (^)(UIEdgeInsets))padding
{
    return ^id(UIEdgeInsets val) {
        ((MyFlexLayout*)self.view).padding = val;
        return self;
    };
}

-(MyFlex* (^)(CGFloat))vert_space
{
    return ^id(CGFloat val) {
        ((MyFlexLayout*)self.view).subviewVSpace = val;
        return self;
    };
}

-(MyFlex* (^)(CGFloat))horz_space
{
    return ^id(CGFloat val) {
        ((MyFlexLayout*)self.view).subviewHSpace = val;
        return self;
    };
}

@end

@implementation UIView(MyFlexLayout)


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
    switch (self.flex.flex_direction_val) {
        case MyFlexDirection_Column_Reverse:  //column_reverse
            lsc.orientation = MyOrientation_Horz;
            lsc.layoutTransform =  CGAffineTransformMake(1,0,0,-1,0,0);  //垂直翻转
            break;
        case MyFlexDirection_Column:  //column;
            lsc.orientation = MyOrientation_Horz;
            lsc.layoutTransform = CGAffineTransformIdentity;
            break;
        case MyFlexDirection_Row_Reverse:  //row_reverse
            lsc.orientation = MyOrientation_Vert;
            lsc.layoutTransform = CGAffineTransformMake(-1,0,0,1,0,0);   //水平翻转
            break;
        case MyFlexDirection_Row:
        default:
            lsc.orientation = MyOrientation_Vert;
            lsc.layoutTransform = CGAffineTransformIdentity;
            break;
    }
    
    //设置换行.
    switch (self.flex.flex_wrap_val) {
        case MyFlexWrap_Wrap:
            lsc.arrangedCount = 0;
            break;
        case MyFlexWrap_Wrap_Reverse:
            lsc.arrangedCount = 0;
            lsc.layoutTransform = CGAffineTransformConcat(lsc.layoutTransform, (lsc.orientation == MyOrientation_Vert)? CGAffineTransformMake(1,0,0,-1,0,0):CGAffineTransformMake(-1,0,0,1,0,0));
            break;
        case MyFlexWrap_NoWrap:
        default:
            lsc.arrangedCount = NSIntegerMax;
            break;
    }
    
    //处理子视图的flexitem设置。
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    //按order排序。
    [sbs sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(UIView*  _Nonnull obj1, UIView*  _Nonnull obj2) {
        
        return obj1.flexItem.order_val - obj2.flexItem.order_val;
    }];
    
    for (UIView *sbv in sbs)
    {
        MyFlexItem *flexItem = sbv.flexItem;
        UIView *sbvsc = sbv.myCurrentSizeClass;
        
        //flex_grow，如果子视图有设置grow则父视图的换行不起作用。
        sbvsc.weight = flexItem.flex_grow_val;
        
        //flex_shrink
        if (lsc.orientation == MyOrientation_Vert)
            sbvsc.widthSize.shrink =  flexItem.flex_shrink_val != MyFlex_Auto? flexItem.flex_shrink_val:0;
        else
            sbvsc.heightSize.shrink = flexItem.flex_shrink_val != MyFlex_Auto? flexItem.flex_shrink_val:0;
        
        [flexItem setSizeConstraintWithSuperview:self];
                
        //基准值设置。
        if (flexItem.flex_basis_val != MyFlex_Auto)
        {
            if (lsc.orientation == MyOrientation_Vert)
            {
                if (flexItem.flex_basis_val < 1 && flexItem.flex_basis_val > 0)
                    [[sbvsc.widthSize __equalTo:lsc.widthSize] __multiply:flexItem.flex_basis_val];
                else
                    [sbvsc.widthSize __equalTo:@(flexItem.flex_basis_val)];
            }
            else
            {
                if (flexItem.flex_basis_val < 1 && flexItem.flex_basis_val > 0)
                    [[sbvsc.heightSize __equalTo:lsc.heightSize] __multiply:flexItem.flex_basis_val];
                else
                    [sbvsc.heightSize __equalTo:@(flexItem.flex_basis_val)];
            }
        }
        
        //对齐方式设置。
        int align_self = flexItem.align_self_val;
        switch (align_self) {
            case MyFlex_Auto:
                sbvsc.alignment = MyGravity_None;
                break;
            case MyFlexGravity_Flex_Start:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Top : MyGravity_Horz_Leading;
                break;
            case MyFlexGravity_Flex_End:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Bottom : MyGravity_Horz_Trailing;
                break;
            case MyFlexGravity_Center:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Center : MyGravity_Horz_Center;
                break;
            case MyFlexGravity_Baseline:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Baseline : MyGravity_None;
                break;
            case MyFlexGravity_Stretch:
                sbvsc.alignment = (lsc.orientation == MyOrientation_Vert)? MyGravity_Vert_Stretch : MyGravity_Horz_Stretch;
                break;
            default:
                break;
        }
    }
    
    
    //设置主轴的水平对齐和拉伸
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = lsc.gravity & MyGravity_Vert_Mask;
    
    switch (self.flex.justify_content_val) {
        case MyFlexGravity_Flex_End:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Trailing | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Bottom | horzGravity;
            break;
        case MyFlexGravity_Center:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Center | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Center | horzGravity;
            break;
        case MyFlexGravity_Space_Between:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Between | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Between | horzGravity;
            break;
        case MyFlexGravity_Space_Around:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.gravity = MyGravity_Horz_Around | vertGravity;
            else
                lsc.gravity = MyGravity_Vert_Around | horzGravity;
            break;
        case MyFlexGravity_Flex_Start:
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
    
    switch (self.flex.align_items_val) {
        case MyFlexGravity_Flex_End:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Bottom | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Trailing | vertArrangedGravity;
            break;
        case MyFlexGravity_Center:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Center | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Center | vertArrangedGravity;
            break;
        case MyFlexGravity_Baseline:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Baseline | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Leading | vertArrangedGravity;
            break;
        case MyFlexGravity_Flex_Start:
            if (lsc.orientation == MyOrientation_Vert)
                lsc.arrangedGravity = MyGravity_Vert_Top | horzArrangedGravity;
            else
                lsc.arrangedGravity = MyGravity_Horz_Leading | vertArrangedGravity;
            break;
        case MyFlexGravity_Stretch:
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
        switch (self.flex.align_content_val) {
            case MyFlexGravity_Flex_End:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Trailing | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Bottom | horzGravity;
                break;
            case MyFlexGravity_Center:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Center | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Center | horzGravity;
                break;
            case MyFlexGravity_Space_Between:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Between | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Between | horzGravity;
                break;
            case MyFlexGravity_Space_Around:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Around | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Around | horzGravity;
                break;
            case MyFlexGravity_Flex_Start:
                if (lsc.orientation == MyOrientation_Horz)
                    lsc.gravity = MyGravity_Horz_Leading | vertGravity;
                else
                    lsc.gravity = MyGravity_Vert_Top | horzGravity;
                break;
            case MyFlexGravity_Stretch:
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

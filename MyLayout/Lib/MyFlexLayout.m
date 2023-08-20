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

const char *const ASSOCIATEDOBJECT_KEY_MYLAYOUT_FLEXITEM = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_FLEXITEM";
const int MyFlex_Auto = -1;

#pragma mark-- MyFlexItemAttrs

@interface MyFlexItemAttrs : NSObject <MyFlexItemAttrs>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) CGFloat flex_grow;
@property (nonatomic, assign) CGFloat flex_shrink;
@property (nonatomic, assign) CGFloat flex_basis;
@property (nonatomic, assign) MyFlexGravity align_self;
@end

@implementation MyFlexItemAttrs

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _order = 0;
        _flex_grow = 0;
        _flex_shrink = 1;
        _flex_basis = MyFlex_Auto;
        _align_self = MyFlex_Auto;
    }
    return self;
}

- (void)setOrder:(NSInteger)order {
    if (_order != order) {
        _order = order;
        [self.view.superview setNeedsLayout];
    }
}

- (void)setFlex_grow:(CGFloat)flex_grow {
    if (_flex_grow != flex_grow) {
        _flex_grow = flex_grow;
        [self.view.superview setNeedsLayout];
    }
}

- (void)setFlex_shrink:(CGFloat)flex_shrink {
    if (_flex_shrink != flex_shrink) {
        _flex_shrink = flex_shrink;
        [self.view.superview setNeedsLayout];
    }
}

- (void)setFlex_basis:(CGFloat)flex_basis {
    if (_flex_basis != flex_basis) {
        _flex_basis = flex_basis;
        [self.view.superview setNeedsLayout];
    }
}

- (void)setAlign_self:(MyFlexGravity)align_self {
    if (_align_self != align_self) {
        _align_self = align_self;
        [self.view.superview setNeedsLayout];
    }
}

- (CGFloat)width {
    if (self.view.widthSizeInner.isWrap) {
        return MyLayoutSize.wrap;
    } else if (self.view.widthSizeInner.isFill) {
        return self.view.widthSizeInner.multiVal == 1 ? MyLayoutSize.fill : self.view.widthSizeInner.multiVal;
    } else if (self.view.widthSizeInner != nil && self.view.widthSizeInner.valType == MyLayoutValType_Nil) {
        return MyLayoutSize.empty;
    } else if (self.view.widthSizeInner.numberVal != nil) {
        return self.view.widthSizeInner.numberVal.doubleValue;
    } else {
        return MyLayoutSize.wrap;
    }
}

- (void)setWidth:(CGFloat)width {
    if (width > 0 && width < 1) {
        self.view.widthSize.equalTo(@(MyLayoutSize.fill)).multiply(width);
    } else {
        self.view.widthSize.equalTo(@(width));
    }
}

- (CGFloat)height {
    if (self.view.heightSizeInner.isWrap) {
        return MyLayoutSize.wrap;
    } else if (self.view.heightSizeInner.isFill) {
        return self.view.heightSizeInner.multiVal == 1 ? MyLayoutSize.fill : self.view.heightSizeInner.multiVal;
    } else if (self.view.heightSizeInner != nil && self.view.heightSizeInner.valType == MyLayoutValType_Nil) {
        return MyLayoutSize.empty;
    } else if (self.view.heightSizeInner.numberVal != nil) {
        return self.view.heightSizeInner.numberVal.doubleValue;
    } else {
        return MyLayoutSize.wrap;
    }
}

- (void)setHeight:(CGFloat)height {
    if (height > 0 && height < 1) {
        self.view.heightSize.equalTo(@(MyLayoutSize.fill)).multiply(height);
    } else {
        self.view.heightSize.equalTo(@(height));
    }
}

@end

#pragma mark-- MyFlexBoxAttrs

@interface MyFlexBoxAttrs : MyFlexItemAttrs <MyFlexBoxAttrs>
@property (nonatomic, assign) MyFlexDirection flex_direction;
@property (nonatomic, assign) MyFlexWrap flex_wrap;
@property (nonatomic, assign) MyFlexGravity justify_content;
@property (nonatomic, assign) MyFlexGravity align_items;
@property (nonatomic, assign) MyFlexGravity align_content;
@property (nonatomic, assign) NSInteger item_size;
@property (nonatomic, assign) UIEdgeInsets padding;
@property (nonatomic, assign) CGFloat vert_space;
@property (nonatomic, assign) CGFloat horz_space;
@end

@implementation MyFlexBoxAttrs

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _flex_direction = MyFlexDirection_Row;
        _flex_wrap = MyFlexWrap_NoWrap;
        _justify_content = MyFlexGravity_Flex_Start;
        _align_items = MyFlexGravity_Stretch;
        _align_content = MyFlexGravity_Stretch;
        _item_size = 0;
    }
    return self;
}

- (void)setFlex_direction:(MyFlexDirection)flex_direction {
    if (_flex_direction != flex_direction) {
        _flex_direction = flex_direction;
        [self.view setNeedsLayout];
    }
}

- (void)setFlex_wrap:(MyFlexWrap)flex_wrap {
    if (_flex_wrap != flex_wrap) {
        _flex_wrap = flex_wrap;
        [self.view setNeedsLayout];
    }
}

- (void)setJustify_content:(MyFlexGravity)justify_content {
    if (_justify_content != justify_content) {
        _justify_content = justify_content;
        [self.view setNeedsLayout];
    }
}

- (void)setAlign_items:(MyFlexGravity)align_items {
    if (_align_items != align_items) {
        _align_items = align_items;
        [self.view setNeedsLayout];
    }
}

- (void)setAlign_content:(MyFlexGravity)align_content {
    if (_align_content != align_content) {
        _align_content = align_content;
        [self.view setNeedsLayout];
    }
}

- (void)setItem_size:(NSInteger)item_size {
    if (_item_size != item_size) {
        _item_size = item_size;
        [self.view setNeedsLayout];
    }
}

- (UIEdgeInsets)padding {
    return ((MyFlexLayout *)self.view).padding;
}

- (void)setPadding:(UIEdgeInsets)padding {
    ((MyFlexLayout *)self.view).padding = padding;
}

- (CGFloat)vert_space {
    return ((MyFlexLayout *)self.view).subviewVSpace;
}

- (void)setVert_space:(CGFloat)vert_space {
    ((MyFlexLayout *)self.view).subviewVSpace = vert_space;
}

- (CGFloat)horz_space {
    return ((MyFlexLayout *)self.view).subviewHSpace;
}

- (void)setHorz_space:(CGFloat)horz_space {
    ((MyFlexLayout *)self.view).subviewHSpace = horz_space;
}

@end

#pragma mark-- MyFlexItem
@interface MyFlexItem : NSObject <MyFlexItem>
@property (nonatomic, weak, readonly) UIView *view;
@end

@implementation MyFlexItem {
  @package
    id<MyFlexItemAttrs> _attrs;
}
@dynamic attrs;

- (instancetype)initWithView:(UIView *)view attrs:(id<MyFlexItemAttrs>)attrs {
    self = [super init];
    if (self != nil) {
        _attrs = attrs;
        _view = view;
    }
    return self;
}

- (id<MyFlexItemAttrs>)attrs {
    return _attrs;
}

- (id<MyFlexItem> (^)(CGFloat))width {
    return ^id(CGFloat val) {
        if (val > 0 && val < 1) {
            self.view.widthSize.equalTo(@(MyLayoutSize.fill)).multiply(val);
        } else {
            self.view.widthSize.equalTo(@(val));
        }
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat percent, CGFloat inc))width_percent {
    return ^id(CGFloat percent, CGFloat inc) {
        self.view.widthSize.equalTo(@(MyLayoutSize.fill)).multiply(percent).add(inc);
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))min_width {
    return ^id(CGFloat val) {
        self.view.widthSize.min(val);
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))max_width {
    return ^id(CGFloat val) {
        self.view.widthSize.max(val);
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))height {
    return ^id(CGFloat val) {
        if (val > 0 && val < 1) {
            self.view.heightSize.equalTo(@(MyLayoutSize.fill)).multiply(val);
        } else {
            self.view.heightSize.equalTo(@(val));
        }
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat percent, CGFloat inc))height_percent {
    return ^id(CGFloat percent, CGFloat inc) {
        self.view.heightSize.equalTo(@(MyLayoutSize.fill)).multiply(percent).add(inc);
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))min_height {
    return ^id(CGFloat val) {
        self.view.heightSize.min(val);
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))max_height {
    return ^id(CGFloat val) {
        self.view.heightSize.max(val);
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))margin_top {
    return ^id(CGFloat val) {
        self.view.myTop = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))margin_bottom {
    return ^id(CGFloat val) {
        self.view.myBottom = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))margin_left {
    return ^id(CGFloat val) {
        self.view.myLeft = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))margin_right {
    return ^id(CGFloat val) {
        self.view.myRight = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))margin {
    return ^id(CGFloat val) {
        self.view.myLeft = val;
        self.view.myRight = val;
        self.view.myTop = val;
        self.view.myBottom = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(MyVisibility))visibility {
    return ^id(MyVisibility val) {
        self.view.visibility = val;
        return self;
    };
}

- (__kindof UIView * (^)(UIView *))addTo {
    return ^(UIView *val) {
        [val addSubview:self.view];
        return self.view;
    };
}

- (id<MyFlexItem> (^)(UIView *))add {
    return ^(UIView *val) {
        [self.view addSubview:val];
        return self;
    };
}

- (id<MyFlexItem> (^)(id<MyFlexItem>))addItem {
    return ^(id<MyFlexItem> item) {
        [self.view addSubview:item.view];
        return self;
    };
}

- (id<MyFlexItem> (^)(NSInteger))order {
    return ^id(NSInteger val) {
        self.attrs.order = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))flex_grow {
    return ^id(CGFloat val) {
        self.attrs.flex_grow = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))flex_shrink {
    return ^id(CGFloat val) {
        self.attrs.flex_shrink = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(CGFloat))flex_basis {
    return ^id(CGFloat val) {
        self.attrs.flex_basis = val;
        return self;
    };
}

- (id<MyFlexItem> (^)(MyFlexGravity))align_self {
    return ^id(MyFlexGravity val) {
        self.attrs.align_self = val;
        return self;
    };
}

@end

#pragma mark-- MyFlexBox

@interface MyFlexBox : MyFlexItem <MyFlexBox>

@end

@implementation MyFlexBox

- (id<MyFlexBox> (^)(MyFlexDirection))flex_direction {
    return ^id(MyFlexDirection val) {
        self.attrs.flex_direction = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(MyFlexWrap))flex_wrap {
    return ^id(MyFlexWrap val) {
        self.attrs.flex_wrap = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(int))flex_flow {
    return ^id(int val) {
        //取方向值。
        MyFlexDirection direction = val & 0x03;
        //取换行值。
        MyFlexWrap wrap = val & 0x0c;
        return self.flex_direction(direction).flex_wrap(wrap);
    };
}

- (id<MyFlexBox> (^)(MyFlexGravity))justify_content {
    return ^id(MyFlexGravity val) {
        self.attrs.justify_content = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(MyFlexGravity))align_items {
    return ^id(MyFlexGravity val) {
        self.attrs.align_items = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(NSInteger))item_size {
    return ^id(NSInteger val) {
        self.attrs.item_size = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(NSInteger))page_size {
    return ^id(NSInteger val) {
        ((MyFlexLayout *)self.view).pagedCount = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(BOOL))auto_arrange {
    return ^id(BOOL val) {
        ((MyFlexLayout *)self.view).autoArrange = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(MyFlexGravity))align_content {
    return ^id(MyFlexGravity val) {
        self.attrs.align_content = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(UIEdgeInsets))padding {
    return ^id(UIEdgeInsets val) {
        ((MyFlexLayout *)self.view).padding = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(CGFloat))vert_space {
    return ^id(CGFloat val) {
        ((MyFlexLayout *)self.view).subviewVSpace = val;
        return self;
    };
}

- (id<MyFlexBox> (^)(CGFloat))horz_space {
    return ^id(CGFloat val) {
        ((MyFlexLayout *)self.view).subviewHSpace = val;
        return self;
    };
}

@end

#pragma mark - UIView

@implementation UIView (MyFlexLayout)

- (id<MyFlexItem>)myFlex {
    if ([self isKindOfClass:[MyFlexLayout class]]) {
        return ((MyFlexLayout *)self).myFlex;
    } else {
        id<MyFlexItem> obj = (id<MyFlexItem>)objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_FLEXITEM);
        if (obj == nil) {
            MyFlexItemAttrs *attrs = [MyFlexItemAttrs new];
            attrs.view = self;
            obj = [[MyFlexItem alloc] initWithView:self attrs:attrs];
        }
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_FLEXITEM, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return obj;
    }
}

@end

@implementation MyFlexLayout

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.orientation = MyOrientation_Vert; //默认row
        self.arrangedCount = NSIntegerMax;     //默认单行
        self.isFlex = YES;                     //满足flexbox的需求。
        self.lastlineGravityPolicy = MyGravityPolicy_Always;

        MyFlexBoxAttrs *attrs = [MyFlexBoxAttrs new];
        attrs.view = self;
        _myFlex = [[MyFlexBox alloc] initWithView:self attrs:attrs];
    }
    return self;
}

- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines context:(MyLayoutContext *)context {
    //将flexbox中的属性映射为MyFlowLayout中的属性。
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    if (context->subviewEngines == nil) {
        context->subviewEngines = [layoutTraits filterEngines:subviewEngines];
    }
    
    id<MyFlexBox> myFlex = self.myFlex;

    //最先设置方向。
    switch (myFlex.attrs.flex_direction) {
        case MyFlexDirection_Column_Reverse: { //column_reverse
            layoutTraits.orientation = MyOrientation_Horz;
            layoutTraits.layoutTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0); //垂直翻转
        } break;
        case MyFlexDirection_Column: { //column;
            layoutTraits.orientation = MyOrientation_Horz;
            layoutTraits.layoutTransform = CGAffineTransformIdentity;
        } break;
        case MyFlexDirection_Row_Reverse: { //row_reverse
            layoutTraits.orientation = MyOrientation_Vert;
            layoutTraits.layoutTransform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0); //水平翻转
        } break;
        case MyFlexDirection_Row:
        default: {
            layoutTraits.orientation = MyOrientation_Vert;
            layoutTraits.layoutTransform = CGAffineTransformIdentity;
        } break;
    }

    //设置换行
    switch (myFlex.attrs.flex_wrap) {
        case MyFlexWrap_Wrap: {
            layoutTraits.arrangedCount = myFlex.attrs.item_size;
        } break;
        case MyFlexWrap_Wrap_Reverse: {
            layoutTraits.arrangedCount = myFlex.attrs.item_size;
            layoutTraits.layoutTransform = CGAffineTransformConcat(layoutTraits.layoutTransform, (layoutTraits.orientation == MyOrientation_Vert) ? CGAffineTransformMake(1, 0, 0, -1, 0, 0) : CGAffineTransformMake(-1, 0, 0, 1, 0, 0));
        } break;
        case MyFlexWrap_NoWrap:
        default: {
            layoutTraits.arrangedCount = NSIntegerMax;
        } break;
    }

    //按order排序。
    [context->subviewEngines sortWithOptions:NSSortStable
         usingComparator:^NSComparisonResult(MyLayoutEngine *_Nonnull obj1, MyLayoutEngine *_Nonnull obj2) {
            return obj1.currentSizeClass.view.myFlex.attrs.order - obj2.currentSizeClass.view.myFlex.attrs.order;
         }];

    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        id<MyFlexItem> flexItem = subviewTraits.view.myFlex;

        //flex_grow，如果子视图有设置grow则父视图的换行不起作用。
        subviewTraits.weight = flexItem.attrs.flex_grow;

        //flex_shrink
        if (layoutTraits.orientation == MyOrientation_Vert) {
            subviewTraits.widthSize.shrink = flexItem.attrs.flex_shrink != MyFlex_Auto ? flexItem.attrs.flex_shrink : 0;
        } else {
            subviewTraits.heightSize.shrink = flexItem.attrs.flex_shrink != MyFlex_Auto ? flexItem.attrs.flex_shrink : 0;
        }

        //如果没有设置尺寸约束则默认是自适应。
        if (subviewTraits.widthSizeInner.val == nil) {
            [subviewTraits.widthSize _myEqualTo:@(MyLayoutSize.wrap)];
        }
        if (subviewTraits.heightSizeInner.val == nil) {
            [subviewTraits.heightSize _myEqualTo:@(MyLayoutSize.wrap)];
        }

        //基准值设置。
        if (flexItem.attrs.flex_basis != MyFlex_Auto) {
            if (layoutTraits.orientation == MyOrientation_Vert) {
                if (flexItem.attrs.flex_basis > 0 && flexItem.attrs.flex_basis < 1) {
                    [[subviewTraits.widthSize _myEqualTo:@(MyLayoutSize.fill)] _myMultiply:flexItem.attrs.flex_basis];
                } else {
                    [subviewTraits.widthSize _myEqualTo:@(flexItem.attrs.flex_basis)];
                }
            } else {
                if (flexItem.attrs.flex_basis > 0 && flexItem.attrs.flex_basis < 1) {
                    [[subviewTraits.heightSize _myEqualTo:@(MyLayoutSize.fill)] _myMultiply:flexItem.attrs.flex_basis];
                } else {
                    [subviewTraits.heightSize _myEqualTo:@(flexItem.attrs.flex_basis)];
                }
            }
        }

        //对齐方式设置。
        int align_self = flexItem.attrs.align_self;
        switch (align_self) {
            case -1:
                subviewTraits.alignment = MyGravity_None;
                break;
            case MyFlexGravity_Flex_Start:
                subviewTraits.alignment = (layoutTraits.orientation == MyOrientation_Vert) ? MyGravity_Vert_Top : MyGravity_Horz_Leading;
                break;
            case MyFlexGravity_Flex_End:
                subviewTraits.alignment = (layoutTraits.orientation == MyOrientation_Vert) ? MyGravity_Vert_Bottom : MyGravity_Horz_Trailing;
                break;
            case MyFlexGravity_Center:
                subviewTraits.alignment = (layoutTraits.orientation == MyOrientation_Vert) ? MyGravity_Vert_Center : MyGravity_Horz_Center;
                break;
            case MyFlexGravity_Baseline:
                subviewTraits.alignment = (layoutTraits.orientation == MyOrientation_Vert) ? MyGravity_Vert_Baseline : MyGravity_None;
                break;
            case MyFlexGravity_Stretch:
                subviewTraits.alignment = (layoutTraits.orientation == MyOrientation_Vert) ? MyGravity_Vert_Stretch : MyGravity_Horz_Stretch;
                break;
            default:
                break;
        }
    }

    //设置主轴的水平对齐和拉伸
    MyGravity vertGravity = MYVERTGRAVITY(layoutTraits.gravity);
    MyGravity horzGravity = MYHORZGRAVITY(layoutTraits.gravity);
    switch (myFlex.attrs.justify_content) {
        case MyFlexGravity_Flex_End:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.gravity = MyGravity_Horz_Trailing | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Bottom | horzGravity;
            }
            break;
        case MyFlexGravity_Center:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.gravity = MyGravity_Horz_Center | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Center | horzGravity;
            }
            break;
        case MyFlexGravity_Space_Between:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.gravity = MyGravity_Horz_Between | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Between | horzGravity;
            }
            break;
        case MyFlexGravity_Space_Around:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.gravity = MyGravity_Horz_Around | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Around | horzGravity;
            }
            break;
        case MyFlexGravity_Flex_Start:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.gravity = MyGravity_Horz_Leading | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Top | horzGravity;
            }
        default:
            break;
    }

    //次轴的对齐处理。
    MyGravity vertArrangedGravity = MYVERTGRAVITY(layoutTraits.arrangedGravity);
    MyGravity horzArrangedGravity = MYHORZGRAVITY(layoutTraits.arrangedGravity);
    switch (myFlex.attrs.align_items) {
        case MyFlexGravity_Flex_End:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.arrangedGravity = MyGravity_Vert_Bottom | horzArrangedGravity;
            } else {
                layoutTraits.arrangedGravity = MyGravity_Horz_Trailing | vertArrangedGravity;
            }
            break;
        case MyFlexGravity_Center:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.arrangedGravity = MyGravity_Vert_Center | horzArrangedGravity;
            } else {
                layoutTraits.arrangedGravity = MyGravity_Horz_Center | vertArrangedGravity;
            }
            break;
        case MyFlexGravity_Baseline:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.arrangedGravity = MyGravity_Vert_Baseline | horzArrangedGravity;
            } else {
                layoutTraits.arrangedGravity = MyGravity_Horz_Leading | vertArrangedGravity;
            }
            break;
        case MyFlexGravity_Flex_Start:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.arrangedGravity = MyGravity_Vert_Top | horzArrangedGravity;
            } else {
                layoutTraits.arrangedGravity = MyGravity_Horz_Leading | vertArrangedGravity;
            }
            break;
        case MyFlexGravity_Stretch:
        default:
            if (layoutTraits.orientation == MyOrientation_Vert) {
                layoutTraits.arrangedGravity = MyGravity_Vert_Stretch | horzArrangedGravity;
            } else {
                layoutTraits.arrangedGravity = MyGravity_Horz_Stretch | vertArrangedGravity;
            }
            break;
    }

    //多行下的整体停靠处理。
    vertGravity = MYVERTGRAVITY(layoutTraits.gravity);
    horzGravity = MYHORZGRAVITY(layoutTraits.gravity);
    switch (myFlex.attrs.align_content) {
        case MyFlexGravity_Flex_End:
            if (layoutTraits.orientation == MyOrientation_Horz) {
                layoutTraits.gravity = MyGravity_Horz_Trailing | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Bottom | horzGravity;
            }
            break;
        case MyFlexGravity_Center:
            if (layoutTraits.orientation == MyOrientation_Horz) {
                layoutTraits.gravity = MyGravity_Horz_Center | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Center | horzGravity;
            }
            break;
        case MyFlexGravity_Space_Between:
            if (layoutTraits.orientation == MyOrientation_Horz) {
                layoutTraits.gravity = MyGravity_Horz_Between | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Between | horzGravity;
            }
            break;
        case MyFlexGravity_Space_Around:
            if (layoutTraits.orientation == MyOrientation_Horz) {
                layoutTraits.gravity = MyGravity_Horz_Around | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Around | horzGravity;
            }
            break;
        case MyFlexGravity_Flex_Start:
            if (layoutTraits.orientation == MyOrientation_Horz) {
                layoutTraits.gravity = MyGravity_Horz_Leading | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Top | horzGravity;
            }
            break;
        case MyFlexGravity_Stretch:
        default:
            if (layoutTraits.orientation == MyOrientation_Horz) {
                layoutTraits.gravity = MyGravity_Horz_Stretch | vertGravity;
            } else {
                layoutTraits.gravity = MyGravity_Vert_Stretch | horzGravity;
            }
            break;
    }

    return [super calcLayoutSize:size subviewEngines:subviewEngines context:context];
}

@end

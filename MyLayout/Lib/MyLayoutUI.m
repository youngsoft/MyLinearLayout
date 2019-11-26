//
//  MyFlexItem.m
//  MyLayout
//
//  Created by oubaiquan on 2019/11/15.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import "MyBaseLayout.h"
#import "MyLayoutInner.h"
#import "MyLayoutUIInner.h"
#import <objc/runtime.h>

const char * const ASSOCIATEDOBJECT_KEY_MYLAYOUT_MYUI = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_MYUI";


#pragma mark -- MyUIViewUI

@implementation MyUIViewUI

-(instancetype)initWithView:(UIView*)view
{
    self = [self init];
    if (self != nil)
    {
        _view = view;
    }
    return self;
}

-(id<MyUIViewUI> (^)(CGFloat))width
{
    return ^id(CGFloat val) {
        if (val > 0 && val < 1)
            self.view.widthSize.equalTo(@(MyLayoutSize.fill)).multiply(val);
        else
            self.view.widthSize.equalTo(@(val));
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat percent, CGFloat inc))width_percent
{
    return ^id(CGFloat percent, CGFloat inc) {
        self.view.widthSize.equalTo(@(MyLayoutSize.fill)).multiply(percent).add(inc);
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))min_width
{
    return ^id(CGFloat val) {
        self.view.widthSize.min(val);
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))max_width
{
    return ^id(CGFloat val) {
        self.view.widthSize.max(val);
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))height
{
    return ^id(CGFloat val) {
        if (val > 0 && val < 1)
            self.view.heightSize.equalTo(@(MyLayoutSize.fill)).multiply(val);
        else
            self.view.heightSize.equalTo(@(val));
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat percent, CGFloat inc))height_percent
{
    return ^id(CGFloat percent, CGFloat inc) {
        self.view.heightSize.equalTo(@(MyLayoutSize.fill)).multiply(percent).add(inc);
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))min_height
{
    return ^id(CGFloat val) {
        self.view.heightSize.min(val);
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))max_height
{
    return ^id(CGFloat val) {
        self.view.heightSize.max(val);
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))margin_top
{
    return ^id(CGFloat val) {
        self.view.myTop = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))margin_bottom
{
    return ^id(CGFloat val) {
        self.view.myBottom = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))margin_left
{
    return ^id(CGFloat val) {
        self.view.myLeft = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))margin_right
{
    return ^id(CGFloat val) {
        self.view.myRight = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))margin
{
    return ^id(CGFloat val) {
        self.view.myLeft = val;
        self.view.myRight = val;
        self.view.myTop = val;
        self.view.myBottom = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(MyVisibility))visibility
{
    return ^id(MyVisibility val) {
        self.view.visibility = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGAffineTransform))transform
{
    return ^id(CGAffineTransform val) {
        self.view.transform = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(BOOL))clipsToBounds
{
    return ^id(BOOL val) {
        self.view.clipsToBounds = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(UIColor*))backgroundColor
{
    return ^id(UIColor *val) {
        self.view.backgroundColor = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))alpha
{
    return ^id(CGFloat val) {
        self.view.alpha = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(NSInteger))tag
{
    return ^id(NSInteger val) {
        self.view.tag = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(BOOL))userInteractionEnabled
{
    return ^id(BOOL val) {
        self.view.userInteractionEnabled = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(UIColor *color, CGFloat width))border
{
    return ^id(UIColor *color, CGFloat width) {
        self.view.layer.borderColor = color.CGColor;
        self.view.layer.borderWidth = width;
        return self;
    };
}

-(id<MyUIViewUI> (^)(CGFloat))cornerRadius
{
    return ^id(CGFloat val) {
        self.view.layer.cornerRadius = val;
        return self;
    };
}

-(id<MyUIViewUI> (^)(UIColor* color, CGSize offset, CGFloat radius))shadow
{
    return ^id(UIColor *color, CGSize offset, CGFloat radius) {
        self.view.layer.shadowColor = color.CGColor;
        self.view.layer.shadowOffset = offset;
        self.view.layer.shadowRadius = radius;
        return self;
    };
}

-(__kindof UIView* (^)(UIView*))addTo
{
    return ^(UIView *val) {
        [val addSubview:self.view];
        return self.view;
    };
}

-(id<MyUIViewUI> (^)(UIView*))add
{
    return ^(UIView *val) {
        [self.view addSubview:val];
        return self;
    };
}


@end


@implementation UIView(MyLayoutUI)

-(id<MyUIViewUI>)myUI
{
    id<MyUIViewUI> obj = (id<MyUIViewUI>)objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_MYUI);
    if (obj == nil)
    {
        obj = [[MyUIViewUI alloc] initWithView:self];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MYLAYOUT_MYUI, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

@end

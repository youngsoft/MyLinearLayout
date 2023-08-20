//
//  MyRelativeLayout.m
//  MyLayout
//
//  Created by oybq on 15/7/1.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyRelativeLayout.h"
#import "MyLayoutInner.h"

@implementation MyRelativeLayout

#pragma mark-- Override Methods

- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines context:(MyLayoutContext *)context {
    [super calcLayoutSize:size subviewEngines:subviewEngines context:context];
    
    MyRelativeLayoutTraits *layoutTraits = (MyRelativeLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    context->paddingTop = layoutTraits.myLayoutPaddingTop;
    context->paddingBottom = layoutTraits.myLayoutPaddingBottom;
    context->paddingLeading = layoutTraits.myLayoutPaddingLeading;
    context->paddingTrailing = layoutTraits.myLayoutPaddingTrailing;
    context->subviewEngines = subviewEngines;

    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:0.0 subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    } 
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:0.0 subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    } 
    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;

        if (subviewTraits.useFrame) {
            continue;
        }
        
        [subviewEngine reset];
        
        //只要同时设置了左右边距且宽度优先级很低则把宽度值置空
        if (subviewTraits.leadingPosInner.val != nil &&
            subviewTraits.trailingPosInner.val != nil &&
            (subviewTraits.widthSizeInner.priority == MyPriority_Low || !layoutTraits.widthSizeInner.wrapVal))
            [subviewTraits.widthSizeInner _myEqualTo:nil];

        //只要同时设置了上下边距且高度优先级很低则把高度值置空
        if (subviewTraits.topPosInner.val != nil &&
            subviewTraits.bottomPosInner.val != nil &&
            (subviewTraits.heightSizeInner.priority == MyPriority_Low || !layoutTraits.heightSizeInner.wrapVal)) {
            [subviewTraits.heightSizeInner _myEqualTo:nil];
        }
    }

    BOOL reCalcWidth = NO;
    BOOL reCalcHeight = NO;
    CGSize maxSize = [self myDoLayoutRecalcWidth:&reCalcWidth recalcHeight:&reCalcHeight withContext:context];
    //如果布局视图的尺寸自适应的，这里要调整一下布局视图的尺寸。但是因为有一些子视图的约束是依赖布局视图的而且可能会引发连锁反应，所以这里要再次进行重新布局处理
    if (layoutTraits.widthSizeInner.wrapVal || layoutTraits.heightSizeInner.wrapVal) {
        if (_myCGFloatNotEqual(context->selfSize.height, maxSize.height) || _myCGFloatNotEqual(context->selfSize.width, maxSize.width)) {
            if (layoutTraits.widthSizeInner.wrapVal) {
                context->selfSize.width = maxSize.width;
            }
            if (layoutTraits.heightSizeInner.wrapVal) {
                context->selfSize.height = maxSize.height;
            }
            //如果里面有需要重新计算的就重新计算布局
            if (reCalcWidth || reCalcHeight) {
                for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
                    [subviewEngine reset];
                }
                [self myDoLayoutRecalcWidth:NULL recalcHeight:NULL withContext:context];
            }
        }
    }

    context->subviewEngines = [layoutTraits filterEngines:context->subviewEngines];
    return [self myAdjustLayoutViewSizeWithContext:context];
}

- (id)createSizeClassInstance {
    return [MyRelativeLayoutTraits new];
}

#pragma mark-- Private Method
- (void)mySubviewEngine:(MyLayoutEngine *)subviewEngine calcLeadingTrailingWithContext:(MyLayoutContext *)context {
    
    MyRelativeLayoutTraits *layoutTraits = (MyRelativeLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;

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

    if (subviewEngine.leading != CGFLOAT_MAX && subviewEngine.trailing != CGFLOAT_MAX && subviewEngine.width != CGFLOAT_MAX) {
        return;
    }
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self mySubviewEngine:subviewEngine calcWidthWithContext:context]) {
        return;
    }

    //表示视图数组水平居中
    if (subviewTraits.centerXPosInner.arrayVal != nil) {
        //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
        NSArray *anchorArray = subviewTraits.centerXPosInner.arrayVal;

        CGFloat totalWidth = 0.0;
        CGFloat totalOffset = 0.0;

        MyLayoutPos *nextAnchor = nil;
        for (NSInteger i = anchorArray.count - 1; i >= 0; i--) {
            MyLayoutPos *anchor = anchorArray[i];
            MyViewTraits *relativeViewTraits = anchor.view.myEngine.currentSizeClass;
            if (![relativeViewTraits invalid]) {
                if (totalWidth != 0) {
                    if (nextAnchor != nil) {
                        totalOffset += nextAnchor.measure;
                    }
                }
                [self mySubviewEngine:anchor.view.myEngine calcWidthWithContext:context];
                totalWidth += anchor.view.myEngine.width;
            }

            nextAnchor = anchor;
        }

        if (![subviewTraits invalid]) {
            if (totalWidth != 0.0) {
                if (nextAnchor != nil) {
                    totalOffset += nextAnchor.measure;
                }
            }

            [self mySubviewEngine:subviewEngine calcWidthWithContext:context];
            totalWidth += subviewEngine.width;
            totalOffset += subviewTraits.centerXPosInner.measure;
        }

        //所有宽度算出后，再分别设置
        CGFloat leadingOffset = (context->selfSize.width - context->paddingLeading - context->paddingTrailing - totalWidth - totalOffset) / 2;
        id prevAxis = @(leadingOffset);
        [subviewTraits.leadingPos _myEqualTo:prevAxis];
        prevAxis = subviewTraits.trailingPos;
        for (MyLayoutPos *anchor in anchorArray) {
            MyViewTraits *relativeViewTraits = anchor.view.myEngine.currentSizeClass;
            [[relativeViewTraits.leadingPos _myEqualTo:prevAxis] _myOffset:anchor.measure];
            prevAxis = relativeViewTraits.trailingPos;
        }
    }

    if (subviewTraits.centerXPosInner.anchorVal != nil) {
        UIView *relativeView = subviewTraits.centerXPosInner.anchorVal.view;
        MyLayoutEngine *relativeViewEngine = relativeView.myEngine;

        subviewEngine.leading = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.centerXPosInner.anchorVal.anchorType withContext:context] - subviewEngine.width / 2 + subviewTraits.centerXPosInner.measure;

        if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
            subviewEngine.leading -= subviewTraits.centerXPosInner.measure;
        }
        if (subviewEngine.leading < 0.0 && relativeView == self && layoutTraits.widthSizeInner.wrapVal) {
            subviewEngine.leading = 0.0;
        }
        subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
    } else if (subviewTraits.centerXPosInner.mostVal != nil) {
        subviewEngine.leading = subviewTraits.centerXPosInner.mostVal.doubleValue - subviewEngine.width / 2 + subviewTraits.centerXPosInner.measure;
        subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
    } else if (subviewTraits.centerXPosInner.numberVal != nil) {
        subviewEngine.leading = (context->selfSize.width - context->paddingLeading - context->paddingTrailing - subviewEngine.width) / 2 + context->paddingLeading + subviewTraits.centerXPosInner.measure;

        if (subviewEngine.leading < 0.0 && layoutTraits.widthSizeInner.wrapVal) {
            subviewEngine.leading = 0.0;
        }
        subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
    } else {
        //如果左右都设置了则上上面的calcWidth会直接返回不会进入这个流程。
        if (subviewTraits.leadingPosInner.anchorVal != nil) {
            UIView *relativeView = subviewTraits.leadingPosInner.anchorVal.view;
            MyLayoutEngine *relativeViewEngine = relativeView.myEngine;

            subviewEngine.leading = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.leadingPosInner.anchorVal.anchorType withContext:context] + subviewTraits.leadingPosInner.measure;

            if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
                subviewEngine.leading -= subviewTraits.leadingPosInner.measure;
            }
            subviewEngine.trailing = subviewEngine.leading + subviewEngine.width + subviewTraits.trailingPosInner.measure;
        } else if (subviewTraits.leadingPosInner.mostVal != nil) {
            subviewEngine.leading = subviewTraits.leadingPosInner.mostVal.doubleValue + subviewTraits.leadingPosInner.measure;
            subviewEngine.trailing = subviewEngine.leading + subviewEngine.width + subviewTraits.trailingPosInner.measure;
        } else if (subviewTraits.leadingPosInner.numberVal != nil) {
            subviewEngine.leading = subviewTraits.leadingPosInner.measure + context->paddingLeading;
            subviewEngine.trailing = subviewEngine.leading + subviewEngine.width + subviewTraits.trailingPosInner.measure;
        } else if (subviewTraits.trailingPosInner.anchorVal != nil) {
            UIView *relativeView = subviewTraits.trailingPosInner.anchorVal.view;
            MyLayoutEngine *relativeViewEngine = relativeView.myEngine;
            subviewEngine.trailing = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.trailingPosInner.anchorVal.anchorType withContext:context] - subviewTraits.trailingPosInner.measure + subviewTraits.leadingPosInner.measure;

            if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
                subviewEngine.trailing += subviewTraits.trailingPosInner.measure;
            }
            subviewEngine.leading = subviewEngine.trailing - subviewEngine.width;
        } else if (subviewTraits.trailingPosInner.mostVal != nil) {
            subviewEngine.trailing = subviewTraits.trailingPosInner.mostVal.doubleValue - subviewTraits.trailingPosInner.measure + subviewTraits.leadingPosInner.measure;
            subviewEngine.leading = subviewEngine.trailing - subviewEngine.width;
        } else if (subviewTraits.trailingPosInner.numberVal != nil) {
            subviewEngine.trailing = context->selfSize.width - subviewTraits.trailingPosInner.measure - context->paddingTrailing;
            subviewEngine.leading = subviewEngine.trailing - subviewEngine.width;
        } else {
            subviewEngine.leading = subviewTraits.leadingPosInner.measure + context->paddingLeading;
            subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
        }
    }

    //这里要更新左边最小和右边最大约束的情况。
    MyLayoutPos *lBoundAnchor = subviewTraits.leadingPosInner.lBoundValInner;
    MyLayoutPos *uBoundAnchor = subviewTraits.trailingPosInner.uBoundValInner;
    UIView *lBoundRelativeView = lBoundAnchor.anchorVal.view;
    UIView *uBoundRelativeView = uBoundAnchor.anchorVal.view;
    MyLayoutEngine *lBoundRelativeViewEngine = lBoundRelativeView.myEngine;
    MyLayoutEngine *uBoundRelativeViewEngine = uBoundRelativeView.myEngine;

    if (lBoundAnchor.anchorVal != nil && uBoundAnchor.anchorVal != nil) {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat minLeading = [self mySubviewEngine:lBoundRelativeViewEngine getMeasureFromAnchorType:lBoundAnchor.anchorVal.anchorType withContext:context] + lBoundAnchor.offsetVal;
        if (lBoundRelativeView != nil && lBoundRelativeView != self && [lBoundRelativeViewEngine.currentSizeClass invalid]) {
            minLeading -= lBoundAnchor.offsetVal;
        }
        CGFloat maxTrailing = [self mySubviewEngine:uBoundRelativeViewEngine getMeasureFromAnchorType:uBoundAnchor.anchorVal.anchorType withContext:context] - uBoundAnchor.offsetVal;
        if (uBoundRelativeView != nil && uBoundRelativeView != self && [uBoundRelativeViewEngine.currentSizeClass invalid]) {
            maxTrailing += uBoundAnchor.offsetVal;
        }
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        CGFloat intervalWidth = maxTrailing - minLeading;
        if (_myCGFloatLess(intervalWidth, subviewEngine.width)) {
            subviewEngine.width = intervalWidth;
            subviewEngine.leading = minLeading;
        } else {
            subviewEngine.leading = (intervalWidth - subviewEngine.width) / 2 + minLeading;
        }
        subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
    } else if (lBoundAnchor.anchorVal != nil) {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat minLeading = [self mySubviewEngine:lBoundRelativeViewEngine getMeasureFromAnchorType:lBoundAnchor.anchorVal.anchorType withContext:context] + lBoundAnchor.offsetVal;
        if (lBoundRelativeView != nil && lBoundRelativeView != self && [lBoundRelativeViewEngine.currentSizeClass invalid]) {
            minLeading -= lBoundAnchor.offsetVal;
        }
        if (_myCGFloatLess(subviewEngine.leading, minLeading)) {
            subviewEngine.leading = minLeading;
            subviewEngine.width = subviewEngine.trailing - subviewEngine.leading;
        }
    } else if (uBoundAnchor.anchorVal != nil) {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat maxTrailing = [self mySubviewEngine:uBoundRelativeViewEngine getMeasureFromAnchorType:uBoundAnchor.anchorVal.anchorType withContext:context] - uBoundAnchor.offsetVal;
        if (uBoundRelativeView != nil && uBoundRelativeView != self && [uBoundRelativeViewEngine.currentSizeClass invalid]) {
            maxTrailing += uBoundAnchor.offsetVal;
        }
        if (_myCGFloatGreat(subviewEngine.trailing, maxTrailing)) {
            subviewEngine.trailing = maxTrailing;
            subviewEngine.width = subviewEngine.trailing - subviewEngine.leading;
        }
    }
}

- (void)mySubviewEngine:(MyLayoutEngine *)subviewEngine calcTopBottomWithContext:(MyLayoutContext *)context {

    MyRelativeLayoutTraits *layoutTraits = (MyRelativeLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;

    
    if (subviewEngine.top != CGFLOAT_MAX && subviewEngine.bottom != CGFLOAT_MAX && subviewEngine.height != CGFLOAT_MAX) {
        return;
    }
    //先检测高度,如果高度是父亲的高度则高度和上下都确定
    if ([self mySubviewEngine:subviewEngine calcHeightWithContext:context]) {
        return;
    }

    //表示视图数组垂直居中
    if (subviewTraits.centerYPosInner.arrayVal != nil) {
        NSArray *anchorArray = subviewTraits.centerYPosInner.arrayVal;

        CGFloat totalHeight = 0.0;
        CGFloat totalOffset = 0.0;

        MyLayoutPos *nextAnchor = nil;
        for (NSInteger i = anchorArray.count - 1; i >= 0; i--) {
            MyLayoutPos *anchor = anchorArray[i];
            MyViewTraits *relativeViewTraits = anchor.view.myEngine.currentSizeClass;
            if (![relativeViewTraits invalid]) {
                if (totalHeight != 0.0) {
                    if (nextAnchor != nil) {
                        totalOffset += nextAnchor.measure;
                    }
                }
                [self mySubviewEngine:anchor.view.myEngine calcHeightWithContext:context];
                totalHeight += anchor.view.myEngine.height;
            }

            nextAnchor = anchor;
        }

        if (![subviewTraits invalid]) {
            if (totalHeight != 0.0) {
                if (nextAnchor != nil) {
                    totalOffset += nextAnchor.measure;
                }
            }
            [self mySubviewEngine:subviewEngine calcHeightWithContext:context];
            totalHeight += subviewEngine.height;
            totalOffset += subviewTraits.centerYPosInner.measure;
        }

        //所有高度算出后，再分别设置
        CGFloat topOffset = (context->selfSize.height - context->paddingTop - context->paddingBottom - totalHeight - totalOffset) / 2;
        id prevAxis = @(topOffset);
        [subviewTraits.topPos _myEqualTo:prevAxis];
        prevAxis = subviewTraits.bottomPos;
        for (MyLayoutPos *anchor in anchorArray) {
            MyViewTraits *relativeViewTraits = anchor.view.myEngine.currentSizeClass;
            [[relativeViewTraits.topPos _myEqualTo:prevAxis] _myOffset:anchor.measure];
            prevAxis = relativeViewTraits.bottomPos;
        }
    }

    if (subviewTraits.baselinePosInner.anchorVal != nil) {
        //得到基线的位置。基线的位置等于top + (子视图的高度 - 字体的高度) / 2 + 字体基线以上的高度。
        UIFont *subviewFont = [self myGetSubviewFont:subviewTraits.view];

        if (subviewFont != nil) {
            //得到基线的位置。
            UIView *relativeView = subviewTraits.baselinePosInner.anchorVal.view;
            MyLayoutEngine *relativeViewEngine = relativeView.myEngine;
            subviewEngine.top = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.baselinePosInner.anchorVal.anchorType withContext:context] - subviewFont.ascender - (subviewEngine.height - subviewFont.lineHeight) / 2 + subviewTraits.baselinePosInner.measure;

            if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
                subviewEngine.top -= subviewTraits.baselinePosInner.measure;
            }
        } else {
            subviewEngine.top = context->paddingTop + subviewTraits.baselinePosInner.measure;
        }

        subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    } else if (subviewTraits.baselinePosInner.mostVal != nil) {
        UIFont *subviewFont = [self myGetSubviewFont:subviewTraits.view];
        if (subviewFont != nil) {
            subviewEngine.top = subviewTraits.baselinePosInner.mostVal.doubleValue + subviewTraits.baselinePosInner.measure - subviewFont.ascender - (subviewEngine.height - subviewFont.lineHeight) / 2;
        } else {
            subviewEngine.top = subviewTraits.baselinePosInner.mostVal.doubleValue + subviewTraits.baselinePosInner.measure;
        }

        subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    } else if (subviewTraits.baselinePosInner.numberVal != nil) {
        UIFont *subviewFont = [self myGetSubviewFont:subviewTraits.view];

        if (subviewFont != nil) {
            //根据基线位置反退顶部位置。
            subviewEngine.top = context->paddingTop + subviewTraits.baselinePosInner.measure - subviewFont.ascender - (subviewEngine.height - subviewFont.lineHeight) / 2;
        } else {
            subviewEngine.top = context->paddingTop + subviewTraits.baselinePosInner.measure;
        }
        subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    } else if (subviewTraits.centerYPosInner.anchorVal != nil) {
        UIView *relativeView = subviewTraits.centerYPosInner.anchorVal.view;
        MyLayoutEngine *relativeViewEngine = relativeView.myEngine;

        subviewEngine.top = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType :subviewTraits.centerYPosInner.anchorVal.anchorType withContext:context] - subviewEngine.height / 2 + subviewTraits.centerYPosInner.measure;

        if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
            subviewEngine.top -= subviewTraits.centerYPosInner.measure;
        }
        if (subviewEngine.top < 0.0 && relativeView == self && layoutTraits.heightSizeInner.wrapVal) {
            subviewEngine.top = 0.0;
        }
        subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    } else if (subviewTraits.centerYPosInner.mostVal != nil) {
        subviewEngine.top = subviewTraits.centerYPosInner.mostVal.doubleValue + subviewTraits.centerYPosInner.measure - subviewEngine.height / 2;

        if (subviewEngine.top < 0.0 && layoutTraits.heightSizeInner.wrapVal) {
            subviewEngine.top = 0.0;
        }
        subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    } else if (subviewTraits.centerYPosInner.numberVal != nil) {
        subviewEngine.top = (context->selfSize.height - context->paddingTop - context->paddingBottom - subviewEngine.height) / 2 + context->paddingTop + subviewTraits.centerYPosInner.measure;

        if (subviewEngine.top < 0.0 && layoutTraits.heightSizeInner.wrapVal) {
            subviewEngine.top = 0.0;
        }
        subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    } else {
        if (subviewTraits.topPosInner.anchorVal != nil) {
            UIView *relativeView = subviewTraits.topPosInner.anchorVal.view;
            MyLayoutEngine *relativeViewEngine = relativeView.myEngine;
            subviewEngine.top = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.topPosInner.anchorVal.anchorType withContext:context] + subviewTraits.topPosInner.measure;
            if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
                subviewEngine.top -= subviewTraits.topPosInner.measure;
            }
            subviewEngine.bottom = subviewEngine.top + subviewEngine.height + subviewTraits.bottomPosInner.measure;
        } else if (subviewTraits.topPosInner.mostVal != nil) {
            subviewEngine.top = subviewTraits.topPosInner.mostVal.doubleValue + subviewTraits.topPosInner.measure;
            subviewEngine.bottom = subviewEngine.top + subviewEngine.height + subviewTraits.bottomPosInner.measure;
        } else if (subviewTraits.topPosInner.numberVal != nil) {
            subviewEngine.top = subviewTraits.topPosInner.measure + context->paddingTop;
            subviewEngine.bottom = subviewEngine.top + subviewEngine.height + subviewTraits.bottomPosInner.measure;
        } else if (subviewTraits.bottomPosInner.anchorVal != nil) {
            UIView *relativeView = subviewTraits.bottomPosInner.anchorVal.view;
            MyLayoutEngine *relativeViewEngine = relativeView.myEngine;
            subviewEngine.bottom = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.bottomPosInner.anchorVal.anchorType withContext:context] - subviewTraits.bottomPosInner.measure + subviewTraits.topPosInner.measure;
            if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
                subviewEngine.bottom += subviewTraits.bottomPosInner.measure;
            }
            subviewEngine.top = subviewEngine.bottom - subviewEngine.height;
        } else if (subviewTraits.bottomPosInner.mostVal != nil) {
            subviewEngine.bottom = subviewTraits.bottomPosInner.mostVal.doubleValue - subviewTraits.bottomPosInner.measure + subviewTraits.topPosInner.measure;
            subviewEngine.top = subviewEngine.bottom - subviewEngine.height;
        } else if (subviewTraits.bottomPosInner.numberVal != nil) {
            subviewEngine.bottom = context->selfSize.height - subviewTraits.bottomPosInner.measure - context->paddingBottom;
            subviewEngine.top = subviewEngine.bottom - subviewEngine.height;
        } else {
            subviewEngine.top = subviewTraits.topPosInner.measure + context->paddingTop;
            subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
        }
    }

    //这里要更新上边最小和下边最大约束的情况。
    MyLayoutPos *lBoundAnchor = subviewTraits.topPosInner.lBoundValInner;
    MyLayoutPos *uBoundAnchor = subviewTraits.bottomPosInner.uBoundValInner;
    UIView *lBoundRelativeView = lBoundAnchor.anchorVal.view;
    UIView *uBoundRelativeView = uBoundAnchor.anchorVal.view;
    MyLayoutEngine *lBoundRelativeViewEngine = lBoundRelativeView.myEngine;
    MyLayoutEngine *uBoundRelativeViewEngine = uBoundRelativeView.myEngine;


    if (lBoundAnchor.anchorVal != nil && uBoundAnchor.anchorVal != nil) {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat minTop = [self mySubviewEngine:lBoundRelativeViewEngine getMeasureFromAnchorType:lBoundAnchor.anchorVal.anchorType withContext:context] + lBoundAnchor.offsetVal;
        if (lBoundRelativeView != nil && lBoundRelativeView != self && [lBoundRelativeViewEngine.currentSizeClass invalid]) {
            minTop -= lBoundAnchor.offsetVal;
        }
        CGFloat maxBottom = [self mySubviewEngine:uBoundRelativeViewEngine getMeasureFromAnchorType:uBoundAnchor.anchorVal.anchorType withContext:context] - uBoundAnchor.offsetVal;
        if (uBoundRelativeView != nil && uBoundRelativeView != self && [uBoundRelativeViewEngine.currentSizeClass invalid]) {
            maxBottom += uBoundAnchor.offsetVal;
        }
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        if (_myCGFloatLess(maxBottom - minTop, subviewEngine.height)) {
            subviewEngine.height = maxBottom - minTop;
            subviewEngine.top = minTop;
        } else {
            subviewEngine.top = (maxBottom - minTop - subviewEngine.height) / 2 + minTop;
        }
        subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
    } else if (lBoundAnchor.anchorVal != nil) {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat minTop = [self mySubviewEngine:lBoundRelativeViewEngine getMeasureFromAnchorType:lBoundAnchor.anchorVal.anchorType withContext:context] + lBoundAnchor.offsetVal;
        if (lBoundRelativeView != nil && lBoundRelativeView != self && [lBoundRelativeViewEngine.currentSizeClass invalid]) {
            minTop -= lBoundAnchor.offsetVal;
        }
        if (_myCGFloatLess(subviewEngine.top, minTop)) {
            subviewEngine.top = minTop;
            subviewEngine.height = subviewEngine.bottom - subviewEngine.top;
        }

    } else if (uBoundAnchor.anchorVal != nil) {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat maxBottom = [self mySubviewEngine:uBoundRelativeViewEngine getMeasureFromAnchorType:uBoundAnchor.anchorVal.anchorType withContext:context] - uBoundAnchor.offsetVal;
        if (uBoundRelativeView != nil && uBoundRelativeView != self && [uBoundRelativeViewEngine.currentSizeClass invalid]) {
            maxBottom += uBoundAnchor.offsetVal;
        }
        if (_myCGFloatGreat(subviewEngine.bottom, maxBottom)) {
            subviewEngine.bottom = maxBottom;
            subviewEngine.height = subviewEngine.bottom - subviewEngine.top;
        }
    }
}

- (CGFloat)mySubviewEngine:(MyLayoutEngine *)subviewEngine getMeasureFromAnchorType:(MyLayoutAnchorType)anchorType withContext:(MyLayoutContext *)context{
    
    UIView *relativeView = subviewEngine.currentSizeClass.view;

    switch (anchorType) {
        case MyLayoutAnchorType_Leading: {
            if (relativeView == self || relativeView == nil) {
                return context->paddingLeading;
            }
            if (subviewEngine.leading != CGFLOAT_MAX) {
                return subviewEngine.leading;
            }
            [self mySubviewEngine:subviewEngine calcLeadingTrailingWithContext:context];

            return subviewEngine.leading;
        } break;
        case MyLayoutAnchorType_Trailing: {
            if (relativeView == self || relativeView == nil) {
                return context->selfSize.width - context->paddingTrailing;
            }
            if (subviewEngine.trailing != CGFLOAT_MAX) {
                return subviewEngine.trailing;
            }
            [self mySubviewEngine:subviewEngine calcLeadingTrailingWithContext:context];

            return subviewEngine.trailing;
        } break;
        case MyLayoutAnchorType_Top: {
            if (relativeView == self || relativeView == nil) {
                return context->paddingTop;
            }
            if (subviewEngine.top != CGFLOAT_MAX) {
                return subviewEngine.top;
            }
            [self mySubviewEngine:subviewEngine calcTopBottomWithContext:context];

            return subviewEngine.top;

        } break;
        case MyLayoutAnchorType_Bottom: {
            if (relativeView == self || relativeView == nil) {
                return context->selfSize.height - context->paddingBottom;
            }
            if (subviewEngine.bottom != CGFLOAT_MAX) {
                return subviewEngine.bottom;
            }
            [self mySubviewEngine:subviewEngine calcTopBottomWithContext:context];

            return subviewEngine.bottom;
        } break;
        case MyLayoutAnchorType_Baseline: {
            if (relativeView == self || relativeView == nil) {
                return context->paddingTop;
            }
            UIFont *subviewFont = [self myGetSubviewFont:relativeView];
            if (subviewFont != nil) {
                if (subviewEngine.top == CGFLOAT_MAX || subviewEngine.height == CGFLOAT_MAX) {
                    [self mySubviewEngine:subviewEngine calcTopBottomWithContext:context];
                }
                //得到基线的位置。
                return subviewEngine.top + (subviewEngine.height - subviewFont.lineHeight) / 2.0 + subviewFont.ascender;
            } else {
                if (subviewEngine.top != CGFLOAT_MAX) {
                    return subviewEngine.top;
                }
                [self mySubviewEngine:subviewEngine calcTopBottomWithContext:context];

                return subviewEngine.top;
            }
        } break;
        case MyLayoutAnchorType_Width: {
            if (relativeView == self || relativeView == nil) {
                return context->selfSize.width - context->paddingLeading - context->paddingTrailing;
            }
            if (subviewEngine.width != CGFLOAT_MAX) {
                return subviewEngine.width;
            }
            [self mySubviewEngine:subviewEngine calcLeadingTrailingWithContext:context];
            return subviewEngine.width;
        } break;
        case MyLayoutAnchorType_Height: {
            if (relativeView == self || relativeView == nil) {
                return context->selfSize.height - context->paddingTop - context->paddingBottom;
            }
            if (subviewEngine.height != CGFLOAT_MAX) {
                return subviewEngine.height;
            }
            [self mySubviewEngine:subviewEngine calcTopBottomWithContext:context];

            return subviewEngine.height;
        } break;
        case MyLayoutAnchorType_CenterX: {
            if (relativeView == self || relativeView == nil) {
                return (context->selfSize.width - context->paddingLeading - context->paddingTrailing) / 2 + context->paddingLeading;
            }
            if (subviewEngine.leading != CGFLOAT_MAX && subviewEngine.trailing != CGFLOAT_MAX && subviewEngine.width != CGFLOAT_MAX) {
                return subviewEngine.leading + subviewEngine.width / 2;
            }
            [self mySubviewEngine:subviewEngine calcLeadingTrailingWithContext:context];
            return subviewEngine.leading + subviewEngine.width / 2;

        } break;

        case MyLayoutAnchorType_CenterY: {
            if (relativeView == self || relativeView == nil) {
                return (context->selfSize.height - context->paddingTop - context->paddingBottom) / 2 + context->paddingTop;
            }
            if (subviewEngine.top != CGFLOAT_MAX && subviewEngine.bottom != CGFLOAT_MAX && subviewEngine.height != CGFLOAT_MAX) {
                return subviewEngine.top + subviewEngine.height / 2;
            }
            [self mySubviewEngine:subviewEngine calcTopBottomWithContext:context];
            return subviewEngine.top + subviewEngine.height / 2;
        } break;
        default:
            break;
    }

    return 0;
}

- (BOOL)mySubviewEngine:(MyLayoutEngine *)subviewEngine calcWidthWithContext:(MyLayoutContext *)context {
    
    MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    BOOL hasMargin = NO;

    if (subviewEngine.width == CGFLOAT_MAX) {
        if (subviewTraits.widthSizeInner.arrayVal != nil) {
            NSArray *anchorArray = subviewTraits.widthSizeInner.arrayVal;

            BOOL invalid = [subviewTraits invalid];
            CGFloat totalMultiple = invalid ? 0.0 : subviewTraits.widthSizeInner.multiVal;
            CGFloat totalIncrement = invalid ? 0.0 : subviewTraits.widthSizeInner.addVal;
            for (MyLayoutSize *anchor in anchorArray) {
                if (anchor.isActive) {
                    MyLayoutEngine *relativeViewEngine = anchor.view.myEngine;
                    invalid = [relativeViewEngine.currentSizeClass invalid];
                    if (!invalid) {
                        if (anchor.val != nil) {
                            [self mySubviewEngine:relativeViewEngine calcWidthWithContext:context];

                            totalIncrement += -1 * relativeViewEngine.width;
                        } else {
                            totalMultiple += anchor.multiVal;
                        }
                        totalIncrement += anchor.addVal;
                    }
                }
            }

            CGFloat spareWidth = context->selfSize.width - context->paddingLeading - context->paddingTrailing + totalIncrement;
            if (_myCGFloatLessOrEqual(spareWidth, 0.0)) {
                spareWidth = 0.0;
            }
            if (totalMultiple != 0.0) {
                CGFloat tempWidth = _myCGFloatRound(spareWidth * (subviewTraits.widthSizeInner.multiVal / totalMultiple));
                subviewEngine.width = tempWidth;

                if ([subviewTraits invalid]) {
                    subviewEngine.width = 0.0;
                } else {
                    spareWidth -= tempWidth;
                    totalMultiple -= subviewTraits.widthSizeInner.multiVal;
                }

                for (MyLayoutSize *anchor in anchorArray) {
                    MyLayoutEngine *relativeViewEngine = anchor.view.myEngine;
                    if (anchor.isActive && ![relativeViewEngine.currentSizeClass invalid]) {
                        if (anchor.val == nil) {
                            tempWidth = _myCGFloatRound(spareWidth * (anchor.multiVal / totalMultiple));
                            spareWidth -= tempWidth;
                            totalMultiple -= anchor.multiVal;
                            relativeViewEngine.width = tempWidth;
                        }
                        relativeViewEngine.width = [self myValidMeasure:anchor subview:anchor.view calcSize:relativeViewEngine.width subviewSize:relativeViewEngine.size selfLayoutSize:context->selfSize];
                    } else {
                        relativeViewEngine.width = 0.0;
                    }
                }
            }
        } else if (subviewTraits.widthSizeInner.anchorVal != nil) {
            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:[self mySubviewEngine:subviewTraits.widthSizeInner.anchorVal.view.myEngine getMeasureFromAnchorType:subviewTraits.widthSizeInner.anchorVal.anchorType withContext:context]];
        } else if (subviewTraits.widthSizeInner.numberVal != nil) {
            subviewEngine.width = subviewTraits.widthSizeInner.measure;
        } else if (subviewTraits.widthSizeInner.fillVal) {
            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:context->selfSize.width - context->paddingLeading - context->paddingTrailing];
        } else if (subviewTraits.widthSizeInner.wrapVal) {
            //对于非布局视图进行宽度自适应计算。
            if (![subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                subviewEngine.width = [subviewTraits.widthSizeInner measureWith:[subviewTraits.view sizeThatFits:CGSizeZero].width];
            } else if (context->isEstimate) {
                MyBaseLayout *sublayout = (MyBaseLayout*)subviewTraits.view;
                subviewEngine.width = [sublayout sizeThatFits:subviewEngine.size inSizeClass:context->sizeClass].width;
                subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.width];
            }
        }

        if (subviewEngine.width == CGFLOAT_MAX) {
            subviewEngine.width = CGRectGetWidth(subviewTraits.view.bounds);
        }

        if (subviewTraits.leadingPosInner.val != nil && subviewTraits.trailingPosInner.val != nil) {
            if (subviewTraits.leadingPosInner.anchorVal != nil) {
                UIView *relaView = subviewTraits.leadingPosInner.anchorVal.view;
                MyLayoutEngine *relativeViewEngine = relaView.myEngine;
                subviewEngine.leading = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.leadingPosInner.anchorVal.anchorType withContext:context] + subviewTraits.leadingPosInner.measure;
                if (relaView != nil && relaView != self && [relativeViewEngine.currentSizeClass invalid]) {
                    subviewEngine.leading -= subviewTraits.leadingPosInner.measure;
                }
            } else if (subviewTraits.leadingPosInner.mostVal != nil) {
                subviewEngine.leading = subviewTraits.leadingPosInner.mostVal.doubleValue + subviewTraits.leadingPosInner.measure;
            } else {
                subviewEngine.leading = subviewTraits.leadingPosInner.measure + context->paddingLeading;
            }

            if (subviewTraits.trailingPosInner.anchorVal != nil) {
                UIView *relativeView = subviewTraits.trailingPosInner.anchorVal.view;
                MyLayoutEngine *relativeViewEngine = relativeView.myEngine;
                subviewEngine.trailing = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.trailingPosInner.anchorVal.anchorType withContext:context] - subviewTraits.trailingPosInner.measure;
                if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
                    subviewEngine.trailing += subviewTraits.trailingPosInner.measure;
                }
            } else if (subviewTraits.trailingPosInner.mostVal != nil) {
                subviewEngine.trailing = subviewTraits.trailingPosInner.mostVal.doubleValue - subviewTraits.trailingPosInner.measure;
            } else {
                subviewEngine.trailing = context->selfSize.width - subviewTraits.trailingPosInner.measure - context->paddingTrailing;
            }

            //只有在没有设置宽度时才计算宽度。
            if (subviewTraits.widthSizeInner.val == nil) {
                subviewEngine.width = subviewEngine.trailing - subviewEngine.leading;
            } else {
                subviewEngine.trailing = subviewEngine.leading + subviewEngine.width + subviewTraits.trailingPosInner.measure;
            }
            hasMargin = YES;
        }

        //计算有最大和最小约束的情况。
        if (subviewTraits.widthSizeInner.uBoundValInner.anchorVal != nil && subviewTraits.widthSizeInner.uBoundValInner.anchorVal.view != self) {
            [self mySubviewEngine:subviewTraits.widthSizeInner.uBoundValInner.anchorVal.view.myEngine calcWidthWithContext:context];
        }

        if (subviewTraits.widthSizeInner.lBoundValInner.anchorVal != nil && subviewTraits.widthSizeInner.lBoundValInner.anchorVal.view != self) {
            [self mySubviewEngine:subviewTraits.widthSizeInner.lBoundValInner.anchorVal.view.myEngine calcWidthWithContext:context];
        }

        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

        if ([subviewTraits invalid]) {
            subviewEngine.width = 0.0;
            subviewEngine.trailing = subviewEngine.leading + subviewEngine.width;
        }
    }

    return hasMargin;
}

- (BOOL)mySubviewEngine:(MyLayoutEngine *)subviewEngine calcHeightWithContext:(MyLayoutContext *)context{
    
    MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    BOOL hasMargin = NO;

    if (subviewEngine.height == CGFLOAT_MAX) {
        if (subviewTraits.heightSizeInner.arrayVal != nil) {
            NSArray *anchorArray = subviewTraits.heightSizeInner.arrayVal;

            BOOL invalid = [subviewTraits invalid];

            CGFloat totalMultiple = invalid ? 0.0 : subviewTraits.heightSizeInner.multiVal;
            CGFloat totalIncrement = invalid ? 0.0 : subviewTraits.heightSizeInner.addVal;
            for (MyLayoutSize *anchor in anchorArray) {
                if (anchor.isActive) {
                    MyLayoutEngine *relativeViewEngine = anchor.view.myEngine;
                    invalid = [relativeViewEngine.currentSizeClass invalid];
                    if (!invalid) {
                        if (anchor.val != nil) {
                            [self mySubviewEngine:relativeViewEngine calcHeightWithContext:context];

                            totalIncrement += -1 * relativeViewEngine.height;
                        } else {
                            totalMultiple += anchor.multiVal;
                        }
                        totalIncrement += anchor.addVal;
                    }
                }
            }

            CGFloat spareHeight = context->selfSize.height - context->paddingTop - context->paddingBottom + totalIncrement;
            if (_myCGFloatLessOrEqual(spareHeight, 0.0)) {
                spareHeight = 0.0;
            }
            if (totalMultiple != 0.0) {
                CGFloat tempHeight = _myCGFloatRound(spareHeight * (subviewTraits.heightSizeInner.multiVal / totalMultiple));
                subviewEngine.height = tempHeight;
                if ([subviewTraits invalid]) {
                    subviewEngine.height = 0.0;
                } else {
                    spareHeight -= tempHeight;
                    totalMultiple -= subviewTraits.heightSizeInner.multiVal;
                }

                for (MyLayoutSize *anchor in anchorArray) {
                    MyLayoutEngine *relativeViewEngine = anchor.view.myEngine;
                    if (anchor.isActive && ![relativeViewEngine.currentSizeClass invalid]) {
                        if (anchor.val == nil) {
                            tempHeight = _myCGFloatRound(spareHeight * (anchor.multiVal / totalMultiple));
                            spareHeight -= tempHeight;
                            totalMultiple -= anchor.multiVal;
                            relativeViewEngine.height = tempHeight;
                        }
                        relativeViewEngine.height = [self myValidMeasure:anchor subview :anchor.view calcSize:relativeViewEngine.height subviewSize:relativeViewEngine.size selfLayoutSize:context->selfSize];
                    } else {
                        relativeViewEngine.height = 0.0;
                    }
                }
            }
        } else if (subviewTraits.heightSizeInner.anchorVal != nil) {
            subviewEngine.height = [subviewTraits.heightSizeInner measureWith:[self mySubviewEngine:subviewTraits.heightSizeInner.anchorVal.view.myEngine getMeasureFromAnchorType:subviewTraits.heightSizeInner.anchorVal.anchorType withContext:context]];
        } else if (subviewTraits.heightSizeInner.numberVal != nil) {
            subviewEngine.height = subviewTraits.heightSizeInner.measure;
        } else if (subviewTraits.heightSizeInner.fillVal) {
            subviewEngine.height = [subviewTraits.heightSizeInner measureWith:context->selfSize.height - context->paddingTop - context->paddingBottom];
        } else if (subviewTraits.heightSizeInner.wrapVal) {
                if (subviewEngine.width == CGFLOAT_MAX) {
                    [self mySubviewEngine:subviewEngine calcWidthWithContext:context];
                }
            subviewEngine.height = [self mySubview:subviewTraits wrapHeightSizeFits:subviewEngine.size withContext:context];
        }

        if (subviewEngine.height == CGFLOAT_MAX) {
            subviewEngine.height = CGRectGetHeight(subviewTraits.view.bounds);
        }
        if (subviewTraits.topPosInner.val != nil && subviewTraits.bottomPosInner.val != nil) {
            if (subviewTraits.topPosInner.anchorVal != nil) {
                UIView *relativeView = subviewTraits.topPosInner.anchorVal.view;
                MyLayoutEngine *relativeViewEngine = relativeView.myEngine;
                subviewEngine.top = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.topPosInner.anchorVal.anchorType withContext:context] + subviewTraits.topPosInner.measure;
                if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
                    subviewEngine.top -= subviewTraits.topPosInner.measure;
                }
            } else if (subviewTraits.topPosInner.mostVal != nil) {
                subviewEngine.top = subviewTraits.topPosInner.mostVal.doubleValue + subviewTraits.topPosInner.measure;
            } else {
                subviewEngine.top = subviewTraits.topPosInner.measure + context->paddingTop;
            }

            if (subviewTraits.bottomPosInner.anchorVal != nil) {
                UIView *relativeView = subviewTraits.bottomPosInner.anchorVal.view;
                MyLayoutEngine *relativeViewEngine = relativeView.myEngine;
                subviewEngine.bottom = [self mySubviewEngine:relativeViewEngine getMeasureFromAnchorType:subviewTraits.bottomPosInner.anchorVal.anchorType withContext:context] - subviewTraits.bottomPosInner.measure;
                if (relativeView != nil && relativeView != self && [relativeViewEngine.currentSizeClass invalid]) {
                    subviewEngine.bottom += subviewTraits.bottomPosInner.measure;
                }
            } else if (subviewTraits.bottomPosInner.mostVal != nil) {
                subviewEngine.bottom = subviewTraits.bottomPosInner.mostVal.doubleValue - subviewTraits.bottomPosInner.measure;
            } else {
                subviewEngine.bottom = context->selfSize.height - subviewTraits.bottomPosInner.measure - context->paddingBottom;
            }

            //只有在没有设置高度时才计算高度。
            if (subviewTraits.heightSizeInner.val == nil) {
                subviewEngine.height = subviewEngine.bottom - subviewEngine.top;
            } else {
                subviewEngine.bottom = subviewEngine.top + subviewEngine.height + subviewTraits.bottomPosInner.measure;
            }
            hasMargin = YES;
        }

        if (subviewTraits.heightSizeInner.uBoundValInner.anchorVal != nil && subviewTraits.heightSizeInner.uBoundValInner.anchorVal.view != self) {
            [self mySubviewEngine:subviewTraits.heightSizeInner.uBoundValInner.anchorVal.view.myEngine calcHeightWithContext:context];
        }

        if (subviewTraits.heightSizeInner.lBoundValInner.anchorVal != nil && subviewTraits.heightSizeInner.lBoundValInner.anchorVal.view != self) {
            [self mySubviewEngine:subviewTraits.heightSizeInner.lBoundValInner.anchorVal.view.myEngine calcHeightWithContext:context];
        }
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        if ([subviewTraits invalid]) {
            subviewEngine.height = 0.0;
            subviewEngine.bottom = subviewEngine.top + subviewEngine.height;
        }
    }
    return hasMargin;
}

- (CGSize)myDoLayoutRecalcWidth:(BOOL *)pRecalcWidth recalcHeight:(BOOL *)pRecalcHeight withContext:(MyLayoutContext *)context {
    MyRelativeLayoutTraits *layoutTraits = (MyRelativeLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    
    if (pRecalcWidth != NULL) {
        *pRecalcWidth = NO;
    }
    if (pRecalcHeight != NULL) {
        *pRecalcHeight = NO;
    }
    //计算最大的宽度和高度
    CGFloat maxLayoutWidth = context->paddingLeading + context->paddingTrailing;
    CGFloat maxLayoutHeight = context->paddingTop + context->paddingBottom;
    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;

        [self mySubviewEngine:subviewEngine calcLeadingTrailingWithContext:context];
        [self mySubviewEngine:subviewEngine calcTopBottomWithContext:context];

        if ([subviewTraits invalid]) {
            continue;
        }
        if (layoutTraits.widthSizeInner.wrapVal && pRecalcWidth != NULL) {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了右边或者中间的值，或者宽度依赖父视图)
            if (subviewTraits.trailingPosInner.numberVal != nil ||
                subviewTraits.trailingPosInner.mostVal != nil ||
                subviewTraits.trailingPosInner.anchorVal.view == self ||
                subviewTraits.centerXPosInner.anchorVal.view == self ||
                subviewTraits.centerXPosInner.numberVal != nil ||
                subviewTraits.widthSizeInner.anchorVal.view == self ||
                subviewTraits.widthSizeInner.fillVal) {
                *pRecalcWidth = YES;
            }

            //宽度最小是任何一个子视图的左右偏移和外加内边距和。
            if (_myCGFloatLess(maxLayoutWidth, subviewTraits.leadingPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing)) {
                maxLayoutWidth = subviewTraits.leadingPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing;
            }

            if ((subviewTraits.widthSizeInner.anchorVal == nil || subviewTraits.widthSizeInner.anchorVal != layoutTraits.widthSizeInner) && !subviewTraits.widthSizeInner.fillVal) {
                if (subviewTraits.centerXPosInner.val != nil) {
                    if (_myCGFloatLess(maxLayoutWidth, subviewEngine.width + subviewTraits.leadingPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing)) {
                        maxLayoutWidth = subviewEngine.width + subviewTraits.leadingPosInner.measure + subviewTraits.trailingPosInner.measure + context->paddingLeading + context->paddingTrailing;
                    }
                } else if (subviewTraits.trailingPosInner.val != nil) { //如果只有右边约束，则可以认为宽度是反过来算的，所以这里是左边的绝对值加上左边的padding来计算最宽宽度。
                    if (_myCGFloatLess(maxLayoutWidth, fabs(subviewEngine.leading) + context->paddingLeading)) {
                        maxLayoutWidth = fabs(subviewEngine.leading) + context->paddingLeading;
                    }
                }

                if (_myCGFloatLess(maxLayoutWidth, fabs(subviewEngine.trailing) + context->paddingTrailing)) {
                    maxLayoutWidth = fabs(subviewEngine.trailing) + context->paddingTrailing;
                }
            }
        }

        if (layoutTraits.heightSizeInner.wrapVal && pRecalcHeight != NULL) {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了下边或者中间的值，或者高度依赖父视图)
            if (subviewTraits.bottomPosInner.numberVal != nil ||
                subviewTraits.bottomPosInner.mostVal != nil ||
                subviewTraits.bottomPosInner.anchorVal.view == self ||
                subviewTraits.centerYPosInner.anchorVal.view == self ||
                subviewTraits.centerYPosInner.numberVal != nil ||
                subviewTraits.heightSizeInner.anchorVal.view == self ||
                subviewTraits.heightSizeInner.fillVal) {
                *pRecalcHeight = YES;
            }

            //每个视图最小的高度，在计算时要进行比较。
            if (_myCGFloatLess(maxLayoutHeight, subviewTraits.topPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom)) {
                maxLayoutHeight = subviewTraits.topPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom;
            }

            //高度不依赖父视图
            if ((subviewTraits.heightSizeInner.anchorVal == nil || subviewTraits.heightSizeInner.anchorVal != layoutTraits.heightSizeInner) && !subviewTraits.heightSizeInner.fillVal) {
                if (subviewTraits.centerYPosInner.val != nil) {
                    if (_myCGFloatLess(maxLayoutHeight, subviewEngine.height + subviewTraits.topPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom)) {
                        maxLayoutHeight = subviewEngine.height + subviewTraits.topPosInner.measure + subviewTraits.bottomPosInner.measure + context->paddingTop + context->paddingBottom;
                    }
                } else if (subviewTraits.bottomPosInner.val != nil) { //如果只有底边约束，则可以认为高度是反过来算的，所以这里是上边的绝对值加上上边的padding来计算最高高度
                    if (_myCGFloatLess(maxLayoutHeight, fabs(subviewEngine.top) + context->paddingTop)) {
                        maxLayoutHeight = fabs(subviewEngine.top) + context->paddingTop;
                    }
                }
                if (_myCGFloatLess(maxLayoutHeight, fabs(subviewEngine.bottom) + context->paddingBottom)) {
                    maxLayoutHeight = fabs(subviewEngine.bottom) + context->paddingBottom;
                }
            }
        }
    }

    return CGSizeMake(maxLayoutWidth, maxLayoutHeight);
}

@end

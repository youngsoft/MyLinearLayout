//
//  MyFrameLayout.m
//  MyLayout
//
//  Created by oybq on 15/6/14.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyFrameLayout.h"
#import "MyLayoutInner.h"

@implementation MyFrameLayout

#pragma mark-- Override Methods

- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines context:(MyLayoutContext *)context {
    [super calcLayoutSize:size subviewEngines:subviewEngines context:context];

    MyFrameLayoutTraits *layoutTraits = (MyFrameLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    context->paddingTop = layoutTraits.myLayoutPaddingTop;
    context->paddingBottom = layoutTraits.myLayoutPaddingBottom;
    context->paddingLeading = layoutTraits.myLayoutPaddingLeading;
    context->paddingTrailing = layoutTraits.myLayoutPaddingTrailing;
    context->vertGravity = MYVERTGRAVITY(layoutTraits.gravity);
    context->horzGravity = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(layoutTraits.gravity)];
    if (context->subviewEngines == nil) {
        context->subviewEngines = [layoutTraits filterEngines:subviewEngines];
    }
 
    CGSize maxWrapSize = CGSizeMake(context->paddingLeading + context->paddingTrailing, context->paddingTop + context->paddingBottom);
    CGSize *pMaxWrapSize = &maxWrapSize;
    if (!layoutTraits.heightSizeInner.wrapVal && !layoutTraits.widthSizeInner.wrapVal) {
        pMaxWrapSize = NULL;
    }
    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        
        [self myAdjustSizeSettingOfSubviewEngine:subviewEngine withContext:context];
        //计算自己的位置和高宽
        [self myCalcRectOfSubviewEngine:subviewEngine pMaxWrapSize:pMaxWrapSize withContext:context];
    }
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:maxWrapSize.width subviewSize: context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:maxWrapSize.height subviewSize: context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    //如果布局视图具有包裹属性这里要调整那些依赖父视图宽度和高度的子视图的位置和尺寸。
    if ((layoutTraits.widthSizeInner.wrapVal && context->horzGravity != MyGravity_Horz_Fill) || (layoutTraits.heightSizeInner.wrapVal && context->vertGravity != MyGravity_Vert_Fill)) {
        for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
            MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;

            //只有子视图的尺寸或者位置依赖父视图的情况下才需要重新计算位置和尺寸。
            if ((subviewTraits.trailingPosInner.val != nil) ||
                (subviewTraits.bottomPosInner.val != nil) ||
                (subviewTraits.centerXPosInner.val != nil) ||
                (subviewTraits.centerYPosInner.val != nil) ||
                (subviewTraits.widthSizeInner.anchorVal.view == self) ||
                (subviewTraits.heightSizeInner.anchorVal.view == self) ||
                subviewTraits.widthSizeInner.fillVal ||
                subviewTraits.heightSizeInner.fillVal) {
                [self myCalcRectOfSubviewEngine:subviewEngine pMaxWrapSize:NULL withContext:context];
            }
        }
    }
    return [self myAdjustLayoutViewSizeWithContext:context];
}

- (id)createSizeClassInstance {
    return [MyFrameLayoutTraits new];
}

@end

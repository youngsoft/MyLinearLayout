//
//  MyFlowLayout.m
//  MyLayout
//
//  Created by oybq on 15/10/31.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyFlowLayout.h"
#import "MyLayoutInner.h"

@implementation MyFlowLayout

#pragma mark-- Public Methods

- (instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount {
    self = [self initWithFrame:frame];
    if (self != nil) {
        MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)self.myDefaultSizeClass;
        layoutTraits.orientation = orientation;
        layoutTraits.arrangedCount = arrangedCount;
    }
    return self;
}

- (instancetype)initWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount {
    return [self initWithFrame:CGRectZero orientation:orientation arrangedCount:arrangedCount];
}

+ (instancetype)flowLayoutWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount {
    MyFlowLayout *layout = [[[self class] alloc] initWithOrientation:orientation arrangedCount:arrangedCount];
    return layout;
}

- (void)setOrientation:(MyOrientation)orientation {
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.orientation != orientation) {
        layoutTraits.orientation = orientation;
        [self setNeedsLayout];
    }
}

- (MyOrientation)orientation {
    return self.myDefaultSizeClassInner.orientation;
}

- (void)setArrangedCount:(NSInteger)arrangedCount {
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.arrangedCount != arrangedCount) {
        layoutTraits.arrangedCount = arrangedCount;
        [self setNeedsLayout];
    }
}

- (NSInteger)arrangedCount {
    return self.myDefaultSizeClassInner.arrangedCount;
}

- (void)setPagedCount:(NSInteger)pagedCount {
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.pagedCount != pagedCount) {
        layoutTraits.pagedCount = pagedCount;
        [self setNeedsLayout];
    }
}

- (NSInteger)pagedCount {
    return self.myDefaultSizeClassInner.pagedCount;
}

- (void)setAutoArrange:(BOOL)autoArrange {
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.autoArrange != autoArrange) {
        layoutTraits.autoArrange = autoArrange;
        [self setNeedsLayout];
    }
}

- (BOOL)autoArrange {
    return self.myDefaultSizeClassInner.autoArrange;
}

- (void)setArrangedGravity:(MyGravity)arrangedGravity {
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.arrangedGravity != arrangedGravity) {
        layoutTraits.arrangedGravity = arrangedGravity;
        [self setNeedsLayout];
    }
}

- (MyGravity)arrangedGravity {
    return self.myDefaultSizeClassInner.arrangedGravity;
}

- (void)setIsFlex:(BOOL)isFlex {
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.isFlex != isFlex) {
        layoutTraits.isFlex = isFlex;
        if (isFlex) {
            layoutTraits.lastlineGravityPolicy = MyGravityPolicy_Always;
        } else {
            layoutTraits.lastlineGravityPolicy = MyGravityPolicy_No;
        }
        [self setNeedsLayout];
    }
}

- (BOOL)isFlex {
    return self.myDefaultSizeClassInner.isFlex;
}

- (void)setLastlineGravityPolicy:(MyGravityPolicy)lastlineGravityPolicy {
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.lastlineGravityPolicy != lastlineGravityPolicy) {
        layoutTraits.lastlineGravityPolicy = lastlineGravityPolicy;
        [self setNeedsLayout];
    }
}

- (MyGravityPolicy)lastlineGravityPolicy {
    return self.myDefaultSizeClassInner.lastlineGravityPolicy;
}

- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace {
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass {
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace centered:NO inSizeClass:sizeClass];
}

- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered {
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace centered:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered inSizeClass:(MySizeClass)sizeClass {
    MySequentLayoutTraits *layoutTraits = (MySequentLayoutTraits *)[self fetchLayoutSizeClass:sizeClass];
    if (subviewSize == 0) {
        layoutTraits.flexSpace = nil;
    } else {
        if (layoutTraits.flexSpace == nil) {
            layoutTraits.flexSpace = [MySequentLayoutFlexSpacing new];
        }
        layoutTraits.flexSpace.subviewSize = subviewSize;
        layoutTraits.flexSpace.minSpace = minSpace;
        layoutTraits.flexSpace.maxSpace = maxSpace;
        layoutTraits.flexSpace.centered = centered;
    }
    [self setNeedsLayout];
}

#pragma mark-- Override Methods

- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines context:(MyLayoutContext *)context {
    [super calcLayoutSize:size subviewEngines:subviewEngines context:context];
    
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    context->paddingTop = layoutTraits.myLayoutPaddingTop;
    context->paddingBottom = layoutTraits.myLayoutPaddingBottom;
    context->paddingLeading = layoutTraits.myLayoutPaddingLeading;
    context->paddingTrailing = layoutTraits.myLayoutPaddingTrailing;
    context->vertGravity = MYVERTGRAVITY(layoutTraits.gravity);
    context->horzGravity = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(layoutTraits.gravity)];
    context->vertSpace = layoutTraits.subviewVSpace;
    context->horzSpace = layoutTraits.subviewHSpace;
    if (context->subviewEngines == nil) {
        context->subviewEngines = [layoutTraits filterEngines:subviewEngines];
    }
    
    MyOrientation orientation = layoutTraits.orientation;
    MyGravity arrangedGravity = layoutTraits.arrangedGravity;
    [self myCalcSubviewsWrapContentSize:context
                      withCustomSetting:^(MyViewTraits *subviewTraits) {
        if (subviewTraits.widthSizeInner.wrapVal) {
            if (layoutTraits.pagedCount > 0 ||
                (orientation == MyOrientation_Vert && subviewTraits.weight != 0.0) ||
                MYHORZGRAVITY(arrangedGravity) == MyGravity_Horz_Fill ||
                MYHORZGRAVITY(arrangedGravity) == MyGravity_Horz_Stretch ||
                context->horzGravity == MyGravity_Horz_Fill) {
                if ([subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                    [subviewTraits.widthSizeInner _myEqualTo:nil];
                }
            }
        }
        
        if (subviewTraits.heightSizeInner.wrapVal) {
            if (layoutTraits.pagedCount > 0 ||
                (orientation == MyOrientation_Horz && subviewTraits.weight != 0.0) ||
                MYVERTGRAVITY(arrangedGravity) == MyGravity_Vert_Fill ||
                MYVERTGRAVITY(arrangedGravity) == MyGravity_Vert_Stretch ||
                context->vertGravity == MyGravity_Vert_Fill) {
                if ([subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                    [subviewTraits.heightSizeInner _myEqualTo:nil];
                }
            }
        }
    }];
    
    if (orientation == MyOrientation_Vert) {
        if (layoutTraits.arrangedCount == 0) {
            [self myDoVertOrientationContentLayoutWithContext:context];
        } else {
            [self myDoVertOrientationCountLayoutWithContext:context];
        }
    } else {
        if (layoutTraits.arrangedCount == 0) {
            [self myDoHorzOrientationContentLayoutWithContext:context];
        } else {
            [self myDoHorzOrientationCountLayoutWithContext:context];
        }
    }
    
    return [self myAdjustLayoutViewSizeWithContext:context];
}

- (id)createSizeClassInstance {
    return [MyFlowLayoutTraits new];
}

#pragma mark-- Private Methods

//计算垂直流式布局下每行的比重值。
- (void)myVertLayoutCalculateSinglelineWeight:(CGFloat)lineTotalWeight lineSpareWidth:(CGFloat)lineSpareWidth startItemIndex:(NSInteger)startItemIndex itemCount:(NSInteger)itemCount withContext:(MyLayoutContext *)context {
    if (itemCount == 0 || lineSpareWidth <= 0.0) {
        return;
    }
   
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    //按照flex规约，如果总的比重小于1则只会将剩余宽度的总比重部分来进行按比例拉伸。
    if (layoutTraits.isFlex && lineTotalWeight < 1.0) {
        lineSpareWidth *= lineTotalWeight;
    }
    
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + itemCount; itemIndex++) {
        MyLayoutEngine *subviewEngine = subviewEngines[itemIndex];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        if (subviewTraits.weight != 0) {
            CGFloat weightWidth = _myCGFloatRound((lineSpareWidth * subviewTraits.weight / lineTotalWeight));
            if (subviewTraits.widthSizeInner != nil && subviewTraits.widthSizeInner.val == nil) {
                weightWidth = [subviewTraits.widthSizeInner measureWith:weightWidth];
            }
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:weightWidth + subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
    }
}

//计算水平流式布局下每行的比重值。
- (void)myHorzLayoutCalculateSinglelineWeight:(CGFloat)lineTotalWeight lineSpareHeight:(CGFloat)lineSpareHeight startItemIndex:(NSInteger)startItemIndex itemCount:(NSInteger)itemCount withContext:(MyLayoutContext *)context {
    if (itemCount == 0 || lineSpareHeight <= 0.0) {
        return;
    }
   
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    if (layoutTraits.isFlex && lineTotalWeight < 1.0) {
        lineSpareHeight *= lineTotalWeight;
    }
    
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + itemCount; itemIndex++) {
        MyLayoutEngine *subviewEngine = subviewEngines[itemIndex];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        if (subviewTraits.weight != 0) {
            CGFloat weightHeight = _myCGFloatRound((lineSpareHeight * subviewTraits.weight / lineTotalWeight));
            if (subviewTraits.heightSizeInner != nil && subviewTraits.heightSizeInner.val == nil) {
                weightHeight = [subviewTraits.heightSizeInner measureWith:weightHeight];
            }
            subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:weightHeight + subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) {
                subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:[subviewTraits.widthSizeInner measureWith:subviewEngine.height] subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            }
        }
    }
}

//调整内容约束垂直流式布局的每行的宽度
- (void)myVertLayoutAdjustSingleline:(NSInteger)lineIndex lineSpareWidth:(CGFloat)lineSpareWidth lineTotalWeight:(CGFloat)lineTotalWeight startItemIndex:(NSInteger)startItemIndex itemCount:(NSInteger)itemCount withContext:(MyLayoutContext *)context {
    if (itemCount == 0 || lineSpareWidth <= 0.0) {
        return;
    }
   
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    MyGravity lineHorzGravity = context->horzGravity;
    if (self.lineGravity != nil) {
        lineHorzGravity = self.lineGravity(self, lineIndex, itemCount, (startItemIndex + itemCount) == subviewEngines.count) & MyGravity_Vert_Mask;
        if (lineHorzGravity == MyGravity_None) {
            lineHorzGravity = context->horzGravity;
        }
    }
    
    //只有最后一行，并且数量小于arrangedCount，并且不是第一行才应用策略。
    BOOL applyLastlineGravityPolicy = ((startItemIndex + itemCount) == subviewEngines.count &&
                                       itemCount != layoutTraits.arrangedCount &&
                                       lineHorzGravity == MyGravity_Horz_Fill);
    CGFloat incWidth = 0.0;
    if (lineHorzGravity == MyGravity_Horz_Fill && lineTotalWeight == 0.0) {
        if (!applyLastlineGravityPolicy || layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Always) {
            incWidth = lineSpareWidth / itemCount;
        }
    } else {
        //flex规则：当总的比重小于1时，剩余的宽度要乘以这个比重值再进行分配。
        if (layoutTraits.isFlex && lineTotalWeight < 1.0) {
            lineSpareWidth *= lineTotalWeight;
        }
    }
    
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + itemCount; itemIndex++) {
        MyLayoutEngine *subviewEngine = subviewEngines[itemIndex];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        if (subviewTraits.weight != 0.0 && lineTotalWeight != 0.0) {
            CGFloat weightWidth = _myCGFloatRound((lineSpareWidth * subviewTraits.weight / lineTotalWeight));
            if (subviewTraits.widthSizeInner != nil && subviewTraits.widthSizeInner.val == nil) {
                weightWidth = [subviewTraits.widthSizeInner measureWith:weightWidth];
            }
            subviewEngine.width += weightWidth;
        }
        //添加拉伸的尺寸。
        if (incWidth != 0.0) {
            subviewEngine.width += incWidth;
        }
    }
}

//调整内容约束水平流式布局的每行的高度
- (void)myHorzLayoutAdjustSingleline:(NSInteger)lineIndex lineSpareHeight:(CGFloat)lineSpareHeight lineTotalWeight:(CGFloat)lineTotalWeight startItemIndex:(NSInteger)startItemIndex itemCount:(NSInteger)itemCount withContext:(MyLayoutContext*)context {
    if (itemCount == 0 || lineSpareHeight <= 0.0) {
        return;
    }
   
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    MyGravity lineVertGravity = context->vertGravity;
    if (self.lineGravity != nil) {
        lineVertGravity = self.lineGravity(self, lineIndex, itemCount, (startItemIndex + itemCount) == subviewEngines.count) & MyGravity_Horz_Mask;
        if (lineVertGravity == MyGravity_None) {
            lineVertGravity = context->vertGravity;
        }
    }
    
    //只有最后一行，并且数量小于arrangedCount，并且不是第一行才应用策略。
    BOOL applyLastlineGravityPolicy = ((startItemIndex + itemCount) == subviewEngines.count &&
                                       itemCount != layoutTraits.arrangedCount &&
                                       lineVertGravity == MyGravity_Vert_Fill);
    CGFloat incHeight = 0.0;
    if (lineVertGravity == MyGravity_Vert_Fill && lineTotalWeight == 0.0) {
        if (!applyLastlineGravityPolicy || layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Always) {
            incHeight = lineSpareHeight / itemCount;
        }
    } else {
        //flex规则：当总的比重小于1时，剩余的高度要乘以这个比重值再进行分配。
        if (layoutTraits.isFlex && lineTotalWeight < 1.0) {
            lineSpareHeight *= lineTotalWeight;
        }
    }
    
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + itemCount; itemIndex++) {
        MyLayoutEngine *subviewEngine = subviewEngines[itemIndex];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        if (subviewTraits.weight != 0.0 && lineTotalWeight != 0.0) {
            CGFloat weightHeight = _myCGFloatRound((lineSpareHeight * subviewTraits.weight / lineTotalWeight));
            if (subviewTraits.heightSizeInner != nil && subviewTraits.heightSizeInner.val == nil) {
                weightHeight = [subviewTraits.heightSizeInner measureWith:weightHeight];
            }
            subviewEngine.height += weightHeight;
        }
        //添加拉伸的尺寸。
        if (incHeight != 0.0) {
            subviewEngine.height += incHeight;
        }
    }
}

- (void)myVertLayoutCalculateSinglelineShrink:(CGFloat)lineTotalShrink lineSpareWidth:(CGFloat)lineSpareWidth startItemIndex:(NSInteger)startItemIndex itemCount:(NSInteger)itemCount withContext:(MyLayoutContext*)context {
    if (_myCGFloatGreatOrEqual(lineSpareWidth, 0.0)) {
        lineTotalShrink = 0.0;
    }
    if (itemCount == 0 || lineTotalShrink == 0.0) {
        return;
    }
    
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    //根据flex规约：如果总的压缩比重小于1则超出部分会乘以这个压缩比再进行压缩。
    if (layoutTraits.isFlex && lineTotalShrink < 1.0) {
        lineSpareWidth *= lineTotalShrink;
    }
    //如果有压缩则调整子视图的宽度。
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + itemCount; itemIndex++) {
        MyLayoutEngine *subviewEngine = subviewEngines[itemIndex];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        if (subviewTraits.widthSizeInner.shrink != 0.0) {
            subviewEngine.width += (subviewTraits.widthSizeInner.shrink / lineTotalShrink) * lineSpareWidth;
            if (subviewEngine.width < 0.0) {
                subviewEngine.width = 0.0;
            }
        }
    }
}

- (void)myHorzLayoutCalculateSinglelineShrink:(CGFloat)lineTotalShrink lineSpareHeight:(CGFloat)lineSpareHeight startItemIndex:(NSInteger)startItemIndex itemCount:(NSInteger)itemCount withContext:(MyLayoutContext *)context {
    if (_myCGFloatGreatOrEqual(lineSpareHeight, 0.0)) {
        lineTotalShrink = 0.0;
    }
    if (itemCount == 0 || lineTotalShrink == 0.0) {
        return;
    }
    
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    //根据flex规约：如果总的压缩比重小于1则超出部分会乘以这个压缩比再进行压缩。
    if (layoutTraits.isFlex && lineTotalShrink < 1.0) {
        lineSpareHeight *= lineTotalShrink;
    }
    //如果有压缩则调整子视图的高度。
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + itemCount; itemIndex++) {
        MyLayoutEngine *subviewEngine = subviewEngines[itemIndex];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        if (subviewTraits.heightSizeInner.shrink != 0.0) {
            subviewEngine.height += (subviewTraits.heightSizeInner.shrink / lineTotalShrink) * lineSpareHeight;
            if (subviewEngine.height < 0.0) {
                subviewEngine.height = 0.0;
            }
        }
    }
}

- (void)myVertLayoutCalculateSingleline:(NSInteger)lineIndex vertAlignment:(MyGravity)vertAlignment lineMaxHeight:(CGFloat)lineMaxHeight lineMaxWidth:(CGFloat)lineMaxWidth lineTotalShrink:(CGFloat)lineTotalShrink startItemIndex:(NSInteger)startItemIndex itemCount:(NSInteger)itemCount withContext:(MyLayoutContext *)context {
    if (itemCount == 0) {
        return;
    }
    
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    CGFloat layoutContentWidth = context->selfSize.width - context->paddingLeading - context->paddingTrailing;
    CGFloat lineSpareWidth = layoutContentWidth - lineMaxWidth;
    if (_myCGFloatGreatOrEqual(lineSpareWidth, 0.0)) {
        lineTotalShrink = 0.0;
    }
    if (lineTotalShrink != 0.0) {
        lineMaxWidth = layoutContentWidth;
    }
    //计算每行的gravity情况。
    CGFloat addXPos = 0.0; //多出来的空隙区域，用于停靠处理。
    CGFloat addXPosInc = 0.0;
    
    MyGravity lineHorzGravity = context->horzGravity;
    MyGravity lineVertAlignment = vertAlignment;
    if (self.lineGravity != nil) {
        MyGravity lineGravity = self.lineGravity(self, lineIndex, itemCount, (startItemIndex + itemCount) == subviewEngines.count);
        lineHorzGravity = MYHORZGRAVITY(lineGravity);
        if (lineHorzGravity == MyGravity_None) {
            lineHorzGravity = context->horzGravity;
        } else {
            lineHorzGravity = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:lineHorzGravity];
        }
        lineVertAlignment = MYVERTGRAVITY(lineGravity);
        if (lineVertAlignment == MyGravity_None) {
            lineVertAlignment = vertAlignment;
        }
    }
    
    //只有最后一行，并且数量小于arrangedCount，并且不是第一行才应用策略。
    BOOL applyLastlineGravityPolicy = ((startItemIndex + itemCount) == subviewEngines.count &&
                                       itemCount != layoutTraits.arrangedCount &&
                                       (lineHorzGravity == MyGravity_Horz_Between || lineHorzGravity == MyGravity_Horz_Around || lineHorzGravity == MyGravity_Horz_Among));
    
    switch (lineHorzGravity) {
        case MyGravity_Horz_Center: {
            addXPos = (layoutContentWidth - lineMaxWidth) / 2.0;
        } break;
        case MyGravity_Horz_Trailing: {
            addXPos = layoutContentWidth - lineMaxWidth; //因为具有不考虑左边距，而原来的位置增加了左边距，因此
        } break;
        case MyGravity_Horz_Between: {
            if (itemCount > 1 && (!applyLastlineGravityPolicy || layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Always)) {
                addXPosInc = (layoutContentWidth - lineMaxWidth) / (itemCount - 1);
            }
        } break;
        case MyGravity_Horz_Around: {
            if (!applyLastlineGravityPolicy || layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Always) {
                if (itemCount > 1) {
                    addXPosInc = (layoutContentWidth - lineMaxWidth) / itemCount;
                    addXPos = addXPosInc / 2.0;
                } else {
                    addXPos = (layoutContentWidth - lineMaxWidth) / 2.0;
                }
            }
        } break;
        case MyGravity_Horz_Among: {
            if (!applyLastlineGravityPolicy || layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Always) {
                if (itemCount > 1) {
                    addXPosInc = (layoutContentWidth - lineMaxWidth) / (itemCount + 1);
                    addXPos = addXPosInc;
                } else {
                    addXPos = (layoutContentWidth - lineMaxWidth) / 2.0;
                }
            }
        } break;
        default:
            break;
    }
    
    //压缩减少的尺寸汇总。
    CGFloat totalShrinkSize = 0.0;
    //基线位置
    CGFloat baselinePos = CGFLOAT_MAX;
    //将整行的位置进行调整。
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + itemCount; itemIndex++) {
        MyLayoutEngine *subviewEngine = subviewEngines[itemIndex];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        if (!context->isEstimate && self.intelligentBorderline != nil) {
            if ([subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                MyBaseLayout *sublayout = (MyBaseLayout *)subviewTraits.view;
                if (!sublayout.notUseIntelligentBorderline) {
                    sublayout.leadingBorderline = nil;
                    sublayout.topBorderline = nil;
                    sublayout.trailingBorderline = nil;
                    sublayout.bottomBorderline = nil;
                    
                    //如果不是最后一行就画下面，
                    if ((startItemIndex + itemCount) != subviewEngines.count) {
                        sublayout.bottomBorderline = self.intelligentBorderline;
                    }
                    //如果不是最后一列就画右边,
                    if (itemIndex < (startItemIndex + itemCount) - 1) {
                        sublayout.trailingBorderline = self.intelligentBorderline;
                    }
                    //如果最后一行的最后一个没有满列数时
                    if (itemIndex == subviewEngines.count - 1 && layoutTraits.arrangedCount != itemCount) {
                        sublayout.trailingBorderline = self.intelligentBorderline;
                    }
                    //如果有垂直间距则不是第一行就画上
                    if (context->vertSpace != 0 && startItemIndex != 0) {
                        sublayout.topBorderline = self.intelligentBorderline;
                    }
                    //如果有水平间距则不是第一列就画左
                    if (context->horzSpace != 0 && itemIndex != startItemIndex) {
                        sublayout.leadingBorderline = self.intelligentBorderline;
                    }
                }
            }
        }
        
        MyGravity sbvVertAlignment = MYVERTGRAVITY(subviewTraits.alignment);
        if (sbvVertAlignment == MyGravity_None) {
            sbvVertAlignment = lineVertAlignment;
        }
        //因为单行内的垂直间距拉伸被赋予紧凑排列，所以这里的定制化将不起作用。
        if (vertAlignment == MyGravity_Vert_Between) {
            sbvVertAlignment = MyGravity_None;
        }
        UIFont *subviewFont = nil;
        if (sbvVertAlignment == MyGravity_Vert_Baseline) {
            subviewFont = [self myGetSubviewFont:subviewTraits.view];
            if (subviewFont == nil) {
                sbvVertAlignment = MyGravity_Vert_Top;
            }
        }
        
        if ((sbvVertAlignment != MyGravity_None && sbvVertAlignment != MyGravity_Vert_Top) || _myCGFloatNotEqual(addXPos, 0.0) || _myCGFloatNotEqual(addXPosInc, 0.0) || applyLastlineGravityPolicy || lineTotalShrink != 0.0) {
            subviewEngine.leading += addXPos;
            
            //处理对间距的压缩
            if (lineTotalShrink != 0.0) {
                if (subviewTraits.leadingPosInner.shrink != 0.0) {
                    totalShrinkSize += (subviewTraits.leadingPosInner.shrink / lineTotalShrink) * lineSpareWidth;
                }
                subviewEngine.leading += totalShrinkSize;
                
                if (subviewTraits.trailingPosInner.shrink != 0.0) {
                    totalShrinkSize += (subviewTraits.trailingPosInner.shrink / lineTotalShrink) * lineSpareWidth;
                }
            }
            
            subviewEngine.leading += addXPosInc * (itemIndex - startItemIndex);
            if (lineIndex != 0 && applyLastlineGravityPolicy && layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Auto) {
                //对齐前一行对应位置的
                subviewEngine.leading = subviewEngines[itemIndex - layoutTraits.arrangedCount].leading;
            }
            
            switch (sbvVertAlignment) {
                case MyGravity_Vert_Center: {
                    subviewEngine.top += (lineMaxHeight - subviewTraits.topPosInner.measure - subviewTraits.bottomPosInner.measure - subviewEngine.height) / 2;
                } break;
                case MyGravity_Vert_Bottom: {
                    subviewEngine.top += lineMaxHeight - subviewTraits.topPosInner.measure - subviewTraits.bottomPosInner.measure - subviewEngine.height;
                } break;
                case MyGravity_Vert_Fill: {
                    subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:lineMaxHeight - subviewTraits.topPosInner.measure - subviewTraits.bottomPosInner.measure subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                } break;
                case MyGravity_Vert_Stretch: {
                    if (subviewTraits.heightSizeInner.val == nil || (subviewTraits.heightSizeInner.wrapVal && ![subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:lineMaxHeight - subviewTraits.topPosInner.measure - subviewTraits.bottomPosInner.measure subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                    }
                } break;
                case MyGravity_Vert_Baseline: {
                    if (baselinePos == CGFLOAT_MAX) {
                        baselinePos = subviewEngine.top + (subviewEngine.height - subviewFont.lineHeight) / 2.0 + subviewFont.ascender;
                    } else {
                        subviewEngine.top = baselinePos - subviewFont.ascender - (subviewEngine.height - subviewFont.lineHeight) / 2;
                    }
                } break;
                default:
                    break;
            }
        }
    }
}

- (void)myHorzLayoutCalculateSingleline:(NSInteger)lineIndex horzAlignment:(MyGravity)horzAlignment lineMaxWidth:(CGFloat)lineMaxWidth lineMaxHeight:(CGFloat)lineMaxHeight lineTotalShrink:(CGFloat)lineTotalShrink startItemIndex:(NSInteger)startItemIndex itemCount:(NSInteger)itemCount withContext:(MyLayoutContext *)context {
    if (itemCount == 0) {
        return;
    }
    
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    CGFloat layoutContentHeight = context->selfSize.height - context->paddingTop - context->paddingBottom;
    CGFloat lineSpareHeight = layoutContentHeight - lineMaxHeight;
    if (_myCGFloatGreatOrEqual(lineSpareHeight, 0.0)) {
        lineTotalShrink = 0.0;
    }
    if (lineTotalShrink != 0.0) {
        lineMaxHeight = layoutContentHeight;
    }
    
    //计算每行的gravity情况。
    CGFloat addYPos = 0.0;
    CGFloat addYPosInc = 0.0;
    MyGravity lineHorzAlignment = horzAlignment;
    MyGravity lineVertGravity = context->vertGravity;
    if (self.lineGravity != nil) {
        MyGravity lineGravity = self.lineGravity(self, lineIndex, itemCount, (startItemIndex + itemCount) == subviewEngines.count);
        lineHorzAlignment = MYHORZGRAVITY(lineGravity);
        if (lineHorzAlignment == MyGravity_None) {
            lineHorzAlignment = horzAlignment;
        } else {
            lineHorzAlignment = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:lineHorzAlignment];
        }
        lineVertGravity = MYVERTGRAVITY(lineGravity);
        if (lineVertGravity == MyGravity_None) {
            lineVertGravity = context->vertGravity;
        }
    }
    
    //只有最后一行，并且数量小于arrangedCount才应用策略。
    BOOL applyLastlineGravityPolicy = ((startItemIndex + itemCount) == subviewEngines.count &&
                                       itemCount != layoutTraits.arrangedCount &&
                                       (lineVertGravity == MyGravity_Vert_Between || lineVertGravity == MyGravity_Vert_Around || lineVertGravity == MyGravity_Vert_Among));
    
    switch (lineVertGravity) {
        case MyGravity_Vert_Center: {
            addYPos = (layoutContentHeight - lineMaxHeight) / 2.0;
        } break;
        case MyGravity_Vert_Bottom: {
            addYPos = layoutContentHeight - lineMaxHeight;
        } break;
        case MyGravity_Vert_Between: {
            if (itemCount > 1 && (!applyLastlineGravityPolicy || layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Always)) {
                addYPosInc = (layoutContentHeight - lineMaxHeight) / (itemCount - 1);
            }
        } break;
        case MyGravity_Vert_Around: {
            if (!applyLastlineGravityPolicy || layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Always) {
                if (itemCount > 1) {
                    addYPosInc = (layoutContentHeight - lineMaxHeight) / itemCount;
                    addYPos = addYPosInc / 2.0;
                } else {
                    addYPos = (layoutContentHeight - lineMaxHeight) / 2.0;
                }
            }
        } break;
        case MyGravity_Vert_Among: {
            if (!applyLastlineGravityPolicy || layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Always) {
                if (itemCount > 1) {
                    addYPosInc = (layoutContentHeight - lineMaxHeight) / (itemCount + 1);
                    addYPos = addYPosInc;
                } else {
                    addYPos = (layoutContentHeight - lineMaxHeight) / 2.0;
                }
            }
        } break;
        default:
            break;
    }
    
    //压缩减少的尺寸汇总。
    CGFloat totalShrinkSize = 0.0;
    //将整行的位置进行调整。
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + itemCount; itemIndex++) {
        MyLayoutEngine *subviewEngine = subviewEngines[itemIndex];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        
        if (!context->isEstimate && self.intelligentBorderline != nil) {
            if ([subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                MyBaseLayout *sublayout = (MyBaseLayout *)subviewTraits.view;
                if (!sublayout.notUseIntelligentBorderline) {
                    sublayout.leadingBorderline = nil;
                    sublayout.topBorderline = nil;
                    sublayout.trailingBorderline = nil;
                    sublayout.bottomBorderline = nil;
                    
                    //如果不是最后一行就画下面，
                    if (itemIndex < (startItemIndex + itemCount) - 1) {
                        sublayout.bottomBorderline = self.intelligentBorderline;
                    }
                    //如果不是最后一列就画右边,
                    if ((startItemIndex + itemCount) != subviewEngines.count) {
                        sublayout.trailingBorderline = self.intelligentBorderline;
                    }
                    //如果最后一行的最后一个没有满列数时
                    if (itemIndex == subviewEngines.count - 1 && layoutTraits.arrangedCount != itemCount) {
                        sublayout.bottomBorderline = self.intelligentBorderline;
                    }
                    //如果有垂直间距则不是第一行就画上
                    if (context->vertSpace != 0 && itemIndex != startItemIndex) {
                        sublayout.topBorderline = self.intelligentBorderline;
                    }
                    //如果有水平间距则不是第一列就画左
                    if (context->horzSpace != 0 && startItemIndex != 0) {
                        sublayout.leadingBorderline = self.intelligentBorderline;
                    }
                }
            }
        }
        
        MyGravity subviewHorzAlignment = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(subviewTraits.alignment)];
        if (subviewHorzAlignment == MyGravity_None) {
            subviewHorzAlignment = lineHorzAlignment;
        }
        //因为单行内的水平间距拉伸被赋予紧凑排列，所以这里的定制化将不起作用。
        if (horzAlignment == MyGravity_Horz_Between) {
            subviewHorzAlignment = MyGravity_None;
        }
        if ((subviewHorzAlignment != MyGravity_None && subviewHorzAlignment != MyGravity_Horz_Leading) || _myCGFloatNotEqual(addYPos, 0.0) || _myCGFloatNotEqual(addYPosInc, 0.0) || applyLastlineGravityPolicy || lineTotalShrink != 0.0) {
            subviewEngine.top += addYPos;
            
            //处理对间距的压缩
            if (lineTotalShrink != 0.0) {
                if (subviewTraits.topPosInner.shrink != 0.0) {
                    totalShrinkSize += (subviewTraits.topPosInner.shrink / lineTotalShrink) * lineSpareHeight;
                }
                subviewEngine.top += totalShrinkSize;
                
                if (subviewTraits.bottomPosInner.shrink != 0.0) {
                    totalShrinkSize += (subviewTraits.bottomPosInner.shrink / lineTotalShrink) * lineSpareHeight;
                }
            }
            
            subviewEngine.top += addYPosInc * (itemIndex - startItemIndex);
            if (lineIndex != 0 && applyLastlineGravityPolicy && layoutTraits.lastlineGravityPolicy == MyGravityPolicy_Auto) {
                //对齐前一行对应位置的
                subviewEngine.top = subviewEngines[itemIndex - layoutTraits.arrangedCount].top;
            }
            
            switch (subviewHorzAlignment) {
                case MyGravity_Horz_Center: {
                    subviewEngine.leading += (lineMaxWidth - subviewTraits.leadingPosInner.measure - subviewTraits.trailingPosInner.measure - subviewEngine.width) / 2;
                } break;
                case MyGravity_Horz_Trailing: {
                    subviewEngine.leading += lineMaxWidth - subviewTraits.leadingPosInner.measure - subviewTraits.trailingPosInner.measure - subviewEngine.width;
                } break;
                case MyGravity_Horz_Fill: {
                    subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:lineMaxWidth - subviewTraits.leadingPosInner.measure - subviewTraits.trailingPosInner.measure subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                } break;
                case MyGravity_Horz_Stretch: {
                    if (subviewTraits.widthSizeInner.val == nil || (subviewTraits.widthSizeInner.wrapVal && ![subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:lineMaxWidth - subviewTraits.leadingPosInner.measure - subviewTraits.trailingPosInner.measure subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                    }
                } break;
                default:
                    break;
            }
        }
    }
}

- (CGFloat)myCalcSinglelineSize:(NSArray<MyLayoutEngine *> *)subviewEngines space:(CGFloat)space {
    CGFloat size = 0;
    for (MyLayoutEngine *subviewEngine in subviewEngines) {
        size += subviewEngine.trailing;
        if (subviewEngine != subviewEngines.lastObject) {
            size += space;
        }
    }
    return size;
}

- (NSArray *)myGetAutoArrangeSubviews:(NSMutableArray<MyLayoutEngine *> *)subviewEngines selfSize:(CGFloat)selfSize space:(CGFloat)space {
    
    NSMutableArray<MyLayoutEngine *> *retArray = [NSMutableArray arrayWithCapacity:subviewEngines.count];
    //保存每行最佳
    NSMutableArray<MyLayoutEngine *> *bestSinglelineArray = [NSMutableArray arrayWithCapacity:subviewEngines.count / 2];
    while (subviewEngines.count) {
        
        //得到每行进行自动排列时最佳的子视图集。
        [self myCalcAutoArrangeSinglelineSubviews:subviewEngines
                                            index:0
                                        calcArray:@[]
                                         selfSize:selfSize
                                            space:space
                              bestSinglelineArray:bestSinglelineArray];
        
        [retArray addObjectsFromArray:bestSinglelineArray];
        
        //将已经排列好的子视图从总的数组中删除。
        [bestSinglelineArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [subviewEngines removeObject:obj];
        }];
        
        [bestSinglelineArray removeAllObjects];
    }
    
    return retArray;
}

- (void)myCalcAutoArrangeSinglelineSubviews:(NSMutableArray<MyLayoutEngine *> *)subviewEngines
                                      index:(NSInteger)index
                                  calcArray:(NSArray<MyLayoutEngine *> *)calcArray
                                   selfSize:(CGFloat)selfSize
                                      space:(CGFloat)space
                        bestSinglelineArray:(NSMutableArray<MyLayoutEngine *> *)bestSinglelineArray {
    if (index >= subviewEngines.count) {
        CGFloat s1 = [self myCalcSinglelineSize:calcArray space:space];
        CGFloat s2 = [self myCalcSinglelineSize:bestSinglelineArray space:space];
        if (_myCGFloatLess(fabs(selfSize - s1), fabs(selfSize - s2)) && _myCGFloatLessOrEqual(s1, selfSize)) {
            [bestSinglelineArray setArray:calcArray];
        }
        return;
    }
    
    for (NSInteger i = index; i < subviewEngines.count; i++) {
        
        NSMutableArray<MyLayoutEngine *> *calcArray2 = [NSMutableArray arrayWithArray:calcArray];
        [calcArray2 addObject:subviewEngines[i]];
        
        CGFloat s1 = [self myCalcSinglelineSize:calcArray2 space:space];
        if (_myCGFloatLessOrEqual(s1, selfSize)) {
            CGFloat s2 = [self myCalcSinglelineSize:bestSinglelineArray space:space];
            if (_myCGFloatLess(fabs(selfSize - s1), fabs(selfSize - s2))) {
                [bestSinglelineArray setArray:calcArray2];
            }
            if (_myCGFloatEqual(s1, selfSize)) {
                break;
            }
            [self myCalcAutoArrangeSinglelineSubviews:subviewEngines
                                                index:i + 1
                                            calcArray:calcArray2
                                             selfSize:selfSize
                                                space:space
                                  bestSinglelineArray:bestSinglelineArray];
            
        } else {
            break;
        }
    }
}

- (void)myDoVertOrientationContentLayoutWithContext:(MyLayoutContext *)context {
    
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSMutableArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    MyGravity vertAlignment = MYVERTGRAVITY(layoutTraits.arrangedGravity);
    
    //支持浮动水平间距。
    CGFloat subviewWidth = [layoutTraits.flexSpace calcMaxMinSubviewSizeForContent:context->selfSize.width paddingStart:&context->paddingLeading paddingEnd:&context->paddingTrailing space:&context->horzSpace];
    
    CGFloat paddingHorz = context->paddingLeading + context->paddingTrailing;
    CGFloat paddingVert = context->paddingTop + context->paddingBottom;
    CGFloat xPos = context->paddingLeading;
    CGFloat yPos = context->paddingTop;
    CGFloat lineMaxHeight = 0.0; //某一行的最高值。
    CGFloat lineMaxWidth = 0.0;  //某一行的最宽值。
    CGFloat maxLayoutWidth = 0.0;      //所有行中最宽的值。
    
    //limitedSelfWidth是用来限制子视图换行的宽度，默认是selfSize.width
    //但是一种特殊情况就是布局视图宽度自适应，但是设置了最宽宽度的情况。
    //这种情况下当子视图超过最宽宽度时还是需要进行换行处理。
    //而如果没有设置最宽宽度的话那么默认限制的宽度就是最大值CGFLOAT_MAX
    CGFloat limitedSelfWidth = context->selfSize.width;
    if (layoutTraits.widthSizeInner.wrapVal) {
        limitedSelfWidth = [self myGetBoundLimitMeasure:layoutTraits.widthSizeInner.uBoundValInner subview:self anchorType:layoutTraits.widthSizeInner.anchorType subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size isUBound:YES];
        limitedSelfWidth = _myCGFloatMin(limitedSelfWidth, CGFLOAT_MAX);
    }
    
    if (layoutTraits.autoArrange) {
        //计算出每个子视图的宽度。
        for (MyLayoutEngine *subviewEngine in subviewEngines) {
            MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
            
#ifdef DEBUG
            //约束异常：垂直流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(subviewTraits.weight == 0, @"Constraint exception!! vertical flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES", self, subviewTraits.view);
#endif
            CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
            CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
            
            subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            
            //暂时把宽度存放sbv.myFrame.trailing上。因为流式布局来说这个属性无用。
            subviewEngine.trailing = leadingSpacing + subviewEngine.width + trailingSpacing;
            if (_myCGFloatGreat(subviewEngine.trailing, context->selfSize.width - paddingHorz)) {
                subviewEngine.trailing = context->selfSize.width - paddingHorz;
            }
        }
        
        [subviewEngines setArray:[self myGetAutoArrangeSubviews:subviewEngines selfSize:context->selfSize.width - paddingHorz space:context->horzSpace]];
    }
    
    //每行行首子视图的索引位置。
    NSMutableIndexSet *lineFirstSubviewIndexSet = [NSMutableIndexSet new];
    NSInteger lineIndex = 0; //行的索引。
    NSInteger itemIndex = 0; //行内子视图的索引
    CGFloat lineTotalWeight = 0.0;
    NSInteger i = 0;
    for (; i < subviewEngines.count; i++) {
        MyLayoutEngine *subviewEngine = subviewEngines[i];
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
        
        //这里先算一下那些有约束的高度，因为有可能有一些子视图的宽度等于这个子视图的高度。
        if (subviewTraits.heightSizeInner.val != nil) {
            subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
            subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
        
        //计算子视图的宽度。
        if (subviewWidth != 0.0) {
            subviewEngine.width = subviewWidth - leadingSpacing - trailingSpacing;
        } else if (subviewTraits.widthSizeInner.val != nil) {
            subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
            
            if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) { //特殊处理宽度等于高度的情况
                subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            }
        } else if (subviewTraits.weight != 0.0) {
            if (layoutTraits.isFlex) {
                subviewEngine.width = 0.0;
            } else {
                CGFloat lineSpareWidth = context->selfSize.width - context->paddingTrailing - xPos - leadingSpacing - trailingSpacing;
                if (itemIndex != 0) {
                    lineSpareWidth -= context->horzSpace;
                }
                if (_myCGFloatLessOrEqual(lineSpareWidth, 0.0)) {
                    //如果当前行的剩余空间不够，则需要换行来计算相对的宽度占比，这时候剩余空间就是按整行来算,并且将行索引设置为0
                    lineSpareWidth = context->selfSize.width - paddingHorz;
                }
                
                subviewEngine.width = (lineSpareWidth + subviewTraits.widthSizeInner.addVal) * subviewTraits.weight - leadingSpacing - trailingSpacing;
            }
        }
        
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        
        //特殊处理自身高度等于自身宽度的情况。
        if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况
            subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
            subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
        
        //计算xPos的值加上leadingSpacing + subviewEngine.width + trailingSpacing 的值要小于整体的宽度。
        CGFloat place = xPos + leadingSpacing + subviewEngine.width + trailingSpacing;
        if (itemIndex != 0) {
            place += context->horzSpace;
        }
        place += context->paddingTrailing;
        
        //sbv所占据的宽度超过了布局视图的限制宽度时需要换行。
        if (place - limitedSelfWidth > 0.0001) {
            context->selfSize.width = limitedSelfWidth;
            
            //保存行首子视图的索引
            [lineFirstSubviewIndexSet addIndex:i - itemIndex];
            
            //拉伸以及调整行内子视图的宽度。
            [self myVertLayoutAdjustSingleline:lineIndex lineSpareWidth:context->selfSize.width - context->paddingTrailing - xPos lineTotalWeight:lineTotalWeight  startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
            
            xPos = context->paddingLeading;
            
            //如果这个sbv的宽度大于整体布局视图的宽度。则将子视图的宽度缩小变为和布局视图一样宽
            if (_myCGFloatGreat(leadingSpacing + trailingSpacing + subviewEngine.width, context->selfSize.width - paddingHorz)) {
                subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:context->selfSize.width - paddingHorz - leadingSpacing - trailingSpacing subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            }
            
            lineTotalWeight = 0.0;
            lineIndex++;
            itemIndex = 0;
        }
        
        if (itemIndex != 0) {
            xPos += context->horzSpace;
        }
        subviewEngine.leading = xPos + leadingSpacing;
        xPos += leadingSpacing + subviewEngine.width + trailingSpacing;
        
        if (layoutTraits.isFlex && subviewTraits.weight != 0.0) {
            lineTotalWeight += subviewTraits.weight;
        }
        
        itemIndex++;
    }
    
    //最后一行的行首索引
    [lineFirstSubviewIndexSet addIndex:i - itemIndex];
    
    //在宽度为自适应时，如果没有设置最大宽度限制，那么就一定是单行，因此宽度就是子视图的总和。
    //如果设置了最大宽度限制时，那就要区分最后一行是单行还是多行，所以我们取限宽和当前计算出的宽度的最小值，并且再取selfSize.width和前面比较结果的最大值。
    if (layoutTraits.widthSizeInner.wrapVal) {
        if (limitedSelfWidth == CGFLOAT_MAX) {
            context->selfSize.width = _myCGFloatMax(xPos + context->paddingTrailing, [self myGetBoundLimitMeasure:layoutTraits.widthSizeInner.uBoundValInner subview:self anchorType:layoutTraits.widthSizeInner.anchorType subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size isUBound:NO]);
        } else {
            context->selfSize.width = _myCGFloatMax(_myCGFloatMin(xPos + context->paddingTrailing, limitedSelfWidth), context->selfSize.width);
        }
    }
    
    [self myVertLayoutAdjustSingleline:lineIndex lineSpareWidth:context->selfSize.width - context->paddingTrailing - xPos lineTotalWeight:lineTotalWeight startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
    
    xPos = context->paddingLeading;
    lineIndex = 0; //行的索引。
    itemIndex = 0; //行内的子视图索引
    NSInteger oldLineFirstIndex = 0;
    i = 0;
    for (; i < subviewEngines.count; i++) {
        MyLayoutEngine *subviewEngine = subviewEngines[i];
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        
        CGFloat topSpace = subviewTraits.topPosInner.measure;
        CGFloat leadingSpace = subviewTraits.leadingPosInner.measure;
        CGFloat bottomSpace = subviewTraits.bottomPosInner.measure;
        CGFloat trailingSpace = subviewTraits.trailingPosInner.measure;
        
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        
        //计算子视图的高度。
        if (subviewTraits.heightSizeInner.val != nil) {
            subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
        } else if (context->vertGravity == MyGravity_Vert_Fill || context->vertGravity == MyGravity_Vert_Stretch) {
            subviewEngine.height = 0;
        }
        
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        
        if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况
            subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
            subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
        
        //计算xPos的值加上leadingSpacing + subviewEngine.width + trailingSpacing 的值要小于整体的宽度。
        maxLayoutWidth = xPos + leadingSpace + subviewEngine.width + trailingSpace;
        if (itemIndex != 0) {
            maxLayoutWidth += context->horzSpace;
        }
        maxLayoutWidth += context->paddingTrailing;
        
        NSUInteger lineFirstIndex = [lineFirstSubviewIndexSet indexLessThanOrEqualToIndex:i];
        if (oldLineFirstIndex != lineFirstIndex) {
            oldLineFirstIndex = lineFirstIndex;
            
            xPos = context->paddingLeading;
            yPos += context->vertSpace;
            yPos += lineMaxHeight;
            
            [self myVertLayoutCalculateSingleline:lineIndex vertAlignment:vertAlignment lineMaxHeight:lineMaxHeight lineMaxWidth:lineMaxWidth lineTotalShrink:0 startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
            
            lineMaxHeight = 0.0;
            lineMaxWidth = 0.0;
            itemIndex = 0;
            lineIndex++;
        }
        
        if (itemIndex != 0) {
            xPos += context->horzSpace;
        }
        subviewEngine.leading = xPos + leadingSpace;
        subviewEngine.top = yPos + topSpace;
        xPos += leadingSpace + subviewEngine.width + trailingSpace;
        
        if (_myCGFloatLess(lineMaxHeight, topSpace + bottomSpace + subviewEngine.height)) {
            lineMaxHeight = topSpace + bottomSpace + subviewEngine.height;
        }
        if (_myCGFloatLess(lineMaxWidth, (xPos - context->paddingLeading))) {
            lineMaxWidth = (xPos - context->paddingLeading);
        }
        itemIndex++;
    }
    
    yPos += lineMaxHeight + context->paddingBottom;
    
    //内容填充约束布局的宽度包裹计算。
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:maxLayoutWidth subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:yPos subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    NSInteger arranges = lineFirstSubviewIndexSet.count;
    //根据flex规则：如果只有一行则整个高度都作为子视图的拉伸和停靠区域。
    if (layoutTraits.isFlex && arranges == 1) {
        lineMaxHeight = context->selfSize.height - paddingVert;
    }
    //最后一行
    [self myVertLayoutCalculateSingleline:lineIndex vertAlignment:vertAlignment lineMaxHeight:lineMaxHeight lineMaxWidth:lineMaxWidth lineTotalShrink:0 startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
    
    //整体的停靠
    if (context->vertGravity != MyGravity_None && context->selfSize.height != yPos) {
        //根据flex标准：只有在多行下vertGravity才有意义。非flex标准则不受这个条件约束。
        if (arranges > 1 || !layoutTraits.isFlex) {
            CGFloat addYPos = 0.0;
            CGFloat between = 0.0;
            CGFloat fill = 0.0;
            
            if (arranges <= 1 && context->vertGravity == MyGravity_Vert_Around) {
                context->vertGravity = MyGravity_Vert_Center;
            }
            if (context->vertGravity == MyGravity_Vert_Center) {
                addYPos = (context->selfSize.height - yPos) / 2;
            } else if (context->vertGravity == MyGravity_Vert_Bottom) {
                addYPos = context->selfSize.height - yPos;
            } else if (context->vertGravity == MyGravity_Vert_Fill || context->vertGravity == MyGravity_Vert_Stretch) {
                if (arranges > 0) {
                    fill = (context->selfSize.height - yPos) / arranges;
                }
                //满足flex规则：如果剩余的空间是负数，该值等效于'flex-start'
                if (fill < 0.0 && context->vertGravity == MyGravity_Vert_Stretch) {
                    fill = 0.0;
                }
            } else if (context->vertGravity == MyGravity_Vert_Between) {
                if (arranges > 1) {
                    between = (context->selfSize.height - yPos) / (arranges - 1);
                }
            } else if (context->vertGravity == MyGravity_Vert_Around) {
                between = (context->selfSize.height - yPos) / arranges;
            } else if (context->vertGravity == MyGravity_Vert_Among) {
                between = (context->selfSize.height - yPos) / (arranges + 1);
            }
            
            if (addYPos != 0.0 || between != 0.0 || fill != 0.0) {
                int lineidx = 0;
                NSUInteger lastIndex = 0;
                for (int i = 0; i < subviewEngines.count; i++) {
                    
                    MyLayoutEngine *subviewEngine = subviewEngines[i];
                    
                    subviewEngine.top += addYPos;
                    
                    //找到行的最初索引。
                    NSUInteger index = [lineFirstSubviewIndexSet indexLessThanOrEqualToIndex:i];
                    if (lastIndex != index) {
                        lastIndex = index;
                        lineidx++;
                    }
                    
                    if (context->vertGravity == MyGravity_Vert_Stretch) {
                        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
                        //只有在没有约束，或者非布局视图下的高度自适应约束才会被拉伸。
                        if (subviewTraits.heightSizeInner.val == nil || (subviewTraits.heightSizeInner.wrapVal && ![subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                            subviewEngine.height += fill;
                        } else {
                            //因为每行都增加了fill。所以如果有行内对齐则需要这里调整。
                            MyGravity subviewVertAlignment = MYVERTGRAVITY( subviewTraits.alignment);
                            if (subviewVertAlignment == MyGravity_None) {
                                subviewVertAlignment = vertAlignment;
                            }
                            if (subviewVertAlignment == MyGravity_Vert_Center) {
                                subviewEngine.top += fill / 2.0;
                            } else if (subviewVertAlignment == MyGravity_Vert_Bottom) {
                                subviewEngine.top += fill;
                            }
                        }
                    } else {
                        subviewEngine.height += fill;
                    }
                    subviewEngine.top += fill * lineidx;
                    
                    subviewEngine.top += between * lineidx;
                    
                    if (context->vertGravity == MyGravity_Vert_Around) {
                        subviewEngine.top += (between / 2.0);
                    }
                    if (context->vertGravity == MyGravity_Vert_Among) {
                        subviewEngine.top += between;
                    }
                }
            }
        }
    }
}

- (void)myDoVertOrientationCountLayoutWithContext:(MyLayoutContext *)context {
    
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSMutableArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    
    BOOL autoArrange = layoutTraits.autoArrange;
    NSInteger arrangedCount = layoutTraits.arrangedCount;
    
    MyGravity vertAlignment = MYVERTGRAVITY(layoutTraits.arrangedGravity);
    
    CGFloat subviewWidth = [layoutTraits.flexSpace calcMaxMinSubviewSize:context->selfSize.width arrangedCount:arrangedCount paddingStart:&context->paddingLeading paddingEnd:&context->paddingTrailing space:&context->horzSpace];
    
    CGFloat paddingHorz = context->paddingLeading + context->paddingTrailing;
    CGFloat paddingVert = context->paddingTop + context->paddingBottom;
    
    CGFloat xPos = context->paddingLeading;
    CGFloat yPos = context->paddingTop;
    CGFloat lineMaxHeight = 0.0;    //某一行的最高值。
    CGFloat lineMaxWidth = 0.0;     //某一行的最宽值
    CGFloat maxLayoutWidth = 0.0;         //全部行的最大宽度
    CGFloat maxLayoutHeight = context->paddingTop; //最大的高度
    
#if TARGET_OS_IOS
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] &&
                           ((UIScrollView *)self.superview).isPagingEnabled);
#else
    BOOL isPagingScroll = NO;
#endif
    
    CGFloat pagingItemHeight = 0.0;
    CGFloat pagingItemWidth = 0.0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (layoutTraits.pagedCount > 0 && self.superview != nil) {
        NSInteger rows = layoutTraits.pagedCount / arrangedCount; //每页的行数。
        //对于垂直流式布局来说，要求要有明确的宽度。因此如果我们启用了分页又设置了宽度包裹时则我们的分页是从左到右的排列。否则分页是从上到下的排列。
        if (layoutTraits.widthSizeInner.wrapVal) {
            isHorzPaging = YES;
            if (isPagingScroll) {
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (arrangedCount - 1) * context->horzSpace) / arrangedCount;
            } else {
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - context->paddingLeading - arrangedCount * context->horzSpace) / arrangedCount;
            }
            //如果是水平滚动则如果布局不是高度自适应才让条目的高度生效。
            if (!layoutTraits.heightSizeInner.wrapVal) {
                pagingItemHeight = (context->selfSize.height - paddingVert - (rows - 1) * context->vertSpace) / rows;
            }
        } else {
            isVertPaging = YES;
            pagingItemWidth = (context->selfSize.width - paddingHorz - (arrangedCount - 1) * context->horzSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的高度计算是不一样的。
            if (isPagingScroll) {
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (rows - 1) * context->vertSpace) / rows;
            } else {
                if ([self.superview isKindOfClass:[UIScrollView class]]) {
                    pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - context->paddingTop - rows * context->vertSpace) / rows;
                } else {
                    pagingItemHeight = (context->selfSize.height - paddingVert - (rows - 1) * context->vertSpace) / rows;
                }
            }
        }
    }
    
    //在宽度自适应的情况下有可能有最小宽度的约束。
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:0 subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    //平均宽度，当布局的gravity设置为Horz_Fill时指定这个平均宽度值。
    CGFloat averageWidth = 0.0;
    if (context->horzGravity == MyGravity_Horz_Fill) {
        averageWidth = (context->selfSize.width - paddingHorz - (arrangedCount - 1) * context->horzSpace) / arrangedCount;
        if (averageWidth < 0.0) {
            averageWidth = 0.0;
        }
    }
    
    //得到行数
    NSInteger arranges = floor((subviewEngines.count + arrangedCount - 1.0) / arrangedCount);
    CGFloat lineTotalFixedWidths[arranges]; //所有行的固定宽度。
    CGFloat lineTotalWeights[arranges];     //所有行的总比重
    CGFloat lineTotalShrinks[arranges];     //所有行的总压缩
    
    CGFloat lineTotalFixedWidth = 0.0;
    CGFloat lineTotalWeight = 0.0;
    CGFloat lineTotalShrink = 0.0; //某一行的总压缩比重。
    BOOL hasTotalWeight = NO;      //是否有比重计算，这个标志用于加快处理速度
    BOOL hasTotalShrink = NO;      //是否有压缩计算，这个标志用于加快处理速度
    //行内子视图的索引号
    NSInteger i = 0;
    NSInteger itemIndex = 0;
    NSInteger lineIndex = 0; //行索引
    for (; i < subviewEngines.count; i++) {
        MyLayoutEngine *subviewEngine = subviewEngines[i];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
        CGFloat topSpacing = subviewTraits.topPosInner.measure;
        CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
        
        if (itemIndex >= arrangedCount) {
            lineTotalFixedWidths[lineIndex] = lineTotalFixedWidth;
            lineTotalWeights[lineIndex] = lineTotalWeight;
            lineTotalShrinks[lineIndex] = lineTotalShrink;
            
            if (!hasTotalWeight) {
                hasTotalWeight = lineTotalWeight > 0;
            }
            if (!hasTotalShrink) {
                hasTotalShrink = lineTotalShrink > 0;
            }
            
            if (lineTotalFixedWidth > maxLayoutWidth) {
                maxLayoutWidth = lineTotalFixedWidth;
            }
            
            lineTotalFixedWidth = 0.0;
            lineTotalWeight = 0.0;
            lineTotalShrink = 0.0;
            itemIndex = 0;
            lineIndex++;
        }
        
        //计算每行的宽度。
        if (averageWidth != 0.0) {
            subviewEngine.width = averageWidth - leadingSpacing - trailingSpacing;
        } else if (subviewWidth != 0.0) {
            subviewEngine.width = subviewWidth - leadingSpacing - trailingSpacing;
        } else if (pagingItemWidth != 0.0) {
            subviewEngine.width = pagingItemWidth - leadingSpacing - trailingSpacing;
        } else if (subviewTraits.widthSizeInner.val != nil) {
            if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) { //特殊处理宽度等于高度的情况
                
                if (pagingItemHeight != 0.0) {
                    subviewEngine.height = pagingItemHeight - topSpacing - bottomSpacing;
                } else {
                    subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
                }
                subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            } else {
                subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine  withContext:context];
            }
        } else if (subviewTraits.weight != 0.0) { //在没有设置任何约束，并且weight不为0时则使用比重来求宽度，因此这预先将宽度设置为0
            subviewEngine.width = 0.0;
        }
        
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        itemIndex++;
        
        lineTotalFixedWidth += subviewEngine.width;
        lineTotalFixedWidth += leadingSpacing + trailingSpacing;
        if (itemIndex < arrangedCount) {
            lineTotalFixedWidth += context->horzSpace;
        }
        //计算总拉伸比。
        if (subviewTraits.weight != 0.0) {
            lineTotalWeight += subviewTraits.weight;
        }
        
        //计算总的压缩比
        lineTotalShrink += subviewTraits.leadingPosInner.shrink + subviewTraits.trailingPosInner.shrink;
        lineTotalShrink += subviewTraits.widthSizeInner.shrink;
    }
    
    //最后一行。
    if (arranges > 0) {
        if (itemIndex < arrangedCount) {
            lineTotalFixedWidth -= context->horzSpace;
        }
        lineTotalWeights[lineIndex] = lineTotalWeight;
        lineTotalFixedWidths[lineIndex] = lineTotalFixedWidth;
        lineTotalShrinks[lineIndex] = lineTotalShrink;
        
        if (!hasTotalWeight) {
            hasTotalWeight = lineTotalWeight > 0;
        }
        if (!hasTotalShrink) {
            hasTotalShrink = lineTotalShrink > 0;
        }
        if (lineTotalFixedWidth > maxLayoutWidth) {
            maxLayoutWidth = lineTotalFixedWidth;
        }
    }
    
    maxLayoutWidth += context->paddingLeading + context->paddingTrailing;
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:maxLayoutWidth subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    
    //进行所有行的宽度拉伸和压缩。
    if (context->horzGravity != MyGravity_Horz_Fill && (hasTotalWeight || hasTotalShrink)) {
        NSInteger remainedCount = subviewEngines.count;
        lineIndex = 0;
        for (; lineIndex < arranges; lineIndex++) {
            lineTotalFixedWidth = lineTotalFixedWidths[lineIndex];
            lineTotalWeight = lineTotalWeights[lineIndex];
            lineTotalShrink = lineTotalShrinks[lineIndex];
            
            if (lineTotalWeight != 0) {
                [self myVertLayoutCalculateSinglelineWeight:lineTotalWeight lineSpareWidth:context->selfSize.width - paddingHorz - lineTotalFixedWidth startItemIndex:lineIndex * arrangedCount itemCount:MIN(arrangedCount, remainedCount) withContext:context];
            }
            
            if (lineTotalShrink != 0) {
                [self myVertLayoutCalculateSinglelineShrink:lineTotalShrink lineSpareWidth:context->selfSize.width - paddingHorz - lineTotalFixedWidth startItemIndex:lineIndex * arrangedCount itemCount:MIN(arrangedCount, remainedCount) withContext:context];
            }
            
            remainedCount -= arrangedCount;
        }
    }
    
    //初始化每行的下一个子视图的位置。
    NSMutableArray<NSValue *> *nextPointOfRows = nil;
    if (autoArrange) {
        nextPointOfRows = [NSMutableArray arrayWithCapacity:arrangedCount];
        for (NSInteger idx = 0; idx < arrangedCount; idx++) {
            [nextPointOfRows addObject:[NSValue valueWithCGPoint:CGPointMake(context->paddingLeading, context->paddingTop)]];
        }
    }
    
    CGFloat pageWidth = 0.0; //页宽。
    maxLayoutWidth = context->paddingLeading;
    lineIndex = 0; //行索引
    itemIndex = 0;
    lineTotalShrink = 0.0;
    i = 0;
    for (; i < subviewEngines.count; i++) {
        MyLayoutEngine *subviewEngine = subviewEngines[i];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        
        //新的一行
        if (itemIndex >= arrangedCount) {
            itemIndex = 0;
            yPos += context->vertSpace;
            yPos += lineMaxHeight;
            
            [self myVertLayoutCalculateSingleline:lineIndex vertAlignment:vertAlignment lineMaxHeight:lineMaxHeight lineMaxWidth:lineMaxWidth lineTotalShrink:lineTotalShrink startItemIndex:i - arrangedCount itemCount:arrangedCount withContext:context];
            
            //分别处理水平分页和垂直分页。
            if (isHorzPaging) {
                if (i % layoutTraits.pagedCount == 0) {
                    pageWidth += CGRectGetWidth(self.superview.bounds);
                    
                    if (!isPagingScroll) {
                        pageWidth -= context->paddingLeading;
                    }
                    yPos = context->paddingTop;
                }
            }
            
            if (isVertPaging) {
                //如果是分页滚动则要多添加垂直间距。
                if (i % layoutTraits.pagedCount == 0) {
                    if (isPagingScroll) {
                        yPos -= context->vertSpace;
                        yPos += paddingVert;
                    }
                }
            }
            
            xPos = context->paddingLeading + pageWidth;
            
            lineMaxHeight = 0.0;
            lineMaxWidth = 0.0;
            lineTotalShrink = 0.0;
            lineIndex++;
        }
        
        CGFloat topSpacing = subviewTraits.topPosInner.measure;
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
        
        if (pagingItemHeight != 0) {
            subviewEngine.height = pagingItemHeight - topSpacing - bottomSpacing;
        } else if (subviewTraits.heightSizeInner.val != nil) {
            subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
        } else if (context->vertGravity == MyGravity_Vert_Fill || context->vertGravity == MyGravity_Vert_Stretch) { //如果没有设置高度约束但是又是垂直拉伸则将高度设置为0.
            subviewEngine.height = 0;
        }
        
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        
        //再算一次宽度,只有比重为0并且不压缩的情况下计算。否则有可能前面被压缩或者被拉升而又会在这里重置了
        if (subviewTraits.weight == 0.0 &&
            subviewTraits.widthSizeInner.shrink == 0 &&
            context->horzGravity != MyGravity_Horz_Fill &&
            pagingItemWidth == 0.0 &&
            subviewWidth == 0.0) {
            subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
        }
        
        //特殊处理宽度和高度相互依赖的情况。。
        if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况
            subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
            subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
        
        if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner && context->horzGravity != MyGravity_Horz_Fill) { //特殊处理宽度等于高度的情况
            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
        
        //得到最大的行高
        if (_myCGFloatLess(lineMaxHeight, topSpacing + bottomSpacing + subviewEngine.height)) {
            lineMaxHeight = topSpacing + bottomSpacing + subviewEngine.height;
        }
        //自动排列。
        if (autoArrange) {
            //查找能存放当前子视图的最小y轴的位置以及索引。
            CGPoint minPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
            NSInteger minNextPointIndex = 0;
            for (int idx = 0; idx < arrangedCount; idx++) {
                CGPoint pt = nextPointOfRows[idx].CGPointValue;
                if (minPoint.y > pt.y) {
                    minPoint = pt;
                    minNextPointIndex = idx;
                }
            }
            
            //找到的minNextPointIndex中的
            xPos = minPoint.x;
            yPos = minPoint.y;
            
            minPoint.y = minPoint.y + topSpacing + subviewEngine.height + bottomSpacing + context->vertSpace;
            nextPointOfRows[minNextPointIndex] = [NSValue valueWithCGPoint:minPoint];
            if (minNextPointIndex + 1 <= arrangedCount - 1) {
                minPoint = nextPointOfRows[minNextPointIndex + 1].CGPointValue;
                minPoint.x = xPos + leadingSpacing + subviewEngine.width + trailingSpacing + context->horzSpace;
                nextPointOfRows[minNextPointIndex + 1] = [NSValue valueWithCGPoint:minPoint];
            }
            
            if (_myCGFloatLess(maxLayoutHeight, yPos + topSpacing + subviewEngine.height + bottomSpacing)) {
                maxLayoutHeight = yPos + topSpacing + subviewEngine.height + bottomSpacing;
            }
        } else if (vertAlignment == MyGravity_Vert_Between) { //当列是紧凑排列时需要特殊处理当前的垂直位置。
            //第0行特殊处理。
            if (i - arrangedCount < 0) {
                yPos = context->paddingTop;
            } else {
                //取前一行的对应的列的子视图。
                MyLayoutEngine *prevColSubviewEngine = subviewEngines[i - arrangedCount];
                MyViewTraits *prevColSubviewTraits = prevColSubviewEngine.currentSizeClass;
                //当前子视图的位置等于前一行对应列的最大y的值 + 前面对应列的底部间距 + 子视图之间的行间距。
                yPos = CGRectGetMaxY(prevColSubviewEngine.frame) + prevColSubviewTraits.bottomPosInner.measure + context->vertSpace;
            }
            
            if (_myCGFloatLess(maxLayoutHeight, yPos + topSpacing + subviewEngine.height + bottomSpacing)) {
                maxLayoutHeight = yPos + topSpacing + subviewEngine.height + bottomSpacing;
            }
        } else { //正常排列。
            //这里的最大其实就是最后一个视图的位置加上最高的子视图的尺寸。
            if (_myCGFloatLess(maxLayoutHeight, yPos + lineMaxHeight)) {
                maxLayoutHeight = yPos + lineMaxHeight;
            }
        }
        
        subviewEngine.leading = xPos + leadingSpacing;
        subviewEngine.top = yPos + topSpacing;
        xPos += leadingSpacing + subviewEngine.width + trailingSpacing;
        
        if (_myCGFloatLess(lineMaxWidth, (xPos - context->paddingLeading))) {
            lineMaxWidth = (xPos - context->paddingLeading);
        }
        if (_myCGFloatLess(maxLayoutWidth, xPos)) {
            maxLayoutWidth = xPos;
        }
        
        if (itemIndex != (arrangedCount - 1) && !autoArrange) {
            xPos += context->horzSpace;
        }
        itemIndex++;
        
        //这里只对间距进行压缩比重的计算，因为前面压缩了宽度，这里只需要压缩间距了。
        lineTotalShrink += subviewTraits.leadingPosInner.shrink + subviewTraits.trailingPosInner.shrink;
    }
    
    maxLayoutHeight += context->paddingBottom;
    
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = maxLayoutHeight;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的高度。
        if (isVertPaging && isPagingScroll) {
            //算出页数来。如果包裹计算出来的高度小于指定页数的高度，因为要分页滚动所以这里会扩充布局的高度。
            NSInteger totalPages = floor((subviewEngines.count + layoutTraits.pagedCount - 1.0) / layoutTraits.pagedCount);
            if (_myCGFloatLess(context->selfSize.height, totalPages * CGRectGetHeight(self.superview.bounds))) {
                context->selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
            }
        }
        
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:context->selfSize.height subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    
    //根据flex规则：如果只有一行则整个高度都作为子视图的拉伸和停靠区域。
    if (layoutTraits.isFlex && arranges == 1) {
        lineMaxHeight = context->selfSize.height - paddingVert;
    }
    
    //最后一行，有可能因为行宽的压缩导致那些高度依赖宽度以及高度自适应的视图会增加高度，从而使得行高被调整。
    [self myVertLayoutCalculateSingleline:lineIndex vertAlignment:vertAlignment lineMaxHeight:lineMaxHeight lineMaxWidth:lineMaxWidth lineTotalShrink:lineTotalShrink startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
    
    //整体的停靠
    if (context->vertGravity != MyGravity_None && context->selfSize.height != maxLayoutHeight && !(isVertPaging && isPagingScroll)) {
        //根据flex标准：只有在多行下vertGravity才有意义。非flex标准则不受这个条件约束。
        if (arranges > 1 || !layoutTraits.isFlex) {
            CGFloat addYPos = 0.0;
            CGFloat between = 0.0;
            CGFloat fill = 0.0;
            
            if (arranges <= 1 && context->vertGravity == MyGravity_Vert_Around) {
                context->vertGravity = MyGravity_Vert_Center;
            }
            if (context->vertGravity == MyGravity_Vert_Center) {
                addYPos = (context->selfSize.height - maxLayoutHeight) / 2;
            } else if (context->vertGravity == MyGravity_Vert_Bottom) {
                addYPos = context->selfSize.height - maxLayoutHeight;
            } else if (context->vertGravity == MyGravity_Vert_Fill || context->vertGravity == MyGravity_Vert_Stretch) {
                if (arranges > 0) {
                    fill = (context->selfSize.height - maxLayoutHeight) / arranges;
                }
                //满足flex规则：如果剩余的空间是负数，该值等效于'flex-start'
                if (fill < 0.0 && context->vertGravity == MyGravity_Vert_Stretch) {
                    fill = 0.0;
                }
            } else if (context->vertGravity == MyGravity_Vert_Between) {
                if (arranges > 1) {
                    between = (context->selfSize.height - maxLayoutHeight) / (arranges - 1);
                }
            } else if (context->vertGravity == MyGravity_Vert_Around) {
                between = (context->selfSize.height - maxLayoutHeight) / arranges;
            } else if (context->vertGravity == MyGravity_Vert_Among) {
                between = (context->selfSize.height - maxLayoutHeight) / (arranges + 1);
            }
            
            if (addYPos != 0.0 || between != 0.0 || fill != 0.0) {
                for (int i = 0; i < subviewEngines.count; i++) {
                    
                    MyLayoutEngine *subviewEngine = subviewEngines[i];
                    
                    int lineidx = i / arrangedCount;
                    if (context->vertGravity == MyGravity_Vert_Stretch) {
                        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
                        if (subviewTraits.heightSizeInner.val == nil || (subviewTraits.heightSizeInner.wrapVal && ![subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                            subviewEngine.height += fill;
                        } else {
                            //因为每行都增加了fill。所以如果有行内对齐则需要这里调整。
                            MyGravity subviewVertAlignment = MYVERTGRAVITY(subviewTraits.alignment);
                            if (subviewVertAlignment == MyGravity_None) {
                                subviewVertAlignment = vertAlignment;
                            }
                            if (subviewVertAlignment == MyGravity_Vert_Center) {
                                subviewEngine.top += fill / 2.0;
                            } else if (subviewVertAlignment == MyGravity_Vert_Bottom) {
                                subviewEngine.top += fill;
                            }
                        }
                    } else {
                        subviewEngine.height += fill;
                    }
                    subviewEngine.top += fill * lineidx;
                    
                    subviewEngine.top += addYPos;
                    
                    subviewEngine.top += between * lineidx;
                    
                    //如果是vert_around那么所有行都应该添加一半的between值。
                    if (context->vertGravity == MyGravity_Vert_Around) {
                        subviewEngine.top += (between / 2.0);
                    }
                    if (context->vertGravity == MyGravity_Vert_Among) {
                        subviewEngine.top += between;
                    }
                }
            }
        }
    }
    
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = maxLayoutWidth + context->paddingTrailing;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll) {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((subviewEngines.count + layoutTraits.pagedCount - 1.0) / layoutTraits.pagedCount);
            if (_myCGFloatLess(context->selfSize.width, totalPages * CGRectGetWidth(self.superview.bounds))) {
                context->selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
            }
        }
    }
}

- (void)myDoHorzOrientationContentLayoutWithContext:(MyLayoutContext *)context {
    
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSMutableArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    
    MyGravity horzAlignment = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(layoutTraits.arrangedGravity)];
    
    //支持浮动垂直间距。
    CGFloat subviewHeight = [layoutTraits.flexSpace calcMaxMinSubviewSizeForContent:context->selfSize.height paddingStart:&context->paddingTop paddingEnd:&context->paddingBottom space:&context->vertSpace];
    
    CGFloat paddingVert = context->paddingTop + context->paddingBottom;
    CGFloat paddingHorz = context->paddingLeading + context->paddingTrailing;
    
    CGFloat xPos = context->paddingLeading;
    CGFloat yPos = context->paddingTop;
    CGFloat lineMaxWidth = 0.0;  //某一列的最宽值。
    CGFloat lineMaxHeight = 0.0; //某一列的最高值
    CGFloat maxLayoutHeight = 0.0;     //所有列的最宽行
    
    //limitedSelfHeight是用来限制子视图换行的高度，默认是selfSize.height
    //但是一种特殊情况就是布局视图高度自适应，但是设置了最高高度的情况。
    //这种情况下当子视图超过最高高度时还是需要进行换行处理。
    //而如果没有设置最高高度的话那么默认限制的高度就是最大值CGFLOAT_MAX
    CGFloat limitedSelfHeight = context->selfSize.height;
    if (layoutTraits.heightSizeInner.wrapVal) {
        limitedSelfHeight = [self myGetBoundLimitMeasure:layoutTraits.heightSizeInner.uBoundValInner subview:self anchorType:layoutTraits.heightSizeInner.anchorType subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size isUBound:YES];
        limitedSelfHeight = _myCGFloatMin(limitedSelfHeight, CGFLOAT_MAX);
    }
    
    if (layoutTraits.autoArrange) {
        //计算出每个子视图的宽度。
        for (MyLayoutEngine *subviewEngine in subviewEngines) {
            MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
            
#ifdef DEBUG
            //约束异常：水平流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(subviewTraits.weight == 0, @"Constraint exception!! horizontal flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES", self, subviewTraits.view);
#endif
            
            CGFloat topSpacing = subviewTraits.topPosInner.measure;
            CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
            
            subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine  withContext:context];
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            
            subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
            subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            
            //暂时把宽度存放sbv.myFrame.trailing上。因为流式布局来说这个属性无用。
            subviewEngine.trailing = topSpacing + subviewEngine.height + bottomSpacing;
            if (_myCGFloatGreat(subviewEngine.trailing, context->selfSize.height - paddingVert)) {
                subviewEngine.trailing = context->selfSize.height - paddingVert;
            }
        }
        
        [subviewEngines setArray:[self myGetAutoArrangeSubviews:subviewEngines selfSize:context->selfSize.height - paddingVert space:context->vertSpace]];
    }
    
    NSMutableIndexSet *lineFirstSubviewIndexSet = [NSMutableIndexSet new];
    NSInteger lineIndex = 0;
    NSInteger itemIndex = 0;
    CGFloat lineTotalWeight = 0.0;
    NSInteger i = 0;
    for (; i < subviewEngines.count; i++) {
        MyLayoutEngine *subviewEngine = subviewEngines[i];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        
        CGFloat topSpacing = subviewTraits.topPosInner.measure;
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
        
        //这里先计算一下宽度，因为有可能有宽度固定，高度自适应的情况。
        if (subviewTraits.widthSizeInner.val != nil) {
            subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
            
            //当只有一行而且是flex标准并且是stretch时会把所有子视图的宽度都强制拉伸为布局视图的宽度
            //所以如果这里是宽度自适应时需要将宽度强制设置为和布局等宽，以便解决同时高度自适应时高度计算不正确的问题。
            if (lineIndex == 0 &&
                subviewTraits.widthSizeInner.wrapVal &&
                layoutTraits.isFlex &&
                context->horzGravity == MyGravity_Horz_Stretch &&
                subviewEngine.width > context->selfSize.width - paddingHorz - leadingSpacing - trailingSpacing) {
                subviewEngine.width = context->selfSize.width - paddingHorz - leadingSpacing - trailingSpacing;
            }
            
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        } else if (context->horzGravity == MyGravity_Horz_Fill || context->horzGravity == MyGravity_Horz_Stretch) {
            subviewEngine.width = 0.0;
        }
        
        if (subviewHeight != 0.0) {
            subviewEngine.height = subviewHeight - topSpacing - bottomSpacing;
        } else if (subviewTraits.heightSizeInner.val != nil) {
            subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
            
            if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况
                subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
                subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            }
        } else if (subviewTraits.weight != 0.0) {
            if (layoutTraits.isFlex) {
                subviewEngine.height = 0.0;
            } else {
                //如果超过了布局尺寸，则表示当前的剩余空间为0了，所以就按新的一行来算。。
                CGFloat lineSpareHeight = context->selfSize.height - context->paddingBottom - yPos - topSpacing - bottomSpacing;
                if (itemIndex != 0) {
                    lineSpareHeight -= context->vertSpace;
                }
                if (_myCGFloatLessOrEqual(lineSpareHeight, 0.0)) {
                    lineSpareHeight = context->selfSize.height - paddingVert;
                }
                
                subviewEngine.height = (lineSpareHeight + subviewTraits.heightSizeInner.addVal) * subviewTraits.weight - topSpacing - bottomSpacing;
            }
        }
        
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        
        //特殊处理宽度依赖高度的子视图。
        if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) { //特殊处理宽度等于高度的情况
            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
        
        //计算yPos的值加上topSpacing + subviewEngine.height + bottomSpacing的值要小于整体的高度。
        CGFloat place = yPos + topSpacing + subviewEngine.height + bottomSpacing;
        if (itemIndex != 0) {
            place += context->vertSpace;
        }
        place += context->paddingBottom;
        
        //sbv所占据的高度要超过了视图的整体高度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的高度和布局视图保持一致。
        if (place - limitedSelfHeight > 0.0001) {
            context->selfSize.height = limitedSelfHeight;
            
            [lineFirstSubviewIndexSet addIndex:i - itemIndex];
            
            //拉伸以及调整行内子视图的高度。
            [self myHorzLayoutAdjustSingleline:lineIndex lineSpareHeight:context->selfSize.height - context->paddingBottom - yPos lineTotalWeight:lineTotalWeight startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
            
            yPos = context->paddingTop;
            
            //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
            if (_myCGFloatGreat(topSpacing + bottomSpacing + subviewEngine.height, context->selfSize.height - paddingVert)) {
                subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:context->selfSize.height - paddingVert - topSpacing - bottomSpacing subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            }
            
            lineTotalWeight = 0.0;
            lineIndex++;
            itemIndex = 0;
        }
        
        if (itemIndex != 0) {
            yPos += context->vertSpace;
        }
        
        subviewEngine.top = yPos + topSpacing;
        yPos += topSpacing + subviewEngine.height + bottomSpacing;
        
        if (layoutTraits.isFlex && subviewTraits.weight != 0) {
            lineTotalWeight += subviewTraits.weight;
        }
        
        itemIndex++;
    }
    
    //最后一行的行首索引
    [lineFirstSubviewIndexSet addIndex:i - itemIndex];
    
    //在高度为自适应时，如果没有设置最大高度限制，那么就一定是单行，因此高度就是子视图的总和。
    //如果设置了最大高度限制时，那就要区分最后一行是单行还是多行，所以我们取限高和当前计算出的高度的最小值，并且再取selfSize.height和前面比较结果的最大值。
    if (layoutTraits.heightSizeInner.wrapVal) {
        if (limitedSelfHeight == CGFLOAT_MAX) {
            context->selfSize.height = _myCGFloatMax(yPos + context->paddingBottom, [self myGetBoundLimitMeasure:layoutTraits.heightSizeInner.uBoundValInner subview:self anchorType:layoutTraits.heightSizeInner.anchorType subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size isUBound:NO]);
        } else {
            context->selfSize.height = _myCGFloatMax(_myCGFloatMin(yPos + context->paddingBottom, limitedSelfHeight), context->selfSize.height);
        }
    }
    
    [self myHorzLayoutAdjustSingleline:lineIndex lineSpareHeight:context->selfSize.height - context->paddingBottom - yPos lineTotalWeight:lineTotalWeight  startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
    
    yPos = context->paddingTop;
    lineIndex = 0; //行的索引。
    itemIndex = 0; //行内的子视图索引
    NSInteger oldLineFirstIndex = 0;
    i = 0;
    for (; i < subviewEngines.count; i++) {
        MyLayoutEngine *subviewEngine = subviewEngines[i];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        
        CGFloat topSpacing = subviewTraits.topPosInner.measure;
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
        
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        
        if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) { //特殊处理宽度等于高度的情况
            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
        
        //计算yPos的值加上topSpacing + subviewEngine.height + bottomSpacing 的值要小于整体的高度。
        maxLayoutHeight = yPos + topSpacing + subviewEngine.height + bottomSpacing;
        if (itemIndex != 0) {
            maxLayoutHeight += context->vertSpace;
        }
        maxLayoutHeight += context->paddingBottom;
        
        NSUInteger lineFirstIndex = [lineFirstSubviewIndexSet indexLessThanOrEqualToIndex:i];
        if (oldLineFirstIndex != lineFirstIndex) {
            oldLineFirstIndex = lineFirstIndex;
            
            yPos = context->paddingTop;
            xPos += context->horzSpace;
            xPos += lineMaxWidth;
            
            [self myHorzLayoutCalculateSingleline:lineIndex horzAlignment:horzAlignment lineMaxWidth:lineMaxWidth lineMaxHeight:lineMaxHeight lineTotalShrink:0 startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
            
            lineMaxWidth = 0.0;
            lineMaxHeight = 0.0;
            itemIndex = 0;
            lineIndex++;
        }
        
        if (itemIndex != 0) {
            yPos += context->vertSpace;
        }
        
        subviewEngine.leading = xPos + leadingSpacing;
        subviewEngine.top = yPos + topSpacing;
        yPos += topSpacing + subviewEngine.height + bottomSpacing;
        
        if (_myCGFloatLess(lineMaxWidth, leadingSpacing + trailingSpacing + subviewEngine.width)) {
            lineMaxWidth = leadingSpacing + trailingSpacing + subviewEngine.width;
        }
        if (_myCGFloatLess(lineMaxHeight, (yPos - context->paddingTop))) {
            lineMaxHeight = (yPos - context->paddingTop);
        }
        itemIndex++;
    }
    
    xPos += lineMaxWidth + context->paddingTrailing;
    
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:maxLayoutHeight subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:xPos subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    NSInteger arranges = lineFirstSubviewIndexSet.count;
    //根据flex规则：如果只有一列则整个宽度都作为子视图的拉伸和停靠区域。
    if (layoutTraits.isFlex && arranges == 1) {
        lineMaxWidth = context->selfSize.width - paddingHorz;
    }
    //最后一行
    [self myHorzLayoutCalculateSingleline:lineIndex horzAlignment:horzAlignment lineMaxWidth:lineMaxWidth lineMaxHeight:lineMaxHeight lineTotalShrink:0 startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
    
    //整体的停靠
    if (context->horzGravity != MyGravity_None && context->selfSize.width != xPos) {
        //根据flex标准：只有在多行下horzGravity才有意义。非flex标准则不受这个条件约束。
        if (arranges > 1 || !layoutTraits.isFlex) {
            CGFloat addXPos = 0.0;
            CGFloat fill = 0.0;
            CGFloat between = 0.0;
            
            if (arranges <= 1 && context->horzGravity == MyGravity_Horz_Around) {
                context->horzGravity = MyGravity_Horz_Center;
            }
            if (context->horzGravity == MyGravity_Horz_Center) {
                addXPos = (context->selfSize.width - xPos) / 2;
            } else if (context->horzGravity == MyGravity_Horz_Trailing) {
                addXPos = context->selfSize.width - xPos;
            } else if (context->horzGravity == MyGravity_Horz_Fill || context->horzGravity == MyGravity_Horz_Stretch) {
                if (arranges > 0) {
                    fill = (context->selfSize.width - xPos) / arranges;
                }
                //满足flex规则：如果剩余的空间是负数，该值等效于'flex-start'
                if (fill < 0.0 && context->horzGravity == MyGravity_Horz_Stretch) {
                    fill = 0.0;
                }
            } else if (context->horzGravity == MyGravity_Horz_Between) {
                if (arranges > 1) {
                    between = (context->selfSize.width - xPos) / (arranges - 1);
                }
            } else if (context->horzGravity == MyGravity_Horz_Around) {
                between = (context->selfSize.width - xPos) / arranges;
            } else if (context->horzGravity == MyGravity_Horz_Among) {
                between = (context->selfSize.width - xPos) / (arranges + 1);
            }
            
            if (addXPos != 0.0 || between != 0.0 || fill != 0.0) {
                int lineidx = 0;
                NSUInteger lastIndex = 0;
                for (int i = 0; i < subviewEngines.count; i++) {
                    MyLayoutEngine *subviewEngine = subviewEngines[i];
                    
                    subviewEngine.leading += addXPos;
                    
                    //找到行的最初索引。
                    NSUInteger index = [lineFirstSubviewIndexSet indexLessThanOrEqualToIndex:i];
                    if (lastIndex != index) {
                        lastIndex = index;
                        lineidx++;
                    }
                    
                    if (context->horzGravity == MyGravity_Horz_Stretch) {
                        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
                        if (subviewTraits.widthSizeInner.val == nil || (subviewTraits.widthSizeInner.wrapVal && ![subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                            subviewEngine.width += fill;
                        } else {
                            //因为每行都增加了fill。所以如果有行内对齐则需要这里调整。
                            MyGravity subviewHorzAlignment = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(subviewTraits.alignment)];
                            if (subviewHorzAlignment == MyGravity_None) {
                                subviewHorzAlignment = horzAlignment;
                            }
                            if (subviewHorzAlignment == MyGravity_Horz_Center) {
                                subviewEngine.leading += fill / 2.0;
                            } else if (subviewHorzAlignment == MyGravity_Horz_Trailing) {
                                subviewEngine.leading += fill;
                            }
                        }
                    } else {
                        subviewEngine.width += fill;
                    }
                    subviewEngine.leading += fill * lineidx;
                    
                    subviewEngine.leading += between * lineidx;
                    
                    if (context->horzGravity == MyGravity_Horz_Around) {
                        subviewEngine.leading += (between / 2.0);
                    }
                    
                    if (context->horzGravity == MyGravity_Horz_Among) {
                        subviewEngine.leading += between;
                    }
                }
            }
        }
    }
}

- (void)myDoHorzOrientationCountLayoutWithContext:(MyLayoutContext *)context {
    MyFlowLayoutTraits *layoutTraits = (MyFlowLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSMutableArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    
    
    BOOL autoArrange = layoutTraits.autoArrange;
    NSInteger arrangedCount = layoutTraits.arrangedCount;
    
    MyGravity horzAlignment = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(layoutTraits.arrangedGravity)];
    
    CGFloat subviewHeight = [layoutTraits.flexSpace calcMaxMinSubviewSize:context->selfSize.height arrangedCount:arrangedCount paddingStart:&context->paddingTop paddingEnd:&context->paddingBottom space:&context->vertSpace];
    
    CGFloat paddingHorz = context->paddingLeading + context->paddingTrailing;
    CGFloat paddingVert = context->paddingTop + context->paddingBottom;
    
    CGFloat xPos = context->paddingLeading;
    CGFloat yPos = context->paddingTop;
    CGFloat lineMaxWidth = 0.0;        //每一列的最大宽度
    CGFloat lineMaxHeight = 0.0;       //每一列的最大高度
    CGFloat maxLayoutHeight = 0.0;           //全列的最大高度
    CGFloat maxLayoutWidth = context->paddingLeading; //最大的宽度。
    
    //父滚动视图是否分页滚动。
#if TARGET_OS_IOS
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] &&
                           ((UIScrollView *)self.superview).isPagingEnabled);
#else
    BOOL isPagingScroll = NO;
#endif
    
    CGFloat pagingItemHeight = 0.0;
    CGFloat pagingItemWidth = 0.0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (layoutTraits.pagedCount > 0 && self.superview != nil) {
        NSInteger cols = layoutTraits.pagedCount / arrangedCount; //每页的列数。
        
        //对于水平流式布局来说，要求要有明确的高度。因此如果我们启用了分页又设置了高度包裹时则我们的分页是从上到下的排列。否则分页是从左到右的排列。
        if (layoutTraits.heightSizeInner.wrapVal) {
            isVertPaging = YES;
            if (isPagingScroll) {
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (arrangedCount - 1) * context->vertSpace) / arrangedCount;
            } else {
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - context->paddingTop - arrangedCount * context->vertSpace) / arrangedCount;
            }
            //如果是水平滚动则如果布局不是高度自适应才让条目的高度生效。
            if (!layoutTraits.widthSizeInner.wrapVal) {
                pagingItemWidth = (context->selfSize.width - paddingHorz - (cols - 1) * context->horzSpace) / cols;
            }
        } else {
            isHorzPaging = YES;
            pagingItemHeight = (context->selfSize.height - paddingVert - (arrangedCount - 1) * context->vertSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的宽度计算是不一样的。
            if (isPagingScroll) {
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (cols - 1) * context->horzSpace) / cols;
            } else {
                if ([self.superview isKindOfClass:[UIScrollView class]]) {
                    pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - context->paddingLeading - cols * context->horzSpace) / cols;
                } else {
                    pagingItemWidth = (context->selfSize.width - paddingHorz - (cols - 1) * context->horzSpace) / cols;
                }
            }
        }
    }
    
    //在高度自适应的情况下有可能有最大最小高度约束。
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:0 subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    //平均高度，当布局的gravity设置为Vert_Fill时指定这个平均高度值。
    CGFloat averageHeight = 0.0;
    if (context->vertGravity == MyGravity_Vert_Fill) {
        averageHeight = (context->selfSize.height - paddingVert - (arrangedCount - 1) * context->vertSpace) / arrangedCount;
    }
    //得到行数
    NSInteger arranges = floor((subviewEngines.count + arrangedCount - 1.0) / arrangedCount);
    CGFloat lineTotalFixedHeights[arranges]; //所有行的固定高度。
    CGFloat lineTotalWeights[arranges];      //所有行的总比重
    CGFloat lineTotalShrinks[arranges];      //所有行的总压缩
    
    CGFloat lineTotalFixedHeight = 0.0;
    CGFloat lineTotalWeight = 0.0;
    CGFloat lineTotalShrink = 0.0; //某一行的总压缩比重。
    BOOL hasTotalWeight = NO;      //是否有比重计算，这个标志用于加快处理速度
    BOOL hasTotalShrink = NO;      //是否有压缩计算，这个标志用于加快处理速度
    
    NSInteger i = 0;
    NSInteger itemIndex = 0;
    NSInteger lineIndex = 0; //行索引
    for (; i < subviewEngines.count; i++) {
        MyLayoutEngine *subviewEngine = subviewEngines[i];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        
        CGFloat topSpacing = subviewTraits.topPosInner.measure;
        CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
        
        if (itemIndex >= arrangedCount) {
            lineTotalFixedHeights[lineIndex] = lineTotalFixedHeight;
            lineTotalWeights[lineIndex] = lineTotalWeight;
            lineTotalShrinks[lineIndex] = lineTotalShrink;
            
            if (!hasTotalWeight) {
                hasTotalWeight = lineTotalWeight > 0;
            }
            if (!hasTotalShrink) {
                hasTotalShrink = lineTotalShrink > 0;
            }
            if (lineTotalFixedHeight > maxLayoutHeight) {
                maxLayoutHeight = lineTotalFixedHeight;
            }
            lineTotalFixedHeight = 0.0;
            lineTotalWeight = 0.0;
            lineTotalShrink = 0.0;
            itemIndex = 0;
            lineIndex++;
        }
        //水平流式布局因为高度依赖宽度自适应的情况比较少，所以这里直接先计算宽度
        if (pagingItemWidth != 0.0) {
            subviewEngine.width = pagingItemWidth - leadingSpacing - trailingSpacing;
        } else if (subviewTraits.widthSizeInner.val != nil) {
            subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
            
            //   当只有一行而且是flex标准并且是stretch时会把所有子视图的宽度都强制拉伸为布局视图的宽度
            //   所以如果这里是宽度自适应时需要将宽度强制设置为和布局等宽，以便解决同时高度自适应时高度计算不正确的问题。
            if (arranges == 1 &&
                subviewTraits.widthSizeInner.wrapVal &&
                layoutTraits.isFlex &&
                context->horzGravity == MyGravity_Horz_Stretch &&
                subviewEngine.width > context->selfSize.width - paddingHorz - leadingSpacing - trailingSpacing) {
                subviewEngine.width = context->selfSize.width - paddingHorz - leadingSpacing - trailingSpacing;
            }
        } else if (context->horzGravity == MyGravity_Horz_Fill || context->horzGravity == MyGravity_Horz_Stretch) {
            subviewEngine.width = 0;
        }
        
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        
        if (averageHeight != 0.0) {
            subviewEngine.height = averageHeight - topSpacing - bottomSpacing;
        } else if (subviewHeight != 0.0) {
            subviewEngine.height = subviewHeight - topSpacing - bottomSpacing;
        } else if (pagingItemHeight != 0.0) {
            subviewEngine.height = pagingItemHeight - topSpacing - bottomSpacing;
        } else if (subviewTraits.heightSizeInner.val != nil) {
            if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况
                subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
            } else {
                subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
            }
        } else if (subviewTraits.weight != 0.0) {
            subviewEngine.height = 0.0;
        }
        
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        
        if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) { //特殊处理宽度等于高度的情况
            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
        
        itemIndex++;
        
        lineTotalFixedHeight += subviewEngine.height;
        lineTotalFixedHeight += topSpacing + bottomSpacing;
        if (itemIndex < arrangedCount) {
            lineTotalFixedHeight += context->vertSpace;
        }
        if (subviewTraits.weight != 0) {
            lineTotalWeight += subviewTraits.weight;
        }
        //计算总的压缩比
        lineTotalShrink += subviewTraits.topPosInner.shrink + subviewTraits.bottomPosInner.shrink;
        lineTotalShrink += subviewTraits.heightSizeInner.shrink;
    }
    
    //最后一行。
    if (arranges > 0) {
        if (itemIndex < arrangedCount) {
            lineTotalFixedHeight -= context->vertSpace;
        }
        lineTotalFixedHeights[lineIndex] = lineTotalFixedHeight;
        lineTotalWeights[lineIndex] = lineTotalWeight;
        lineTotalShrinks[lineIndex] = lineTotalShrink;
        
        if (!hasTotalWeight) {
            hasTotalWeight = lineTotalWeight > 0;
        }
        if (!hasTotalShrink) {
            hasTotalShrink = lineTotalShrink > 0;
        }
        if (lineTotalFixedHeight > maxLayoutHeight) {
            maxLayoutHeight = lineTotalFixedHeight;
        }
    }
    
    maxLayoutHeight += context->paddingTop + context->paddingBottom;
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:maxLayoutHeight subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    //进行所有行的宽度拉伸和压缩。
    if (context->vertGravity != MyGravity_Vert_Fill && (hasTotalWeight || hasTotalShrink)) {
        NSInteger remainedCount = subviewEngines.count;
        lineIndex = 0;
        for (; lineIndex < arranges; lineIndex++) {
            lineTotalFixedHeight = lineTotalFixedHeights[lineIndex];
            lineTotalWeight = lineTotalWeights[lineIndex];
            lineTotalShrink = lineTotalShrinks[lineIndex];
            
            if (lineTotalWeight != 0) {
                [self myHorzLayoutCalculateSinglelineWeight:lineTotalWeight lineSpareHeight:context->selfSize.height - paddingVert - lineTotalFixedHeight startItemIndex:lineIndex * arrangedCount itemCount:MIN(arrangedCount, remainedCount) withContext:context];
            }
            
            if (lineTotalShrink != 0) {
                [self myHorzLayoutCalculateSinglelineShrink:lineTotalShrink lineSpareHeight:context->selfSize.height - paddingVert - lineTotalFixedHeight startItemIndex:lineIndex * arrangedCount itemCount:MIN(arrangedCount, remainedCount) withContext:context];
            }
            
            remainedCount -= arrangedCount;
        }
    }
    
    //初始化每行的下一个子视图的位置。
    NSMutableArray<NSValue *> *nextPointOfCols = nil;
    if (autoArrange) {
        nextPointOfCols = [NSMutableArray arrayWithCapacity:arrangedCount];
        for (NSInteger idx = 0; idx < arrangedCount; idx++) {
            [nextPointOfCols addObject:[NSValue valueWithCGPoint:CGPointMake(context->paddingLeading, context->paddingTop)]];
        }
    }
    
    CGFloat pageHeight = 0.0; //页高
    maxLayoutHeight = context->paddingTop;
    lineIndex = 0;
    itemIndex = 0;
    lineTotalShrink = 0.0;
    i = 0;
    for (; i < subviewEngines.count; i++) {
        MyLayoutEngine *subviewEngine = subviewEngines[i];
        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
        
        if (itemIndex >= arrangedCount) {
            itemIndex = 0;
            xPos += context->horzSpace;
            xPos += lineMaxWidth;
            
            [self myHorzLayoutCalculateSingleline:lineIndex horzAlignment:horzAlignment lineMaxWidth:lineMaxWidth lineMaxHeight:lineMaxHeight lineTotalShrink:lineTotalShrink startItemIndex:i - arrangedCount itemCount:arrangedCount withContext:context];
            
            //分别处理水平分页和垂直分页。
            if (isVertPaging) {
                if (i % layoutTraits.pagedCount == 0) {
                    pageHeight += CGRectGetHeight(self.superview.bounds);
                    
                    if (!isPagingScroll) {
                        pageHeight -= context->paddingTop;
                    }
                    xPos = context->paddingLeading;
                }
            }
            
            if (isHorzPaging) {
                //如果是分页滚动则要多添加垂直间距。
                if (i % layoutTraits.pagedCount == 0) {
                    if (isPagingScroll) {
                        xPos -= context->horzSpace;
                        xPos += paddingHorz;
                    }
                }
            }
            
            yPos = context->paddingTop + pageHeight;
            
            lineMaxWidth = 0.0;
            lineMaxHeight = 0.0;
            lineTotalShrink = 0.0;
            lineIndex++;
        }
        
        CGFloat topSpacing = subviewTraits.topPosInner.measure;
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
        
        //得到最大的列宽
        if (_myCGFloatLess(lineMaxWidth, leadingSpacing + trailingSpacing + subviewEngine.width)) {
            lineMaxWidth = leadingSpacing + trailingSpacing + subviewEngine.width;
        }
        //自动排列。
        if (autoArrange) {
            //查找能存放当前子视图的最小x轴的位置以及索引。
            CGPoint minPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
            NSInteger minNextPointIndex = 0;
            for (int idx = 0; idx < arrangedCount; idx++) {
                CGPoint pt = nextPointOfCols[idx].CGPointValue;
                if (minPoint.x > pt.x) {
                    minPoint = pt;
                    minNextPointIndex = idx;
                }
            }
            
            //找到的minNextPointIndex中的
            xPos = minPoint.x;
            yPos = minPoint.y;
            
            minPoint.x = minPoint.x + leadingSpacing + subviewEngine.width + trailingSpacing + context->horzSpace;
            nextPointOfCols[minNextPointIndex] = [NSValue valueWithCGPoint:minPoint];
            if (minNextPointIndex + 1 <= arrangedCount - 1) {
                minPoint = nextPointOfCols[minNextPointIndex + 1].CGPointValue;
                minPoint.y = yPos + topSpacing + subviewEngine.height + bottomSpacing + context->vertSpace;
                nextPointOfCols[minNextPointIndex + 1] = [NSValue valueWithCGPoint:minPoint];
            }
            
            if (_myCGFloatLess(maxLayoutWidth, xPos + leadingSpacing + subviewEngine.width + trailingSpacing)) {
                maxLayoutWidth = xPos + leadingSpacing + subviewEngine.width + trailingSpacing;
            }
        } else if (horzAlignment == MyGravity_Horz_Between) { //当列是紧凑排列时需要特殊处理当前的水平位置。
            //第0列特殊处理。
            if (i - arrangedCount < 0) {
                xPos = context->paddingLeading;
            } else {
                //取前一列的对应的行的子视图。
                MyLayoutEngine *prevColSubviewEngine = subviewEngines[i - arrangedCount];
                MyViewTraits *prevColSubviewTraits = prevColSubviewEngine.currentSizeClass;
                //当前子视图的位置等于前一列对应行的最大x的值 + 前面对应行的尾部间距 + 子视图之间的列间距。
                xPos = CGRectGetMaxX(prevColSubviewEngine.frame) + prevColSubviewTraits.trailingPosInner.measure + context->horzSpace;
            }
            
            if (_myCGFloatLess(maxLayoutWidth, xPos + leadingSpacing + subviewEngine.width + trailingSpacing)) {
                maxLayoutWidth = xPos + leadingSpacing + subviewEngine.width + trailingSpacing;
            }
        } else { //正常排列。
            //这里的最大其实就是最后一个视图的位置加上最宽的子视图的尺寸。
            if (_myCGFloatLess(maxLayoutWidth, xPos + lineMaxWidth)) {
                maxLayoutWidth = xPos + lineMaxWidth;
            }
        }
        
        subviewEngine.leading = xPos + leadingSpacing;
        subviewEngine.top = yPos + topSpacing;
        yPos += topSpacing + subviewEngine.height + bottomSpacing;
        
        if (_myCGFloatLess(lineMaxHeight, (yPos - context->paddingTop))) {
            lineMaxHeight = yPos - context->paddingTop;
        }
        
        if (_myCGFloatLess(maxLayoutHeight, yPos)) {
            maxLayoutHeight = yPos;
        }
        //不是最后一行以及非自动排列时才添加布局视图设置的行间距。自动排列的情况下上面已经有添加行间距了。
        if (itemIndex != (arrangedCount - 1) && !autoArrange) {
            yPos += context->vertSpace;
        }
        
        itemIndex++;
        
        //这里只对间距进行压缩比重的计算。
        lineTotalShrink += subviewTraits.topPosInner.shrink + subviewTraits.bottomPosInner.shrink;
    }
    
    maxLayoutWidth += context->paddingTrailing;
    
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = maxLayoutWidth;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll) {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((subviewEngines.count + layoutTraits.pagedCount - 1.0) / layoutTraits.pagedCount);
            if (_myCGFloatLess(context->selfSize.width, totalPages * CGRectGetWidth(self.superview.bounds))) {
                context->selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
            }
        }
        
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:context->selfSize.width subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }
    //根据flex规则：如果只有一行则整个宽度都作为子视图的拉伸和停靠区域。
    if (layoutTraits.isFlex && arranges == 1) {
        lineMaxWidth = context->selfSize.width - paddingHorz;
    }
    //最后一行
    [self myHorzLayoutCalculateSingleline:lineIndex horzAlignment:horzAlignment lineMaxWidth:lineMaxWidth lineMaxHeight:lineMaxHeight lineTotalShrink:lineTotalShrink startItemIndex:i - itemIndex itemCount:itemIndex withContext:context];
    
    //整体的停靠。
    if (context->horzGravity != MyGravity_None && context->selfSize.width != maxLayoutWidth && !(isHorzPaging && isPagingScroll)) {
        
        //根据flex标准：只有在多行下horzGravity才有意义。非flex标准则不受这个条件约束。
        if (arranges > 1 || !layoutTraits.isFlex) {
            CGFloat addXPos = 0.0;
            CGFloat between = 0.0;
            CGFloat fill = 0.0;
            
            if (arranges <= 1 && context->horzGravity == MyGravity_Horz_Around) {
                context->horzGravity = MyGravity_Horz_Center;
            }
            
            if (context->horzGravity == MyGravity_Horz_Center) {
                addXPos = (context->selfSize.width - maxLayoutWidth) / 2;
            } else if (context->horzGravity == MyGravity_Horz_Trailing) {
                addXPos = context->selfSize.width - maxLayoutWidth;
            } else if (context->horzGravity == MyGravity_Horz_Fill || context->horzGravity == MyGravity_Horz_Stretch) {
                if (arranges > 0) {
                    fill = (context->selfSize.width - maxLayoutWidth) / arranges;
                }
                //满足flex规则：如果剩余的空间是负数，该值等效于'flex-start'
                if (fill < 0.0 && context->horzGravity == MyGravity_Horz_Stretch) {
                    fill = 0.0;
                }
            } else if (context->horzGravity == MyGravity_Horz_Between) {
                if (arranges > 1) {
                    between = (context->selfSize.width - maxLayoutWidth) / (arranges - 1);
                }
            } else if (context->horzGravity == MyGravity_Horz_Around) {
                between = (context->selfSize.width - maxLayoutWidth) / arranges;
            } else if (context->horzGravity == MyGravity_Horz_Among) {
                between = (context->selfSize.width - maxLayoutWidth) / (arranges + 1);
            }
            
            if (addXPos != 0.0 || between != 0.0 || fill != 0.0) {
                for (int i = 0; i < subviewEngines.count; i++) {
                    
                    MyLayoutEngine *subviewEngine = subviewEngines[i];
                    
                    int lineidx = i / arrangedCount;
                    if (context->horzGravity == MyGravity_Horz_Stretch) {
                        MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;
                        if (subviewTraits.widthSizeInner.val == nil || (subviewTraits.widthSizeInner.wrapVal && ![subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                            subviewEngine.width += fill;
                        } else {
                            //因为每行都增加了fill。所以如果有行内对齐则需要这里调整。
                            MyGravity subviewHorzAlignment = [MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(subviewTraits.alignment)];
                            if (subviewHorzAlignment == MyGravity_None) {
                                subviewHorzAlignment = horzAlignment;
                            }
                            if (subviewHorzAlignment == MyGravity_Horz_Center) {
                                subviewEngine.leading += fill / 2.0;
                            } else if (subviewHorzAlignment == MyGravity_Horz_Trailing) {
                                subviewEngine.leading += fill;
                            }
                        }
                    } else {
                        subviewEngine.width += fill;
                    }
                    subviewEngine.leading += fill * lineidx;
                    
                    subviewEngine.leading += addXPos;
                    
                    subviewEngine.leading += between * lineidx;
                    
                    if (context->horzGravity == MyGravity_Horz_Around) {
                        subviewEngine.leading += (between / 2.0);
                    }
                    if (context->horzGravity == MyGravity_Horz_Among) {
                        subviewEngine.leading += between;
                    }
                }
            }
        }
    }
    
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = maxLayoutHeight + context->paddingBottom;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll) {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((subviewEngines.count + layoutTraits.pagedCount - 1.0) / layoutTraits.pagedCount);
            if (_myCGFloatLess(context->selfSize.height, totalPages * CGRectGetHeight(self.superview.bounds))) {
                context->selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
            }
        }
    }
}

@end

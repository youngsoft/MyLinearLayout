//
//  MyFloatLayout.m
//  MyLayout
//
//  Created by oybq on 16/2/18.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyFloatLayout.h"
#import "MyLayoutInner.h"

@implementation UIView (MyFloatLayoutExt)

- (void)setReverseFloat:(BOOL)reverseFloat {
    MyViewTraits *viewTraits = (MyViewTraits*)self.myDefaultSizeClass;
    if (viewTraits.isReverseFloat != reverseFloat) {
        viewTraits.reverseFloat = reverseFloat;
        if (self.superview != nil) {
            [self.superview setNeedsLayout];
        }
    }
}

- (BOOL)isReverseFloat {
    return self.myDefaultSizeClassInner.isReverseFloat;
}

- (void)setClearFloat:(BOOL)clearFloat {
    MyViewTraits *viewTraits = (MyViewTraits*)self.myDefaultSizeClass;
    if (viewTraits.clearFloat != clearFloat) {
        viewTraits.clearFloat = clearFloat;
        if (self.superview != nil) {
            [self.superview setNeedsLayout];
        }
    }
}

- (BOOL)clearFloat {
    return self.myDefaultSizeClassInner.clearFloat;
}

@end

@implementation MyFloatLayout

#pragma mark-- Public Methods

- (instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.myDefaultSizeClass.orientation = orientation;
    }
    return self;
}

- (instancetype)initWithOrientation:(MyOrientation)orientation {
    return [self initWithFrame:CGRectZero orientation:orientation];
}

+ (instancetype)floatLayoutWithOrientation:(MyOrientation)orientation {
    MyFloatLayout *layout = [[[self class] alloc] initWithOrientation:orientation];
    return layout;
}

- (void)setOrientation:(MyOrientation)orientation {
    MyFloatLayoutTraits *layoutTraits = (MyFloatLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.orientation != orientation) {
        layoutTraits.orientation = orientation;
        [self setNeedsLayout];
    }
}

- (MyOrientation)orientation {
    return self.myDefaultSizeClassInner.orientation;
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

    MyFloatLayoutTraits *layoutTraits = (MyFloatLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    context->subviewEngines = [layoutTraits filterEngines:subviewEngines];
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

    [self myCalcSubviewsWrapContentSize:context
                      withCustomSetting:^(MyViewTraits *subviewTraits) {
                          if (subviewTraits.widthSizeInner.wrapVal &&
                              orientation == MyOrientation_Vert &&
                              subviewTraits.weight != 0 &&
                              [subviewTraits.view isKindOfClass:[MyBaseLayout class]])
                              [subviewTraits.widthSizeInner _myEqualTo:nil];

                          if (subviewTraits.heightSizeInner.wrapVal &&
                              orientation == MyOrientation_Horz &&
                              subviewTraits.weight != 0 &&
                              [subviewTraits.view isKindOfClass:[MyBaseLayout class]])
                              [subviewTraits.heightSizeInner _myEqualTo:nil];
                      }];

    if (orientation == MyOrientation_Vert) {
        [self myDoVertOrientationLayoutWithContext:context];
    } else {
        [self myDoHorzOrientationLayoutWithContext:context];
    }
    return [self myAdjustLayoutViewSizeWithContext:context];
}

- (id)createSizeClassInstance {
    return [MyFloatLayoutTraits new];
}

#pragma mark-- Private Methods

- (CGPoint)myFindTrailingCandidatePoint:(CGRect)leadingCandidateRect width:(CGFloat)width trailingBoundary:(CGFloat)trailingBoundary trailingCandidateRects:(NSArray *)trailingCandidateRects hasWeight:(BOOL)hasWeight paddingTop:(CGFloat)paddingTop {
    CGPoint retPoint = {trailingBoundary, CGFLOAT_MAX};

    CGFloat lastHeight = paddingTop;
    for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--) {
        CGRect trailingCandidateRect = ((NSValue *)trailingCandidateRects[i]).CGRectValue;

        //如果有比重则不能相等只能小于。
        if ((hasWeight ? _myCGFloatLess(CGRectGetMaxX(leadingCandidateRect) + width, CGRectGetMinX(trailingCandidateRect)) : _myCGFloatLessOrEqual(CGRectGetMaxX(leadingCandidateRect) + width, CGRectGetMinX(trailingCandidateRect))) &&
            _myCGFloatGreat(CGRectGetMaxY(leadingCandidateRect), lastHeight)) {
            retPoint.y = _myCGFloatMax(CGRectGetMinY(leadingCandidateRect), lastHeight);
            retPoint.x = CGRectGetMinX(trailingCandidateRect);

            if (hasWeight &&
                CGRectGetHeight(leadingCandidateRect) == CGFLOAT_MAX &&
                CGRectGetWidth(leadingCandidateRect) == 0 &&
                _myCGFloatGreatOrEqual(CGRectGetMinY(leadingCandidateRect), CGRectGetMaxY(trailingCandidateRect))) {
                retPoint.x = trailingBoundary;
            }

            break;
        }

        lastHeight = CGRectGetMaxY(trailingCandidateRect);
    }

    if (retPoint.y == CGFLOAT_MAX) {
        if ((hasWeight ? _myCGFloatLess(CGRectGetMaxX(leadingCandidateRect) + width, trailingBoundary) : _myCGFloatLessOrEqual(CGRectGetMaxX(leadingCandidateRect) + width, trailingBoundary)) &&
            _myCGFloatGreat(CGRectGetMaxY(leadingCandidateRect), lastHeight)) {
            retPoint.y = _myCGFloatMax(CGRectGetMinY(leadingCandidateRect), lastHeight);
        }
    }

    return retPoint;
}

- (CGPoint)myFindBottomCandidatePoint:(CGRect)topCandidateRect height:(CGFloat)height bottomBoundary:(CGFloat)bottomBoundary bottomCandidateRects:(NSArray *)bottomCandidateRects hasWeight:(BOOL)hasWeight paddingLeading:(CGFloat)paddingLeading {
    CGPoint retPoint = {CGFLOAT_MAX, bottomBoundary};
    CGFloat lastWidth = paddingLeading;
    for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--) {
        CGRect bottomCandidateRect = ((NSValue *)bottomCandidateRects[i]).CGRectValue;

        if ((hasWeight ? _myCGFloatLess(CGRectGetMaxY(topCandidateRect) + height, CGRectGetMinY(bottomCandidateRect)) : _myCGFloatLessOrEqual(CGRectGetMaxY(topCandidateRect) + height, CGRectGetMinY(bottomCandidateRect))) &&
            _myCGFloatGreat(CGRectGetMaxX(topCandidateRect), lastWidth)) {
            retPoint.x = _myCGFloatMax(CGRectGetMinX(topCandidateRect), lastWidth);
            retPoint.y = CGRectGetMinY(bottomCandidateRect);

            if (hasWeight &&
                CGRectGetWidth(topCandidateRect) == CGFLOAT_MAX &&
                CGRectGetHeight(topCandidateRect) == 0 &&
                _myCGFloatGreatOrEqual(CGRectGetMinX(topCandidateRect), CGRectGetMaxX(bottomCandidateRect))) {
                retPoint.y = bottomBoundary;
            }
            break;
        }
        lastWidth = CGRectGetMaxX(bottomCandidateRect);
    }

    if (retPoint.x == CGFLOAT_MAX) {
        if ((hasWeight ? _myCGFloatLess(CGRectGetMaxY(topCandidateRect) + height, bottomBoundary) : _myCGFloatLessOrEqual(CGRectGetMaxY(topCandidateRect) + height, bottomBoundary)) &&
            _myCGFloatGreat(CGRectGetMaxX(topCandidateRect), lastWidth)) {
            retPoint.x = _myCGFloatMax(CGRectGetMinX(topCandidateRect), lastWidth);
        }
    }
    return retPoint;
}

- (CGPoint)myFindLeadingCandidatePoint:(CGRect)trailingCandidateRect width:(CGFloat)width leadingBoundary:(CGFloat)leadingBoundary leadingCandidateRects:(NSArray *)leadingCandidateRects hasWeight:(BOOL)hasWeight paddingTop:(CGFloat)paddingTop {
    CGPoint retPoint = {leadingBoundary, CGFLOAT_MAX};
    CGFloat lastHeight = paddingTop;
    for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--) {
        CGRect leadingCandidateRect = ((NSValue *)leadingCandidateRects[i]).CGRectValue;

        if ((hasWeight ? _myCGFloatGreat(CGRectGetMinX(trailingCandidateRect) - width, CGRectGetMaxX(leadingCandidateRect)) : _myCGFloatGreatOrEqual(CGRectGetMinX(trailingCandidateRect) - width, CGRectGetMaxX(leadingCandidateRect))) &&
            _myCGFloatGreat(CGRectGetMaxY(trailingCandidateRect), lastHeight)) {
            retPoint.y = _myCGFloatMax(CGRectGetMinY(trailingCandidateRect), lastHeight);
            retPoint.x = CGRectGetMaxX(leadingCandidateRect);
            if (hasWeight &&
                CGRectGetHeight(trailingCandidateRect) == CGFLOAT_MAX &&
                CGRectGetWidth(trailingCandidateRect) == 0 &&
                _myCGFloatGreatOrEqual(CGRectGetMinY(trailingCandidateRect), CGRectGetMaxY(leadingCandidateRect))) {
                retPoint.x = leadingBoundary;
            }
            break;
        }
        lastHeight = CGRectGetMaxY(leadingCandidateRect);
    }

    if (retPoint.y == CGFLOAT_MAX) {
        if ((hasWeight ? _myCGFloatGreat(CGRectGetMinX(trailingCandidateRect) - width, leadingBoundary) : _myCGFloatGreatOrEqual(CGRectGetMinX(trailingCandidateRect) - width, leadingBoundary)) &&
            _myCGFloatGreat(CGRectGetMaxY(trailingCandidateRect), lastHeight)) {
            retPoint.y = _myCGFloatMax(CGRectGetMinY(trailingCandidateRect), lastHeight);
        }
    }
    return retPoint;
}

- (CGPoint)myFindTopCandidatePoint:(CGRect)bottomCandidateRect height:(CGFloat)height topBoundary:(CGFloat)topBoundary topCandidateRects:(NSArray *)topCandidateRects hasWeight:(BOOL)hasWeight paddingLeading:(CGFloat)paddingLeading {
    CGPoint retPoint = {CGFLOAT_MAX, topBoundary};

    CGFloat lastWidth = paddingLeading;
    for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--) {
        CGRect topCandidateRect = ((NSValue *)topCandidateRects[i]).CGRectValue;

        if ((hasWeight ? _myCGFloatGreat(CGRectGetMinY(bottomCandidateRect) - height, CGRectGetMaxY(topCandidateRect)) : _myCGFloatGreatOrEqual(CGRectGetMinY(bottomCandidateRect) - height, CGRectGetMaxY(topCandidateRect))) &&
            _myCGFloatGreat(CGRectGetMaxX(bottomCandidateRect), lastWidth)) {
            retPoint.x = _myCGFloatMax(CGRectGetMinX(bottomCandidateRect), lastWidth);
            retPoint.y = CGRectGetMaxY(topCandidateRect);

            if (hasWeight &&
                CGRectGetWidth(bottomCandidateRect) == CGFLOAT_MAX &&
                CGRectGetHeight(bottomCandidateRect) == 0 &&
                _myCGFloatGreatOrEqual(CGRectGetMinX(bottomCandidateRect), CGRectGetMaxX(topCandidateRect))) {
                retPoint.y = topBoundary;
            }
            break;
        }

        lastWidth = CGRectGetMaxX(topCandidateRect);
    }

    if (retPoint.x == CGFLOAT_MAX) {
        if ((hasWeight ? _myCGFloatGreat(CGRectGetMinY(bottomCandidateRect) - height, topBoundary) : _myCGFloatGreatOrEqual(CGRectGetMinY(bottomCandidateRect) - height, topBoundary)) &&
            _myCGFloatGreat(CGRectGetMaxX(bottomCandidateRect), lastWidth)) {
            retPoint.x = _myCGFloatMax(CGRectGetMinX(bottomCandidateRect), lastWidth);
        }
    }

    return retPoint;
}

- (void)myCalcSubviewsSize:(CGFloat)specialMeasure isWidth:(BOOL)isWidth withContext:(MyLayoutContext *)context {
    //设置子视图的宽度和高度。
    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        if (specialMeasure != 0.0) {
            if (isWidth) {
                subviewEngine.width = specialMeasure;
            } else {
                subviewEngine.height = specialMeasure;
            }
        }

        subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

        subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

        if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况
            subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
            subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }

        if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) { //特殊处理宽度等于高度的情况
            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }
    }
}

- (void)myDoVertOrientationLayoutWithContext:(MyLayoutContext *)context {
    MyFloatLayoutTraits *layoutTraits = (MyFloatLayoutTraits*)context->layoutViewEngine.currentSizeClass;

    BOOL isBeyondFlag = NO; //子视图是否超出剩余空间需要换行。
    
    if (layoutTraits.widthSizeInner.wrapVal) {
        //如果有最大限制则取最大值，解决那种宽度自适应，但是有最大值需要换行的情况。
        context->selfSize.width = [self myGetBoundLimitMeasure:layoutTraits.widthSizeInner.uBoundValInner subview:self anchorType:layoutTraits.widthSizeInner.anchorType subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size isUBound:YES];
    }

    //支持浮动水平间距。
    CGFloat subviewWidth = [layoutTraits.flexSpace calcMaxMinSubviewSizeForContent:context->selfSize.width paddingStart:&context->paddingLeading paddingEnd:&context->paddingTrailing space:&context->horzSpace];

    //计算所有子视图的宽度和高度。
    [self myCalcSubviewsSize:subviewWidth isWidth:YES withContext:context];

    //左边候选区域数组，保存的是CGRect值。
    NSMutableArray *leadingCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最左边的个虚拟区域作为一个候选区域
    [leadingCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(context->paddingLeading, context->paddingTop, 0, CGFLOAT_MAX)]];

    //右边候选区域数组，保存的是CGRect值。
    NSMutableArray *trailingCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最右边的个虚拟区域作为一个候选区域
    [trailingCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(context->selfSize.width - context->paddingTrailing, context->paddingTop, 0, CGFLOAT_MAX)]];

    //分别记录左边和右边的最后一个视图在Y轴的偏移量
    CGFloat leadingLastYOffset = context->paddingTop;
    CGFloat trailingLastYOffset = context->paddingTop;

    //分别记录左右边和全局浮动视图的最高占用的Y轴的值
    CGFloat leadingMaxHeight = context->paddingTop;
    CGFloat trailingMaxHeight = context->paddingTop;
    CGFloat maxLayoutHeight = context->paddingTop;
    CGFloat maxLayoutWidth = context->paddingLeading;

    //记录是否有子视图设置了对齐，如果设置了对齐就会在后面对每行子视图做对齐处理。
    BOOL subviewHasAlignment = NO;
    NSMutableIndexSet *lineIndexes = [NSMutableIndexSet new];

    for (NSInteger idx = 0; idx < context->subviewEngines.count; idx++) {
        MyLayoutEngine *subviewEngine = context->subviewEngines[idx];
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;

        CGFloat topSpacing = subviewTraits.topPosInner.measure;
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;

        //只要有一个子视图设置了对齐，就会做对齐处理，否则不会，这里这样做是为了对后面的对齐计算做优化。
        subviewHasAlignment |= (MYVERTGRAVITY(subviewTraits.alignment) > MyGravity_Vert_Top);

        //如果是RTL的场景则默认是右对齐的。
        if (subviewTraits.isReverseFloat) {
#ifdef DEBUG
            //异常崩溃：当布局视图设置了宽度值为MyLayoutSize.wrap时，子视图不能逆向浮动
            NSCAssert(!layoutTraits.widthSizeInner.wrapVal, @"Constraint exception！！, vertical float layout:%@ can not set width to MyLayoutSize.wrap when the subview:%@ set reverseFloat to YES.", self, subviewTraits.view);
#endif

            CGPoint nextPoint = {context->selfSize.width - context->paddingTrailing, leadingLastYOffset};
            CGFloat leadingCandidateXBoundary = context->paddingLeading;
            if (subviewTraits.clearFloat) {
                //找到最底部的位置。
                nextPoint.y = _myCGFloatMax(trailingMaxHeight, leadingLastYOffset);
                CGPoint leadingPoint = [self myFindLeadingCandidatePoint:CGRectMake(context->selfSize.width - context->paddingTrailing, nextPoint.y, 0, CGFLOAT_MAX) width:leadingSpacing + (subviewTraits.weight != 0 ? 0 : subviewEngine.width) + trailingSpacing leadingBoundary:context->paddingLeading leadingCandidateRects:leadingCandidateRects hasWeight:subviewTraits.weight != 0 paddingTop:context->paddingTop];
                if (leadingPoint.y != CGFLOAT_MAX) {
                    nextPoint.y = _myCGFloatMax(trailingMaxHeight, leadingPoint.y);
                    leadingCandidateXBoundary = leadingPoint.x;
                }
            } else {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--) {
                    CGRect candidateRect = ((NSValue *)trailingCandidateRects[i]).CGRectValue;
                    CGPoint leadingPoint = [self myFindLeadingCandidatePoint:candidateRect width:leadingSpacing + (subviewTraits.weight != 0 ? 0 :subviewEngine.width) + trailingSpacing leadingBoundary:context->paddingLeading leadingCandidateRects:leadingCandidateRects hasWeight:subviewTraits.weight != 0 paddingTop:context->paddingTop];
                    if (leadingPoint.y != CGFLOAT_MAX) {
                        nextPoint = CGPointMake(CGRectGetMinX(candidateRect), _myCGFloatMax(nextPoint.y, leadingPoint.y));
                        leadingCandidateXBoundary = leadingPoint.x;
                        break;
                    }

                    nextPoint.y = CGRectGetMaxY(candidateRect);
                }
            }

            //重新设置宽度
            if (subviewTraits.weight != 0.0) {
                subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:(nextPoint.x - leadingCandidateXBoundary + subviewTraits.widthSizeInner.addVal) * subviewTraits.weight - leadingSpacing - trailingSpacing subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

                //特殊处理高度等于宽度，并且高度依赖宽度的情况。
                if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) {
                    subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
                    subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                }

                //特殊处理高度包裹的场景
                if (subviewTraits.heightSizeInner.wrapVal) {
                    subviewEngine.height = [self mySubview:subviewTraits wrapHeightSizeFits:subviewEngine.size withContext:context];
                    subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                }
            }

            subviewEngine.leading = nextPoint.x - trailingSpacing - subviewEngine.width;
            subviewEngine.top = _myCGFloatMin(nextPoint.y, maxLayoutHeight) + topSpacing;

            //如果有智能边界线则找出所有智能边界线。
            if (!context->isEstimate && self.intelligentBorderline != nil) {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                    MyBaseLayout *sublayout = (MyBaseLayout *)subviewTraits.view;
                    if (!sublayout.notUseIntelligentBorderline) {
                        sublayout.bottomBorderline = nil;
                        sublayout.topBorderline = nil;
                        sublayout.trailingBorderline = nil;
                        sublayout.leadingBorderline = nil;

                        if (_myCGFloatLess(subviewEngine.leading + subviewEngine.width + trailingSpacing, context->selfSize.width - context->paddingTrailing)) {
                            sublayout.trailingBorderline = self.intelligentBorderline;
                        }

                        if (_myCGFloatLess(subviewEngine.top + subviewEngine.height + bottomSpacing, context->selfSize.height - context->paddingBottom)) {
                            sublayout.bottomBorderline = self.intelligentBorderline;
                        }

                        if (_myCGFloatGreat(subviewEngine.leading, leadingCandidateXBoundary) && subviewEngine == context->subviewEngines.lastObject) {
                            sublayout.leadingBorderline = self.intelligentBorderline;
                        }
                    }
                }
            }

            //这里有可能子视图本身的宽度会超过布局视图本身，但是我们的候选区域则不存储超过的宽度部分。
            CGRect cRect = CGRectMake(_myCGFloatMax((subviewEngine.leading - leadingSpacing - context->horzSpace), context->paddingLeading), subviewEngine.top - topSpacing, _myCGFloatMin((subviewEngine.width + leadingSpacing + trailingSpacing), (context->selfSize.width - context->paddingLeading - context->paddingTrailing)), subviewEngine.height + topSpacing + bottomSpacing + context->vertSpace);

            //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
            for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--) {
                CGRect candidateRect = ((NSValue *)trailingCandidateRects[i]).CGRectValue;
                if (_myCGFloatLessOrEqual(CGRectGetMaxY(candidateRect), CGRectGetMaxY(cRect))) {
                    [trailingCandidateRects removeObjectAtIndex:i];
                }
            }

            //删除左边高度小于新添加区域的顶部的候选区域
            for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--) {
                CGRect candidateRect = ((NSValue *)leadingCandidateRects[i]).CGRectValue;

                CGFloat candidateMaxY = CGRectGetMaxY(candidateRect);
                CGFloat candidateMaxX = CGRectGetMaxX(candidateRect);
                CGFloat cMinx = CGRectGetMinX(cRect);

                if (_myCGFloatLessOrEqual(candidateMaxY, CGRectGetMinY(cRect))) {
                    [leadingCandidateRects removeObjectAtIndex:i];
                } else if (_myCGFloatEqual(candidateMaxY, CGRectGetMaxY(cRect)) && _myCGFloatLessOrEqual(cMinx, candidateMaxX)) {
                    [leadingCandidateRects removeObjectAtIndex:i];
                    cRect = CGRectUnion(cRect, candidateRect);
                    cRect.size.width += candidateMaxX - cMinx;
                }
            }

            //记录每一行的最大子视图位置的索引值。
            if (trailingLastYOffset != subviewEngine.top - topSpacing) {
                [lineIndexes addIndex:idx - 1];
            }
            [trailingCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            trailingLastYOffset = subviewEngine.top - topSpacing;

            if (_myCGFloatGreat(subviewEngine.top + subviewEngine.height + bottomSpacing + context->vertSpace, trailingMaxHeight)) {
                trailingMaxHeight = subviewEngine.top + subviewEngine.height + bottomSpacing + context->vertSpace;
            }
        } else {
            CGPoint nextPoint = {context->paddingLeading, trailingLastYOffset};
            CGFloat trailingCandidateXBoundary = context->selfSize.width - context->paddingTrailing;

            //如果是清除了浮动则直换行移动到最下面。
            if (subviewTraits.clearFloat) {
                //找到最低点。
                nextPoint.y = _myCGFloatMax(leadingMaxHeight, trailingLastYOffset);

                CGPoint trailingPoint = [self myFindTrailingCandidatePoint:CGRectMake(context->paddingLeading, nextPoint.y, 0, CGFLOAT_MAX) width:leadingSpacing + (subviewTraits.weight != 0 ? 0 : subviewEngine.width) + trailingSpacing trailingBoundary:trailingCandidateXBoundary trailingCandidateRects:trailingCandidateRects hasWeight:subviewTraits.weight != 0 paddingTop:context->paddingTop];
                if (trailingPoint.y != CGFLOAT_MAX) {
                    nextPoint.y = _myCGFloatMax(leadingMaxHeight, trailingPoint.y);
                    trailingCandidateXBoundary = trailingPoint.x;
                }
            } else {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--) {
                    CGRect candidateRect = ((NSValue *)leadingCandidateRects[i]).CGRectValue;

                    CGPoint trailingPoint = [self myFindTrailingCandidatePoint:candidateRect width:leadingSpacing + (subviewTraits.weight != 0 ? 0 : subviewEngine.width) + trailingSpacing trailingBoundary:context->selfSize.width - context->paddingTrailing trailingCandidateRects:trailingCandidateRects hasWeight:subviewTraits.weight != 0 paddingTop:context->paddingTop];
                    if (trailingPoint.y != CGFLOAT_MAX) {
                        nextPoint = CGPointMake(CGRectGetMaxX(candidateRect), _myCGFloatMax(nextPoint.y, trailingPoint.y));
                        trailingCandidateXBoundary = trailingPoint.x;
                        break;
                    } else { //这里表明剩余空间放不下了。
                        isBeyondFlag = YES;
                    }
                    nextPoint.y = CGRectGetMaxY(candidateRect);
                }
            }

            //重新设置宽度
            if (subviewTraits.weight != 0) {
#ifdef DEBUG
                //异常崩溃：当布局视图设置了宽度值为MyLayoutSize.wrap 子视图不能设置weight大于0
                NSCAssert(!layoutTraits.widthSizeInner.wrapVal, @"Constraint exception！！, vertical float layout:%@ can not set width to MyLayoutSize.wrap when the subview:%@ set weight big than zero.", self, subviewTraits.view);
#endif
                subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:(trailingCandidateXBoundary - nextPoint.x + subviewTraits.widthSizeInner.addVal) * subviewTraits.weight - leadingSpacing - trailingSpacing subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

                //特殊处理高度等于宽度，并且高度依赖宽度的情况。
                if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) {
                    subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
                    subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                }

                //特殊处理高度包裹的场景
                if (subviewTraits.heightSizeInner.wrapVal) {
                    subviewEngine.height = [self mySubview:subviewTraits wrapHeightSizeFits:subviewEngine.size withContext:context];
                    subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                }
            }

            subviewEngine.leading = nextPoint.x + leadingSpacing;
            subviewEngine.top = _myCGFloatMin(nextPoint.y, maxLayoutHeight) + topSpacing;

            if (!context->isEstimate && self.intelligentBorderline != nil) {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                    MyBaseLayout *sublayout = (MyBaseLayout *)subviewTraits.view;

                    if (!sublayout.notUseIntelligentBorderline) {
                        sublayout.bottomBorderline = nil;
                        sublayout.topBorderline = nil;
                        sublayout.trailingBorderline = nil;
                        sublayout.leadingBorderline = nil;

                        if (_myCGFloatLess(subviewEngine.leading + subviewEngine.width + trailingSpacing, context->selfSize.width - context->paddingTrailing)) {
                            sublayout.trailingBorderline = self.intelligentBorderline;
                        }

                        if (_myCGFloatLess(subviewEngine.top + subviewEngine.height + bottomSpacing, context->selfSize.height - context->paddingBottom)) {
                            sublayout.bottomBorderline = self.intelligentBorderline;
                        }
                    }
                }
            }

            CGRect cRect = CGRectMake(subviewEngine.leading - leadingSpacing, subviewEngine.top - topSpacing, _myCGFloatMin((subviewEngine.width + leadingSpacing + trailingSpacing + context->horzSpace), (context->selfSize.width - context->paddingLeading - context->paddingTrailing)), subviewEngine.height + topSpacing + bottomSpacing + context->vertSpace);

            //把新添加到候选中去。并删除高度小于的候选键。和高度
            for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--) {
                CGRect candidateRect = ((NSValue *)leadingCandidateRects[i]).CGRectValue;

                if (_myCGFloatLessOrEqual(CGRectGetMaxY(candidateRect), CGRectGetMaxY(cRect))) {
                    [leadingCandidateRects removeObjectAtIndex:i];
                }
            }

            //删除右边高度小于新添加区域的顶部的候选区域
            for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--) {
                CGRect candidateRect = ((NSValue *)trailingCandidateRects[i]).CGRectValue;
                CGFloat candidateMaxY = CGRectGetMaxY(candidateRect);
                CGFloat candidateMinX = CGRectGetMinX(candidateRect);
                CGFloat cMaxX = CGRectGetMaxX(cRect);
                if (_myCGFloatLessOrEqual(candidateMaxY, CGRectGetMinY(cRect))) {
                    [trailingCandidateRects removeObjectAtIndex:i];
                } else if (_myCGFloatEqual(candidateMaxY, CGRectGetMaxY(cRect)) && _myCGFloatLessOrEqual(candidateMinX, cMaxX)) { //当右边的高度和cRect的高度相等，又有重合时表明二者可以合并为一个区域。
                    [trailingCandidateRects removeObjectAtIndex:i];
                    cRect = CGRectUnion(cRect, candidateRect);
                    cRect.size.width += cMaxX - candidateMinX; //要加上重叠部分来增加宽度，否则会出现宽度不正确的问题。
                }
            }

            //记录每一行的最大子视图位置的索引值。
            if (leadingLastYOffset != subviewEngine.top - topSpacing) {
                [lineIndexes addIndex:idx - 1];
            }
            [leadingCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            leadingLastYOffset = subviewEngine.top - topSpacing;

            if (_myCGFloatGreat(subviewEngine.top + subviewEngine.height + bottomSpacing + context->vertSpace, leadingMaxHeight)) {
                leadingMaxHeight = subviewEngine.top + subviewEngine.height + bottomSpacing + context->vertSpace;
            }
        }

        if (_myCGFloatGreat(subviewEngine.top + subviewEngine.height + bottomSpacing + context->vertSpace, maxLayoutHeight)) {
            maxLayoutHeight = subviewEngine.top + subviewEngine.height + bottomSpacing + context->vertSpace;
        }
        if (_myCGFloatGreat(subviewEngine.leading + subviewEngine.width + trailingSpacing + context->horzSpace, maxLayoutWidth)) {
            maxLayoutWidth = subviewEngine.leading + subviewEngine.width + trailingSpacing + context->horzSpace;
        }
    }

    if (context->subviewEngines.count > 0) {
        maxLayoutHeight -= context->vertSpace;
        maxLayoutWidth -= context->horzSpace;
    }

    maxLayoutWidth += context->paddingTrailing;
    if (layoutTraits.widthSizeInner.wrapVal) {
        //只有在设置了最大宽度限制并且超出了才认为最大宽度是限制宽度，否则是最大子视图宽度。
        if (context->selfSize.width == CGFLOAT_MAX || !isBeyondFlag) {
            context->selfSize.width = maxLayoutWidth;
        }
    }

    maxLayoutHeight += context->paddingBottom;
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:maxLayoutHeight subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }

    if (context->selfSize.height != maxLayoutHeight) {
        if (context->vertGravity != MyGravity_None) {
            CGFloat addYPos = 0.0;
            if (context->vertGravity == MyGravity_Vert_Center) {
                addYPos = (context->selfSize.height - maxLayoutHeight) / 2;
            } else if (context->vertGravity == MyGravity_Vert_Bottom) {
                addYPos = context->selfSize.height - maxLayoutHeight;
            }

            if (addYPos != 0.0) {
                for (int i = 0; i < context->subviewEngines.count; i++) {
                    context->subviewEngines[i].top += addYPos;
                }
            }
        }
    }

    //如果有子视图设置了对齐属性，那么就要对处在同一行内的子视图进行对齐设置。
    //对齐的规则是以行内最高的子视图作为参考的对象，其他的子视图按照行内最高子视图进行垂直对齐的调整。
    if (subviewHasAlignment) {
        //最后一行。
        if (context->subviewEngines.count > 0) {
            [lineIndexes addIndex:context->subviewEngines.count - 1];
        }
       __block NSInteger lineFirstIndex = 0;
       [lineIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL lineHasAlignment = NO;

            //计算每行内的最高的子视图，作为行对齐的标准。
            CGFloat lineMaxHeight = 0;
            for (NSInteger i = lineFirstIndex; i <= idx; i++) {
                MyLayoutEngine *subviewEngine = context->subviewEngines[i];
                MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
                if (subviewEngine.height > lineMaxHeight) {
                    lineMaxHeight = subviewEngine.height;
                }
                lineHasAlignment |= (MYVERTGRAVITY(subviewTraits.alignment) > MyGravity_Vert_Top);
            }

            //设置行内的对齐
            if (lineHasAlignment) {
                CGFloat baselinePos = CGFLOAT_MAX;
                for (NSInteger i = lineFirstIndex; i <= idx; i++) {
                    MyLayoutEngine *subviewEngine = context->subviewEngines[i];
                    MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
                    MyGravity subviewVertAlignment = MYVERTGRAVITY(subviewTraits.alignment);
                    UIFont *subviewFont = nil;
                    if (subviewVertAlignment == MyGravity_Vert_Baseline) {
                        subviewFont = [self myGetSubviewFont:subviewTraits.view];
                        if (subviewFont == nil) {
                            subviewVertAlignment = MyGravity_Vert_Top;
                        }
                    }

                    switch (subviewVertAlignment) {
                        case MyGravity_Vert_Center:
                            subviewEngine.top += (lineMaxHeight - subviewEngine.height) / 2.0;
                            break;
                        case MyGravity_Vert_Bottom:
                            subviewEngine.top += (lineMaxHeight - subviewEngine.height);
                            break;
                        case MyGravity_Vert_Fill:
                            subviewEngine.height = lineMaxHeight;
                            break;
                        case MyGravity_Vert_Stretch: {
                            if (subviewTraits.heightSizeInner.val == nil || (subviewTraits.heightSizeInner.wrapVal && ![subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                                subviewEngine.height = lineMaxHeight;
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

            lineFirstIndex = idx + 1;
       }];
    }
}

- (void)myDoHorzOrientationLayoutWithContext:(MyLayoutContext *)context {
    MyFloatLayoutTraits *layoutTraits = (MyFloatLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    //如果没有边界限制我们将高度设置为最大。。
    BOOL isBeyondFlag = NO; //子视图是否超出剩余空间需要换行。
    if (layoutTraits.heightSizeInner.wrapVal) {
        //如果有最大限制则取最大值，解决那种高度自适应，但是有最大值需要换行的情况。
        context->selfSize.height = [self myGetBoundLimitMeasure:layoutTraits.heightSizeInner.uBoundValInner subview:self anchorType:layoutTraits.heightSizeInner.anchorType subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size isUBound:YES];
    }

    //支持浮动垂直间距。
     CGFloat subviewHeight = [layoutTraits.flexSpace calcMaxMinSubviewSizeForContent:context->selfSize.height paddingStart:&context->paddingTop paddingEnd:&context->paddingBottom space:&context->vertSpace];

    //设置子视图的宽度和高度。
    [self myCalcSubviewsSize:subviewHeight isWidth:NO withContext:context];

    //上边候选区域数组，保存的是CGRect值。
    NSMutableArray *topCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最上边的个虚拟区域作为一个候选区域
    [topCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(context->paddingLeading, context->paddingTop, CGFLOAT_MAX, 0)]];

    //下边候选区域数组，保存的是CGRect值。
    NSMutableArray *bottomCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最下边的个虚拟区域作为一个候选区域,如果没有边界限制则
    [bottomCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(context->paddingLeading, context->selfSize.height - context->paddingBottom, CGFLOAT_MAX, 0)]];

    //分别记录上边和下边的最后一个视图在X轴的偏移量
    CGFloat topLastXOffset = context->paddingLeading;
    CGFloat bottomLastXOffset = context->paddingLeading;

    //分别记录上下边和全局浮动视图的最宽占用的X轴的值
    CGFloat topMaxWidth = context->paddingLeading;
    CGFloat bottomMaxWidth = context->paddingLeading;
    CGFloat maxLayoutWidth = context->paddingLeading;
    CGFloat maxLayoutHeight = context->paddingTop;

    //记录是否有子视图设置了对齐，如果设置了对齐就会在后面对每行子视图做对齐处理。
    BOOL subviewHasAlignment = NO;
    NSMutableIndexSet *lineIndexes = [NSMutableIndexSet new];

    for (NSInteger idx = 0; idx < subviewEngines.count; idx++) {
        MyLayoutEngine *subviewEngine = subviewEngines[idx];
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;

        CGFloat topSpacing = subviewTraits.topPosInner.measure;
        CGFloat leadingSpacing = subviewTraits.leadingPosInner.measure;
        CGFloat bottomSpacing = subviewTraits.bottomPosInner.measure;
        CGFloat trailingSpacing = subviewTraits.trailingPosInner.measure;
        
        //只要有一个子视图设置了对齐，就会做对齐处理，否则不会，这里这样做是为了对后面的对齐计算做优化。
        subviewHasAlignment |= (MYHORZGRAVITY(subviewTraits.alignment) > MyGravity_Horz_Left);

        if (subviewTraits.reverseFloat) {
#ifdef DEBUG
            //异常崩溃：当布局视图设置了高度为MyLayoutSize.wrap时子视图不能设置逆向浮动
            NSCAssert(!layoutTraits.heightSizeInner.wrapVal, @"Constraint exception！！, horizontal float layout:%@ can not set height to wrap when the subview:%@ set reverseFloat to YES.", self, subviewTraits.view);
#endif

            CGPoint nextPoint = {topLastXOffset, context->selfSize.height - context->paddingBottom};
            CGFloat topCandidateYBoundary = context->paddingTop;
            if (subviewTraits.clearFloat) {
                //找到最底部的位置。
                nextPoint.x = _myCGFloatMax(bottomMaxWidth, topLastXOffset);
                CGPoint topPoint = [self myFindTopCandidatePoint:CGRectMake(nextPoint.x, context->selfSize.height - context->paddingBottom, CGFLOAT_MAX, 0) height:topSpacing + (subviewTraits.weight != 0 ? 0 : subviewEngine.height) + bottomSpacing topBoundary:topCandidateYBoundary topCandidateRects:topCandidateRects hasWeight:subviewTraits.weight != 0 paddingLeading:context->paddingLeading];
                if (topPoint.x != CGFLOAT_MAX) {
                    nextPoint.x = _myCGFloatMax(bottomMaxWidth, topPoint.x);
                    topCandidateYBoundary = topPoint.y;
                }
            } else {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--) {
                    CGRect candidateRect = ((NSValue *)bottomCandidateRects[i]).CGRectValue;

                    CGPoint topPoint = [self myFindTopCandidatePoint:candidateRect height:topSpacing + (subviewTraits.weight != 0 ? 0 : subviewEngine.height) + bottomSpacing topBoundary:context->paddingTop topCandidateRects:topCandidateRects hasWeight:subviewTraits.weight != 0 paddingLeading:context->paddingLeading];
                    if (topPoint.x != CGFLOAT_MAX) {
                        nextPoint = CGPointMake(_myCGFloatMax(nextPoint.x, topPoint.x), CGRectGetMinY(candidateRect));
                        topCandidateYBoundary = topPoint.y;
                        break;
                    }

                    nextPoint.x = CGRectGetMaxX(candidateRect);
                }
            }

            if (subviewTraits.weight != 0.0) {
                subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:(nextPoint.y - topCandidateYBoundary + subviewTraits.heightSizeInner.addVal) * subviewTraits.weight - topSpacing - bottomSpacing subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

                //特殊处理宽度等于高度的问题。
                if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) {
                    subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:[subviewTraits.widthSizeInner measureWith:subviewEngine.height] subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                }
            }

            subviewEngine.top = nextPoint.y - bottomSpacing - subviewEngine.height;
            subviewEngine.leading = _myCGFloatMin(nextPoint.x, maxLayoutWidth) + leadingSpacing;

            //如果有智能边界线则找出所有智能边界线。
            if (!context->isEstimate && self.intelligentBorderline != nil) {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                    MyBaseLayout *sublayout = (MyBaseLayout *)subviewTraits.view;

                    if (!sublayout.notUseIntelligentBorderline) {
                        sublayout.bottomBorderline = nil;
                        sublayout.topBorderline = nil;
                        sublayout.trailingBorderline = nil;
                        sublayout.leadingBorderline = nil;

                        //如果自己的上边和左边有子视图。
                        if (_myCGFloatLess(subviewEngine.leading + subviewEngine.width + trailingSpacing, context->selfSize.width - context->paddingTrailing)) {
                            sublayout.trailingBorderline = self.intelligentBorderline;
                        }

                        if (_myCGFloatLess(subviewEngine.top + subviewEngine.height + bottomSpacing, context->selfSize.height - context->paddingBottom)) {
                            sublayout.bottomBorderline = self.intelligentBorderline;
                        }

                        if (_myCGFloatGreat(subviewEngine.top, topCandidateYBoundary) && subviewEngine == subviewEngines.lastObject) {
                            sublayout.topBorderline = self.intelligentBorderline;
                        }
                    }
                }
            }

            //这里有可能子视图本身的高度会超过布局视图本身，但是我们的候选区域则不存储超过的高度部分。
            CGRect cRect = CGRectMake(subviewEngine.leading - leadingSpacing, _myCGFloatMax((subviewEngine.top - topSpacing - context->vertSpace), context->paddingTop), subviewEngine.width + leadingSpacing + trailingSpacing + context->horzSpace, _myCGFloatMin((subviewEngine.height + topSpacing + bottomSpacing), (context->selfSize.height - context->paddingTop - context->paddingBottom)));

            //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
            for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--) {
                CGRect candidateRect = ((NSValue *)bottomCandidateRects[i]).CGRectValue;
                if (_myCGFloatLessOrEqual(CGRectGetMaxX(candidateRect), CGRectGetMaxX(cRect))) {
                    [bottomCandidateRects removeObjectAtIndex:i];
                }
            }

            //删除顶部宽度小于新添加区域的顶部的候选区域
            for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--) {
                CGRect candidateRect = ((NSValue *)topCandidateRects[i]).CGRectValue;

                CGFloat candidateMaxX = CGRectGetMaxX(candidateRect);
                CGFloat candidateMaxY = CGRectGetMaxY(candidateRect);
                CGFloat cMinY = CGRectGetMinY(cRect);

                if (_myCGFloatLessOrEqual(candidateMaxX, CGRectGetMinX(cRect))) {
                    [topCandidateRects removeObjectAtIndex:i];
                } else if (_myCGFloatEqual(candidateMaxX, CGRectGetMaxX(cRect)) && _myCGFloatLessOrEqual(cMinY, candidateMaxY)) {
                    [topCandidateRects removeObjectAtIndex:i];
                    cRect = CGRectUnion(cRect, candidateRect);
                    cRect.size.height += candidateMaxY - cMinY;
                }
            }

            //记录每一列的最大子视图位置的索引值。
            if (bottomLastXOffset != subviewEngine.leading - leadingSpacing) {
                [lineIndexes addIndex:idx - 1];
            }

            [bottomCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            bottomLastXOffset = subviewEngine.leading - leadingSpacing;

            if (_myCGFloatGreat(subviewEngine.leading + subviewEngine.width + trailingSpacing + context->horzSpace, bottomMaxWidth)) {
                bottomMaxWidth = subviewEngine.leading + subviewEngine.width + trailingSpacing + context->horzSpace;
            }
        } else {
            CGPoint nextPoint = {bottomLastXOffset, context->paddingTop};
            CGFloat bottomCandidateYBoundary = context->selfSize.height - context->paddingBottom;
            //如果是清除了浮动则直换行移动到最下面。
            if (subviewTraits.clearFloat) {
                //找到最低点。
                nextPoint.x = _myCGFloatMax(topMaxWidth, bottomLastXOffset);

                CGPoint bottomPoint = [self myFindBottomCandidatePoint:CGRectMake(nextPoint.x, context->paddingTop, CGFLOAT_MAX, 0) height:topSpacing + (subviewTraits.weight != 0 ? 0 : subviewEngine.height) + bottomSpacing bottomBoundary:bottomCandidateYBoundary bottomCandidateRects:bottomCandidateRects hasWeight:subviewTraits.weight != 0 paddingLeading:context->paddingLeading];
                if (bottomPoint.x != CGFLOAT_MAX) {
                    nextPoint.x = _myCGFloatMax(topMaxWidth, bottomPoint.x);
                    bottomCandidateYBoundary = bottomPoint.y;
                }
            } else {

                //依次从后往前，每个都比较右边的。
                for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--) {
                    CGRect candidateRect = ((NSValue *)topCandidateRects[i]).CGRectValue;
                    CGPoint bottomPoint = [self myFindBottomCandidatePoint:candidateRect height:topSpacing + (subviewTraits.weight != 0 ? 0 : subviewEngine.height) + bottomSpacing bottomBoundary:context->selfSize.height - context->paddingBottom bottomCandidateRects:bottomCandidateRects hasWeight:subviewTraits.weight != 0 paddingLeading:context->paddingLeading];
                    if (bottomPoint.x != CGFLOAT_MAX) {
                        nextPoint = CGPointMake(_myCGFloatMax(nextPoint.x, bottomPoint.x), CGRectGetMaxY(candidateRect));
                        bottomCandidateYBoundary = bottomPoint.y;
                        break;
                    } else {
                        isBeyondFlag = YES;
                    }
                    nextPoint.x = CGRectGetMaxX(candidateRect);
                }
            }

            if (subviewTraits.weight != 0.0) {

#ifdef DEBUG
                //异常崩溃：当布局视图设置了高度为wrap时子视图不能设置weight大于0
                NSCAssert(!layoutTraits.heightSizeInner.wrapVal, @"Constraint exception！！, horizontal float layout:%@ can not set height to wrap when the subview:%@ set weight big than zero.", self, subviewTraits.view);
#endif

                subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subviewTraits.view calcSize:(bottomCandidateYBoundary - nextPoint.y + subviewTraits.heightSizeInner.addVal) * subviewTraits.weight - topSpacing - bottomSpacing subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

                if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) {
                    subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:[subviewTraits.widthSizeInner measureWith:subviewEngine.height] subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
                }
            }

            subviewEngine.top = nextPoint.y + topSpacing;
            subviewEngine.leading = _myCGFloatMin(nextPoint.x, maxLayoutWidth) + leadingSpacing;

            //如果有智能边界线则找出所有智能边界线。
            if (!context->isEstimate && self.intelligentBorderline != nil) {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                    MyBaseLayout *sublayout = (MyBaseLayout *)subviewTraits.view;
                    if (!sublayout.notUseIntelligentBorderline) {
                        sublayout.bottomBorderline = nil;
                        sublayout.topBorderline = nil;
                        sublayout.trailingBorderline = nil;
                        sublayout.leadingBorderline = nil;

                        //如果自己的上边和左边有子视图。
                        if (_myCGFloatLess(subviewEngine.leading + subviewEngine.width + trailingSpacing, context->selfSize.width - context->paddingTrailing)) {
                            sublayout.trailingBorderline = self.intelligentBorderline;
                        }

                        if (_myCGFloatLess(subviewEngine.top + subviewEngine.height + bottomSpacing, context->selfSize.height - context->paddingBottom)) {
                            sublayout.bottomBorderline = self.intelligentBorderline;
                        }
                    }
                }
            }

            CGRect cRect = CGRectMake(subviewEngine.leading - leadingSpacing, subviewEngine.top - topSpacing, subviewEngine.width + leadingSpacing + trailingSpacing + context->horzSpace, _myCGFloatMin((subviewEngine.height + topSpacing + bottomSpacing + context->vertSpace), (context->selfSize.height - context->paddingTop - context->paddingBottom)));

            //把新添加到候选中去。并删除宽度小于的最新候选区域的候选区域
            for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--) {
                CGRect candidateRect = ((NSValue *)topCandidateRects[i]).CGRectValue;

                if (_myCGFloatLessOrEqual(CGRectGetMaxX(candidateRect), CGRectGetMaxX(cRect))) {
                    [topCandidateRects removeObjectAtIndex:i];
                }
            }

            //删除顶部宽度小于新添加区域的顶部的候选区域
            for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--) {
                CGRect candidateRect = ((NSValue *)bottomCandidateRects[i]).CGRectValue;

                CGFloat candidateMaxX = CGRectGetMaxX(candidateRect);
                CGFloat candidateMinY = CGRectGetMinY(candidateRect);
                CGFloat cMaxY = CGRectGetMaxY(cRect);
                if (_myCGFloatLessOrEqual(candidateMaxX, CGRectGetMinX(cRect))) {
                    [bottomCandidateRects removeObjectAtIndex:i];
                } else if (_myCGFloatEqual(candidateMaxX, CGRectGetMaxX(cRect)) && _myCGFloatLessOrEqual(candidateMinY, cMaxY)) { //当右边的宽度和cRect的宽度相等，又有重合时表明二者可以合并为一个区域。
                    [bottomCandidateRects removeObjectAtIndex:i];
                    cRect = CGRectUnion(cRect, candidateRect);
                    cRect.size.height += cMaxY - candidateMinY; //要加上重叠部分来增加高度，否则会出现高度不正确的问题。
                }
            }

            //记录每一列的最大子视图位置的索引值。
            if (topLastXOffset != subviewEngine.leading - leadingSpacing) {
                [lineIndexes addIndex:idx - 1];
            }
            [topCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            topLastXOffset = subviewEngine.leading - leadingSpacing;

            if (_myCGFloatGreat(subviewEngine.leading + subviewEngine.width + trailingSpacing + context->horzSpace, topMaxWidth)) {
                topMaxWidth = subviewEngine.leading + subviewEngine.width + trailingSpacing + context->horzSpace;
            }
        }

        if (_myCGFloatGreat(subviewEngine.leading + subviewEngine.width + trailingSpacing + context->horzSpace, maxLayoutWidth)) {
            maxLayoutWidth = subviewEngine.leading + subviewEngine.width + trailingSpacing + context->horzSpace;
        }

        if (_myCGFloatGreat(subviewEngine.top + subviewEngine.height + bottomSpacing + context->vertSpace, maxLayoutHeight)) {
            maxLayoutHeight = subviewEngine.top + subviewEngine.height + bottomSpacing + context->vertSpace;
        }
    }

    if (subviewEngines.count > 0) {
        maxLayoutWidth -= context->horzSpace;
        maxLayoutHeight -= context->vertSpace;
    }

    maxLayoutHeight += context->paddingBottom;
    if (layoutTraits.heightSizeInner.wrapVal) {
        if (context->selfSize.height == CGFLOAT_MAX || !isBeyondFlag) {
            context->selfSize.height = maxLayoutHeight;
        }
    }

    maxLayoutWidth += context->paddingTrailing;
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:maxLayoutWidth subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }

    if (context->selfSize.width != maxLayoutWidth) {
        if (context->horzGravity != MyGravity_None) {
            CGFloat addXPos = 0.0;
            if (context->horzGravity == MyGravity_Horz_Center) {
                addXPos = (context->selfSize.width - maxLayoutWidth) / 2;
            } else if (context->horzGravity == MyGravity_Horz_Trailing) {
                addXPos = context->selfSize.width - maxLayoutWidth;
            }

            if (addXPos != 0.0) {
                for (int i = 0; i < subviewEngines.count; i++) {
                    subviewEngines[i].leading += addXPos;
                }
            }
        }
    }

    //如果有子视图设置了对齐属性，那么就要对处在同一列内的子视图进行对齐设置。
    //对齐的规则是以列内最宽的子视图作为参考的对象，其他的子视图按照列内最宽子视图进行水平对齐的调整。
    if (subviewHasAlignment) {
        //最后一列。
        if (subviewEngines.count > 0) {
            [lineIndexes addIndex:subviewEngines.count - 1];
        }
        __block NSInteger lineFirstIndex = 0;
        [lineIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL lineHasAlignment = NO;
            
            //计算每列内的最宽的子视图，作为列对齐的标准。
            CGFloat lineMaxWidth = 0;
            for (NSInteger i = lineFirstIndex; i <= idx; i++) {
                MyLayoutEngine *subviewEngine = subviewEngines[i];
                MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
                if (subviewEngine.width > lineMaxWidth) {
                    lineMaxWidth = subviewEngine.width;
                }
                lineHasAlignment |= (MYHORZGRAVITY(subviewTraits.alignment) > MyGravity_Horz_Left);
            }
            
            //设置行内的对齐
            if (lineHasAlignment) {
                for (NSInteger i = lineFirstIndex; i <= idx; i++) {
                    MyLayoutEngine *subviewEngine = subviewEngines[i];
                    MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
                    switch ([MyViewTraits convertLeadingTrailingGravityFromLeftRightGravity:MYHORZGRAVITY(subviewTraits.alignment)]) {
                        case MyGravity_Horz_Center:
                            subviewEngine.leading += (lineMaxWidth - subviewEngine.width) / 2.0;
                            break;
                        case MyGravity_Horz_Trailing:
                            subviewEngine.leading += (lineMaxWidth - subviewEngine.width);
                            break;
                        case MyGravity_Horz_Fill:
                            subviewEngine.width = lineMaxWidth;
                            break;
                        case MyGravity_Horz_Stretch: {
                            if (subviewTraits.widthSizeInner.val == nil || (subviewTraits.widthSizeInner.wrapVal && ![subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                                subviewEngine.width = lineMaxWidth;
                            }
                        } break;
                        default:
                            break;
                    }
                }
            }
            
            lineFirstIndex = idx + 1;
        }];
    }
}

@end

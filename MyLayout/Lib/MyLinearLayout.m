//
//  MyLinearLayout.m
//  MyLayout
//
//  Created by oybq on 15/2/12.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLinearLayout.h"
#import "MyLayoutInner.h"

@implementation MyLinearLayout

#pragma mark-- Public Methods

- (instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation {
    self = [super initWithFrame:frame];
    if (self) {
        MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits*)self.myDefaultSizeClass;
        if (orientation == MyOrientation_Vert) {
            [layoutTraits.heightSize _myEqualTo:@(MyLayoutSize.wrap) priority:MyPriority_Low]; //这是暂时先设置为低优先级,为了兼容老版本。
        } else {
            [layoutTraits.widthSize _myEqualTo:@(MyLayoutSize.wrap) priority:MyPriority_Low];
        }
        layoutTraits.orientation = orientation;
    }
    return self;
}

- (instancetype)initWithOrientation:(MyOrientation)orientation {
    return [self initWithFrame:CGRectZero orientation:orientation];
}

+ (instancetype)linearLayoutWithOrientation:(MyOrientation)orientation {
    return [[[self class] alloc] initWithOrientation:orientation];
}

- (void)setOrientation:(MyOrientation)orientation {
    MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.orientation != orientation) {
        layoutTraits.orientation = orientation;
        [self setNeedsLayout];
    }
}

- (MyOrientation)orientation {
    return self.myDefaultSizeClassInner.orientation;
}

- (void)setShrinkType:(MySubviewsShrinkType)shrinkType {
    MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits*)self.myDefaultSizeClass;
    if (layoutTraits.shrinkType != shrinkType) {
        layoutTraits.shrinkType = shrinkType;
        [self setNeedsLayout];
    }
}

- (MySubviewsShrinkType)shrinkType {
    return self.myDefaultSizeClassInner.shrinkType;
}

- (void)equalizeSubviews:(BOOL)centered {
    [self equalizeSubviews:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

- (void)equalizeSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass {
    [self equalizeSubviews:centered withSpace:CGFLOAT_MAX inSizeClass:sizeClass];
}

- (void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space {
    [self equalizeSubviews:centered withSpace:space inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

- (void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space inSizeClass:(MySizeClass)sizeClass {
    NSArray *tuple = [self myUpdateCurrentSizeClass:sizeClass subviews:nil];
    MyLayoutEngine *layoutViewEngine = tuple.firstObject;
    NSMutableArray<MyLayoutEngine *> *subviewEngines = tuple.lastObject;
    
    MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits*)layoutViewEngine.currentSizeClass;
    subviewEngines = [layoutTraits filterEngines:subviewEngines];
    [self myEqualizeSubviewEngines:subviewEngines orientation:layoutTraits.orientation centered:centered space:space];
    [self setNeedsLayout];
}

- (void)equalizeSubviewsSpace:(BOOL)centered {
    [self equalizeSubviewsSpace:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

- (void)equalizeSubviewsSpace:(BOOL)centered inSizeClass:(MySizeClass)sizeClass {
    NSArray *tuple = [self myUpdateCurrentSizeClass:sizeClass subviews:nil];
    MyLayoutEngine *layoutViewEngine = tuple.firstObject;
    NSMutableArray<MyLayoutEngine *> *subviewEngines = tuple.lastObject;
    
    MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits*)layoutViewEngine.currentSizeClass;
    subviewEngines = [layoutTraits filterEngines:subviewEngines];
    [self myEqualizeSubviewEngines:subviewEngines orientation:layoutTraits.orientation centered:centered];
    [self setNeedsLayout];
}

- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered {
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace centered:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

- (void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered inSizeClass:(MySizeClass)sizeClass {
    MySequentLayoutTraits *layoutTraits = (MySequentLayoutTraits *)[self fetchLayoutSizeClass:sizeClass];
    if (subviewSize == 0.0) {
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

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];
    if (subview == self.baselineBaseView) {
        self.baselineBaseView = nil;
    }
}

- (CGSize)calcLayoutSize:(CGSize)size subviewEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines context:(MyLayoutContext *)context {
    [super calcLayoutSize:size subviewEngines:subviewEngines context:context];
    
    MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits *)context->layoutViewEngine.currentSizeClass;
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
                          [self myLayout:layoutTraits orientation:orientation gravity:(orientation == MyOrientation_Vert) ? context->horzGravity : context->vertGravity adjustSizeSettingOfSubview:subviewTraits];
                      }];

    if (orientation == MyOrientation_Vert) {
        [self myDoVertOrientationLayoutWithContext:context];
    } else {
        [self myDoHorzOrientationLayoutWithContext:context];
    }
    //绘制智能线。
    [self mySetIntelligentBorderlineWithContext:context];
    return [self myAdjustLayoutViewSizeWithContext:context];
}

- (id)createSizeClassInstance {
    return [MyLinearLayoutTraits new];
}

#pragma mark-- Private Methods

//调整子视图的wrapContent设置
- (void)myLayout:(MyLinearLayoutTraits *)layoutTraits orientation:(MyOrientation)orientation gravity:(MyGravity)gravity adjustSizeSettingOfSubview:(MyViewTraits *)subviewTraits {
    if (orientation == MyOrientation_Vert) {
        //如果是拉伸处理则需要把包裹宽度取消。
        if (subviewTraits.widthSizeInner.wrapVal && gravity == MyGravity_Horz_Fill) {
            [subviewTraits.widthSizeInner _myEqualTo:nil];
        }
        //如果同时设置了左右依赖。并且优先级低时或者布局视图不是宽度自适应则取消自视图宽度自适应，这里是为了兼容老版本。
        if (subviewTraits.leadingPosInner.val != nil && subviewTraits.trailingPosInner.val != nil && (subviewTraits.widthSizeInner.priority == MyPriority_Low || !layoutTraits.widthSizeInner.wrapVal)) {
            [subviewTraits.widthSizeInner _myEqualTo:nil];
        }
        //只要同时设置了高度或者比重属性则应该把尺寸设置为空
        if (subviewTraits.heightSizeInner.wrapVal && subviewTraits.weight != 0) {
            [subviewTraits.heightSizeInner _myEqualTo:nil];
        }
    } else {
        //如果是拉伸处理则需要把包裹高度
        if (subviewTraits.heightSizeInner.wrapVal && gravity == MyGravity_Vert_Fill) {
            [subviewTraits.heightSizeInner _myEqualTo:nil];
        }
        //如果同时设置了左右依赖。并且优先级低时则取消宽度自适应，这里是为了兼容老版本。
        if (subviewTraits.topPosInner.val != nil && subviewTraits.bottomPosInner.val != nil && (subviewTraits.heightSizeInner.priority == MyPriority_Low || !layoutTraits.heightSizeInner.wrapVal)) {
            [subviewTraits.heightSizeInner _myEqualTo:nil];
        }
        //只要同时设置了宽度或者比重属性则应该把宽度置空
        if (subviewTraits.widthSizeInner.wrapVal && subviewTraits.weight != 0) {
            [subviewTraits.widthSizeInner _myEqualTo:nil];
        }
    }
}

//设置智能边界线
- (void)mySetIntelligentBorderlineWithContext:(MyLayoutContext *)context {
    if (context->isEstimate) {
        return;
    }
    
    MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    NSArray<MyLayoutEngine *> *subviewEngines = context->subviewEngines;
    if (self.intelligentBorderline == nil) {
        return;
    }
    BOOL isVert = (layoutTraits.orientation == MyOrientation_Vert);
    CGFloat subviewSpace = (layoutTraits.orientation == MyOrientation_Vert) ? layoutTraits.subviewVSpace : layoutTraits.subviewHSpace;
    for (int i = 0; i < subviewEngines.count; i++) {
        UIView *subview = subviewEngines[i].currentSizeClass.view;
        if (![subview isKindOfClass:[MyBaseLayout class]]) {
            continue;
        }
        MyBaseLayout *sublayoutview = (MyBaseLayout *)subview;
        if (sublayoutview.notUseIntelligentBorderline) {
            continue;
        }
        if (isVert) {
            sublayoutview.topBorderline = nil;
            sublayoutview.bottomBorderline = nil;
        } else {
            sublayoutview.leadingBorderline = nil;
            sublayoutview.trailingBorderline = nil;
        }

        UIView *prevSiblingView = nil;
        UIView *nextSiblingView = nil;

        if (i != 0) {
            prevSiblingView = subviewEngines[i - 1].currentSizeClass.view;
        }
        if (i + 1 != subviewEngines.count) {
            nextSiblingView = subviewEngines[i + 1].currentSizeClass.view;
        }
        if (prevSiblingView != nil) {
            BOOL ok = YES;
            if ([prevSiblingView isKindOfClass:[MyBaseLayout class]] && subviewSpace == 0) {
                MyBaseLayout *prevSiblingLayout = (MyBaseLayout *)prevSiblingView;
                if (prevSiblingLayout.notUseIntelligentBorderline) {
                    ok = NO;
                }
            }

            if (ok) {
                if (isVert) {
                    sublayoutview.topBorderline = self.intelligentBorderline;
                } else {
                    sublayoutview.leadingBorderline = self.intelligentBorderline;
                }
            }
        }

        if (nextSiblingView != nil && (![nextSiblingView isKindOfClass:[MyBaseLayout class]] || subviewSpace != 0)) {
            if (isVert) {
                sublayoutview.bottomBorderline = self.intelligentBorderline;
            } else {
                sublayoutview.trailingBorderline = self.intelligentBorderline;
            }
        }
    }
}

- (void)myDoVertOrientationLayoutWithContext:(MyLayoutContext *)context {
    MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits *)context->layoutViewEngine.currentSizeClass;
    
    CGFloat subviewHeight = [layoutTraits.flexSpace calcMaxMinSubviewSize:context->selfSize.height arrangedCount:context->subviewEngines.count paddingStart:&context->paddingTop paddingEnd:&context->paddingBottom space:&context->vertSpace];
    CGFloat paddingVert = context->paddingTop + context->paddingBottom;
    CGFloat totalHeight = 0.0; //计算固定部分的总高度
    CGFloat totalWeight = 0.0; //剩余部分的总比重
    CGFloat totalShrink = 0.0; //总的压缩比重
    CGFloat addSpace = 0.0;    //用于压缩时的间距压缩增量。
    CGFloat maxLayoutWidth = 0.0;

    //高度可以被伸缩的子视图集合
    NSMutableSet<MyLayoutEngine *> *flexHeightSubviewEngines = [NSMutableSet new];
    //高度是固定尺寸的子视图集合
    NSMutableArray<MyLayoutEngine*> *fixedHeightSubviewEngines = [NSMutableArray new];
    CGFloat totalFixedHeight = 0.0;
    NSInteger fixedSpacingSubviewCount = 0; //固定间距的子视图数量。
    CGFloat totalFixedSpacing = 0.0;  //固定间距的子视图的高度。
    CGFloat pos = context->paddingTop;
    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        if (context->vertGravity == MyGravity_Vert_Fill || context->vertGravity == MyGravity_Vert_Stretch) {
            BOOL isFlexEngine = YES;
            //比重高度的子视图不能被伸缩。
            if (subviewTraits.weight != 0.0) {
                isFlexEngine = NO;
            }
            //高度依赖于父视图的不能被伸缩
            if ((subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == layoutTraits.heightSizeInner) || subviewTraits.heightSizeInner.fillVal) {
                isFlexEngine = NO;
            }
            //布局视图的高度自适应尺寸的不能被伸缩。
            if (subviewTraits.heightSizeInner.wrapVal && [subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                isFlexEngine = NO;
            }
            //高度最小是自身尺寸的不能被伸缩。
            if (subviewTraits.heightSizeInner.lBoundValInner.wrapVal) {
                isFlexEngine = NO;
            }
            //对于拉伸来说，只要是设置了高度约束(除了非布局子视图的高度自适应除外)都不会被伸缩
            if (context->vertGravity == MyGravity_Vert_Stretch &&
                subviewTraits.heightSizeInner.val != nil &&
                (!subviewTraits.heightSizeInner.wrapVal || [subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                isFlexEngine = NO;
            }
            if (isFlexEngine) {
                [flexHeightSubviewEngines addObject:subviewEngine];
            }
            //在计算拉伸时，如果没有设置宽度约束则将宽度设置为0
            if (subviewTraits.heightSizeInner.val == nil && !subviewTraits.heightSizeInner.lBoundValInner.wrapVal) {
                subviewEngine.height = 0;
            }
        }

        //计算子视图的高度
        if (subviewHeight != 0.0) {
            subviewEngine.height = subviewHeight;
        } else {
            subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
        }
        subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview :subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

        //特殊处理宽度等于高度的情况
        if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) {
            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
        }
        //计算子视图宽度以及对齐, 先计算宽度的原因是处理那些高度依赖宽度并且是wrap的情况。
        CGFloat tempLayoutWidth = [self mySubviewEngine:subviewEngine calcLeadingTrailingWithContext:context];

        //左右依赖的，或者依赖父视图宽度的不参数最宽计算！！
        if ((tempLayoutWidth > maxLayoutWidth) &&
            (subviewTraits.widthSizeInner.anchorVal == nil || subviewTraits.widthSizeInner.anchorVal != layoutTraits.widthSizeInner) &&
            !subviewTraits.widthSizeInner.fillVal &&
            (subviewTraits.leadingPosInner.val == nil || subviewTraits.trailingPosInner.val == nil || subviewTraits.widthSizeInner.val != nil)) {
            maxLayoutWidth = tempLayoutWidth;
        }

        if (subviewHeight == 0.0) {
            if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况

                subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
                subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview :subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            }

            //再次特殊处理高度包裹的场景
            if (subviewTraits.heightSizeInner.wrapVal) {
                subviewEngine.height = [self mySubview:subviewTraits wrapHeightSizeFits:subviewEngine.size withContext:context];
               subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview :subviewTraits.view calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            }
        }

        //计算固定高度尺寸和浮动高度尺寸部分
        if (subviewTraits.topPosInner.isRelativePos) {
            totalWeight += subviewTraits.topPosInner.numberVal.doubleValue;
            totalHeight += subviewTraits.topPosInner.offsetVal;
        } else {
            totalHeight += subviewTraits.topPosInner.measure;

            if (subviewTraits.topPosInner.measure != 0.0) {
                fixedSpacingSubviewCount += 1;
                totalFixedSpacing += subviewTraits.topPosInner.measure;
            }
        }
        totalShrink += subviewTraits.topPosInner.shrink;
        pos += subviewTraits.topPosInner.measure;
        subviewEngine.top = pos;

        if (subviewTraits.weight != 0.0) {
            totalWeight += subviewTraits.weight;
        } else {
            totalHeight += subviewEngine.height;
            totalShrink += subviewTraits.heightSizeInner.shrink;

            //如果最小高度不为自身并且高度不是包裹的则可以进行缩小。
            if (!subviewTraits.heightSizeInner.lBoundValInner.wrapVal) {
                totalFixedHeight += subviewEngine.height;
                [fixedHeightSubviewEngines addObject:subviewEngine];
            }
        }

        pos += subviewEngine.height;

        if (subviewTraits.bottomPosInner.isRelativePos) {
            totalWeight += subviewTraits.bottomPosInner.numberVal.doubleValue;
            totalHeight += subviewTraits.bottomPosInner.offsetVal;
        } else {
            totalHeight += subviewTraits.bottomPosInner.measure;
            if (subviewTraits.bottomPosInner.measure != 0.0) {
                fixedSpacingSubviewCount += 1;
                totalFixedSpacing += subviewTraits.bottomPosInner.measure;
            }
        }
        totalShrink += subviewTraits.bottomPosInner.shrink;
        pos += subviewTraits.bottomPosInner.measure;

        if (subviewEngine != context->subviewEngines.lastObject) {
            totalHeight += context->vertSpace;
            pos += context->vertSpace;
            if (context->vertSpace != 0.0) {
                fixedSpacingSubviewCount += 1;
                totalFixedSpacing += context->vertSpace;
            }
        }
    }

    if (layoutTraits.heightSizeInner.wrapVal) {
        if (totalWeight != 0.0) { //在包裹高度且总体比重不为0时则，则需要还原最小的高度，这样就不会使得高度在横竖屏或者多次计算后越来高。
            CGFloat tempLayoutHeight = paddingVert;
            if (context->subviewEngines.count > 1) {
                tempLayoutHeight += (context->subviewEngines.count - 1) * context->vertSpace;
            }
           context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:tempLayoutHeight subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
        } else {
            context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:totalHeight + paddingVert subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
        }

        //如果是高度自适应则不需要压缩。
        totalShrink = 0.0;
    }

    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:maxLayoutWidth + context->paddingLeading + context->paddingTrailing subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }

    //这里需要特殊处理当子视图的尺寸高度大于布局视图的高度的情况。
    BOOL isWeightShrinkSpacing = NO; //是否按比重缩小间距。
    CGFloat weightShrinkSpacingTotalHeight = 0;
    CGFloat spareHeight = context->selfSize.height - totalHeight - paddingVert; //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    //取出shrinkType中的模式和内容类型：
    MySubviewsShrinkType sstMode = layoutTraits.shrinkType & 0x0F;    //压缩的模式
    MySubviewsShrinkType sstContent = layoutTraits.shrinkType & 0xF0; //压缩内容

    //如果子视图设置了压缩比重则ssMode不起作用
    if (totalShrink != 0.0) {
        sstMode = MySubviewsShrink_None;
    }
    if (_myCGFloatLessOrEqual(spareHeight, 0)) {
        if (sstMode != MySubviewsShrink_None) {
            if (sstContent == MySubviewsShrink_Size) { //压缩尺寸
                if (fixedHeightSubviewEngines.count > 0 && spareHeight < 0 && context->selfSize.height > 0) {
                    if (sstMode == MySubviewsShrink_Average) { //均分。
                        CGFloat averageHeight = spareHeight / fixedHeightSubviewEngines.count;

                        for (MyLayoutEngine *fixedHeightSubviewEngine in fixedHeightSubviewEngines) {
                            fixedHeightSubviewEngine.height += averageHeight;
                        }
                    } else if (_myCGFloatNotEqual(totalFixedHeight, 0)) { //按比例分配。
                        for (MyLayoutEngine *fixedHeightSubviewEngine in fixedHeightSubviewEngines) {
                            fixedHeightSubviewEngine.height += spareHeight * (fixedHeightSubviewEngine.height / totalFixedHeight);
                        }
                    }
                }
            } else if (sstContent == MySubviewsShrink_Space) { //压缩间距
                if (fixedSpacingSubviewCount > 0 && spareHeight < 0 && context->selfSize.height > 0 && totalFixedSpacing > 0) {
                    if (sstMode == MySubviewsShrink_Average) {
                        addSpace = spareHeight / fixedSpacingSubviewCount;
                    } else if (sstMode == MySubviewsShrink_Weight) {
                        isWeightShrinkSpacing = YES;
                        weightShrinkSpacingTotalHeight = spareHeight;
                    }
                }
            }
        }

        if (totalShrink == 0.0) {
            spareHeight = 0.0;
        }
    } else {
        //如果不需要压缩则压缩比设置为0
        totalShrink = 0.0;
    }

    //如果是总的压缩比重不为0则认为固定高度和布局视图高度保持一致。
    if (totalShrink != 0.0) {
        totalHeight = context->selfSize.height - paddingVert;
    }
    //如果有浮动尺寸或者有压缩模式
    if (totalWeight != 0.0 || totalShrink != 0.0 || (sstMode != MySubviewsShrink_None && _myCGFloatLessOrEqual(spareHeight, 0)) || context->vertGravity != MyGravity_None || layoutTraits.widthSizeInner.wrapVal) {
        maxLayoutWidth = 0.0;
        CGFloat incSpacing = 0.0; //间距扩充
        CGFloat incHeight = 0.0;    //尺寸扩充
        if (context->vertGravity == MyGravity_Vert_Center) {
            pos = (context->selfSize.height - totalHeight - paddingVert) / 2.0 + context->paddingTop;
        } else if (context->vertGravity == MyGravity_Vert_Window_Center) {
            if (self.window != nil) {
                pos = (CGRectGetHeight(self.window.bounds) - totalHeight) / 2.0;
                CGPoint point = CGPointMake(0, pos);
                pos = [self.window convertPoint:point toView:self].y;
            }
        } else if (context->vertGravity == MyGravity_Vert_Bottom) {
            pos = context->selfSize.height - totalHeight - context->paddingBottom;
        } else if (context->vertGravity == MyGravity_Vert_Between) {
            pos = context->paddingTop;

            if (context->subviewEngines.count > 1) {
                incSpacing = (context->selfSize.height - totalHeight - paddingVert) / (context->subviewEngines.count - 1);
            }
        } else if (context->vertGravity == MyGravity_Vert_Around) {
            //around停靠中如果子视图数量大于1则间距均分，并且首尾子视图和父视图的间距为均分的一半，如果子视图数量为1则一个子视图垂直居中。
            if (context->subviewEngines.count > 1) {
                incSpacing = (context->selfSize.height - totalHeight - paddingVert) / context->subviewEngines.count;
                pos = context->paddingTop + incSpacing / 2;
            } else {
                pos = (context->selfSize.height - totalHeight - paddingVert) / 2.0 + context->paddingTop;
            }
        } else if (context->vertGravity == MyGravity_Vert_Among) {
            incSpacing = (context->selfSize.height - totalHeight - paddingVert) / (context->subviewEngines.count + 1);
            pos = context->paddingTop + incSpacing;
        } else if (context->vertGravity == MyGravity_Vert_Fill || context->vertGravity == MyGravity_Vert_Stretch) {
            pos = context->paddingTop;
            if (flexHeightSubviewEngines.count > 0) {
                incHeight = (context->selfSize.height - totalHeight - paddingVert) / flexHeightSubviewEngines.count;
            }
        } else {
            pos = context->paddingTop;
        }

        for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
            
            MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;

            CGFloat topSpacing = subviewTraits.topPosInner.numberVal.doubleValue;
            CGFloat bottomSpacing = subviewTraits.bottomPosInner.numberVal.doubleValue;
            CGFloat weight = subviewTraits.weight;

            //分别处理相对顶部间距和绝对顶部间距
            if (subviewTraits.topPosInner.isRelativePos) {
                CGFloat topSpacingWeight = topSpacing;
                topSpacing = _myCGFloatRound((topSpacingWeight / totalWeight) * spareHeight);
                if (_myCGFloatLessOrEqual(topSpacing, 0.0)) {
                    topSpacing = 0.0;
                }
            } else {
                if (topSpacing + subviewTraits.topPosInner.offsetVal != 0.0) {
                    pos += addSpace;
                    if (isWeightShrinkSpacing) {
                        pos += weightShrinkSpacingTotalHeight * (topSpacing + subviewTraits.topPosInner.offsetVal) / totalFixedSpacing;
                    }
                }
            }

            topSpacing += subviewTraits.topPosInner.offsetVal;
            if (totalShrink != 0.0 && subviewTraits.topPosInner.shrink != 0.0) {
                topSpacing += (subviewTraits.topPosInner.shrink / totalShrink) * spareHeight;
            }
            pos += [self myValidMargin:subviewTraits.topPosInner subview:subviewTraits.view calcPos:topSpacing selfLayoutSize:context->selfSize];
            subviewEngine.top = pos;

            //分别处理相对高度和绝对高度
            if (weight != 0) {
                CGFloat h = _myCGFloatRound((weight / totalWeight) * spareHeight);
                if (_myCGFloatLessOrEqual(h, 0.0)) {
                    h = 0.0;
                }
                subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview :subviewTraits.view calcSize:h subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            }

            //加上扩充的宽度。
            if (incHeight != 0 && [flexHeightSubviewEngines containsObject:subviewEngine]) {
                subviewEngine.height += incHeight;
            }
            if (totalShrink != 0.0 && subviewTraits.heightSizeInner.shrink != 0.0) {
                subviewEngine.height += (subviewTraits.heightSizeInner.shrink / totalShrink) * spareHeight;
                if (subviewEngine.height < 0.0) {
                    subviewEngine.height = 0.0;
                }
            }

            if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner) { //特殊处理宽度等于高度的情况
                subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            }

            //计算子视图宽度以及对齐
            CGFloat tempLayoutWidth = [self mySubviewEngine:subviewEngine calcLeadingTrailingWithContext:context];

            if (layoutTraits.widthSizeInner.wrapVal &&
                (tempLayoutWidth > maxLayoutWidth) &&
                (subviewTraits.widthSizeInner.anchorVal == nil || subviewTraits.widthSizeInner.anchorVal != layoutTraits.widthSizeInner) &&
                !subviewTraits.widthSizeInner.fillVal &&
                (subviewTraits.leadingPosInner.val == nil || subviewTraits.trailingPosInner.val == nil || subviewTraits.widthSizeInner.val != nil)) {
                maxLayoutWidth = tempLayoutWidth;
                if (context->selfSize.width < maxLayoutWidth + context->paddingLeading + context->paddingTrailing)
                    context->selfSize.width = maxLayoutWidth + context->paddingLeading + context->paddingTrailing;
            }

            pos += subviewEngine.height;

            //分别处理相对底部间距和绝对底部间距
            if (subviewTraits.bottomPosInner.isRelativePos) {
                CGFloat bottomSpaceWeight = bottomSpacing;
                bottomSpacing = _myCGFloatRound((bottomSpaceWeight / totalWeight) * spareHeight);
                if (_myCGFloatLessOrEqual(bottomSpacing, 0.0)) {
                    bottomSpacing = 0.0;
                }
            } else {
                if (bottomSpacing + subviewTraits.bottomPosInner.offsetVal != 0.0) {
                    pos += addSpace;
                    if (isWeightShrinkSpacing) {
                        pos += weightShrinkSpacingTotalHeight * (bottomSpacing + subviewTraits.bottomPosInner.offsetVal) / totalFixedSpacing;
                    }
                }
            }

            bottomSpacing += subviewTraits.bottomPosInner.offsetVal;
            if (totalShrink != 0.0 && subviewTraits.bottomPosInner.shrink != 0.0) {
                bottomSpacing += (subviewTraits.bottomPosInner.shrink / totalShrink) * spareHeight;
            }
            pos += [self myValidMargin:subviewTraits.bottomPosInner subview:subviewTraits.view calcPos:bottomSpacing selfLayoutSize:context->selfSize];

            //添加共有的子视图间距
            if (subviewEngine != context->subviewEngines.lastObject) {
                pos += context->vertSpace;
                if (context->vertSpace != 0.0) {
                    pos += addSpace;
                    if (isWeightShrinkSpacing) {
                        pos += weightShrinkSpacingTotalHeight * context->vertSpace / totalFixedSpacing;
                    }
                }
                pos += incSpacing; //只有mgvert为between才加这个间距拉伸。
            }
        }
    }
    pos += context->paddingBottom;
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = pos;
    }
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = maxLayoutWidth + context->paddingLeading + context->paddingTrailing;
    }
}

- (void)myDoHorzOrientationLayoutWithContext:(MyLayoutContext *)context {
    MyLinearLayoutTraits *layoutTraits = (MyLinearLayoutTraits*)context->layoutViewEngine.currentSizeClass;
    CGFloat subviewWidth = [layoutTraits.flexSpace calcMaxMinSubviewSize:context->selfSize.width arrangedCount:context->subviewEngines.count paddingStart:&context->paddingLeading paddingEnd:&context->paddingTrailing space:&context->horzSpace];
    CGFloat totalWidth = 0.0;  //计算固定部分的宽度
    CGFloat totalWeight = 0.0; //剩余部分的总比重
    CGFloat totalShrink = 0.0; //总的压缩比重
    CGFloat addSpace = 0.0;    //用于压缩时的间距压缩增量。
    CGFloat paddingHorz = context->paddingLeading + context->paddingTrailing;

    //宽度是可伸缩的子视图集合
    NSMutableSet<MyLayoutEngine *> *flexWidthSubviewEngines = [NSMutableSet new];
    //宽度是固定尺寸的子视图集合
    NSMutableArray<MyLayoutEngine *> *fixedWidthSubviewEngines = [NSMutableArray new];
    //左右拉伸宽度尺寸的子视图集合
    NSMutableArray<MyLayoutEngine *> *leftRightFlexWidthSubviewEngines = [NSMutableArray new];
    CGFloat totalFixedWidth = 0.0;      //固定尺寸视图的宽度
    NSInteger fixedSpacingSubviewCount = 0;   //固定间距的子视图数量。
    CGFloat totalFixedSpacing = 0.0;     //固定间距的子视图的宽度。
    CGFloat baselinePos = CGFLOAT_MAX; //保存基线的值。
    CGFloat pos = context->paddingLeading;
    CGFloat maxLayoutHeight = 0.0;
    for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
        //计算出固定宽度部分以及weight部分。这里的宽度可能依赖高度。如果不是高度包裹则计算出所有高度。
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        if (context->horzGravity == MyGravity_Horz_Fill || context->horzGravity == MyGravity_Horz_Stretch) {
            BOOL isFlexEngine = YES;
            //设置了比重宽度的子视图不伸缩
            if (subviewTraits.weight != 0.0) {
                isFlexEngine = NO;
            }
            //宽度依赖父视图宽度的不伸缩
            if ((subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == layoutTraits.widthSizeInner) || subviewTraits.widthSizeInner.fillVal) {
                isFlexEngine = NO;
            }
            //布局子视图宽度自适应时不伸缩
            if (subviewTraits.widthSizeInner.wrapVal && [subviewTraits.view isKindOfClass:[MyBaseLayout class]]) {
                isFlexEngine = NO;
            }
            //子视图宽度最小为自身宽度时不伸缩。
            if (subviewTraits.widthSizeInner.lBoundValInner.wrapVal) {
                isFlexEngine = NO;
            }
            //对于拉伸来说，只要是设置了宽度约束(除了非布局子视图的宽度自适应除外)都不会被伸缩
            if (context->horzGravity == MyGravity_Horz_Stretch &&
                subviewTraits.widthSizeInner.val != nil &&
                (!subviewTraits.widthSizeInner.wrapVal || [subviewTraits.view isKindOfClass:[MyBaseLayout class]])) {
                isFlexEngine = NO;
            }
            if (isFlexEngine) {
                [flexWidthSubviewEngines addObject:subviewEngine];
            }
            //在计算拉伸时，如果没有设置宽度约束则将宽度设置为0
            if (subviewTraits.widthSizeInner.val == nil && !subviewTraits.widthSizeInner.lBoundValInner.wrapVal) {
                subviewEngine.width = 0.0;
            }
        }

        //计算子视图的宽度，这里不管是否设置约束以及是否宽度是weight的都是进行计算。
        if (subviewWidth != 0.0) {
            subviewEngine.width = subviewWidth;
        } else {
            subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
        }
        subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview :subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

        if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况
            subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
        }

        //计算子视图高度以及对齐
        CGFloat tempLayoutHeight = [self mySubviewEngine:subviewEngine baselinePos:baselinePos calcTopBottomWithContext:context];

        if ((tempLayoutHeight > maxLayoutHeight) &&
            (subviewTraits.heightSizeInner.anchorVal == nil || subviewTraits.heightSizeInner.anchorVal != layoutTraits.heightSizeInner) &&
            !subviewTraits.heightSizeInner.fillVal &&
            (subviewTraits.topPosInner.val == nil || subviewTraits.bottomPosInner.val == nil || subviewTraits.heightSizeInner.val != nil)) {
            maxLayoutHeight = tempLayoutHeight;
        }

        //如果垂直方向的对齐方式是基线对齐，那么就以第一个具有基线的视图作为标准位置。
        if (context->vertGravity == MyGravity_Vert_Baseline && baselinePos == CGFLOAT_MAX && self.baselineBaseView == subviewTraits.view) {
            UIFont *subviewFont = [subviewTraits.view valueForKey:@"font"];
            //这里要求baselineBaseView必须要具有font属性。
            //得到基线位置。
            baselinePos = subviewEngine.top + (subviewEngine.height - subviewFont.lineHeight) / 2.0 + subviewFont.ascender;
        }

        if (subviewTraits.widthSizeInner.anchorVal != nil && subviewTraits.widthSizeInner.anchorVal == subviewTraits.heightSizeInner && subviewWidth == 0.0) { //特殊处理宽度等于高度的情况

            subviewEngine.width = [subviewTraits.widthSizeInner measureWith:subviewEngine.height];
            subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview :subviewTraits.view calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
        }

        //计算固定宽度尺寸和浮动宽度尺寸部分
        if (subviewTraits.leadingPosInner.isRelativePos) {
            totalWeight += subviewTraits.leadingPosInner.numberVal.doubleValue;

            totalWidth += subviewTraits.leadingPosInner.offsetVal;
        } else {
            totalWidth += subviewTraits.leadingPosInner.measure;

            if (subviewTraits.leadingPosInner.measure != 0.0) {
                fixedSpacingSubviewCount += 1;
                totalFixedSpacing += subviewTraits.leadingPosInner.measure;
            }
        }

        totalShrink += subviewTraits.leadingPosInner.shrink;

        pos += subviewTraits.leadingPosInner.measure;
        subviewEngine.leading = pos;

        if (subviewTraits.weight != 0.0) {
            totalWeight += subviewTraits.weight;
        } else {
            totalWidth += subviewEngine.width;
            totalShrink += subviewTraits.widthSizeInner.shrink;

            //如果最小宽度不为自身并且宽度不是包裹的则可以进行缩小。
            if (!subviewTraits.widthSizeInner.lBoundValInner.wrapVal) {
                totalFixedWidth += subviewEngine.width;
                [fixedWidthSubviewEngines addObject:subviewEngine];
            }

            if (subviewTraits.widthSizeInner.wrapVal) {
                [leftRightFlexWidthSubviewEngines addObject:subviewEngine];
            }
        }

        pos += subviewEngine.width;

        if (subviewTraits.trailingPosInner.isRelativePos) {
            totalWeight += subviewTraits.trailingPosInner.numberVal.doubleValue;
            totalWidth += subviewTraits.trailingPosInner.offsetVal;
        } else {
            totalWidth += subviewTraits.trailingPosInner.measure;

            if (subviewTraits.trailingPosInner.measure != 0.0) {
                fixedSpacingSubviewCount += 1;
                totalFixedSpacing += subviewTraits.trailingPosInner.measure;
            }
        }
        totalShrink += subviewTraits.trailingPosInner.shrink;
        pos += subviewTraits.trailingPosInner.measure;
        if (subviewEngine != context->subviewEngines.lastObject) {
            totalWidth += context->horzSpace;
            pos += context->horzSpace;
            if (context->horzSpace != 0.0) {
                fixedSpacingSubviewCount += 1;
                totalFixedSpacing += context->horzSpace;
            }
        }
    }

    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (layoutTraits.widthSizeInner.wrapVal) {
        if (totalWeight != 0.0) {
            CGFloat tempSelfWidth = paddingHorz;
            if (context->subviewEngines.count > 1) {
                tempSelfWidth += (context->subviewEngines.count - 1) * context->horzSpace;
            }
            context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:tempSelfWidth subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
        } else {
            context->selfSize.width = [self myValidMeasure:layoutTraits.widthSizeInner subview:self calcSize:totalWidth + paddingHorz subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
        }

        //如果是宽度自适应则不需要压缩。
        totalShrink = 0.0;
    }

    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = [self myValidMeasure:layoutTraits.heightSizeInner subview:self calcSize:maxLayoutHeight + context->paddingTop + context->paddingBottom subviewSize:context->selfSize selfLayoutSize:self.superview.bounds.size];
    }

    //这里需要特殊处理当子视图的尺寸宽度大于布局视图的宽度的情况.
    //剩余的可浮动的宽度，那些weight不为0的从这个宽度来进行分发
    BOOL isWeightShrinkSpacing = NO; //是否按比重缩小间距。。。
    CGFloat weightShrinkSpacingTotalWidth = 0.0;
    CGFloat spareWidth = context->selfSize.width - totalWidth - paddingHorz;
    //取出shrinkType中的模式和内容类型：
    MySubviewsShrinkType sstMode = layoutTraits.shrinkType & 0x0F;    //压缩的模式
    MySubviewsShrinkType sstContent = layoutTraits.shrinkType & 0xF0; //压缩内容

    //如果子视图设置了压缩比重则ssMode不起作用
    if (totalShrink != 0.0) {
        sstMode = MySubviewsShrink_None;
    }
    if (_myCGFloatLessOrEqual(spareWidth, 0.0)) {
        //如果压缩方式为自动，但是浮动宽度子视图数量不为2则压缩类型无效。
        if (sstMode == MySubviewsShrink_Auto && leftRightFlexWidthSubviewEngines.count != 2) {
            sstMode = MySubviewsShrink_None;
        }
        if (sstMode != MySubviewsShrink_None) {
            if (sstContent == MySubviewsShrink_Size) {
                if (fixedWidthSubviewEngines.count > 0 && spareWidth < 0 && context->selfSize.width > 0) {
                    //均分。
                    if (sstMode == MySubviewsShrink_Average) {
                        CGFloat averageWidth = spareWidth / fixedWidthSubviewEngines.count;

                        for (MyLayoutEngine *fixedWidthSubviewEngine in fixedWidthSubviewEngines) {
                            fixedWidthSubviewEngine.width += averageWidth;
                        }
                    } else if (sstMode == MySubviewsShrink_Auto) {
                        MyLayoutEngine *leadingViewEngine = leftRightFlexWidthSubviewEngines[0];
                        MyLayoutEngine *trailingViewEngine = leftRightFlexWidthSubviewEngines[1];
                        CGFloat leadingWidth = leadingViewEngine.width;
                        CGFloat trailingWidth = trailingViewEngine.width;

                        //如果2个都超过一半则总是一半显示。
                        //如果1个超过了一半则 如果两个没有超过总宽度则正常显示，如果超过了总宽度则超过一半的视图的宽度等于总宽度减去未超过一半的视图的宽度。
                        //如果没有一个超过一半。则正常显示
                        CGFloat layoutWidth = spareWidth + leadingWidth + trailingWidth;
                        CGFloat halfLayoutWidth = layoutWidth / 2;

                        if (_myCGFloatGreat(leadingWidth, halfLayoutWidth) && _myCGFloatGreat(trailingWidth, halfLayoutWidth)) {
                            leadingViewEngine.width = halfLayoutWidth;
                            trailingViewEngine.width = halfLayoutWidth;
                        } else if ((_myCGFloatGreat(leadingWidth, halfLayoutWidth) || _myCGFloatGreat(trailingWidth, halfLayoutWidth)) && (_myCGFloatGreat(leadingWidth + trailingWidth, layoutWidth))) {

                            if (_myCGFloatGreat(leadingWidth, halfLayoutWidth)) {
                                trailingViewEngine.width = trailingWidth;
                                leadingViewEngine.width = layoutWidth - trailingWidth;
                            } else {
                                leadingViewEngine.width = leadingWidth;
                                trailingViewEngine.width = layoutWidth - leadingWidth;
                            }
                        }
                    } else if (_myCGFloatNotEqual(totalFixedWidth, 0.0)) { //按比例分配。
                        for (MyLayoutEngine *fixedWidthSubviewEngine in fixedWidthSubviewEngines) {
                            fixedWidthSubviewEngine.width += spareWidth * (fixedWidthSubviewEngine.width / totalFixedWidth);
                        }
                    }
                }
            } else if (sstContent == MySubviewsShrink_Space) {
                if (fixedSpacingSubviewCount > 0 && spareWidth < 0 && context->selfSize.width > 0 && totalFixedSpacing > 0) {
                    if (sstMode == MySubviewsShrink_Average) {
                        addSpace = spareWidth / fixedSpacingSubviewCount;
                    } else if (sstMode == MySubviewsShrink_Weight) {
                        isWeightShrinkSpacing = YES;
                        weightShrinkSpacingTotalWidth = spareWidth;
                    }
                }
            }
        }

        if (totalShrink == 0.0) {
            spareWidth = 0.0;
        }
    } else {
        //如果不需要压缩则压缩比设置为0
        totalShrink = 0.0;
    }

    //如果是总的压缩比重不为0则认为固定宽度和布局视图宽度保持一致。
    if (totalShrink != 0.0) {
        totalWidth = context->selfSize.width - paddingHorz;
    }
    //如果有浮动尺寸或者有压缩模式
    if (totalWeight != 0.0 || totalShrink != 0.0 || (sstMode != MySubviewsShrink_None && _myCGFloatLessOrEqual(spareWidth, 0)) || context->horzGravity != MyGravity_None || layoutTraits.heightSizeInner.wrapVal) {
        maxLayoutHeight = 0.0;
        CGFloat incSpacing = 0.0; //间距扩充
        CGFloat incWidth = 0.0;    //尺寸扩充
        if (context->horzGravity == MyGravity_Horz_Center) {
            pos = (context->selfSize.width - totalWidth - paddingHorz) / 2.0 + context->paddingLeading;
        } else if (context->horzGravity == MyGravity_Horz_Window_Center) {
            if (self.window != nil) {
                pos = (CGRectGetWidth(self.window.bounds) - totalWidth) / 2.0;

                CGPoint point = CGPointMake(pos, 0);
                pos = [self.window convertPoint:point toView:self].x;
            }
        } else if (context->horzGravity == MyGravity_Horz_Trailing) {
            pos = context->selfSize.width - totalWidth - context->paddingTrailing;
        } else if (context->horzGravity == MyGravity_Horz_Between) {
            pos = context->paddingLeading;

            if (context->subviewEngines.count > 1) {
                incSpacing = (context->selfSize.width - totalWidth - paddingHorz) / (context->subviewEngines.count - 1);
            }
        } else if (context->horzGravity == MyGravity_Horz_Around) {
            //around停靠中如果子视图数量大于1则间距均分，并且首尾子视图和父视图的间距为均分的一半，如果子视图数量为1则一个子视图垂直居中。
            if (context->subviewEngines.count > 1) {
                incSpacing = (context->selfSize.width - totalWidth - paddingHorz) / context->subviewEngines.count;
                pos = context->paddingLeading + incSpacing / 2.0;
            } else {
                pos = (context->selfSize.width - totalWidth - paddingHorz) / 2.0 + context->paddingLeading;
            }
        } else if (context->horzGravity == MyGravity_Horz_Among) {
            incSpacing = (context->selfSize.width - totalWidth - paddingHorz) / (context->subviewEngines.count + 1);
            pos = context->paddingLeading + incSpacing;
        } else if (context->horzGravity == MyGravity_Horz_Fill || context->horzGravity == MyGravity_Horz_Stretch) {
            pos = context->paddingLeading;
            if (flexWidthSubviewEngines.count > 0) {
                incWidth = (context->selfSize.width - totalWidth - paddingHorz) / flexWidthSubviewEngines.count;
            }
        } else {
            pos = context->paddingLeading;
        }
        for (MyLayoutEngine *subviewEngine in context->subviewEngines) {
            MyViewTraits *subviewTraits = (MyViewTraits *)subviewEngine.currentSizeClass;

            CGFloat leadingSpacing = subviewTraits.leadingPosInner.numberVal.doubleValue;
            CGFloat trailingSpacing = subviewTraits.trailingPosInner.numberVal.doubleValue;
            CGFloat weight = subviewTraits.weight;

            //分别处理相对顶部间距和绝对顶部间距
            if (subviewTraits.leadingPosInner.isRelativePos) {
                CGFloat topSpaceWeight = leadingSpacing;
                leadingSpacing = _myCGFloatRound((topSpaceWeight / totalWeight) * spareWidth);
                if (_myCGFloatLessOrEqual(leadingSpacing, 0.0)) {
                    leadingSpacing = 0.0;
                }
            } else {
                if (leadingSpacing + subviewTraits.leadingPosInner.offsetVal != 0.0) {
                    pos += addSpace;

                    if (isWeightShrinkSpacing) {
                        pos += weightShrinkSpacingTotalWidth * (leadingSpacing + subviewTraits.leadingPosInner.offsetVal) / totalFixedSpacing;
                    }
                }
            }
            leadingSpacing += subviewTraits.leadingPosInner.offsetVal;
            if (totalShrink != 0.0 && subviewTraits.leadingPosInner.shrink != 0.0) {
                leadingSpacing += (subviewTraits.leadingPosInner.shrink / totalShrink) * spareWidth;
            }

            pos += [self myValidMargin:subviewTraits.leadingPosInner subview:subviewTraits.view calcPos:leadingSpacing selfLayoutSize:context->selfSize];
            subviewEngine.leading = pos;

            //分别处理相对宽度和绝对宽度
            if (weight != 0.0) {
                CGFloat w = _myCGFloatRound((weight / totalWeight) * spareWidth);
                if (_myCGFloatLessOrEqual(w, 0.0)) {
                    w = 0.0;
                }
                subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subviewTraits.view calcSize:w subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];
            }

            //加上扩充的宽度。
            if (incWidth != 0.0 && [flexWidthSubviewEngines containsObject:subviewEngine]) {
                subviewEngine.width += incWidth;
            }
            if (totalShrink != 0.0 && subviewTraits.widthSizeInner.shrink != 0.0) {
                subviewEngine.width += (subviewTraits.widthSizeInner.shrink / totalShrink) * spareWidth;
                if (subviewEngine.width < 0.0) {
                    subviewEngine.width = 0.0;
                }
            }

            //特殊处理高度依赖宽度的情况。
            if (subviewTraits.heightSizeInner.anchorVal != nil && subviewTraits.heightSizeInner.anchorVal == subviewTraits.widthSizeInner) { //特殊处理高度等于宽度的情况
                subviewEngine.height = [subviewTraits.heightSizeInner measureWith:subviewEngine.width];
            }

            CGFloat tempLayoutHeight = [self mySubviewEngine:subviewEngine baselinePos:baselinePos calcTopBottomWithContext:context];

            if (layoutTraits.heightSizeInner.wrapVal &&
                (tempLayoutHeight > maxLayoutHeight) &&
                (subviewTraits.heightSizeInner.anchorVal == nil || subviewTraits.heightSizeInner.anchorVal != layoutTraits.heightSizeInner) &&
                !subviewTraits.heightSizeInner.fillVal &&
                (subviewTraits.topPosInner.val == nil || subviewTraits.bottomPosInner.val == nil || subviewTraits.heightSizeInner.val != nil)) {
                maxLayoutHeight = tempLayoutHeight;
                if (context->selfSize.height < maxLayoutHeight + context->paddingTop + context->paddingBottom)
                    context->selfSize.height = maxLayoutHeight + context->paddingTop + context->paddingBottom;
            }

            pos += subviewEngine.width;

            //计算相对的右边边距和绝对的右边边距
            if (subviewTraits.trailingPosInner.isRelativePos) {
                CGFloat trailingSpaceWeight = trailingSpacing;
                trailingSpacing = _myCGFloatRound((trailingSpaceWeight / totalWeight) * spareWidth);
                if (_myCGFloatLessOrEqual(trailingSpacing, 0.0)) {
                    trailingSpacing = 0.0;
                }
            } else {
                if (trailingSpacing + subviewTraits.trailingPosInner.offsetVal != 0.0) {
                    pos += addSpace;

                    if (isWeightShrinkSpacing) {
                        pos += weightShrinkSpacingTotalWidth * (trailingSpacing + subviewTraits.trailingPosInner.offsetVal) / totalFixedSpacing;
                    }
                }
            }
            trailingSpacing += subviewTraits.trailingPosInner.offsetVal;
            if (totalShrink != 0.0 && subviewTraits.trailingPosInner.shrink != 0.0) {
                trailingSpacing += (subviewTraits.trailingPosInner.shrink / totalShrink) * spareWidth;
            }
            pos += [self myValidMargin:subviewTraits.trailingPosInner subview:subviewTraits.view calcPos:trailingSpacing selfLayoutSize:context->selfSize];
            //添加共有的子视图间距
            if (subviewEngine != context->subviewEngines.lastObject) {
                pos += context->horzSpace;
                if (context->horzSpace != 0.0) {
                    pos += addSpace;
                    if (isWeightShrinkSpacing) {
                        pos += weightShrinkSpacingTotalWidth * context->horzSpace / totalFixedSpacing;
                    }
                }
                pos += incSpacing; //只有gravity为between或者around才加这个间距拉伸。
            }
        }
    }
    pos += context->paddingTrailing;
    if (layoutTraits.widthSizeInner.wrapVal) {
        context->selfSize.width = pos;
    }
    if (layoutTraits.heightSizeInner.wrapVal) {
        context->selfSize.height = maxLayoutHeight + context->paddingTop + context->paddingBottom;
    }
}

- (CGFloat)mySubviewEngine:(MyLayoutEngine *)subviewEngine calcLeadingTrailingWithContext:(MyLayoutContext *)context {
    MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    UIView *subview = subviewTraits.view;
    subviewEngine.width = [self myWidthSizeValueOfSubviewEngine:subviewEngine withContext:context];
    if (subviewTraits.leadingPosInner.val != nil && subviewTraits.trailingPosInner.val != nil) {
        if (subviewTraits.widthSizeInner.val == nil) {
            subviewEngine.width = context->selfSize.width - context->paddingLeading - context->paddingTrailing - subviewTraits.leadingPosInner.measure - subviewTraits.trailingPosInner.measure;
        }
    }
    subviewEngine.width = [self myValidMeasure:subviewTraits.widthSizeInner subview:subview calcSize:subviewEngine.width subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

    return [self myCalcSubview:subviewEngine horzGravity:[subviewTraits finalHorzGravityFrom:context->horzGravity] withContext:context];
}

- (CGFloat)mySubviewEngine:(MyLayoutEngine *)subviewEngine baselinePos:(CGFloat)baselinePos calcTopBottomWithContext:(MyLayoutContext *)context  {
    MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
    UIView *subview = subviewTraits.view;
    subviewEngine.height = [self myHeightSizeValueOfSubviewEngine:subviewEngine withContext:context];
    if (subviewTraits.topPosInner.val != nil && subviewTraits.bottomPosInner.val != nil) {
        if (subviewTraits.heightSizeInner.val == nil)
            subviewEngine.height = context->selfSize.height - context->paddingTop - context->paddingBottom - subviewTraits.topPosInner.measure - subviewTraits.bottomPosInner.measure;
    }
    subviewEngine.height = [self myValidMeasure:subviewTraits.heightSizeInner subview:subview calcSize:subviewEngine.height subviewSize:subviewEngine.size selfLayoutSize:context->selfSize];

    return [self myCalcSubview:subviewEngine vertGravity:[subviewTraits finalVertGravityFrom:context->vertGravity] baselinePos:baselinePos withContext:context];
}

- (void)myEqualizeSubviewEngines:(NSMutableArray<MyLayoutEngine *> *)subviewEngines  orientation:(MyOrientation)orientation centered:(BOOL)centered space:(CGFloat)space {
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat weight;
    if (space == CGFLOAT_MAX) {
        CGFloat fragments = centered ? subviewEngines.count * 2 + 1 : subviewEngines.count * 2 - 1;
        weight = 1 / fragments;
        space = weight;
    } else {
        weight = 1.0;
    }

    for (MyLayoutEngine *subviewEngine in subviewEngines) {
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        if (orientation == MyOrientation_Vert) {
            [subviewTraits.topPos _myEqualTo:@(space)];
            [subviewTraits.bottomPos _myEqualTo:@0];
        } else {
            [subviewTraits.leadingPos _myEqualTo:@(space)];
            [subviewTraits.trailingPos _myEqualTo:@0];
        }
        
        subviewTraits.weight = weight;
        
        if (subviewEngine == subviewEngines.firstObject && !centered) {
            if (orientation == MyOrientation_Vert) {
                [subviewTraits.topPos _myEqualTo:@0];
            } else {
                [subviewTraits.leadingPos _myEqualTo:@0];
            }
        }
        if (subviewEngine == subviewEngines.lastObject && centered) {
            if (orientation == MyOrientation_Vert) {
                [subviewTraits.bottomPos _myEqualTo:@(space)];
            } else {
                [subviewTraits.trailingPos _myEqualTo:@(space)];
            }
        }
    }
}

- (void)myEqualizeSubviewEngines:(NSArray<MyLayoutEngine *> *)subviewEngines orientation:(MyOrientation)orientation centered:(BOOL)centered {
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat fragments = centered ? subviewEngines.count + 1 : subviewEngines.count - 1;
    CGFloat space = 1 / fragments;
    for (MyLayoutEngine *subviewEngine in subviewEngines) {
        MyViewTraits *subviewTraits = subviewEngine.currentSizeClass;
        if (orientation == MyOrientation_Vert) {
            [subviewTraits.topPos _myEqualTo:@(space)];
        } else {
            [subviewTraits.leadingPos _myEqualTo:@(space)];
        }
        if (subviewEngine == subviewEngines.firstObject && !centered) {
            if (orientation == MyOrientation_Vert) {
                [subviewTraits.topPos _myEqualTo:@0];
            } else {
                [subviewTraits.leadingPos _myEqualTo:@0];
            }
        }
        if (subviewEngine == subviewEngines.lastObject) {
            if (orientation == MyOrientation_Vert) {
                [subviewTraits.bottomPos _myEqualTo:centered ? @(space) : @0];
            } else {
                [subviewTraits.trailingPos _myEqualTo:centered ? @(space) : @0];
            }
        }
    }
}

@end

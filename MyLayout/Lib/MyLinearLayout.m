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

#pragma mark -- Public Methods

-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation
{
    self = [super initWithFrame:frame];
    if (self)
    {
        MyLinearLayout *lsc = self.myCurrentSizeClass;
        if (orientation == MyOrientation_Vert)
            lsc.wrapContentHeight = YES;
        else
            lsc.wrapContentWidth = YES;
        lsc.orientation = orientation;
    }
 
    return self;
}


-(instancetype)initWithOrientation:(MyOrientation)orientation
{
    return [self initWithFrame:CGRectZero orientation:orientation];
}

+(instancetype)linearLayoutWithOrientation:(MyOrientation)orientation
{
    return [[[self class] alloc] initWithOrientation:orientation];
}

-(void)setOrientation:(MyOrientation)orientation
{
    MyLinearLayout *lsc = self.myCurrentSizeClass;
    if (lsc.orientation != orientation)
    {
        lsc.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(MyOrientation)orientation
{
    return self.myCurrentSizeClass.orientation;
}



-(void)setShrinkType:(MySubviewsShrinkType)shrinkType
{
    MyLinearLayout *lsc = self.myCurrentSizeClass;
    if (lsc.shrinkType != shrinkType)
    {
        lsc.shrinkType = shrinkType;
        [self setNeedsLayout];
    }
}

-(MySubviewsShrinkType)shrinkType
{
    return self.myCurrentSizeClass.shrinkType;
}


-(void)equalizeSubviews:(BOOL)centered
{
    [self equalizeSubviews:centered withSpace:CGFLOAT_MAX];
}

-(void)equalizeSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    [self equalizeSubviews:centered withSpace:CGFLOAT_MAX inSizeClass:sizeClass];
}

-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space
{
    [self equalizeSubviews:centered withSpace:space inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
    [self setNeedsLayout];
}

-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space inSizeClass:(MySizeClass)sizeClass
{
    self.myFrame.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == MyOrientation_Vert)
    {
        [self myEqualizeSubviewsForVert:centered withSpace:space];
    }
    else
    {
        [self myEqualizeSubviewsForHorz:centered withSpace:space];
    }
    
    self.myFrame.sizeClass = self.myDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = sbv.myDefaultSizeClass;

}

-(void)equalizeSubviewsSpace:(BOOL)centered
{
    [self equalizeSubviewsSpace:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
    [self setNeedsLayout];

}

-(void)equalizeSubviewsSpace:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    
    self.myFrame.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == MyOrientation_Vert)
    {
        [self myEqualizeSubviewsSpaceForVert:centered];
    }
    else
    {
        [self myEqualizeSubviewsSpaceForHorz:centered];
    }
    
    self.myFrame.sizeClass = self.myDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = sbv.myDefaultSizeClass;

}


#pragma mark -- Override Methods

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    //减少约束冲突的提示。。
    MyLinearLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.orientation == MyOrientation_Vert)
    {
        if (lsc.heightSizeInner.dimeVal != nil && lsc.wrapContentHeight)
        {
            lsc.wrapContentHeight = NO;
        }
            
    }
    else
    {
        if (lsc.widthSizeInner.dimeVal != nil && lsc.wrapContentWidth)
        {
            lsc.wrapContentWidth = NO;
        }
        
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    if (subview == self.baselineBaseView)
    {
        self.baselineBaseView = nil;
    }
}




-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray *)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    
    MyLinearLayout *lsc = self.myCurrentSizeClass;
    
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = lsc.gravity & MyGravity_Vert_Mask;
    MyOrientation oreintation = lsc.orientation;
    
    [self myCalcSubviewsWrapContentSize:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs withCustomSetting:^(UIView *sbv, UIView *sbvsc) {
        
        [self myAdjustSubviewWrapContent:sbv sbvsc:sbvsc orientation:oreintation gravity:(oreintation == MyOrientation_Vert)? horzGravity : vertGravity];
    }];
    
    
    if (oreintation == MyOrientation_Vert)
        selfSize = [self myLayoutSubviewsForVert:selfSize sbs:sbs lsc:lsc];
    else
        selfSize = [self myLayoutSubviewsForHorz:selfSize sbs:sbs lsc:lsc];
    
    //绘制智能线。
    if (!isEstimate)
    {
        [self mySetLayoutIntelligentBorderline:sbs lsc:lsc];
    }
    

    //调整布局视图自己的尺寸。
    [self myAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    //对所有子视图进行布局变换
    [self myAdjustSubviewsLayoutTransform:sbs lsc:lsc selfWidth:selfSize.width selfHeight:selfSize.height];
    //对所有子视图进行RTL设置
    [self myAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self myAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
    
}

-(id)createSizeClassInstance
{
    return [MyLinearLayoutViewSizeClass new];
}


#pragma mark -- Private Methods

//调整子视图的wrapContent设置
- (void)myAdjustSubviewWrapContent:(UIView*)sbv sbvsc:(UIView*)sbvsc orientation:(MyOrientation)orientation  gravity:(MyGravity)gravity
{
    if (orientation == MyOrientation_Vert)
    {
        if (sbvsc.wrapContentWidth)
        {
            //只要同时设置了左右边距或者设置了宽度或者设置了子视图宽度填充则应该把wrapContentWidth置为NO
            if ((sbvsc.widthSizeInner.dimeVal != nil) ||
                (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil) ||
                (gravity == MyGravity_Horz_Fill)
                )
            {
                sbvsc.wrapContentWidth = NO;
            }
        }
        
        if (sbvsc.wrapContentHeight)
        {
            //只要同时设置了高度或者比重属性则应该把wrapContentHeight置为NO
            if ((sbvsc.heightSizeInner.dimeVal != nil) ||
                (sbvsc.weight != 0))
            {
                sbvsc.wrapContentHeight = NO;
            }
        }
        
    }
    else
    {
        
        if (sbvsc.wrapContentHeight)
        {
            //只要同时设置了高度或者上下边距或者父视图的填充属性则应该把wrapContentHeight置为NO
            if ((sbvsc.heightSizeInner.dimeVal != nil) ||
                (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil) ||
                (gravity == MyGravity_Vert_Fill)
                )
            {
                sbvsc.wrapContentHeight = NO;
            }
        }
        
        if (sbvsc.wrapContentWidth)
        {
            //只要同时设置了宽度或者比重属性则应该把wrapContentWidth置为NO
            if (sbvsc.widthSizeInner.dimeVal != nil || sbvsc.weight != 0)
            {
                sbvsc.wrapContentWidth = NO;
            }
        }
    }
}

//设置智能边界线
-(void)mySetLayoutIntelligentBorderline:(NSArray*)sbs lsc:(MyLinearLayout*)lsc
{
    if (self.intelligentBorderline == nil)
        return;
    
    BOOL isVert = (lsc.orientation == MyOrientation_Vert);
    CGFloat subviewSpace = (lsc.orientation == MyOrientation_Vert) ? lsc.subviewVSpace : lsc.subviewHSpace;
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        if (![sbv isKindOfClass:[MyBaseLayout class]])
            continue;
        
        MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
        if (sbvl.notUseIntelligentBorderline)
            continue;
        
        if (isVert)
        {
            sbvl.topBorderline = nil;
            sbvl.bottomBorderline = nil;
        }
        else
        {
            sbvl.leadingBorderline = nil;
            sbvl.trailingBorderline = nil;
        }
        
        UIView *prevSiblingView = nil;
        UIView *nextSiblingView = nil;
        
        if (i != 0)
        {
            prevSiblingView = sbs[i - 1];
        }
        
        if (i + 1 != sbs.count)
        {
            nextSiblingView = sbs[i + 1];
        }
        
        if (prevSiblingView != nil)
        {
            BOOL ok = YES;
            if ([prevSiblingView isKindOfClass:[MyBaseLayout class]] && subviewSpace == 0)
            {
                MyBaseLayout *prevSiblingLayout = (MyBaseLayout*)prevSiblingView;
                if (prevSiblingLayout.notUseIntelligentBorderline)
                    ok = NO;
            }
            
            if (ok)
            {
                if (isVert)
                    sbvl.topBorderline = self.intelligentBorderline;
                else
                    sbvl.leadingBorderline = self.intelligentBorderline;
            }
        }
        
        if (nextSiblingView != nil && (![nextSiblingView isKindOfClass:[MyBaseLayout class]] || subviewSpace != 0))
        {
            if (isVert)
                sbvl.bottomBorderline = self.intelligentBorderline;
            else
                sbvl.trailingBorderline = self.intelligentBorderline;
        }
    }
}

-(CGSize)myLayoutSubviewsForVert:(CGSize)selfSize sbs:(NSArray*)sbs lsc:(MyLinearLayout*)lsc
{
    CGFloat subviewSpace = lsc.subviewVSpace;
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;

    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat totalWeight = 0;    //剩余部分的总比重
    CGFloat addSpace = 0;      //用于压缩时的间距压缩增量。
    CGFloat maxSelfWidth = 0;
   
    //高度不是包裹的子视图集合
    NSMutableSet *noWrapsbsSet = [NSMutableSet new];
    //固定高度尺寸的子视图集合
    NSMutableArray *fixedSizeSbs = [NSMutableArray new];
    CGFloat fixedSizeHeight = 0;
    NSInteger fixedSpaceCount = 0;  //固定间距的子视图数量。
    CGFloat  fixedSpaceHeight = 0;  //固定间距的子视图的高度。
    CGFloat pos = paddingTop;
    for (UIView *sbv in sbs)
    {
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        CGRect rect = sbvmyFrame.frame;
    
        //计算子视图的高度
        rect.size.height = [self myGetSubviewHeightSizeValue:sbv
                                                       sbvsc:sbvsc
                                                         lsc:lsc
                                                    selfSize:selfSize
                                                  paddingTop:paddingTop
                                              paddingLeading:paddingLeading
                                               paddingBottom:paddingBottom
                                             paddingTrailing:paddingTrailing
                                                     sbvSize:rect.size];
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
        {//特殊处理宽度等于高度的情况
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
        }
        
        //计算子视图宽度以及对齐, 先计算宽度的原因是处理那些高度依赖宽度并且是wrap的情况。
        CGFloat tempSelfWidth = [self myCalcSubviewLeadingTrailingRect:horzGravity
                                                              selfSize:selfSize
                                                                 pRect:&rect
                                                                   sbv:sbv
                                                       paddingTrailing:paddingTrailing
                                                        paddingLeading:paddingLeading
                                                                 sbvsc:sbvsc
                                                                   lsc:lsc];
        
        
        
        if ((tempSelfWidth > maxSelfWidth) &&
            (lsc.widthSizeInner == nil || (sbvsc.widthSizeInner.dimeRelaVal != lsc.widthSizeInner))  &&
            (sbvsc.leadingPosInner.posVal == nil || sbvsc.trailingPosInner.posVal == nil))
        {
            maxSelfWidth = tempSelfWidth;
        }
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {//特殊处理高度等于宽度的情况
            
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //再次特殊处理高度包裹的场景
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[MyBaseLayout class]])
        {
            rect.size.height = [self myHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算固定高度尺寸和浮动高度尺寸部分
        if (sbvsc.topPosInner.isRelativePos)
        {
            totalWeight += sbvsc.topPosInner.posNumVal.doubleValue;
            
            fixedHeight += sbvsc.topPosInner.offsetVal;
        }
        else
        {
            fixedHeight += sbvsc.topPosInner.absVal;
            
            if (sbvsc.topPosInner.absVal != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += sbvsc.topPosInner.absVal;
            }

        }
        
        pos += sbvsc.topPosInner.absVal;
        rect.origin.y = pos;
        
        
        if (sbvsc.weight != 0.0)
        {
            totalWeight += sbvsc.weight;
        }
        else
        {
            fixedHeight += rect.size.height;
            
            //如果最小高度不为自身并且高度不是包裹的则可以进行缩小。
            if (sbvsc.heightSizeInner.lBoundValInner.dimeSelfVal == nil)
            {
                fixedSizeHeight += rect.size.height;
                [fixedSizeSbs addObject:sbv];
            }
        }

        pos += rect.size.height;
        
        if (sbvsc.bottomPosInner.isRelativePos)
        {
            totalWeight += sbvsc.bottomPosInner.posNumVal.doubleValue;
            fixedHeight += sbvsc.bottomPosInner.offsetVal;
        }
        else
        {
            fixedHeight += sbvsc.bottomPosInner.absVal;
            
            if (sbvsc.bottomPosInner.absVal != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += sbvsc.bottomPosInner.absVal;
            }

        }
        
        pos += sbvsc.bottomPosInner.absVal;
        
        if (sbv != sbs.lastObject)
        {
            fixedHeight += subviewSpace;
            
            pos += subviewSpace;
            
            if (subviewSpace != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += subviewSpace;
            }
        }
        
        if (vertGravity == MyGravity_Vert_Fill)
        {
            BOOL canAddToNoWrapSbs = YES;
            
            if (sbvsc.weight != 0)
                canAddToNoWrapSbs = NO;
            
            //判断是否是添加到参与布局视图包裹计算的子视图。
            if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
                canAddToNoWrapSbs = NO;
            
            //如果子视图高度是包裹的也不进行扩展
            if (sbvsc.wrapContentHeight)
                canAddToNoWrapSbs = NO;
            
            //如果子视图的最小高度就是自身则也不进行扩展。
            if (sbvsc.heightSizeInner.lBoundValInner.dimeSelfVal != nil)
                canAddToNoWrapSbs = NO;
            
            if (canAddToNoWrapSbs)
                [noWrapsbsSet addObject:sbv];
        }
        
        sbvmyFrame.frame = rect;
    }
    
    //在包裹高度且总体比重不为0时则，则需要还原最小的高度，这样就不会使得高度在横竖屏或者多次计算后越来高。
    if (lsc.wrapContentHeight && totalWeight != 0)
    {
        CGFloat tempSelfHeight = paddingVert;
        if (sbs.count > 1)
            tempSelfHeight += (sbs.count - 1) * subviewSpace;
        
        selfSize.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:tempSelfHeight sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        
    }
    
    if (lsc.wrapContentWidth)
        selfSize.width = maxSelfWidth + paddingLeading + paddingTrailing;

    //这里需要特殊处理当子视图的尺寸高度大于布局视图的高度的情况。
    
    BOOL isWeightShrinkSpace = NO;   //是否按比重缩小间距。
    CGFloat weightShrinkSpaceTotalHeight = 0;
    CGFloat floatingHeight = selfSize.height - fixedHeight - paddingVert;  //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    //取出shrinkType中的模式和内容类型：
    MySubviewsShrinkType sstMode = lsc.shrinkType & 0x0F; //压缩的模式
    MySubviewsShrinkType sstContent = lsc.shrinkType & 0xF0; //压缩内容
    if (_myCGFloatLessOrEqual(floatingHeight, 0))
    {
        if (sstMode != MySubviewsShrink_None)
        {
            if (sstContent == MySubviewsShrink_Size)
            {//压缩尺寸
                if (fixedSizeSbs.count > 0 && totalWeight != 0 && floatingHeight < 0 && selfSize.height > 0)
                {
                    if (sstMode == MySubviewsShrink_Average)
                    {//均分。
                        CGFloat averageHeight = floatingHeight / fixedSizeSbs.count;
                        
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.myFrame.height += averageHeight;
                        }
                    }
                    else if (_myCGFloatNotEqual(fixedSizeHeight, 0))
                    {//按比例分配。
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.myFrame.height += floatingHeight * (fsbv.myFrame.height / fixedSizeHeight);
                        }
                        
                    }
                }
            }
            else if (sstContent == MySubviewsShrink_Space)
            {//压缩间距
                if (fixedSpaceCount > 0 && floatingHeight < 0 && selfSize.height > 0 && fixedSpaceHeight > 0)
                {
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        addSpace = floatingHeight / fixedSpaceCount;
                    }
                    else if (sstMode == MySubviewsShrink_Weight)
                    {
                        isWeightShrinkSpace = YES;
                        weightShrinkSpaceTotalHeight = floatingHeight;
                    }
                }
                
            }
            else
            {
                ;
            }

        }

        
        floatingHeight = 0;
    }
    
    //如果有浮动尺寸或者有压缩模式
    if (totalWeight != 0 || (sstMode != MySubviewsShrink_None && _myCGFloatLessOrEqual(floatingHeight, 0)) || vertGravity != MyGravity_None || lsc.wrapContentWidth)
    {
        maxSelfWidth = 0;
        CGFloat between = 0; //间距扩充
        CGFloat fill = 0;    //尺寸扩充
        if (vertGravity == MyGravity_Vert_Center)
        {
            pos = (selfSize.height - fixedHeight - paddingVert)/2.0 + paddingTop;
        }
        else if (vertGravity == MyGravity_Vert_Window_Center)
        {
            if (self.window != nil)
            {
                pos = (CGRectGetHeight(self.window.bounds) - fixedHeight)/2.0;
                
                CGPoint pt = CGPointMake(0, pos);
                pos = [self.window convertPoint:pt toView:self].y;
            }
        }
        else if (vertGravity == MyGravity_Vert_Bottom)
        {
            pos = selfSize.height - fixedHeight - paddingBottom;
        }
        else if (vertGravity == MyGravity_Vert_Between)
        {
            pos = paddingTop;
            
            if (sbs.count > 1)
                between = (selfSize.height - fixedHeight - paddingVert) / (sbs.count - 1);
        }
        else if (vertGravity == MyGravity_Vert_Fill)
        {
            pos = paddingTop;
            if (noWrapsbsSet.count > 0)
                fill = (selfSize.height - fixedHeight - paddingVert) / noWrapsbsSet.count;
        }
        else
        {
            pos = paddingTop;
        }
        
        for (UIView *sbv in sbs) {
            
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
          
            
            CGFloat topSpace = sbvsc.topPosInner.posNumVal.doubleValue;
            CGFloat bottomSpace = sbvsc.bottomPosInner.posNumVal.doubleValue;
            CGFloat weight = sbvsc.weight;
            CGRect rect =  sbvmyFrame.frame;
            
            //分别处理相对顶部间距和绝对顶部间距
            if ([self myIsRelativePos:topSpace])
            {
                CGFloat topSpaceWeight = topSpace;
                topSpace = _myCGFloatRound((topSpaceWeight / totalWeight) * floatingHeight);
                floatingHeight -= topSpace;
                totalWeight -= topSpaceWeight;
                if (_myCGFloatLessOrEqual(topSpace, 0))
                    topSpace = 0;
            }
            else
            {
                if (topSpace + sbvsc.topPosInner.offsetVal != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * (topSpace + sbvsc.topPosInner.offsetVal) / fixedSpaceHeight;
                    }
                }
                
            }
            
            pos += [self myValidMargin:sbvsc.topPosInner sbv:sbv calcPos:topSpace + sbvsc.topPosInner.offsetVal selfLayoutSize:selfSize];
            rect.origin.y = pos;
            
            //分别处理相对高度和绝对高度
            if (weight != 0)
            {
                CGFloat h = _myCGFloatRound((weight / totalWeight) * floatingHeight);
                floatingHeight -= h;
                totalWeight -= weight;
                if (_myCGFloatLessOrEqual(h, 0))
                    h = 0;
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:h sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            //加上扩充的宽度。
            if (fill != 0 && [noWrapsbsSet containsObject:sbv])
                rect.size.height += fill;
            
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            {//特殊处理宽度等于高度的情况
                rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            }
            
            //计算子视图宽度以及对齐
            CGFloat tempSelfWidth = [self myCalcSubviewLeadingTrailingRect:horzGravity
                                                                  selfSize:selfSize
                                                                     pRect:&rect
                                                                       sbv:sbv
                                                           paddingTrailing:paddingTrailing
                                                            paddingLeading:paddingLeading
                                                                     sbvsc:sbvsc
                                                                       lsc:lsc];
            
            if ((tempSelfWidth > maxSelfWidth) &&
                (lsc.widthSizeInner == nil || (sbvsc.widthSizeInner.dimeRelaVal != lsc.widthSizeInner))  &&
                (sbvsc.leadingPosInner.posVal == nil || sbvsc.trailingPosInner.posVal == nil))
            {
                maxSelfWidth = tempSelfWidth;
            }
            
            pos += rect.size.height;
            
            //分别处理相对底部间距和绝对底部间距
            if ([self myIsRelativePos:bottomSpace])
            {
                CGFloat bottomSpaceWeight = bottomSpace;
                bottomSpace = _myCGFloatRound((bottomSpaceWeight / totalWeight) * floatingHeight);
                floatingHeight -= bottomSpace;
                totalWeight -= bottomSpaceWeight;
                if ( _myCGFloatLessOrEqual(bottomSpace, 0))
                    bottomSpace = 0;
                
            }
            else
            {
                if (bottomSpace + sbvsc.bottomPosInner.offsetVal != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * (bottomSpace + sbvsc.bottomPosInner.offsetVal) / fixedSpaceHeight;
                    }
                }
                
            }
            
            pos += [self myValidMargin:sbvsc.bottomPosInner sbv:sbv calcPos:bottomSpace + sbvsc.bottomPosInner.offsetVal selfLayoutSize:selfSize];
            
            //添加共有的子视图间距
            if (sbv != sbs.lastObject)
            {
                pos += subviewSpace;
                
                if (subviewSpace != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * subviewSpace / fixedSpaceHeight;
                    }
                }
                
                pos += between;  //只有mgvert为between才加这个间距拉伸。
            }
            
            sbvmyFrame.frame = rect;
        }
        
    }
    
    pos += paddingBottom;

    if (lsc.wrapContentHeight)
        selfSize.height = pos;
    
    if (lsc.wrapContentWidth)
        selfSize.width = maxSelfWidth + paddingLeading + paddingTrailing;
    
    return selfSize;
}

-(CGSize)myLayoutSubviewsForHorz:(CGSize)selfSize sbs:(NSArray*)sbs lsc:(MyLinearLayout*)lsc
{
    CGFloat subviewSpace = lsc.subviewHSpace;
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    CGFloat fixedWidth = 0;   //计算固定部分的宽度
    CGFloat totalWeight = 0;    //剩余部分的总比重
    CGFloat addSpace = 0;      //用于压缩时的间距压缩增量。
    
    //宽度不是包裹的子视图集合
    NSMutableSet *noWrapsbsSet = [NSMutableSet new];
    //固定宽度尺寸的子视图集合
    NSMutableArray *fixedSizeSbs = [NSMutableArray new];
    //浮动宽度尺寸的子视图集合
    NSMutableArray *flexedSizeSbs = [NSMutableArray new];
    CGFloat fixedSizeWidth = 0;   //固定尺寸视图的宽度
    NSInteger fixedSpaceCount = 0;  //固定间距的子视图数量。
    CGFloat  fixedSpaceWidth = 0;  //固定间距的子视图的宽度。
    CGFloat baselinePos = CGFLOAT_MAX;  //保存基线的值。
    CGFloat pos = paddingLeading;
    CGFloat maxSelfHeight = 0;
    for (UIView *sbv in sbs)
    {
        //计算出固定宽度部分以及weight部分。这里的宽度可能依赖高度。如果不是高度包裹则计算出所有高度。
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        CGRect rect = sbvmyFrame.frame;
        
        //计算子视图的宽度，这里不管是否设置约束以及是否宽度是weight的都是进行计算。
        rect.size.width = [self myGetSubviewWidthSizeValue:sbv
                                                       sbvsc:sbvsc
                                                         lsc:lsc
                                                    selfSize:selfSize
                                                  paddingTop:paddingTop
                                              paddingLeading:paddingLeading
                                               paddingBottom:paddingBottom
                                             paddingTrailing:paddingTrailing
                                                     sbvSize:rect.size];
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {//特殊处理高度等于宽度的情况
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        }
        
        //计算子视图高度以及对齐
       CGFloat tempSelfHeight = [self myCalcSubviewTopBottomRect:vertGravity
                               selfSize:selfSize
                                 pRect:&rect
                                    sbv:sbv
                        paddingTop:paddingTop
                         paddingBottom:paddingBottom
                             baselinePos:baselinePos
                                  sbvsc:sbvsc
                                    lsc:lsc];
        
        if ((tempSelfHeight > maxSelfHeight) &&
            (lsc.heightSizeInner == nil || (sbvsc.heightSizeInner.dimeRelaVal != lsc.heightSizeInner))  &&
            (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil))
        {
            maxSelfHeight = tempSelfHeight;
        }
        
        
        //如果垂直方向的对齐方式是基线对齐，那么就以第一个具有基线的视图作为标准位置。
        if (vertGravity == MyGravity_Vert_Baseline && baselinePos == CGFLOAT_MAX && self.baselineBaseView == sbv)
        {
            UIFont *sbvFont = [sbv valueForKey:@"font"];
            //这里要求baselineBaseView必须要具有font属性。
            //得到基线位置。
            baselinePos = rect.origin.y + (rect.size.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender;
            
        }
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
        {//特殊处理宽度等于高度的情况
            
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        //计算固定宽度尺寸和浮动宽度尺寸部分
        if (sbvsc.leadingPosInner.isRelativePos)
        {
            totalWeight += sbvsc.leadingPosInner.posNumVal.doubleValue;
            
            fixedWidth += sbvsc.leadingPosInner.offsetVal;
        }
        else
        {
            fixedWidth += sbvsc.leadingPosInner.absVal;
            
            if (sbvsc.leadingPosInner.absVal != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += sbvsc.leadingPosInner.absVal;
            }
            
        }
        
        pos += sbvsc.leadingPosInner.absVal;
        rect.origin.x = pos;
        
        
        if (sbvsc.weight != 0.0)
        {
            totalWeight += sbvsc.weight;
        }
        else
        {
            fixedWidth += rect.size.width;
            
            //如果最小宽度不为自身并且宽度不是包裹的则可以进行缩小。
            if (sbvsc.widthSizeInner.lBoundValInner.dimeSelfVal == nil)
            {
                fixedSizeWidth += rect.size.width;
                [fixedSizeSbs addObject:sbv];
            }
            
            if (sbvsc.widthSizeInner.dimeSelfVal != nil)
            {
                [flexedSizeSbs addObject:sbv];
            }
        }
        
        pos += rect.size.width;
        
        if (sbvsc.trailingPosInner.isRelativePos)
        {
            totalWeight += sbvsc.trailingPosInner.posNumVal.doubleValue;
            fixedWidth += sbvsc.trailingPosInner.offsetVal;
        }
        else
        {
            fixedWidth += sbvsc.trailingPosInner.absVal;
            
            if (sbvsc.trailingPosInner.absVal != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += sbvsc.trailingPosInner.absVal;
            }
            
        }
        
        pos += sbvsc.trailingPosInner.absVal;
        
        if (sbv != sbs.lastObject)
        {
            fixedWidth += subviewSpace;
            
            pos += subviewSpace;
            
            if (subviewSpace != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += subviewSpace;
            }
        }
        
        if (horzGravity == MyGravity_Horz_Fill)
        {
            BOOL canAddToNoWrapSbs = YES;
            
            if (sbvsc.weight != 0)
                canAddToNoWrapSbs = NO;
            
            //判断是否是添加到参与布局视图包裹计算的子视图。
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner)
                canAddToNoWrapSbs = NO;
            
            //如果子视图宽度是包裹的也不进行扩展
            if (sbvsc.wrapContentWidth)
                canAddToNoWrapSbs = NO;
            
            //如果子视图的最小宽度就是自身则也不进行扩展。
            if (sbvsc.widthSizeInner.lBoundValInner.dimeSelfVal != nil)
                canAddToNoWrapSbs = NO;
            
            if (canAddToNoWrapSbs)
                [noWrapsbsSet addObject:sbv];
        }
        
        sbvmyFrame.frame = rect;
    }
    
    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (lsc.wrapContentWidth && totalWeight != 0)
    {
        CGFloat tempSelfWidth = paddingHorz;
        if (sbs.count > 1)
            tempSelfWidth += (sbs.count - 1) * subviewSpace;
        
        selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:tempSelfWidth sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        
    }
    
    if (lsc.wrapContentHeight)
        selfSize.height = maxSelfHeight + paddingTop + paddingBottom;
    
    //这里需要特殊处理当子视图的尺寸宽度大于布局视图的宽度的情况。
    
    //剩余的可浮动的宽度，那些weight不为0的从这个宽度来进行分发
    BOOL isWeightShrinkSpace = NO;   //是否按比重缩小间距。。。
    CGFloat weightShrinkSpaceTotalWidth = 0;
    CGFloat floatingWidth = selfSize.width - fixedWidth - paddingHorz;
    //取出shrinkType中的模式和内容类型：
    MySubviewsShrinkType sstMode = lsc.shrinkType & 0x0F; //压缩的模式
    MySubviewsShrinkType sstContent = lsc.shrinkType & 0xF0; //压缩内容
    if (_myCGFloatLessOrEqual(floatingWidth, 0))
    {
        //如果压缩方式为自动，但是浮动宽度子视图数量不为2则压缩类型无效。
        if (sstMode == MySubviewsShrink_Auto && flexedSizeSbs.count != 2)
            sstMode = MySubviewsShrink_None;
        
        if (sstMode != MySubviewsShrink_None)
        {
            if (sstContent == MySubviewsShrink_Size)
            {
                if (fixedSizeSbs.count > 0 && totalWeight != 0 && floatingWidth < 0 && selfSize.width > 0)
                {
                    //均分。
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        CGFloat averageWidth = floatingWidth / fixedSizeSbs.count;
                        
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.myFrame.width += averageWidth;
                            
                        }
                    }
                    else if (sstMode == MySubviewsShrink_Auto)
                    {
                        
                        UIView *leadingView = flexedSizeSbs[0];
                        UIView *trailingView = flexedSizeSbs[1];
                        
                        CGFloat leadingWidth = leadingView.myFrame.width;
                        CGFloat trailingWidth = trailingView.myFrame.width;
                        
                        //如果2个都超过一半则总是一半显示。
                        //如果1个超过了一半则 如果两个没有超过总宽度则正常显示，如果超过了总宽度则超过一半的视图的宽度等于总宽度减去未超过一半的视图的宽度。
                        //如果没有一个超过一半。则正常显示
                        CGFloat layoutWidth = floatingWidth + leadingWidth + trailingWidth;
                        CGFloat halfLayoutWidth = layoutWidth / 2;
                        
                        if (_myCGFloatGreat(leadingWidth, halfLayoutWidth) && _myCGFloatGreat(trailingWidth,halfLayoutWidth))
                        {
                            leadingView.myFrame.width = halfLayoutWidth;
                            trailingView.myFrame.width = halfLayoutWidth;
                        }
                        else if ((_myCGFloatGreat(leadingWidth, halfLayoutWidth) || _myCGFloatGreat(trailingWidth, halfLayoutWidth)) && (_myCGFloatGreat(leadingWidth + trailingWidth, layoutWidth)))
                        {
                            
                            if (_myCGFloatGreat(leadingWidth, halfLayoutWidth))
                            {
                                trailingView.myFrame.width = trailingWidth;
                                leadingView.myFrame.width = layoutWidth - trailingWidth;
                            }
                            else
                            {
                                leadingView.myFrame.width = leadingWidth;
                                trailingView.myFrame.width = layoutWidth - leadingWidth;
                            }
                            
                        }
                        else ;
                        
                        
                    }
                    else if (_myCGFloatNotEqual(fixedSizeWidth, 0))
                    {//按比例分配。
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.myFrame.width += floatingWidth * (fsbv.myFrame.width / fixedSizeWidth);
                        }
                        
                    }
                }
            }
            else if (sstContent == MySubviewsShrink_Space)
            {
                if (fixedSpaceCount > 0 && floatingWidth < 0 && selfSize.width > 0 && fixedSpaceWidth > 0)
                {
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        addSpace = floatingWidth / fixedSpaceCount;
                    }
                    else if (sstMode == MySubviewsShrink_Weight)
                    {
                        isWeightShrinkSpace = YES;
                        weightShrinkSpaceTotalWidth = floatingWidth;
                    }
                }
                
            }
            else
            {
                ;
            }
            
        }
        
        
        
        floatingWidth = 0;
    }
    
    //如果有浮动尺寸或者有压缩模式
    if (totalWeight != 0 || (sstMode != MySubviewsShrink_None && _myCGFloatLessOrEqual(floatingWidth, 0)) || horzGravity != MyGravity_None || lsc.wrapContentHeight)
    {
        maxSelfHeight = 0;
        CGFloat between = 0; //间距扩充
        CGFloat fill = 0;    //尺寸扩充
        if (horzGravity == MyGravity_Horz_Center)
        {
            pos = (selfSize.width - fixedWidth - paddingHorz)/2.0 + paddingLeading;
        }
        else if (horzGravity == MyGravity_Horz_Window_Center)
        {
            if (self.window != nil)
            {
                pos = (CGRectGetWidth(self.window.bounds) - fixedWidth)/2.0;
                
                CGPoint pt = CGPointMake(pos, 0);
                pos = [self.window convertPoint:pt toView:self].x;
                
                
            }
        }
        else if (horzGravity == MyGravity_Horz_Trailing)
        {
            pos = selfSize.width - fixedWidth - paddingTrailing;
        }
        else if (horzGravity == MyGravity_Horz_Between)
        {
            pos = paddingLeading;
            
            if (sbs.count > 1)
                between = (selfSize.width - fixedWidth - paddingHorz) / (sbs.count - 1);
        }
        else if (horzGravity == MyGravity_Horz_Fill)
        {
            pos = paddingLeading;
            if (noWrapsbsSet.count > 0)
                fill = (selfSize.width - fixedWidth - paddingHorz) / noWrapsbsSet.count;
        }
        else
        {
            pos = paddingLeading;
        }
        
        for (UIView *sbv in sbs) {
            
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
            
            
            CGFloat leadingSpace = sbvsc.leadingPosInner.posNumVal.doubleValue;
            CGFloat trailingSpace = sbvsc.trailingPosInner.posNumVal.doubleValue;
            CGFloat weight = sbvsc.weight;
            CGRect rect =  sbvmyFrame.frame;
            
            //分别处理相对顶部间距和绝对顶部间距
            if ([self myIsRelativePos:leadingSpace])
            {
                CGFloat topSpaceWeight = leadingSpace;
                leadingSpace = _myCGFloatRound((topSpaceWeight / totalWeight) * floatingWidth);
                floatingWidth -= leadingSpace;
                totalWeight -= topSpaceWeight;
                if (_myCGFloatLessOrEqual(leadingSpace, 0))
                    leadingSpace = 0;
            }
            else
            {
                if (leadingSpace + sbvsc.leadingPosInner.offsetVal != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * (leadingSpace + sbvsc.leadingPosInner.offsetVal) / fixedSpaceWidth;
                    }
                }
                
            }
            
            pos += [self myValidMargin:sbvsc.leadingPosInner sbv:sbv calcPos:leadingSpace + sbvsc.leadingPosInner.offsetVal selfLayoutSize:selfSize];
            rect.origin.x = pos;
            
            //分别处理相对高度和绝对高度
            if (weight != 0)
            {
                CGFloat w = _myCGFloatRound((weight / totalWeight) * floatingWidth);
                floatingWidth -= w;
                totalWeight -= weight;
                if (_myCGFloatLessOrEqual(w, 0))
                    w = 0;
                
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:w sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            //加上扩充的宽度。
            if (fill != 0 && [noWrapsbsSet containsObject:sbv])
                rect.size.width += fill;
            
            //特殊处理高度依赖宽度的情况。
            if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            {//特殊处理高度等于宽度的情况
                rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            }
            
            CGFloat tempSelfHeight = [self myCalcSubviewTopBottomRect:vertGravity
                                    selfSize:selfSize
                                       pRect:&rect
                                         sbv:sbv
                                  paddingTop:paddingTop
                               paddingBottom:paddingBottom
                                 baselinePos:baselinePos
                                       sbvsc:sbvsc
                                         lsc:lsc];
            
            if ((tempSelfHeight > maxSelfHeight) &&
                (lsc.heightSizeInner == nil || (sbvsc.heightSizeInner.dimeRelaVal != lsc.heightSizeInner))  &&
                (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil))
            {
                maxSelfHeight = tempSelfHeight;
            }
    
            pos += rect.size.width;
            
            //计算相对的右边边距和绝对的右边边距
            if ([self myIsRelativePos:trailingSpace])
            {
                CGFloat trailingSpaceWeight = trailingSpace;
                trailingSpace = _myCGFloatRound((trailingSpaceWeight / totalWeight) * floatingWidth);
                floatingWidth -= trailingSpace;
                totalWeight -= trailingSpaceWeight;
                if (_myCGFloatLessOrEqual(trailingSpace, 0))
                    trailingSpace = 0;
            }
            else
            {
                if (trailingSpace + sbvsc.trailingPosInner.offsetVal != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * (trailingSpace + sbvsc.trailingPosInner.offsetVal) / fixedSpaceWidth;
                    }
                }
            }
            
            pos += [self myValidMargin:sbvsc.trailingPosInner sbv:sbv calcPos:trailingSpace + sbvsc.trailingPosInner.offsetVal selfLayoutSize:selfSize];
            
            //添加共有的子视图间距
            if (sbv != sbs.lastObject)
            {
                pos += subviewSpace;
                
                if (subviewSpace != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * subviewSpace / fixedSpaceWidth;
                    }
                }
                
                pos += between;  //只有mgvert为between才加这个间距拉伸。
            }
            
            sbvmyFrame.frame = rect;
        }
        
    }
    
    pos += paddingTrailing;
    
    if (lsc.wrapContentWidth)
        selfSize.width = pos;
    
    if (lsc.wrapContentHeight)
        selfSize.height = maxSelfHeight + paddingTop + paddingBottom;
    
    return selfSize;
}

- (CGFloat)myCalcSubviewLeadingTrailingRect:(MyGravity)horzGravity selfSize:(CGSize)selfSize pRect:(CGRect *)pRect sbv:(UIView *)sbv paddingTrailing:(CGFloat)paddingTrailing paddingLeading:(CGFloat)paddingLeading sbvsc:(UIView *)sbvsc lsc:(MyLinearLayout*)lsc
{
    
    pRect->size.width = [self myGetSubviewWidthSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:lsc.myLayoutTopPadding paddingLeading:paddingLeading paddingBottom:lsc.myLayoutBottomPadding paddingTrailing:paddingTrailing sbvSize:pRect->size];
    
    if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        pRect->size.width = selfSize.width - paddingLeading - paddingTrailing - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal;
    
    pRect->size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:pRect->size.width sbvSize:pRect->size selfLayoutSize:selfSize];
    
   return [self myCalcHorzGravity:[self myGetSubviewHorzGravity:sbv sbvsc:sbvsc horzGravity:horzGravity] sbv:sbv sbvsc:sbvsc paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:pRect];
}

- (CGFloat)myCalcSubviewTopBottomRect:(MyGravity)vertGravity selfSize:(CGSize)selfSize pRect:(CGRect *)pRect sbv:(UIView *)sbv paddingTop:(CGFloat)paddingTop paddingBottom:(CGFloat)paddingBottom  baselinePos:(CGFloat)baselinePos sbvsc:(UIView *)sbvsc lsc:(MyLinearLayout*)lsc
{
    pRect->size.height = [self myGetSubviewHeightSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:lsc.myLayoutLeadingPadding paddingBottom:paddingBottom paddingTrailing:lsc.myLayoutTrailingPadding sbvSize:pRect->size];

    if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        pRect->size.height = selfSize.height - paddingTop - paddingBottom - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal;
    
    
    pRect->size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:pRect->size.height sbvSize:pRect->size selfLayoutSize:selfSize];
    
    return [self myCalcVertGravity:[self myGetSubviewVertGravity:sbv sbvsc:sbvsc vertGravity:vertGravity] sbv:sbv sbvsc:sbvsc paddingTop:paddingTop paddingBottom:paddingBottom  baselinePos:baselinePos selfSize:selfSize pRect:pRect];
}

-(void)myEqualizeSubviewsForVert:(BOOL)centered withSpace:(CGFloat)margin
{
    
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    
    CGFloat scale;
    CGFloat scale2;
    NSArray *sbs = [self myGetLayoutSubviews];
    if (margin == CGFLOAT_MAX)
    {
        CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
        scale = 1 / fragments;
        scale2 = scale;
        
    }
    else
    {
        scale = 1.0;
        scale2 = margin;
    }
    
    
    for (UIView *sbv in sbs)
    {
        UIView *sbvsc = sbv.myCurrentSizeClass;
        
        [sbvsc.bottomPos __equalTo:@0];
        [sbvsc.topPos __equalTo:@(scale2)];
        sbvsc.weight = scale;
        
        if (sbv == sbs.firstObject && !centered)
            [sbvsc.topPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbvsc.bottomPos __equalTo:@(scale2)];
    }
    
}

-(void)myEqualizeSubviewsForHorz:(BOOL)centered withSpace:(CGFloat)space
{
    
    
    NSArray *sbs = [self myGetLayoutSubviews];
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat scale;
    CGFloat scale2;
    
    if (space == CGFLOAT_MAX)
    {
        CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
        scale = 1 / fragments;
        scale2 = scale;
        
    }
    else
    {
        scale = 1.0;
        scale2 = space;
    }
    
    for (UIView *sbv in sbs)
    {
        UIView *sbvsc = sbv.myCurrentSizeClass;
        
        [sbvsc.trailingPos __equalTo:@0];
        [sbvsc.leadingPos __equalTo:@(scale2)];
        sbvsc.weight = scale;
        
        if (sbv == sbs.firstObject && !centered)
            [sbvsc.leadingPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbvsc.trailingPos __equalTo:@(scale2)];
    }
    
}


-(void)myEqualizeSubviewsSpaceForVert:(BOOL)centered
{
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    NSArray *sbs = [self myGetLayoutSubviews];
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (UIView *sbv in sbs)
    {
        UIView *sbvsc = sbv.myCurrentSizeClass;

        [sbvsc.topPos __equalTo:@(scale)];
        
        if (sbv == sbs.firstObject && !centered)
            [sbvsc.topPos __equalTo:@0];
        
        if (sbv == sbs.lastObject)
            [sbvsc.bottomPos __equalTo: centered? @(scale) : @0];
    }
    
    
}

-(void)myEqualizeSubviewsSpaceForHorz:(BOOL)centered
{
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    NSArray *sbs = [self myGetLayoutSubviews];
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (UIView *sbv in sbs)
    {
        UIView *sbvsc = sbv.myCurrentSizeClass;

        [sbvsc.leadingPos __equalTo:@(scale)];
        
        if (sbv == sbs.firstObject && !centered)
            [sbvsc.leadingPos __equalTo:@0];
        
        if (sbv == sbs.lastObject)
            [sbvsc.trailingPos __equalTo:centered? @(scale) : @0];
    }
}

@end

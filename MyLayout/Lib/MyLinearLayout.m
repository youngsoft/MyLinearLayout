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
            [lsc.heightSize __equalTo:@(MyLayoutSize.wrap) priority:MyPriority_Low];  //这是暂时先设置为低优先级,为了兼容老版本。
        else
            [lsc.widthSize __equalTo:@(MyLayoutSize.wrap) priority:MyPriority_Low];
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
    [self equalizeSubviews:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

-(void)equalizeSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    [self equalizeSubviews:centered withSpace:CGFLOAT_MAX inSizeClass:sizeClass];
}

-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space
{
    [self equalizeSubviews:centered withSpace:space inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
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

    [self setNeedsLayout];
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

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered
{
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace centered:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace centered:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    MySequentLayoutViewSizeClass *lsc = (MySequentLayoutViewSizeClass*)[self fetchLayoutSizeClass:sizeClass];
    if (subviewSize == 0)
    {
        lsc.flexSpace = nil;
    }
    else
    {
        if (lsc.flexSpace == nil)
            lsc.flexSpace = [MySequentLayoutFlexSpace new];
        
        lsc.flexSpace.subviewSize = subviewSize;
        lsc.flexSpace.minSpace = minSpace;
        lsc.flexSpace.maxSpace = maxSpace;
        lsc.flexSpace.centered = centered;
    }
    [self setNeedsLayout];
}


#pragma mark -- Override Methods

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    if (subview == self.baselineBaseView)
        self.baselineBaseView = nil;
}

-(CGSize)calcLayoutSize:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray *)sbs
{
    CGSize selfSize = [super calcLayoutSize:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    MyLinearLayoutViewSizeClass *lsc = (MyLinearLayoutViewSizeClass*)self.myCurrentSizeClass;
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = lsc.gravity & MyGravity_Vert_Mask;
    MyOrientation orientation = lsc.orientation;
    
    [self myCalcSubviewsWrapContentSize:sbs isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass withCustomSetting:^(MyViewSizeClass *sbvsc) {
        
        [self myLayout:lsc orientation:orientation gravity:(orientation == MyOrientation_Vert)? horzGravity : vertGravity adjustSizeSettingOfSubview:sbvsc];
    }];
    
    if (orientation == MyOrientation_Vert)
        selfSize = [self myVertOrientationLayout:lsc calcRectOfSubviews:sbs withSelfSize:selfSize];
    else
        selfSize = [self myHorzOrientationLayout:lsc calcRectOfSubviews:sbs withSelfSize:selfSize];
    
    //绘制智能线。
    if (!isEstimate)
        [self myLayout:lsc setIntelligentBorderlineOnSubviews:sbs];
    
    return [self myLayout:lsc adjustSelfSize:selfSize withSubviews:sbs];
}

-(id)createSizeClassInstance
{
    return [MyLinearLayoutViewSizeClass new];
}

#pragma mark -- Private Methods

//调整子视图的wrapContent设置
- (void)myLayout:(MyLinearLayoutViewSizeClass*)lsc orientation:(MyOrientation)orientation gravity:(MyGravity)gravity adjustSizeSettingOfSubview:(MyViewSizeClass*)sbvsc
{
    if (orientation == MyOrientation_Vert)
    {
        //如果是拉伸处理则需要把包裹宽度取消。
        if (sbvsc.widthSizeInner.dimeWrapVal && gravity == MyGravity_Horz_Fill)
            [sbvsc.widthSizeInner __equalTo:nil];
        
        //如果同时设置了左右依赖。并且优先级低时或者布局视图不是宽度自适应则取消自视图宽度自适应，这里是为了兼容老版本。
        if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil && (sbvsc.widthSizeInner.priority == MyPriority_Low || !lsc.widthSizeInner.dimeWrapVal))
            [sbvsc.widthSizeInner __equalTo:nil];
        
        //只要同时设置了高度或者比重属性则应该把尺寸设置为空
        if (sbvsc.heightSizeInner.dimeWrapVal && sbvsc.weight != 0)
            [sbvsc.heightSizeInner __equalTo:nil];
    }
    else
    {
        //如果是拉伸处理则需要把包裹高度
        if (sbvsc.heightSizeInner.dimeWrapVal && gravity == MyGravity_Vert_Fill)
            [sbvsc.heightSizeInner __equalTo:nil];
        
        //如果同时设置了左右依赖。并且优先级低时则取消宽度自适应，这里是为了兼容老版本。
        if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil && (sbvsc.heightSizeInner.priority == MyPriority_Low || !lsc.heightSizeInner.dimeWrapVal))
            [sbvsc.heightSizeInner __equalTo:nil];
        
        //只要同时设置了宽度或者比重属性则应该把宽度置空
        if (sbvsc.widthSizeInner.dimeWrapVal && sbvsc.weight != 0)
            [sbvsc.widthSizeInner __equalTo:nil];
    }
}

//设置智能边界线
-(void)myLayout:(MyLinearLayoutViewSizeClass*)lsc setIntelligentBorderlineOnSubviews:(NSArray*)sbs
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
            prevSiblingView = sbs[i - 1];
        
        if (i + 1 != sbs.count)
            nextSiblingView = sbs[i + 1];
        
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

-(CGSize)myVertOrientationLayout:(MyLinearLayoutViewSizeClass*)lsc calcRectOfSubviews:(NSArray*)sbs withSelfSize:(CGSize)selfSize
{
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;

    CGFloat subviewSpace = lsc.subviewVSpace;
    CGFloat subviewSize = [lsc.flexSpace calcMaxMinSubviewSize:selfSize.height arrangedCount:sbs.count startPadding:&paddingTop endPadding:&paddingBottom space:&subviewSpace];
    CGFloat paddingVert = paddingTop + paddingBottom;
    CGFloat fixedHeight = 0.0;   //计算固定部分的高度
    CGFloat totalWeight = 0.0;    //剩余部分的总比重
    CGFloat totalShrink = 0.0;    //总的压缩比重
    CGFloat addSpace = 0.0;      //用于压缩时的间距压缩增量。
    CGFloat maxSelfWidth = 0.0;

   
    //高度可以被伸缩的子视图集合
    NSMutableSet *flexSbsSet = [NSMutableSet new];
    //高度是固定尺寸的子视图集合
    NSMutableArray *fixedSbsSet = [NSMutableArray new];
    CGFloat fixedSizeHeight = 0.0;
    NSInteger fixedSpaceCount = 0.0;  //固定间距的子视图数量。
    CGFloat  fixedSpaceHeight = 0.0;  //固定间距的子视图的高度。
    CGFloat pos = paddingTop;
    for (UIView *sbv in sbs)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
        CGRect rect = sbvmyFrame.frame;
        
        if (vertGravity == MyGravity_Vert_Fill || vertGravity == MyGravity_Vert_Stretch)
        {
            BOOL isFlexSbv = YES;
            
            //比重高度的子视图不能被伸缩。
            if (sbvsc.weight != 0.0)
                isFlexSbv = NO;
            
            //高度依赖于父视图的不能被伸缩
            if ((sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner) || sbvsc.heightSizeInner.dimeFillVal)
                isFlexSbv = NO;
            
            //布局视图的高度自适应尺寸的不能被伸缩。
            if (sbvsc.heightSizeInner.dimeWrapVal && [sbv isKindOfClass:[MyBaseLayout class]])
                isFlexSbv = NO;
            
            //高度最小是自身尺寸的不能被伸缩。
            if (sbvsc.heightSizeInner.lBoundValInner.dimeWrapVal)
                isFlexSbv = NO;
            
            //对于拉伸来说，只要是设置了高度约束(除了非布局子视图的高度自适应除外)都不会被伸缩
            if (vertGravity == MyGravity_Vert_Stretch &&
                sbvsc.heightSizeInner.dimeVal != nil &&
                (!sbvsc.heightSizeInner.dimeWrapVal || [sbv isKindOfClass:[MyBaseLayout class]]))
                isFlexSbv = NO;
            
            if (isFlexSbv)
                [flexSbsSet addObject:sbv];
            
            //在计算拉伸时，如果没有设置宽度约束则将宽度设置为0
            if (sbvsc.heightSizeInner.dimeVal == nil && !sbvsc.heightSizeInner.lBoundValInner.dimeWrapVal)
                rect.size.height = 0;
        }
    
        //计算子视图的高度
        if (subviewSize != 0.0)
            rect.size.height = subviewSize;
        else
            rect.size.height = [self myLayout:lsc heightSizeValueOfSubview:sbvsc selfSize:selfSize sbvSize:rect.size paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing];
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

        //特殊处理宽度等于高度的情况
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
        
        //计算子视图宽度以及对齐, 先计算宽度的原因是处理那些高度依赖宽度并且是wrap的情况。
        CGFloat tempSelfWidth = [self myLayout:lsc
                                   calcSubview:sbvsc
                           leadingTrailingRect:&rect
                                   horzGravity:horzGravity
                               paddingTrailing:paddingTrailing
                                paddingLeading:paddingLeading
                                      selfSize:selfSize];
        
        //左右依赖的，或者依赖父视图宽度的不参数最宽计算！！
        if ((tempSelfWidth > maxSelfWidth) &&
            (sbvsc.widthSizeInner.dimeRelaVal == nil || sbvsc.widthSizeInner.dimeRelaVal != lsc.widthSizeInner) &&
            !sbvsc.widthSizeInner.dimeFillVal &&
            (sbvsc.leadingPosInner.posVal == nil || sbvsc.trailingPosInner.posVal == nil || sbvsc.widthSizeInner.dimeVal != nil))
        {
            maxSelfWidth = tempSelfWidth;
        }
        
        if (subviewSize == 0.0)
        {
            if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            {//特殊处理高度等于宽度的情况
                
                rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            //再次特殊处理高度包裹的场景
            if (sbvsc.heightSizeInner.dimeWrapVal && ![sbv isKindOfClass:[MyBaseLayout class]])
            {
                rect.size.height = [self mySubview:sbvsc wrapHeightSizeFits:rect.size.width];
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            }
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
            
            if (sbvsc.topPosInner.absVal != 0.0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += sbvsc.topPosInner.absVal;
            }
        }
        
        totalShrink += sbvsc.topPosInner.shrink;
        
        pos += sbvsc.topPosInner.absVal;
        rect.origin.y = pos;
        
        if (sbvsc.weight != 0.0)
        {
            totalWeight += sbvsc.weight;
        }
        else
        {
            fixedHeight += rect.size.height;
            totalShrink += sbvsc.heightSizeInner.shrink;
            
            //如果最小高度不为自身并且高度不是包裹的则可以进行缩小。
            if (!sbvsc.heightSizeInner.lBoundValInner.dimeWrapVal)
            {
                fixedSizeHeight += rect.size.height;
                [fixedSbsSet addObject:sbv];
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
            
            if (sbvsc.bottomPosInner.absVal != 0.0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += sbvsc.bottomPosInner.absVal;
            }
        }
        totalShrink += sbvsc.bottomPosInner.shrink;
        
        pos += sbvsc.bottomPosInner.absVal;
        
        if (sbv != sbs.lastObject)
        {
            fixedHeight += subviewSpace;
            
            pos += subviewSpace;
            
            if (subviewSpace != 0.0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += subviewSpace;
            }
        }
        
        sbvmyFrame.frame = rect;
    }
    
    if (lsc.heightSizeInner.dimeWrapVal)
    {
        if (totalWeight != 0.0)
        { //在包裹高度且总体比重不为0时则，则需要还原最小的高度，这样就不会使得高度在横竖屏或者多次计算后越来高。
            CGFloat tempSelfHeight = paddingVert;
            if (sbs.count > 1)
                tempSelfHeight += (sbs.count - 1) * subviewSpace;
            
            selfSize.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:tempSelfHeight sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        }
        else
        {
            selfSize.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:fixedHeight + paddingVert sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        }
        
        //如果是高度自适应则不需要压缩。
        totalShrink = 0.0;
    }
    
    if (lsc.widthSizeInner.dimeWrapVal)
    {
        selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:maxSelfWidth + paddingLeading + paddingTrailing sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    }

    //这里需要特殊处理当子视图的尺寸高度大于布局视图的高度的情况。
    BOOL isWeightShrinkSpace = NO;   //是否按比重缩小间距。
    CGFloat weightShrinkSpaceTotalHeight = 0;
    CGFloat spareHeight = selfSize.height - fixedHeight - paddingVert;  //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    //取出shrinkType中的模式和内容类型：
    MySubviewsShrinkType sstMode = lsc.shrinkType & 0x0F; //压缩的模式
    MySubviewsShrinkType sstContent = lsc.shrinkType & 0xF0; //压缩内容
    
    //如果子视图设置了压缩比重则ssMode不起作用
    if (totalShrink != 0.0)
        sstMode = MySubviewsShrink_None;
    
    if (_myCGFloatLessOrEqual(spareHeight, 0))
    {
        if (sstMode != MySubviewsShrink_None)
        {
            if (sstContent == MySubviewsShrink_Size)
            {//压缩尺寸
                if (fixedSbsSet.count > 0 && spareHeight < 0 && selfSize.height > 0)
                {
                    if (sstMode == MySubviewsShrink_Average)
                    {//均分。
                        CGFloat averageHeight = spareHeight / fixedSbsSet.count;
                        
                        for (UIView *fsbv in fixedSbsSet)
                        {
                            fsbv.myFrame.height += averageHeight;
                        }
                    }
                    else if (_myCGFloatNotEqual(fixedSizeHeight, 0))
                    {//按比例分配。
                        for (UIView *fsbv in fixedSbsSet)
                        {
                            fsbv.myFrame.height += spareHeight * (fsbv.myFrame.height / fixedSizeHeight);
                        }
                        
                    }
                }
            }
            else if (sstContent == MySubviewsShrink_Space)
            {//压缩间距
                if (fixedSpaceCount > 0 && spareHeight < 0 && selfSize.height > 0 && fixedSpaceHeight > 0)
                {
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        addSpace = spareHeight / fixedSpaceCount;
                    }
                    else if (sstMode == MySubviewsShrink_Weight)
                    {
                        isWeightShrinkSpace = YES;
                        weightShrinkSpaceTotalHeight = spareHeight;
                    }
                }
            }
            else
            {
                ;
            }
        }

        if (totalShrink == 0.0)
            spareHeight = 0.0;
    }
    else
    {
        //如果不需要压缩则压缩比设置为0
        totalShrink = 0.0;
    }
    
    //如果是总的压缩比重不为0则认为固定高度和布局视图高度保持一致。
    if (totalShrink != 0.0)
        fixedHeight = selfSize.height - paddingVert;
    
    //如果有浮动尺寸或者有压缩模式
    if (totalWeight != 0.0 || totalShrink != 0.0 ||  (sstMode != MySubviewsShrink_None && _myCGFloatLessOrEqual(spareHeight, 0)) || vertGravity != MyGravity_None || lsc.widthSizeInner.dimeWrapVal)
    {
        maxSelfWidth = 0.0;
        CGFloat between = 0.0; //间距扩充
        CGFloat fill = 0.0;    //尺寸扩充
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
        else if (vertGravity == MyGravity_Vert_Around)
        {
            //around停靠中如果子视图数量大于1则间距均分，并且首尾子视图和父视图的间距为均分的一半，如果子视图数量为1则一个子视图垂直居中。
            if (sbs.count > 1)
            {
                between = (selfSize.height - fixedHeight - paddingVert) / sbs.count;
                pos = paddingTop + between / 2;
            }
            else
            {
                pos = (selfSize.height - fixedHeight - paddingVert)/2.0 + paddingTop;
            }
        }
        else if (vertGravity == MyGravity_Vert_Among)
        {
            between = (selfSize.height - fixedHeight - paddingVert) / (sbs.count + 1);
            pos = paddingTop + between;
        }
        else if (vertGravity == MyGravity_Vert_Fill || vertGravity == MyGravity_Vert_Stretch)
        {
            pos = paddingTop;
            if (flexSbsSet.count > 0)
                fill = (selfSize.height - fixedHeight - paddingVert) / flexSbsSet.count;
        }
        else
        {
            pos = paddingTop;
        }
        
        for (UIView *sbv in sbs) {
            
            MyFrame *sbvmyFrame = sbv.myFrame;
            MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
            
            CGFloat topSpace = sbvsc.topPosInner.posNumVal.doubleValue;
            CGFloat bottomSpace = sbvsc.bottomPosInner.posNumVal.doubleValue;
            CGFloat weight = sbvsc.weight;
            CGRect rect =  sbvmyFrame.frame;
            
            //分别处理相对顶部间距和绝对顶部间距
            if ([self myIsRelativePos:topSpace])
            {
                CGFloat topSpaceWeight = topSpace;
                topSpace = _myCGFloatRound((topSpaceWeight / totalWeight) * spareHeight);
                if (_myCGFloatLessOrEqual(topSpace, 0))
                    topSpace = 0;
            }
            else
            {
                if (topSpace + sbvsc.topPosInner.offsetVal != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                        pos += weightShrinkSpaceTotalHeight * (topSpace + sbvsc.topPosInner.offsetVal) / fixedSpaceHeight;
                }
            }
            
            topSpace += sbvsc.topPosInner.offsetVal;
            if (totalShrink != 0.0 && sbvsc.topPosInner.shrink != 0.0)
                topSpace += (sbvsc.topPosInner.shrink / totalShrink) * spareHeight;
            
            pos += [self myValidMargin:sbvsc.topPosInner sbv:sbv calcPos:topSpace selfLayoutSize:selfSize];
            rect.origin.y = pos;
            
            //分别处理相对高度和绝对高度
            if (weight != 0)
            {
                CGFloat h = _myCGFloatRound((weight / totalWeight) * spareHeight);
                if (_myCGFloatLessOrEqual(h, 0))
                    h = 0;
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:h sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            //加上扩充的宽度。
            if (fill != 0 && [flexSbsSet containsObject:sbv])
                rect.size.height += fill;
            
            if (totalShrink != 0.0 && sbvsc.heightSizeInner.shrink != 0.0)
            {
                rect.size.height += (sbvsc.heightSizeInner.shrink / totalShrink) * spareHeight;
                if (rect.size.height < 0.0)
                    rect.size.height = 0.0;
            }
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            {//特殊处理宽度等于高度的情况
                rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            }
            
            //计算子视图宽度以及对齐
            CGFloat tempSelfWidth = [self myLayout:lsc
                                       calcSubview:sbvsc
                               leadingTrailingRect:&rect
                                       horzGravity:horzGravity
                                   paddingTrailing:paddingTrailing
                                    paddingLeading:paddingLeading
                                          selfSize:selfSize];
            
            if ((tempSelfWidth > maxSelfWidth) &&
                (sbvsc.widthSizeInner.dimeRelaVal == nil || sbvsc.widthSizeInner.dimeRelaVal != lsc.widthSizeInner) &&
                !sbvsc.widthSizeInner.dimeFillVal &&
                (sbvsc.leadingPosInner.posVal == nil || sbvsc.trailingPosInner.posVal == nil || sbvsc.widthSizeInner.dimeVal != nil))
            {
                maxSelfWidth = tempSelfWidth;
            }
            
            pos += rect.size.height;
            
            //分别处理相对底部间距和绝对底部间距
            if ([self myIsRelativePos:bottomSpace])
            {
                CGFloat bottomSpaceWeight = bottomSpace;
                bottomSpace = _myCGFloatRound((bottomSpaceWeight / totalWeight) * spareHeight);
                if ( _myCGFloatLessOrEqual(bottomSpace, 0))
                    bottomSpace = 0;
            }
            else
            {
                if (bottomSpace + sbvsc.bottomPosInner.offsetVal != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                        pos += weightShrinkSpaceTotalHeight * (bottomSpace + sbvsc.bottomPosInner.offsetVal) / fixedSpaceHeight;
                }
            }
            
            bottomSpace += sbvsc.bottomPosInner.offsetVal;
            if (totalShrink != 0.0 && sbvsc.bottomPosInner.shrink != 0.0)
                bottomSpace += (sbvsc.bottomPosInner.shrink / totalShrink) * spareHeight;
            
            pos += [self myValidMargin:sbvsc.bottomPosInner sbv:sbv calcPos:bottomSpace selfLayoutSize:selfSize];
            
            //添加共有的子视图间距
            if (sbv != sbs.lastObject)
            {
                pos += subviewSpace;
                
                if (subviewSpace != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                        pos += weightShrinkSpaceTotalHeight * subviewSpace / fixedSpaceHeight;
                }
                
                pos += between;  //只有mgvert为between才加这个间距拉伸。
            }
            
            sbvmyFrame.frame = rect;
        }
    }
    
    pos += paddingBottom;

    if (lsc.heightSizeInner.dimeWrapVal)
        selfSize.height = pos;
    
    if (lsc.widthSizeInner.dimeWrapVal)
        selfSize.width = maxSelfWidth + paddingLeading + paddingTrailing;
    
    return selfSize;
}

-(CGSize)myHorzOrientationLayout:(MyLinearLayoutViewSizeClass*)lsc calcRectOfSubviews:(NSArray*)sbs withSelfSize:(CGSize)selfSize
{
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    
    CGFloat subviewSpace = lsc.subviewHSpace;
    CGFloat subviewSize = [lsc.flexSpace calcMaxMinSubviewSize:selfSize.width arrangedCount:sbs.count startPadding:&paddingLeading endPadding:&paddingTrailing space:&subviewSpace];
    CGFloat fixedWidth = 0.0;   //计算固定部分的宽度
    CGFloat totalWeight = 0.0;    //剩余部分的总比重
    CGFloat totalShrink = 0.0;    //总的压缩比重
    CGFloat addSpace = 0.0;      //用于压缩时的间距压缩增量。
    CGFloat paddingHorz = paddingLeading + paddingTrailing;

    //宽度是可伸缩的子视图集合
    NSMutableSet *flexSbsSet = [NSMutableSet new];
    //宽度是固定尺寸的子视图集合
    NSMutableArray *fixedSbsSet = [NSMutableArray new];
    //左右拉伸宽度尺寸的子视图集合
    NSMutableArray *leftRightFlexSbs = [NSMutableArray new];
    CGFloat fixedSizeWidth = 0.0;   //固定尺寸视图的宽度
    NSInteger fixedSpaceCount = 0.0;  //固定间距的子视图数量。
    CGFloat  fixedSpaceWidth = 0.0;  //固定间距的子视图的宽度。
    CGFloat baselinePos = CGFLOAT_MAX;  //保存基线的值。
    CGFloat pos = paddingLeading;
    CGFloat maxSelfHeight = 0.0;
    for (UIView *sbv in sbs)
    {
        //计算出固定宽度部分以及weight部分。这里的宽度可能依赖高度。如果不是高度包裹则计算出所有高度。
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
        CGRect rect = sbvmyFrame.frame;
        
        if (horzGravity == MyGravity_Horz_Fill || horzGravity == MyGravity_Horz_Stretch)
        {
            BOOL isFlexSbv = YES;
            
            //设置了比重宽度的子视图不伸缩
            if (sbvsc.weight != 0.0)
                isFlexSbv = NO;
            
            //宽度依赖父视图宽度的不伸缩
            if ((sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner) || sbvsc.widthSizeInner.dimeFillVal)
                isFlexSbv = NO;
            
            //布局子视图宽度自适应时不伸缩
            if (sbvsc.widthSizeInner.dimeWrapVal && [sbv isKindOfClass:[MyBaseLayout class]])
                isFlexSbv = NO;
            
            //子视图宽度最小为自身宽度时不伸缩。
            if (sbvsc.widthSizeInner.lBoundValInner.dimeWrapVal)
                isFlexSbv = NO;
            
            //对于拉伸来说，只要是设置了宽度约束(除了非布局子视图的宽度自适应除外)都不会被伸缩
            if (horzGravity == MyGravity_Horz_Stretch &&
                sbvsc.widthSizeInner.dimeVal != nil &&
                (!sbvsc.widthSizeInner.dimeWrapVal || [sbv isKindOfClass:[MyBaseLayout class]]))
                isFlexSbv = NO;
            
            if (isFlexSbv)
                [flexSbsSet addObject:sbv];
            
            //在计算拉伸时，如果没有设置宽度约束则将宽度设置为0
            if (sbvsc.widthSizeInner.dimeVal == nil && !sbvsc.widthSizeInner.lBoundValInner.dimeWrapVal)
                rect.size.width = 0.0;
        }
        
        //计算子视图的宽度，这里不管是否设置约束以及是否宽度是weight的都是进行计算。
        if (subviewSize != 0.0)
            rect.size.width = subviewSize;
        else
            rect.size.width = [self myLayout:lsc widthSizeValueOfSubview:sbvsc selfSize:selfSize sbvSize:rect.size paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing];
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {//特殊处理高度等于宽度的情况
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        }
        
        //计算子视图高度以及对齐
        CGFloat tempSelfHeight = [self myLayout:lsc
                                    calcSubview:sbvsc
                                  topBottomRect:&rect
                                    vertGravity:vertGravity
                                     paddingTop:paddingTop
                                  paddingBottom:paddingBottom
                                    baselinePos:baselinePos
                                       selfSize:selfSize];
        
        if ((tempSelfHeight > maxSelfHeight) &&
            (sbvsc.heightSizeInner.dimeRelaVal == nil || sbvsc.heightSizeInner.dimeRelaVal != lsc.heightSizeInner) &&
            !sbvsc.heightSizeInner.dimeFillVal &&
            (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil || sbvsc.heightSizeInner.dimeVal != nil))
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
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner && subviewSize == 0.0)
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
            
            if (sbvsc.leadingPosInner.absVal != 0.0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += sbvsc.leadingPosInner.absVal;
            }
        }
        
        totalShrink += sbvsc.leadingPosInner.shrink;
        
        pos += sbvsc.leadingPosInner.absVal;
        rect.origin.x = pos;
        
        if (sbvsc.weight != 0.0)
        {
            totalWeight += sbvsc.weight;
        }
        else
        {
            fixedWidth += rect.size.width;
            totalShrink += sbvsc.widthSizeInner.shrink;
            
            //如果最小宽度不为自身并且宽度不是包裹的则可以进行缩小。
            if (!sbvsc.widthSizeInner.lBoundValInner.dimeWrapVal)
            {
                fixedSizeWidth += rect.size.width;
                [fixedSbsSet addObject:sbv];
            }
            
            if (sbvsc.widthSizeInner.dimeWrapVal)
            {
                [leftRightFlexSbs addObject:sbv];
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
            
            if (sbvsc.trailingPosInner.absVal != 0.0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += sbvsc.trailingPosInner.absVal;
            }
        }
        totalShrink += sbvsc.trailingPosInner.shrink;
        
        pos += sbvsc.trailingPosInner.absVal;
        
        if (sbv != sbs.lastObject)
        {
            fixedWidth += subviewSpace;
            
            pos += subviewSpace;
            
            if (subviewSpace != 0.0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += subviewSpace;
            }
        }
        
        sbvmyFrame.frame = rect;
    }
    
    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (lsc.widthSizeInner.dimeWrapVal)
    {
        if (totalWeight != 0.0)
        {
            CGFloat tempSelfWidth = paddingHorz;
            if (sbs.count > 1)
                tempSelfWidth += (sbs.count - 1) * subviewSpace;
            
            selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:tempSelfWidth sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        }
        else
        {
            selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:fixedWidth + paddingHorz sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        }
        
        //如果是宽度自适应则不需要压缩。
        totalShrink = 0.0;
    }
    
    if (lsc.heightSizeInner.dimeWrapVal)
    {
        selfSize.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:maxSelfHeight + paddingTop + paddingBottom sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    }
    
    //这里需要特殊处理当子视图的尺寸宽度大于布局视图的宽度的情况.
    //剩余的可浮动的宽度，那些weight不为0的从这个宽度来进行分发
    BOOL isWeightShrinkSpace = NO;   //是否按比重缩小间距。。。
    CGFloat weightShrinkSpaceTotalWidth = 0.0;
    CGFloat spareWidth = selfSize.width - fixedWidth - paddingHorz;
    //取出shrinkType中的模式和内容类型：
    MySubviewsShrinkType sstMode = lsc.shrinkType & 0x0F; //压缩的模式
    MySubviewsShrinkType sstContent = lsc.shrinkType & 0xF0; //压缩内容
    
    //如果子视图设置了压缩比重则ssMode不起作用
    if (totalShrink != 0.0)
        sstMode = MySubviewsShrink_None;
    
    if (_myCGFloatLessOrEqual(spareWidth, 0.0))
    {
        //如果压缩方式为自动，但是浮动宽度子视图数量不为2则压缩类型无效。
        if (sstMode == MySubviewsShrink_Auto && leftRightFlexSbs.count != 2)
            sstMode = MySubviewsShrink_None;
        
        if (sstMode != MySubviewsShrink_None)
        {
            if (sstContent == MySubviewsShrink_Size)
            {
                if (fixedSbsSet.count > 0 && spareWidth < 0 && selfSize.width > 0)
                {
                    //均分。
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        CGFloat averageWidth = spareWidth / fixedSbsSet.count;
                        
                        for (UIView *fsbv in fixedSbsSet)
                        {
                            fsbv.myFrame.width += averageWidth;
                        }
                    }
                    else if (sstMode == MySubviewsShrink_Auto)
                    {
                        UIView *leadingView = leftRightFlexSbs[0];
                        UIView *trailingView = leftRightFlexSbs[1];
                        CGFloat leadingWidth = leadingView.myFrame.width;
                        CGFloat trailingWidth = trailingView.myFrame.width;
                        
                        //如果2个都超过一半则总是一半显示。
                        //如果1个超过了一半则 如果两个没有超过总宽度则正常显示，如果超过了总宽度则超过一半的视图的宽度等于总宽度减去未超过一半的视图的宽度。
                        //如果没有一个超过一半。则正常显示
                        CGFloat layoutWidth = spareWidth + leadingWidth + trailingWidth;
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
                        for (UIView *fsbv in fixedSbsSet)
                        {
                            fsbv.myFrame.width += spareWidth * (fsbv.myFrame.width / fixedSizeWidth);
                        }
                    }
                }
            }
            else if (sstContent == MySubviewsShrink_Space)
            {
                if (fixedSpaceCount > 0 && spareWidth < 0 && selfSize.width > 0 && fixedSpaceWidth > 0)
                {
                    if (sstMode == MySubviewsShrink_Average)
                    {
                        addSpace = spareWidth / fixedSpaceCount;
                    }
                    else if (sstMode == MySubviewsShrink_Weight)
                    {
                        isWeightShrinkSpace = YES;
                        weightShrinkSpaceTotalWidth = spareWidth;
                    }
                }
            }
            else
            {
                ;
            }
        }
    
        if (totalShrink == 0.0)
            spareWidth = 0;
    }
    else
    {
        //如果不需要压缩则压缩比设置为0
        totalShrink = 0.0;
    }
    
    //如果是总的压缩比重不为0则认为固定宽度和布局视图宽度保持一致。
    if (totalShrink != 0.0)
        fixedWidth = selfSize.width - paddingHorz;

    //如果有浮动尺寸或者有压缩模式
    if (totalWeight != 0.0 || totalShrink != 0.0 ||  (sstMode != MySubviewsShrink_None && _myCGFloatLessOrEqual(spareWidth, 0)) || horzGravity != MyGravity_None || lsc.heightSizeInner.dimeWrapVal)
    {
        maxSelfHeight = 0.0;
        CGFloat between = 0.0; //间距扩充
        CGFloat fill = 0.0;    //尺寸扩充
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
        else if (horzGravity == MyGravity_Horz_Around)
        {
            //around停靠中如果子视图数量大于1则间距均分，并且首尾子视图和父视图的间距为均分的一半，如果子视图数量为1则一个子视图垂直居中。
            if (sbs.count > 1)
            {
                between = (selfSize.width - fixedWidth - paddingHorz) / sbs.count;
                pos = paddingLeading + between / 2.0;
            }
            else
            {
                pos = (selfSize.width - fixedWidth - paddingHorz)/2.0 + paddingLeading;
            }
        }
        else if (horzGravity == MyGravity_Horz_Among)
        {
            between = (selfSize.width - fixedWidth - paddingHorz) / (sbs.count + 1);
            pos = paddingLeading + between;
        }
        else if (horzGravity == MyGravity_Horz_Fill || horzGravity == MyGravity_Horz_Stretch)
        {
            pos = paddingLeading;
            if (flexSbsSet.count > 0)
                fill = (selfSize.width - fixedWidth - paddingHorz) / flexSbsSet.count;
        }
        else
        {
            pos = paddingLeading;
        }
        
        for (UIView *sbv in sbs) {
            
            MyFrame *sbvmyFrame = sbv.myFrame;
            MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
            
            CGFloat leadingSpace = sbvsc.leadingPosInner.posNumVal.doubleValue;
            CGFloat trailingSpace = sbvsc.trailingPosInner.posNumVal.doubleValue;
            CGFloat weight = sbvsc.weight;
            CGRect rect =  sbvmyFrame.frame;
            
            //分别处理相对顶部间距和绝对顶部间距
            if ([self myIsRelativePos:leadingSpace])
            {
                CGFloat topSpaceWeight = leadingSpace;
                leadingSpace = _myCGFloatRound((topSpaceWeight / totalWeight) * spareWidth);
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
            leadingSpace += sbvsc.leadingPosInner.offsetVal;
            if (totalShrink != 0.0 && sbvsc.leadingPosInner.shrink != 0.0)
            {
                leadingSpace += (sbvsc.leadingPosInner.shrink / totalShrink) * spareWidth;
            }
            
            pos += [self myValidMargin:sbvsc.leadingPosInner sbv:sbv calcPos:leadingSpace selfLayoutSize:selfSize];
            rect.origin.x = pos;
            
            //分别处理相对高度和绝对高度
            if (weight != 0.0)
            {
                CGFloat w = _myCGFloatRound((weight / totalWeight) * spareWidth);
                if (_myCGFloatLessOrEqual(w, 0))
                    w = 0;
                
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:w sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            //加上扩充的宽度。
            if (fill != 0.0 && [flexSbsSet containsObject:sbv])
                rect.size.width += fill;
            
            if (totalShrink != 0.0 && sbvsc.widthSizeInner.shrink != 0.0)
            {
                rect.size.width += (sbvsc.widthSizeInner.shrink / totalShrink) * spareWidth;
                if (rect.size.width < 0.0)
                    rect.size.width = 0.0;
            }
            
            //特殊处理高度依赖宽度的情况。
            if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            {//特殊处理高度等于宽度的情况
                rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            }
            
            CGFloat tempSelfHeight = [self myLayout:lsc
                                        calcSubview:sbvsc
                                      topBottomRect:&rect
                                        vertGravity:vertGravity
                                         paddingTop:paddingTop
                                      paddingBottom:paddingBottom
                                        baselinePos:baselinePos
                                           selfSize:selfSize];
            
            if ((tempSelfHeight > maxSelfHeight) &&
                (sbvsc.heightSizeInner.dimeRelaVal == nil || sbvsc.heightSizeInner.dimeRelaVal != lsc.heightSizeInner) &&
                !sbvsc.heightSizeInner.dimeFillVal &&
                (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil || sbvsc.heightSizeInner.dimeVal != nil ))
            {
                maxSelfHeight = tempSelfHeight;
            }
    
            pos += rect.size.width;
            
            //计算相对的右边边距和绝对的右边边距
            if ([self myIsRelativePos:trailingSpace])
            {
                CGFloat trailingSpaceWeight = trailingSpace;
                trailingSpace = _myCGFloatRound((trailingSpaceWeight / totalWeight) * spareWidth);
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
            trailingSpace += sbvsc.trailingPosInner.offsetVal;
            if (totalShrink != 0.0 && sbvsc.trailingPosInner.shrink != 0.0)
            {
                trailingSpace += (sbvsc.trailingPosInner.shrink / totalShrink) * spareWidth;
            }
            
            pos += [self myValidMargin:sbvsc.trailingPosInner sbv:sbv calcPos:trailingSpace  selfLayoutSize:selfSize];
            
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
                
                pos += between;  //只有gravity为between或者around才加这个间距拉伸。
            }
            
            sbvmyFrame.frame = rect;
        }
    }
    
    pos += paddingTrailing;
    
    if (lsc.widthSizeInner.dimeWrapVal)
        selfSize.width = pos;
    
    if (lsc.heightSizeInner.dimeWrapVal)
        selfSize.height = maxSelfHeight + paddingTop + paddingBottom;
    
    return selfSize;
}

- (CGFloat)myLayout:(MyLinearLayoutViewSizeClass*)lsc calcSubview:(MyViewSizeClass*)sbvsc leadingTrailingRect:(CGRect *)pRect horzGravity:(MyGravity)horzGravity paddingTrailing:(CGFloat)paddingTrailing paddingLeading:(CGFloat)paddingLeading selfSize:(CGSize)selfSize
{
    UIView *sbv = sbvsc.view;
    
    pRect->size.width = [self myLayout:lsc widthSizeValueOfSubview:sbvsc selfSize:selfSize sbvSize:pRect->size paddingTop:lsc.myLayoutTopPadding paddingLeading:paddingLeading paddingBottom:lsc.myLayoutBottomPadding paddingTrailing:paddingTrailing];
    
    if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
    {
        if (sbvsc.widthSizeInner.dimeVal == nil)
        {
            pRect->size.width = selfSize.width - paddingLeading - paddingTrailing - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal;
        }
    }
    
    pRect->size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:pRect->size.width sbvSize:pRect->size selfLayoutSize:selfSize];
    
    return [self myCalcSubview:sbvsc horzGravity:[self myGetSubview:sbvsc horzGravity:horzGravity] paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:pRect];
}

- (CGFloat)myLayout:(MyLinearLayoutViewSizeClass*)lsc calcSubview:(MyViewSizeClass*)sbvsc topBottomRect:(CGRect *)pRect  vertGravity:(MyGravity)vertGravity paddingTop:(CGFloat)paddingTop paddingBottom:(CGFloat)paddingBottom  baselinePos:(CGFloat)baselinePos selfSize:(CGSize)selfSize
{
    UIView *sbv = sbvsc.view;

    pRect->size.height = [self myLayout:lsc heightSizeValueOfSubview:sbvsc selfSize:selfSize sbvSize:pRect->size paddingTop:paddingTop paddingLeading:lsc.myLayoutLeadingPadding paddingBottom:paddingBottom paddingTrailing:lsc.myLayoutTrailingPadding];

    if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
    {
        if (sbvsc.heightSizeInner.dimeVal == nil)
            pRect->size.height = selfSize.height - paddingTop - paddingBottom - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal;
    }
    
    pRect->size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:pRect->size.height sbvSize:pRect->size selfLayoutSize:selfSize];
    
    return [self myCalcSubview:sbvsc vertGravity:[self myGetSubview:sbvsc vertGravity:vertGravity] paddingTop:paddingTop paddingBottom:paddingBottom  baselinePos:baselinePos selfSize:selfSize pRect:pRect];
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

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

#pragma mark -- Public Methods

-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.myCurrentSizeClass.orientation = orientation;
        self.myCurrentSizeClass.arrangedCount = arrangedCount;
    }
    
    return  self;
}

-(instancetype)initWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    return [self initWithFrame:CGRectZero orientation:orientation arrangedCount:arrangedCount];
}


+(instancetype)flowLayoutWithOrientation:(MyOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    MyFlowLayout *layout = [[[self class] alloc] initWithOrientation:orientation arrangedCount:arrangedCount];
    return layout;
}

-(void)setOrientation:(MyOrientation)orientation
{
     MyFlowLayout *lsc = self.myCurrentSizeClass;
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


-(void)setArrangedCount:(NSInteger)arrangedCount
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.arrangedCount != arrangedCount)
    {
        lsc.arrangedCount = arrangedCount;
        [self setNeedsLayout];
    }
}

-(NSInteger)arrangedCount
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    return lsc.arrangedCount;
}


-(NSInteger)pagedCount
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    return lsc.pagedCount;
}

-(void)setPagedCount:(NSInteger)pagedCount
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.pagedCount != pagedCount)
    {
        lsc.pagedCount = pagedCount;
        [self setNeedsLayout];
    }
}


-(void)setAutoArrange:(BOOL)autoArrange
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.autoArrange != autoArrange)
    {
        lsc.autoArrange = autoArrange;
        [self setNeedsLayout];
    }
}

-(BOOL)autoArrange
{
    return self.myCurrentSizeClass.autoArrange;
}


-(void)setArrangedGravity:(MyGravity)arrangedGravity
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.arrangedGravity != arrangedGravity)
    {
        lsc.arrangedGravity = arrangedGravity;
        [self setNeedsLayout];
    }
}

-(MyGravity)arrangedGravity
{
    return self.myCurrentSizeClass.arrangedGravity;
}

-(BOOL)isFlex
{
    return self.myCurrentSizeClass.isFlex;
}

-(void)setIsFlex:(BOOL)isFlex
{
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    if (lsc.isFlex != isFlex)
    {
        lsc.isFlex = isFlex;
        [self setNeedsLayout];
    }
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace
{
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass
{
    MyFlowLayoutViewSizeClass *lsc = (MyFlowLayoutViewSizeClass*)[self fetchLayoutSizeClass:sizeClass];
    lsc.subviewSize = subviewSize;
    lsc.maxSpace = maxSpace;
    lsc.minSpace = minSpace;
    [self setNeedsLayout];
}


#pragma mark -- Override Methods

-(CGSize)calcLayoutSize:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutSize:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    MyFlowLayout *lsc = self.myCurrentSizeClass;
    
    MyOrientation orientation = lsc.orientation;
    MyGravity gravity = lsc.gravity;
    MyGravity arrangedGravity = lsc.arrangedGravity;
    
    [self myCalcSubviewsWrapContentSize:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs withCustomSetting:^(UIView *sbv, UIView *sbvsc) {
        
        if (sbvsc.widthSizeInner.dimeWrapVal)
        {
            if (lsc.pagedCount > 0  ||
                (orientation == MyOrientation_Horz && (arrangedGravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill) ||
                (orientation == MyOrientation_Vert && ((gravity & MyGravity_Vert_Mask) == MyGravity_Horz_Fill || sbvsc.weight != 0)))
            {
                [sbvsc.widthSizeInner __clear];
            }
        }
        
        if (sbvsc.heightSizeInner.dimeWrapVal)
        {
            if (lsc.pagedCount > 0 ||
                (orientation == MyOrientation_Vert && (arrangedGravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill) ||
                (orientation == MyOrientation_Horz && ((gravity & MyGravity_Horz_Mask) == MyGravity_Vert_Fill || sbvsc.weight != 0)))
            {
                [sbvsc.heightSizeInner __clear];
            }
        }
        
    }];
    
    
    if (orientation == MyOrientation_Vert)
    {
        if (lsc.arrangedCount == 0)
            selfSize = [self myCalcLayoutSizeForVertOrientationContent:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
        else
            selfSize = [self myCalcLayoutSizeForVertOrientation:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    }
    else
    {
        if (lsc.arrangedCount == 0)
            selfSize = [self myCalcLayoutSizeForHorzOrientationContent:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
        else
            selfSize = [self myCalcLayoutSizeForHorzOrientation:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
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
    return [MyFlowLayoutViewSizeClass new];
}

#pragma mark -- Private Methods

//计算垂直流式布局下每行的比重值。
- (void)myCalcVertLayoutSinglelineWeight:(CGFloat)lineTotalWeight lineSpareWidth:(CGFloat)lineSpareWidth  sbs:(NSArray *)sbs startItemIndex:(NSInteger)startItemIndex count:(NSInteger)count lsc:(MyFlowLayout*)lsc inSelfSize:(CGSize)selfSize
{
    //如果浮动宽度都是小于等于0因为没有拉升必要，所以直接返回
    if (lineSpareWidth <= 0.0)
        return;
    
    //按照flex规约，如果总的比重小于1则只会将剩余宽度的总比重部分来进行按比例拉伸。
    if (lsc.isFlex && lineTotalWeight < 1.0)
        lineSpareWidth *= lineTotalWeight;
    
    
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + count; itemIndex++)
    {
        UIView *sbv = sbs[itemIndex];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.weight != 0)
        {
            CGFloat tempWidth = _myCGFloatRound((lineSpareWidth * sbvsc.weight / lineTotalWeight));
            if (sbvsc.widthSizeInner != nil && sbvsc.widthSizeInner.dimeVal == nil)
                tempWidth = [sbvsc.widthSizeInner measureWith:tempWidth];
            
            sbvmyFrame.width =  [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:tempWidth + sbvmyFrame.width sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        }
     }
}

//计算水平流式布局下每行的比重值。
- (void)myCalcHorzLayoutSinglelineWeight:(CGFloat)lineTotalWeight lineSpareHeight:(CGFloat)lineSpareHeight sbs:(NSArray *)sbs startItemIndex:(NSInteger)startItemIndex count:(NSInteger)count lsc:(MyFlowLayout*)lsc inSelfSize:(CGSize)selfSize
{
    if (lineSpareHeight <= 0.0)
        return;
    
    if (lsc.isFlex && lineTotalWeight < 1.0)
        lineSpareHeight *= lineTotalWeight;
    
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + count; itemIndex++)
    {
        UIView *sbv = sbs[itemIndex];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.weight != 0)
        {
            CGFloat tempHeight = _myCGFloatRound((lineSpareHeight * sbvsc.weight / lineTotalWeight));
            if (sbvsc.heightSizeInner != nil && sbvsc.heightSizeInner.dimeVal == nil)
                tempHeight = [sbvsc.heightSizeInner measureWith:tempHeight];
            
            lineSpareHeight -= tempHeight;
            lineTotalWeight -= sbvsc.weight;
            
            sbvmyFrame.height =  [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:tempHeight + sbvmyFrame.height sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: sbvmyFrame.height ] sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
        }
    }
}

//调整内容约束垂直流式布局的每行的宽度
- (void)myAdjustVertLayoutSingleline:(NSInteger)lineIndex lineSpareWidth:(CGFloat)lineSpareWidth lineTotalWeight:(CGFloat)lineTotalWeight horzGravity:(MyGravity)horzGravity sbs:(NSArray *)sbs startItemIndex:(NSInteger)startItemIndex count:(NSInteger)count lsc:(MyFlowLayout*)lsc  inSelfSize:(CGSize)selfSize
{
    if (lineSpareWidth <= 0.0)
        return;

    MyGravity lineHorzGravity = horzGravity;
    if (self.lineGravity != nil)
    {
        lineHorzGravity = self.lineGravity(self, lineIndex, count, (startItemIndex + count) == sbs.count) & MyGravity_Vert_Mask;
        if (lineHorzGravity == MyGravity_None)
            lineHorzGravity = horzGravity;
    }
    
    CGFloat addXFill = 0;
    if (lineHorzGravity == MyGravity_Horz_Fill && lineTotalWeight == 0.0)
    {
        //流式布局中最后一行不会进行拉伸处理。
        if (lsc.isFlex || (startItemIndex + count) != sbs.count)
            addXFill = lineSpareWidth / count;
    }
    else
    {
        //flex规则：当总的比重小于1时，剩余的宽度要乘以这个比重值再进行分配。
        if (lsc.isFlex && lineTotalWeight < 1.0)
            lineSpareWidth *= lineTotalWeight;
    }
    
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + count; itemIndex++)
    {
        UIView *sbv = sbs[itemIndex];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.weight != 0.0 && lineTotalWeight != 0.0)
        {
            CGFloat tempWidth = _myCGFloatRound((lineSpareWidth * sbvsc.weight / lineTotalWeight));
            if (sbvsc.widthSizeInner != nil && sbvsc.widthSizeInner.dimeVal == nil)
                tempWidth = [sbvsc.widthSizeInner measureWith:tempWidth];
            
            sbvmyFrame.width += tempWidth;
        }
        
        //添加拉伸的尺寸。
        if (addXFill != 0.0)
            sbvmyFrame.width += addXFill;
    }
    
}

//调整内容约束水平流式布局的每行的高度
- (void)myAdjustHorzLayoutSingleline:(NSInteger)lineIndex lineSpareHeight:(CGFloat)lineSpareHeight lineTotalWeight:(CGFloat)lineTotalWeight vertGravity:(MyGravity)vertGravity sbs:(NSArray *)sbs startItemIndex:(NSInteger)startItemIndex count:(NSInteger)count lsc:(MyFlowLayout*)lsc inSelfSize:(CGSize)selfSize
{
    if (lineSpareHeight <= 0.0)
        return;
    
    MyGravity lineVertGravity = vertGravity;
    if (self.lineGravity != nil)
    {
        lineVertGravity = self.lineGravity(self, lineIndex, count, (startItemIndex + count) == sbs.count) & MyGravity_Horz_Mask;
        if (lineVertGravity == MyGravity_None)
            lineVertGravity = vertGravity;
    }
    
    CGFloat addYFill = 0;
    if (lineVertGravity == MyGravity_Vert_Fill && lineTotalWeight == 0.0)
    {
        //流式布局中最后一行不会进行拉伸处理。
        if (lsc.isFlex || (startItemIndex + count) != sbs.count)
            addYFill = lineSpareHeight / count;
    }
    else
    {
        //flex规则：当总的比重小于1时，剩余的高度要乘以这个比重值再进行分配。
        if (lsc.isFlex && lineTotalWeight < 1.0)
            lineSpareHeight *= lineTotalWeight;
    }
    
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + count; itemIndex++)
    {
        UIView *sbv = sbs[itemIndex];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.weight != 0.0 && lineTotalWeight != 0.0)
        {
            CGFloat tempHeight = _myCGFloatRound((lineSpareHeight * sbvsc.weight / lineTotalWeight));
            if (sbvsc.heightSizeInner != nil && sbvsc.heightSizeInner.dimeVal == nil)
                tempHeight = [sbvsc.heightSizeInner measureWith:tempHeight];
            
            sbvmyFrame.height += tempHeight;
        }
        
        //添加拉伸的尺寸。
        if (addYFill != 0.0)
            sbvmyFrame.height += addYFill;
    }
    
}

- (void)myCalcVertLayoutSinglelineShrink:(CGFloat)lineTotalShrink lineSpareWidth:(CGFloat)lineSpareWidth sbs:(NSArray *)sbs startItemIndex:(NSInteger)startItemIndex count:(NSInteger)count lsc:(MyFlowLayout*)lsc inSelfSize:(CGSize)selfSize
{
    if (_myCGFloatGreatOrEqual(lineSpareWidth, 0.0))
        lineTotalShrink = 0.0;
    
    if (lineTotalShrink == 0.0)
        return;
    
    //根据flex规约：如果总的压缩比重小于1则超出部分会乘以这个压缩比再进行压缩。
    if (lsc.isFlex && lineTotalShrink < 1.0)
        lineSpareWidth *= lineTotalShrink;
    
    //如果有压缩则调整子视图的宽度。
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + count; itemIndex++)
    {
        UIView *sbv = sbs[itemIndex];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.widthSizeInner.shrink != 0.0)
        {
            sbvmyFrame.width += (sbvsc.widthSizeInner.shrink / lineTotalShrink) * lineSpareWidth;
            if (sbvmyFrame.width < 0.0)
                sbvmyFrame.width = 0.0;
        }
    }
}

- (void)myCalcHorzLayoutSinglelineShrink:(CGFloat)lineTotalShrink lineSpareHeight:(CGFloat)lineSpareHeight sbs:(NSArray *)sbs startItemIndex:(NSInteger)startItemIndex count:(NSInteger)count lsc:(MyFlowLayout *)lsc inSelfSize:(CGSize)selfSize
{
    if (_myCGFloatGreatOrEqual(lineSpareHeight, 0.0))
        lineTotalShrink = 0.0;
    
    if (lineTotalShrink == 0.0)
        return;
    
    //根据flex规约：如果总的压缩比重小于1则超出部分会乘以这个压缩比再进行压缩。
    if (lsc.isFlex && lineTotalShrink < 1.0)
        lineSpareHeight *= lineTotalShrink;
    
    //如果有压缩则调整子视图的高度。
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + count; itemIndex++)
    {
        UIView *sbv = sbs[itemIndex];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (sbvsc.heightSizeInner.shrink != 0.0)
        {
            sbvmyFrame.height += (sbvsc.heightSizeInner.shrink / lineTotalShrink) * lineSpareHeight;
            if (sbvmyFrame.height < 0.0)
                sbvmyFrame.height = 0.0;
        }
    }
}


- (void)myCalcVertLayoutSingleline:(NSInteger)lineIndex vertAlignment:(MyGravity)vertAlignment horzGravity:(MyGravity)horzGravity lineMaxHeight:(CGFloat)lineMaxHeight lineMaxWidth:(CGFloat)lineMaxWidth lineTotalShrink:(CGFloat)lineTotalShrink sbs:(NSArray *)sbs startItemIndex:(NSInteger)startItemIndex count:(NSInteger)count vertSpace:(CGFloat)vertSpace horzSpace:(CGFloat)horzSpace isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc inSelfSize:(CGSize)selfSize
{
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    
    CGFloat lineSpareWidth = selfSize.width - lineMaxWidth - paddingHorz;
    if (_myCGFloatGreatOrEqual(lineSpareWidth, 0.0))
        lineTotalShrink = 0.0;
    
    if (lineTotalShrink != 0.0)
        lineMaxWidth = selfSize.width - paddingHorz;
    
    //计算每行的gravity情况。
    CGFloat addXPos = 0; //多出来的空隙区域，用于停靠处理。
    CGFloat addXFill = 0;  //多出来的平均区域，用于拉伸间距或者尺寸

    MyGravity lineHorzGravity = horzGravity;
    MyGravity lineVertAlignment = vertAlignment;
    if (self.lineGravity != nil)
    {
        MyGravity lineGravity = self.lineGravity(self, lineIndex, count, (startItemIndex+count) == sbs.count);
        lineHorzGravity = lineGravity & MyGravity_Vert_Mask;
        if (lineHorzGravity == MyGravity_None)
            lineHorzGravity = horzGravity;
        else
            lineHorzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lineHorzGravity];
        
        lineVertAlignment = lineGravity & MyGravity_Horz_Mask;
        if (lineVertAlignment == MyGravity_None)
            lineVertAlignment = vertAlignment;
    }
    
    switch (lineHorzGravity)
    {
        case MyGravity_Horz_Center:
        {
            addXPos = (selfSize.width - paddingHorz - lineMaxWidth) / 2;
        }
            break;
        case MyGravity_Horz_Trailing:
        {
            addXPos = selfSize.width - paddingHorz - lineMaxWidth; //因为具有不考虑左边距，而原来的位置增加了左边距，因此
        }
            break;
        case MyGravity_Horz_Between:
        {
            //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效(如果最后一行的数量和其他行的数量一样以及总共就只有一行除外)。
            if ((lsc.isFlex || (startItemIndex + count) != sbs.count || count == lsc.arrangedCount || sbs.count == count) && count > 1)
            {
                addXFill = (selfSize.width - paddingHorz - lineMaxWidth) / (count - 1);
            }
        }
            break;
        case MyGravity_Horz_Around:
        {
            //多于一个拉伸间距，只有一个则居中处理。
            if (count > 1)
            {
                addXFill = (selfSize.width - paddingHorz - lineMaxWidth) / count;
                addXPos = addXFill / 2.0;
            }
            else
            {
                addXPos = (selfSize.width - paddingHorz - lineMaxWidth) / 2;
            }
        }
            break;
        default:
            break;
    }
    
    //压缩减少的尺寸汇总。
    CGFloat totalShrinkSize = 0.0;
    //基线位置
    CGFloat baselinePos = CGFLOAT_MAX;
    //将整行的位置进行调整。
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + count; itemIndex++)
    {
        UIView *sbv = sbs[itemIndex];
        
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (!isEstimate && self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leadingBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.trailingBorderline = nil;
                    sbvl.bottomBorderline = nil;
                    
                    //如果不是最后一行就画下面，
                    if ((startItemIndex + count) != sbs.count)
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    
                    //如果不是最后一列就画右边,
                    if (itemIndex < (startItemIndex + count) - 1)
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    
                    //如果最后一行的最后一个没有满列数时
                    if (itemIndex == sbs.count - 1 && lsc.arrangedCount != count )
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertSpace != 0 && startItemIndex != 0)
                        sbvl.topBorderline = self.intelligentBorderline;
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzSpace != 0 && itemIndex != startItemIndex)
                        sbvl.leadingBorderline = self.intelligentBorderline;
                }
            }
        }
        
        MyGravity sbvVertAlignment = sbvsc.alignment & MyGravity_Horz_Mask;
        if (sbvVertAlignment == MyGravity_None)
            sbvVertAlignment = lineVertAlignment;
        //因为单行内的垂直间距拉伸被赋予紧凑排列，所以这里的定制化将不起作用。
        if (vertAlignment == MyGravity_Vert_Between)
            sbvVertAlignment = MyGravity_None;
        
        UIFont *sbvFont = nil;
        if (sbvVertAlignment == MyGravity_Vert_Baseline)
        {
            sbvFont = [self myGetSubviewFont:sbv];
            if (sbvFont == nil)
                sbvVertAlignment = MyGravity_Vert_Top;
        }
        
        if ((sbvVertAlignment != MyGravity_None && sbvVertAlignment != MyGravity_Vert_Top) || _myCGFloatNotEqual(addXPos, 0.0)  ||  _myCGFloatNotEqual(addXFill, 0.0) || lineTotalShrink != 0.0)
        {
            
            sbvmyFrame.leading += addXPos;
            
            //处理对间距的压缩
            if (lineTotalShrink != 0.0)
            {
                if (sbvsc.leadingPosInner.shrink != 0.0)
                    totalShrinkSize += (sbvsc.leadingPosInner.shrink / lineTotalShrink) * lineSpareWidth;
                
                sbvmyFrame.leading += totalShrinkSize;
                
                if (sbvsc.trailingPosInner.shrink != 0.0)
                    totalShrinkSize += (sbvsc.trailingPosInner.shrink / lineTotalShrink) * lineSpareWidth;
            }
            
            //内容约束布局并且是填充尺寸或者拉升尺寸。
            if (addXFill != 0.0)
            {
                if ( lineHorzGravity != MyGravity_Horz_Fill)
                {
                    //其他的只拉伸间距
                    sbvmyFrame.leading += addXFill * (itemIndex - startItemIndex);
                }
            }
            
            switch (sbvVertAlignment) {
                case MyGravity_Vert_Center:
                {
                    sbvmyFrame.top += (lineMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal - sbvmyFrame.height) / 2;
                }
                    break;
                case MyGravity_Vert_Bottom:
                {
                    sbvmyFrame.top += lineMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal - sbvmyFrame.height;
                }
                    break;
                case MyGravity_Vert_Fill:
                {
                    sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:lineMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                case MyGravity_Vert_Stretch:
                {
                    if (sbvsc.heightSizeInner.dimeVal == nil)
                    {
                        sbvmyFrame.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:lineMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
                    }
                }
                    break;
                case MyGravity_Vert_Baseline:
                {
                    if (baselinePos == CGFLOAT_MAX)
                        baselinePos = sbvmyFrame.top + (sbvmyFrame.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender;
                    else
                        sbvmyFrame.top = baselinePos - sbvFont.ascender - (sbvmyFrame.height - sbvFont.lineHeight) / 2;
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}

- (void)myCalcHorzLayoutSingleline:(NSInteger)lineIndex horzAlignment:(MyGravity)horzAlignment vertGravity:(MyGravity)vertGravity lineMaxWidth:(CGFloat)lineMaxWidth lineMaxHeight:(CGFloat)lineMaxHeight lineTotalShrink:(CGFloat)lineTotalShrink sbs:(NSArray *)sbs startItemIndex:(NSInteger)startItemIndex count:(NSInteger)count vertSpace:(CGFloat)vertSpace horzSpace:(CGFloat)horzSpace isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc inSelfSize:(CGSize)selfSize
{
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;
   
    CGFloat lineSpareHeight = selfSize.height - lineMaxHeight - paddingVert;
    if (_myCGFloatGreatOrEqual(lineSpareHeight, 0.0))
        lineTotalShrink = 0.0;
    
    if (lineTotalShrink != 0.0)
        lineMaxHeight = selfSize.height - paddingVert;
    
    //计算每行的gravity情况。
    CGFloat addYPos = 0;
    CGFloat addYFill = 0;
    MyGravity lineHorzAlignment = horzAlignment;
    MyGravity lineVertGravity = vertGravity;
    if (self.lineGravity != nil)
    {
        MyGravity lineGravity = self.lineGravity(self, lineIndex, count, (startItemIndex + count) == sbs.count);
        lineHorzAlignment = lineGravity & MyGravity_Vert_Mask;
        if (lineHorzAlignment == MyGravity_None)
            lineHorzAlignment = horzAlignment;
        else
            lineHorzAlignment = [self myConvertLeftRightGravityToLeadingTrailing:lineHorzAlignment];
        
        lineVertGravity = lineGravity & MyGravity_Horz_Mask;
        if (lineVertGravity == MyGravity_None)
            lineVertGravity = vertGravity;
    }
    
    switch (lineVertGravity)
    {
        case MyGravity_Vert_Center:
        {
            addYPos = (selfSize.height - paddingVert - lineMaxHeight) / 2;
        }
            break;
        case MyGravity_Vert_Bottom:
        {
            addYPos = selfSize.height - paddingVert - lineMaxHeight;
        }
            break;
        case MyGravity_Vert_Between:
        {
            //总高度减去最大的高度。再除以数量表示每个应该扩展的空间。最后一列无效(如果最后一列的数量和其他列的数量一样以及总共就只有一列除外)。
            if ((lsc.isFlex || (startItemIndex + count) != sbs.count || count == lsc.arrangedCount || sbs.count == count) && count > 1)
            {
                addYFill = (selfSize.height - paddingVert - lineMaxHeight) / (count - 1);
            }
        }
            break;
        case MyGravity_Vert_Around:
        {
            if (count > 1)
            {
                addYFill = (selfSize.height - paddingVert - lineMaxHeight) / count;
                addYPos = addYFill / 2.0;
            }
            else
            {
                addYPos = (selfSize.height - paddingVert - lineMaxHeight) / 2;
            }
        }
            break;
        default:
            break;
    }
    
   
    //压缩减少的尺寸汇总。
    CGFloat totalShrinkSize = 0;
    //将整行的位置进行调整。
    for (NSInteger itemIndex = startItemIndex; itemIndex < startItemIndex + count; itemIndex++)
    {
        UIView *sbv = sbs[itemIndex];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        
        if (!isEstimate && self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leadingBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.trailingBorderline = nil;
                    sbvl.bottomBorderline = nil;
                    
                    
                    //如果不是最后一行就画下面，
                    if (itemIndex < (startItemIndex + count) - 1)
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    
                    //如果不是最后一列就画右边,
                    if ((startItemIndex + count) != sbs.count )
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    
                    //如果最后一行的最后一个没有满列数时
                    if (itemIndex == sbs.count - 1 && lsc.arrangedCount != count )
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertSpace != 0 && itemIndex != startItemIndex)
                        sbvl.topBorderline = self.intelligentBorderline;
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzSpace != 0 && startItemIndex != 0  )
                       sbvl.leadingBorderline = self.intelligentBorderline;
                }
            }
        }
        
        
        MyGravity sbvHorzAlignment = [self myConvertLeftRightGravityToLeadingTrailing:sbvsc.alignment & MyGravity_Vert_Mask];
        if (sbvHorzAlignment == MyGravity_None)
            sbvHorzAlignment = lineHorzAlignment;
        //因为单行内的水平间距拉伸被赋予紧凑排列，所以这里的定制化将不起作用。
        if (horzAlignment == MyGravity_Horz_Between)
            sbvHorzAlignment = MyGravity_None;
        
        if ((sbvHorzAlignment != MyGravity_None && sbvHorzAlignment != MyGravity_Horz_Leading) || _myCGFloatNotEqual(addYPos, 0.0) || _myCGFloatNotEqual(addYFill, 0.0) || lineTotalShrink != 0.0)
        {
            sbvmyFrame.top += addYPos;
            
            //处理对间距的压缩
            if (lineTotalShrink != 0.0)
            {
                if (sbvsc.topPosInner.shrink != 0.0)
                    totalShrinkSize += (sbvsc.topPosInner.shrink / lineTotalShrink) * lineSpareHeight;
                
                sbvmyFrame.top += totalShrinkSize;
                
                if (sbvsc.bottomPosInner.shrink != 0.0)
                    totalShrinkSize += (sbvsc.bottomPosInner.shrink / lineTotalShrink) * lineSpareHeight;
            }
            
            //内容约束布局并且是填充尺寸或者拉升尺寸。
            if (addYFill != 0.0)
            {
                if (lineVertGravity != MyGravity_Vert_Fill)
                {
                    //只拉伸间距
                    sbvmyFrame.top += addYFill * (itemIndex - startItemIndex);
                }
            }
            
            switch (sbvHorzAlignment) {
                case MyGravity_Horz_Center:
                {
                    sbvmyFrame.leading += (lineMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal - sbvmyFrame.width) / 2;
                }
                    break;
                case MyGravity_Horz_Trailing:
                {
                    sbvmyFrame.leading += lineMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal - sbvmyFrame.width;
                }
                    break;
                case MyGravity_Horz_Fill:
                {
                    sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:lineMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                case MyGravity_Horz_Stretch:
                {
                    if (sbvsc.widthSizeInner.dimeVal == nil)
                    {
                        sbvmyFrame.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:lineMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal sbvSize:sbvmyFrame.frame.size selfLayoutSize:selfSize];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}


-(CGFloat)myCalcSinglelineSize:(NSArray*)sbs space:(CGFloat)space
{
    CGFloat size = 0;
    for (UIView *sbv in sbs)
    {
        size += sbv.myFrame.trailing;
        if (sbv != sbs.lastObject)
            size += space;
    }
    
    return size;
}

-(NSArray*)myGetAutoArrangeSubviews:(NSMutableArray*)sbs selfSize:(CGFloat)selfSize space:(CGFloat)space
{
    
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:sbs.count];
    
    NSMutableArray *bestSinglelineArray = [NSMutableArray arrayWithCapacity:sbs.count /2];
    
    while (sbs.count) {
        
        [self myCalcAutoArrangeSinglelineSubviews:sbs
                                          index:0
                                      calcArray:@[]
                                       selfSize:selfSize
                                         space:space
                            bestSinglelineArray:bestSinglelineArray];
        
        [retArray addObjectsFromArray:bestSinglelineArray];
        
        [bestSinglelineArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            [sbs removeObject:obj];
        }];
        
        [bestSinglelineArray removeAllObjects];
    }
    
    return retArray;
}

-(void)myCalcAutoArrangeSinglelineSubviews:(NSMutableArray*)sbs
                                   index:(NSInteger)index
                               calcArray:(NSArray*)calcArray
                                selfSize:(CGFloat)selfSize
                                  space:(CGFloat)space
                     bestSinglelineArray:(NSMutableArray*)bestSinglelineArray
{
    if (index >= sbs.count)
    {
        CGFloat s1 = [self myCalcSinglelineSize:calcArray space:space];
        CGFloat s2 = [self myCalcSinglelineSize:bestSinglelineArray space:space];
        if (_myCGFloatLess(fabs(selfSize - s1), fabs(selfSize - s2)) && _myCGFloatLessOrEqual(s1, selfSize) )
            [bestSinglelineArray setArray:calcArray];
        
        return;
    }
    
    
    for (NSInteger i = index; i < sbs.count; i++) {
        
        
        NSMutableArray *calcArray2 = [NSMutableArray arrayWithArray:calcArray];
        [calcArray2 addObject:sbs[i]];
        
        CGFloat s1 = [self myCalcSinglelineSize:calcArray2 space:space];
        if (_myCGFloatLessOrEqual(s1, selfSize))
        {
            CGFloat s2 = [self myCalcSinglelineSize:bestSinglelineArray space:space];
            if (_myCGFloatLess(fabs(selfSize - s1), fabs(selfSize - s2)))
                [bestSinglelineArray setArray:calcArray2];
            
            if (_myCGFloatEqual(s1, selfSize))
                break;
            
            [self myCalcAutoArrangeSinglelineSubviews:sbs
                                              index:i + 1
                                          calcArray:calcArray2
                                           selfSize:selfSize
                                             space:space
                                bestSinglelineArray:bestSinglelineArray];
            
        }
        else
        {
            break;
        }
        
    }
    
}

-(CGFloat)myCalcMaxMinSubviewSizeForContent:(CGFloat)selfSize lsc:(MyFlowLayoutViewSizeClass*)lsc space:(CGFloat*)pSpace
{
    CGFloat subviewSize = lsc.subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat minSpace = lsc.minSpace;
        CGFloat maxSpace = lsc.maxSpace;
        
        NSInteger rowCount =  floor((selfSize + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            *pSpace = (selfSize - subviewSize * rowCount)/(rowCount - 1);
            if (_myCGFloatGreat(*pSpace, maxSpace) || _myCGFloatLess(*pSpace, minSpace))
            {
                if (_myCGFloatGreat(*pSpace, maxSpace))
                    *pSpace = maxSpace;
                if (_myCGFloatLess(*pSpace, minSpace))
                    *pSpace = minSpace;
                
                subviewSize =  (selfSize - (*pSpace) * (rowCount - 1)) / rowCount;
            }
        }
    }
    
    return subviewSize;
}


-(CGFloat)myCalcMaxMinSubviewSize:(CGFloat)selfSize lsc:(MyFlowLayoutViewSizeClass*)lsc arrangedCount:(NSInteger)arrangedCount space:(CGFloat*)pSpace
{
    CGFloat subviewSize = lsc.subviewSize;
    if (subviewSize != 0)
    {
        CGFloat maxSpace = lsc.maxSpace;
        CGFloat minSpace = lsc.minSpace;
        if (arrangedCount > 1)
        {
            *pSpace = (selfSize - subviewSize * arrangedCount)/(arrangedCount - 1);
            if (_myCGFloatGreat(*pSpace, maxSpace) || _myCGFloatLess(*pSpace, minSpace))
            {
                if (_myCGFloatGreat(*pSpace, maxSpace))
                    *pSpace = maxSpace;
                if (_myCGFloatLess(*pSpace, minSpace))
                    *pSpace = minSpace;
                
                subviewSize =  (selfSize -  (*pSpace) * (arrangedCount - 1)) / arrangedCount;
                
            }
        }
    }
    
    return subviewSize;
}


-(CGSize)myCalcLayoutSizeForVertOrientationContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{
    
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;


    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity vertAlignment = lsc.arrangedGravity & MyGravity_Horz_Mask;
    
    //支持浮动水平间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = [self myCalcMaxMinSubviewSizeForContent:selfSize.width - paddingHorz lsc:(MyFlowLayoutViewSizeClass*)lsc space:&horzSpace];
    
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat lineMaxHeight = 0.0;  //某一行的最高值。
    CGFloat lineMaxWidth = 0.0;   //某一行的最宽值。
    CGFloat maxWidth = 0.0;      //所有行中最宽的值。
    
    if (lsc.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
            
#ifdef DEBUG
            //约束异常：垂直流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbvsc.weight == 0, @"Constraint exception!! vertical flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
            CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
            CGRect rect = sbvmyFrame.frame;
        
            rect.size.width = [self myGetSubviewWidthSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            //暂时把宽度存放sbv.myFrame.trailing上。因为流式布局来说这个属性无用。
            sbvmyFrame.trailing = leadingSpace + rect.size.width + trailingSpace;
            if (_myCGFloatGreat(sbvmyFrame.trailing, selfSize.width - paddingHorz))
                sbvmyFrame.trailing = selfSize.width - paddingHorz;
        }
        
        [sbs setArray:[self myGetAutoArrangeSubviews:sbs selfSize:selfSize.width - paddingHorz space:horzSpace]];
        
    }
    
    
    //每行行首子视图的索引位置。
    NSMutableIndexSet *lineFirstSubviewIndexSet = [NSMutableIndexSet new];
    NSInteger lineIndex = 0;   //行的索引。
    NSInteger itemIndex = 0; //行内子视图的索引
    CGFloat lineTotalWeight = 0.0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        //这里先算一下那些有约束的高度，因为有可能有一些子视图的宽度等于这个子视图的高度。
        if (sbvsc.heightSizeInner.dimeVal != nil)
        {
            rect.size.height = [self myGetSubviewHeightSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算子视图的宽度。
        if (subviewSize != 0.0)
        {
            rect.size.width = subviewSize - leadingSpace - trailingSpace;
        }
        else if (sbvsc.widthSizeInner.dimeVal != nil)
        {
            rect.size.width = [self myGetSubviewWidthSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            {//特殊处理宽度等于高度的情况
                rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            }
        }
        else if (sbvsc.weight != 0.0)
        {
            if (lsc.isFlex)
            {
                rect.size.width = 0.0;
            }
            else
            {
                CGFloat lineSpareWidth = selfSize.width - paddingTrailing - xPos - leadingSpace - trailingSpace;
                if (itemIndex != 0)
                    lineSpareWidth -= horzSpace;
                
                if (_myCGFloatLessOrEqual(lineSpareWidth, 0.0))
                {
                    //如果当前行的剩余空间不够，则需要换行来计算相对的宽度占比，这时候剩余空间就是按整行来算,并且将行索引设置为0
                    lineSpareWidth = selfSize.width - paddingHorz;
                }
                
                rect.size.width = (lineSpareWidth + sbvsc.widthSizeInner.addVal) * sbvsc.weight - leadingSpace - trailingSpace;
            }
        }
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //特殊处理自身高度等于自身宽度的情况。
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {//特殊处理高度等于宽度的情况
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算xPos的值加上leadingSpace + rect.size.width + trailingSpace 的值要小于整体的宽度。
        CGFloat place = xPos + leadingSpace + rect.size.width + trailingSpace;
        if (itemIndex != 0)
            place += horzSpace;
        place += paddingTrailing;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。
        if (!lsc.widthSizeInner.dimeWrapVal && (place - selfSize.width > 0.0001))
        {
            //保存行首子视图的索引
            [lineFirstSubviewIndexSet addIndex:i - itemIndex];
            
            //拉伸以及调整行内子视图的宽度。
            [self myAdjustVertLayoutSingleline:lineIndex lineSpareWidth:selfSize.width - paddingTrailing - xPos lineTotalWeight:lineTotalWeight horzGravity:horzGravity sbs:sbs startItemIndex:i - itemIndex count:itemIndex lsc:lsc inSelfSize:selfSize];
            
            xPos = paddingLeading;
            
            //如何这个sbv的宽度大于整体布局视图的宽度。则将子视图的宽度缩小变为和布局视图一样宽
            if (_myCGFloatGreat(leadingSpace + trailingSpace + rect.size.width, selfSize.width - paddingHorz))
            {
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:selfSize.width - paddingHorz - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            lineTotalWeight = 0.0;
            lineIndex++;
            itemIndex = 0;
        }
        
        if (itemIndex != 0)
            xPos += horzSpace;
        
        rect.origin.x = xPos + leadingSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;
        
        if (lsc.isFlex && sbvsc.weight != 0.0)
            lineTotalWeight += sbvsc.weight;
        
        sbvmyFrame.frame = rect;
        itemIndex++;
    }
    
    //最后一行的行首索引
    [lineFirstSubviewIndexSet addIndex:i - itemIndex];
    
    [self myAdjustVertLayoutSingleline:lineIndex lineSpareWidth:selfSize.width - paddingTrailing - xPos lineTotalWeight:lineTotalWeight horzGravity:horzGravity sbs:sbs startItemIndex:i - itemIndex count:itemIndex lsc:lsc inSelfSize:selfSize];
    
    xPos = paddingLeading;
    lineIndex = 0;   //行的索引。
    itemIndex = 0; //行内的子视图索引
    NSInteger oldLineFirstIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
       
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
      
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算子视图的高度。
        if (sbvsc.heightSizeInner.dimeVal != nil)
        {
            rect.size.height = [self myGetSubviewHeightSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
        }
        else if (vertGravity == MyGravity_Vert_Fill || vertGravity == MyGravity_Vert_Stretch)
        {
            rect.size.height = 0;
        }
        
        
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {//特殊处理高度等于宽度的情况
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算xPos的值加上leadingSpace + rect.size.width + trailingSpace 的值要小于整体的宽度。
        maxWidth= xPos + leadingSpace + rect.size.width + trailingSpace;
        if (itemIndex != 0)
            maxWidth += horzSpace;
        maxWidth += paddingTrailing;
        
        NSUInteger lineFirstIndex = [lineFirstSubviewIndexSet indexLessThanOrEqualToIndex:i];
        if (!lsc.widthSizeInner.dimeWrapVal && oldLineFirstIndex != lineFirstIndex)
        {
            oldLineFirstIndex = lineFirstIndex;

            xPos = paddingLeading;
            yPos += vertSpace;
            yPos += lineMaxHeight;
            
            [self myCalcVertLayoutSingleline:lineIndex vertAlignment:vertAlignment horzGravity:horzGravity lineMaxHeight:lineMaxHeight lineMaxWidth:lineMaxWidth lineTotalShrink:0 sbs:sbs startItemIndex:i - itemIndex count:itemIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc inSelfSize:selfSize];
            
          
            lineMaxHeight = 0.0;
            lineMaxWidth = 0.0;
            itemIndex = 0;
            lineIndex++;
            
        }
        
        if (itemIndex != 0)
            xPos += horzSpace;
        
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;
        
        if (_myCGFloatLess(lineMaxHeight, topSpace + bottomSpace + rect.size.height))
            lineMaxHeight = topSpace + bottomSpace + rect.size.height;
        
        if (_myCGFloatLess(lineMaxWidth, (xPos - paddingLeading)))
            lineMaxWidth = (xPos - paddingLeading);
        
        sbvmyFrame.frame = rect;
        itemIndex++;
    }
    
    yPos += lineMaxHeight + paddingBottom;

    
    //内容填充约束布局的宽度包裹计算。
    if (lsc.widthSizeInner.dimeWrapVal)
        selfSize.width = maxWidth;
    
    if (lsc.heightSizeInner.dimeWrapVal)
       selfSize.height =  [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:yPos sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    NSInteger arranges = lineFirstSubviewIndexSet.count;
    //根据flex规则：如果只有一行则整个高度都作为子视图的拉伸和停靠区域。
    if (lsc.isFlex && arranges == 1)
        lineMaxHeight = selfSize.height - paddingVert;
    
    //最后一行
    [self myCalcVertLayoutSingleline:lineIndex vertAlignment:vertAlignment horzGravity:horzGravity lineMaxHeight:lineMaxHeight lineMaxWidth:lineMaxWidth lineTotalShrink:0 sbs:sbs startItemIndex:i - itemIndex count:itemIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc inSelfSize:selfSize];

    //整体的停靠
    if (vertGravity != MyGravity_None && selfSize.height != yPos)
    {
        //根据flex标准：只有在多行下vertGravity才有意义。非flex标准则不受这个条件约束。
        if (arranges > 1 || !lsc.isFlex)
        {
            CGFloat addYPos = 0.0;
            CGFloat between = 0.0;
            CGFloat fill = 0.0;
            
            if (vertGravity == MyGravity_Vert_Center)
            {
                addYPos = (selfSize.height - yPos) / 2;
            }
            else if (vertGravity == MyGravity_Vert_Bottom)
            {
                addYPos = selfSize.height - yPos;
            }
            else if (vertGravity == MyGravity_Vert_Fill || vertGravity == MyGravity_Vert_Stretch)
            {
                if (lineFirstSubviewIndexSet.count > 0)
                    fill = (selfSize.height - yPos) / arranges;
                
                //满足flex规则：如果剩余的空间是负数，该值等效于'flex-start'
                if (fill < 0.0  && vertGravity == MyGravity_Vert_Stretch)
                    fill = 0.0;
            }
            else if (vertGravity == MyGravity_Vert_Between)
            {
                if (lineFirstSubviewIndexSet.count > 1)
                    between = (selfSize.height - yPos) / (arranges - 1);
            }
            else if (vertGravity == MyGravity_Vert_Around)
            {
                if (lineFirstSubviewIndexSet.count > 1)
                    between = (selfSize.height - yPos) / arranges;
            }
            
            if (addYPos != 0.0 || between != 0.0 || fill != 0.0)
            {
                int lineidx = 0;
                NSUInteger lastIndex = 0;
                for (int i = 0; i < sbs.count; i++)
                {
                    UIView *sbv = sbs[i];
                    
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    
                    sbvmyFrame.top += addYPos;
                    
                    //找到行的最初索引。
                    NSUInteger index = [lineFirstSubviewIndexSet indexLessThanOrEqualToIndex:i];
                    if (lastIndex != index)
                    {
                        lastIndex = index;
                        lineidx ++;
                    }
                    
                    if (vertGravity == MyGravity_Vert_Stretch)
                    {
                        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
                        if (sbvsc.heightSizeInner.dimeVal == nil)
                        {
                            sbvmyFrame.height += fill;
                        }
                        else
                        {
                            //因为每行都增加了fill。所以如果有行内对齐则需要这里调整。
                            MyGravity sbvVertAlignment = sbvsc.alignment & MyGravity_Horz_Mask;
                            if (sbvVertAlignment == MyGravity_None)
                                sbvVertAlignment = vertAlignment;
                            
                            if (sbvVertAlignment == MyGravity_Vert_Center)
                                sbvmyFrame.top += fill/2.0;
                            else if (sbvVertAlignment == MyGravity_Vert_Bottom)
                                sbvmyFrame.top += fill;
                            else;
                        }
                    }
                    else
                    {
                        sbvmyFrame.height += fill;
                    }
                    sbvmyFrame.top += fill * lineidx;
                    
                    sbvmyFrame.top += between * lineidx;
                    
                    if (vertGravity == MyGravity_Vert_Around)
                        sbvmyFrame.top += (between / 2.0);
                }
            }
        }
    }
    
    return selfSize;
}


-(CGSize)myCalcLayoutSizeForVertOrientation:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    BOOL autoArrange = lsc.autoArrange;
    NSInteger arrangedCount = lsc.arrangedCount;
    
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity vertAlignment = lsc.arrangedGravity & MyGravity_Horz_Mask;
    
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = [self myCalcMaxMinSubviewSize:selfSize.width - paddingHorz lsc:(MyFlowLayoutViewSizeClass*)lsc arrangedCount:arrangedCount space:&horzSpace];
    
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat lineMaxHeight = 0.0;  //某一行的最高值。
    CGFloat lineMaxWidth = 0.0;   //某一行的最宽值
    CGFloat maxWidth = paddingLeading;  //全部行的最大宽度
    CGFloat maxHeight = paddingTop; //最大的高度
    
#if TARGET_OS_IOS
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] && ((UIScrollView*)self.superview).isPagingEnabled);
#else
    BOOL isPagingScroll = NO;
#endif
    
    CGFloat pagingItemHeight = 0.0;
    CGFloat pagingItemWidth = 0.0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (lsc.pagedCount > 0 && self.superview != nil)
    {
        NSInteger rows = lsc.pagedCount / arrangedCount;  //每页的行数。
        
        //对于垂直流式布局来说，要求要有明确的宽度。因此如果我们启用了分页又设置了宽度包裹时则我们的分页是从左到右的排列。否则分页是从上到下的排列。
        if (lsc.widthSizeInner.dimeWrapVal)
        {
            isHorzPaging = YES;
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (arrangedCount - 1) * horzSpace ) / arrangedCount;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingLeading - arrangedCount * horzSpace ) / arrangedCount;
            
            pagingItemHeight = (selfSize.height - paddingVert - (rows - 1) * vertSpace) / rows;
        }
        else
        {
            isVertPaging = YES;
            pagingItemWidth = (selfSize.width - paddingHorz - (arrangedCount - 1) * horzSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的高度计算是不一样的。
            if (isPagingScroll)
            {
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (rows - 1) * vertSpace) / rows;
            }
            else
            {
                if ([self.superview isKindOfClass:[UIScrollView class]])
                    pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingTop - rows * vertSpace) / rows;
                else
                    pagingItemHeight = (selfSize.height - paddingVert - (rows - 1) * vertSpace) / rows;
            }
            
        }
        
    }
    
    //平均宽度，当布局的gravity设置为Horz_Fill时指定这个平均宽度值。
    CGFloat averageWidth = 0.0;
    if (horzGravity == MyGravity_Horz_Fill)
        averageWidth = (selfSize.width - paddingHorz - (arrangedCount - 1) * horzSpace) / arrangedCount;

    //行内子视图的索引号
    NSInteger itemIndex = 0;
    NSInteger i = 0;
    CGFloat lineTotalShrink = 0.0;  //某一行的总压缩比重。
    CGFloat lineTotalWeight = 0.0;
    CGFloat lineTotalFixedWidth = 0.0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (itemIndex >= arrangedCount)
        {
            itemIndex = 0;
            
            if (lineTotalWeight != 0 && horzGravity != MyGravity_Horz_Fill)
            {
                [self myCalcVertLayoutSinglelineWeight:lineTotalWeight lineSpareWidth:selfSize.width - paddingHorz - lineTotalFixedWidth sbs:sbs startItemIndex:i - arrangedCount count:arrangedCount lsc:lsc inSelfSize:selfSize];
            }
            
            if (lineTotalShrink != 0 && horzGravity != MyGravity_Horz_Fill)
            {
                [self myCalcVertLayoutSinglelineShrink:lineTotalShrink lineSpareWidth:selfSize.width - paddingHorz - lineTotalFixedWidth sbs:sbs startItemIndex:i - arrangedCount count:arrangedCount lsc:lsc inSelfSize:selfSize];
            }
            
            lineTotalWeight = 0.0;
            lineTotalFixedWidth = 0.0;
            lineTotalShrink = 0.0;
        }
        
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        //计算每行的宽度。
        if (averageWidth != 0.0)
        {
            rect.size.width = averageWidth - leadingSpace - trailingSpace;
        }
        else if (subviewSize != 0.0)
        {
            rect.size.width = subviewSize - leadingSpace - trailingSpace;
        }
        else if (pagingItemWidth != 0.0)
        {
            rect.size.width = pagingItemWidth - leadingSpace - trailingSpace;
        }
        else if (sbvsc.widthSizeInner.dimeVal != nil)
        {
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            {//特殊处理宽度等于高度的情况
                
                if (pagingItemHeight != 0.0)
                    rect.size.height = pagingItemHeight - topSpace - bottomSpace;
                else
                    rect.size.height = [self myGetSubviewHeightSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            }
            else
            {
                rect.size.width = [self myGetSubviewWidthSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            }
        }
        else if (sbvsc.weight != 0.0)
        { //在没有设置任何约束，并且weight不为0时则使用比重来求宽度，因此这预先将宽度设置为0
            rect.size.width = 0.0;
        }
        
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.weight != 0.0)
            lineTotalWeight += sbvsc.weight;
        
        //计算总的压缩比
        lineTotalShrink += sbvsc.leadingPosInner.shrink + sbvsc.trailingPosInner.shrink;
        lineTotalShrink += sbvsc.widthSizeInner.shrink;
        
        lineTotalFixedWidth += rect.size.width;
        lineTotalFixedWidth += leadingSpace + trailingSpace;
        if (itemIndex != (arrangedCount - 1))
            lineTotalFixedWidth += horzSpace;
        
        sbvmyFrame.frame = rect;
        itemIndex++;

    }
    
    //最后一行。
    if (itemIndex < arrangedCount)
        lineTotalFixedWidth -= horzSpace;
    
    if (lineTotalWeight != 0.0 && horzGravity != MyGravity_Horz_Fill)
    {
        [self myCalcVertLayoutSinglelineWeight:lineTotalWeight lineSpareWidth:selfSize.width - paddingHorz - lineTotalFixedWidth sbs:sbs startItemIndex:i - itemIndex count:itemIndex lsc:lsc inSelfSize:selfSize];
    }
    
    //如果有压缩子视图的处理则需要压缩子视图。
    if (lineTotalShrink != 0.0 && horzGravity != MyGravity_Horz_Fill)
    {
        [self myCalcVertLayoutSinglelineShrink:lineTotalShrink lineSpareWidth:selfSize.width - paddingHorz - lineTotalFixedWidth sbs:sbs startItemIndex:i - itemIndex count:itemIndex lsc:lsc inSelfSize:selfSize];
    }
    
    //初始化每行的下一个子视图的位置。
    NSMutableArray<NSValue*> *nextPointOfRows = nil;
    if (autoArrange)
    {
        nextPointOfRows = [NSMutableArray arrayWithCapacity:arrangedCount];
        for (NSInteger idx = 0; idx < arrangedCount; idx++)
        {
            [nextPointOfRows addObject:[NSValue valueWithCGPoint:CGPointMake(paddingLeading, paddingTop)]];
        }
    }
    
    NSInteger lineIndex = 0;  //行索引
    CGFloat pageWidth  = 0.0; //页宽。
    itemIndex = 0;
    lineTotalShrink = 0.0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        //新的一行
        if (itemIndex >=  arrangedCount)
        {
            itemIndex = 0;
            yPos += vertSpace;
            yPos += lineMaxHeight;
            
            [self myCalcVertLayoutSingleline:lineIndex vertAlignment:vertAlignment horzGravity:horzGravity lineMaxHeight:lineMaxHeight lineMaxWidth:lineMaxWidth lineTotalShrink:lineTotalShrink sbs:sbs startItemIndex:i - arrangedCount count:arrangedCount vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc inSelfSize:selfSize];
            
            //分别处理水平分页和垂直分页。
            if (isHorzPaging)
            {
                if (i % lsc.pagedCount == 0)
                {
                    pageWidth += CGRectGetWidth(self.superview.bounds);
                    
                    if (!isPagingScroll)
                        pageWidth -= paddingLeading;
                    
                    yPos = paddingTop;
                }
                
            }
            
            if (isVertPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % lsc.pagedCount == 0)
                {
                    if (isPagingScroll)
                    {
                        yPos -= vertSpace;
                        yPos += paddingVert;
                    }
                }
            }
            
            xPos = paddingLeading + pageWidth;
            
            lineMaxHeight = 0.0;
            lineMaxWidth = 0.0;
            lineTotalShrink = 0.0;
            lineIndex++;
        }
        
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        if (pagingItemHeight != 0)
        {
            rect.size.height = pagingItemHeight - topSpace - bottomSpace;
        }
        else if (sbvsc.heightSizeInner.dimeVal != nil)
        {
            rect.size.height = [self myGetSubviewHeightSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
        }
        else if (vertGravity == MyGravity_Vert_Fill || vertGravity == MyGravity_Vert_Stretch)
        {//如果没有设置高度约束但是又是垂直拉伸则将高度设置为0.
            rect.size.height = 0;
        }
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        //再算一次宽度,只有比重为0并且不压缩的情况下计算。否则有可能前面被压缩或者被拉升而又会在这里重置了
        if (sbvsc.weight == 0.0 && sbvsc.widthSizeInner.shrink == 0 && horzGravity != MyGravity_Horz_Fill)
        {
            rect.size.width = [self myGetSubviewWidthSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
        }
        
        //特殊处理宽度和高度相互依赖的情况。。
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {//特殊处理高度等于宽度的情况
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner && horzGravity != MyGravity_Horz_Fill)
        {//特殊处理宽度等于高度的情况
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //得到最大的行高
        if (_myCGFloatLess(lineMaxHeight, topSpace + bottomSpace + rect.size.height))
            lineMaxHeight = topSpace + bottomSpace + rect.size.height;
        
        
        //自动排列。
        if (autoArrange)
        {
            //查找能存放当前子视图的最小y轴的位置以及索引。
            CGPoint minPt = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
            NSInteger minNextPointIndex = 0;
            for (int idx = 0; idx < arrangedCount; idx++)
            {
                CGPoint pt = nextPointOfRows[idx].CGPointValue;
                if (minPt.y > pt.y)
                {
                    minPt = pt;
                    minNextPointIndex = idx;
                }
            }
            
            //找到的minNextPointIndex中的
            xPos = minPt.x;
            yPos = minPt.y;
            
            minPt.y = minPt.y + topSpace + rect.size.height + bottomSpace + vertSpace;
            nextPointOfRows[minNextPointIndex] = [NSValue valueWithCGPoint:minPt];
            if (minNextPointIndex + 1 <= arrangedCount - 1)
            {
                minPt = nextPointOfRows[minNextPointIndex + 1].CGPointValue;
                minPt.x = xPos + leadingSpace + rect.size.width + trailingSpace + horzSpace;
                nextPointOfRows[minNextPointIndex + 1] = [NSValue valueWithCGPoint:minPt];
            }
            
            if (_myCGFloatLess(maxHeight, yPos + topSpace + rect.size.height + bottomSpace))
                maxHeight = yPos + topSpace + rect.size.height + bottomSpace;
            
        }
        else if (vertAlignment == MyGravity_Vert_Between)
        { //当列是紧凑排列时需要特殊处理当前的垂直位置。
            //第0行特殊处理。
            if (i - arrangedCount < 0)
            {
                yPos = paddingTop;
            }
            else
            {
                //取前一行的对应的列的子视图。
                UIView *myPrevColSbv = (UIView*)sbs[i - arrangedCount];
                MyFrame *myPrevColSbvFrame = myPrevColSbv.myFrame;
                UIView *myPrevColSbvsc = [myPrevColSbv myCurrentSizeClassFrom:myPrevColSbvFrame];
                //当前子视图的位置等于前一行对应列的最大y的值 + 前面对应列的底部间距 + 子视图之间的行间距。
                yPos =  CGRectGetMaxY(myPrevColSbvFrame.frame)+ myPrevColSbvsc.bottomPosInner.absVal + vertSpace;
            }
            
            if (_myCGFloatLess(maxHeight, yPos + topSpace + rect.size.height + bottomSpace))
                maxHeight = yPos + topSpace + rect.size.height + bottomSpace;
        }
        else
        {//正常排列。
            //这里的最大其实就是最后一个视图的位置加上最高的子视图的尺寸。
            maxHeight = yPos + lineMaxHeight;
        }
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;
        
        if (itemIndex != (arrangedCount - 1) && !autoArrange)
            xPos += horzSpace;
        
        if (_myCGFloatLess(lineMaxWidth, (xPos - paddingLeading)))
            lineMaxWidth = (xPos - paddingLeading);
        
        if (_myCGFloatLess(maxWidth, xPos))
            maxWidth = xPos;
    
        sbvmyFrame.frame = rect;
        itemIndex++;
        
        //这里只对间距进行压缩比重的计算，因为前面压缩了宽度，这里只需要压缩间距了。
        lineTotalShrink += sbvsc.leadingPosInner.shrink + sbvsc.trailingPosInner.shrink;
    }

    maxHeight += paddingBottom;
    
    if (lsc.heightSizeInner.dimeWrapVal)
    {
        selfSize.height = maxHeight;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的高度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的高度小于指定页数的高度，因为要分页滚动所以这里会扩充布局的高度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_myCGFloatLess(selfSize.height, totalPages * CGRectGetHeight(self.superview.bounds)))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }
        
        selfSize.height =  [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    }
    
    //得到行数
    NSInteger arranges = floor((sbs.count + arrangedCount - 1.0) / arrangedCount); //行数
    //根据flex规则：如果只有一行则整个高度都作为子视图的拉伸和停靠区域。
    if (lsc.isFlex && arranges == 1)
        lineMaxHeight = selfSize.height - paddingVert;
    
    //最后一行，有可能因为行宽的压缩导致那些高度依赖宽度以及高度自适应的视图会增加高度，从而使得行高被调整。
    [self myCalcVertLayoutSingleline:lineIndex vertAlignment:vertAlignment horzGravity:horzGravity lineMaxHeight:lineMaxHeight lineMaxWidth:lineMaxWidth lineTotalShrink:lineTotalShrink sbs:sbs startItemIndex:i - itemIndex count:itemIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc inSelfSize:selfSize];
    

    //整体的停靠
    if  (vertGravity != MyGravity_None && selfSize.height != maxHeight && !(isVertPaging && isPagingScroll))
    {
        //根据flex标准：只有在多行下vertGravity才有意义。非flex标准则不受这个条件约束。
        if (arranges > 1 || !lsc.isFlex)
        {
            CGFloat addYPos = 0.0;
            CGFloat between = 0.0;
            CGFloat fill = 0.0;
            
            if (vertGravity == MyGravity_Vert_Center)
            {
                addYPos = (selfSize.height - maxHeight) / 2;
            }
            else if (vertGravity == MyGravity_Vert_Bottom)
            {
                addYPos = selfSize.height - maxHeight;
            }
            else if (vertGravity == MyGravity_Vert_Fill || vertGravity == MyGravity_Vert_Stretch)
            {
                if (arranges > 0)
                    fill = (selfSize.height - maxHeight) / arranges;
                
                //满足flex规则：如果剩余的空间是负数，该值等效于'flex-start'
                if (fill < 0.0 && vertGravity == MyGravity_Vert_Stretch)
                    fill = 0.0;
            }
            else if (vertGravity == MyGravity_Vert_Between)
            {
                if (arranges > 1)
                    between = (selfSize.height - maxHeight) / (arranges - 1);
            }
            else if (vertGravity == MyGravity_Vert_Around)
            {
                if (arranges > 1)
                    between = (selfSize.height - maxHeight) / arranges;
            }
            
            if (addYPos != 0.0 || between != 0.0 || fill != 0.0)
            {
                for (int i = 0; i < sbs.count; i++)
                {
                    UIView *sbv = sbs[i];
                    
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    
                    int lineidx = i / arrangedCount;
                    if (vertGravity == MyGravity_Vert_Stretch)
                    {
                        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
                        if (sbvsc.heightSizeInner.dimeVal == nil)
                        {
                            sbvmyFrame.height += fill;
                        }
                        else
                        {
                            //因为每行都增加了fill。所以如果有行内对齐则需要这里调整。
                            MyGravity sbvVertAlignment = sbvsc.alignment & MyGravity_Horz_Mask;
                            if (sbvVertAlignment == MyGravity_None)
                                sbvVertAlignment = vertAlignment;
                            
                            if (sbvVertAlignment == MyGravity_Vert_Center)
                                sbvmyFrame.top += fill/2.0;
                            else if (sbvVertAlignment == MyGravity_Vert_Bottom)
                                sbvmyFrame.top += fill;
                            else;
                        }
                    }
                    else
                    {
                        sbvmyFrame.height += fill;
                    }
                    sbvmyFrame.top += fill * lineidx;
                    
                    sbvmyFrame.top += addYPos;
                    
                    sbvmyFrame.top += between * lineidx;
                    
                    //如果是vert_around那么所有行都应该添加一半的between值。
                    if (vertGravity == MyGravity_Vert_Around)
                        sbvmyFrame.top += (between / 2.0);
                }
            }
        }
    }
    
    if (lsc.widthSizeInner.dimeWrapVal)
    {
        selfSize.width = maxWidth + paddingTrailing;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_myCGFloatLess(selfSize.width, totalPages * CGRectGetWidth(self.superview.bounds)))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }
    }
    
    return selfSize;
}

-(CGSize)myCalcLayoutSizeForHorzOrientationContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{

    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;

    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity horzAlign =  [self myConvertLeftRightGravityToLeadingTrailing:lsc.arrangedGravity & MyGravity_Vert_Mask];
        
    
    //支持浮动垂直间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = [self myCalcMaxMinSubviewSizeForContent:selfSize.height - paddingVert lsc:(MyFlowLayoutViewSizeClass*)lsc space:&vertSpace];
    
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat lineMaxWidth = 0.0;  //某一列的最宽值。
    CGFloat lineMaxHeight = 0.0;   //某一列的最高值
    CGFloat maxHeight = 0.0;   //所有列的最宽行
    
    if (lsc.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
            
#ifdef DEBUG
            //约束异常：水平流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbvsc.weight == 0, @"Constraint exception!! horizontal flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            
            CGFloat topSpace = sbvsc.topPosInner.absVal;
            CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
            CGRect rect = sbvmyFrame.frame;
            
            
            rect.size.width = [self myGetSubviewWidthSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            rect.size.height = [self myGetSubviewHeightSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];

            //暂时把宽度存放sbv.myFrame.trailing上。因为流式布局来说这个属性无用。
            sbvmyFrame.trailing = topSpace + rect.size.height + bottomSpace;
            if (_myCGFloatGreat(sbvmyFrame.trailing, selfSize.height - paddingVert))
                sbvmyFrame.trailing = selfSize.height - paddingVert;
        }
        
        [sbs setArray:[self myGetAutoArrangeSubviews:sbs selfSize:selfSize.height - paddingVert space:vertSpace]];
    }
    
    NSMutableIndexSet *lineFirstSubviewIndexSet = [NSMutableIndexSet new];
    NSInteger lineIndex = 0;
    NSInteger itemIndex = 0;
    CGFloat lineTotalWeight = 0.0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;

        //这里先计算一下宽度，因为有可能有宽度固定，高度自适应的情况。
        if (sbvsc.widthSizeInner.dimeVal != nil)
        {
            rect.size.width = [self myGetSubviewWidthSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        }
        else if (horzGravity == MyGravity_Horz_Fill || horzGravity == MyGravity_Horz_Stretch)
        {
            rect.size.width = 0.0;
        }
        
        if (subviewSize != 0.0)
        {
            rect.size.height = subviewSize - topSpace - bottomSpace;
        }
        else if (sbvsc.heightSizeInner.dimeVal != nil)
        {
            rect.size.height = [self myGetSubviewHeightSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            
            if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            {//特殊处理高度等于宽度的情况
                rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            }
        }
        else if (sbvsc.weight != 0.0)
        {
            if (lsc.isFlex)
            {
                rect.size.height = 0.0;
            }
            else
            {
               //如果超过了布局尺寸，则表示当前的剩余空间为0了，所以就按新的一行来算。。
                CGFloat lineSpareHeight = selfSize.height - paddingBottom - yPos - topSpace - bottomSpace;
                if (itemIndex != 0)
                    lineSpareHeight -= vertSpace;
                if (_myCGFloatLessOrEqual(lineSpareHeight, 0.0))
                {
                    lineSpareHeight = selfSize.height - paddingVert;
                }
               
                rect.size.height = (lineSpareHeight + sbvsc.heightSizeInner.addVal) * sbvsc.weight - topSpace - bottomSpace;
            }
        }
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //特殊处理宽度依赖高度的子视图。
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
        {//特殊处理宽度等于高度的情况
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        //计算yPos的值加上topSpace + rect.size.height + bottomSpace的值要小于整体的高度。
        CGFloat place = yPos + topSpace + rect.size.height + bottomSpace;
        if (itemIndex != 0)
            place += vertSpace;
        place += paddingBottom;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (!lsc.heightSizeInner.dimeWrapVal && (place - selfSize.height > 0.0001))
        {
            [lineFirstSubviewIndexSet addIndex:i - itemIndex];

           //拉伸以及调整行内子视图的高度。
            [self myAdjustHorzLayoutSingleline:lineIndex lineSpareHeight:selfSize.height - paddingBottom - yPos lineTotalWeight:lineTotalWeight vertGravity:vertGravity sbs:sbs startItemIndex:i - itemIndex count:itemIndex lsc:lsc inSelfSize:selfSize];
            
            yPos = paddingTop;
            
            //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
            if (_myCGFloatGreat(topSpace + bottomSpace + rect.size.height, selfSize.height - paddingVert))
            {
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:selfSize.height - paddingVert - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            lineTotalWeight = 0.0;
            lineIndex++;
            itemIndex = 0;
        }
        
        if (itemIndex != 0)
            yPos += vertSpace;
        
        
        rect.origin.y = yPos + topSpace;
        yPos += topSpace + rect.size.height + bottomSpace;
        
        if (lsc.isFlex && sbvsc.weight != 0)
            lineTotalWeight += sbvsc.weight;
        
        sbvmyFrame.frame = rect;
        itemIndex++;
    }
    
    //最后一行的行首索引
    [lineFirstSubviewIndexSet addIndex:i - itemIndex];
    
    [self myAdjustHorzLayoutSingleline:lineIndex lineSpareHeight:selfSize.height - paddingBottom - yPos lineTotalWeight:lineTotalWeight vertGravity:vertGravity sbs:sbs startItemIndex:i - itemIndex count:itemIndex lsc:lsc inSelfSize:selfSize];

    
    yPos = paddingTop;
    lineIndex = 0;   //行的索引。
    itemIndex = 0; //行内的子视图索引
    NSInteger oldLineFirstIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
       
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
        {//特殊处理宽度等于高度的情况
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算yPos的值加上topSpace + rect.size.height + bottomSpace 的值要小于整体的高度。
        maxHeight= yPos + topSpace + rect.size.height + bottomSpace;
        if (itemIndex != 0)
            maxHeight += vertSpace;
        maxHeight += paddingBottom;
        
        NSUInteger lineFirstIndex = [lineFirstSubviewIndexSet indexLessThanOrEqualToIndex:i];
        if (!lsc.heightSizeInner.dimeWrapVal && oldLineFirstIndex != lineFirstIndex)
        {
            oldLineFirstIndex = lineFirstIndex;
            
            yPos = paddingTop;
            xPos += horzSpace;
            xPos += lineMaxWidth;
            
            [self myCalcHorzLayoutSingleline:lineIndex horzAlignment:horzAlign vertGravity:vertGravity lineMaxWidth:lineMaxWidth lineMaxHeight:lineMaxHeight lineTotalShrink:0 sbs:sbs startItemIndex:i - itemIndex count:itemIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc inSelfSize:selfSize];
            
            
            lineMaxWidth = 0.0;
            lineMaxHeight = 0.0;
            itemIndex = 0;
            lineIndex++;
            
        }
        
        if (itemIndex != 0)
            yPos += vertSpace;
        
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        yPos += topSpace + rect.size.height + bottomSpace;
        
        if (_myCGFloatLess(lineMaxWidth, leadingSpace + trailingSpace + rect.size.width))
            lineMaxWidth = leadingSpace + trailingSpace + rect.size.width;
        
        if (_myCGFloatLess(lineMaxHeight, (yPos - paddingTop)))
            lineMaxHeight = (yPos - paddingTop);
        
        sbvmyFrame.frame = rect;
        itemIndex++;
    }
    
    xPos += lineMaxWidth + paddingTrailing;

    if (lsc.heightSizeInner.dimeWrapVal)
        selfSize.height = maxHeight;


    if (lsc.widthSizeInner.dimeWrapVal)
        selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:xPos sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    NSInteger arranges = lineFirstSubviewIndexSet.count;
    //根据flex规则：如果只有一列则整个宽度都作为子视图的拉伸和停靠区域。
    if (lsc.isFlex && arranges == 1)
        lineMaxWidth = selfSize.width - paddingHorz;

    //最后一行
     [self myCalcHorzLayoutSingleline:lineIndex horzAlignment:horzAlign vertGravity:vertGravity lineMaxWidth:lineMaxWidth lineMaxHeight:lineMaxHeight lineTotalShrink:0 sbs:sbs startItemIndex:i - itemIndex count:itemIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc inSelfSize:selfSize];
    
    //整体的停靠
    if (horzGravity != MyGravity_None && selfSize.width != xPos)
    {
        //根据flex标准：只有在多行下horzGravity才有意义。非flex标准则不受这个条件约束。
        if (arranges > 1 || !lsc.isFlex)
        {
            CGFloat addXPos = 0.0;
            CGFloat fill = 0.0;
            CGFloat between = 0.0;
            if (horzGravity == MyGravity_Horz_Center)
            {
                addXPos = (selfSize.width - xPos) / 2;
            }
            else if (horzGravity == MyGravity_Horz_Trailing)
            {
                addXPos = selfSize.width - xPos;
            }
            else if (horzGravity == MyGravity_Horz_Fill || horzGravity == MyGravity_Horz_Stretch)
            {
                if (lineFirstSubviewIndexSet.count > 0)
                    fill = (selfSize.width - xPos) / lineFirstSubviewIndexSet.count;
                
                //满足flex规则：如果剩余的空间是负数，该值等效于'flex-start'
                if (fill < 0.0 && horzGravity == MyGravity_Horz_Stretch)
                    fill = 0.0;
            }
            else if (horzGravity == MyGravity_Horz_Between)
            {
                if (lineFirstSubviewIndexSet.count > 1)
                    between = (selfSize.width - xPos) / (lineFirstSubviewIndexSet.count - 1);
            }
            else if (horzGravity == MyGravity_Horz_Around)
            {
                if (lineFirstSubviewIndexSet.count > 1)
                    between = (selfSize.width - xPos) / lineFirstSubviewIndexSet.count;
            }
            
            if (addXPos != 0.0 || between != 0.0 || fill != 0.0)
            {
                int lineidx = 0;
                NSUInteger lastIndex = 0;
                for (int i = 0; i < sbs.count; i++)
                {
                    UIView *sbv = sbs[i];
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    
                    sbvmyFrame.leading += addXPos;
                    
                    //找到行的最初索引。
                    NSUInteger index = [lineFirstSubviewIndexSet indexLessThanOrEqualToIndex:i];
                    if (lastIndex != index)
                    {
                        lastIndex = index;
                        lineidx ++;
                    }
                    
                    if (horzGravity == MyGravity_Horz_Stretch)
                    {
                        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
                        if (sbvsc.widthSizeInner.dimeVal == nil)
                        {
                            sbvmyFrame.width += fill;
                        }
                        else
                        {
                            //因为每行都增加了fill。所以如果有行内对齐则需要这里调整。
                            MyGravity sbvHorzAlignment = [self myConvertLeftRightGravityToLeadingTrailing:sbvsc.alignment & MyGravity_Vert_Mask];
                            if (sbvHorzAlignment == MyGravity_None)
                                sbvHorzAlignment = horzAlign;
                            
                            if (sbvHorzAlignment == MyGravity_Horz_Center)
                                sbvmyFrame.leading += fill/2.0;
                            else if (sbvHorzAlignment == MyGravity_Horz_Trailing)
                                sbvmyFrame.leading += fill;
                            else;
                        }
                    }
                    else
                    {
                        sbvmyFrame.width += fill;
                    }
                    sbvmyFrame.leading += fill * lineidx;
                    
                    sbvmyFrame.leading += between * lineidx;
                    
                    if (horzGravity == MyGravity_Horz_Around)
                        sbvmyFrame.leading += (between / 2.0);
                }
            }
        }
    }
    
    return selfSize;
}



-(CGSize)myCalcLayoutSizeForHorzOrientation:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(MyFlowLayout*)lsc
{
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;

    BOOL autoArrange = lsc.autoArrange;
    NSInteger arrangedCount = lsc.arrangedCount;
    
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity horzAlignment =  [self myConvertLeftRightGravityToLeadingTrailing:lsc.arrangedGravity & MyGravity_Vert_Mask];
    
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = [self myCalcMaxMinSubviewSize:selfSize.height - paddingVert lsc:(MyFlowLayoutViewSizeClass*)lsc arrangedCount:arrangedCount space:&vertSpace];
    
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat lineMaxWidth = 0.0;  //每一列的最大宽度
    CGFloat lineMaxHeight = 0.0; //每一列的最大高度
    CGFloat maxHeight = paddingTop; //全列的最大高度
    CGFloat maxWidth = paddingLeading; //最大的宽度。
    
    //父滚动视图是否分页滚动。
#if TARGET_OS_IOS
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] && ((UIScrollView*)self.superview).isPagingEnabled);
#else
    BOOL isPagingScroll = NO;
#endif
    
    CGFloat pagingItemHeight = 0.0;
    CGFloat pagingItemWidth = 0.0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (lsc.pagedCount > 0 && self.superview != nil)
    {
        NSInteger cols = lsc.pagedCount / arrangedCount;  //每页的列数。
        
        //对于水平流式布局来说，要求要有明确的高度。因此如果我们启用了分页又设置了高度包裹时则我们的分页是从上到下的排列。否则分页是从左到右的排列。
        if (lsc.heightSizeInner.dimeWrapVal)
        {
            isVertPaging = YES;
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (arrangedCount - 1) * vertSpace ) / arrangedCount;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingTop - arrangedCount * vertSpace ) / arrangedCount;
            
            pagingItemWidth = (selfSize.width - paddingHorz - (cols - 1) * horzSpace) / cols;
        }
        else
        {
            isHorzPaging = YES;
            pagingItemHeight = (selfSize.height - paddingVert - (arrangedCount - 1) * vertSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的宽度计算是不一样的。
            if (isPagingScroll)
            {
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (cols - 1) * horzSpace) / cols;
            }
            else
            {
                if ([self.superview isKindOfClass:[UIScrollView class]])
                    pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingLeading - cols * horzSpace) / cols;
                else
                    pagingItemWidth = (selfSize.width - paddingHorz - (cols - 1) * horzSpace) / cols;
            }
            
        }
        
    }
    
    //平均高度，当布局的gravity设置为Vert_Fill时指定这个平均高度值。
    CGFloat averageHeight = 0.0;
    if (vertGravity == MyGravity_Vert_Fill)
        averageHeight = (selfSize.height - paddingVert - (arrangedCount - 1) * vertSpace) / arrangedCount;

    NSInteger itemIndex = 0;
    NSInteger i = 0;
    CGFloat lineTotalShrink = 0.0;  //某一行的总压缩比重。
    CGFloat lineTotalWeight = 0.0;
    CGFloat lineTotalFixedHeight = 0.0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        if (itemIndex >= arrangedCount)
        {
            itemIndex = 0;
            
            if (lineTotalWeight != 0 && vertGravity != MyGravity_Vert_Fill)
            {
                [self myCalcHorzLayoutSinglelineWeight:lineTotalWeight lineSpareHeight:selfSize.height - paddingVert - lineTotalFixedHeight sbs:sbs startItemIndex:i - arrangedCount count:arrangedCount lsc:lsc inSelfSize:selfSize];
            }
            
            if (lineTotalShrink != 0 && vertGravity != MyGravity_Vert_Fill)
            {
                [self myCalcHorzLayoutSinglelineShrink:lineTotalShrink lineSpareHeight:selfSize.height - paddingVert - lineTotalFixedHeight sbs:sbs startItemIndex:i - arrangedCount count:arrangedCount lsc:lsc inSelfSize:selfSize];
            }
            
            lineTotalWeight = 0.0;
            lineTotalFixedHeight = 0.0;
            lineTotalShrink = 0.0;
            
        }
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        //水平流式布局因为高度依赖宽度自适应的情况比较少，所以这里直接先计算宽度
        if (pagingItemWidth != 0.0)
            rect.size.width = pagingItemWidth - leadingSpace - trailingSpace;
        else if (sbvsc.widthSizeInner.dimeVal != nil)
        {
            rect.size.width = [self myGetSubviewWidthSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
        }
        else if (horzGravity == MyGravity_Horz_Fill || horzGravity == MyGravity_Horz_Stretch)
        {
            rect.size.width = 0;
        }
        
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (averageHeight != 0.0)
        {
            rect.size.height = averageHeight - topSpace - bottomSpace;
        }
        else if (subviewSize != 0.0)
        {
            rect.size.height = subviewSize - topSpace - bottomSpace;
        }
        else if (pagingItemHeight != 0.0)
        {
            rect.size.height = pagingItemHeight - topSpace - bottomSpace;
        }
        else if (sbvsc.heightSizeInner.dimeVal != nil)
        {
            if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            {//特殊处理高度等于宽度的情况
                rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            }
            else
            {
                rect.size.height = [self myGetSubviewHeightSizeValue:sbv sbvsc:sbvsc lsc:lsc selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing sbvSize:rect.size];
            }
        }
        else if (sbvsc.weight != 0.0)
        {
            rect.size.height = 0.0;
        }
        
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
        {//特殊处理宽度等于高度的情况
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        if (sbvsc.weight != 0)
            lineTotalWeight += sbvsc.weight;
        
        //计算总的压缩比
        lineTotalShrink += sbvsc.topPosInner.shrink + sbvsc.bottomPosInner.shrink;
        lineTotalShrink += sbvsc.heightSizeInner.shrink;
        
        lineTotalFixedHeight += rect.size.height;
        lineTotalFixedHeight += topSpace + bottomSpace;
        if (itemIndex != (arrangedCount - 1))
            lineTotalFixedHeight += vertSpace;
        
        sbvmyFrame.frame = rect;
        itemIndex++;
    }
    
    //最后一行。
    if (itemIndex < arrangedCount)
        lineTotalFixedHeight -= vertSpace;
    
    if (lineTotalWeight != 0.0 && vertGravity != MyGravity_Vert_Fill)
    {
        [self myCalcHorzLayoutSinglelineWeight:lineTotalWeight lineSpareHeight:selfSize.height - paddingVert - lineTotalFixedHeight sbs:sbs startItemIndex:i - itemIndex count:itemIndex lsc:lsc inSelfSize:selfSize];
    }
    
    if (lineTotalShrink != 0.0 && vertGravity != MyGravity_Vert_Fill)
    {
        [self myCalcHorzLayoutSinglelineShrink:lineTotalShrink lineSpareHeight:selfSize.height - paddingVert - lineTotalFixedHeight sbs:sbs startItemIndex:i - itemIndex count:itemIndex lsc:lsc inSelfSize:selfSize];
    }
    
    //初始化每行的下一个子视图的位置。
    NSMutableArray<NSValue*> *nextPointOfCols = nil;
    if (autoArrange)
    {
        nextPointOfCols = [NSMutableArray arrayWithCapacity:arrangedCount];
        for (NSInteger idx = 0; idx < arrangedCount; idx++)
        {
            [nextPointOfCols addObject:[NSValue valueWithCGPoint:CGPointMake(paddingLeading, paddingTop)]];
        }
    }
   
    NSInteger lineIndex = 0;
    CGFloat pageHeight = 0.0; //页高
    itemIndex = 0;
    lineTotalShrink = 0.0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        MyFrame *sbvmyFrame = sbv.myFrame;
        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
       
        if (itemIndex >=  arrangedCount)
        {
            itemIndex = 0;
            xPos += horzSpace;
            xPos += lineMaxWidth;
            
            [self myCalcHorzLayoutSingleline:lineIndex horzAlignment:horzAlignment vertGravity:vertGravity lineMaxWidth:lineMaxWidth lineMaxHeight:lineMaxHeight lineTotalShrink:lineTotalShrink sbs:sbs startItemIndex:i - arrangedCount count:arrangedCount vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc inSelfSize:selfSize];
            
            
            //分别处理水平分页和垂直分页。
            if (isVertPaging)
            {
                if (i % lsc.pagedCount == 0)
                {
                    pageHeight += CGRectGetHeight(self.superview.bounds);
                    
                    if (!isPagingScroll)
                        pageHeight -= paddingTop;
                    
                    xPos = paddingLeading;
                }
            }
            
            if (isHorzPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % lsc.pagedCount == 0)
                {
                    if (isPagingScroll)
                    {
                        xPos -= horzSpace;
                        xPos += paddingHorz;
                    }
                }
            }
            
            
            yPos = paddingTop + pageHeight;
            
            lineMaxWidth = 0.0;
            lineMaxHeight = 0.0;
            lineTotalShrink = 0.0;
            lineIndex++;
        }
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        //得到最大的列宽
        if (_myCGFloatLess(lineMaxWidth, leadingSpace + trailingSpace + rect.size.width))
            lineMaxWidth = leadingSpace + trailingSpace + rect.size.width;
        
        //自动排列。
        if (autoArrange)
        {
            //查找能存放当前子视图的最小x轴的位置以及索引。
            CGPoint minPt = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
            NSInteger minNextPointIndex = 0;
            for (int idx = 0; idx < arrangedCount; idx++)
            {
                CGPoint pt = nextPointOfCols[idx].CGPointValue;
                if (minPt.x > pt.x)
                {
                    minPt = pt;
                    minNextPointIndex = idx;
                }
            }
            
            //找到的minNextPointIndex中的
            xPos = minPt.x;
            yPos = minPt.y;
            
            minPt.x = minPt.x + leadingSpace + rect.size.width + trailingSpace + horzSpace;
            nextPointOfCols[minNextPointIndex] = [NSValue valueWithCGPoint:minPt];
            if (minNextPointIndex + 1 <= arrangedCount - 1)
            {
                minPt = nextPointOfCols[minNextPointIndex + 1].CGPointValue;
                minPt.y = yPos + topSpace + rect.size.height + bottomSpace + vertSpace;
                nextPointOfCols[minNextPointIndex + 1] = [NSValue valueWithCGPoint:minPt];
            }
            
            if (_myCGFloatLess(maxWidth, xPos + leadingSpace + rect.size.width + trailingSpace))
                maxWidth = xPos + leadingSpace + rect.size.width + trailingSpace;
        
        }
        else if (horzAlignment == MyGravity_Horz_Between)
        { //当列是紧凑排列时需要特殊处理当前的水平位置。
            //第0列特殊处理。
            if (i - arrangedCount < 0)
            {
                xPos = paddingLeading;
            }
            else
            {
                //取前一列的对应的行的子视图。
                UIView *myPrevColSbv = (UIView*)sbs[i - arrangedCount];
                MyFrame *myPrevColSbvFrame = myPrevColSbv.myFrame;
                UIView *myPrevColSbvsc = [myPrevColSbv myCurrentSizeClassFrom:myPrevColSbvFrame];
                //当前子视图的位置等于前一列对应行的最大x的值 + 前面对应行的尾部间距 + 子视图之间的列间距。
                xPos =  CGRectGetMaxX(myPrevColSbvFrame.frame)+ myPrevColSbvsc.trailingPosInner.absVal + horzSpace;
            }
            
            if (_myCGFloatLess(maxWidth, xPos + leadingSpace + rect.size.width + trailingSpace))
                maxWidth = xPos + leadingSpace + rect.size.width + trailingSpace;
        }
        else
        {//正常排列。
            //这里的最大其实就是最后一个视图的位置加上最宽的子视图的尺寸。
            maxWidth = xPos + lineMaxWidth;
        }
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        yPos += topSpace + rect.size.height + bottomSpace;
        
        //不是最后一行以及非自动排列时才添加布局视图设置的行间距。自动排列的情况下上面已经有添加行间距了。
        if (itemIndex != (arrangedCount - 1) && !autoArrange)
            yPos += vertSpace;
        
        
        if (_myCGFloatLess(lineMaxHeight, (yPos - paddingTop)))
            lineMaxHeight = yPos - paddingTop;
        
        if (_myCGFloatLess(maxHeight, yPos))
            maxHeight = yPos;
        
    
        sbvmyFrame.frame = rect;
        itemIndex++;
        
        //这里只对间距进行压缩比重的计算。
        lineTotalShrink += sbvsc.topPosInner.shrink + sbvsc.bottomPosInner.shrink;
    }
    
    
    maxWidth += paddingTrailing;
    
    if (lsc.widthSizeInner.dimeWrapVal)
    {
        selfSize.width = maxWidth;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_myCGFloatLess(selfSize.width, totalPages * CGRectGetWidth(self.superview.bounds)))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }
        
        selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    }
    
    //得到行数
    NSInteger arranges = floor((sbs.count + arrangedCount - 1.0) / arrangedCount); //行数
    //根据flex规则：如果只有一行则整个高度都作为子视图的拉伸和停靠区域。
    if (lsc.isFlex && arranges == 1)
        lineMaxWidth = selfSize.width - paddingHorz;
    
    //最后一行
     [self myCalcHorzLayoutSingleline:lineIndex horzAlignment:horzAlignment vertGravity:vertGravity lineMaxWidth:lineMaxWidth lineMaxHeight:lineMaxHeight lineTotalShrink:lineTotalShrink sbs:sbs startItemIndex:i - itemIndex count:itemIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc inSelfSize:selfSize];
    

    //整体的停靠。
    if (horzGravity != MyGravity_None && selfSize.width != maxWidth && !(isHorzPaging && isPagingScroll))
    {

        //根据flex标准：只有在多行下horzGravity才有意义。非flex标准则不受这个条件约束。
        if (arranges > 1 || !lsc.isFlex)
        {
            CGFloat addXPos = 0.0;
            CGFloat between = 0.0;
            CGFloat fill = 0.0;
            
            if (horzGravity == MyGravity_Horz_Center)
            {
                addXPos = (selfSize.width - maxWidth) / 2;
            }
            else if (horzGravity == MyGravity_Horz_Trailing)
            {
                addXPos = selfSize.width - maxWidth;
            }
            else if (horzGravity == MyGravity_Horz_Fill || horzGravity == MyGravity_Horz_Stretch)
            {
                if (arranges > 0)
                    fill = (selfSize.width - maxWidth) / arranges;
                
                //满足flex规则：如果剩余的空间是负数，该值等效于'flex-start'
                if (fill < 0.0 && horzGravity == MyGravity_Horz_Stretch)
                    fill = 0.0;
            }
            else if (horzGravity == MyGravity_Horz_Between)
            {
                if (arranges > 1)
                    between = (selfSize.width - maxWidth) / (arranges - 1);
            }
            else if (horzGravity == MyGravity_Horz_Around)
            {
                if (arranges > 1)
                    between = (selfSize.width - maxWidth) / arranges;
            }
            
            if (addXPos != 0.0 || between != 0.0 || fill != 0.0)
            {
                for (int i = 0; i < sbs.count; i++)
                {
                    UIView *sbv = sbs[i];
                    
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    
                    int lineidx = i / arrangedCount;
                    if (horzGravity == MyGravity_Horz_Stretch)
                    {
                        UIView *sbvsc = [sbv myCurrentSizeClassFrom:sbvmyFrame];
                        if (sbvsc.widthSizeInner.dimeVal == nil)
                        {
                            sbvmyFrame.width += fill;
                        }
                        else
                        {
                            //因为每行都增加了fill。所以如果有行内对齐则需要这里调整。
                            MyGravity sbvHorzAlignment = [self myConvertLeftRightGravityToLeadingTrailing:sbvsc.alignment & MyGravity_Vert_Mask];
                            if (sbvHorzAlignment == MyGravity_None)
                                sbvHorzAlignment = horzAlignment;
                            
                            if (sbvHorzAlignment == MyGravity_Horz_Center)
                                sbvmyFrame.leading += fill/2.0;
                            else if (sbvHorzAlignment == MyGravity_Horz_Trailing)
                                sbvmyFrame.leading += fill;
                            else;
                        }
                    }
                    else
                    {
                        sbvmyFrame.width += fill;
                    }
                    sbvmyFrame.leading += fill * lineidx;
                    
                    sbvmyFrame.leading += addXPos;
                    
                    sbvmyFrame.leading += between * lineidx;
                    
                    if (horzGravity == MyGravity_Horz_Around)
                        sbvmyFrame.leading += (between / 2.0);
                }
            }
        }
    }
    
    if (lsc.heightSizeInner.dimeWrapVal)
    {
        selfSize.height = maxHeight + paddingBottom;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_myCGFloatLess(selfSize.height, totalPages * CGRectGetHeight(self.superview.bounds)))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }
    }
    
    return selfSize;
    
}

@end

//
//  MyLinearLayout.m
//  MyLayout
//
//  Created by oybq on 15/2/12.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyLinearLayout.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>

@implementation UIView(MyLinearLayoutExt)

-(CGFloat)weight
{
    return self.myCurrentSizeClass.weight;
}

-(void)setWeight:(CGFloat)weight
{
    if (self.myCurrentSizeClass.weight != weight)
    {
        self.myCurrentSizeClass.weight = weight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}




@end


@implementation MyLinearLayout


-(id)initWithOrientation:(MyLayoutViewOrientation)orientation
{
    self = [super init];
    if (self)
    {
        if (orientation == MyLayoutViewOrientation_Vert)
            self.myCurrentSizeClass.wrapContentHeight = YES;
        else
            self.myCurrentSizeClass.wrapContentWidth = YES;
        self.myCurrentSizeClass.orientation = orientation;
        
    }
    
    return self;
}

+(id)linearLayoutWithOrientation:(MyLayoutViewOrientation)orientation
{
    return [[[self class] alloc] initWithOrientation:orientation];
}

-(void)setOrientation:(MyLayoutViewOrientation)orientation
{
    if (self.myCurrentSizeClass.orientation != orientation)
    {
        self.myCurrentSizeClass.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(MyLayoutViewOrientation)orientation
{
    return self.myCurrentSizeClass.orientation;
}



-(void)setGravity:(MyMarginGravity)gravity
{
    
    MyLinearLayout *lsc = self.myCurrentSizeClass;
    if (lsc.gravity != gravity)
    {
        lsc.gravity = gravity;
        [self setNeedsLayout];
    }
}

-(MyMarginGravity)gravity
{
    return self.myCurrentSizeClass.gravity;
}



-(void)setSubviewMargin:(CGFloat)subviewMargin
{
    MyLinearLayout *lsc = self.myCurrentSizeClass;
    
    if (lsc.subviewMargin != subviewMargin)
    {
        lsc.subviewMargin = subviewMargin;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewMargin
{
    return self.myCurrentSizeClass.subviewMargin;
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


-(void)averageSubviews:(BOOL)centered
{
    [self averageSubviews:centered withMargin:CGFLOAT_MAX];
}

-(void)averageSubviews:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    [self averageSubviews:centered withMargin:CGFLOAT_MAX inSizeClass:sizeClass];
}


-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin
{
    [self averageSubviews:centered withMargin:margin inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
    [self setNeedsLayout];
}

-(void)averageSubviews:(BOOL)centered withMargin:(CGFloat)margin inSizeClass:(MySizeClass)sizeClass
{
    self.myFrame.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        [self averageSubviewsForVert:centered withMargin:margin];
    }
    else
    {
        [self averageSubviewsForHorz:centered withMargin:margin];
    }
    
    self.myFrame.sizeClass = self.myDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = sbv.myDefaultSizeClass;
}



-(void)averageMargin:(BOOL)centered
{
    [self averageMargin:centered inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
    [self setNeedsLayout];
    
}

-(void)averageMargin:(BOOL)centered inSizeClass:(MySizeClass)sizeClass
{
    self.myFrame.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        [self averageMarginForVert:centered];
    }
    else
    {
        [self averageMarginForHorz:centered];
    }
    
    self.myFrame.sizeClass = self.myDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.myFrame.sizeClass = sbv.myDefaultSizeClass;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


#pragma mark -- Private Method


- (CGSize)AdjustSelfWidth:(NSArray *)sbs selfSize:(CGSize)selfSize
{
    
    CGFloat maxSubviewWidth = 0;
    
    //计算出最宽的子视图所占用的宽度
    if (self.wrapContentWidth)
    {
        for (UIView *sbv in sbs)
        {
            if (!sbv.widthDime.isMatchParent && (sbv.leftPos.posVal == nil || sbv.rightPos.posVal == nil))
            {
                
                CGFloat vWidth =  sbv.myFrame.width;
                if (sbv.widthDime.dimeNumVal != nil)
                    vWidth = sbv.widthDime.measure;
                
                vWidth = [self validMeasure:sbv.widthDime sbv:sbv calcSize:vWidth sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
                
                //左边 + 中间偏移+ 宽度 + 右边
                maxSubviewWidth = [self calcSelfMeasure:maxSubviewWidth
                                         subviewMeasure:vWidth
                                                headPos:sbv.leftPos
                                              centerPos:sbv.centerXPos
                                                tailPos:sbv.rightPos];
                
                
            }
        }
        
        selfSize.width = maxSubviewWidth + self.leftPadding + self.rightPadding;
    }
    
    return selfSize;
}

-(CGSize)layoutSubviewsForVert:(CGSize)selfSize sbs:(NSArray*)sbs
{
    
    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat floatingHeight = 0; //浮动的高度。
    CGFloat totalWeight = 0;    //剩余部分的总比重
    selfSize = [self AdjustSelfWidth:sbs selfSize:selfSize];   //调整自身的宽度
    
    NSMutableArray *fixedSizeSbs = [NSMutableArray new];
    CGFloat fixedSizeHeight = 0;
     for (UIView *sbv in sbs)
    {
        
        CGRect rect = sbv.myFrame.frame;
        
        CGFloat tm = sbv.topPos.posNumVal.doubleValue;
        CGFloat bm = sbv.bottomPos.posNumVal.doubleValue;
        BOOL isFlexedHeight = sbv.isFlexedHeight && sbv.weight == 0;
        
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        if (sbv.heightDime.isMatchParent && !self.wrapContentHeight)
             rect.size.height = (selfSize.height - self.topPadding - self.bottomPadding)*sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        
        //调整子视图的宽度，如果子视图为matchParent的话
        if (sbv.widthDime.isMatchParent)
            rect.size.width = (selfSize.width - self.leftPadding - self.rightPadding)*sbv.widthDime.mutilVal + sbv.widthDime.addVal;
        
        if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
            rect.size.width = selfSize.width - self.leftPadding - self.rightPadding - sbv.leftPos.margin - sbv.rightPos.margin;
        
        MyMarginGravity mg = MyMarginGravity_Horz_Left;
        if ((self.gravity & MyMarginGravity_Vert_Mask)!= MyMarginGravity_None)
            mg =self.gravity & MyMarginGravity_Vert_Mask;
        else
        {
            if (sbv.centerXPos.posVal != nil)
                mg = MyMarginGravity_Horz_Center;
            else if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
                mg = MyMarginGravity_Horz_Fill;
            else if (sbv.leftPos.posVal != nil)
                mg = MyMarginGravity_Horz_Left;
            else if (sbv.rightPos.posVal != nil)
                mg = MyMarginGravity_Horz_Right;
        }
        
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        [self horzGravity:mg selfSize:selfSize sbv:sbv rect:&rect];
        
        
        if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
        {
            rect.size.height = rect.size.width * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        }
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        //计算固定高度和浮动高度。
        if ([self isRelativeMargin:tm])
        {
            totalWeight += tm;
            
            fixedHeight += sbv.topPos.offsetVal;
        }
        else
        {
            fixedHeight += sbv.topPos.margin;
        }
        
        
        
        if ([self isRelativeMargin:bm])
        {
            totalWeight += bm;
            fixedHeight += sbv.bottomPos.offsetVal;
        }
        else
        {
            fixedHeight += sbv.bottomPos.margin;
        }
        
        
        if (sbv.weight > 0.0)
        {
            totalWeight += sbv.weight;
        }
        else
        {
            fixedHeight += rect.size.height;
            
            //如果最小高度不为自身则可以进行缩小。
            if (sbv.heightDime.lBoundVal.dimeSelfVal == nil)
            {
                fixedSizeHeight += rect.size.height;
                [fixedSizeSbs addObject:sbv];
            }
        }
        
        if (sbv != sbs.lastObject)
            fixedHeight += self.subviewMargin;
        
        sbv.myFrame.frame = rect;
    }
    
    
    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (self.wrapContentHeight && totalWeight != 0)
    {
        CGFloat tempSelfHeight = self.topPadding + self.bottomPadding;
        if (sbs.count > 1)
            tempSelfHeight += (sbs.count - 1) * self.subviewMargin;
        
        selfSize.height = [self validMeasure:self.heightDime sbv:self calcSize:tempSelfHeight sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        
    }

    
    //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    floatingHeight = selfSize.height - fixedHeight - self.topPadding - self.bottomPadding;
    if (/*floatingHeight <= 0 || floatingHeight == -0.0*/ _myCGFloatLessOrEqual(floatingHeight, 0))
    {
        //取出shrinkType中的方式和压缩的类型：
        MySubviewsShrinkType smd = self.shrinkType & 0x0F; //压缩的模式
        if (smd != MySubviewsShrink_None)
        {
            if (fixedSizeSbs.count > 0 && totalWeight != 0 && floatingHeight < 0 && selfSize.height > 0)
            {
                //均分。
                if (smd == MySubviewsShrink_Average)
                {
                    CGFloat averageHeight = floatingHeight / fixedSizeSbs.count;
                
                    for (UIView *fsbv in fixedSizeSbs)
                    {
                            fsbv.myFrame.height += averageHeight;
                    }
                }
                else if (/*fixedSizeHeight != 0*/ _myCGFloatNotEqual(fixedSizeHeight, 0))
                {//按比例分配。
                    for (UIView *fsbv in fixedSizeSbs)
                    {
                        fsbv.myFrame.height += floatingHeight * (fsbv.myFrame.height / fixedSizeHeight);
                    }

                }
            }
        }

        
        floatingHeight = 0;
    }
    
    CGFloat pos = self.topPadding;
    for (UIView *sbv in sbs) {
        
        
        CGFloat topMargin = sbv.topPos.posNumVal.doubleValue;
        CGFloat bottomMargin = sbv.bottomPos.posNumVal.doubleValue;
        CGFloat weight = sbv.weight;
        CGRect rect =  sbv.myFrame.frame;
        
        //分别处理相对顶部边距和绝对顶部边距
        if ([self isRelativeMargin:topMargin])
        {
            topMargin = (topMargin / totalWeight) * floatingHeight;
            if (/*topMargin <= 0 || topMargin == -0.0*/ _myCGFloatLessOrEqual(topMargin, 0))
                topMargin = 0;
            
        }
        pos += [self validMargin:sbv.topPos sbv:sbv calcPos:topMargin + sbv.topPos.offsetVal selfLayoutSize:selfSize];
        
        //分别处理相对高度和绝对高度
        rect.origin.y = pos;
        if (weight > 0)
        {
            CGFloat h = (weight / totalWeight) * floatingHeight;
            if (/*h <= 0 || h == -0.0*/ _myCGFloatLessOrEqual(h, 0))
                h = 0;
            
            rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:h sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        pos += rect.size.height;
        
        //分别处理相对底部边距和绝对底部边距
        if ([self isRelativeMargin:bottomMargin])
        {
            bottomMargin = (bottomMargin / totalWeight) * floatingHeight;
            if (/*bottomMargin <= 0 || bottomMargin == -0.0*/ _myCGFloatLessOrEqual(bottomMargin, 0))
                bottomMargin = 0;
            
        }
        pos += [self validMargin:sbv.bottomPos sbv:sbv calcPos:bottomMargin + sbv.bottomPos.offsetVal selfLayoutSize:selfSize];
        
        if (sbv != sbs.lastObject)
            pos += self.subviewMargin;
        
        sbv.myFrame.frame = rect;
    }
    
    pos += self.bottomPadding;
    
    
    if (self.wrapContentHeight)
    {
        selfSize.height = pos;
    }
    
    return selfSize;
}

-(CGSize)layoutSubviewsForHorz:(CGSize)selfSize sbs:(NSArray*)sbs
{
    
    CGFloat fixedWidth = 0;   //计算固定部分的高度
    CGFloat floatingWidth = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat maxSubviewHeight = 0;
    
    
    //计算出固定的子视图宽度的总和以及宽度比例总和
    
    NSMutableArray *fixedSizeSbs = [NSMutableArray new];
    CGFloat fixedSizeWidth = 0;
    for (UIView *sbv in sbs)
    {
        
        if ([self isRelativeMargin:sbv.leftPos.posNumVal.doubleValue])
        {
            totalWeight += sbv.leftPos.posNumVal.doubleValue;
            fixedWidth += sbv.leftPos.offsetVal;
        }
        else
            fixedWidth += sbv.leftPos.margin;
        
        if ([self isRelativeMargin:sbv.rightPos.posNumVal.doubleValue])
        {
            totalWeight += sbv.rightPos.posNumVal.doubleValue;
            fixedWidth += sbv.rightPos.offsetVal;
        }
        else
            fixedWidth += sbv.rightPos.margin;
        
        if (sbv.weight > 0.0)
        {
            totalWeight += sbv.weight;
        }
        else
        {
            CGFloat vWidth = sbv.myFrame.width;
            if (sbv.widthDime.dimeNumVal != nil)
                vWidth = sbv.widthDime.measure;

            if (sbv.widthDime.isMatchParent && !self.wrapContentWidth)
                  vWidth = (selfSize.width - self.leftPadding - self.rightPadding)*sbv.widthDime.mutilVal + sbv.widthDime.addVal;
            
            vWidth = [self validMeasure:sbv.widthDime sbv:sbv calcSize:vWidth sbvSize:sbv.myFrame.frame.size selfLayoutSize:selfSize];
            sbv.myFrame.width = vWidth;
            fixedWidth += vWidth;
            
            //如果最小宽度不为自身则可以进行缩小。
            if (sbv.widthDime.lBoundVal.dimeSelfVal == nil)
            {
               fixedSizeWidth += vWidth;
               [fixedSizeSbs addObject:sbv];
            }
        }
        
        if (sbv != sbs.lastObject)
            fixedWidth += self.subviewMargin;
    }
    
    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (self.wrapContentWidth && totalWeight != 0)
    {
        CGFloat tempSelfWidth = self.leftPadding + self.rightPadding;
        if (sbs.count > 1)
            tempSelfWidth += (sbs.count - 1) * self.subviewMargin;
        
        selfSize.width = [self validMeasure:self.widthDime sbv:self calcSize:tempSelfWidth sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];

    }
    
    //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
    floatingWidth = selfSize.width - fixedWidth - self.leftPadding - self.rightPadding;
    if (/*floatingWidth <= 0 || floatingWidth == -0.0*/ _myCGFloatLessOrEqual(floatingWidth, 0))
    {
        //取出shrinkType中的方式和压缩的类型：
        MySubviewsShrinkType smd = self.shrinkType & 0x0F; //压缩的模式
        if (smd != MySubviewsShrink_None)
        {
            if (fixedSizeSbs.count > 0 && totalWeight != 0 && floatingWidth < 0 && selfSize.width > 0)
            {
                //均分。
                if (smd == MySubviewsShrink_Average)
                {
                    CGFloat averageWidth = floatingWidth / fixedSizeSbs.count;
                    
                    for (UIView *fsbv in fixedSizeSbs)
                    {
                       fsbv.myFrame.width += averageWidth;
                        
                    }
                }
                else if (/*fixedSizeWidth != 0*/_myCGFloatNotEqual(fixedSizeWidth, 0))
                {//按比例分配。
                    for (UIView *fsbv in fixedSizeSbs)
                    {
                       fsbv.myFrame.width += floatingWidth * (fsbv.myFrame.width / fixedSizeWidth);
                    }
                    
                }
            }
        }
        
        
        floatingWidth = 0;
    }
    
    //调整所有子视图的宽度
    CGFloat pos = self.leftPadding;
    for (UIView *sbv in sbs) {
        
        CGFloat leftMargin = sbv.leftPos.posNumVal.doubleValue;
        CGFloat rightMargin = sbv.rightPos.posNumVal.doubleValue;
        CGFloat weight = sbv.weight;
        BOOL isFlexedHeight = sbv.isFlexedHeight && !sbv.heightDime.isMatchParent;
        CGRect rect =  sbv.myFrame.frame;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        
        if (sbv.heightDime.isMatchParent)
            rect.size.height= (selfSize.height - self.topPadding - self.bottomPadding)*sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        
        
        //计算出先对左边边距和绝对左边边距
        if ([self isRelativeMargin:leftMargin])
        {
            leftMargin = (leftMargin / totalWeight) * floatingWidth;
            if (/*leftMargin <= 0 || leftMargin == -0.0*/ _myCGFloatLessOrEqual(leftMargin, 0))
                leftMargin = 0;
            
        }
       pos += [self validMargin:sbv.leftPos sbv:sbv calcPos:leftMargin + sbv.leftPos.offsetVal selfLayoutSize:selfSize];
        
        //计算出相对宽度和绝对宽度
        rect.origin.x = pos;
        if (weight > 0)
        {
            CGFloat w = (weight / totalWeight) * floatingWidth;
            if (/*w <= 0 || w == -0.0*/ _myCGFloatLessOrEqual(w, 0))
                w = 0;
            
            rect.size.width = w;
            
        }
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        pos += rect.size.width;
        
        //计算相对的右边边距和绝对的右边边距
        if ([self isRelativeMargin:rightMargin])
        {
            rightMargin = (rightMargin / totalWeight) * floatingWidth;
            if (/*rightMargin <= 0 || rightMargin == -0.0*/ _myCGFloatLessOrEqual(rightMargin, 0))
                rightMargin = 0;
        }
        pos += [self validMargin:sbv.rightPos sbv:sbv calcPos:rightMargin + sbv.rightPos.offsetVal selfLayoutSize:selfSize];
        
        
        if (sbv != sbs.lastObject)
            pos += self.subviewMargin;
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
        }
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        //计算最高的高度。
        if (self.wrapContentHeight && !sbv.heightDime.isMatchParent && (sbv.topPos.posVal == nil || sbv.bottomPos.posVal == nil))
        {
            maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headPos:sbv.topPos centerPos:sbv.centerYPos tailPos:sbv.bottomPos];
            
        }
        
        sbv.myFrame.frame = rect;
    }
    
    if (self.wrapContentHeight)
    {
        selfSize.height = maxSubviewHeight + self.topPadding + self.bottomPadding;
    }
    
    
    //调整所有子视图的高度
    for (UIView *sbv in sbs)
    {
        
        CGRect rect = sbv.myFrame.frame;
        
        //计算高度
        if (sbv.heightDime.isMatchParent)
        {
            rect.size.height = (selfSize.height - self.topPadding - self.bottomPadding) * sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        }
        
        if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
            rect.size.height = selfSize.height - self.topPadding - self.bottomPadding - sbv.topPos.margin - sbv.bottomPos.margin;

        //优先以容器中的指定为标准
        MyMarginGravity mg = MyMarginGravity_Vert_Top;
        if ((self.gravity & MyMarginGravity_Horz_Mask)!= MyMarginGravity_None)
            mg =self.gravity & MyMarginGravity_Horz_Mask;
        else
        {
            if (sbv.centerYPos.posVal != nil)
                mg = MyMarginGravity_Vert_Center;
            else if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
                mg = MyMarginGravity_Vert_Fill;
            else if (sbv.topPos.posVal != nil)
                mg = MyMarginGravity_Vert_Top;
            else if (sbv.bottomPos.posVal != nil)
                mg = MyMarginGravity_Vert_Bottom;
        }
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        [self vertGravity:mg selfSize:selfSize sbv:sbv rect:&rect];
        
        sbv.myFrame.frame = rect;
    }
    
    pos += self.rightPadding;
    
    if (self.wrapContentWidth)
    {
        selfSize.width = pos;
    }
    
    return selfSize;
}


-(CGSize)layoutSubviewsForVertGravity:(CGSize)selfSize sbs:(NSArray*)sbs
{
    MyMarginGravity mgvert = self.gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity mghorz = self.gravity & MyMarginGravity_Vert_Mask;
    
    CGFloat totalHeight = 0;
    if (sbs.count > 1)
        totalHeight += (sbs.count - 1) * self.subviewMargin;
    
    selfSize = [self AdjustSelfWidth:sbs selfSize:selfSize];
    
    CGFloat floatingHeight = selfSize.height - self.topPadding - self.bottomPadding - totalHeight;
    if (/*floatingHeight <=0*/ _myCGFloatLessOrEqual(floatingHeight, 0))
        floatingHeight = 0;
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    NSMutableSet *noWrapsbsSet = [NSMutableSet new];
    for (UIView *sbv in sbs)
    {
        BOOL canAddToNoWrapSbs = YES;
        CGRect rect =  sbv.myFrame.frame;
        BOOL isFlexedHeight = sbv.isFlexedHeight && sbv.weight == 0;
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        if (sbv.heightDime.isMatchParent && !self.wrapContentHeight)
        {
            rect.size.height = [sbv.heightDime measureWith:selfSize.height - self.topPadding - self.bottomPadding];
            canAddToNoWrapSbs = NO;
        }
        
        //调整子视图的宽度，如果子视图为matchParent的话
        if (sbv.widthDime.isMatchParent)
        {
            rect.size.width = [sbv.widthDime measureWith:selfSize.width - self.leftPadding - self.rightPadding];            
        }
        
        if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
            rect.size.width = selfSize.width - self.leftPadding - self.rightPadding - sbv.leftPos.margin - sbv.rightPos.margin;
        
        //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
        MyMarginGravity sbvmghorz = MyMarginGravity_Horz_Left;
        if ( mghorz != MyMarginGravity_None)
            sbvmghorz = mghorz;
        else
        {
            if (sbv.centerXPos.posVal != nil)
                sbvmghorz = MyMarginGravity_Horz_Center;
            else if (sbv.leftPos.posVal != nil && sbv.rightPos.posVal != nil)
                sbvmghorz = MyMarginGravity_Horz_Fill;
            else if (sbv.leftPos.posVal != nil)
                sbvmghorz = MyMarginGravity_Horz_Left;
            else if (sbv.rightPos.posVal != nil)
                sbvmghorz = MyMarginGravity_Horz_Right;
        }
        
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        [self horzGravity:sbvmghorz selfSize:selfSize sbv:sbv rect:&rect];
        
        
        if (sbv.heightDime.dimeRelaVal == sbv.widthDime)
        {
            rect.size.height = [sbv.heightDime measureWith:rect.size.width];
        }
        
        //如果子视图需要调整高度则调整高度
        if (isFlexedHeight)
        {
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
            canAddToNoWrapSbs = NO;
       }
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
    
        //如果子视图的最小高度就是自身则也不进行扩展。
        if (sbv.heightDime.lBoundVal.dimeSelfVal != nil)
        {
            canAddToNoWrapSbs = NO;
        }

        
        
        totalHeight += [self validMargin:sbv.topPos sbv:sbv calcPos:[sbv.topPos realMarginInSize:floatingHeight] selfLayoutSize:selfSize];
        
        totalHeight += rect.size.height;
        
        totalHeight += [self validMargin:sbv.bottomPos sbv:sbv calcPos:[sbv.bottomPos realMarginInSize:floatingHeight] selfLayoutSize:selfSize];
        
        sbv.myFrame.frame = rect;
        
        //如果子布局视图是wrap属性则不进行扩展。
        if (mgvert == MyMarginGravity_Vert_Fill && [sbv isKindOfClass:[MyBaseLayout class]])
        {
            if (((MyBaseLayout*)sbv).wrapContentHeight)
            {
                canAddToNoWrapSbs = NO;
            }
        }
        
        if (canAddToNoWrapSbs)
            [noWrapsbsSet addObject:sbv];
        
    }
    
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;  //位置偏移
    CGFloat between = 0; //间距扩充
    CGFloat fill = 0;    //尺寸扩充
    if (mgvert == MyMarginGravity_Vert_Top)
    {
        pos = self.topPadding;
    }
    else if (mgvert == MyMarginGravity_Vert_Center)
    {
        pos = (selfSize.height - totalHeight - self.bottomPadding - self.topPadding)/2.0;
        pos += self.topPadding;
    }
    else if (mgvert == MyMarginGravity_Vert_Window_Center)
    {
        if (self.window != nil)
        {
            pos = (CGRectGetHeight(self.window.bounds) - totalHeight)/2.0;
            
            CGPoint pt = CGPointMake(0, pos);
            pos = [self.window convertPoint:pt toView:self].y;
            
            
        }
    }
    else if (mgvert == MyMarginGravity_Vert_Bottom)
    {
        pos = selfSize.height - totalHeight - self.bottomPadding;
    }
    else if (mgvert == MyMarginGravity_Vert_Between)
    {
        pos = self.topPadding;
        
        if (sbs.count > 1)
            between = (selfSize.height - totalHeight - self.topPadding - self.bottomPadding) / (sbs.count - 1);
    }
    else if (mgvert == MyMarginGravity_Vert_Fill)
    {
        pos = self.topPadding;
        if (noWrapsbsSet.count > 0)
             fill = (selfSize.height - totalHeight - self.topPadding - self.bottomPadding) / noWrapsbsSet.count;
    }
    else
    {
        pos = self.topPadding;
    }
    
    
    
    for (UIView *sbv in sbs)
    {
        pos += [self validMargin:sbv.topPos sbv:sbv calcPos:[sbv.topPos realMarginInSize:floatingHeight] selfLayoutSize:selfSize];
        
        sbv.myFrame.topPos = pos;
        
        //加上扩充的宽度。
        if (fill != 0 && [noWrapsbsSet containsObject:sbv])
            sbv.myFrame.height += fill;
        
        pos +=  sbv.myFrame.height;
    
        pos += [self validMargin:sbv.bottomPos sbv:sbv calcPos:[sbv.bottomPos realMarginInSize:floatingHeight] selfLayoutSize:selfSize];
        
        if (sbv != sbs.lastObject)
            pos += self.subviewMargin;
        
        pos += between;  //只有mgvert为between才加这个间距拉伸。
    }
    
    return selfSize;
    
}

-(CGSize)layoutSubviewsForHorzGravity:(CGSize)selfSize sbs:(NSArray*)sbs
{
    
    MyMarginGravity mgvert = self.gravity & MyMarginGravity_Horz_Mask;
    MyMarginGravity mghorz = self.gravity & MyMarginGravity_Vert_Mask;
    
    CGFloat totalWidth = 0;
    if (sbs.count > 1)
        totalWidth += (sbs.count - 1) * self.subviewMargin;
    
    
    CGFloat floatingWidth = 0;
    
    CGFloat maxSubviewHeight = 0;
    
    floatingWidth = selfSize.width - self.leftPadding - self.rightPadding - totalWidth;
    if (/*floatingWidth <= 0*/ _myCGFloatLessOrEqual(floatingWidth, 0))
        floatingWidth = 0;
    
    //计算出固定的高度
    NSMutableSet *noWrapsbsSet = [NSMutableSet new];
    for (UIView *sbv in sbs)
    {
        BOOL canAddToNoWrapSbs = YES;

        CGRect rect = sbv.myFrame.frame;
        BOOL isFlexedHeight = sbv.isFlexedHeight && !sbv.heightDime.isMatchParent;
        
        
        if (sbv.widthDime.dimeNumVal != nil)
            rect.size.width = sbv.widthDime.measure;
        
        if (sbv.heightDime.dimeNumVal != nil)
            rect.size.height = sbv.heightDime.measure;
        
        if (sbv.widthDime.isMatchParent && !self.wrapContentWidth)
        {
            rect.size.width= [sbv.widthDime measureWith:selfSize.width - self.leftPadding - self.rightPadding];
            canAddToNoWrapSbs = NO;
        }
        
        if (sbv.heightDime.isMatchParent)
            rect.size.height= [sbv.heightDime measureWith:selfSize.height - self.topPadding - self.bottomPadding];
        
        rect.size.width = [self validMeasure:sbv.widthDime sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果最小宽度不能被缩小则不加入。
        if (sbv.widthDime.lBoundVal.dimeSelfVal != nil)
        {
            canAddToNoWrapSbs = NO;
        }

        
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
        {
            rect.size.height = [self heightFromFlexedHeightView:sbv inWidth:rect.size.width];
        }
        
        rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算以子视图为大小的情况
        if (self.wrapContentHeight && !sbv.heightDime.isMatchParent && (sbv.topPos.posVal == nil || sbv.bottomPos.posVal == nil))
        {
            maxSubviewHeight = [self calcSelfMeasure:maxSubviewHeight subviewMeasure:rect.size.height headPos:sbv.topPos centerPos:sbv.centerYPos tailPos:sbv.bottomPos];
        }
        
        
        totalWidth += [self validMargin:sbv.leftPos sbv:sbv calcPos:[sbv.leftPos realMarginInSize:floatingWidth] selfLayoutSize:selfSize];
        
        totalWidth += rect.size.width;
    
        totalWidth += [self validMargin:sbv.rightPos sbv:sbv calcPos:[sbv.rightPos realMarginInSize:floatingWidth] selfLayoutSize:selfSize];
        
        
        sbv.myFrame.frame = rect;
        
        //如果子视图是包裹属性则也不加入。
        if (mghorz == MyMarginGravity_Horz_Fill && [sbv isKindOfClass:[MyBaseLayout class]])
        {
            if (((MyBaseLayout*)sbv).wrapContentWidth)
            {
                canAddToNoWrapSbs = NO;
            }
        }
        
        if (canAddToNoWrapSbs)
            [noWrapsbsSet addObject:sbv];

    }
    
    
    //调整自己的高度。
    if (self.wrapContentHeight)
    {
        selfSize.height = maxSubviewHeight + self.topPadding + self.bottomPadding;
    }
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    CGFloat between = 0;
    CGFloat fill = 0;

    if (mghorz == MyMarginGravity_Horz_Left)
    {
        pos = self.leftPadding;
    }
    else if (mghorz == MyMarginGravity_Horz_Center)
    {
        pos = (selfSize.width - totalWidth - self.leftPadding - self.rightPadding)/2.0;
        pos += self.leftPadding;
    }
    else if (mghorz == MyMarginGravity_Horz_Window_Center)
    {
        if (self.window != nil)
        {
            pos = (CGRectGetWidth(self.window.bounds) - totalWidth)/2.0;
            
            CGPoint pt = CGPointMake(pos, 0);
            pos = [self.window convertPoint:pt toView:self].x;
        }
    }
    else if (mghorz == MyMarginGravity_Horz_Right)
    {
        pos = selfSize.width - totalWidth - self.rightPadding;
    }
    else if (mghorz == MyMarginGravity_Horz_Between)
    {
        pos = self.leftPadding;
        
        if (sbs.count > 1)
            between = (selfSize.width - totalWidth - self.leftPadding - self.rightPadding) / (sbs.count - 1);
    }
    else if (mghorz == MyMarginGravity_Horz_Fill)
    {
        pos = self.leftPadding;
        if (noWrapsbsSet.count > 0)
            fill = (selfSize.width - totalWidth - self.leftPadding - self.rightPadding) / noWrapsbsSet.count;
    }
    else
    {
        pos = self.leftPadding;
    }

    
    
    
    for (UIView *sbv in sbs)
    {
        
        pos += [self validMargin:sbv.leftPos sbv:sbv calcPos:[sbv.leftPos realMarginInSize:floatingWidth] selfLayoutSize:selfSize];
        
        
        CGRect rect = sbv.myFrame.frame;
        rect.origin.x = pos;
        
        //计算高度
        if (sbv.heightDime.isMatchParent)
        {
            rect.size.height = (selfSize.height - self.topPadding - self.bottomPadding)*sbv.heightDime.mutilVal + sbv.heightDime.addVal;
        }
        
        if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
            rect.size.height = selfSize.height - self.topPadding - self.bottomPadding - sbv.topPos.margin - sbv.bottomPos.margin;
        
        MyMarginGravity sbvmgvert = MyMarginGravity_Vert_Top;
        if (mgvert != MyMarginGravity_None)
            sbvmgvert = mgvert;
        else
        {
            if (sbv.centerYPos.posVal != nil)
                sbvmgvert = MyMarginGravity_Vert_Center;
            else if (sbv.topPos.posVal != nil && sbv.bottomPos.posVal != nil)
                sbvmgvert = MyMarginGravity_Vert_Fill;
            else if (sbv.topPos.posVal != nil)
                sbvmgvert = MyMarginGravity_Vert_Top;
            else if (sbv.bottomPos.posVal != nil)
                sbvmgvert = MyMarginGravity_Vert_Bottom;
        }
        
         rect.size.height = [self validMeasure:sbv.heightDime sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        [self vertGravity:sbvmgvert selfSize:selfSize sbv:sbv rect:&rect];
        
        if (fill != 0 &&  [noWrapsbsSet containsObject:sbv])
            rect.size.width += fill;

        sbv.myFrame.frame = rect;
        
        pos += rect.size.width;
        
        pos += [self validMargin:sbv.rightPos sbv:sbv calcPos:[sbv.rightPos realMarginInSize:floatingWidth] selfLayoutSize:selfSize];
        
        
        if (sbv != sbs.lastObject)
            pos += self.subviewMargin;
        
        pos += between;  //只有mghorz为between才加这个间距拉伸。

    }
    
    return selfSize;
}


-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass];
    
    NSArray *sbs = [self getLayoutSubviews];
    
    if (self.orientation == MyLayoutViewOrientation_Vert)
    {
        
        //如果是垂直的布局，但是子视图设置了左右的边距或者设置了宽度则wrapContentWidth应该设置为NO
        for (UIView *sbv in sbs)
        {
            
            if (!isEstimate)
            {
                sbv.myFrame.frame = sbv.bounds;
                [self calcSizeOfWrapContentSubview:sbv selfLayoutSize:selfSize];
                
            }
            
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (sbvl.wrapContentWidth)
                {
                    //只要同时设置了左右边距或者设置了宽度或者设置了子视图宽度填充则应该把wrapContentWidth置为NO
                    if ((sbvl.leftPos.posVal != nil && sbvl.rightPos.posVal != nil) ||
                        sbvl.widthDime.dimeVal != nil ||
                        (self.gravity & MyMarginGravity_Vert_Mask) == MyMarginGravity_Horz_Fill)
                    {
                        [sbvl setWrapContentWidthNoLayout:NO];
                    }
                }
                
                if (sbvl.wrapContentHeight)
                {
                    if (sbvl.heightDime.dimeVal != nil || sbvl.weight != 0)
                    {
                        [sbvl setWrapContentHeightNoLayout:NO];
                    }
                }
                
                if (pHasSubLayout != nil && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                    *pHasSubLayout = YES;
                
                
                if (isEstimate && (sbvl.wrapContentHeight || sbvl.wrapContentWidth ))
                {
                    [sbvl estimateLayoutRect:sbvl.myFrame.frame.size inSizeClass:sizeClass];
                    sbvl.myFrame.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                }
            }
            
        }
        
        if ((self.gravity & MyMarginGravity_Horz_Mask) != MyMarginGravity_None)
        {
            selfSize = [self layoutSubviewsForVertGravity:selfSize sbs:sbs];
        }
        else
        {
            selfSize = [self layoutSubviewsForVert:selfSize sbs:sbs];
        }
        
        //绘制智能线。
        if (!isEstimate && self.IntelligentBorderLine != nil)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderLine)
                    {
                        sbvl.topBorderLine = nil;
                        sbvl.bottomBorderLine = nil;
                        
                        //取前一个视图和后一个视图。
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
                            if ([prevSiblingView isKindOfClass:[MyBaseLayout class]] && self.subviewMargin == 0)
                            {
                                MyBaseLayout *prevSiblingLayout = (MyBaseLayout*)prevSiblingView;
                                if (prevSiblingLayout.notUseIntelligentBorderLine)
                                    ok = NO;
                            }
                            
                            if (ok)
                                sbvl.topBorderLine = self.IntelligentBorderLine;
                        }
                        
                        if (nextSiblingView != nil && (![nextSiblingView isKindOfClass:[MyBaseLayout class]] || self.subviewMargin != 0))
                        {
                            sbvl.bottomBorderLine = self.IntelligentBorderLine;
                        }
                    }
                }
            
            }
        }
        
    }
    else
    {
        for (UIView *sbv in sbs)
        {
            
            if (!isEstimate)
            {
                sbv.myFrame.frame = sbv.bounds;
                [self calcSizeOfWrapContentSubview:sbv selfLayoutSize:selfSize];

            }
            
            if ([sbv isKindOfClass:[MyBaseLayout class]])
            {
               
                MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                if (sbvl.wrapContentHeight)
                {
                    //只要同时设置了上下边距或者设置了高度或者设置了比重或者父视图的填充属性则应该把wrapContentHeight置为NO
                    if ((sbvl.topPos.posVal != nil && sbvl.bottomPos.posVal != nil) ||
                        sbvl.heightDime.dimeVal != nil ||
                        (self.gravity & MyMarginGravity_Horz_Mask) == MyMarginGravity_Vert_Fill)
                    {
                        [sbvl setWrapContentHeightNoLayout:NO];
                    }
                }
                
                if (sbvl.wrapContentWidth)
                {
                    if (sbvl.widthDime.dimeVal != nil || sbvl.weight != 0)
                    {
                        [sbvl setWrapContentWidthNoLayout:NO];
                    }
                }
                
                if (pHasSubLayout != nil && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                    *pHasSubLayout = YES;
                
                if (isEstimate && (sbvl.wrapContentHeight || sbvl.wrapContentWidth))
                {
                    [sbvl estimateLayoutRect:sbvl.myFrame.frame.size inSizeClass:sizeClass];
                    sbvl.myFrame.sizeClass = [sbvl myBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    
                }
            }
            
        }
        
        
        if ((self.gravity & MyMarginGravity_Vert_Mask) != MyMarginGravity_None)
            selfSize = [self layoutSubviewsForHorzGravity:selfSize sbs:sbs];
        else
            selfSize = [self layoutSubviewsForHorz:selfSize sbs:sbs];
        
        //绘制智能线。
        if (!isEstimate && self.IntelligentBorderLine != nil)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderLine)
                    {
                        sbvl.leftBorderLine = nil;
                        sbvl.rightBorderLine = nil;
                        
                        //取前一个视图和后一个视图。
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
                            if ([prevSiblingView isKindOfClass:[MyBaseLayout class]] && self.subviewMargin == 0)
                            {
                                MyBaseLayout *prevSiblingLayout = (MyBaseLayout*)prevSiblingView;
                                if (prevSiblingLayout.notUseIntelligentBorderLine)
                                    ok = NO;
                            }
                            
                            if (ok)
                                sbvl.leftBorderLine = self.IntelligentBorderLine;
                        }
                        
                        if (nextSiblingView != nil && (![nextSiblingView isKindOfClass:[MyBaseLayout class]] || self.subviewMargin != 0))
                        {
                            sbvl.rightBorderLine = self.IntelligentBorderLine;
                        }
                    }
                }
                
            }
        }

        
    }
    
    selfSize.height = [self validMeasure:self.heightDime sbv:self calcSize:selfSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    selfSize.width = [self validMeasure:self.widthDime sbv:self calcSize:selfSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    
    return selfSize;
    
}


-(CGFloat)calcSelfMeasure:(CGFloat)selfMeasure subviewMeasure:(CGFloat)subviewMeasure headPos:(MyLayoutPos*)headPos centerPos:(MyLayoutPos*)centerPos tailPos:(MyLayoutPos*)tailPos
{
    CGFloat temp = subviewMeasure;
    CGFloat tempWeight = 0;
    
    CGFloat hm = headPos.posNumVal.doubleValue;
    CGFloat cm = centerPos.posNumVal.doubleValue;
    CGFloat tm = tailPos.posNumVal.doubleValue;
    
    //这里是求父视图的最大尺寸,因此如果使用了相对边距的话，最大最小要参与计算。
    
    if (![self isRelativeMargin:hm])
        temp += hm;
    else
        tempWeight += hm;
    
    temp += headPos.offsetVal;
    
    if (![self isRelativeMargin:cm])
        temp += cm;
    else
        tempWeight += cm;
    
    temp += centerPos.offsetVal;
    
    if (![self isRelativeMargin:tm])
        temp += tm;
    else
        tempWeight += tm;
    
    temp += tailPos.offsetVal;
    
    
    if (/*1 <= tempWeight*/ _myCGFloatLessOrEqual(1, tempWeight))
        temp = 0;
    else
        temp /=(1 - tempWeight);  //在有相对
    
    
   CGFloat headMargin = [self validMargin:headPos sbv:headPos.view calcPos:[headPos realMarginInSize:temp] selfLayoutSize:CGSizeZero];
    
    CGFloat centerMargin = [self validMargin:centerPos sbv:centerPos.view calcPos:[centerPos realMarginInSize:temp] selfLayoutSize:CGSizeZero];
    
    CGFloat tailMargin = [self validMargin:tailPos sbv:tailPos.view calcPos:[tailPos realMarginInSize:temp] selfLayoutSize:CGSizeZero];
    
    temp = subviewMeasure + headMargin + centerMargin + tailMargin;
    if (temp > selfMeasure)
    {
        selfMeasure = temp;
    }
    
    return selfMeasure;
    
}

-(void)averageSubviewsForVert:(BOOL)centered withMargin:(CGFloat)margin
{
    
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    
    CGFloat scale;
    CGFloat scale2;
    NSArray *sbs = [self getLayoutSubviews];
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
        
        [sbv.bottomPos __equalTo:@0];
        [sbv.topPos __equalTo:@(scale2)];
        sbv.weight = scale;
        
        if (sbv == sbs.firstObject && !centered)
            [sbv.topPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbv.bottomPos __equalTo:@(scale2)];
    }
    
}

-(void)averageSubviewsForHorz:(BOOL)centered withMargin:(CGFloat)margin
{
    
    
    NSArray *sbs = [self getLayoutSubviews];
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat scale;
    CGFloat scale2;
    
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
        [sbv.leftPos __equalTo:@(scale2)];
        sbv.weight = scale;
        
        if (sbv == sbs.firstObject && !centered)
            [sbv.leftPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbv.rightPos __equalTo:@(scale2)];
    }
    
}


-(void)averageMarginForVert:(BOOL)centered
{
    
    
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    NSArray *sbs = [self getLayoutSubviews];
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (UIView *sbv in sbs)
    {
        
        [sbv.topPos __equalTo:@(scale)];
        
        if (sbv == sbs.firstObject && !centered)
            [sbv.topPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbv.bottomPos __equalTo:@(scale)];
    }
    
    
}

-(void)averageMarginForHorz:(BOOL)centered
{
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    NSArray *sbs = [self getLayoutSubviews];
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (UIView *sbv in sbs)
    {
        [sbv.leftPos __equalTo:@(scale)];
        
        if (sbv == sbs.firstObject && !centered)
            [sbv.leftPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbv.rightPos __equalTo:@(scale)];
    }
}

-(id)createSizeClassInstance
{
    return [MyLinearLayoutViewSizeClass new];
}




@end

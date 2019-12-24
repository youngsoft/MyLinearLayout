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

#pragma mark -- Override Methods

-(CGSize)calcLayoutSize:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray *)sbs
{
    CGSize selfSize = [super calcLayoutSize:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    MyFrameLayoutViewSizeClass *lsc = (MyFrameLayoutViewSizeClass*)self.myCurrentSizeClass;
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    
    MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
    MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
    
    CGSize maxWrapSize = CGSizeMake(paddingLeading + paddingTrailing, paddingTop + paddingBottom);
    CGSize *pMaxWrapSize = &maxWrapSize;
    if (!lsc.heightSizeInner.dimeWrapVal && !lsc.widthSizeInner.dimeWrapVal)
        pMaxWrapSize = NULL;
    
    for (UIView *sbv in sbs)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        [self myLayout:lsc adjustSizeSettingOfSubview:sbvsc isEstimate:isEstimate sbvmyFrame:sbvmyFrame selfSize:selfSize vertGravity:vertGravity horzGravity:horzGravity sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
        
        //计算自己的位置和高宽
        [self myLayout:lsc calcRectOfSubview:sbvsc sbvmyFrame:sbvmyFrame vertGravity:vertGravity horzGravity:horzGravity inSelfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:pMaxWrapSize];
    }
    
    if (lsc.widthSizeInner.dimeWrapVal)
         selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:maxWrapSize.width sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    if (lsc.heightSizeInner.dimeWrapVal)
        selfSize.height = [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:maxWrapSize.height sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    
    //如果布局视图具有包裹属性这里要调整那些依赖父视图宽度和高度的子视图的位置和尺寸。
    if ((lsc.widthSizeInner.dimeWrapVal && horzGravity != MyGravity_Horz_Fill) || (lsc.heightSizeInner.dimeWrapVal && vertGravity != MyGravity_Vert_Fill))
    {
        for (UIView *sbv in sbs)
        {
            MyFrame *sbvmyFrame = sbv.myFrame;
            MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
           
            
            //只有子视图的尺寸或者位置依赖父视图的情况下才需要重新计算位置和尺寸。
            if ((sbvsc.trailingPosInner.posVal != nil) ||
                (sbvsc.bottomPosInner.posVal != nil) ||
                (sbvsc.centerXPosInner.posVal != nil) ||
                (sbvsc.centerYPosInner.posVal != nil) ||
                (sbvsc.widthSizeInner.dimeRelaVal.view == self) ||
                (sbvsc.heightSizeInner.dimeRelaVal.view == self) ||
                sbvsc.widthSizeInner.dimeFillVal ||
                sbvsc.heightSizeInner.dimeFillVal)
            {
                [self myLayout:lsc calcRectOfSubview:sbvsc sbvmyFrame:sbvmyFrame vertGravity:vertGravity horzGravity:horzGravity inSelfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:NULL];
            }
        }
    }
    
    return [self myLayout:lsc adjustSelfSize:selfSize withSubviews:sbs];
}

-(id)createSizeClassInstance
{
    return [MyFrameLayoutViewSizeClass new];
}

@end

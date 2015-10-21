//
//  MyFrameLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyFrameLayout.h"
#import "MyLayoutInner.h"
#import <objc/runtime.h>


@implementation UIView(MyFrameLayoutExt)

const char * const ASSOCIATEDOBJECT_KEY_MARGINGRAVITY = "associatedobject_key_margingravity";

-(MarignGravity)marginGravity
{
    NSNumber *num = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MARGINGRAVITY);
    if (num == nil)
        return MGRAVITY_VERT_TOP | MGRAVITY_HORZ_LEFT;
    return num.unsignedCharValue;
}


-(void)setMarginGravity:(MarignGravity)marginGravity
{
    MarignGravity oldVal = [self marginGravity];
    if (oldVal != marginGravity)
    {
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_MARGINGRAVITY, [NSNumber numberWithUnsignedChar:marginGravity], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

@end

@implementation MyFrameLayout

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)calcSubView:(UIView*)subView pRect:(CGRect*)pRect inSize:(CGSize)selfSize
{
    
    MarignGravity gravity = subView.marginGravity;
    MarignGravity vert = gravity & MGRAVITY_HORZ_MASK;
    MarignGravity horz = gravity & MGRAVITY_VERT_MASK;
    
    //优先用设定的宽度尺寸。
    if (subView.widthDime.dimeNumVal != nil)
        pRect->size.width = subView.widthDime.measure;
    
    if (subView.heightDime.dimeNumVal != nil)
        pRect->size.height = subView.heightDime.measure;
    
    
    [self horzGravity:horz selfWidth:selfSize.width leftMargin:subView.leftPos.margin centerMargin:subView.centerXPos.margin rightMargin:subView.rightPos.margin rect:pRect];
    
    if (subView.isFlexedHeight)
    {
        CGSize sz = [subView sizeThatFits:CGSizeMake(pRect->size.width, 0)];
        pRect->size.height = sz.height;
    }
    
    [self vertGravity:vert selfHeight:selfSize.height topMargin:subView.topPos.margin centerMargin:subView.centerYPos.margin bottomMargin:subView.bottomPos.margin rect:pRect];
    
}

-(CGRect)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate
{
    
    CGRect selfRect;
    
    if (isEstimate)
        selfRect = self.absPos.frame;
    else
        selfRect = [super estimateLayoutRect:size];
    
    
    CGSize selfSize = selfRect.size;
    
    NSArray *sbs = self.subviews;
    for (UIView *v in sbs)
    {
        CGRect rect;
    
        if (!isEstimate)
        {
            rect  = v.frame;
        }
        
        if ([v isKindOfClass:[MyLayoutBase class]])
        {
            if (isEstimate)
            {
                MyLayoutBase *vl = (MyLayoutBase*)v;
                rect = [vl estimateLayoutRect:vl.absPos.frame.size];
            }
        }


        
        //宽度等于另外视图的高度
        if (v.widthDime.dimeRelaVal != nil && v.widthDime.dimeRelaVal.dime == MGRAVITY_VERT_FILL)
        {
            CGRect otherRect = v.widthDime.dimeRelaVal.view.frame;
            [self calcSubView:v.widthDime.dimeRelaVal.view pRect:&otherRect inSize:selfSize];
            rect.size.width = [v.widthDime validMeasure:otherRect.size.height];
        }
        
        //高度等于另外视图的宽度
        if (v.heightDime.dimeRelaVal != nil && v.heightDime.dimeRelaVal.dime == MGRAVITY_HORZ_FILL)
        {
            CGRect otherRect = v.heightDime.dimeRelaVal.view.frame;
            [self calcSubView:v.heightDime.dimeRelaVal.view pRect:&otherRect inSize:selfSize];
            rect.size.height = [v.heightDime validMeasure:otherRect.size.width];
        }
        
        //计算自己的位置和高宽
        [self calcSubView:v pRect:&rect inSize:selfSize];
        v.absPos.frame = rect;
        
    }
    
    return selfRect;

}


-(CGRect)estimateLayoutRect:(CGSize)size
{
    self.absPos.frame = [self calcLayoutRect:size isEstimate:NO];
    return [self calcLayoutRect:CGSizeZero isEstimate:YES];
}


-(CGRect)doLayoutSubviews
{
    return [self calcLayoutRect:CGSizeZero isEstimate:NO];
}

@end

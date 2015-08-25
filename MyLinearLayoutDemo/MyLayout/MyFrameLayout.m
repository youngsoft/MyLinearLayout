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




-(void)doLayoutSubviews
{
    [super doLayoutSubviews];
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    //有限布局填充，再布局
    NSArray *sbs = self.subviews;
    for (UIView *v in sbs)
    {
        CGRect rect = v.frame;
        
        MarignGravity gravity = v.marginGravity;
        MarignGravity vert = gravity & 0xF0;
        MarignGravity horz = gravity & 0x0F;
        
        //优先用设定的宽度尺寸。
        if (v.widthDime.dimeNumVal != nil)
            rect.size.width = v.widthDime.measure;
        
        if (v.heightDime.dimeNumVal != nil)
            rect.size.height = v.heightDime.measure;
        
        [self horzGravity:horz selfWidth:selfWidth leftMargin:v.leftPos.margin centerMargin:v.centerXPos.margin rightMargin:v.rightPos.margin rect:&rect];
        
        if (v.isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, rect.size.height)];
            rect.size.height = sz.height;
        }
        
        [self vertGravity:vert selfHeight:selfHeight topMargin:v.topPos.margin centerMargin:v.centerYPos.margin bottomMargin:v.bottomPos.margin rect:&rect];
        
        
        v.frame = rect;
        
    }

}

@end

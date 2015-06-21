//
//  MyFrameLayout.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyFrameLayout.h"



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
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    //有限布局填充，再布局
    NSArray *sbs = self.subviews;
    for (UIView *v in sbs)
    {
        CGRect rect = v.frame;
        MarignGravity gravity = v.marginGravity;
        CGFloat topMargin = v.topMargin;
        CGFloat leftMargin = v.leftMargin;
        CGFloat rightMargin = v.rightMargin;
        CGFloat bottomMargin = v.bottomMargin;
        
        //分别计算出左右部分和中间不分的值。
        MarignGravity vert = gravity & 0xF0;
        MarignGravity horz = gravity & 0x0F;
        
        [self horzGravity:horz selfWidth:selfWidth leftMargin:leftMargin rightMargin:rightMargin rect:&rect];
        
        if (v.isFlexedHeight)
        {
            CGSize sz = [v sizeThatFits:CGSizeMake(rect.size.width, rect.size.height)];
            rect.size.height = sz.height;
        }
        
        [self vertGravity:vert selfHeight:selfHeight topMargin:topMargin bottomMargin:bottomMargin rect:&rect];
        
        
        
        v.frame = rect;
        
    }

}

@end

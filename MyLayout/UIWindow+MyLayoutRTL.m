//
//  UIWindow+MyLayoutRTL.m
//  MyLayoutDemo
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import "UIWindow+MyLayoutRTL.h"
#import "MyLayout.h"

@implementation UIWindow (MyLayoutRTL)
-(void)updateAllMyLayout:(BOOL)isRTL
{
    [MyBaseLayout setIsRTL:isRTL];
    [self setAllSubviewsNeedLayout:self];
}


-(void)setAllSubviewsNeedLayout:(UIView *)v
{
    NSArray *sbs = v.subviews;
    for (UIView *sv in sbs)
    {
        if ([sv isKindOfClass:[MyBaseLayout class]])
        {
            [sv setNeedsLayout];

        }
     
        [self setAllSubviewsNeedLayout:sv];
    }
    
    
 
    
}



@end

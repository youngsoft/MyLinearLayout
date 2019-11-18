//
//  MyFlexItem.h
//  MyLayout
//
//  Created by oubaiquan on 2019/11/15.
//  Copyright © 2019 YoungSoft. All rights reserved.
//

#import "MyLayoutUI.h"

#pragma mark -- MyUIViewUI

@interface MyUIViewUI : NSObject<MyUIViewUI>

@property(nonatomic, weak, readonly) __kindof UIView *view;

-(instancetype)initWithView:(UIView*)view;

@end

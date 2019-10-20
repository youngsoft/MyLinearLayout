//
//  MyLayoutTestCaseBase.h
//  MyLayout
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MyLayout.h"


#define MyRectAssert(v, rc)  XCTAssert(CGRectEqualToRect(v.frame, rc),  @"the real frame = %@",NSStringFromCGRect(v.frame));


@interface MyLayoutTestCaseBase : XCTestCase

-(void)startClock;

-(void)endClock:(NSString*)text;


@end


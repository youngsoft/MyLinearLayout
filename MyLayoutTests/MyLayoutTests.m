//
//  MyLayoutTests.m
//  MyLayoutTests
//
//  Created by oybq on 15/6/13.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MyLayout.h"

@interface MyLayoutTests : XCTestCase


@end

@implementation MyLayoutTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    //self.testLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    
}

-(CGFloat)roundNumber:(CGFloat)num scale:(CGFloat)scale
{
  //  static CGFloat scale;
   // scale = [UIScreen mainScreen].scale;
   // static CGFloat xxxx;
    CGFloat xxxx = 0.5/scale;
    
    num += xxxx; //0.49999;
    num *= scale;
    return floor(num) / scale;
    
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testExample {
    // This is an example of a functional test case.
    XCTAssertEqual([self roundNumber:0 scale:1], 0);
    XCTAssertEqual([self roundNumber:1 scale:1], 1);
    XCTAssertEqual([self roundNumber:1.6 scale:1], 2);
    XCTAssertEqual([self roundNumber:1.4 scale:1], 1);
    XCTAssertEqual([self roundNumber:1.1 scale:1], 1);
    XCTAssertEqual([self roundNumber:1.8 scale:1], 2);

    XCTAssertEqual([self roundNumber:0 scale:2], 0);
    XCTAssertEqual([self roundNumber:1 scale:2], 1);
    XCTAssertEqual([self roundNumber:1.6 scale:2], 1.5);
    XCTAssertEqual([self roundNumber:1.4 scale:2], 1.5);
    XCTAssertEqual([self roundNumber:1.1 scale:2], 1);
    XCTAssertEqual([self roundNumber:1.8 scale:2], 2);

    XCTAssertEqual([self roundNumber:1 scale:3], 1);
    
    XCTAssertEqualWithAccuracy([self roundNumber:1.6 scale:3], 1.66666666666, 0.00001);
    XCTAssertEqualWithAccuracy([self roundNumber:1.4 scale:3], 1.33333333, 0.00001);
    XCTAssertEqualWithAccuracy([self roundNumber:1.1 scale:3], 1, 0.00001);
    XCTAssertEqualWithAccuracy([self roundNumber:1.8 scale:3], 1.66666, 0.00001);
    XCTAssertEqualWithAccuracy([self roundNumber:1.9 scale:3], 2, 0.00001);

    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

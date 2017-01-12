//
//  MyLayoutTests.m
//  MyLayoutTests
//
//  Created by oybq on 15/6/13.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface MyLayoutTests : XCTestCase


@end

@implementation MyLayoutTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    //self.testLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
       
    
    XCTAssert(YES, @"Pass");
    

    
//    MyLinearLayout *ll = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
//    ll.wrapContentWidth = YES;
//    UILabel *label = [UILabel new];
//    label.mySize = CGSizeMake(100, 100);
//    [ll addSubview:label];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

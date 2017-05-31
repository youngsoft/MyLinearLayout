//
//  MyLinearLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 17/4/25.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"
#import "TLTest3ViewController.h"

@interface MyLinearLayoutTestCase : MyLayoutTestCaseBase

@end

@implementation MyLinearLayoutTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testWrapContentHeight
{
    
    
}

- (void)testTable1 {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    TLTest3ViewController *vc = [TLTest3ViewController new];
    
    [self startClock];
    
    UIView *view = vc.view;
    
    [self endClock:@"vc loadview"];   //>=20ms
    
    [self startClock];
    
    [view layoutIfNeeded];
    
    [self endClock:@"view layout"];
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
    }];
    
   
}

@end

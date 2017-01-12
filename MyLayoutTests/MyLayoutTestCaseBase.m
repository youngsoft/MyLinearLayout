//
//  MyLayoutTestCaseBase.m
//  MyLayout
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//
#import "MyLayoutTestCaseBase.h"


@implementation MyLayoutTestCaseBase
{
    NSInteger _startClock;
}

-(void)startClock
{
    _startClock = clock();
}

-(void)endClock:(NSString*)text
{
    NSInteger endClock = clock();
    
    NSLog(@"%@: end - start = %f ms",text, (endClock - _startClock) * 1000.0 / CLOCKS_PER_SEC);
}


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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

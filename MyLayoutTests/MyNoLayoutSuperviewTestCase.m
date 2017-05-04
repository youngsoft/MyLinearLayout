//
//  MyNoLayoutSuperviewTestCase.m
//  MyLayout
//
//  Created by apple on 17/4/22.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"

@interface MyNoLayoutSuperviewTestCase : MyLayoutTestCaseBase

@end

@implementation MyNoLayoutSuperviewTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample1 {
    
    //测试停靠到非布局父视图上的布局。
    
    [MyBaseLayout setIsRTL:YES];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    
    MyFrameLayout *layout1 = [[MyFrameLayout alloc] initWithFrame:CGRectMake(20, 30, 40, 60)];
    [containerView addSubview:layout1];
    
    MyFrameLayout *layout2 = [[MyFrameLayout alloc] initWithFrame:CGRectMake(30, 40, 50, 50)];
    layout2.mySize = CGSizeMake(80, 70);
    [containerView addSubview:layout2];
    
    
    MyFrameLayout *layout3 = [MyFrameLayout new];
    layout3.myLeading = 30;
    layout3.myTrailing = 40;
    layout3.myTop = 60;
    layout3.myBottom = 20;
    [containerView addSubview:layout3];
    
    MyFrameLayout *layout4 = [MyFrameLayout new];
    layout4.widthSize.equalTo(containerView).multiply(0.5).max(40);
    layout4.heightSize.equalTo(containerView).add(-100);
    layout4.myCenterX = 10;
    layout4.myCenterY = 10;
    [containerView addSubview:layout4];

    
    MyFrameLayout *layout5 = [MyFrameLayout new];
    layout5.myLeft = 100;
    layout5.myTop = 0.5;
    layout5.widthSize.equalTo(containerView).multiply(0.25).max(40);
    layout5.heightSize.equalTo(containerView).multiply(0.25).add(-20);
    [containerView addSubview:layout5];
    
    
    MyFrameLayout *layout6 = [MyFrameLayout new];
    layout6.wrapContentWidth = YES;
    layout6.wrapContentHeight = YES;
    layout6.myCenterX = 20;
    layout6.myBottom = 20;
    [containerView addSubview:layout6];
   
    UIView *v1 = [UIView new];
    v1.myTrailing = 10;
    v1.myCenterY = 10;
    v1.mySize = CGSizeMake(60, 60);
    [layout6 addSubview:v1];
    [layout6 layoutIfNeeded];

    
    if ([MyBaseLayout isRTL])
    {
        XCTAssertTrue(CGRectEqualToRect(layout1.frame, CGRectMake(20, 30, 40, 60)), @"layout1 frame=%@", NSStringFromCGRect(layout1.frame));
        XCTAssertTrue(CGRectEqualToRect(layout2.frame, CGRectMake(30, 40, 80, 70)), @"layout2 frame=%@", NSStringFromCGRect(layout2.frame));
        XCTAssertTrue(CGRectEqualToRect(layout3.frame, CGRectMake(40, 60, 130, 320)),@"layout3 frame=%@", NSStringFromCGRect(layout3.frame));
        XCTAssertTrue(CGRectEqualToRect(layout4.frame, CGRectMake(70, 60, 40, 300)), @"layout4 frame=%@", NSStringFromCGRect(layout4.frame));
        XCTAssertTrue(CGRectEqualToRect(layout5.frame, CGRectMake(100, 200, 40, 80)), @"layout5 frame=%@", NSStringFromCGRect(layout5.frame));
        XCTAssertTrue(CGRectEqualToRect(layout6.frame, CGRectMake(45, 310, 70, 70)), @"layout6 frame=%@", NSStringFromCGRect(layout6.frame));

    }
    else
    {
        
        XCTAssertTrue(CGRectEqualToRect(layout1.frame, CGRectMake(20, 30, 40, 60)), @"layout1 frame=%@", NSStringFromCGRect(layout1.frame));
        XCTAssertTrue(CGRectEqualToRect(layout2.frame, CGRectMake(30, 40, 80, 70)), @"layout2 frame=%@", NSStringFromCGRect(layout2.frame));
        XCTAssertTrue(CGRectEqualToRect(layout3.frame, CGRectMake(30, 60, 130, 320)),@"layout3 frame=%@", NSStringFromCGRect(layout3.frame));
        XCTAssertTrue(CGRectEqualToRect(layout4.frame, CGRectMake(90, 60, 40, 300)), @"layout4 frame=%@", NSStringFromCGRect(layout4.frame));
        XCTAssertTrue(CGRectEqualToRect(layout5.frame, CGRectMake(100, 200, 40, 80)), @"layout5 frame=%@", NSStringFromCGRect(layout5.frame));
        XCTAssertTrue(CGRectEqualToRect(layout6.frame, CGRectMake(85, 310, 70, 70)), @"layout6 frame=%@", NSStringFromCGRect(layout6.frame));

    }
    
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

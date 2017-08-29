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

-(void)testWeight
{//测试均分
    
    MyLinearLayout* rootLayout1 = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Horz];
   // rootLayout1.myMargin = 0;
    rootLayout1.backgroundColor = [UIColor redColor];
    rootLayout1.wrapContentWidth = NO;
    
    for (int i = 0; i < 4; i++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.weight = 1;
        if (i % 2 == 0)
        {
            button.backgroundColor = [UIColor yellowColor];
        }
        else
        {
            button.backgroundColor = [UIColor greenColor];
        }
        [button setTitle:[NSString stringWithFormat:@"%zi",i] forState:UIControlStateNormal];
        button.heightSize.equalTo(rootLayout1.heightSize);
        [rootLayout1 addSubview:button];
    }
    
    [rootLayout1 layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(rootLayout1.subviews[0].frame, CGRectMake(0,0,94,667)), @"the button0.frame = %@",NSStringFromCGRect(rootLayout1.subviews[0].frame));
    XCTAssertTrue(CGRectEqualToRect(rootLayout1.subviews[1].frame, CGRectMake(94,0,93.5,667)), @"the button0.frame = %@",NSStringFromCGRect(rootLayout1.subviews[1].frame));
    XCTAssertTrue(CGRectEqualToRect(rootLayout1.subviews[2].frame, CGRectMake(187.5,0,94,667)), @"the button0.frame = %@",NSStringFromCGRect(rootLayout1.subviews[2].frame));
    XCTAssertTrue(CGRectEqualToRect(rootLayout1.subviews[3].frame, CGRectMake(281.5,0,93.5,667)), @"the button0.frame = %@",NSStringFromCGRect(rootLayout1.subviews[3].frame));

    

}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
    }];
    
   
}

@end

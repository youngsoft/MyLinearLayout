//
//  MyFrameLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 17/4/21.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"

@interface MyFrameLayoutTestCase : MyLayoutTestCaseBase

@end

@implementation MyFrameLayoutTestCase

- (void)setUp {
    [super setUp];
    
 }

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testblurred
{
    MyFrameLayout *frameLayout = [[MyFrameLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    frameLayout.backgroundColor = [UIColor whiteColor];
    frameLayout.myMargin = 0;              //这个表示框架布局的尺寸和self.view保持一致,四周离父视图的边距都是0
    frameLayout.padding = UIEdgeInsetsMake(20, 20, 20, 20);

    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"统计";
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:17];
    label1.myCenterY = 0;
    label1.myLeft = 10;
    label1.wrapContentSize = YES;
    
    [frameLayout addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"统计";
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:17];
    label2.myTop = 200;
    label2.myLeft = 10;
    label2.wrapContentSize = YES;
    [frameLayout addSubview:label2];
    

    [frameLayout layoutIfNeeded];
    
   // XCTAssertTrue(CGRectEqualToRect(label1, <#CGRect rect2#>)([frameLayout estimateLayoutRect:CGSizeZero].size, CGSizeMake(0, 0)), @"frameLayout size is:%@",NSStringFromCGSize([frameLayout estimateLayoutRect:CGSizeZero].size));
    

}

//测试尺寸包裹。
- (void)testWrapContent {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.padding = UIEdgeInsetsMake(20, 10, 5, 6);
    frameLayout.wrapContentSize = YES;
    
    frameLayout.zeroPadding = NO;
    
    
    XCTAssertTrue(CGSizeEqualToSize([frameLayout estimateLayoutRect:CGSizeZero].size, CGSizeMake(0, 0)), @"frameLayout size is:%@",NSStringFromCGSize([frameLayout estimateLayoutRect:CGSizeZero].size));
    
    frameLayout.zeroPadding = YES;
    XCTAssertTrue(CGSizeEqualToSize([frameLayout estimateLayoutRect:CGSizeZero].size, CGSizeMake(16, 25)), @"frameLayout size is:%@",NSStringFromCGSize([frameLayout estimateLayoutRect:CGSizeZero].size));
    
    UIView *v0 = [UIView new];
    v0.myLeft = 10;
    v0.myRight = 12;
    v0.myTop = 5;
    v0.myBottom = 10;
    [frameLayout addSubview:v0];
    
    
    XCTAssertTrue(CGSizeEqualToSize([frameLayout estimateLayoutRect:CGSizeZero].size, CGSizeMake(16+10+12, 25+5+10)), @"frameLayout size is:%@",NSStringFromCGSize([frameLayout estimateLayoutRect:CGSizeZero].size));
    
    
    UIView *v1 = [UIView new];
    v1.myWidth = 100;
    v1.myHeight = 180;
    v1.myTrailing = 10;
    v1.myBottom = 40;
    [frameLayout addSubview:v1];
    
    
    UIView *v2 = [UIView new];
    v2.myWidth = 150;
    v2.myHeight = 160;
    v2.myLeading = 20;
    v2.myBottom = 30;
    [frameLayout addSubview:v2];
    
    UIView *v3 = [UIView new];
    v3.myWidth = 100;
    v3.myHeight = 120;
    v3.myTop = 10;
    [frameLayout addSubview:v3];
    
    [self startClock];
    
    [frameLayout estimateLayoutRect:CGSizeZero];
    
    [self endClock:@"frameLayout1"];

    
    XCTAssertTrue(CGSizeEqualToSize(frameLayout.estimatedRect.size, CGSizeMake(186, 245)), @"frameLayout size is:%@",NSStringFromCGSize(frameLayout.estimatedRect.size));
    
     XCTAssertTrue(CGRectEqualToRect(v0.estimatedRect, CGRectMake(20,25,148, 205)), @"v0 rect is:%@", NSStringFromCGRect(v0.estimatedRect));
    XCTAssertTrue(CGRectEqualToRect(v1.estimatedRect, CGRectMake(70,20,100, 180)), @"v1 rect is:%@", NSStringFromCGRect(v1.estimatedRect));
    XCTAssertTrue(CGRectEqualToRect(v2.estimatedRect, CGRectMake(30,50,150, 160)), @"v2 rect is:%@", NSStringFromCGRect(v2.estimatedRect));
    XCTAssertTrue(CGRectEqualToRect(v3.estimatedRect, CGRectMake(10,30,100, 120)), @"v3 rect is:%@", NSStringFromCGRect(v3.estimatedRect));

}

-(void)testSizeDependent
{
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.mySize = CGSizeMake(200, 200);
    
    UIView *v1 = [UIView new];
    v1.widthSize.equalTo(v1.heightSize);
    v1.heightSize.equalTo(frameLayout.heightSize).multiply(0.5);
    [frameLayout addSubview:v1];
    
    UIView *v2 = [UIView new];
    v2.heightSize.equalTo(v2.widthSize);
    v2.widthSize.equalTo(frameLayout.widthSize).multiply(0.25);
    [frameLayout addSubview:v2];
    
    UIView *v3 = [UIView new];
    v3.widthSize.equalTo(v1.widthSize);
    v3.heightSize.equalTo(v2.heightSize);
    [frameLayout addSubview:v3];

    
    [frameLayout estimateLayoutRect:CGSizeMake(200, 200)];
    
    XCTAssertTrue(CGRectEqualToRect(v1.estimatedRect, CGRectMake(0,0,100, 100)), @"v1 rect is:%@", NSStringFromCGRect(v1.estimatedRect));
    XCTAssertTrue(CGRectEqualToRect(v2.estimatedRect, CGRectMake(0,0,50, 50)), @"v2 rect is:%@", NSStringFromCGRect(v2.estimatedRect));
    XCTAssertTrue(CGRectEqualToRect(v3.estimatedRect, CGRectMake(0,0,100,50)), @"v3 rect is:%@", NSStringFromCGRect(v3.estimatedRect));

}

-(void)testPerformanceExample
{
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
    }];

}

@end

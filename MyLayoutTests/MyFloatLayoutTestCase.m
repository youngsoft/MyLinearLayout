//
//  MyFloatLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 17/4/26.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"
#import "FOLTest2ViewController.h"

@interface MyFloatLayoutTestCase : MyLayoutTestCaseBase

@end

@implementation MyFloatLayoutTestCase

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
    FOLTest2ViewController *vc = [FOLTest2ViewController new];
    
    [self startClock];
    UIView *v1 = vc.view;
    [self endClock:@"load view:"];       //>60ms
    
    [self startClock];
    
    [v1 layoutIfNeeded];
    
    [self endClock:@"layout:"];
    
    
}

-(void)testExample2
{
    MyFloatLayout *dectorInfoFloatLayout  = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    dectorInfoFloatLayout.padding = UIEdgeInsetsMake(10.f, 0.f, 10.f, 0.f);
    dectorInfoFloatLayout.subviewSpace = 10;
    
    
    UILabel *dectorInAttention = [UILabel new];
    dectorInAttention.textColor = [UIColor grayColor];
    dectorInAttention.textAlignment = NSTextAlignmentRight;
    [dectorInfoFloatLayout addSubview:dectorInAttention];
    dectorInAttention.myHeight = 32.0;
    dectorInAttention.myWidth = 100.f;
    dectorInAttention.reverseFloat = YES;
    dectorInAttention.myTop = 10.f;
    dectorInAttention.text =@"关注";
    dectorInAttention.backgroundColor = [UIColor orangeColor];
    
    UIView *dectorImageView = [UIView new];
    dectorImageView.backgroundColor = [UIColor blackColor];
    dectorImageView.myHeight = dectorImageView.myWidth = 120.f;
    [dectorInfoFloatLayout addSubview:dectorImageView];
    
    UILabel *dectorNameLabel = [UILabel new];
    dectorNameLabel.text = @"name";
    dectorNameLabel.backgroundColor = [UIColor redColor];
    dectorNameLabel.myHeight = 16.f;
    dectorNameLabel.weight = 1.f;
    [dectorInfoFloatLayout addSubview:dectorNameLabel];
    
    
    
    UILabel *dectorCategoryLabel = [UILabel new];
    dectorCategoryLabel.backgroundColor = [UIColor blueColor];
    dectorCategoryLabel.myHeight = 16.f;
    dectorCategoryLabel.weight = 1.f;
    [dectorInfoFloatLayout addSubview:dectorCategoryLabel];
    dectorCategoryLabel.text = @"333";
    
    
    
    UILabel *dectorSpecialityLabel = [UILabel new];
    dectorSpecialityLabel.backgroundColor = [UIColor greenColor];
    [dectorInfoFloatLayout addSubview:dectorSpecialityLabel];
    //  dectorSpecialityLabel.myTop = 14.f;
    dectorSpecialityLabel.myHeight = 75.f;
    dectorSpecialityLabel.weight = 1.f;
    dectorSpecialityLabel.text = @"666";
    
    [dectorInfoFloatLayout estimateLayoutRect:CGSizeMake(375, 667)];
    
    XCTAssert(CGRectEqualToRect(dectorSpecialityLabel.estimatedRect, CGRectMake(130, 62, 245, 75)), @"dectorSpecialityLabel' rect:%@", NSStringFromCGRect(dectorSpecialityLabel.estimatedRect));


}

-(void)testExample3
{
    MyFloatLayout *layout = [[MyFloatLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Vert];
    layout.subviewSpace = 5.f;
    layout.padding = UIEdgeInsetsMake(10.f, 0.f, 0.f, 0.f);
    
    UIImageView *mobileImageView = [UIImageView new];
    [layout addSubview:mobileImageView];
    mobileImageView.backgroundColor = [UIColor greenColor];
    mobileImageView.myWidth = 30.f;
    mobileImageView.myHeight = 30.f;
    mobileImageView.myTop = 8.f;
    mobileImageView.myRight = 10.f;
    mobileImageView.reverseFloat = YES;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor blackColor];
    [layout addSubview:nameLabel];
    nameLabel.myHeight = 20.f;
    nameLabel.weight = 1.f;
    nameLabel.myLeft = 10.f;
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.textColor = [UIColor grayColor];
    // addressLabel.font = kSystemFont10;
    addressLabel.backgroundColor = [UIColor blueColor];
    [layout addSubview:addressLabel];
    addressLabel.myHeight = 20.f;
    addressLabel.weight = 1.f;
    addressLabel.myLeft = 10.f;
    
    
    UIView *segmentedControl = [UIView new];
    segmentedControl.backgroundColor = [UIColor redColor];
    [layout addSubview:segmentedControl];
    segmentedControl.clearFloat = YES;
    segmentedControl.weight = 1.f;
    segmentedControl.myHeight = 40.f;

    [layout estimateLayoutRect:CGSizeMake(375, 667)];
    
    XCTAssert(CGRectEqualToRect(segmentedControl.estimatedRect, CGRectMake(0, 60, 375, 40)), @"segmentedControl' rect:%@", NSStringFromCGRect(segmentedControl.estimatedRect));
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.

    }];
}

@end

//
//  MyFloatLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 17/4/26.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"
#import "FOLTest1ViewController.h"
#import "FOLTest2ViewController.h"
#import "FOLTest3ViewController.h"
#import "FOLTest4ViewController.h"
#import "FOLTest5ViewController.h"
#import "FOLTest6ViewController.h"
#import "FOLTest7ViewController.h"

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
    FOLTest1ViewController *vc1 = [FOLTest1ViewController new];
    FOLTest2ViewController *vc2 = [FOLTest2ViewController new];
    FOLTest3ViewController *vc3 = [FOLTest3ViewController new];
    FOLTest4ViewController *vc4 = [FOLTest4ViewController new];
    FOLTest5ViewController *vc5 = [FOLTest5ViewController new];
    FOLTest6ViewController *vc6 = [FOLTest6ViewController new];
    FOLTest7ViewController *vc7 = [FOLTest7ViewController new];

    UIView *v1 = vc1.view;
    UIView *v2=  vc2.view;
    UIView *v3 = vc3.view;
    UIView *v4 = vc4.view;
    UIView *v5 = vc5.view;
    UIView *v6 = vc6.view;
    UIView *v7 = vc7.view;

   
    [v1 layoutIfNeeded];
    [v2 layoutIfNeeded];
    [v3 layoutIfNeeded];
    [v4 layoutIfNeeded];
    [v5 layoutIfNeeded];
    [v6 layoutIfNeeded];
    [v7 layoutIfNeeded];
    
}


-(void)testSubviewSizeDependent
{//测试子视图尺寸依赖
    
    //垂直线性布局
    {
        MyFloatLayout *rootLayout1 = [[MyFloatLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Vert];
        rootLayout1.wrapContentHeight = NO;
        //1. 子视图宽度等于自身高度
        UILabel *label1 = [UILabel new];
        label1.myHeight = 100;
        label1.widthSize.equalTo(label1.heightSize);
        [rootLayout1 addSubview:label1];
        
        
        //2. 子视图高度等于自身宽度
        UILabel *label2 = [UILabel new];
        label2.wrapContentWidth = YES;
        label2.heightSize.equalTo(label2.widthSize);
        label2.text = @"hello World";
        [rootLayout1 addSubview:label2];
        
        //3. 子视图高度等于兄弟视图高度, 子视图宽度等于兄弟视图宽度
        UILabel *label3 = [UILabel new];
        label3.heightSize.equalTo(label1.heightSize);
        label3.widthSize.equalTo(label1.widthSize);
        [rootLayout1 addSubview:label3];
        
        //4. 子视图高度等于兄弟视图宽度, 子视图宽度等于兄弟视图高度
        UILabel *label4 = [UILabel new];
        label4.widthSize.equalTo(label2.heightSize).add(20);
        label4.heightSize.equalTo(label2.widthSize).add(10).multiply(0.5);
        [rootLayout1 addSubview:label4];
        
        //5. 子视图宽度等于父视图宽度，高度等于宽度
        UILabel *label5 = [UILabel new];
        label5.widthSize.equalTo(rootLayout1.widthSize).add(-20);
        label5.heightSize.equalTo(label5.widthSize);
        [rootLayout1 addSubview:label5];
        
        //6. 子视图高度等于父视图高度，宽度等于高度
        UILabel *label6 = [UILabel new];
        label6.heightSize.equalTo(rootLayout1.heightSize).multiply(0.5);
        label6.widthSize.equalTo(label6.heightSize);
        [rootLayout1 addSubview:label6];
        
        [rootLayout1 layoutIfNeeded];
        
        XCTAssertTrue(label1.frame.size.width == label1.frame.size.height, @"label1.frame = %@",NSStringFromCGRect(label1.frame));
        XCTAssertTrue(label2.frame.size.width == label2.frame.size.height, @"label1.frame = %@",NSStringFromCGRect(label2.frame));
        XCTAssertTrue(label3.frame.size.width == label1.frame.size.width &&
                      label3.frame.size.height == label1.frame.size.height, @"label3.frame = %@",NSStringFromCGRect(label3.frame));
        XCTAssertTrue(label4.frame.size.width == (label2.frame.size.height + 20) &&
                      label4.frame.size.height == (label2.frame.size.width * 0.5 + 10), @"label4.frame = %@",NSStringFromCGRect(label4.frame));
        
        XCTAssertTrue(label5.frame.size.width == (rootLayout1.frame.size.width - 20) &&
                      label5.frame.size.height == label5.frame.size.width, @"label5.frame = %@",NSStringFromCGRect(label5.frame));
        
        XCTAssertTrue(label6.frame.size.width == label6.frame.size.height &&
                      label6.frame.size.height == rootLayout1.frame.size.height * 0.5, @"label6.frame = %@",NSStringFromCGRect(label6.frame));
    }
    
    
    //水平线性布局
    {
        MyFloatLayout *rootLayout1 = [[MyFloatLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Horz];
        rootLayout1.wrapContentWidth = NO;
        //1. 子视图宽度等于自身高度
        UILabel *label1 = [UILabel new];
        label1.myHeight = 100;
        label1.widthSize.equalTo(label1.heightSize);
        [rootLayout1 addSubview:label1];
        
        
        //2. 子视图高度等于自身宽度
        UILabel *label2 = [UILabel new];
        label2.wrapContentWidth = YES;
        label2.heightSize.equalTo(label2.widthSize);
        label2.text = @"hello World";
        [rootLayout1 addSubview:label2];
        
        //3. 子视图高度等于兄弟视图高度, 子视图宽度等于兄弟视图宽度
        UILabel *label3 = [UILabel new];
        label3.heightSize.equalTo(label1.heightSize);
        label3.widthSize.equalTo(label1.widthSize);
        [rootLayout1 addSubview:label3];
        
        //4. 子视图高度等于兄弟视图宽度, 子视图宽度等于兄弟视图高度
        UILabel *label4 = [UILabel new];
        label4.widthSize.equalTo(label2.heightSize).add(20);
        label4.heightSize.equalTo(label2.widthSize).add(10).multiply(0.5);
        [rootLayout1 addSubview:label4];
        
        //5. 子视图宽度等于父视图宽度，高度等于宽度
        UILabel *label5 = [UILabel new];
        label5.widthSize.equalTo(rootLayout1.widthSize).add(-20);
        label5.heightSize.equalTo(label5.widthSize);
        [rootLayout1 addSubview:label5];
        
        //6. 子视图高度等于父视图高度，宽度等于高度
        UILabel *label6 = [UILabel new];
        label6.heightSize.equalTo(rootLayout1.heightSize).multiply(0.5);
        label6.widthSize.equalTo(label6.heightSize);
        [rootLayout1 addSubview:label6];
        
        
        [rootLayout1 layoutIfNeeded];
        
        XCTAssertTrue(label1.frame.size.width == label1.frame.size.height, @"label1.frame = %@",NSStringFromCGRect(label1.frame));
        XCTAssertTrue(label2.frame.size.width == label2.frame.size.height, @"label1.frame = %@",NSStringFromCGRect(label2.frame));
        XCTAssertTrue(label3.frame.size.width == label1.frame.size.width &&
                      label3.frame.size.height == label1.frame.size.height, @"label3.frame = %@",NSStringFromCGRect(label3.frame));
        XCTAssertTrue(label4.frame.size.width == (label2.frame.size.height + 20) &&
                      label4.frame.size.height == (label2.frame.size.width * 0.5 + 10), @"label4.frame = %@",NSStringFromCGRect(label4.frame));
        
        XCTAssertTrue(label5.frame.size.width == (rootLayout1.frame.size.width - 20) &&
                      label5.frame.size.height == label5.frame.size.width, @"label5.frame = %@",NSStringFromCGRect(label5.frame));
        
        XCTAssertTrue(label6.frame.size.width == label6.frame.size.height &&
                      label6.frame.size.height == rootLayout1.frame.size.height * 0.5, @"label6.frame = %@",NSStringFromCGRect(label6.frame));
        
    }
    
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
    
    [dectorInfoFloatLayout sizeThatFits:CGSizeMake(375, 667)];
    
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

    [layout sizeThatFits:CGSizeMake(375, 667)];
    
    XCTAssert(CGRectEqualToRect(segmentedControl.estimatedRect, CGRectMake(0, 60, 375, 40)), @"segmentedControl' rect:%@", NSStringFromCGRect(segmentedControl.estimatedRect));
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.

    }];
}

@end

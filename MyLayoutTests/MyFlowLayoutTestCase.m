//
//  MyFlowLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 17/4/26.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"

@interface MyFlowLayoutTestCase : MyLayoutTestCaseBase

@end

@implementation MyFlowLayoutTestCase

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
    
    for (int i = 1; i <= 9; i++)
    {
        Class cls = NSClassFromString([NSString stringWithFormat:@"FLLTest%dViewController", i]);
        UIViewController *vc = [[cls alloc] init];
        UIView *v = vc.view;
        [v setNeedsLayout];
        [v layoutIfNeeded];
    }
  
}

-(void)testWrapContentSize
{
    //测试内容约束布局的宽度自适应和高度自适应的设置。
    MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap,MyLayoutSize.wrap);
    rootLayout.padding = UIEdgeInsetsMake(10, 20, 30, 40);
    rootLayout.subviewHSpace = 5;
    rootLayout.subviewVSpace = 5;
    
    for (int i = 0; i < 3; i++)
    {
        UIView *v = [UIView new];
        v.mySize = CGSizeMake(100, 100 * (i+1));
        [rootLayout addSubview:v];
    }
    
    [rootLayout layoutIfNeeded];
    
    
    XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,20+40+3*100 + 2*5 ,10+30+300)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
    
    
    rootLayout.orientation = MyOrientation_Horz;
    
    [rootLayout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,20+40+100, 10+30+100+200+300+2*5)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
    
}


-(void)testSubviewSizeDependent
{//测试子视图尺寸依赖
    
    //垂直线性布局
    {
        MyFlowLayout *rootLayout1 = [[MyFlowLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Vert arrangedCount:4];
        rootLayout1.heightSize.equalTo(nil);
        //1. 子视图宽度等于自身高度
        UILabel *label1 = [UILabel new];
        label1.myHeight = 100;
        label1.widthSize.equalTo(label1.heightSize);
        [rootLayout1 addSubview:label1];
        
        
        //2. 子视图高度等于自身宽度
        UILabel *label2 = [UILabel new];
        label2.widthSize.equalTo(@(MyLayoutSize.wrap));
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
        MyFlowLayout *rootLayout1 = [[MyFlowLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Horz arrangedCount:4];
        //1. 子视图宽度等于自身高度
        UILabel *label1 = [UILabel new];
        label1.myHeight = 100;
        label1.widthSize.equalTo(label1.heightSize);
        [rootLayout1 addSubview:label1];
        
        
        //2. 子视图高度等于自身宽度
        UILabel *label2 = [UILabel new];
        label2.widthSize.equalTo(@(MyLayoutSize.wrap));
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
    
    //垂直线性布局
    {
        MyFlowLayout *rootLayout1 = [[MyFlowLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Vert arrangedCount:0];
        //1. 子视图宽度等于自身高度
        UILabel *label1 = [UILabel new];
        label1.myHeight = 100;
        label1.widthSize.equalTo(label1.heightSize);
        [rootLayout1 addSubview:label1];
        
        
        //2. 子视图高度等于自身宽度
        UILabel *label2 = [UILabel new];
        label2.widthSize.equalTo(@(MyLayoutSize.wrap));
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
        MyFlowLayout *rootLayout1 = [[MyFlowLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Horz arrangedCount:0];
        //1. 子视图宽度等于自身高度
        UILabel *label1 = [UILabel new];
        label1.myHeight = 100;
        label1.widthSize.equalTo(label1.heightSize);
        [rootLayout1 addSubview:label1];
        
        
        //2. 子视图高度等于自身宽度
        UILabel *label2 = [UILabel new];
        label2.widthSize.equalTo(@(MyLayoutSize.wrap));
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


@end

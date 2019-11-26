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

-(void)testWrapContentSize2
{
    //测试一个布局宽度固定，高度包裹，然后子视图的高度依赖宽度，或者子视图高度自适应，然后又有压缩的场景，看是否会导致行高不对，或者整个行高不对。
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
        rootLayout.frame = CGRectMake(0, 0, 110, 0);
        rootLayout.padding = UIEdgeInsetsMake(10, 10, 5, 5);
        rootLayout.mySize = CGSizeMake(110, MyLayoutSize.wrap);
        rootLayout.subviewSpace = 6;
        rootLayout.gravity = MyGravity_Horz_Fill;
        
        UIView *v1 = [UIView new];
        v1.mySize = CGSizeMake(10, 20);
        v1.myMargin = 5;
        [rootLayout addSubview:v1];
        
        UIView *v2 = [UIView new];
        v2.myWidth = 30;
        v2.heightSize.equalTo(v2.widthSize);
        v2.myMargin = 6;
        [rootLayout addSubview:v2];
        
        
        UIView *v3 = [UIView new];
        v3.mySize = CGSizeMake(10, 50);
        v3.myMargin = 2;
        [rootLayout addSubview:v3];
        
        UIView *v4 = [UIView new];
        v4.myWidth = 20;
        v4.heightSize.equalTo(v4.widthSize).multiply(0.5).add(10);
        v4.myMargin = 3;
        [rootLayout addSubview:v4];
        
        UILabel *v5 = [UILabel new];
        v5.text = @"测试测试测试";
        v5.frame = CGRectMake(0, 0, 20, 0);
        v5.heightSize.equalTo(@(MyLayoutSize.wrap));
        [rootLayout addSubview:v5];
        
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,110,197)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(15,15,12.5,20)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(44.5,16,32.5,32.5)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(90.5,12,12.5,50)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(13,73,20,20)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(42,70,20,122)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        rootLayout.isFlex = YES;
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,110,136)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(15,15,12.5,20)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(44.5,16,32.5,32.5)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(90.5,12,12.5,50)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(13,73,41.5,31)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(63.5,70,41.5,61)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
    }
    
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:0];
        rootLayout.frame = CGRectMake(0, 0, 0, 110);
        rootLayout.padding = UIEdgeInsetsMake(10, 10, 5, 5);
        rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap, 110);
        rootLayout.subviewSpace = 6;
        rootLayout.gravity = MyGravity_Vert_Fill;
        
        UIView *v1 = [UIView new];
        v1.mySize = CGSizeMake(20, 10);
        v1.myMargin = 5;
        [rootLayout addSubview:v1];
        
        UIView *v2 = [UIView new];
        v2.myHeight = 30;
        v2.widthSize.equalTo(v2.heightSize);
        v2.myMargin = 6;
        [rootLayout addSubview:v2];
        
        
        UIView *v3 = [UIView new];
        v3.mySize = CGSizeMake(50, 10);
        v3.myMargin = 2;
        [rootLayout addSubview:v3];
        
        UIView *v4 = [UIView new];
        v4.myHeight = 20;
        v4.widthSize.equalTo(v4.heightSize).multiply(0.5).add(10);
        v4.myMargin = 3;
        [rootLayout addSubview:v4];
        
        UILabel *v5 = [UILabel new];
        v5.text = @"测试测试测试";
        v5.frame = CGRectMake(0, 0, 0, 20);
        v5.widthSize.equalTo(@(MyLayoutSize.wrap));
        [rootLayout addSubview:v5];
        
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,179,110)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(15,15,20,12.5)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(16,44.5,32.5,32.5)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(12,90.5,50,12.5)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(73,13,20,20)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(70,42,104,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        rootLayout.isFlex = YES;
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,179,110)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(15,15,20,12.5)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(16,44.5,32.5,32.5)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(12,90.5,50,12.5)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(73,13,31,41.5)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(70,63.5,104,41.5)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));

    }
}

-(void)testWrapContentSize3
{
    {
        MyFlowLayout *layout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:4];
        layout.frame = CGRectMake(0, 0, 0, 0);
        layout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        layout.subviewHSpace = 5;
        layout.subviewVSpace = 5;
        
        for (int i = 0; i < 1; i++)
        {
            UIView *sbv = [UIView new];
            sbv.mySize = CGSizeMake(50, 50);
            [layout addSubview:sbv];
        }
        
        [layout layoutIfNeeded];
        MyRectAssert(layout, CGRectMake(0, 0, 50, 50));
        
        for (int i = 0; i < 1; i++)
        {
            UIView *sbv = [UIView new];
            sbv.mySize = CGSizeMake(50, 50);
            [layout addSubview:sbv];

        }
        [layout layoutIfNeeded];
        MyRectAssert(layout, CGRectMake(0, 0, 105, 50));

        for (int i =0; i < 4; i++)
        {
            UIView *sbv = [UIView new];
            sbv.mySize = CGSizeMake(50, 50);
            [layout addSubview:sbv];
        }
        
        [layout layoutIfNeeded];
        MyRectAssert(layout, CGRectMake(0, 0, 215, 105));
    }
    
    {
        MyFlowLayout *layout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:4];
        layout.frame = CGRectMake(0, 0, 0, 0);
        layout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        layout.subviewHSpace = 5;
        layout.subviewVSpace = 5;
        
        for (int i = 0; i < 1; i++)
        {
            UIView *sbv = [UIView new];
            sbv.mySize = CGSizeMake(50, 50);
            [layout addSubview:sbv];

        }
        
        [layout layoutIfNeeded];
        MyRectAssert(layout, CGRectMake(0, 0, 50, 50));
        
        for (int i = 0; i < 1; i++)
        {
            UIView *sbv = [UIView new];
            sbv.mySize = CGSizeMake(50, 50);
            [layout addSubview:sbv];

        }
        [layout layoutIfNeeded];
        MyRectAssert(layout, CGRectMake(0, 0, 50, 105));
        
        for (int i =0; i < 4; i++)
        {
            UIView *sbv = [UIView new];
            sbv.mySize = CGSizeMake(50, 50);
            [layout addSubview:sbv];

        }
        
        [layout layoutIfNeeded];
        MyRectAssert(layout, CGRectMake(0, 0, 105, 215));
    }
}


-(void)testWeight
{
    //测试内容约束布局中weight刚好在边界的情况。
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
        rootLayout.frame = CGRectMake(0, 0, 152, 100);
        rootLayout.padding = UIEdgeInsetsMake(10, 10, 5, 5);
        rootLayout.subviewSpace = 6;
        rootLayout.myHeight = MyLayoutSize.wrap;
        
        UIView *v1 = [UIView new];
        v1.myHorzMargin = 4;
        v1.mySize = CGSizeMake(20, 20);
        [rootLayout addSubview:v1];   //  10+4+20+4+6 = 44
        
        UIView *v2 = [UIView new];
        v2.myHorzMargin = 5;
        v2.mySize = CGSizeMake(30, 30);
        [rootLayout addSubview:v2];   //10+4+20+4+6+5+30+5+6 = 90
        
        UIView *v3 = [UIView new];
        v3.myHorzMargin = 6;
        v3.mySize = CGSizeMake(40, 40);
        [rootLayout addSubview:v3];     //10+4+20+4+6+5+30+5+6+ 6+40+6+ 6 + 5 = 153
        
        UIView *v4 = [UIView new];
        v4.myHeight = 50;
        v4.weight = 0.6;
        [rootLayout addSubview:v4];
        
        UIView *v5 = [UIView new];
        v5.mySize = CGSizeMake(20, 20);
        [rootLayout addSubview:v5];
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(10,56,82,50)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(98,56,20,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,152,111)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        rootLayout.frame = CGRectMake(0, 0, 153, 0);
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(10,56,83,50)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(99,56,20,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,153,111)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        
        rootLayout.frame = CGRectMake(0, 0, 154, 100);
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(148,10,0.5,50)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(10,66,20,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,154,91)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        rootLayout.frame = CGRectMake(0, 0, 152, 100);
        v4.weight = 1;
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(10,56,137,50)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(10,112,20,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,152,137)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        rootLayout.isFlex = YES;
        v4.weight = 1;
        v5.weight = 1;
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(10,56,55.5,50)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(71.5,56,75.5,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,152,111)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
    }
    
    //测试内容约束布局中weight刚好在边界的情况。
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:0];
        rootLayout.frame = CGRectMake(0, 0, 100, 152);
        rootLayout.padding = UIEdgeInsetsMake(10, 10, 5, 5);
        rootLayout.subviewSpace = 6;
        rootLayout.myWidth = MyLayoutSize.wrap;
        
        UIView *v1 = [UIView new];
        v1.myVertMargin = 4;
        v1.mySize = CGSizeMake(20, 20);
        [rootLayout addSubview:v1];   //  10+4+20+4+6 = 44
        
        UIView *v2 = [UIView new];
        v2.myVertMargin = 5;
        v2.mySize = CGSizeMake(30, 30);
        [rootLayout addSubview:v2];   //10+4+20+4+6+5+30+5+6 = 90
        
        UIView *v3 = [UIView new];
        v3.myVertMargin = 6;
        v3.mySize = CGSizeMake(40, 40);
        [rootLayout addSubview:v3];     //10+4+20+4+6+5+30+5+6+ 6+40+6+ 6 + 5 = 153
        
        UIView *v4 = [UIView new];
        v4.myWidth = 50;
        v4.weight = 0.6;
        [rootLayout addSubview:v4];
        
        UIView *v5 = [UIView new];
        v5.mySize = CGSizeMake(20, 20);
        [rootLayout addSubview:v5];
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(56,10,50,82)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(56,98,20,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,111,152)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        rootLayout.frame = CGRectMake(0, 0, 0, 153);
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(56,10,50,83)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(56,99,20,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,111,153)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        
        rootLayout.frame = CGRectMake(0, 0, 100, 154);
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(10,148,50,0.5)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(66,10,20,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,91,154)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        rootLayout.frame = CGRectMake(0, 0, 100, 152);
        v4.weight = 1;
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(56,10,50,137)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(112,10,20,20)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,137,152)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        rootLayout.isFlex = YES;
        v4.weight = 1;
        v5.weight = 1;
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(56,10,50,55.5)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(56,71.5,20,75.5)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,111,152)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
    }

}

-(void)testWrapAndWeightAndShrink
{
    //测试数量约束布局的宽度和高度是自适应，并且有最大，最小值约束下的用例。
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:1];
        rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        rootLayout.padding = UIEdgeInsetsMake(10, 5, 5, 10);
        rootLayout.subviewHSpace = 20;
        rootLayout.subviewVSpace = 20;
        
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 15, 15));
        
        {
            UIView *v1 = [UIView new];
            v1.mySize = CGSizeMake(30, 30);
            [rootLayout addSubview:v1];
        }
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 15+30, 15+30));
        
        {
            UIView *v1 = [UIView new];
            v1.mySize = CGSizeMake(30, 30);
            [rootLayout addSubview:v1];
        }
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 15+30, 15+30+20+30));
        
        rootLayout.arrangedCount = 2;
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 10+30+20+30+5, 10+30+5));
        
        {
            UIView *v1 = [UIView new];
            v1.mySize = CGSizeMake(30, 30);
            [rootLayout addSubview:v1];
        }
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 10+30+20+30+5, 10+30+20+30+5));
        
        {
            UIView *v1 = [UIView new];
            v1.mySize = CGSizeMake(40, 40);
            [rootLayout addSubview:v1];
        }
        rootLayout.subviews.firstObject.weight = 1;
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 10+30+20+40+5, 10+30+20+40+5));
        MyRectAssert(rootLayout.subviews.firstObject, CGRectMake(5,10, 40, 30));
        
        rootLayout.widthSize.max(70);
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 70, 10+30+20+40+5));
        MyRectAssert(rootLayout.subviews.firstObject, CGRectMake(5,10, 30, 30));
        MyRectAssert(rootLayout.subviews.lastObject, CGRectMake(5+30+20, 10+30+20, 40, 40));
        
        rootLayout.subviews.lastObject.widthSize.shrink = 1;
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout.subviews.lastObject, CGRectMake(5+30+20, 10+30+20, 5, 40));
    }
    
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:1];
        rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        rootLayout.padding = UIEdgeInsetsMake(5, 10, 10, 5);
        rootLayout.subviewHSpace = 20;
        rootLayout.subviewVSpace = 20;
        
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 15, 15));
        
        {
            UIView *v1 = [UIView new];
            v1.mySize = CGSizeMake(30, 30);
            [rootLayout addSubview:v1];
        }
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 15+30, 15+30));
        
        {
            UIView *v1 = [UIView new];
            v1.mySize = CGSizeMake(30, 30);
            [rootLayout addSubview:v1];
        }
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 15+30+20+30, 15+30));
        
        rootLayout.arrangedCount = 2;
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0,10+30+5,10+30+20+30+5));
        
        {
            UIView *v1 = [UIView new];
            v1.mySize = CGSizeMake(30, 30);
            [rootLayout addSubview:v1];
        }
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 10+30+20+30+5, 10+30+20+30+5));
        
        {
            UIView *v1 = [UIView new];
            v1.mySize = CGSizeMake(40, 40);
            [rootLayout addSubview:v1];
        }
        rootLayout.subviews.firstObject.weight = 1;
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 10+30+20+40+5,10+30+20+40+5));
        MyRectAssert(rootLayout.subviews.firstObject, CGRectMake(10,5,30,40));
        
        rootLayout.heightSize.max(70);
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 10+30+20+40+5, 70));
        MyRectAssert(rootLayout.subviews.firstObject, CGRectMake(10,5,30, 30));
        MyRectAssert(rootLayout.subviews.lastObject, CGRectMake(10+30+20,5+30+20,40, 40));
        
        rootLayout.subviews.lastObject.heightSize.shrink = 1;
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout.subviews.lastObject, CGRectMake(10+30+20,5+30+20,40,5));
    }
}

-(void)testWrapAndMinSize
{
    //测试自适应并且是最小高宽约束的情况。
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:2];
        rootLayout.widthSize.equalTo(@(MyLayoutSize.wrap)).min(50);
        rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0,0,50,0));
        
        UIView *v = [UIView new];
        v.mySize = CGSizeMake(20, 20);
        [rootLayout addSubview:v];
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0,0,50,20));
        
        rootLayout.subviews.firstObject.weight = 1;
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0,0,50,20));
        MyRectAssert(rootLayout.subviews.firstObject, CGRectMake(0,0,50,20));
        
        UIView *v2 = [UIView new];
        v2.mySize = CGSizeMake(40, 40);
        [rootLayout addSubview:v2];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0,0,20+40,40));
        MyRectAssert(rootLayout.subviews.firstObject, CGRectMake(0,0,20,20));
    }
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:2];
        rootLayout.widthSize.equalTo(@(MyLayoutSize.wrap));
        rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap)).min(50);
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0,0,0,50));
        
        UIView *v = [UIView new];
        v.mySize = CGSizeMake(20, 20);
        [rootLayout addSubview:v];
        
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0,0,20,50));
        
        rootLayout.subviews.firstObject.weight = 1;
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0,0,20,50));
        MyRectAssert(rootLayout.subviews.firstObject, CGRectMake(0,0,20,50));
        
        UIView *v2 = [UIView new];
        v2.mySize = CGSizeMake(40, 40);
        [rootLayout addSubview:v2];
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0,0,40,20+40));
        MyRectAssert(rootLayout.subviews.firstObject, CGRectMake(0,0,20,20));
    }
    
}

-(void)testRightAndBottomGravity
{
    //测试
    {
        MyFlowLayout *layout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:4];
        layout.frame = CGRectMake(0, 0, 200, 200);
        layout.gravity = MyGravity_Horz_Right;
        layout.subviewHSpace = 5;
        layout.subviewVSpace = 5;
        
        UIView *v1 = [UIView new];
        v1.mySize = CGSizeMake(50, 50);
        [layout addSubview:v1];
        
        [layout layoutIfNeeded];
        
        MyRectAssert(v1, CGRectMake(150, 0, 50, 50));
        
        UIView *v2 = [UIView new];
        v2.mySize = CGSizeMake(50, 50);
        [layout addSubview:v2];
        [layout layoutIfNeeded];

        MyRectAssert(v2, CGRectMake(150, 0, 50, 50));

        
        UIView *v3 = [UIView new];
        v3.mySize = CGSizeMake(50, 50);
        [layout addSubview:v3];
        [layout layoutIfNeeded];
        
        UIView *v4 = [UIView new];
        v4.mySize = CGSizeMake(50, 50);
        [layout addSubview:v4];
        [layout layoutIfNeeded];
        
        UIView *v5 = [UIView new];
        v5.mySize = CGSizeMake(50, 50);
        [layout addSubview:v5];
        [layout layoutIfNeeded];
        
        UIView *v6 = [UIView new];
        v6.mySize = CGSizeMake(50, 50);
        [layout addSubview:v6];
        [layout layoutIfNeeded];
        
        MyRectAssert(v6, CGRectMake(150, 55, 50, 50));

    }
    {
        MyFlowLayout *layout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:4];
        layout.frame = CGRectMake(0, 0, 200, 200);
        layout.gravity = MyGravity_Vert_Bottom;
        layout.subviewHSpace = 5;
        layout.subviewVSpace = 5;
        
        UIView *v1 = [UIView new];
        v1.mySize = CGSizeMake(50, 50);
        [layout addSubview:v1];
        
        [layout layoutIfNeeded];
        
        MyRectAssert(v1, CGRectMake(0, 150, 50, 50));
        
        UIView *v2 = [UIView new];
        v2.mySize = CGSizeMake(50, 50);
        [layout addSubview:v2];
        [layout layoutIfNeeded];
        
        MyRectAssert(v2, CGRectMake(0, 150, 50, 50));
        
        
        UIView *v3 = [UIView new];
        v3.mySize = CGSizeMake(50, 50);
        [layout addSubview:v3];
        [layout layoutIfNeeded];
        
        UIView *v4 = [UIView new];
        v4.mySize = CGSizeMake(50, 50);
        [layout addSubview:v4];
        [layout layoutIfNeeded];
        
        UIView *v5 = [UIView new];
        v5.mySize = CGSizeMake(50, 50);
        [layout addSubview:v5];
        [layout layoutIfNeeded];
        
        UIView *v6 = [UIView new];
        v6.mySize = CGSizeMake(50, 50);
        [layout addSubview:v6];
        [layout layoutIfNeeded];
        
        MyRectAssert(v6, CGRectMake(55, 150, 50, 50));
    }
    
    //测试
    {
        MyFlowLayout *layout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
        layout.frame = CGRectMake(0, 0, 200, 200);
        layout.gravity = MyGravity_Horz_Right;
        layout.subviewHSpace = 5;
        layout.subviewVSpace = 5;
        
        UIView *v1 = [UIView new];
        v1.mySize = CGSizeMake(50, 50);
        [layout addSubview:v1];
        
        [layout layoutIfNeeded];
        
        MyRectAssert(v1, CGRectMake(150, 0, 50, 50));
        
        UIView *v2 = [UIView new];
        v2.mySize = CGSizeMake(50, 50);
        [layout addSubview:v2];
        [layout layoutIfNeeded];
        
        MyRectAssert(v2, CGRectMake(150, 0, 50, 50));
        
        
        UIView *v3 = [UIView new];
        v3.mySize = CGSizeMake(50, 50);
        [layout addSubview:v3];
        [layout layoutIfNeeded];
        
        UIView *v4 = [UIView new];
        v4.mySize = CGSizeMake(50, 50);
        [layout addSubview:v4];
        [layout layoutIfNeeded];
        
        UIView *v5 = [UIView new];
        v5.mySize = CGSizeMake(50, 50);
        [layout addSubview:v5];
        [layout layoutIfNeeded];
        
        UIView *v6 = [UIView new];
        v6.mySize = CGSizeMake(50, 50);
        [layout addSubview:v6];
        [layout layoutIfNeeded];
        
        MyRectAssert(v6, CGRectMake(150, 55, 50, 50));
        
    }
    {
        MyFlowLayout *layout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:0];
        layout.frame = CGRectMake(0, 0, 200, 200);
        layout.gravity = MyGravity_Vert_Bottom;
        layout.subviewHSpace = 5;
        layout.subviewVSpace = 5;
        
        UIView *v1 = [UIView new];
        v1.mySize = CGSizeMake(50, 50);
        [layout addSubview:v1];
        
        [layout layoutIfNeeded];
        
        MyRectAssert(v1, CGRectMake(0, 150, 50, 50));
        
        UIView *v2 = [UIView new];
        v2.mySize = CGSizeMake(50, 50);
        [layout addSubview:v2];
        [layout layoutIfNeeded];
        
        MyRectAssert(v2, CGRectMake(0, 150, 50, 50));
        
        
        UIView *v3 = [UIView new];
        v3.mySize = CGSizeMake(50, 50);
        [layout addSubview:v3];
        [layout layoutIfNeeded];
        
        UIView *v4 = [UIView new];
        v4.mySize = CGSizeMake(50, 50);
        [layout addSubview:v4];
        [layout layoutIfNeeded];
        
        UIView *v5 = [UIView new];
        v5.mySize = CGSizeMake(50, 50);
        [layout addSubview:v5];
        [layout layoutIfNeeded];
        
        UIView *v6 = [UIView new];
        v6.mySize = CGSizeMake(50, 50);
        [layout addSubview:v6];
        [layout layoutIfNeeded];
        
        MyRectAssert(v6, CGRectMake(55, 150, 50, 50));
    }
}

-(void)testFillAndStretch
{
    //测试填充和拉伸。垂直数量约束流式布局的行内拉升和填充。以及整体
    
    //垂直流式布局主要是高度的填充和拉伸。
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:4];
        rootLayout.arrangedGravity = MyGravity_Vert_Fill;
        rootLayout.frame = CGRectMake(0, 0, 200, 200);
        
        //一个子视图高度有约束， 一个高度为自适应， 一个没有设置任何高度约束。一个标杆高度视图。
        UIView *v1 = [UIView new];
        v1.mySize = CGSizeMake(40, 40);
        [rootLayout addSubview:v1];
        
        UILabel *v2 = [UILabel new];
        v2.text = @"hello";
        v2.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        [rootLayout addSubview:v2];
        
        UIView *v3 = [UIView new];
        v3.frame = CGRectMake(0, 0, 30, 30);
        [rootLayout addSubview:v3];
        
        UIView *v4 = [UIView new];
        v4.mySize = CGSizeMake(50, 50);
        [rootLayout addSubview:v4];
        
        UIView *v5 = [UIView new];
        v5.mySize = CGSizeMake(60, 60);
        [rootLayout addSubview:v5];
        
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 200, 200));
        
        MyRectAssert(v1, CGRectMake(0, 0, 40, 50));
        MyRectAssert(v2, CGRectMake(40, 0, 36.5, 50));
        MyRectAssert(v3, CGRectMake(76.5, 0, 30, 50));
        MyRectAssert(v4, CGRectMake(106.5, 0, 50, 50));
        MyRectAssert(v5, CGRectMake(0, 50, 60, 60));
        
        rootLayout.arrangedGravity = MyGravity_Vert_Stretch;
        [rootLayout layoutIfNeeded];
        MyRectAssert(v1, CGRectMake(0, 0, 40, 40));
        MyRectAssert(v2, CGRectMake(40, 0, 36.5, 50));
        MyRectAssert(v3, CGRectMake(76.5, 0, 30, 50));
        MyRectAssert(v4, CGRectMake(106.5, 0, 50, 50));
        MyRectAssert(v5, CGRectMake(0, 50, 60, 60));
        
        
        rootLayout.gravity = MyGravity_Vert_Fill;
        [rootLayout layoutIfNeeded];
        MyRectAssert(v1, CGRectMake(0, 0, 40, 85));
        MyRectAssert(v2, CGRectMake(40, 0, 36.5, 95));
        MyRectAssert(v3, CGRectMake(76.5, 0, 30, 95));
        MyRectAssert(v4, CGRectMake(106.5, 0, 50, 95));
        MyRectAssert(v5, CGRectMake(0, 95, 60, 105));
        
        
        rootLayout.gravity = MyGravity_Vert_Stretch;
        [rootLayout layoutIfNeeded];
        MyRectAssert(v1, CGRectMake(0, 0, 40, 40));
        MyRectAssert(v2, CGRectMake(40, 0, 36.5, 50));
        MyRectAssert(v3, CGRectMake(76.5, 0, 30, 95));
        MyRectAssert(v4, CGRectMake(106.5, 0, 50, 50));
        MyRectAssert(v5, CGRectMake(0, 95, 60, 60));
    }
    
    //水平流式布局主要是宽度和填充和拉伸
    {
        MyFlowLayout *rootLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Horz arrangedCount:4];
        rootLayout.arrangedGravity = MyGravity_Horz_Fill;
        rootLayout.frame = CGRectMake(0, 0, 200, 200);
        
        //一个子视图高度有约束， 一个高度为自适应， 一个没有设置任何高度约束。一个标杆高度视图。
        UIView *v1 = [UIView new];
        v1.mySize = CGSizeMake(40, 40);
        [rootLayout addSubview:v1];
        
        UILabel *v2 = [UILabel new];
        v2.text = @"hello";
        v2.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        [rootLayout addSubview:v2];
        
        UIView *v3 = [UIView new];
        v3.frame = CGRectMake(0, 0, 30, 30);
        [rootLayout addSubview:v3];
        
        UIView *v4 = [UIView new];
        v4.mySize = CGSizeMake(50, 50);
        [rootLayout addSubview:v4];
        
        UIView *v5 = [UIView new];
        v5.mySize = CGSizeMake(60, 60);
        [rootLayout addSubview:v5];
        
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 200, 200));
        
        MyRectAssert(v1, CGRectMake(0, 0, 50, 40));
        MyRectAssert(v2, CGRectMake(0, 40,50,20.5));
        MyRectAssert(v3, CGRectMake(0,60.5, 50, 30));
        MyRectAssert(v4, CGRectMake(0,90.5, 50, 50));
        MyRectAssert(v5, CGRectMake(50, 0, 60, 60));
        
        rootLayout.arrangedGravity = MyGravity_Horz_Stretch;
        [rootLayout layoutIfNeeded];
        MyRectAssert(v1, CGRectMake(0, 0, 40, 40));
        MyRectAssert(v2, CGRectMake(0, 40, 50,20.5));
        MyRectAssert(v3, CGRectMake(0,60.5, 50, 30));
        MyRectAssert(v4, CGRectMake(0,90.5, 50, 50));
        MyRectAssert(v5, CGRectMake(50, 0, 60, 60));
        
        
        rootLayout.gravity = MyGravity_Horz_Fill;
        [rootLayout layoutIfNeeded];
        MyRectAssert(v1, CGRectMake(0, 0, 85, 40));
        MyRectAssert(v2, CGRectMake(0, 40, 95, 20.5));
        MyRectAssert(v3, CGRectMake(0,60.5, 50+45, 30));
        MyRectAssert(v4, CGRectMake(0,90.5, 50+45, 50));
        MyRectAssert(v5, CGRectMake(50+45, 0, 60+45, 60));
        
        rootLayout.gravity = MyGravity_Horz_Stretch;
        [rootLayout layoutIfNeeded];
        MyRectAssert(v1, CGRectMake(0, 0, 40, 40));
        MyRectAssert(v2, CGRectMake(0, 40, 50, 20.5));
        MyRectAssert(v3, CGRectMake(0,60.5, 50+45, 30));
        MyRectAssert(v4, CGRectMake(0,90.5, 50, 50));
        MyRectAssert(v5, CGRectMake(95, 0, 60, 60));
    }
    
    
}

-(void)testFlex1
{
    //测试内容约束布局下的尺寸自适应，以及最大最小值设置的场景。
    
    {
        MyFlexLayout *flexLayout = MyFlexLayout.new.myFlex
        .align_items(MyFlexGravity_Center)
        .justify_content(MyFlexGravity_Center)
        .margin(0)
        .view;
        
        flexLayout.frame = CGRectMake(0, 0, 300, 300);
        flexLayout.backgroundColor = [UIColor redColor];
        
        
        MyFlexLayout *contentLayout = MyFlexLayout.new.myFlex
        .flex_wrap(MyFlexWrap_Wrap)
        .max_width(100)
        .addTo(flexLayout);
        
        contentLayout.backgroundColor = [UIColor greenColor];
        
        UILabel *lb1 = UILabel.new.myFlex
        .width(30)
        .height(30)
        .addTo(contentLayout);
        
        lb1.backgroundColor = [UIColor blueColor];
        
        UILabel *lb2 = UILabel.new.myFlex
        .width(40)
        .height(40)
        .addTo(contentLayout);
        
        lb2.backgroundColor = [UIColor yellowColor];
        
        UILabel *lb3 = UILabel.new.myFlex
        .width(50)
        .height(50)
        .addTo(contentLayout);
        
        lb3.backgroundColor = [UIColor grayColor];
        
        [flexLayout layoutIfNeeded];
        [contentLayout layoutIfNeeded];
        
        MyRectAssert(contentLayout, CGRectMake((300-100)/2.0, (300-90)/2.0, 100, 90));
        MyRectAssert(lb3, CGRectMake(0, 40, 50, 50));
        
        contentLayout.myFlex.height(30);
        [flexLayout setNeedsLayout];
        [contentLayout setNeedsLayout];
        [contentLayout layoutIfNeeded];
        [flexLayout layoutIfNeeded];
        
        MyRectAssert(contentLayout, CGRectMake((300-100)/2.0, (300-30)/2.0, 100, 30));
        MyRectAssert(lb3, CGRectMake(0, 40, 50, 50));

    }
    
    {
        MyFlexLayout *flexLayout = MyFlexLayout.new.myFlex
        .align_items(MyFlexGravity_Center)
        .justify_content(MyFlexGravity_Center)
        .margin(0)
        .view;
        
        flexLayout.frame = CGRectMake(0, 0, 300, 300);
        flexLayout.backgroundColor = [UIColor redColor];
        
        
        MyFlexLayout *contentLayout = MyFlexLayout.new.myFlex
        .flex_wrap(MyFlexWrap_Wrap)
        .flex_direction(MyFlexDirection_Column)
        .width(MyLayoutSize.wrap)
        .max_height(100)
        .height(MyLayoutSize.wrap)
        .addTo(flexLayout);
        
        contentLayout.backgroundColor = [UIColor greenColor];
        
        UILabel *lb1 = UILabel.new.myFlex
        .width(30)
        .height(30)
        .addTo(contentLayout);
        
        lb1.backgroundColor = [UIColor blueColor];
        
        UILabel *lb2 = UILabel.new.myFlex
        .width(40)
        .height(40)
        .addTo(contentLayout);
        
        lb2.backgroundColor = [UIColor yellowColor];
        
        UILabel *lb3 = UILabel.new.myFlex
        .width(50)
        .height(50)
        .addTo(contentLayout);
        
        lb3.backgroundColor = [UIColor grayColor];
        
        [flexLayout layoutIfNeeded];
        [contentLayout layoutIfNeeded];
        
        MyRectAssert(contentLayout, CGRectMake((300-90)/2.0,(300-100)/2.0,90,100));
        MyRectAssert(lb3, CGRectMake(40, 0, 50, 50));
        
        contentLayout.myFlex.width(30);
        [flexLayout setNeedsLayout];
        [contentLayout setNeedsLayout];
        [contentLayout layoutIfNeeded];
        [flexLayout layoutIfNeeded];
        
        MyRectAssert(contentLayout, CGRectMake((300-30)/2.0, (300-100)/2.0, 30, 100));
        MyRectAssert(lb3, CGRectMake(40, 0, 50, 50));
    }
    
}

@end

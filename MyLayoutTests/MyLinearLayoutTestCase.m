//
//  MyLinearLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 17/4/25.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"
#import "LLTest1ViewController.h"
#import "LLTest2ViewController.h"
#import "LLTest3ViewController.h"
#import "LLTest4ViewController.h"
#import "LLTest5ViewController.h"
#import "LLTest6ViewController.h"
#import "LLTest7ViewController.h"

#import "TLTest1ViewController.h"
#import "TLTest2ViewController.h"
#import "TLTest3ViewController.h"
#import "TLTest4ViewController.h"


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
    
    for (int i = 1; i <=7; i++)
    {
        Class cls = NSClassFromString([NSString stringWithFormat:@"LLTest%dViewController", i]);
        UIViewController *vc = [cls new];
        UIView *v = vc.view;
        [v layoutIfNeeded];
    }
    
    for (int i = 1; i <=3; i++)
    {
        Class cls = NSClassFromString([NSString stringWithFormat:@"TLTest%dViewController", i]);
        UIViewController *vc = [cls new];
        UIView *v = vc.view;
        [v layoutIfNeeded];
    }
    
    for (int i = 1; i <=12; i++)
    {
        Class cls = NSClassFromString([NSString stringWithFormat:@"AllTest%dViewController", i]);
        UIViewController *vc = [cls new];
        UIView *v = vc.view;
        [v layoutIfNeeded];
    }
    
}

-(void)testWrapContentHeight
{
    
    
}


-(void)testSubviewSizeDependent
{//测试子视图尺寸依赖
    
    //垂直线性布局
    {
        MyLinearLayout *rootLayout1 = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Vert];
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
        MyLinearLayout *rootLayout1 = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Horz];
        rootLayout1.widthSize.equalTo(nil);
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

-(void)testSubviewSizeDependent2
{
    //测试隐藏、比重、尺寸依赖。
    
    MyLinearLayout *layout2 = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 200) orientation:MyOrientation_Horz];
    layout2.widthSize.equalTo(nil);
    
    
    UIButton *zoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    zoneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLab.numberOfLines = 1.0;
    nameLab.font = [UIFont systemFontOfSize:18];
    nameLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *placeholderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    zoneBtn.myLeft = 20;
    zoneBtn.myCenterY = 0;
    zoneBtn.widthSize.equalTo(zoneBtn.widthSize).add(20);
    zoneBtn.heightSize.equalTo(zoneBtn.heightSize).add(3);
    
    nameLab.myCenterY = 0;
    nameLab.weight = 1.0;
    nameLab.heightSize.equalTo(nameLab.heightSize);
    
    placeholderBtn.myCenterY = 0;
    placeholderBtn.myRight = 20;
    placeholderBtn.widthSize.equalTo(zoneBtn.widthSize);
    placeholderBtn.heightSize.equalTo(zoneBtn.heightSize);
    
    [layout2 addSubview:zoneBtn];
    [layout2 addSubview:nameLab];
    [layout2 addSubview:placeholderBtn];
    
    zoneBtn.visibility = MyVisibility_Gone;
    placeholderBtn.visibility = MyVisibility_Gone;
    
    [layout2 layoutIfNeeded];
    
    XCTAssertTrue(nameLab.frame.size.width == layout2.frame.size.width &&
                  nameLab.center.y == layout2.frame.size.height * 0.5, @"nameLab.frame = %@",NSStringFromCGRect(nameLab.frame));
    
}

-(void)testWeight
{//测试均分
    
    MyLinearLayout* rootLayout1 = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 667) orientation:MyOrientation_Horz];
   // rootLayout1.myMargin = 0;
    rootLayout1.backgroundColor = [UIColor redColor];
    rootLayout1.widthSize.equalTo(nil);
    
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
        [button setTitle:[NSString stringWithFormat:@"%i",i] forState:UIControlStateNormal];
        button.heightSize.equalTo(rootLayout1.heightSize);
        [rootLayout1 addSubview:button];
    }
    
    [rootLayout1 layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(rootLayout1.subviews[0].frame, CGRectMake(0,0,94,667)), @"the button0.frame = %@",NSStringFromCGRect(rootLayout1.subviews[0].frame));
    XCTAssertTrue(CGRectEqualToRect(rootLayout1.subviews[1].frame, CGRectMake(94,0,94,667)), @"the button0.frame = %@",NSStringFromCGRect(rootLayout1.subviews[1].frame));
    XCTAssertTrue(CGRectEqualToRect(rootLayout1.subviews[2].frame, CGRectMake(188,0,94,667)), @"the button0.frame = %@",NSStringFromCGRect(rootLayout1.subviews[2].frame));
    XCTAssertTrue(CGRectEqualToRect(rootLayout1.subviews[3].frame, CGRectMake(282,0,94,667)), @"the button0.frame = %@",NSStringFromCGRect(rootLayout1.subviews[3].frame));

    

}

-(void)testWrapContentHeight2
{
    MyLinearLayout *layout = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 0) orientation:MyOrientation_Vert];
    layout.backgroundColor = [UIColor redColor];
    layout.gravity = MyGravity_Horz_Center;
    layout.padding = UIEdgeInsetsMake(15, 0, 0, 0);
    layout.subviewVSpace = 12;
    
    
    UILabel *timeLabel = UILabel.new;
    timeLabel.myHorzMargin = 0;
    timeLabel.myHeight = MyLayoutSize.wrap;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = @"剩余时间为";
    [layout addSubview:timeLabel];
    
    // 汇率
    MyLinearLayout *convertLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    convertLayout.backgroundColor = [UIColor greenColor];
    convertLayout.myHeight = MyLayoutSize.wrap;
    convertLayout.gravity = MyGravity_Vert_Center;
    convertLayout.subviewHSpace = 7;
    [layout addSubview:convertLayout];
    
    NSArray *items = @[@"$454", @"^sdsf"];
    for (int i=0; i<items.count; i++) {
        UILabel *label = UILabel.new;
        label.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        label.text = items[i];
        label.font = [UIFont systemFontOfSize:28];
        [convertLayout addSubview:label];
        
        if (i==0) {
            
            UILabel *btn = [UILabel new];
            btn.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
            btn.text = @"->";
            [convertLayout addSubview:btn];
        }
    }
    
    [layout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(layout.frame, CGRectMake(0,0,375,81)), @"the layout.frame = %@",NSStringFromCGRect(layout.frame));
    XCTAssertTrue(CGRectEqualToRect(convertLayout.frame, CGRectMake(105,47.5,165,33.5)), @"the convertLayout.frame = %@",NSStringFromCGRect(convertLayout.frame));
    
    XCTAssertTrue(CGRectEqualToRect(timeLabel.frame, CGRectMake(0,15,375,20.5)), @"the timeLabel.frame = %@",NSStringFromCGRect(timeLabel.frame));
    XCTAssertTrue(CGRectEqualToRect(convertLayout.subviews[1].frame, CGRectMake(76,6.5,18.5,20.5)), @"the convertLayout.subviews[1].frame = %@",NSStringFromCGRect(convertLayout.subviews[1].frame));

}

-(void)testWrapGravityMinMaxShrink
{
    //测试自适应，停靠，最大和最小。
    MyLinearLayout *testLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    testLayout.widthSize.min(200).max(300);
    testLayout.heightSize.equalTo(@(MyLayoutSize.wrap)).min(40).max(100);
    testLayout.shrinkType = MySubviewsShrink_Average;
    testLayout.subviewHSpace = 10;
    testLayout.gravity = MyGravity_Center;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    button.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    [testLayout addSubview:button];

    
    UILabel *label1 = [[UILabel alloc] init];
    label1.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    label1.text = @"文本1";
    label1.backgroundColor = [UIColor grayColor];
    [testLayout addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"文本2";
    label2.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    label2.backgroundColor = [UIColor cyanColor];
    [testLayout addSubview:label2];
    
    [testLayout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(testLayout.frame, CGRectMake(0,0,200,40)), @"the testLayout.frame = %@",NSStringFromCGRect(testLayout.frame));
    XCTAssertTrue(CGRectEqualToRect(button.frame, CGRectMake(28,3,37,34)), @"the button.frame = %@",NSStringFromCGRect(button.frame));
    XCTAssertTrue(CGRectEqualToRect(label1.frame, CGRectMake(75,10,42.5,20.5)), @"the label1.frame = %@",NSStringFromCGRect(label1.frame));

    //字体高度扩高。文字超长。
    button.titleLabel.font = [UIFont systemFontOfSize:30];
    label1.text = @"文本111111111111";
    [testLayout setNeedsLayout];
    
    [testLayout layoutIfNeeded];

    XCTAssertTrue(CGRectEqualToRect(testLayout.frame, CGRectMake(0,0,251.5,48)), @"the testLayout.frame = %@",NSStringFromCGRect(testLayout.frame));
    XCTAssertTrue(CGRectEqualToRect(button.frame, CGRectMake(0,0,61,48)), @"the button.frame = %@",NSStringFromCGRect(button.frame));
    XCTAssertTrue(CGRectEqualToRect(label1.frame, CGRectMake(71,14,125.5,20.5)), @"the label1.frame = %@",NSStringFromCGRect(label1.frame));

    
//    label1.text = @"文本111111111111111111111111111";
//    label1.mySize = CGSizeMake(400, 20.5);
//    
//    [testLayout setNeedsLayout];
//    [testLayout layoutIfNeeded];
//    
//    XCTAssertTrue(CGRectEqualToRect(testLayout.frame, CGRectMake(0,0,330,48)), @"the testLayout.frame = %@",NSStringFromCGRect(testLayout.frame));
//    XCTAssertTrue(CGRectEqualToRect(button.frame, CGRectMake(0,0,44.5,48)), @"the button.frame = %@",NSStringFromCGRect(button.frame));
//    XCTAssertTrue(CGRectEqualToRect(label1.frame, CGRectMake(54.5,14,237,20.5)), @"the label1.frame = %@",NSStringFromCGRect(label1.frame));

}

-(void)testBetweenAndAround
{
    //测试布局视图的gravity属性的between和around特性。
    
    MyLinearLayout *layout = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 100, 100) orientation:MyOrientation_Vert];
    layout.heightSize.equalTo(nil);
    
    //一个子视图下的垂直和水平的差异。
    UIView *v1 = [UIView new];
    v1.mySize = CGSizeMake(30, 30);
    [layout addSubview:v1];
    
    layout.orientation = MyOrientation_Vert;
    layout.gravity = MyGravity_Vert_Between;
    [layout layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,0,30,30)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));


    layout.orientation = MyOrientation_Horz;
    layout.gravity = MyGravity_Horz_Between;
    [layout layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,0,30,30)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));

    
    layout.orientation = MyOrientation_Vert;
    layout.gravity = MyGravity_Vert_Around;
    [layout layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,35,30,30)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
    
    
    layout.orientation = MyOrientation_Horz;
    layout.gravity = MyGravity_Horz_Around;
    [layout layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(35,0,30,30)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
    
    
    //两个子视图
    UIView *v2 = [UIView new];
    v2.mySize = CGSizeMake(30, 30);
    [layout addSubview:v2];
    
    layout.orientation = MyOrientation_Vert;
    layout.gravity = MyGravity_Vert_Between;
    [layout layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(0,70,30,30)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
    
    
    layout.orientation = MyOrientation_Horz;
    layout.gravity = MyGravity_Horz_Between;
    [layout layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(70,0,30,30)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
    
    
    layout.orientation = MyOrientation_Vert;
    layout.gravity = MyGravity_Vert_Around;
    [layout layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(0,60,30,30)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
    
    
    layout.orientation = MyOrientation_Horz;
    layout.gravity = MyGravity_Horz_Around;
    [layout layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(60,0,30,30)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
    
}

-(void)testFillAndStretch
{
    //子视图有几个设置了约束，有几个没有设置约束。分别展现Fill 和Stretch的差异。
    if (1){
        MyLinearLayout *rootLayout = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 0, 400) orientation:MyOrientation_Vert];
        rootLayout.padding = UIEdgeInsetsMake(10, 10, 20, 20);
        rootLayout.widthSize.equalTo(@(MyLayoutSize.wrap));
        rootLayout.heightSize.equalTo(nil);
        
        //视图1宽度依赖父视图，高度设置。
        UILabel *v1 = [UILabel new];
        v1.text = @"你好";  //iPhone8模拟器
        v1.myHorzMargin = 10;
        v1.myHeight = MyLayoutSize.wrap;
        [rootLayout addSubview:v1];
        
        //视图2宽度定值，右边对齐，高度不设置。
        UIView *v2 = [UIView new];
        v2.myRight = 20;
        v2.myWidth = 50;
        [rootLayout addSubview:v2];
        
        //视图3宽度定值，居中对齐，高度设置。
        UIView *v3 = [UIView new];
        v3.widthSize.equalTo(v2.widthSize).add(20);
        v3.myCenterX = 0;
        v3.myHeight = 40;
        [rootLayout addSubview:v3];
        
        //视图4设置左右边距，并且宽度定值，高度不设置。
        UIView *v4 = [UIView new];
        v4.myHorzMargin = 30;
        v4.myWidth = 100;
        [rootLayout addSubview:v4];
        
        //视图5设置宽度依赖父视图，高度设置。
        UIView *v5 = [UIView new];
        v5.widthSize.equalTo(rootLayout.widthSize).multiply(0.5);
        v5.myHeight = 40;
        [rootLayout addSubview:v5];
        
        rootLayout.gravity = MyGravity_Vert_Fill;
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,190,400)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
         XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(20,10,140,74.5)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
         XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(100,84.5,50,54)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
         XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(55,138.5,70,94)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
         XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(40,232,100,54)), @"the v4 .frame = %@",NSStringFromCGRect(v4.frame));
         XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(10,286,80,94)), @"the v5 .frame = %@",NSStringFromCGRect(v5.frame));
    }

    if (1){
        MyLinearLayout *rootLayout = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 0, 400) orientation:MyOrientation_Vert];
        rootLayout.padding = UIEdgeInsetsMake(10, 10, 20, 20);
        rootLayout.widthSize.equalTo(@(MyLayoutSize.wrap));
        rootLayout.heightSize.equalTo(nil);
        
        //视图1宽度依赖父视图，高度设置。
        UILabel *v1 = [UILabel new];
        v1.text = @"你好";  //iPhone8模拟器
        v1.myHorzMargin = 10;
        v1.myHeight = MyLayoutSize.wrap;
        [rootLayout addSubview:v1];
        
        //视图2宽度定值，右边对齐，高度不设置。
        UIView *v2 = [UIView new];
        v2.myRight = 20;
        v2.myWidth = 50;
        [rootLayout addSubview:v2];
        
        //视图3宽度定值，居中对齐，高度设置。
        UIView *v3 = [UIView new];
        v3.widthSize.equalTo(v2.widthSize).add(20);
        v3.myCenterX = 0;
        v3.myHeight = 40;
        [rootLayout addSubview:v3];
        
        //视图4设置左右边距，并且宽度定值，高度不设置。
        UIView *v4 = [UIView new];
        v4.myHorzMargin = 30;
        v4.myWidth = 100;
        [rootLayout addSubview:v4];
        
        //视图5设置宽度依赖父视图，高度设置。
        UIView *v5 = [UIView new];
        v5.widthSize.equalTo(rootLayout.widthSize).multiply(0.5);
        v5.myHeight = 40;
        [rootLayout addSubview:v5];
        
        rootLayout.gravity = MyGravity_Vert_Stretch;
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,190,400)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(20,10,140,110.5)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(100,120.5,50,90)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(55,210,70,40)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(40,250,100,90)), @"the v4 .frame = %@",NSStringFromCGRect(v4.frame));
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(10,340,80,40)), @"the v5 .frame = %@",NSStringFromCGRect(v5.frame));
    }

    
    if (1){
        MyLinearLayout *rootLayout = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 400, 0) orientation:MyOrientation_Horz];
        rootLayout.padding = UIEdgeInsetsMake(10, 10, 20, 20);
        rootLayout.widthSize.equalTo(nil);
        rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
        
        //视图1高度依赖父视图，宽度设置。
        UILabel *v1 = [UILabel new];
        v1.text = @"你好";  //iPhone8模拟器
        v1.myVertMargin = 10;
        v1.myWidth = MyLayoutSize.wrap;
        [rootLayout addSubview:v1];
        
        //视图2高度定值，下边对齐，宽度不设置。
        UIView *v2 = [UIView new];
        v2.myBottom = 20;
        v2.myHeight = 50;
        [rootLayout addSubview:v2];
        
        //视图3高度定值，居中对齐，宽度设置。
        UIView *v3 = [UIView new];
        v3.heightSize.equalTo(v2.heightSize).add(20);
        v3.myCenterY = 0;
        v3.myWidth = 40;
        [rootLayout addSubview:v3];
        
        //视图4设置上下边距，并且高度定值，宽度不设置。
        UIView *v4 = [UIView new];
        v4.myVertMargin = 30;
        v4.myHeight = 100;
        [rootLayout addSubview:v4];
        
        //视图5设置高度依赖父视图，宽度设置。
        UIView *v5 = [UIView new];
        v5.heightSize.equalTo(rootLayout.heightSize).multiply(0.5);
        v5.myWidth = 40;
        [rootLayout addSubview:v5];
        
        rootLayout.gravity = MyGravity_Horz_Fill;
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,400,190)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));

        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(10,20,86,140)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(96,100,51,50)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(147,55,91,70)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(238,40,51,100)), @"the v4 .frame = %@",NSStringFromCGRect(v4.frame));
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(289,10,91,80)), @"the v5 .frame = %@",NSStringFromCGRect(v5.frame));
    }
    
    if (1){
        MyLinearLayout *rootLayout = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 400, 0) orientation:MyOrientation_Horz];
        rootLayout.padding = UIEdgeInsetsMake(10, 10, 20, 20);
        rootLayout.widthSize.equalTo(nil);
        rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
        
        //视图1高度依赖父视图，宽度设置。
        UILabel *v1 = [UILabel new];
        v1.text = @"你好";  //iPhone8模拟器
        v1.myVertMargin = 10;
        v1.myWidth = MyLayoutSize.wrap;
        [rootLayout addSubview:v1];
        
        //视图2高度定值，下边对齐，宽度不设置。
        UIView *v2 = [UIView new];
        v2.myBottom = 20;
        v2.myHeight = 50;
        [rootLayout addSubview:v2];
        
        //视图3高度定值，居中对齐，宽度设置。
        UIView *v3 = [UIView new];
        v3.heightSize.equalTo(v2.heightSize).add(20);
        v3.myCenterY = 0;
        v3.myWidth = 40;
        [rootLayout addSubview:v3];
        
        //视图4设置上下边距，并且高度定值，宽度不设置。
        UIView *v4 = [UIView new];
        v4.myVertMargin = 30;
        v4.myHeight = 100;
        [rootLayout addSubview:v4];
        
        //视图5设置高度依赖父视图，宽度设置。
        UIView *v5 = [UIView new];
        v5.heightSize.equalTo(rootLayout.heightSize).multiply(0.5);
        v5.myWidth = 40;
        [rootLayout addSubview:v5];
        
        rootLayout.gravity = MyGravity_Horz_Stretch;
        [rootLayout layoutIfNeeded];
        
        XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,400,190)), @"the rootLayout.frame = %@",NSStringFromCGRect(rootLayout.frame));
        
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(10,20,120,140)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(130,100,85,50)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(215,55,40,70)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(255,40,85,100)), @"the v4 .frame = %@",NSStringFromCGRect(v4.frame));
        XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(340,10,40,80)), @"the v5 .frame = %@",NSStringFromCGRect(v5.frame));
    }


    
    
}

-(void)testequalizeSubviews
{
    //测试均分视图的能力。
    {
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        rootLayout.heightSize.equalTo(@300);
        rootLayout.frame = CGRectMake(0, 0, 100, 300);
        rootLayout.gravity = MyGravity_Horz_Fill;
        
        UIView *v1 = [UIView new];
        v1.myHeight = 10;
        UIView *v2 = [UIView new];
        v2.myHeight = 10;
        UIView *v3 = [UIView new];
        v3.myHeight = 10;
        
        [rootLayout addSubview:v1];
        [rootLayout addSubview:v2];
        [rootLayout addSubview:v3];
        
        [rootLayout equalizeSubviews:YES];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,43,100,43)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(0,129,100,43)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(0,215,100,43)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));


        [rootLayout equalizeSubviews:NO];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,0,100,60)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(0,120,100,60)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(0,240,100,60)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));

        
        v1.weight = 0;
        v2.weight = 0;
        v3.weight = 0;
        [rootLayout equalizeSubviewsSpace:YES];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,67.5,100,10)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(0,67.5+10+67.5,100,10)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(0,67.5*3+10*2,100,10)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        v1.myTop = 0;
        v1.myBottom = 0;
        v2.myTop = 0;
        v2.myBottom = 0;
        v3.myTop = 0;
        v3.myBottom = 0;
        [rootLayout equalizeSubviewsSpace:NO];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,0,100,10)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(0,135+10,100,10)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(0,135+10+135+10,100,10)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        v1.weight = 0;
        v2.weight = 0;
        v3.weight = 0;
        v1.myTop = 0;
        v1.myBottom = 0;
        v2.myTop = 0;
        v2.myBottom = 0;
        v3.myTop = 0;
        v3.myBottom = 0;
        [rootLayout equalizeSubviews:YES withSpace:10];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,10,100,86.5)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(0,106.5,100,86.5)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(0,203,100,86.5)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        v1.weight = 0;
        v2.weight = 0;
        v3.weight = 0;
        [rootLayout equalizeSubviews:NO withSpace:10];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,0,100,93.5)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(0,103.5,100,93.5)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(0,207,100,93.5)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
    }

    
    {
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        rootLayout.widthSize.equalTo(@300);
        rootLayout.frame = CGRectMake(0, 0, 300, 100);
        rootLayout.gravity = MyGravity_Vert_Fill;
        
        UIView *v1 = [UIView new];
        v1.myWidth = 10;
        UIView *v2 = [UIView new];
        v2.myWidth = 10;
        UIView *v3 = [UIView new];
        v3.myWidth = 10;
        
        [rootLayout addSubview:v1];
        [rootLayout addSubview:v2];
        [rootLayout addSubview:v3];
        
        [rootLayout equalizeSubviews:YES];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(43,0,43,100)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(129,0,43,100)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(215,0,43,100)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        
        
        [rootLayout equalizeSubviews:NO];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,0,60,100)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(120,0,60,100)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(240,0,60,100)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        v1.weight = 0;
        v2.weight = 0;
        v3.weight = 0;
        [rootLayout equalizeSubviewsSpace:YES];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(67.5,0,10,100)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(67.5+10+67.5,0,10,100)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(67.5*3+10*2,0,10,100)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        v1.myLeading = 0;
        v1.myTrailing = 0;
        v2.myLeading = 0;
        v2.myTrailing = 0;
        v3.myLeading = 0;
        v3.myTrailing = 0;
        [rootLayout equalizeSubviewsSpace:NO];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,0,10,100)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(135+10,0,10,100)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(135+10+135+10,0,10,100)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        v1.weight = 0;
        v2.weight = 0;
        v3.weight = 0;
        v1.myLeading = 0;
        v1.myTrailing = 0;
        v2.myLeading = 0;
        v2.myTrailing = 0;
        v3.myLeading = 0;
        v3.myTrailing = 0;
        [rootLayout equalizeSubviews:YES withSpace:10];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(10,0,86.5,100)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(106.5,0,86.5,100)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(203,0,86.5,100)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
        
        v1.weight = 0;
        v2.weight = 0;
        v3.weight = 0;
        [rootLayout equalizeSubviews:NO withSpace:10];
        [rootLayout layoutIfNeeded];
        XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(0,0,93.5,100)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
        XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(103.5,0,93.5,100)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
        XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(207,0,93.5,100)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
    }
    
}

-(void)testMaxAndMin
{
    MyFrameLayout *rootLayout = [MyFrameLayout new];
    rootLayout.frame = CGRectMake(0, 0, 375, 667);
    
    // B 视图
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.backgroundColor = [UIColor blueColor];
    scrollview.myHorzMargin = 0;
    scrollview.heightSize.equalTo(@(MyLayoutSize.wrap)).min(280).uBound(rootLayout.heightSize, 66.5, 0.5);
    [rootLayout addSubview:scrollview];
    
    // 内容C视图
    MyLinearLayout * backLinear = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    backLinear.backgroundColor = [UIColor greenColor];
    backLinear.myHorzMargin = 0;
    backLinear.heightSize.equalTo(@(MyLayoutSize.wrap)).min(280);
    backLinear.gravity = MyGravity_Vert_Bottom;
    [scrollview addSubview:backLinear];
    
    UIView *v = [UIView new];
    v.myHeight = 100;
    v.myWidth = 100;
    v.backgroundColor = [UIColor redColor];
    [backLinear addSubview:v];
    
    [rootLayout setNeedsLayout];
    [rootLayout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(scrollview.frame, CGRectMake(0,0,375,280)), @"the scrollview.frame = %@",NSStringFromCGRect(scrollview.frame));
     XCTAssertTrue(CGSizeEqualToSize(scrollview.contentSize, CGSizeMake(375, 280)), @"the scrollview.contentSize = %@",NSStringFromCGSize(scrollview.contentSize));
    XCTAssertTrue(CGRectEqualToRect(backLinear.frame, CGRectMake(0,0,375,280)), @"the backLinear.frame = %@",NSStringFromCGRect(backLinear.frame));
    XCTAssertTrue(CGRectEqualToRect(v.frame, CGRectMake(0,180,100,100)), @"the v.frame = %@",NSStringFromCGRect(v.frame));

    
    v.myHeight = 350;
    [rootLayout setNeedsLayout];
    [rootLayout layoutIfNeeded];

    XCTAssertTrue(CGRectEqualToRect(scrollview.frame, CGRectMake(0,0,375,350)), @"the scrollview.frame = %@",NSStringFromCGRect(scrollview.frame));
    XCTAssertTrue(CGSizeEqualToSize(scrollview.contentSize, CGSizeMake(375, 350)), @"the scrollview.contentSize = %@",NSStringFromCGSize(scrollview.contentSize));
    XCTAssertTrue(CGRectEqualToRect(backLinear.frame, CGRectMake(0,0,375,350)), @"the backLinear.frame = %@",NSStringFromCGRect(backLinear.frame));
    XCTAssertTrue(CGRectEqualToRect(v.frame, CGRectMake(0,0,100,350)), @"the v.frame = %@",NSStringFromCGRect(v.frame));

    v.myHeight = 500;
    [rootLayout setNeedsLayout];
    [rootLayout layoutIfNeeded];
    
    
    XCTAssertTrue(CGRectEqualToRect(scrollview.frame, CGRectMake(0,0,375,400)), @"the scrollview.frame = %@",NSStringFromCGRect(scrollview.frame));
    XCTAssertTrue(CGSizeEqualToSize(scrollview.contentSize, CGSizeMake(375, 500)), @"the scrollview.contentSize = %@",NSStringFromCGSize(scrollview.contentSize));
    XCTAssertTrue(CGRectEqualToRect(backLinear.frame, CGRectMake(0,0,375,500)), @"the backLinear.frame = %@",NSStringFromCGRect(backLinear.frame));
    XCTAssertTrue(CGRectEqualToRect(v.frame, CGRectMake(0,0,100,500)), @"the v.frame = %@",NSStringFromCGRect(v.frame));

}

-(void)testNoLayoutConstraint1
{
    //这用来测试没有设置约束，直接通过frame来得到布局尺寸自适应的情况。
    {
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        
        UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [rootLayout addSubview:v1];
        
        UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [rootLayout addSubview:v2];
        
        UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        [rootLayout addSubview:v3];
        
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 300, 100+200+300));
    }
    
    {
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        
        UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [rootLayout addSubview:v1];
        
        UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [rootLayout addSubview:v2];
        
        UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        [rootLayout addSubview:v3];
        
        [rootLayout layoutIfNeeded];
        MyRectAssert(rootLayout, CGRectMake(0, 0, 100+200+300,300));
    }
    
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//
//    }];
//
   
}

@end

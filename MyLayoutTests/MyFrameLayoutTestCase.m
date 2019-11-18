//
//  MyFrameLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 17/4/21.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"
#import "FLTest1ViewController.h"
#import "FLTest2ViewController.h"

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

-(void)testExample
{
   
    for (int i = 1; i <=2; i++)
    {
        Class cls = NSClassFromString([NSString stringWithFormat:@"FLTest%dViewController", i]);
        UIViewController *vc = [cls new];
        UIView *v = vc.view;
        [v layoutIfNeeded];
    }

}

-(void)testblurred
{
    //测试位置偏移不正确或者尺寸不正确将会产生模糊显示的效果。
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
    label1.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    
    [frameLayout addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"统计";
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:17];
    label2.myTop = 200;
    label2.myLeft = 10;
    label2.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    [frameLayout addSubview:label2];
    

    [frameLayout layoutIfNeeded];
    
    if ([UIScreen mainScreen].bounds.size.width == 414)
    {
    
    XCTAssertTrue(CGRectEqualToRect(label1.frame, CGRectMake(29.999999999999996, 323.333333333333331, 34.666666666666664, 20.333333333333332)), @"the label1.frame = %@",NSStringFromCGRect(label1.frame));
    
    }
    else
    {
        XCTAssertTrue(CGRectEqualToRect(label1.frame, CGRectMake(30, 323.5, 35, 20.5)), @"the label1.frame = %@",NSStringFromCGRect(label1.frame));
        
    }

}

//测试尺寸包裹。
- (void)testWrapContent {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.padding = UIEdgeInsetsMake(20, 10, 5, 6);
    frameLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    
    frameLayout.zeroPadding = NO;
    
    
    XCTAssertTrue(CGSizeEqualToSize([frameLayout sizeThatFits:CGSizeZero], CGSizeMake(0, 0)), @"frameLayout size is:%@",NSStringFromCGSize([frameLayout sizeThatFits:CGSizeZero]));
    
    frameLayout.zeroPadding = YES;
    XCTAssertTrue(CGSizeEqualToSize([frameLayout sizeThatFits:CGSizeZero], CGSizeMake(16, 25)), @"frameLayout size is:%@",NSStringFromCGSize([frameLayout sizeThatFits:CGSizeZero]));
    
    UIView *v0 = [UIView new];
    v0.myLeft = 10;
    v0.myRight = 12;
    v0.myTop = 5;
    v0.myBottom = 10;
    [frameLayout addSubview:v0];
    
    
    XCTAssertTrue(CGSizeEqualToSize([frameLayout sizeThatFits:CGSizeZero], CGSizeMake(16+10+12, 25+5+10)), @"frameLayout size is:%@",NSStringFromCGSize([frameLayout sizeThatFits:CGSizeZero]));
    
    
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
    
    [frameLayout sizeThatFits:CGSizeZero];
    
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

    
    [frameLayout sizeThatFits:CGSizeMake(200, 200)];
    
    XCTAssertTrue(CGRectEqualToRect(v1.estimatedRect, CGRectMake(0,0,100, 100)), @"v1 rect is:%@", NSStringFromCGRect(v1.estimatedRect));
    XCTAssertTrue(CGRectEqualToRect(v2.estimatedRect, CGRectMake(0,0,50, 50)), @"v2 rect is:%@", NSStringFromCGRect(v2.estimatedRect));
    XCTAssertTrue(CGRectEqualToRect(v3.estimatedRect, CGRectMake(0,0,100,50)), @"v3 rect is:%@", NSStringFromCGRect(v3.estimatedRect));

}

-(void)testWrapContent2
{
    MyFrameLayout * dataview = [[MyFrameLayout alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    dataview.heightSize.equalTo(@(MyLayoutSize.wrap)).min([UIScreen mainScreen].bounds.size.height);
    //上面在滚动视图下。
    
    MyLinearLayout * dataContentV = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    dataContentV.topPadding = 64;
    dataContentV.bottomPadding = 64;      // + 10;
    dataContentV.myCenterX = 0;
    dataContentV.myCenterY = 0;
    dataContentV.myHeight = MyLayoutSize.wrap;
    dataContentV.myHorzMargin = 0;
    [dataview addSubview:dataContentV];

    
    MyLinearLayout * subrootview1 = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    subrootview1.gravity = MyGravity_Horz_Fill;
    subrootview1.myHeight = MyLayoutSize.wrap;
    subrootview1.myHorzMargin = 0;
    subrootview1.padding = UIEdgeInsetsMake(0, 10, 0, 10);
    [dataContentV addSubview:subrootview1];

    
    UILabel * view1 = [UILabel new];
    view1.myTop = 120;
    view1.myHeight = 140 + 180;
    [subrootview1 addSubview:view1];
    
    
    UILabel * view2 = [UILabel new];
    view2.myHeight = 160 + 200;
    [subrootview1 addSubview:view2];
    
    
    UILabel * subrootview2 = [UILabel new];
    subrootview2.myHeight = 150;
    subrootview2.myHorzMargin = 0;
    subrootview2.text = @"subrootview2";
    [dataContentV addSubview:subrootview2];
    
    view2.hidden = YES;
    subrootview2.hidden = YES;
    
    [dataview layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(dataview.frame, CGRectMake(0,0,375,667)), @"dataview rect is:%@", NSStringFromCGRect(dataview.frame));
     XCTAssertTrue(CGRectEqualToRect(dataContentV.frame, CGRectMake(0,49.5,375,568)), @"dataContentV rect is:%@", NSStringFromCGRect(dataContentV.frame));
    
    
    subrootview2.hidden = NO;
    
    [dataview layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(dataview.frame, CGRectMake(0,0,375,718)), @"dataview rect is:%@", NSStringFromCGRect(dataview.frame));
    XCTAssertTrue(CGRectEqualToRect(dataContentV.frame, CGRectMake(0,0,375,718)), @"dataContentV rect is:%@", NSStringFromCGRect(dataContentV.frame));
    
    
    view2.hidden = NO;
    subrootview2.hidden = YES;
    
    [dataview layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(dataview.frame, CGRectMake(0,0,375,928)), @"dataview rect is:%@", NSStringFromCGRect(dataview.frame));
    XCTAssertTrue(CGRectEqualToRect(dataContentV.frame, CGRectMake(0,0,375,928)), @"dataContentV rect is:%@", NSStringFromCGRect(dataContentV.frame));
    
    
    view2.hidden = YES;
    subrootview2.hidden = YES;
    
    [dataview layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(dataview.frame, CGRectMake(0,0,375,667)), @"dataview rect is:%@", NSStringFromCGRect(dataview.frame));
    XCTAssertTrue(CGRectEqualToRect(dataContentV.frame, CGRectMake(0,49.5,375,568)), @"dataContentV rect is:%@", NSStringFromCGRect(dataContentV.frame));

}

-(void)testWrapContent3
{
    //测试一个布局视图的尺寸是包裹的，同时里面的子视图设置了宽高。
    MyFrameLayout *rootLayout = [MyFrameLayout new];
    rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    rootLayout.padding = UIEdgeInsetsMake(10, 20, 30, 40);
    
    //1.同时设置了上下和左右。没有设置高度。
    UIView *v1 = [UIView new];
    v1.myLeft = 10;
    v1.myRight = 20;
    v1.myTop = 30;
    v1.myBottom = 40;
    [rootLayout addSubview:v1];
    
    [rootLayout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,90,110)), @"rootLayout rect is:%@", NSStringFromCGRect(rootLayout.frame));
    XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(30,40,0,0)), @"v1 rect is:%@", NSStringFromCGRect(v1.frame));

    
    
    UIView *v2 = [UIView new];
    v2.myLeft = 40;
    v2.myRight = 30;
    v2.myTop = 20;
    v2.myBottom = 10;
    v2.myWidth = 100;
    v2.myHeight = 200;
    [rootLayout addSubview:v2];
    
    [rootLayout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,230,270)), @"rootLayout rect is:%@", NSStringFromCGRect(rootLayout.frame));
    XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(30,40,140,160)), @"v1 rect is:%@", NSStringFromCGRect(v1.frame));
    XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(60,30,100,200)), @"v2 rect is:%@", NSStringFromCGRect(v2.frame));

    [v1 removeFromSuperview];
    [v2 removeFromSuperview];
    
    UILabel *label = [UILabel new];
    label.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    label.text = @"您好！";
    label.myMargin = 20;
    CGSize lablesz = [label sizeThatFits:CGSizeZero];
    [rootLayout addSubview:label];
    
    [rootLayout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,60+40+lablesz.width,40+40+lablesz.height)), @"rootLayout rect is:%@", NSStringFromCGRect(rootLayout.frame));
    XCTAssertTrue(CGRectEqualToRect(label.frame, CGRectMake(20+20,10+20,lablesz.width,lablesz.height)), @"label rect is:%@", NSStringFromCGRect(label.frame));
    
    
    UIView *v3 = [UIView new];
    v3.myRight = 30;
    v3.myBottom = 30;
    v3.mySize = CGSizeMake(100, 100);
    [rootLayout addSubview:v3];
    
    [rootLayout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(rootLayout.frame, CGRectMake(0,0,20+40+30+100,10+30+30+100)), @"rootLayout rect is:%@", NSStringFromCGRect(rootLayout.frame));
    
     XCTAssertTrue(CGRectEqualToRect(label.frame, CGRectMake(20+20,10+20,lablesz.width,lablesz.height)), @"label rect is:%@", NSStringFromCGRect(label.frame));
    
    XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(rootLayout.frame.size.width - 40 - 30 - 100 ,rootLayout.frame.size.height - 30 - 30 - 100, 100,100)), @"v3 rect is:%@", NSStringFromCGRect(v3.frame));
    
    
}

-(void)testWrapContent4
{
    //没有约束，原生的frame值设置。
    MyFrameLayout *rootLayout = [MyFrameLayout new];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    
    UIView *v = [UIView new];
    v.frame = CGRectMake(0, 0, 150, 150);
    [rootLayout addSubview:v];
    
    [rootLayout layoutIfNeeded];
    MyRectAssert(rootLayout, CGRectMake(0, 0, 170, 170));
    
}

-(void)testWrapContent5
{
    MyFrameLayout* _layoutRoot = [[MyFrameLayout alloc] init];
    _layoutRoot.myTop =
    _layoutRoot.myLeft =
    _layoutRoot.myRight = 0;
    _layoutRoot.wrapContentHeight = YES;
    _layoutRoot.bottomPadding = 12;
    // _layoutRoot.backgroundColor = [UIColor whiteColor];
    //_layoutRoot.clipsToBounds = YES;
    _layoutRoot.frame = CGRectMake(0, 0, 100, 0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.myLeft =
    imageView.myRight = 0;
    imageView.myBottom = -12;
    [_layoutRoot addSubview:imageView];
    
    [_layoutRoot layoutIfNeeded];
    
    MyRectAssert(_layoutRoot, CGRectMake(0, 0, 100, 50));
    
    
    [_layoutRoot setNeedsLayout];
    [_layoutRoot layoutIfNeeded];
    
    MyRectAssert(_layoutRoot, CGRectMake(0, 0, 100, 50));

}

-(void)testPerformanceExample
{
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
    }];

}

@end

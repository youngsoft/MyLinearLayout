//
//  MyLayoutPerformanceTestCase.m
//  MyLayout
//
//  Created by apple on 17/5/3.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"

//对SDAutoLayout和Masonry的测试请单独引入这两个第三方库进行测试。

@interface MyLayoutPerformanceTestCase : MyLayoutTestCaseBase

@property(nonatomic, assign) int counts;

@end

@implementation MyLayoutPerformanceTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.counts = 300; //分别设置10,20,50,80,100,200,300
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testCenterBounds
{
    UIView *testView = [UIView new];
    
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        
        // Do setup work that needs to be done for every iteration but you don't want to measure before the call to -startMeasuring
    
        [self startMeasuring];

        for (int i = 0; i < 10000; i++)
        {
            
            CGRect rect = CGRectMake(arc4random_uniform(100), arc4random_uniform(100), arc4random_uniform(100), arc4random_uniform(100));
            
            
            testView.center = CGPointMake(rect.origin.x + testView.layer.anchorPoint.x * rect.size.width, rect.origin.y + testView.layer.anchorPoint.y * rect.size.height);
            testView.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
            
            // Do that thing you want to measure.
        }
        
        [self stopMeasuring];

        // Do teardown work that needs to be done for every iteration but you don't want to measure after the call to -stopMeasuring
    }];
    
}

-(void)testFrame
{
    UIView *testView = [UIView new];
    
    
    [self measureMetrics:[[self class] defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        
        // Do setup work that needs to be done for every iteration but you don't want to measure before the call to -startMeasuring
        [self startMeasuring];

        for (int  i = 0; i < 10000; i++)
        {
            
            CGRect rect = CGRectMake(arc4random_uniform(100), arc4random_uniform(100), arc4random_uniform(100), arc4random_uniform(100));
            
            if (CGAffineTransformIsIdentity(testView.transform))
                testView.frame = rect;
            // Do that thing you want to measure.
        }
        
        [self stopMeasuring];

        // Do teardown work that needs to be done for every iteration but you don't want to measure after the call to -stopMeasuring
    }];

   
}



-(void)testFont
{
    //这里测试各种字体对sizeToFit的影响。
    
    UILabel *testLabel = [UILabel new];
    testLabel.text = @"Hello 欧阳大哥，.-?？asd 水电费asdfasf 阿斯顿发安防";
    testLabel.numberOfLines = 0;
    CGSize sz = CGSizeMake(70, 0);
    
    for (NSString *familyName in [UIFont familyNames])
    {
        NSArray *arr1 = [UIFont fontNamesForFamilyName:familyName];
        for (NSString *fontName in arr1)
        {
            UIFont *font = [UIFont fontWithName:fontName size:15];
            testLabel.font = font;
            [self startClock];
            for (int i = 0; i < 1000; i++)
            {
                [testLabel sizeThatFits:sz];
            }
            
            [self endClock:[NSString stringWithFormat:@"%@:%@",familyName, fontName]];
        }
    }
    
    
    UIFont *font = [UIFont systemFontOfSize:15];
    testLabel.font = font;
    [self startClock];
    for (int i = 0; i < 1000; i++)
    {
        [testLabel sizeThatFits:sz];
    }
    
    [self endClock:[NSString stringWithFormat:@"%@:%@",@"system", @"system"]];
  

}

/*
   线性布局部分的性能测试。
 */
#pragma mark -- LinearLayout

-(UIView*)linearlayout_createFrame
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    CGFloat top = 0;
    for (int i = 0; i < self.counts; i++)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, top, 100, 20)];
        [containerView addSubview:v];
        top += 20 + 10;
    }
    
    return containerView;
}

-(UIView*)linearlayout_createMyLayout
{
    MyLinearLayout *containerView = [[MyLinearLayout alloc] initWithFrame:CGRectMake(0, 0, 100, 100) orientation:MyOrientation_Vert];
    containerView.wrapContentHeight = NO;
    
    for (int i = 0; i < self.counts; i++)
    {
        UIView *v = [UIView new];
        [containerView addSubview:v];
        v.myTop = 10;
        v.myHeight = 20;
        v.myHorzMargin = 0;
    }
    
    return containerView;
}

-(UIView*)linearlayout_createAutoLayout
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    NSLayoutYAxisAnchor *top = containerView.topAnchor;
    for (int i = 0; i < self.counts; i++)
    {
        UIView *v = [UIView new];
        v.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v];
        [NSLayoutConstraint activateConstraints:@[[v.widthAnchor constraintEqualToAnchor:containerView.widthAnchor multiplier:1],
                                                  [v.heightAnchor constraintEqualToConstant:20],
                                                  [v.topAnchor constraintEqualToAnchor:top constant:10],
                                                  [v.leftAnchor constraintEqualToAnchor:containerView.leftAnchor]
                                                  ]];
        
        top = v.bottomAnchor;
        
    }
    
    return containerView;
    
}


-(UIView*)linearlayout_createMasonry
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
   /* __block MASViewAttribute *top = containerView.mas_top;
    for (int i = 0; i < self.counts; i++)
    {
        UIView *v = [UIView new];
        [containerView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(containerView.mas_width);
            make.height.equalTo(@20);
            make.left.equalTo(containerView.mas_left);
            make.top.equalTo(top).offset(10);
            
        }];
        
        top = v.mas_bottom;
        
    }
    */
    
    return containerView;
}

-(UIView*)linearlayout_createUIStackView
{
    UIStackView *containerView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, 100, 4000)];
    containerView.axis = UILayoutConstraintAxisVertical;
    containerView.spacing = 1;
    containerView.alignment = UIStackViewAlignmentFill;
    
    for (int i = 0; i < self.counts; i++)
    {
        UIView *v = [UIView new];
        [containerView addArrangedSubview:v];
    }
    
    return containerView;
}

/*
   相对布局的性能测试
 */
#pragma mark -- RelativeLayout

-(UIView*)relativelayout_createFrame
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    for (int i = 0; i < self.counts/10; i++)
    {
        UIView *topLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [containerView addSubview:topLeft];
        
        UIView *topCenter = [[UIView alloc] initWithFrame:CGRectMake((100 - 20)/2, 0, 20, 20)];
        [containerView addSubview:topCenter];
        
        UIView *topRight = [[UIView alloc] initWithFrame:CGRectMake((100 - 20), 0, 20, 20)];
        [containerView addSubview:topRight];
        
        
        UIView *centerLeft = [[UIView alloc] initWithFrame:CGRectMake(0, (100-20)/2, 20, 20)];
        [containerView addSubview:centerLeft];
        
        UIView *centerCenter = [[UIView alloc] initWithFrame:CGRectMake((100-20)/2, (100 - 20)/2, 20, 20)];
        [containerView addSubview:centerCenter];
        
        UIView *centerRight = [[UIView alloc] initWithFrame:CGRectMake(100-20,(100 - 20)/2, 20, 20)];
        [containerView addSubview:centerRight];
        
        
        UIView *bottomLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 100-20, 20, 20)];
        [containerView addSubview:bottomLeft];
        
        UIView *bottomCenter = [[UIView alloc] initWithFrame:CGRectMake((100-20)/2, 100 - 20, 20, 20)];
        [containerView addSubview:bottomCenter];
        
        UIView *bottomRight = [[UIView alloc] initWithFrame:CGRectMake(100-20,100 - 20, 20, 20)];
        [containerView addSubview:bottomRight];
        
        UIView *fill = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
        [containerView addSubview:fill];
        
    }
    
    return containerView;
}

-(UIView*)relativelayout_createMyLayout
{
    MyRelativeLayout *containerView = [[MyRelativeLayout alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    for (int i = 0; i < self.counts/10; i++)
    {
        UIView *v10 = [UIView new];
        [containerView addSubview:v10];
        
        UIView *v9 = [UIView new];
        [containerView addSubview:v9];
        
        UIView *v8 = [UIView new];
        [containerView addSubview:v8];
        
        UIView *v7 = [UIView new];
        [containerView addSubview:v7];
        
        UIView *v6 = [UIView new];
        [containerView addSubview:v6];
        
        UIView *v5 = [UIView new];
        [containerView addSubview:v5];
        
        UIView *v4 = [UIView new];
        [containerView addSubview:v4];
        
        UIView *v3 = [UIView new];
        [containerView addSubview:v3];
        
        UIView *v2 = [UIView new];
        [containerView addSubview:v2];
        
        UIView *v1 = [UIView new];
        [containerView addSubview:v1];
        
        
        v1.widthSize.equalTo(@20);
        v1.heightSize.equalTo(@20);
        
        
        
        v2.widthSize.equalTo(v1.widthSize).multiply(2);
        v2.heightSize.equalTo(v1.heightSize).add(10);
        v2.topPos.equalTo(v1.bottomPos);
        v2.leftPos.equalTo(v1.rightPos);
        
        
        
        v3.widthSize.equalTo(containerView.widthSize).multiply(0.5);
        v3.heightSize.equalTo(@40);
        v3.topPos.equalTo(v2.bottomPos);
        v3.leftPos.equalTo(v2.rightPos);
        
        
        
        
        v4.widthSize.equalTo(@40);
        v4.heightSize.equalTo(v4.widthSize);
        v4.centerXPos.equalTo(@0);
        v4.centerYPos.equalTo(v2.centerYPos);
        
        
        v5.leftPos.equalTo(containerView.leftPos).offset(20);
        v5.rightPos.equalTo(containerView.rightPos).offset(20);
        v5.topPos.equalTo(containerView.topPos).offset(20);
        v5.bottomPos.equalTo(containerView.bottomPos).offset(20);
        
        
        
        v6.widthSize.equalTo(v5.heightSize);
        v6.heightSize.equalTo(v5.widthSize);
        v6.rightPos.equalTo(v1.rightPos);
        v6.centerYPos.equalTo(v2.bottomPos);
        
        
        
        
        v7.widthSize.equalTo(@40);
        v7.heightSize.equalTo(@40);
        v7.leftPos.equalTo(v5.rightPos);
        v7.bottomPos.equalTo(v4.topPos);
        
        
        
        v8.widthSize.equalTo(v1.widthSize);
        v8.heightSize.equalTo(containerView.heightSize).multiply(0.4);
        v8.centerYPos.equalTo(@0);
        v8.centerXPos.equalTo(@0);
        
        
        
        v9.widthSize.equalTo(v3.widthSize);
        v9.heightSize.equalTo(v4.heightSize);
        v9.bottomPos.equalTo(v5.bottomPos);
        v9.rightPos.equalTo(v6.rightPos);
        
        
        
        
        
        v10.myMargin = 0;
        
    }
    
    return containerView;
}

-(UIView*)relativelayout_createAutoLayout
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    for (int i = 0; i < self.counts/10; i++)
    {
        
        UIView *v10 = [UIView new];
        v10.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v10];
        
        UIView *v9 = [UIView new];
        v9.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v9];
        
        UIView *v8 = [UIView new];
        v8.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v8];
        
        UIView *v7 = [UIView new];
        v7.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v7];
        
        UIView *v6 = [UIView new];
        v6.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v6];
        
        UIView *v5 = [UIView new];
        v5.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v5];
        
        UIView *v4 = [UIView new];
        v4.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v4];
        
        UIView *v3 = [UIView new];
        v3.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v3];
        
        UIView *v2 = [UIView new];
        v2.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v2];
        
        UIView *v1 = [UIView new];
        v1.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v1];
        
        
        
        
        [NSLayoutConstraint activateConstraints:@[[v1.widthAnchor constraintEqualToConstant:20],
                                                  [v1.heightAnchor constraintEqualToConstant:20],
                                                  [v1.topAnchor constraintEqualToAnchor:containerView.topAnchor],
                                                  [v1.leftAnchor constraintEqualToAnchor:containerView.leftAnchor]
                                                  ]];
        
        
        [NSLayoutConstraint activateConstraints:@[[v2.widthAnchor constraintEqualToAnchor:v1.widthAnchor multiplier:2],
                                                  [v2.heightAnchor constraintEqualToAnchor:v1.heightAnchor multiplier:1 constant:10],
                                                  [v2.topAnchor constraintEqualToAnchor:v1.bottomAnchor],
                                                  [v2.leftAnchor constraintEqualToAnchor:v1.rightAnchor]
                                                  ]];
        
        
        
        [NSLayoutConstraint activateConstraints:@[[v3.widthAnchor constraintEqualToAnchor:containerView.widthAnchor multiplier:0.5],
                                                  [v3.heightAnchor constraintEqualToConstant:40],
                                                  [v3.topAnchor constraintEqualToAnchor:v2.bottomAnchor],
                                                  [v3.leftAnchor constraintEqualToAnchor:v2.rightAnchor]
                                                  ]];
        
        
        
        [NSLayoutConstraint activateConstraints:@[[v4.widthAnchor constraintEqualToConstant:20],
                                                  [v4.heightAnchor constraintEqualToAnchor:v4.widthAnchor],
                                                  [v4.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
                                                  [v4.centerYAnchor constraintEqualToAnchor:v2.centerYAnchor]
                                                  ]];
        
        
        [NSLayoutConstraint activateConstraints:@[[v5.leftAnchor constraintEqualToAnchor:containerView.leftAnchor constant:20],
                                                  [v5.rightAnchor constraintEqualToAnchor:containerView.rightAnchor constant:-20],
                                                  [v5.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:20],
                                                  [v5.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-20]
                                                  ]];
        
        
        
        [NSLayoutConstraint activateConstraints:@[[v6.widthAnchor constraintEqualToAnchor:v5.heightAnchor],
                                                  [v6.heightAnchor constraintEqualToAnchor:v5.widthAnchor],
                                                  [v6.centerYAnchor constraintEqualToAnchor:v2.bottomAnchor],
                                                  [v6.rightAnchor constraintEqualToAnchor:v1.rightAnchor]
                                                  ]];
        
        
        
        [NSLayoutConstraint activateConstraints:@[[v7.widthAnchor constraintEqualToConstant:40],
                                                  [v7.heightAnchor constraintEqualToConstant:40],
                                                  [v7.bottomAnchor constraintEqualToAnchor:v4.topAnchor],
                                                  [v7.leftAnchor constraintEqualToAnchor:v5.rightAnchor]
                                                  ]];
        
        
        [NSLayoutConstraint activateConstraints:@[[v8.widthAnchor constraintEqualToAnchor:v1.widthAnchor],
                                                  [v8.heightAnchor constraintEqualToAnchor:containerView.heightAnchor multiplier:0.4],
                                                  [v8.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor],
                                                  [v8.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor]
                                                  ]];
        
        
        
        
        [NSLayoutConstraint activateConstraints:@[[v9.widthAnchor constraintEqualToAnchor:v3.widthAnchor],
                                                  [v9.heightAnchor constraintEqualToAnchor:v4.heightAnchor],
                                                  [v9.bottomAnchor constraintEqualToAnchor:v5.bottomAnchor],
                                                  [v9.rightAnchor constraintEqualToAnchor:v6.rightAnchor]
                                                  ]];
        
        
        
        
        
        [NSLayoutConstraint activateConstraints:@[[v10.widthAnchor constraintEqualToAnchor:containerView.widthAnchor],
                                                  [v10.heightAnchor constraintEqualToAnchor:containerView.heightAnchor],
                                                  [v10.leftAnchor constraintEqualToAnchor:containerView.leftAnchor],
                                                  [v10.topAnchor constraintEqualToAnchor:containerView.topAnchor]
                                                  ]];
        
        
        
    }
    
    return containerView;
    
}



-(UIView*)relativelayout_createMasonry
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
  /*  for (int i = 0; i < self.counts/10; i++)
    {
        
        UIView *v10 = [UIView new];
        [containerView addSubview:v10];
        
        UIView *v9 = [UIView new];
        [containerView addSubview:v9];
        
        UIView *v8 = [UIView new];
        [containerView addSubview:v8];
        
        UIView *v7 = [UIView new];
        [containerView addSubview:v7];
        
        UIView *v6 = [UIView new];
        [containerView addSubview:v6];
        
        UIView *v5 = [UIView new];
        [containerView addSubview:v5];
        
        UIView *v4 = [UIView new];
        [containerView addSubview:v4];
        
        UIView *v3 = [UIView new];
        [containerView addSubview:v3];
        
        UIView *v2 = [UIView new];
        [containerView addSubview:v2];
        
        UIView *v1 = [UIView new];
        [containerView addSubview:v1];
        
        
        
        [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(containerView.mas_top);
            make.left.equalTo(containerView.mas_left);
            make.width.height.equalTo(@20);
            
        }];
        
        
        [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(v1.mas_width).multipliedBy(2);
            make.height.equalTo(v1.mas_height).offset(10);
            make.top.equalTo(v1.mas_bottom);
            make.left.equalTo(v1.mas_right);
            
        }];
        
        
        [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(containerView.mas_width).multipliedBy(0.5);
            make.height.equalTo(@40);
            make.top.equalTo(v2.mas_bottom);
            make.left.equalTo(v2.mas_right);
            
        }];
        
        
        
        [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.equalTo(@40);
            make.height.equalTo(v4.mas_width);
            make.centerX.equalTo(@0);
            make.centerY.equalTo(v2.mas_centerY);
            
        }];
        
        
        [v5 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(@20);
        }];
        
        
        [v6 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(v5.mas_height);
            make.height.equalTo(v5.mas_width);
            make.right.equalTo(v1.mas_right);
            make.centerY.equalTo(v2.mas_bottom);
            
        }];
        
        
        
        [v7 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.equalTo(@40);
            make.left.equalTo(v5.mas_right);
            make.bottom.equalTo(v4.mas_top);
        }];
        
        
        
        [v8 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(v1.mas_width);
            make.height.equalTo(containerView.mas_height).multipliedBy(0.4);
            make.centerX.centerY.equalTo(@0);
            
        }];
        
        
        [v9 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(v3.mas_width);
            make.height.equalTo(v4.mas_height);
            make.bottom.equalTo(v5.mas_bottom);
            make.right.equalTo(v6.mas_right);
            
        }];
        
        
        
        [v10 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(@0);
        }];
        
        
    }
    */
    return containerView;
}



#pragma mark -- FrameLayout

-(UIView*)framelayout_createFrame
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    for (int i = 0; i < self.counts/10; i++)
    {
        UIView *topLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [containerView addSubview:topLeft];
        
        UIView *topCenter = [[UIView alloc] initWithFrame:CGRectMake((100 - 20)/2, 0, 20, 20)];
        [containerView addSubview:topCenter];
        
        UIView *topRight = [[UIView alloc] initWithFrame:CGRectMake((100 - 20), 0, 20, 20)];
        [containerView addSubview:topRight];
        
        
        UIView *centerLeft = [[UIView alloc] initWithFrame:CGRectMake(0, (100-20)/2, 20, 20)];
        [containerView addSubview:centerLeft];
        
        UIView *centerCenter = [[UIView alloc] initWithFrame:CGRectMake((100-20)/2, (100 - 20)/2, 20, 20)];
        [containerView addSubview:centerCenter];
        
        UIView *centerRight = [[UIView alloc] initWithFrame:CGRectMake(100-20,(100 - 20)/2, 20, 20)];
        [containerView addSubview:centerRight];
        
        
        UIView *bottomLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 100-20, 20, 20)];
        [containerView addSubview:bottomLeft];
        
        UIView *bottomCenter = [[UIView alloc] initWithFrame:CGRectMake((100-20)/2, 100 - 20, 20, 20)];
        [containerView addSubview:bottomCenter];
        
        UIView *bottomRight = [[UIView alloc] initWithFrame:CGRectMake(100-20,100 - 20, 20, 20)];
        [containerView addSubview:bottomRight];
        
        UIView *fill = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
        [containerView addSubview:fill];
        
    }
    
    return containerView;
}

-(UIView*)framelayout_createMyLayout
{
    MyFrameLayout *containerView = [[MyFrameLayout alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    for (int i = 0; i < self.counts/10; i++)
    {
        UIView *topLeft = [UIView new];
        [containerView addSubview:topLeft];
        topLeft.mySize = CGSizeMake(20, 20);
        topLeft.myLeft = 0;
        topLeft.myTop = 0;
        
        
        UIView *topCenter = [UIView new];
        [containerView addSubview:topCenter];
        topCenter.mySize = CGSizeMake(20, 20);
        topCenter.myCenterX = 0;
        topCenter.myTop = 0;
        
        
        UIView *topRight = [UIView new];
        [containerView addSubview:topRight];
        topRight.mySize = CGSizeMake(20, 20);
        topRight.myRight = 0;
        topRight.myTop = 0;
        
        
        
        UIView *centerLeft = [UIView new];
        [containerView addSubview:centerLeft];
        centerLeft.mySize = CGSizeMake(20, 20);
        centerLeft.myLeft = 0;
        centerLeft.myCenterY = 0;
        
        UIView *centerCenter = [UIView new];
        [containerView addSubview:centerCenter];
        centerCenter.mySize = CGSizeMake(20, 20);
        centerCenter.myCenterX = 0;
        centerCenter.myCenterY = 0;
        
        
        UIView *centerRight = [UIView new];
        [containerView addSubview:centerRight];
        centerRight.mySize = CGSizeMake(20, 20);
        centerRight.myRight = 0;
        centerRight.myCenterY = 0;
        
        
        
        UIView *bottomLeft = [UIView new];
        [containerView addSubview:bottomLeft];
        bottomLeft.mySize = CGSizeMake(20, 20);
        bottomLeft.myLeft = 0;
        bottomLeft.myBottom = 0;
        
        
        
        
        UIView *bottomCenter = [UIView new];
        [containerView addSubview:bottomCenter];
        bottomCenter.mySize = CGSizeMake(20, 20);
        bottomCenter.myCenterX = 0;
        bottomCenter.myBottom = 0;
        
        
        UIView *bottomRight = [UIView new];
        [containerView addSubview:bottomRight];
        bottomRight.mySize = CGSizeMake(20, 20);
        bottomRight.myRight = 0;
        bottomRight.myBottom = 0;
        
        
        
        
        UIView *fill = [UIView new];
        [containerView addSubview:fill];
        fill.myMargin = 0;
        
    }
    
    return containerView;
}

-(UIView*)framelayout_createAutoLayout
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    for (int i = 0; i < self.counts/10; i++)
    {
        UIView *topLeft = [UIView new];
        topLeft.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:topLeft];
        [NSLayoutConstraint activateConstraints:@[[topLeft.widthAnchor constraintEqualToConstant:20],
                                                  [topLeft.heightAnchor constraintEqualToConstant:20],
                                                  [topLeft.topAnchor constraintEqualToAnchor:containerView.topAnchor],
                                                  [topLeft.leftAnchor constraintEqualToAnchor:containerView.leftAnchor]
                                                  ]];
        
        UIView *topCenter = [UIView new];
        topCenter.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:topCenter];
        [NSLayoutConstraint activateConstraints:@[[topCenter.widthAnchor constraintEqualToConstant:20],
                                                  [topCenter.heightAnchor constraintEqualToConstant:20],
                                                  [topCenter.topAnchor constraintEqualToAnchor:containerView.topAnchor],
                                                  [topCenter.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor]
                                                  ]];
        
        
        UIView *topRight = [UIView new];
        topRight.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:topRight];
        [NSLayoutConstraint activateConstraints:@[[topRight.widthAnchor constraintEqualToConstant:20],
                                                  [topRight.heightAnchor constraintEqualToConstant:20],
                                                  [topRight.topAnchor constraintEqualToAnchor:containerView.topAnchor],
                                                  [topRight.rightAnchor constraintEqualToAnchor:containerView.rightAnchor]
                                                  ]];
        
        
        UIView *centerLeft = [UIView new];
        centerLeft.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:centerLeft];
        [NSLayoutConstraint activateConstraints:@[[centerLeft.widthAnchor constraintEqualToConstant:20],
                                                  [centerLeft.heightAnchor constraintEqualToConstant:20],
                                                  [centerLeft.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor],
                                                  [centerLeft.leftAnchor constraintEqualToAnchor:containerView.leftAnchor]
                                                  ]];
        
        
        UIView *centerCenter = [UIView new];
        centerCenter.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:centerCenter];
        [NSLayoutConstraint activateConstraints:@[[centerCenter.widthAnchor constraintEqualToConstant:20],
                                                  [centerCenter.heightAnchor constraintEqualToConstant:20],
                                                  [centerCenter.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor],
                                                  [centerCenter.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor]
                                                  ]];
        
        
        UIView *centerRight = [UIView new];
        centerRight.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:centerRight];
        [NSLayoutConstraint activateConstraints:@[[centerRight.widthAnchor constraintEqualToConstant:20],
                                                  [centerRight.heightAnchor constraintEqualToConstant:20],
                                                  [centerRight.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor],
                                                  [centerRight.rightAnchor constraintEqualToAnchor:containerView.rightAnchor]
                                                  ]];
        
        
        
        UIView *bottomLeft = [UIView new];
        bottomLeft.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:bottomLeft];
        [NSLayoutConstraint activateConstraints:@[[bottomLeft.widthAnchor constraintEqualToConstant:20],
                                                  [bottomLeft.heightAnchor constraintEqualToConstant:20],
                                                  [bottomLeft.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
                                                  [bottomLeft.leftAnchor constraintEqualToAnchor:containerView.leftAnchor]
                                                  ]];
        
        
        UIView *bottomCenter = [UIView new];
        bottomCenter.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:bottomCenter];
        [NSLayoutConstraint activateConstraints:@[[bottomCenter.widthAnchor constraintEqualToConstant:20],
                                                  [bottomCenter.heightAnchor constraintEqualToConstant:20],
                                                  [bottomCenter.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
                                                  [bottomCenter.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor]
                                                  ]];
        
        
        
        UIView *bottomRight = [UIView new];
        bottomRight.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:bottomRight];
        [NSLayoutConstraint activateConstraints:@[[bottomRight.widthAnchor constraintEqualToConstant:20],
                                                  [bottomRight.heightAnchor constraintEqualToConstant:20],
                                                  [bottomRight.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
                                                  [bottomRight.rightAnchor constraintEqualToAnchor:containerView.rightAnchor]
                                                  ]];
        
        
        
        
        UIView *fill = [UIView new];
        fill.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:fill];
        [NSLayoutConstraint activateConstraints:@[[fill.widthAnchor constraintEqualToAnchor:containerView.widthAnchor],
                                                  [fill.heightAnchor constraintEqualToAnchor:containerView.heightAnchor],
                                                  [fill.leftAnchor constraintEqualToAnchor:containerView.leftAnchor],
                                                  [fill.topAnchor constraintEqualToAnchor:containerView.topAnchor]
                                                  ]];
        
        
        
    }
    
    return containerView;
    
}


-(UIView*)framelayout_createMasonry
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
   /*
    for (int i = 0; i < self.counts/10; i++)
    {
        UIView *topLeft = [UIView new];
        [containerView addSubview:topLeft];
        [topLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(containerView.mas_top);
            make.left.equalTo(containerView.mas_left);
            make.width.height.equalTo(@20);
            
        }];
        
        
        UIView *topCenter = [UIView new];
        [containerView addSubview:topCenter];
        [topCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(containerView.mas_top);
            make.centerX.equalTo(containerView.mas_centerX);
            make.width.height.equalTo(@20);
            
        }];
        
        
        UIView *topRight = [UIView new];
        [containerView addSubview:topRight];
        [topRight mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(containerView.mas_top);
            make.right.equalTo(containerView.mas_right);
            make.width.height.equalTo(@20);
            
        }];
        
        
        
        UIView *centerLeft = [UIView new];
        [containerView addSubview:centerLeft];
        [centerLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(containerView.mas_centerY);
            make.left.equalTo(containerView.mas_left);
            make.width.height.equalTo(@20);
            
        }];
        
        
        UIView *centerCenter = [UIView new];
        [containerView addSubview:centerCenter];
        [centerCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(containerView.mas_centerY);
            make.centerX.equalTo(containerView.mas_centerX);
            make.width.height.equalTo(@20);
            
        }];
        
        
        UIView *centerRight = [UIView new];
        [containerView addSubview:centerRight];
        [centerRight mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(containerView.mas_centerY);
            make.right.equalTo(containerView.mas_right);
            make.width.height.equalTo(@20);
            
        }];
        
        
        
        UIView *bottomLeft = [UIView new];
        [containerView addSubview:bottomLeft];
        [bottomLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(containerView.mas_bottom);
            make.left.equalTo(containerView.mas_left);
            make.width.height.equalTo(@20);
            
        }];
        
        
        
        UIView *bottomCenter = [UIView new];
        [containerView addSubview:bottomCenter];
        [bottomCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(containerView.mas_bottom);
            make.centerX.equalTo(containerView.mas_centerX);
            make.width.height.equalTo(@20);
            
        }];
        
        
        UIView *bottomRight = [UIView new];
        [containerView addSubview:bottomRight];
        [bottomRight mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(containerView.mas_bottom);
            make.right.equalTo(containerView.mas_right);
            make.width.height.equalTo(@20);
            
        }];
        
        
        
        
        
        UIView *fill = [UIView new];
        [containerView addSubview:fill];
        [fill mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(@0);
        }];
        
        
    }
    */
    
    return containerView;
}

//构建！！！


#pragma mark -- FlowLayout

-(UIView*)flowlayout_createFrame
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    CGFloat top = 0;
    for (int i = 0; i < self.counts/5; i++)
    {
        CGFloat left = 0;
        for (int j = 0; j < 5; j++)
        {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(left, top, 20, 20)];
            [containerView addSubview:v];
            
            left += 20;
        }
        top += 20;
    }
    
    return containerView;
}

-(UIView*)flowlayout_createMyLayout
{
    MyFlowLayout *containerView = [[MyFlowLayout alloc] initWithFrame:CGRectMake(0, 0, 100, 100) orientation:MyOrientation_Vert arrangedCount:5];
    
    for (int i = 0; i < self.counts; i++)
    {
        UIView *v = [UIView new];
        [containerView addSubview:v];
        v.mySize = CGSizeMake(20, 20);
    }
    
    return containerView;
}

-(UIView*)flowlayout_createAutoLayout
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    NSLayoutYAxisAnchor *top = containerView.topAnchor;
    for (int i = 0; i < self.counts/5; i++)
    {
        NSLayoutXAxisAnchor *left = containerView.leftAnchor;
        for (int j = 0; j < 5;j++)
        {
            UIView *v = [UIView new];
            v.translatesAutoresizingMaskIntoConstraints = NO;
            [containerView addSubview:v];
            [NSLayoutConstraint activateConstraints:@[[v.widthAnchor constraintEqualToConstant:20],
                                                      [v.heightAnchor constraintEqualToConstant:20],
                                                      [v.topAnchor constraintEqualToAnchor:top],
                                                      [v.leftAnchor constraintEqualToAnchor:left]
                                                      ]];
            
            left = v.rightAnchor;
        }
        
        top = containerView.subviews.lastObject.bottomAnchor;
        
    }
    
    return containerView;
    
}



-(UIView*)flowlayout_createMasonry
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    /*
    MASViewAttribute *top = containerView.mas_top;
    for (int i = 0; i < self.counts/5; i++)
    {
        MASViewAttribute *left = containerView.mas_left;
        for (int j = 0; j < 5; j++)
        {
            UIView *v = [UIView new];
            [containerView addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(@20);
                make.height.equalTo(@20);
                make.left.equalTo(left);
                make.top.equalTo(top);
                
            }];
            
            left = v.mas_right;
            
        }
        
        top = containerView.subviews.lastObject.mas_bottom;
        
    }
    */
    return containerView;
}


//构建！！！



#pragma mark -- FloatLayout

-(UIView*)floatlayout_createFrame
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    CGFloat top = 0;
    for (int i = 0; i < self.counts/5; i++)
    {
        CGFloat left = 0;
        for (int j = 0; j < 5; j++)
        {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(left, top, 20, 20)];
            [containerView addSubview:v];
            
            left += 20;
        }
        top += 20;
    }
    
    return containerView;
}

-(UIView*)floatlayout_createMyLayout
{
    
    MyFloatLayout *containerView = [[MyFloatLayout alloc] initWithFrame:CGRectMake(0, 0, 100, 100) orientation:MyOrientation_Vert];
    
    for (int i = 0; i < self.counts/5; i++)
    {
        UIView *v = [UIView new];
        [containerView addSubview:v];
        v.mySize = CGSizeMake(20, 20);
        
        v = [UIView new];
        [containerView addSubview:v];
        v.mySize = CGSizeMake(20, 20);
        
        v = [UIView new];
        [containerView addSubview:v];
        v.mySize = CGSizeMake(20, 20);
        
        v = [UIView new];
        [containerView addSubview:v];
        v.reverseFloat = YES;
        v.mySize = CGSizeMake(20, 20);
        
        v = [UIView new];
        [containerView addSubview:v];
        v.reverseFloat = YES;
        v.mySize = CGSizeMake(20, 20);
    }
    
    return containerView;
}

-(UIView*)floatlayout_createAutoLayout
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    NSLayoutYAxisAnchor *top = containerView.topAnchor;
    for (int i = 0; i < self.counts/5; i++)
    {
        UIView *v1 = [UIView new];
        v1.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v1];
        [NSLayoutConstraint activateConstraints:@[[v1.widthAnchor constraintEqualToConstant:20],
                                                  [v1.heightAnchor constraintEqualToConstant:20],
                                                  [v1.topAnchor constraintEqualToAnchor:top],
                                                  [v1.leftAnchor constraintEqualToAnchor:containerView.leftAnchor]
                                                  ]];
        
        UIView *v2 = [UIView new];
        v2.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v2];
        [NSLayoutConstraint activateConstraints:@[[v2.widthAnchor constraintEqualToConstant:20],
                                                  [v2.heightAnchor constraintEqualToConstant:20],
                                                  [v2.topAnchor constraintEqualToAnchor:top],
                                                  [v2.leftAnchor constraintEqualToAnchor:v1.rightAnchor]
                                                  ]];
        
        
        UIView *v3 = [UIView new];
        v3.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v3];
        [NSLayoutConstraint activateConstraints:@[[v3.widthAnchor constraintEqualToConstant:20],
                                                  [v3.heightAnchor constraintEqualToConstant:20],
                                                  [v3.topAnchor constraintEqualToAnchor:top],
                                                  [v3.leftAnchor constraintEqualToAnchor:v2.rightAnchor]
                                                  ]];
        
        
        UIView *v4 = [UIView new];
        v4.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v4];
        [NSLayoutConstraint activateConstraints:@[[v4.widthAnchor constraintEqualToConstant:20],
                                                  [v4.heightAnchor constraintEqualToConstant:20],
                                                  [v4.topAnchor constraintEqualToAnchor:top],
                                                  [v4.rightAnchor constraintEqualToAnchor:containerView.rightAnchor]
                                                  ]];
        
        
        UIView *v5 = [UIView new];
        v5.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:v5];
        [NSLayoutConstraint activateConstraints:@[[v5.widthAnchor constraintEqualToConstant:20],
                                                  [v5.heightAnchor constraintEqualToConstant:20],
                                                  [v5.topAnchor constraintEqualToAnchor:top],
                                                  [v5.rightAnchor constraintEqualToAnchor:v4.leftAnchor]
                                                  ]];
        
        top = v1.bottomAnchor;
        
    }
    
    return containerView;
    
}


-(UIView*)floatlayout_createMasonry
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
   /*
    MASViewAttribute *top = containerView.mas_top;
    for (int i = 0; i < self.counts/5; i++)
    {
        
        
        UIView *v1 = [UIView new];
        [containerView addSubview:v1];
        [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.left.equalTo(containerView.mas_left);
            make.top.equalTo(top);
            
        }];
        
        UIView *v2 = [UIView new];
        [containerView addSubview:v2];
        [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.left.equalTo(v1.mas_right);
            make.top.equalTo(top);
            
        }];
        
        UIView *v3 = [UIView new];
        [containerView addSubview:v3];
        [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.left.equalTo(v2.mas_right);
            make.top.equalTo(top);
            
        }];
        
        
        UIView *v4 = [UIView new];
        [containerView addSubview:v4];
        [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.right.equalTo(containerView.mas_right);
            make.top.equalTo(top);
            
        }];
        
        
        UIView *v5 = [UIView new];
        [containerView addSubview:v5];
        [v5 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.right.equalTo(v4.mas_left);
            make.top.equalTo(top);
            
        }];
        
        
        top = v1.mas_bottom;
    }
    */
    return containerView;
}

/*
- (void)testPerformance_relativelayout_createMasonry {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self relativelayout_createMasonry];
        
    }];
}

- (void)testPerformance_relativelayout_layoutFrame {
    // This is an example of a performance test case.
    
    UIView * v = [self relativelayout_createFrame];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [v setNeedsLayout];
        [v layoutIfNeeded];
    }];
}



- (void)testPerformance_relativelayout_layoutMasonry {
    // This is an example of a performance test case.
    
    UIView *v = [self relativelayout_createMasonry];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}


- (void)testPerformance_framelayout_createMasonry {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self framelayout_createMasonry];
        
    }];
}

- (void)testPerformance_framelayout_layoutFrame {
    // This is an example of a performance test case.
    
    UIView * v = [self framelayout_createFrame];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [v setNeedsLayout];
        [v layoutIfNeeded];
    }];
}



- (void)testPerformance_framelayout_layoutMasonry {
    // This is an example of a performance test case.
    
    UIView *v = [self framelayout_createMasonry];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}



- (void)testPerformance_flowlayout_createMasonry {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self flowlayout_createMasonry];
        
    }];
}

//布局
- (void)testPerformance_flowlayout_layoutFrame {
    // This is an example of a performance test case.
    
    UIView * v = [self flowlayout_createFrame];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [v setNeedsLayout];
        [v layoutIfNeeded];
    }];
}


- (void)testPerformance_flowlayout_layoutMasonry {
    // This is an example of a performance test case.
    
    UIView *v = [self flowlayout_createMasonry];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}


- (void)testPerformance_floatlayout_createMasonry {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self floatlayout_createMasonry];
        
    }];
}

//布局
- (void)testPerformance_floatlayout_layoutFrame {
    // This is an example of a performance test case.
    
    UIView * v = [self floatlayout_createFrame];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [v setNeedsLayout];
        [v layoutIfNeeded];
    }];
}


- (void)testPerformance_floatlayout_layoutMasonry {
    // This is an example of a performance test case.
    
    UIView *v = [self floatlayout_createMasonry];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}


- (void)testPerformance_linearlayout_createMasonry {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self linearlayout_createMasonry];
        
    }];
}


//布局
- (void)testPerformance_linearlayout_layoutFrame {
    // This is an example of a performance test case.
    
    UIView * v = [self linearlayout_createFrame];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [v setNeedsLayout];
        [v layoutIfNeeded];
    }];
}

- (void)testPerformance_linearlayout_layoutMasonry {
    // This is an example of a performance test case.
    
    UIView *v = [self linearlayout_createMasonry];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}
*/

//构建！！！

- (void)testPerformance_relativelayout_createFrame {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self relativelayout_createFrame];
    }];
}


- (void)testPerformance_relativelayout_createMyLayout {
    
    
    [self measureBlock:^{
        
        [self relativelayout_createMyLayout];
        
    }];
}




- (void)testPerformance_relativelayout_createAutolayout {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self relativelayout_createAutoLayout];
        
    }];
}






//布局

- (void)testPerformance_relativelayout_layoutMyLayout {
    
    UIView *v = [self relativelayout_createMyLayout];
    
    [self measureBlock:^{
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}





- (void)testPerformance_relativelayout_layoutAutolayout {
    // This is an example of a performance test case.
    
    UIView *v = [self relativelayout_createAutoLayout];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}




- (void)testPerformance_framelayout_createFrame {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self framelayout_createFrame];
    }];
}

- (void)testPerformance_framelayout_createMyLayout {
    
    
    [self measureBlock:^{
        
        [self framelayout_createMyLayout];
        
    }];
}



- (void)testPerformance_framelayout_createAutolayout {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self framelayout_createAutoLayout];
        
    }];
}



//布局


- (void)testPerformance_framelayout_layoutMyLayout {
    
    UIView *v = [self framelayout_createMyLayout];
    
    [self measureBlock:^{
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}


- (void)testPerformance_framelayout_layoutAutolayout {
    // This is an example of a performance test case.
    
    UIView *v = [self framelayout_createAutoLayout];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}




- (void)testPerformance_flowlayout_createFrame {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self flowlayout_createFrame];
    }];
}

- (void)testPerformance_flowlayout_createMyLayout {
    
    
    [self measureBlock:^{
        
        [self flowlayout_createMyLayout];
        
    }];
}



- (void)testPerformance_flowlayout_createAutolayout {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self flowlayout_createAutoLayout];
        
    }];
}




- (void)testPerformance_flowlayout_layoutMyLayout {
    
    UIView *v = [self flowlayout_createMyLayout];
    
    [self measureBlock:^{
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}



- (void)testPerformance_flowlayout_layoutAutolayout {
    // This is an example of a performance test case.
    
    UIView *v = [self flowlayout_createAutoLayout];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}




- (void)testPerformance_floatlayout_createFrame {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self floatlayout_createFrame];
    }];
}

- (void)testPerformance_floatlayout_createMyLayout {
    
    
    [self measureBlock:^{
        
        [self floatlayout_createMyLayout];
        
    }];
}



- (void)testPerformance_floatlayout_createAutolayout {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self floatlayout_createAutoLayout];
        
    }];
}





- (void)testPerformance_floatlayout_layoutMyLayout {
    
    UIView *v = [self floatlayout_createMyLayout];
    
    [self measureBlock:^{
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}




- (void)testPerformance_floatlayout_layoutAutolayout {
    // This is an example of a performance test case.
    
    UIView *v = [self floatlayout_createAutoLayout];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}



- (void)testPerformance_linearlayout_createFrame {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self linearlayout_createFrame];
    }];
}

- (void)testPerformance_linearlayout_createMyLayout {
    
    
    [self measureBlock:^{
        
        [self linearlayout_createMyLayout];
        
    }];
}


- (void)testPerformance_linearlayout_createAutolayout {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self linearlayout_createAutoLayout];
        
    }];
}






- (void)testPerformance_linearlayout_createUIStackView {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [self linearlayout_createUIStackView];
        
    }];
}



- (void)testPerformance_linearlayout_layoutMyLayout {
    
    UIView *v = [self linearlayout_createMyLayout];
    
    [self measureBlock:^{
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}




- (void)testPerformance_linearlayout_layoutAutolayout {
    // This is an example of a performance test case.
    
    UIView *v = [self linearlayout_createAutoLayout];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}






- (void)testPerformance_linearlayout_layoutUIStackView {
    // This is an example of a performance test case.
    
    UIView *v = [self linearlayout_createUIStackView];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        [v setNeedsLayout];
        [v layoutIfNeeded];
        
    }];
}



@end

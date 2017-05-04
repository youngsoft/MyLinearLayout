//
//  MyRelativeLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"
#import "RLTest1ViewController.h"


@interface MyRelativeLayoutTestCase : MyLayoutTestCaseBase

@property(nonatomic,strong) RLTest1ViewController *vc;

@end

@implementation MyRelativeLayoutTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.vc = [RLTest1ViewController new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.vc = nil;
    [super tearDown];
}

-(void)testRLTest1VC
{
    
    UIView *v = self.vc.view;
    [self startClock];
    [v layoutIfNeeded];
    [self endClock:@"RLTest1"];
    
    
}

- (void)testHidden {
    
    //测试子视图隐藏的布局变更
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.wrapContentHeight = YES;
    
    UILabel *shopNameLabel = [UILabel new];
    shopNameLabel.topPos.equalTo(rootLayout.topPos).offset(10);
    shopNameLabel.centerXPos.equalTo(@0);
    shopNameLabel.mySize = CGSizeMake(80, 20);
    [rootLayout addSubview:shopNameLabel];
    
    
    UILabel *userTimeLabel = [UILabel new];
    userTimeLabel.topPos.equalTo(shopNameLabel.bottomPos).offset(5);
    userTimeLabel.centerXPos.equalTo(@0);
    userTimeLabel.mySize = CGSizeMake(100, 30);
    [rootLayout addSubview:userTimeLabel];
    
    
    UILabel *moneyLable = [UILabel new];
      moneyLable.topPos.equalTo(userTimeLabel.bottomPos).offset(15);
    moneyLable.leftPos.equalTo(rootLayout.leftPos).offset(15);
    moneyLable.mySize = CGSizeMake(80, 80);
    [rootLayout addSubview:moneyLable];
    
    
    UILabel *numberLabel = [UILabel new];
    numberLabel.bottomPos.equalTo(rootLayout.bottomPos).offset(15);
    numberLabel.rightPos.equalTo(rootLayout.rightPos).offset(15);
    numberLabel.mySize = CGSizeMake(60, 30);
    [rootLayout addSubview:numberLabel];
    
    
    UILabel *descLabel = [UILabel new];
    descLabel.bottomPos.equalTo(rootLayout.bottomPos).offset(15);
    descLabel.rightPos.equalTo(numberLabel.leftPos).offset(15);
    descLabel.mySize = CGSizeMake(100, 20);
    [rootLayout addSubview:descLabel];
    
    
   CGRect rect1 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect1, CGRectMake(0,0,320, 180)), @"rect1 is:%@", NSStringFromCGRect(rect1));
    XCTAssertTrue(CGRectEqualToRect(descLabel.estimatedRect, CGRectMake(120,135,100, 20)), @"descLabel rect is:%@", NSStringFromCGRect(descLabel.estimatedRect));
    
    
    numberLabel.hidden = YES;
    
    CGRect rect2 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    
    XCTAssertTrue(CGRectEqualToRect(rect2, CGRectMake(0,0,320, 180)), @"rect2 is:%@", NSStringFromCGRect(rect2));
    XCTAssertTrue(CGRectEqualToRect(descLabel.estimatedRect, CGRectMake(195,135,100, 20)), @"descLabel rect is:%@", NSStringFromCGRect(descLabel.estimatedRect));
    
}

-(void)testWrapContentHeight1
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.wrapContentHeight = YES;
    rootLayout.bottomPadding = 20;
    rootLayout.topPadding = 10;
    rootLayout.leadingPadding = 10;
    rootLayout.trailingPadding = 10;
    
    
    CGRect rect0 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect0, CGRectMake(0,0,320, 30)), @"rect0 is:%@", NSStringFromCGRect(rect0));


    UILabel *titleLabel = [UILabel new];
    titleLabel.text=@"你发我抢 > 未付款";
    titleLabel.mySize = CGSizeMake(90, 20);
    titleLabel.leftPos.equalTo(rootLayout.leftPos).offset(10);
    [rootLayout addSubview:titleLabel];
    
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text=@"配送中 > ";
    rightLabel.mySize = CGSizeMake(45, 20);
    rightLabel.rightPos.equalTo(rootLayout.rightPos).offset(1);
    [rootLayout addSubview:rightLabel];
    
    titleLabel.rightPos.equalTo(rightLabel.leftPos).offset(10);
    
    
    
    UILabel *allMoneyLabel = [UILabel new];
    allMoneyLabel.text=@"¥ 1000.00";
    allMoneyLabel.mySize = CGSizeMake(45, 20);
    allMoneyLabel.topPos.equalTo(rightLabel.bottomPos).offset(5);
    allMoneyLabel.rightPos.equalTo(rootLayout.rightPos).offset(5);
    [rootLayout addSubview:allMoneyLabel];
    
    
    
    UILabel *orderNumberLabel = [UILabel new];
    orderNumberLabel.text=@"订单号: 12121212122121";
    orderNumberLabel.mySize = CGSizeMake(100, 20);
    orderNumberLabel.topPos.equalTo(titleLabel.bottomPos).offset(5);
    orderNumberLabel.leftPos.equalTo(titleLabel.leftPos);
    orderNumberLabel.rightPos.equalTo(allMoneyLabel.leftPos).offset(0);
     [rootLayout addSubview:orderNumberLabel];
    
    
    UILabel *orderTimeLabel= [UILabel new];
    orderTimeLabel.text=@"下单时间: 2016-10-10";
    orderTimeLabel.mySize = CGSizeMake(90, 20);
    orderTimeLabel.topPos.equalTo(orderNumberLabel.bottomPos).offset(5);
    orderTimeLabel.leftPos.equalTo(titleLabel.leftPos);
    orderTimeLabel.rightPos.equalTo(allMoneyLabel.rightPos).offset(0);
    [rootLayout addSubview:orderTimeLabel];
    
    UILabel *orderLabel = [UILabel new];
    orderLabel.text=@"订单描述:";
    orderLabel.mySize = CGSizeMake(40, 20);
    orderLabel.topPos.equalTo(orderTimeLabel.bottomPos).offset(5);
    orderLabel.leftPos.equalTo(titleLabel.leftPos);
    [rootLayout addSubview:orderLabel];
    
    //125
    
    MyLinearLayout * lineLayout=[[MyLinearLayout alloc]initWithOrientation:MyOrientation_Vert];
    lineLayout.wrapContentHeight=YES;
    lineLayout.wrapContentWidth=NO;
    lineLayout.topPos.equalTo(orderLabel.bottomPos).offset(5);
    lineLayout.myLeft=lineLayout.myRight=10;
    [rootLayout addSubview:lineLayout];
    
  //130
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.text=@"期望时间 10分钟:";
    timeLabel.tag = 1234;
    timeLabel.mySize = CGSizeMake(80, 20);
    timeLabel.topPos.equalTo(lineLayout.bottomPos).offset(10);
    timeLabel.leftPos.equalTo(titleLabel.leftPos);
    [rootLayout addSubview:timeLabel];
    
  
    CGRect rect1 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect1, CGRectMake(0,0,320, 160)), @"rect1 is:%@", NSStringFromCGRect(rect1));
    
    UILabel *noteLabel = [UILabel new];
    noteLabel.mySize = CGSizeMake(100, 30);
    [lineLayout addSubview:noteLabel];
    
    CGRect rect2 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect2, CGRectMake(0,0,320, 190)), @"rect2 is:%@", NSStringFromCGRect(rect2));
    
    
    [noteLabel removeFromSuperview];
    
    for (int i = 0; i < 3; i++)
    {
       MyLinearLayout  *horzLayout=[[MyLinearLayout alloc]initWithOrientation:MyOrientation_Horz];
        horzLayout.wrapContentHeight=YES;
        horzLayout.wrapContentWidth=NO;
        horzLayout.myLeft=horzLayout.myRight=0;
        
        UILabel *v1 = [UILabel new];
        v1.text = @"v1";
        v1.mySize = CGSizeMake(200, 20);
        [horzLayout addSubview:v1];
        
        UILabel *v2 = [UILabel new];
        v2.text = @"v2";
        v2.myLeft = 0.5;
        v2.myRight = 0.5;
        v2.mySize = CGSizeMake(40, 30);
        [horzLayout addSubview:v2];
        
        UILabel *v3 = [UILabel new];
        v3.text = @"v3";
        v3.weight=1;
        v3.mySize = CGSizeMake(60, 25);
        [horzLayout addSubview:v3];
        [lineLayout addSubview:horzLayout];
    }
    
    
    timeLabel.hidden = YES;
    
    CGRect rect3 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect3, CGRectMake(0,0,320, 220)), @"rect3 is:%@", NSStringFromCGRect(rect3));
    
    
    UIButton *orderbutton=[UIButton new];
    orderbutton.widthSize.equalTo(rootLayout.widthSize).add(-20);
    [orderbutton setTitle:@"确认收货" forState:UIControlStateNormal];
    orderbutton.topPos.equalTo(timeLabel.bottomPos).offset(10);
    orderbutton.leftPos.equalTo(titleLabel.leftPos);
    orderbutton.mySize = CGSizeMake(50, 30);
    
    [rootLayout addSubview:orderbutton];
    
    UIButton *canclebutton=[UIButton new];
    canclebutton.widthSize.equalTo(rootLayout.widthSize).add(-20);
    [canclebutton setTitle:@"取消" forState:UIControlStateNormal];
    canclebutton.topPos.equalTo(orderbutton.bottomPos).offset(10);
    canclebutton.leftPos.equalTo(titleLabel.leftPos);
    canclebutton.mySize = CGSizeMake(50, 20);
    [rootLayout  addSubview:canclebutton];
    
    
    CGRect rect4 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect4, CGRectMake(0,0,320, 290)), @"rect4 is:%@", NSStringFromCGRect(rect4));
    
    
    timeLabel.hidden = NO;
    CGRect rect5 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect5, CGRectMake(0,0,320, 320)), @"rect5 is:%@", NSStringFromCGRect(rect5));
    
    orderbutton.hidden = YES;
    CGRect rect6 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect6, CGRectMake(0,0,320, 280)), @"rect6 is:%@", NSStringFromCGRect(rect6));
    
    
    orderbutton.hidden = NO;
    for (UIView *sbv in lineLayout.subviews)
    {
        [sbv removeFromSuperview];
    }
    CGRect rect7 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect7, CGRectMake(0,0,320, 230)), @"rect7 is:%@", NSStringFromCGRect(rect7));
    
    
    timeLabel.hidden = YES;
    orderbutton.hidden = YES;
    CGRect rect8 = [rootLayout estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect8, CGRectMake(0,0,320, 160)), @"rect8 is:%@", NSStringFromCGRect(rect8));

    

}

-(void)testWrapContentHeight2
{
    MyRelativeLayout *rootRelativeView = [MyRelativeLayout new];
    rootRelativeView.wrapContentHeight = YES;
    
    UIView *verticalLine = [UIView new];
    verticalLine.leftPos.equalTo(rootRelativeView.leftPos).offset(16);
    verticalLine.widthSize.equalTo(@1);
    verticalLine.heightSize.equalTo(rootRelativeView.heightSize);
    verticalLine.bottomPos.equalTo(rootRelativeView.bottomPos);
    [rootRelativeView addSubview:verticalLine];
    
    UIView *roundImageView = [[UIView alloc] init];
    roundImageView.topPos.equalTo(rootRelativeView.topPos).offset(8);
    roundImageView.centerXPos.equalTo(verticalLine.centerXPos);
    roundImageView.mySize = CGSizeMake(4, 4) ;
    [rootRelativeView addSubview:roundImageView];
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.topPos.equalTo(roundImageView.topPos);
    dateLabel.leftPos.equalTo(rootRelativeView.leftPos).offset(38);
    dateLabel.rightPos.equalTo(rootRelativeView.rightPos).offset(16);
    dateLabel.myHeight = 20;
    [rootRelativeView addSubview:dateLabel];
    
    UILabel *newsTitleLabel = [UILabel new];
    newsTitleLabel.wrapContentHeight = YES;
    newsTitleLabel.topPos.equalTo(dateLabel.bottomPos).offset(5);
    newsTitleLabel.leftPos.equalTo(dateLabel.leftPos);
    newsTitleLabel.rightPos.equalTo(dateLabel.rightPos);
    newsTitleLabel.bottomPos.equalTo(rootRelativeView.bottomPos).offset(8);
    [rootRelativeView addSubview:newsTitleLabel];
    
    CGRect rect1 = [rootRelativeView estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect1, CGRectMake(0,0,320, 41)), @"rect1 is:%@", NSStringFromCGRect(rect1));
    
    
    newsTitleLabel.text = @"aaaaaaaaaaaa";
    
    
    CGRect rect2 = [rootRelativeView estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect2, CGRectMake(0,0,320, 41 + [newsTitleLabel sizeThatFits:CGSizeMake(266, 0)].height)), @"rect2 is:%@", NSStringFromCGRect(rect2));
    
    
    newsTitleLabel.text = @"ajkhkahflkahfklahdflkajhdfalkjsdhflkajhdsflajsdhflaksdfhasdlhfjkashdfaasdfasdfasfd";
    
    
    CGRect rect3 = [rootRelativeView estimateLayoutRect:CGSizeMake(320, 0)];
    XCTAssertTrue(CGRectEqualToRect(rect3, CGRectMake(0,0,320, 41+[newsTitleLabel sizeThatFits:CGSizeMake(266, 0)].height)), @"rect3 is:%@", NSStringFromCGRect(rect3));

}

-(void)testWrapContentWidth1
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.wrapContentHeight = YES;
    rootLayout.wrapContentWidth = YES;
    rootLayout.bottomPadding = 20;
    rootLayout.topPadding = 10;
    rootLayout.leadingPadding = 10;
    rootLayout.trailingPadding = 10;
    
    
    XCTAssertTrue(CGRectEqualToRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)], CGRectMake(0,0,20, 30)), @"rect is:%@", NSStringFromCGRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)]));
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text=@"你发我抢 > 未付款";
    titleLabel.mySize = CGSizeMake(90, 20);
    titleLabel.leftPos.equalTo(rootLayout.leftPos).offset(10);
    [rootLayout addSubview:titleLabel];
    
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text=@"配送中 > ";
    rightLabel.mySize = CGSizeMake(45, 20);
    rightLabel.rightPos.equalTo(rootLayout.rightPos).offset(1);
    [rootLayout addSubview:rightLabel];
    
    titleLabel.rightPos.equalTo(rightLabel.leftPos).offset(10);
    
    
    XCTAssertTrue(CGRectEqualToRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)], CGRectMake(0,0,86, 50)), @"rect is:%@", NSStringFromCGRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)]));
    
    
    UILabel *allMoneyLabel = [UILabel new];
    allMoneyLabel.text=@"¥ 1000.00";
    allMoneyLabel.mySize = CGSizeMake(45, 20);
    allMoneyLabel.topPos.equalTo(rightLabel.bottomPos).offset(5);
    allMoneyLabel.rightPos.equalTo(rootLayout.rightPos).offset(5);
    [rootLayout addSubview:allMoneyLabel];
    
    
    
    UILabel *orderNumberLabel = [UILabel new];
    orderNumberLabel.text=@"订单号: 12121212122121";
    orderNumberLabel.mySize = CGSizeMake(100, 20);
    orderNumberLabel.topPos.equalTo(titleLabel.bottomPos).offset(5);
    orderNumberLabel.leftPos.equalTo(titleLabel.leftPos);
    orderNumberLabel.rightPos.equalTo(allMoneyLabel.leftPos).offset(0);
    [rootLayout addSubview:orderNumberLabel];
    
    
    UILabel *orderTimeLabel= [UILabel new];
    orderTimeLabel.text=@"下单时间: 2016-10-10";
    orderTimeLabel.mySize = CGSizeMake(90, 20);
    orderTimeLabel.topPos.equalTo(orderNumberLabel.bottomPos).offset(5);
    orderTimeLabel.leftPos.equalTo(titleLabel.leftPos);
    orderTimeLabel.rightPos.equalTo(allMoneyLabel.rightPos).offset(0);
    [rootLayout addSubview:orderTimeLabel];
    
    UILabel *orderLabel = [UILabel new];
    orderLabel.text=@"订单描述:";
    orderLabel.mySize = CGSizeMake(40, 20);
    orderLabel.topPos.equalTo(orderTimeLabel.bottomPos).offset(5);
    orderLabel.leftPos.equalTo(titleLabel.leftPos);
    [rootLayout addSubview:orderLabel];
    
    
    XCTAssertTrue(CGRectEqualToRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)], CGRectMake(0,0,86, 125)), @"rect is:%@", NSStringFromCGRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)]));
    
}

-(void)testWrapContentWidth2
{
    //A的宽度等于B的宽度。
    
    //A的左边等于B的左边
    //A的左边等于B的中间
    //A的左边等于B的右边
    
    //A的中间等于B的左边
    //A的中间等于B的中间
    //A的中间等于B的右边
    
    //A的右边等于B的左边
    //A的右边等于B的中间
    //A的右边等于B的右边。
    
    //A的两边等于B的两边。
    
    //这里里面B可以是父视图也可以是兄弟视图。
    
    //A的位置有9种。A的宽度有2种(固定宽度，以及依赖于另外一个视图的宽度)，这里就是18个视图。外加A的2的两边等于B的两边就是19个视图。
    
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.wrapContentWidth = YES;
    

    //随机生成N个数字保存到数组里面。
    CGFloat max = 0;
    NSMutableArray *numbers = [NSMutableArray arrayWithCapacity:40];
    for (int i = 0; i < 2; i++)
    {
        CGFloat num = (CGFloat)arc4random_uniform(100);
        if (num > max)
            max = num;
        
        [numbers addObject:@(num)];
    }
    
    //依赖父视图的约束。
    
    NSMutableArray *widths = [NSMutableArray new];
    [widths addObject:rootLayout.widthSize];
    [widths addObjectsFromArray:numbers];
    
    NSMutableArray *poss = [NSMutableArray new];
    [poss addObjectsFromArray:@[rootLayout.leftPos, rootLayout.centerXPos, rootLayout.rightPos]];
    [poss addObjectsFromArray:numbers];
    
    NSMutableArray *poss2 = [NSMutableArray new];
    NSMutableArray *widths2 = [NSMutableArray new];
    
    for (id pos in poss)
    {
        for (id width in widths)
        {
          /*  UIView *A1 = [UIView new];
            A1.leftPos.equalTo(pos);
            A1.widthSize.equalTo(width);
            [rootLayout addSubview:A1];
            
            [poss2 addObject:A1.leftPos];
            [poss2 addObject:A1.centerXPos];
            [poss2 addObject:A1.rightPos];
            [widths2 addObject:A1.widthSize];
            */
            
            UIView *A2 = [UIView new];
            A2.centerXPos.equalTo(pos);
            A2.widthSize.equalTo(width);
            [rootLayout addSubview:A2];

            [poss2 addObject:A2.leftPos];
            [poss2 addObject:A2.centerXPos];
            [poss2 addObject:A2.rightPos];
            [widths2 addObject:A2.widthSize];
            
            UIView *A3 = [UIView new];
            A3.rightPos.equalTo(pos);
            A3.widthSize.equalTo(width);
            [rootLayout addSubview:A3];
            
            [poss2 addObject:A3.leftPos];
            [poss2 addObject:A3.centerXPos];
            [poss2 addObject:A3.rightPos];
            [widths2 addObject:A3.widthSize];
        }
    }
    
    XCTAssertTrue(CGRectEqualToRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)], CGRectMake(0,0,max*2, 0)), @"rect is:%@", NSStringFromCGRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)]));
    

    
    for (id pos1 in poss)
    {
        for (id pos2 in poss)
        {
            UIView *A4 = [UIView new];
            A4.leftPos.equalTo(pos1);
            A4.rightPos.equalTo(pos2);
            [rootLayout addSubview:A4];
            
          //  [poss2 addObject:A4.leftPos];
          //  [poss2 addObject:A4.centerXPos];
          //  [poss2 addObject:A4.rightPos];
          //  [widths2 addObject:A4.widthSize];
        }
    }
    
    XCTAssertTrue(CGRectEqualToRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)], CGRectMake(0,0,max*2, 0)), @"rect is:%@", NSStringFromCGRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)]));

    
    //一次依赖其他子视图。
    
    [poss2 addObjectsFromArray:numbers];
    [widths2 addObjectsFromArray:numbers];
    
    
    NSMutableArray *poss3 = [NSMutableArray new];
    NSMutableArray *widths3 = [NSMutableArray new];
    
    for (id pos in poss2)
    {
        for (id width in widths2)
        {
            /*UIView *A1 = [UIView new];
            A1.leftPos.equalTo(pos);
            A1.widthSize.equalTo(width);
            [rootLayout addSubview:A1];
            
            [poss3 addObject:A1.leftPos];
            [poss3 addObject:A1.centerXPos];
            [poss3 addObject:A1.rightPos];
            [widths3 addObject:A1.widthSize];
            */
            
            UIView *A2 = [UIView new];
            A2.centerXPos.equalTo(pos);
            A2.widthSize.equalTo(width);
            [rootLayout addSubview:A2];
            
            [poss3 addObject:A2.leftPos];
          //  [poss3 addObject:A2.centerXPos];
          //  [poss3 addObject:A2.rightPos];
          //  [widths3 addObject:A2.widthSize];
            
            UIView *A3 = [UIView new];
            A3.rightPos.equalTo(pos);
            A3.widthSize.equalTo(width);
            [rootLayout addSubview:A3];
            
           // [poss3 addObject:A3.leftPos];
           // [poss3 addObject:A3.centerXPos];
            [poss3 addObject:A3.rightPos];
           // [widths3 addObject:A3.widthSize];
      }
    }
    
    XCTAssertTrue(CGRectEqualToRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)], CGRectMake(0,0,max*3, 0)), @"rect is:%@", NSStringFromCGRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)]));

    

    for (id pos1 in poss2)
    {
        for (id pos2 in poss2)
        {
            UIView *A4 = [UIView new];
            A4.leftPos.equalTo(pos1);
            A4.rightPos.equalTo(pos2);
            [rootLayout addSubview:A4];
        }
    }
   
    
    XCTAssertTrue(CGRectEqualToRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)], CGRectMake(0,0,max*3, 0)), @"rect is:%@", NSStringFromCGRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)]));
    
    
    
    //2次依赖其他子视图
    
    [poss3 addObjectsFromArray:numbers];
    [widths3 addObjectsFromArray:numbers];
    
    for (id pos in poss3)
    {
        for (id width in widths3)
        {
          /*  UIView *A1 = [UIView new];
            A1.leftPos.equalTo(pos);
            A1.widthSize.equalTo(width);
            [rootLayout addSubview:A1];
            */
            
            UIView *A2 = [UIView new];
            A2.centerXPos.equalTo(pos);
            A2.widthSize.equalTo(width);
            [rootLayout addSubview:A2];
            
            UIView *A3 = [UIView new];
            A3.rightPos.equalTo(pos);
            A3.widthSize.equalTo(width);
            [rootLayout addSubview:A3];
        }
    }


  //  XCTAssertTrue(CGRectEqualToRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)], CGRectMake(0,0,max*3, 0)), @"rect is:%@", NSStringFromCGRect([rootLayout estimateLayoutRect:CGSizeMake(0, 0)]));

    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

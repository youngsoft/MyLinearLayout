//
//  MyRelativeLayoutTestCase.m
//  MyLayout
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyLayoutTestCaseBase.h"
#import "RLTest1ViewController.h"
#import "RLTest2ViewController.h"
#import "RLTest3ViewController.h"
#import "RLTest4ViewController.h"
#import "RLTest5ViewController.h"


@interface MyRelativeLayoutTestCase : MyLayoutTestCaseBase

@property(nonatomic,strong) RLTest1ViewController *vc;

@end

@implementation MyRelativeLayoutTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testRLTest1VC
{
   
    for (int i = 1; i <= 6; i++)
    {
        Class cls = NSClassFromString([NSString stringWithFormat:@"RLTest%dViewController", i]);
        UIViewController *vc = [[cls alloc] init];
        UIView *v = vc.view;
        [v setNeedsLayout];
        [v layoutIfNeeded];
    }
   
    
    
}

- (void)testHidden {
    
    //测试子视图隐藏的布局变更
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    rootLayout.myHeight = MyLayoutSize.wrap;
    
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
    
    
   CGSize size1 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size1, CGSizeMake(320, 180)), @"size1 is:%@", NSStringFromCGSize(size1));
    XCTAssertTrue(CGRectEqualToRect(descLabel.estimatedRect, CGRectMake(120,135,100, 20)), @"descLabel rect is:%@", NSStringFromCGRect(descLabel.estimatedRect));
    
    
    numberLabel.hidden = YES;
    
    CGSize size2 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    
    XCTAssertTrue(CGSizeEqualToSize(size2, CGSizeMake(320, 180)), @"size2 is:%@", NSStringFromCGSize(size2));
    XCTAssertTrue(CGRectEqualToRect(descLabel.estimatedRect, CGRectMake(195,135,100, 20)), @"descLabel rect is:%@", NSStringFromCGRect(descLabel.estimatedRect));
    
}

-(void)testWrapContentHeight1
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.myHeight = MyLayoutSize.wrap;
    rootLayout.bottomPadding = 20;
    rootLayout.topPadding = 10;
    rootLayout.leadingPadding = 10;
    rootLayout.trailingPadding = 10;
    
    
    CGSize size0 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size0, CGSizeMake(320, 30)), @"size0 is:%@", NSStringFromCGSize(size0));


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
    lineLayout.myHeight = MyLayoutSize.wrap;
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
    
  
    CGSize size1 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size1, CGSizeMake(320, 160)), @"size1 is:%@", NSStringFromCGSize(size1));
    
    UILabel *noteLabel = [UILabel new];
    noteLabel.mySize = CGSizeMake(100, 30);
    [lineLayout addSubview:noteLabel];
    
    CGSize size2 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size2, CGSizeMake(320, 190)), @"size2 is:%@", NSStringFromCGSize(size2));
    
    
    [noteLabel removeFromSuperview];
    
    for (int i = 0; i < 3; i++)
    {
       MyLinearLayout  *horzLayout=[[MyLinearLayout alloc]initWithOrientation:MyOrientation_Horz];
        horzLayout.myHeight = MyLayoutSize.wrap;
        horzLayout.widthSize.equalTo(nil);
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
    
    CGSize size3 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size3, CGSizeMake(320, 220)), @"size3 is:%@", NSStringFromCGSize(size3));
    
    
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
    
    
    CGSize size4 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size4, CGSizeMake(320, 290)), @"size4 is:%@", NSStringFromCGSize(size4));
    
    
    timeLabel.hidden = NO;
    CGSize size5 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size5, CGSizeMake(320, 320)), @"size5 is:%@", NSStringFromCGSize(size5));
    
    orderbutton.hidden = YES;
    CGSize size6 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size6, CGSizeMake(320, 280)), @"size6 is:%@", NSStringFromCGSize(size6));
    
    
    orderbutton.hidden = NO;
    for (UIView *sbv in lineLayout.subviews)
    {
        [sbv removeFromSuperview];
    }
    CGSize size7 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size7, CGSizeMake(320, 230)), @"size7 is:%@", NSStringFromCGSize(size7));
    
    
    timeLabel.hidden = YES;
    orderbutton.hidden = YES;
    CGSize size8 = [rootLayout sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size8, CGSizeMake(320, 160)), @"size8 is:%@", NSStringFromCGSize(size8));

    

}

-(void)testWrapContentHeight2
{
    MyRelativeLayout *rootRelativeView = [MyRelativeLayout new];
    rootRelativeView.myHeight = MyLayoutSize.wrap;
    
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
    newsTitleLabel.myHeight = MyLayoutSize.wrap;
    newsTitleLabel.topPos.equalTo(dateLabel.bottomPos).offset(5);
    newsTitleLabel.leftPos.equalTo(dateLabel.leftPos);
    newsTitleLabel.rightPos.equalTo(dateLabel.rightPos);
    newsTitleLabel.bottomPos.equalTo(rootRelativeView.bottomPos).offset(8);
    [rootRelativeView addSubview:newsTitleLabel];
    
    CGSize size1 = [rootRelativeView sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size1, CGSizeMake(320, 41)), @"size1 is:%@", NSStringFromCGSize(size1));
    
    
    newsTitleLabel.text = @"aaaaaaaaaaaa";
    
    
    CGSize size2 = [rootRelativeView sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size2, CGSizeMake(320, 41 + [newsTitleLabel sizeThatFits:CGSizeMake(266, 0)].height)), @"size2 is:%@", NSStringFromCGSize(size2));
    
    
    newsTitleLabel.text = @"ajkhkahflkahfklahdflkajhdfalkjsdhflkajhdsflajsdhflaksdfhasdlhfjkashdfaasdfasdfasfd";
    
    
    CGSize size3 = [rootRelativeView sizeThatFits:CGSizeMake(320, 0)];
    XCTAssertTrue(CGSizeEqualToSize(size3, CGSizeMake(320, 41+[newsTitleLabel sizeThatFits:CGSizeMake(266, 0)].height)), @"size3 is:%@", NSStringFromCGSize(size3));

}

-(void)testWrapContentHeight3
{
    MyRelativeLayout * midView = [MyRelativeLayout new];
    midView.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    
    UILabel * cartypeLabel = [UILabel new];
    cartypeLabel.mySize = CGSizeMake(90, 30);
    cartypeLabel.centerXPos.equalTo(@0);
    cartypeLabel.topPos.equalTo(@0);
    [midView addSubview:cartypeLabel];  //90 30;
    
    UILabel * line = [UILabel new];
    line.heightSize.equalTo(@2);
    line.topPos.equalTo(cartypeLabel.bottomPos).offset(5);
    line.widthSize.equalTo(cartypeLabel.widthSize).add(20); //110, 37
    [midView addSubview:line];
    
    UIView * leftView = [[UIView alloc]init];
    leftView.heightSize.equalTo(@8);
    leftView.widthSize.equalTo(@8);
    leftView.leftPos.equalTo(@0);
    leftView.centerYPos.equalTo(line.centerYPos);  //118,41
    [midView addSubview:leftView];
    
    line.leftPos.equalTo(leftView.rightPos);
    
    
    UIView * rightView = [[UIView alloc]init];
    rightView.heightSize.equalTo(@8);
    rightView.widthSize.equalTo(@8);
    rightView.leftPos.equalTo(line.rightPos);
    rightView.centerYPos.equalTo(line.centerYPos);
    [midView addSubview:rightView];    //126, 41
    
    UILabel * numLabel = [UILabel new];
    numLabel.mySize = CGSizeMake(40, 20);
    numLabel.topPos.equalTo(line.bottomPos).offset(5); //126,62
    numLabel.centerXPos.equalTo(@0);
    [midView addSubview:numLabel];
    
   CGSize sz =  [midView sizeThatFits:CGSizeZero];
    
    NSLog(@"%@",NSStringFromCGSize(sz));
    MySizeAssert(midView, sz, CGSizeMake(126, 62));
}

-(void)testWrapContentWidth1
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    rootLayout.bottomPadding = 20;
    rootLayout.topPadding = 10;
    rootLayout.leadingPadding = 10;
    rootLayout.trailingPadding = 10;
    
    
    XCTAssertTrue(CGSizeEqualToSize([rootLayout sizeThatFits:CGSizeMake(0, 0)], CGSizeMake(20, 30)), @"size is:%@", NSStringFromCGSize([rootLayout sizeThatFits:CGSizeMake(0, 0)]));
    
    
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
    
    rightLabel.leftPos.equalTo(titleLabel.rightPos).offset(10);
    
    
    XCTAssertTrue(CGSizeEqualToSize([rootLayout sizeThatFits:CGSizeMake(0, 0)], CGSizeMake(176, 50)), @"size is:%@", NSStringFromCGSize([rootLayout sizeThatFits:CGSizeMake(0, 0)]));
    
    
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
    
    
    XCTAssertTrue(CGSizeEqualToSize([rootLayout sizeThatFits:CGSizeMake(0, 0)], CGSizeMake(176, 125)), @"size is:%@", NSStringFromCGSize([rootLayout sizeThatFits:CGSizeMake(0, 0)]));
    
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
    rootLayout.myWidth = MyLayoutSize.wrap;
    

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
    
    XCTAssertTrue(CGSizeEqualToSize([rootLayout sizeThatFits:CGSizeMake(0, 0)], CGSizeMake(max*2, 0)), @"size is:%@", NSStringFromCGSize([rootLayout sizeThatFits:CGSizeMake(0, 0)]));
    

    
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
    
    XCTAssertTrue(CGSizeEqualToSize([rootLayout sizeThatFits:CGSizeMake(0, 0)], CGSizeMake(max*2, 0)), @"size is:%@", NSStringFromCGSize([rootLayout sizeThatFits:CGSizeMake(0, 0)]));

    
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
    
    XCTAssertTrue(CGSizeEqualToSize([rootLayout sizeThatFits:CGSizeMake(0, 0)], CGSizeMake(max*3, 0)), @"size is:%@", NSStringFromCGSize([rootLayout sizeThatFits:CGSizeMake(0, 0)]));

    

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
   
    
    XCTAssertTrue(CGSizeEqualToSize([rootLayout sizeThatFits:CGSizeMake(0, 0)], CGSizeMake(max*3, 0)), @"size is:%@", NSStringFromCGSize([rootLayout sizeThatFits:CGSizeMake(0, 0)]));
    
    
    
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


  //  XCTAssertTrue(CGSizeEqualToSize([rootLayout sizeThatFits:CGSizeMake(0, 0)], CGSizeMake(max*3, 0)), @"size is:%@", NSStringFromCGSize([rootLayout sizeThatFits:CGSizeMake(0, 0)]));

    
}

-(void)testDemo1
{
    MyRelativeLayout *_layoutRoot = nil;
    
    MyRelativeLayout* relative = [MyRelativeLayout new];
    //  relative.widthSize.equalTo(self.contentView.widthSize);
    relative.myHeight = MyLayoutSize.wrap;
    relative.myHorzMargin = 0;
    _layoutRoot = relative;
  //  [self.view addSubview:_layoutRoot];
    
    
    // 头像区域
    MyLinearLayout* linear = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    linear.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    linear.padding = UIEdgeInsetsMake(12, 15, 12, 15);
    linear.myLeading = 0.0f;
    [_layoutRoot addSubview:linear];
    MyLinearLayout *_layoutPortrait = linear;
    
    // 头像
    UIImageView* imgv = [UIImageView new];
    imgv.mySize = CGSizeMake(40,40);
    [_layoutPortrait addSubview:imgv];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    // 最右侧的附加区域
    linear = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    linear.heightSize.equalTo(_layoutRoot.heightSize);
    linear.widthSize.equalTo(@(screenWidth)).multiply(0.24).min(90.0f);
    linear.myTrailing = 0.0f;
    linear.trailingPadding = 15.0f;
    linear.subviewVSpace = 8.0f;
    linear.gravity = MyGravity_Horz_Right|MyGravity_Vert_Center;
    [_layoutRoot addSubview:linear];
    MyLinearLayout * _layoutAccessory = linear;
    
    // 时间
    UILabel* lbl = [UILabel new];
    lbl.text = @"2019-11-11";
    [lbl setTextAlignment:NSTextAlignmentRight];
    lbl.font = [UIFont systemFontOfSize:12];
    [lbl setMinimumScaleFactor:10.0f];
    [lbl setTextColor:[UIColor greenColor]];
    lbl.heightSize.equalTo(@(MyLayoutSize.wrap));
    lbl.widthSize.equalTo(@(MyLayoutSize.wrap)).uBound(_layoutAccessory.widthSize,-2,1);
    [lbl setNumberOfLines:1];
    [_layoutAccessory addSubview:lbl];
    
    // 附加区域底部
    linear = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    linear.gravity = MyGravity_Vert_Center|MyGravity_Horz_Right;
    linear.widthSize.equalTo(_layoutAccessory.widthSize);
    linear.myHeight = 20.0f;
    linear.subviewHSpace = 4.0f;
    [_layoutAccessory addSubview:linear];
    MyLinearLayout *_layoutAccessoryBottom = linear;
    
    // 勿扰图标
    UIImage* image = [UIImage imageNamed:@"edit"];
    imgv = [[UIImageView alloc] initWithImage:image];
    imgv.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    imgv.visibility = MyVisibility_Gone;
    [_layoutAccessoryBottom addSubview:imgv];
    UIView *hideView1 = imgv;
    
    // 勿扰状态下，有新消息时的小红点提示
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6.0f, 6.0f)];
    [view setBackgroundColor:[UIColor greenColor]];
    view.visibility = MyVisibility_Gone;
    [_layoutAccessoryBottom addSubview:view];
    UIView *hideView2 = view;
    
    // 非勿扰状态下未读消息数
    lbl = [UILabel new];
    lbl.text = @"1";
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont systemFontOfSize:10]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor redColor]];
    [_layoutAccessoryBottom addSubview:lbl];
    [lbl setNumberOfLines:1];
    lbl.heightSize.equalTo(lbl.heightSize).add(4.0f).lBound(@16,0,1);
    lbl.widthSize.equalTo(lbl.widthSize).add(8.0f).lBound(@16,0,1).uBound(_layoutAccessory.widthSize,0,1);
    
    // 中间区域
    linear = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    linear.myVertMargin = 0.0f;
    linear.heightSize.equalTo(@(MyLayoutSize.wrap)).min(67.0f);
    linear.leadingPos.equalTo(_layoutPortrait.trailingPos);
    linear.trailingPos.equalTo(_layoutAccessory.leadingPos);
    linear.gravity = MyGravity_Vert_Center;
    linear.subviewVSpace = 8.0f;
    [_layoutRoot addSubview:linear];
    MyLinearLayout * _layoutContent = linear;
    
    // 标题区域
    relative = [MyRelativeLayout new];
    relative.widthSize.equalTo(_layoutContent.widthSize);
    relative.myHeight = MyLayoutSize.wrap;
    [_layoutContent addSubview:relative];
    MyRelativeLayout * _layoutTitle = relative;
    
    // 会话名称
    lbl = [UILabel new];
    lbl.text = @"asdfklajdf爱的色放就爱";
    lbl.myLeading = 0.0f;
    lbl.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    [lbl setFont:[UIFont systemFontOfSize:17]];
    [lbl setTextColor:[UIColor greenColor]];
    lbl.numberOfLines = 1;
    [_layoutTitle addSubview:lbl];
    UILabel *_lblTitle = lbl;
    UIView *hideView4 = _lblTitle;
    
    // 名称右侧的标记（例如，选题、部门等，作用是标记会话的类型）
    lbl = [UILabel new];
    lbl.text = @"选题";
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont systemFontOfSize:10]];
    lbl.widthSize.equalTo(lbl.widthSize);
    lbl.heightSize.equalTo(lbl.heightSize).add(4.0f);
    lbl.myTrailing = 4.0f;
    lbl.centerYPos.equalTo(_lblTitle.centerYPos);
    lbl.leadingPos.equalTo(_lblTitle.trailingPos).offset(4.0f);
    [lbl setNumberOfLines:1];
    [_layoutTitle addSubview:lbl];
    UILabel *_lblMark = lbl;
    
    _lblTitle.trailingPos.uBound(_layoutTitle.rightPos,4.0+_lblMark.frame.size.width);
    
    // 摘要
    linear = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    linear.widthSize.equalTo(_layoutContent.widthSize);
    linear.myHeight = MyLayoutSize.wrap;
    linear.subviewHSpace = 2.0f;
    [_layoutContent addSubview:linear];
    MyLinearLayout *_layoutSummary = linear;
    
    // 发送状态（例如：发送中，发送失败）
    imgv = [UIImageView new];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    imgv.mySize = CGSizeMake(50,50);
    imgv.visibility = MyVisibility_Gone;
    [_layoutSummary addSubview:imgv];
    UIView *hideView3 = imgv;
    
    // 勿扰状态下，在摘要显示的消息数
    lbl = [UILabel new];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont systemFontOfSize:12]];
    lbl.mySize = CGSizeMake(5, 5);
    [lbl setNumberOfLines:1];
    lbl.visibility = MyVisibility_Gone;
    [_layoutSummary addSubview:lbl];
    
    // 状态（包括：未读，已读，草稿，有人@）
    lbl = [UILabel new];
    [lbl setFont:[UIFont systemFontOfSize:12]];
    lbl.mySize = CGSizeMake(5,5);
    [lbl setNumberOfLines:1];
    lbl.visibility = MyVisibility_Gone;
    [_layoutSummary addSubview:lbl];
    
    // 摘要内容
    lbl = [UILabel new];
    [lbl setFont:[UIFont systemFontOfSize:12]];
    lbl.weight = 1.0f;
    lbl.mySize = CGSizeMake(70, 40);
    [lbl setNumberOfLines:1];
    [_layoutSummary addSubview:lbl];
    
    //hideView1
    //hideView2
    //hideView3
    CGSize sz = [_layoutRoot sizeThatFits:CGSizeMake(375, 0)];
    MySizeAssert(midView, sz, CGSizeMake(375, 68.5));
    
    hideView3.visibility = MyVisibility_Visible;
    
    sz = [_layoutRoot sizeThatFits:CGSizeMake(375, 0)];
    MySizeAssert(midView, sz, CGSizeMake(375, 78.5));
    
    hideView3.visibility = MyVisibility_Gone;
    hideView4.visibility = MyVisibility_Gone;
    
    sz = [_layoutRoot sizeThatFits:CGSizeMake(375, 0)];
    MySizeAssert(midView, sz, CGSizeMake(375, 67));
    
}

-(void)testDemo2
{
    MyRelativeLayout *_rootLayout = [MyRelativeLayout new];
    
    _rootLayout.wrapContentHeight = YES;
    _rootLayout.topPadding = 15;
    _rootLayout.bottomPadding = 15;
    _rootLayout.backgroundColor = [UIColor whiteColor];
    
    
    
    MyLinearLayout *topLayout = [MyLinearLayout linearLayoutWithOrientation:(MyOrientation_Vert)];
    
    topLayout.wrapContentWidth = YES;
    topLayout.myHorzMargin = 0;
    topLayout.wrapContentHeight = YES;
    topLayout.subviewVSpace = 5;
    [_rootLayout addSubview:topLayout];
    
    
    UILabel *topLable = [UILabel new];
    topLable.text = @"宿州学院-皁阳火车站";
    topLable.myTop = 0;
    topLable.myLeft = 11;
    topLable.wrapContentSize = YES;
    [topLayout addSubview:topLable];
    
    
    
    UIButton *checkMarkBtn = [UIButton new];
    [checkMarkBtn setImage:[UIImage imageNamed:@"train_progresscomplete"] forState:(UIControlStateNormal)];
    checkMarkBtn.widthSize.equalTo(@(13));
    checkMarkBtn.heightSize.equalTo(@(13));
    checkMarkBtn.rightPos.equalTo(@(10));
    checkMarkBtn.centerYPos.equalTo(@(0));
    [_rootLayout addSubview:checkMarkBtn];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = @"途径：蒙城、嘎县、阜阳师范学院、嘎县、阜阳师范学院、嘎县、阜阳师范学院";
    contentLabel.myLeft = 11;
    
    contentLabel.wrapContentHeight= YES;
    contentLabel.myRight = 27;
    contentLabel.hidden = NO;
    [topLayout addSubview:contentLabel];
    
    CGSize sz = [_rootLayout sizeThatFits:CGSizeMake(375, 0)];
    MySizeAssert(midView, sz, CGSizeMake(375, 96.5));
}

-(void)testDemo3
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.myWidth = MyLayoutSize.wrap;
    rootLayout.myHeight = MyLayoutSize.wrap;
    rootLayout.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    
    MyLinearLayout *headerLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    headerLayout.topPos.equalTo(rootLayout.topPos);
    headerLayout.leftPos.equalTo(rootLayout.leftPos);
    headerLayout.myHeight = MyLayoutSize.wrap;
    [rootLayout addSubview:headerLayout];
    
    UIView *headerView = [UIView new];
    headerView.mySize = CGSizeMake(32, 32);
    [headerLayout addSubview:headerView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.mySize = CGSizeMake(60, 20);
    nameLabel.alignment = MyGravity_Vert_Center;
    nameLabel.myLeft = 5;
    [headerLayout addSubview:nameLabel];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.myHeight = 50;
    titleLabel.leftPos.equalTo(headerLayout.leftPos);
    titleLabel.topPos.equalTo(headerLayout.bottomPos).offset(5);
    titleLabel.rightPos.equalTo(rootLayout.rightPos);
    [rootLayout addSubview:titleLabel];
    
    UIView *barView = [UIView new];
    barView.myHeight = 30;
    barView.leftPos.equalTo(titleLabel.leftPos);
    barView.rightPos.equalTo(titleLabel.rightPos);
    barView.topPos.equalTo(titleLabel.bottomPos);
    [rootLayout addSubview:barView];
    
    CGSize sz = [rootLayout sizeThatFits:CGSizeMake(0, 0)];
    MySizeAssert(rootLayout, sz, CGSizeMake(121,141));
}

- (UILabel *)textLabel:(NSString *)text fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = text;
    [label sizeToFit];
    return label;
}

- (UILabel *)amountLabel:(NSString *)text fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    label.text = text;
    [label sizeToFit];
    return label;
}

-(void)testDemo4
{
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    rootLayout.myHorzMargin = 0;
    rootLayout.myHeight = MyLayoutSize.wrap;
    
    MyLinearLayout *baseLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    [rootLayout addSubview:baseLayout];
    baseLayout.widthSize.equalTo(rootLayout);
    
    ///背景布局
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat ten_margin = 10;
    MyLinearLayout *bgLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
  //  bgLayout.widthSize.equalTo(@(screen_width - 2 * ten_margin));
    bgLayout.widthSize.equalTo(baseLayout.widthSize).add(-2 * ten_margin);
    bgLayout.myLeft = ten_margin;
    bgLayout.myTop = ten_margin;
    bgLayout.padding = UIEdgeInsetsMake(2 * ten_margin, 0, 2 * ten_margin, 0);
    [baseLayout addSubview:bgLayout];
  //  self.bgLayout = bgLayout;
   // bgLayout.backgroundColor = UIColorFromRGB(0x6095f0);
    bgLayout.backgroundColor = [UIColor lightGrayColor];
    
    ///资产布局
    MyRelativeLayout *assetsLayout = [[MyRelativeLayout alloc] init];
    [bgLayout addSubview:assetsLayout];
    assetsLayout.myHorzMargin = 0;
    assetsLayout.leftPadding = 1.8 * ten_margin;
    assetsLayout.wrapContentHeight = YES;
    
    ///总资产Lab
    UILabel *assetsLab = [UILabel new];
    assetsLab.text = @"TotalAssetsBracketsYuan";
    [assetsLab sizeToFit];
    assetsLab.font = [UIFont systemFontOfSize:11];
    [assetsLayout addSubview:assetsLab];
    
    ///总资产金额Lab
    UILabel *assetsAmountLab = [UILabel new];
    assetsAmountLab.text = @"0.00";
    assetsAmountLab.font = [UIFont systemFontOfSize:19];
    assetsAmountLab.leftPos.equalTo(assetsLab);
    assetsAmountLab.topPos.equalTo(assetsLab.bottomPos).offset(0.3 * ten_margin);
    [assetsLayout addSubview:assetsAmountLab];
    
    /*************************************************/
    
    ///本金布局
    MyFloatLayout *principalLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    principalLayout.myHorzMargin = 0;
    principalLayout.topPadding = 1.5 * ten_margin;
    principalLayout.leftPadding = 1.8 * ten_margin;
    principalLayout.wrapContentHeight = YES;
    [bgLayout addSubview:principalLayout];
    
    ///待收本金
    UILabel *principalLab = [UILabel new];
    principalLab.text = @"PendingPrincipalBracketsYuan";
    principalLab.font = [UIFont systemFontOfSize:10];
    [principalLab sizeToFit];
    principalLab.weight = 0.33 ;
    [principalLayout addSubview:principalLab];
    
    ///锁定资金金额
    UILabel *lockLab = [UILabel new];
    lockLab.text = @"LockFundsBracketsYuan";
    lockLab.font = [UIFont systemFontOfSize:10];
    [lockLab sizeToFit];
    lockLab.weight = 0.5;
    [principalLayout addSubview:lockLab];
    
    ///可用余额
    UILabel *balanceLab = [UILabel new];
    balanceLab.text = @"AvailableBalanceBracketsYuan";
    balanceLab.font = [UIFont systemFontOfSize:10];
    [balanceLab sizeToFit];
    balanceLab.weight = 1;
    [principalLayout addSubview:balanceLab];
    
#define QDLabel UILabel
    ///待收本金金额
    QDLabel *principalAmountLab = [self amountLabel:@"0.00" fontSize:15];
    principalAmountLab.weight = 0.33 ;
    [principalLayout addSubview:principalAmountLab];
    
    ///锁定资金金额
    QDLabel *lockAmountLab = [self amountLabel:@"0.00" fontSize:15];
    lockAmountLab.weight = 0.5;
    [principalLayout addSubview:lockAmountLab];
    
    ///可用余额金额
    QDLabel *balanceAmountLab = [self amountLabel:@"0.00" fontSize:15];
    balanceAmountLab.weight = 1;
    [principalLayout addSubview:balanceAmountLab];
    
    ///可伸缩布局
    MyLinearLayout *animLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    [bgLayout addSubview:animLayout];
    animLayout.myHorzMargin = 0;
    
    UIView *topLine = [[UIView alloc] init];
    [animLayout addSubview:topLine];
   // topLine.backgroundColor = color_bg_white;
    topLine.myTop = 2 * ten_margin;
    topLine.myHorzMargin = 0;
    topLine.heightSize.equalTo(@(1));
    
    ///收益布局
    MyFloatLayout *incomeLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    incomeLayout.myHorzMargin = 0;
    incomeLayout.topPadding = 2 * ten_margin;
    incomeLayout.leftPadding = 1.8 * ten_margin;
    incomeLayout.wrapContentHeight = YES;
    [animLayout addSubview:incomeLayout];
    
    ///待收收益
    QDLabel *pendingIncomeLab = [self textLabel:@"PendingIncomeBracketsYuan" fontSize:10];
    pendingIncomeLab.weight = 0.33 ;
    [incomeLayout addSubview:pendingIncomeLab];
    
    ///累计收益
    QDLabel *cumulativeIncomeLab = [self textLabel:@"CumulativeIncomeBracketsYuan" fontSize:10];
    cumulativeIncomeLab.weight = 1;
    [incomeLayout addSubview:cumulativeIncomeLab];
    
    ///待收收益金额
    QDLabel *pendingIncomeAmountLab = [self amountLabel:@"0.00" fontSize:15];
    pendingIncomeAmountLab.weight = 0.33 ;
    [incomeLayout addSubview:pendingIncomeAmountLab];
    
    ///累计收益金额
    QDLabel *cumulativeIncomeAmountLab = [self amountLabel:@"0.00" fontSize:15];
    cumulativeIncomeAmountLab.weight = 1;
    [incomeLayout addSubview:cumulativeIncomeAmountLab];
    
    UIView *bttomLine = [[UIView alloc] init];
    [animLayout addSubview:bttomLine];
  //  bttomLine.backgroundColor = color_bg_white;
    bttomLine.myTop = 2 * ten_margin;
    bttomLine.myHorzMargin = 0;
    bttomLine.heightSize.equalTo(@(1));
    
    //出借总额布局
    MyFloatLayout *totalLoanLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    totalLoanLayout.myHorzMargin = 0;
    totalLoanLayout.topPadding = 2 * ten_margin;
    totalLoanLayout.leftPadding = 1.8 * ten_margin;
    totalLoanLayout.wrapContentHeight = YES;
    [animLayout addSubview:totalLoanLayout];
    
    ///累积出借总额
    QDLabel *totalLoanLab = [self textLabel:@"TotalAccumulatedLoanBracketsYuan" fontSize:10];
    totalLoanLab.weight = 1 ;
    [totalLoanLayout addSubview:totalLoanLab];
    
    ///累计收益金额
    QDLabel *totalLoanAmountLab = [self amountLabel:@"0.00" fontSize:15];
    totalLoanAmountLab.weight = 1;
    [totalLoanLayout addSubview:totalLoanAmountLab];
    CGRect animRect = [baseLayout subview:animLayout estimatedRectInLayoutSize:CGSizeMake(screen_width - 2 * ten_margin, 100)];
    animLayout.frame = CGRectMake(animRect.origin.x, animRect.origin.y, animRect.size.width, animRect.size.height);
    animLayout.visibility = MyVisibility_Visible;
    
    ///点击布局
    MyLinearLayout *stretchLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    stretchLayout.wrapContentHeight = YES;
    //    stretchLayout.heightSize.equalTo(@100);
    stretchLayout.widthSize.equalTo(rootLayout);
    stretchLayout.topPadding = stretchLayout.bottomPadding = 1.2 * ten_margin;
    stretchLayout.gravity = MyGravity_Horz_Center;
    [baseLayout addSubview:stretchLayout];
    
    UILabel *arrowBtn = [UILabel new];
    arrowBtn.backgroundColor = [UIColor redColor];
//    [arrowBtn setImage:[UIImage imageNamed:@"assets_my_assets_header_hide"]
//              forState:UIControlStateNormal];
//    [arrowBtn setImage:[UIImage imageNamed:@"assets_my_assets_header_show"]
//              forState:UIControlStateSelected];
//    [arrowBtn addTarget:self
//                 action:@selector(arrowBtnClicked:)
//       forControlEvents:UIControlEventTouchUpInside];
    arrowBtn.mySize = CGSizeMake(40, 40);
    [stretchLayout addSubview:arrowBtn];
   // self.arrowBtn = arrowBtn;
    
    CGSize sz = [rootLayout sizeThatFits:CGSizeMake(screen_width, 0)];
    MySizeAssert(rootLayout, sz, CGSizeMake(screen_width,324.5));
    
    animLayout.visibility = MyVisibility_Gone;
    
    sz = [rootLayout sizeThatFits:CGSizeMake(screen_width, 0)];
    MySizeAssert(rootLayout, sz, CGSizeMake(screen_width,182.5));
    
}


-(void)testhideandubound
{
    //测试视图隐藏以及
    {
        UIButton *zoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        zoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        zoneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLab.numberOfLines = 1.0;
        nameLab.font = [UIFont systemFontOfSize:18];
        nameLab.textAlignment = NSTextAlignmentCenter;
        
        UIButton *placeholderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        MyRelativeLayout *layout2 = [[MyRelativeLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 100)];
        
        zoneBtn.myLeft = 20;
        zoneBtn.myCenterY = 0;
        zoneBtn.widthSize.equalTo(zoneBtn.widthSize).add(20);
        zoneBtn.heightSize.equalTo(zoneBtn.heightSize).add(3);
        
        nameLab.myCenterY = 0;
        nameLab.leftPos.equalTo(zoneBtn.rightPos).offset(15);
        nameLab.rightPos.equalTo(placeholderBtn.leftPos).offset(15);
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
        
        XCTAssertTrue(nameLab.frame.size.width == layout2.frame.size.width - 40 &&
                      nameLab.center.y == layout2.frame.size.height * 0.5, @"nameLab.frame = %@",NSStringFromCGRect(nameLab.frame));
    }
    
    {
        UIButton *zoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        zoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        zoneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLab.numberOfLines = 1.0;
        nameLab.font = [UIFont systemFontOfSize:18];
        nameLab.textAlignment = NSTextAlignmentCenter;
        
        UIButton *placeholderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        MyRelativeLayout *layout2 = [[MyRelativeLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 100)];
        
        zoneBtn.myLeft = 20;
        zoneBtn.myCenterY = 0;
        zoneBtn.widthSize.equalTo(zoneBtn.widthSize).add(20);
        zoneBtn.heightSize.equalTo(zoneBtn.heightSize).add(3);
        
        nameLab.myCenterY = 0;
        nameLab.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        nameLab.leftPos.lBound(zoneBtn.rightPos, 15);
        nameLab.rightPos.uBound(placeholderBtn.leftPos, 15);
        nameLab.text = @"这是阿斯蒂芬阿道夫阿斯蒂芬安防安防阿斯蒂芬安防大师傅阿斯蒂芬阿斯蒂芬安防";
        
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
        
        XCTAssertTrue(nameLab.frame.size.width == layout2.frame.size.width - 40 &&
                      nameLab.center.y == layout2.frame.size.height * 0.5, @"nameLab.frame = %@",NSStringFromCGRect(nameLab.frame));
        
    }
    
}

-(void)testBaseline
{
    MyRelativeLayout *relaLayout = [MyRelativeLayout new];
 //   self.view = relaLayout;
    
    UIButton *lb1 = [UIButton new];
    //lb1.text = @"ajbdg";
    [lb1 setTitle:@"ajbdg" forState:UIControlStateNormal];
    lb1.titleLabel.font = [UIFont systemFontOfSize:70];
    // lb1.adjustsFontSizeToFitWidth = YES;
    lb1.mySize = CGSizeMake(180, 100);
    // lb1.font = [UIFont systemFontOfSize:70];
    // [lb1 sizeToFit];
    
    UIFont *font1 = lb1.font;
    
    
    
    
    lb1.backgroundColor = [UIColor greenColor];
    lb1.baselinePos.equalTo(@200);
    lb1.myLeft = 30;
    [relaLayout addSubview:lb1];
    
    UILabel *lb2 = [UILabel new];
    lb2.text = @"jjgiii";
    lb2.mySize = CGSizeMake(200, 100);
    lb2.leftPos.equalTo(lb1.rightPos);
    lb2.baselinePos.equalTo(lb1.baselinePos);
    lb2.backgroundColor =[UIColor redColor];
    [relaLayout addSubview:lb2];

}

-(void)testMaxHeightAndWidth
{
    MyRelativeLayout *rellayout = [MyRelativeLayout new];
    
    UIView *vv = [UIView new];
    [rellayout addSubview:vv];
    
    UILabel *label = [UILabel new];
    [rellayout addSubview:label];
    
    label.myLeft = 10;
    label.widthSize.equalTo(@(MyLayoutSize.wrap)).max(100);
    label.heightSize.equalTo(@(MyLayoutSize.wrap));
    
    
    vv.topPos.equalTo(label.topPos);
    vv.bottomPos.equalTo(label.bottomPos);
    vv.leftPos.equalTo(label.leftPos);
    vv.rightPos.equalTo(label.rightPos);
    
    
    label.text = @"测试";
    vv.backgroundColor = [UIColor redColor];
    
    [rellayout sizeThatFits:CGSizeZero];
    
    XCTAssertTrue(CGSizeEqualToSize(label.estimatedRect.size, CGSizeMake(35, 20.5)));
    XCTAssertTrue(CGSizeEqualToSize(vv.estimatedRect.size, CGSizeMake(35, 20.5)));
    XCTAssertTrue(CGSizeEqualToSize(vv.estimatedRect.size, label.estimatedRect.size));

    label.text = @"测试12345660392034323";
    
    [rellayout sizeThatFits:CGSizeZero];
    
    XCTAssertTrue(CGSizeEqualToSize(label.estimatedRect.size, CGSizeMake(100, 61)));
    XCTAssertTrue(CGSizeEqualToSize(vv.estimatedRect.size, CGSizeMake(100, 61)));
    XCTAssertTrue(CGSizeEqualToSize(vv.estimatedRect.size, label.estimatedRect.size));

}


-(void)testExample1
{
    MyRelativeLayout *rootLayout = [[MyRelativeLayout alloc] initWithFrame:CGRectMake(0, 0, 375, 603)];
    
    
    UIView *v1 = [UIView new];
    v1.mySize = CGSizeMake(100, 100);
    v1.myTop = 100;
    v1.myLeft = 100;
    v1.visibility = MyVisibility_Gone;
    [rootLayout addSubview:v1];
    
    //某个视图的水平居中依赖另外一个视图，另外一个视图隐藏。
    UIView *v2 = [UIView new];
    v2.mySize = CGSizeMake(100, 100);
    v2.centerXPos.equalTo(v1.centerXPos).offset(20);
    v2.centerYPos.equalTo(v1.centerYPos).offset(20);
    [rootLayout addSubview:v2];
    
    //某个视图的左边依赖另外一个视图，另外一个视图隐藏。
    UIView *v3 = [UIView new];
    v3.mySize = CGSizeMake(100, 100);
    v3.leadingPos.equalTo(v1.leadingPos).offset(20);
    v3.bottomPos.equalTo(v1.bottomPos).offset(20);
    [rootLayout addSubview:v3];
    
    UIView *v4 = [UIView new];
    v4.mySize = CGSizeMake(100, 100);
    v4.leadingPos.lBound(v3.leadingPos, 0);
    v4.trailingPos.uBound(rootLayout.trailingPos,0);
    v4.bottomPos.equalTo(@(10));
    [rootLayout addSubview:v4];
    
    UIView *v5 = [UIView new];
    v5.mySize = CGSizeMake(100, 100);
    v5.baselinePos.equalTo(v4.baselinePos).offset(20);
    [rootLayout addSubview:v5];
    
    UILabel *v6 = [UILabel new];
    v6.mySize = CGSizeMake(100, 100);
    v6.baselinePos.equalTo(v1.baselinePos).offset(20);
    [rootLayout addSubview:v6];
    
    UILabel *v7 = [UILabel new];
    v7.mySize = CGSizeMake(100, 100);
    v7.baselinePos.equalTo(@(40));
    [rootLayout addSubview:v7];
    
    [rootLayout setNeedsLayout];
    [rootLayout layoutIfNeeded];
    
    XCTAssertTrue(CGRectEqualToRect(v1.frame, CGRectMake(100,100,0,0)), @"the v1.frame = %@",NSStringFromCGRect(v1.frame));
    XCTAssertTrue(CGRectEqualToRect(v2.frame, CGRectMake(50,50,100,100)), @"the v2.frame = %@",NSStringFromCGRect(v2.frame));
    XCTAssertTrue(CGRectEqualToRect(v3.frame, CGRectMake(100,0,100,100)), @"the v3.frame = %@",NSStringFromCGRect(v3.frame));
    XCTAssertTrue(CGRectEqualToRect(v4.frame, CGRectMake(187.5,493,100,100)), @"the v4.frame = %@",NSStringFromCGRect(v4.frame));
    XCTAssertTrue(CGRectEqualToRect(v5.frame, CGRectMake(0,20,100,100)), @"the v5.frame = %@",NSStringFromCGRect(v5.frame));
    XCTAssertTrue(CGRectEqualToRect(v6.frame, CGRectMake(0,44,100,100)), @"the v6.frame = %@",NSStringFromCGRect(v6.frame));
    XCTAssertTrue(CGRectEqualToRect(v7.frame, CGRectMake(0,-16,100,100)), @"the v7.frame = %@",NSStringFromCGRect(v7.frame));
}

-(void)testWrapContentHeight4
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.myHeight = MyLayoutSize.wrap;
    rootLayout.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    
    MyLinearLayout *headerLayout = [MyLinearLayout linearLayoutWithOrientation:(MyOrientation_Horz)];
    headerLayout.topPos.equalTo(rootLayout.topPos);
    headerLayout.leftPos.equalTo(rootLayout.leftPos);
    headerLayout.wrapContentHeight = YES;
    [rootLayout addSubview:headerLayout];
    
    UIImageView *headerView = UIImageView.alloc.init;
    headerView.mySize = CGSizeMake(32, 32);
    [headerLayout addSubview:headerView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"欧阳大哥";
    nameLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    nameLabel.alignment = MyGravity_Vert_Center;
    nameLabel.myLeft = 5;
    [headerLayout addSubview:nameLabel];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"大师傅阿萨德阿斯蒂芬阿斯蒂芬";
    titleLabel.myHeight = MyLayoutSize.wrap;
    titleLabel.leftPos.equalTo(headerLayout.leftPos).offset(32 + 5);
    titleLabel.topPos.equalTo(headerLayout.bottomPos).offset(5);
    titleLabel.rightPos.equalTo(rootLayout.rightPos);
    [rootLayout addSubview:titleLabel];
    
    MyLinearLayout *barView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    barView.myHeight = 20;
    barView.leftPos.equalTo(titleLabel.leftPos);
    barView.rightPos.equalTo(rootLayout.rightPos);
    barView.topPos.equalTo(titleLabel.bottomPos);
    [rootLayout addSubview:barView];
    
   CGSize sz = [rootLayout sizeThatFits:CGSizeMake(375, 0)];
    MySizeAssert(rootLayout,sz,CGSizeMake(375, 101.5));
    //MyRectAssert(rootLayout, CGRectMake(0, 0, sz.width, sz.height));
}

-(void)testWrapContentHeight5
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.myWidth = MyLayoutSize.wrap;
    rootLayout.myHeight = MyLayoutSize.wrap;
    
    //放一个高宽都是wrap的子布局视图。
    MyRelativeLayout *layout1 = [MyRelativeLayout new];
    layout1.myWidth = MyLayoutSize.wrap;
    layout1.myHeight = MyLayoutSize.wrap;
    layout1.myMargin = 10;
    [rootLayout addSubview:layout1];
    
    MyRelativeLayout *layout11 = [MyRelativeLayout new];
    layout11.myWidth = MyLayoutSize.wrap;
    layout11.myHeight = MyLayoutSize.wrap;
    layout11.myMargin = 10;
    [layout1 addSubview:layout11];
    
    UIView *v111 = [UIView new];
    v111.mySize = CGSizeMake(10, 10);
    v111.myMargin = 10;
    [layout11 addSubview:v111];
    
    CGSize sz = [rootLayout sizeThatFits:CGSizeMake(0, 0)];
    MySizeAssert(rootLayout,sz,CGSizeMake(70, 70));
    
    v111.visibility = MyVisibility_Gone;
    sz = [rootLayout sizeThatFits:CGSizeMake(0, 0)];
    MySizeAssert(rootLayout,sz,CGSizeMake(40, 40));
    
    v111.visibility = MyVisibility_Visible;
    
    
    MyFlowLayout *layout2 = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    layout2.widthSize.equalTo(@(MyLayoutSize.wrap)).max(80);
    layout2.myHeight = MyLayoutSize.wrap;
    layout2.topPos.equalTo(layout1.centerYPos);
    layout2.leftPos.equalTo(layout1.rightPos);
    layout2.rightPos.equalTo(rootLayout.rightPos).offset(20);
    [rootLayout addSubview:layout2];
    
    UIView *v21 = [UIView new];
    v21.mySize = CGSizeMake(60, 60);
    [layout2 addSubview:v21];
    
    sz = [rootLayout sizeThatFits:CGSizeMake(0, 0)];
    MySizeAssert(rootLayout,sz,CGSizeMake(150, 95));
    
    
    UIView *v22 = [UIView new];
    v22.mySize = CGSizeMake(60, 60);
    [layout2 addSubview:v22];
    
    sz = [rootLayout sizeThatFits:CGSizeMake(0, 0)];
    MySizeAssert(rootLayout,sz,CGSizeMake(170, 35+60+60));
    
    
}

-(void)testWrapContentHeight6
{
   MyRelativeLayout* _layoutRoot = [[MyRelativeLayout alloc] init];
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


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

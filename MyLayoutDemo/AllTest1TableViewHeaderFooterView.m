//
//  AllTest1TableViewHeaderFooterView.m
//  MyLayout
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "AllTest1TableViewHeaderFooterView.h"
#import "MyLayout.h"

@interface AllTest1TableViewHeaderFooterView()

@property(nonatomic, strong) UIView *underLineView;
@property(nonatomic, copy) void(^action)(NSInteger index);

@end

@implementation AllTest1TableViewHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        MyFrameLayout *rootLayout = [MyFrameLayout new];
        rootLayout.widthSize.equalTo(self.contentView.widthSize);
        rootLayout.heightSize.equalTo(self.contentView.heightSize);
        [self.contentView addSubview:rootLayout];
        
        MyFrameLayout *leftItemLayout = [self createItemLayout:NSLocalizedString(@"Show", @"") withTag:0];
        leftItemLayout.widthSize.equalTo(rootLayout.widthSize).multiply(1/3.0);
        leftItemLayout.heightSize.equalTo(rootLayout.heightSize);
        leftItemLayout.highlightedOpacity = 0.5;
        [rootLayout addSubview:leftItemLayout];
        
        MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor lightGrayColor]];
        bld.tailIndent = bld.headIndent = 5;
        
        MyFrameLayout *centerItemLayout = [self createItemLayout:NSLocalizedString(@"Topic", @"") withTag:1];
        centerItemLayout.widthSize.equalTo(rootLayout.widthSize).multiply(1/3.0);
        centerItemLayout.heightSize.equalTo(rootLayout.heightSize);
        centerItemLayout.centerXPos.equalTo(@0);
        centerItemLayout.leadingBorderline = bld;
        centerItemLayout.highlightedOpacity = 0.5;
        [rootLayout addSubview:centerItemLayout];
        
        
        MyFrameLayout *rightItemLayout = [self createItemLayout:NSLocalizedString(@"Follow", @"") withTag:2];
        rightItemLayout.widthSize.equalTo(rootLayout.widthSize).multiply(1/3.0);
        rightItemLayout.heightSize.equalTo(rootLayout.heightSize);
        rightItemLayout.trailingPos.equalTo(@0);
        rightItemLayout.leadingBorderline = bld;
        rightItemLayout.highlightedOpacity = 0.5;
        [rootLayout addSubview:rightItemLayout];
        
        //底部的横线
        _underLineView = [UIView new];
        _underLineView.backgroundColor = [UIColor redColor];
        _underLineView.widthSize.equalTo(rootLayout.widthSize).multiply(1/3.0);
        _underLineView.heightSize.equalTo(@2);
        _underLineView.bottomPos.equalTo(@0);
        _underLineView.leadingPos.equalTo(@0).active = YES;   //设置左边位置有效
        _underLineView.centerXPos.equalTo(@0).active = NO;  //设置水平中间位置无效
        _underLineView.trailingPos.equalTo(@0).active = NO;    //设置右边位置无效
        [rootLayout addSubview:_underLineView];
        
        MyBorderline *rootLayoutBld = [[MyBorderline alloc] initWithColor:[UIColor lightGrayColor]];
        rootLayout.bottomBorderline = rootLayoutBld;
        rootLayout.topBorderline = rootLayoutBld;
        
    }
    
    return self;
}


-(void)setItemChangedAction:(void(^)(NSInteger index))action
{
    self.action = [action copy];
}


#pragma mark -- Layout Construction

-(MyFrameLayout*)createItemLayout:(NSString*)title withTag:(NSInteger)tag
{
    //创建一个框架条目布局，并设置触摸处理事件
    MyFrameLayout *itemLayout = [MyFrameLayout new];
    itemLayout.tag = tag;
    [itemLayout setTarget:self action:@selector(handleTap:)];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLabel sizeToFit];
    titleLabel.centerXPos.equalTo(@0);
    titleLabel.centerYPos.equalTo(@0); //标题尺寸由内容包裹，位置在布局视图中居中。
    [itemLayout addSubview:titleLabel];
    
    return itemLayout;
}


#pragma mark -- Handle Method

-(void)handleTap:(MyBaseLayout*)sender
{
    //调整underLineView的位置的有效值来实现位置移动。对于位置MyLayoutPos对象和尺寸对象MyLayoutSize来说有一个active属性来设置是否这个约束有效。
    switch (sender.tag) {
        case 0:
            self.underLineView.leadingPos.active = YES;
            self.underLineView.centerXPos.active = NO;
            self.underLineView.trailingPos.active = NO;
            break;
        case 1:
            self.underLineView.leadingPos.active = NO;
            self.underLineView.centerXPos.active = YES;
            self.underLineView.trailingPos.active = NO;
            break;
        case 2:
            self.underLineView.leadingPos.active = NO;
            self.underLineView.centerXPos.active = NO;
            self.underLineView.trailingPos.active = YES;
            break;
        default:
            NSAssert(0, @"oops!");
            break;
    }
    
    MyBaseLayout *layout = (MyBaseLayout*)sender.superview;
    [layout layoutAnimationWithDuration:0.2];
    
    if (self.action != nil)
        self.action(sender.tag);
}


@end


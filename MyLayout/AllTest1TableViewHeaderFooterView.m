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
        rootLayout.widthDime.equalTo(self.contentView.widthDime);
        rootLayout.heightDime.equalTo(self.contentView.heightDime);
        [self.contentView addSubview:rootLayout];
        
        MyFrameLayout *leftItemLayout = [self createItemLayout:@"晒单" withTag:0];
        leftItemLayout.widthDime.equalTo(rootLayout.widthDime).multiply(1/3.0);
        leftItemLayout.marginGravity = MyMarginGravity_Vert_Fill | MyMarginGravity_Horz_Left;
        leftItemLayout.highlightedOpacity = 0.5;
        [rootLayout addSubview:leftItemLayout];
        
        MyBorderLineDraw *bld = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
        bld.tailIndent = bld.headIndent = 5;
        
        MyFrameLayout *centerItemLayout = [self createItemLayout:@"话题" withTag:1];
        centerItemLayout.widthDime.equalTo(rootLayout.widthDime).multiply(1/3.0);
        centerItemLayout.marginGravity = MyMarginGravity_Vert_Fill | MyMarginGravity_Horz_Center;
        centerItemLayout.leftBorderLine = bld;
        centerItemLayout.highlightedOpacity = 0.5;
        [rootLayout addSubview:centerItemLayout];
        
        
        MyFrameLayout *rightItemLayout = [self createItemLayout:@"关注" withTag:2];
        rightItemLayout.widthDime.equalTo(rootLayout.widthDime).multiply(1/3.0);
        rightItemLayout.marginGravity = MyMarginGravity_Vert_Fill | MyMarginGravity_Horz_Right;
        rightItemLayout.leftBorderLine = bld;
        rightItemLayout.highlightedOpacity = 0.5;
        [rootLayout addSubview:rightItemLayout];
        
        //底部的横线
        _underLineView = [UIView new];
        _underLineView.myHeight = 2;
        _underLineView.backgroundColor = [UIColor redColor];
        _underLineView.widthDime.equalTo(rootLayout.widthDime).multiply(1/3.0);
        _underLineView.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Left;
        [rootLayout addSubview:_underLineView];
        
        MyBorderLineDraw *rootLayoutBld = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
        rootLayout.bottomBorderLine = rootLayoutBld;
        rootLayout.topBorderLine = rootLayoutBld;
        
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
    titleLabel.marginGravity = MyMarginGravity_Center;  //标题尺寸由内容包裹，位置在布局视图中居中。
    [itemLayout addSubview:titleLabel];
    
    return itemLayout;
}


#pragma mark -- Handle Method

-(void)handleTap:(MyBaseLayout*)sender
{
    //调整underLineView的marginGravity值来实现位置移动。
    switch (sender.tag) {
        case 0:
            self.underLineView.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Left;
            break;
        case 1:
            self.underLineView.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Center;
            break;
        case 2:
            self.underLineView.marginGravity = MyMarginGravity_Vert_Bottom | MyMarginGravity_Horz_Right;
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


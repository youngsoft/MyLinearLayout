//
//  AllTest9CollectionViewCell.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2017/11/1.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "AllTest9CollectionViewCell.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface AllTest9CollectionViewCell()


@property(nonatomic, strong) MyLinearLayout *rootLayout;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation AllTest9CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.backgroundColor =  [CFTool color:(random()%14 + 1)];
        _rootLayout= [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _rootLayout.topPadding = 5;
        _rootLayout.bottomPadding = 5;
        _rootLayout.subviewVSpace = 10;
        _rootLayout.myHorzMargin = 0;
        _rootLayout.cacheEstimatedRect = YES;  //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
        [self.contentView addSubview:_rootLayout];
        
        _titleLabel = [UILabel new];
        _titleLabel.widthSize.equalTo(@(MyLayoutSize.wrap)).max(100);
        _titleLabel.heightSize.equalTo(@30);
        [_rootLayout addSubview:_titleLabel];
        
        _subtitleLabel = [UILabel new];
        _subtitleLabel.myWidth = 70;
        _subtitleLabel.myHeight = MyLayoutSize.wrap;
        [_rootLayout addSubview:_subtitleLabel];
        
    }
    
    return self;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    /*
     通过布局视图的sizeThatFits方法能够评估出UITableViewCell的动态高度。sizeThatFits并不会进行布局而只是评估布局的尺寸。
     因为cell的高度是自适应的，因此这里通过调用高度为wrap的布局视图的sizeThatFits来获取真实的高度。
     */
    return  [self.rootLayout sizeThatFits:targetSize];//如果使用系统自带的分割线，请记得将返回的高度height+1
    
}

-(void)setModel:(AllTest9DataModel *)model
{
    _titleLabel.text = model.title;
    _subtitleLabel.text = model.subtitle;
}

@end

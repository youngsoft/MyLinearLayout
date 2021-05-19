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
        _rootLayout.paddingTop = 5;
        _rootLayout.paddingBottom = 5;
        _rootLayout.subviewVSpace = 10;
        _rootLayout.myHorzMargin = 0;
        _rootLayout.gravity = MyGravity_Horz_Fill;
        [self.contentView addSubview:_rootLayout];
        
        _titleLabel = [UILabel new];
        _titleLabel.myHeight = MyLayoutSize.wrap;
        [_rootLayout addSubview:_titleLabel];
        
        _subtitleLabel = [UILabel new];
        _subtitleLabel.myTop = 10;
        _subtitleLabel.myHeight = MyLayoutSize.wrap;
        [_rootLayout addSubview:_subtitleLabel];
        
    }
    
    return self;
}

///自适应高度处理，需要重载这个方法来指定尺寸和位置。
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    UICollectionViewLayoutAttributes *retLayoutAttributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size =  [self.rootLayout sizeThatFits:CGSizeMake(200, 0)];
    
    retLayoutAttributes.size = size;
    //如果您需要对位置进行控制，则需要借助一些累加的处理来进行位置处理。
    return retLayoutAttributes;
    
}


-(void)setModel:(AllTest9DataModel *)model
{
    _titleLabel.text = model.title;
    _subtitleLabel.text = model.subtitle;
}

@end

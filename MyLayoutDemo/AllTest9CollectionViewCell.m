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

-  (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    ///自适应高度处理，需要重载这个方法来指定尺寸和位置。
    CGSize sz =  [self.rootLayout systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
    return sz;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    return [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
}

-(void)setModel:(AllTest9DataModel *)model {
    _titleLabel.text = model.title;
    _subtitleLabel.text = model.subtitle;
}

@end

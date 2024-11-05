//
//  AllTest10HeaderView.m
//  FriendListDemo
//
//  Created by 谢海龙 on 2018/5/8.
//  Copyright © 2018年 bsj_mac_2. All rights reserved.
//

#import "AllTest10HeaderView.h"
#import "AllTest10Model.h"

@interface AllTest10HeaderView ()
@property (strong, nonatomic) MyLinearLayout *rootLayout;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel     *nickNameLabel;
@property(nonatomic, strong) UILabel     *textMessageLabel;
@property(nonatomic, strong) UILabel     *timeLabel;
@property(nonatomic, strong) UILabel     *browLabel;
@property(nonatomic, strong) UILabel     *giveLikeLabel;
@property (strong, nonatomic) NSArray * nineImageViews;
@property (strong, nonatomic) MyFlowLayout * nineFlowLayout;
@property (strong, nonatomic) UIButton * giveLikeButton;
@property (strong, nonatomic) UIButton * commentsButton;
@property (strong, nonatomic) MyLinearLayout *giveLikeLayout;
@end

@implementation AllTest10HeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createLinearRootLayout];
    }
    return self;
}

#pragma mark -- Layout Construction

//用线性布局来实现UI界面
-(void)createLinearRootLayout
{
    _rootLayout= [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    _rootLayout.padding = UIEdgeInsetsMake(10, 10, 0.3, 10);
    _rootLayout.backgroundColor = [UIColor whiteColor];
    _rootLayout.myHorzMargin = MyLayoutPos.safeAreaMargin;
    _rootLayout.myHeight = MyLayoutSize.wrap;
    [self.contentView addSubview:_rootLayout];
    
    _headImageView = [UIImageView new];
    _headImageView.myWidth = 50;
    _headImageView.myHeight = 50;
    _headImageView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.clipsToBounds = YES;
    [_rootLayout addSubview:_headImageView];
    
    
    MyLinearLayout *messageLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    messageLayout.weight = 1;
    messageLayout.myLeading = 5;
    messageLayout.subviewVSpace = 5;
    [_rootLayout addSubview:messageLayout];
    
    _nickNameLabel = [UILabel new];
    _nickNameLabel.text = @"";
    _nickNameLabel.font = [UIFont systemFontOfSize:14];
    [messageLayout addSubview:_nickNameLabel];
    
    [self.nickNameLabel sizeToFit];
    
    _textMessageLabel = [UILabel new];
    _textMessageLabel.text = @"";
    _textMessageLabel.myLeading = 0;
    _textMessageLabel.myTrailing = 0;
    _textMessageLabel.myHeight = MyLayoutSize.wrap;
    [messageLayout addSubview:_textMessageLabel];
    
    _nineFlowLayout = [[MyFlowLayout alloc] initWithOrientation:MyOrientation_Vert arrangedCount:3];
    _nineFlowLayout.gravity = MyGravity_Horz_Fill;
    _nineFlowLayout.myHorzMargin = 0;
    _nineFlowLayout.subviewHSpace = 5;
    _nineFlowLayout.subviewVSpace = 5;
    _nineFlowLayout.myHeight = MyLayoutSize.wrap;
    [messageLayout addSubview:_nineFlowLayout];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"";
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [messageLayout addSubview:_timeLabel];
    
    MyLinearLayout *hLinearLayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    hLinearLayout.myHeight = MyLayoutSize.wrap;
    hLinearLayout.gravity = MyGravity_Horz_Between | MyGravity_Vert_Center;
    hLinearLayout.myHorzMargin = 0;
    [messageLayout addSubview:hLinearLayout];
    
    _browLabel = [UILabel new];
    _browLabel.text = @"";
    _browLabel.font = [UIFont systemFontOfSize:14];
    _browLabel.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap); //尺寸自适应。
    [hLinearLayout addSubview:_browLabel];
    
    MyLinearLayout *actionshLinearLayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    actionshLinearLayout.paddingRight = 5;
    actionshLinearLayout.myHeight = MyLayoutSize.wrap;
    actionshLinearLayout.gravity =  MyGravity_Vert_Center;
    actionshLinearLayout.myHorzMargin = 0;
    [hLinearLayout addSubview:actionshLinearLayout];
    
    _giveLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_giveLikeButton setImage:[UIImage imageNamed:@"friend_zan"] forState:UIControlStateNormal];
    [_giveLikeButton setImage:[UIImage imageNamed:@"zan_select"] forState:UIControlStateSelected];
    _giveLikeButton.mySize = CGSizeMake(30, 30);
    [_giveLikeButton addTarget:self action:@selector(praiseClick) forControlEvents:UIControlEventTouchUpInside];
    [_giveLikeButton sizeToFit];
    [actionshLinearLayout addSubview:_giveLikeButton];
    
    _commentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentsButton setImage:[UIImage imageNamed:@"interactive_fill"] forState:UIControlStateNormal];
    [_commentsButton addTarget:self action:@selector(commentsClick) forControlEvents:UIControlEventTouchUpInside];
    _commentsButton.myLeft = 20;
    _commentsButton.mySize = CGSizeMake(30, 30);
    [_commentsButton sizeToFit];
    [actionshLinearLayout addSubview:_commentsButton];
    
    MyLinearLayout *giveLikeLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    giveLikeLayout.padding = UIEdgeInsetsMake(8, 5, 8, 5);
    giveLikeLayout.myHorzMargin = 0;
    giveLikeLayout.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    [messageLayout addSubview:giveLikeLayout];
    _giveLikeLayout = giveLikeLayout;
    _giveLikeLabel = [UILabel new];
    _giveLikeLabel.text = @"";
    _giveLikeLabel.textColor = [UIColor blueColor];
    _giveLikeLabel.font = [UIFont systemFontOfSize:12];
    _giveLikeLabel.myHorzMargin = 0;
    _giveLikeLabel.myHeight = MyLayoutSize.wrap;
    [giveLikeLayout addSubview:_giveLikeLabel];
    
}

- (void)praiseClick {
    if (self.praiseClickHandler) {
        self.praiseClickHandler(self,self.model);
    }
}

- (void)commentsClick {
    if (self.commentsClickHandler) {
        self.commentsClickHandler(self,self.model);
    }
}

- (void)setCountWithImageArray:(NSArray *)array {
    [_nineFlowLayout removeAllSubviews];
    __weak typeof(self) weakSelf = self;
    [self.nineImageViews enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < array.count) {
            imageView.image = [UIImage imageNamed:array[idx]];
            [weakSelf.nineFlowLayout addSubview:imageView];
        }
    }];
}

- (void)setModel:(AllTest10Model *)model {
    _model = model;
    
    UIImage *image = [UIImage imageNamed:model.icon];
    _headImageView.image = image;
    _giveLikeButton.selected = model.isGiveLike;
    _nickNameLabel.text = model.name;
    [_nickNameLabel sizeToFit];
    _textMessageLabel.text = model.content;
    [_textMessageLabel sizeToFit];
    _timeLabel.text = model.time;
    [_timeLabel sizeToFit];
    _browLabel.text = [NSString stringWithFormat:@"浏览%ld次",model.browCount];
    [_browLabel sizeToFit];
    
    NSString *giveLikeText = model.giveLikeNames.count > 0 ? [NSString stringWithFormat:@"%@等点了👍",[model.giveLikeNames componentsJoinedByString:@"、"]] : @"";
    _giveLikeLayout.visibility = model.giveLikeNames.count > 0 ? MyVisibility_Visible : MyVisibility_Gone;
    _nineFlowLayout.visibility = model.commentsImageUrls.count > 0 ? MyVisibility_Visible : MyVisibility_Gone;
    _giveLikeLabel.text = giveLikeText;
    [_giveLikeLabel sizeToFit];
    [self setCountWithImageArray:model.commentsImageUrls];
}

//如果您的最低支持是iOS8，那么你可以重载这个方法来动态的评估cell的高度，Autolayout内部是通过这个方法来评估高度的，因此如果用MyLayout实现的话就不需要调用基类的方法，而是调用根布局视图的sizeThatFits来评估获取动态的高度。
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    //如果你的界面要支持横屏的话，因为iPhoneX的横屏左右有44的安全区域，所以这里要减去左右的安全区域的值，来作为布局宽度尺寸的评估值。
    //如果您的界面不需要支持横屏，或者延伸到安全区域外则不需要做这个特殊处理，而直接使用else部分的代码即可。
    return [self.rootLayout sizeThatFits:CGSizeMake(targetSize.width - self.safeAreaInsets.left - self.safeAreaInsets.right, targetSize.height)];
}

- (NSArray *)nineImageViews {
    if (!_nineImageViews) {
        NSMutableArray *imageViewArray = [NSMutableArray array];
        for (int i = 0; i<9; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
            imageView.heightSize.equalTo(imageView.widthSize);
            [imageViewArray addObject:imageView];
        }
        _nineImageViews = [imageViewArray copy];
    }
    return _nineImageViews;
}

@end

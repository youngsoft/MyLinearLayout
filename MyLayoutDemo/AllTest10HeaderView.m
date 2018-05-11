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
//    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.backgroundColor = [UIColor whiteColor];
    /*
     在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是动态的，请务必在将布局视图添加到contentView之前进行如下设置：
     _rootLayout.widthSize.equalTo(self.contentView.widthSize);
     _rootLayout.wrapContentHeight = YES;
     */
    // _rootLayout.widthSize.equalTo(self.contentView.widthSize);
    _rootLayout.myHorzMargin = MyLayoutPos.safeAreaMargin;
    _rootLayout.wrapContentHeight = YES;
    _rootLayout.wrapContentWidth = NO;
    [self.contentView addSubview:_rootLayout];  //如果您将布局视图作为子视图添加到UITableViewCell本身，并且同时用了myLeft和myRight来做边界的话，那么有可能最终展示的宽度会不正确。经过试验是因为对UITableViewCell本身的KVO监控所得到的新老尺寸的问题导致的这应该是iOS的一个BUG。所以这里建议最好是把布局视图添加到UITableViewCell的子视图contentView里面去。
    
    
    
    /*
     用线性布局实现时，整体用一个水平线性布局：左边是头像，右边是一个垂直的线性布局。垂直线性布局依次加入昵称、文本消息、图片消息。
     */
    
    
    _headImageView = [UIImageView new];
    _headImageView.myWidth = 50;
    _headImageView.myHeight = 50;
    _headImageView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.clipsToBounds = YES;
    [_rootLayout addSubview:_headImageView];
    
    
    MyLinearLayout *messageLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    messageLayout.weight = 1;
    messageLayout.myLeading = 5;  //前面2行代码描述的是垂直布局占用除头像外的所有宽度，并和头像保持5个点的间距。
    messageLayout.subviewVSpace = 5; //垂直布局里面所有子视图都保持5个点的间距。
    [_rootLayout addSubview:messageLayout];
    
    _nickNameLabel = [UILabel new];
    _nickNameLabel.text = @"";
    _nickNameLabel.font = [UIFont systemFontOfSize:14];
    [messageLayout addSubview:_nickNameLabel];
    
    [self.nickNameLabel sizeToFit];
    
    _textMessageLabel = [UILabel new];
    _textMessageLabel.text = @"";
    _textMessageLabel.myLeading = 0;
    _textMessageLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _textMessageLabel.wrapContentHeight = YES; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将wrapContentHeight设置为YES。
    [messageLayout addSubview:_textMessageLabel];
    
    _nineFlowLayout = [[MyFlowLayout alloc] initWithOrientation:MyOrientation_Vert arrangedCount:3];
    _nineFlowLayout.gravity = MyGravity_Horz_Fill;  //所有子视图水平填充，也就是所有子视图的宽度相等。
    _nineFlowLayout.myHorzMargin = 0;
    _nineFlowLayout.subviewHSpace = 5;
    _nineFlowLayout.subviewVSpace = 5;
    _nineFlowLayout.wrapContentHeight = YES;
    _nineFlowLayout.wrapContentWidth = NO;
    [messageLayout addSubview:_nineFlowLayout];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"";
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [messageLayout addSubview:_timeLabel];
    
    MyLinearLayout *hLinearLayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    hLinearLayout.wrapContentHeight = YES;
    hLinearLayout.gravity = MyGravity_Horz_Between | MyGravity_Vert_Center;
    hLinearLayout.myHorzMargin = 0;
    [messageLayout addSubview:hLinearLayout];
    
    _browLabel = [UILabel new];
    _browLabel.text = @"";
    _browLabel.font = [UIFont systemFontOfSize:14];
    _browLabel.wrapContentWidth = YES;
    _browLabel.wrapContentHeight = YES; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将wrapContentHeight设置为YES。
    [hLinearLayout addSubview:_browLabel];
    
    MyLinearLayout *actionshLinearLayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    actionshLinearLayout.rightPadding = 5;
    actionshLinearLayout.wrapContentHeight = YES;
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
    _giveLikeLabel.wrapContentHeight = YES; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将wrapContentHeight设置为YES。
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
    _giveLikeLayout.myVisibility = model.giveLikeNames.count > 0 ? MyVisibility_Visible : MyVisibility_Gone;
    _nineFlowLayout.myVisibility = model.commentsImageUrls.count > 0 ? MyVisibility_Visible : MyVisibility_Gone;
    _giveLikeLabel.text = giveLikeText;
    [_giveLikeLabel sizeToFit];
    [self setCountWithImageArray:model.commentsImageUrls];
}

//如果您的最低支持是iOS8，那么你可以重载这个方法来动态的评估cell的高度，Autolayout内部是通过这个方法来评估高度的，因此如果用MyLayout实现的话就不需要调用基类的方法，而是调用根布局视图的sizeThatFits来评估获取动态的高度。
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    /*
     通过布局视图的sizeThatFits方法能够评估出UITableViewCell的动态高度。sizeThatFits并不会进行布局而只是评估布局的尺寸。
     因为cell的高度是自适应的，因此这里通过调用高度为wrap的布局视图的sizeThatFits来获取真实的高度。
     */
    
    if (@available(iOS 11.0, *)) {
        //如果你的界面要支持横屏的话，因为iPhoneX的横屏左右有44的安全区域，所以这里要减去左右的安全区域的值，来作为布局宽度尺寸的评估值。
        //如果您的界面不需要支持横屏，或者延伸到安全区域外则不需要做这个特殊处理，而直接使用else部分的代码即可。
        return [self.rootLayout sizeThatFits:CGSizeMake(targetSize.width - self.safeAreaInsets.left - self.safeAreaInsets.right, targetSize.height)];
    } else {
        return [self.rootLayout sizeThatFits:targetSize];  //如果使用系统自带的分割线，请记得将返回的高度height+1
    }
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

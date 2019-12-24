//
//  AllTest10Cell.m
//  FriendListDemo
//
//  Created by bsj_mac_2 on 2018/5/7.
//  Copyright © 2018年 bsj_mac_2. All rights reserved.
//

#import "AllTest10Cell.h"

@interface AllTest10Cell ()
@property(nonatomic, strong) UILabel     *commentsLabel;
@property (strong, nonatomic) MyLinearLayout *rootLayout;
@end

@implementation AllTest10Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        [self createLinearRootLayout];
    }
    
    return self;
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

#pragma mark -- Layout Construction

//用线性布局来实现UI界面
-(void)createLinearRootLayout
{
    _rootLayout= [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    _rootLayout.padding = UIEdgeInsetsMake(0, 65, 0, 10);
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.myHorzMargin = MyLayoutPos.safeAreaMargin;
    _rootLayout.myHeight = MyLayoutSize.wrap;
    //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
    MyBorderline  *bld = [[MyBorderline alloc] initWithColor:[UIColor whiteColor]];
    self.rootLayout.bottomBorderline = bld;
    [self.contentView addSubview:_rootLayout];
    MyLinearLayout *giveLikeLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    giveLikeLayout.padding = UIEdgeInsetsMake(5, 6, 5, 6);
    giveLikeLayout.weight = 1;
    giveLikeLayout.myHorzMargin = 0;
    giveLikeLayout.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    [self.rootLayout addSubview:giveLikeLayout];
    
    _commentsLabel = [UILabel new];
    _commentsLabel.text = @"正文";
    _commentsLabel.textColor = [UIColor blueColor];
    _commentsLabel.font = [UIFont systemFontOfSize:12];
    _commentsLabel.myHorzMargin = 0;
    _commentsLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应
    [giveLikeLayout addSubview:_commentsLabel];
}

- (void)setCommentsText:(NSString *)text {
    self.commentsLabel.text = text;
}

@end

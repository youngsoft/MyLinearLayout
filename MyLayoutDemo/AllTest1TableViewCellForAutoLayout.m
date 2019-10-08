//
//  AllTest1TableViewCellForAutoLayout.m
//  MyLayout
//
//  Created by apple on 19/5/16.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "AllTest1TableViewCellForAutoLayout.h"
#import "CFTool.h"


@interface AllTest1TableViewCellForAutoLayout()

@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel     *nickNameLabel;
@property(nonatomic, strong) UILabel     *textMessageLabel;
@property(nonatomic, strong) UIImageView *imageMessageImageView;

@end


@implementation AllTest1TableViewCellForAutoLayout

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        /**
         * 您可以尝试用不同的布局来实现相同的功能。
         */
          [self createLinearRootLayout];
       // [self createRelativeRootLayout];
       // [self createFloatRootLayout];
       
        //如果是代码实现autolayout的话必须要将translatesAutoresizingMaskIntoConstraints 设置为NO。
        _rootLayout.translatesAutoresizingMaskIntoConstraints = NO;
        
        //设置布局视图的autolayout约束，这里是用iOS9提供的约束设置方法，您也可以用低级版本设置，以及用masonry来进行设置。
        [_rootLayout.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [_rootLayout.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        //目前MyLayout和AutoLayout相结合并且高度根据宽度自适应时只能通过明确设置宽度约束，暂时不支持同时设置左右约束来确定宽度的能力。
        [_rootLayout.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
        
        //这句代码很关键，表明self.contentView的高度随着子视图_rootLayout的高度自适应。
        [self.contentView.bottomAnchor constraintEqualToAnchor:_rootLayout.bottomAnchor constant:0].active = YES;

        
    }
    
    return self;
}

-(void)setModel:(AllTest1DataModel*)model isImageMessageHidden:(BOOL)isImageMessageHidden
{    
    self.headImageView.image = [UIImage imageNamed:model.headImage];
    [self.headImageView sizeToFit];
    
    
    self.nickNameLabel.text = model.nickName;
    [self.nickNameLabel sizeToFit];
    
    self.textMessageLabel.text = model.textMessage;
    
    if (model.imageMessage.length == 0)
    {
        self.imageMessageImageView.visibility = MyVisibility_Gone;
    }
    else
    {
        self.imageMessageImageView.image = [UIImage imageNamed:model.imageMessage];
        [self.imageMessageImageView sizeToFit];
        if (isImageMessageHidden)
        {
            self.imageMessageImageView.visibility = MyVisibility_Gone;
        }
        else
        {
            self.imageMessageImageView.visibility = MyVisibility_Visible;
        }
    }
    
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark -- Layout Construction

//用线性布局来实现UI界面
-(void)createLinearRootLayout
{
    _rootLayout= [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    _rootLayout.topPadding = 5;
    _rootLayout.bottomPadding = 5;
    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    _rootLayout.widthSize.equalTo(nil);
    [self.contentView addSubview:_rootLayout];
    
    
    
    /*
       用线性布局实现时，整体用一个水平线性布局：左边是头像，右边是一个垂直的线性布局。垂直线性布局依次加入昵称、文本消息、图片消息。
     */
    
    
    _headImageView = [UIImageView new];
    [_rootLayout addSubview:_headImageView];
    
    
    MyLinearLayout *messageLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    messageLayout.weight = 1;
    messageLayout.myLeading = 5;  //前面2行代码描述的是垂直布局占用除头像外的所有宽度，并和头像保持5个点的间距。
    messageLayout.subviewVSpace = 5; //垂直布局里面所有子视图都保持5个点的间距。
    [_rootLayout addSubview:messageLayout];
    
    
    _nickNameLabel = [UILabel new];
    _nickNameLabel.textColor = [CFTool color:3];
    _nickNameLabel.font = [CFTool font:17];
    [messageLayout addSubview:_nickNameLabel];
    
    
    _textMessageLabel = [UILabel new];
    _textMessageLabel.font = [CFTool font:15];
    _textMessageLabel.textColor = [CFTool color:4];
    _textMessageLabel.myLeading = 0;
    _textMessageLabel.myTrailing = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _textMessageLabel.myHeight = MyLayoutSize.wrap; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    [messageLayout addSubview:_textMessageLabel];
    
    
    _imageMessageImageView = [UIImageView new];
    _imageMessageImageView.myCenterX = 0;  //图片视图在父布局视图中水平居中。
    [messageLayout addSubview:_imageMessageImageView];
}

//用相对布局来实现UI界面
-(void)createRelativeRootLayout
{
    _rootLayout = [MyRelativeLayout new];
    _rootLayout.topPadding = 5;
    _rootLayout.bottomPadding = 5;
    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    [self.contentView addSubview:_rootLayout];
    
  
    /*
     用相对布局实现时，左边是头像视图，昵称文本在头像视图的右边，文本消息在昵称文本的下面，图片消息在文本消息的下面。
     */
    
    _headImageView = [UIImageView new];
    [_rootLayout addSubview:_headImageView];
    
    
    _nickNameLabel = [UILabel new];
    _nickNameLabel.textColor = [CFTool color:3];
    _nickNameLabel.font = [CFTool font:17];
    _nickNameLabel.leadingPos.equalTo(_headImageView.trailingPos).offset(5);  //昵称文本的左边在头像视图的右边并偏移5个点。
    [_rootLayout addSubview:_nickNameLabel];
    
    
    _textMessageLabel = [UILabel new];
    _textMessageLabel.font = [CFTool font:15];
    _textMessageLabel.textColor = [CFTool color:4];
    _textMessageLabel.leadingPos.equalTo(_headImageView.trailingPos).offset(5); //文本消息的左边在头像视图的右边并偏移5个点。
    _textMessageLabel.trailingPos.equalTo(_rootLayout.trailingPos);    //文本消息的右边和父布局的右边对齐。上面2行代码也同时确定了文本消息的宽度。
    _textMessageLabel.topPos.equalTo(_nickNameLabel.bottomPos).offset(5); //文本消息的顶部在昵称文本的底部并偏移5个点。
    _textMessageLabel.heightSize.equalTo(@(MyLayoutSize.wrap)); //如果想让文本消息的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应
    [_rootLayout addSubview:_textMessageLabel];
    
    
    _imageMessageImageView = [UIImageView new];
    _imageMessageImageView.centerXPos.equalTo(@5);  //图片消息的水平中心点等于父布局的水平中心点并偏移5个点的位置,这里要偏移5的原因是头像和消息之间需要5个点的间距。
    _imageMessageImageView.topPos.equalTo(_textMessageLabel.bottomPos).offset(5); //图片消息的顶部在文本消息的底部并偏移5个点。
    [_rootLayout addSubview:_imageMessageImageView];

}

//用浮动布局来实现UI界面
-(void)createFloatRootLayout
{
    _rootLayout= [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    _rootLayout.topPadding = 5;
    _rootLayout.bottomPadding = 5;
    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    [self.contentView addSubview:_rootLayout];

    /*
     用浮动布局实现时，头像视图浮动到最左边，昵称文本跟在头像视图后面并占用剩余宽度，文本消息也跟在头像视图后面并占用剩余宽度，图片消息不浮动占据所有宽度。
     要想了解浮动布局的原理，请参考文章：http://www.jianshu.com/p/0c075f2fdab2 中的介绍。
     */

    
    _headImageView = [UIImageView new];
    _headImageView.myTrailing = 5;  //右边保留出5个点的视图间距。
    [_rootLayout addSubview:_headImageView];
    
    _nickNameLabel = [UILabel new];
    _nickNameLabel.textColor = [CFTool color:3];
    _nickNameLabel.font = [CFTool font:17];
    _nickNameLabel.myBottom = 5;  //下边保留出5个点的视图间距。
    _nickNameLabel.weight = 1;          //占用剩余宽度。
    [_rootLayout addSubview:_nickNameLabel];
    
    _textMessageLabel = [UILabel new];
    _textMessageLabel.font = [CFTool font:15];
    _textMessageLabel.textColor = [CFTool color:4];
    _textMessageLabel.weight = 1;  //占用剩余宽度
    _textMessageLabel.myHeight = MyLayoutSize.wrap; //如果想让文本消息的高度是动态的，请在设置明确宽度的情况下将高度设置为自适应。
    [_rootLayout addSubview:_textMessageLabel];
    
    _imageMessageImageView = [UIImageView new];
    _imageMessageImageView.myTop = 5;
    _imageMessageImageView.reverseFloat = YES; //反向浮动
    _imageMessageImageView.weight = 1;   //占用剩余空间。
    _imageMessageImageView.contentMode = UIViewContentModeCenter;
    [_rootLayout addSubview:_imageMessageImageView];
}

@end

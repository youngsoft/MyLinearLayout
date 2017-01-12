//
//  AllTest1TableViewCell.m
//  MyLayout
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "AllTest1TableViewCell.h"
#import "CFTool.h"


@interface AllTest1TableViewCell()

@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel     *nickNameLabel;
@property(nonatomic, strong) UILabel     *textMessageLabel;
@property(nonatomic, strong) UIImageView *imageMessageImageView;

@end


@implementation AllTest1TableViewCell

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
    
    self.imageMessageImageView.hidden = (model.imageMessage.length == 0);
    if (model.imageMessage.length != 0)
    {
        self.imageMessageImageView.image = [UIImage imageNamed:model.imageMessage];
        [self.imageMessageImageView sizeToFit];
        self.imageMessageImageView.hidden = isImageMessageHidden;
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
    _rootLayout= [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Horz];
    _rootLayout.topPadding = 5;
    _rootLayout.bottomPadding = 5;
 
    /*
     在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是动态的，请务必在将布局视图添加到contentView之前进行如下设置：
     _rootLayout.widthDime.equalTo(self.contentView.widthDime);
     _rootLayout.wrapContentHeight = YES;
     */
    _rootLayout.widthDime.equalTo(self.contentView.widthDime);
    _rootLayout.wrapContentHeight = YES;
    _rootLayout.wrapContentWidth = NO;
    [self.contentView addSubview:_rootLayout];  //如果您将布局视图作为子视图添加到UITableViewCell本身，并且同时用了myLeftMargin和myRightMargin来做边界的话，那么有可能最终展示的宽度会不正确。经过试验是因为对UITableViewCell本身的KVO监控所得到的新老尺寸的问题导致的这应该是iOS的一个BUG。所以这里建议最好是把布局视图添加到UITableViewCell的子视图contentView里面去。
    
    
    
    /*
       用线性布局实现时，整体用一个水平线性布局：左边是头像，右边是一个垂直的线性布局。垂直线性布局依次加入昵称、文本消息、图片消息。
     */
    
    
    _headImageView = [UIImageView new];
    [_rootLayout addSubview:_headImageView];
    
    
    MyLinearLayout *messageLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    messageLayout.weight = 1;
    messageLayout.myLeftMargin = 5;  //前面2行代码描述的是垂直布局占用除头像外的所有宽度，并和头像保持5个点的间距。
    messageLayout.subviewMargin = 5; //垂直布局里面所有子视图都保持5个点的间距。
    [_rootLayout addSubview:messageLayout];
    
    
    _nickNameLabel = [UILabel new];
    _nickNameLabel.textColor = [CFTool color:3];
    _nickNameLabel.font = [CFTool font:17];
    [messageLayout addSubview:_nickNameLabel];
    
    
    _textMessageLabel = [UILabel new];
    _textMessageLabel.font = [CFTool font:15];
    _textMessageLabel.textColor = [CFTool color:4];
    _textMessageLabel.myLeftMargin = 0;
    _textMessageLabel.myRightMargin = 0; //垂直线性布局里面如果同时设置了左右边距则能确定子视图的宽度，这里表示宽度和父视图相等。
    _textMessageLabel.numberOfLines = 0;
    _textMessageLabel.flexedHeight = YES; //如果想让文本的高度是动态的，请在设置明确宽度的情况下将numberOfLines设置为0并且将flexedHeight设置为YES。
    [messageLayout addSubview:_textMessageLabel];
    
    
    _imageMessageImageView = [UIImageView new];
    _imageMessageImageView.myCenterXOffset = 0;  //图片视图在父布局视图中水平居中。
    [messageLayout addSubview:_imageMessageImageView];
}

//用相对布局来实现UI界面
-(void)createRelativeRootLayout
{
    _rootLayout = [MyRelativeLayout new];
    _rootLayout.topPadding = 5;
    _rootLayout.bottomPadding = 5;
 
    /*
     在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是动态的，请务必在将布局视图添加到contentView之前进行如下设置：
     _rootLayout.widthDime.equalTo(self.contentView.widthDime);
     _rootLayout.wrapContentHeight = YES;
     */
    _rootLayout.widthDime.equalTo(self.contentView.widthDime);
    _rootLayout.wrapContentHeight = YES;
    [self.contentView addSubview:_rootLayout];
    
  
    /*
     用相对布局实现时，左边是头像视图，昵称文本在头像视图的右边，文本消息在昵称文本的下面，图片消息在文本消息的下面。
     */
    
    _headImageView = [UIImageView new];
    [_rootLayout addSubview:_headImageView];
    
    
    _nickNameLabel = [UILabel new];
    _nickNameLabel.textColor = [CFTool color:3];
    _nickNameLabel.font = [CFTool font:17];
    _nickNameLabel.leftPos.equalTo(_headImageView.rightPos).offset(5);  //昵称文本的左边在头像视图的右边并偏移5个点。
    [_rootLayout addSubview:_nickNameLabel];
    
    
    _textMessageLabel = [UILabel new];
    _textMessageLabel.font = [CFTool font:15];
    _textMessageLabel.textColor = [CFTool color:4];
    _textMessageLabel.leftPos.equalTo(_headImageView.rightPos).offset(5); //文本消息的左边在头像视图的右边并偏移5个点。
    _textMessageLabel.rightPos.equalTo(_rootLayout.rightPos);    //文本消息的右边和父布局的右边对齐。上面2行代码也同时确定了文本消息的宽度。
    _textMessageLabel.topPos.equalTo(_nickNameLabel.bottomPos).offset(5); //文本消息的顶部在昵称文本的底部并偏移5个点。
    _textMessageLabel.numberOfLines = 0;
    _textMessageLabel.flexedHeight = YES; //如果想让文本消息的高度是动态的，请在设置明确宽度的情况下将numberOfLines设置为0并且将flexedHeight设置为YES。
    [_rootLayout addSubview:_textMessageLabel];
    
    
    _imageMessageImageView = [UIImageView new];
    _imageMessageImageView.centerXPos.equalTo(@5);  //图片消息的水平中心点等于父布局的水平中心点并偏移5个点的位置,这里要偏移5的原因是头像和消息之间需要5个点的间距。
    _imageMessageImageView.topPos.equalTo(_textMessageLabel.bottomPos).offset(5); //图片消息的顶部在文本消息的底部并偏移5个点。
    [_rootLayout addSubview:_imageMessageImageView];

}

//用浮动布局来实现UI界面
-(void)createFloatRootLayout
{
    _rootLayout= [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    _rootLayout.topPadding = 5;
    _rootLayout.bottomPadding = 5;
    
    /*
     在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是动态的，请务必在将布局视图添加到contentView之前进行如下设置：
     _rootLayout.widthDime.equalTo(self.contentView.widthDime);
     _rootLayout.wrapContentHeight = YES;
     */
    _rootLayout.widthDime.equalTo(self.contentView.widthDime);
    _rootLayout.wrapContentHeight = YES;
    [self.contentView addSubview:_rootLayout];

    /*
     用浮动布局实现时，头像视图浮动到最左边，昵称文本跟在头像视图后面并占用剩余宽度，文本消息也跟在头像视图后面并占用剩余宽度，图片消息不浮动占据所有宽度。
     要想了解浮动布局的原理，请参考文章：http://www.jianshu.com/p/0c075f2fdab2 中的介绍。
     */

    
    _headImageView = [UIImageView new];
    _headImageView.myRightMargin = 5;  //右边保留出5个点的视图间距。
    [_rootLayout addSubview:_headImageView];
    
    _nickNameLabel = [UILabel new];
    _nickNameLabel.textColor = [CFTool color:3];
    _nickNameLabel.font = [CFTool font:17];
    _nickNameLabel.myBottomMargin = 5;  //下边保留出5个点的视图间距。
    _nickNameLabel.weight = 1;          //占用剩余宽度。
    [_rootLayout addSubview:_nickNameLabel];
    
    _textMessageLabel = [UILabel new];
    _textMessageLabel.font = [CFTool font:15];
    _textMessageLabel.textColor = [CFTool color:4];
    _textMessageLabel.weight = 1;  //占用剩余宽度
    _textMessageLabel.numberOfLines = 0;
    _textMessageLabel.flexedHeight = YES; //如果想让文本消息的高度是动态的，请在设置明确宽度的情况下将numberOfLines设置为0并且将flexedHeight设置为YES。
    [_rootLayout addSubview:_textMessageLabel];
    
    _imageMessageImageView = [UIImageView new];
    _imageMessageImageView.myTopMargin = 5;
    _imageMessageImageView.reverseFloat = YES; //反向浮动
    _imageMessageImageView.weight = 1;   //占用剩余空间。
    _imageMessageImageView.contentMode = UIViewContentModeCenter;
    [_rootLayout addSubview:_imageMessageImageView];
}

@end

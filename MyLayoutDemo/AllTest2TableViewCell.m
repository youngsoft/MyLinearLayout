//
//  AllTest2TableViewCell.m
//  MyLayout
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "AllTest2TableViewCell.h"

#import "CFTool.h"


@interface AllTest2TableViewCell()

@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel     *nameLabel;
@property(nonatomic, strong) UILabel     *descLabel;
@property(nonatomic, strong) UILabel     *priceLabel;

@end


@implementation AllTest2TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        /**
         * 您可以尝试用不同的布局来实现相同的功能。
         */
        //[self createLinearRootLayout];
        [self createRelativeRootLayout];
       //  [self createFloatRootLayout];
    }
    
    return self;
}

-(void)setModel:(AllTest2DataModel*)model
{
    self.headImageView.image = [UIImage imageNamed:model.headImage];
    [self.headImageView sizeToFit];
    
    self.nameLabel.text = model.name;
    
    self.descLabel.text = model.desc;
    
    self.priceLabel.text = model.price;
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
    /*
      在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是静态的，请务必在将布局视图添加到contentView之前进行如下设置：
          rootLayout.myMargin = 0;
     */
    
    MyLinearLayout *rootLayout= [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    rootLayout.myMargin = 0;   //四周边距是0表示布局视图的尺寸和contentView的尺寸一致。
    [self.contentView addSubview:rootLayout]; //如果您将布局视图作为子视图添加到UITableViewCell本身，并且同时用了myLeft和myRight来做边界的话，那么有可能最终展示的宽度会不正确。经过试验是因为对UITableViewCell本身的KVO监控所得到的新老尺寸的问题导致的这应该是iOS的一个BUG。所以这里建议最好是把布局视图添加到UITableViewCell的子视图contentView里面去。
    
    MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor lightGrayColor]];
    bld.headIndent = bld.tailIndent = 10;
    rootLayout.bottomBorderline = bld;
    rootLayout.leftPadding = rootLayout.rightPadding = 10;  //两边保留10的内边距。
    rootLayout.gravity = MyGravity_Vert_Center;       //整个布局内容垂直居中。
    
    /*
      如果用线性布局的话，分为左中右三段，因此用水平线性布局：左边头像，中间用户信息，右边价格。中间用户信息在用一个垂直线性布局分为上下两部分：上面是用户名称和几个图标，下面是个人介绍。而用户名称和图标部分右通过建立一个水平线性布局来实现。
     */
    
    //头像视图
    _headImageView  = [UIImageView new];
    [rootLayout addSubview:_headImageView];
    
    
    //中间用户信息是一个垂直线性布局：上部分是姓名，以及一些小图标这部分组成一个水平线性布局。下面是一行长的描述文字。
    MyLinearLayout *userInfoLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    userInfoLayout.wrapContentHeight = YES;  //高度由子视图决定
    userInfoLayout.weight = 1;               //中间部分的宽度占用整个水平线性布局剩余的空间。
    userInfoLayout.gravity = MyGravity_Horz_Fill;   //里面的子视图宽度和布局视图相等。
    userInfoLayout.subviewVSpace = 5;       //子视图间距为5。
    [rootLayout addSubview:userInfoLayout];
    
    
    //姓名信息部分，一个水平线性布局：左边名称，后面两个操作按钮，整体底部对齐。
    MyLinearLayout *userNameLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    userNameLayout.wrapContentHeight = YES;   //高度由子视图决定
    userNameLayout.wrapContentWidth  = NO;    //因为布局的宽度是和父布局相等，因此这里必须要设置为NO！！否则会有约束冲突。
    userNameLayout.subviewHSpace = 5;    //子视图之间宽度间隔是5
    userNameLayout.gravity = MyGravity_Vert_Bottom;  //整体垂直底部对齐。
    [userInfoLayout addSubview:userNameLayout];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [CFTool font:17];
    _nameLabel.textColor = [CFTool color:3];
    //_nameLabel的宽度根据内容自适应，但是最大的宽度是父视图的宽度的1倍，再减去5+14+5+14。这里的5是视图之间的间距，14是后面两个图片的宽度。
    //这个设置的意思是_nameLabel的宽可以动态增长，但是不能超过父视图的宽度，并且要保证后面的2个图片视图显示出来。
    //您可以通过uBound方法设置尺寸的最大上边界。具体参见对uBound的方法的详细介绍。
    _nameLabel.widthSize.equalTo(_nameLabel.widthSize).uBound(userNameLayout.widthSize, -(5 + 14 + 5 + 14), 1);
    _nameLabel.heightSize.equalTo(@25);
    [userNameLayout addSubview:_nameLabel];
    
    UIImageView *editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    [userNameLayout addSubview:editImageView];
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"del"]];
    [userNameLayout addSubview:shareImageView];
    
    //描述部分
    _descLabel = [UILabel new];
    _descLabel.textColor = [CFTool color:4];
    _descLabel.font = [CFTool font:15];
    _descLabel.adjustsFontSizeToFitWidth = YES;
    _descLabel.wrapContentHeight = YES;  //2行高度，高度根据内容确定。
    _descLabel.numberOfLines = 2;
    [userInfoLayout addSubview:_descLabel];
    
    
    
    //右边的价格。
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [CFTool color:4];
    _priceLabel.font = [CFTool font:14];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    //宽度最宽为100,注意到这里使用了宏MYDIMESCALEW表示会根据屏幕的宽度来对100进行缩放。这个100是按iPhone6为标准设置的。具体请参考MyDimeScale类。
    _priceLabel.widthSize.equalTo(_priceLabel.widthSize).uBound(@(MYDIMESCALEW(100)), 0, 1).lBound(@(MYDIMESCALEW(50)), 0, 1);
    _priceLabel.heightSize.equalTo(@25);
    _priceLabel.myLeading = 10;
    [rootLayout addSubview:_priceLabel];
    
 }

//用相对布局来实现UI界面
-(void)createRelativeRootLayout
{
    /*
     在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是静态的，请务必在将布局视图添加到contentView之前进行如下设置：
     rootLayout.myMargin = 0;
     */
  
    MyRelativeLayout *rootLayout= [MyRelativeLayout new];
    rootLayout.myMargin = 0;   //四周边距是0表示布局视图的尺寸和contentView的尺寸一致。
    [self.contentView addSubview:rootLayout];
    
    MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor lightGrayColor]];
    bld.headIndent = bld.tailIndent = 10;
    rootLayout.bottomBorderline = bld;
    rootLayout.leftPadding = rootLayout.rightPadding = 10;  //两边保留10的内边距。
    
    
    _headImageView  = [UIImageView new];
    _headImageView.centerYPos.equalTo(rootLayout.centerYPos);
    _headImageView.leadingPos.equalTo(rootLayout.leadingPos);
    [rootLayout addSubview:_headImageView];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [CFTool color:4];
    _priceLabel.font = [CFTool font:14];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _priceLabel.trailingPos.equalTo(rootLayout.trailingPos);
    _priceLabel.centerYPos.equalTo(rootLayout.centerYPos);
    //priceLabel的宽度根据内容自适应，但是最大的宽度是100，最小的宽度是50。注意到这里使用了宏MYDIMESCALEW表示会根据屏幕的宽度来对100进行缩放。这个100是在DEMO中是按iPhone6为标准设置的。具体请参考MyDimeScale类的介绍。
    _priceLabel.widthSize.equalTo(_priceLabel.widthSize).uBound(@(MYDIMESCALEW(100)), 0, 1).lBound(@(MYDIMESCALEW(50)), 0, 1);
    _priceLabel.heightSize.equalTo(@25);
    [rootLayout addSubview:_priceLabel];

    
    _nameLabel = [UILabel new];
    _nameLabel.font = [CFTool font:17];
    _nameLabel.textColor = [CFTool color:3];
    _nameLabel.widthSize.equalTo(_nameLabel.widthSize); //视图的宽度由内容包裹
    _nameLabel.heightSize.equalTo(@25);
    _nameLabel.leadingPos.equalTo(_headImageView.trailingPos);
    //1.3.0版本最新支持。设置_nameLabel的右边距最大是_priceLabel的左边距，再偏移两个小图标和间距的距离。这样当_nameLabel的尺寸超过这个最大的右边距时就会自动的缩小视图的宽度。
    _nameLabel.trailingPos.uBound(_priceLabel.leadingPos, (5 + 14 + 5 + 14));
    [rootLayout addSubview:_nameLabel];
    
    UIImageView *editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    editImageView.leadingPos.equalTo(_nameLabel.trailingPos).offset(5);
    editImageView.bottomPos.equalTo(_nameLabel.bottomPos);
    [rootLayout addSubview:editImageView];

    
    UIImageView *shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"del"]];
    shareImageView.leadingPos.equalTo(editImageView.trailingPos).offset(5);
    shareImageView.bottomPos.equalTo(editImageView.bottomPos);
    [rootLayout addSubview:shareImageView];
    

    
    _descLabel = [UILabel new];
    _descLabel.textColor = [CFTool color:4];
    _descLabel.font = [CFTool font:15];
    _descLabel.adjustsFontSizeToFitWidth = YES;
    _descLabel.wrapContentHeight = YES;  //2行高度，高度根据内容确定。
    _descLabel.numberOfLines = 2;
    _descLabel.leadingPos.equalTo(_nameLabel.leadingPos);
    _descLabel.trailingPos.equalTo(_priceLabel.leadingPos).offset(10);
    [rootLayout addSubview:_descLabel];
    
    _nameLabel.centerYPos.equalTo(@[_descLabel.centerYPos.offset(5)]);  //_nameLabel,_descLabel整体垂直居中。这里通过将centerYPos设置为一个数组的值来表示。具体参考关于相对布局的介绍和DEMO。

}

-(void)createFloatRootLayout
{
    /*
     在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是静态的，请务必在将布局视图添加到contentView之前进行如下设置：
     rootLayout.myMargin = 0;
     */
    
    MyFloatLayout *rootLayout= [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.myMargin = 0;   //四周边距是0表示布局视图的尺寸和contentView的尺寸一致。
    [self.contentView addSubview:rootLayout];
    
    MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor lightGrayColor]];
    bld.headIndent = bld.tailIndent = 10;
    rootLayout.bottomBorderline = bld;
    rootLayout.leftPadding = rootLayout.rightPadding = 10;  //两边保留10的内边距。
    
    _headImageView = [UIImageView new];
    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    _headImageView.heightSize.equalTo(rootLayout.heightSize);
    [rootLayout addSubview:_headImageView];
    
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [CFTool color:4];
    _priceLabel.font = [CFTool font:14];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _priceLabel.reverseFloat = YES;
    _priceLabel.myLeading = 10;
    //priceLabel的宽度根据内容自适应，但是最大的宽度是100，最小的宽度是50。注意到这里使用了宏MYDIMESCALEW表示会根据屏幕的宽度来对100进行缩放。这个100是在DEMO中是按iPhone6为标准设置的。具体请参考MyDimeScale类的介绍。
    _priceLabel.widthSize.equalTo(_priceLabel.widthSize).uBound(@(MYDIMESCALEW(100)), 0, 1).lBound(@(MYDIMESCALEW(50)), 0, 1);
    _priceLabel.heightSize.equalTo(rootLayout.heightSize);
    [rootLayout addSubview:_priceLabel];
    
    
    MyFloatLayout *userInfoLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    userInfoLayout.heightSize.equalTo(rootLayout.heightSize);
    userInfoLayout.weight = 1;
    userInfoLayout.gravity = MyGravity_Vert_Center;
    userInfoLayout.subviewVSpace = 5;
    userInfoLayout.subviewHSpace = 5;
    [rootLayout addSubview:userInfoLayout];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [CFTool font:17];
    _nameLabel.textColor = [CFTool color:3];
    //_nameLabel的宽度根据内容自适应，但是最大的宽度是父视图的宽度的1倍，再减去5+14+5+14。这里的5是视图之间的间距，14是后面两个图片的宽度。
    //这个设置的意思是_nameLabel的宽可以动态增长，但是不能超过父视图的宽度，并且要保证后面的2个图片视图显示出来。
    //您可以通过uBound方法设置尺寸的最大上边界。具体参见对uBound的方法的详细介绍。
    _nameLabel.widthSize.equalTo(_nameLabel.widthSize).uBound(userInfoLayout.widthSize, -(5 + 14 + 5 + 14), 1);
    _nameLabel.heightSize.equalTo(@25);
    [userInfoLayout addSubview:_nameLabel];
    
    UIImageView *editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    [userInfoLayout addSubview:editImageView];
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"del"]];
    [userInfoLayout addSubview:shareImageView];
    
    _descLabel = [UILabel new];
    _descLabel.textColor = [CFTool color:4];
    _descLabel.font = [CFTool font:15];
    _descLabel.adjustsFontSizeToFitWidth = YES;
    _descLabel.wrapContentHeight = YES;  //2行高度，高度根据内容确定。
    _descLabel.numberOfLines = 2;
    _descLabel.clearFloat = YES;
    _descLabel.weight = 1;
    [userInfoLayout addSubview:_descLabel];
    
    
}


@end


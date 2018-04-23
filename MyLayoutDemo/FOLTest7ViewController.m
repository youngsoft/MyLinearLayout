//
//  FOLTest7ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "FOLTest7ViewController.h"
#import "MyLayout.h"
#import "CFTool.h"

@interface FOLTest7ViewController ()

@end

@implementation FOLTest7ViewController


-(void)loadView
{
    /*
       这个例子主要给大家演示，在浮动布局中也可以支持一行(列)内的子视图的对齐方式的设置了。我们可以借助子视图的myAlignment属性来设置其在浮动布局行(列)内的对齐方式。
       这里的对齐的标准都是以当前行(列)内最高(宽)的子视图为参考来进行(列)对齐的。
     
       在垂直浮动布局里面的子视图的行内对齐只能设置MyGravity_Vert_Top, MyGravity_Vert_Center, MyGravity_Vert_Bottom, MyGravity_Vert_Fill这几种对齐方式。
       在水平浮动布局里面的子视图的列内对齐只能设置MyGravity_Horz_Left, MyGravity_Horz_Center, MyGravity_Horz_Right, MyGravity_Horz_Fill这几种对齐方式。

     */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    rootLayout.backgroundColor = [UIColor lightGrayColor];
    rootLayout.gravity = MyGravity_Horz_Fill;  //所有子视图的宽度都和自己相等。
    rootLayout.subviewVSpace = 10;
    self.view = rootLayout;
    
    MyFloatLayout *vertLayout = [self createVertFloatLayout:rootLayout];
    vertLayout.backgroundColor = [UIColor whiteColor];
    vertLayout.weight = 0.8; //高度占用80%
    [rootLayout addSubview:vertLayout];
    
    MyFloatLayout *horzLayout =  [self createHorzFloatLayout:rootLayout];
    horzLayout.backgroundColor = [UIColor whiteColor];
    horzLayout.weight = 0.2; //高度占用20%
    [rootLayout addSubview:horzLayout];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- Layout Construction

-(MyFloatLayout*)createVertFloatLayout:(MyLinearLayout*)rootLayout
{
    MyFloatLayout *floatLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p1-12"]];
    logoImageView.layer.borderColor = [CFTool color:4].CGColor;
    logoImageView.layer.borderWidth = 1;
    logoImageView.myAlignment = MyGravity_Vert_Center;  //在浮动的一行内垂直居中对齐。
    logoImageView.myMargin = 10;  //四周的边距都设置为10.
    logoImageView.mySize = CGSizeMake(80, 36);
    [floatLayout addSubview:logoImageView];
    
    UILabel *brandLabel = [UILabel new];
    brandLabel.text = @"千奈美官方旗舰店";
    [brandLabel sizeToFit];
    brandLabel.myAlignment = MyGravity_Vert_Center; //在浮动的一行内垂直居中对齐。
    brandLabel.myVertMargin = 10;
    [floatLayout addSubview:brandLabel];
    
    UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [attentionButton sizeToFit];
    attentionButton.reverseFloat = YES;   //关注放在右边，所以浮动到右边。
    attentionButton.myMargin = 10;
    attentionButton.myAlignment = MyGravity_Vert_Center;  //在浮动的一行内垂直居中对齐。
    [floatLayout addSubview:attentionButton];
    
    //单独一行。
    UIView *line1 = [UIView new];
    line1.backgroundColor = [CFTool color:5];
    line1.myHeight = 2;
    line1.widthSize.equalTo(floatLayout.widthSize); //宽度和父视图一样宽。
    [floatLayout addSubview:line1];
    
    
    UIImageView *showImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image2"]];
    showImageView1.myMargin = 10;  //四周边距是10
    showImageView1.weight = 0.6;   //此时父布局的剩余宽度是屏幕，因此这里的宽度就是屏幕宽度的0.6
    showImageView1.heightSize.equalTo(showImageView1.widthSize);  //高度等于宽度。
    [floatLayout addSubview:showImageView1];
    
    
    //绘制线
    UIView *line2 = [UIView new];
    line2.backgroundColor = [CFTool color:5];
    line2.myWidth = 2;
    line2.heightSize.equalTo(showImageView1.heightSize).add(22); //高度和showImageView1高度相等，因为showImageView1还有上下分别为10的边距,还有中间横线的高度2，所以这里要增加22的高度。
    [floatLayout addSubview:line2];
    
    
    //右边上面的小图。
    UIImageView *showImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image3"]];
    showImageView2.myMargin = 10;  //四周边距是10
    showImageView2.weight = 1.0;    //注意这里是剩余宽度的比重，因为这个小图要占用全部的剩余空间，因此这里设置为1。
    showImageView2.heightSize.equalTo(showImageView1.heightSize).multiply(0.5).add(-10);  //高度等于大图高度的一半，再减去多余的边距10
    [floatLayout addSubview:showImageView2];
    
    
    //中间横线。
    UIView *line3 = [UIView new];
    line3.backgroundColor = [CFTool color:5];
    line3.myHeight = 2;
    line3.weight = 1.0;
    [floatLayout addSubview:line3];
    
    //右边下面的小图
    UIImageView *showImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image4"]];
    showImageView3.myMargin = 10;
    showImageView3.weight = 1.0;
    showImageView3.heightSize.equalTo(showImageView1.heightSize).multiply(0.5).add(-10);
    [floatLayout addSubview:showImageView3];
    
    //绘制下面的横线。
    UIView *line4 = [UIView new];
    line4.backgroundColor = [CFTool color:5];
    line4.myHeight = 2;
    line4.weight = 1.0;  //因为前面的所有内容都占满一行了，所以这条线是单独一行，这里是占用屏幕的全部空间了。
    line4.myBottom = 10;
    [floatLayout addSubview:line4];
    
    
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.text = @"今日已有137人签到获得好礼";
    signatureLabel.font = [CFTool font:14];
    signatureLabel.textColor = [CFTool color:4];
    [signatureLabel sizeToFit];
    signatureLabel.myHorzMargin = 10;
    signatureLabel.myAlignment = MyGravity_Vert_Center;
    [floatLayout addSubview:signatureLabel];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
    moreImageView.reverseFloat = YES;
    moreImageView.myHorzMargin = 10;
    moreImageView.myAlignment = MyGravity_Vert_Center;
    [floatLayout addSubview:moreImageView];
    
    
    UILabel *moreLabel = [UILabel new];
    moreLabel.text = @"进店看看";
    [moreLabel sizeToFit];
    moreLabel.reverseFloat = YES;
    moreLabel.myAlignment = MyGravity_Vert_Center;
    [floatLayout addSubview:moreLabel];
    
    
    UIView *line5 = [UIView new];
    line5.backgroundColor = [CFTool color:5];
    line5.myHeight = 2;
    line5.myVertMargin = 10;
    line5.widthSize.equalTo(floatLayout.widthSize);
    [floatLayout addSubview:line5];
    
    
    //
    UIImageView *commentImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions4"]];
    commentImageView1.myAlignment = MyGravity_Vert_Fill;  //这里使用填充对齐，表明会和这行里面高度最高的那个子视图的高度保持一致。
    commentImageView1.myLeft = 10;
    [floatLayout addSubview:commentImageView1];
    
    UIImageView *commentImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions3"]];
    commentImageView2.myAlignment = MyGravity_Vert_Fill;   //这里使用填充对齐，表明会和这行里面高度最高的那个子视图的高度保持一致。
    commentImageView2.myLeft = 10;
    [floatLayout addSubview:commentImageView2];
    
    UIImageView *commentImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minions3"]];
    commentImageView3.myLeft = 10;
    [floatLayout addSubview:commentImageView3];
    
    
    for (int i = 0; i < 4; i++)
    {
        UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"section2"]];
        starImageView.mySize = CGSizeMake(20, 20);
        starImageView.myAlignment = MyGravity_Vert_Bottom;  //这里底部对齐，表明子视图和一行内最高的子视图保持底部对齐。
        starImageView.myLeft = 5;
        [floatLayout addSubview:starImageView];
    }
    
    
    UIView *line6 = [UIView new];
    line6.backgroundColor = [CFTool color:5];
    line6.myHeight = 2;
    line6.widthSize.equalTo(floatLayout.widthSize);
    [floatLayout addSubview:line6];
    

    
    
    return floatLayout;
    
}

-(MyFloatLayout*)createHorzFloatLayout:(MyLinearLayout*)rootLayout
{
    MyFloatLayout *floatLayout = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Horz];
    floatLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    floatLayout.subviewSpace = 10;
    
    NSArray *names = @[@"minions1",@"minions3",@"minions2",@"minions4",@"p4-23",@"p4-11"];
    for (int i = 0; i < 6; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:names[i]]];
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [CFTool color:6].CGColor;
        imageView.heightSize.equalTo(floatLayout.heightSize).multiply(0.5).add(-5); //高度等于父视图的高度的一半，因为设置了每个子视图的间距为10，所以这里要减去5。
        if (i % 2 == 0)
        {//这句话的意思一列显示两个子视图，所以当索引下标为偶数时就是换列处理。
            imageView.clearFloat = YES;
        }
        
        //水平填充,每列两个子视图，每列的对齐方式都不一样。
        switch (i) {
            case 0:
            case 1:
                imageView.myAlignment = MyGravity_Horz_Center;
                break;
            case 2:
            case 3:
                imageView.myAlignment = MyGravity_Horz_Right;
                break;
            case 4:
            case 5:
                imageView.myAlignment = MyGravity_Horz_Fill;
            default:
                break;
        }
        
        [floatLayout addSubview:imageView];

    }
    

    return floatLayout;
    
    
}

@end

//
//  FOLTest4ViewController.m
//  MyLayout
//
//  Created by oybq on 16/2/19.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "FOLTest4ViewController.h"
#import "MyLayout.h"


static CGFloat sTagHeight = 40;
static CGFloat sTagWidth = 70;


@interface FOLTest4ViewController ()

@property(nonatomic, strong) MyLinearLayout *contentLayout;

@property(nonatomic, strong) NSArray *datas;

@end

@implementation FOLTest4ViewController

-(NSArray*)datas
{
    if (_datas == nil)
    {
        _datas = @[@{
                       @"title":@"已关注的标签",
                       @"sections":@[@{
                                         @"sectionTitle":@"",   //如果片段的内容为空则不显示片段。
                                         @"sectionImage":@"",
                                         @"tags":@[@"内衣",
                                                   @"中国风",
                                                   @"度假"
                                                   ]
                                         }
                                     ]
                       },
                   @{
                       @"title":@"热门标签",
                       @"sections":@[@{
                                         @"sectionTitle":@"",
                                         @"sectionImage":@"",
                                         @"tags":@[@"复古",
                                                   @"日系甜美",
                                                   @"御姐范",
                                                   @"就要代言购"
                                                   ]
                                         }
                                     ]
                       },
                   @{
                       @"title":@"搭配标签",
                       @"sections":@[@{
                                         @"sectionTitle":@"风格标签",
                                         @"sectionImage":@"section1",
                                         @"tags":@[@"欧美",
                                                   @"英伦",
                                                   @"韩系",
                                                   @"日系",
                                                   @"中国风",
                                                   @"民族风",
                                                   @"朋克",
                                                   @"街头",
                                                   @"运动",
                                                   @"休闲",
                                                   @"极简",
                                                   @"中性",
                                                   @"复古",
                                                   @"田园"
                                                   ]
                                         },
                                     @{
                                         @"sectionTitle":@"流行单品",
                                         @"sectionImage":@"section2",
                                         @"tags":@[@"阔腿裤",
                                                   @"白衬衫",
                                                   @"小白鞋",
                                                   @"连衣裙",
                                                   @"双肩包",
                                                   @"墨镜",
                                                   @"棒球衫",
                                                   @"牛仔外套",
                                                   @"百褶裙",
                                                   @"松糕鞋",
                                                   @"手拿包",
                                                   @"sneaker",
                                                   @"内衣",
                                                   @"西装",
                                                   @"牛仔裤",
                                                   @"链条包",
                                                   @"九分裤",
                                                   @"背带裤"
                                                   ]
                                         },
                                     @{
                                         @"sectionTitle":@"场景标签",
                                         @"sectionImage":@"section3",
                                         @"tags":@[@"校园",
                                                   @"通勤",
                                                   @"约会",
                                                   @"居家",
                                                   @"度假",
                                                   @"海边"
                                                   ]
                                         
                                         }
                                     ]
                       
                       }
                   ];
        
    }
    
    return _datas;
}


- (void)viewDidLoad {
    
    /*
     这个例子介绍用浮动布局来实现一个标签流的效果。因为浮动布局里面的子视图也是按照添加到布局中的顺序来进行布局定位的，所以浮动布局也具有实现标签流的能力。对于流式布局来说，里面的子视图不能出现跨行排列的情况。而浮动布局则能很方便的实现这个功能。
     */
    
    
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:scrollView];
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    rootLayout.myLeftMargin = rootLayout.myRightMargin = 0;  //宽度和滚动条视图保持一致。
    rootLayout.gravity = MyMarginGravity_Horz_Fill;
    [scrollView addSubview:rootLayout];
    
    //添加操作提示布局
    [rootLayout addSubview:[self createActionLayout]];
    
    
    //添加数据内容布局
    self.contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    self.contentLayout.backgroundColor = [UIColor lightGrayColor];
    self.contentLayout.gravity = MyMarginGravity_Horz_Fill;
    self.contentLayout.subviewMargin = 10;
    self.contentLayout.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    [rootLayout addSubview:self.contentLayout];
    
    //默认第一个风格。
    [self style1Layout:self.contentLayout];
 
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

//样式1布局： 每行放4个标签，标签宽度不固定，标签之间的间距固定。
-(void)style1Layout:(MyLinearLayout*)contentLayout
{
    NSInteger partIndex = 0;
    for (NSDictionary *dict in self.datas)
    {
        MyFloatLayout *floatLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
        floatLayout.backgroundColor = [UIColor whiteColor];
        floatLayout.padding = UIEdgeInsetsMake(20, 10, 20, 10);
        floatLayout.wrapContentHeight = YES;
        floatLayout.subviewHorzMargin = 30; //设置浮动布局里面子视图之间的水平间距。
        floatLayout.subviewVertMargin = 10; //设置浮动布局里面子视图之间的垂直间距。
        [contentLayout addSubview:floatLayout];
        
        //添加标题文本。
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = dict[@"title"];
        titleLabel.weight = 1;  //标题部分占据全部的宽度，独占一行。所以
        titleLabel.myBottomMargin = 5; //设置底部边距，这样下面的内容都和这个视图距离5个点。
        [titleLabel sizeToFit];
        [floatLayout addSubview:titleLabel];
        
        UIView *lastTagView = nil;  //记录一下每个section的最后的tag视图。原因是每个section的开头都和前一部分有一定的距离。
        NSInteger sectionIndex = 0;
        for (NSDictionary *sectionDict in dict[@"sections"])
        {
            //创建Section部分的视图。
            NSString *sectionTitle = sectionDict[@"sectionTitle"];
            if (sectionTitle.length > 0)
            {
                UIView *sectionView = [self createSectionView:sectionTitle image:sectionDict[@"sectionImage"]];
                //宽度是布局视图宽度的1/4，因为视图之间是有间距的，所以这里每个视图的宽度都要再减去3/4的间距值。
                sectionView.widthDime.equalTo(floatLayout.widthDime).multiply(1.0 / 4.0).add(-3.0 / 4.0 *floatLayout.subviewHorzMargin);
                //高度是标签的2倍，但因为中间还包括了一个垂直间距的高度，所以这里要加上垂直间距的值。
                sectionView.heightDime.equalTo(@(sTagHeight * 2)).add(floatLayout.subviewVertMargin);
                sectionView.clearFloat = YES;  //因为每个section总是新的一行开始。所以这里要把clearFloat设置为YES。
                [floatLayout addSubview:sectionView];
                
                if (lastTagView != nil)
                {
                    lastTagView.myBottomMargin = 20;  //最后一个tag视图的底部间距是20,这样下一个section的位置就会有一定的偏移。。
                }
                
                
                sectionView.tag = partIndex * 1000 + sectionIndex;

            }
            
            //创建tag部分的视图。
            lastTagView = nil;
            NSInteger tagIndex = 0;
            for (NSString *tagstr in sectionDict[@"tags"])
            {
                UIView *tagView = [self createTagView:tagstr];
                //宽度是布局视图宽度的1/4，因为视图之间是有间距的，所以这里每个视图的宽度都要再减去3/4的间距值。
                tagView.widthDime.equalTo(floatLayout.widthDime).multiply(1.0 / 4.0).add(-3.0 / 4.0 * floatLayout.subviewHorzMargin);
                //高度是固定的40
                tagView.heightDime.equalTo(@(sTagHeight));
                [floatLayout addSubview:tagView];
                lastTagView = tagView;

                tagView.tag = (partIndex * 1000 + sectionIndex) * 1000 + tagIndex;
                tagIndex++;
            }
            
            sectionIndex++;
        }
        
        partIndex++;
        
    }
    
}

//样式2布局：标签宽度固定为70，然后根据屏幕大小算出每行应该排列的数量，以及动态间距，但是间距不能小于8，如果间距小于8则每行的数量应该减少1个，同时增加间距。
-(void)style2Layout:(MyLinearLayout*)contentLayout
{
    /*
     通过对浮动布局的setSubviewFloatMargin的使用，可以很方便的设置浮动间距值。布局会根据布局的宽度值，和你设置的子视图的固定宽度值，以及虽小间距值来自动算出您的子视图间距。需要注意的是如果当前的浮动布局的方向是MyLayoutViewOrientation_Vert,则setSubviewFloatMargin设置的是水平浮动间距，否则设置的将是垂直浮动间距。
     */
    
    NSInteger partIndex = 0;
    for (NSDictionary *dict in self.datas)
    {
        MyFloatLayout *floatLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
        floatLayout.backgroundColor = [UIColor whiteColor];
        floatLayout.padding = UIEdgeInsetsMake(20, 5, 20, 5);
        floatLayout.wrapContentHeight = YES;
        floatLayout.subviewVertMargin = 10; //设置浮动布局里面子视图之间的垂直间距。
        [floatLayout setSubviewFloatMargin:sTagWidth minMargin:8];  //这里面水平间距用浮动间距，浮动间距设置为子视图固定宽度为70，做小的间距为8.
        [contentLayout addSubview:floatLayout];
        
        //在学习DEMO时您可以尝试着把下面两句代码解除注释！然后看看横竖屏的区别，这里面用到了SIZECLASS。表示横屏时的最小间距是不一样的。
        //当然如果您要改变子视图的尺寸的话，则要将下面的子视图也要实现对SIZECLASS的支持！！！
        //  [floatLayout fetchLayoutSizeClass:MySizeClass_Landscape copyFrom:MySizeClass_wAny | MySizeClass_hAny];
        //  [floatLayout setSubviewFloatMargin:sTagWidth minMargin:40 inSizeClass:MySizeClass_Landscape];
        
        //添加标题文本。
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = dict[@"title"];
        titleLabel.weight = 1;  //标题部分占据全部的宽度，独占一行。所以
        titleLabel.myBottomMargin = 5; //设置底部边距，这样下面的内容都和这个视图距离5个点。
        [titleLabel sizeToFit];
        [floatLayout addSubview:titleLabel];
        
        UIView *lastTagView = nil;  //记录一下每个section的最后的tag视图。原因是每个section的开头都和前一部分有一定的距离。
        NSInteger sectionIndex = 0;
        for (NSDictionary *sectionDict in dict[@"sections"])
        {
            //创建Section部分的视图。
            NSString *sectionTitle = sectionDict[@"sectionTitle"];
            if (sectionTitle.length > 0)
            {
                UIView *sectionView = [self createSectionView:sectionTitle image:sectionDict[@"sectionImage"]];
                sectionView.widthDime.equalTo(@(sTagWidth)); //固定宽度
                sectionView.heightDime.equalTo(@(sTagHeight * 2)).add(floatLayout.subviewVertMargin); //高度是标签的2倍，但因为中间还包括了一个垂直间距的高度，所以这里要加上垂直间距的值。

                sectionView.clearFloat = YES;  //因为每个section总是新的一行开始。所以这里要把clearFloat设置为YES。
                [floatLayout addSubview:sectionView];
                sectionView.tag = partIndex * 1000 + sectionIndex;
                
                if (lastTagView != nil)
                {
                    lastTagView.myBottomMargin = 20;  //最后一个tag视图的底部间距是20,这样下一个section的位置就会有一定的偏移。。
                }
                
            }
            
            //创建tag部分的视图。
            lastTagView = nil;
            NSInteger tagIndex = 0;
            for (NSString *tagstr in sectionDict[@"tags"])
            {
                UIView *tagView = [self createTagView:tagstr];
                tagView.widthDime.equalTo(@(sTagWidth)); //宽度固定
                tagView.heightDime.equalTo(@(sTagHeight)); //             高度是固定的40
                [floatLayout addSubview:tagView];
                tagView.tag = (partIndex * 1000 + sectionIndex) * 1000 + tagIndex;
                
                lastTagView = tagView;
                tagIndex++;
            }
            
            sectionIndex++;
        }
        
        partIndex++;
        
    }
    
}

//创建操作动作布局。
-(UIView*)createActionLayout
{
    MyFloatLayout *actionLayout = [MyFloatLayout floatLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    actionLayout.wrapContentHeight = YES;
    actionLayout.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor blackColor]];
    
    
    NSArray *actions = @[@"浮动宽度,固定间距风格",
                         @"固定宽度,浮动间距风格",
                         ];
    for (NSInteger  i = 0; i < actions.count; i++)
    {
        UIButton *button = [UIButton new];
        [button setTitle:actions[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.myHeight = 44;
        button.widthDime.equalTo(actionLayout.widthDime).multiply(1.0/actions.count);  //宽度均分
        button.tag = i + 100;
        [button addTarget:self action:@selector(handleStyleChange:) forControlEvents:UIControlEventTouchUpInside];
        [actionLayout addSubview:button];
    }
    
    UILabel *actionDesc = [UILabel new];
    actionDesc.text = @"*风格布局1里面每行固定放4个标签子视图，子视图左右间距固定，子视图宽度浮动。\n*风格布局2里面每个标签子视图宽度固定，子视图左右间距浮动，但有最小间距限制。\n您可以在两个风格下切换横竖屏或者切换模拟器查看不同的效果。";
    actionDesc.backgroundColor = [UIColor whiteColor];
    actionDesc.numberOfLines = 0;
    actionDesc.flexedHeight = YES;
    actionDesc.myTopMargin = 10;
    actionDesc.clearFloat = YES;  //换行
    actionDesc.weight = 1;        //占用全部宽度。
    [actionLayout addSubview:actionDesc];
    
    return actionLayout;
}

//建立片段视图
-(UIView*)createSectionView:(NSString*)title image:(NSString*)image
{
    
    MyLinearLayout *sectionLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
    sectionLayout.wrapContentHeight = NO;
    sectionLayout.layer.cornerRadius = 5;
    sectionLayout.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sectionLayout.layer.borderWidth = 1;
    sectionLayout.gravity = MyMarginGravity_Center;
    [sectionLayout setTarget:self action:@selector(handleSectionViewTap:)];

    
    UIImageView *sectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    [sectionLayout addSubview:sectionImageView];
    
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.text = title;
    sectionLabel.textColor = [UIColor lightGrayColor];
    sectionLabel.adjustsFontSizeToFitWidth = YES;
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.myLeftMargin = sectionLabel.myRightMargin = 0;
    [sectionLabel sizeToFit];
    [sectionLayout addSubview:sectionLabel];
 
    return sectionLayout;
}

//建立标签视图
-(UIView*)createTagView:(NSString*)title
{
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:title forState:UIControlStateNormal];
    [tagButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tagButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    tagButton.layer.cornerRadius = 20;
    tagButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tagButton.layer.borderWidth = 1;
    [tagButton addTarget:self action:@selector(handleTagViewTap:) forControlEvents:UIControlEventTouchUpInside];

    return tagButton;
}



#pragma mark -- Handle Method

-(void)handleTagViewTap:(UIView*)sender
{
    NSInteger partIndex = sender.tag / 1000 / 1000;
    NSInteger sectionIndex = (sender.tag / 1000) % 1000;
    NSInteger tagIndex = sender.tag % 1000;
    
    NSString *message = [NSString stringWithFormat:@"您单击了:\npartIndex:%ld\nsectionIndex:%ld\ntagIndex:%ld", (long)partIndex, (long)sectionIndex, (long)tagIndex];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)handleSectionViewTap:(UIView*)sender
{
    NSInteger partIndex = sender.tag / 1000;
    NSInteger sectionIndex = sender.tag % 1000;
    
    NSString *message = [NSString stringWithFormat:@"您单击了:\npartIndex:%ld\nsectionIndex:%ld", (long)partIndex, (long)sectionIndex];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)handleStyleChange:(UIButton*)sender
{
    [self.contentLayout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (sender.tag == 100)
    {
        sender.backgroundColor=[UIColor redColor];
        [sender.superview viewWithTag:101].backgroundColor = [UIColor clearColor];
        
        [self style1Layout:self.contentLayout];
    }
    else
    {
        sender.backgroundColor=[UIColor redColor];
        [sender.superview viewWithTag:100].backgroundColor = [UIColor clearColor];

        [self style2Layout:self.contentLayout];
    }
    
}

@end

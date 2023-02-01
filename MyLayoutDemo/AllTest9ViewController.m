//
//  AllTest9ViewController.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2017/10/31.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import "AllTest9ViewController.h"
#import "AllTest9CollectionViewCell.h"
#import "AllTest9WaterFlowLayout.h"

@interface AllTest9ViewController ()

@property(nonatomic, strong) NSMutableArray *datas;      //数据模型数组

@end

@implementation AllTest9ViewController

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init
{
    
    AllTest9WaterFlowLayout  *layout = [[AllTest9WaterFlowLayout alloc] init];
    layout.numberOfColumn = 2;
    layout.vertSpace = 10;
    layout.horzSpace = 10;
     //您可以试试内置的UICollectionViewFlowLayout效果。
    /*
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
     */
    self = [self initWithCollectionViewLayout:layout];
    if (self != nil) {
    }
    return self;
}


-(NSMutableArray*)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray new];
        
        
        
        NSArray *titles = @[@"欧阳大哥",
                           @"醉里挑灯看键",
                           @"张三",
                           @"尼古拉・阿列克赛耶维奇・奥斯特洛夫斯基"
                           ];
        
        NSArray *subtitles = @[@"只有一行文本",
                           @"这个例子是用于测试自动布局在UITableView中实现静态高度的解决方案。",
                           @"通过布局视图的sizeThatFits函数能够评估出UITableViewCell的动态高度",
                           @"这是一段既有文本也有图片，文本在上面，图片在下面"
                           ];
        
        
        
        for (int i = 0; i < 50; i++)
        {
            AllTest9DataModel *model = [AllTest9DataModel new];
            
             model.title  =  titles[arc4random_uniform((uint32_t)titles.count)];
             model.subtitle =  subtitles[arc4random_uniform((uint32_t)subtitles.count)];
            
            [_datas addObject:model];
        }
        
    }
    
    return _datas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[AllTest9CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width - 10)/2, 0);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AllTest9CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    AllTest9DataModel *model = self.datas[indexPath.section * 1 + indexPath.row];
    cell.model = model;
    return cell;
}

@end

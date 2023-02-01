//
//  AllTest9WaterFlowLayout.m
//  MyLayoutDemo
//
//  Created by oubaiquan on 2022/12/19.
//  Copyright © 2022 YoungSoft. All rights reserved.
//

#import "AllTest9WaterFlowLayout.h"

@interface AllTest9WaterFlowLayout()

//存放每一列的高度
@property (nonatomic, strong) NSMutableArray<NSNumber*> *columnHeightArray;

//存放 每一个item的 属性 包含 frame以及下标
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;


@end


@implementation AllTest9WaterFlowLayout


//获取最大值
- (CGFloat)maxHeight
{
    CGFloat max = 0;
    for (NSNumber *height in _columnHeightArray) {
        CGFloat h = [height floatValue];
        if (max < h) {
            max = h;
        }
    }
    return max;
}

- (void)invalidateLayout {
    [super invalidateLayout];
    _columnHeightArray = nil;
    _attributesArray = nil;
}

-(void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
}

//重写父类的布局方法
- (void)prepareLayout
{
    [super prepareLayout];
    
   
    if (_columnHeightArray == nil) {
        _columnHeightArray = [[NSMutableArray alloc] initWithCapacity:self.numberOfColumn];
        for (int i = 0; i < self.numberOfColumn; i ++) {
            [_columnHeightArray addObject:@(self.vertSpace)];
        }
    }
    
    if (_attributesArray == nil) {
        _attributesArray = [[NSMutableArray alloc] init];
        
        CGFloat totalWidth = self.collectionView.frame.size.width;
        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
        CGFloat itemWidth = (totalWidth - self.horzSpace) / self.numberOfColumn;
        for (int i = 0; i < itemCount; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attribute.frame = CGRectMake(-1, 0, itemWidth, 0);
            [_attributesArray addObject:attribute];
        }
    }
}


- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
    
   UICollectionViewLayoutAttributes *attributes = _attributesArray[preferredAttributes.indexPath.item];
    if (attributes.frame.origin.x >= 0) {
        return NO;
    }
    
    NSInteger minHeightIndex = -1;
    CGFloat minHeight = CGFLOAT_MAX;
    for (int j = 0; j < self.columnHeightArray.count; j++) {
        CGFloat h = [self.columnHeightArray[j] doubleValue];
        if (minHeight > h) {
            minHeight = h;
            minHeightIndex = j;
        }
    }
    CGFloat x = minHeightIndex * (preferredAttributes.size.width + self.horzSpace);
    CGFloat y = minHeight;
    attributes.frame = CGRectMake(x, y, preferredAttributes.size.width, preferredAttributes.size.height);
    self.columnHeightArray[minHeightIndex] = [NSNumber numberWithFloat:minHeight + preferredAttributes.size.height + self.vertSpace];
    return YES;
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    BOOL ok = [super shouldInvalidateLayoutForBoundsChange:newBounds];
//    return YES;
//}

//重写这个方法，可以返回集合视图的总高度
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, [self maxHeight]);
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}


//@property(class, nonatomic, readonly) Class layoutAttributesClass; // override this method to provide a custom class to be used when instantiating instances of UICollectionViewLayoutAttributes
//@property(class, nonatomic, readonly) Class invalidationContextClass API_AVAILABLE(ios(7.0)); // override this method to provide a custom class to be used for invalidation contexts
//
//// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
//// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
//// Subclasses should always call super if they override.
//- (void)prepareLayout;
//
//// UICollectionView calls these four methods to determine the layout information.
//// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
//// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
//// If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.
//- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect; // return an array layout attributes instances for all the views in the given rect
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath;
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; // return YES to cause the collection view to requery the layout for geometry information
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds API_AVAILABLE(ios(7.0));
//
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes API_AVAILABLE(ios(8.0));
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes API_AVAILABLE(ios(8.0));
//
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity; // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset API_AVAILABLE(ios(7.0)); // a layout can return the content offset to be applied during transition or update animations
//
//@property(nonatomic, readonly) CGSize collectionViewContentSize; // Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.

 

@end

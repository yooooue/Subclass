//
//  HQYCollectionViewLayout.m
//  UICollection瀑布流
//
//  Created by 韩倩云 on 2018/3/16.
//  Copyright © 2018年 HanQianyun. All rights reserved.
//

#import "WaterfallCollectionViewLayout.h"

@interface WaterfallCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray * attributesArr;

@property (nonatomic, strong) NSMutableArray * columnHeightsArr;//记录每列的高度

@end

@implementation WaterfallCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.columnHeightsArr removeAllObjects];
    for (int i = 0; i < self.columnCount; i++) {
        [self.columnHeightsArr addObject:@(self.edgeInsets.top)];
    }
    
    [self.attributesArr removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArr addObject:attributes];
    }
}
//返回当前屏幕中所有元素的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    return [self deepCopyWithArray:self.attributesArr];
}

/*
 这个警告来源主要是在使用layoutAttributesForElementsInRect：方法返回的数组时，没有使用该数组的拷贝对象，而是直接使用了该数组。解决办法对该数组进行拷贝，并且是深拷贝
 */
- (NSArray *)deepCopyWithArray:(NSArray *)array
{
    NSMutableArray *copys = [NSMutableArray arrayWithCapacity:array.count];
    
    for (UICollectionViewLayoutAttributes *attris in array) {
        [copys addObject:[attris copy]];
    }
    return copys;
}

//返回indexPath位置cell的attribute
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //得到相应位置的att
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat width = (collectionViewWidth-self.edgeInsets.left-self.edgeInsets.right-(self.columnCount-1)*self.columnMargin)/self.columnCount;//cell的宽度
    CGFloat height = 100;
    if (self.attributesHeight) {
        height = self.attributesHeight(width, indexPath);
    
    }
    NSInteger destColumn = 0;//假设最短列是第一列
    
    CGFloat minColumnHeight = [self.columnHeightsArr[0] doubleValue];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeightsArr[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (width + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    attributes.frame = CGRectMake(x, y, width, height);
    
    self.columnHeightsArr[destColumn] = @(CGRectGetMaxY(attributes.frame));
    attributes.frame = CGRectMake(x, y+self.headerReferenceSize.height, width, height);

    CGFloat columnHeight = [self.columnHeightsArr[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attributes;
}

//返回collectionView的滚动范围
- (CGSize)collectionViewContentSize {
    CGSize contentSize = CGSizeMake(self.collectionView.frame.size.width, self.contentHeight+self.edgeInsets.bottom+self.headerReferenceSize.height);
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position {
    return [self.collectionView indexPathForItemAtPoint:position];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position{
    UICollectionViewLayoutAttributes * attribute = [super layoutAttributesForInteractivelyMovingItemAtIndexPath:indexPath withTargetPosition:position];
    NSLog(@"%ld",(long)indexPath.item);
    return attribute;
}

//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition {
//    
//    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
////    NSLog(@"目标%ld---之前%ld",(long)targetIndexPaths[0].item,(long)previousIndexPaths[0].item);
////    if([self.delegate respondsToSelector:@selector(moveItemAtIndexPath: toIndexPath:)]){
////        [self.delegate moveItemAtIndexPath:previousIndexPaths[0] toIndexPath:targetIndexPaths[0]];
////    }
//    return context;
//}

//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled {
//    UICollectionViewLayoutInvalidationContext * context = [super invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:indexPaths previousIndexPaths:previousIndexPaths movementCancelled:movementCancelled];
//    return context;
//}


- (NSMutableArray *)columnHeightsArr {
    if (!_columnHeightsArr) {
        _columnHeightsArr = [NSMutableArray array];
    }
    return _columnHeightsArr;
}

- (NSMutableArray *)attributesArr {
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    return _attributesArr;
}

@end

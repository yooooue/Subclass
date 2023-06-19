//
//  WaterfallFlowLayout.m
//  Subclass
//
//  Created by 韩倩云 on 2020/10/15.
//  Copyright © 2020 yy. All rights reserved.
//

#import "WaterfallFlowLayout.h"

@interface WaterfallFlowLayout ()

@property (nonatomic, strong) NSMutableArray * attributesArr;

@property (nonatomic, strong) NSMutableArray * columnHeightsArr;//记录每列的高度

@end

@implementation WaterfallFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    [self.columnHeightsArr removeAllObjects];
    for (int i = 0; i < self.columnCount; i++) {
        [self.columnHeightsArr addObject:@(self.edgeInsets.top)];
    }
    [self.attributesArr removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 1; i < count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArr addObject:attributes];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArr;
}

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

- (CGSize)collectionViewContentSize {
    CGSize contentSize = CGSizeMake(self.collectionView.width, self.contentHeight+self.edgeInsets.bottom+self.edgeInsets.top+self.headerReferenceSize.height);
    return contentSize;
}

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

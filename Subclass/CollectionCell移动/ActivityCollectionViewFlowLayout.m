//
//  ActivityCollectionViewFlowLayout.m
//  MUD004
//
//  Created by 韩倩云 on 2019/4/10.
//  Copyright © 2019 MACCO. All rights reserved.
//

#import "ActivityCollectionViewFlowLayout.h"

@implementation ActivityCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * array =  [[NSArray alloc]initWithArray:original copyItems:YES];
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //可视区域
    CGRect visibleRect;
    visibleRect.origin = proposedContentOffset;
    visibleRect.size = self.collectionView.frame.size;
    NSArray * arr = [super layoutAttributesForElementsInRect:visibleRect];
    CGFloat centerX = CGRectGetMidX(visibleRect)-self.offset;
    //self.collectionView.frame.size.width /2+ proposedContentOffset.x;
    //存放的最小间距
    //TODO:   注意研究一下：
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * attrs in arr) {
        if (ABS(minDelta)>ABS(attrs.center.x-centerX)) {
            minDelta=attrs.center.x-centerX;
        }
    }
    CGFloat s = self.collectionView.contentSize.width;
    if (proposedContentOffset.x+self.collectionView.frame.size.width - self.collectionView.contentInset.left == s) {
//        NSLog(@"%f",s);
        //这里的判断是为了避免当滑动到最后一个cell collectionview回弹停靠
    }else {
        // 修改原有的偏移量
        proposedContentOffset.x+=minDelta;
    }
    //如果返回的时zero 那个滑动停止后 就会立刻回到原地
    return proposedContentOffset;
    return CGPointZero;
}
@end

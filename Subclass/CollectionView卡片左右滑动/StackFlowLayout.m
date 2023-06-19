//
//  StackFlowLayout.m
//  Subclass
//
//  Created by 韩倩云 on 2019/6/11.
//  Copyright © 2019 yy. All rights reserved.
//

#import "StackFlowLayout.h"

@implementation StackFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //创建布局实例
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //设置布局属性
    attrs.center = CGPointMake(self.collectionView.frame.size.width*0.5, self.contentSize.height*0.5);
    
    //设置偏移
    NSArray *offsets = @[@(0.0),@(15.0),@(30.0)];
    
    //只显示3张
    if (indexPath.item >= 3)
    {
        attrs.hidden = YES;
    }
    else
    {
        //开始偏移
        attrs.transform = CGAffineTransformMakeTranslation(0, [offsets[indexPath.item] floatValue]);
        attrs.size = CGSizeMake(self.contentSize.width - [offsets[indexPath.item] floatValue], self.contentSize.height);
        
        //zIndex值越大,图片越在上面
        attrs.zIndex = [self.collectionView numberOfItemsInSection:indexPath.section] - indexPath.item;
    }
    return attrs;
}

//重写layoutAttributesForElementsInRect,设置所有cell的布局属性（包括item、header、footer）
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *arrayM = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    //给每一个item创建并设置布局属性
    for (int i = 0; i < count; i++)
    {
        //创建item的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [arrayM addObject:attrs];
    }
    return arrayM;
}

@end

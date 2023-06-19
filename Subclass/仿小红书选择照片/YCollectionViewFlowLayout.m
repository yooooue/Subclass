//
//  YCollectionViewFlowLayout.m
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/1.
//  Copyright © 2019 yy. All rights reserved.
//

#import "YCollectionViewFlowLayout.h"

@interface YCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray * attributesArr;

@end

@implementation YCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.attributesArr = [NSMutableArray array];
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

    return attributes;
}
@end

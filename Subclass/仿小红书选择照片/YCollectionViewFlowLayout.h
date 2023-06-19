//
//  YCollectionViewFlowLayout.h
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/1.
//  Copyright © 2019 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger columnCount;//列数

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

NS_ASSUME_NONNULL_END

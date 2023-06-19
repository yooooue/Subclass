//
//  WaterfallFlowLayout.h
//  Subclass
//
//  Created by 韩倩云 on 2020/10/15.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallFlowLayout : UICollectionViewFlowLayout
///列数
@property (nonatomic, assign) NSInteger columnCount;
///边距
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
///行间距
@property (nonatomic, assign) NSInteger rowMargin;
///列间距
@property (nonatomic, assign) NSInteger columnMargin;

@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, copy) CGFloat(^attributesHeight)(CGFloat itemWidth, NSIndexPath * indexPath);//cell高

@end

NS_ASSUME_NONNULL_END

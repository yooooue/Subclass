//
//  HQYCollectionViewLayout.h
//  UICollection瀑布流
//
//  Created by 韩倩云 on 2018/3/16.
//  Copyright © 2018年 HanQianyun. All rights reserved.
//

/*
 tag : MainPage.infoList ’ view
 功能 : 重写layoutAttributesForItemAtIndexPath: indexPath
 描述 :
 */

#import <UIKit/UIKit.h>

@protocol WaterfallCollectionViewLayoutDelegate<NSObject>
- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;
@end

@interface WaterfallCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger columnCount;//列数

@property (nonatomic, assign) UIEdgeInsets edgeInsets;//上左下右边缘距离

@property (nonatomic, assign) CGFloat columnMargin;//列间距

@property (nonatomic, assign) CGFloat rowMargin;//行间距

@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, copy) CGFloat(^attributesHeight)(CGFloat itemWidth, NSIndexPath * indexPath);//cell高

@property(nonatomic,weak)id<WaterfallCollectionViewLayoutDelegate> delegate;

@end

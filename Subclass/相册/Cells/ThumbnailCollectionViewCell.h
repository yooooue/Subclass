//
//  ThumbnailCollectionViewCell.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/22.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPhotoManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface ThumbnailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * photoImage;
@property (nonatomic, strong) YAssetModel * asssetModel;

@end

@interface ShowPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * photoImage;
@property (nonatomic, strong) YAssetModel * asssetModel;
//@property (nonatomic, assign) <#NSInteger#> <#integer#>;

@end
NS_ASSUME_NONNULL_END

//
//  AssetCollectionViewCell.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/21.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPhotoAlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * photoImgView;

@property (nonatomic, strong) UILabel * selectNumLabel;

@property (nonatomic, strong) UIButton * selectBtn;

@property (nonatomic, strong) UILabel * videoTimeLenghtLabel;

@property (nonatomic, strong) UIView * unableClickCoverView;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) YAssetModel * assetModel;

@property (nonatomic, copy) void(^selectPhotoBlock)(BOOL isSelected);

@end

NS_ASSUME_NONNULL_END

//
//  YCollectionViewCell.h
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/5.
//  Copyright © 2019 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPhotoAlbumModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectPhotoBlock)(BOOL isSelect);

@interface YCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UILabel *selectNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic, copy) SelectPhotoBlock selectPhotoBlock;

@property (nonatomic, strong) YAssetModel * model;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@class YPhotoAlbumModel;

@interface YAlbumTableViewCell : UITableViewCell


@property (nonatomic, strong) YPhotoAlbumModel * model;

@end
NS_ASSUME_NONNULL_END

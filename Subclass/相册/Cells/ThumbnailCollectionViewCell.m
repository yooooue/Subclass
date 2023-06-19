//
//  ThumbnailCollectionViewCell.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/22.
//  Copyright © 2020 yy. All rights reserved.
//

#import "ThumbnailCollectionViewCell.h"

@implementation ThumbnailCollectionViewCell

- (UIImageView *)photoImage {
    if (!_photoImage) {
        _photoImage = [[UIImageView alloc]initWithFrame:self.bounds];
        _photoImage.contentMode = UIViewContentModeScaleAspectFill;
        _photoImage.clipsToBounds = YES;
        _photoImage.layer.cornerRadius = 4;
        _photoImage.layer.borderColor = [UIColor colorWithHexStr:@"#ff4a83"].CGColor;
        [self.contentView addSubview:_photoImage];
    }
    return _photoImage;
}

- (void)setAsssetModel:(YAssetModel *)asssetModel {
    if (asssetModel.cropImage) {
        self.photoImage.image = asssetModel.cropImage;
    }else {
        [[YPhotoManager sharedManager] requestImageForAsset:asssetModel.asset size:self.frame.size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            self.photoImage.image = image;
        }];
    }
}
@end


@implementation ShowPhotoCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:_photoImage];
}

- (UIImageView *)photoImage {
    if (!_photoImage) {
        CGFloat width = self.height*3/4.0;
        _photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, self.height)];
        _photoImage.center = self.contentView.center;
        _photoImage.contentMode = UIViewContentModeScaleAspectFill;
        _photoImage.clipsToBounds = YES;
//        _photoImage.layer.cornerRadius = 4;
        _photoImage.layer.borderColor = [UIColor colorWithHexStr:@"#ff4a83"].CGColor;
    }
    return _photoImage;
}

- (void)setAsssetModel:(YAssetModel *)asssetModel {
    if (asssetModel.cropImage) {
        self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
        self.photoImage.image = asssetModel.cropImage;
    }else {
        [[YPhotoManager sharedManager] requestImageForAsset:asssetModel.asset size:self.frame.size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            self.photoImage.image = image;
            asssetModel.aspectRatio = image.size.width/image.size.height;
        }];
    }
}
@end

//
//  AssetCollectionViewCell.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/21.
//  Copyright © 2020 yy. All rights reserved.
//

#import "AssetCollectionViewCell.h"
#import "YPhotoManager.h"

@implementation AssetCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:self.photoImgView];
    UIImageView * selectImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-6-23, 6, 23, 23)];
    selectImg.image = [UIImage imageNamed:@"photo_selectImg"];
    [self.contentView addSubview:selectImg];
    [self.contentView addSubview:self.selectNumLabel];
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.videoTimeLenghtLabel];
    [self.contentView addSubview:self.unableClickCoverView];

}

- (void)setAssetModel:(YAssetModel *)assetModel {
    _assetModel = assetModel;
    if (assetModel.assetModelMediaType == YAssetModelMediaTypeVideo) {
        self.videoTimeLenghtLabel.hidden = NO;
        self.videoTimeLenghtLabel.text = assetModel.timeLenght;
    }else {
        self.videoTimeLenghtLabel.hidden = YES;
    }
    [[YPhotoManager sharedManager] requestImageForAsset:assetModel.asset size:self.frame.size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        self.photoImgView.image = image;
        assetModel.aspectRatio = image.size.width/image.size.height;
    }];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    self.selectNumLabel.hidden = NO;
    self.selectNumLabel.text = [NSString stringWithFormat:@"%ld", selectIndex+1];
//    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        CGPoint center = self.selectNumLabel.center;
//        self.selectNumLabel.frame = CGRectMake(0, 0, 30, 30);
//        self.selectNumLabel.center = center;
//    } completion:^(BOOL finished) {
//        self.selectNumLabel.frame = CGRectMake(self.width-6-23, 6, 23, 23);
//    }];
}

- (void)clickSelectBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.selectPhotoBlock) {
        self.selectPhotoBlock(btn.selected);
    }
}

#pragma mark ---lazy load
- (UIImageView *)photoImgView {
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc]initWithFrame:self.bounds];
        _photoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgView.clipsToBounds = YES;
        _photoImgView.layer.borderColor = [UIColor colorWithHexStr:@"#ff4a83"].CGColor;
    }
    return _photoImgView;
}

- (UILabel *)selectNumLabel {
    if (!_selectNumLabel) {
        _selectNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-6-23, 6, 23, 23)];
        _selectNumLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _selectNumLabel.backgroundColor = [UIColor colorWithHexStr:@"#ff4a83"];
        _selectNumLabel.textAlignment = NSTextAlignmentCenter;
        _selectNumLabel.layer.cornerRadius = 23/2.0;
        _selectNumLabel.layer.masksToBounds = YES;
        _selectNumLabel.textColor = [UIColor whiteColor];
    }
    return _selectNumLabel;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width-50, 0, 50, 50)];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UILabel *)videoTimeLenghtLabel {
    if (!_videoTimeLenghtLabel) {
        _videoTimeLenghtLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.height-20, self.width-10, 20)];
        _videoTimeLenghtLabel.font = [UIFont systemFontOfSize:11];
        _videoTimeLenghtLabel.textAlignment = NSTextAlignmentRight;
        _videoTimeLenghtLabel.textColor = [UIColor whiteColor];
        _videoTimeLenghtLabel.hidden = YES;
    }
    return _videoTimeLenghtLabel;
}

- (UIView *)unableClickCoverView {
    if (!_unableClickCoverView) {
        _unableClickCoverView = [[UIView alloc]initWithFrame:self.bounds];
        _unableClickCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _unableClickCoverView.hidden = YES;
    }
    return _unableClickCoverView;
}
@end

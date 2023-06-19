//
//  YCollectionViewCell.m
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/5.
//  Copyright © 2019 yy. All rights reserved.
//

#import "YCollectionViewCell.h"
#import "YPhotoManager.h"

@implementation YCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.photoImgView.layer.borderColor = [UIColor redColor].CGColor;
    self.selectNumLabel.layer.cornerRadius = 12;
    self.selectNumLabel.layer.masksToBounds = YES;
    self.selectNumLabel.hidden = YES;
}

- (void)setModel:(YAssetModel *)model {
    _model = model;
    [[YPhotoManager sharedManager] requestImageForAsset:model.asset size:self.frame.size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        self.photoImgView.image = image;
        model.aspectRatio = image.size.width/image.size.height;
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.selectNumLabel.hidden = NO;
    self.selectNumLabel.text = [NSString stringWithFormat:@"%ld",(long)selectedIndex+1];
    if (selectedIndex == 0 && self.selectBtn.selected) {
        self.model.isFirstSelected = YES;
    }else {
        self.model.isFirstSelected = NO;
    }
}

- (IBAction)clickSelectBtn:(id)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    NSLog(@"是否选中---%d",self.selectBtn.selected);
    if (self.selectPhotoBlock) {
        self.selectPhotoBlock(self.selectBtn.selected);
    }
}

@end

@interface YAlbumTableViewCell()

@property (nonatomic, strong) UIImageView * albumImageView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * countLabel;

@end

@implementation YAlbumTableViewCell

- (void)setModel:(YPhotoAlbumModel *)model {
    _model = model;
    CGFloat labelW = [model.albumName boundingRectWithSize:CGSizeMake(MAXFLOAT,15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:15]} context:nil].size.width+5;
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.albumImageView.frame)+15, 32, labelW, 15);
    self.titleLabel.text = model.albumName;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)model.photoCount];
    YAssetModel * assetModel = model.models.firstObject;
    [[YPhotoManager sharedManager] requestImageForAsset:assetModel.asset size:CGSizeMake(50, 50) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
        self.albumImageView.image = image;
    }];
}

- (UIImageView *)albumImageView {
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
        _albumImageView.layer.cornerRadius = 4;
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.clipsToBounds = YES;
        [self.contentView addSubview:_albumImageView];
    }
    return _albumImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.albumImageView.frame)+15, 32, 60, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5, 32, 60, 15)];
        _countLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [self.contentView addSubview:_countLabel];
    }
    return _countLabel;
}

@end

//
//  PhotoAlbums.m
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/6.
//  Copyright © 2019 yy. All rights reserved.
//

#import "YPhotoAlbumModel.h"
#import "YPhotoManager.h"

@implementation YPhotoAlbumModel

- (void)setFetchResult:(PHFetchResult *)fetchResult {
   
    [[YPhotoManager sharedManager]getAssetsFromFetchResult:fetchResult completion:^(NSArray<YAssetModel *> * models) {
        self.models = models;
    }];
}
@end

@implementation YAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(YAssetModelMediaType)mediaType timeLength:(NSString *)timeLength {
    YAssetModel * assetModel = [[YAssetModel alloc]init];
    assetModel.assetModelMediaType = mediaType;
    assetModel.asset = asset;
    assetModel.timeLenght = timeLength;
    assetModel.scale = 1.0;
    return assetModel;
}

- (void)setAspectRatio:(CGFloat)aspectRatio {
    _aspectRatio = aspectRatio;
    if (aspectRatio == 1) {
        _type = 0;
    }else if (aspectRatio > 1) {
        _type = 2;
    }else {
        _type = 1;
    }
}
@end

//
//  PhotoAlbums.h
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/6.
//  Copyright © 2019 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <Photos/Photos.h>

typedef enum: NSInteger {
    YAssetModelMediaTypePhoto = 0,
    YAssetModelMediaTypeLivePhoto,
    YAssetModelMediaTypePhotoGif,
    YAssetModelMediaTypeVideo,
    YAssetModelMediaTypeAudio
} YAssetModelMediaType;

@class PHAsset;

@interface YAssetModel : NSObject

@property (nonatomic, assign) BOOL isSelected;//被选中 默认NO

@property (nonatomic, strong) PHAsset * asset;

@property (nonatomic, assign) YAssetModelMediaType assetModelMediaType;

@property (nonatomic, copy) NSString * timeLenght;//视频时长

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGPoint finallyOffset;

@property (nonatomic, assign) BOOL isChangeFrame;

@property (nonatomic, strong) UIImage * cropImage;

@property (nonatomic, assign) CGFloat aspectRatio;//图片宽高比

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL isFirstSelected;//是否是选中数组中第一个元素

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(YAssetModelMediaType)mediaType timeLength:(NSString *)timeLength;

@end

@class PHFetchResult;

@interface YPhotoAlbumModel : NSObject

@property (nonatomic, copy) NSString * albumName;

@property (nonatomic, assign) NSInteger photoCount;

@property (nonatomic, strong) PHAsset * firstImgAsset;

//@property (nonatomic, strong) PHAssetCollection * assetCollection;

@property (nonatomic, strong) PHFetchResult * fetchResult;

@property (nonatomic, assign) NSInteger selectedCount;

@property (nonatomic, strong) NSArray * selectedModels;

@property (nonatomic, strong) NSArray * models;

@end


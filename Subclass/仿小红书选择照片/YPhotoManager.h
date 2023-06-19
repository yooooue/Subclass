//
//  YPhotoManager.h
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/6.
//  Copyright © 2019 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "YPhotoAlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPhotoManager : NSObject

+ (instancetype)sharedManager;

//- (NSArray <PhotoAlbums *> *)getPhotoAlbums;

//获取相机里全部的相册
- (void)getAllAlbumsWithAscending:(BOOL)ascending completion:(void (^)(NSArray<YPhotoAlbumModel *>*))completion;
/// 获得相册内容及相册数量
- (void)getCameraRollAlbumWithAscending:(BOOL)ascending completion:(void (^)(YPhotoAlbumModel *))completion;

/// Get Assets 获得照片数组
- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<YAssetModel *> *))completion;

- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image, NSDictionary *info))completion;

- (void)requestImageForAsset:(PHAsset *)asset scale:(CGFloat)scale resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;

//- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *photosBytes))completion;

- (BOOL)judgeAssetisInLocalAblum:(PHAsset *)asset ;

@end

NS_ASSUME_NONNULL_END

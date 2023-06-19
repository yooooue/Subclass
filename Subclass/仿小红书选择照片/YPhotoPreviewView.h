//
//  YPhotoPreviewView.h
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/16.
//  Copyright © 2019 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    YFirstSelectPhotoHeightEqualToWidth = 0,//正方形
    YFirstSelectPhotoHeightLongerThanWidth,//长大于宽的长方形
    YFirstSelectPhotoWidthLongerThanHeight//宽大于长的长方形
} YFirstSelectPhotoType;

typedef void(^CropImgBlock)(UIImage * cropImage);

@class YAssetModel, YPhotoManager;

@interface YPhotoPreviewView : UIView

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) PHAsset * asset;

@property (nonatomic, strong) YAssetModel * model;

@property (nonatomic, assign) YFirstSelectPhotoType type;

@property (nonatomic, weak) CropImgBlock cropImgBlock;

@property (nonatomic, assign) BOOL hasSelected;//是否已有选择的图片

- (CGRect)imageCropFrameWithImage:(UIImage *)image;

- (void)saveCropImgforModel;

@end

NS_ASSUME_NONNULL_END

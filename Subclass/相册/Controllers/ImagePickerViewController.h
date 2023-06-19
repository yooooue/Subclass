//
//  ImagePickerViewController.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/20.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImagePickerControllerDelegate <NSObject>


@end

@interface ImagePickerViewController : UINavigationController

/// 最大可选数量 默认9张
@property (nonatomic, assign) NSInteger maxCount;

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<ImagePickerControllerDelegate>)delegate pushPhotoPickerVc:(BOOL)pushPhotoPickerVc;


@end


@interface PhotoPickerViewController : UIViewController

@property (nonatomic, assign) NSInteger columnNumber;

@property (nonatomic, assign) BOOL isImageOnly;

@property (nonatomic, assign) NSInteger maxImgCount;

@property (nonatomic,weak) void (^nextStepClickBlock)(NSArray<UIImage *>* photos);

@end

NS_ASSUME_NONNULL_END

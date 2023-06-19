//
//  ClipViewController.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/23.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClipViewController : UIViewController

@property (nonatomic, strong) UIImage * editImage;

@property (nonatomic, strong) YAssetModel * assetModel;

@property (nonatomic, copy) void(^clipImageBlock)(UIImage * image);

@end

NS_ASSUME_NONNULL_END

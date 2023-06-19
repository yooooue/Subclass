//
//  EditPhotosViewController.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/22.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPhotoAlbumModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditPhotosViewController : UIViewController

@property (nonatomic, strong) NSArray<YAssetModel *> * photoArr;

@end

NS_ASSUME_NONNULL_END

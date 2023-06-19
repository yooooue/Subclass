//
//  UIImage+CorpImage.h
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/21.
//  Copyright © 2019 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CropImage)

- (UIImage *)cropImgWithSize:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

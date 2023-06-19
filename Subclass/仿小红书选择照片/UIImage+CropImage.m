//
//  UIImage+CorpImage.m
//  仿小红书裁剪
//
//  Created by 韩倩云 on 2019/8/21.
//  Copyright © 2019 yy. All rights reserved.
//

#import "UIImage+CropImage.h"

@implementation UIImage (CropImage)

- (UIImage *)cropImgWithSize:(CGRect)frame {
    UIImage * cropImg = nil;
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, self.scale);
    {
        CGContextRef contex = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(contex, -frame.origin.x, -frame.origin.y);
        [self drawAtPoint:CGPointZero];
        cropImg = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return cropImg;
    return [UIImage imageWithCGImage:cropImg.CGImage scale:self.scale orientation:UIImageOrientationUp];
//
}
@end

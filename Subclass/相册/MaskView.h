//
//  MaskView.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/24.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TOClipViewControllerAspectRatioPreset) {
    TOClipViewControllerAspectRatioPresetOriginal,
    TOClipViewControllerAspectRatioPreset3x4,
    TOClipViewControllerAspectRatioPreset1x1,
    TOClipViewControllerAspectRatioPreset4x3,
    TOClipViewControllerAspectRatioPresetCustom
};

@interface MaskView : UIView

@property (nonatomic, assign) TOClipViewControllerAspectRatioPreset aspectRatio;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

NS_ASSUME_NONNULL_END

//
//  MaskView.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/24.
//  Copyright © 2020 yy. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return self;
}

- (void)setAspectRatio:(TOClipViewControllerAspectRatioPreset)aspectRatio {
    _aspectRatio = aspectRatio;
    CGFloat ratio = 1;
    switch (aspectRatio) {
        case TOClipViewControllerAspectRatioPreset1x1:
            ratio = 1;
            break;
        case TOClipViewControllerAspectRatioPreset3x4:
            ratio = 3/4.0;
        break;
        case TOClipViewControllerAspectRatioPreset4x3:
            ratio = 4/3.0;
        break;
        default:
            break;
    }
    [self bezierWithAspectRatio:ratio];
}

- (void)bezierWithAspectRatio:(CGFloat)ratio {
    CGFloat maskW = self.width-20;
    CGFloat maskH = maskW/ratio;
    UIBezierPath * bPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, self.height)];
    CGRect maskRect = CGRectMake(10, (self.height-maskH)/2, maskW, maskH);
    [bPath appendPath:[UIBezierPath bezierPathWithRect:maskRect]];
    
    self.shapeLayer.path = bPath.CGPath;
    self.layer.mask = self.shapeLayer;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.fillRule = kCAFillRuleEvenOdd;
        shapeLayer.fillColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        _shapeLayer = shapeLayer;
    }
    return _shapeLayer;;
}
@end

//
//  CustomLayer.h
//  Subclass
//
//  Created by 韩倩云 on 2019/11/27.
//  Copyright © 2019 yy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomLayer : CATransformLayer
@property (nonatomic, strong) CALayer * frontLayer;
@property (nonatomic, strong) CALayer * backLayer;
@end

NS_ASSUME_NONNULL_END

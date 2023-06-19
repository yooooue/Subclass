//
//  VideoPlayView.h
//  Subclass
//
//  Created by 韩倩云 on 2020/2/18.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoView : UIView

- (instancetype)initWithVC:(UIViewController *)vc;

- (void)setUrls:(NSArray *)urls index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

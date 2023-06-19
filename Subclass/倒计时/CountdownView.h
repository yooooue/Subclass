//
//  CountdownView.h
//  Subclass
//
//  Created by 韩倩云 on 2020/1/4.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountdownView : UIView

- (instancetype)initWithFrame:(CGRect)frame countdownTime:(NSDate *)countdownTime;

- (void)startCountDown;

@end

NS_ASSUME_NONNULL_END

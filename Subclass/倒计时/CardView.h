//
//  CardView.h
//  Subclass
//
//  Created by 韩倩云 on 2020/1/4.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardView : UIView

- (instancetype)initWithFrame:(CGRect)frame cardNumber:(NSInteger)number currentPage:(NSInteger)currentPage;

- (void)startOnce;
@end

NS_ASSUME_NONNULL_END

//
//  UIView+ViewFrame.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/2.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ViewFrame)

//只能生成get/Set方法声明

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;

#pragma mark - API
//- (BOOL)isDisplayedInScreen;
@end

NS_ASSUME_NONNULL_END

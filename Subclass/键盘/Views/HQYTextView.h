//
//  HQYTextView.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/2.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQYTextView : UITextView

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

@property (nonatomic, assign) BOOL placeholderHidden;

@end

NS_ASSUME_NONNULL_END

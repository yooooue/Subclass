//
//  EmgjiFaceSignlePageView.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/1.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmojiFaceSignlePageView : UIView

@property (nonatomic, strong) NSArray * emojiArr;

@property (nonatomic, copy) void(^emojiDidDeleteBlock)(void);   //表情删除回调

@property (nonatomic, copy) void(^emojiDidSelectBlock)(NSString *emojiStr);   //选中某个表情回调

@end

NS_ASSUME_NONNULL_END

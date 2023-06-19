//
//  AtUserListViewController.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/2.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AtUserListViewControllerDelegate <NSObject>

- (void)selectNickName:(NSString *)nickName withIsSelect:(BOOL)isSelect;

@end
@interface AtUserListViewController : UIViewController

@property (nonatomic, copy) void(^selectUser)(BOOL isSelect, NSString * nickName);

@property (nonatomic,weak) id <AtUserListViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

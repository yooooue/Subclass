//
//  CommentTableViewCell.h
//  Subclass
//
//  Created by 韩倩云 on 2019/12/4.
//  Copyright © 2019 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *label;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

@interface WriteBackCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
NS_ASSUME_NONNULL_END

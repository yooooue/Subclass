//
//  CommentTableViewCell.m
//  Subclass
//
//  Created by 韩倩云 on 2019/12/4.
//  Copyright © 2019 yy. All rights reserved.
//

#import "ReviewTableViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define ImgWH (kScreenWidth-53-15-27)/4;

@implementation ReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgViewHeight.constant = ImgWH;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"ReviewTableViewCell";
    ReviewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ReviewTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation WriteBackCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"WriteBackCommentTableViewCell";
    WriteBackCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ReviewTableViewCell" owner:nil options:nil] objectAtIndex:1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

//
//  EmgjiFaceSignlePageView.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/1.
//  Copyright © 2020 yy. All rights reserved.
//

#import "EmojiFaceSignlePageView.h"

@interface EmojiFaceSignlePageView ()

@property (nonatomic, strong) UIButton * deleteBtn;

@end

@implementation EmojiFaceSignlePageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.deleteBtn];
    }
    return self;
}

- (void)setEmojiArr:(NSArray *)emojiArr {
    _emojiArr = emojiArr;
    NSInteger count = emojiArr.count;
    for (NSInteger i = 0; i<count; i++) {
        UIButton * emojiBtn = [[UIButton alloc]init];
        [emojiBtn setTitle:emojiArr[i] forState:UIControlStateNormal];
        [emojiBtn addTarget:self action:@selector(clickEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emojiBtn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = self.emojiArr.count;
    CGFloat btnW = self.frame.size.width /7;
    CGFloat btnH = self.frame.size.height/4;
    for (NSInteger i=0; i<count; i++) {
        CGFloat btnX = i%7 * btnW;
        CGFloat btnY = i/7 *btnH;
        UIButton * emojiBtn = self.subviews[i+1];
        emojiBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    UIButton *lastEmojiButton = [self.subviews lastObject];
    //布局删除按钮
    CGFloat deleteButtonX = lastEmojiButton.frame.origin.x + lastEmojiButton.bounds.size.width;
    CGFloat deleteButtonY = lastEmojiButton.frame.origin.y;
    CGFloat deleteButtonW = btnW;
    CGFloat deleteButtonH = btnH;
    self.deleteBtn.frame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
}


- (void)clickEmoji:(UIButton *)btn {
    NSString * btnText = btn.titleLabel.text;
    if (self.emojiDidSelectBlock) {
        self.emojiDidSelectBlock(btnText);
    }
}

- (void)deleteClick {
    if (self.emojiDidDeleteBlock) {
        self.emojiDidDeleteBlock();
    }
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    return _deleteBtn;
}
@end

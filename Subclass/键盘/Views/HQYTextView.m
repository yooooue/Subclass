//
//  HQYTextView.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/2.
//  Copyright © 2020 yy. All rights reserved.
//

#import "HQYTextView.h"

@interface HQYTextView ()

@property (nonatomic, strong) UILabel * placeholderLabel;

@end

@implementation HQYTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.placeholderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}

- (void)setPlaceholderHidden:(BOOL)placeholderHidden {
    _placeholderHidden = placeholderHidden;
    self.placeholderLabel.hidden = placeholderHidden;
}

- (void)textDidChange {
    self.placeholderHidden = self.hasText;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 0, 0)];
        _placeholderLabel.numberOfLines = 1;
    }
    return _placeholderLabel;
}
@end

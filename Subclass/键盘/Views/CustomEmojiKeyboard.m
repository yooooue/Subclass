//
//  CustomEmojiKeyboard.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/1.
//  Copyright © 2020 yy. All rights reserved.
//

#import "CustomEmojiKeyboard.h"
#import "EmojiFaceView.h"
#import "HQYTextView.h"

#define kKeyboardView_FaceViewHeight 267  // 表情键盘高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define kKeyboardViewToolBarHeight 90  // 默认键盘输入工具条的高度
#define kKeyboardViewToolBarLimitHeight 140  // 默认键盘输入工具条的限制高度
#define kKeyboardViewToolBar_TextView_Height 20  // 默认键盘输入框的高度
#define kKeyboardViewToolBar_TextView_LimitHeight 80  // 默认键盘输入框的限制高度
#define kKeyboardViewToolBar_TextView_BottomMargin 47  // 默认键盘输入框距底部的间距
#define kKeyboardViewToolBar_TextView_TopMargin 13  // 默认键盘输入框距底部的间距
#define kKeyboardViewToolBar_TextView_LeftMargin 17  // 默认键盘输入框距底部的间距
#define kKeyboardViewToolBar_TextView_RightMargin 85  // 默认键盘输入框距底部的间距

@interface CustomEmojiKeyboard ()<UITextViewDelegate>

@property (nonatomic, strong) EmojiFaceView * faceView;

@property (nonatomic, strong) HQYTextView * inputTextView;

@property (nonatomic, strong) NSMutableArray * allEmojiArray ;

@property (nonatomic, strong) UIButton * selectPhotoBtn;

@property (nonatomic, strong) UIButton * atBtn;

@property (nonatomic, strong) UIButton * selectEmojiBtn;

@property (nonatomic, strong) UILabel * textLenghtLabel;

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UIButton * deleteImgBtn;


@property (nonatomic, assign) CGFloat animationDuration;  //动画时间
@property (nonatomic, assign) CGFloat textHeight;   //输入文字高度
@property (nonatomic, copy) void(^sendTextBlock)(NSString *text);  //输入框输入字符串回调Blcok

@end

@implementation CustomEmojiKeyboard

+ (CustomEmojiKeyboard *)showKeyBoardWithConfigToolBarHeight:(CGFloat)toolBarHeight sendTextCompletion:(void(^)(NSString *sendText))sendTextBlock {
    CustomEmojiKeyboard *toolBar = [[CustomEmojiKeyboard alloc]init];
    toolBar.backgroundColor = [UIColor colorWithHexStr:@"#f7f7f7"];
    if(toolBarHeight < kKeyboardViewToolBarHeight)
        toolBarHeight = kKeyboardViewToolBarHeight;
    toolBar.frame = CGRectMake(0, ScreenHeight, ScreenWidth, toolBarHeight);
    toolBar.sendTextBlock = sendTextBlock;
    return toolBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.inputTextView];
    [self addSubview:self.selectPhotoBtn];
    [self addSubview:self.atBtn];
    [self addSubview:self.selectEmojiBtn];
    [self addSubview:self.imageView];
    [self addSubview:self.deleteImgBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.inputTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(atUsers:) name:@"CommentTextViewAtUserNotifation" object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    
    CGFloat height = (self.textHeight + kKeyboardViewToolBar_TextView_Height+kKeyboardViewToolBar_TextView_TopMargin+kKeyboardViewToolBar_TextView_BottomMargin)> kKeyboardViewToolBarHeight ? (self.textHeight + kKeyboardViewToolBar_TextView_Height+kKeyboardViewToolBar_TextView_TopMargin+kKeyboardViewToolBar_TextView_BottomMargin) : kKeyboardViewToolBarHeight;
    height = self.selectImg?140:height;
    CGFloat offsetY = self.height - height;
    [UIView animateWithDuration:self.animationDuration animations:^{
        weakSelf.y  += offsetY;
        weakSelf.height = height;
    }];
    
    self.selectPhotoBtn.width = 40;
    self.selectPhotoBtn.height = 40;
    self.selectPhotoBtn.x = 7;
    
    self.selectEmojiBtn.width = 40;
    self.selectEmojiBtn.height = 40;
    self.selectEmojiBtn.x = self.selectPhotoBtn.x+40+18;
    
    self.atBtn.width = 40;
    self.atBtn.height = 40;
    self.atBtn.x = self.selectEmojiBtn.x+40+18;
    
    self.inputTextView.width = self.width - 85-15;
    self.inputTextView.x = kKeyboardViewToolBar_TextView_LeftMargin;
    [UIView animateWithDuration:self.animationDuration animations:^{
        weakSelf.inputTextView.height = weakSelf.height-47-kKeyboardViewToolBar_TextView_TopMargin;
        weakSelf.inputTextView.y = kKeyboardViewToolBar_TextView_TopMargin;
        weakSelf.selectPhotoBtn.y = weakSelf.inputTextView.y+weakSelf.inputTextView.height+7;
        weakSelf.atBtn.centerY = weakSelf.selectPhotoBtn.centerY;
        weakSelf.selectEmojiBtn.centerY = weakSelf.selectPhotoBtn.centerY;
    }];
    
    [self.inputTextView setNeedsUpdateConstraints];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.inputTextView.placeholder = placeholder;
}

- (void)becomeFirstResponder {
    [self.inputTextView becomeFirstResponder];
    self.hidden = NO;
}

- (void)resignFirstResponder {
    [self.inputTextView resignFirstResponder];
}

- (void)clearText {
    self.inputTextView.text = @"";
    [self textDidChange];
}

#pragma mark 通知
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    CGFloat keyboardAnimaitonDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.animationDuration = keyboardAnimaitonDuration;
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // 普通文本键盘与表情键盘切换时，过滤
    BOOL isEmojiKeyBoard = !self.selectEmojiBtn.selected &&keyboardFrame.size.height == kKeyboardView_FaceViewHeight;
    BOOL isNormalKeyBoard = self.selectEmojiBtn.selected &&keyboardFrame.size.height != kKeyboardView_FaceViewHeight;
    if(isEmojiKeyBoard || isNormalKeyBoard) return;
    
    //判断键盘是否出现
    BOOL isKeyBoardHidden = ScreenHeight == keyboardFrame.origin.y;
    CGFloat offsetMarginY = isKeyBoardHidden ? ScreenHeight - self.frame.size.height :ScreenHeight - self.frame.size.height - keyboardHeight;
    
    [UIView animateKeyframesWithDuration:self.animationDuration delay:0 options:option animations:^{
        self.y = offsetMarginY;
    } completion:nil];
    
}

- (void)textDidChange {
    //注意：点击发送之后是先收到这个通知，收到通知的时候hasText = YES，让后再text = @"",所以在inputTextView里面的监听无效
    self.inputTextView.placeholderHidden = self.inputTextView.hasText;
    if([self.inputTextView.text containsString:@"\n"])
    {
        [self emojitionDidSend];
        return;
    }
    
    CGFloat margin = self.inputTextView.textContainerInset.left + self.inputTextView.textContainerInset.right;
    
    CGFloat height = [self.inputTextView.text boundingRectWithSize:CGSizeMake(self.inputTextView.width - margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.inputTextView.font} context:nil].size.height;
    
    if(height == self.textHeight) return;
    
    // 确保输入框不会无限增高，控制在显示4行
    if (height > kKeyboardViewToolBar_TextView_LimitHeight) {
        return;
    }
    self.textHeight = height;
    
    [self setNeedsLayout];
}

- (void)atUsers:(NSNotification *)noti {
    NSDictionary * infoDic = noti.userInfo;
    if ([[infoDic objectForKey:@"IsSelect"]boolValue]) {
        NSString * nickName = [infoDic objectForKey:@"NickName"];
        self.inputTextView.text = [self.inputTextView.text stringByAppendingString:[NSString stringWithFormat:@"@%@ ",nickName]];
    }else {
        NSLog(@"@");
        self.inputTextView.text = [self.inputTextView.text stringByAppendingString:@"@"];
    }
    [self textDidChange];
    [self textViewDidChange:self.inputTextView];
}

- (void)emojitionDidSend {
    
}

- (void)emojitionDidSelect:(NSString *)emojiStr {
    self.inputTextView.text = [self.inputTextView.text stringByAppendingString:emojiStr];
    [self textDidChange];
}

- (void)emojitionDidDelete {
    [self.inputTextView deleteBackward];
}

#pragma mark ---click
- (void)deleteImg {
    
}

- (void)clickPhotoBtn {
    
}

- (void)clickAtBtn {
    if (self.atUserBlock) {
        self.atUserBlock();
    }
}

- (void)clickEmojiBtn:(UIButton *)selectEmojiBtn {
    selectEmojiBtn.selected = !selectEmojiBtn.selected;
    [self.inputTextView resignFirstResponder];
    self.inputTextView.inputView = selectEmojiBtn.selected?self.faceView:nil;
    [self.inputTextView becomeFirstResponder];
}

#pragma mark ---UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
//    self.commentText = textView.text;
    
    NSArray * matchs = [self getMatchsWithStr:textView.text];
    [textView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexStr:@"#46464b"] range:NSMakeRange(0, textView.text.length)];
    for (NSTextCheckingResult * match in matchs) {
        [textView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexStr:@"#006CF9"] range:NSMakeRange(match.range.location, match.range.length)];
    }
    
//    self.commentText = textView.text;
}

- (void)textViewClickReturnBtn {
    if (self.sendTextBlock) {
        self.sendTextBlock(self.inputTextView.text);
    }
}

- (NSArray *) getMatchsWithStr : (NSString *) text {
    NSString * kATRegular = @"@([^@].*?) ";
    // 找到文本中所有的@
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])];
//    NSMutableArray * mArr = [NSMutableArray array];
//    for (NSTextCheckingResult * matche in matches) {
//        NSString * subStr = [text substringWithRange:matche.range];
//        if ([self.atUserNickNames containsObject:subStr]) {
//            [mArr addObject:matche];
//        }
//    }
    return matches;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //发送
    if ([text isEqualToString:@"\n"]) {
        [self textViewClickReturnBtn];
        return NO;
    }
    //@ 触发
    if ([text isEqualToString:@"@"]) {
        [self clickAtBtn];
        return NO;
    }
    //删除整块@区域
    if ([text isEqualToString:@""]) {
        NSRange selectRange = textView.selectedRange;
        if (selectRange.length > 0) {
            return YES;
        }
        
        NSMutableString * string = [NSMutableString stringWithString:textView.text];
        NSArray * matchs = [self getMatchsWithStr:string];
        
        BOOL inAt = NO;
        NSInteger index = range.location;
        for (int i=0; i<matchs.count; i++) {
            NSTextCheckingResult *match = matchs[i];
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
           if (NSLocationInRange(range.location, newRange)) {
               inAt = YES;
               index = match.range.location;
               [textView.textStorage replaceCharactersInRange:match.range withString:@""];
//               [self.atUsers removeObjectAtIndex:i];
//               [self.atUserNickNames removeObjectAtIndex:i];
//               textView.selectedRange = NSMakeRange(index, match.range.length);
               [self textViewDidChange:textView];
               return NO;
               break;
           }
        }
        for (NSTextCheckingResult *match in matchs) {
             NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
           if (NSLocationInRange(range.location, newRange)) {
               inAt = YES;
               index = match.range.location;
               [textView.textStorage replaceCharactersInRange:match.range withString:@""];
//               textView.selectedRange = NSMakeRange(index, match.range.length);
               [self textViewDidChange:textView];
               return NO;
               break;
           }
        }
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    // 光标不能点落在@词中间
    NSRange range = textView.selectedRange;
    
    NSArray *matches = [self getMatchsWithStr:textView.text];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange newRange = NSMakeRange(match.range.location+1, match.range.length-1);
        if (NSLocationInRange(range.location, newRange)) {
            textView.selectedRange = NSMakeRange(match.range.location , range.length==0?0:range.length+match.range.length);
            break;
        }else if (NSLocationInRange(range.location+range.length, newRange)) {
            textView.selectedRange = NSMakeRange(range.location , range.length==0?0:range.length+match.range.length);
            break;
        }
    }
}

#pragma mark ---懒载
- (HQYTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[HQYTextView alloc]init];
        _inputTextView.placeholderColor = [UIColor lightGrayColor];
        _inputTextView.font = [UIFont systemFontOfSize:14];
        _inputTextView.placeholder = @"bibi两句吧...";
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES;
        _inputTextView.delegate = self;
    }
    return _inputTextView;
}

- (EmojiFaceView *)faceView {
    if (!_faceView) {
        _faceView = [[EmojiFaceView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kKeyboardView_FaceViewHeight)];
         __weak typeof(self) weakSelf = self;
        _faceView.emojiDidDeleteBlock = ^{
            [weakSelf emojitionDidDelete];
        };
        _faceView.emojiDidSendBlock = ^{
            [weakSelf emojitionDidSend];
        };
        _faceView.emojiDidSelectBlock = ^(NSString * _Nonnull emojiStr) {
            [weakSelf emojitionDidSelect:emojiStr];
        };
        _faceView.emojiArr = self.allEmojiArray;
    }
    return _faceView;
}

- (NSMutableArray *)allEmojiArray {
    if (_allEmojiArray == nil) {
        _allEmojiArray = [[NSMutableArray alloc] init];
        NSString *wechatEmpStr = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"];
        NSMutableArray *empArr = [[NSMutableArray alloc] initWithContentsOfFile:wechatEmpStr];
        [_allEmojiArray removeAllObjects];
        [_allEmojiArray addObjectsFromArray:empArr];
    }
    return _allEmojiArray;
}

- (UIButton *)selectPhotoBtn {
    if (!_selectPhotoBtn) {
        _selectPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectPhotoBtn.tag = 100;
        [_selectPhotoBtn setImage:[UIImage imageNamed:@"comment_selectPhoto"] forState:UIControlStateNormal];
        [_selectPhotoBtn addTarget:self action:@selector(clickPhotoBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPhotoBtn;;
}

- (UIButton *)selectEmojiBtn {
    if (!_selectEmojiBtn) {
        _selectEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectEmojiBtn.tag = 101;
        [_selectEmojiBtn setImage:[UIImage imageNamed:@"comment_selectEmoji"] forState:UIControlStateNormal];
        [_selectEmojiBtn addTarget:self action:@selector(clickEmojiBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectEmojiBtn;;
}

- (UIButton *)atBtn {
    if (!_atBtn) {
        _atBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _atBtn.tag = 102;
        [_atBtn setImage:[UIImage imageNamed:@"comment_selectAtUser"] forState:UIControlStateNormal];
        [_atBtn addTarget:self action:@selector(clickAtBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _atBtn;;
}

- (UILabel *)textLenghtLabel {
    if (!_textLenghtLabel) {
        _textLenghtLabel = [[UILabel alloc]init];
        _textLenghtLabel.textColor = [UIColor colorWithHexStr:@"#b3b4c4"];
        _textLenghtLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _textLenghtLabel.text = @"300";
        _textLenghtLabel.textAlignment = NSTextAlignmentRight;
    }
    return _textLenghtLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-15-60, 15, 60, 60)];
    }
    return _imageView;;
}

- (UIButton *)deleteImgBtn {
    if (!_deleteImgBtn) {
        _deleteImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-15-18, 15, 18, 18)];
        [_deleteImgBtn setImage:[UIImage imageNamed:@"comment_deletePhoto"] forState:UIControlStateNormal];
        [_deleteImgBtn addTarget:self action:@selector(deleteImg) forControlEvents:UIControlEventTouchUpInside];
        _deleteImgBtn.hidden = YES;
    }
    return _deleteImgBtn;
}
@end

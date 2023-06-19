//
//  CustomEmojiKeyboard.h
//  Subclass
//
//  Created by 韩倩云 on 2020/7/1.
//  Copyright © 2020 yy. All rights reserved.
//

//自定义表情键盘

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomEmojiKeyboard : UIView

@property (nonatomic, strong) UIImage * selectImg;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, copy) void(^atUserBlock)(void);  //输入框输入字符串回调Blcok

@property (nonatomic, copy) void(^selectPhotoBlock)(NSString *text);  //输入框输入字符串回调Blcok

/**
 弹出自定义键盘和输入框工具条--有表情键盘  注意：一定是要在viewDidLayout中增加控件
 
 @param toolBarHeight 工具条的高度
 @param sendTextBlock 返回输入框输入的文字
 @return  返回LZBKeyBoardToolBar
 */
+ (CustomEmojiKeyboard *)showKeyBoardWithConfigToolBarHeight:(CGFloat)toolBarHeight sendTextCompletion:(void(^)(NSString *sendText))sendTextBlock;

- (void)becomeFirstResponder;

- (void)resignFirstResponder;

- (void)clearText;
@end

NS_ASSUME_NONNULL_END

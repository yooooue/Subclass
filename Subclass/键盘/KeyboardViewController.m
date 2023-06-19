//
//  KeyboardViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/1.
//  Copyright © 2020 yy. All rights reserved.
//

#import "KeyboardViewController.h"
#import "CustomEmojiKeyboard.h"
#import "AtUserListViewController.h"
#import "UILabel+AttributeTextTapAction.h"

@interface KeyboardViewController ()<AtUserListViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CustomEmojiKeyboard * keyboard;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * textArr;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyboard];
    UIButton * commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-40-BOTTOM_SPACE, self.view.width, 40)];
    commentBtn.backgroundColor = [UIColor redColor];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentBtn];
}

- (void)clickBtn {
    [self.keyboard becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.keyboard becomeFirstResponder];
}

- (void)clickSentText:(NSString *)text {
    [self.textArr addObject:text];
    [self.tableView reloadData];
    [self.keyboard clearText];
}

- (void)selectNickName:(NSString *)nickName withIsSelect:(BOOL)isSelect{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CommentTextViewAtUserNotifation" object:self userInfo:@{@"NickName":nickName,@"IsSelect":@(isSelect)}];
//    NSLog(@"%@", nickName);
}

- (void)atUSers{
    AtUserListViewController * atVC = [[AtUserListViewController alloc]init];
    atVC.title = @"@我的关注";
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:atVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    atVC.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    NSString * text = self.textArr[indexPath.row];
#warning attributedText设置不能精确跳转的原因是没有设置字体大小 导致点击的文字range与实际有偏差 给attributedString添加font大小 就能精确点击跳转！！！
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    NSArray * matchs = [self getMatchsWithStr:text];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexStr:@"#46464b"] range:NSMakeRange(0, text.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexStr:@"#46464b"],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, text.length)];
    NSMutableArray * tapRangeArr = [NSMutableArray arrayWithCapacity:matchs.count];
    for (int i = 0; i<matchs.count; i++) {
        NSTextCheckingResult * match = matchs[i];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexStr:@"#5e92e2"],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:match.range];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexStr:@"#5e92e2"] range:match.range];
        [tapRangeArr addObject:NSStringFromRange(match.range)];
    }
//    cell.textLabel.text = text;
    cell.textLabel.attributedText = attributedString.copy;
    if (tapRangeArr.count)
        [cell.textLabel yb_addAttributeTapActionWithRanges:tapRangeArr tapClicked:^(UILabel * _Nonnull label, NSString * _Nonnull string, NSRange range, NSInteger index) {
            NSLog(@"点击@用户名%@", string);
        }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSArray *) getMatchsWithStr : (NSString *) text {
    NSString * kATRegular = @"@([^@].*?) ";
    // 找到文本中所有的@
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])];

    return matches;
}

- (CustomEmojiKeyboard *)keyboard {
    if (!_keyboard) {
        __weak typeof(self) weakSelf = self;
        _keyboard = [CustomEmojiKeyboard showKeyBoardWithConfigToolBarHeight:0 sendTextCompletion:^(NSString * _Nonnull sendText) {
            [weakSelf clickSentText:sendText];
        }];
//        _keyboard.placeholder = @"说点什么吧";
        _keyboard.atUserBlock = ^{
            [weakSelf atUSers];
        };
    }
    return _keyboard;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _tableView;
}

- (NSMutableArray *)textArr {
    if (!_textArr) {
        _textArr = [NSMutableArray array];
    }
    return _textArr;
}

@end

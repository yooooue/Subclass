//
//  EmojiFaceView.m
//  Subclass
//
//  Created by 韩倩云 on 2020/7/1.
//  Copyright © 2020 yy. All rights reserved.
//

#import "EmojiFaceView.h"
#import "EmojiFaceSignlePageView.h"

@interface EmojiFaceView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) UIButton * sendBtn;

@property (nonatomic, strong) NSMutableArray * allEmojiArray ;

@end

@implementation EmojiFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.sendBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.width, 200);
    //单个面板控件
    NSInteger count = self.scrollView.subviews.count;
    for (NSInteger i = 0; i < count; i++) {
        EmojiFaceSignlePageView *pageView = self.scrollView.subviews[i];
        CGFloat pageViewW = self.scrollView.bounds.size.width;
        CGFloat pageViewH = self.scrollView.bounds.size.height;
        CGFloat pageViewY = 0;
        CGFloat pageViewX = pageViewW * i;
        pageView.frame = CGRectMake(pageViewX, pageViewY, pageViewW, pageViewH);
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * count, 0);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

- (void)clickSendBtn {
    //发送
    if (self.emojiDidSendBlock) {
        self.emojiDidSendBlock();
    }
}

- (void)setEmojiArr:(NSArray *)emojiArr {
    _emojiArr = emojiArr;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger pageCount = (emojiArr.count+27)/27;
    self.pageControl.numberOfPages = pageCount;
    for (NSInteger i = 0; i<pageCount; i++) {
        EmojiFaceSignlePageView * pageView = [[EmojiFaceSignlePageView alloc]init];
        pageView.emojiDidDeleteBlock = self.emojiDidDeleteBlock;
        pageView.emojiDidSelectBlock = self.emojiDidSelectBlock;
        NSRange range;
        range.location = i*27;
        NSInteger remainCount = emojiArr.count - range.location;
        if(remainCount >= 27)
            range.length = 27;
        else
            range.length = remainCount;
        pageView.emojiArr = [emojiArr subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    [self setNeedsLayout];
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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), self.frame.size.width, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.center = CGPointMake(self.center.x, _pageControl.center.y);
    }
    return _pageControl;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-55, self.frame.size.height-36, 55, 36)];
        _sendBtn.backgroundColor = [UIColor redColor];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
@end

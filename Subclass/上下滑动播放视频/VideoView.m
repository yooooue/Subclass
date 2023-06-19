//
//  VideoPlayView.m
//  Subclass
//
//  Created by 韩倩云 on 2020/2/18.
//  Copyright © 2020 yy. All rights reserved.
//

#import "VideoView.h"
#import "VideoPlayer.h"
#import "VideoControlView.h"
#import "Masonry/Masonry.h"

@interface VideoView ()<UIScrollViewDelegate, VideoPlayerDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIViewController * vc;

@property (nonatomic, strong) VideoControlView * topView;

@property (nonatomic, strong) VideoControlView * ctrView;

@property (nonatomic, strong) VideoControlView * btmView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) VideoPlayer * player;

@property (nonatomic, assign) CGFloat startLocationY;

@property (nonatomic, assign) CGPoint startLocation;

@property (nonatomic, assign) CGRect startFrame;

@property (nonatomic, strong) NSMutableArray * videos;

@property (nonatomic, strong) VideoControlView * currentPlayView;

@end

@implementation VideoView

- (instancetype)initWithVC:(UIViewController *)vc {
    if (self = [super init]) {
        self.vc = vc;
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat controlW = CGRectGetWidth(self.scrollView.frame);
    CGFloat controlH = CGRectGetHeight(self.scrollView.frame);
    
    self.topView.frame   = CGRectMake(0, 0, controlW, controlH);
    self.ctrView.frame   = CGRectMake(0, controlH, controlW, controlH);
    self.btmView.frame   = CGRectMake(0, 2 * controlH, controlW, controlH);
}

#pragma mark  - Public Methods
- (void)setUrls:(NSArray *)urls index:(NSInteger)index {
    [self.videos removeAllObjects];
    [self.videos addObjectsFromArray:urls];
    self.index = index;
    
    if (urls.count == 0) return;
    if (urls.count == 1) {
        [self.ctrView removeFromSuperview];
        [self.btmView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
        self.topView.hidden = NO;
        self.topView.url = self.videos.firstObject;
        [self playVideoFromView:self.topView];
    }if (urls.count == 2) {
        [self.btmView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, 2*SCREEN_HEIGHT);
        self.topView.hidden = NO;
        self.ctrView.hidden = NO;
        self.topView.url = self.videos.firstObject;
        self.ctrView.url = self.videos[1];
        [self playVideoFromView:self.topView];
    } else {
        self.scrollView.contentSize = CGSizeMake(0, urls.count*SCREEN_HEIGHT);
        self.topView.hidden = NO;
        self.ctrView.hidden = NO;
        self.btmView.hidden = NO;
        self.topView.url = self.videos.firstObject;
        self.ctrView.url = self.videos[1];
        self.btmView.url = self.videos[2];
        [self playVideoFromView:self.topView];
    }
}

- (void)playVideoFromView:(VideoControlView *)view {
    [self.player removeVideo];
    
    self.currentPlayView = view;
    
    self.index = [self indexOfModel:view.url];
    
    [self.player playVideoWithView:view url:self.videos[self.index]];
}

// 获取当前播放内容的索引
- (NSInteger)indexOfModel:(NSString *)model {
    __block NSInteger index = 0;
    [self.videos enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model isEqualToString:obj]) {
            index = idx;
        }
    }];
    return index;
}
#pragma mark -VideoPlayerDelegate
- (void)player:(VideoPlayer *)player staatusChanged:(VideoPlayerStatus)status {
    
}

- (void)player:(VideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress {
    
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.index==0 && scrollView.contentOffset.y<0) {
        self.scrollView.contentOffset = CGPointZero;
    }
    
    // 小于等于三个，不用处理
    if (self.videos.count <= 3) return;
    
    // 上滑到第一个
    if (self.index == 0 && scrollView.contentOffset.y <= SCREEN_HEIGHT) {
        return;
    }
    // 下滑到最后一个
    if (self.index > 0 && self.index == self.videos.count - 1 && scrollView.contentOffset.y > SCREEN_HEIGHT) {
        return;
    }
}

// 结束滚动后开始播放
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
//        if (self.currentPlayId == self.topView.model.post_id) return;
        [self playVideoFromView:self.topView];
    }else if (scrollView.contentOffset.y == SCREEN_HEIGHT) {
//        if (self.currentPlayId == self.ctrView.model.post_id) return;
        [self playVideoFromView:self.ctrView];
    }else if (scrollView.contentOffset.y == 2 * SCREEN_HEIGHT) {
//        if (self.currentPlayId == self.btmView.model.post_id) return;
        [self playVideoFromView:self.btmView];
    }
}

#pragma mark -懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        [_scrollView addSubview:self.topView];
        [_scrollView addSubview:self.ctrView];
        [_scrollView addSubview:self.btmView];
        _scrollView.contentSize = CGSizeMake(0, self.frame.size.height*3);
    }
    return _scrollView;
}

- (VideoControlView *)topView {
    if (!_topView) {
        _topView = [VideoControlView new];
        _topView.hidden = YES;
    }
    return _topView;
}

- (VideoControlView *)ctrView {
    if (!_ctrView) {
        _ctrView = [VideoControlView new];
        _ctrView.hidden = YES;
    }
    return _ctrView;
}

- (VideoControlView *)btmView {
    if (!_btmView) {
        _btmView = [VideoControlView new];
        _btmView.hidden = YES;
    }
    return _btmView;
}

- (VideoPlayer *)player {
    if (!_player) {
        _player = [VideoPlayer new];
        _player.delegate = self;
    }
    return _player;
}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}
@end

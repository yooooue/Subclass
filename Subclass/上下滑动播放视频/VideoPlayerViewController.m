//
//  VideoPlayerViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/2/14.
//  Copyright © 2020 yy. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "VideoView.h"
#import "Masonry.h"

@interface VideoPlayerViewController ()


@property (nonatomic, strong) VideoView * videoView;

@property (nonatomic, strong) UIButton * backBtn;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.videoView];
    self.videoView.backgroundColor = [UIColor blackColor];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [self.view addSubview:self.backBtn];
//    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(15.0f);
//        make.top.equalTo(self.view).offset(STATUSBAR_HEIGHT + 20.0f);
//        make.width.height.mas_equalTo(44.0f);
//    }];
    [self.videoView setUrls:@[@"https://v3f.imacco.com/Web/Assert/InfoVideo/Info000029902/10e6271fb7fa40e794f038e3200e66c7.mp4",@"https://v3f.imacco.com/Web/Assert/InfoVideo/Info000029900/03aca29a7e94484a8d833edbcf8afc84.mp4",@"https://v3f.imacco.com/Web/Assert/InfoVideo/Info000029904/bf12f760a5fe4c478d08e92b56c30469.mp4 "] index:0];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (VideoView *)videoView {
    if (!_videoView) {
        _videoView = [[VideoView alloc] initWithVC:self];
//        _videoView.delegate = self;
    }
    return _videoView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
//        [_backBtn setImage:[UIImage gk_imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
        _backBtn.backgroundColor = [UIColor whiteColor];
        [_backBtn setTitle:@"Back" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}


@end
